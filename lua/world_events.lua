-- =====================================================================
-- World events + city reputation (living world v3).
--  * Village attacks: raiders from the area (hostile creatures that live
--    around the village) hit a village a player is in. 3 waves; defenders
--    get Mystic Runes, gold and reputation with the region's capital.
--  * Migrations: herds of the local beasts cross the land near players.
--  * Storms: thunder rolls in and elementals of the area break loose.
--  * Caravans: escorting a caravan to its stop pays; raiding one pays the
--    raider and angers its city.
--  * City reputation (characters.city_rep): Stranger, Friend, Honored,
--    Revered, Exalted. NPCs greet you by name, Mystic Enchanter / Hero
--    Trainer prices drop and bounties pay more as you rise. .rep shows it.
-- =====================================================================

-- Navmesh-only movement (custom core method MoveToSafe): never fly or cut
-- through walls when no walkable path exists. Falls back on older cores.
local function SafeMove(c, id, x, y, z)
    local ok, moved = pcall(function() return c:MoveToSafe(id, x, y, z) end)
    if ok then return moved end
    c:MoveTo(id, x, y, z, true)
    return true
end

local ENABLED = true
local TAG = "|cffffa000[World]|r "
local RTAG = "|cff40ff40[Reputation]|r "
local ATTACK_EVERY, MIGRATION_EVERY, STORM_EVERY = 20 * 60, 12 * 60, 25 * 60
local VILLAGE_COOLDOWN = 60 * 60

local HOSTILE = {}   -- hostile FactionTemplate ids (filled below)
local function Friendly(cr)
    local ok, f = pcall(function() return cr:GetFaction() end)
    return ok and not HOSTILE[f]
end

local function Key(player) return (string.gsub(player:GetName() or "", "'", "''")) end
local function Ground(obj, x, y, z)
    local ok, h = pcall(function() return obj:GetMap():GetHeight(x, y, obj) end)
    if ok and h then return h end
    return z
end

-- ---------------------------------------------------------------- cities and reputation
local CITY_NAME = {org = "Orgrimmar", sw = "Stormwind", ["if"] = "Ironforge", tb = "Thunder Bluff", uc = "Undercity",
    darn = "Darnassus", smc = "Silvermoon", exo = "The Exodar", shatt = "Shattrath", dal = "Dalaran", vald = "Valdrakken", dorn = "Dornogal"}
local ZONE_CITY = {
    [1637] = "org", [14] = "org", [17] = "org", [16] = "org", [400] = "org", [331] = "org",
    [1519] = "sw", [12] = "sw", [40] = "sw", [44] = "sw", [10] = "sw", [33] = "sw", [8] = "sw", [4] = "sw",
    [1537] = "if", [1] = "if", [38] = "if", [11] = "if", [3] = "if", [45] = "if", [47] = "if", [51] = "if", [46] = "if",
    [1638] = "tb", [215] = "tb", [405] = "tb", [357] = "tb", [440] = "tb", [406] = "tb",
    [1497] = "uc", [85] = "uc", [130] = "uc", [267] = "uc", [28] = "uc", [139] = "uc",
    [1657] = "darn", [141] = "darn", [148] = "darn", [361] = "darn", [618] = "darn", [493] = "darn", [15] = "darn",
    [3487] = "smc", [3430] = "smc", [3433] = "smc",
    [3557] = "exo", [3524] = "exo", [3525] = "exo",
    [3703] = "shatt", [3519] = "shatt", [3483] = "shatt", [3521] = "shatt", [3518] = "shatt", [3520] = "shatt", [3522] = "shatt", [3523] = "shatt",
    [4395] = "dal", [7502] = "dal", [65] = "dal", [66] = "dal", [67] = "dal", [210] = "dal", [394] = "dal", [495] = "dal", [3537] = "dal", [3711] = "dal",
    [13862] = "vald", [13644] = "vald", [13645] = "vald", [13646] = "vald", [13647] = "vald",
    [14771] = "dorn", [14717] = "dorn", [14795] = "dorn", [14838] = "dorn",
}
local TIERS = {{0, "Stranger"}, {100, "Friend"}, {300, "Honored"}, {600, "Revered"}, {1000, "Exalted"}}

