-- Suramar campaign: 43564 Flow Control & 43567 All In (QuestLine 204)
-- Retail flow, exact broadcast texts and soundkits (BT 118700-118721, kits 67353-67371)
-- 43564: 3 Arcway outlets (252776, 252779, 252783) clicked -> credit GO
-- 43567: Dramatic Conduit sabotage sequence -> Arluin sacrifice -> Shal'Aran return -> Farodin turn-in

local Q_FLOW = 43564
local Q_ALL_IN = 43567

local THALYSSRA = 97140
local ARLUIN_WOUNDED = 113062

local OBJ_SABOTAGED = 113069
local OBJ_CHECK_ARLUIN = 113062
local OBJ_ENTER_SHAL = 113070
local OBJ_ARRIVAL = 113061

local OUTLETS = { 252776, 252779, 252783 }

local st = {}
local function S(p)
    local k = tostring(p:GetGUIDLow())
    st[k] = st[k] or {}
    return st[k]
end

local function alive(c)
    if not c then return false end
    local ok, v = pcall(function() return c:IsInWorld() and c:IsAlive() end)
    return ok and v
end

local function say(c, text, kit)
    if not alive(c) then return end
    pcall(function() c:SendUnitSay(text, 0) end)
    if kit and kit > 0 then
        pcall(function() c:PlayDistanceSound(kit) end)
    end
end

local function after(p, ms, fn)
    pcall(function()
        p:RegisterEvent(function(_, _, _, pl) fn(pl or p) end, ms, 1)
    end)
end

-- --------------------------------------------------------------------------
-- 43564: Flow Control - Click 3 outlets in Suramar City
-- --------------------------------------------------------------------------
for _, goEntry in ipairs(OUTLETS) do
    RegisterGameObjectEvent(goEntry, 14, function(event, go, player)
        if not player or not player:HasQuest(Q_FLOW) then return false end
        pcall(function() player:KillGOCredit(goEntry) end)
        return false
    end)
end

-- --------------------------------------------------------------------------
-- 43567: All In - Dramatic Sabotage and Arluin Sacrifice
-- --------------------------------------------------------------------------
local function start_sabotage_scene(player, thalyssra)
    local s = S(player)
    if s.running then return end
    s.running = true

    say(thalyssra, "Erath-omnas! The conduit is unstable!", 67353)

    -- Arluin shouts during conduit defense
    after(player, 3500, function(p)
        say(thalyssra, "The manastorm is only getting stronger! We need to shut that thing down!", 67354)
    end)

    after(player, 7000, function(p)
        say(thalyssra, "It is too dangerous! The arcane torrents would tear us apart!", 67355)
    end)

    after(player, 10500, function(p)
        say(thalyssra, "Damn it... You guys owe me...", 67357)
    end)

    after(player, 14000, function(p)
        say(thalyssra, "What are you doing?! Arluin! NO!!", 67359)
    end)

    after(player, 17500, function(p)
        say(thalyssra, "Hhghh-AAAHHHH!!!", 67360)
    end)

    -- Conduit sabotaged!
    after(player, 20500, function(p)
        p:KilledMonsterCredit(OBJ_SABOTAGED, 0)
        say(thalyssra, "Oculeth, get us out of here!", 67361)
    end)

    -- Return to Shal'Aran
    after(player, 23500, function(p)
        p:KilledMonsterCredit(OBJ_ENTER_SHAL, 0)
        say(thalyssra, "Ugh... we made it... Where is Arluin?! Oh no...", 67363)

        -- Spawn wounded Arluin at Shal'Aran upper terrace
        local x, y, z, o = 1713.0, 4629.5, 124.0, 4.5
        local arluin = p:SpawnCreature(ARLUIN_WOUNDED, x, y, z, o, 8, 120000)
        if arluin then
            s.arluin = arluin
            pcall(function()
                arluin:SetFaction(35)
                arluin:SetNPCFlags(1)
                arluin:SetStandState(1)
            end)
        end
    end)
end

-- Thalyssra gossip: offer to start the sabotage
RegisterCreatureGossipEvent(THALYSSRA, 1, function(event, player, creature)
    if not player:HasQuest(Q_ALL_IN) then return false end
    local s = S(player)
    if s.running or player:GetQuestStatus(Q_ALL_IN) ~= 3 then return false end

    player:GossipClearMenu()
    player:GossipAddQuests(creature)
    player:GossipMenuAddItem(0, "(Quest) <Begin the sabotage on the Nightflow Conduit>", 0, 1)
    player:GossipSendMenu(999999999, creature)
    return true
end)

RegisterCreatureGossipEvent(THALYSSRA, 2, function(event, player, creature, sender, intid)
    if intid == 1 and player:HasQuest(Q_ALL_IN) then
        player:GossipComplete()
        start_sabotage_scene(player, creature)
        return true
    end
end)

-- Wounded Arluin: Check on Arluin
RegisterCreatureGossipEvent(ARLUIN_WOUNDED, 1, function(event, player, creature)
    if not player:HasQuest(Q_ALL_IN) then return false end
    local s = S(player)
    if s.arluin_done then return false end
    s.arluin_done = true

    player:GossipComplete()
    player:KilledMonsterCredit(OBJ_CHECK_ARLUIN, 0)

    -- Arluin's dying words
    say(creature, "<cough> Nghh... Hey... Tell Vanthir I said... thanks... for every...", 67369)

    local thal = player:GetNearestCreature(40, THALYSSRA)

    after(player, 4000, function(p)
        say(creature, "We pulled it off... <wheeze> didn't we?", 67367)
    end)

    after(player, 7500, function(p)
        if thal then say(thal, "Yes. You saved us. Please... try to rest.", 67368) end
    end)

    after(player, 11000, function(p)
        p:KilledMonsterCredit(OBJ_ARRIVAL, 0)
        if thal then
            say(thal, "He is gone. Come... Let us check on the others.", 67370)
        end
        pcall(function() creature:DespawnOrUnsummon(2000) end)
        s.running = nil
    end)

    return true
end)

-- Reset state on quest abandon / accept
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == Q_ALL_IN then
        st[tostring(player:GetGUIDLow())] = nil
    end
end)
