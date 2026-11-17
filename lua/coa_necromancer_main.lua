-- =====================================================================
-- CoA Necromancer on Midnight (test slice).
-- Spells/creatures come from sql/20261106_coa_necromancer_{spells,creatures}.sql (new id = 7000000 + CoA id).
-- GM test commands:
--   .necro            list commands
--   .necro all        learn every castable Necromancer spell (89)
--   .necro find <txt> list spells whose name contains <txt>
--   .necro learn <id> learn one spell by its NEW id (7xxxxxx) or the old CoA id
--   .necro reset      unlearn them again
--   .necro dmg        print spell power info of the player (spell power drives CoA coefficients)
-- CoA coefficients (AscensionNecromancerData.h) are applied in coa_necromancer_hooks (next step).
-- =====================================================================
-- command hooks run in the world state too: no IS_WORLD_STATE guard here

local function Hostile(a, b)   -- this Eluna has no IsHostileTo: different faction and not a's own pet / minion
    if not b or b == a or b:GetGUID() == a:GetGUID() then return false end
    local o = b.GetOwner and b:GetOwner()
    if o and o:GetGUID() == a:GetGUID() then return false end
    return b:GetFaction() ~= a:GetFaction()
end

local OFF = 7000000
local TAG = "|cff9482c9[Necromancer]|r "

local BYID = {}
for _, s in ipairs(NECRO_SPELLS or {}) do BYID[s[1]] = s[2] end

local function Norm(id)
    id = tonumber(id) or 0
    if id > 0 and id < OFF then id = id + OFF end
    return id
end

RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local args = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do args[#args + 1] = w end
    if string.lower(args[1] or "") ~= "necro" then return end
    if player:GetGMRank() < 1 then return end
    local sub = string.lower(args[2] or "")
    if sub == "all" then
        local n = 0
        for _, s in ipairs(NECRO_SPELLS) do
            if not player:HasSpell(s[1]) then player:LearnSpell(s[1]); n = n + 1 end
        end
        player:SendBroadcastMessage(TAG .. "learned " .. n .. " spells (" .. #NECRO_SPELLS .. " castable in total).")
    elseif sub == "find" then
        local q = string.lower(args[3] or "")
        local n = 0
        for _, s in ipairs(NECRO_SPELLS) do
            if string.find(string.lower(s[2]), q, 1, true) then
                player:SendBroadcastMessage(TAG .. s[1] .. "  " .. s[2]); n = n + 1
                if n >= 30 then break end
            end
        end
    elseif sub == "learn" then
        local id = Norm(args[3])
        player:LearnSpell(id)
        player:SendBroadcastMessage(TAG .. "learned " .. id .. " " .. (BYID[id] or ""))
    elseif sub == "reset" then
        for _, s in ipairs(NECRO_SPELLS) do if player:HasSpell(s[1]) then player:RemoveSpell(s[1]) end end
        player:SendBroadcastMessage(TAG .. "Necromancer spells removed.")
    elseif sub == "dmg" then
        -- one line that explains a damage report: level, intellect, shadow spell power and the
        -- flat magic bonus the two hidden passives add to every hit / DoT tick (see
        -- sql/20261112_coa_flat_damage_tune.sql), plus the Lichfrost rank 2 estimate.
        local lvl = player:GetLevel()
        local sp = 0   -- Unit:GetBaseSpellPower crashes this core natively
        local int = tonumber(player:GetStat(3)) or 0
        local flat = 1 + 1.5 * lvl
        player:SendBroadcastMessage(TAG .. string.format(
            "lvl %d | intellect %d | shadow spell power %d | flat magic +%d | Lichfrost r2 ~%.0f (base 66 + 0.87 x sp + flat)",
            lvl, int, sp, math.floor(flat), 66 + 0.87 * sp + flat))
    elseif sub == "on" or sub == "cap" then return   -- handled by the Life Force handler below
    else
        player:SendBroadcastMessage(TAG .. ".necro all | find <text> | learn <id> | reset | dmg | on | cap <n>")
    end
    return false
end)

print("[coa_necromancer] loaded, " .. #(NECRO_SPELLS or {}) .. " castable spells")

-- =====================================================================
-- Life Force = minion capacity (port of AscensionNecromancer.cpp Cost/Capacity/Used + Summons.cpp Evict).
-- Bar 9991 (alt power, aura 1400011): max = capacity, value = free capacity.
-- Map-state part below runs only in map states (needs creatures).
-- =====================================================================
local POWER_ALT, LF_AURA, HERO_AURA = 10, 1400011, 1400010

-- Life Force configuration and rules live in aaa_coa_lf_rules.lua (COA_LF.CAPACITY / SUMMON / SPELL / Capacity / Allow).
NECRO_CAP = NECRO_CAP or 2     -- legacy base; the level curve above is authoritative, .necro cap <n> overrides for tests

local KEYCACHE = {}   -- ponytail: per-character cache, the cast hook asks on every spell of every player (bots too) and a sync DB query there is slow
local function CoaKey(player)
    local k = COA_SLOT_KEY and COA_KEY(player)    -- the creation slot decides the CoA class
    if k then return k end
    local nm = player:GetName()
    if KEYCACHE[nm] ~= nil then return KEYCACHE[nm] or nil end
    local ok, r = pcall(CharDBQuery, string.format("SELECT class FROM characters.wildcard_coa WHERE name = '%s'", (string.gsub(player:GetName(), "'", "''"))))
    local v = ok and r and r:GetString(0) or nil
    KEYCACHE[nm] = v or false
    return v
end
local function IsNecro(player) return CoaKey(player) == "necromancer" end

if not IS_WORLD_STATE then
local function CapOf(p)   -- Life Force capacity from the level curve (CoA: 2 + talents; here data-driven per level)
    if CoaEssenceUnlocked and not CoaEssenceUnlocked(p) then return 0 end   -- Life Force is locked until the first initiation quest
    if NECRO_CAP_OVERRIDE then return NECRO_CAP_OVERRIDE end
    return COA_LF.Capacity(p:GetLevel())
end
    local tracked = {}      -- [playerName] = { {guid, id, cost, group, tank}, ... } rebuilt from live creatures
    local function List(p) local k = p:GetName(); tracked[k] = tracked[k] or {}; return tracked[k] end
    local function Find(p, guid)
        local ok, o = pcall(function() return p:GetMap():GetWorldObject(guid) end)
        return ok and o or nil
    end
    -- Authoritative registry: rebuilt from the creatures that actually exist, so a relog, a server
    -- restart, a death or a despawn can never leave a stale or negative Life Force reservation.
    local function Prune(p)
        local out, seen = {}, {}
        local ok, list = pcall(function() return p:GetCreaturesInRange(60) end)
        if ok and list then
            for _, c in ipairs(list) do
                local id = c:GetEntry() - OFF
                local d = COA_LF.SUMMON[id]
                if d and c:IsAlive() then
                    local o = c:GetOwner()
                    local g = tostring(c:GetGUID())
                    if (not o or o:GetGUID() == p:GetGUID()) and not seen[g] then
                        seen[g] = true
                        out[#out + 1] = {guid = c:GetGUID(), id = id, cost = d.cost, group = d.group, tank = d.tank}
                    end
                end
            end
        end
        tracked[p:GetName()] = out
        local used = 0
        for _, m in ipairs(out) do used = used + m.cost end
        return used, out
    end
    -- Life Force / individual limit / main tank rules, checked before the summon spell creates anything.
    local function Check(p, id)
        local _, list = Prune(p)
        return COA_LF.Allow(CapOf(p), list, id)
    end
    -- Safety net for summons that bypass the cast check: extra copies over the limit and extra main
    -- tanks are removed (the oldest summon of an identity is kept).
    local function Enforce(p)
        local used, list = Prune(p)
        local seenGroup, tank = {}, nil
        for i = #list, 1, -1 do
            local d = COA_LF.SUMMON[list[i].id]
            local n = seenGroup[d.group] or 0
            if n >= d.limit or (d.tank and tank) then
                local c = Find(p, list[i].guid)
                if c then pcall(function() c:DespawnOrUnsummon(0) end) end
            else
                seenGroup[d.group] = n + 1
                if d.tank then tank = d end
            end
        end
        -- Fallback for a summon the cast-time veto could not stop: capacity overflow removes the
        -- extra summons (never a main tank) and says so, instead of leaving a broken reservation.
        local cap = CapOf(p)
        local guard = 0
        while used > cap and guard < 20 do
            guard = guard + 1
            local _, l = Prune(p)
            local m = l[#l]
            if not m or COA_LF.SUMMON[m.id].tank then break end
            local c = Find(p, m.guid)
            if not c then break end
            pcall(function() c:DespawnOrUnsummon(0) end)
            p:SendBroadcastMessage(TAG .. "Life Force capacity exceeded: " .. COA_LF.SUMMON[m.id].name .. " was dismissed.")
            used = Prune(p)
        end
        return used
    end
    local function Bar(p, used)   -- Life Force aura 1400011: stack count = FREE capacity (aura missing = 0 free); the client orb (CoAUI addon) shows free/capacity
        used = used or Prune(p)
        pcall(function()
            local free = CapOf(p) - used
            local a = p:GetAura(LF_AURA)
            if free <= 0 then
                if a then p:RemoveAura(LF_AURA) end
            else
                if not a then p:AddAura(LF_AURA, p); a = p:GetAura(LF_AURA) end
                if a and a:GetStackAmount() ~= free then a:SetStackAmount(free) end
            end
        end)
        pcall(function() p:SendAddonMessage("COAUI", string.format("LF;%d;%d", math.max(0, CapOf(p) - used), CapOf(p)), 7, p) end)   -- client orb (CoAUI): free;capacity
        return used
    end
    function COA_LF.Report(p)   -- text UI: used / capacity plus every active summon and its cost
        local ok, err = pcall(function()
            local cap = CapOf(p)
            local used, list = Prune(p)
            local agg, order = {}, {}
            for _, m in ipairs(list) do
                local d = COA_LF.SUMMON[m.id]
                if not agg[d.group] then
                    agg[d.group] = {name = d.name, n = 0, cost = d.cost, tank = d.tank}
                    order[#order + 1] = d.group
                end
                agg[d.group].n = agg[d.group].n + 1
            end
            p:SendBroadcastMessage(string.format("|cff9bd7ffLife Force: %d / %d|r  (available %d)", used, cap, math.max(0, cap - used)))
            if used > cap then p:SendBroadcastMessage("|cffff4444  over capacity: dismiss a summon to cast again|r") end
            if #order == 0 then p:SendBroadcastMessage("  no summons active") end
            for _, g in ipairs(order) do
                local a = agg[g]
                p:SendBroadcastMessage(string.format("  %s x%d - %d%s", a.name, a.n, a.cost * a.n, a.tank and " [main tank]" or ""))
            end
        end)
        if not ok then PrintInfo("[coa] lifeforce report failed: " .. tostring(err)) end
    end
    -- Evict is gone on purpose: the rules now reject a summon with a clear message instead of
    -- silently dismissing an existing minion (a main tank is never dismissed behind the player's back).

    local PACIFY = OFF + 500983   -- Undead: Pacify = minions stay passive
    local function Assist(p, target)   -- every tracked minion attacks the target (CoA: minions follow the necromancer's attacks)
        if not target or p:HasAura(PACIFY) then return end
        for _, t in ipairs(List(p)) do
            local c = Find(p, t.guid)
            if c and c:IsAlive() then   -- compare GUIDs (userdata ~= is always true) and never re-issue AttackStart on a minion that already fights it
                local v = c:GetVictim()
                if not v or v:GetGUID() ~= target:GetGUID() then pcall(function() c:AttackStart(target) end) end
            end
        end
    end
    RegisterPlayerEvent(5, function(_, player, spell)       -- Command: Undead (500991 trigger on the target) / any hostile cast = send the minions
        if not IsNecro(player) then return end
        local ok, t = pcall(function() return spell:GetTarget() end)
        if ok and t and t.IsAlive and t:IsAlive() and Hostile(player, t) then Assist(player, t) end
    end)
    RegisterPlayerEvent(5, function(_, player, spell)       -- ON_SPELL_CAST: check the rules before anything spawns
        local id = COA_LF.SPELL[spell:GetEntry() - OFF]
        if not id or not IsNecro(player) then return end
        local allowed, err = Check(player, id)
        -- ponytail: no spell:Cancel() here. Cancelling inside the ON_SPELL_CAST hook (Spell::_cast) is a heap-corruption suspect (c0000374 in
        -- SendSpellStart); the rejected summon is removed right after it appears instead. Nothing is charged: no resource is consumed.
        if not allowed then player:SendBroadcastMessage(TAG .. err) end
        local function Adopt(_, _, _, p)                    -- the summon exists shortly after the cast: adopt it (once per new creature)
            if not p or not p:IsInWorld() then return end
            local ok2, list = pcall(function() return p:GetCreaturesInRange(40, OFF + id) end)
            if not (ok2 and list) then return end
            local known = {}
            for _, t in ipairs(List(p)) do known[tostring(t.guid)] = true end   -- GUIDs are userdata: compare as strings
            for _, c in ipairs(list) do
                local g = c:GetGUID()
                local o = c:GetOwner()
                if c:IsAlive() and not known[tostring(g)] and (not o or o:GetGUID() == p:GetGUID()) then
                    if not allowed then pcall(function() c:DespawnOrUnsummon(0) end); break end   -- rejected by the Life Force rules
                    local d = COA_LF.SUMMON[id]
                    List(p)[#List(p) + 1] = {guid = g, id = id, cost = d.cost, group = d.group, tank = d.tank}
                    if COA_SCALE_THIS then pcall(COA_SCALE_THIS, c, p) end   -- level + health like the owner (coa_necro_minions.lua)
                    pcall(function() c:CastSpell(c, 7991101, true) end)   -- Necromantic Spawn visual (tools/coa_spellforge.py)
                    break
                end
            end
            Enforce(p)
            Bar(p)
        end
        player:RegisterEvent(Adopt, 400, 1)
        player:RegisterEvent(Adopt, 1500, 1)   -- second try if the creature appeared late
    end)

    MAP_Timer("coa_lifeforce", function()
        for _, p in ipairs(MAP_Players()) do
            if IsNecro(p) then
                Enforce(p)                -- individual limits + main tank exclusivity, also for summons made by other paths
                Bar(p)
                local v = p:GetVictim()   -- auto-assist: the necromancer's melee / auto-attack target
                if v and p:IsInCombat() then Assist(p, v) end
            end
        end
    end, 1000)

    -- Necromancer spells by level (class 15 = Necromancer picked on the creation screen)
    local function LearnByLevel(p)
        local n, lvl = 0, p:GetLevel()
        local key = CoaKey(p)
        local sched = key and COA_SCHEDULE and COA_SCHEDULE[key]
        if not sched then return 0 end
        for _, b in ipairs({1488101, 1488102}) do if not p:HasSpell(b) then p:LearnSpell(b) end end   -- companion books
        for _, s in ipairs(sched) do
            if s[3] <= 1 and lvl >= s[3] and not p:HasSpell(s[1]) then   -- level>1 spells are taught by the Book of Ascension (trainer)
                p:LearnSpell(s[1]); n = n + 1
                p:SendBroadcastMessage(TAG .. "New ability: " .. s[2])
            end
        end
        -- Severed Covenant (Nerubian Swarm Calls) is NOT granted here: it comes later via the optional class-campaign quest
        return n
    end
    COA_LEARN = LearnByLevel   -- coa_choose.lua calls it right after a Conquest Hero picked a class
    RegisterPlayerEvent(13, function(_, player) player:RegisterEvent(function(_, _, _, p) if p then LearnByLevel(p) end end, 500, 1) end)   -- level change

    -- login: Necromancers use the Life Force bar instead of Hero Essence
    RegisterPlayerEvent(28, function(_, player)   -- enter world (map state); event 3 fires only in the world state
        player:RegisterEvent(function(_, _, _, p)
            if p and p:IsInWorld() then local n = LearnByLevel(p); PrintInfo(string.format('[coa] login %s class=%d key=%s learned=%d necro=%s', p:GetName(), p:GetClass(), tostring(CoaKey(p)), n or -1, tostring(IsNecro(p)))) end
            if p and p:IsInWorld() and COA_SLOT_KEY and COA_KEY(p) and p:HasAura(HERO_AURA) and not IsNecro(p) then p:RemoveAura(HERO_AURA) end
            if p and p:IsInWorld() and IsNecro(p) then
                if p:HasAura(HERO_AURA) then p:RemoveAura(HERO_AURA) end
                Bar(p)   -- adds the Life Force aura only once unlocked
            end
        end, 6000, 1)
    end)
end

-- test command extension (world state): .necro on | cap <n>
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local args = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do args[#args + 1] = w end
    if string.lower(args[1] or "") ~= "necro" then return end
    local sub = string.lower(args[2] or "")
    if player:GetGMRank() < 1 then return end
    if sub == "on" then
        KEYCACHE[player:GetName()] = nil
        pcall(CharDBExecute, string.format("REPLACE INTO characters.wildcard_coa (name, class) VALUES ('%s', 'necromancer')", (string.gsub(player:GetName(), "'", "''"))))
        if player:HasAura(HERO_AURA) then player:RemoveAura(HERO_AURA) end
        player:AddAura(LF_AURA, player)
        for _, s in ipairs(NECRO_SPELLS) do if not player:HasSpell(s[1]) then player:LearnSpell(s[1]) end end
        player:SendBroadcastMessage(TAG .. "You are a Necromancer: Life Force bar active, spells learned.")
        return false
    elseif sub == "status" then
        player:SendBroadcastMessage(TAG .. "LF aura=" .. tostring(player:HasAura(LF_AURA)) .. " essence aura=" .. tostring(player:HasAura(HERO_AURA)) ..
            " altpower=" .. tostring(player:GetPower(POWER_ALT)) .. "/" .. tostring(player:GetMaxPower(POWER_ALT)) .. " class=" .. player:GetClass())
        return false
    elseif sub == "learnall" then   -- test helper: every class trainer spell up to the player's level + the three Life Force capacity passives
        local key, n = CoaKey(player), 0
        for _, r in ipairs((COA_SCHEDULE and key and COA_SCHEDULE[key]) or {}) do
            if r[3] <= player:GetLevel() and not player:HasSpell(r[1]) then player:LearnSpell(r[1]); n = n + 1 end
        end
        for _, sp in ipairs({7680283, 7092123, 7704699}) do if not player:HasSpell(sp) then player:LearnSpell(sp); n = n + 1 end end
        for _, bad in ipairs({92121, 92122, 92123}) do if player:HasSpell(bad) then player:RemoveSpell(bad) end end   -- wrongly mapped retail ids from an earlier bug
        player:SendBroadcastMessage(TAG .. "Learned " .. n .. " spells (test).")
        return false
    elseif sub == "cap" then
        NECRO_CAP_OVERRIDE = tonumber(args[3])
        player:SendBroadcastMessage(TAG .. "Life Force capacity set to " .. tostring(NECRO_CAP_OVERRIDE or NECRO_CAP) .. " (this state; relog/map change resets in other states).")
        return false
    end
end)

-- player-facing Life Force report (.lf / .lifeforce), no GM rank needed
RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local cmd = string.lower(tostring(command or ""))
    if cmd ~= "lf" and cmd ~= "lifeforce" then return end
    if COA_LF and COA_LF.Report then COA_LF.Report(player) end
    return false
end)
