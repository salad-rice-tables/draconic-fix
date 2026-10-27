-- =====================================================================
-- Quest 86559 The Far, Far Frontier v1: Lothraxion/Alleria gossip + says s dabingom.
-- Lothraxion 235522 (menu 38425): Play-Movie button (video chybí - follow-up C++ autoplay).
-- Alleria 235521 (menu 38431): 2 quest buttony + submenu 38432 (movie button = existujuci
-- SAI PlayMovie 1040). Says: Lothraxion 283105 (kit 300669) + Alleria 289014 (kit 300672).
-- Survey/speak kredity idu otvorenim (Oathstone, mechanika). Turn-in 235522 (faza 45754 OK).
-- DB: Custom/sql/20261016_abyss86559.sql (+undo).
-- Follow-up: cutscene "Reunion", Arator post-movie chain, Antius stretnutie (45757 mimo 86559).
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86559] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86559] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86559] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureGossipEvent(235522, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86559] lothraxion player=%s menu=%s intid=%s q86559=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86559)))) end)
    if sender ~= 38425 then return end
    pcall(function() player:KilledMonsterCredit(235522) end)
end)

RegisterCreatureGossipEvent(235521, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86559] alleria player=%s menu=%s intid=%s q86559=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86559)))) end)
    if sender ~= 38431 then return end
    pcall(function() player:KilledMonsterCredit(235521) end)
    local key = player:GetName() .. ":alleria-help"
    if (SaidAt[key] or 0) + 300 < os.time() then
        SaidAt[key] = os.time()
        SayAt(player, 235522, 80, 2000, "Understand, Alleria, that I lead this mission. But your aid is welcome.", 300669)
        SayAt(player, 235521, 80, 8000, "Then that is our first target. We must weaken the storm and our foes! Move out!", 300672)
    end
end)

print("[far_far_frontier] loaded")
