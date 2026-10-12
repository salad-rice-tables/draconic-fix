-- =====================================================================
-- Worldforge (Descend): hidden objects all over Azeroth, each holds one
-- unique Worldforged item (custom items 9700001+, worldforge_items.sql).
--  * Objects (gameobject entry = item ID, worldforge_objects.sql) are put into
--    the world the first time a player comes near: ground height is taken from
--    the map, then the spawn is saved to `gameobject`, so later restarts load
--    it like any other object.
--  * Each character can claim each Worldforged item once
--    (characters.worldforge_looted).
--  * .wf  -> how many you found in this zone and how far the nearest one is.
-- Mystic Enchants (Descend): Mystic Scroll objects (9710001+, mystic_enchants.sql)
-- teach an enchant into your collection; turn enchants on in /ca (Mystic tab) or
-- with .me. Slots: 1 + 1 per 10 levels, at most 1 Legendary/Artifact and 3 Epic.
-- =====================================================================

-- GetCoinage() returns a 64-bit userdata on this Eluna: math.floor/compare need a plain number
local function Coin(p)
    local ok, v = pcall(function() return p:GetCoinage() end)
    return ok and (tonumber(tostring(v)) or 0) or 0
end
local ENABLED = true
local FIRST, LAST = 9700001, 9701383
local RADIUS = 450           -- spawn objects within this many yards of a player
local CHECK_MS = 30000       -- re-check around each player every 30 s
local TAG = "|cffff8000[Worldforge]|r "

local MFIRST, MLAST = 9710001, 9712500
local MTAG = "|cffa335ee[Mystic]|r "
local MQ = {[3] = {"Rare", "ff0070dd"}, [4] = {"Epic", "ffa335ee"}, [5] = {"Legendary", "ffff8000"}, [6] = {"Artifact", "ffe6cc80"}}

local function Key(player) return (string.gsub(player:GetName() or "", "'", "''")) end

local function Ground(player, x, y)
    local ok, z = pcall(function() return player:GetMap():GetHeight(x, y, player) end)
    if ok and z then return z end
    return nil
end

local busy = {}
local function SpawnNear(player)
    if not player or not player:IsInWorld() then return end
    local mapId = player:GetMapId()
    if mapId ~= 0 and mapId ~= 1 then return end
    if busy[mapId] then return end
    busy[mapId] = true
    local px, py = player:GetX(), player:GetY()
    local n = 0
    -- {table, key column, entry column}
    -- Runtime spawning is OFF: PerformIngameSpawn for GameObjects crashes this core (and its SaveToDB fails).
    -- The 3399 Worldforged and 3759 Mystic objects with a static spawn in world.gameobject are enough.
    for _, t in ipairs({}) do
        local q = WorldDBQuery(string.format(
            "SELECT %s AS k, %s AS e, wx, wy FROM %s WHERE map = %d AND wx BETWEEN %f AND %f AND wy BETWEEN %f AND %f",
            t[2], t[3], t[1], mapId, px - RADIUS, px + RADIUS, py - RADIUS, py + RADIUS))
        if q then
            repeat
                local key, entry, x, y = q:GetUInt32(0), q:GetUInt32(1), q:GetFloat(2), q:GetFloat(3)
                -- the objects are temporary spawns (saving them to the DB fails on this core): each Worldforged
                -- object has its own entry, so "already standing nearby" means it is spawned
                local okN, near = pcall(function() return player:GetNearestGameObject(RADIUS + 60, entry) end)
                if not (okN and near) then
                    local z = Ground(player, x, y)
                    if z then
                        local ok, go = pcall(PerformIngameSpawn, 2, entry, mapId, 0, x, y, z, math.random() * 6.28, false)
                        if ok and go then n = n + 1 end
                    end
                end
            until not q:NextRow()
        end
    end
    busy[mapId] = nil
    if n > 0 then print("[worldforge] placed " .. n .. " objects near " .. player:GetName()) end
end

local function Looted(player, item)
    local ok, res = pcall(CharDBQuery, string.format("SELECT 1 FROM characters.worldforge_looted WHERE name = '%s' AND item = %d", Key(player), item))
    return ok and res ~= nil
end

