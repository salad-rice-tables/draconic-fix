-- 86806 Luminous Wings (retail flow, video E3m8C7fw0H4):
--  click Empowered Dragonhawk 237221 -> 1224696 -> vehicle 240226 (bar 1224774 / 1227927 / 1227878, see SQL 20261021_midnight_*).
--  The vehicle must fly under the player; after 16 Void Invaders (242505) and 3 civilians (241823) the end scene 1261505
--  plays ("You did it, champion!", credit 258837) and 1224709 puts the player back at the Silver Landing.
if IS_WORLD_STATE then return end

local QUEST, VEHICLE = 86806, 240226
local SCENE, LEAVE = 1261505, 1224709
local MOVE_FLIGHT = 6
local done = {}

-- 1224705 summons the vehicle at a fixed DB point (the static dragonhawk). Seat 25394 hides the passenger and has no
-- attachment, so if the rider is not standing right there the camera stays on the rider's old spot ("camera far away").
-- Bring the vehicle to its rider first.
local function RiderOf(c)
    local ok, o = pcall(function() return c:GetOwner() end)
    if ok and o and o:IsInWorld() then return o end
    local best, bd
    for _, p in ipairs(MAP_Players and MAP_Players() or {}) do
        if p:GetMapId() == c:GetMapId() and p:HasAura(1224705) then
            local d = p:GetDistance(c)
            if not bd or d < bd then best, bd = p, d end
        end
    end
    return best
end

RegisterCreatureEvent(VEHICLE, 5, function(_, creature)          -- on spawn
    local r = RiderOf(creature)
    if r and r:GetDistance(creature) > 4 then
        local x, y, z, o = r:GetLocation()
        pcall(function() creature:NearTeleport(x, y, z, o) end)
    end
    creature:RegisterEvent(function(_, _, _, c)
        pcall(function() c:SetCanFly(true) end)
        pcall(function() c:SetDisableGravity(true) end)
        pcall(function() c:SetSpeed(MOVE_FLIGHT, 3.0, true) end)
    end, 300, 1)
end)

local function Tick()
    for _, p in ipairs(MAP_Players()) do
        local ok, st = pcall(function() return p:GetQuestStatus(QUEST) end)
        if ok and st == 3 and p:IsOnVehicle() then
            local key = tostring(p:GetGUID())
            local kills = p:GetReqKillOrCastCurrentCount(QUEST, 242505)
            local saved = p:GetReqKillOrCastCurrentCount(QUEST, 241823)
            if kills >= 16 and saved >= 3 and not done[key] then
                done[key] = true
                pcall(function() p:CastSpell(p, SCENE, true) end)
                p:RegisterEvent(function(_, _, _, pl)
                    pcall(function() pl:CastSpell(pl, LEAVE, true) end)
                    done[tostring(pl:GetGUID())] = nil
                end, 12000, 1)
            end
        end
    end
end

if MAP_Timer then MAP_Timer("luminous_wings", function() pcall(Tick) end, 2000) end
print("[luminous_wings] loaded")

-- Void Invaders (Voidborn Soarling 240263, Umbral Slickette 241807) are hostile targets that never fight back (retail, per user).
-- SAI react-passive gets overwritten by the core's InitializeReactState, so enforce it here on spawn and whenever they engage.
local function Calm(c)
    pcall(function() c:SetReactState(0) end)   -- REACT_PASSIVE
    pcall(function() c:AttackStop() end)
end
for _, entry in ipairs({ 240263, 241807 }) do
    RegisterCreatureEvent(entry, 5, function(_, c) Calm(c); c:RegisterEvent(function(_, _, _, cc) Calm(cc) end, 500, 1) end) -- spawn
    RegisterCreatureEvent(entry, 1, function(_, c) Calm(c) end)                                                              -- enter combat
end
