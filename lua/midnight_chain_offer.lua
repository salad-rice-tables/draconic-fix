-- Midnight campaign: quests that retail pushes to the player when the previous one is handed in (no giver NPC in the data).
if IS_WORLD_STATE then return end
local NEXT = { [86745] = 94871, [86650] = 86708, [86898] = 89193, [86530] = 86528 }
RegisterPlayerEvent(54, function(_, player, questId, status)
    if status ~= 6 then return end
    local nq = NEXT[questId]
    if not nq then return end
    pcall(function()
        if player:GetQuestStatus(nq) == 0 and player:CanTakeQuest(nq, false) then player:AddQuest(nq) end
    end)
end)
-- catch up: a character that already handed the previous quest in but never got the next one
RegisterPlayerEvent(3, function(_, player)   -- login
    pcall(function()
        for prev, nq in pairs(NEXT) do
            if player:GetQuestStatus(prev) == 6 and player:GetQuestStatus(nq) == 0 and player:CanTakeQuest(nq, false) then player:AddQuest(nq) end
        end
    end)
end)
-- 91281 "Midnight" is AUTO_ACCEPT in retail: pushed to every level 80+ character that has not started the campaign (turn-in at the Image of Lady Liadrin gives 88719).
local OPENER, OPENER_NEXT = 91281, 88719
local function OfferOpener(player)
    pcall(function()
        if player:GetLevel() < 80 then return end
        if player:GetQuestStatus(OPENER) ~= 0 then return end                       -- already taken or rewarded
        if player:GetQuestStatus(OPENER_NEXT) ~= 0 then return end                  -- campaign already past the opener
        if player:CanTakeQuest(OPENER, false) then player:AddQuest(OPENER) end
    end)
end
RegisterPlayerEvent(3, function(_, player) OfferOpener(player) end)                  -- login
RegisterPlayerEvent(13, function(_, player) OfferOpener(player) end)                 -- level change
-- "Locate the Image of Lady Liadrin": credit when the player speaks to any Image (retail: reaching the Image). Also done by SAI hello, this keeps it working if SAI is skipped.
RegisterCreatureGossipEvent(241677, 1, function(_, player, creature)
    pcall(function()
        if player:GetQuestStatus(OPENER) == 3 then player:KilledMonsterCredit(241677) end
    end)
    return false
end)
-- Light's Summon (item 239151, spell 1227749): the retail effect chain (scene + conversation) is not available, so the item itself takes the player to the Sunwell
-- (spell_target_position 1227749 = map 2858) and gives credit 241691 "use the Light's Summon".
RegisterPlayerEvent(5, function(_, player, spell)   -- ON_SPELL_CAST
    local ok, id = pcall(function() return spell:GetEntry() end)
    if ok and id == 1227749 then
        pcall(function() player:KilledMonsterCredit(241691) end)
        -- let the spell's own effect (scene 335817) play, then move the player like retail does when the scene ends
        player:RegisterEvent(function(_, _, _, p)
            if p and p:IsInWorld() and p:GetMapId() ~= 2858 then pcall(function() p:Teleport(2858, 11115, -4519, 82, 0.9192) end) end
        end, 8000, 1)
    end
end)
print("[midnight_chain_offer] loaded")
