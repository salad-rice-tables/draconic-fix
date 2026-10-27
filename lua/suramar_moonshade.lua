-- 42224 Cloaked in Moonshade: accept lines (Thalyssra speaking through Theryn's communion), retail broadcast texts 112567-112570 + soundkits
local Q = 42224
local THALYSSRA, THERYN = 97140, 104618
local LINES = {
    { THALYSSRA, "Can you hear me? Do not be alarmed.", 67239 },
    { THERYN,    "Ngahh...", 71837 },
    { THALYSSRA, "Arcane communion forms a bond that transcends physical space.", 67240 },
    { THALYSSRA, "I shall do my best to keep Theryn off the line...", 67242 },
}
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= Q or status ~= 3 then return end
    local t = 1000
    for _, l in ipairs(LINES) do
        player:RegisterEvent(function(_, _, _, p)
            local n = p:GetNearestCreature(200, l[1])
            if n then n:SendUnitSay(l[2], 0); n:PlayDistanceSound(l[3]) end
        end, t, 1)
        t = t + math.max(2000, #l[2] * 75) + 2500
    end
end)

-- "Explore Moonshade Sanctum": the SAI areatrigger that was meant to give credit does not exist, so use the area itself (7995)
local AREA_SANCTUM, CREDIT_SANCTUM = 7995, 107446
RegisterPlayerEvent(47, function(event, player, oldArea, newArea)
    if newArea == AREA_SANCTUM and player:HasQuest(Q) then player:KilledMonsterCredit(CREDIT_SANCTUM, 0) end
end)
