-- 91000 A Humble Servant + 86846 Resupplying Our Suppliers (Hammerfall; retail lines per Warcraft Wiki)
-- 91000: Injured Peon heal (credit 245257), optional Malu/Nadura talk. Trash piles/rubble/rats/cockroaches are native credits.
-- 86846: gossip "(Quest) Dezco sent these supplies for you." on Jun'ha / Slagg / Tunkk / Mu'uta / Keena; hidden DNT credits follow deliveries.
local Q_HUMBLE, Q_SUPPLY = 91000, 86846
local NPC_TEXT = 999999999

local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or { peons = {}, given = {}, n = 0, talked = {} }; return st[k] end
local function fill(t, p) return (t:gsub("%$n", p:GetName()):gsub("%$p", p:GetName())) end

local Q_PLOW = 89338
local DEZCO, ARATOR, FAOL = 247299, 241428, 240747

local function say(p, entry, text, sound)
    local n = p:GetNearestCreature(120, entry)
    if n then n:SendUnitSay(fill(text, p), 0); n:PlayDistanceSound(sound) end
end
-- lines = { {entry,text,sound}, ... } with 2-3 s pause after each estimated voice length
local function play(p, lines, done)
    local t = 100
    for _, l in ipairs(lines) do
        p:RegisterEvent(function(_, _, _, pl) say(pl, l[1], l[2], l[3]) end, t, 1)
        t = t + math.max(2000, #l[2] * 75) + 2500
    end
    if done then p:RegisterEvent(function(_, _, _, pl) done(pl) end, t, 1) end
end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == Q_HUMBLE or questId == Q_SUPPLY or questId == Q_PLOW then st[tostring(player:GetGUIDLow())] = nil end
    if status ~= 3 then return end
    local k = tostring(player:GetGUIDLow())
    st[k] = st[k] or { peons = {}, given = {}, n = 0, talked = {} }
    if (questId == Q_HUMBLE or questId == Q_SUPPLY) and not st[k].accepted then
        st[k].accepted = true
        play(player, {
            { 245186, "$n, if you could help with cleanup and deliveries. Arator can help me with some work that needs another pair of hands.", 306086 },
            { 240747, "If you'll all excuse me, I must find Eitrigg. There are some things I need to arrange.", 306085 },
        })
    elseif questId == Q_PLOW then
        play(player, {
            { DEZCO, "The discarded weapons of past wars litter the fields and complicate farming.", 306071 },
            { DEZCO, "$n, if you would gather what you can, Arator and I will prepare the forge.", 311309 },
        })
    end
end)

-- ---------------------------------------------------------------- Gathering Plowshares (89338)
local PLOW_TALK = {
    { ARATOR, "Is this what it means to be a Sunwalker?", 306088 },
    { DEZCO,  "For some. Others are content to smite the wicked with a giant hammer.", 306084 },
    { DEZCO,  "But allowing the innocent to suffer... that is the worst evil.", 306083 },
    { ARATOR, "This isn't the type of thing the Silver Hand gets involved in, is it?", 306082 },
    { DEZCO,  "Alonsus has told me how he always intended for the Silver Hand to focus on this kind of service.", 306081 },
    { DEZCO,  "But war changed what his paladins were called to do.", 306080 },
    { DEZCO,  "Alonsus tells me stories of his first students. The legendary Uther was apparently quite the nurse.", 306079 },
    { ARATOR, "I would have liked to meet the man during that time.", 306078 },
    { ARATOR, "My father was one of those students. He's never mentioned any of this to me.", 306077 },
    { DEZCO,  "I don't know the High Exarch well. I do know he's been to other worlds, far from here. Fighting for an unimaginable amount of time.", 306076 },
    { DEZCO,  "We're shaped by the events in our lives. But we can choose how we will live going forward.", 306075 },
    { DEZCO,  "What type of paladin do you want to be, Arator? What type of person?", 306074 },
    { ARATOR, "I... want to come back here and help you, once this war has ended. I think this is as much my calling as facing down the horrors of the Void.", 306073 },
}
-- The client sends the quest hello (not gossip hello) to an NPC that is the ender of an in-progress quest, so the
-- "Stay awhile and listen" option can't be offered as gossip here: the talk starts when the player walks up to Dezco.
local plowWatch = {}
local function plowStart(player)
    local k = tostring(player:GetGUIDLow())
    if plowWatch[k] then return end
    plowWatch[k] = player:RegisterEvent(function(id, _, _, p)
        if not p:HasQuest(Q_PLOW) or S(p).plowTalk then p:RemoveEventById(id); plowWatch[k] = nil; return end
        local d = p:GetNearestCreature(8, DEZCO)
        if d then
            S(p).plowTalk = true
            p:RemoveEventById(id); plowWatch[k] = nil
            p:KilledMonsterCredit(253978, 0)
            play(p, PLOW_TALK)
        end
    end, 2000, 0)
