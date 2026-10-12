-- =====================================================================
-- GM placement tool (server part of the WildcardGM addon): search NPCs / objects, spawn them where the GM stands,
-- select, move, turn, delete. Messages travel over the addon channel (prefix WCARD, kind "GMT").
--   client -> server:  GMT;S;<c|g>;<text or id>   search          -> GMT;R;<c|g>;<id>;<display>;<name>   (up to 25 lines)
--                      GMT;P;<c|g>;<id>            spawn at me    -> GMT;SEL;...
--                      GMT;N;<c|g>                 select nearest -> GMT;SEL;...
--                      GMT;M;<dx>;<dy>;<dz>        move selected (world axes, yards)
--                      GMT;MF;<yards>              move selected forward/back relative to my facing
--                      GMT;T;<radians>             turn selected by an angle
--                      GMT;H                       put selected where I stand
--                      GMT;D                       delete selected
--                      GMT;SET;<x>;<y>;<z>;<deg>   put selected at exact coordinates (any empty field keeps the old value)
-- Creatures are saved by the core (PerformIngameSpawn save=true). Objects: the core cannot save runtime GameObjects
-- here (SaveToDB fails), so the tool writes its own world.gameobject row (guid 3100900001+) and the object comes
-- back after a restart. GM rank 2+ only.
-- =====================================================================
if not IS_WORLD_STATE then return end

local PREFIX_TYPE = 7   -- CHAT_MSG_WHISPER
local SEL = {}          -- player name -> {kind, obj guid, row (db guid), entry, name, x, y, z, o}
local function Send(p, msg) pcall(function() p:SendAddonMessage("WCARD", msg, PREFIX_TYPE, p) end) end
local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end
local function Num(v) return tonumber((string.gsub(tostring(v or 0), "U?LL$", ""))) or 0 end   -- db guids come back as 64-bit userdata
-- Database rows (gameobject guids reach 990000000101170004) must stay exact: a Lua number loses digits above 2^53 and "%d" only takes 32 bits.
-- So rows are kept as decimal STRINGS ("0" = not saved).
local function Row(v) local r = string.gsub(tostring(v or 0), "U?LL$", ""); if r == "" or not string.match(r, "^%d+$") then r = "0" end; return r end
local function HasRow(r) return r ~= nil and r ~= 0 and r ~= "0" and r ~= "" end
local function RowGt(a, b) if #a ~= #b then return #a > #b end return a > b end


-- ---------------------------------------------------------------- housing: players with a plot may use the tool inside it
pcall(WorldDBExecute, [[CREATE TABLE IF NOT EXISTS world.house_plot (owner VARCHAR(40) NOT NULL PRIMARY KEY, map INT UNSIGNED NOT NULL, x FLOAT NOT NULL, y FLOAT NOT NULL, z FLOAT NOT NULL,
  radius FLOAT NOT NULL DEFAULT 40) ENGINE=InnoDB]])
pcall(WorldDBExecute, [[CREATE TABLE IF NOT EXISTS world.house_obj (guid BIGINT UNSIGNED NOT NULL PRIMARY KEY, owner VARCHAR(40) NOT NULL, KEY (owner)) ENGINE=InnoDB]])
local MAX_HOUSE_OBJ = 150
local function PlotOf(p)
    local q = WorldDBQuery("SELECT map, x, y, z, radius FROM house_plot WHERE owner = '" .. Esc(p:GetName()) .. "'")
    if not q then return nil end
    return {map = q:GetUInt32(0), x = q:GetFloat(1), y = q:GetFloat(2), z = q:GetFloat(3), r = q:GetFloat(4)}
end
local function InPlot(plot, map, x, y)
    return plot and plot.map == map and (plot.x - x) ^ 2 + (plot.y - y) ^ 2 <= plot.r * plot.r
end
local function OwnsRow(p, row)
    if not HasRow(row) then return false end
    local q = WorldDBQuery("SELECT 1 FROM house_obj WHERE guid = " .. row .. " AND owner = '" .. Esc(p:GetName()) .. "'")
    return q ~= nil
end
local function CountObj(p)
    local q = WorldDBQuery("SELECT COUNT(*) FROM house_obj WHERE owner = '" .. Esc(p:GetName()) .. "'")
    return q and q:GetUInt32(0) or 0
end


