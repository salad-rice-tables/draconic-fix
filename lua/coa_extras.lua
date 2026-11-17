-- Extra spells for CoA classes, on top of the exact CoA spells (nothing in CoA is changed or replaced).
-- Add a row {spellId, minLevel, "note"} under the class key; it is taught automatically at login and level-up.
-- Use Midnight ids (CoA custom spells = 7000000 + CoA id). Find ids with /gmt -> Spell, test them there with Learn / Cast on me.
-- Players can also learn them any time through the GM tool; this file is only for spells every character of the class should get.
if not COA_SLOT_KEY then return end

COA_EXTRAS = COA_EXTRAS or {
    necromancer = {
        {7990001, 1, "Necrobolt: shadow bolt, slow + damage over time, 20 % chance for Grasp of the Grave (3 s stun)"},
    },
    witchdoctor = {
        -- {spellId, minLevel, "note"},
    },
}

local function Teach(p)
    local key = COA_KEY(p)
    local lvl = p:GetLevel()
    for _, rows in ipairs({key and COA_EXTRAS[key] or {}, key and COA_FORGED and COA_FORGED[key] or {}}) do   -- COA_FORGED: tools/coa_spellforge.py
        for _, r in ipairs(rows) do
            if lvl >= r[2] and not p:HasSpell(r[1]) then p:LearnSpell(r[1]) end
        end
    end
end

RegisterPlayerEvent(13, function(_, player) player:RegisterEvent(function(_, _, _, p) if p then Teach(p) end end, 800, 1) end)   -- level change
RegisterPlayerEvent(28, function(_, player) player:RegisterEvent(function(_, _, _, p) if p and p:IsInWorld() then Teach(p) end end, 7000, 1) end)   -- enter world
-- Necrobolt proc: 20 % chance that a necrotic hand (Grasp of the Grave, 7990002) bursts under the target and stuns it
RegisterPlayerEvent(5, function(_, player, spell)
    if spell:GetEntry() ~= 7990001 or math.random(100) > 20 then return end
    local ok, t = pcall(function() return spell:GetTarget() end)
    if not (ok and t and t.IsAlive) then return end
    local guid = t:GetGUID()
    player:RegisterEvent(function(_, _, _, p)   -- after the bolt lands
        local u = p and p:GetMap():GetWorldObject(guid)
        if u and u:IsAlive() then pcall(function() p:CastSpell(u, 7990002, true) end) end
    end, 900, 1)
end)
print("[coa_extras] loaded")
