-- Primary stat of a Hero (Character Advancement, as on Ascension): Strength, Agility, Intellect or Spirit. The choice is kept per character in
-- characters.hero_primary and shows as a hidden passive aura (hotfix spells 1409031-1409034, made by scratchpad/primary_stat_spells.py) that
-- grows with the level. The client window sends PSTAT;n (1-4, 0 = just tell me) and answers with PSTAT;n.
if IS_WORLD_STATE then return end

local PREFIX = "WCARD"
local AURAS = {1409031, 1409032, 1409033, 1409034}
pcall(CharDBExecute, "CREATE TABLE IF NOT EXISTS characters.hero_primary (guid INT UNSIGNED NOT NULL PRIMARY KEY, stat TINYINT NOT NULL DEFAULT 0)")

local function Get(player)
    local ok, r = pcall(CharDBQuery, "SELECT stat FROM characters.hero_primary WHERE guid = " .. tostring(player:GetGUIDLow()))
    if ok and r then return r:GetUInt32(0) end
    return 0
end

local function Tell(player, n)
    pcall(function() player:SendAddonMessage(PREFIX, "PSTAT;" .. n, 7, player) end)
end

local function Apply(player, n)
    for i, id in ipairs(AURAS) do
        pcall(function() player:RemoveAura(id) end)
    end
    if n >= 1 and n <= 4 then pcall(function() player:AddAura(AURAS[n], player) end) end
end

RegisterPlayerEvent(3, function(_, player)   -- login
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local n = Get(p)
        Apply(p, n); Tell(p, n)
    end, 2500, 1)
end)
RegisterPlayerEvent(13, function(_, player)   -- level change: the points are worked out when the aura is applied
    player:RegisterEvent(function(_, _, _, p) if p and p:IsInWorld() then Apply(p, Get(p)) end end, 800, 1)
end)
RegisterPlayerEvent(28, function(_, player)   -- map change
    player:RegisterEvent(function(_, _, _, p)
        if p and p:IsInWorld() then
            local n = Get(p)
            if n >= 1 and not p:HasAura(AURAS[n]) then Apply(p, n) end
        end
    end, 1500, 1)
end)

RegisterServerEvent(30, function(_, sender, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    local n = string.match(msg, "^PSTAT;(%d)")
    if not n then return end
    n = tonumber(n)
    local ok, isPlayer = pcall(function() return sender:GetGUIDLow() ~= nil and sender.LearnSpell ~= nil end)
    if not ok or not isPlayer then return end
    if n == 0 then Tell(sender, Get(sender)) return end
    if n > 4 then return end
    pcall(CharDBExecute, string.format("REPLACE INTO characters.hero_primary (guid, stat) VALUES (%d, %d)", sender:GetGUIDLow(), n))
    Apply(sender, n); Tell(sender, n)
    pcall(function() sender:SendBroadcastMessage("|cffffd200[Hero]|r Primary stat chosen. You can change it any time.") end)
end)
print("[primary_stat] loaded")
