-- 86650 Fractured: opening Lor'themar's gossip in Silvermoon gives 'Speak to Lor'themar' credit (SAI hello did not fire on him)
local LOR, QUEST, CREDIT = 235787, 86650, 245704
RegisterCreatureGossipEvent(LOR, 1, function(event, player, creature)
    if player:HasQuest(QUEST) then player:KilledMonsterCredit(CREDIT, 0) end
    return false
end)
