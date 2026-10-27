-- =====================================================================
-- Quest 86511 Edge of the Abyss v1: accept scena + report scena (temp-summon).
-- Maella report button (kredit Eluna + SAI) + Decimus submenus (DB).
-- Speakri report-sceny mimo faze -> temp-summon (village_life vzor).
-- Turn-in nativny (45779 OK). Texty Wiki verbatim.
-- DB: Custom/sql/20261016_abyss6511.sql (+undo).
-- Follow-up: party odchod pohyb.
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86511] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86511] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86511] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function SummonSay(player, entry, x, y, z, text, kit, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), 0, x, y, z, 0, false, 120000)
        if not (ok and c) then pcall(function() PrintInfo("[ds86511] summon MISSED entry=" .. entry) end) return end
        local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
        if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
        pcall(function() PrintInfo("[ds86511] summon-say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(238296, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86511) then return end
    pcall(function() PrintInfo("[ds86511] quest accepted by " .. player:GetName()) end)
    SayAt(player, 238296, 80, 2000, "Make haste. We should have the Mantle before Terminas returns to his citadel.", 301045)
end)

-- Report scena: Maella native (45779) + Lothraxion/Alleria/Maella summon (Wiki poradie)
RegisterCreatureGossipEvent(239349, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86511] maella player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
    if sender ~= 38390 then return end
    pcall(function() player:KilledMonsterCredit(239349) end)
    local key = player:GetName() .. ":report"
    if (SaidAt[key] or 0) + 600 < os.time() then
        SaidAt[key] = os.time()
        SayAt(player, 239349, 60, 2000, "Torentia controls the trench, Severum guards the upper citadel.", 301014)
        SummonSay(player, 235473, 625.0, -730.0, -197.0, "I'll hunt down Severum. You and this voidspawn can handle the trench.", 301013, 9000)
        SummonSay(player, 235726, 625.0, -726.0, -197.0, "This is no time to go off on your own!", 301129, 16000)
        SayAt(player, 239349, 60, 23000, "We'll follow him, my lady. Ren'dorei, with me.", 301128)
    end
end)

print("[edge_of_the_abyss] loaded")