end
RegisterPlayerEvent(3, function(event, player) if player:HasQuest(Q_PLOW) then plowStart(player) end end)
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == Q_PLOW and status == 1 then       -- objectives done
        say(player, DEZCO, "The fields are cleared of scrap metal! We'll make something useful out of this refuse.", 306070)
    end
    if questId == Q_PLOW and status == 3 then
        plowWatch[tostring(player:GetGUIDLow())] = nil
        -- start after the accept lines (about 14 s)
        player:RegisterEvent(function(_, _, _, p) if p:HasQuest(Q_PLOW) then plowStart(p) end end, 14000, 1)
    end
end)

-- ---------------------------------------------------------------- Injured Peons
local PEON = 245257
local PEON_LINES = { "Back to work, then.", "Much better!", "Thank you, $n." }
RegisterCreatureGossipEvent(PEON, 1, function(event, player, creature)
    if not player:HasQuest(Q_HUMBLE) then return false end
    local s, g = S(player), tostring(creature:GetDBTableGUIDLow())
    if not s.peons[g] then
        s.peons[g] = true
        player:KilledMonsterCredit(PEON, 0)
        creature:SendUnitSay(fill(PEON_LINES[math.random(#PEON_LINES)], player), 0)
        creature:PerformEmote(1)
    end
    player:GossipComplete()
    return true
end)

-- ---------------------------------------------------------------- Malu / Nadura (optional talk)
local TALK = {
    [238101] = { "Do you have anything better to do?", "Helping those in need is rewarding work." },   -- Malu
    [238081] = { "Taking a break?", "I wasn't made a Sunwalker to do a laborer's work." },            -- Nadura
}
for entry, t in pairs(TALK) do
    RegisterCreatureGossipEvent(entry, 1, function(event, player, creature)
        if not player:HasQuest(Q_HUMBLE) then return false end
        player:GossipClearMenu()
        player:GossipAddQuests(creature)
        if not S(player).talked[entry] then player:GossipMenuAddItem(0, t[1], 0, 1) end
        player:GossipSendMenu(NPC_TEXT, creature)
        return true
    end)
    RegisterCreatureGossipEvent(entry, 2, function(event, player, creature, sender, intid)
        player:GossipComplete()
        local s = S(player)
        if intid ~= 1 or s.talked[entry] then return end
        s.talked[entry] = true
        creature:SendUnitSay(t[2], 0)
        player:TalkedToCreature(entry, creature)
    end)
end

-- ---------------------------------------------------------------- supply deliveries (86846)
-- entry -> reply line
local SUPPLY = {
    [232033] = "Much appreciated, $n. No one likes clothes that are worn too thin.",       -- Jun'ha (tailoring)
    [232031] = "Excellent, $n. I won't have to stop my work to deal with other details.",   -- Slagg (butcher)
    [232036] = "Perfect, just what I need to keep working.",                                -- Tunkk (leatherworking)
    [232037] = "Ah, I was nearly out of string.",                                           -- Mu'uta (bowyer)
    [232035] = "This will help Hammerfall, $n, thank you.",                                 -- Keena (trade goods)
}
local OPT_SUPPLY = "(Quest) Dezco sent these supplies for you."

for entry, line in pairs(SUPPLY) do
    RegisterCreatureGossipEvent(entry, 1, function(event, player, creature)
        if not player:HasQuest(Q_SUPPLY) then return false end
        player:GossipClearMenu()
        player:GossipAddQuests(creature)
        if not S(player).given[entry] then player:GossipMenuAddItem(0, OPT_SUPPLY, 0, 1) end
        player:GossipSendMenu(NPC_TEXT, creature)
        return true
    end)
    RegisterCreatureGossipEvent(entry, 2, function(event, player, creature, sender, intid)
        player:GossipComplete()
        local s = S(player)
        if intid ~= 1 or s.given[entry] or not player:HasQuest(Q_SUPPLY) then return end
        s.given[entry] = true
        s.n = s.n + 1
        creature:SetFacingToObject(player)
        creature:SendUnitSay(fill(line, player), 0)
        player:KilledMonsterCredit(entry, 0)
        -- hidden DNT credits retail fires along the way
        if s.n == 1 then player:KilledMonsterCredit(245254, 0) end
        if s.n == 3 then player:KilledMonsterCredit(245305, 0); player:KilledMonsterCredit(240747, 0) end
        if s.n == 5 then player:KilledMonsterCredit(251859, 0) end
    end)
end
