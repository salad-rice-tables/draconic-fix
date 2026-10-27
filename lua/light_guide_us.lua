-- 86648 Light Guide Us: dissuade 8 sin'dorei at Amani Pass via gossip (retail option + per-NPC reply, no soundkits)
local QUEST = 86648
local OPTION = "(Quest) Stop! The Amani are not the real threat here."
local COUNT_CREDIT = 258300
local SLOT_CREDIT = { 258526, 258528, 258529, 258530, 258531, 258532, 258533, 258534 }

-- entry -> { npc_text id shown on hello, reply line }
local NPC = {
    [258585] = { 9108821, "Stop? We are not the ones who need to halt our actions--they are!" },             -- Spellbreaker
    [258561] = { 9108822, "The Amani may not seem like a real threat to you, but given the opportunity, they'll take our lands and kill us all!" }, -- Arch Magister
    [237424] = { 9108823, "How do you not see the enemy that stands before you? They strike, and we deliver retribution!" }, -- Blessed Lightbringer
    [258564] = { 9108823, "Stop? We've only just turned the tides!" },                                       -- Blessed Lightbringer
    [258582] = { 9108824, "And give them the upper hand? Never! Glory to the sin'dorei!" },                  -- Eversong Magister
    [258559] = { 9108825, "Not the real threat? They have been a threat for generations. This will not stand!" }, -- Farstrider
}

local done = {}   -- [playerGuid] = { count = n, spawns = { [spawnGuid] = true } }

local function st(player)
    local k = tostring(player:GetGUIDLow())
    done[k] = done[k] or { count = 0, spawns = {} }
    return done[k]
end

local function eligible(player, creature)
    if not player:HasQuest(QUEST) then return false end
    local s = st(player)
    return s.count < 8 and not s.spawns[tostring(creature:GetDBTableGUIDLow())]
end

local function hello(event, player, creature)
    if not eligible(player, creature) then
        player:GossipComplete()
        return true
    end
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, OPTION, 0, 1)
    player:GossipSendMenu(NPC[creature:GetEntry()][1], creature)
    return true
end

local function select(event, player, creature, sender, intid)
    player:GossipComplete()
    if intid ~= 1 or not eligible(player, creature) then return end
    local s = st(player)
    s.count = s.count + 1
    s.spawns[tostring(creature:GetDBTableGUIDLow())] = true
    creature:SetFacingToObject(player)
    creature:SendUnitSay(NPC[creature:GetEntry()][2], 0)
    player:KilledMonsterCredit(SLOT_CREDIT[s.count], 0)
    player:KilledMonsterCredit(COUNT_CREDIT, 0)
end

for entry in pairs(NPC) do
    RegisterCreatureGossipEvent(entry, 1, hello)
    RegisterCreatureGossipEvent(entry, 2, select)
end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == QUEST then done[tostring(player:GetGUIDLow())] = nil end
end)


