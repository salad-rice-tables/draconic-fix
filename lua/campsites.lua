-- =====================================================================
-- Warband Campsites: only the two starter camps unlock by playing.
--   Alliance player enters Stormwind  -> "For the Alliance!"  unlocks Founder's Point
--   Horde player enters Orgrimmar     -> "For the Horde!"     unlocks Razorwind Shores
-- The camp belongs to the account (Warband), so any character of it can use it afterwards.
-- Needs the Eluna method Player:AddWarbandScene (PlayerMethods.h).
-- Scene ids come from WarbandScene.db2 (string order): 145 Razorwind Shores, 146 Founder's Point.
-- =====================================================================

local CAMPS = {
    -- [team] = {zone, scene, title, text}
    [0] = {zone = 1519, scene = 146, name = "Founder's Point",
           title = "For the Alliance!",
           text = "You reached Stormwind. Your Warband unlocks the Founder's Point campsite."},
    [1] = {zone = 1637, scene = 145, name = "Razorwind Shores",
           title = "For the Horde!",
           text = "You reached Orgrimmar. Your Warband unlocks the Razorwind Shores campsite."},
}

local function Toast(player, title, text)
    local msg = "TOAST;" .. title .. ";" .. text
    pcall(function() player:SendAddonMessage("WCARD", msg, 7, player) end)
end

local function Check(player)
    if not player or not player:IsInWorld() then return end
    local c = CAMPS[player:GetTeam()]
    if not c or player:GetZoneId() ~= c.zone then return end
    local key = string.format("camp:%d:%d", player:GetAccountId(), c.scene)
    local ok, res = pcall(WorldDBQuery, string.format("SELECT 1 FROM world.lw_state WHERE k = '%s'", key))
    if ok and res then return end                          -- already awarded on this account
    local okA = pcall(function() player:AddWarbandScene(c.scene) end)
    if not okA then return end
    pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('%s', '1')", key))
    player:SendBroadcastMessage("|cffffd200[" .. c.title .. "]|r " .. c.text)
    Toast(player, c.title, c.text)
    pcall(function() player:PlayDirectSound(12891, player) end)   -- achievement chime
end

if not IS_WORLD_STATE then
    RegisterPlayerEvent(27, function(_, player) Check(player) end)   -- zone change
    RegisterPlayerEvent(28, function(_, player)                       -- map change / login into the world
        if player then player:RegisterEvent(function(_, _, _, p) Check(p) end, 4000, 1) end
    end)
end
print("[campsites] loaded")
