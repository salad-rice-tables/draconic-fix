-- =====================================================================
-- Ascension world systems (needs worldforge.lua):
--  * Rares and bosses: rare elites drop Worldforged loot or Mystic Runes,
--    world bosses always give a Worldforged item, an enchant and runes,
--    dungeon bosses sometimes give an enchant. The killer's party shares it.
--  * Daily Bounties: Bounty Master (9900132, capital inns) gives 3 bounties
--    a day; finish them for gold and Mystic Runes, all 3 for an enchant.
--  * High-Risk zones (Ascension Bronzebeard): +50% XP and double rare loot,
--    but dying drops one random item from your bags in a Lost Satchel that
--    anyone can pick up for 10 minutes.
-- =====================================================================

local ENABLED = true
local TAG = "|cffff8000[Ascension]|r "
local HTAG = "|cffff2020[High-Risk]|r "
local BTAG = "|cff3fc7eb[Bounty]|r "

local function Key(player) return (string.gsub(player:GetName() or "", "'", "''")) end

-- ---------------------------------------------------------------- High-Risk zones
local HIGH_RISK = {
    [46] = "Burning Steppes", [51] = "Searing Gorge", [4] = "Blasted Lands", [1377] = "Silithus",
    [139] = "Eastern Plaguelands", [3] = "Badlands", [361] = "Felwood", [618] = "Winterspring",
    [3523] = "Netherstorm", [3520] = "Shadowmoon Valley", [210] = "Icecrown", [66] = "Zul'Drak",
    [5842] = "Townlong Steppes", [6721] = "Gorgrond", [7637] = "Suramar", [8721] = "Drustvar",
    [11462] = "Maldraxxus", [13646] = "The Azure Span", [14795] = "The Ringing Deeps",
}
local function InHighRisk(player)
    local ok, z = pcall(function() return player:GetZoneId() end)
    return ok and HIGH_RISK[z] ~= nil
end

local SATCHEL = 9709998
local satchels = {}   -- [go guid string] = {entry, count, owner, expires}

