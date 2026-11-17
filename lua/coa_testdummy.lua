-- GM test helper: ".dummy" spawns a hostile Target Dummy with lots of health 6 yards in front of the GM, ".dummy clear" removes the dummies of that player.
-- Used to test the CoA class spells (damage, minions, buffs) in game. GM rank 1+ only.
local DUMMY = 2673
local made = {}

RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "dummy" or player:GetGMRank() < 1 then return end
    local key = player:GetGUIDLow()
    if string.lower(a[2] or "") == "clear" then
        for _, c in ipairs(made[key] or {}) do pcall(function() c:DespawnOrUnsummon(0) end) end
        made[key] = {}
        player:SendBroadcastMessage("[dummy] removed")
        return false
    end
    local o = player:GetO()
    local x, y, z = player:GetX() + 6 * math.cos(o), player:GetY() + 6 * math.sin(o), player:GetZ()
    local c = player:SpawnCreature(DUMMY, x, y, z, o + math.pi, 8)   -- 8 = manual despawn
    if c then
        pcall(function() c:SetFaction(14) end)                       -- hostile to everyone
        pcall(function() c:SetLevel(math.max(1, player:GetLevel())) end)
        pcall(function() c:SetMaxHealth(50000000); c:SetHealth(50000000) end)
        made[key] = made[key] or {}
        made[key][#made[key] + 1] = c
        player:SendBroadcastMessage("[dummy] spawned (50M health, hostile). .dummy clear removes it")
    else
        player:SendBroadcastMessage("[dummy] spawn failed")
    end
    return false
end)

-- ".ncast <CoA spell id>": GM test, casts the spell (+7000000) on yourself as a triggered cast and tells how many of your minions stand nearby after 2 s.

local function NewestDummy(p)
    local best, bg = nil, -1
    local ok, l = pcall(function() return p:GetCreaturesInRange(30) end)
    for _, c in ipairs(ok and l or {}) do
        if c:GetEntry() == 2673 and c:IsAlive() then
            local g = tonumber(tostring(c:GetGUIDLow())) or 0
            if g > bg then best, bg = c, g end
        end
    end
    return best
