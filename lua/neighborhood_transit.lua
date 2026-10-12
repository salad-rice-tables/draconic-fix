-- =====================================================================
-- Founder's Point public transportation: Kirt (256327) and the wagon stops ([DNT] Wagon Point markers).
-- Talking to Kirt lists the wagon stops of the neighborhood; the chosen one takes the passenger there.
-- (Retail drives a wagon along a path; the wagon vehicle data is not in our database, so the ride is a short fade and a
-- hand-over at the stop.)
-- Loads at worldserver start from lua_scripts/ (map state).
-- =====================================================================
if IS_WORLD_STATE then return end

local MAP_ID, KIRT = 2735, 256327
local STOPS = nil

local function Load()
    STOPS = {}
    local q = WorldDBQuery(string.format("SELECT position_x, position_y, position_z FROM creature WHERE map = %d AND id IN (246971, 247958) ORDER BY position_y, position_x", MAP_ID))
    if q then
        repeat
            local s = { x = q:GetFloat(0), y = q:GetFloat(1), z = q:GetFloat(2) }
            local dup = false
            for _, o in ipairs(STOPS) do if (o.x - s.x) ^ 2 + (o.y - s.y) ^ 2 < 400 then dup = true end end
            if not dup then STOPS[#STOPS + 1] = s end
        until not q:NextRow()
    end
end

local function Hello(event, player, creature)
    if not STOPS then Load() end
    player:GossipClearMenu()
    for i, s in ipairs(STOPS) do
        local d = math.sqrt((player:GetX() - s.x) ^ 2 + (player:GetY() - s.y) ^ 2)
        if d > 40 then player:GossipMenuAddItem(2, string.format("Take me to wagon stop %d.", i), 1, i) end
    end
    player:GossipMenuAddItem(0, "Never mind.", 1, 0)
    player:GossipSendMenu(1, creature)
    return true
end

local function Select(event, player, creature, sender, intid)
    player:GossipComplete()
    local s = STOPS and STOPS[intid]
    if s then
        creature:SendUnitSay("Hop on, hold tight!", 0)
        player:Teleport(MAP_ID, s.x, s.y, s.z + 1, player:GetO())
    end
    return true
end

RegisterCreatureGossipEvent(KIRT, 1, Hello)
RegisterCreatureGossipEvent(KIRT, 2, Select)
print("[neighborhood_transit] Kirt wagon stops registered")
