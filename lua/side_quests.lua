-- =====================================================================
-- Side quests from Village Elders (one in every village and camp, entries 9902001+, table world.sq_village).
-- An elder offers tasks written from what really lives around the village: thin out the local hostile creatures, bring down the chieftain
-- of a gang (the mini-bosses 9901001+), scout the next village. Progress is counted by Lua; the reward (experience, gold, Mystic Runes) is paid at
-- the elder. State in characters.hero_sidequest. Up to 5 open tasks per hero, one per elder.
-- =====================================================================
if IS_WORLD_STATE then return end

local TAG = "|cffffd200[Side quest]|r "
local MAX_OPEN = 5

pcall(CharDBExecute, [[CREATE TABLE IF NOT EXISTS characters.hero_sidequest (id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(40) NOT NULL, elder INT UNSIGNED NOT NULL, kind VARCHAR(8) NOT NULL, target INT UNSIGNED NOT NULL DEFAULT 0,
  target_name VARCHAR(80) NOT NULL DEFAULT '', need INT UNSIGNED NOT NULL DEFAULT 1, have INT UNSIGNED NOT NULL DEFAULT 0,
  lvl_sum INT UNSIGNED NOT NULL DEFAULT 0, map INT UNSIGNED NOT NULL DEFAULT 0, x FLOAT NOT NULL DEFAULT 0, y FLOAT NOT NULL DEFAULT 0,
  KEY (name)) ENGINE=InnoDB]])

local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end -- local: Eluna izoluje subory, zdielany global nefunguje