local function DropSatchel(player)
    if player:GetLevel() < 10 then return end
    -- every bag item (backpack 35..62 and the 4 bags in slots 30..33) except quest items and the hearthstone
    local cand = {}
    local function consider(it)
        if not it then return end
        local okE, e = pcall(function() return it:GetEntry() end)
        local okC, c = pcall(function() return it:GetClass() end)
        if okE and e ~= 6948 and okC and c ~= 12 then cand[#cand + 1] = it end
    end
    for slot = 35, 62 do consider(player:GetItemByPos(255, slot)) end
    for bag = 30, 33 do
        for slot = 0, 35 do
            local ok, it = pcall(function() return player:GetItemByPos(bag, slot) end)
            if ok then consider(it) end
        end
    end
    if #cand == 0 then return end
    if true then return end   -- the Lost Satchel is a runtime GameObject: PerformIngameSpawn for GameObjects crashes this core, so nothing is dropped for now
    local it = cand[math.random(#cand)]
    local entry, count = it:GetEntry(), it:GetCount()
    local link = GetItemLink(entry) or ("item " .. entry)
    player:RemoveItem(entry, count)
    local ok, go = pcall(PerformIngameSpawn, 2, SATCHEL, player:GetMapId(), player:GetInstanceId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO(), false)
    if ok and go then
        satchels[tostring(go:GetGUIDLow())] = {entry = entry, count = count, owner = player:GetName(), expires = os.time() + 600, go = go}
    end
    player:SendBroadcastMessage(HTAG .. "You died in a High-Risk zone and dropped " .. link .. (count > 1 and (" x" .. count) or "") ..
        ". It lies in a Lost Satchel where you fell - hurry, anyone can take it!")
end

local function OnSatchel(event, go, player)
    local k = tostring(go:GetGUIDLow())
    local s = satchels[k]
    if not s then return true end
    if player:AddItem(s.entry, s.count) then
        local link = GetItemLink(s.entry) or s.entry
        player:SendBroadcastMessage(HTAG .. (player:GetName() == s.owner and "You recovered " or "You looted ") .. link ..
            (player:GetName() == s.owner and "." or (" from " .. s.owner .. "'s Lost Satchel.")))
        satchels[k] = nil
        pcall(function() go:Despawn() end)
        pcall(function() go:RemoveFromWorld(false) end)
    else
        player:SendNotification("Your bags are full.")
    end
    return true
end

CreateLuaEvent(function()
    local now = os.time()
    for k, s in pairs(satchels) do
        if now >= s.expires then
            pcall(function() s.go:Despawn() end)
            pcall(function() s.go:RemoveFromWorld(false) end)
            satchels[k] = nil
        end
    end
end, 30000, 0)

-- ---------------------------------------------------------------- Bounties
local KINDS = {
    kill     = {need = 40, runes = 1, text = "Slay %d creatures of your level or higher"},
    rare     = {need = 2,  runes = 2, text = "Slay %d rare creatures"},
    find     = {need = 3,  runes = 1, text = "Claim %d Worldforged items or Mystic Scrolls"},
    boss     = {need = 3,  runes = 2, text = "Defeat %d dungeon bosses"},
    highrisk = {need = 15, runes = 3, text = "Slay %d creatures in a High-Risk zone"},
}
local KIND_ORDER = {"kill", "rare", "find", "boss", "highrisk"}

local function Today() return os.date("%Y-%m-%d") end

-- cached per player for a minute; progress updates the cached rows in place
local BCACHE = {}
local BountiesDB
local function Bounties(player)
    local c = BCACHE[player:GetName()]
    if c and c.day == Today() and os.time() - c.t < 60 then return c.list end
    local list = BountiesDB(player)
    BCACHE[player:GetName()] = {list = list, t = os.time(), day = Today()}
    return list
end

function BountiesDB(player)
    local t = {}
    local ok, res = pcall(CharDBQuery, string.format(
        "SELECT slot, kind, need, have, claimed FROM characters.hero_bounty WHERE name = '%s' AND day = '%s' ORDER BY slot", Key(player), Today()))
    if ok and res then
        repeat t[#t + 1] = {slot = res:GetUInt32(0), kind = res:GetString(1), need = res:GetUInt32(2), have = res:GetUInt32(3), claimed = res:GetUInt32(4) == 1}
        until not res:NextRow()
    end
    return t
end

local function RollBounties(player)
    BCACHE[player:GetName()] = nil
    local pool = {}
    for _, k in ipairs(KIND_ORDER) do pool[#pool + 1] = k end
    local key, day = Key(player), Today()
    pcall(CharDBExecute, string.format("DELETE FROM characters.hero_bounty WHERE name = '%s' AND day <> '%s'", key, day))
    for slot = 1, 3 do
        local k = table.remove(pool, math.random(#pool))
        pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.hero_bounty (name, day, slot, kind, need, have, claimed) VALUES ('%s', '%s', %d, '%s', %d, 0, 0)",
            key, day, slot, k, KINDS[k].need))
    end
end

function BountyProgress(player, kind, n)
    if kind == "find" and SAGA_Progress then pcall(SAGA_Progress, player, "find", n) end
    local list = Bounties(player)
    for _, b in ipairs(list) do
        if b.kind == kind and b.have < b.need and not b.claimed then
            local have = math.min(b.need, b.have + (n or 1))
            b.have = have
            pcall(CharDBExecute, string.format("UPDATE characters.hero_bounty SET have = %d WHERE name = '%s' AND day = '%s' AND slot = %d",
                have, Key(player), Today(), b.slot))
            if have >= b.need then
                player:SendBroadcastMessage(BTAG .. "Bounty complete: " .. string.format(KINDS[kind].text, b.need) .. ". Report to a Bounty Master.")
            end
        end
    end
end

local BOUNTY_NPC = 9900132
local function BountyShow(player, creature)
    player:GossipClearMenu()
    local list = Bounties(player)
    if #list == 0 then RollBounties(player); list = Bounties(player) end
    local all = true
    for _, b in ipairs(list) do
        local text = string.format(KINDS[b.kind].text, b.need)
        if b.claimed then
            player:GossipMenuAddItem(0, "|cff00a000[Done]|r " .. text, 0, 0)
        elseif b.have >= b.need then
            player:GossipMenuAddItem(3, "|cffffd100[Claim reward]|r " .. text, 0, 100 + b.slot)
            all = false
        else
            player:GossipMenuAddItem(0, text .. "  (" .. b.have .. "/" .. b.need .. ")", 0, 0)
            all = false
        end
    end
    if all then player:GossipMenuAddItem(0, "All bounties done for today. Come back tomorrow.", 0, 0) end
    player:GossipMenuAddItem(0, "|cffe6cc80Sagas:|r tell me a story worth following.", 0, 2)
    player:GossipMenuAddItem(0, "How do bounties work?", 0, 1)
    player:GossipSendMenu(1, creature)
end

local function BountySelect(event, player, creature, sender, intid)
    if intid == 2 then
        if SAGA_Offer then SAGA_Offer(player) end
    elseif intid == 1 then
        player:SendBroadcastMessage(BTAG .. "Three new bounties every day. Each pays gold and Mystic Runes; finish all three for a random Mystic Enchant.")
    elseif intid > 100 then
        local slot = intid - 100
        for _, b in ipairs(Bounties(player)) do
            if b.slot == slot and b.have >= b.need and not b.claimed then
                b.claimed = true
                pcall(CharDBExecute, string.format("UPDATE characters.hero_bounty SET claimed = 1 WHERE name = '%s' AND day = '%s' AND slot = %d", Key(player), Today(), slot))
                local gold = math.floor(5000 * math.max(1, player:GetLevel()) * (CITY_RewardFactor and CITY_RewardFactor(player) or 1))
                if CITY_AddRep then CITY_AddRep(player, CITY_RepOfZone(player, creature:GetZoneId()), 15) end
                player:ModifyMoney(gold)
                if MYS_AddRunes then MYS_AddRunes(player, KINDS[b.kind].runes) end
                if SEASON_AddPoints then SEASON_AddPoints(player, 5) end
                player:SendBroadcastMessage(BTAG .. "Reward: " .. math.floor(gold / 10000) .. "g " .. math.floor(gold % 10000 / 100) .. "s.")
                local done = 0
                for _, x in ipairs(Bounties(player)) do if x.claimed then done = done + 1 end end
                if done == 3 and MYS_GiveRandomEnchant then
                    player:SendBroadcastMessage(BTAG .. "All three bounties done - the Bounty Master hands you a Mystic Scroll!")
                    MYS_GiveRandomEnchant(player)
                end
            end
        end
    end
    BountyShow(player, creature)
end

-- ---------------------------------------------------------------- kills
local function Party(killer, victim)
    local list = {}
    local okG, group = pcall(function() return killer:GetGroup() end)
    if okG and group then
        local okM, members = pcall(function() return group:GetMembers() end)
        if okM and members then
            for _, m in ipairs(members) do
                if m and m:IsInWorld() and m:GetMapId() == killer:GetMapId() and m:GetDistance(victim) < 100 then list[#list + 1] = m end
            end
        end
    end
    if #list == 0 then list[1] = killer end
    return list
end

local function OnKill(event, killer, victim)
    if not killer or not victim then return end
    local okR, rank = pcall(function() return victim:GetRank() end)
    rank = okR and rank or 0
    local wb = pcall(function() return victim:IsWorldBoss() end) and victim:IsWorldBoss()
    local db = pcall(function() return victim:IsDungeonBoss() end) and victim:IsDungeonBoss()
    local hr = InHighRisk(killer)
    for _, p in ipairs(Party(killer, victim)) do
        if wb then
            p:SendBroadcastMessage(TAG .. "World boss defeated!")
            if WF_GiveNearbyItem then WF_GiveNearbyItem(p, 5000) end
            -- world-drop schopnost pre pool hrdinov (teleport/mount)
            if WORLD_DROP_TryGive then pcall(WORLD_DROP_TryGive, p) end
            if MYS_GiveRandomEnchant then MYS_GiveRandomEnchant(p) end
            if MYS_AddRunes then MYS_AddRunes(p, 3) end
        elseif db then
            BountyProgress(p, "boss", 1)
            if WORLD_DROP_TryGive and math.random() < 0.15 then pcall(WORLD_DROP_TryGive, p) end
            if math.random() < 0.2 and MYS_GiveRandomEnchant then MYS_GiveRandomEnchant(p)
            elseif MYS_AddRunes then MYS_AddRunes(p, 1) end
        elseif rank == 2 or rank == 4 then
            BountyProgress(p, "rare", 1)
            local chance = (hr and 0.7 or 0.35) * ((SEASON_Is and SEASON_Is("fortune")) and 2 or 1)
            if WORLD_DROP_TryGive and math.random() < 0.03 then pcall(WORLD_DROP_TryGive, p) end
            if not (math.random() < chance and WF_GiveNearbyItem and WF_GiveNearbyItem(p)) and MYS_AddRunes then MYS_AddRunes(p, 1) end
        end
        if victim:GetLevel() >= p:GetLevel() then BountyProgress(p, "kill", 1) end
        if hr then BountyProgress(p, "highrisk", 1) end
    end
end

if ENABLED then
    RegisterPlayerEvent(7, (PERF_Wrap or function(_, f) return f end)("ascension_world.OnKill", OnKill))  -- ON_KILL_CREATURE
    RegisterPlayerEvent(12, function(_, player, amount)   -- ON_GIVE_XP: +50% in High-Risk zones
        local f = (InHighRisk(player) and 1.5 or 1.0) * (CHALLENGE_XPFactor and CHALLENGE_XPFactor(player) or 1.0) *
                  (ROOM_XPFactor and ROOM_XPFactor(player) or 1.0)
        for _, fn in ipairs(XP_FACTORS or {}) do local okF, v = pcall(fn, player); if okF and v then f = f * v end end
        if f ~= 1.0 then return math.floor(amount * f) end
    end)
    RegisterPlayerEvent(8, function(_, killer, killed) if InHighRisk(killed) then DropSatchel(killed) end end)   -- killed by creature
    RegisterPlayerEvent(6, function(_, killer, killed) if InHighRisk(killed) then DropSatchel(killed) end end)   -- killed by player
    RegisterPlayerEvent(27, function(_, player, zone)     -- ON_UPDATE_ZONE
        if HIGH_RISK[zone] then
            player:SendNotification("HIGH-RISK ZONE: " .. HIGH_RISK[zone])
            player:SendBroadcastMessage(HTAG .. HIGH_RISK[zone] .. " is a High-Risk zone: +50% experience and double rare loot, " ..
                "but if you die you drop an item from your bags for anyone to take.")
        end
    end)
    RegisterCreatureGossipEvent(BOUNTY_NPC, 1, function(_, player, creature) BountyShow(player, creature) end)
    RegisterCreatureGossipEvent(BOUNTY_NPC, 2, BountySelect)
    local function RegisterSatchel() RegisterGameObjectEvent(SATCHEL, 14, OnSatchel) end
    if not pcall(RegisterSatchel) then RegisterServerEvent(14, RegisterSatchel) end
    print("[ascension] rares, bounties and High-Risk zones loaded")
end
