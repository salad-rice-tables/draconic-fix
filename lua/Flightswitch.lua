local DUMMY_SPELL             = 1900000
local SKYRIDING               = 436854
local STEADY                  = 460003
local BASELINE                = 406095

local function ToggleFlight(player)
    -- Check current state after aura has settled
    if player:HasAura(STEADY) then
        player:RemoveAura(STEADY)
        player:RemoveAura(BASELINE)
        player:CastSpell(player, SKYRIDING, true)
        player:SendBroadcastMessage("Flight style switched to Skyriding.")
    else
        player:RemoveAura(SKYRIDING)
        player:RemoveAura(BASELINE)
        player:CastSpell(player, STEADY, true)
        player:SendBroadcastMessage("Flight style switched to Steady Flight.")
    end
end

local function OnSpellCast(event, player, spell, skipCheck)
    if spell:GetEntry() ~= DUMMY_SPELL then return end
    -- Run toggle after a short delay so auras exist
    CreateLuaEvent(function() ToggleFlight(player) end, 100, 1)
end

RegisterPlayerEvent(5, OnSpellCast)
