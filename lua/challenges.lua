-- =====================================================================
-- Ascension Challenges. A Challenge Master (9900133, starting areas and
-- capital inns) lets a character up to level 10 take on challenges; each
-- active one pays extra at levels 20/40/60/80 and grants a title at 90.
--   hardcore  one death and the character stays a ghost for good
--   ironman   only white/grey gear, no Mystic Enchants, no groups
--   exile     capitals are closed to you
--   lonewolf  no groups
--   selfmade  no trade, no mail, no auction house
--   slow      half experience
-- Breaking a rule fails that challenge. characters.hero_challenge holds state.
-- =====================================================================

local ENABLED = true
local TAG = "|cffc41e3a[Challenge]|r "
local NPC = 9900133
local MAX_START = 10
local ACTIVE, FAILED, DONE, PERISHED = 0, 1, 2, 3
local MILESTONES = {20, 40, 60, 80}
local FINAL = 90

local MODES = {
    {key = "hardcore", name = "Hardcore", title = 1400, desc = "Die once and your hero stays a ghost forever."},
    {key = "ironman",  name = "Iron Man", title = 1401, desc = "Only white and grey gear, no Mystic Enchants, no groups."},
    {key = "exile",    name = "Exile",    title = 1402, desc = "Capital cities are closed to you."},
    {key = "lonewolf", name = "Lone Wolf", title = 1403, desc = "You never join a group."},
    {key = "selfmade", name = "Self-Made", title = 1404, desc = "No trading, no mail, no auction house."},
    {key = "slow",     name = "Slow & Steady", title = 1405, desc = "You gain only half experience."},
}
local BY_KEY = {}
for _, m in ipairs(MODES) do BY_KEY[m.key] = m end
local ASCENDED_TITLE = 1406
local CAPITALS = {[1637] = true, [1519] = true, [1537] = true, [1638] = true, [1497] = true, [1657] = true, [3487] = true,
    [3557] = true, [3703] = true, [4395] = true, [7502] = true, [13862] = true, [14771] = true}

local function Key(player) return (string.gsub(player:GetName() or "", "'", "''")) end

-- cache per player name: mode -> {status, reward}
local CACHE = {}
local function Load(player)
    local t = {}
    local ok, res = pcall(CharDBQuery, string.format("SELECT mode, status, reward_level FROM characters.hero_challenge WHERE name = '%s'", Key(player)))
    if ok and res then repeat t[res:GetString(0)] = {status = res:GetUInt32(1), reward = res:GetUInt32(2)} until not res:NextRow() end
    CACHE[player:GetName()] = t
    return t
end
local function State(player) return CACHE[player:GetName()] or Load(player) end
local function Active(player, key) local s = State(player)[key]; return s and s.status == ACTIVE end

local function Save(player, key, status, reward)
    pcall(CharDBExecute, string.format("REPLACE INTO characters.hero_challenge (name, mode, status, reward_level) VALUES ('%s', '%s', %d, %d)",
        Key(player), key, status, reward or 0))
    State(player)[key] = {status = status, reward = reward or 0}
end

local function Fail(player, key, why)
    if not Active(player, key) then return end
    Save(player, key, FAILED, State(player)[key].reward)
    player:SendBroadcastMessage(TAG .. "|cffff4040" .. BY_KEY[key].name .. " failed:|r " .. why)
end

-- XP factor used by the single XP hook in ascension_world.lua
function CHALLENGE_XPFactor(player)
    return Active(player, "slow") and 0.5 or 1.0
end
function CHALLENGE_NoMystic(player) return Active(player, "ironman") end

