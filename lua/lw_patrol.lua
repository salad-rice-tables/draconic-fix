-- =====================================================================
-- Living World: patrols (world.lw_patrol, routes from world.lw_route_node).
--  * Road patrols march in formation between settlements. Out on the road
--    they sometimes make camp beside it: campfire, sit, eat, drink, talk,
--    then break camp and march on.
--  * City watches (night_only = 1) walk their loop at night and wait at
--    the barracks (node 1) during the day.
-- Routes are recorded in game with .lw rec (lw_engine.lua).
-- GM: .lw patrol <id>   spawn the leader of patrol <id> at node 1 (saved)
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

local TICK = 1000
local ARRIVE_DIST = 3
local CAMPFIRE = 1798          -- gameobject "Campfire"
-- camp props (generic retail gameobjects): Orc Tent, Bedroll, Cooking Pot
local TENT, BEDROLL, COOKPOT = 193215, 224602, 187370
local CAMP_OFFSET = 14         -- yards off the road
local CAMP_COOLDOWN = 600      -- seconds of marching between camps

local EMOTE_EAT, EMOTE_TALK, EMOTE_LAUGH = 7, 1, 11
local STAND, SIT, SLEEP = 0, 1, 3

local CAMP_LINES = {
    "Pass the jerky.",
    "Feet are killing me.",
    "Quiet road today. I don't like it.",
    "Ten minutes, then we move.",
    "Who packed this bread? It's stone.",
    "Remember that raid on the south farms?",
    "Keep one eye on the ridge.",
    "Water's warm. Still better than nothing.",
}
local MARCH_LINES = {
    "Keep formation!",
    "Eyes open. Bandit country.",
    "Pick up the pace!",
    "Halt talk, mind the road.",
}

local PATROLS = {}   -- id -> cfg + nodes
local STATE = {}     -- id -> live state (one leader per patrol)

local function GameHour()
    local ok, t = pcall(GetGameTime)
    if not ok or type(t) ~= "number" then t = os.time() end
    return math.floor(t / 3600) % 24
end
local _forceNightAt, _forceNight = 0, nil
local function ForceNight() -- GM test: world.lw_state force_night=1 (cached 30 s)
    if os.time() - _forceNightAt > 30 then
        _forceNightAt = os.time()
        local ok, r = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = 'force_night'")
        _forceNight = ok and r and r:GetString(0) == "1"
    end
    return _forceNight
end
local function IsNight()
    if ForceNight() then return true end
    local h = GameHour()
    return h >= 21 or h < 6
end

