-- 91274 Severing the Void: after the 5th Quel'Danas Sentinel is activated (246247 x5) the sentinels destroy the Void-Breach Pylon
-- (retail objective "Void-Breach Pylon destroyed", credit 246317).
if IS_WORLD_STATE or not MAP_Timer then return end
local QUEST = 91274
local function Tick()
    for _, p in ipairs(MAP_Players()) do
        local ok, st = pcall(function() return p:GetQuestStatus(QUEST) end)
        if ok and st == 3 and p:GetReqKillOrCastCurrentCount(QUEST, 246247) >= 5
           and p:GetReqKillOrCastCurrentCount(QUEST, 246317) < 1 then
            pcall(function() p:KilledMonsterCredit(246317) end)
        end
    end
end
MAP_Timer("severing_void", function() pcall(Tick) end, 2000)
print("[severing_void] loaded")
