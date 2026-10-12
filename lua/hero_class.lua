-- =====================================================================
-- Hero Classes v1 (prototyp) for TrinityCore Retail + Eluna.
-- No core recompile, no client patch. A hero path is a second layer on
-- top of the normal class: any class can walk any path.
--
--  * Hero Master Arvenne (entry 9900100, Orgrimmar) - pick / abandon path.
--  * Requires level MIN_LEVEL. One path at a time.
--  * Hero XP: +1 per kill of a creature that is not grey for you.
--    Ranks unlock at RANK_HXP thresholds, each rank teaches one spell.
--  * Abandoning removes only spells the path granted (spells you already
--    owned, e.g. from Wildcard, stay).
--  * Command:  .hero  (status)
--  * State persists in characters.hero_class (see Custom/sql/hero_class.sql).
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

local ENABLED = true
local MIN_LEVEL = 10
local MASTER_ENTRY = 9900100
local MASTER_TEXT = 68 -- generic "Greetings, $N" npc_text
local GREY_DELTA = 5   -- kills more than this many levels below you give 0 hxp
local RANK_HXP = {0, 50, 150} -- hxp needed for rank 1, 2, 3

-- {name, tagline, {rank1, rank2, rank3 spells}}
local PATHS = {
    [1] = {"Fel Warden", "shadow and pursuit", {
        {36554, "Shadowstep"}, {5277, "Evasion"}, {31224, "Cloak of Shadows"}}},
    [2] = {"Archmage", "arcane mastery", {
        {1953, "Blink"}, {55342, "Mirror Image"}, {45438, "Ice Block"}}},
    [3] = {"Templar", "holy protection", {
        {1022, "Blessing of Protection"}, {633, "Lay on Hands"}, {642, "Divine Shield"}}},
}

local TAG = "|cffff8000[Hero]|r "

local function HasSQL()
    return CharDBQuery ~= nil and CharDBExecute ~= nil
end

-- Name as key: GetGUIDLow() returns userdata in this Eluna build.
local function Key(player)
    return (string.gsub(player:GetName() or "", "'", "''"))
end

local function SpellLink(s)
    return "|cffffffff|Hspell:" .. s[1] .. "|h[" .. s[2] .. "]|h|r"
end

local function Get(key)
    local ok, res = pcall(CharDBQuery, string.format(
        "SELECT path, hxp, granted FROM characters.hero_class WHERE name = '%s'", key))
    if ok and res then
        return {path = res:GetUInt32(0), hxp = res:GetUInt32(1), granted = res:GetString(2) or ""}
    end
    return {path = 0, hxp = 0, granted = ""}
end

local function Put(key, st)
    pcall(CharDBExecute, string.format(
        "REPLACE INTO characters.hero_class (name, path, hxp, granted) VALUES ('%s', %d, %d, '%s')",
        key, st.path, st.hxp, st.granted))
end

local function RankOf(hxp)
    local r = 0
    for i, need in ipairs(RANK_HXP) do
        if hxp >= need then r = i end
    end
    return r
end

local function Owns(player, id)
    local ok, has = pcall(function() return player:HasSpell(id) end)
    return ok and has
end

-- Teach every rank spell up to the current rank; remember what we gave.
local function GrantRanks(player, st)
    local path = PATHS[st.path]
    if not path then return end
    local rank = RankOf(st.hxp)
    for i = 1, rank do
        local s = path[3][i]
        if not Owns(player, s[1]) then
            pcall(function() player:LearnSpell(s[1]) end)
            st.granted = (st.granted == "" and "" or st.granted .. ",") .. s[1]
            player:SendBroadcastMessage(TAG .. path[1] .. " rank " .. i .. ": learned " .. SpellLink(s) .. "!")
        end
    end
end

local function Abandon(player, st)
    for num in string.gmatch(st.granted, "(%d+)") do
        pcall(function() player:RemoveSpell(tonumber(num)) end)
    end
    local old = PATHS[st.path]
    st.path, st.hxp, st.granted = 0, 0, ""
    if old then player:SendBroadcastMessage(TAG .. "You abandoned the path of the " .. old[1] .. ".") end
