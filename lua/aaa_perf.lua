-- =====================================================================
-- Performance watch for the custom Lua systems (loads first: "aaa_").
-- PERF_Wrap(name, fn) returns fn timed with os.clock. Every 10 minutes the
-- slowest systems go to the server log; GMs see live numbers with .lwperf
-- =====================================================================

-- Extra experience multipliers; every system adds a function(player) -> factor.
-- descend_world.lua applies them all in its single ON_GIVE_XP hook.
XP_FACTORS = XP_FACTORS or {}

local STATS = {}   -- name -> {calls, total, max}

function PERF_Wrap(name, fn)
    return function(...)
        local t0 = os.clock()
        local a, b, c, d = fn(...)
        local dt = os.clock() - t0
        local s = STATS[name]
        if not s then s = {calls = 0, total = 0, max = 0}; STATS[name] = s end
        s.calls, s.total = s.calls + 1, s.total + dt
        if dt > s.max then s.max = dt end
        return a, b, c, d
    end
end

local function Report()
    local list = {}
    for n, s in pairs(STATS) do list[#list + 1] = {n, s} end
    table.sort(list, function(a, b) return a[2].total > b[2].total end)
    local out = {}
    for i = 1, math.min(10, #list) do
        local n, s = list[i][1], list[i][2]
        out[#out + 1] = string.format("%s: %d calls, avg %.2f ms, max %.1f ms, total %.0f ms", n, s.calls,
            1000 * s.total / math.max(1, s.calls), 1000 * s.max, 1000 * s.total)
    end
    return out
end

CreateLuaEvent(function()
    local r = Report()
    if #r > 0 then print("[perf] " .. table.concat(r, " | ")) end
    STATS = {}
end, 600000, 0)

RegisterPlayerEvent(42, function(_, player, command)
    if string.lower(command or "") ~= "lwperf" then return end
    if player:GetGMRank() < 1 then return end
    player:SendBroadcastMessage("|cff00ff00[Perf]|r Lua systems since the last 10-minute report:")
    for _, line in ipairs(Report()) do player:SendBroadcastMessage("  " .. line) end
    return false
end)

-- Creatures with a C++ script (ScriptName set) must keep it: registering ANY Eluna creature event for an entry replaces its C++ AI.
-- Every system that registers events by entry skips these.
HAS_CPP_SCRIPT = {}
do
    local q = WorldDBQuery("SELECT entry FROM creature_template WHERE ScriptName <> ''")
    if q then repeat HAS_CPP_SCRIPT[q:GetUInt32(0)] = true until not q:NextRow() end
end

-- ---------------------------------------------------------------- multistate helpers
-- This Eluna runs one Lua state per map (map threads) plus a world state (-1).
-- Objects may only be touched, and timers on them registered, from the state
-- of the map they are on. World-state events (login, chat commands, addon
-- messages) hand work to map states through the DB queue world.lw_queue.
IS_WORLD_STATE = (GetStateMapId and GetStateMapId() == -1) or false
STATE_MAP = GetStateMapId and GetStateMapId() or -1

function MAP_Players()
    if IS_WORLD_STATE then
        local ok, l = pcall(GetPlayersInWorld)
        return (ok and l) or {}
    end
    local ok, l = pcall(GetPlayersOnMap)
    return (ok and l) or {}
end

function FindPlayer(name)
    if IS_WORLD_STATE then
        local ok, p = pcall(GetPlayerByName, name)
        return ok and p or nil
    end
    for _, p in ipairs(MAP_Players()) do if p:GetName() == name then return p end end
    return nil
end

-- run fn every ms only in map states (never in the world state)
function MAP_Timer(name, fn, ms)
    if IS_WORLD_STATE then return end
    CreateLuaEvent(PERF_Wrap(name, fn), ms, 0)
end

-- queue work for a player's map state: kind, player name, argument
function LW_Queue(kind, name, arg)
    WorldDBExecute(string.format("INSERT INTO lw_queue (kind, name, arg) VALUES ('%s', '%s', '%s')",
        kind, (string.gsub(name or "", "'", "''")), (string.gsub(arg or "", "'", "''"))))
end

-- map states: handlers per kind, run for queued players that are on this map
LW_QUEUE_HANDLERS = LW_QUEUE_HANDLERS or {}
MAP_Timer("lw_queue", function()
    local players = MAP_Players()
    if #players == 0 then return end
    local here = {}
    local names = {}
    for _, p in ipairs(players) do here[p:GetName()] = p; names[#names + 1] = "'" .. string.gsub(p:GetName(), "'", "''") .. "'" end
    local q = WorldDBQuery("SELECT id, kind, name, arg FROM lw_queue WHERE name IN (" .. table.concat(names, ",") .. ") OR name = '' ORDER BY id LIMIT 50")
    if not q then return end
    local done = {}
    repeat
        local id, kind, name, arg = q:GetUInt32(0), q:GetString(1), q:GetString(2), q:GetString(3)
        local h = LW_QUEUE_HANDLERS[kind]
        if h then
            local ok, consumed = pcall(h, here[name], arg, name)
            if ok and consumed ~= false then done[#done + 1] = id end
        end
    until not q:NextRow()
    if #done > 0 then WorldDBExecute("DELETE FROM lw_queue WHERE id IN (" .. table.concat(done, ",") .. ")") end
end, 3000)