-- ---------------------------------------------------------------- rewards
local function OnLevel(event, player, oldLevel)
    local lvl = player:GetLevel()
    local st = State(player)
    local actives = {}
    for k, s in pairs(st) do if s.status == ACTIVE then actives[#actives + 1] = k end end
    if #actives == 0 then return end
    for _, k in ipairs(actives) do
        local s = st[k]
        for _, m in ipairs(MILESTONES) do
            if lvl >= m and s.reward < m then
                s.reward = m
                Save(player, k, ACTIVE, m)
                local runes = 2 + #actives
                local gold = 10000 * m
                player:ModifyMoney(gold)
                player:SendBroadcastMessage(TAG .. BY_KEY[k].name .. " - level " .. m .. " reached! Reward: " .. math.floor(gold / 10000) .. "g.")
                if MYS_AddRunes then MYS_AddRunes(player, runes) end
                if (m == 40 or m == 80) and MYS_GiveRandomEnchant then MYS_GiveRandomEnchant(player) end
            end
        end
        if lvl >= FINAL then
            Save(player, k, DONE, FINAL)
            pcall(function() player:SetKnownTitle(BY_KEY[k].title) end)
            player:SendBroadcastMessage(TAG .. "|cff00ff00" .. BY_KEY[k].name .. " completed!|r You earned a new title.")
            SendWorldMessage(TAG .. player:GetName() .. " has completed the " .. BY_KEY[k].name .. " challenge!")
            if WORLD_News then WORLD_News(player:GetName() .. " has completed the " .. BY_KEY[k].name .. " challenge!") end
        end
    end
    local done = 0
    for _, s in pairs(State(player)) do if s.status == DONE then done = done + 1 end end
    if done >= 3 then pcall(function() player:SetKnownTitle(ASCENDED_TITLE) end) end
end

-- ---------------------------------------------------------------- rules
local function Perish(player)
    if not Active(player, "hardcore") then return end
    if MANASTORM_InRun and MANASTORM_InRun(player) then return end   -- Manastorm deaths are safe
    Save(player, "hardcore", PERISHED, State(player).hardcore.reward)
    player:SendBroadcastMessage(TAG .. "|cffff2020Your Hardcore journey has ended. Your spirit can no longer return to life.|r")
    SendWorldMessage(TAG .. player:GetName() .. " has fallen at level " .. player:GetLevel() .. " (Hardcore). Rest in peace.")
    if WORLD_News then WORLD_News(player:GetName() .. " fell in the Hardcore challenge at level " .. player:GetLevel() .. ". A funeral is held in the capital.") end
    if LW_Funeral then pcall(LW_Funeral, player:GetName(), player:IsHorde()) end
end

local function Perished(player) local s = State(player).hardcore; return s and s.status == PERISHED end

local function KeepDead(player)
    if Perished(player) and player:IsAlive() then
        player:SendBroadcastMessage(TAG .. "A Hardcore hero who has fallen stays among the spirits.")
        player:RegisterEvent(function(_, _, _, p) if p and p:IsAlive() then p:KillPlayer() end end, 1000, 1)
    end
end

local lastSafe = {}   -- name -> {map, x, y, z, o} outside capitals (Exile)
local function OnZone(event, player, zone)
    if Active(player, "exile") and CAPITALS[zone] then
        local s = lastSafe[player:GetName()]
        player:SendNotification("Exiles are not welcome here.")
        player:SendBroadcastMessage(TAG .. "As an Exile you cannot enter capital cities.")
        if s then player:RegisterEvent(function(_, _, _, p) if p then p:Teleport(s[1], s[2], s[3], s[4], s[5]) end end, 500, 1) end
    elseif not CAPITALS[zone] then
        lastSafe[player:GetName()] = {player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO()}
    end
end

local function OnEquip(event, player, item)
    if Active(player, "ironman") then
        local ok, q = pcall(function() return item:GetQuality() end)
        if ok and q and q >= 2 then Fail(player, "ironman", "you equipped an item better than common quality.") end
    end
end

local function OnGroupAdd(event, group, guid)
    local p = GetPlayerByGUID(guid)
    if not p then return end
    for _, k in ipairs({"lonewolf", "ironman"}) do
        if Active(p, k) then
            p:SendBroadcastMessage(TAG .. BY_KEY[k].name .. " heroes walk alone - you were removed from the group.")
            pcall(function() group:RemoveMember(guid) end)
            return
        end
    end
end

-- ---------------------------------------------------------------- Challenge Master
local function Show(player, creature)
    player:GossipClearMenu()
    local st = State(player)
    local canStart = player:GetLevel() <= MAX_START
    for i, m in ipairs(MODES) do
        local s = st[m.key]
        local label
        if not s then
            label = canStart and ("Take the |cffc41e3a" .. m.name .. "|r challenge: " .. m.desc) or (m.name .. " (only up to level " .. MAX_START .. ")")
        elseif s.status == ACTIVE then label = "|cff00a000[Active]|r " .. m.name .. " - abandon it"
        elseif s.status == DONE then label = "|cffffd100[Completed]|r " .. m.name
        elseif s.status == PERISHED then label = "|cff808080[Fallen]|r " .. m.name
        else label = "|cff808080[Failed]|r " .. m.name end
        local popup = (not s and canStart) and ("Take the " .. m.name .. " challenge? " .. m.desc) or
                      ((s and s.status == ACTIVE) and ("Abandon " .. m.name .. "? You cannot take it again.") or nil)
        player:GossipMenuAddItem(0, label, 0, i, false, popup)
    end
    if player:GetLevel() >= FINAL then
        player:GossipMenuAddItem(0, "|cffff8000Rebirth:|r start over at level 1 and grow stronger.", 0, 60, false,
            "Be reborn at level 1? Your collections, titles, runes and reputation stay. Your Hero build starts over.")
    end
    player:GossipMenuAddItem(0, "What are challenges?", 0, 50)
    player:GossipMenuAddItem(0, "|cffff8000Reset my challenges (if bugged).|r Hardcore death stays.", 0, 70, false,
        "Delete all my challenge states except a Hardcore death? Use only when something broke.")
    player:GossipSendMenu(1, creature)
end

-- actions shared by gossip menu, addon window and chat (single source of truth)
local function HasUI(player)
    if HERO_HasUI then local ok, v = pcall(HERO_HasUI, player); if ok then return v end end
    return false
end
local function SendWindow(player)
    -- CHALOPEN;key:status,...;canStart:0/1  (status: -=none, A, D, F, P)
    local st = State(player)
    local parts = {}
    for _, m in ipairs(MODES) do
        local s = st[m.key]
        parts[#parts + 1] = m.key .. ":" .. (not s and "-" or (s.status == ACTIVE and "A" or (s.status == DONE and "D" or (s.status == PERISHED and "P" or "F"))))
    end
    parts[#parts + 1] = "canStart:" .. (player:GetLevel() <= MAX_START and "1" or "0")
    pcall(function() player:SendAddonMessage("WCARD", "CHALOPEN;" .. table.concat(parts, ","), 7, player) end)
end
local function TakeChallenge(player, key)
    local m = BY_KEY[key]
    if not m then return end
    local s = State(player)[m.key]
    if not s and player:GetLevel() <= MAX_START then
        Save(player, m.key, ACTIVE, 0)
        player:SendBroadcastMessage(TAG .. "You took the |cffc41e3a" .. m.name .. "|r challenge. " .. m.desc ..
            " Rewards at levels 20, 40, 60, 80 and a title at " .. FINAL .. ".")
        if m.key == "lonewolf" or m.key == "ironman" then pcall(function() player:RemoveFromGroup() end) end
    elseif s and s.status == ACTIVE then
        -- abandon = toggle OFF (row deleted, can be taken again); FAILED stays
        -- only for rule violations via Fail() and is permanent
        pcall(CharDBExecute, string.format("DELETE FROM characters.hero_challenge WHERE name = '%s' AND mode = '%s'", Key(player), m.key))
        State(player)[m.key] = nil
        player:SendBroadcastMessage(TAG .. "You abandoned " .. m.name .. ". You can take it again.")
    end
end
local function ResetChallenges(player)
    pcall(CharDBExecute, string.format("DELETE FROM characters.hero_challenge WHERE name = '%s' AND NOT (mode = 'hardcore' AND status = 3)", Key(player)))
    CACHE[player:GetName()] = nil
    State(player)
    player:SendBroadcastMessage(TAG .. "Challenge states reset (a Hardcore death, if any, stays).")
end
local function Select(event, player, creature, sender, intid)
    if sender == 9900133 then
        -- DB trigger menu: window for UI players, gossip menu otherwise
        if HasUI(player) then
            player:GossipComplete()
            SendWindow(player)
        else
            Show(player, creature)
        end
        return
    end
    local m = MODES[intid]
    if m then
        TakeChallenge(player, m.key)
    elseif intid == 60 then
        player:GossipComplete()
        if PROG_Rebirth then PROG_Rebirth(player) end
        return
    elseif intid == 50 then
        player:SendBroadcastMessage(TAG .. "Up to level " .. MAX_START .. " you may take any number of challenges. Each one makes the road harder " ..
            "and pays Mystic Runes, gold and enchants at levels 20/40/60/80, and a title at " .. FINAL .. ". Three completed challenges make you Ascended.")
    elseif intid == 70 then
        -- reset bugged states, but never a Hardcore death (PERISHED hardcore stays dead)
        ResetChallenges(player)
    end
    Show(player, creature)
end

if ENABLED then
    RegisterPlayerEvent(3, function(_, player) Load(player) end)                         -- login (world state)
    RegisterPlayerEvent(28, function(_, player) if not IS_WORLD_STATE then KeepDead(player) end end)   -- enters a map
    RegisterPlayerEvent(4, function(_, player) CACHE[player:GetName()] = nil end)          -- logout
    RegisterPlayerEvent(13, OnLevel)                                                       -- level change
    RegisterPlayerEvent(35, function(_, player) Perish(player) end)                        -- repop (released spirit)
    RegisterPlayerEvent(8, function(_, killer, killed) Perish(killed) end)                 -- killed by creature
    RegisterPlayerEvent(6, function(_, killer, killed) Perish(killed) end)                 -- killed by player
    RegisterPlayerEvent(36, function(_, player) KeepDead(player) end)                      -- resurrect
    RegisterPlayerEvent(27, OnZone)                                                        -- zone change
    RegisterPlayerEvent(29, OnEquip)                                                       -- equip
    RegisterPlayerEvent(48, function(_, player, target)                                   -- trade init
        if Active(player, "selfmade") or (target and Active(target, "selfmade")) then
            player:SendBroadcastMessage(TAG .. "Self-Made heroes do not trade.")
            return false
        end
    end)
    RegisterPlayerEvent(49, function(_, player)                                           -- send mail
        if Active(player, "selfmade") then player:SendBroadcastMessage(TAG .. "Self-Made heroes do not use the mail."); return false end
    end)
    RegisterServerEvent(26, function(_, auctionId, owner)                                 -- auction listed
        local ok, isP = pcall(function() return owner and owner.GetName ~= nil end)
        if ok and isP then Fail(owner, "selfmade", "you used the auction house.") end
    end)
    RegisterGroupEvent(1, OnGroupAdd)                                                      -- member added
    RegisterCreatureGossipEvent(NPC, 1, function(_, player, creature)
        PrintInfo("[challenges] gossip hello: " .. player:GetName())
        local ok, err = pcall(Show, player, creature)
        if not ok then
            PrintInfo("[challenges] Show failed: " .. tostring(err))
            player:SendBroadcastMessage(TAG .. "The Challenge Master cannot speak right now: " .. tostring(err))
            pcall(WorldDBExecute, "REPLACE INTO world.lw_state (k, v) VALUES ('chal:error', '" .. string.gsub(tostring(err), "'", "") .. "')")
        else
            pcall(WorldDBExecute, "REPLACE INTO world.lw_state (k, v) VALUES ('chal:hello', '" .. player:GetName() .. "')")
        end
    end)
    RegisterCreatureGossipEvent(NPC, 2, Select)
    -- addon window protocol (WCARD): CHALQUERY -> CHALOPEN; CHALTAKE;key, CHALDROP;key, CHALRESET
    RegisterServerEvent(30, function(_, sender, _, prefix, msg)
        if prefix ~= "WCARD" or type(msg) ~= "string" then return end
        local okP, isP = pcall(function() return sender.LearnSpell ~= nil end)
        if not okP or not isP then return end
        local kind, arg = string.match(msg, "^(CHAL[A-Z]*);?(%w*.-)$")
        if kind == "CHALQUERY" then SendWindow(sender)
        elseif (kind == "CHALTAKE" or kind == "CHALDROP") and arg ~= "" then TakeChallenge(sender, arg:lower()); SendWindow(sender)
        elseif kind == "CHALRESET" then ResetChallenges(sender); SendWindow(sender) end
    end)
    -- .chall text fallback (works even if no gossip fires at all)
    RegisterPlayerEvent(42, function(_, player, command)
        if command ~= "chall" and command ~= "challenge" then return end
        local st = State(player)
        player:SendBroadcastMessage(TAG .. "Challenges (take up to level " .. MAX_START .. "):")
        for _, m in ipairs(MODES) do
            local s = st[m.key]
            player:SendBroadcastMessage("  " .. m.name .. " - " .. (s and s.status or "available") .. ". " .. m.desc)
        end
        return false
    end)
    print("[challenges] loaded: " .. #MODES .. " challenges")
end