end

local function Status(player)
    local st = Get(Key(player))
    local path = PATHS[st.path]
    if not path then
        player:SendBroadcastMessage(TAG .. "No hero path. Visit Hero Master Arvenne in Orgrimmar (level " ..
            MIN_LEVEL .. "+).")
        return
    end
    local rank = RankOf(st.hxp)
    local nxt = RANK_HXP[rank + 1]
    player:SendBroadcastMessage(TAG .. path[1] .. " - rank " .. rank .. "/" .. #RANK_HXP ..
        ", hero xp " .. st.hxp .. (nxt and (" / " .. nxt) or " (max)"))
end

local function OnKill(event, player, killed)
    if not ENABLED then return end
    local ok, lvl = pcall(function() return killed:GetLevel() end)
    if not ok or not lvl or lvl < player:GetLevel() - GREY_DELTA then return end
    local key = Key(player)
    local st = Get(key)
    if st.path == 0 or RankOf(st.hxp) >= #RANK_HXP then return end
    local before = RankOf(st.hxp)
    st.hxp = st.hxp + 1
    if RankOf(st.hxp) > before then GrantRanks(player, st) end
    Put(key, st)
end

local function OnLogin(event, player)
    if not ENABLED then return end
    local key = Key(player)
    local st = Get(key)
    if st.path ~= 0 then
        GrantRanks(player, st) -- re-teach if a spell got lost (e.g. respec)
        Put(key, st)
    end
end

local function OnCommand(event, player, command)
    if not ENABLED then return end
    if string.lower(command or "") ~= "hero" then return end
    Status(player)
    return false
end

local function MasterShow(player, creature)
    player:GossipClearMenu()
    local st = Get(Key(player))
    if player:GetLevel() < MIN_LEVEL then
        player:GossipMenuAddItem(0, "Return at level " .. MIN_LEVEL .. ", hero.", 0, 0)
    elseif st.path == 0 then
        for i, p in ipairs(PATHS) do
            player:GossipMenuAddItem(0, "Walk the path of the " .. p[1] .. " (" .. p[2] .. ")", 0, i)
        end
    else
        player:GossipMenuAddItem(0, "Show my progress.", 0, 50)
        player:GossipMenuAddItem(0, "Abandon my path (lose its spells and hero xp).", 0, 99)
    end
    player:GossipSendMenu(MASTER_TEXT, creature)
end

local function MasterHello(event, player, creature)
    MasterShow(player, creature)
end

local function MasterSelect(event, player, creature, sender, intid, code, menu_id)
    local key = Key(player)
    local st = Get(key)
    if PATHS[intid] and st.path == 0 and player:GetLevel() >= MIN_LEVEL then
        st.path, st.hxp, st.granted = intid, 0, ""
        player:SendBroadcastMessage(TAG .. "You are now a " .. PATHS[intid][1] .. ". Slay worthy foes to rank up.")
        GrantRanks(player, st)
        Put(key, st)
        print("[hero] " .. player:GetName() .. " chose path " .. intid)
    elseif intid == 50 then
        Status(player)
    elseif intid == 99 and st.path ~= 0 then
        Abandon(player, st)
        Put(key, st)
        print("[hero] " .. player:GetName() .. " abandoned path")
    end
    MasterShow(player, creature)
end

if ENABLED then
    if not HasSQL() then
        print("[hero] DISABLED: CharDBQuery/CharDBExecute not available in this Eluna build")
    else
        RegisterPlayerEvent(3, OnLogin)    -- ON_LOGIN
        RegisterPlayerEvent(7, OnKill)     -- ON_KILL_CREATURE
        RegisterPlayerEvent(42, OnCommand) -- ON_COMMAND
        RegisterCreatureGossipEvent(MASTER_ENTRY, 1, MasterHello)  -- GOSSIP_HELLO
        RegisterCreatureGossipEvent(MASTER_ENTRY, 2, MasterSelect) -- GOSSIP_SELECT
        print("[hero] loaded: " .. #PATHS .. " hero paths, ranks at " .. table.concat(RANK_HXP, "/") .. " hxp")
    end
end
