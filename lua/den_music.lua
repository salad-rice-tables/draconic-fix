-- =====================================================================
-- Den music: v Den (Valley of Trials) hra bubny 218010, vonku stop.
-- Stav drzi server (INSIDE), takze pri prechode hranicou prepne raz.
-- =====================================================================
if IS_WORLD_STATE then return end

local DEN_AREA = 364   -- cele The Den podla AreaId (nie kruh, aby nevypadavalo uprostred)
local MUSIC = 218010   -- Tuskarr drum sting A
local INSIDE = {}

if MAP_Timer then
    MAP_Timer("den.music", function()
        for _, p in ipairs(MAP_Players() or {}) do
            local ok, name = pcall(function() return p:GetName() end)
            if ok and name then
                local okA, area = pcall(function() return p:GetAreaId() end)
                local inside = okA and area == DEN_AREA
                if inside and not INSIDE[name] then
                    INSIDE[name] = true
                    pcall(function() p:PlayMusic(MUSIC, p) end)
                elseif not inside and INSIDE[name] then
                    INSIDE[name] = nil
                    pcall(function() p:PlayMusic(0, p) end)   -- stop, spat zona hudba
                end
            end
        end
    end, 5000)
end
print("[den_music] loaded")
