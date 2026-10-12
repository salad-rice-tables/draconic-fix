-- Dungeon portals: click a portal (object 204386 "Zanzil's Portal") and you are carried to its destination.
-- The real dungeons use stairs, lifts and portals that this core has no instance script for. Each portal is a normal object spawn in the
-- world database; its destination is taken from this table by the spawn guid (gameobject.guid). Add portals the same way.
if IS_WORLD_STATE then return end

local PORTAL = 204386   -- retail "Zanzil's Portal"
local DEST = {
    [3500000100] = {map = 2923, x = 4752.6245, y = -450.12906, z = -62.59247, o = 0, text = "Voidscar Arena: up to the Atroxus platform"},
    [3500000101] = {map = 3004, x = 582.20337, y = 49.54895, z = 468.40628, o = 0, text = "The Venomous Abyss: back from the Pit of Fangs"},
    [3500000102] = {map = 3004, x = 581.839, y = -49.4809, z = 468.4053, o = 0, text = "The Venomous Abyss: back from the Pit of Fangs"},
}

local function Use(event, player, go)
    local ok, row = pcall(function() return tonumber(tostring(go:GetDBTableGUIDLow())) end)
    local d = ok and row and DEST[row]
    if not d then player:SendBroadcastMessage("|cff00ccff[Dungeon]|r This portal leads nowhere yet.") return true end
    player:SendBroadcastMessage("|cff00ccff[Dungeon]|r " .. d.text)
    player:Teleport(d.map, d.x, d.y, d.z, d.o)
    return true
end
RegisterGameObjectGossipEvent(PORTAL, 1, Use)
print("[dungeon_pads] dungeon portals loaded")