local function CityOfZone(zone, player)
    local c = ZONE_CITY[zone]
    if c then return c end
    if player then return player:IsHorde() and "org" or "sw" end
    return nil
end

local function GetRep(player, city)
    local ok, res = pcall(CharDBQuery, string.format("SELECT rep FROM characters.city_rep WHERE name = '%s' AND city = '%s'", Key(player), city))
    if ok and res then return res:GetInt32(0) end
    return 0
end

local function Tier(rep)
    local idx = 1
    for i, t in ipairs(TIERS) do if rep >= t[1] then idx = i end end
    return idx, TIERS[idx][2]
end

function CITY_AddRep(player, city, n)
    if not city or not CITY_NAME[city] or n == 0 then return end
    local before = GetRep(player, city)
    local after = math.max(-500, math.min(2000, before + n))
    pcall(CharDBExecute, string.format("INSERT INTO characters.city_rep (name, city, rep) VALUES ('%s', '%s', %d) ON DUPLICATE KEY UPDATE rep = %d",
        Key(player), city, after, after))
    local tb, ta = Tier(before), Tier(after)
    if n > 0 then
        player:SendBroadcastMessage(RTAG .. CITY_NAME[city] .. " +" .. n .. (ta > tb and (" - you are now |cff40ff40" .. TIERS[ta][2] .. "|r there!") or ""))
    else
        player:SendBroadcastMessage(RTAG .. CITY_NAME[city] .. " " .. n .. (ta < tb and (" - you dropped to " .. TIERS[ta][2] .. ".") or ""))
    end
end

function CITY_RepOfZone(player, zone) return CityOfZone(zone, player) end

-- price factor for city services (Mystic Enchanter, Hero Trainer) and bounty bonus
function CITY_PriceFactor(player)
    local c = CityOfZone(player:GetZoneId(), player)
    local t = Tier(GetRep(player, c))
    return ({1.0, 0.9, 0.8, 0.7, 0.6})[t] * (ECON_Factor and ECON_Factor(c) or 1.0)
end
function CITY_RewardFactor(player)
    local c = CityOfZone(player:GetZoneId(), player)
    local t = Tier(GetRep(player, c))
    return ({1.0, 1.1, 1.2, 1.35, 1.5})[t]
end

