-- GetHealth / GetMaxHealth return a 64-bit userdata on this Eluna (Midnight health is uint64): plain Lua arithmetic needs a number
local function Num(v) return tonumber(tostring(v)) or 0 end
-- CoA necromancer minion engine (port of AscensionNecromancerSummons.cpp: Responds / Order / DoAction / Scale).
-- Spell and creature ids are CoA ids; Midnight ids = 7000000 + CoA id.
local function Hostile(a, b)   -- this Eluna has no IsHostileTo: different faction and not a's own pet / minion
    if not b or b == a or b:GetGUID() == a:GetGUID() then return false end
    local o = b.GetOwner and b:GetOwner()
    if o and o:GetGUID() == a:GetGUID() then return false end
    return b:GetFaction() ~= a:GetFaction()
end

local OFF = 7000000
MINION_DMG_MULT = 3.5   -- tuning knob: CoA's creature auto attack is stronger than the bare weapon-damage formula; raise / lower after testing
DEBUG_MINIONS = false   -- per-hit console print; only for a quick look at the damage numbers
DEBUG_SCALE = true      -- one log line per summoned minion with level / health before and after scaling (turn off once confirmed)
local PACIFY = OFF + 500983

-- creature (CoA id) -> {health share of the owner, ranged}
local MINION = {
    [50065] = {0.54}, [51065] = {0.54}, [50073] = {0.66}, [50075] = {0.66, true}, [50115] = {0.79}, [50323] = {0.94, true},
    [50068] = {1.38}, [51275] = {1.44}, [50177] = {2.53, true}, [50067] = {0.94, true}, [50076] = {0.66, true}, [50078] = {0.66},
    [500650] = {0.94}, [50309] = {0.94}, [50261] = {0.94}, [50320] = {1.38}, [50385] = {1.38}, [503200] = {0.94},
    [500482] = {4.0}, [500483] = {4.0}, [500484] = {4.0}, [50133] = {0.54}, [50303] = {0.54},
    [50130] = {0.62, true},   -- Skeletal Archer (Animate: Skeletal Archers): Lesser Skeletal Warrior model, bow + quiver, shoots
    -- Swarm Call (Severed Covenant): one creature per tier, random look from its retail model pool per spawn
    [50140] = {0.30}, [50141] = {0.30}, [50142] = {0.54, true},                              -- Swarmite / Skitterling / Crypt Fiend
    [50143] = {0.94}, [50144] = {0.66, true}, [50145] = {0.66},                              -- Royal Warrior / Mage / Rogue
    [50146] = {0.66, true}, [50147] = {0.66, true},                                          -- Royal Priest / Hunter
    [50148] = {1.38}, [50149] = {1.38},                                                      -- Crypt Lord (80 / 85)
    [50150] = {0.94}, [50151] = {0.66, true}, [50152] = {0.66}, [50155] = {0.66, true},      -- Royal 90: Warrior / Mage / Rogue / Priest
    [50154] = {2.53},                                                                        -- Nerubian Hulk
    [50160] = {2.53},                                                                        -- Skyrazor (top Necrotic Call tank)
}
local STATIONARY = {[50132] = true, [542064] = true, [575091] = true}

-- Swarm Call summons: only stay alive for an owner who knows the Severed Covenant passive
local SWARM = {}
for _, e in ipairs({50140, 50141, 50142, 50143, 50144, 50145, 50146, 50147, 50148, 50149, 50150, 50151, 50152, 50154, 50155, 50160}) do SWARM[e] = true end
local COVENANT = 7991155

