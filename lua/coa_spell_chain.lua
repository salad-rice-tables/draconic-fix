-- Spell chains / combos, data driven from world.coa_spell_chain (edited in Midnight Creator Studio, Spell Studio).
--   mode 'auto'  : the player casts A -> the server casts next_spell (triggered) after delay_ms, on the same target (or on self).
--   mode 'combo': the player casts A, then casts next_spell (B) within window_ms -> bonus_spell is fired too (a combo finisher).
-- GM command .chain reload  re-reads the table without a restart (per Lua state: run it once per map you are on).
local RULES = {}   -- spell A -> list of rules

local function Load()
    RULES = {}
    local q = WorldDBQuery("SELECT spell_id, mode, next_spell, bonus_spell, delay_ms, window_ms, target FROM coa_spell_chain")
    if not q then return 0 end
    local n = 0
    repeat
        local a = q:GetUInt32(0)
        RULES[a] = RULES[a] or {}
        table.insert(RULES[a], {mode = q:GetString(1), next = q:GetUInt32(2), bonus = q:GetUInt32(3), delay = q:GetUInt32(4), window = q:GetUInt32(5), target = q:GetString(6)})
        n = n + 1
    until not q:NextRow()
    return n
end
Load()

local LAST = {}   -- player guid string -> {spell, time ms}
local function Now() return GetCurrTime and GetCurrTime() or 0 end

local function Target(p, rule)
    if rule.target == "self" then return p end
    local ok, t = pcall(function() return p:GetSelection() end)
    return (ok and t) or p
end

RegisterPlayerEvent(5, function(_, p, spell)   -- ON_SPELL_CAST (spell is the Spell object)
    local ok, id = pcall(function() return spell:GetEntry() end)
    if not ok or not id then return end
    local g = tostring(p:GetGUIDLow())
    local prev = LAST[g]; LAST[g] = {id, Now()}
    -- combo finisher: B cast inside the window after A
    if prev then
        for _, r in ipairs(RULES[prev[1]] or {}) do
            if r.mode == "combo" and r.next == id and r.bonus > 0 and Now() - prev[2] <= r.window then
                pcall(function() p:CastSpell(Target(p, r), r.bonus, true) end)
            end
        end
    end
    -- auto chain: A makes the server cast B
    for _, r in ipairs(RULES[id] or {}) do
        if r.mode == "auto" then
            local t = Target(p, r)
            if r.delay > 0 then p:RegisterEvent(function(_, _, _, pl) if pl and pl:IsInWorld() then pcall(function() pl:CastSpell(t, r.next, true) end) end end, r.delay, 1)
            else pcall(function() p:CastSpell(t, r.next, true) end) end
        end
    end
end)

RegisterPlayerEvent(42, function(_, p, command)
    if string.lower(command or "") ~= "chain reload" or p:GetGMRank() < 1 then return end
    p:SendBroadcastMessage("|cff00ccff[Chain]|r " .. Load() .. " rule(s) loaded."); return false
end)
print("[coa_spell_chain] loaded")
