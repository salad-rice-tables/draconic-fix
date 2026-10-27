-- 92136 Infusion of Hope + 86902 Relinquishing Relics (retail flow per Warcraft Wiki; retail broadcast lines + soundkits)
-- 92136: accept lines (Arator/Faol), Faol gossip "ready to return" -> portal to Silvermoon (GO 246004), credits 237602/246427/250066.
-- 86902: Faol asks to deliver relics, relic gossip on Taelia/Valunei/Salandria/Mehlar, remaining relics to Velen, Aelyse optional.
local Q_INF, Q_REL = 92136, 86902
local FAOL_HALLS, FAOL_SW, ARATOR_HALLS, VELEN = 237602, 251355, 241311, 239623
local PORTAL_GO = 9108870                  -- own goober (GO 246004's spell 32270 leads to old Silvermoon, map 530)
local DEST = { 0, 10776.0, -4610.0, 35.4, 0.0 }   -- Silvermoon, beside Alonsus (phase 45803)
local NPC_TEXT = 999999999

local function fill(t, p) return (t:gsub("%$n", p:GetName()):gsub("%$p", p:GetName())) end

local function play(anchor, lines, player, done)
    local t = 100
    for _, l in ipairs(lines) do
        anchor:RegisterEvent(function(_, _, _, a)
            local npc = a:GetNearestCreature(250, l[1]) or (a:GetEntry() == l[1] and a)
            if npc then npc:SendUnitSay(fill(l[2], player), 0); npc:PlayDistanceSound(l[3]) end
        end, t, 1)
        t = t + math.max(2000, #l[2] * 75) + 2500    -- estimated voice length + 2.5 s pause
    end
    if done then anchor:RegisterEvent(function() done() end, t, 1) end
end

local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or {}; return st[k] end

-- ---------------------------------------------------------------- 92136
local ACCEPT_INF = {
    { ARATOR_HALLS, "Is this the fate of all paladins? Die a legend or live to be consumed by zealotry and wrath?", 305896 },
    { FAOL_HALLS,   "No, Arator. My hope is that you can find a different path to follow.", 305895 },
}

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == Q_INF or questId == Q_REL then st[tostring(player:GetGUIDLow())] = nil end
    if status ~= 3 then return end
    if questId == Q_INF then
        local f = player:GetNearestCreature(40, FAOL_HALLS)
        if f then play(f, ACCEPT_INF, player) end
    elseif questId == Q_REL then
        local f = player:GetNearestCreature(40, FAOL_SW)
        if f then
            play(f, { { FAOL_SW, "$n, if you could deliver the relics. I need to have a word in private with Arator.", 305917 } }, player,
                function() if player:IsInWorld() then player:KilledMonsterCredit(248305, 0) end end)
        end
    end
end)

RegisterCreatureGossipEvent(FAOL_HALLS, 1, function(event, player, creature)
    if not player:HasQuest(Q_INF) or S(player).portal then return false end
    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    player:GossipMenuAddItem(0, "<Tell Alonsus you are ready to return to Silvermoon.>", 0, 1)
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end)

RegisterCreatureGossipEvent(FAOL_HALLS, 2, function(event, player, creature, sender, intid)
    player:GossipComplete()
    if intid ~= 1 or S(player).portal then return end
    S(player).portal = true
    player:KilledMonsterCredit(237602, 0)
    local x, y, z, o = creature:GetLocation()
    creature:PerformEmote(1)
    creature:RegisterEvent(function(_, _, _, c)
        c:SummonGameObject(PORTAL_GO, x + 3 * math.cos(o), y + 3 * math.sin(o), z, o, 300)
        if player:IsInWorld() then player:KilledMonsterCredit(246427, 0) end
    end, 3000, 1)
end)

RegisterCreatureGossipEvent(ARATOR_HALLS, 1, function(event, player, creature)
    if not player:HasQuest(Q_INF) then return false end
    creature:SendUnitSay("I can't face those gathered at the Sunwell right now.", 0)
    creature:PlayDistanceSound(305921)
    player:GossipComplete()
    return true
end)

RegisterGameObjectGossipEvent(PORTAL_GO, 1, function(event, player, go)
    if not player:HasQuest(Q_INF) then return false end
    player:KilledMonsterCredit(250066, 0)
    player:Teleport(DEST[1], DEST[2], DEST[3], DEST[4], DEST[5])
    return true
end)

-- ---------------------------------------------------------------- 86902
-- entry -> { option text, credit, optional line {text, soundkit} }
local RELIC = {
    [248323] = { "<Give Taelia Mara Fordragon's Prayer Book.>", 248323 },
    [248326] = { "<Give Valunei Vindicator Maraad's Meditation Crystal.>", 248326 },
    [248322] = { "Take this sword.", 248322 },
    [248321] = { "<Give Mehlar Uther's Healing Kit.>", 248321 },
    [VELEN]  = { "<Give Velen the remaining relics to distribute.>", VELEN,
                 { "Thank you, $n. We are resolute in our defense, but mortal in our constitutions. These relics will bolster us for a time.", 305918 } },
    [248408] = { nil, 248408 },                              -- Aelyse: optional talk credit
}

local function relicHello(event, player, creature)
    if not player:HasQuest(Q_REL) then return false end
    local r = RELIC[creature:GetEntry()]
    local s = S(player)
    s.given = s.given or {}
    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    if r[1] and not s.given[r[2]] then player:GossipMenuAddItem(0, "(Quest) " .. r[1], 0, 1) end
    if not r[1] and not s.given[r[2]] then s.given[r[2]] = true; player:KilledMonsterCredit(r[2], 0) end
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end

local function relicSelect(event, player, creature, sender, intid)
    player:GossipComplete()
    local r = RELIC[creature:GetEntry()]
    local s = S(player); s.given = s.given or {}
    if intid ~= 1 or not r or s.given[r[2]] or not player:HasQuest(Q_REL) then return end
    s.given[r[2]] = true
    creature:SetFacingToObject(player)
    player:KilledMonsterCredit(r[2], 0)
    if r[3] then creature:SendUnitSay(fill(r[3][1], player), 0); creature:PlayDistanceSound(r[3][2]) end
end

for entry in pairs(RELIC) do
    RegisterCreatureGossipEvent(entry, 1, relicHello)
    RegisterCreatureGossipEvent(entry, 2, relicSelect)
end
