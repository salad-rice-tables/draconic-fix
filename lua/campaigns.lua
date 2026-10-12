-- =====================================================================
-- Campaigns: the other continents are not open from level 10. Each campaign (a custom story chain) opens its region once the hero
-- starts it with the Campaign Master (capital cities, 9900138) at the required level. Entering a locked region sends the hero
-- back to the capital. GMs (rank 1+) can go anywhere. characters.hero_campaign holds what is open; the Mystic and quest systems
-- continue to work inside. Custom quests will hang on each campaign later (CAMPAIGN_Unlock(player, key) opens one from Lua).
-- =====================================================================
if IS_WORLD_STATE then return end

local MASTER = 9900138
local TAG = "|cff7fd6ff[Campaign]|r "

local CAMPAIGNS = {
    {key = "outland",   name = "Beyond the Dark Portal",   lvl = 10, maps = {530},
     story = "The Portal burned long ago, yet the red sky above Hellfire never faded. Scouts speak of broken lands, demons still drilling for something older. Take the road to Outland."},
    {key = "northrend", name = "The Frozen Throne Calls",  lvl = 18, maps = {571},
     story = "A cold wind brings whispers from Icecrown. The Scourge is not finished, and a king under ice still dreams of armies. Sail north, Hero."},
    {key = "cataclysm", name = "When the Earth Broke",     lvl = 26, maps = {646, 732},
     story = "Deathwing tore the world open. Down beyond the roots of Azeroth a stone realm shakes, and the elemental lords stir. Dig deep."},
    {key = "pandaria",  name = "Mists of the Wandering Isle", lvl = 34, maps = {870, 1064},
     story = "A turtle the size of a continent drifts out of the mist, and with it a land of hidden valleys, a hundred thousand monks and one old war to be fought again."},
    {key = "draenor",   name = "The Iron Tide",            lvl = 42, maps = {1116},
     story = "A door opens to a younger Draenor, before it was broken. The Iron Horde gathers there. What was lost may yet be saved, and what was won may be undone."},
    {key = "legion",    name = "The Burning Legion",       lvl = 50, maps = {1220, 1669},
     story = "The Legion returns, and this time the fight is on Azeroth's doorstep, on islands that held the Pillars of Creation. Gather the artifacts."},
    {key = "bfa",       name = "War of Thorns",            lvl = 58, maps = {1642, 1643, 1718},
     story = "Tides, trolls and tempests. Kul Tiras and Zandalar call for allies, and a war between the old factions waits for you at the harbours."},
    {key = "shadowlands", name = "Beyond the Veil",        lvl = 66, maps = {2222, 2454},
     story = "The sky above Icecrown tore open. Past it lie realms where the dead are judged, and the Jailer walks. Those who cross may never come back the same."},
    {key = "dragonisles", name = "The Dragon Isles",       lvl = 74, maps = {2444},
     story = "The Dragonflights awaken on islands lost to time. A world of aspects, primalists and ancient vaults, waiting for a hero with wings of their own."},
    {key = "warwithin", name = "The Worldsoul Saga",       lvl = 82, maps = {2552, 2769},
     story = "Beneath the roots of the world a hidden empire, a city of light and a gnome with a very large machine. The last story is the deepest one."},
}
local BY_MAP, BY_KEY = {}, {}
for i, c in ipairs(CAMPAIGNS) do
    BY_KEY[c.key] = c
    for _, m in ipairs(c.maps) do BY_MAP[m] = c end
end

local CREDIT = 9903900              -- dummy creature: one kill credit per 100 campaign points fills the quest objective (8)
local AUTO = {outland = true}       -- campaigns that start by themselves when the level is reached (the others still use the Campaign Master)
local GOAL = 800   -- campaign points to finish one (normal kill 1, elite 6, rare 10, boss 30)
pcall(CharDBExecute, [[CREATE TABLE IF NOT EXISTS characters.hero_campaign_prog (name VARCHAR(40) NOT NULL, campaign VARCHAR(20) NOT NULL,
  points INT UNSIGNED NOT NULL DEFAULT 0, done TINYINT UNSIGNED NOT NULL DEFAULT 0, PRIMARY KEY (name, campaign)) ENGINE=InnoDB]])
pcall(CharDBExecute, [[CREATE TABLE IF NOT EXISTS characters.hero_campaign (name VARCHAR(40) NOT NULL, campaign VARCHAR(20) NOT NULL,
  PRIMARY KEY (name, campaign)) ENGINE=InnoDB]])

