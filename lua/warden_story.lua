-- =====================================================================
-- Warden Velarys (entry 95113) story gossip: hub + 4 lore topics.
-- NOTE: no GossipClearMenu here - core adds quest [!]/[?] items to the
-- same menu and clearing would hide them. Items are added fresh on every
-- hello, selecting a topic only swaps the shown text.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

local VELARYS_ENTRY = 95113
local VELARYS_HUB = 95001 -- npc_text, topics live in 95002-95005
local FINALE_QUEST = 95010

local TOPICS = {
    [1] = {text = 95002, label = "Who are the Wardens?"},
    [2] = {text = 95003, label = "What threatens these woods?"},
    [3] = {text = 95004, label = "Why do you need demon hunters?"},
    [4] = {text = 95005, label = "What is my path?"},
}

local function WKey(player)
    return (string.gsub(player:GetName() or "", "'", "''"))
end

local function IsRewarded(player, questId)
    local ok, st = pcall(function() return player:GetQuestStatus(questId) end)
    return ok and (st == 4) -- QUEST_STATUS_REWARDED
end

local function IsHonored(key, quest)
    local ok, res = pcall(CharDBQuery,
        string.format("SELECT name FROM characters.warden_honors WHERE name = '%s' AND quest = %d", key, quest))
    return ok and res ~= nil
end

local function MarkHonored(key, quest)
    pcall(CharDBExecute,
        string.format("REPLACE INTO characters.warden_honors (name, quest) VALUES ('%s', %d)", key, quest))
end

local function VelarysHello(event, player, creature)
    for i = 1, 4 do
        player:GossipMenuAddItem(0, TOPICS[i].label, 0, i)
    end
    if IsRewarded(player, 95010) and not IsHonored(CharKey(player), 95010) then
        player:GossipMenuAddItem(0, "Kneel before Maiev. (Campaign finale)", 0, 5)
    end
    if IsRewarded(player, 95016) and not IsHonored(CharKey(player), 95016) then
        player:GossipMenuAddItem(0, "Kneel as Demonslayer. (Fel Hunt finale)", 0, 6)
    end
    player:GossipSendMenu(VELARYS_HUB, creature)
end

local function VelarysSelect(event, player, creature, sender, intid, code, menu_id)
    local t = TOPICS[intid]
    if t then
        player:GossipSendMenu(t.text, creature)
        return
    end
    if intid == 5 then
        if not IsRewarded(player, 95010) then
            player:SendBroadcastMessage("|cffffd200[Warden]|r Finish 'The Avatar\\'s Shadow' first. Maiev kneels for no unfinished hunter.")
        elseif IsHonored(WKey(player), 95010) then
            player:SendBroadcastMessage("|cffffd200[Warden]|r You already rose as Vengeance Incarnate.")
        else
            MarkHonored(WKey(player), 95010)
            SendWorldMessage("|cffffd200[Warden]|r " .. player:GetName() ..
                " has risen as Vengeance Incarnate, Warden under Maiev Shadowsong!")
        end
        player:GossipSendMenu(VELARYS_HUB, creature)
    elseif intid == 6 then
        if not IsRewarded(player, 95016) then
            player:SendBroadcastMessage("|cffffd200[Warden]|r Finish 'Fall of the Overfiend' first.")
        elseif IsHonored(WKey(player), 95016) then
            player:SendBroadcastMessage("|cffffd200[Warden]|r The realms already know the Demonslayer.")
        else
            MarkHonored(WKey(player), 95016)
            SendWorldMessage("|cffffd200[Warden]|r " .. player:GetName() ..
                " has slain the Felborne Overfiend and earned the name Demonslayer!")
        end
        player:GossipSendMenu(VELARYS_HUB, creature)
    end
end

RegisterCreatureEvent(VELARYS_ENTRY, 1, VelarysHello)  -- GOSSIP_HELLO
RegisterCreatureEvent(VELARYS_ENTRY, 2, VelarysSelect) -- GOSSIP_SELECT

print("[warden-story] loaded: Velarys gossip (entry " .. VELARYS_ENTRY .. ")")
