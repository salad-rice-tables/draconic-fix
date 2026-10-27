-- 86839 Relics of Light's Hope: Alonsus Faol (240240) at the Sunwell, Arator (237273) beside him.
-- Gossip "<Stay awhile and listen.>" plays the Faol/Arator talk (optional credit 253943),
-- "Tell Alonsus you are ready..." -> credit 240240, departure lines, both walk off -> credit 237273.
local QUEST, FAOL, ARATOR = 86839, 240240, 237273
local CREDIT_LISTEN, CREDIT_SPEAK, CREDIT_DEPART = 253943, 240240, 237273
local NPC_TEXT = 999999999
local OPT_LISTEN = "<Stay awhile and listen.>"
local OPT_READY = "Tell Alonsus you are ready to go to Light's Hope."

-- { speaker (F/A), text, soundkit } retail broadcast texts 296343..298611
local TALK = {
    { "F", "You're creating a bigger cloud with your moping than Xal'atath's Voidstorm.", 305939 },
    { "F", "Speak your mind! Let it out before these feelings create a well of poison in your gut.", 305938 },
    { "A", "I'm not just upset that my father cut me down.", 305937 },
    { "A", "I'm upset that when he did so... I saw the Light shining brightly in his eyes.", 305936 },
    { "A", "The same Light that I am taught to revere. Under its guidance, he almost killed me.", 305935 },
    { "F", "So you blame the Light, not your father?", 305934 },
    { "A", "We are trained to wield the Light as a weapon. Is that all that I am as a paladin?", 305933 },
    { "A", "You founded the Silver Hand. You trained my father. I suppose I blame you as well.", 305932 },
    { "A", "You crafted this philosophy of war. I followed your teachings until I burned myself with my own wrath.", 305931 },
    { "F", "Well, I think you're absolutely right. I really did make a mess of it all, didn't I?", 305930 },
    { "A", "What?", 305929 },
    { "F", "I'm reminded of each and every one of my failings every day when the Light burns me as I channel it.", 305928 },
    { "A", "What are you saying?", 305927 },
    { "F", "In many ways, this world is broken. You should feel angry about it.", 305926 },
    { "F", "That doesn't mean you can't try to change the world, or yourself, for the better.", 305925 },
    { "F", "Come with me on my little quest. I can't promise we'll change anything but how you feel.", 305924 },
    { "F", "But that's the only thing we can control.", 305923 },
}
local DEPART = {
    { "F", "To Light's Hope to gather relics and inspire the Vanguard.", 305878 },
    { "A", "No better place to take my mind off the problems with paladins.", 305877 },
}

local st = {}      -- [playerGuid] = { listened, ready, busy }
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or {}; return st[k] end

local function speak(faol, who, line)
    local npc = who == "F" and faol or faol:GetNearestCreature(20, ARATOR)
    if npc then
        npc:SendUnitSay(line[2], 0)
        npc:PlayDistanceSound(line[3])
    end
end

local function play(faol, lines, done)
    local t = 100
    for _, line in ipairs(lines) do
        local at = t
        faol:RegisterEvent(function(_, _, _, f) speak(f, line[1], line) end, at, 1)
        t = t + math.max(2000, #line[2] * 75) + 2500   -- estimated voice length + 2.5 s pause
    end
    if done then faol:RegisterEvent(function(_, _, _, f) done(f) end, t, 1) end
end

local function depart(faol, player)
    local ar = faol:GetNearestCreature(20, ARATOR)
    for _, npc in ipairs({ faol, ar }) do
        if npc then
            npc:SetNPCFlags(0)
            local x, y, z = npc:GetLocation()
            npc:MoveTo(1, x, y - 25, z)
            npc:DespawnOrUnsummon(6000)
        end
    end
    if player and player:IsInWorld() and player:HasQuest(QUEST) then player:KilledMonsterCredit(CREDIT_DEPART, 0) end
end

RegisterCreatureGossipEvent(FAOL, 1, function(event, player, creature)
    if not player:HasQuest(QUEST) then return false end
    local s = S(player)
    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    if s.busy then player:GossipComplete() return true end
    if not s.listened then player:GossipMenuAddItem(0, OPT_LISTEN, 0, 1) end
    player:GossipMenuAddItem(0, OPT_READY, 0, 2)
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end)

RegisterCreatureGossipEvent(FAOL, 2, function(event, player, creature, sender, intid)
    player:GossipComplete()
    local s = S(player)
    if s.busy then return end
    if intid == 1 then
        s.listened, s.busy = true, true
        player:KilledMonsterCredit(CREDIT_LISTEN, 0)
        play(creature, TALK, function() s.busy = nil end)
    elseif intid == 2 then
        s.busy = true
        player:KilledMonsterCredit(CREDIT_SPEAK, 0)
        local guid = player:GetGUID()
        play(creature, DEPART, function(f)
            s.busy = nil
            depart(f, f:GetMap():GetWorldObject(guid))
        end)
    end
end)

RegisterPlayerEvent(54, function(event, player, questId)
    if questId == QUEST then st[tostring(player:GetGUIDLow())] = nil end
end)
