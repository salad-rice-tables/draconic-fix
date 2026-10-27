-- 86845 The Sunwalker Path (retail flow per Warcraft Wiki): Faol gossip "ready to go to Hammerfall" -> portal (GO 9108871, phase 45805) -> Hammerfall, Dezco turn-in.
local QUEST, FAOL, PORTAL_GO = 86845, 251355, 9108871
local DEST = { 0, -1059.0, -3550.0, 55.0, 6.25764 }      -- from retail Borrowed Portal SAI (Hammerfall)
local NPC_TEXT = 999999999
local OPT = "<Tell Alonsus you are ready to go to Hammerfall.>"

local ACCEPT = {
    { "A", "I spoke to you of finding a different path, Arator. I think it's time we started on it.", 305894 },   -- retail 290800 (Faol)
    { "A2", "All right... But if this lesson is anything like the others--", 305893 },                            -- retail 290801 (Arator)
    { "A", "Oh, don't worry. This one won't be imparted by me.", 305892 },                                       -- retail 299121 (Faol)
}
local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or {}; return st[k] end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= QUEST then return end
    st[tostring(player:GetGUIDLow())] = nil
    if status ~= 3 then return end
    local faol = player:GetNearestCreature(60, FAOL)
    if not faol then return end
    local t = 100
    for _, l in ipairs(ACCEPT) do
        faol:RegisterEvent(function(_, _, _, f)
            local who = (l[1] == "A2") and (f:GetNearestCreature(60, 248348) or f:GetNearestCreature(250, 237273)) or f
            if who then who:SendUnitSay(l[2], 0); who:PlayDistanceSound(l[3]) end
        end, t, 1)
        t = t + math.max(2000, #l[2] * 75) + 2500          -- estimated voice length + 2.5 s pause
    end
end)

RegisterCreatureGossipEvent(FAOL, 1, function(event, player, creature)
    if not player:HasQuest(QUEST) or S(player).ready then return false end
    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    player:GossipMenuAddItem(0, OPT, 0, 1)
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end)

RegisterCreatureGossipEvent(FAOL, 2, function(event, player, creature, sender, intid)
    player:GossipComplete()
    if intid ~= 1 or S(player).ready then return end
    S(player).ready = true
    player:KilledMonsterCredit(237511, 0)
    creature:PerformEmote(1)
    creature:RegisterEvent(function() if player:IsInWorld() then player:KilledMonsterCredit(264111, 0) end end, 3000, 1)   -- portal created
end)

RegisterGameObjectGossipEvent(PORTAL_GO, 1, function(event, player, go)
    if not player:HasQuest(QUEST) then return false end
    player:KilledMonsterCredit(248052, 0)
    player:Teleport(DEST[1], DEST[2], DEST[3], DEST[4], DEST[5])
    -- hidden DNT credits that retail gives on arrival
    player:RegisterEvent(function(_, _, _, p)
        p:KilledMonsterCredit(245207, 0)
        p:KilledMonsterCredit(238072, 0)
        -- arrival conversation (retail lines + soundkits)
        local lines = {
            { 241428, "Hammerfall? Is this about the Red Dawn?", 306092 },
            { 240747, "Quite the opposite. We're going to see someone who is doing something wonderful. Something I failed to accomplish.", 306090 },
            { 245186, "One moment--this post is being stubborn.", 306094 },
            { 245186, "Faol! What brings you and your friends to Hammerfall? Please tell me the world isn't ending again.", 306093 },
        }
        local t = 0
        for _, l in ipairs(lines) do
            p:RegisterEvent(function(_, _, _, pl)
                local n = pl:GetNearestCreature(120, l[1])
                if n then n:SendUnitSay(l[2], 0); n:PlayDistanceSound(l[3]) end
            end, t, 1)
            t = t + math.max(2000, #l[2] * 75) + 2500
        end
    end, 6000, 1)
    return true
end)
