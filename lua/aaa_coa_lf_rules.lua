-- Necromancer Life Force rules: the ONE place for capacity curve, costs, limits, tank exclusivity and the pure
-- validation logic. No game API in here, so tools/test_lf_rules.lua runs it with the stock lua interpreter.
-- coa_necromancer_main.lua (live registry, UI, enforcement) and coa_necro_minions.lua (AI) only read COA_LF.
-- ===== Necromancer Life Force: central, data-driven configuration =====
-- Capacity per player level: the last row whose level <= the player level wins.
COA_LF = COA_LF or {}
COA_LF.CAPACITY = { {1, 1}, {10, 3}, {20, 4}, {30, 4}, {40, 5}, {50, 5}, {60, 6}, {70, 7}, {80, 8}, {90, 12} }

-- Summon definition, keyed by the creature (CoA id = creature entry - 7000000):
--   cost  = Life Force occupied while the summon is alive
--   limit = maximum active copies
--   group = summon identity; spells that summon the same unit share one limit
--   tank  = main tank: only one of all tank=true units may be active
COA_LF.SUMMON = {
    [50065]  = {name = "Lesser Skeletal Warrior", cost = 1, limit = 4, group = "lesser"},
    [51065]  = {name = "Greater Skeletal Warrior", cost = 2, limit = 2, group = "greater"},
    [50078]  = {name = "Skeletal Rogue", cost = 1, limit = 3, group = "rogue"},
    [50075]  = {name = "Skeletal Mage", cost = 1, limit = 3, group = "mage"},
    [50076]  = {name = "Skeletal Archer", cost = 1, limit = 4, group = "archer"},
    [50130]  = {name = "Skeletal Archer", cost = 1, limit = 4, group = "archer"},
    [50073]  = {name = "Ghoul", cost = 2, limit = 3, group = "ghoul"},
    [50140]  = {name = "Nerubian Swarmite", cost = 1, limit = 4, group = "swarmite"},
    [50141]  = {name = "Nerubian Skitterling", cost = 1, limit = 3, group = "skitterling"},
    [50142]  = {name = "Crypt Fiend", cost = 2, limit = 2, group = "cryptfiend"},
    [50323]  = {name = "Crypt Fiend", cost = 2, limit = 2, group = "cryptfiend"},
    [50143]  = {name = "Royal Warrior", cost = 2, limit = 3, group = "royalwarrior"},
    [50150]  = {name = "Royal Warrior", cost = 2, limit = 3, group = "royalwarrior"},
    [50144]  = {name = "Royal Mage", cost = 2, limit = 2, group = "royalmage"},
    [50151]  = {name = "Royal Mage", cost = 2, limit = 2, group = "royalmage"},
    [50145]  = {name = "Royal Rogue", cost = 2, limit = 2, group = "royalrogue"},
    [50152]  = {name = "Royal Rogue", cost = 2, limit = 2, group = "royalrogue"},
    [50146]  = {name = "Royal Priest", cost = 3, limit = 1, group = "royalpriest"},
    [50155]  = {name = "Royal Priest", cost = 3, limit = 1, group = "royalpriest"},
    [50147]  = {name = "Royal Hunter", cost = 2, limit = 2, group = "royalhunter"},
    [50148]  = {name = "Crypt Lord", cost = 4, limit = 1, group = "cryptlord", tank = true},
    [50149]  = {name = "Crypt Lord", cost = 4, limit = 1, group = "cryptlord", tank = true},
    [50068]  = {name = "Abomination", cost = 4, limit = 1, group = "abomination", tank = true},
    [50154]  = {name = "Nerubian Hulk", cost = 5, limit = 1, group = "hulk", tank = true},
    [50160]  = {name = "Skyrazor", cost = 6, limit = 1, group = "skyrazor", tank = true},
    -- later Necrotic Calls; no values were supplied for these, so cost/limit follow the same scale
    [50067]  = {name = "Gargoyle", cost = 3, limit = 2, group = "gargoyle"},
    [50115]  = {name = "Decaying Colossus", cost = 4, limit = 1, group = "colossus"},
    [50309]  = {name = "Bone Wraith", cost = 3, limit = 1, group = "bonewraith"},
    [50320]  = {name = "Tomb King", cost = 5, limit = 1, group = "tombking"},
    [50385]  = {name = "Plaguefather", cost = 5, limit = 1, group = "plaguefather"},
    [50177]  = {name = "Frost Wyrm", cost = 6, limit = 1, group = "frostwyrm"},
    [50261]  = {name = "Skeletal Smith", cost = 2, limit = 2, group = "smith"},
    [500650] = {name = "Banshee", cost = 2, limit = 2, group = "banshee"},
}
-- Summon spell -> creature (both CoA ids: spell id - 7000000, creature entry - 7000000).
COA_LF.SPELL = {
    [500329] = 50067, [500335] = 50068, [803139] = 50068, [500989] = 50115,
    [500330] = 50130, [500332] = 50076, [805040] = 50130,
    [500331] = 50075, [504859] = 50323, [801941] = 50323, [504861] = 500650,
    [500969] = 50078, [500970] = 50065, [500971] = 50073, [504901] = 51065,
    [504682] = 50065, [600992] = 50065,
    [805032] = 50309, [805044] = 50320, [805048] = 50385, [805428] = 50177, [804681] = 50261,
    [991140] = 50140, [991141] = 50141, [991142] = 50142, [991143] = 50143, [991144] = 50144,
    [991145] = 50145, [991146] = 50146, [991147] = 50147, [991148] = 50148, [991149] = 50149,
    [991150] = 50150, [991151] = 50151, [991152] = 50152, [991153] = 50155, [991154] = 50154,
    [991160] = 50160,
}

-- capacity for a player level: the last row whose level <= level wins (level 1 = 1 ... level 90 = 12)
function COA_LF.Capacity(level)
    local c = 1
    for _, r in ipairs(COA_LF.CAPACITY) do if level >= r[1] then c = r[2] end end
    return c
end

-- Can `id` (creature, CoA id) be added to `active` (list of {id=}) under capacity `cap`?  -> ok, reason
-- Checks, in order: capacity, individual limit (by identity group, never by spell id), main-tank exclusivity.
function COA_LF.Allow(cap, active, id)
    local d = COA_LF.SUMMON[id]
    if not d then return true end
    if cap <= 0 then return false, "Life Force is not unlocked yet." end
    local used, n, tank = 0, 0, nil
    for _, m in ipairs(active) do
        local md = COA_LF.SUMMON[m.id]
        if md then
            used = used + md.cost
            if md.group == d.group then n = n + 1 end
            if md.tank then tank = md end
        end
    end
    if used + d.cost > cap then
        return false, string.format("Life Force %d/%d: %s costs %d, only %d free.", used, cap, d.name, d.cost, math.max(0, cap - used))
    end
    if n >= d.limit then return false, string.format("%s limit reached (%d active, max %d).", d.name, n, d.limit) end
    if d.tank and tank then
        return false, string.format("A main tank is already active (%s). Dismiss it before summoning %s.", tank.name, d.name)
    end
    return true
end
