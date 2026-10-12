-- =====================================================================
-- Living World: guards walk a beat around their post.
-- About half of the standing guards (decided per spawn) leave their post
-- every few minutes, walk a short loop nearby, look around and come back.
-- The other half hold the post, so gates and doors are never empty.
-- Guards on DB waypoint paths already walk and are left alone.
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

local GUARDS = {
    74228, 45015,          -- Darkspear Headhunter (Orgrimmar)
    3296,                  -- Orgrimmar Grunt
    3297,                  -- Sen'jin Watcher (Durotar)
    5953, 51911, 75685,    -- Razor Hill Grunt
    9900115, 9900116,      -- our road and night watch grunts (torches only, they follow leaders)
}

-- Every guard carries a torch at night (spell 445981 "Flickering Torch",
-- a 10 min aura, refreshed while the night lasts, removed at dawn).
local TORCH = 445981
local function IsNight()
    local ok, t = pcall(GetGameTime)
    if not ok or type(t) ~= "number" then t = os.time() end
    local h = math.floor(t / 3600) % 24
    return h >= 21 or h < 6
end
local function Torch(_, _, _, c)
    if not c or not c:IsAlive() then return end
    local okH, has = pcall(function() return c:HasAura(TORCH) end)
    if IsNight() then
        if not (okH and has) then pcall(function() c:AddAura(TORCH, c) end) end
    elseif okH and has then
        pcall(function() c:RemoveAura(TORCH) end)
    end
end
local BEAT_SHARE = 0.5     -- share of standing guards that walk a beat
local TICK = 3000
local STAND, E_ROAR, E_POINT = 0, 15, 25
local MOTION_WAYPOINT = 2

-- Ground height at x,y. This Eluna build wants a WorldObject (for its phase)
-- as the 3rd argument of Map:GetHeight; any failure falls back to z.
local function Ground(obj, x, y, z)
    local ok, h = pcall(function() return obj:GetMap():GetHeight(x, y, obj) end)
    if ok and type(h) == "number" and h > -10000 and math.abs(h - z) < 30 then return h end
    return z
end

local function Spot(c, hx, hy, hz)
    local a, d = math.random() * 2 * math.pi, math.random(6, 14)
    local x, y = hx + math.cos(a) * d, hy + math.sin(a) * d
    return x, y, Ground(c, x, y, hz)
end

local function Beat(_, _, _, c)
    if not c or not c:IsAlive() or c:IsInCombat() then return end
    local st = c:Data():Get("lw_beat")
    if type(st) ~= "number" then return end
    -- st counts down ticks; phases: >0 waiting at post, 0 = leave, -1.. = out on the beat
    if st > 0 then
        c:Data():Set("lw_beat", st - 1)
        return
    end
    local hx, hy, hz, ho = c:GetHomePosition()
    if st == 0 then
        local x, y, z = Spot(c, hx, hy, hz)
        c:SetWalk(true)
        SafeMove(c, 0, x, y, z)
        c:Data():Set("lw_beat", -1)
    elseif st == -1 then
        if not c:IsMoving() then
            c:PerformEmote(math.random() < 0.5 and E_POINT or 0)
            c:Data():Set("lw_beat", -2)
        end
    elseif st > -6 then
        c:Data():Set("lw_beat", st - 1)   -- look around for a few ticks
    else
        SafeMove(c, 0, hx, hy, hz)     -- back to the post
        c:RegisterEvent(function(_, _, _, u)
            if u and u:IsAlive() and not u:IsMoving() then u:SetFacing(ho) end
        end, 15000, 1)
        c:Data():Set("lw_beat", math.random(20, 50))
    end
end

local function OnSpawn(_, c)
    c:RegisterEvent(Torch, 30000, 0)
    Torch(nil, nil, nil, c)
    -- only DB spawns; summoned guards (caravan escort, road patrol) follow their leader
    local okS, sid = pcall(function() return tonumber(tostring(c:GetDBTableGUIDLow())) end)
    if not okS or not sid or sid == 0 then return end
    local ok, mt = pcall(function() return c:GetDefaultMovementType() end)
    if not ok or mt == MOTION_WAYPOINT or mt == 1 then return end -- already walks
    if math.random() > BEAT_SHARE then return end                  -- holds the post
    c:Data():Set("lw_beat", math.random(5, 60))
    pcall(function() c:Data():Set("lw_claim", "guard") end)
    c:RegisterEvent(Beat, TICK, 0)
end

for _, e in ipairs(GUARDS) do
    if not (HAS_CPP_SCRIPT and HAS_CPP_SCRIPT[e]) then RegisterCreatureEvent(e, 5, OnSpawn) end -- ON_SPAWN
end
print("[lw] guard beats loaded: " .. #GUARDS .. " guard types")