local VILL = {}       -- elder entry -> {map, x, y, z, zone}
local VLIST = {}
do
    local q = WorldDBQuery("SELECT entry, map, x, y, z, zone FROM sq_village")
    if q then repeat
        local v = {entry = q:GetUInt32(0), map = q:GetUInt32(1), x = q:GetFloat(2), y = q:GetFloat(3), z = q:GetFloat(4), zone = q:GetUInt32(5)}
        VILL[v.entry] = v
        VLIST[#VLIST + 1] = v
    until not q:NextRow() end
end

-- ---------------------------------------------------------------- what lives around a village (cached)
local HOSTILE_SKIP = 'Villager|Citizen|Peon|Peasant|Farmer|Laborer|Settler|Guard|Footman|Sentinel|Mountaineer|Militia|Merchant|Trainer|Innkeeper|Elder|Corpse|Dead|Riding|Swift|Captive|Prisoner|Slave|Target|Dummy|Trigger|Invisible|Wanderer|Cow|Sheep|Chicken|Rabbit|Squirrel|Rat$|Toad|Frog|Cat$|Deer'
local function Around(v)
    if v.around then return v.around end
    v.around = {hunt = {}, chief = {}, near = {}}
    local q = WorldDBQuery(string.format(
        "SELECT t.entry, t.name, COUNT(*) FROM creature c JOIN creature_template t ON t.entry = c.id WHERE c.map = %d AND c.position_x BETWEEN %f AND %f AND c.position_y BETWEEN %f AND %f " ..
        "AND t.npcflag = 0 AND t.Classification = 0 AND t.type IN (1, 2, 3, 4, 5, 6, 7, 9) AND t.name NOT REGEXP '%s' AND IFNULL(c.PhaseId, 0) IN (0, 169) GROUP BY t.entry, t.name HAVING COUNT(*) >= 3 ORDER BY COUNT(*) DESC LIMIT 6",
        v.map, v.x - 230, v.x + 230, v.y - 230, v.y + 230, HOSTILE_SKIP))
    if q then repeat v.around.hunt[#v.around.hunt + 1] = {entry = q:GetUInt32(0), name = q:GetString(1)} until not q:NextRow() end
    local c = WorldDBQuery(string.format(
        "SELECT t.entry, t.name FROM creature c JOIN creature_template t ON t.entry = c.id WHERE c.map = %d AND c.id BETWEEN 9901001 AND 9901999 AND c.position_x BETWEEN %f AND %f AND c.position_y BETWEEN %f AND %f LIMIT 3",
        v.map, v.x - 450, v.x + 450, v.y - 450, v.y + 450))
    if c then repeat v.around.chief[#v.around.chief + 1] = {entry = c:GetUInt32(0), name = c:GetString(1)} until not c:NextRow() end
    for _, o in ipairs(VLIST) do
        if o.map == v.map and o.entry ~= v.entry then
            local d = math.sqrt((o.x - v.x) ^ 2 + (o.y - v.y) ^ 2)
            if d > 150 and d < 900 then v.around.near[#v.around.near + 1] = o end
        end
    end
    return v.around
end

-- ---------------------------------------------------------------- open quests per player (cache)
local OPEN = {}
local function Load(player)
    local n = player:GetName()
    if OPEN[n] then return OPEN[n] end
    local list = {}
    local ok, q = pcall(CharDBQuery, "SELECT id, elder, kind, target, target_name, need, have, lvl_sum, map, x, y FROM characters.hero_sidequest WHERE name = '" .. Esc(n) .. "'")
    if ok and q then repeat
        list[#list + 1] = {id = q:GetUInt32(0), elder = q:GetUInt32(1), kind = q:GetString(2), target = q:GetUInt32(3), tname = q:GetString(4), need = q:GetUInt32(5),
            have = q:GetUInt32(6), lsum = q:GetUInt32(7), map = q:GetUInt32(8), x = q:GetFloat(9), y = q:GetFloat(10)}
    until not q:NextRow() end
    OPEN[n] = list
    return list
end
local function Save(player, qst)
    pcall(CharDBExecute, string.format("UPDATE characters.hero_sidequest SET have = %d, lvl_sum = %d WHERE id = %d", qst.have, qst.lsum, qst.id))
end
local function ForElder(player, elder)
    for _, q in ipairs(Load(player)) do if q.elder == elder then return q end end
end
local function Remove(player, qst)
    pcall(CharDBExecute, "DELETE FROM characters.hero_sidequest WHERE id = " .. qst.id)
    local list = Load(player)
    for i, q in ipairs(list) do if q == qst then table.remove(list, i) break end end
end

-- ---------------------------------------------------------------- generating a task with a little lore
local HUNT_TEXT = {
    "The %s have grown bold around %s. They scare the herds and the children alike. Thin them out, %d should do it.",
    "Our people cannot walk the roads near %s while the %s roam. Put %d of them down and you will have our thanks.",
    "I have counted the %s near %s, more every week. Bring me word that %d fewer of them remain.",
}
local CHIEF_TEXT = {
    "%s leads a gang that has been raiding the roads near %s. Cut off the head, and the rest will scatter.",
    "They call him %s. He has taken three wagons and a good man's life. End this, hero.",
}
local EXPLORE_TEXT = {
    "No word has come from %s for days. Walk there and see if they are safe, then return.",
    "Our messenger never came back from %s. Go and see what happened.",
}

local function Offer(player, elder, v)
    local a = Around(v)
    local lvl = player:GetLevel()
    local roll = math.random(100)
    local kind, target, tname, need, text, x, y
    if roll <= 15 and #a.chief > 0 then
        local c = a.chief[math.random(#a.chief)]
        kind, target, tname, need = "chief", c.entry, c.name, 1
        text = string.format(CHIEF_TEXT[math.random(#CHIEF_TEXT)], c.name, GetAreaName and GetAreaName(elder:GetAreaId()) or "the village")
    elseif roll <= 35 and #a.near > 0 then
        local o = a.near[math.random(#a.near)]
        kind, target, tname, need = "explore", o.entry, "the next village", 1
        x, y = o.x, o.y
        text = string.format(EXPLORE_TEXT[math.random(#EXPLORE_TEXT)], "the settlement in that direction")
    elseif #a.hunt > 0 then
        local c = a.hunt[math.random(#a.hunt)]
        kind, target, tname, need = "hunt", c.entry, c.name, 6 + math.random(0, 6)
        local area = GetAreaName and GetAreaName(elder:GetAreaId()) or "the village"
        local i = math.random(#HUNT_TEXT)
        text = (i == 1) and string.format(HUNT_TEXT[1], c.name, area, need) or (i == 2 and string.format(HUNT_TEXT[2], area, c.name, need) or string.format(HUNT_TEXT[3], c.name, area, need))
    else
        return nil
    end
    local sql = string.format("INSERT INTO characters.hero_sidequest (name, elder, kind, target, target_name, need, have, lvl_sum, map, x, y) VALUES ('%s', %d, '%s', %d, '%s', %d, 0, 0, %d, %f, %f)",
        Esc(player:GetName()), elder:GetEntry(), kind, target, Esc(tname), need, v.map, x or 0, y or 0)
    CharDBExecute(sql)
    local r = CharDBQuery("SELECT MAX(id) FROM characters.hero_sidequest WHERE name = '" .. Esc(player:GetName()) .. "'")
    local qst = {id = r and r:GetUInt32(0) or 0, elder = elder:GetEntry(), kind = kind, target = target, tname = tname, need = need, have = 0, lsum = 0, map = v.map, x = x or 0, y = y or 0}
    table.insert(Load(player), qst)
    return qst, text
end

local function Describe(q)
    if q.kind == "hunt" then return "Kill " .. q.need .. " " .. q.tname .. " (" .. q.have .. "/" .. q.need .. ")"
    elseif q.kind == "chief" then return "Defeat " .. q.tname .. " (" .. q.have .. "/1)"
    else return "Scout the next village (" .. q.have .. "/1)" end
end

local function Reward(player, q)
    local avg = q.kind == "hunt" and math.max(1, math.floor(q.lsum / math.max(1, q.have))) or player:GetLevel()
    local xp = math.floor((avg * 4 + 40) * q.need * (q.kind == "chief" and 3 or (q.kind == "explore" and 2 or 1)))
    local gold = math.floor(avg * 40 * math.max(1, q.need))
    if player:GetLevel() >= 90 then xp = 0 end
    if xp > 0 then pcall(function() player:GiveXP(xp) end) end
    player:ModifyMoney(gold)
    local runes = q.kind == "chief" and 3 or 1
    if MYS_AddRunes then pcall(MYS_AddRunes, player, runes) end
    player:SendBroadcastMessage(TAG .. "Complete! +" .. xp .. " XP, " .. math.floor(gold / 100) .. " silver, " .. runes .. " Mystic Rune(s).")
end

-- ---------------------------------------------------------------- gossip
local function Hello(_, player, elder)
    player:GossipClearMenu()
    local v = VILL[elder:GetEntry()]
    local q = ForElder(player, elder:GetEntry())
    if q then
        if q.have >= q.need then
            player:GossipMenuAddItem(0, "|cff40ff40Turn in:|r " .. Describe(q), 0, 1)
        else
            player:GossipMenuAddItem(0, "Task: " .. Describe(q), 0, 2)
            player:GossipMenuAddItem(0, "Give up this task", 0, 3, false, "Give up this task?")
        end
    else
        player:GossipMenuAddItem(0, "Is there anything I can do for you?", 0, 4)
    end
    player:GossipMenuAddItem(0, "Never mind.", 0, 99)
    player:GossipSendMenu(1, elder)
end

local function Select(_, player, elder, _, intid)
    player:GossipComplete()
    local v = VILL[elder:GetEntry()]
    local q = ForElder(player, elder:GetEntry())
    if intid == 1 and q and q.have >= q.need then
        Reward(player, q)
        Remove(player, q)
        pcall(function() elder:SendUnitSay("Well done. The village will not forget this.", 0) end)
    elseif intid == 2 and q then
        player:SendBroadcastMessage(TAG .. Describe(q))
    elseif intid == 3 and q then
        Remove(player, q)
        player:SendBroadcastMessage(TAG .. "Task abandoned.")
    elseif intid == 4 and not q then
        if #Load(player) >= MAX_OPEN then player:SendBroadcastMessage(TAG .. "You are already carrying " .. MAX_OPEN .. " tasks.") return end
        local nq, text = Offer(player, elder, v)
        if nq then
            pcall(function() elder:SendUnitSay(text, 0) end)
            player:SendBroadcastMessage(TAG .. "|cffffffff" .. text .. "|r")
            player:SendBroadcastMessage(TAG .. "New task: " .. Describe(nq))
        else
            pcall(function() elder:SendUnitSay("Nothing right now, friend. Come back later.", 0) end)
        end
    end
end

for entry in pairs(VILL) do
    RegisterCreatureGossipEvent(entry, 1, Hello)
    RegisterCreatureGossipEvent(entry, 2, Select)
end

-- ---------------------------------------------------------------- progress
local function Progress(player, q, killed)
    q.have = q.have + 1
    if killed then q.lsum = q.lsum + killed:GetLevel() end
    Save(player, q)
    if q.have >= q.need then
        player:SendBroadcastMessage(TAG .. "|cff40ff40Task done:|r " .. Describe(q) .. " Return to the elder.")
    else
        player:SendBroadcastMessage(TAG .. Describe(q))
    end
end

RegisterPlayerEvent(7, function(_, killer, killed)
    if not killer or not killed then return end
    local entry = killed:GetEntry()
    for _, q in ipairs(Load(killer)) do
        if q.have < q.need and ((q.kind == "hunt" and q.target == entry) or (q.kind == "chief" and q.target == entry)) then
            Progress(killer, q, killed)
        end
    end
end)

RegisterPlayerEvent(4, function(_, player) OPEN[player:GetName()] = nil end)

-- scouting: standing close to the target village completes the task
MAP_Timer("side_quests.scout", function()
    for _, p in ipairs(MAP_Players() or {}) do
        for _, q in ipairs(Load(p)) do
            if q.kind == "explore" and q.have < q.need and q.map == p:GetMapId() and (p:GetX() - q.x) ^ 2 + (p:GetY() - q.y) ^ 2 < 40 * 40 then
                Progress(p, q, nil)
            end
        end
    end
end, 5000)

local n = 0
for _ in pairs(VILL) do n = n + 1 end
print("[side_quests] " .. n .. " village elders")