local function OnUse(event, go, player)
    if not player then return true end
    local item = go:GetEntry()
    if Looted(player, item) then
        player:SendNotification("You already claimed what this held.")
        return true
    end
    local given = player:AddItem(item, 1)
    if not given then
        player:SendNotification("Your bags are full.")
        return true
    end
    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.worldforge_looted (name, item) VALUES ('%s', %d)", Key(player), item))
    local link = GetItemLink(item) or ("item " .. item)
    player:SendBroadcastMessage(TAG .. "You discovered a Worldforged item: " .. link .. "!")
    pcall(function() player:PlayDirectSound(888, player) end)  -- level-up fanfare
    print("[worldforge] " .. player:GetName() .. " found " .. item)
    if BountyProgress then pcall(BountyProgress, player, "find", 1) end
    if COLLECTION_Check then pcall(COLLECTION_Check, player) end
    if SEASON_AddPoints then pcall(SEASON_AddPoints, player, 2) end
    return true
end

local function Status(player)
    local zone = player:GetZoneId()
    local px, py = player:GetX(), player:GetY()
    local q = WorldDBQuery(string.format(
        "SELECT item, wx, wy, object_name FROM worldforge_item WHERE map = %d AND wx BETWEEN %f AND %f AND wy BETWEEN %f AND %f",
        player:GetMapId(), px - 2500, px + 2500, py - 2500, py + 2500))
    local total, found, best = 0, 0, nil
    if q then
        repeat
            local item, x, y = q:GetUInt32(0), q:GetFloat(1), q:GetFloat(2)
            total = total + 1
            if Looted(player, item) then found = found + 1
            else
                local d = math.sqrt((x - px) ^ 2 + (y - py) ^ 2)
                if not best or d < best[1] then best = {d, q:GetString(3), x, y} end
            end
        until not q:NextRow()
    end
    player:SendBroadcastMessage(TAG .. "Worldforged items around you: found " .. found .. " / " .. total .. ".")
    if best then
        local dx, dy = best[3] - px, best[4] - py
        local dir = (math.abs(dx) > math.abs(dy)) and (dx > 0 and "north" or "south") or (dy > 0 and "west" or "east")
        player:SendBroadcastMessage(TAG .. "The nearest unclaimed one (" .. best[2] .. ") is about " .. math.floor(best[1]) .. " yards " .. dir .. ".")
    end
end

-- ---------------------------------------------------------------- Mystic Enchants
local ENCH, ENCH_BY_SCROLL = {}, {}
do
    local q = WorldDBQuery("SELECT id, name, spell, quality, scroll, classes FROM mystic_enchant")
    if q then
        repeat
            local e = {id = q:GetUInt32(0), name = q:GetString(1), spell = q:GetUInt32(2), q = q:GetUInt32(3), scroll = q:GetUInt32(4), classes = q:GetString(5) or ""}
            ENCH[e.id] = e; ENCH_BY_SCROLL[e.scroll] = e
        until not q:NextRow()
    end
end

local function SendClient(player, msg)
    pcall(function() player:SendAddonMessage("WCARD", msg, 7, player) end)
end

-- window on the client: MREV;kind;spellId;name;rarity   (kind E = enchant learned, D = already known -> rune, R = runes)
local function Reveal(player, kind, e, extra)
    local q = e and e.q or 0
    SendClient(player, string.format("MREV;%s;%d;%s;%s", kind, e and e.spell or 0, e and e.name or "Mystic Rune", (MQ[q] and MQ[q][1] or "") .. (extra and ("|" .. extra) or "")))
end

-- Midnight "Astral Acceleration" (1299501, haste): a short burst of speed when a new Mystic Enchant is unlocked
local function MysticFx(player)
    pcall(function() player:CastSpell(player, 1299501, true) end)
    pcall(function() player:RegisterEvent(function(_, _, _, p) if p then pcall(function() p:RemoveAura(1299501) end) end end, 8000, 1) end)
end

local function Collection(player)
    local t = {}
    local ok, res = pcall(CharDBQuery, string.format("SELECT enchant, active FROM characters.mystic_collection WHERE name = '%s'", Key(player)))
    if ok and res then repeat t[res:GetUInt32(0)] = res:GetUInt32(1) == 1 until not res:NextRow() end
    return t
end

local function Slots(player) return math.min(10, 1 + math.floor(player:GetLevel() / 10)) end

