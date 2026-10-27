-- Midnight spells picked by the owner (see mid_pool.py / coa_spells_mid.py): custom Ash Veil (3 s invisibility), Translocator Recall, Atal'Utek's Mask
-- (Witch Doctor lightning mask: the Amani visual 1282313 plays on the caster) and the clean-water buff "Cleansed" (1405020): standing in clean water
-- gives +2% Stamina until you leave it for a while. NPC visuals live in workday.lua (builders cast Activating 1281882).
if IS_WORLD_STATE then return end

local MASK, MASK_VISUAL = 1405003, 1282313
local CLEANSED = 1405020
-- zones with foul water: Swamp of Sorrows, Blasted Lands, Felwood, Plaguelands, Stratholme, Deadwind, Duskwood swamp, Zangarmarsh coil, Tirisfal Brill
local FOUL = {[8] = true, [4] = true, [361] = true, [28] = true, [139] = true, [10] = true, [3521] = false, [85] = false}

RegisterPlayerEvent(5, function(_, player, spell)   -- ON_SPELL_CAST
    local ok, id = pcall(function() return spell:GetEntry() end)
    if ok and id == MASK then
        pcall(function() player:CastSpell(player, MASK_VISUAL, true) end)
    end
    -- Translocator Recall (1405002): prvy cast ulozi kotvu, dalsi teleportuje spat.
    if ok and id == 1405002 and player and player.GetName then
        local key = (string.gsub(player:GetName() or "", "'", "''"))
        local q = WorldDBQuery(string.format("SELECT v FROM world.lw_state WHERE k = 'transloc:%s'", key))
        local anchor = q and q:GetString(0) or nil
        if anchor then
            local m, x, y, z, o = string.match(anchor, "([^:]+):([^:]+):([^:]+):([^:]+):([^:]+)")
            m, x, y, z, o = tonumber(m), tonumber(x), tonumber(y), tonumber(z), tonumber(o or 0)
            if m and x and y and z then
                pcall(function() player:Teleport(m, x, y, z, o) end)
                player:SendBroadcastMessage("|cff6fd6ff[Translocator]|r Recalled to your anchor.")
            else
                player:SendBroadcastMessage("|cff6fd6ff[Translocator]|r Anchor corrupted, setting a new one here.")
                anchor = nil
            end
        end
        if not anchor then
            pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('transloc:%s', '%d:%.2f:%.2f:%.2f:%.2f')",
                key, player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO()))
            player:SendBroadcastMessage("|cff6fd6ff[Translocator]|r Anchor set here. Cast again to return.")
        end
    end
end)

local last = {}   -- name -> last time in clean water
MAP_Timer("midnight.cleansed", function()
    for _, p in ipairs(MAP_Players() or {}) do
        local ok, wet = pcall(function() return p:IsInWater() and not p:IsInCombat() end)
        if ok then
            local zok, z = pcall(function() return p:GetZoneId() end)
            local n = p:GetName()
            if wet and zok and not FOUL[z] then
                last[n] = os.time()
                if not p:HasAura(CLEANSED) then
                    pcall(function() p:AddAura(CLEANSED, p) end)
                    p:SendBroadcastMessage("|cff6fd6ff[Cleansed]|r The clean water refreshes you: +2% Stamina.")
                end
            elseif p:HasAura(CLEANSED) and (os.time() - (last[n] or 0)) > 600 then
                pcall(function() p:RemoveAura(CLEANSED) end)
            end
        end
    end
end, 15000)
print("[midnight] Atal'Utek's Mask visual and the Cleansed water buff are active")