for i, c in ipairs(CAMPAIGNS) do c.quest = 9500000 + i end
local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end
local CACHE = {}    -- name -> {key = true}
local function Open(player)
    local n = player:GetName()
    local t = CACHE[n]
    if t then return t end
    t = {}
    local ok, q = pcall(CharDBQuery, "SELECT campaign FROM characters.hero_campaign WHERE name = '" .. Esc(n) .. "'")
    if ok and q then repeat t[q:GetString(0)] = true until not q:NextRow() end
    CACHE[n] = t
    return t
end

local PROG = {}   -- name -> {key = {points, done}}
local function Prog(player)
    local n = player:GetName()
    local t = PROG[n]
    if t then return t end
    t = {}
    local ok, q = pcall(CharDBQuery, "SELECT campaign, points, done FROM characters.hero_campaign_prog WHERE name = '" .. Esc(n) .. "'")
    if ok and q then repeat t[q:GetString(0)] = {points = q:GetUInt32(1), done = q:GetUInt32(2) == 1} until not q:NextRow() end
    PROG[n] = t
    return t
end
local function SaveProg(player, key)
    local p = Prog(player)[key]
    if p then pcall(CharDBExecute, string.format("REPLACE INTO characters.hero_campaign_prog (name, campaign, points, done) VALUES ('%s', '%s', %d, %d)",
        Esc(player:GetName()), key, p.points, p.done and 1 or 0)) end
end
local function Done(player, key) local p = Prog(player)[key]; return p and p.done end
local function Prev(c)
    for i, x in ipairs(CAMPAIGNS) do if x.key == c.key then return CAMPAIGNS[i - 1] end end
end
-- a campaign can be started when the level fits and the previous campaign is finished (the first one is free)
local function CanStart(player, c)   -- every campaign is open to everyone: creatures scale to the player, so any road can be walked at any level
    return true
end

function CAMPAIGN_Unlock(player, key)
    local c = BY_KEY[key]
    if not c then return false end
    local t = Open(player)
    if t[key] then return false end
    t[key] = true
    pcall(CharDBExecute, string.format("REPLACE INTO characters.hero_campaign (name, campaign) VALUES ('%s', '%s')", Esc(player:GetName()), key))
    return true
end
function CAMPAIGN_IsOpen(player, key) return Open(player)[key] == true end

local function Capital(player)
    local ok, team = pcall(function() return player:GetTeam() end)
    if ok and team == 1 then return 1, 1570.0, -4430.0, 16.2, 5.0 end
    return 0, -8860.0, 668.0, 97.9, 2.1
end

local function Start(player, c, auto)
    CAMPAIGN_Unlock(player, c.key)
    Prog(player)[c.key] = Prog(player)[c.key] or {points = 0, done = false}
    SaveProg(player, c.key)
    pcall(function() if player:GetQuestStatus(c.quest) == 0 then player:AddQuest(c.quest) end end)
    player:SendBroadcastMessage(TAG .. "|cff40ff40Campaign " .. (auto and "unlocked" or "begun") .. ": " .. c.name .. "|r. " .. c.story)
    local short = string.sub(c.story, 1, 150)
    pcall(function() player:SendAddonMessage("WCARD", "MREV;C;0;" .. c.name .. ";" .. short, 7, player) end)
    pcall(function() player:PlayDirectSound(888, player) end)
    if MYS_AddRunes then pcall(MYS_AddRunes, player, 2) end
end

local function AutoCheck(player)
    if not player or not player:IsInWorld() then return end
    for _, c in ipairs(CAMPAIGNS) do
        if AUTO[c.key] and not Open(player)[c.key] and CanStart(player, c) then Start(player, c, true)
        elseif Open(player)[c.key] and not Done(player, c.key) then   -- started earlier (Campaign Master): give the quest too
            pcall(function() if player:GetQuestStatus(c.quest) == 0 then player:AddQuest(c.quest) end end)
        end
    end
end

local function Gate(_, player)
    if not player then return end
    AutoCheck(player)
    -- walking into the land of a campaign starts that campaign (no gate: go anywhere, pick any campaign)
    local c = BY_MAP[player:GetMapId()]
    if c and not Open(player)[c.key] and player:GetGMRank() < 1 then
        player:RegisterEvent(function(_, _, _, p)
            if p and p:IsInWorld() and not Open(p)[c.key] then pcall(Start, p, c, true) end
        end, 3000, 1)
    end
end
RegisterPlayerEvent(13, function(_, player) AutoCheck(player) end)   -- level change
RegisterPlayerEvent(28, Gate)    -- enters a map (also at login)

RegisterPlayerEvent(4, function(_, player) CACHE[player:GetName()] = nil; PROG[player:GetName()] = nil end)

