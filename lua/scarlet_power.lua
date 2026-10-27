-- 86842 Scarlet Power (retail flow per Warcraft Wiki, retail broadcast texts + soundkits)
-- Light's Hope: accept lines, Arator gossip "<Stay awhile and listen.>" talk (optional credit 253953).
-- Scarlet Monastery entrance triggers (45 / 614) take questers to the Scarlet Halls (map 2857), credit 242627.
-- Map 2857: Faol greets on arrival, "Enter the Scarlet Halls" (248044) once past the courtyard.
local QUEST = 86842
local FAOL_LH, ARATOR_LH, FAOL_SH = 237601, 241255, 240714
local CREDIT_LISTEN, CREDIT_ENTER, CREDIT_HALLS = 253953, 242627, 248044
local HALLS_MAP, HALLS_X, HALLS_Y, HALLS_Z, HALLS_O = 2857, 1072.0, 503.0, 2.82, 0.0   -- clear of the exit trigger 9108456 at (1058,510) r=5
local HALLS_ENTER_X = 1110            -- past the initiates' courtyard
local NPC_TEXT = 999999999
local OPT_LISTEN = "<Stay awhile and listen.>"
local ARATOR_OPEN = "$p, it's so strange to me that the Light responds to the Scarlets just as it does to me, Faol, or Lord Tyrosus."

local ACCEPT = {
    { "A", "The Scarlet Crusade? You, of all people, want to spread their Light?", 305948 },
    { "F", "They claimed many relics when they seized my church. Relics that would be better used to our purpose of holding back Xal'atath.", 305947 },
}
local TALK = {
    { "A", "I can scarcely believe that the Light answers their call.", 305963 },
    { "A", "I was always taught that the Light was good. The Crusade is... unconscionable.", 305960 },
    { "F", "The Light seeks a path. It does not dictate the way.", 305959 },
    { "F", "Look at all the cultures across Azeroth that channel the Light. From Elune, to Gral, to An'she.", 305958 },
    { "F", "Philosophically different from our Church of Holy Light, but with the same ability to channel the energy.", 305957 },
    { "A", "I have often wondered.", 305956 },
    { "F", "The Light needs a lens to focus its power through the wielder. The Light brings certainty, and it responds to one's conviction.", 305955 },
    { "F", "But the Light cannot distinguish between love and hatred.", 305954 },
    { "A", "So that is why the Scarlet Crusade claims it acts according to the Light's will.", 305953 },
    { "F", "And why they were able to pervert my teachings of fellowship and protection into something you and I recognize so clearly as evil.", 305952 },
    { "F", "The Scarlet Crusade was founded by a paladin I personally anointed. For a long time, I saw them as my own misjudgment made manifest. Perhaps I still do.", 305951 },
    { "F", "However... the relics they possess will do for our purposes of bolstering the Sunwell defenders.", 305950 },
    { "F", "It... will be good to reclaim them.", 305949 },
}
local ARRIVE = { "F", "You're here, $n. We should join Arator inside. My sermon to these fanatics is falling on deaf ears.", 305846 }

local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or {}; return st[k] end

local function fill(text, player)
    return (text:gsub("%$p", player:GetName()):gsub("%$n", player:GetName()))
end

-- lines: { "F"/"A", text, soundkit }; pause = estimated voice length + 2.5 s
local function play(anchor, faolEntry, aratorEntry, lines, player, done)
    local t = 100
    for _, line in ipairs(lines) do
        anchor:RegisterEvent(function(_, _, _, a)
            local npc = a:GetEntry() == (line[1] == "F" and faolEntry or aratorEntry) and a
                or a:GetNearestCreature(30, line[1] == "F" and faolEntry or aratorEntry)
            if npc then
                npc:SendUnitSay(player and fill(line[2], player) or line[2], 0)
                npc:PlayDistanceSound(line[3])
            end
        end, t, 1)
        t = t + math.max(2000, #line[2] * 75) + 2500
    end
    if done then anchor:RegisterEvent(function() done() end, t, 1) end
end

-- accept at Faol (Light's Hope)
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= QUEST then return end
    st[tostring(player:GetGUIDLow())] = nil
    if status == 3 then
        local faol = player:GetNearestCreature(40, FAOL_LH)
        if faol then play(faol, FAOL_LH, ARATOR_LH, ACCEPT, player) end
    end
end)

-- Arator gossip at Light's Hope
RegisterCreatureGossipEvent(ARATOR_LH, 1, function(event, player, creature)
    if not player:HasQuest(QUEST) or S(player).listened then return false end
    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    player:GossipMenuAddItem(0, OPT_LISTEN, 0, 1)
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end)

RegisterCreatureGossipEvent(ARATOR_LH, 2, function(event, player, creature, sender, intid)
    player:GossipComplete()
    local s = S(player)
    if intid ~= 1 or s.listened then return end
    s.listened = true
    player:KilledMonsterCredit(CREDIT_LISTEN, 0)
    creature:SendUnitSay(fill(ARATOR_OPEN, player), 0)
    creature:RegisterEvent(function(_, _, _, c) play(c, FAOL_LH, ARATOR_LH, TALK, player) end, 5000, 1)
end)

-- Scarlet Monastery Entrance area (5511, Tirisfal) while the quest is active -> credit + Scarlet Halls (2857)
local ENTRANCE_AREA = 5511
RegisterPlayerEvent(47, function(event, player, oldArea, newArea)
    if newArea == ENTRANCE_AREA and player:HasQuest(QUEST) and player:GetMapId() == 0 then
        local s = S(player)
        player:KilledMonsterCredit(CREDIT_ENTER, 0)
        if s.sentToHalls then return end        -- only once per quest (the Halls exit trigger sends us back to Tirisfal)
        s.sentToHalls = true
        player:RegisterEvent(function(_, _, _, p) p:Teleport(HALLS_MAP, HALLS_X, HALLS_Y, HALLS_Z, HALLS_O) end, 1500, 1)
    end
end)

-- on map 2857: Faol greets once, halls credit once past the courtyard
local function watch(player)
    local s = S(player)
    if s.watch then return end
    s.watch = player:RegisterEvent(function(id, _, _, p)
        local ss = S(p)
        if p:GetMapId() ~= HALLS_MAP or not p:HasQuest(QUEST) then
            p:RemoveEventById(id); ss.watch = nil; return
        end
        if not ss.greeted then
            local faol = p:GetNearestCreature(25, FAOL_SH)
            if faol then
                ss.greeted = true
                faol:SendUnitSay(fill(ARRIVE[2], p), 0)
                faol:PlayDistanceSound(ARRIVE[3])
            end
        end
        if not ss.halls and p:GetX() > HALLS_ENTER_X then
            ss.halls = true
            p:KilledMonsterCredit(CREDIT_HALLS, 0)
        end
    end, 2000, 0)
end

RegisterPlayerEvent(28, function(event, player) if player:GetMapId() == HALLS_MAP then watch(player) end end) -- map change
RegisterPlayerEvent(3, function(event, player) if player:GetMapId() == HALLS_MAP then watch(player) end end)  -- login