local function ELink(e)
    local c = MQ[e.q] or MQ[3]
    return "|c" .. c[2] .. "|Hspell:" .. e.spell .. "|h[" .. e.name .. "]|h|r"
end

local function Knows(player, id)
    local ok, has = pcall(function() return player:HasSpell(id) end)
    return ok and has
end

-- apply the collection: active enchants learned, inactive ones removed
local function ApplyMystic(player)
    for id, active in pairs(Collection(player)) do
        local e = ENCH[id]
        if e then
            if active and not Knows(player, e.spell) then pcall(function() player:LearnSpell(e.spell) end)
            elseif not active and Knows(player, e.spell) then pcall(function() player:RemoveSpell(e.spell) end) end
        end
    end
end

local function MysticState(player)
    local col = Collection(player)
    local used, leg, epic, total = 0, 0, 0, 0
    for id, active in pairs(col) do
        local e = ENCH[id]
        total = total + 1
        if active and e then
            used = used + 1
            if e.q >= 5 then leg = leg + 1 elseif e.q == 4 then epic = epic + 1 end
        end
    end
    return col, used, leg, epic, total
end

local function SetActive(player, id, on)
    local e = ENCH[id]
    if not e then return false, "Unknown Mystic Enchant." end
    local col, used, leg, epic = MysticState(player)
    if col[id] == nil then return false, "You have not found that Mystic Scroll yet." end
    if player:IsInCombat() then return false, "You cannot change Mystic Enchants in combat." end
    if on and CHALLENGE_NoMystic and CHALLENGE_NoMystic(player) then return false, "Iron Man heroes cannot use Mystic Enchants." end
    if on then
        if col[id] then return false, e.name .. " is already active." end
        if used >= Slots(player) then return false, "All " .. Slots(player) .. " Mystic slots are in use (1 more every 10 levels)." end
        if e.q >= 5 and leg >= 1 then return false, "Only one Legendary or Artifact enchant can be active." end
        if e.q == 4 and epic >= 3 then return false, "Only three Epic enchants can be active." end
        pcall(function() player:LearnSpell(e.spell) end)
    else
        if not col[id] then return false, e.name .. " is not active." end
        pcall(function() player:RemoveSpell(e.spell) end)
    end
    pcall(CharDBExecute, string.format("UPDATE characters.mystic_collection SET active = %d WHERE name = '%s' AND enchant = %d", on and 1 or 0, Key(player), id))
    player:SendBroadcastMessage(MTAG .. (on and "Activated " or "Deactivated ") .. ELink(e) .. ".")
    SendClient(player, "MCHANGED")
    return true
end

-- Mystic Runes: from scrolls you already know; spent at a Mystic Altar
local function Runes(player)
    local ok, res = pcall(CharDBQuery, string.format("SELECT runes FROM characters.mystic_runes WHERE name = '%s'", Key(player)))
    if ok and res then return res:GetUInt32(0) end
    return 0
end

local function AddRunes(player, n)
    pcall(CharDBExecute, string.format("INSERT INTO characters.mystic_runes (name, runes) VALUES ('%s', %d) ON DUPLICATE KEY UPDATE runes = GREATEST(0, runes + %d)",
        Key(player), math.max(0, n), n))
end

local function OnScrollUse(event, go, player)
    if not player then return true end
    local e = ENCH_BY_SCROLL[go:GetEntry()]
    if not e then return true end
    local col = Collection(player)
    if col[e.id] ~= nil then
        local spawn = tostring(go:GetDBTableGUIDLow())
        local okC, res = pcall(CharDBQuery, string.format("SELECT 1 FROM characters.mystic_rune_claim WHERE name = '%s' AND spawn = '%s'", Key(player), spawn))
        if okC and res then
            player:SendNotification("You already know " .. e.name .. ".")
        else
            pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.mystic_rune_claim (name, spawn) VALUES ('%s', '%s')", Key(player), spawn))
            AddRunes(player, (SEASON_Is and SEASON_Is("mystic")) and 2 or 1)
            Reveal(player, "D", e, "Runes: " .. Runes(player))
            player:SendBroadcastMessage(MTAG .. "You already know " .. ELink(e) .. " - the scroll crumbles into a |cffa335eeMystic Rune|r. Runes: " .. Runes(player) .. ".")
        end
        return true
    end
    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.mystic_collection (name, enchant, active) VALUES ('%s', %d, 0)", Key(player), e.id))
    Reveal(player, "E", e); MysticFx(player)
    player:SendBroadcastMessage(MTAG .. "You learned the Mystic Enchant " .. ELink(e) .. "! Turn it on in the window.")
    if HERO_MysticWindow then pcall(HERO_MysticWindow, player) end
    pcall(function() player:PlayDirectSound(888, player) end)
    print("[mystic] " .. player:GetName() .. " learned enchant " .. e.id)
    if BountyProgress then pcall(BountyProgress, player, "find", 1) end
    if COLLECTION_Check then pcall(COLLECTION_Check, player) end
    if SEASON_AddPoints then pcall(SEASON_AddPoints, player, 2) end
    return true
