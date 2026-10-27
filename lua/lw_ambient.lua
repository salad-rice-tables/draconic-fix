-- =====================================================================
-- Living World: wildlife routines, everywhere in the world.
-- Works around players (no per-entry registration): every few seconds
-- the beasts and critters near each player may graze, wander to a new
-- spot, or lie down for a rest and get back up. Hostile or busy
-- creatures (combat, owned, on a waypoint path) are left alone.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

-- Navmesh-only movement (custom core method MoveToSafe): never fly or cut
-- through walls when no walkable path exists. Falls back on older cores.
local function SafeMove(c, id, x, y, z)
    local ok, moved = pcall(function() return c:MoveToSafe(id, x, y, z) end)
    if ok then return moved end
    c:MoveTo(id, x, y, z, true)
    return true
end

local SCAN_MS = 8000
local SCAN_RANGE = 60
local COOLDOWN = 45            -- seconds between routines of one creature
local ACT_CHANCE = 0.12        -- per scan, per idle creature

local CT_BEAST, CT_CRITTER = 1, 8
local EMOTE_EAT = 7
local STAND, SLEEP = 0, 3
local MOTION_WAYPOINT = 2

-- Ground height at x,y. This Eluna build wants a WorldObject (for its phase)
-- as the 3rd argument of Map:GetHeight; any failure falls back to z.
local function Ground(obj, x, y, z)
    local ok, h = pcall(function() return obj:GetMap():GetHeight(x, y, obj) end)
    if ok and type(h) == "number" and h > -10000 and math.abs(h - z) < 30 then return h end
    return z
end

local function ClaimedByOther(c)
    local ok, v = pcall(function() return c:Data():Get("lw_claim") end)
    if not ok or v == nil or v == "ambient" then return false end
    if v == "workday" then
        local okt, t = pcall(function() return c:Data():Get("lw_claim_t") end)
        if okt and type(t) == "number" and os.time() - t > 600 then return false end
    end
    return true
end
local function Claim(c) pcall(function() c:Data():Set("lw_claim", "ambient") end) end
local function Unclaim(c)
    pcall(function() if c:Data():Get("lw_claim") == "ambient" then c:Data():Set("lw_claim", nil) end end)
end

local function Busy(c)
    local ok, busy = pcall(function()
        return c:IsInCombat() or c:IsMoving() or c:GetOwner() ~= nil or c:GetVictim() ~= nil
            or c:GetDefaultMovementType() == MOTION_WAYPOINT
    end)
    return not ok or busy or ClaimedByOther(c)
end

local function WakeUp(_, _, _, c)
    if c and c:IsAlive() and not c:IsInCombat() then c:SetStandState(STAND) end
    if c then Unclaim(c) end
end

local function Graze(c)
    Claim(c)
    c:PerformEmote(EMOTE_EAT)
    c:RegisterEvent(function(_, _, _, u)
        if u and u:IsAlive() then u:PerformEmote(EMOTE_EAT) end
    end, 3000, 1)
    c:RegisterEvent(function(_, _, _, u) if u then Unclaim(u) end end, 7000, 1)
end

local function Wander(c)
    local hx, hy, hz = c:GetHomePosition()
    if not hx then return end
    Claim(c)
    local ang, d = math.random() * 2 * math.pi, math.random(5, 14)
    local x, y = hx + math.cos(ang) * d, hy + math.sin(ang) * d
    local z = Ground(c, x, y, hz)
    c:SetWalk(true)
    SafeMove(c, 0, x, y, z)
    c:RegisterEvent(function(_, _, _, u) if u then Unclaim(u) end end, 20000, 1)
end

local function Rest(c)
    Claim(c)
    c:SetStandState(SLEEP)
    c:RegisterEvent(WakeUp, math.random(20, 50) * 1000, 1)
end

local function Routine(c)
    local r = math.random()
    if r < 0.45 then Graze(c)
    elseif r < 0.8 then Wander(c)
    else Rest(c) end
end

local function Scan(_, _, _, player)
    if not player or not player:IsInWorld() then return end
    local list = player:GetCreaturesInRange(SCAN_RANGE)
    if not list then return end
    local now = os.time()
    for _, c in ipairs(list) do
        local okT, t = pcall(function() return c:GetCreatureType() end)
        if okT and (t == CT_BEAST or t == CT_CRITTER) and c:IsAlive() then
            local last = c:Data():Get("lw_amb") or 0
            if type(last) ~= "number" then last = 0 end
            if now - last >= COOLDOWN and math.random() < ACT_CHANCE and not Busy(c) then
                c:Data():Set("lw_amb", now)
                pcall(Routine, c)
            end
        end
    end
end

-- one timer per map state over its players (multistate safe)
if MAP_Timer then
    MAP_Timer("lw_ambient.Scan", function()
        for _, p in ipairs(LW_Players()) do pcall(Scan, nil, nil, nil, p) end
    end, SCAN_MS)
end
print("[lw] wildlife routines loaded")
