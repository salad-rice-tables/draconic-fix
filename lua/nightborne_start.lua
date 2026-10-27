-- Nightborne (race 27) start in the Suramar campaign at the level the Legion Suramar quests require on retail
-- (ContentTuning 335: level 45), already unlocked. playercreateinfo puts race 27 at (288,3352) ~1900 yd from Thalyssra, so the first login also
-- places the character next to First Arcanist Thalyssra in Shal'Aran (she offers 40324 directly).
local NIGHTBORNE, START_LEVEL = 27, 45
RegisterPlayerEvent(30, function(event, player)          -- first login
    if player:GetRace() ~= NIGHTBORNE or player:GetLevel() >= START_LEVEL then return end
    player:RegisterEvent(function(_, _, _, p)
        if p:IsInWorld() and p:GetLevel() < START_LEVEL then
            p:SetLevel(START_LEVEL)
            p:Teleport(1220, 1717.5, 4628.5, 124.1, 0.0)
            p:SendBroadcastMessage("|cff00ff96[Nightborne]|r You arrive in Suramar ready for the Nightborne campaign.")
        end
    end, 3000, 1)
end)