local GREET = {
    [2] = {"Good to see you again, %s.", "Ah, %s! Welcome back.", "%s! The city remembers your help."},
    [3] = {"%s! Honored to see you.", "Make way for %s!", "Word of your deeds travels, %s."},
    [4] = {"%s, our champion! Welcome home.", "Everyone, %s is here!", "The city owes you much, %s."},
    [5] = {"Hail, %s, hero of this city!", "%s! Drinks are on the house tonight!", "Children tell stories about you, %s."},
}
local lastGreet = {}
local function GreetTick()
    for _, p in ipairs(MAP_Players()) do
        if p:IsInWorld() and not p:IsInCombat() then
            local c = ZONE_CITY[p:GetZoneId()]
            local t = c and Tier(GetRep(p, c)) or 1
            local k = p:GetName()
            if t >= 2 and (lastGreet[k] or 0) + 180 < os.time() then
                local list = p:GetCreaturesInRange(18) or {}
                local talkers = {}
                for _, cr in ipairs(list) do
                    local okT, ty = pcall(function() return cr:GetCreatureType() end)
                    if okT and ty == 7 and cr:IsAlive() and not cr:IsInCombat() and Friendly(cr) then talkers[#talkers + 1] = cr end
                end
                if #talkers > 0 then
                    local cr = talkers[math.random(#talkers)]
                    local lines = GREET[t]
                    pcall(function() cr:SetFacingToObject(p) end)
                    cr:SendUnitSay(string.format(lines[math.random(#lines)], p:GetName()), 0)
                    pcall(function() cr:PerformEmote(3) end)
                    lastGreet[k] = os.time()
                end
            end
        end
    end
end

local function ShowRep(player)
    local ok, res = pcall(CharDBQuery, string.format("SELECT city, rep FROM characters.city_rep WHERE name = '%s' ORDER BY rep DESC", Key(player)))
    if not (ok and res) then player:SendBroadcastMessage(RTAG .. "No city knows your name yet. Bounties, defending villages and escorting caravans earn reputation."); return end
    repeat
        local c, r = res:GetString(0), res:GetInt32(1)
        local _, name = Tier(r)
        player:SendBroadcastMessage(RTAG .. (CITY_NAME[c] or c) .. ": " .. name .. " (" .. r .. ")")
    until not res:NextRow()
end

-- ---------------------------------------------------------------- event helpers
do
    local q = WorldDBQuery("SELECT id FROM we_hostile_faction")
    if q then repeat HOSTILE[q:GetUInt32(0)] = true until not q:NextRow() end
end

local function OpenWorldPlayers()
    local out = {}
    for _, p in ipairs(MAP_Players()) do
        if p:IsInWorld() and p:IsAlive() and not p:IsInCombat() and p:GetLevel() >= 5 then
            local okI, inst = pcall(function() return p:GetInstanceId() end)
            local m = p:GetMapId()
            if (not okI or inst == 0) and m ~= 2736 and m ~= 2735 then out[#out + 1] = p end
        end
    end
    return out
end

-- entries of creatures living around (x, y): type 7 humanoid / 1 beast / 4 elemental, hostile, plain
local function LocalEntries(map, x, y, rmin, rmax, ctype, hostile)
    local q = WorldDBQuery(string.format([[
        SELECT c.id, t.faction FROM creature c JOIN creature_template t ON t.entry = c.id
         WHERE c.map = %d AND c.position_x BETWEEN %f AND %f AND c.position_y BETWEEN %f AND %f
           AND t.type = %d AND t.npcflag = 0 AND t.Classification = 0 AND t.ScriptName = '' AND t.name NOT REGEXP 'riding|swift |mount|steed|charger|stallion|palomino|warhorse|reins|armored |brown horse|black wolf|gray kodo|great (white|brown|gray) kodo|familiar|imp$|^imp |voidwalker|felhunter|succubus|felguard|infernal|doomguard|wisp|golem|elemental|skeleton|zombie|ghoul|abomination|spirit|ghost|treant|totem|spider|wolf|boar|bear|^cat$|bat$|rat$|dog|horse|kodo|raptor|hawk|snake|worg|hound|guardian|critter|bunny|scorpid|crab' AND IFNULL(c.PhaseId,0) = 0
           AND POW(c.position_x - %f, 2) + POW(c.position_y - %f, 2) > %f
         GROUP BY c.id, t.faction LIMIT 40]], map, x - rmax, x + rmax, y - rmax, y + rmax, ctype, x, y, rmin * rmin))
    local out = {}
    if q then repeat
        local e, f = q:GetUInt32(0), q:GetUInt32(1)
        if (not hostile) or HOSTILE[f] then out[#out + 1] = e end
    until not q:NextRow() end
    return out
end

local function Spawn(entry, ref, x, y, ms)
    local z = Ground(ref, x, y, ref:GetZ())
    local ok, c = pcall(PerformIngameSpawn, 1, entry, ref:GetMapId(), 0, x, y, z, math.random() * 6.28, false, ms)
    if ok and c then return c end
    return nil
end

local function Reward(player, runes, rep, city, why)
    local gold = math.floor(2000 * math.max(1, player:GetLevel()) * (CITY_RewardFactor and CITY_RewardFactor(player) or 1))
    player:ModifyMoney(gold)
    player:SendBroadcastMessage(TAG .. why .. " " .. math.floor(gold / 10000) .. "g " .. math.floor(gold % 10000 / 100) .. "s.")
    if runes > 0 and MYS_AddRunes then MYS_AddRunes(player, runes) end
    if rep ~= 0 then CITY_AddRep(player, city, rep) end
end

-- ---------------------------------------------------------------- village attacks
local VILLAGES = {}   -- {area, map, x, y, z}
do
    local q = WorldDBQuery([[
        SELECT c.areaId, c.map, c.position_x, c.position_y, c.position_z, c.zoneId FROM creature c JOIN creature_template t ON t.entry = c.id
         WHERE (t.subname = 'Innkeeper' OR t.npcflag & 65536) AND c.areaId <> 0 AND IFNULL(c.PhaseId,0) IN (0, 169)
           AND c.zoneId NOT IN (1637,1519,1537,1638,1497,1657,3487,3557,3703,4395,7502,13862,14771)
         GROUP BY c.areaId]])
    if q then repeat
        VILLAGES[#VILLAGES + 1] = {area = q:GetUInt32(0), map = q:GetUInt32(1), x = q:GetFloat(2), y = q:GetFloat(3), z = q:GetFloat(4), zone = q:GetUInt32(5)}
    until not q:NextRow() end
end
local attacked = {}     -- area -> last attack time
local raid = nil        -- current attack {village, wave, alive, defenders, entries, started}

local function NearVillage(p)
    for _, v in ipairs(VILLAGES) do
        if v.map == p:GetMapId() and (v.x - p:GetX()) ^ 2 + (v.y - p:GetY()) ^ 2 < 120 * 120 then return v end
    end
end

local function RaidWave()
    if not raid then return end
    local v, ref = raid.village, raid.ref
    if not ref or not ref:IsInWorld() then raid = nil return end
    raid.wave = raid.wave + 1
    local n = 4 + 2 * math.min(4, #(ref:GetPlayersInRange(150) or {}))
    for i = 1, n do
        local a = math.random() * 6.28
        local x, y = v.x + math.cos(a) * math.random(35, 50), v.y + math.sin(a) * math.random(35, 50)
        local c = Spawn(raid.entries[math.random(#raid.entries)], ref, x, y, 300000)
        if c then
            c:Data():Set("we_raid", raid.id)
            raid.alive = raid.alive + 1
            pcall(function() SafeMove(c, 0, v.x + math.random(-6, 6), v.y + math.random(-6, 6), v.z) end)
        end
    end
    for _, p in ipairs(ref:GetPlayersInRange(200) or {}) do
        p:SendBroadcastMessage(TAG .. "|cffff4040Wave " .. raid.wave .. " of 3|r is attacking!")
    end
end

local function StartRaid(p, v)
    local entries = LocalEntries(v.map, v.x, v.y, 150, 1200, 7, true)
    if #entries == 0 then entries = LocalEntries(v.map, v.x, v.y, 150, 1200, 1, true) end
    if #entries == 0 then return false end
    attacked[v.area] = os.time()
    raid = {id = os.time(), village = v, wave = 0, alive = 0, defenders = {}, entries = entries, ref = p, started = os.time()}
    local okN, name = pcall(function() return GetAreaName and GetAreaName(v.area) end)
    local where = (okN and name) or "the village"
    for _, cr in ipairs(p:GetCreaturesInRange(80) or {}) do
        local okT, ty = pcall(function() return cr:GetCreatureType() end)
        if okT and ty == 7 and Friendly(cr) then cr:SendUnitYell("To arms! Raiders are attacking " .. where .. "!", 0) break end
    end
    for _, pl in ipairs(p:GetPlayersInRange(250) or {}) do
        pl:SendNotification("Raiders are attacking " .. where .. "!")
        pl:SendBroadcastMessage(TAG .. "Raiders are attacking " .. where .. "! Defend it - three waves are coming.")
    end
    RaidWave()
    return true
end

-- three defended raids in a zone summon the raiders' warlord
local defended = {}
local warlord = nil
function EventBoss(ref, v, entries)
    if warlord or not ref or not ref:IsInWorld() then return end
    local elite = {}
    local q = WorldDBQuery(string.format("SELECT entry FROM manastorm_pool WHERE elite = 1 AND min_level <= %d AND max_level >= %d ORDER BY RAND() LIMIT 1",
        ref:GetLevel(), ref:GetLevel()))
    local e = (q and q:GetUInt32(0)) or entries[1]
    local a = math.random() * 6.28
    local c = Spawn(e, ref, v.x + math.cos(a) * 45, v.y + math.sin(a) * 45, 1800000)
    if not c then return end
    for i = 0, 5 do pcall(function() c:AddAura(1402000 + i, c) end) end
    c:Data():Set("we_warlord", 1)
    warlord = c
    pcall(function() c:SendUnitYell("You broke my raiders three times. Now face me!", 0) end)
    pcall(function() SafeMove(c, 0, v.x, v.y, v.z) end)
    for _, p in ipairs(MAP_Players()) do
        if p:GetZoneId() == v.zone then
            p:SendNotification("A raider warlord marches on the village!")
            p:SendBroadcastMessage(TAG .. "|cffff4040A raider warlord marches on the village!|r Defeat " .. c:GetName() .. " for great rewards.")
        end
    end
end

local function WarlordKill(killer, victim)
    if not victim:Data():Get("we_warlord") then return end
    warlord = nil
    if WORLD_News then WORLD_News(killer:GetName() .. " and allies slew the raider warlord " .. victim:GetName() .. "!") end
    if LW_Celebrate then pcall(LW_Celebrate, killer) end
    for _, p in ipairs(killer:GetPlayersInRange(150) or {}) do
        p:SendBroadcastMessage(TAG .. "|cff00ff00The warlord has fallen!|r")
        if WF_GiveNearbyItem then WF_GiveNearbyItem(p, 3000) end
        if MYS_GiveRandomEnchant then MYS_GiveRandomEnchant(p) end
        Reward(p, 4, 50, CityOfZone(p:GetZoneId(), p), "The region rewards its heroes:")
        if SEASON_AddPoints then SEASON_AddPoints(p, 25) end
    end
end

local function RaidKill(killer, victim)
    if not raid or victim:Data():Get("we_raid") ~= raid.id then return end
    raid.alive = raid.alive - 1
    raid.defenders[killer:GetName()] = true
    if raid.alive <= 0 then
        if raid.wave < 3 then
            CreateLuaEvent(RaidWave, 8000, 1)
        else
            local v = raid.village
            local city = CityOfZone(v.zone, killer)
            for _, p in ipairs(killer:GetPlayersInRange(200) or {}) do
                if raid.defenders[p:GetName()] then
                    Reward(p, (SEASON_Is and SEASON_Is("raiders")) and 4 or 2, 25, city, "The village is saved! The villagers reward you:")
                    if SEASON_AddPoints then SEASON_AddPoints(p, 10) end
                    if GV_OnDefended then pcall(GV_OnDefended, p, v) end
                end
            end
            local entries = raid.entries
            raid = nil
            if LW_Celebrate then pcall(LW_Celebrate, killer) end
            if WORLD_News then
                local okN, nm = pcall(function() return GetAreaName(v.area) end)
                WORLD_News("Heroes drove the raiders from " .. ((okN and nm) or "a village") .. "!")
            end
            defended[v.zone] = (defended[v.zone] or 0) + 1
            if defended[v.zone] >= 3 then
                defended[v.zone] = 0
                CreateLuaEvent(function() EventBoss(killer, v, entries) end, 30000, 1)
            end
        end
    end
end

-- ---------------------------------------------------------------- migrations
local function Migration(p)
    local beasts = LocalEntries(p:GetMapId(), p:GetX(), p:GetY(), 0, 600, 1, false)
    if #beasts == 0 then return false end
    local e = beasts[math.random(#beasts)]
    local a = math.random() * 6.28
    local sx, sy = p:GetX() + math.cos(a) * 70, p:GetY() + math.sin(a) * 70
    local tx, ty = p:GetX() - math.cos(a) * 90, p:GetY() - math.sin(a) * 90
    local n = math.random(6, 10)
    local name
    for i = 1, n do
        local c = Spawn(e, p, sx + math.random(-10, 10), sy + math.random(-10, 10), 75000)
        if c then
            name = name or c:GetName()
            pcall(function() c:SetReactState(0) end)   -- passive while migrating
            SafeMove(c, i, tx + math.random(-12, 12), ty + math.random(-12, 12), Ground(p, tx, ty, p:GetZ()))
        end
    end
    if name then p:SendBroadcastMessage(TAG .. "A herd of " .. name .. " migrates across the land.") end
    return name ~= nil
end

-- ---------------------------------------------------------------- storms
local function Storm(p)
    local ele = LocalEntries(p:GetMapId(), p:GetX(), p:GetY(), 0, 2500, 4, true)
    if #ele == 0 then return false end
    pcall(function() p:GetMap():SetWeather(p:GetZoneId(), 86, 1.0) end)   -- thunderstorm
    local e = ele[math.random(#ele)]
    for i = 1, math.random(3, 5) do
        local a = math.random() * 6.28
        local c = Spawn(e, p, p:GetX() + math.cos(a) * math.random(25, 40), p:GetY() + math.sin(a) * math.random(25, 40), 240000)
        if c then c:Data():Set("we_storm", 1) end
    end
    p:SendNotification("A storm breaks loose!")
    p:SendBroadcastMessage(TAG .. "Thunder rolls over the land - elementals ride the storm! Each one slain may leave a Mystic Rune.")
    local mapRef, zone = p:GetMap(), p:GetZoneId()
    CreateLuaEvent(function() pcall(function() mapRef:SetWeather(zone, 0, 0) end) end, 240000, 1)
    return true
end

-- ---------------------------------------------------------------- caravans
local escortPaid = {}
function WE_CaravanArrived(master, stop)
    local city = "org"
    for _, p in ipairs(master:GetPlayersInRange(40) or {}) do
        local k = p:GetName() .. ":" .. stop
        if (escortPaid[k] or 0) + 600 < os.time() and p:IsHorde() then
            escortPaid[k] = os.time()
            Reward(p, 0, 5, city, "Caravan escorted safely to " .. stop .. ". The caravan master pays you:")
            if ECON_Change then ECON_Change(city, 1) end
        end
    end
end

local CARAVAN_ENTRIES = {9900110, 9900111}
local function CaravanRaided(event, creature, killer)
    if not killer or not killer.SendBroadcastMessage then return end
    local okP, isP = pcall(function() return killer:GetLevel() ~= nil and killer.ModifyMoney ~= nil end)
    if not (okP and isP) then return end
    Reward(killer, 2, 0, nil, "You raided an enemy caravan! Loot:")
    CITY_AddRep(killer, "org", -50)
    if ECON_Change then ECON_Change("org", -2) end
    CITY_AddRep(killer, killer:IsHorde() and "org" or "sw", 10)
end

-- ---------------------------------------------------------------- scheduler
local lastAttack, lastMigration, lastStorm = os.time(), os.time(), os.time()
local function Director()
    local now = os.time()
    local players = OpenWorldPlayers()
    if #players == 0 then return end
    local season = SEASON_Current and SEASON_Current().key or ""
    local attackEvery = (season == "raiders") and ATTACK_EVERY / 2 or ATTACK_EVERY
    local stormEvery = (season == "storms") and STORM_EVERY / 2 or STORM_EVERY
    if not raid and now - lastAttack >= attackEvery then
        for _, p in ipairs(players) do
            local v = NearVillage(p)
            if v and (attacked[v.area] or 0) + VILLAGE_COOLDOWN < now and StartRaid(p, v) then lastAttack = now break end
        end
    end
    if raid and now - raid.started > 600 then raid = nil end   -- raiders gave up
    if now - lastMigration >= MIGRATION_EVERY then
        local p = players[math.random(#players)]
        if not NearVillage(p) and Migration(p) then lastMigration = now end
    end
    if now - lastStorm >= stormEvery then
        local p = players[math.random(#players)]
        if not NearVillage(p) and Storm(p) then lastStorm = now end
    end
end

if ENABLED then
    MAP_Timer("world_events.Director", Director, 60000)
    MAP_Timer("world_events.Greet", GreetTick, 20000)
    -- GM panel commands arrive from the world state through the queue
    LW_QUEUE_HANDLERS["gm"] = function(p, arg)
        if not p then return false end
        p:SendBroadcastMessage("|cff00ff00[GM]|r " .. (WE_GM(p, arg) or "Unknown option."))
        return true
    end
    RegisterPlayerEvent(7, function(_, killer, victim)       -- ON_KILL_CREATURE
        if not victim then return end
        RaidKill(killer, victim)
        WarlordKill(killer, victim)
        if victim:Data():Get("we_storm") and (math.random() < 0.3 or (SEASON_Is and SEASON_Is("storms"))) and MYS_AddRunes then MYS_AddRunes(killer, 1) end
        local okR, rank = pcall(function() return victim:GetRank() end)
        if okR and (rank == 2 or rank == 4) then CITY_AddRep(killer, CityOfZone(killer:GetZoneId(), nil), 2) end
        local okW, wb = pcall(function() return victim:IsWorldBoss() end)
        if okW and wb then CITY_AddRep(killer, CityOfZone(killer:GetZoneId(), killer), 20) end
    end)
    RegisterPlayerEvent(42, function(_, player, command)    -- ON_COMMAND
        if string.lower(command or "") == "rep" then ShowRep(player) return false end
    end)
    for _, e in ipairs(CARAVAN_ENTRIES) do RegisterCreatureEvent(e, 4, CaravanRaided) end
    print("[world events] " .. #VILLAGES .. " villages, raids every " .. ATTACK_EVERY / 60 .. " min, migrations, storms, city reputation")
end

-- ---------------------------------------------------------------- GM panel hooks (gm_panel.lua)
function WE_GM(player, what)
    if what == "status" then
        return string.format("raid: %s, warlord: %s, villages: %d, next raid in %d min, storm in %d min",
            raid and ("floor/wave " .. raid.wave) or "none", warlord and "active" or "none", #VILLAGES,
            math.max(0, math.floor((ATTACK_EVERY - (os.time() - lastAttack)) / 60)), math.max(0, math.floor((STORM_EVERY - (os.time() - lastStorm)) / 60)))
    elseif what == "raid" then
        local v = NearVillage(player)
        if not v then return "Stand in a village (within 120 yd of its inn)." end
        if raid then return "A raid is already running." end
        attacked[v.area] = 0
        return StartRaid(player, v) and "Raid started." or "No raiders found around this village."
    elseif what == "storm" then return Storm(player) and "Storm started." or "No elementals live around here."
    elseif what == "migration" then return Migration(player) and "Herd spawned." or "No beasts live around here."
    elseif what == "warlord" then
        local v = NearVillage(player)
        if not v then return "Stand in a village." end
        EventBoss(player, v, {})
        return "Warlord summoned."
    end
end

function WE_VillageAt(player)
    local v = NearVillage(player)
    if not v then return nil end
    local okN, name = pcall(function() return GetAreaName(v.area) end)
    return v, (okN and name) or ("area " .. v.area)
end
