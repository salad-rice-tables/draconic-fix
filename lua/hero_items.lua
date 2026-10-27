-- Hero currency items (Ascension icons): Ability Purge 9750001, Talent Purge 9750002, Dice of Destiny 9750003, Token of Prestige 9750004,
-- Bedlam Bullion 9750005, Bonzo Bolt 9750006. Each has a dummy use spell (1409001-1409006); a failed use returns the item.
if IS_WORLD_STATE then return end

local function Use(item, fn)
    RegisterItemEvent(item, 1, function(_, caster)
        if not caster or not caster.GetName then return true end
        local ok, done, why = pcall(fn, caster)
        if not ok or not done then
            pcall(function() caster:AddItem(item, 1) end)
            caster:SendBroadcastMessage("|cffff8000[Hero]|r " .. tostring((ok and why) or "That did nothing."))
        end
        return true
    end)
end
Use(9750001, function(p) return HERO_AbilityPurge(p) end)
Use(9750002, function(p) return HERO_TalentPurge(p) end)
Use(9750003, function(p) return HERO_DiceOfDestiny(p) end)
Use(9750004, function(p) if MYS_AddRunes then MYS_AddRunes(p, 10) return true end end)
-- Bedlam Bullion and Bonzo Bolt are payments of the Mystic Forge: using one opens the forge (the item stays in the bag) and says so.
local function ForgePayment(name)
    return function(p)
        if MYS_ForgeOpen then pcall(MYS_ForgeOpen, p) end
        pcall(function() p:SendAddonMessage("WCARD", "TOAST;" .. name .. ";Pay the Mystic Forge with it", 7, p) end)
        return false, name .. " is a payment for the Mystic Forge. The forge is open: choose it there."
    end
end
Use(9750005, ForgePayment("Bedlam Bullion"))
Use(9750006, ForgePayment("Bonzo Bolt"))
Use(9750007, function(p) if HERO_SkillCard then return HERO_SkillCard(p) end end)
Use(9750008, function(p) if HERO_HandOfFate then return HERO_HandOfFate(p) end end)
Use(9750009, function(p) return false, "Marks of Ascension are spent at the Mystic Forge (5 for a Mystic Scroll): /forge or a Mystic Altar." end)
print("[hero_items] currency items registered")
