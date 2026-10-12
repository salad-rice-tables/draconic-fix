-- Housing tutorial "My First Home" (quest 91863): talking to a steward gives the credits "Greet the steward" (249851) and "Ask the steward to join you" (248857).
-- On retail a SmartAI line on the steward does this; the steward standing in the Wizard's Sanctum (Lyssabel Dawnpetal, entry 256078) has no such script in the database.
-- The gossip window still opens normally (the hook returns false).
if IS_WORLD_STATE then return end
local QUEST = 91863
local STEWARDS = { 256078, 233063, 233708, 249850 }
local function Greet(event, player, creature)
    if player:GetQuestStatus(QUEST) == 3 then      -- QUEST_STATUS_INCOMPLETE
        player:KilledMonsterCredit(249851)
        player:KilledMonsterCredit(248857)
    end
    return false
end
for _, e in ipairs(STEWARDS) do
    if not (HAS_CPP_SCRIPT and HAS_CPP_SCRIPT[e]) then RegisterCreatureGossipEvent(e, 1, Greet) end
end
print("[housing_tutorial] steward greeting credits registered")
