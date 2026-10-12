-- Companion passives. Some retail abilities only work together with a passive that reacts to them (it listens for the spell id): Shear creates Soul Fragments
-- only through the passive "Shear proc" (203783). A Hero has no class kit, so the passive is learned together with the ability, at login and at every level.
-- Table: custom (hero) spell id -> retail passives that go with it. Add a line when a spell "does nothing" because its passive is missing.
if IS_WORLD_STATE then return end

local COMPANIONS = {
    [1410512] = {203783},   -- Shear -> Shear proc (Soul Fragments)
}

local function Sync(player)
    if not player or not player:IsInWorld() then return end
    for spell, list in pairs(COMPANIONS) do
        local have = false
        pcall(function() have = player:HasSpell(spell) end)
        if have then
            for _, p in ipairs(list) do pcall(function() if not player:HasSpell(p) then player:LearnSpell(p) end end) end
        end
    end
end

RegisterPlayerEvent(3, function(_, player) player:RegisterEvent(function(_, _, _, p) Sync(p) end, 4000, 1) end)    -- login
RegisterPlayerEvent(13, function(_, player) player:RegisterEvent(function(_, _, _, p) Sync(p) end, 1500, 1) end)   -- level change
print("[companions] loaded")