local function NameOf(kind, entry)
    local q
    if kind == "c" then q = WorldDBQuery("SELECT name FROM creature_template WHERE entry = " .. entry)
    else q = WorldDBQuery("SELECT name FROM gameobject_template WHERE entry = " .. entry) end
    return q and q:GetString(0) or ("#" .. entry)
end

local PAGE = 40
local function Search(p, kind, text, page)
    page = math.max(0, tonumber(page) or 0)
    local n = tonumber(text)
    local q, cnt
    local lim = " LIMIT " .. PAGE .. " OFFSET " .. (page * PAGE)
    if kind == "c" then
        local where = n and ("t.entry = " .. n) or ("t.name LIKE '%" .. Esc(text) .. "%'")
        cnt = WorldDBQuery("SELECT COUNT(*) FROM creature_template t WHERE " .. where)
        q = WorldDBQuery("SELECT t.entry, COALESCE(MIN(m.CreatureDisplayID), 0), t.name FROM creature_template t LEFT JOIN creature_template_model m ON m.CreatureID = t.entry WHERE " ..
            where .. " GROUP BY t.entry, t.name ORDER BY t.entry" .. lim)
    else
        local where = n and ("t.entry = " .. n) or ("t.name LIKE '%" .. Esc(text) .. "%'")
        cnt = WorldDBQuery("SELECT COUNT(*) FROM gameobject_template t WHERE " .. where)
        q = WorldDBQuery("SELECT t.entry, COALESCE(f.file_id, 0), t.name, COALESCE(e.ext, x.ext, '') FROM gameobject_template t LEFT JOIN gameobject_display_file f ON f.display_id = t.displayId LEFT JOIN go_model_ext e ON e.displayId = t.displayId LEFT JOIN go_file_ext x ON x.file_id = f.file_id WHERE " .. where .. " AND (COALESCE(e.ext, x.ext, '') <> 'wmo' OR t.name NOT REGEXP '_[0-9]{3}(_lod[0-9])?$') ORDER BY t.entry" .. lim)
    end
    Send(p, "GMT;B;" .. kind .. ";" .. (cnt and cnt:GetUInt32(0) or 0) .. ";" .. page)
    if q then
        if kind == "g" then
            repeat Send(p, string.format("GMT;R;%s;%d;%d;%s;%s", kind, q:GetUInt32(0), q:GetUInt32(1), q:GetString(3), q:GetString(2))) until not q:NextRow()
        else
            repeat Send(p, string.format("GMT;R;%s;%d;%d;%s", kind, q:GetUInt32(0), q:GetUInt32(1), q:GetString(2))) until not q:NextRow()
        end
    end
end

local function SendSel(p, sel)
    Send(p, string.format("GMT;SEL;%s;%d;%s;%.3f;%.3f;%.3f;%.4f;%s", sel.kind, sel.entry, sel.name, sel.x, sel.y, sel.z, sel.o, tostring(sel.row or 0)))
end

local function Select(p, kind, obj, row, entry)
    local x, y, z, o = obj:GetLocation()
    SEL[p:GetName()] = {kind = kind, obj = obj:GetGUID(), row = row, entry = entry, name = NameOf(kind, entry), x = x, y = y, z = z, o = o or 0}
    SendSel(p, SEL[p:GetName()])
end

-- Finds the live object of a selection (objects are recreated by the core when moved, so the runtime guid changes: search by db row).
local function FindObj(p, sel)
    local obj
    pcall(function() obj = p:GetMap():GetWorldObject(sel.obj) end)
    if obj then return obj end
    if sel.kind == "g" and HasRow(sel.row) then
        local ok, list = pcall(function() return p:GetGameObjectsInRange(250, sel.entry) end)
        if ok and list then
            for _, g in ipairs(list) do
                local okr, r = pcall(function() return Row(g:GetDBTableGUIDLow()) end)
                if okr and r == sel.row then sel.obj = g:GetGUID(); return g end
            end
        end
    end
    return nil
end

