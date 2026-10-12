-- =====================================================================
-- Living World engine v1: route recorder + caravans.
-- Data lives in world.lw_route_node / world.lw_caravan (Custom/sql/lw_engine.sql).
--
-- GM commands (record a road by riding it):
--   .lw rec <route>         start recording, a node every REC_STEP yards
--   .lw end                 stop recording
--   .lw stop <wait_s> <name>  mark your position as a stop (adds a node)
--   .lw clear <route>       delete all nodes of a route
--   .lw spawn <route>       spawn the caravan master at node 1 (saved to DB)
--   .lw info <route>        node / stop count
--   .lw patrol <id>         spawn a patrol leader (lw_patrol.lua)
-- Players: talk to the caravan master at a stop, pick a destination, pay,
-- ride on the kodo until the caravan reaches it.
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

local REC_STEP = 20        -- yards between recorded nodes
local TICK = 1000          -- caravan brain tick (ms)
local ARRIVE_DIST = 3
local TAG = "|cffffd200[Caravan]|r "

local ROUTES = {}          -- route -> {nodes = {...}, cfg = {...}}
local RIDERS = {}          -- route -> {playerName = destIdx}
local REC = {}             -- playerName -> {route, idx, x, y}
local STATE = {}           -- route -> live caravan state (one master per route)

-- ---------------------------------------------------------------- data

local function LoadRoute(route)
    local nodes = {}
    local q = WorldDBQuery(string.format(
        "SELECT idx, map, x, y, z, stop, wait_s FROM lw_route_node WHERE route = %d ORDER BY idx", route))
    if q then
        repeat
            nodes[#nodes + 1] = {
                idx = q:GetUInt32(0), map = q:GetUInt32(1),
                x = q:GetFloat(2), y = q:GetFloat(3), z = q:GetFloat(4),
                stop = (not q:IsNull(5)) and q:GetString(5) or nil, wait = q:GetUInt32(6),
            }
        until not q:NextRow()
    end
    local cfg = nil
    local c = WorldDBQuery(string.format(
        "SELECT name, master_entry, kodo_entry, guard_entry, guards, copper_per_yard, pingpong FROM lw_caravan WHERE route = %d", route))
    if c then
        cfg = {name = c:GetString(0), master = c:GetUInt32(1), kodo = c:GetUInt32(2), guard = c:GetUInt32(3),
               guards = c:GetUInt32(4), cpy = c:GetUInt32(5), pingpong = c:GetUInt32(6) == 1}
    end
    ROUTES[route] = {nodes = nodes, cfg = cfg}
    return ROUTES[route]
end

local function RouteByMaster(entry)
    local q = WorldDBQuery(string.format("SELECT route FROM lw_caravan WHERE master_entry = %d", entry))
    return q and q:GetUInt32(0) or nil
end

-- Ground height at x,y. This Eluna build wants a WorldObject (for its phase)
-- as the 3rd argument of Map:GetHeight; any failure falls back to z.
local function Ground(obj, x, y, z)
    local ok, h = pcall(function() return obj:GetMap():GetHeight(x, y, obj) end)
    if ok and type(h) == "number" and h > -10000 and math.abs(h - z) < 30 then return h end
    return z
end

local function Dist2(a, b)
    return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2)
end

-- Road length between two node positions (in list order).
local function RoadLength(nodes, from, to)
    local d, step = 0, (to > from) and 1 or -1
    local i = from
    while i ~= to do
        d = d + Dist2(nodes[i], nodes[i + step])
        i = i + step
    end
    return d
end

