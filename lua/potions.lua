-- Essence potions (tiers Minor..Supreme) restore a share of the Hero Essence pool; Hero elixirs are 1 hour buffs.
-- Items/spells: sql/potions.sql (items 9730010-15, 9730020-25). Both drop from creatures killed by Heroes.
if IS_WORLD_STATE then return end

local POTIONS = {   -- item id -> {spell, percent}
    [9730010] = {1402310, 15}, [9730011] = {1402311, 25}, [9730012] = {1402312, 40},
    [9730013] = {1402313, 55}, [9730014] = {1402314, 75}, [9730015] = {1402315, 100},
}
local ELIXIRS = {9730020, 9730021, 9730022, 9730023, 9730024, 9730025}
local POWER_ALT, HERO_AURA = 10, 1400010

for item, d in pairs(POTIONS) do
    RegisterItemEvent(item, 1, function(_, caster, spellId, effIndex, itemObj)   -- the potion's dummy effect
        if not caster or not caster.GetPower then return true end
        local maxE = caster:GetMaxPower(POWER_ALT)
        if maxE <= 0 then return true end
        local add = math.floor(maxE * d[2] / 100)
        local before = caster:GetPower(POWER_ALT)
        caster:SetPower(math.min(maxE, before + add), POWER_ALT)
        caster:SendBroadcastMessage("|cff6fd6ff[Essence]|r +" .. (math.min(maxE, before + add) - before) .. " Essence.")
        return true
    end)
end

-- Mystic Rune (9730030) and Mystic Scroll (9730031): ordinary loot items (see sql/loot_*.sql), used from the bags
RegisterItemEvent(9730030, 1, function(_, caster)
    if caster and MYS_AddRunes then pcall(MYS_AddRunes, caster, 1); caster:SendBroadcastMessage("|cff6fd6ff[Mystic]|r +1 Mystic Rune.") end
    return true
end)
RegisterItemEvent(9730031, 1, function(_, caster)
    if caster and MYS_GiveRandomEnchant then pcall(MYS_GiveRandomEnchant, caster) end
    return true
end)
-- Potions and elixirs now drop as normal loot from creatures (reference loot tables); no script gives them out any more.
print("[potions] Essence potions and Hero elixirs loaded")