-- Nearest saved object (db row ~= 0) of an entry within range of the player.
local function NearestGo(p, range, entry)
    -- smart pick: an object you look towards wins over one right behind you (score = distance, penalised by the angle to where you face);
    -- saved objects (movable) are preferred, unsaved ones are only returned when nothing saved is around
    local ok, list = pcall(function() return p:GetGameObjectsInRange(range, entry or 0) end)
    if not ok or not list then return nil end
    local px, py, pz, po = p:GetLocation()
    po = po or 0
    local best, bscore, brow
    local anyObj, anyScore
    for _, g in ipairs(list) do
        local okr, r = pcall(function() return Row(g:GetDBTableGUIDLow()) end)
        local gx, gy, gz = g:GetLocation()
        local dx, dy = gx - px, gy - py
        local d = math.sqrt(dx * dx + dy * dy + (gz - pz) ^ 2)
        local ang = math.abs(math.atan2(dy, dx) - po) % (2 * math.pi)
        if ang > math.pi then ang = 2 * math.pi - ang end
        local score = d * (1 + 1.5 * ang / math.pi)
        if okr and HasRow(r) then
            if not bscore or score < bscore then best, bscore, brow = g, score, r end
        elseif not anyScore or score < anyScore then
            anyObj, anyScore = g, score
        end
    end
    if best then return best, brow end
    if anyObj then return anyObj, "0" end
    return nil
end

local function NewGoGuid()
    local q = WorldDBQuery("SELECT COALESCE(MAX(guid), 3100900000) + 1 FROM gameobject WHERE guid BETWEEN 3100900001 AND 3100999999")
    return q and q:GetUInt64(0) or 3100900001
end

local function GroundZ(p, x, y, z)
    local ok, gz = pcall(function() return p:GetMap():GetHeight(x, y, 1000, p) end)
    if ok and gz and gz > -1000 and gz < 10000 then
        if gz > z - 30 and gz < z + 30 then return gz end
        if z <= gz then return gz end
    end
    return z
end

local function SpawnAt(p, kind, entry, x, y, z, o)
    -- NOTE: creature save=true v C++ pada (SaveToDB bez spawnId + CleanupsBeforeDelete crash, GlobalMethods.h:1886).
    -- Kym nebude recompil, creature spawnujeme docasne save=false (bez crashu) + hned Select pre Delete/move.
    -- Permanentny spawn pre NPC rob cez core `.npc add` (ten crashnuty nie je).
    if kind == "c" then
        z = GroundZ(p, x, y, z)
        local okQ, q = pcall(WorldDBQuery, "SELECT name FROM creature_template WHERE entry = " .. entry)
        if not (okQ and q) then
            print("[gmtool] SpawnAt c " .. tostring(entry) .. " no template")
            return nil, 0, "no template " .. entry
        end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), p:GetInstanceId(), x, y, z, o, false)
        if ok and c then
            local row = "0"
            pcall(function() row = Row(c:GetDBTableGUIDLow()) end)
            print("[gmtool] SpawnAt c " .. tostring(entry) .. " temp ok, row=" .. tostring(row))
            return c, row or "0", nil
        end
        print("[gmtool] SpawnAt c " .. tostring(entry) .. " failed (temp). Skus .npc add " .. tostring(entry))
        return nil, 0, "create failed " .. entry
    else
        z = GroundZ(p, x, y, z)
        local okQ, q = pcall(WorldDBQuery, "SELECT name FROM gameobject_template WHERE entry = " .. entry)
        if not (okQ and q) then
            print("[gmtool] SpawnAt g " .. tostring(entry) .. " no template")
            return nil, 0, "no template " .. entry
        end
        local gm = p:GetGMRank() >= 2
        if gm then
            -- GMs use the core's own .gobject add (the same thing typed by hand); it saves the object and keeps it after restarts
            local before = {}
            local okB, list = pcall(function() return p:GetGameObjectsInRange(12, entry) end)
            if okB and list then
                for _, g in ipairs(list) do
                    local okr, r = pcall(function() return Row(g:GetDBTableGUIDLow()) end)
                    if okr and r then before[r] = true end
                end
            end
            pcall(function() p:RunCommand("gobject add " .. entry) end)
            local okA, list2 = pcall(function() return p:GetGameObjectsInRange(12, entry) end)
            local row
            if okA and list2 then
                for _, g in ipairs(list2) do
                    local okr, r = pcall(function() return Row(g:GetDBTableGUIDLow()) end)
                    if okr and HasRow(r) and not before[r] and (not row or RowGt(r, row)) then row = r end
                end
            end
            if row then
                pcall(function() p:RunCommand(string.format("gobject move %s %.4f %.4f %.4f", row, x, y, z)) end)
                pcall(function() p:RunCommand(string.format("gobject turn %s %.4f", row, o)) end)
                local go = FindObj(p, {kind = "g", entry = entry, row = row})
                if go then
                    print("[gmtool] SpawnAt g " .. tostring(entry) .. " ok via .gobject add, row=" .. tostring(row))
                    return go, row, nil
                end
            end
            print("[gmtool] SpawnAt g " .. tostring(entry) .. " .gobject add produced nothing, trying PerformIngameSpawn")
        end
        local ok, go = pcall(PerformIngameSpawn, 2, entry, p:GetMapId(), p:GetInstanceId(), x, y, z, o, true)
        if ok and go then
            local row = "0"
            pcall(function() row = Row(go:GetDBTableGUIDLow()) end)
            if not gm and HasRow(row) then WorldDBExecute("INSERT IGNORE INTO house_obj (guid, owner) VALUES (" .. row .. ", '" .. Esc(p:GetName()) .. "')") end
            print("[gmtool] SpawnAt g " .. tostring(entry) .. " ok, row=" .. tostring(row))
            return go, row or "0", nil
        end
        print("[gmtool] SpawnAt g " .. tostring(entry) .. " failed: " .. tostring(go))
        return nil, 0, "the core refused entry " .. entry .. " (invalid display id?)"
    end