end
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "ncast" or player:GetGMRank() < 1 then return end
    local id = (tonumber(a[2]) or 0) + 7000000
    local rp0 = 0
    rp0 = tonumber(tostring(player:GetPower(6))) or -1
    local real = a[3] == "real"
    local tgt = player
    if real then
        tgt = player:GetSelection()
        if not tgt then
            tgt = NewestDummy(player)
        end
        tgt = tgt or player
    end
    local okc, err
    if a[3] == "add" then
        tgt = NewestDummy(player)
        if tgt then okc, err = pcall(function() player:AddAura(id, tgt) end) end
    elseif a[3] == "remove" then
        tgt = NewestDummy(player)
        if tgt then okc, err = pcall(function() tgt:RemoveAura(id) end) end
    elseif a[3] == "self" then okc, err = pcall(function() player:SetPower(900, 6); player:CastSpell(player, id, false) end)
    elseif a[3] == "ground" then okc, err = pcall(function() player:CastSpellAoF(player:GetX() + 3, player:GetY(), player:GetZ(), id, true) end)
    else okc, err = pcall(function() player:CastSpell(tgt, id, not real) end) end
    player:RegisterEvent(function(_, _, _, p)
        local n, names = 0, {}
        local ok, list = pcall(function() return p:GetCreaturesInRange(60) end)
        for _, c in ipairs(ok and list or {}) do
            local o = c:GetOwner()
            if o and tostring(o:GetGUIDLow()) == tostring(p:GetGUIDLow()) then n = n + 1; names[#names + 1] = c:GetName() .. "[A" .. (c:HasAura(7500982) and 1 or 0) .. " Pa" .. (c:HasAura(7500983) and 1 or 0) .. " Pr" .. (c:HasAura(7500985) and 1 or 0) .. " react " .. tostring(pcall(function() return c:GetReactState() end) and c:GetReactState() or "?") .. "]" end
            if c:GetEntry() >= 7000000 and not (o and tostring(o:GetGUIDLow()) == tostring(p:GetGUIDLow())) then names[#names + 1] = c:GetName() .. "(entry " .. c:GetEntry() .. ", no owner)" end
        end
        p:SendBroadcastMessage(string.format("[ncast] %d minions: %s | runic power %d -> %d (max %s)", n, table.concat(names, ", "), rp0, tonumber(tostring(p:GetPower(6))) or -1, tostring(p:GetMaxPower(6))) .. (function() local d = NewestDummy(p); if d then local pa = d:GetAura(7570131); return " | plague stacks " .. (pa and pa:GetStackAmount() or 0) .. " | spell cooldown ms " .. tostring(tonumber(tostring(p:GetSpellCooldownDelay(id))) or -1) .. " | dummy has Razorice " .. tostring(d:HasAura(7500967)) .. " Mandate " .. tostring(d:HasAura(7800199)) .. " | me Razorice " .. tostring(p:HasAura(7500967)) .. " | LFaura " .. tostring(p:HasAura(1400011)) .. " talent92121 " .. tostring(p:HasAura(7092121)) end return "" end)())
    end, 2000, 1)
    return false
end)

-- ".nhit <amount> [minion]": GM test, the nearest dummy deals <amount> damage to you (or to your first minion with "minion") so the Necromancer defence hooks can be seen.
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "nhit" or player:GetGMRank() < 1 then return end
    local dmg, dummy, minion = tonumber(a[2]) or 1000, nil, nil
    local ok, l = pcall(function() return player:GetCreaturesInRange(40) end)
    for _, c in ipairs(ok and l or {}) do
        if c:GetEntry() == 2673 and not dummy then dummy = c end
        local o = c:GetOwner()
        if o and tostring(o:GetGUIDLow()) == tostring(player:GetGUIDLow()) and not minion then minion = c end
    end
    if not dummy then player:SendBroadcastMessage("[nhit] no dummy, use .dummy"); return false end
    local victim = (a[3] == "minion") and minion or player
    if not victim then player:SendBroadcastMessage("[nhit] no minion"); return false end
    local before = tostring(victim:GetHealth())
    pcall(function() dummy:DealDamage(victim, dmg, false, 0) end)
    player:SendBroadcastMessage(string.format("[nhit] %s took hit %d: health %s -> %s", victim:GetName(), dmg, before, tostring(victim:GetHealth())))
    return false
end)

-- ".nvir": GM test of Virulency / Infest. Spawns dummies A and B, plagues A, casts Virulency on A, Infest on B, reports the diseases B got.
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "nvir" or player:GetGMRank() < 1 then return end
    local o = player:GetO()
    local function Spawn(off)
        local c = player:SpawnCreature(2673, player:GetX() + 6 * math.cos(o) + off, player:GetY() + 6 * math.sin(o) + off, player:GetZ(), o + math.pi, 8)
        if c then pcall(function() c:SetFaction(14); c:SetMaxHealth(50000000); c:SetHealth(50000000) end) end
        return c
    end
    local A, B = Spawn(0), Spawn(3)
    if not (A and B) then player:SendBroadcastMessage("[nvir] spawn failed"); return false end
    pcall(function() player:ResetSpellCooldown(7801938, true); player:ResetSpellCooldown(7803781, true) end)
    player:RegisterEvent(function(_, _, _, p) pcall(function() p:AddAura(7570131, A) end) end, 3000, 1)
    player:RegisterEvent(function(_, _, _, p) pcall(function() p:SetSelection(A:GetGUID()); p:CastSpell(A, 7801938, true) end) end, 5000, 1)
    player:RegisterEvent(function(_, _, _, p) pcall(function() p:SetSelection(B:GetGUID()); p:CastSpell(B, 7803781, true) end) end, 7000, 1)
    player:RegisterEvent(function(_, _, _, p)
        local pa = B:GetAura(7570131)
        p:SendBroadcastMessage("[nvir] dummy B has Crypt Plague stacks: " .. (pa and pa:GetStackAmount() or 0) .. " | Infest known " .. tostring(p:HasSpell(7803781)))
        pcall(function() A:DespawnOrUnsummon(0); B:DespawnOrUnsummon(0) end)
    end, 9000, 1)
    return false
end)

