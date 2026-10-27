-- 86848 Light's Arsenal: one "Weapons collected" credit (240919) per legendary weapon the player holds (Plaque chests, retail items).
if IS_WORLD_STATE or not MAP_Timer then return end
local lastLog = 0
local QUEST, CREDIT = 86848, 240919
local ITEMS = { 238807, 238846, 238845, 238844, 238842, 238843, 238864, 238890, 238891 }
local function Tick()
    for _, p in ipairs(MAP_Players()) do
        local ok, st = pcall(function() return p:GetQuestStatus(QUEST) end)
        if ok and st == 3 then
            local owned = 0
            if os.time() - lastLog > 30 then lastLog = os.time(); PrintInfo("[arsenal] tick for " .. p:GetName()) end
            for _, id in ipairs(ITEMS) do
                local got = 0
                pcall(function() got = p:GetReqKillOrCastCurrentCount(QUEST, id) end)
                if got >= 1 then owned = owned + 1 end
            end
            local cur = p:GetReqKillOrCastCurrentCount(QUEST, CREDIT)
            if os.time() - lastLog < 3 then PrintInfo("[arsenal] owned=" .. owned .. " cur=" .. tostring(cur)) end
            for _ = cur + 1, math.min(owned, 7) do pcall(function() p:KilledMonsterCredit(CREDIT) end) end
        end
    end
end
MAP_Timer("arsenal", function()
    local ok, err = pcall(Tick)
    if not ok and os.time() - lastLog > 30 then lastLog = os.time(); PrintInfo("[arsenal] tick error: " .. tostring(err)) end
end, 2000)
print("[arsenal] loaded")
