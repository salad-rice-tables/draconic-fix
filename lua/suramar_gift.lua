-- Suramar campaign "An Ancient Gift" (QuestLine 158): retail flow, retail broadcast texts
-- 40324 Arcane Communion: Theryn gossip "Feed: 300x Ancient Mana" (no currency API in Eluna -> no mana cost) -> credit 104618
-- 40325 Scenes from a Memory: Thalyssra starts the communion, the ghostly Memories (107631) around Theryn are dismissed by clicking them
local Q_FEED, Q_SCENE = 40324, 40325
local THALYSSRA, THERYN, MEMORY = 97140, 104618, 107631
local BS = string.char(92)
local TXT_FEED_OPT = "Feed: 300x |TINTERFACE" .. BS .. "ICONS" .. BS .. "INV_MISC_ANCIENT_MANA.BLP:20|t|Hcurrency:1155|h|cFFFFFFFF Ancient Mana|h|r"
local NEED_DISMISS = 12
local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or { dismissed = {}, n = 0 }; return st[k] end

local function say(p, entry, text, d)
    p:RegisterEvent(function(_, _, _, pl)
        local n = pl:GetNearestCreature(120, entry)
        if n then n:SendUnitSay(text, 0) end
    end, d, 1)
end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == Q_FEED or questId == Q_SCENE then st[tostring(player:GetGUIDLow())] = nil end
    if status ~= 3 then return end
    if questId == Q_FEED then
        say(player, THALYSSRA, "That is precisely what I am doing.", 2500)
    elseif questId == Q_SCENE then
        say(player, THALYSSRA, "Let us begin. Come along, Theryn.", 1500)
        say(player, THALYSSRA, "Nar'thala vas manari...", 6000)
        say(player, THALYSSRA, "Dismiss these memories so we can proceed.", 11000)
    end
end)

-- ------------------------------------------------------------ Theryn: feed
RegisterCreatureGossipEvent(THERYN, 1, function(event, player, creature)
    if not player:HasQuest(Q_FEED) or S(player).fed then return false end
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, TXT_FEED_OPT, 0, 1)
    player:GossipSendMenu(9108880, creature)          -- "<Theryn seems entranced.>"
    return true
end)
RegisterCreatureGossipEvent(THERYN, 2, function(event, player, creature, sender, intid)
    print("[suramar] theryn select", sender, intid)
    player:GossipComplete()
    if S(player).fed or not player:HasQuest(Q_FEED) then return end
    S(player).fed = true
    creature:PerformEmote(1)
    player:KilledMonsterCredit(THERYN, 0)
end)

-- ------------------------------------------------------------ Memories: dismiss
RegisterCreatureGossipEvent(MEMORY, 1, function(event, player, creature)
    player:GossipComplete()
    if not player:HasQuest(Q_SCENE) then return true end
    local s, g = S(player), tostring(creature:GetDBTableGUIDLow())
    if s.dismissed[g] then return true end
    s.dismissed[g] = true
    s.n = s.n + 1
    creature:DespawnOrUnsummon(0)
    if s.n == 6 then say(player, THALYSSRA, "I am losing control...", 500) end
    if s.n >= NEED_DISMISS and not s.done then
        s.done = true
        player:KilledMonsterCredit(THALYSSRA, 0)
    end
    return true
end)
