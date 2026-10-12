-- =====================================================================
-- Khansguard raids: the centaur camp in the Barrens (Khansguard Patrollers, Warriors, Prospects, Jebotai and Captain Akato, entries 9903020-9903024)
-- sends a war band to Crossroads or Camp Taurajo while a hero is near. Raiders march in, charge and attack; the captain leads every second raid.
-- 25 minutes cooldown per target, a raid lasts 6 minutes.
-- =====================================================================
if IS_WORLD_STATE then return end

local CAMP = {x = -1150.0, y = -2215.0}
local TARGETS = {
    {name = "the Crossroads", x = -441.0, y = -2596.0, z = 91.5},
    {name = "Camp Taurajo",   x = -2373.0, y = -1939.0, z = 96.0},
}
local RAIDERS = {9903020, 9903023, 9903023, 9903024, 9903022}
local CAPTAIN = 9903021
local COOLDOWN, LIFE = 25 * 60, 6 * 60
local last = {}

local function Tick()
    local now = os.time()
    for ti, t in ipairs(TARGETS) do
        if now - (last[ti] or 0) >= COOLDOWN and math.random(100) <= 30 then
            local who
            for _, p in ipairs(MAP_Players() or {}) do
                if p:GetMapId() == 1 and (p:GetX() - t.x) ^ 2 + (p:GetY() - t.y) ^ 2 < 200 * 200 then who = p break end
            end
            if who then
                last[ti] = now
                local dx, dy = CAMP.x - t.x, CAMP.y - t.y
                local len = math.max(1, math.sqrt(dx * dx + dy * dy))
                local sx, sy = t.x + dx / len * 150, t.y + dy / len * 150
                local n = 5 + math.random(0, 2)
                if WORLD_News then pcall(WORLD_News, "|cffffa000[Raid]|r Khansguard centaurs are riding on " .. t.name .. "!") end
                for i = 1, n + 1 do
                    local entry = (i == n + 1) and (math.random(2) == 1 and CAPTAIN or RAIDERS[1]) or RAIDERS[math.random(#RAIDERS)]
                    local ok, c = pcall(PerformIngameSpawn, 1, entry, 1, 0, sx + (i % 3) * 3, sy + math.floor(i / 3) * 3, t.z, 0, false, LIFE * 1000)
                    if ok and c then
                        pcall(function()
                            c:SetWalk(false)
                            c:MoveTo(1, t.x + math.random(-8, 8), t.y + math.random(-8, 8), t.z, true)
                            if i == 1 then c:SendUnitYell("Khansguard, ride! Crush " .. t.name .. "!", 0) end
                        end)
                    end
                end
            end
        end
    end
end

MAP_Timer("khans_raid.tick", Tick, 60000)
print("[khans] raid script ready")
