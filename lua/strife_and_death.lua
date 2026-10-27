-- =====================================================================
-- Quest 86557 A Matter of Strife and Death v1: kill kredity + accept scena.
-- Objekt dava marker 239684 (nie mob-entry) -> kredity cez kill-hook 5 Ingress mobov
-- (235414/235416/235415/235413/241975, vsetci spawnuti na 2771).
-- Accept scena (Wiki Notes): Lothraxion "Come!" + Everdawn say (speakri na Sanctume).
-- Progress text v DB. Turn-in Lothraxion 235522 funguje (Oathstone open = mechanika).
-- DB: Custom/sql/20261016_abyss655758.sql (+undo).
-- Follow-up: Maella says (chyba speaker), scout split-up pohyb.
-- =====================================================================
if IS_WORLD_STATE then return end

local MOBS = { [235414] = true, [235416] = true, [235415] = true, [235413] = true, [241975] = true }

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86557] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86557] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86557] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterPlayerEvent(7, function(_, killer, victim)
    local okV, v = pcall(function() return victim:GetEntry() end)
    if not okV or not MOBS[v] then return end
    local okS, st = pcall(function() return killer:GetQuestStatus(86557) end)
    if okS and st == STATUS_INCOMPLETE then
        pcall(function() killer:KilledMonsterCredit(239684) end)
        pcall(function() PrintInfo("[ds86557] kill credit 239684 mob=" .. v .. " player=" .. killer:GetName()) end)
    end
end)

RegisterCreatureEvent(235486, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86557) then return end
    pcall(function() PrintInfo("[ds86557] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235486, 80, 1500, "We must get a lay of the land. Come!", 300651)
    SayAt(player, 240831, 80, 7000, "We must scout... yes. Yes, scout ahead...", 300652)  -- bt 283094 kit2 vo_120_voidlight_everdawn_02
end)

print("[strife_and_death] loaded")