end

local function Remove(p, sel)
    local obj
    pcall(function() obj = p:GetMap():GetWorldObject(sel.obj) end)
    if sel.kind == "c" then
        if obj then pcall(function() obj:DespawnOrUnsummon(0) end) end
        if HasRow(sel.row) then
            WorldDBExecute("DELETE FROM creature WHERE guid = " .. sel.row)
            WorldDBExecute("DELETE FROM creature_addon WHERE guid = " .. sel.row)
        end
    else
        if not obj then obj = FindObj(p, sel) end
        if HasRow(sel.row) and p:GetGMRank() >= 2 then
            pcall(function() p:RunCommand("gobject delete " .. sel.row) end)
        else
            if obj then pcall(function() obj:RemoveFromWorld(false) end) end
            if HasRow(sel.row) then WorldDBExecute("DELETE FROM gameobject WHERE guid = " .. sel.row) end
        end
        if HasRow(sel.row) then WorldDBExecute("DELETE FROM house_obj WHERE guid = " .. sel.row) end
    end
end

local function Selected(p)
    local sel = SEL[p:GetName()]
    if not sel then Send(p, "GMT;ERR;Nothing selected (use Select nearest or spawn something).") return nil end
    return sel
end

-- Re-place the selected thing at x,y,z,o: creatures teleport, objects are respawned (the core cannot move them live).
local function Place(p, sel, x, y, z, o)
    local gm = p:GetGMRank() >= 2
    if sel.kind == "g" and gm and HasRow(sel.row) then
        -- the core moves and turns saved objects precisely (and recreates them live)
        pcall(function() p:RunCommand(string.format("gobject move %s %.4f %.4f %.4f", sel.row, x, y, z)) end)
        pcall(function() p:RunCommand(string.format("gobject turn %s %.4f", sel.row, o)) end)
        sel.x, sel.y, sel.z, sel.o = x, y, z, o
        local g = FindObj(p, sel)
        if g then
            sel.obj = g:GetGUID()
            local gx, gy, gz = g:GetLocation()
            local off = math.sqrt((gx - x) ^ 2 + (gy - y) ^ 2 + (gz - z) ^ 2)
            print(string.format("[gmtool] move row %s: wanted %.2f %.2f %.2f, now %.2f %.2f %.2f (off %.2f)", tostring(sel.row), x, y, z, gx, gy, gz, off))
            if off > 3 then   -- the core put it somewhere else: tell where it really is
                Send(p, string.format("GMT;ERR;Object %s is at %.1f %.1f %.1f (not where you wanted). Use Select nearest or .gobject near.", tostring(sel.row), gx, gy, gz))
                sel.x, sel.y, sel.z = gx, gy, gz
            end
        else
            print("[gmtool] move row " .. tostring(sel.row) .. ": object not found after the move (wanted " .. string.format("%.2f %.2f %.2f", x, y, z) .. ")")
            Send(p, string.format("GMT;ERR;Object %s was moved to %.1f %.1f %.1f but is not in range of you. .gobject near will not show it there.", tostring(sel.row), x, y, z))
        end
        SendSel(p, sel)
        return
    end
    local obj = FindObj(p, sel)
    if not obj then Send(p, "GMT;ERR;The selected object no longer exists.") return end
    if sel.kind == "c" then
        pcall(function() obj:NearTeleport(x, y, z, o) end)
        if HasRow(sel.row) then
            WorldDBExecute(string.format("UPDATE creature SET position_x = %f, position_y = %f, position_z = %f, orientation = %f WHERE guid = %s", x, y, z, o, sel.row))
        end
        Select(p, "c", obj, sel.row, sel.entry)
    else
        local oldRow = sel.row
        pcall(function() obj:RemoveFromWorld(false) end)
        if HasRow(oldRow) then WorldDBExecute("DELETE FROM gameobject WHERE guid = " .. oldRow) end
        local go, row = SpawnAt(p, "g", sel.entry, x, y, z, o)
        if go then Select(p, "g", go, row, sel.entry) else Send(p, "GMT;ERR;Respawn failed.") end
    end