local function Load(id)
    local q = WorldDBQuery(string.format(
        "SELECT route, leader_entry, member_entry, members, loop_route, camp_chance, camp_minutes, night_only FROM lw_patrol WHERE id = %d", id))
    if not q then return nil end
    local P = {id = id, route = q:GetUInt32(0), leader = q:GetUInt32(1), member = q:GetUInt32(2),
               members = q:GetUInt32(3), loop = q:GetUInt32(4) == 1, campChance = q:GetUInt32(5),
               campMin = q:GetUInt32(6), nightOnly = q:GetUInt32(7) == 1, nodes = {}}
    local n = WorldDBQuery(string.format(
        "SELECT map, x, y, z FROM lw_route_node WHERE route = %d ORDER BY idx", P.route))
    if n then
        repeat
            P.nodes[#P.nodes + 1] = {map = n:GetUInt32(0), x = n:GetFloat(1), y = n:GetFloat(2), z = n:GetFloat(3)}
        until not n:NextRow()
    end
    PATROLS[id] = P
    return P
end

local function Members(leader, st)
    local out = {}
    local map = leader:GetMap()
    for _, guid in ipairs(st.members) do
        local c = map:GetWorldObject(guid)
        if c and c:IsAlive() then out[#out + 1] = c end
    end
    return out
end

-- Two columns behind the leader.
local function FallIn(leader, st)
    for k, m in ipairs(Members(leader, st)) do
        m:SetStandState(STAND)
        local row = math.floor((k + 1) / 2)
        local side = (k % 2 == 1) and 1 or -1
        m:MoveFollow(leader, 2.5 * row, math.pi + side * 0.35)
    end
end

local function SpawnMembers(leader, P, st)
    local x, y, z, o = leader:GetLocation()
    st.members = {}
    for k = 1, P.members do
        local m = leader:SpawnCreature(P.member, x - k, y, z, o, 8, 0) -- 8 = manual despawn
        if m then
            st.members[#st.members + 1] = m:GetGUID()
            pcall(function() m:Data():Set("lw_claim", "patrol") end)
        end
    end
    FallIn(leader, st)
end

local function Next(P, st)
    local n = st.i + st.dir
    if n < 1 or n > #P.nodes then
        if P.loop then n = 1 else st.dir = -st.dir; n = st.i + st.dir end
    end
    return n
end

-- ---------------------------------------------------------------- camp

-- Ground height at x,y. This Eluna build wants a WorldObject (for its phase)
-- as the 3rd argument of Map:GetHeight; any failure falls back to z.
local function Ground(obj, x, y, z)
    local ok, h = pcall(function() return obj:GetMap():GetHeight(x, y, obj) end)
    if ok and type(h) == "number" and h > -10000 and math.abs(h - z) < 30 then return h end
    return z
end

local function MakeCamp(leader, P, st)
    local a, b = P.nodes[st.i], P.nodes[Next(P, {i = st.i, dir = st.dir})]
    -- step off the road, perpendicular to its direction
    local dx, dy = b.x - a.x, b.y - a.y
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 1 then return false end
    local side = (math.random() < 0.5) and 1 or -1
    local cx = a.x - dy / len * CAMP_OFFSET * side
    local cy = a.y + dx / len * CAMP_OFFSET * side
    local cz = Ground(leader, cx, cy, a.z)
    -- fire in the middle, tent and bedroll further from the road, pot by the fire
    local ox, oy = -dy / len * side, dx / len * side   -- unit vector away from the road
    local map = leader:GetMap()
    local function Prop(entry, px, py, face)
        local g = leader:SummonGameObject(entry, px, py, Ground(leader, px, py, cz), face or 0, 0)
        if g then st.props[#st.props + 1] = g:GetGUID() end
    end
    st.props = {}
    local away = math.atan2(oy, ox)
    Prop(CAMPFIRE, cx, cy)
    Prop(COOKPOT, cx + 1.2, cy + 1.2)
    Prop(TENT, cx + ox * 7, cy + oy * 7, away + math.pi)
    local bx, by = cx + ox * 4 - oy * 3, cy + oy * 4 + ox * 3
    Prop(BEDROLL, bx, by, away)
    st.camp = {x = cx, y = cy, z = cz, bx = bx, by = by, left = P.campMin * 60, seated = false}
    -- everyone walks to a spot around the fire; the last one takes the bedroll
    local all = Members(leader, st)
    table.insert(all, 1, leader)
    for k, u in ipairs(all) do
        if k == #all and k > 2 then
            SafeMove(u, 0, bx, by, Ground(leader, bx, by, cz))
        else
            local ang = (k / #all) * 2 * math.pi
            SafeMove(u, 0, cx + math.cos(ang) * 2.5, cy + math.sin(ang) * 2.5, cz)
        end
    end
    leader:SendUnitSay("Break here. Ten minutes, then we march.", 0)
    return true
end

local function CampTick(leader, P, st)
    local c = st.camp
    c.left = c.left - 1
    local all = Members(leader, st)
    table.insert(all, 1, leader)
    if not c.seated and c.left < P.campMin * 60 - 15 then
        c.seated = true
        for k, u in ipairs(all) do
            if k == #all and k > 2 then
                u:SetStandState(SLEEP)         -- napping on the bedroll
            else
                u:SetFacing(math.atan2(c.y - select(2, u:GetLocation()), c.x - select(1, u:GetLocation())))
                u:SetStandState(SIT)
            end
        end
    end
    if c.seated and math.random() < 0.06 then
        local u = all[math.random(#all)]
        if math.random() < 0.5 then
            u:PerformEmote(EMOTE_EAT)
        else
            u:SendUnitSay(CAMP_LINES[math.random(#CAMP_LINES)], 0)
            u:PerformEmote(math.random() < 0.3 and EMOTE_LAUGH or EMOTE_TALK)
        end
    end
    if c.left <= 0 then
        for _, guid in ipairs(st.props or {}) do
            local g = leader:GetMap():GetWorldObject(guid)
            if g then g:Despawn() end
        end
        st.props, st.camp = nil, nil
        st.lastCamp = os.time()
        leader:SetStandState(STAND)
        leader:SendUnitSay("On your feet! We move.", 0)
        FallIn(leader, st)
        st.issued = 0
    end
end

-- ---------------------------------------------------------------- brain

local function Brain(_, _, _, leader)
    if not leader or not leader:IsAlive() then return end
    local id = leader:Data():Get("lw_patrol")
    local P, st = PATROLS[id], STATE[id]
    if not P or not st or #P.nodes < 2 then return end
    if leader:IsInCombat() then return end
    if st.camp then CampTick(leader, P, st) return end

    -- city watch: off duty during the day, holds position (no march back to node 1)
    if P.nightOnly and not IsNight() then
        if not st.parked then
            st.parked = true
            st.issued = 0
        end
        return
    end
    st.parked = nil
    local node = P.nodes[st.i]
    local x, y, z = leader:GetLocation()
    -- 3D prichod (povodne len 2D): hlidka sa nezasekne pod/nad uzlom
    if math.sqrt((x - node.x) ^ 2 + (y - node.y) ^ 2) <= ARRIVE_DIST and math.abs((z or 0) - (node.z or 0)) <= 5 then
        leader:SetHomePosition(node.x, node.y, node.z, leader:GetO())
        -- dopln padlych clenov na uzle (nie v boji)
        local alive = Members(leader, st)
        if #alive < P.members then
            local lx, ly, lz, lo = leader:GetLocation()
            for k = #alive + 1, P.members do
                local m = leader:SpawnCreature(P.member, lx - k, ly, lz, lo, 8, 0)
                if m then
                    st.members[#st.members + 1] = m:GetGUID()
                    pcall(function() m:Data():Set("lw_claim", "patrol") end)
                end
            end
            FallIn(leader, st)
        end
        if P.campChance > 0 and os.time() - (st.lastCamp or 0) > CAMP_COOLDOWN
            and math.random(100) <= P.campChance and MakeCamp(leader, P, st) then
            return
        end
        st.i = Next(P, st)
        st.issued = 0
        node = P.nodes[st.i]
    end
    if st.issued <= 0 then
        leader:SetWalk(true)
        SafeMove(leader, st.i, node.x, node.y, Ground(leader, node.x, node.y, node.z))
        st.issued = 5
        st.stuckX, st.stuckY, st.stuckN = x, y, 0
        if math.random() < 0.01 then leader:SendUnitSay(MARCH_LINES[math.random(#MARCH_LINES)], 0) end
    else
        st.issued = st.issued - 1
        -- zaseknuty vodca (pozicia sa nehybe): vydaj prikaz znovu
        if st.stuckX and math.sqrt((x - st.stuckX) ^ 2 + (y - st.stuckY) ^ 2) < 0.5 then
            st.stuckN = (st.stuckN or 0) + 1
            if st.stuckN >= 8 then st.issued = 0; st.stuckN = 0 end
        else
            st.stuckX, st.stuckY, st.stuckN = x, y, 0
        end
    end
end

local function OnLeaderSpawn(_, leader)
    local q = WorldDBQuery(string.format("SELECT id FROM lw_patrol WHERE leader_entry = %d", leader:GetEntry()))
    if not q then return end
    local id = q:GetUInt32(0)
    local P = Load(id)
    if not P or #P.nodes < 2 then return end
    local x, y = leader:GetLocation()
    local best, bi = 1e9, 1
    for i, n in ipairs(P.nodes) do
        local d = (x - n.x) ^ 2 + (y - n.y) ^ 2
        if d < best then best, bi = d, i end
    end
    leader:Data():Set("lw_patrol", id)
    STATE[id] = {i = bi, dir = 1, issued = 0, members = {}}
    SpawnMembers(leader, P, STATE[id])
    leader:RegisterEvent(Brain, TICK, 0)
end

local function OnLeaderRemove(_, leader)
    local id = leader:Data():Get("lw_patrol")
    local st = id and STATE[id]
    if not st then return end
    for _, m in ipairs(Members(leader, st)) do m:DespawnOrUnsummon(0) end
    for _, guid in ipairs(st.props or {}) do
        local g = leader:GetMap():GetWorldObject(guid)
        if g then g:Despawn() end
    end
end

-- GM: .lw patrol <id>
local function OnCommand(_, player, command)
    local a, b, c = string.match(string.lower(command or ""), "^(%S+)%s+(%S+)%s*(%S*)")
    if a ~= "lw" or b ~= "patrol" then return end
    if not player:IsGM() then return false end
    local P = Load(tonumber(c) or 0)
    if not P or #P.nodes < 2 then
        player:SendBroadcastMessage("[Patrol] Unknown patrol or its route has < 2 nodes.")
        return false
    end
    local n = P.nodes[1]
    local ok = pcall(PerformIngameSpawn, 1, P.leader, n.map, 0, n.x, n.y, n.z, player:GetO(), true)
    -- our content lives in the Living World main phase (applies after restart)
    if ok then WorldDBExecute(string.format("UPDATE creature SET PhaseId = 9600 WHERE id = %d AND PhaseId = 0", P.leader)) end
    player:SendBroadcastMessage("[Patrol] " .. (ok and "Leader spawned at node 1 and saved." or "Spawn failed."))
    return false
end

local count = 0
local q = WorldDBQuery("SELECT DISTINCT leader_entry FROM lw_patrol")
if q then
    repeat
        local e = q:GetUInt32(0)
        RegisterCreatureEvent(e, 5, OnLeaderSpawn)    -- ON_SPAWN
        RegisterCreatureEvent(e, 37, OnLeaderRemove)  -- ON_REMOVE
        count = count + 1
    until not q:NextRow()
end
RegisterPlayerEvent(42, OnCommand)
print("[lw] patrols loaded: " .. count .. " leader type(s)")