-- command spell (CoA id) -> creatures that answer it; "mobile" = every non-stationary minion
local RESPONDS = {
    [504020] = {50075}, [504489] = {50075}, [504021] = {50073}, [504052] = {50067}, [504318] = {50078}, [504319] = {50076},
    [504334] = {50065, 51065}, [504905] = {50065, 51065}, [504860] = {50323}, [504862] = {500650}, [504864] = {500650},
    [504050] = {50115}, [504863] = {50115}, [504316] = {50068}, [504865] = {50068},
    [500991] = "mobile", [504868] = "mobile", [504907] = "mobile", [504908] = "mobile", [805871] = "mobile",
}
RESPONDS[504319] = {50076, 50130}   -- Command: Skeletal Archers also orders the new armed archers
-- generic command: the ability each creature uses on the target (CoA DoAction)
local ABILITY = {
    [50065] = 570042, [51065] = 570042, [50073] = 801514, [50068] = 504022, [50067] = 707598, [50133] = 801518, [50303] = 801518,
    [50076] = 801516, [50323] = 822074, [500650] = 572211, [50075] = 801513, [500484] = 801513, [50309] = 801412,
}

-- Rolled archer abilities (retail Midnight ids, NOT CoA ids: no +7000000 offset).
local ARROW_BARRAGE  = 1308116   -- Arrow Barrage, instant -> fired at most once per second by the timer below
local SANDBURST      = 1292623   -- Sandburst Arrow, instant -> once per minute
local BLIGHTED_ARROW = 1239356   -- Blighted Arrow, the plain shot between the two above
local ARCHER_SANDBURST_MS = 60000
local ARCHER = {[50130] = true}

local function Answers(entry, command)
    local r = RESPONDS[command]
    if r == "mobile" then return not STATIONARY[entry] end
    if r then for _, e in ipairs(r) do if e == entry then return true end end end
    return false
end