-- ---------------------------------------------------------------- Campaign Master
local function Show(_, player, creature)
    player:GossipClearMenu()
    local open = Open(player)
    for i, c in ipairs(CAMPAIGNS) do
        local status
        if Done(player, c.key) then status = "|cff40ff40Completed|r"
        elseif open[c.key] then status = "|cff7fd6ffIn progress " .. math.min(100, math.floor((Prog(player)[c.key] or {points = 0}).points * 100 / GOAL)) .. "%|r"
        else
            local ok, why, p = CanStart(player, c)
            status = ok and "|cffffd200Ready|r" or (why == "level" and ("|cffff7060Level " .. c.lvl .. "|r") or ("|cffff7060Finish " .. p.name .. "|r"))
        end
        player:GossipMenuAddItem(0, c.name .. "  [" .. status .. "]", 0, i)
    end
    player:GossipMenuAddItem(0, "How do Campaigns work?", 0, 100)
    player:GossipSendMenu(1, creature)
end

local function Select(_, player, creature, _, intid)
    player:GossipComplete()
    if intid == 100 then
        player:SendBroadcastMessage(TAG .. "The wide world is closed to heroes until they are ready. Each Campaign is a story that opens one region for you: " ..
            "reach its level, speak to the Campaign Master and begin it. Only then can you travel there. Your journey is chosen in order, but you are free to stay.")
        return
    end
    local c = CAMPAIGNS[intid]
    if not c then return end
    local open = Open(player)
    if Done(player, c.key) then
        player:SendBroadcastMessage(TAG .. c.name .. " is complete. " .. c.story)
    elseif open[c.key] then
        local p = Prog(player)[c.key] or {points = 0}
        player:SendBroadcastMessage(TAG .. c.name .. ": " .. p.points .. " / " .. GOAL .. " campaign points. Hunt in the region (elites and bosses count most).")
    else
        local ok, why, prev = CanStart(player, c)
        if not ok and why == "level" then
            player:SendBroadcastMessage(TAG .. c.name .. " begins at level " .. c.lvl .. ". Come back when you are ready.")
        elseif not ok then
            player:SendBroadcastMessage(TAG .. "Finish |cffffd200" .. prev.name .. "|r first. Campaigns follow one another so no story is left behind.")
        else
            Start(player, c, false)
        end
    end
end

-- campaign points: every kill inside the region of a started campaign
RegisterPlayerEvent(7, function(_, killer, killed)
    if not killer or not killed then return end
    local c = BY_MAP[killer:GetMapId()]
    if not c or not Open(killer)[c.key] then return end
    local pr = Prog(killer)
    local p = pr[c.key]
    if not p then p = {points = 0, done = false}; pr[c.key] = p end
    if p.done then return end
    if killed:GetLevel() + 12 < killer:GetLevel() then return end
    local gain = 1
    local okE, elite = pcall(function() return killed:IsElite() end)
    if okE and elite then gain = 6 end
    local okB, boss = pcall(function() return killed:IsWorldBoss() or killed:IsDungeonBoss() end)
    if okB and boss then gain = 30 end
    local before = p.points
    p.points = p.points + gain
    for _ = 1, math.floor(math.min(p.points, GOAL) / 100) - math.floor(before / 100) do pcall(function() killer:KilledMonsterCredit(CREDIT) end) end
    if math.floor(p.points * 10 / GOAL) > math.floor(before * 10 / GOAL) then
        killer:SendBroadcastMessage(TAG .. c.name .. ": " .. math.min(100, math.floor(p.points * 100 / GOAL)) .. "%")
        SaveProg(killer, c.key)
    end
    if p.points >= GOAL then
        p.done = true
        SaveProg(killer, c.key)
        pcall(function() killer:CompleteQuest(c.quest); killer:RewardQuest(c.quest, 0) end)
        killer:SendBroadcastMessage(TAG .. "|cff40ff40Campaign complete: " .. c.name .. "!|r +5 Mystic Runes.")
        pcall(function() killer:SendAddonMessage("WCARD", "TOAST;Campaign complete!;" .. c.name, 7, killer) end)
        if MYS_AddRunes then pcall(MYS_AddRunes, killer, 5) end
        local nx
        for i, x in ipairs(CAMPAIGNS) do if x.key == c.key then nx = CAMPAIGNS[i + 1] end end
        if nx then killer:SendBroadcastMessage(TAG .. "Next story: |cffffd200" .. nx.name .. "|r (level " .. nx.lvl .. "), speak to a Campaign Master.") end
    end
end)

RegisterCreatureGossipEvent(MASTER, 1, Show)
RegisterCreatureGossipEvent(MASTER, 2, Select)
print("[campaigns] " .. #CAMPAIGNS .. " campaigns")
