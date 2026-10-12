-- Retail style world quest rotation: keeps world_quest_active (read by the core, see game/Quests/WorldQuests.h) filled with a handful of Coiled Isle world quests that change every day.
-- Quests are taken automatically when a player enters their area and rewarded by the core when the last objective is done.
if not IS_WORLD_STATE then return end
local POOL = {93648, 93649, 93664, 93669, 94573, 93670, 93671, 93672, 94571, 94572, 94574, 96307, 94611, 94612, 94876, 94967, 94996, 95253, 95381, 95429, 95448, 95449, 95451, 95453, 95484, 95513, 95529, 95662, 95794, 95918, 95807, 95921, 95922, 95923, 95931, 96029, 96625, 96329, 95990, 96066, 96492}
local ACTIVE, HOURS = 9, 24
local function Rotate()
    local now = os.time()
    WorldDBExecute("DELETE FROM world_quest_active WHERE EndTime <= " .. now)
    local q = WorldDBQuery("SELECT QuestID FROM world_quest_active")
    local have, n = {}, 0
    if q then repeat have[q:GetUInt32(0)] = true; n = n + 1 until not q:NextRow() end
    local free = {}
    for _, id in ipairs(POOL) do if not have[id] then free[#free + 1] = id end end
    while n < ACTIVE and #free > 0 do
        local i = math.random(#free)
        WorldDBExecute(string.format("INSERT INTO world_quest_active (QuestID, EndTime) VALUES (%d, %d)", free[i], now + HOURS * 3600 - math.random(0, 6 * 3600)))
        table.remove(free, i); n = n + 1
    end
end
Rotate()
CreateLuaEvent(Rotate, 30 * 60 * 1000, 0)
print("[world_quest_rotation] loaded, " .. #POOL .. " world quests in the pool")
