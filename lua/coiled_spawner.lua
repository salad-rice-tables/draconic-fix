-- The Coiled Isle: populates the island with the custom NPCs of the campaign, and runs its ambient life (barks, camp raids).
-- Self-contained. The first player who sets foot on the isle triggers the one-time "bake": the heights come from the map itself
-- (Map:GetHeight), the spawns are written into world.creature (guids 3100400001+) and also appear straight away for this session.
local TAG = "|cff00ff96[Coiled Isle]|r "
local CAMP = {x = 6378.0, y = -12855.0}
local FLAG = "coiled:baked:v1"
local GUID0 = 3100400000

-- {entry, count, centre x, centre y, radius, wander}
local GROUPS = {
  -- the camp (friendly folk)
  {258029, 1, 6384, -12862, 6, 0}, {268110, 1, 6370, -12862, 6, 0}, {272031, 1, 6392, -12852, 6, 0}, {260653, 1, 6366, -12846, 6, 0},
  -- Amani lookout
  {262798, 1, 6090, -12125, 8, 0}, {262880, 1, 6080, -12118, 8, 0}, {270762, 1, 6096, -12130, 8, 0}, {264337, 1, 6076, -12110, 8, 0},
  -- Mlurkkr Mire: spitters, slayers, coilguards
  {258262, 14, 6300, -12800, 90, 8}, {261382, 10, 6250, -12700, 110, 8}, {264231, 6, 6200, -12600, 90, 6}, {261386, 4, 6180, -12500, 70, 6},
  -- Scaleskin temple
  {257033, 2, 6150, -11564, 40, 5}, {263359, 3, 6140, -11580, 50, 5}, {260900, 4, 6160, -11560, 60, 5}, {261390, 1, 6130, -11575, 30, 5},
  -- Vilescar marsh
  {272920, 3, 6446, -12548, 50, 6}, {261386, 6, 6480, -12530, 70, 6}, {261382, 8, 6430, -12520, 80, 8}, {264351, 1, 6500, -12540, 20, 4},
  -- nests and the hollow (kills for chapter 4)
  {256788, 1, 5133, -11268, 20, 4}, {258262, 12, 5200, -11200, 80, 8}, {263688, 12, 5240, -11140, 70, 6}, {262909, 2, 5190, -11160, 40, 6},
  -- the shadow coil (Nek'zali)
  {264392, 5, 5101, -12958, 45, 5}, {261376, 8, 5120, -12900, 70, 6},
  -- the coast
  {258262, 10, 4700, -11700, 80, 8}, {261382, 6, 4800, -11500, 80, 6},
  -- the last stretch
  {261376, 8, 6700, -13000, 90, 6}, {263688, 8, 6880, -13090, 60, 6}, {263688, 6, 7040, -11010, 60, 6},
}

local function Baked()
    local ok, r = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = '" .. FLAG .. "'")
    return ok and r ~= nil
end

local function Bake(player)
    local map = player:GetMap()
    if not map then return end
    pcall(WorldDBExecute, "REPLACE INTO world.lw_state (k, v) VALUES ('" .. FLAG .. "', '1')")   -- first, so a second player can not bake it again
    local n, miss = 0, 0
    math.randomseed(7)
    local rows = {}
    for _, g in ipairs(GROUPS) do
        local entry, cnt, cx, cy, r, wander = g[1], g[2], g[3], g[4], g[5], g[6]
        for i = 1, cnt do
            local ang, rad = math.random() * 6.2832, math.sqrt(math.random()) * r
            local x, y = cx + rad * math.cos(ang), cy + rad * math.sin(ang)
            local z = map:GetHeight(x, y)
            if z and z > -50 and z < 900 then
                local o = math.random() * 6.28
                n = n + 1
                rows[#rows + 1] = string.format("(%d,%d,0,0,0,'0',-1,%.2f,%.2f,%.2f,%.2f,120,%d,%d)",
                    GUID0 + n, entry, x, y, z, o, wander, wander > 0 and 1 or 0)
                pcall(function() player:SpawnCreature(entry, x, y, z, o, 8) end)   -- TEMPSUMMON_MANUAL_DESPAWN: lives until the next restart, then the DB rows take over
            else
                miss = miss + 1
            end
        end
    end
    for i = 1, #rows, 100 do
        pcall(WorldDBExecute, "INSERT INTO world.creature (guid,id,map,zoneId,areaId,spawnDifficulties,terrainSwapMap,position_x,position_y,position_z,orientation,spawntimesecs,wander_distance,MovementType) VALUES " ..
            table.concat(rows, ",", i, math.min(i + 99, #rows)))
    end
    print("[coiled] baked " .. n .. " spawns (" .. miss .. " skipped, no ground) for the Coiled Isle")
    player:SendBroadcastMessage(TAG .. "The isle stirs: " .. n .. " creatures wake.")
end

-- the first foot on the isle: map 0, east of x 4000 and south of y -10000
-- Wowhead gave exact x and y but only a guessed height: the first foot on the isle replaces the heights of those spawns (guids 3003721002 to 3003721400)
-- with the real ground height from the map. The new height is in the database; it applies to the stones that load from then on (next restart).
local ZFLAG = "coiled:zfix:v1"
local function FixHeights(player)
    local ok0, r0 = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = '" .. ZFLAG .. "'")
    if ok0 and r0 then return end
    pcall(WorldDBExecute, "REPLACE INTO world.lw_state (k, v) VALUES ('" .. ZFLAG .. "', '1')")
    local map = player:GetMap()
    local ok, r = pcall(WorldDBQuery, "SELECT guid, position_x, position_y, position_z FROM world.creature WHERE guid BETWEEN 3003721002 AND 3003721400")
    local n = 0
    if ok and r then
        repeat
            local g, x, y, z = r:GetUInt64(0), r:GetFloat(1), r:GetFloat(2), r:GetFloat(3)
            local h = map:GetHeight(x, y)
            if h and h > -50 and h < 900 and math.abs(h - z) > 0.5 then
                pcall(WorldDBExecute, string.format("UPDATE world.creature SET position_z = %.2f WHERE guid = %d", h, g))
                n = n + 1
            end
        until not r:NextRow()
    end
    print("[coiled] height fix: " .. n .. " spawns corrected")
end

local function FirstFoot(_, player)
    if player:GetMapId() ~= 0 then return end
    local x, y = player:GetX(), player:GetY()
    if x < 4000 or x > 8000 or y > -10000 or y < -14000 then return end
    pcall(FixHeights, player)
    if Baked() then return end
    Bake(player)
end
RegisterPlayerEvent(28, FirstFoot)   -- map change
RegisterPlayerEvent(27, FirstFoot)   -- zone change (the portal lands on the same map)

-- ambient life: friendly NPCs bark now and then; Otoola calls a raid on the camp every 25 minutes while someone stands there
local BARKS = {
  [258029] = {"Eyes on the reeds.", "I do not like how quiet it is."},
  [268110] = {"Fresh water is running short.", "Never trust a snake that smiles."},
  [272031] = {"Another day, another scar.", "Keep your blades dry!"},
  [260653] = {"Ula'tek is listening. I can feel it.", "The mist moves wrong tonight."},
  [262798] = {"For the Amani!", "Hold the high ground."},
  [262880] = {"The eagles are restless.", "The wind carries a bad omen."},
  [270762] = {"Easy now, my wings. Easy.", "The eagles smell the curse."},
  [264337] = {"Candles for sale! Best wax on the isle!", "A candle against the dark, friend!"},
}
for entry, lines in pairs(BARKS) do
    pcall(RegisterCreatureEvent, entry, 5, function(_, creature)   -- ON_SPAWN
        creature:RegisterEvent(function(_, _, _, c)
            if c and c:IsInWorld() and c:IsAlive() then
                local p = c:GetNearestPlayer(25)
                if p then pcall(function() c:SendUnitSay(lines[math.random(#lines)], 0) end) end
            end
        end, 45000 + math.random(0, 30000), 0)
    end)
end

local RAIDERS = {261382, 261382, 264231, 261386}
pcall(RegisterCreatureEvent, 253843, 5, function(_, otoola)
    otoola:RegisterEvent(function(_, _, _, c)
        if not c or not c:IsInWorld() then return end
        local p = c:GetNearestPlayer(60)
        if not p then return end
        pcall(function() c:SendUnitYell("Serpents in the reeds! The Vilescar are attacking the camp! To arms!", 0) end)
        local x, y, z = c:GetX(), c:GetY(), c:GetZ()
        for i = 1, 5 do
            local ang = math.random() * 6.28
            local sx, sy = x + 25 * math.cos(ang), y + 25 * math.sin(ang)
            local mob = c:SpawnCreature(RAIDERS[(i % #RAIDERS) + 1], sx, sy, c:GetMap():GetHeight(sx, sy) or z, ang + 3.14, 1, 180000)
            if mob then mob:AttackStart(p) end
        end
    end, 25 * 60000, 0)
end)

-- ghosts of players who died on the isle wake up at the camp, beside its Spirit Healer (the isle has no graveyard in the client data,
-- so the game sends the ghost to the Northern Barrens, which is another map and therefore another Lua state). The place of death is written
-- to the database at death; the state of the map the ghost lands on reads it and sends the ghost back to the camp.
local function OnIsle(p)
    local x, y = p:GetX(), p:GetY()
    return p:GetMapId() == 0 and x >= 4000 and x <= 8000 and y <= -10000 and y >= -14000
end
local function GhostKey(p) return "coiled:ghost:" .. tostring(p:GetGUIDLow()) end
local function Died(_, _, killed)
    pcall(function()
        if OnIsle(killed) then pcall(WorldDBExecute, "REPLACE INTO world.lw_state (k, v) VALUES ('" .. GhostKey(killed) .. "', '1')") end
    end)
end
RegisterPlayerEvent(8, Died)   -- killed by a creature
RegisterPlayerEvent(6, Died)   -- killed by a player
local function GhostHome(_, player)
    pcall(function()
        if not player:HasAura(8326) and not player:IsDead() then return end   -- 8326: ghost
        local key = GhostKey(player)
        local ok, r = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = '" .. key .. "'")
        if not (ok and r) then return end
        pcall(WorldDBExecute, "DELETE FROM world.lw_state WHERE k = '" .. key .. "'")
        player:RegisterEvent(function(_, _, _, p)
            if p and p:IsInWorld() then p:Teleport(0, 6362.0, -12850.0, 35.5, 3.1) end
        end, 800, 1)
    end)
end
RegisterPlayerEvent(28, GhostHome)   -- map change: the ghost lands in the Barrens
RegisterPlayerEvent(27, GhostHome)   -- zone change
RegisterPlayerEvent(36, function(_, player) pcall(WorldDBExecute, "DELETE FROM world.lw_state WHERE k = '" .. GhostKey(player) .. "'") end)   -- resurrected
