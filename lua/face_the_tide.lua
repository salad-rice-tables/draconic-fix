-- =====================================================================
-- Quest 86513 Face the Tide v1 (Wiki Notes).
--  1) klietka 517340 (use): oslobodeny Abducted Offworlder (238535) prehovori
--     jednu z 3 Draenei liniek (Wiki verbatim), potom despawn (~8 s).
--  2) Arator meet-up: hrac s 86512/86513 v 60 y od 236944 -> Arator line
--     "Some of these captives aren't from Azeroth..." (bcast 283333, kit 301127).
--  DB: Custom/sql/20261017_abyss1213.sql (+undo). Kredit klietky je nativny (GO data1=0).
-- =====================================================================
if IS_WORLD_STATE then return end

local LINES = {
    "The sky opened and they poured through!",
    "How many have they taken?",
    "They'll never stop!",
}
local lineIdx = 0
local Met = {}
local LastUse = {}

local function QStatus(player, q)
    local ok, st = pcall(function() return player:GetQuestStatus(q) end)
    return (ok and st) or -1
end

RegisterGameObjectEvent(517340, 14, function(_, go, player)
    if not (go and player) then return false end
    if QStatus(player, 86513) ~= STATUS_INCOMPLETE then return false end
    local key = player:GetName()
    if (LastUse[key] or 0) + 3 > os.time() then return false end
    LastUse[key] = os.time()
    lineIdx = lineIdx + 1
    if lineIdx > #LINES then lineIdx = 1 end
    local text = LINES[lineIdx]
    local said = false
    local ok, list = pcall(function() return player:GetCreaturesInRange(40, 238535) end)
    if ok and list then
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == 238535 then
                pcall(function() c:SendUnitSay(text, 0) end)
                said = true
                break
            end
        end
    end
    if not said then
        local okP, x, y, z = pcall(function() return go:GetX(), go:GetY(), go:GetZ() end)
        if okP then
            local okS, c = pcall(PerformIngameSpawn, 1, 238535, player:GetMapId(), 0, x, y, z, 0, false, 8000)
            if okS and c then pcall(function() c:SendUnitSay(text, 0) end) end
        end
    end
    pcall(function() PrintInfo("[ds86513] captive freed (" .. (said and "native" or "summon") .. ") line=" .. lineIdx) end)
    return false
end)

MAP_Timer("ds86513.arator", function()
    for _, p in ipairs(MAP_Players() or {}) do
        if p and p:IsInWorld() and p:GetMapId() == 2771 and not Met[p:GetName()] then
            local s12, s13 = QStatus(p, 86512), QStatus(p, 86513)
            if s12 == STATUS_INCOMPLETE or s13 == STATUS_INCOMPLETE then
                local ok, list = pcall(function() return p:GetCreaturesInRange(60, 236944) end)
                if ok and list and #list > 0 then
                    Met[p:GetName()] = true
                    p:RegisterEvent(function(_, _, _, pl)
                        if not pl or not pl:IsInWorld() then return end
                        local ok2, l2 = pcall(function() return pl:GetCreaturesInRange(60, 236944) end)
                        if ok2 and l2 then
                            for _, c in ipairs(l2) do
                                local okE, e = pcall(function() return c:GetEntry() end)
                                if okE and e == 236944 then
                                    pcall(function() c:SendUnitSay("Some of these captives aren't from Azeroth. How many worlds have suffered the Void's violence?", 0) end)
                                    pcall(function() c:PlayDistanceSound(301127, pl) end)
                                    pcall(function() PrintInfo("[ds86513] arator meet-up SENT for " .. pl:GetName()) end)
                                    return
                                end
                            end
                        end
                    end, 600, 1)
                end
            end
        end
    end
end, 5000)

print("[face_the_tide] loaded")