-- ".ntest": GM smoke test of the Necromancer kit. Every summon spell is cast, the creature is looked up (entry, owner, scaled health), then removed;
-- afterwards the zombie / muckworm raising procs are exercised on a dummy. Result: chat + Custom/logs/necro_test.txt. All timing is server side.
local OFFN = 7000000
local SUMMONS = {   -- CoA spell, CoA creature entry, label
    {500970, 50065, "Lesser Skeletal Warrior"}, {504901, 51065, "Greater Skeletal Warrior"}, {500969, 50078, "Skeletal Rogue"},
    {500331, 50075, "Skeletal Mage"}, {500330, 50130, "Skeletal Archer (x3)"}, {500971, 50073, "Ghoul"}, {500335, 50068, "Abomination"},
    {500329, 50067, "Gargoyle"}, {500989, 50115, "Decaying Colossus"}, {504861, 500650, "Banshee"}, {504859, 50323, "Crypt Fiend"},
    {504505, 50385, "Plaguefather"}, {500933, 50132, "Phylactery"}, {504313, 503030, "Lesser Zombie"}, {525379, 503031, "Zombie"},
    {525380, 503032, "Greater Zombie"}, {520367, 50133, "Bone Bomb"}, {561316, 51275, "Rotting Frost Giant"}, {504682, 50065, "Skeletal Warrior (talent)"},
}
local function Owned(p, entry)
    local out = {}
    local ok, l = pcall(function() return p:GetCreaturesInRange(60) end)
    for _, c in ipairs(ok and l or {}) do
        if c:GetEntry() == OFFN + entry then
            local o = c:GetOwner()
            if o and tostring(o:GetGUIDLow()) == tostring(p:GetGUIDLow()) then out[#out + 1] = c end
        end
    end
    return out
end
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "ntest" or player:GetGMRank() < 1 then return end
    local res, i = {}, 0
    local function Log(s) res[#res + 1] = s end
    local function Done()
        local f = io.open("C:/WowServer/Custom/logs/necro_test.txt", "w")
        if f then f:write(table.concat(res, "\n") .. "\n"); f:close() end
        player:SendBroadcastMessage("[ntest] finished: " .. #res .. " lines in Custom/logs/necro_test.txt")
    end
    local function Next()
        i = i + 1
        local s = SUMMONS[i]
        if not s then
            -- proc test: muckworm talent + periodic plague damage on a dummy
            local o = player:GetO()
            local d = player:SpawnCreature(2673, player:GetX() + 6 * math.cos(o), player:GetY() + 6 * math.sin(o), player:GetZ(), o + math.pi, 8)
            if d then pcall(function() d:SetFaction(14); d:SetMaxHealth(50000000); d:SetHealth(50000000) end) end
            pcall(function() player:CastSpell(player, OFFN + 806086, true) end)   -- Muck Summoner talent aura
            pcall(function() player:CastSpell(player, OFFN + 807700, true) end)
            player:RegisterEvent(function(_, _, _, p) pcall(function() p:AddAura(OFFN + 570131, d) end) end, 2000, 1)
            for t = 1, 6 do
                player:RegisterEvent(function(_, _, _, p) pcall(function() p:AddAura(OFFN + 570131, d) end) end, 2000 + t * 3000, 1)
            end
            player:RegisterEvent(function(_, _, _, p)
                local mw, zb = #Owned(p, 806087), #Owned(p, 302586)
                Log(string.format("PROC Muck Summoner (806086) / Lesser Zombie (807700) after ~20 s of plague ticks: muckworms %d, lesser zombies %d  [%s]", mw, zb, (mw + zb > 0) and "PASS" or "no proc seen (chance based)"))
                pcall(function() d:DespawnOrUnsummon(0) end)
                Done()
            end, 22000, 1)
            return
        end
        pcall(function() player:CastSpell(player, OFFN + s[1], true) end)
        player:RegisterEvent(function(_, _, _, p)
            local list = Owned(p, s[2])
            if #list == 0 then
                Log(string.format("FAIL  %-28s spell %d: no owned creature %d appeared", s[3], s[1], s[2]))
            else
                local c = list[1]
                local hp = tonumber(tostring(c:GetMaxHealth())) or 0
                Log(string.format("PASS  %-28s spell %d: %d spawned, level %d, health %d, faction %s", s[3], s[1], #list, c:GetLevel(), hp, tostring(c:GetFaction() == p:GetFaction())))
            end
            for _, c in ipairs(list) do pcall(function() c:DespawnOrUnsummon(0) end) end
            p:RegisterEvent(function() Next() end, 3500, 1)
        end, 1500, 1)
    end
    do   -- start clean: dismiss every minion of this player so Life Force capacity is free
        local okc, lc = pcall(function() return player:GetCreaturesInRange(60) end)
        for _, c in ipairs(okc and lc or {}) do
            local o = c:GetOwner()
            if o and tostring(o:GetGUIDLow()) == tostring(player:GetGUIDLow()) then pcall(function() c:DespawnOrUnsummon(0) end) end
        end
    end
    player:SendBroadcastMessage("[ntest] running " .. #SUMMONS .. " summon checks + proc test, ~50 s")
    Next()
    return false
end)

-- ".nproc": GM test of the C++ proc layer with proc chances forced to 100 (hotfixes.coa_procchance_bak holds the real values).
-- Gives the talent auras, fights a dummy with plague ticks + Lichfrost casts, then reports which procs fired.
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "nproc" or player:GetGMRank() < 1 then return end
    local O = 7000000
    for _, t in ipairs({806086, 807700, 705750, 560730, 561319, 531135, 806321, 92121}) do pcall(function() player:CastSpell(player, O + t, true) end) end
    pcall(function() player:CastSpell(player, O + 500971, true) end)   -- a Ghoul to fight
    local o = player:GetO()
    local d = player:SpawnCreature(2673, player:GetX() + 6 * math.cos(o), player:GetY() + 6 * math.sin(o), player:GetZ(), o + math.pi, 8)
    if d then pcall(function() d:SetFaction(14); d:SetMaxHealth(50000000); d:SetHealth(50000000) end) end
    for t = 1, 8 do
        player:RegisterEvent(function(_, _, _, p)
            pcall(function() p:AddAura(O + 570131, d) end)
            pcall(function() p:SetSelection(d:GetGUID()); p:CastSpell(d, O + 801722, true) end)
        end, 1500 + t * 2500, 1)
    end
    player:RegisterEvent(function(_, _, _, p)
        local function Count(entry)
            local n = 0
            local ok, l = pcall(function() return p:GetCreaturesInRange(60) end)
            for _, c in ipairs(ok and l or {}) do if c:GetEntry() == O + entry then n = n + 1 end end
            return n
        end
        local function Has(unit, id) return unit:HasAura(O + id) and "yes" or "no" end
        p:SendBroadcastMessage(string.format("[nproc] muckworms %d | lesser zombies %d | target Parasites(560729) %s | me 705751 %s | target 706732 %s | plague stacks %s",
            Count(806087), Count(302586), Has(d, 560729), Has(p, 705751), Has(d, 706732), tostring((d:GetAura(O + 570131) and d:GetAura(O + 570131):GetStackAmount()) or 0)))
        pcall(function() d:DespawnOrUnsummon(0) end)
    end, 26000, 1)
    player:SendBroadcastMessage("[nproc] running 26 s")
    return false
end)

-- ".ncorpse": GM test of Corpse Explosion (533236). Kills a boar (corpse), puts a live hostile dummy next to it, casts the spell, reports the dummy's damage and whether the corpse was consumed.
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "ncorpse" or player:GetGMRank() < 1 then return end
    local o = player:GetO()
    local x, y, z = player:GetX() + 5 * math.cos(o), player:GetY() + 5 * math.sin(o), player:GetZ()
    local boar = player:SpawnCreature(3098, x, y, z, o, 8)
    local dummy = player:SpawnCreature(2673, x + 3, y, z, o, 8)
    if not (boar and dummy) then player:SendBroadcastMessage("[ncorpse] spawn failed"); return false end
    pcall(function() dummy:SetFaction(14); dummy:SetMaxHealth(50000000); dummy:SetHealth(50000000) end)
    pcall(function() boar:DealDamage(boar, 10000000, false, 0) end)
    local before = tonumber(tostring(dummy:GetHealth())) or 0
    player:RegisterEvent(function(_, _, _, p) pcall(function() p:CastSpell(p, 7533236, true) end) end, 2500, 1)
    player:RegisterEvent(function(_, _, _, p)
        local after = tonumber(tostring(dummy:GetHealth())) or 0
        p:SendBroadcastMessage(string.format("[ncorpse] dummy health %d -> %d (damage %d) | boar corpse still there: %s", before, after, before - after, (function() local ok, r = pcall(function() return boar:IsInWorld() and boar:IsDead() end); if not ok then return "no (corpse consumed)" end return tostring(r) end)()))
        pcall(function() dummy:DespawnOrUnsummon(0); boar:DespawnOrUnsummon(0) end)
    end, 5000, 1)
    return false
end)

-- ".nunlearn <id> [id...]": GM, removes spells (CoA ids +7000000) from yourself.
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "nunlearn" or player:GetGMRank() < 1 then return end
    for i = 2, #a do pcall(function() player:RemoveSpell(tonumber(a[i])) end) end
    player:SendBroadcastMessage("[nunlearn] done")
    return false
end)

-- ".ncmd [spell]": GM test of the generic command (default Command: Undead 504868): raises a Warrior + Ghoul, orders them against a dummy, reports the damage the dummy took.
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "ncmd" or player:GetGMRank() < 1 then return end
    local O, id = 7000000, tonumber(a[2]) or 504868
    pcall(function() player:SetPower(900, 6) end)   -- Command: Undead costs 30 runic power
    local okc, lc = pcall(function() return player:GetCreaturesInRange(60) end)
    for _, c in ipairs(okc and lc or {}) do
        local o = c:GetOwner()
        if o and tostring(o:GetGUIDLow()) == tostring(player:GetGUIDLow()) then pcall(function() c:DespawnOrUnsummon(0) end) end
    end
    local o = player:GetO()
    local d = player:SpawnCreature(2673, player:GetX() + 6 * math.cos(o), player:GetY() + 6 * math.sin(o), player:GetZ(), o + math.pi, 8)
    if d then pcall(function() d:SetFaction(14); d:SetMaxHealth(50000000); d:SetHealth(50000000) end) end
    player:RegisterEvent(function(_, _, _, p) pcall(function() p:CastSpell(p, O + 500970, true); p:CastSpell(p, O + 500971, true) end) end, 3500, 1)
    local h0
    player:RegisterEvent(function(_, _, _, p)
        h0 = tonumber(tostring(d:GetHealth())) or 0
        pcall(function() p:SetPower(900, 6); p:SetSelection(d:GetGUID()); p:CastSpell(d, O + id, false) end)
    end, 7000, 1)
    player:RegisterEvent(function(_, _, _, p)
        local h1 = tonumber(tostring(d:GetHealth())) or 0
        p:SendBroadcastMessage(string.format("[ncmd] spell %d: dummy lost %d health in 8 s", id, h0 - h1))
        pcall(function() d:DespawnOrUnsummon(0) end)
    end, 15500, 1)
    player:SendBroadcastMessage("[ncmd] running ~16 s")
    return false
end)

-- ".nstance": casts Undead: Protect on yourself and lists which nearby creatures got the aura (real mobs vs summons)
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "nstance" or player:GetGMRank() < 1 then return end
    pcall(function() player:CastSpell(player, 7500985, true) end)
    player:RegisterEvent(function(_, _, _, p)
        local lines, n = {}, 0
        local ok, l = pcall(function() return p:GetCreaturesInRange(40) end)
        for _, c in ipairs(ok and l or {}) do
            local o = c:GetOwner()
            local mine = o and tostring(o:GetGUIDLow()) == tostring(p:GetGUIDLow())
            if c:HasAura(7500985) or c:GetEntry() < 1000000 then
                n = n + 1
                if n <= 12 then lines[#lines + 1] = string.format("%s(%d)%s=%s", c:GetName(), c:GetEntry(), mine and " [my summon]" or "", tostring(c:HasAura(7500985))) end
            end
        end
        p:SendBroadcastMessage("[nstance] Protect on: " .. table.concat(lines, "; "))
    end, 1500, 1)
    return false
end)
