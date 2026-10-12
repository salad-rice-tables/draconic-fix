-- =====================================================================
-- Founder's Point wagons (256630 Public Carriage, driven by Kellyn): drive from wagon stop to wagon stop, wait a while at every stop, and
-- come back; players board by clicking the wagon (spellclick, vehicle seat) and ride along. Runs while a player is on the map.
-- Loads at worldserver start from lua_scripts/ (map state).
-- =====================================================================
if IS_WORLD_STATE then return end
if not MAP_Timer or not MAP_Players then return end

local MAP_ID, WAGON = 2735, 256630
local TICK_MS = 5000
local WAIT = { 25, 45 }      -- seconds at a stop
local STOPS = nil
local STATE = {}             -- guid -> { idx, dir, nextT }

local function Load()
    STOPS = {}
    local q = WorldDBQuery(string.format("SELECT position_x, position_y, position_z FROM creature WHERE map = %d AND id IN (246971, 247958)", MAP_ID))
    local pts = {}
    if q then repeat pts[#pts + 1] = { x = q:GetFloat(0), y = q:GetFloat(1), z = q:GetFloat(2) } until not q:NextRow() end
    if #pts == 0 then return end
    table.sort(pts, function(a, b) return a.x < b.x end)
    STOPS[1] = table.remove(pts, 1)
    while #pts > 0 do
        local last, bi, bd = STOPS[#STOPS], 1, math.huge
        for i, p in ipairs(pts) do
            local d = (last.x - p.x) ^ 2 + (last.y - p.y) ^ 2
            if d < bd then bi, bd = i, d end
        end
        STOPS[#STOPS + 1] = table.remove(pts, bi)
    end
end

local function Step(c, now)
    local guid = tostring(c:GetGUIDLow())
    local st = STATE[guid]
    if not st then
        local bi, bd = 1, math.huge
        for i, p in ipairs(STOPS) do
            local d = (c:GetX() - p.x) ^ 2 + (c:GetY() - p.y) ^ 2
            if d < bd then bi, bd = i, d end
        end
        STATE[guid] = { idx = bi, dir = 1, nextT = now + math.random(WAIT[1], WAIT[2]) }
        return
    end
    if now < st.nextT or c:IsMoving() then return end
    local nxt = st.idx + st.dir
    if nxt < 1 or nxt > #STOPS then st.dir = -st.dir; nxt = st.idx + st.dir end
    local p = STOPS[nxt]
    if not p then return end
    st.idx = nxt
    st.nextT = now + math.random(WAIT[1], WAIT[2]) + 40
    local ok, moved = pcall(function() return c:MoveToSafe(1, p.x, p.y, p.z) end)
    if not ok or not moved then pcall(function() c:MoveTo(1, p.x, p.y, p.z, true) end) end
end

local function Tick()
    if not STOPS then Load() end
    if #STOPS < 2 then return end
    local players = MAP_Players()
    local here
    for _, p in ipairs(players) do if p:GetMapId() == MAP_ID then here = p break end end
    if not here then return end
    local ok, list = pcall(function() return here:GetCreaturesInRange(5000, WAGON) end)
    if ok and list then
        local now = os.time()
        for _, c in ipairs(list) do if c:IsAlive() then pcall(Step, c, now) end end
    end
end

MAP_Timer("neighborhood_wagon.tick", Tick, TICK_MS)
print("[neighborhood_wagon] Founder's Point wagons run between the wagon stops")
