-- =====================================================================
-- Descend extras:
--  * Dungeon Tiers I-V: .tier <0-5> before entering a 5-player dungeon. Every
--    tier empowers the dungeon's creatures (+25% health, +12% damage each)
--    and boss kills pay runes and a chance for that dungeon's Worldforged loot.
--  * Collections: Worldforged items and Mystic Enchants you collect unlock
--    rewards at milestones (runes, gold, mounts, titles). .collection
--  * Sagas: the Bounty Master offers a 3-chapter story across zones of your
--    level (slay, find, hunt a rare). One saga at a time.
-- =====================================================================

local ENABLED = true
local TTAG = "|cffff7d0a[Dungeon Tier]|r "
local CTAG = "|cff00c0ff[Collection]|r "
local STAG = "|cffe6cc80[Saga]|r "
local EMPOWER = 1402000

local function Key(player) return (string.gsub(player:GetName() or "", "'", "''")) end
local function Count(sql)
    local ok, res = pcall(CharDBQuery, sql)
    if ok and res then return res:GetUInt32(0) end
    return 0
end

-- ---------------------------------------------------------------- Dungeon tiers
local wantTier = {}        -- player name -> tier chosen
local instanceTier = {}    -- instance id -> tier (fixed at first entry)
local ROMAN = {"I", "II", "III", "IV", "V"}

local function InParty5(player)
    local ok, m = pcall(function() return player:GetMap() end)
    if not ok or not m then return false end
    local okD, dungeon = pcall(function() return m:IsDungeon() end)
    local okR, raid = pcall(function() return m:IsRaid() end)
    return okD and dungeon and not (okR and raid)
end

local function LeaderOf(player)
    local okG, g = pcall(function() return player:GetGroup() end)
    if okG and g then
        local okL, lg = pcall(function() return g:GetLeaderGUID() end)
        if okL and lg then
            local okM, members = pcall(function() return g:GetMembers() end)   -- Group:GetMembers does not exist in every Lua state (map states)
            if okM and members then
                for _, m in ipairs(members) do if tostring(m:GetGUID()) == tostring(lg) then return m end end
            else
                for _, m in ipairs(MAP_Players()) do if tostring(m:GetGUID()) == tostring(lg) then return m end end
            end
        end
    end
    return player
end

local function TierScan()
    for _, p in ipairs(MAP_Players()) do
        if p:IsInWorld() and InParty5(p) then
            local inst = p:GetInstanceId()
            if instanceTier[inst] == nil then
                local leader = LeaderOf(p):GetName()
                local q = WorldDBQuery(string.format("SELECT v FROM lw_state WHERE k = 'tier:%s'", (string.gsub(leader, "'", "''"))))
                local t = q and tonumber(q:GetString(0)) or 0
                instanceTier[inst] = t
                if t > 0 then p:SendBroadcastMessage(TTAG .. "This dungeon runs at Tier " .. ROMAN[t] .. ".") end
            end
            local t = instanceTier[inst]
            if t > 0 then
                for _, c in ipairs(p:GetCreaturesInRange(90) or {}) do
                    if c:IsAlive() and not c:Data():Get("tier_done") then
                        c:Data():Set("tier_done", true)
                        local okN, flag = pcall(function() return c:GetNPCFlags() end)
                        if not (okN and flag and flag ~= 0) then
                            for i = 0, t - 1 do pcall(function() c:AddAura(EMPOWER + i, c) end) end
                        end
                    end
                end
            end
        end
    end
end