end


-- ---------------------------------------------------------------- groups and emotes
pcall(WorldDBExecute, [[CREATE TABLE IF NOT EXISTS world.gm_group (id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(60) NOT NULL, owner VARCHAR(40) NOT NULL DEFAULT '') ENGINE=InnoDB]])
pcall(WorldDBExecute, [[CREATE TABLE IF NOT EXISTS world.gm_group_item (group_id INT UNSIGNED NOT NULL, idx INT UNSIGNED NOT NULL, kind CHAR(1) NOT NULL, entry INT UNSIGNED NOT NULL,
  dx FLOAT NOT NULL, dy FLOAT NOT NULL, dz FLOAT NOT NULL, dorient FLOAT NOT NULL, PRIMARY KEY (group_id, idx)) ENGINE=InnoDB]])

local DRAFT = {}   -- player name -> list of {kind, entry, x, y, z, o}
local LAST = {}    -- player name -> list of spawned selections of the last group spawn (for Undo)

local function ListGroups(p)
    Send(p, "GMT;GB")
    local q = WorldDBQuery("SELECT g.id, g.name, (SELECT COUNT(*) FROM gm_group_item i WHERE i.group_id = g.id) FROM gm_group g ORDER BY g.id DESC LIMIT 30")
    if q then repeat Send(p, string.format("GMT;GR;%d;%d;%s", q:GetUInt32(0), q:GetUInt32(2), q:GetString(1))) until not q:NextRow() end
end

