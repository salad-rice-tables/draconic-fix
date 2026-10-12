-- Nemesis: the humanoid that kills you in the open world is promoted, remembers you and later hunts you. Self-contained (own table, own locals).
-- Visible to everyone (no personal phasing in Eluna), but it only hunts its victim and has the victim's name in its yells.
local TAG = "|cffc41e3a[Nemesis]|r "
local HUNT_EVERY = 12 * 60 * 1000          -- how often a living nemesis looks for its victim
local MIN_LEVEL = 5
pcall(CharDBExecute, "CREATE TABLE IF NOT EXISTS characters.nemesis (name VARCHAR(48) NOT NULL PRIMARY KEY, entry INT NOT NULL, nname VARCHAR(64) NOT NULL, affix TINYINT NOT NULL DEFAULT 1, victories INT NOT NULL DEFAULT 1, created TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")

local FIRST = {"Gruul", "Skarn", "Vok", "Brakka", "Dorn", "Mogu", "Razzik", "Hulk", "Tarn", "Borgul"}
local LAST = {"the Face-Smasher", "the Merciless", "the Hungry", "Bonecrusher", "the Unforgiven", "Skullsplitter", "the Relentless", "Gutripper"}
-- affixes follow the class that fell: casters meet a warded foe, melee a thick-skinned one, the rest a frenzied one
local AFFIX = {[1] = "Thick-Skinned", [2] = "Warded", [3] = "Frenzied"}
local CASTERS = {[5] = true, [8] = true, [9] = true, [11] = true, [13] = true}
local MELEE = {[1] = true, [2] = true, [6] = true, [4] = true, [12] = true, [10] = true}
local function AffixFor(cls) return CASTERS[cls] and 2 or (MELEE[cls] and 1 or 3) end

local HUNTED = {}        -- spawned hunter guid -> victim name
local CACHE = {}         -- victim name -> {entry, nname, affix, victories} (nil = none)

local function Load(name)
    if CACHE[name] ~= nil then return CACHE[name] or nil end
    local ok, r = pcall(CharDBQuery, string.format("SELECT entry, nname, affix, victories FROM characters.nemesis WHERE name = '%s'", name))
    if ok and r then CACHE[name] = {entry = r:GetUInt32(0), nname = r:GetString(1), affix = r:GetUInt32(2), victories = r:GetUInt32(3)}
    else CACHE[name] = false end
    return CACHE[name] or nil
end
local function Drop(name)
    CACHE[name] = false
    pcall(CharDBExecute, string.format("DELETE FROM characters.nemesis WHERE name = '%s'", name))
end

local function ApplyAffix(c, affix, level)
    pcall(function()
        c:SetScale(1.35)
        c:SetLevel(level)
        local hp = c:GetMaxHealth() * (affix == 1 and 5 or 3)
        c:SetMaxHealth(hp); c:SetHealth(hp)
        if affix == 2 then   -- warded: a power-word shield on itself now and then
            c:RegisterEvent(function(_, _, _, u) if u and u:IsAlive() and u:IsInCombat() then u:CastSpell(u, 17, true) end end, 15000, 0)
        elseif affix == 3 then   -- frenzied: enrage now and then
            c:RegisterEvent(function(_, _, _, u) if u and u:IsAlive() and u:IsInCombat() then u:CastSpell(u, 8599, true) end end, 20000, 0)
        end
    end)
end

-- a humanoid kills a player in the open world: it becomes that player's nemesis
RegisterPlayerEvent(8, function(_, killer, killed)
    local ok = pcall(function()
        if not killer or not killed or killed:GetLevel() < MIN_LEVEL then return end
        if killer:GetOwner() then return end                                        -- pets and guardians do not count
        if killer:GetCreatureType() ~= 7 then return end                             -- humanoids only
        if killer:GetEntry() >= 9900000 or killer:IsWorldBoss() then return end     -- custom NPCs and world bosses are left alone
        local map = killed:GetMap()
        if map:IsDungeon() or map:IsRaid() or map:IsBattleground() then return end
        local name = killed:GetName()
        local cur = Load(name)
        if cur then   -- a nemesis already waits: it only grows stronger
            pcall(CharDBExecute, string.format("UPDATE characters.nemesis SET victories = victories + 1 WHERE name = '%s'", name))
            cur.victories = cur.victories + 1
            return
        end
        local nname = FIRST[math.random(#FIRST)] .. " " .. LAST[math.random(#LAST)]
        local affix = AffixFor(killed:GetClass())
        local e = killer:GetEntry()
        pcall(CharDBExecute, string.format("REPLACE INTO characters.nemesis (name, entry, nname, affix, victories) VALUES ('%s', %d, '%s', %d, 1)", name, e, nname, affix))
        CACHE[name] = {entry = e, nname = nname, affix = affix, victories = 1}
        ApplyAffix(killer, affix, killed:GetLevel() + 1)
        pcall(function() killer:SendUnitYell("You will remember the name " .. nname .. ", " .. name .. "!", 0) end)
        killed:SendBroadcastMessage(TAG .. "|cffffd200" .. nname .. "|r now hunts you (" .. AFFIX[affix] .. "). It will find you again.")
    end)
    if not ok then print("[nemesis] death hook failed") end
end)

-- the hunt: now and then a living nemesis appears close to its victim
local function Hunt(player)
    if not player or not player:IsInWorld() or not player:IsAlive() then return end
    local name = player:GetName()
    local n = Load(name)
    if not n then return end
    local map = player:GetMap()
    if map:IsDungeon() or map:IsRaid() or map:IsBattleground() or player:IsInCombat() or player:GetLevel() < MIN_LEVEL then return end
    for g, v in pairs(HUNTED) do if v == name then return end end   -- one hunter at a time
    local ang = math.random() * 6.2832
    local x, y = player:GetX() + 28 * math.cos(ang), player:GetY() + 28 * math.sin(ang)
    local z = map:GetHeight(x, y) or player:GetZ()
    local c = player:SpawnCreature(n.entry, x, y, z, ang + 3.14, 1, 900000)
    if not c then return end
    HUNTED[c:GetGUIDLow()] = name
    ApplyAffix(c, n.affix, player:GetLevel() + 1)
    c:SetFaction(14)
    c:SendUnitYell("Did you think you could run from me, " .. name .. "?!", 0)
    player:SendBroadcastMessage(TAG .. "|cffffd200" .. n.nname .. "|r has found you!")
    c:AttackStart(player)
end

RegisterPlayerEvent(3, function(_, player)   -- login: start the hunting timer
    if not Load(player:GetName()) then return end
    player:RegisterEvent(function(_, _, _, p) Hunt(p) end, HUNT_EVERY, 0)
end)

-- the nemesis falls: reward, and the victim is free
RegisterPlayerEvent(7, function(_, killer, victim)
    local ok = pcall(function()
        local g = victim:GetGUIDLow()
        local owner = HUNTED[g]
        if not owner then return end
        HUNTED[g] = nil
        local n = Load(owner)
        Drop(owner)
        local lvl = killer:GetLevel()
        killer:ModifyMoney(lvl * 5000)
        killer:SendBroadcastMessage(TAG .. "|cff40ff40" .. (n and n.nname or "The nemesis") .. " falls!|r Reward: " .. lvl * 50 .. " silver. " .. owner .. " is free of it.")
        local victimPlayer = GetPlayerByName and GetPlayerByName(owner)
        if victimPlayer and victimPlayer:GetName() ~= killer:GetName() then victimPlayer:SendBroadcastMessage(TAG .. "Your nemesis was slain.") end
    end)
    if not ok then print("[nemesis] kill hook failed") end
end)