local function TierBossKill(killer, victim)
    if not InParty5(killer) then return end
    local t = instanceTier[killer:GetInstanceId()] or 0
    if t == 0 then return end
    local okB, boss = pcall(function() return victim:IsDungeonBoss() end)
    if not (okB and boss) then return end
    local list = {killer}
    local okG, g = pcall(function() return killer:GetGroup() end)
    if okG and g then
        list = {}
        for _, m in ipairs(g:GetMembers() or {}) do if m:IsInWorld() and m:GetMapId() == killer:GetMapId() then list[#list + 1] = m end end
    end
    for _, p in ipairs(list) do
        p:SendBroadcastMessage(TTAG .. "Tier " .. ROMAN[t] .. " boss defeated!")
        if MYS_AddRunes then MYS_AddRunes(p, t) end
        if math.random() < 0.15 * t and WF_GiveNearbyItem then WF_GiveNearbyItem(p, 800) end
    end
end

-- ---------------------------------------------------------------- Collections
local MILESTONES = {
    wf = {{10, 2}, {25, 3}, {50, 5}, {100, 8, mount = 41252}, {250, 12, title = 1407}},
    me = {{10, 2}, {25, 3}, {50, 5}, {100, 8, mount = 230987}, {200, 12, title = 1408}},
}
local NAMES = {wf = "Worldforged items", me = "Mystic Enchants"}

local function Progress(player)
    local k = Key(player)
    return {
        wf = Count(string.format("SELECT COUNT(*) FROM characters.worldforge_looted WHERE name = '%s'", k)),
        me = Count(string.format("SELECT COUNT(*) FROM characters.mystic_collection WHERE name = '%s'", k)),
    }
end

function COLLECTION_Check(player)
    local pr, k = Progress(player), Key(player)
    for kind, list in pairs(MILESTONES) do
        for _, m in ipairs(list) do
            if pr[kind] >= m[1] then
                local claimed = Count(string.format("SELECT COUNT(*) FROM characters.hero_collection WHERE name = '%s' AND kind = '%s' AND milestone = %d", k, kind, m[1]))
                if claimed == 0 then
                    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.hero_collection (name, kind, milestone) VALUES ('%s', '%s', %d)", k, kind, m[1]))
                    player:SendBroadcastMessage(CTAG .. m[1] .. " " .. NAMES[kind] .. " collected!")
                    if MYS_AddRunes then MYS_AddRunes(player, m[2]) end
                    player:ModifyMoney(10000 * m[1])
                    if m.mount then pcall(function() player:LearnSpell(m.mount) end); player:SendBroadcastMessage(CTAG .. "Reward: a new mount!") end
                    if m.title then pcall(function() player:SetKnownTitle(m.title) end); player:SendBroadcastMessage(CTAG .. "Reward: a new title!") end
                end
            end
        end
    end
end

local function ShowCollection(player)
    local pr = Progress(player)
    local total = {wf = 0, me = 0}
    local ok1, r1 = pcall(WorldDBQuery, "SELECT COUNT(*) FROM worldforge_item WHERE object_name <> ''")
    if ok1 and r1 then total.wf = r1:GetUInt32(0) end
    local ok2, r2 = pcall(WorldDBQuery, "SELECT COUNT(*) FROM mystic_enchant")
    if ok2 and r2 then total.me = r2:GetUInt32(0) end
    for _, kind in ipairs({"wf", "me"}) do
        local nextM
        for _, m in ipairs(MILESTONES[kind]) do if pr[kind] < m[1] then nextM = m[1] break end end
        player:SendBroadcastMessage(CTAG .. NAMES[kind] .. ": " .. pr[kind] .. " / " .. total[kind] .. (nextM and ("  (next reward at " .. nextM .. ")") or "  (all rewards earned)"))
    end
end

-- ---------------------------------------------------------------- Sagas
local SAGAS = {
    {"The Ashen Pact", "Cultists are gathering ash and bone across the land.",
        {"Scatter the cult's servants in %s", "Recover a Worldforged relic in %s", "Hunt the cult's champion, a rare beast or foe, in %s"}},
    {"Whispers of the Storm", "A manastorm stirs. Its echoes twist the creatures of the wild.",
        {"Calm the storm-touched creatures of %s", "Find the lost storm-relic in %s", "Slay the storm-born rare in %s"}},
    {"The Wanderer's Map", "An old explorer's map leads across the world.",
        {"Clear the trail through %s", "Dig up the explorer's cache in %s", "Defeat the guardian of the final page in %s"}},
    {"Blood and Iron", "Raiders gather war chests for a great assault.",
        {"Break the raiders' line in %s", "Seize a war chest in %s", "Slay the warlord's lieutenant in %s"}},
}
local NEED = {40, 1, 1}
local KIND = {"kill", "find", "rare"}

local function ZonesFor(level)
    local out = {}
    for _, z in ipairs(SAGA_ZONES or {}) do
        if level >= z[3] and level <= z[4] and not string.find(z[2], "City", 1, true) then out[#out + 1] = z end
    end
    return out
end

local SCACHE = {}   -- name -> saga row (false = none), refreshed every 2 minutes
local function GetSaga(player)
    local c = SCACHE[player:GetName()]
    if c ~= nil and os.time() - c.t < 120 then return c.s or nil end
    local s = nil
    local ok, res = pcall(CharDBQuery, string.format("SELECT saga, step, have, z1, z2, z3 FROM characters.hero_saga WHERE name = '%s'", Key(player)))
    if ok and res then s = {saga = res:GetUInt32(0), step = res:GetUInt32(1), have = res:GetUInt32(2), zones = {res:GetUInt32(3), res:GetUInt32(4), res:GetUInt32(5)}} end
    SCACHE[player:GetName()] = {s = s or false, t = os.time()}
    return s
end

local function ZoneName(id)
    for _, z in ipairs(SAGA_ZONES or {}) do if z[1] == id then return z[2] end end
    return "the wilds"
end

local function StepText(s)
    local sg = SAGAS[s.saga]
    return string.format(sg[3][s.step], ZoneName(s.zones[s.step])) .. (NEED[s.step] > 1 and (" (" .. s.have .. "/" .. NEED[s.step] .. ")") or "")
end

function SAGA_Offer(player)
    local s = GetSaga(player)
    if s then
        player:SendBroadcastMessage(STAG .. SAGAS[s.saga][1] .. " - chapter " .. s.step .. " of 3: " .. StepText(s) .. ".")
        return
    end
    local zones = ZonesFor(player:GetLevel())
    if #zones < 1 then player:SendBroadcastMessage(STAG .. "No saga fits your level yet.") return end
    local id = math.random(#SAGAS)
    local z = {}
    for i = 1, 3 do z[i] = zones[math.random(#zones)][1] end
    SCACHE[player:GetName()] = nil
    pcall(CharDBExecute, string.format("REPLACE INTO characters.hero_saga (name, saga, step, have, z1, z2, z3) VALUES ('%s', %d, 1, 0, %d, %d, %d)",
        Key(player), id, z[1], z[2], z[3]))
    local s2 = GetSaga(player)
    player:SendBroadcastMessage(STAG .. "|cffe6cc80" .. SAGAS[id][1] .. "|r - " .. SAGAS[id][2])
    player:SendBroadcastMessage(STAG .. "Chapter 1: " .. StepText(s2) .. ".")
end

function SAGA_Progress(player, kind, n)
    local s = GetSaga(player)
    if not s or KIND[s.step] ~= kind or player:GetZoneId() ~= s.zones[s.step] then return end
    s.have = s.have + (n or 1)
    if s.have < NEED[s.step] then
        pcall(CharDBExecute, string.format("UPDATE characters.hero_saga SET have = %d WHERE name = '%s'", s.have, Key(player)))
        return
    end
    if s.step >= 3 then
        pcall(CharDBExecute, string.format("DELETE FROM characters.hero_saga WHERE name = '%s'", Key(player)))
        SCACHE[player:GetName()] = nil
        player:SendBroadcastMessage(STAG .. "|cff00ff00" .. SAGAS[s.saga][1] .. " is complete!|r")
        if SEASON_AddPoints then SEASON_AddPoints(player, 15) end
        player:ModifyMoney(30000 * math.max(1, player:GetLevel()))
        if MYS_AddRunes then MYS_AddRunes(player, 5) end
        if MYS_GiveRandomEnchant then MYS_GiveRandomEnchant(player) end
        if CITY_AddRep then CITY_AddRep(player, CITY_RepOfZone(player, s.zones[3]), 40) end
        return
    end
    s.step, s.have = s.step + 1, 0
    pcall(CharDBExecute, string.format("UPDATE characters.hero_saga SET step = %d, have = 0 WHERE name = '%s'", s.step, Key(player)))
    player:SendBroadcastMessage(STAG .. "Chapter " .. s.step .. " of 3: " .. StepText(s) .. ".")
    if MYS_AddRunes then MYS_AddRunes(player, 1) end
end

-- ---------------------------------------------------------------- hooks
if ENABLED then
    MAP_Timer("dungeon_tiers.Scan", TierScan, 5000)
    RegisterPlayerEvent(7, function(_, killer, victim)
        if not victim then return end
        TierBossKill(killer, victim)
        if victim:GetLevel() >= killer:GetLevel() - 3 then SAGA_Progress(killer, "kill", 1) end
        local okR, rank = pcall(function() return victim:GetRank() end)
        if okR and (rank == 2 or rank == 4) then SAGA_Progress(killer, "rare", 1) end
    end)
    RegisterPlayerEvent(42, function(_, player, command)
        local c = string.lower(command or "")
        local t = string.match(c, "^tier%s*(%d)$")
        if t then
            t = math.min(5, tonumber(t))
            wantTier[player:GetName()] = t
            WorldDBExecute(string.format("REPLACE INTO lw_state (k, v) VALUES ('tier:%s', '%d')", (string.gsub(player:GetName(), "'", "''")), t))
            player:SendBroadcastMessage(TTAG .. (t == 0 and "Dungeon tier off." or ("Next dungeon you (as leader) enter runs at Tier " .. ROMAN[t] ..
                ": creatures +" .. 25 * t .. "% health, +" .. 12 * t .. "% damage; bosses pay " .. t .. " runes and Worldforged loot.")))
            return false
        elseif c == "tier" then
            player:SendBroadcastMessage(TTAG .. "Usage: .tier 0-5 (set before entering a 5-player dungeon).")
            return false
        elseif c == "collection" then ShowCollection(player) return false
        elseif c == "saga" then SAGA_Offer(player) return false
        end
    end)
    RegisterPlayerEvent(3, function(_, player) pcall(COLLECTION_Check, player) end)
    print("[descend extra] dungeon tiers, collections, sagas loaded (" .. #(SAGA_ZONES or {}) .. " saga zones)")
end
