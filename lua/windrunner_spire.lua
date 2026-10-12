-- Windrunner Spire: after Commander Kroluk (the Promenade) falls, the way up opens: everybody near him is carried to The Pinnacle,
-- where The Restless Heart waits. (The real dungeon opens a way up; this core has no instance script for it.)
if IS_WORLD_STATE then return end
local MAP, KROLUK = 2805, 231631
local PINNACLE = {x = 5216.823, y = -3072.4763, z = 300.36676, o = 4.71}   -- from .gps on The Pinnacle
RegisterCreatureEvent(KROLUK, 4, function(_, c)   -- ON_DIED
    local players = c:GetPlayersInRange(120)
    if not players then return end
    for _, p in ipairs(players) do
        p:SendBroadcastMessage("|cff00ccff[Windrunner Spire]|r The way up to The Pinnacle opens...")
        p:RegisterEvent(function(_, _, _, pl)
            if pl and pl:IsInWorld() and pl:GetMapId() == MAP then pl:Teleport(MAP, PINNACLE.x, PINNACLE.y, PINNACLE.z, PINNACLE.o) end
        end, 8000, 1)
    end
end)
print("[windrunner_spire] Kroluk opens the way to The Pinnacle")
