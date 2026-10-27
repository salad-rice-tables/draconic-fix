-- =====================================================================
-- Founder's Point (map 2735): the Neighborhood Watch walks its beat along the streets.
-- The watch posts of the neighborhood (the spawn points of the watch NPCs) are chained into a route; every watchman walks
-- between his own post and the nearest posts of that route on the navmesh (so he stays on the roads), stops for a
-- moment at each one, and then walks back. Runs only near players.
-- Loads at worldserver start from lua_scripts/ (map state).
-- =====================================================================
if IS_WORLD_STATE then return end
if not MAP_Timer or not MAP_Players then return end

local MAP_ID   = 2735
local WATCH    = { [239415] = true, [244806] = true, [256085] = true }
local TICK_MS  = 6000
local SCAN     = 150
local MAX_HOP  = 260          -- never walk further than this between two posts
local SPAN     = 3            -- posts to each side of his own that a watchman visits
local PAUSE    = { 12, 35 }   -- seconds at a post

local POSTS = nil
local function Dist2(ax, ay, bx, by) return (ax - bx) ^ 2 + (ay - by) ^ 2 end

local function LoadPosts()
    local pts = {}
    local q = WorldDBQuery(string.format("SELECT DISTINCT position_x, position_y, position_z FROM creature WHERE map = %d AND id IN (239415, 244806, 256085)", MAP_ID))
    if q then repeat pts[#pts + 1] = { x = q:GetFloat(0), y = q:GetFloat(1), z = q:GetFloat(2) } until not q:NextRow() end
    if #pts == 0 then return {} end
    -- nearest-neighbour chain, starting from the westmost post
    table.sort(pts, function(a, b) return a.x < b.x end)
    local route, left = { table.remove(pts, 1) }, pts
    while #left > 0 do
        local last, bi, bd = route[#route], 1, math.huge
        for i, p in ipairs(left) do
            local d = Dist2(last.x, last.y, p.x, p.y)
            if d < bd then bi, bd = i, d end
        end
        route[#route + 1] = table.remove(left, bi)
    end
    return route
end

local STATE = {}   -- guid -> { idx, dir, nextT }

local function Nearest(c)
    local bi, bd = 1, math.huge
    for i, p in ipairs(POSTS) do
        local d = Dist2(c:GetX(), c:GetY(), p.x, p.y)
        if d < bd then bi, bd = i, d end
    end
    return bi
end

local function Step(c, now)
    local guid = tostring(c:GetGUIDLow())
    local st = STATE[guid]
    if not st then
        local h = Nearest(c)
        st = { home = h, idx = h, dir = (math.random() < 0.5) and 1 or -1, nextT = now + math.random(PAUSE[1], PAUSE[2]) }
        STATE[guid] = st
        return
    end
    if now < st.nextT or c:IsMoving() then return end
    local nxt = st.idx + st.dir
    if nxt < st.home - SPAN or nxt > st.home + SPAN or nxt < 1 or nxt > #POSTS then
        st.dir = -st.dir
        nxt = st.idx + st.dir
    end
    local p = POSTS[nxt]
    if not p or Dist2(c:GetX(), c:GetY(), p.x, p.y) > MAX_HOP ^ 2 then
        st.dir = -st.dir
        st.nextT = now + math.random(PAUSE[1], PAUSE[2])
        return
    end
    st.idx = nxt
    st.nextT = now + math.random(PAUSE[1], PAUSE[2]) + 25
    local ok, moved = pcall(function() return c:MoveToSafe(1, p.x, p.y, p.z) end)
    if not ok or not moved then pcall(function() c:MoveTo(1, p.x, p.y, p.z, true) end) end
end

local function Tick()
    if not POSTS then POSTS = LoadPosts() end
    if #POSTS < 2 then return end
    local now = os.time()
    for _, p in ipairs(LW_Players()) do
        if p:GetMapId() == MAP_ID then
            local ok, list = pcall(function() return p:GetCreaturesInRange(SCAN) end)
            if ok and list then
                for _, c in ipairs(list) do
                    if WATCH[c:GetEntry()] and c:IsAlive() and not c:IsInCombat()
                       and not (HAS_CPP_SCRIPT and HAS_CPP_SCRIPT[c:GetEntry()]) then
                        pcall(Step, c, now)
                    end
                end
            end
        end
    end
end

MAP_Timer("neighborhood_watch.tick", Tick, TICK_MS)
print("[neighborhood_watch] Founder's Point watch patrols the streets")
