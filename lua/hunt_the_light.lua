-- =====================================================================
-- 86520 "Hunt the Light" - objektiv 459797 "Travel to Nexus-Point Xenas"
-- (kredit 241025 "[DNT] Kill Credit: Travel to Xenas")
--
-- Primarny trigger UZ existuje: areatrigger 9108447 (SmartAreaTriggerAI,
-- shape radius ~10y) pri spawnu Allerie (1460,-1719) creditne 241025.
-- Tento skript je POISTKA pre pripad, ze hrac trigger obide (napr.
-- prilietne/prileti inou cestou): vacsi radius 60y, rovnaky kredit.
--
-- Alleria (235763) sa objavi vo faze 45791 az ked je 86520 v logu
-- (conditions: QUESTSTATE 86520 = 74, negative 86522 = 64).
-- Po dokonceni objektivu (quest status COMPLETE) sa kredit uz neposiela.
--
-- SQL: Custom/sql/20261017_dor_86519_86522.sql (+ _undo)
-- =====================================================================
if IS_WORLD_STATE then return end

local STATUS_INCOMPLETE = 3 -- QUEST_STATUS_INCOMPLETE (fork enum: NONE=0, COMPLETE=1, INCOMPLETE=3)

local XENAS = { x = 1459.93, y = -1717.67, r = 60.0 }
local LastTry = {}

if MAP_Timer then
    MAP_Timer("hunt_the_light.xenas", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86520) end)
                if okS and st == STATUS_INCOMPLETE then
                    local dx, dy = XENAS.x - p:GetX(), XENAS.y - p:GetY()
                    if (dx * dx + dy * dy) <= (XENAS.r * XENAS.r) then
                        local name = p:GetName()
                        local now = os.time()
                        if now - (LastTry[name] or 0) >= 30 then
                            LastTry[name] = now
                            local okC, err = pcall(function() return p:KilledMonsterCredit(241025) end)
                            print(string.format("[hunt_the_light] xenas arrival credit %s -> %s",
                                name, okC and "OK" or tostring(err)))
                        end
                    end
                end
            end
        end
    end, 3000)
end
