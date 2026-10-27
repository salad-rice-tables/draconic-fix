-- Delve The Shadow Enclave (86636 Void Walk With Me): Valeera role choice. Retail objective "Select a Combat Role for Valeera Sanguinar"
-- is criteria tree 225238 = Gain Aura of one of the role auras; gossip replaces the companion config UI.
if IS_WORLD_STATE then return end
local MENU = 912046759
local ROLE = { [1] = 1250821, [2] = 1249646, [3] = 1251118 }   -- Defender / Healer / Damage Dealer
RegisterCreatureGossipEvent(242099, 2, function(_, player, creature, sender, intid)
    local spell = ROLE[intid]
    if sender == MENU and spell then
        local ok, aura = pcall(function() return player:AddAura(spell, player) end)
        pcall(function() PrintInfo("[valeera_role] " .. player:GetName() .. " role aura " .. spell .. " -> " .. tostring(aura)) end)
        pcall(function() player:GossipComplete() end)
        return true
    end
    return false
end)
print("[midnight_valeera_role] loaded")
