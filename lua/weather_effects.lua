-- Weather that matters: the cold zones chill you (slower movement) unless you stand near a fire. Self-contained.
local TAG = "|cff69ccf0[Weather]|r "
local COLD_ZONES = {[1] = true, [618] = true, [36] = true, [2817] = true}   -- Dun Morogh, Winterspring, Alterac Mountains, Crystalsong-ish
local CHILL = 7321          -- Chilled: movement slowed
local FIRE_RANGE = 14
local FIRES = nil
local function LoadFires()
    FIRES = {}
    local ok, r = pcall(WorldDBQuery, "SELECT entry FROM world.gameobject_template WHERE name LIKE '%campfire%' OR name LIKE '%bonfire%' OR name LIKE '%brazier%' OR name LIKE '%forge%' OR name LIKE '%hearth%'")
    if ok and r then repeat FIRES[r:GetUInt32(0)] = true until not r:NextRow() end
end
local function NearFire(p)
    if not FIRES then LoadFires() end
    local ok, list = pcall(function() return p:GetGameObjectsInRange(FIRE_RANGE) end)
    if ok and list then
        for _, go in ipairs(list) do if FIRES[go:GetEntry()] then return true end end
    end
    return false
end
local warned = {}
RegisterPlayerEvent(3, function(_, player)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() or not p:IsAlive() or p:GetLevel() > 60 then return end
        if not COLD_ZONES[p:GetZoneId()] or p:IsGM() then return end
        if NearFire(p) then return end
        pcall(function() p:AddAura(CHILL, p) end)
        local t = GetCurrTime and GetCurrTime() or 0
        if (warned[p:GetName()] or 0) + 90000 < t then
            warned[p:GetName()] = t
            p:SendBroadcastMessage(TAG .. "The cold slows you down. Warm yourself by a fire.")
        end
    end, 20000, 0)
end)
RegisterPlayerEvent(4, function(_, p) warned[p:GetName()] = nil end)
