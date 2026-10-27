-- 86822 One Final Relic (retail flow per Warcraft Wiki; retail broadcast lines + soundkits)
-- accept: Faol/Arator lines; Faol gossip "ready to go to the Burning Steppes" -> credit 240747 -> travel to Black Tooth Hovel;
-- arrival: credit 246899 + Kurdran line; talking to Faol there gives credit 246863; Danath Trollbane (242120) ends the quest.
local QUEST = 86822
local FAOL_HF, ARATOR_HF = 240747, 241428
local FAOL_BS = 248263
local DEST = { 0, -7996.0, -1521.0, 134.8, 0.0 }     -- Black Tooth Hovel, next to Danath (guid 3000214643)
local NPC_TEXT = 999999999

local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or {}; return st[k] end
local function fill(t, p) return (t:gsub("%$n", p:GetName()):gsub("%$p", p:GetName())) end

local function play(player, lines)
    local t = 100
    for _, l in ipairs(lines) do
        player:RegisterEvent(function(_, _, _, p)
            local n = p:GetNearestCreature(120, l[1])
            if n then n:SendUnitSay(fill(l[2], p), 0); n:PlayDistanceSound(l[3]) end
        end, t, 1)
        t = t + math.max(2000, #l[2] * 75) + 2500          -- estimated voice length + 2.5 s pause
    end
end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= QUEST then return end
    st[tostring(player:GetGUIDLow())] = nil
    if status == 3 then
        play(player, {
            { FAOL_HF,   "I must now steal Arator and $n away. Arrangements have been made to find one last relic.", 306068 },
            { ARATOR_HF, "Thank you, Dezco. I really admire what you're doing here. I'll be sure to return.", 306067 },
        })
    end
end)

RegisterCreatureGossipEvent(FAOL_HF, 1, function(event, player, creature)
    if not player:HasQuest(QUEST) or S(player).left then return false end
    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    player:GossipMenuAddItem(0, "(Quest) Tell Alonsus you are ready to go to the Burning Steppes.", 0, 1)
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end)

RegisterCreatureGossipEvent(FAOL_HF, 2, function(event, player, creature, sender, intid)
    player:GossipComplete()
    if intid ~= 1 or S(player).left then return end
    S(player).left = true
    player:KilledMonsterCredit(240747, 0)
    creature:PerformEmote(1)
    player:RegisterEvent(function(_, _, _, p)
        p:Teleport(DEST[1], DEST[2], DEST[3], DEST[4], DEST[5])
        p:RegisterEvent(function(_, _, _, pl)
            pl:KilledMonsterCredit(246899, 0)                 -- Faol and Arator arrive
            play(pl, { { 237268, "There you are! Faol, why'd you bring us back to this desolate place?", 306037 } })
        end, 5000, 1)
    end, 3000, 1)
end)

-- Faol in the Burning Steppes: "Speak with Alonsus Faol" (credit 246863)
RegisterCreatureGossipEvent(FAOL_BS, 1, function(event, player, creature)
    if not player:HasQuest(QUEST) or S(player).spoke then return false end
    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    player:GossipMenuAddItem(0, "(Quest) <Speak with Alonsus Faol.>", 0, 1)
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end)
RegisterCreatureGossipEvent(FAOL_BS, 2, function(event, player, creature, sender, intid)
    player:GossipComplete()
    if intid ~= 1 or S(player).spoke then return end
    S(player).spoke = true
    player:KilledMonsterCredit(246863, 0)
end)

-- ---------------------------------------------------------------- 91391 Still Scouting (accept lines + hidden "Eitrigg Walks Off" credit)
local Q_SCOUT, FAOL_BS2, EITRIGG = 91391, 248263, 237224
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= Q_SCOUT or status ~= 3 then return end
    local lines = {
        { FAOL_BS2, "Kurdran flew to the entrance of Blackrock Spire, $n. He's tracked down the next fragment.", 306016 },
        { EITRIGG,  "The Dark Horde displays them like trophies. But the only thing they mark is loss.", 306014 },
    }
    local t = 100
    for _, l in ipairs(lines) do
        player:RegisterEvent(function(_, _, _, p)
            local n = p:GetNearestCreature(120, l[1])
            if n then n:SendUnitSay(fill(l[2], p), 0); n:PlayDistanceSound(l[3]) end
        end, t, 1)
        t = t + math.max(2000, #l[2] * 75) + 2500
    end
    player:RegisterEvent(function(_, _, _, p) if p:IsInWorld() then p:KilledMonsterCredit(247004, 0) end end, t, 1)   -- Eitrigg walks off
end)

-- ---------------------------------------------------------------- 86827 Due Recognition (hidden "Kurdran Flies In" credit 248116)
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == 86827 and status == 3 then
        player:RegisterEvent(function(_, _, _, p) if p:IsInWorld() then p:KilledMonsterCredit(248116, 0) end end, 3000, 1)
    end
end)
