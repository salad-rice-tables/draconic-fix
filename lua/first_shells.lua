-- =====================================================================
-- Quest 86530 First, The Shells v1: Listen button + 13-say scena (Wiki verbatim).
-- Loot manacellov nativny (100% ze 4 mobov). Turn-in nativny. Odmeny gear-choice
-- follow-up (9 ID z ItemSparse: 260848/262375/76/262672/74/75/78/262733/37).
-- DB: Custom/sql/20261016_abyss3038.sql (+undo).
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86530] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86530] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86530] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureGossipEvent(235713, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86530] player=%s menu=%s intid=%s q86530=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86530)))) end)
    if sender ~= 38396 then return end
    pcall(function() player:KilledMonsterCredit(235713) end)
    local key = player:GetName() .. ":listen"
    if (SaidAt[key] or 0) + 600 < os.time() then
        SaidAt[key] = os.time()
        local L, D = 235713, 235718
        SayAt(player, L, 80, 2000, "Earn your keep. Tell us more.", 300888)
        SayAt(player, D, 80, 8000, "But of course, it is the right of the victor to take from the defeated. On this world, and on every other.", 300903)
        SayAt(player, D, 80, 15000, "You stand upon a land ruled by predation. Here, the strong thrive and the weak sustain them.", 300879)
        SayAt(player, D, 80, 22000, "The recent arrival of Xal'atath was, for a time, an entertaining shake up. But her vision for your world--for all of our cosmos--is terribly dull.", 300800)
        SayAt(player, D, 80, 29000, "Darkness. Endless, yawning, monotonous darkness.", 300855)
        SayAt(player, L, 80, 36000, "She brought you to heel? How like the endless armies of the Void to suffer from disorder.", 300889)
        SayAt(player, D, 80, 43000, "Too true. I prefer the thrash and struggle. The delights of stark contrast. There is no foe so thrilling as one strong in the Light.", 300843)
        SayAt(player, L, 80, 50000, "Belief is our strength. You believe in nothing.", 300831)
        SayAt(player, D, 80, 57000, "So pious. You're a curious creature, aren't you? A nathrezim, all wreathed in gold? Must be quite the story.", 300907)
        SayAt(player, L, 80, 64000, "We embrace a unity you could never understand.", 300839)
        SayAt(player, L, 80, 71000, "I became worthy of the Light. Such strength of will is beyond you.", 300854)
        SayAt(player, D, 80, 78000, "So aggressive. This world suits you, Lothraxion.", 300812)
    end
end)

print("[first_shells] loaded")
