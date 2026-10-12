-- Green portals to The Coiled Isle (curse of Ula'tek isle). Spawned by scratchpad/coiled_portals.py:
-- one at the Echo Isles start, one at the Zuldazar start, and a return portal on the isle. Trolls only (Darkspear 8, Zandalari 31).
local GO_IN, GO_OUT = 9712510, 9712511
local TROLLS = {[8] = true, [31] = true}
local COILED = {map = 0, x = 6377.93, y = -12855.46, z = 35.5, o = 3.1}   -- Mlurkkr Mire, The Coiled Isle
local HOME = {[8] = {1, -1171.4, -5263.6, 0.8, 5.79}, [31] = {1642, -1127.3, 805.4, 500.2, 3.18}}

pcall(RegisterGameObjectEvent, GO_IN, 14, function(_, go, player)
    if not player then return true end
    if not TROLLS[player:GetRace()] then
        player:SendBroadcastMessage("|cff00ff96[Portal]|r Only trolls can pass through this portal.")
        return true
    end
    player:SendBroadcastMessage("|cff00ff96[Portal]|r The portal carries you to The Coiled Isle...")
    player:Teleport(COILED.map, COILED.x, COILED.y, COILED.z, COILED.o)
    return true
end)

pcall(RegisterGameObjectEvent, GO_OUT, 14, function(_, go, player)
    if not player then return true end
    local h = HOME[player:GetRace()] or HOME[8]
    player:Teleport(h[1], h[2], h[3], h[4], h[5])
    return true
end)
