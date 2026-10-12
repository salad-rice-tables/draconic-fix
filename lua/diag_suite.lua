-- =====================================================================
-- GM diagnostics. One family of commands that says what is going on, so quests and NPCs can be fixed from facts:
--   .diag            help
--   .diag all        everything below in one report (you, area, target or nearest NPC, nearest object)
--   .diag me         you: position, zone/area, phases, level, quest log with objectives, auras that matter
--   .diag npc [x]    the target (or the nearest creature within 20 yd, or entry x): template, spawn, flags, gossip menu and options, quests (and why you can/can not
--                    take them), vendor/trainer, SmartAI, addon auras, event/pool/formation links, live state and live auras
--   .diag go         the nearest object within 20 yd: template, spawn, quest links, loot
--   .diag quest <id> a quest: starters/enders with positions, objectives, prerequisites, conditions, your state and why you can not take it
--   .diag auras [t]  every aura on you (or the target) with id, name, stacks, duration, caster (scans spell ids 1 to 1,500,000)
--   .diag area       zone/area/subzone ids, phase_area rows that apply, ground height, water, weather
--   .diag spell <id> name, whether you know it, aura on you, cooldown, hotfix rows
--   .diag near [yd]  creatures and objects around you with their flags
-- Every line goes to your chat, to the server console and to DiagReport.txt next to worldserver.exe (so you can paste it to me).
-- GM rank 1+. World-state script (player command events arrive there; the player's map is reached through the player).
-- =====================================================================
if not IS_WORLD_STATE then return end   -- GM commands (player event 42) are delivered to the world state


-- Eluna returns some numbers (health, power, money, guids) as 64-bit values that string.format rejects: SF converts them first.
local sfmt = string.format
-- SF: string.format that survives Eluna's 64-bit values and guids above 2^31 (a %d with such a number fails in LuaJIT).
local function SF(f, ...)
    local n = select('#', ...)
    local t = {...}
    for i = 1, n do
        local v = t[i]
        local ty = type(v)
        if ty ~= "number" and ty ~= "string" and ty ~= "boolean" and v ~= nil then
            t[i] = tonumber((string.gsub(tostring(v), "U?LL$", ""))) or tostring(v)
        end
    end
    local idx = 0
    f = string.gsub(f, "%%([%-%d%.]*)([%a%%])", function(flags, conv)
        if conv == "%" then return nil end
        idx = idx + 1
        local v = t[idx]
        if (conv == "d" or conv == "i") and type(v) == "number" and (v > 2147483647 or v < -2147483648 or v ~= math.floor(v)) then
            t[idx] = string.format("%.0f", v)
            return "%" .. flags:gsub("%..*", "") .. "s"
        end
        return nil
    end)
    return sfmt(f, (table.unpack or unpack)(t, 1, n))
end

local FILE = "DiagReport.txt"
local NPCFLAGS = {{1, "gossip"}, {2, "questgiver"}, {16, "trainer"}, {32, "class trainer"}, {64, "profession trainer"}, {128, "vendor"}, {256, "ammo vendor"}, {512, "food vendor"},
    {1024, "poison vendor"}, {2048, "reagent vendor"}, {4096, "repair"}, {8192, "flightmaster"}, {16384, "spirit healer"}, {32768, "spirit guide"}, {65536, "innkeeper"},
    {131072, "banker"}, {262144, "petitioner"}, {524288, "tabard"}, {1048576, "battlemaster"}, {2097152, "auctioneer"}, {4194304, "stable master"}, {8388608, "guild banker"},
    {16777216, "spellclick"}, {33554432, "player vehicle"}, {67108864, "mailbox"}}
local UNITFLAGS = {{2, "NON_ATTACKABLE?"}, {256, "IMMUNE_PC"}, {512, "IMMUNE_NPC"}, {768, "IMMUNE"}, {32768, "NOT_SELECTABLE?"}, {2, "SERVER_CONTROLLED"}, {4, "NON_ATTACKABLE"}, {128, "IMMUNE_TO_PC"},
    {1024, "IMMUNE_TO_NPC"}, {2048, "PET_IN_COMBAT"}, {16384, "PVP"}, {32768, "SILENCED"}, {131072, "PACIFIED"}, {262144, "STUNNED"}, {524288, "IN_COMBAT"}, {33554432, "UNINTERACTIBLE"}, {67108864, "SKINNABLE"}}
local QSTATUS = {[0] = "none", [1] = "complete (turn in)", [3] = "in progress", [5] = "failed", [6] = "rewarded"}
local QOBJ = {[0] = "kill creature", [1] = "collect item", [2] = "use gameobject", [3] = "talk to", [4] = "currency", [5] = "learn spell", [6] = "min rep", [7] = "max rep", [8] = "money",
    [9] = "player kills", [10] = "area trigger", [11] = "defeat battle pet", [12] = "complete scenario", [13] = "complete criteria", [14] = "buy", [15] = "increase rep", [16] = "have currency"}
local SCHOOL_NOTE = "(ids that exist in the 12.1 client)"

local function band(a, b)
    if bit and bit.band then return bit.band(a, b) end
    return (math.floor(a / b) % 2 == 1) and b or 0
end

local function flagnames(v, list)
    local t = {}
    v = tonumber(v) or 0
    for _, f in ipairs(list) do if band(v, f[1]) ~= 0 then t[#t + 1] = f[2] end end
    return #t > 0 and table.concat(t, ", ") or "-"
end

-- output: chat (split in 200-char parts), console, file
local function Out(player, text)
    text = tostring(text)
    PrintInfo("[diag] " .. text)
    pcall(function()
        local f = io.open(FILE, "a")
        if f then f:write(os.date("%H:%M:%S ") .. text .. "\n") f:close() end
    end)
    while #text > 0 do
        player:SendBroadcastMessage(string.sub(text, 1, 200))
        text = string.sub(text, 201)
    end
end

local function Head(player, title)
    Out(player, "|cff00ff96== " .. title .. " ==|r")
end

local function Rows(sql, cols)
    local out = {}
    local ok, q = pcall(WorldDBQuery, sql)
    if not ok or not q then return out end
    repeat
        local r = {}
        for i = 1, cols do r[i] = q:GetString(i - 1) or "" end
        out[#out + 1] = r
        if #out >= 60 then break end
    until not q:NextRow()
    return out
end

local function One(sql, cols)
    return Rows(sql, cols)[1]
end

local function Color(f)
    f = tonumber(f) or 0
    if f == 35 then return "friendly (green)" end
    if f == 14 or f == 16 then return "hostile (red)" end
    if f == 7 or f == 31 or f == 188 or f == 189 then return "neutral (yellow)" end
    return "faction " .. f .. " (colour depends on the faction table)"
end

local function Num(v) return tonumber((string.gsub(tostring(v or 0), "U?LL$", ""))) or 0 end

local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end

local function SpellName(id)
    local ok, q = pcall(WorldDBQuery, "SELECT Name FROM hotfixes.spell_name WHERE ID = " .. tonumber(id))
    if ok and q then return q:GetString(0) end
    return "?"
end

local function EntryName(kind, entry)
    local r
    if kind == "c" then r = One("SELECT name FROM creature_template WHERE entry = " .. tonumber(entry), 1)
    else r = One("SELECT name FROM gameobject_template WHERE entry = " .. tonumber(entry), 1) end
    return r and r[1] or ("#" .. tostring(entry))
end

-- ------------------------------------------------------------------ player
local function DiagMe(player)
    Head(player, "YOU: " .. player:GetName())
    local x, y, z, o = player:GetLocation()
    Out(player, SF("level %d  race %d  class %d  map %d  zone %d  area %d  pos %.1f, %.1f, %.1f  facing %.2f  GM rank %d", player:GetLevel(), player:GetRace(), player:GetClass(),
        player:GetMapId(), player:GetZoneId(), player:GetAreaId(), x, y, z, o, player:GetGMRank()))
    Out(player, SF("health %d/%d  power(0..10) mana %d  essence %d/%d  money %d copper  phasemask %s", player:GetHealth(), player:GetMaxHealth(), player:GetPower(0),
        player:GetPower(10), player:GetMaxPower(10), Num(player:GetCoinage()), tostring(player:GetPhaseMask())))
    local sel = player:GetSelection()
    Out(player, "selection: " .. (sel and (sel:GetName() .. " (" .. tostring(sel:GetEntry()) .. ")") or "none"))
    -- quest log from the database (statuses with objective progress)
    local rows = Rows(SF("SELECT 1 LIMIT 0"), 1)
    local ok, q = pcall(CharDBQuery, SF("SELECT quest, status FROM character_queststatus WHERE guid = %d ORDER BY quest", Num(player:GetGUIDLow())))
    local n = 0
    if ok and q then
        repeat
            n = n + 1
            if n <= 40 then
                local id = q:GetUInt32(0)
                local t = One("SELECT LogTitle FROM quest_template WHERE ID = " .. id, 1)
                Out(player, SF("quest %d '%s': %s", id, t and t[1] or "?", QSTATUS[player:GetQuestStatus(id)] or tostring(player:GetQuestStatus(id))))
            end
        until not q:NextRow()
    end
    Out(player, n .. " quests in the log (saved state)")
    local c = player:GetSelection()
    Out(player, "tip: .diag auras lists every aura; .diag area lists the phases for this place")
end

-- ------------------------------------------------------------------ area / phases
local function DiagArea(player)
    Head(player, "AREA AND PHASES")
    local x, y, z = player:GetLocation()
    local zone, area = player:GetZoneId(), player:GetAreaId()
    Out(player, SF("map %d  zone %d  area %d  pos %.1f, %.1f, %.1f", player:GetMapId(), zone, area, x, y, z))
    local okH, h = pcall(function() return player:GetMap():GetHeight(x, y, player) end)
    Out(player, SF("ground height here: %s  (you are %s the ground)", okH and h and SF("%.1f", h) or "unknown", (okH and h) and (z - h > 3 and SF("%.1f above", z - h) or (z - h < -3 and "below" or "on")) or "?"))
    Out(player, "in water: " .. tostring(player:IsInWater()) .. "   underwater: " .. tostring(player:IsUnderWater()) .. "   flying: " .. tostring(player:IsFlying()) .. "   mounted: " .. tostring(player:IsMounted()))
    -- which phases of this place pass their conditions for YOU (quest-state conditions are evaluated here; other types are listed as "?")
    local function QState(q)
        if player:GetQuestRewardStatus(q) then return 64 end
        local st = player:GetQuestStatus(q)
        if st == 1 then return 2 elseif st == 3 then return 8 elseif st == 5 then return 32 end
        return 1
    end
    local pa = Rows(SF("SELECT a.AreaId, a.PhaseId, COALESCE(n.Name,''), COALESCE(a.Comment,'') FROM phase_area a LEFT JOIN phase_name n ON n.ID = a.PhaseId WHERE a.AreaId IN (%d, %d) ORDER BY a.PhaseId", zone, area), 4)
    Out(player, #pa .. " phase_area rows for zone/area; those that pass for you:")
    local shown, passed = 0, 0
    for _, r in ipairs(pa) do
        local cond = Rows(SF("SELECT ConditionTypeOrReference, ConditionValue1, ConditionValue2, NegativeCondition, ElseGroup FROM conditions WHERE SourceTypeOrReferenceId = 26 AND SourceGroup = %s AND SourceEntry = %s ORDER BY ElseGroup", r[2], r[1]), 5)
        local groups, unknown = {}, false
        for _, c in ipairs(cond) do
            local g = c[5]
            groups[g] = groups[g] == nil and true or groups[g]
            local ok
            local t = tonumber(c[1])
            if t == 47 then ok = band(QState(tonumber(c[2])), tonumber(c[3])) ~= 0
            elseif t == 8 then ok = player:GetQuestRewardStatus(tonumber(c[2]))
            elseif t == 9 then ok = player:GetQuestStatus(tonumber(c[2])) == 3
            else ok = true; unknown = true end
            if c[4] == "1" then ok = not ok end
            groups[g] = groups[g] and ok
        end
        local pass = #cond == 0
        for _, v in pairs(groups) do if v then pass = true end end
        if pass then
            passed = passed + 1
            local desc = {}
            for _, c in ipairs(cond) do desc[#desc + 1] = SF("%s%s(%s/%s)", c[4] == "1" and "NOT " or "", c[1], c[2], c[3]) end
            Out(player, SF("  PHASE %s '%s' %s %s%s", r[2], r[3], #cond == 0 and "(no conditions)" or table.concat(desc, " & "), unknown and " [has conditions I can not evaluate: ?]" or "", ""))
        end
    end
    Out(player, passed .. " of " .. #pa .. " phases pass for you (compare with `.debug phase`)")
end

-- ------------------------------------------------------------------ auras
local function DiagAuras(player, unit)
    unit = unit or player
    Head(player, "AURAS on " .. unit:GetName())
    local n = 0
    for id = 1, 1500000 do
        if unit:HasAura(id) then
            n = n + 1
            if n <= 80 then
                local a = unit:GetAura(id)
                local st, dur, caster = 0, 0, "?"
                pcall(function() st = a:GetStackAmount() end)
                pcall(function() dur = a:GetDuration() end)
                pcall(function() local c = a:GetCaster() if c then caster = c:GetName() end end)
                Out(player, SF("  %d '%s' stacks %s duration %sms caster %s", id, SpellName(id), tostring(st), tostring(dur), caster))
            end
        end
    end
    Out(player, n .. " auras" .. (n > 80 and " (first 80 shown)" or ""))
end

-- ------------------------------------------------------------------ quests
local function WhyNot(player, id)
    local why = {}
    local st = player:GetQuestStatus(id)
    if player:GetQuestRewardStatus(id) then why[#why + 1] = "already rewarded" end
    if st == 3 or st == 1 then why[#why + 1] = "already in your log" end
    local ad = One(SF("SELECT PrevQuestID, ExclusiveGroup, AllowableClasses, NextQuestID FROM quest_template_addon WHERE ID = %d", id), 4)
    if ad then
        local prev = tonumber(ad[1]) or 0
        if prev > 0 and not player:GetQuestRewardStatus(math.abs(prev)) then why[#why + 1] = "needs quest " .. prev .. " rewarded first" end
        if prev < 0 and player:GetQuestStatus(math.abs(prev)) ~= 3 and player:GetQuestStatus(math.abs(prev)) ~= 1 then why[#why + 1] = "needs quest " .. math.abs(prev) .. " active" end
        local cl = tonumber(ad[3]) or 0
        if cl ~= 0 and band(cl, math.floor(2 ^ (player:GetClass() - 1))) == 0 then why[#why + 1] = "class not allowed (mask " .. cl .. ")" end
    end
    local t = One(SF("SELECT AllowableRaces FROM quest_template WHERE ID = %d", id), 1)
    if t then
        local ar = tonumber(t[1]) or 0
        if ar == 0 then why[#why + 1] = "AllowableRaces is 0 = nobody" end
    end
    local cond = Rows(SF("SELECT SourceTypeOrReferenceId, ConditionTypeOrReference, ConditionValue1, ConditionValue2, NegativeCondition FROM conditions WHERE SourceTypeOrReferenceId IN (19, 20) AND SourceEntry = %d", id), 5)
    for _, c in ipairs(cond) do why[#why + 1] = SF("condition(src %s) type %s val %s/%s%s", c[1], c[2], c[3], c[4], c[5] == "1" and " NOT" or "") end
    return #why > 0 and table.concat(why, "; ") or "nothing blocks it (check level/ContentTuning)"
end

local function DiagQuest(player, id)
    Head(player, "QUEST " .. id)
    local t = One(SF("SELECT LogTitle, QuestSortID, ContentTuningID, RewardXPDifficulty, RewardBonusMoney, RewardItem1, RewardAmount1, AllowableRaces, Flags FROM quest_template WHERE ID = %d", id), 9)
    if not t then Out(player, "no quest with that id in quest_template") return end
    Out(player, SF("'%s'  sort %s  tuning %s  xpdiff %s  money %s  reward item %s x%s  races %s  flags %s", t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9]))
    local ad = One(SF("SELECT PrevQuestID, NextQuestID, ExclusiveGroup, AllowableClasses FROM quest_template_addon WHERE ID = %d", id), 4)
    if ad then Out(player, SF("prev %s  next %s  exclusive group %s  class mask %s", ad[1], ad[2], ad[3], ad[4])) end
    local function Givers(kind, tbl, label)
        local g = Rows(SF("SELECT s.id, t.name FROM %s s JOIN creature_template t ON t.entry = s.id WHERE s.quest = %d", tbl, id), 2)
        for _, r in ipairs(g) do
            local sp = Rows(SF("SELECT map, ROUND(position_x), ROUND(position_y), ROUND(position_z), guid FROM creature WHERE id = %s LIMIT 3", r[1]), 5)
            local where = {}
            for _, s in ipairs(sp) do where[#where + 1] = SF("map %s (%s, %s, %s) db:%s", s[1], s[2], s[3], s[4], s[5]) end
            Out(player, SF("%s: %s (%s) %s", label, r[2], r[1], #where > 0 and table.concat(where, " | ") or "NO SPAWN IN THE WORLD"))
        end
        if #g == 0 then Out(player, label .. ": none") end
    end
    Givers("c", "creature_queststarter", "starter NPC")
    Givers("c", "creature_questender", "ender NPC")
    local gs = Rows(SF("SELECT id FROM gameobject_queststarter WHERE quest = %d", id), 1)
    for _, r in ipairs(gs) do Out(player, "starter object: " .. EntryName("g", r[1]) .. " (" .. r[1] .. ")") end
    local ge = Rows(SF("SELECT id FROM gameobject_questender WHERE quest = %d", id), 1)
    for _, r in ipairs(ge) do Out(player, "ender object: " .. EntryName("g", r[1]) .. " (" .. r[1] .. ")") end
    local ob = Rows(SF("SELECT `Order`, Type, ObjectID, Amount, COALESCE(Description,'') FROM quest_objectives WHERE QuestID = %d ORDER BY `Order`", id), 5)
    for _, o in ipairs(ob) do
        local ty = tonumber(o[2]) or -1
        local nm = (ty == 0 or ty == 3) and EntryName("c", o[3]) or (ty == 2 and EntryName("g", o[3]) or "")
        local spawns = (ty == 0) and (tonumber((One("SELECT COUNT(*) FROM creature WHERE id = " .. tonumber(o[3]), 1) or {0})[1]) or 0) or -1
        Out(player, SF("objective %s: %s %s '%s' x%s %s%s", o[1], QOBJ[ty] or ("type " .. o[2]), o[3], nm, o[4], o[5], spawns == 0 and "   <-- NO SPAWNS OF THIS CREATURE" or (spawns > 0 and ("   (" .. spawns .. " spawns)") or "")))
    end
    Out(player, "your state: " .. (QSTATUS[player:GetQuestStatus(id)] or tostring(player:GetQuestStatus(id))) .. ", rewarded: " .. tostring(player:GetQuestRewardStatus(id)))
    Out(player, "why you may not get it: " .. WhyNot(player, id))
end

-- ------------------------------------------------------------------ NPC
local function Target(player, arg)
    if arg and tonumber(arg) then return nil, tonumber(arg) end
    local sel = player:GetSelection()
    if sel and sel.GetEntry and sel.GetNPCFlags then return sel end
    local ok, c = pcall(function() return player:GetNearestCreature(20) end)
    if ok and c then return c end
    return nil
end

local function DiagNpc(player, arg)
    local c, entry = Target(player, arg)
    local guid = 0
    if c then entry = c:GetEntry(); guid = Num(c:GetDBTableGUIDLow()) end
    if not entry then Out(player, "no target: select an NPC, stand near one, or use .diag npc <entry>") return end
    Head(player, "NPC " .. EntryName("c", entry) .. " (" .. entry .. ")")
    local t = One(SF("SELECT t.name, COALESCE(t.subname,''), t.faction, t.npcflag, t.unit_flags, t.Classification, t.type, t.family, t.AIName, t.ScriptName, t.MovementType FROM creature_template t WHERE t.entry = %d", entry), 11)
    if t then
        Out(player, SF("name '%s' <%s>  faction %s  rank %s  type %s  family %s  AI '%s'  script '%s'", t[1], t[2], t[3], t[6], t[7], t[8], t[9], t[10]))
        Out(player, "npcflag " .. t[4] .. " = " .. flagnames(t[4], NPCFLAGS) .. "   unit_flags " .. t[5] .. " = " .. flagnames(t[5], UNITFLAGS))
        local nf = tonumber(t[4]) or 0
        if band(nf, 3) == 0 then Out(player, "  note: the template has no gossip/questgiver flag, so no ! and no menu (spawn.npcflag can override, see below)") end
    else
        Out(player, "no creature_template row!")
    end
    local d = One(SF("SELECT HealthModifier, DamageModifier, ContentTuningID, LevelScalingDeltaMin, LevelScalingDeltaMax, LootID FROM creature_template_difficulty WHERE Entry = %d LIMIT 1", entry), 6)
    if d then Out(player, SF("health x%s  damage x%s  tuning %s (delta %s..%s)  loot %s", d[1], d[2], d[3], d[4], d[5], d[6])) else Out(player, "no creature_template_difficulty row (health/level tuning missing)") end
    local md = Rows(SF("SELECT CreatureDisplayID, DisplayScale FROM creature_template_model WHERE CreatureID = %d", entry), 2)
    local mt = {}
    for _, m in ipairs(md) do mt[#mt + 1] = m[1] .. " x" .. m[2] end
    Out(player, "models: " .. (#mt > 0 and table.concat(mt, ", ") or "NONE (will show as nothing/rabbit)"))
    -- the spawn
    if guid > 0 then
        local s = One(SF("SELECT map, zoneId, areaId, ROUND(position_x,1), ROUND(position_y,1), ROUND(position_z,1), spawntimesecs, wander_distance, MovementType, COALESCE(npcflag,'NULL'), PhaseId, PhaseGroup, phaseUseFlags, spawnDifficulties, COALESCE(ScriptName,''), COALESCE(StringId,'') FROM creature WHERE guid = %d", guid), 16)
        if s then
            Out(player, SF("spawn db:%d  map %s zone %s area %s  (%s, %s, %s)  respawn %ss  wander %s  movement %s", guid, s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9]))
            Out(player, SF("  spawn npcflag override: %s%s  phase id %s group %s useflags %s  difficulties '%s'  script '%s' stringid '%s'", s[10], s[10] == "0" and "   <-- 0 OVERRIDES the template to nothing: no gossip, no quests!" or "", s[11], s[12], s[13], s[14], s[15], s[16]))
        end
        local ad = One(SF("SELECT COALESCE(auras,''), emote, StandState, PathId, mount FROM creature_addon WHERE guid = %d", guid), 5)
        if ad then Out(player, SF("  addon: auras '%s'  emote %s  stand %s  path %s  mount %s", ad[1], ad[2], ad[3], ad[4], ad[5])) end
        local ev = Rows(SF("SELECT eventEntry FROM game_event_creature WHERE guid = %d", guid), 1)
        if #ev > 0 then Out(player, "  in game event " .. ev[1][1]) end
        local pm = One(SF("SELECT poolSpawnId FROM pool_members WHERE type = 0 AND spawnId = %d", guid), 1)
        if pm then Out(player, "  in spawn pool " .. pm[1] .. " (only some of the pool is alive at a time)") end
        local fm = One(SF("SELECT leaderGUID FROM creature_formations WHERE memberGUID = %d", guid), 1)
        if fm then Out(player, "  formation leader db:" .. fm[1]) end
    else
        Out(player, "spawn: " .. (c and "TEMPORARY (summon or /gmt spawn, gone after restart)" or "(no spawn selected, template only)") .. "   total spawns of this entry: " .. ((One("SELECT COUNT(*) FROM creature WHERE id = " .. entry, 1) or {"?"})[1]))
    end
    -- gossip
    local menus = Rows(SF("SELECT MenuID FROM creature_template_gossip WHERE CreatureID = %d", entry), 1)
    if #menus == 0 then Out(player, "gossip: no creature_template_gossip row (Lua may still add a menu: grep RegisterCreatureGossipEvent)") end
    for _, m in ipairs(menus) do
        local txt = Rows(SF("SELECT g.TextID, COALESCE(b.Text,'') FROM gossip_menu g LEFT JOIN npc_text n ON n.ID = g.TextID LEFT JOIN hotfixes.broadcast_text b ON b.ID = n.BroadcastTextID0 WHERE g.MenuID = %s", m[1]), 2)
        Out(player, "gossip menu " .. m[1] .. ":")
        for _, tx in ipairs(txt) do Out(player, "  text " .. tx[1] .. ": " .. (tx[2] ~= "" and string.sub(tx[2], 1, 150) or "(empty / no broadcast text)")) end
        local opts = Rows(SF("SELECT OptionID, OptionNpc, OptionText, ActionMenuID, COALESCE(SpellID,0) FROM gossip_menu_option WHERE MenuID = %s ORDER BY OptionID", m[1]), 5)
        for _, o in ipairs(opts) do
            local cond = tonumber((One(SF("SELECT COUNT(*) FROM conditions WHERE SourceTypeOrReferenceId = 15 AND SourceGroup = %s AND SourceEntry = %s", m[1], o[1]), 1) or {0})[1]) or 0
            Out(player, SF("  option %s npc-type %s '%s' -> menu %s%s%s", o[1], o[2], string.sub(o[3], 1, 60), o[4], o[5] ~= "0" and (" spell " .. o[5]) or "", cond > 0 and ("  (" .. cond .. " conditions)") or ""))
        end
    end
    -- quests
    local qs = Rows(SF("SELECT s.quest, q.LogTitle, 'starts' FROM creature_queststarter s JOIN quest_template q ON q.ID = s.quest WHERE s.id = %d UNION ALL SELECT e.quest, q.LogTitle, 'ends' FROM creature_questender e JOIN quest_template q ON q.ID = e.quest WHERE e.id = %d ORDER BY 1", entry, entry), 3)
    Out(player, #qs .. " quest relations:")
    for _, q in ipairs(qs) do
        local id = tonumber(q[1])
        Out(player, SF("  %s %s '%s': %s%s", q[3], q[1], q[2], QSTATUS[player:GetQuestStatus(id)] or tostring(player:GetQuestStatus(id)), q[3] == "starts" and (" | " .. WhyNot(player, id)) or ""))
    end
    -- vendor / trainer / ai
    local vend = One("SELECT COUNT(*) FROM npc_vendor WHERE entry = " .. entry, 1)
    if vend and vend[1] ~= "0" then Out(player, "vendor items: " .. vend[1]) end
    local tr = Rows(SF("SELECT TrainerID FROM creature_trainer WHERE CreatureID = %d", entry), 1)
    if #tr > 0 then Out(player, "trainer id " .. tr[1][1]) end
    local sm = One(SF("SELECT COUNT(*) FROM smart_scripts WHERE source_type = 0 AND entryorguid = %d", entry), 1)
    if sm and sm[1] ~= "0" then
        Out(player, "SmartAI lines: " .. sm[1])
        local sl = Rows(SF("SELECT id, event_type, action_type, action_param1, action_param2, COALESCE(comment,'') FROM smart_scripts WHERE source_type = 0 AND entryorguid = %d ORDER BY id LIMIT 14", entry), 6)
        for _, l in ipairs(sl) do Out(player, SF("  smart %s: event %s action %s (%s, %s) %s", l[1], l[2], l[3], l[4], l[5], string.sub(l[6], 1, 90))) end
    end
    local ct = Rows(SF("SELECT t.GroupID, t.ID, LEFT(t.Text, 60), t.Type, t.Sound, t.BroadcastTextId, COALESCE(b.SoundKitID1, 0) FROM creature_text t LEFT JOIN hotfixes.broadcast_text b ON b.ID = t.BroadcastTextId WHERE t.CreatureID = %d ORDER BY t.GroupID, t.ID LIMIT 16", entry), 7)
    if #ct > 0 then Out(player, #ct .. " creature_text rows (group.id 'text' type sound broadcast->soundkit):") end
    for _, l in ipairs(ct) do Out(player, SF("  text %s.%s '%s' type %s sound %s broadcast %s -> soundkit %s", l[1], l[2], l[3], l[4], l[5], l[6], l[7])) end
    local ta = One(SF("SELECT COALESCE(auras,''), emote, StandState, mount FROM creature_template_addon WHERE entry = %d", entry), 4)
    if ta then Out(player, SF("template addon: auras '%s' emote %s stand %s mount %s", ta[1], ta[2], ta[3], ta[4])) end
    local sp = Rows(SF("SELECT Spell FROM creature_template_spell WHERE CreatureID = %d ORDER BY `Index`", entry), 1)
    if #sp > 0 then local l = {} for _, r in ipairs(sp) do l[#l + 1] = r[1] end Out(player, "template spells: " .. table.concat(l, ", ")) end
    -- live state
    if c then
        local x, y, z, o = c:GetLocation()
        Out(player, SF("LIVE: alive %s  level %d  health %d/%d (%.0f%%)  in combat %s  faction %d  npcflags(live) %s  scale %.2f  distance %.1f", tostring(c:IsAlive()), c:GetLevel(), c:GetHealth(), c:GetMaxHealth(),
            c:GetHealthPct(), tostring(c:IsInCombat()), c:GetFaction(), tostring(c:GetNPCFlags()), c:GetScale(), player:GetDistance(c)))
        Out(player, SF("LIVE: pos %.1f, %.1f, %.1f  facing %.2f  displayid %s  phasemask %s  victim %s", x, y, z, o, tostring(c:GetDisplayId()), tostring(c:GetPhaseMask()), (c:GetVictim() and c:GetVictim():GetName()) or "none"))
        Out(player, "reaction toward you: " .. Color(c:GetFaction()))
    end
end

-- ------------------------------------------------------------------ gameobject
local function DiagGo(player)
    local ok, g = pcall(function() return player:GetNearestGameObject(20) end)
    if not ok or not g then Out(player, "no object within 20 yards") return end
    local entry = g:GetEntry()
    Head(player, "OBJECT " .. EntryName("g", entry) .. " (" .. entry .. ")")
    local t = One(SF("SELECT type, displayId, name, size, Data0, Data1, Data2, Data3, AIName, ScriptName FROM gameobject_template WHERE entry = %d", entry), 10)
    if t then Out(player, SF("type %s  display %s  size %s  data0-3: %s, %s, %s, %s  AI '%s' script '%s'", t[1], t[2], t[4], t[5], t[6], t[7], t[8], t[9], t[10])) end
    local guid = Num(g:GetDBTableGUIDLow())
    if guid > 0 then
        local s = One(SF("SELECT map, ROUND(position_x,1), ROUND(position_y,1), ROUND(position_z,1), spawntimesecs, state, PhaseId, PhaseGroup, COALESCE(ScriptName,'') FROM gameobject WHERE guid = %d", guid), 9)
        if s then Out(player, SF("spawn db:%d map %s (%s, %s, %s) respawn %ss state %s phase %s group %s script '%s'", guid, s[1], s[2], s[3], s[4], s[5], s[6], s[7], s[8], s[9])) end
    else
        Out(player, "spawn: temporary or not in the database")
    end
    local x, y, z, o = g:GetLocation()
    Out(player, SF("LIVE: pos %.1f, %.1f, %.1f facing %.2f state %s phasemask %s distance %.1f", x, y, z, o, tostring(g:GetGoState()), tostring(g:GetPhaseMask()), player:GetDistance(g)))
    for _, tb in ipairs({{"gameobject_queststarter", "starts"}, {"gameobject_questender", "ends"}}) do
        local qs = Rows(SF("SELECT s.quest, q.LogTitle FROM %s s JOIN quest_template q ON q.ID = s.quest WHERE s.id = %d", tb[1], entry), 2)
        for _, q in ipairs(qs) do Out(player, SF("  %s quest %s '%s': %s", tb[2], q[1], q[2], QSTATUS[player:GetQuestStatus(tonumber(q[1]))] or "?")) end
    end
    local lt = One(SF("SELECT COUNT(*) FROM gameobject_loot_template WHERE Entry = %s", t and t[5] or "0"), 1)
    if lt and lt[1] ~= "0" then Out(player, "loot rows (via data1): " .. lt[1]) end
end

-- ------------------------------------------------------------------ spell
local function DiagSpell(player, id)
    id = tonumber(id)
    if not id then Out(player, "usage: .diag spell <id>") return end
    Head(player, "SPELL " .. id)
    Out(player, "name: " .. SpellName(id))
    Out(player, "you know it: " .. tostring(player:HasSpell(id)) .. "   aura on you: " .. tostring(player:HasAura(id)) .. "   on cooldown: " .. tostring(player:HasSpellCooldown(id)))
    local eff = Rows(SF("SELECT EffectIndex, Effect, EffectAura, EffectBasePoints, EffectTriggerSpell FROM hotfixes.spell_effect WHERE SpellID = %d ORDER BY EffectIndex", id), 5)
    for _, e in ipairs(eff) do Out(player, SF("  hotfix effect %s: type %s aura %s base %s trigger spell %s", e[1], e[2], e[3], e[4], e[5])) end
    if #eff == 0 then Out(player, "  no hotfix effect rows (retail data from the client files, or the spell does not exist)") end
    local cl = One(SF("SELECT COUNT(*) FROM spell_script_names WHERE spell_id = %d", id), 1)
    if cl and cl[1] ~= "0" then Out(player, "  C++ spell scripts attached: " .. cl[1]) end
end

-- ------------------------------------------------------------------ near
local function DiagNear(player, yd)
    yd = math.min(tonumber(yd) or 40, 120)
    Head(player, "NEAR (" .. yd .. " yd)")
    local rows = {}
    pcall(function()
        for _, c in ipairs(player:GetCreaturesInRange(yd) or {}) do
            local g = Num(c:GetDBTableGUIDLow())
            local ph = ""
            if g > 0 then local r = One(SF("SELECT PhaseId, PhaseGroup FROM creature WHERE guid = %d", g), 2) if r then ph = " phase " .. r[1] .. (r[2] ~= "0" and ("/grp " .. r[2]) or "") end end
            rows[#rows + 1] = SF("NPC %s (%d) %.0fyd lvl%d %s%s%s %s%s", c:GetName(), c:GetEntry(), player:GetDistance(c), c:GetLevel(), flagnames(c:GetNPCFlags(), NPCFLAGS) ~= "-" and ("[" .. flagnames(c:GetNPCFlags(), NPCFLAGS) .. "]") or "",
                c:IsAlive() and "" or " DEAD", " " .. Color(c:GetFaction()), g > 0 and ("db:" .. g) or "TEMP", ph)
        end
    end)
    pcall(function()
        for _, g in ipairs(player:GetGameObjectsInRange(yd) or {}) do
            rows[#rows + 1] = SF("OBJ %s (%d) %.0fyd %s", g:GetName(), g:GetEntry(), player:GetDistance(g), Num(g:GetDBTableGUIDLow()) > 0 and ("db:" .. Num(g:GetDBTableGUIDLow())) or "TEMP")
        end
    end)
    table.sort(rows)
    for i = 1, math.min(#rows, 60) do Out(player, rows[i]) end
    Out(player, #rows .. " found" .. (#rows > 60 and " (60 shown)" or ""))
end

-- ------------------------------------------------------------------ dispatcher
local HELP = {".diag all | me | npc [entry] | go | quest <id> | auras [t] | area | spell <id> | near [yd]",
              "Select an NPC first for .diag npc / .diag auras t. Output is also saved to DiagReport.txt next to worldserver.exe."}

RegisterPlayerEvent(42, function(_, player, command)
    local cmd = string.lower(command or "")
    if cmd == "npcs" then
        local okR, rank = pcall(function() return player:GetGMRank() end)
        if okR and (rank or 0) >= 1 then pcall(function() DiagNear(player, 80) end) end
        return false
    end
    local sub, rest = string.match(cmd, "^diag%s*(%S*)%s*(.*)$")
    if not sub then return end
    local okR, rank = pcall(function() return player:GetGMRank() end)
    if not okR or (rank or 0) < 1 then return false end
    local ok, err = pcall(function()
        Out(player, "---- .diag " .. sub .. " " .. rest .. " ----")
        if sub == "" or sub == "help" then for _, h in ipairs(HELP) do Out(player, h) end
        elseif sub == "me" then DiagMe(player)
        elseif sub == "area" then DiagArea(player)
        elseif sub == "npc" then DiagNpc(player, rest ~= "" and rest or nil)
        elseif sub == "go" then DiagGo(player)
        elseif sub == "quest" then DiagQuest(player, tonumber(rest) or 0)
        elseif sub == "auras" then
            local u = player
            if string.sub(rest, 1, 1) == "t" then u = player:GetSelection() or player end
            DiagAuras(player, u)
        elseif sub == "spell" then DiagSpell(player, rest)
        elseif sub == "near" then DiagNear(player, rest ~= "" and rest or nil)
        elseif sub == "all" or sub == "snap" then
            DiagMe(player); DiagArea(player); DiagNpc(player, nil); DiagGo(player); DiagNear(player, 30)
            DiagAuras(player, player)
            local tsel = player:GetSelection()
            if tsel and tsel.GetEntry and tsel ~= player then DiagAuras(player, tsel) end
            -- every quest in your log, in detail (max 6)
            local okq, q = pcall(CharDBQuery, SF("SELECT quest FROM character_queststatus WHERE guid = %d AND status IN (1, 3) ORDER BY quest", Num(player:GetGUIDLow())))
            local n = 0
            if okq and q then repeat n = n + 1 if n <= 6 then DiagQuest(player, q:GetUInt32(0)) end until not q:NextRow() end
            Out(player, "---- end of .diag all: saved to DiagReport.txt (the server file), nothing to copy ----")
        else for _, h in ipairs(HELP) do Out(player, h) end end
    end)
    if not ok then Out(player, "|cffff0000[diag] error: " .. tostring(err) .. "|r") end
    return false
end)
print("[diag_suite] loaded")
