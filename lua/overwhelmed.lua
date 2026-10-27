-- =====================================================================
-- Quest 89249 Overwhelmed v1: accept scena + Arator gossip (DB) + turn-in nativny.
-- 0 objektivov (TDB parita) = story-hop: vziat -> stretnut gang -> odovzdat.
-- Accept scena (Wiki Notes, 45770 pri starterovi): Decimus + Lothraxion.
-- Arator 235724 (menu 38642): telo + 2 buttony + submenu (Wiki verbatim).
-- DB: Custom/sql/20261016_abyss312849.sql (+undo).
-- =====================================================================
if IS_WORLD_STATE then return end

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds89249] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds89249] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds89249] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(241109, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 89249) then return end
    pcall(function() PrintInfo("[ds89249] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235652, 80, 2000, "I had no idea Lady Windrunner held a dark naaru of her own. This is more than mere entertainment...", 300825)
    SayAt(player, 235649, 80, 9000, "Ignore it, Arator. See to Alleria. Salvaging this mission now falls to me.", 300870)
end)

RegisterCreatureGossipEvent(235724, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds89249] arator player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
end)

print("[overwhelmed] loaded")
