-- Midnight campaign: objectives that retail drives with scenes/conversations (not available here) get a fallback credit.
-- Per player and quest: after the quest has been incomplete for FIRST seconds, the listed credits are tried every STEP seconds
-- in order (core ignores credits for objectives that are sequenced-locked or done, so retrying is harmless).
if IS_WORLD_STATE or not MAP_Timer or not MIDNIGHT_FALLBACK then return end
local INCOMPLETE, FIRST, STEP = 3, 45, 12
local byq = {}
for _, e in ipairs(MIDNIGHT_FALLBACK) do byq[e.q] = byq[e.q] or {}; table.insert(byq[e.q], e.c) end
local since = {}
local function Tick()
    local now = os.time()
    for _, p in ipairs(MAP_Players()) do
        if p:IsInWorld() then
            for q, list in pairs(byq) do
                local ok, st = pcall(function() return p:GetQuestStatus(q) end)
                local key = tostring(p:GetGUID()) .. ":" .. q
                if ok and st == INCOMPLETE then
                    since[key] = since[key] or now
                    local t = now - since[key]
                    if t >= FIRST then
                        local i = math.floor((t - FIRST) / STEP) % #list + 1
                        pcall(function() p:KilledMonsterCredit(list[i]) end)
                    end
                else
                    since[key] = nil
                end
            end
        end
    end
end
MAP_Timer("midnight_fallback_credit", function() pcall(Tick) end, STEP * 1000 / 2)
print("[midnight_fallback_credit] loaded")
