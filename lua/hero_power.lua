-- Hero's Power (hotfix spell 1409020, made by scratchpad/hero_power.py): a hidden passive aura that gives every player spell power, healing power and attack power
-- that grow with the level. Retail damage and healing spells are coefficient x spell power / attack power, so a hero without gear did 0 damage and the tooltips showed 0.
-- The aura is applied at login and again at every level up (the points are worked out when the aura is applied).
if IS_WORLD_STATE then return end

local POWER = 1409020

local function Apply(player)
    if not player or not player:IsInWorld() then return end
    pcall(function() player:RemoveAura(POWER) end)
    pcall(function() player:AddAura(POWER, player) end)
end

RegisterPlayerEvent(3, function(_, player)   -- login
    player:RegisterEvent(function(_, _, _, p) Apply(p) end, 2000, 1)
end)
RegisterPlayerEvent(13, function(_, player)   -- level change (the new level is already set)
    player:RegisterEvent(function(_, _, _, p) Apply(p) end, 500, 1)
end)
RegisterPlayerEvent(28, function(_, player)   -- map change: the aura follows into the new Lua state
    player:RegisterEvent(function(_, _, _, p) if p and not p:HasAura(POWER) then Apply(p) end end, 1500, 1)
end)
print("[hero_power] loaded")