end

local function MysticList(player)
    local col, used, leg, epic, total = MysticState(player)
    local ids = {}
    for id in pairs(col) do ids[#ids + 1] = id end
    table.sort(ids, function(a, b) return (ENCH[a] and ENCH[a].q or 0) > (ENCH[b] and ENCH[b].q or 0) end)
    player:SendBroadcastMessage(MTAG .. "Collection: " .. total .. " enchants. Active " .. used .. " / " .. Slots(player) ..
        " (Legendary " .. leg .. "/1, Epic " .. epic .. "/3).")
    for i, id in ipairs(ids) do
        if i > 30 then player:SendBroadcastMessage("  ...") break end
        local e = ENCH[id]
        if e then player:SendBroadcastMessage("  " .. id .. "  " .. ELink(e) .. (col[id] and "  |cff00ff00active|r" or "")) end
    end
    player:SendBroadcastMessage(MTAG .. ".me on <id>  .me off <id>")
end

local function MysticUI(player)
    local col, used, leg, epic = MysticState(player)
    local chunk, n = {}, 0
    for id, active in pairs(col) do
        local e = ENCH[id]
        if e then
            chunk[#chunk + 1] = id .. ":" .. e.spell .. ":" .. e.q .. ":" .. (active and 1 or 0)
            if #chunk == 12 then n = n + 1; SendClient(player, "MYS;" .. n .. ";" .. table.concat(chunk, ",")); chunk = {} end
        end
    end
    n = n + 1
    SendClient(player, "MYS;" .. n .. ";" .. table.concat(chunk, ","))
    SendClient(player, "MSTATE;" .. Slots(player) .. ";" .. used .. ";" .. leg .. ";" .. epic)
    SendClient(player, "MRUNES;" .. Runes(player))
end

-- random enchant the player does not have; higher qualities unlock with level
local function RollEnchant(player)
    local col, lvl = Collection(player), player:GetLevel()
    local w = {[3] = 70, [4] = 25, [5] = lvl >= 30 and 4 or 0, [6] = lvl >= 50 and 1 or 0}
    local byQ, total = {}, 0
    for id, e in pairs(ENCH) do
        if col[id] == nil and (w[e.q] or 0) > 0 then
            byQ[e.q] = byQ[e.q] or {}
            table.insert(byQ[e.q], e)
        end
    end
    for q, lst in pairs(byQ) do total = total + w[q] end
    if total == 0 then return nil end
    local r = math.random() * total
    for q, lst in pairs(byQ) do
        r = r - w[q]
        if r <= 0 then return lst[math.random(#lst)] end
    end
    local _, lst = next(byQ)
    return lst[1]
end

local function GoldCost(player)   -- 50 silver per level, cheaper with city reputation (world_events.lua)
    local season = (SEASON_Is and SEASON_Is("mystic")) and 0.5 or 1
    return math.floor(5000 * math.max(1, player:GetLevel()) * (CITY_PriceFactor and CITY_PriceFactor(player) or 1) * season)
end
local RUNE_COST = 3

local ALTAR_NPC, ALTAR_TEXT = 9900130, 9900130

local function AltarShow(player, creature)
    player:GossipClearMenu()
    local g = GoldCost(player)
    player:GossipMenuAddItem(3, "Roll a random Mystic Enchant (" .. math.floor(g / 10000) .. "g " .. math.floor(g % 10000 / 100) .. "s)", 0, 1, false,
        "Roll a Mystic Enchant you do not know yet?", g)
    player:GossipMenuAddItem(3, "Roll with " .. RUNE_COST .. " Mystic Runes (you have " .. Runes(player) .. ")", 0, 2)
    player:GossipMenuAddItem(0, "Show my Mystic Enchants", 0, 3)
    player:GossipMenuAddItem(3, "Use the Mystic Forge (window)", 0, 6)
    player:GossipMenuAddItem(1, "Hero supplies: Ability Purge, Talent Purge, Dice of Destiny", 0, 7)
    player:GossipMenuAddItem(3, "Forge a Worldforged item at the anvil (10 Mystic Runes)", 0, 5, false, "Spend 10 Mystic Runes to forge a Worldforged item for your level?")
    player:GossipMenuAddItem(1, "Learn a mount or travel spell (100 gold each)", 0, 8)
    player:GossipMenuAddItem(0, "How does Mystic Enchanting work?", 0, 4)
    player:GossipSendMenu(1, creature)
end

-- mounts and travel spells (WORLD_DROPS of wildcard.lua) are bought here, they are not part of the Wildcard draft
local UTIL_PRICE = 1000000
local function UtilityShow(player, creature)
    player:GossipClearMenu()
    local n = 0
    for i, e in ipairs(WORLD_DROPS or {}) do
        if not player:HasSpell(e[1]) and n < 28 then
            n = n + 1
            player:GossipMenuAddItem(1, e[2], 0, 100 + i, false, "Learn " .. e[2] .. " for 100 gold?", UTIL_PRICE)
        end
    end
    if n == 0 then player:GossipMenuAddItem(0, "You know every mount and travel spell on offer.", 0, 3000) end
    player:GossipMenuAddItem(0, "Back", 0, 3001)
    player:GossipSendMenu(1, creature)
end

local function GiveRolled(player)
    local e = RollEnchant(player)
    if not e then player:SendBroadcastMessage(MTAG .. "You already know every enchant you can roll at your level."); return false end
    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.mystic_collection (name, enchant, active) VALUES ('%s', %d, 0)", Key(player), e.id))
    Reveal(player, "E", e); MysticFx(player)
    player:SendBroadcastMessage(MTAG .. "The altar flares: you learned " .. ELink(e) .. "! Turn it on in /ca (Mystic) or .me on " .. e.id .. ".")
    pcall(function() player:PlayDirectSound(888, player) end)
    if COLLECTION_Check then pcall(COLLECTION_Check, player) end
    if SEASON_AddPoints then pcall(SEASON_AddPoints, player, 2) end
    return true
end

local function AltarSelect(event, player, creature, sender, intid, code)
    if intid == 8 then UtilityShow(player, creature); return
    elseif intid > 100 and intid < 3000 then
        local e = (WORLD_DROPS or {})[intid - 100]
        if e and not player:HasSpell(e[1]) and Coin(player) >= UTIL_PRICE then
            player:ModifyMoney(-UTIL_PRICE); player:LearnSpell(e[1])
            player:SendBroadcastMessage(MTAG .. "You learned " .. e[2] .. ".")
        else player:SendNotification("You cannot afford that.") end
        UtilityShow(player, creature); return
    elseif intid == 3000 or intid == 3001 then AltarShow(player, creature); return
    end
    if intid == 1 then
        local g = GoldCost(player)
        if Coin(player) < g then player:SendNotification("You cannot afford that.")
        elseif RollEnchant(player) then player:ModifyMoney(-g); GiveRolled(player) end
    elseif intid == 2 then
        if Runes(player) < RUNE_COST then player:SendNotification("You need " .. RUNE_COST .. " Mystic Runes.")
        elseif RollEnchant(player) then AddRunes(player, -RUNE_COST); GiveRolled(player) end
    elseif intid == 6 then
        player:GossipComplete(); MYS_ForgeOpen(player); return
    elseif intid == 7 then
        player:GossipComplete(); player:SendListInventory(creature); return
    elseif intid == 3 then
        MysticList(player)
    elseif intid == 5 then
        if PROG_ForgeWorldforged then PROG_ForgeWorldforged(player) end
    elseif intid == 4 then
        player:SendBroadcastMessage(MTAG .. "Mystic Scrolls lie all over the world and in dungeons - each teaches an enchant. " ..
            "A scroll you already know turns into a Mystic Rune; " .. RUNE_COST .. " runes or gold buy a random enchant here. " ..
            "Active slots: 1 + 1 per 10 levels, at most 1 Legendary/Artifact and 3 Epic (/ca, Mystic tab).")
    end
    AltarShow(player, creature)
end

SpawnNear = (PERF_Wrap or function(_, f) return f end)("worldforge.SpawnNear", SpawnNear)

local function OnLogin(event, player)
    ApplyMystic(player)
end

-- objects are placed by the map's own state, never from the login (world) state
if MAP_Timer then
    MAP_Timer("worldforge.Spawn", function()
        for _, p in ipairs(MAP_Players()) do pcall(SpawnNear, p) end
    end, CHECK_MS)
end

if ENABLED then
    RegisterPlayerEvent(3, OnLogin)
    RegisterPlayerEvent(27, function(_, player) if not IS_WORLD_STATE then SpawnNear(player) end end)  -- ON_UPDATE_ZONE (map state)
    RegisterPlayerEvent(42, function(_, player, command)                -- ON_COMMAND
        local c = string.lower(command or "")
        if c == "wf" or c == "worldforge" then Status(player) return false end
        local sub, id = string.match(c, "^me%s*(%a*)%s*(%d*)$")
        if sub then
            local ok, err = true, nil
            if sub == "on" then ok, err = SetActive(player, tonumber(id) or 0, true)
            elseif sub == "off" then ok, err = SetActive(player, tonumber(id) or 0, false)
            else MysticList(player) end
            if not ok and err then player:SendBroadcastMessage(MTAG .. err) end
            return false
        end
    end)
    RegisterServerEvent(30, function(_, sender, _, prefix, msg)          -- ADDON message (/ca Mystic tab)
        if prefix ~= "WCARD" then return end
        local ok, isPlayer = pcall(function() return sender.LearnSpell ~= nil end)
        if not ok or not isPlayer then return end
        local kind, arg = string.match(msg or "", "^(%a+);?(%d*)")
        if kind == "MLIST" then MysticUI(sender)
        elseif kind == "MROLL" then   -- roll an enchant from anywhere with the Mystic tab (no altar needed)
            if sender:IsInCombat() then SendClient(sender, "ERR;Not in combat.")
            elseif Runes(sender) < RUNE_COST then SendClient(sender, "ERR;You need " .. RUNE_COST .. " Mystic Runes."); sender:SendBroadcastMessage(MTAG .. "You need " .. RUNE_COST .. " Mystic Runes.")
            elseif RollEnchant(sender) then AddRunes(sender, -RUNE_COST); GiveRolled(sender); MysticUI(sender)
            else sender:SendBroadcastMessage(MTAG .. "You already know every enchant you can roll at your level.") end
        elseif kind == "FORGEOPEN" then MYS_ForgeOpen(sender)
        elseif kind == "FORGEBUY" then MYS_ForgeBuy(sender, tonumber(arg) or 1)
        elseif kind == "MON" or kind == "MOFF" then
            local ok2, err = SetActive(sender, tonumber(arg) or 0, kind == "MON")
            if not ok2 and err then sender:SendBroadcastMessage(MTAG .. err); SendClient(sender, "ERR;" .. err) end
        end
    end)
    -- ON_USE. At server start Lua loads before the object templates, so the
    -- registration waits for WORLD_EVENT_ON_STARTUP; on .reload eluna it runs at once.
    local function RegisterObjects()
        -- POZOR: neregistrujeme slepo cely rozsah MFIRST-MLAST. V DB chybaju
        -- zaznamy 9712208-9712500 a prve chybajuce ID by vyhodilo chybu,
        -- ktora by prerusila celu registraciu (aj OnUse pre worldforge itemy).
        -- Registrujeme preto len objekty, ktore v DB naozaj existuju.
        local gq = WorldDBQuery(string.format(
            "SELECT entry FROM gameobject_template WHERE entry BETWEEN %d AND %d",
            MFIRST, MLAST))
        if gq then repeat pcall(RegisterGameObjectEvent, gq:GetUInt32(0), 14, OnScrollUse) until not gq:NextRow() end
        local q = WorldDBQuery("SELECT item FROM worldforge_item WHERE object_name <> ''")  -- items without a place have no object
        if q then repeat pcall(RegisterGameObjectEvent, q:GetUInt32(0), 14, OnUse) until not q:NextRow() end
    end
    if not pcall(RegisterObjects) then RegisterServerEvent(14, RegisterObjects) end
    RegisterCreatureGossipEvent(ALTAR_NPC, 1, function(_, player, creature) AltarShow(player, creature) end)
    RegisterCreatureGossipEvent(ALTAR_NPC, 2, AltarSelect)
    local ne = 0
    for _ in pairs(ENCH) do ne = ne + 1 end
    print("[worldforge] loaded: objects " .. FIRST .. "-" .. LAST .. ", " .. ne .. " Mystic Enchants")
end

-- ---------------------------------------------------------------- shared with descend_world.lua
-- Give the player an unclaimed Worldforged item from near (x, y) on map; returns item id or nil.
function WF_GiveNearbyItem(player, radius)
    local px, py = player:GetX(), player:GetY()
    local r = radius or 2500
    local q = WorldDBQuery(string.format(
        "SELECT item FROM worldforge_item WHERE map = %d AND wx BETWEEN %f AND %f AND wy BETWEEN %f AND %f ORDER BY RAND() LIMIT 25",
        player:GetMapId(), px - r, px + r, py - r, py + r))
    if not q then return nil end
    repeat
        local item = q:GetUInt32(0)
        if not Looted(player, item) then
            if player:AddItem(item, 1) then
                pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.worldforge_looted (name, item) VALUES ('%s', %d)", Key(player), item))
                player:SendBroadcastMessage(TAG .. "Worldforged loot: " .. (GetItemLink(item) or item) .. "!")
                return item
            end
            return nil
        end
    until not q:NextRow()
    return nil
end

function MYS_AddRunes(player, n)
    AddRunes(player, n)
    SendClient(player, "MREV;R;0;+" .. n .. " Mystic Rune" .. (n > 1 and "s" or "") .. ";Added to your Mystic Rune pool.")
    player:SendBroadcastMessage(MTAG .. "+" .. n .. " Mystic Rune" .. (n > 1 and "s" or "") .. ". Runes: " .. Runes(player) .. ".")
end

function MYS_GiveRandomEnchant(player) return GiveRolled(player) end

-- Descend style scrolls: item 9740000 + enchant id teaches exactly that enchant (loot from any creature, see mystic_scroll_items.py)
local SCROLL_BASE = 9740000
local function LearnScroll(player, e, quiet)
    local col = Collection(player)
    if col[e.id] ~= nil then
        AddRunes(player, (SEASON_Is and SEASON_Is("mystic")) and 2 or 1)
        if not quiet then Reveal(player, "D", e, "Added 1 Mystic Rune.") end
        player:SendBroadcastMessage(MTAG .. "You already know " .. ELink(e) .. " - the scroll crumbles into a |cffa335eeMystic Rune|r.")
        return "dup"
    end
    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.mystic_collection (name, enchant, active) VALUES ('%s', %d, 0)", Key(player), e.id))
    if not quiet then Reveal(player, "E", e) end; MysticFx(player)
    player:SendBroadcastMessage(MTAG .. "You learned the Mystic Enchant " .. ELink(e) .. "! Turn it on in the Mystic window (/mystic).")
    pcall(function() player:PlayDirectSound(888, player) end)
    if COLLECTION_Check then pcall(COLLECTION_Check, player) end
    if SEASON_AddPoints then pcall(SEASON_AddPoints, player, 2) end
    print("[mystic] " .. player:GetName() .. " learned enchant " .. e.id .. " from a scroll")
    return "new"
end

-- ---------------------------------------------------------------- Mystic Forge (object with a window)
local FORGE_GO, BULLION, BOLT, FORGE_COPPER = 9712501, 9750005, 9750006, 5000
local MARK, MARK_COST = 9750009, 5   -- Mark of Descend: quests, dungeons and bosses give them
local ODDS = {   -- Rare, Epic, Legendary, Artifact by payment: 1 = 50 silver, 2 = Bedlam Bullion, 3 = Bonzo Bolt
    [1] = {62, 28, 9, 1}, [2] = {62, 28, 9, 1}, [3] = {30, 45, 22, 3}, [4] = {55, 33, 11, 1},
}
local function ClassToken(player)
    local ok, c = pcall(function() return player:GetClass() end)
    local T = {[1] = "warrior", [2] = "paladin", [3] = "hunter", [4] = "rogue", [5] = "priest", [7] = "shaman", [8] = "mage", [9] = "warlock", [11] = "druid"}
    return ok and T[c] or ""
end
local function PickEnchant(player, quality)
    local col, cls, mine, any = Collection(player), ClassToken(player), {}, {}
    for id, e in pairs(ENCH) do
        if e.q == quality then
            any[#any + 1] = e
            if col[id] == nil then
                if cls ~= "" and string.find(e.classes or "", cls, 1, true) then for _ = 1, 4 do mine[#mine + 1] = e end end
                mine[#mine + 1] = e
            end
        end
    end
    local pool = #mine > 0 and mine or any
    if #pool == 0 then return nil end
    return pool[math.random(#pool)]
end
function MYS_ForgeOpen(player)
    local function Count(item) local ok, n = pcall(function() return player:GetItemCount(item) end) return ok and n or 0 end
    SendClient(player, "FORGE;OPEN;" .. Count(BULLION) .. ";" .. Count(BOLT) .. ";" .. Runes(player) .. ";" .. math.floor((Coin(player) or 0) / 100) .. ";" .. Count(MARK))
end
local function ForgeBuy(player, method)
    if player:IsInCombat() then SendClient(player, "ERR;Not in combat.") return end
    if method == 4 then
        if player:GetItemCount(MARK) < MARK_COST then SendClient(player, "ERR;You need " .. MARK_COST .. " Marks of Descend.") return end
    elseif method == 3 then
        if player:GetItemCount(BOLT) < 1 then SendClient(player, "ERR;You need a Bonzo Bolt.") return end
    elseif method == 2 then
        if player:GetItemCount(BULLION) < 1 then SendClient(player, "ERR;You need Bedlam Bullion.") return end
    else
        method = 1
        if Coin(player) < FORGE_COPPER then SendClient(player, "ERR;The scroll costs 50 silver.") return end
    end
    -- pay
    if method == 4 then player:RemoveItem(MARK, MARK_COST) elseif method == 3 then player:RemoveItem(BOLT, 1) elseif method == 2 then player:RemoveItem(BULLION, 1) else player:ModifyMoney(-FORGE_COPPER) end
    local w, lvl = ODDS[method], player:GetLevel()
    local r, q = math.random(100), 3
    local acc = 0
    for i, weight in ipairs(w) do acc = acc + weight; if r <= acc then q = 2 + i break end end
    if q == 5 and lvl < 30 then q = 4 end
    if q == 6 and lvl < 50 then q = (lvl < 30) and 4 or 5 end
    local e = PickEnchant(player, q)
    if not e then SendClient(player, "ERR;The forge found nothing.") return end
    local res = LearnScroll(player, e, true)
    SendClient(player, string.format("FORGE;RES;%d;%d;%d;%d;%s", e.id, e.q, res == "dup" and 1 or 0, e.spell, e.name))
    MysticUI(player)
    MYS_ForgeOpen(player)
end
function MYS_ForgeBuy(player, method) ForgeBuy(player, method) end

if not IS_WORLD_STATE then
    pcall(RegisterGameObjectEvent, FORGE_GO, 14, function(_, go, player) if player then MYS_ForgeOpen(player) end return true end)
    local reg = 0
    for id, e in pairs(ENCH) do
        RegisterItemEvent(SCROLL_BASE + id, 1, function(_, caster)
            if caster and caster.GetName then LearnScroll(caster, e) end
            return true
        end)
        reg = reg + 1
    end
    print("[worldforge] " .. reg .. " Mystic Scroll items registered")
end

-- for the Character Advancement window (wildcard.lua): collection list and toggle
function MYS_GetList(player)
    local col = Collection(player)
    local out = {}
    for id, active in pairs(col) do
        local e = ENCH[id]
        if e then out[#out + 1] = {id = id, name = e.name, q = e.q, active = active} end
    end
    table.sort(out, function(a, b) if a.active ~= b.active then return a.active end if a.q ~= b.q then return a.q > b.q end return a.name < b.name end)
    local _, used = MysticState(player)
    return out, used, Slots(player)
end
function MYS_Toggle(player, id, on) return SetActive(player, id, on) end
