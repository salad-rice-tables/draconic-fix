-- =====================================================================
-- Manastorms (Descend): a roguelike run on a storm-torn isle.
-- Talk to a Manastorm Keeper (9900134, capital inns) alone or with your
-- party. 5 floors of waves drawn from creatures all over Azeroth that scale
-- to your level; every floor they grow stronger (Manastorm Empowerment) and
-- you pick one of three boons. Floor 5 ends with a champion. Rewards:
-- Mystic Runes per floor, gold, and on a full clear a Worldforged item and a
-- Mystic Enchant. One rewarded run per character per day.
-- =====================================================================

local ENABLED = true
local TAG = "|cff8a6cff[Manastorm]|r "
local KEEPER = 9900134
local ARENA = {map = 1, x = 16226.2, y = 16257.0, z = 13.2}   -- the isle far off Kalimdor's coast
local FLOORS = 5
local EMPOWER = 1402000
local BOONS = {
    {1402100, "Storm-Touched Might", "+15% damage"}, {1402101, "Arcane Bulwark", "-15% damage taken"},
    {1402102, "Mana Surge", "+12% haste"}, {1402103, "Crackling Precision", "+10% critical strike"},
    {1402104, "Vital Storm", "+20% Stamina"}, {1402105, "Leeching Winds", "6% leech"},
    {1402106, "Swift Gale", "+25% movement speed"}, {1402107, "Healing Torrent", "+20% healing done"},
}
local BOON_MENU = 9900134

local run = nil   -- {id, members = {name = {back, boons}}, floor, alive, level, started, offered}

local function Key(name) return (string.gsub(name or "", "'", "''")) end
local function Ground(obj, x, y, z)
    local ok, h = pcall(function() return obj:GetMap():GetHeight(x, y, obj) end)
    if ok and h then return h end
    return z
