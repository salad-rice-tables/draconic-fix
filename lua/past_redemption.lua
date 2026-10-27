-- 86649 Past Redemption: Turalyon gossip "(Quest) <Play Movie!> I'm ready." plays movie 1047 (retail),
-- then Turalyon says "Were we blind to Arator's truth?" (bt 298415, soundkit 300113)
local TURALYON, QUEST, MOVIE = 241654, 86649, 1047
local MOVIE_MS = 85000

RegisterCreatureGossipEvent(TURALYON, 2, function(event, player, creature, sender, intid)
    if not player:HasQuest(QUEST) then return end
    player:GossipComplete()
    player:SendMovieStart(MOVIE)
    local guid = creature:GetGUID()
    player:RegisterEvent(function(_, _, _, p)
        local t = p:GetNearestCreature(60, TURALYON)
        if t then
            t:SendUnitSay("Were we blind to Arator's truth?", 0)
            t:PlayDirectSound(300113, p)
        end
    end, MOVIE_MS, 1)
    return true
end)