local function GroupCmd(p, parts)
    local sub = parts[2]
    local name = p:GetName()
    local gm = p:GetGMRank() >= 2
    if sub == "A" then   -- add the selected object to the draft
        local sel = Selected(p)
        if not sel then return end
        if not gm and not OwnsRow(p, sel.row) then Send(p, "GMT;ERR;That object is not yours.") return end
        local obj
        pcall(function() obj = p:GetMap():GetWorldObject(sel.obj) end)
        if not obj then Send(p, "GMT;ERR;The selected object no longer exists.") return end
        local x, y, z, o = obj:GetLocation()
        DRAFT[name] = DRAFT[name] or {}
        table.insert(DRAFT[name], {kind = sel.kind, entry = sel.entry, x = x, y = y, z = z, o = o})
        Send(p, "GMT;GD;" .. #DRAFT[name])
    elseif sub == "C" then DRAFT[name] = nil; Send(p, "GMT;GD;0")
    elseif sub == "S" then   -- save the draft as a group, relative to its first object
        local d = DRAFT[name]
        if not d or #d == 0 then Send(p, "GMT;ERR;The draft is empty. Select objects and press Add to draft.") return end
        local gname = Esc(string.sub(parts[3] or "", 1, 58))
        if gname == "" then gname = "Group " .. os.date("%H%M%S") end
        WorldDBExecute(string.format("INSERT INTO gm_group (name, owner) VALUES ('%s', '%s')", gname, Esc(name)))
        local q = WorldDBQuery("SELECT MAX(id) FROM gm_group")
        local gid = q and q:GetUInt32(0) or 0
        local f = d[1]
        local c, s = math.cos(-f.o), math.sin(-f.o)
        for i, it in ipairs(d) do
            local rx, ry = it.x - f.x, it.y - f.y
            WorldDBExecute(string.format("INSERT INTO gm_group_item (group_id, idx, kind, entry, dx, dy, dz, dorient) VALUES (%d, %d, '%s', %d, %f, %f, %f, %f)",
                gid, i, it.kind, it.entry, rx * c - ry * s, rx * s + ry * c, it.z - f.z, (it.o - f.o) % (2 * math.pi)))
        end
        DRAFT[name] = nil
        Send(p, "GMT;GD;0")
        ListGroups(p)
    elseif sub == "L" then ListGroups(p)
    elseif sub == "P" then   -- spawn a group in front of me, facing my direction
        local gid = tonumber(parts[3])
        if not gid then return end
        local q = WorldDBQuery("SELECT kind, entry, dx, dy, dz, dorient FROM gm_group_item WHERE group_id = " .. gid .. " ORDER BY idx")
        if not q then Send(p, "GMT;ERR;Group not found.") return end
        local x, y, z, o = p:GetLocation()
        local ox, oy = x + math.cos(o) * 3, y + math.sin(o) * 3
        local c, s = math.cos(o), math.sin(o)
        LAST[name] = {}
        local made = 0
        repeat
            local kind, entry, dx, dy, dz, do_ = q:GetString(0), q:GetUInt32(1), q:GetFloat(2), q:GetFloat(3), q:GetFloat(4), q:GetFloat(5)
            local obj, row = SpawnAt(p, kind, entry, ox + dx * c - dy * s, oy + dx * s + dy * c, z + dz, (o + do_) % (2 * math.pi))
            if obj then
                made = made + 1
                table.insert(LAST[name], {kind = kind, obj = obj:GetGUID(), row = row, entry = entry})
            end
        until not q:NextRow()
        Send(p, "GMT;GD;" .. 0 .. ";spawned " .. made)
    elseif sub == "U" then   -- undo: delete everything of the last spawned group
        local l = LAST[name]
        if not l then Send(p, "GMT;ERR;No group was spawned yet.") return end
        for _, sel in ipairs(l) do pcall(Remove, p, sel) end
        LAST[name] = nil
        Send(p, "GMT;GD;0;removed")
    elseif sub == "X" then   -- delete the group definition
        local gid = tonumber(parts[3])
        if gid then
            WorldDBExecute("DELETE FROM gm_group_item WHERE group_id = " .. gid)
            WorldDBExecute("DELETE FROM gm_group WHERE id = " .. gid)
            ListGroups(p)
        end
    end
end

local function EmoteCmd(p, parts)
    local sel = Selected(p)
    if not sel then return end
    if sel.kind ~= "c" then Send(p, "GMT;ERR;Emotes work on NPCs.") return end
    local obj
    pcall(function() obj = p:GetMap():GetWorldObject(sel.obj) end)
    if not obj then Send(p, "GMT;ERR;The selected NPC no longer exists.") return end
    local id = tonumber(parts[3]) or 0
    if parts[2] == "S" then pcall(function() obj:EmoteState(id) end)      -- looping emote state (0 = stop)
    else pcall(function() obj:PerformEmote(id) end) end                   -- one shot
end

local function OnMessageInner(event, sender, msgType, prefix, msg)
    if prefix ~= "WCARD" or not msg or string.sub(msg, 1, 4) ~= "GMT;" then return end
    print("[gmtool] " .. tostring(sender:GetName()) .. ": " .. tostring(msg))
    local ok, isPlayer = pcall(function() return sender:GetGUIDLow() ~= nil and sender.GetGMRank ~= nil end)
    if not ok or not isPlayer then return end
    local gm = sender:GetGMRank() >= 2
    local plot
    if not gm then
        plot = PlotOf(sender)
        if not plot then Send(sender, "GMT;ERR;You need a house plot (.house claim) or GM rank 2.") return end
    end
    local parts = {}
    for f in string.gmatch(string.sub(msg, 5) .. ";", "([^;]*);") do parts[#parts + 1] = f end
    local cmd = parts[1]
    local p = sender
    local x, y, z, o = p:GetLocation()
    if not gm then
        if (cmd == "S" or cmd == "P" or cmd == "N") and parts[2] ~= "g" then Send(p, "GMT;ERR;Plot owners can place objects only (the Object tab).") return end
        if (cmd == "P" or cmd == "H") and not InPlot(plot, p:GetMapId(), x, y) then Send(p, "GMT;ERR;Stand inside your plot.") return end
        if cmd == "P" and CountObj(p) >= MAX_HOUSE_OBJ then Send(p, "GMT;ERR;Your plot is full (" .. MAX_HOUSE_OBJ .. " objects).") return end
        if cmd == "G" then Send(p, "GMT;ERR;Groups are for GMs.") return end
    end
    if cmd == "S" then Search(p, parts[2] == "g" and "g" or "c", parts[3] or "", parts[4])
    elseif cmd == "P" then
        local kind, entry = parts[2] == "g" and "g" or "c", tonumber(parts[3])
        if not entry then return end
        -- two yards in front of the GM
        local sx, sy = x + math.cos(o) * 2.5, y + math.sin(o) * 2.5
        local obj, row, err = SpawnAt(p, kind, entry, sx, sy, z, o + math.pi)
        if obj then
            -- auto-select hned po spawne aby Delete/move fungoval (hlavne pre OBJECT)
            Select(p, kind, obj, row, entry)
            if kind == "c" and not HasRow(row) then
                Send(p, "GMT;ERR;NPC docasny (bez crashu). Permanentny daj cez .npc add " .. entry)
            end
        else
            Send(p, "GMT;ERR;Spawn failed for " .. kind .. " " .. entry .. (err and (" (" .. err .. ")") or ""))
        end
    elseif cmd == "N" then
        local kind = parts[2] == "g" and "g" or "c"
        local obj, row = nil, "0"
        if kind == "c" then
            obj = p:GetSelection() or p:GetNearestCreature(15)
            if obj and obj.GetEntry == nil then obj = nil end
            if obj then pcall(function() row = Row(obj:GetDBTableGUIDLow()) end) end
        else
            obj, row = NearestGo(p, 80)
            if not obj then
                obj = p:GetNearestGameObject(20)
                if obj then pcall(function() row = Row(obj:GetDBTableGUIDLow()) end) end
            end
        end
        if not obj then Send(p, "GMT;ERR;Nothing within 80 yards.") return end
        row = row or "0"
        if not gm and not OwnsRow(p, row) then Send(p, "GMT;ERR;That object is not yours.") return end
        Select(p, kind, obj, row, obj:GetEntry())
        if kind == "g" and not HasRow(row) then Send(p, "GMT;ERR;Selected, but it is not saved in the database, so it cannot be moved.") end
    elseif cmd == "G" then GroupCmd(p, parts)
    elseif cmd == "E" then EmoteCmd(p, parts)
    elseif cmd == "D" then
        local sel = Selected(p)
        if sel and not gm and not OwnsRow(p, sel.row) then Send(p, "GMT;ERR;That object is not yours.") return end
        if sel then Remove(p, sel); SEL[p:GetName()] = nil; Send(p, "GMT;DEL") end
    elseif cmd == "M" or cmd == "MF" or cmd == "T" or cmd == "H" or cmd == "SET" then
        local sel = Selected(p)
        if not sel then return end
        if not gm and not OwnsRow(p, sel.row) then Send(p, "GMT;ERR;That object is not yours.") return end
        local obj = FindObj(p, sel)
        local ox, oy, oz, oo
        if obj then
            ox, oy, oz, oo = obj:GetLocation()
            sel.x, sel.y, sel.z, sel.o = ox, oy, oz, oo or 0
        else
            ox, oy, oz, oo = sel.x, sel.y, sel.z, sel.o
        end
        if not ox then Send(p, "GMT;ERR;The selected object no longer exists.") return end
        oo = oo or 0
        local function Cap(v) v = tonumber(v) or 0; return math.max(-100, math.min(100, v)) end   -- one step never moves further than 100 yards
        if cmd == "M" then ox, oy, oz = ox + Cap(parts[2]), oy + Cap(parts[3]), oz + Cap(parts[4])
        elseif cmd == "MF" then
            local d = Cap(parts[2])
            ox, oy = ox + math.cos(oo) * d, oy + math.sin(oo) * d
        elseif cmd == "T" then oo = (oo + (tonumber(parts[2]) or 0)) % (2 * math.pi)
        elseif cmd == "SET" then
            ox, oy, oz = tonumber(parts[2]) or ox, tonumber(parts[3]) or oy, tonumber(parts[4]) or oz
            if parts[5] and parts[5] ~= "" then oo = math.rad(tonumber(parts[5]) or 0) % (2 * math.pi) end
        else ox, oy, oz = x, y, z end
        if not gm and not InPlot(plot, p:GetMapId(), ox, oy) then Send(p, "GMT;ERR;Keep it inside your plot.") return end
        Place(p, sel, ox, oy, oz, oo)
    end
end

local function OnMessage(event, sender, msgType, prefix, msg)
    local ok, err = pcall(OnMessageInner, event, sender, msgType, prefix, msg)
    if not ok then
        print("[gmtool] ERROR: " .. tostring(err))
        pcall(function() Send(sender, "GMT;ERR;server error: " .. string.sub(tostring(err), 1, 150)) end)
    end
end

-- .house buy | info | abandon are core commands now (retail player housing); the old free-plot claim was removed.

RegisterServerEvent(30, OnMessage)
print("[gmtool] loaded")

-- ---------------------------------------------------------------- .nsp <entry>
-- Rychly chat spawn NPC bez addonu: postavi mobku 2.5 yardu pred GMa DOCASNE (save=false).
-- DOVOD ZMENY: save=true v C++ pada (GlobalMethods.h:1886 CleanupsBeforeDelete crash).
-- Kym nebude recompil, pouzivaj na permanentny spawn core `.npc add <entry>` (ten necrashuje).
-- Len GM rank 2+.
RegisterPlayerEvent(42, function(_, player, command)
    local id = string.match(string.lower(command or ""), "^nsp%s+(%d+)")
    if not id then return end
    local okG, rank = pcall(function() return player:GetGMRank() end)
    if not okG or (rank or 0) < 2 then
        player:SendBroadcastMessage("|cffff0000[GM]|r .nsp je len pre GM rank 2+.")
        return false
    end
    id = tonumber(id)
    -- sablona + model check (65 Midnight displayov chyba v creature_model_info - tie nejdu ani docasne)
    local okQ, q = pcall(WorldDBQuery, "SELECT name FROM creature_template WHERE entry = " .. id)
    local nm = (okQ and q and q:GetString(0)) or nil
    if not nm then
        player:SendBroadcastMessage("|cffff0000[GM]|r Sablona " .. id .. " v DB nie je.")
        return false
    end
    local okM = pcall(WorldDBQuery, "SELECT m.CreatureDisplayID FROM creature_template_model m LEFT JOIN creature_model_info mi ON mi.DisplayID=m.CreatureDisplayID WHERE m.CreatureID=" .. id .. " AND mi.DisplayID IS NULL LIMIT 1")
    -- vyssie okM je len pcall, realny check:
    local miss = WorldDBQuery("SELECT m.CreatureDisplayID FROM creature_template_model m LEFT JOIN creature_model_info mi ON mi.DisplayID=m.CreatureDisplayID WHERE m.CreatureID=" .. id .. " AND mi.DisplayID IS NULL LIMIT 1")
    if miss then
        player:SendBroadcastMessage("|cffff0000[GM]|r Entry " .. id .. " ma display " .. miss:GetUInt32(0) .. " bez creature_model_info - treba doplnit + restart (docasne nejde).")
        return false
    end
    local map, x, y, z, o = player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO()
    local sx, sy = x + math.cos(o) * 2.5, y + math.sin(o) * 2.5
    local okH, gz = pcall(function() return player:GetMap():GetHeight(sx, sy, 1000, player) end)
    if okH and gz and gz > -1000 then z = gz end
    local okS, c = pcall(PerformIngameSpawn, 1, id, map, player:GetInstanceId(), sx, sy, z, o, false)
    if okS and c then
        player:SendBroadcastMessage("|cff00ff00[GM]|r Docasne spawnute (bez crashu): " .. nm .. " (entry " .. id .. "). Permanentne daj cez .npc add " .. id .. ".")
    else
        player:SendBroadcastMessage("|cffff0000[GM]|r Spawn zlyhal pre entry " .. id .. " (aj docasny). Skus .npc add " .. id .. ".")
    end
    return false
end)