local function Minions(p)   -- every creature this necromancer owns within 60 yards
    local out = {}
    local ok, list = pcall(function() return p:GetCreaturesInRange(60) end)
    if ok and list then
        for _, c in ipairs(list) do
            local o, e = c:GetOwner(), c:GetEntry() - OFF
            if o and o:GetGUID() == p:GetGUID() and c:IsAlive() and (MINION[e] or STATIONARY[e]) then
                out[#out + 1] = c
            end
        end
    end
    return out
end

local function Cast(c, target, spell) pcall(function() c:CastSpell(target, OFF + spell, true) end) end
local function CastRaw(c, target, spell) pcall(function() c:CastSpell(target, spell, true) end) end

local function Order(p, target, command)   -- CoA Order + DoAction
    if not target or not target:IsAlive() or p:HasAura(PACIFY) or not Hostile(p, target) then return end
    for _, c in ipairs(Minions(p)) do
        local entry = c:GetEntry() - OFF
        local m = MINION[entry]
        if Answers(entry, command) and (not (m and m[2]) or c:IsWithinDistInMap(target, 40)) then
            pcall(function() c:AttackStart(target) end)
            if ARCHER[entry] then
                -- the archers' own 1 s timer picks the shot
            elseif command == 504316 then Cast(c, target, 800043)                  -- Command: Hook (Abomination pulls the target)
            elseif command == 504489 then Cast(c, target, 504845)              -- Command: Bonefreeze (Skeletal Mage)
            elseif command == 504050 then Cast(c, c, 801534)                   -- Command: Blight (Decaying Colossus)
            elseif command ~= 500991 and ABILITY[entry] then
                if entry == 50068 then Cast(c, c, ABILITY[entry]) else Cast(c, target, ABILITY[entry]) end
            end
        end
    end
end

RegisterPlayerEvent(5, function(_, player, spell)   -- ON_SPELL_CAST: command spells
    local id = spell:GetEntry() - OFF
    if not RESPONDS[id] then return end
    local ok, t = pcall(function() return spell:GetTarget() end)
    if not (ok and t and t.IsAlive) then t = player:GetVictim() end
    if not t then t = player:GetSelection() end
    Order(player, t, id)
end)

-- CoA Scale: owner level, health = owner's health x share (cost weighted), owner faction, defensive.
-- Applied immediately on spawn (owner is already known there) and once more from the player side
-- (coa_necromancer_main.lua Adopt) if the spawn handler was not reached.
local function Scale(c, o, share)
    if not (c and o and o.GetLevel) then return false end
    pcall(function() c:SetLevel(o:GetLevel()) end)
    local okHp = pcall(function() local hp = math.max(1, math.floor(Num(o:GetMaxHealth()) * share)); c:SetMaxHealth(hp); c:SetHealth(hp) end)
    pcall(function() c:SetFaction(o:GetFaction()) end)
    pcall(function() c:SetReactState(1) end)   -- REACT_DEFENSIVE
    pcall(function() c:AddAura(OFF + 805015, c) end)
    if DEBUG_SCALE then
        local lvl, hp, want = -1, -1, -1
        pcall(function() lvl = c:GetLevel(); hp = Num(c:GetMaxHealth()); want = math.max(1, math.floor(Num(o:GetMaxHealth()) * share)) end)
        PrintInfo(string.format("[necro] scale %s(%d) lvl=%s hp=%s want=%s owner=%s/%s ok=%s",
            c:GetName(), c:GetEntry(), tostring(lvl), tostring(hp), tostring(want),
            tostring(o:GetLevel()), tostring(Num(o:GetMaxHealth())), tostring(okHp)))
    end
    return okHp
end
COA_SCALE_MINION = Scale   -- called from coa_necromancer_main.lua Adopt (guaranteed post-summon path)
function COA_SCALE_THIS(c, o)   -- same, but the health share is looked up from the creature entry
    local m = MINION[c:GetEntry() - OFF]
    return Scale(c, o, m and m[1] or 0.66)
end

-- Archer: one cast per second. Sandburst on its minute, Arrow Barrage / Blighted Arrow otherwise.
-- Instant spells would otherwise be spammed by the client-less creature AI, so the timer is the throttle.
local function ArcherLoop(c, share)
    local sand = 0            -- seconds until the next Sandburst Arrow
    local flip = false
    local ok = pcall(function()
        c:RegisterEvent(function(_, _, _, a)
            local ow = a:GetOwner()
            if not (ow and a:IsAlive()) or ow:HasAura(PACIFY) then return end
            local t = a:GetVictim() or ow:GetVictim()
            if not t then local ok2, sel = pcall(function() return ow:GetSelection() end); if ok2 then t = sel end end
            if not (t and t.IsAlive and t:IsAlive() and Hostile(ow, t) and (ow:IsInCombat() or a:IsInCombat())) then return end
            if not a:GetVictim() then pcall(function() a:AttackStart(t) end) end
            if a:GetDistance(t) > 35 then return end
            sand = sand - 1
            if sand <= 0 then
                sand = math.floor(ARCHER_SANDBURST_MS / 1000)
                CastRaw(a, t, SANDBURST)
            else
                flip = not flip
                CastRaw(a, t, flip and ARROW_BARRAGE or BLIGHTED_ARROW)
            end
        end, 1000, 0)
    end)
    if not ok then PrintInfo(string.format("[necro] archer timer unavailable for %d", c:GetEntry())) end
end

-- =====================================================================
-- Role abilities (retail Midnight spell ids, no +7000000 offset).
-- {spell, cooldown in seconds, mode, noBoss}
--   mode: nil / "victim" on the current target, "self" on the summon, "heal" for the Royal Priest
--   noBoss = true: a web / root / CC spell is never used on a dungeon or world boss
-- Every cast is pcall-guarded, so an id that is not a real spell in this build is a silent no-op.
-- =====================================================================
local ROLE = {
    [50148] = {{457868, 9}, {369823, 20, "self"}, {461134, 30}},                      -- Crypt Lord 80: Lurking Impale, Spiked Carapace, Carrion Beetles
    [50149] = {{457868, 9}, {369823, 20, "self"}, {461134, 30}},                      -- Crypt Lord 85
    [50154] = {{232210, 8}, {213526, 30}, {459637, 20, "self"}},                      -- Nerubian Hulk: Crushing Blow, Petrify, Chitinous Plating
    [50144] = {{1266568, 3}, {1317993, 12}, {1316702, 20}},                           -- Royal Mage: Shadow Bolt, Shadow Blast, Shadow Barrage
    [50151] = {{1266568, 3}, {1317993, 12}, {1316702, 20}},
    [50145] = {{1296896, 6}, {1247078, 15}, {440235, 30}},                            -- Royal Rogue: Shadow Bite, Shadow Jump, Kiss of Death
    [50152] = {{1296896, 6}, {1247078, 15}, {440235, 30}},
    [50147] = {{1264746, 6}, {228273, 10}},                                           -- Royal Hunter: Aimed Shot, Multi-Shot
    [50146] = {{299268, 8, "heal"}, {1254306, 15, "heal"}},                           -- Royal Priest: Shadow Mend, Power Word: Shield
    [50155] = {{299268, 8, "heal"}, {1254306, 15, "heal"}},
    [50142] = {{1266568, 3}, {458087, 20, "victim", true}},                           -- Crypt Fiend: Shadow Bolt, Web Blast
    [50141] = {{4962, 20, "victim", true}, {1266741, 20, "victim", true}},            -- Skitterling: Encasing Webs
    [50160] = {{449644, 12}, {461039, 20, "victim", true}, {1225375, 25, "victim", true}},  -- Skyrazor: Dive Bomb, Wing Buffet, Grabbing Web
}
local HEALER = {[50146] = true, [50155] = true}   -- no melee/shot damage tick, they only heal and shield

local function IsBoss(u)
    local ok, b = pcall(function() return u:IsDungeonBoss() end)
    if ok and b then return true end
    local ok2, b2 = pcall(function() return u:IsWorldBoss() end)
    return ok2 and (b2 == true)
end

local function Hurt(u, pct)
    if not (u and u.IsAlive and u:IsAlive()) then return false end
    local ok, mx = pcall(function() return Num(u:GetMaxHealth()) end)
    local ok2, hp = pcall(function() return Num(u:GetHealth()) end)
    if not (ok and ok2 and mx and hp and mx > 0) then return false end
    return (hp / mx) < pct
end

-- Royal Priest priority: owner, main tank, group, own summons (spec: owner -> tank -> group -> summons)
local function HealTarget(ow)
    if Hurt(ow, 0.60) then return ow end
    local ok, list = pcall(function() return ow:GetCreaturesInRange(40) end)
    local tank, low = nil, nil
    if ok and list then
        for _, c in ipairs(list) do
            local o = c:GetOwner()
            if o and o:GetGUID() == ow:GetGUID() and c:IsAlive() then
                local d = COA_LF and COA_LF.SUMMON and COA_LF.SUMMON[c:GetEntry() - OFF]
                if d then
                    if d.tank and Hurt(c, 0.70) then tank = c end
                    if not low and Hurt(c, 0.50) then low = c end
                end
            end
        end
    end
    if tank then return tank end
    local okg, grp = pcall(function() return ow:GetGroup() end)
    if okg and grp then
        local okm, mem = pcall(function() return grp:GetMembers() end)
        if okm and mem then
            for _, mm in ipairs(mem) do if Hurt(mm, 0.60) then return mm end end
        end
    end
    return low
end

local function RoleLoop(c, entry)
    local list, ready = ROLE[entry], {}
    for i = 1, #list do ready[i] = 1 end   -- first use after one second
    local ok = pcall(function()
        c:RegisterEvent(function(_, _, _, a)
            local ow = a:GetOwner()
            if not (ow and a:IsAlive()) or ow:HasAura(PACIFY) then return end
            for i, s in ipairs(list) do
                ready[i] = ready[i] - 1
                if ready[i] <= 0 then
                    local t
                    if s[3] == "self" then
                        t = a
                    elseif s[3] == "heal" then
                        t = HealTarget(ow)
                    else
                        t = a:GetVictim() or ow:GetVictim()
                        if not t then local ok2, sel = pcall(function() return ow:GetSelection() end); if ok2 then t = sel end end
                    end
                    if t and t.IsAlive and t:IsAlive() then
                        if s[3] ~= "self" and s[3] ~= "heal" then
                            if not (Hostile(ow, t) and (ow:IsInCombat() or a:IsInCombat())) then t = nil end
                        end
                        if t and s[4] and IsBoss(t) then t = nil end   -- never lock a boss down with a web
                        if t then
                            pcall(function() a:CastSpell(t, s[1], true) end)
                            ready[i] = math.max(1, s[2])
                        end
                    end
                end
            end
        end, 1000, 0)
    end)
    if not ok then PrintInfo(string.format("[necro] role timer unavailable for %d", c:GetEntry())) end
end

-- CoA Scale + combat loop. Creature events: ON_SPAWN.
for entry, m in pairs(MINION) do
    pcall(RegisterCreatureEvent, OFF + entry, 5, function(_, creature)   -- ON_SPAWN (pcall: some CoA creatures are not in this world DB)
        local o = creature:GetOwner()
        if not (o and o.GetLevel) then return end
        if SWARM[entry] then   -- Severed Covenant gate: no passive, no minion
            local ok2, has = pcall(function() return o:HasAura(COVENANT) or o:HasSpell(COVENANT) end)
            if ok2 and not has then
                pcall(function() creature:DespawnOrUnsummon(0) end)
                return
            end
        end
        Scale(creature, o, m[1])
        if ROLE[entry] then RoleLoop(creature, entry) end
        if HEALER[entry] then return end   -- the Royal Priest heals and shields, it does not swing
        if ARCHER[entry] then return end   -- CoA archers shoot their AttackSpell 800609 (coa_necro_behaviors.lua), not retail arrows   -- archers deal damage with arrows, not with the melee swing
        local weight = math.max(1, math.floor(m[1] / 0.46 + 0.5))   -- CoA cost weight (1 / 2 / 3 / 4) from the health share
        local lvl = o:GetLevel()
        creature:RegisterEvent(function(_, _, _, a)   -- minion combat: CoA-style weapon damage dealt directly every 2 s
            local ow = a:GetOwner()
            if not (ow and a:IsAlive()) or ow:HasAura(PACIFY) then return end   -- Undead: Pacify = minions stay passive
            local t = a:GetVictim() or ow:GetVictim()
            if not t then local ok, sel = pcall(function() return ow:GetSelection() end); if ok then t = sel end end   -- a caster has no melee victim: use the owner's target
            if not (t and t.IsAlive and t:IsAlive() and Hostile(ow, t) and (ow:IsInCombat() or a:IsInCombat())) then return end
            local reach = m[2] and 35 or 6
            if not a:GetVictim() then pcall(function() a:AttackStart(t) end) end
            if a:GetDistance(t) > reach then return end
            local ap = (ow:GetStat(3) or 0) * 0.4 * weight   -- (intellect + spell power) x 0.4 x weight, CoA Scale()
            local dmg = math.max(1, math.floor((math.random(ow:GetLevel() * weight, math.floor(ow:GetLevel() * weight * 1.5)) + ap / 14 * 2) * MINION_DMG_MULT))
            local ok = pcall(function() a:DealDamage(t, dmg, false, 0) end)
            pcall(function() t:AddThreat(a, dmg * 4) end)   -- tanking: enemies prefer the minion over its owner
            if DEBUG_MINIONS then print(string.format("[minion] %s -> %s dmg %d ok %s", a:GetName(), t:GetName(), dmg, tostring(ok))) end
        end, 2000, 0)
    end)
end
print("[coa_necro_minions] loaded")
