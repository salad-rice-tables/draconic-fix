-- =====================================================================
-- Living World: Creature AI Overhaul (in the spirit of Ascension's).
-- Creatures without their own script fight by what they ARE:
--   beasts by family (boar charges and gores, spider webs and poisons...),
--   humanoids by role read from their name and NPC class (shaman heals and
--   throws lightning, warlock-cultist shadow bolts, bandit kicks and
--   backstabs, warrior charges, hamstrings and shouts...).
-- Abilities are NPC spells taken from what Blizzard's own creatures cast
-- (smart_scripts statistics, build 12.1.0.69933). Creatures keep the spells
-- Blizzard gave them and only GAIN what their kind lacks; C++-scripted
-- creatures, quest givers, vendors and bosses are left alone.
-- ZONES limits the pilot; set ALL_ZONES = true for the whole world.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

local ALL_ZONES = true
local ZONES = {14, 17}           -- pilot: Durotar, Northern Barrens
local TICK = 1200

-- rule fields: s = spell, cd = cooldown (s), when = "pull" | "range" | "melee"
-- | "low" (own HP < 35%) | "hurt" (own HP < 60%) | "buff" (once at pull),
-- chance = per tick when the rule is ready (default 0.35), self = cast on self
local ARCH = {
    boar     = {{s = 6268, when = "range", cd = 12, chance = 0.9}, {s = 152573, when = "melee", cd = 8},
                {s = 161040, when = "melee", cd = 14}, {s = 11876, when = "melee", cd = 28, chance = 0.3}, {s = 8599, when = "low", cd = 60, self = true}},
    wolf     = {{s = 32919, when = "buff", self = true}, {s = 255852, when = "melee", cd = 6},
                {s = 3604, when = "melee", cd = 15}, {s = 131944, when = "melee", cd = 12}, {s = 3391, when = "melee", cd = 14, chance = 0.4}},
    cat      = {{s = 6268, when = "range", cd = 14, chance = 0.6}, {s = 13443, when = "melee", cd = 10},
                {s = 3604, when = "melee", cd = 15}, {s = 3391, when = "melee", cd = 14, chance = 0.4}},
    spider   = {{s = 745, when = "range", cd = 15, chance = 0.7}, {s = 744, when = "melee", cd = 10}},
    bear     = {{s = 379023, when = "melee", cd = 7}, {s = 3391, when = "melee", cd = 14, chance = 0.4}, {s = 374898, when = "low", cd = 60, self = true}},
    raptor   = {{s = 6268, when = "range", cd = 12, chance = 0.8}, {s = 13443, when = "melee", cd = 10},
                {s = 3427, when = "melee", cd = 14}},
    scorpid  = {{s = 5416, when = "melee", cd = 9}, {s = 79840, when = "hurt", cd = 30, self = true}},
    croc     = {{s = 48287, when = "melee", cd = 9}, {s = 3604, when = "melee", cd = 15}},
    bird     = {{s = 5708, when = "range", cd = 14, chance = 0.7}, {s = 3427, when = "melee", cd = 12}},
    warrior  = {{s = 81219, when = "buff", self = true}, {s = 6268, when = "range", cd = 15, chance = 0.6},
                {s = 9080, when = "melee", cd = 12}, {s = 15496, when = "melee", cd = 8},
                {s = 13730, when = "melee", cd = 30, chance = 0.25}, {s = 15284, when = "melee", cd = 15, chance = 0.3}, {s = 8599, when = "low", cd = 60, self = true}},
    rogue    = {{s = 79864, when = "range", cd = 20, chance = 0.5}, {s = 60195, when = "melee", cd = 5},
                {s = 79862, when = "melee", cd = 10}, {s = 11978, when = "melee", cd = 15, chance = 0.25}},
    hunter   = {{s = 6660, when = "range", cd = 3, chance = 0.8}, {s = 9080, when = "melee", cd = 12}},
    mage     = {{s = 12544, when = "buff", self = true}, {s = 9672, when = "range", cd = 4, chance = 0.7},
                {s = 9053, when = "range", cd = 7, chance = 0.5}, {s = 11831, when = "melee", cd = 20, chance = 0.6}},
    shaman   = {{s = 12550, when = "buff", self = true}, {s = 9532, when = "range", cd = 5, chance = 0.6},
                {s = 15039, when = "melee", cd = 12}, {s = 11986, when = "hurt", cd = 15, self = true}},
    priest   = {{s = 9734, when = "range", cd = 5, chance = 0.6}, {s = 11639, when = "pull", cd = 18},
                {s = 11986, when = "hurt", cd = 12, self = true}},
    warlock  = {{s = 9613, when = "range", cd = 4, chance = 0.7}, {s = 14868, when = "pull", cd = 20},
                {s = 2601, when = "buff", self = true}},
    druid    = {{s = 9739, when = "range", cd = 4, chance = 0.6}, {s = 11986, when = "hurt", cd = 15, self = true}},
}

-- extra rules for elites and bosses (tier 1 = elite / rare, 2 = boss): they fight with more than their kind
local TIER_RULES = {
    [1] = {{s = 11876, when = "melee", cd = 30, chance = 0.3}, {s = 15284, when = "melee", cd = 12, chance = 0.4},
           {s = 8599, when = "below", hp = 30, cd = 9999, self = true}},
    [2] = {{s = 11876, when = "melee", cd = 25, chance = 0.4}, {s = 15284, when = "melee", cd = 10, chance = 0.5},
           {s = 16856, when = "melee", cd = 14, chance = 0.5}, {s = 6253, when = "melee", cd = 22, chance = 0.35},
           {s = 13730, when = "pull", cd = 40}, {s = 5164, when = "below", hp = 70, cd = 9999},
           {s = 8599, when = "below", hp = 35, cd = 9999, self = true}, {s = 8599, when = "below", hp = 15, cd = 9999, self = true}},
}

-- beast family -> archetype
local FAMILY = {[1] = "wolf", [2] = "cat", [3] = "spider", [4] = "bear", [5] = "boar", [6] = "croc",
    [7] = "bird", [11] = "raptor", [20] = "scorpid", [26] = "bird", [24] = "bird", [9] = "bear"}

-- humanoid role from name keywords (first match wins), then NPC class
local ROLE_WORDS = {
    {"shaman", "shaman"}, {"mystic", "shaman"}, {"seer", "shaman"}, {"oracle", "shaman"}, {"geomancer", "shaman"},
    {"priest", "priest"}, {"cleric", "priest"}, {"acolyte", "priest"}, {"healer", "priest"}, {"zealot", "priest"},
    {"warlock", "warlock"}, {"baneshadow", "warlock"}, {"shadow", "warlock"}, {"cultist", "warlock"}, {"shadowcaster", "warlock"}, {"necrolyte", "warlock"}, {"summoner", "warlock"},
    {"mage", "mage"}, {"sorcer", "mage"}, {"arcanist", "mage"}, {"conjurer", "mage"}, {"magus", "mage"}, {"apprentice", "mage"},
    {"druid", "druid"}, {"shaper", "druid"},
    {"hunter", "hunter"}, {"ranger", "hunter"}, {"sniper", "hunter"}, {"sharpshooter", "hunter"}, {"huntsman", "hunter"}, {"tracker", "hunter"}, {"archer", "hunter"}, {"marksman", "hunter"}, {"rifleman", "hunter"}, {"scout", "hunter"}, {"trapper", "hunter"},
    {"rogue", "rogue"}, {"thief", "rogue"}, {"assassin", "rogue"}, {"bandit", "rogue"}, {"cutpurse", "rogue"}, {"stalker", "rogue"}, {"thug", "rogue"}, {"pillager", "rogue"},
}
local BEAST_WORDS = {
    {"boar", "boar"}, {"quilboar", "boar"}, {"pig", "boar"},
    {"wolf", "wolf"}, {"worg", "wolf"}, {"coyote", "wolf"}, {"hyena", "wolf"}, {"jackal", "wolf"},
    {"spider", "spider"}, {"webwood", "spider"}, {"tarantula", "spider"},
    {"scorpid", "scorpid"}, {"scorpion", "scorpid"},
    {"raptor", "raptor"},
    {"lion", "cat"}, {"tiger", "cat"}, {"panther", "cat"}, {"prowler", "cat"}, {"highmane", "cat"}, {"cat", "cat"}, {"lynx", "cat"},
    {"bear", "bear"}, {"croc", "croc"}, {"hawk", "bird"}, {"vulture", "bird"}, {"buzzard", "bird"}, {"owl", "bird"}, {"harpy", "bird"},
}
local CLASS_ROLE = {[1] = "warrior", [2] = "warrior", [4] = "rogue", [8] = "mage"}   -- paladin-class NPCs fight in melee, they do not heal

local CT_BEAST, CT_HUMANOID = 1, 7
local STATE = {}   -- per creature: archetype + cooldowns, keyed by "lw_ai" Data id
local nextId = 0

local function Archetype(c, family, unitClass, tier)
    local okT, t = pcall(function() return c:GetCreatureType() end)
    if not okT then return nil end
    if t == CT_BEAST then
        if FAMILY[family] then return FAMILY[family] end
        -- many retail beasts have no family set: read it from the name
        local n = string.lower(c:GetName() or "")
        for _, w in ipairs(BEAST_WORDS) do
            if string.find(n, w[1], 1, true) then return w[2] end
        end
        return nil
    end
    local n = string.lower(c:GetName() or "")
    if t ~= CT_HUMANOID then
        if tier == 0 then return nil end   -- elites and bosses of any type fight like a warrior / caster
        for _, w in ipairs(ROLE_WORDS) do
            if string.find(n, w[1], 1, true) then return w[2] end
        end
        return (t == 3 or t == 6) and "warlock" or "warrior"
    end
    for _, w in ipairs(ROLE_WORDS) do
        if string.find(n, w[1], 1, true) then return w[2] end
    end
    return CLASS_ROLE[unitClass] or "warrior"
end

local function Ready(st, i, cd)
    return (st.cd[i] or 0) <= os.time() and true or false, function() st.cd[i] = os.time() + (cd or 10) end
end

local function Brain(_, _, _, c)
    if not c or not c:IsAlive() or not c:IsInCombat() then return end
    local st = STATE[c:Data():Get("lw_ai") or 0]
    if not st then return end
    local okC, casting = pcall(function() return c:IsCasting() end)
    if okC and casting then return end
    local victim = c:GetVictim()
    if not victim then return end
    local dist = c:GetDistance(victim)
    local hp = c:GetHealthPct()
    local rules = st.rules
    for i, r in ipairs(rules) do
        local ok, use = Ready(st, i, r.cd)
        if ok and (r.when == "any" or not st.own[r.s]) then
            local fits = false
            if r.when == "melee" then fits = dist <= 6
            elseif r.when == "range" then fits = dist > 8 and dist < 30
            elseif r.when == "pull" then fits = not st.pulled
            elseif r.when == "low" then fits = hp < 35
            elseif r.when == "hurt" then fits = hp < 60
            elseif r.when == "below" then fits = hp < r.hp
            elseif r.when == "any" then fits = dist < 30
            end
            if fits and math.random() < (r.chance or 0.5) then
                use()
                pcall(function() c:CastSpell(r.self and c or victim, r.s, false) end)
                st.pulled = true
                return
            end
        end
    end
    st.pulled = true
end

local function OnEnterCombat(_, c)
    local id = c:Data():Get("lw_ai")
    local st = id and STATE[id]
    if not st then return end
    st.cd, st.pulled = {}, false
    -- buffs at the pull
    for _, r in ipairs(st.rules) do
        if r.when == "buff" and not st.own[r.s] then pcall(function() c:CastSpell(c, r.s, true) end) end
    end
    if st.ev then c:RemoveEventById(st.ev) end
    st.ev = c:RegisterEvent(Brain, TICK, 0)
end

local function OnLeave(_, c)
    local id = c:Data():Get("lw_ai")
    local st = id and STATE[id]
    if st and st.ev then c:RemoveEventById(st.ev); st.ev = nil end
end

local ENTRY_INFO = {}  -- entry -> {family, unitClass}

local function OnSpawn(_, c)
    local info = ENTRY_INFO[c:GetEntry()]
    if not info then return end
    if not ALL_ZONES then
        local okZ, z = pcall(function() return c:GetZoneId() end)
        local inZone = false
        for _, zz in ipairs(ZONES) do if okZ and z == zz then inZone = true break end end
        if not inZone then return end
    end
    local nOwn = 0
    for _ in pairs(info[3] or {}) do nOwn = nOwn + 1 end
    if nOwn >= 3 then return end   -- already scripted with its own spells (named bosses): leave them as designed
    local arch = Archetype(c, info[1], info[2], info[4] or 0)
    local own = {}
    for sp in pairs(info[3] or {}) do own[#own + 1] = sp end
    if (not arch or not ARCH[arch]) and #own == 0 then return end
    nextId = nextId + 1
    c:Data():Set("lw_ai", nextId)
    local rules = {}
    -- the creature's own SmartAI spells: Lua replaced its SmartAI, so it casts them itself now
    for _, sp in ipairs(own) do rules[#rules + 1] = {s = sp, when = "any", cd = 9, chance = 0.45} end
    if arch and ARCH[arch] then for _, r in ipairs(ARCH[arch]) do rules[#rules + 1] = r end end
    for _, r in ipairs(TIER_RULES[info[4] or 0] or {}) do rules[#rules + 1] = r end
    STATE[nextId] = {arch = arch, cd = {}, own = info[3] or {}, rules = rules}
end

-- creatures with no script of their own, not service NPCs, not bosses
local zoneFilter = ALL_ZONES and "1=1" or ("c.zoneId IN (" .. table.concat(ZONES, ",") .. ")")
local q = WorldDBQuery([[
    SELECT t.entry, t.family, t.unit_class, t.Classification,
           COALESCE((SELECT GROUP_CONCAT(DISTINCT s.action_param1) FROM smart_scripts s
                      WHERE s.entryorguid = t.entry AND s.source_type = 0 AND s.action_type IN (11, 85, 86, 134)), '')
      FROM creature_template t
     WHERE t.entry IN (SELECT DISTINCT c.id FROM creature c WHERE ]] .. zoneFilter .. [[)
       AND t.npcflag = 0
       AND ((t.type IN (1, 7) AND t.Classification IN (0, 1)) OR (t.type IN (1, 2, 3, 4, 5, 6, 7) AND t.Classification IN (1, 2, 3, 4)))
       AND t.ScriptName = ''
       AND (t.AIName = '' OR (t.AIName = 'SmartAI' AND NOT EXISTS (SELECT 1 FROM smart_scripts s2 WHERE s2.entryorguid = t.entry AND s2.source_type = 0
                                AND s2.action_type NOT IN (1, 5, 11, 85, 86, 134))))   -- SmartAI that only talks, emotes and casts is replaced (e.g. Cutpurse: Backstab only)
       AND t.name NOT LIKE '%Riding%' AND t.name NOT LIKE 'Swift %']])
local n = 0
if q then
    repeat
        local e = q:GetUInt32(0)
        -- spells Blizzard/TDB already gave this creature: we only ADD what it lacks
        local own = {}
        for sp in string.gmatch(q:GetString(4) or "", "(%d+)") do own[tonumber(sp)] = true end
        local cl = q:GetUInt32(3)
        local nOwnSp = 0
        for _ in pairs(own) do nOwnSp = nOwnSp + 1 end
        -- creatures with 3+ spells of their own (named bosses, big cats, Khansguard) keep their SmartAI: any Lua event here would replace it
        if nOwnSp >= 3 then goto continue end
        ENTRY_INFO[e] = {q:GetUInt32(1), q:GetUInt32(2), own, (cl == 3) and 2 or (cl >= 1 and cl <= 4) and 1 or 0}
        RegisterCreatureEvent(e, 5, OnSpawn)        -- ON_SPAWN
        RegisterCreatureEvent(e, 1, OnEnterCombat)  -- ON_ENTER_COMBAT
        RegisterCreatureEvent(e, 2, OnLeave)        -- ON_LEAVE_COMBAT
        RegisterCreatureEvent(e, 4, OnLeave)        -- ON_DIED
        n = n + 1
        ::continue::
    until not q:NextRow()
end
print("[lw] creature AI overhaul: " .. n .. " creature types (" .. (ALL_ZONES and "whole world" or "pilot zones") .. ")")
