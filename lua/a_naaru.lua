-- =====================================================================
-- Quest 86539 A Naaru! v1: accept scena s dabingom + Arator gossip (DB).
-- Turn-in nativny (faza 45764 OK). Decimus unlink (ziadny gossip).
-- DB: Custom/sql/20261016_abyss86539.sql (+undo).
-- Follow-up: party odchod pohyb.
-- =====================================================================
if IS_WORLD_STATE then return end

local function SayAt(player, entry, range, delayMs, text, kit)
    text = text:gsub("<name>", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86539] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86539] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86539] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(235717, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86539) then return end
    pcall(function() PrintInfo("[ds86539] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235713, 80, 2000, "Keep your distance from the naaru, voidspawn. You are unworthy to bask in its radiance!", 300893)
    SayAt(player, 235718, 80, 8000, "If you're going to degrade me, Lothraxion, you could at least put some effort into it.", 300883)
end)

print("[a_naaru] loaded")