local function Money(copper)
    local g, s, c = math.floor(copper / 10000), math.floor(copper / 100) % 100, copper % 100
    local out = {}
    if g > 0 then out[#out + 1] = g .. "g" end
    if s > 0 then out[#out + 1] = s .. "s" end
    if c > 0 or #out == 0 then out[#out + 1] = c .. "c" end
    return table.concat(out, " ")
end

-- ---------------------------------------------------------------- caravan

local ROAD_LINES = {
    "Keep the line tight! Eyes on the ridges!",
    "Steady, kodo. Steady.",
    "Water stop at the next post.",
    "Stay close to the wagon, travelers.",
    "Bandit country ahead. Weapons ready.",
}

local function Escort(master)
    local st = STATE[master:Data():Get("lw_route") or 0]
    local cfg = ROUTES[st.route].cfg
    local x, y, z, o = master:GetLocation()
    local kodo = master:SpawnCreature(cfg.kodo, x - 3, y, z, o, 8, 0) -- 8 = manual despawn
    if kodo then
        kodo:MoveFollow(master, 3, math.pi)
        st.kodo = kodo:GetGUID()
        pcall(function() kodo:Data():Set("lw_claim", "caravan") end)
    end
    st.guards = {}
    for i = 1, cfg.guards do
        local g = master:SpawnCreature(cfg.guard, x + 2, y + i, z, o, 8, 0)
        if g then
            g:MoveFollow(master, 4, (i % 2 == 0) and (math.pi / 2) or (-math.pi / 2))
            st.guards[#st.guards + 1] = g:GetGUID()
            pcall(function() g:Data():Set("lw_claim", "caravan") end)
        end
    end
end

local function Kodo(master)
    local st = STATE[master:Data():Get("lw_route") or 0]
    if not st.kodo then return nil end
    return master:GetMap():GetWorldObject(st.kodo)
end

local function DropRiders(master, node)
    local st = STATE[master:Data():Get("lw_route") or 0]
    local riders = RIDERS[st.route] or {}
    for name, dest in pairs(riders) do
        if dest == node.idx then
            local p = FindPlayer(name)
            if p then
                local x, y, z, o = master:GetLocation()
                p:Teleport(node.map, x + 2, y + 2, z + 0.5, o) -- leaving the seat
                p:SendBroadcastMessage(TAG .. "We have arrived at " .. node.stop .. ". Safe travels!")
            end
            riders[name] = nil
        end
    end
end

local function NextIndex(st, count, pingpong)
    local n = st.i + st.dir
    if n < 1 or n > count then
        if pingpong then
            st.dir = -st.dir
            n = st.i + st.dir
        else
            n = 1
        end
    end
    return n
end

local function Brain(_, _, _, master)
    if not master or not master:IsAlive() then return end
    local st = STATE[master:Data():Get("lw_route") or 0]
    local R = ROUTES[st.route]
    local nodes = R.nodes
    if #nodes < 2 then return end
    if master:IsInCombat() then return end
    if st.wait > 0 then
        st.wait = st.wait - 1
        if st.wait == 0 then
            master:SendUnitSay("Caravan moving out! All aboard!", 0)
            st.atStop = false
            st.i = NextIndex(st, #nodes, R.cfg.pingpong)
            st.issued = 0
        end
        return
    end
    local node = nodes[st.i]
    local x, y, z = master:GetLocation()
    if math.sqrt((x - node.x) ^ 2 + (y - node.y) ^ 2) <= ARRIVE_DIST and math.abs((z or 0) - (node.z or 0)) <= 5 then
        master:SetHomePosition(node.x, node.y, node.z, master:GetO())
        -- dopln padly sprievod na zastavke (karavana nejazdi bezbrane naveky)
        do
            local aliveG, totalG = 0, 0
            for _, guid in ipairs(st.guards or {}) do
                totalG = totalG + 1
                local g = master:GetMap():GetWorldObject(guid)
                if g and g:IsAlive() then aliveG = aliveG + 1 end
            end
            local cfg = R.cfg
            if not Kodo(master) then
                local mx, my, mz, mo = master:GetLocation()
                local kodo = master:SpawnCreature(cfg.kodo, mx - 3, my, mz, mo, 8, 0)
                if kodo then
                    kodo:MoveFollow(master, 3, math.pi)
                    st.kodo = kodo:GetGUID()
                    pcall(function() kodo:Data():Set("lw_claim", "caravan") end)
                end
            end
            if aliveG < cfg.guards then
                local mx, my, mz, mo = master:GetLocation()
                for i = aliveG + 1, cfg.guards do
                    local g = master:SpawnCreature(cfg.guard, mx + 2, my + i, mz, mo, 8, 0)
                    if g then
                        g:MoveFollow(master, 4, (i % 2 == 0) and (math.pi / 2) or (-math.pi / 2))
                        st.guards[#st.guards + 1] = g:GetGUID()
                        pcall(function() g:Data():Set("lw_claim", "caravan") end)
                    end
                end
            end
        end
        if node.stop then
            DropRiders(master, node)
            if WE_CaravanArrived then pcall(WE_CaravanArrived, master, node.stop) end  -- escort reward (world_events.lua)
            st.atStop = true
            st.wait = math.max(node.wait, 10)
            master:SendUnitSay("Caravan to " .. (nodes[NextIndex({i = st.i, dir = st.dir}, #nodes, R.cfg.pingpong)].stop or "the road") ..
                " leaves soon! Talk to me for a seat.", 0)
            return
        end
        st.i = NextIndex(st, #nodes, R.cfg.pingpong)
        st.issued = 0
        node = nodes[st.i]
    end
    -- (re)issue the move every few ticks; path generation follows the navmesh
    if st.issued <= 0 then
        master:SetWalk(true)
        SafeMove(master, st.i, node.x, node.y, Ground(master, node.x, node.y, node.z))
        st.issued = 5
        st.stuckX, st.stuckY, st.stuckN = x, y, 0
        if math.random() < 0.02 then master:SendUnitSay(ROAD_LINES[math.random(#ROAD_LINES)], 0) end
    else
        st.issued = st.issued - 1
        if st.stuckX and math.sqrt((x - st.stuckX) ^ 2 + (y - st.stuckY) ^ 2) < 0.5 then
            st.stuckN = (st.stuckN or 0) + 1
            if st.stuckN >= 8 then st.issued = 0; st.stuckN = 0 end
        else
            st.stuckX, st.stuckY, st.stuckN = x, y, 0
        end
    end
end

local function OnMasterSpawn(_, master)
    local route = RouteByMaster(master:GetEntry())
    if not route then return end
    local R = ROUTES[route] or LoadRoute(route)
    if not R.cfg or #R.nodes < 2 then return end
    -- start at the closest node (the DB spawn sits on node 1)
    local x, y = master:GetLocation()
    local best, bi = 1e9, 1
    for i, n in ipairs(R.nodes) do
        local d = math.sqrt((x - n.x) ^ 2 + (y - n.y) ^ 2)
        if d < best then best, bi = d, i end
    end
    master:Data():Set("lw_route", route)
    STATE[route] = {route = route, i = bi, dir = 1, wait = 0, issued = 0, atStop = false}
    Escort(master)
    master:RegisterEvent(Brain, TICK, 0)
end

local function OnMasterRemove(_, master)
    local st = STATE[master:Data():Get("lw_route") or 0]
    if not st then return end
    local map = master:GetMap()
    local all = {st.kodo}
    for _, g in ipairs(st.guards or {}) do all[#all + 1] = g end
    for _, guid in ipairs(all) do
        local c = guid and map:GetWorldObject(guid)
        if c then c:DespawnOrUnsummon(0) end
    end
end

-- ---------------------------------------------------------------- gossip

local function MasterHello(_, player, master)
    player:GossipClearMenu()
    local st = STATE[master:Data():Get("lw_route") or 0]
    if not st then
        player:GossipMenuAddItem(0, "The caravan is not ready.", 0, 0)
        player:GossipSendMenu(68, master)
        return
    end
    local R = ROUTES[st.route]
    if not st.atStop then
        player:GossipMenuAddItem(0, "We're on the road. Catch me at the next stop.", 0, 0)
    else
        -- destinations ahead in the current direction
        local i = st.i + st.dir
        while i >= 1 and i <= #R.nodes do
            local n = R.nodes[i]
            if n.stop then
                local price = math.max(1, math.floor(RoadLength(R.nodes, st.i, i) * R.cfg.cpy))
                player:GossipMenuAddItem(0, "Ride to " .. n.stop .. " (" .. Money(price) .. ")", i, price)
            end
            i = i + st.dir
        end
    end
    player:GossipMenuAddItem(0, "Never mind.", 0, 0)
    player:GossipSendMenu(68, master)
end

local function MasterSelect(_, player, master, destIdx, price)
    player:GossipComplete()
    if destIdx == 0 or price == 0 then return end
    local st = STATE[master:Data():Get("lw_route") or 0]
    if not st or not st.atStop then return end
    -- paket sa da sfalsovat: ciel musi byt zastavka pred nami a cenu prepocitame na serveri
    local R = ROUTES[st.route]
    local i, okDest = st.i + st.dir, false
    while R and i >= 1 and i <= #R.nodes do
        local n = R.nodes[i]
        if n.stop and i == destIdx then okDest = true break end
        i = i + st.dir
    end
    if not okDest then return end
    price = math.max(1, math.floor(RoadLength(R.nodes, st.i, destIdx) * R.cfg.cpy))
    if player:GetCoinage() < price then
        player:SendBroadcastMessage(TAG .. "You can't afford that, friend.")
        return
    end
    local kodo = Kodo(master)
    local ok = false
    if kodo then
        ok = pcall(function() kodo:GetVehicleKit():AddPassenger(player, -1) end)
        ok = ok and player:IsOnVehicle()
    end
    if not ok then
        player:SendBroadcastMessage(TAG .. "No free seat on the wagon right now.")
        return
    end
    player:ModifyMoney(-price)
    RIDERS[st.route] = RIDERS[st.route] or {}
    RIDERS[st.route][player:GetName()] = destIdx
    player:SendBroadcastMessage(TAG .. "Welcome aboard! Next stop: " .. ROUTES[st.route].nodes[destIdx].stop .. ".")
end

-- ---------------------------------------------------------------- recorder

local function RecTick(_, _, _, player)
    local r = REC[player:GetName()]
    if not r then return end
    local x, y, z = player:GetLocation()
    if math.sqrt((x - r.x) ^ 2 + (y - r.y) ^ 2) < REC_STEP then return end
    r.idx = r.idx + 1
    r.x, r.y = x, y
    WorldDBExecute(string.format(
        "INSERT INTO lw_route_node (route, idx, map, x, y, z) VALUES (%d, %d, %d, %.2f, %.2f, %.2f)",
        r.route, r.idx, player:GetMapId(), x, y, z))
end

local function MaxIdx(route)
    local q = WorldDBQuery(string.format("SELECT COALESCE(MAX(idx), 0) FROM lw_route_node WHERE route = %d", route))
    return q and q:GetUInt32(0) or 0
end

local function OnCommand(_, player, command)
    local args = {}
    for w in string.gmatch(command or "", "%S+") do args[#args + 1] = w end
    if string.lower(args[1] or "") ~= "lw" then return end
    if not player or not player:IsGM() then return false end
    local sub = string.lower(args[2] or "")
    if sub == "patrol" then return end -- handled by lw_patrol.lua
    local route = tonumber(args[3] or "")
    local name = player:GetName()
    if sub == "rec" and route then
        local x, y, z = player:GetLocation()
        REC[name] = {route = route, idx = MaxIdx(route), x = 1e9, y = 1e9}
        RecTick(nil, nil, nil, player)
        REC[name].ev = player:RegisterEvent(RecTick, 1000, 0)
        player:SendBroadcastMessage(TAG .. "Recording route " .. route .. ". Ride the road, then .lw end")
    elseif sub == "end" then
        local r = REC[name]
        REC[name] = nil
        if r and r.ev then player:RemoveEventById(r.ev) end
        player:SendBroadcastMessage(TAG .. "Recording stopped" .. (r and (" at node " .. r.idx) or "") .. ".")
    elseif sub == "stop" then
        local r = REC[name]
        local wait = tonumber(args[3] or "") or 60
        local stopName = table.concat(args, " ", 4)
        if not r or stopName == "" then
            player:SendBroadcastMessage(TAG .. "Usage while recording: .lw stop <wait_s> <name>")
            return false
        end
        local x, y, z = player:GetLocation()
        r.idx = r.idx + 1
        r.x, r.y = x, y
        WorldDBExecute(string.format(
            "INSERT INTO lw_route_node (route, idx, map, x, y, z, stop, wait_s) VALUES (%d, %d, %d, %.2f, %.2f, %.2f, '%s', %d)",
            r.route, r.idx, player:GetMapId(), x, y, z, (string.gsub(stopName, "'", "''")), wait))
        player:SendBroadcastMessage(TAG .. "Stop '" .. stopName .. "' saved as node " .. r.idx .. ".")
    elseif sub == "clear" and route then
        WorldDBExecute(string.format("DELETE FROM lw_route_node WHERE route = %d", route))
        ROUTES[route] = nil
        player:SendBroadcastMessage(TAG .. "Route " .. route .. " cleared.")
    elseif sub == "info" and route then
        local R = LoadRoute(route)
        local stops = {}
        for _, n in ipairs(R.nodes) do if n.stop then stops[#stops + 1] = n.stop end end
        player:SendBroadcastMessage(TAG .. "Route " .. route .. ": " .. #R.nodes .. " nodes, stops: " ..
            (#stops > 0 and table.concat(stops, " > ") or "none"))
    elseif sub == "spawn" and route then
        local R = LoadRoute(route)
        if not R.cfg or #R.nodes < 2 then
            player:SendBroadcastMessage(TAG .. "Route " .. route .. " needs a lw_caravan row and 2+ nodes.")
            return false
        end
        local n = R.nodes[1]
        local ok = pcall(PerformIngameSpawn, 1, R.cfg.master, n.map, 0, n.x, n.y, n.z, player:GetO(), true)
        -- our content lives in the Living World main phase (applies after restart)
        if ok then WorldDBExecute(string.format("UPDATE creature SET PhaseId = 9600 WHERE id = %d AND PhaseId = 0", R.cfg.master)) end
        player:SendBroadcastMessage(TAG .. (ok and "Caravan master spawned at node 1 and saved." or "Spawn failed."))
    else
        player:SendBroadcastMessage(TAG .. ".lw rec <route> | end | stop <wait_s> <name> | clear <route> | info <route> | spawn <route>")
    end
    return false
end

-- ---------------------------------------------------------------- register

local MASTERS = {}
local mq = WorldDBQuery("SELECT DISTINCT master_entry FROM lw_caravan")
if mq then
    repeat MASTERS[#MASTERS + 1] = mq:GetUInt32(0) until not mq:NextRow()
end
for _, entry in ipairs(MASTERS) do
    RegisterCreatureEvent(entry, 5, OnMasterSpawn)    -- ON_SPAWN
    RegisterCreatureEvent(entry, 37, OnMasterRemove)  -- ON_REMOVE
    RegisterCreatureGossipEvent(entry, 1, MasterHello)
    RegisterCreatureGossipEvent(entry, 2, MasterSelect)
end
RegisterPlayerEvent(42, OnCommand)
print("[lw] engine loaded: " .. #MASTERS .. " caravan master type(s)")