end
local function Members()
    local out = {}
    if not run then return out end
    for name in pairs(run.members) do
        local p = FindPlayer(name)
        if p and p:IsInWorld() then out[#out + 1] = p end
    end
    return out
end
function MANASTORM_InRun(player) return run ~= nil and run.members[player:GetName()] ~= nil end

local function DoneToday(player)
    local ok, res = pcall(CharDBQuery, string.format("SELECT day = CURDATE(), best_floor FROM characters.manastorm WHERE name = '%s'", Key(player:GetName())))
    if ok and res then return res:GetUInt32(0) == 1, res:GetUInt32(1) end
    return false, 0
end

local function Record(player, floor)
    pcall(CharDBExecute, string.format(
        "INSERT INTO characters.manastorm (name, day, best_floor, runs) VALUES ('%s', CURDATE(), %d, 1) " ..
        "ON DUPLICATE KEY UPDATE day = CURDATE(), best_floor = GREATEST(best_floor, %d), runs = runs + 1", Key(player:GetName()), floor, floor))
end

-- ---------------------------------------------------------------- end of a run
local function Finish(success)
    if not run then return end
    local reached = success and FLOORS or (run.floor - 1)
    for _, p in ipairs(Members()) do
        local m = run.members[p:GetName()]
        for _, b in ipairs(BOONS) do pcall(function() p:RemoveAura(b[1]) end) end
        if not m.rewarded then
            Record(p, reached)
            if reached > 0 and MYS_AddRunes then MYS_AddRunes(p, reached) end
            local gold = 2000 * math.max(1, p:GetLevel()) * reached
            if gold > 0 then p:ModifyMoney(gold) end
            if success then
                p:SendBroadcastMessage(TAG .. "|cff00ff00The Manastorm is calmed!|r Your spoils:")
                if WORLD_News then WORLD_News(p:GetName() .. " calmed a Manastorm!") end
                if SEASON_AddPoints then SEASON_AddPoints(p, 20) end
                local q = WorldDBQuery("SELECT item FROM worldforge_item WHERE quality >= 3 AND object_name <> '' ORDER BY RAND() LIMIT 1")
                if q then
                    local item = q:GetUInt32(0)
                    if p:AddItem(item, 1) then p:SendBroadcastMessage(TAG .. "Worldforged: " .. (GetItemLink(item) or item)) end
                end
                if MYS_GiveRandomEnchant then MYS_GiveRandomEnchant(p) end
                if BountyProgress then pcall(BountyProgress, p, "boss", 1) end
            else
                p:SendBroadcastMessage(TAG .. "The storm overwhelms you on floor " .. run.floor .. ". You keep what you earned.")
            end
        end
        local back = m.back
        p:RegisterEvent(function(_, _, _, pl)
            if not pl then return end
            if not pl:IsAlive() then pl:ResurrectPlayer(100) end
            pl:Teleport(back[1], back[2], back[3], back[4], back[5])
        end, 8000, 1)
    end
    for _, c in ipairs(run.mobs or {}) do pcall(function() if c:IsInWorld() then c:DespawnOrUnsummon(0) end end) end
    run = nil
end

-- ---------------------------------------------------------------- floors
local function PickEntries(level, elite, n)
    local q = WorldDBQuery(string.format(
        "SELECT entry FROM manastorm_pool WHERE min_level <= %d AND max_level >= %d AND elite = %d ORDER BY RAND() LIMIT %d", level, level, elite, n))
    local out = {}
    if q then repeat out[#out + 1] = q:GetUInt32(0) until not q:NextRow() end
    return out
end

local StartFloor
local function SpawnMob(entry, ref, extra)
    local a = math.random() * 6.28
    local x, y = ARENA.x + math.cos(a) * math.random(18, 28), ARENA.y + math.sin(a) * math.random(18, 28)
    local ok, c = pcall(PerformIngameSpawn, 1, entry, ARENA.map, 0, x, y, Ground(ref, x, y, ARENA.z), a + 3.14, false, 900000)
    if not (ok and c) then return nil end
    c:Data():Set("ms_run", run.id)
    for i = 0, math.min(9, run.floor - 1 + (extra or 0)) do pcall(function() c:AddAura(EMPOWER + i, c) end) end
    pcall(function() c:AttackStart(ref) end)
    run.mobs[#run.mobs + 1] = c
    run.alive = run.alive + 1
    return c
end

local function OfferBoons()
    for _, p in ipairs(Members()) do
        local have = {}
        for _, b in ipairs(BOONS) do if p:HasAura(b[1]) then have[b[1]] = true end end
        local opts = {}
        for _, b in ipairs(BOONS) do if not have[b[1]] then opts[#opts + 1] = b end end
        p:GossipClearMenu()
        for i = 1, 3 do
            if #opts == 0 then break end
            local b = table.remove(opts, math.random(#opts))
            p:GossipMenuAddItem(0, "|cff8a6cff" .. b[2] .. "|r - " .. b[3], 0, b[1])
        end
        p:GossipSendMenu(1, p, BOON_MENU)
    end
end

function StartFloor()
    if not run then return end
    run.floor = run.floor + 1
    run.alive = 0
    local players = Members()
    if #players == 0 then Finish(false) return end
    local ref = players[1]
    local n = 3 + 2 * #players + run.floor
    local normals = PickEntries(run.level, 0, 4)
    local elites = PickEntries(run.level, 1, 2)
    if #normals == 0 then normals = elites end
    if #normals == 0 then Finish(false) return end
    for _ = 1, n do SpawnMob(normals[math.random(#normals)], players[math.random(#players)]) end
    if #elites > 0 then
        SpawnMob(elites[1], ref, run.floor == FLOORS and 3 or 0)
        if run.floor == FLOORS and elites[2] then SpawnMob(elites[2], ref, 2) end
    end
    for _, p in ipairs(players) do
        p:SendNotification("Manastorm - floor " .. run.floor .. " of " .. FLOORS)
        p:SendBroadcastMessage(TAG .. "Floor " .. run.floor .. ": " .. run.alive .. " foes, empowered x" .. run.floor ..
            (run.floor == FLOORS and " - a storm champion leads them!" or "."))
    end
end

local function OnKill(event, killer, victim)
    if not run or not victim or victim:Data():Get("ms_run") ~= run.id then return end
    run.alive = run.alive - 1
    if run.alive > 0 then return end
    if run.floor >= FLOORS then Finish(true) return end
    for _, p in ipairs(Members()) do
        p:SendBroadcastMessage(TAG .. "Floor " .. run.floor .. " cleared! Choose a boon - the next floor starts in 20 seconds.")
        if MYS_AddRunes and math.random() < 0.3 then MYS_AddRunes(p, 1) end
    end
    OfferBoons()
    CreateLuaEvent(function() StartFloor() end, 20000, 1)
end

local function OnDeath(event, killer, killed)
    if not run or not killed or not run.members[killed:GetName()] then return end
    for _, p in ipairs(Members()) do if p:IsAlive() then return end end
    Finish(false)
end

-- ---------------------------------------------------------------- start
-- The keeper can stand on any map; the run itself lives in the arena map's
-- own Lua state (map 1). The keeper queues every member and sends them there.
local function Start(player)
    local members = {player}
    local okG, group = pcall(function() return player:GetGroup() end)
    if okG and group then
        for _, m in ipairs(group:GetMembers() or {}) do
            if m ~= player and m:IsInWorld() and m:IsAlive() and m:GetDistance(player) < 40 then members[#members + 1] = m end
        end
    end
    for i, m in ipairs(members) do
        LW_Queue("ms_join", m:GetName(), string.format("%d:%.2f:%.2f:%.2f:%.2f:%s", m:GetMapId(), m:GetX(), m:GetY(), m:GetZ(), m:GetO(), player:GetName()))
        local a = i * 1.2
        m:Teleport(ARENA.map, ARENA.x + math.cos(a) * 3, ARENA.y + math.sin(a) * 3, ARENA.z + 1, a)
        m:SendBroadcastMessage(TAG .. "The storm tears you away... survive " .. FLOORS .. " floors!")
    end
end

-- arena map state: members arrive, the run starts a few seconds after the first one
LW_QUEUE_HANDLERS["ms_join"] = function(p, arg)
    if STATE_MAP ~= ARENA.map then return false end
    if not p then return false end                              -- still teleporting
    local m, x, y, z, o = string.match(arg, "^(%d+):([%-%d.]+):([%-%d.]+):([%-%d.]+):([%-%d.]+)")
    if run and os.time() - run.started > 20 * 60 then Finish(false) end
    if run and run.floor > 0 then
        p:SendBroadcastMessage(TAG .. "Another party is inside the Manastorm. Try again in a few minutes.")
        p:Teleport(tonumber(m), tonumber(x), tonumber(y), tonumber(z), tonumber(o))
        return true
    end
    if not run then
        run = {id = os.time(), members = {}, floor = 0, alive = 0, level = p:GetLevel(), started = os.time(), mobs = {}}
        CreateLuaEvent(function() StartFloor() end, 6000, 1)
    end
    run.members[p:GetName()] = {back = {tonumber(m), tonumber(x), tonumber(y), tonumber(z), tonumber(o)}}
    if DoneToday(p) then
        run.members[p:GetName()].rewarded = true
        p:SendBroadcastMessage(TAG .. "You already braved a Manastorm today - this run gives no rewards to you.")
    end
    return true
end

local function KeeperShow(player, creature)
    player:GossipClearMenu()
    local done, best = DoneToday(player)
    player:GossipMenuAddItem(0, "Enter the Manastorm" .. ((player:GetGroup() ~= nil) and " with my party" or "") ..
        (done and " (no rewards today)" or ""), 0, 1, false, "Enter the Manastorm? Party members within 40 yards come with you.")
    player:GossipMenuAddItem(0, "What is a Manastorm?", 0, 2)
    if best > 0 then player:GossipMenuAddItem(0, "Your best today: floor " .. best .. " of " .. FLOORS, 0, 3) end
    player:GossipSendMenu(1, creature)
end

local function KeeperSelect(event, player, creature, sender, intid)
    player:GossipComplete()
    if intid == 1 then
        if player:GetLevel() < 10 then player:SendBroadcastMessage(TAG .. "Come back at level 10.") return end
        Start(player)
    elseif intid == 2 then
        player:SendBroadcastMessage(TAG .. "A Manastorm is a wild tear of arcane power. Five floors of foes from all over Azeroth, stronger on every floor. " ..
            "After each floor pick a boon. Clear all five for a Worldforged item, a Mystic Enchant, runes and gold. One rewarded run a day.")
    end
end

if ENABLED then
    RegisterCreatureGossipEvent(KEEPER, 1, function(_, player, creature) KeeperShow(player, creature) end)
    RegisterCreatureGossipEvent(KEEPER, 2, KeeperSelect)
    RegisterPlayerGossipEvent(BOON_MENU, 2, function(_, player, _, sender, intid)
        if run and run.members[player:GetName()] then
            for _, b in ipairs(BOONS) do
                if b[1] == intid then
                    pcall(function() player:AddAura(b[1], player) end)
                    player:SendBroadcastMessage(TAG .. "Boon gained: |cff8a6cff" .. b[2] .. "|r (" .. b[3] .. ").")
                end
            end
        end
        player:GossipComplete()
    end)
    RegisterPlayerEvent(7, OnKill)
    RegisterPlayerEvent(8, OnDeath)
    RegisterPlayerEvent(6, OnDeath)
    -- someone who logged out inside the arena comes back outside of a run: send them home
    RegisterPlayerEvent(28, function(_, player)
        if IS_WORLD_STATE or STATE_MAP ~= ARENA.map then return end
        if player:GetMapId() ~= ARENA.map or player:GetDistance(ARENA.x, ARENA.y, ARENA.z) > 150 then return end
        if run and run.members[player:GetName()] then return end
        player:RegisterEvent(function(_, _, _, pl)
            if not pl or (run and run.members[pl:GetName()]) then return end
            local q = WorldDBQuery(string.format("SELECT 1 FROM lw_queue WHERE kind = 'ms_join' AND name = '%s'", (string.gsub(pl:GetName(), "'", "''"))))
            if q then return end
            if pl:IsHorde() then pl:Teleport(1, 1573.3, -4439.2, 16.1, 1.9) else pl:Teleport(0, -8867.8, 673.7, 98.0, 5.2) end
        end, 5000, 1)
    end)
    print("[manastorm] loaded")
end

function MANASTORM_Status()
    if not run then return "free" end
    local n = 0
    for _ in pairs(run.members) do n = n + 1 end
    return string.format("running: %d player(s), floor %d of %d, %d foes alive, %d min", n, run.floor, FLOORS, run.alive, math.floor((os.time() - run.started) / 60))
end
