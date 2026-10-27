-- =====================================================================
-- Quest 86531 Work Disruption v1: Progress (DB) + accept scena.
-- Bar objektivy SAHNUTE (13 rucnych riadkov vs TDB bar - rozhodne herny test).
-- Accept scena (Wiki Notes, overlook 45762): Alleria + Arator.
-- Alleria ender menu 38434 (telo). Turn-in nativny.
-- DB: Custom/sql/20261016_abyss312849.sql (+undo).
-- Follow-up: captive rescue dialog, Siphoner says, bar-overenie v hre.
-- =====================================================================
if IS_WORLD_STATE then return end

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86531] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86531] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86531] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(235389, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86531) then return end
    pcall(function() PrintInfo("[ds86531] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235389, 80, 2000, "We'll secure the canisters and disrupt their operations. Stay close, Arator.", 300920)  -- bt 282976 vo_120_alleria_windrunner_32
    SayAt(player, 235393, 80, 8000, "I was about to say the same to you.", 300918)
end)

print("[work_disruption] loaded")
