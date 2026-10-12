-- =====================================================================
-- Pet scaling: Wildcard summoni (Imp 416, Felhunter 417, Voidwalker 1860,
-- Succubus 1863) sa rodia na fixed nizkom leveli a davaju 1 dmg.
-- Pri spawne sa zrovnaju na level majitela (hrac) a dofulluju HP.
-- Damage je potom prirodzene trosku nizsi ako hracov (NPC stats vs gear).
-- =====================================================================
if IS_WORLD_STATE then return end

local PETS = {[416] = true, [417] = true, [1860] = true, [1863] = true}

local function SyncLevel(_, summon)
    if not summon or not summon:IsAlive() then return end
    local okO, owner = pcall(function() return summon:GetOwner() end)
    if not okO or not owner or not owner.GetLevel then return end
    local okL, lvl = pcall(function() return owner:GetLevel() end)
    if not okL or not lvl or lvl < 1 then return end
    local okS, slvl = pcall(function() return summon:GetLevel() end)
    if okS and slvl == lvl then return end
    pcall(function() summon:SetLevel(lvl) end)
    pcall(function()
        local mx = summon:GetMaxHealth()
        summon:SetHealth(mx)
    end)
    print("[pet_scaling] " .. summon:GetName() .. " synced to level " .. lvl)
end

for entry in pairs(PETS) do
    RegisterCreatureEvent(entry, 5, SyncLevel)   -- ON_SPAWN
end
print("[pet_scaling] loaded")
