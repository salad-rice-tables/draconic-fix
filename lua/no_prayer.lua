-- =====================================================================
-- Quest 86565 No Prayer for the Wicked v1: metal + pet + vortex + Listen dialog.
-- Metal GO 532503 (use -> kredit 243730 + temp-summon Alleria/Arator + 4 says).
-- Sinewshredder 235570: approach (Lothraxion "pet" say, temp-summon) + kill
--   (domanaar 283119 + Lothraxion 283120). Domanaar approach say 283117.
-- Vortex GO 504677 (use -> post-video says 283125/283123, 45760 entries).
-- Listen (Alleria 235609, menu 912046906): kredit 244305 + 20-say dialog + timed
--   kredit 243586 (Arator embers). Certain button: dialog bez kreditu.
-- VO kits 300687-300692 (retail dabing). Texty Wiki No_Prayer_for_the_Wicked verbatim.
-- DB: Custom/sql/20261016_abyss86565.sql (+undo).
-- Follow-up: cutscene "Decimus" (video), beam, Maella manaforge say (chyba speaker).
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}

local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or 300) then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text, kit)
    text = text:gsub("<name>", player:GetName()):gsub("%$p", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86565] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86565] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86565] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function SummonSay(player, entry, x, y, z, text, kit, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), 0, x, y, z, 0, false, 120000)
        if not (ok and c) then pcall(function() PrintInfo("[ds86565] summon MISSED entry=" .. entry) end) return end
        local t = text:gsub("<name>", p:GetName()):gsub("%$p", p:GetName())
        local okS, err = pcall(function() c:SendUnitSay(t, 0) end)
        if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
        pcall(function() PrintInfo("[ds86565] summon-say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
    end, delayMs, 1)
end

-- Metal: kredit + Alleria/Arator docasne + 4 says (speakri mimo faze -> summon)
local function MetalUse(_, player, _)
    local okQ, st = pcall(function() return player:GetQuestStatus(86565) end)
    if not (okQ and st == STATUS_INCOMPLETE) then return true end
    pcall(function() player:KilledMonsterCredit(243730) end)
    pcall(function() PrintInfo("[ds86565] metal use player=" .. player:GetName()) end)
    if OnCooldown(player, "metal-scene") then return true end
    SummonSay(player, 235609, 2167.0, 2129.0, -55.17, "Light and Shadow, two sides of the same coin. With enough of a push, Light can become Shadow.", nil, 2000)
    SummonSay(player, 235608, 2169.0, 2129.0, -55.17, "And Shadow can become Light. I see, mother. We can use their own materials to bind and capture that domanaar.", 300679, 9000)
    return true
end
pcall(RegisterGameObjectGossipEvent, 532503, 1, MetalUse)

-- Pet: approach say + kill says
if MAP_Timer then
    MAP_Timer("noprayer.pet", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86565) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(80) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            if okE and e == 235570 and not OnCooldown(p, "pet-approach") then
                                SummonSay(p, 235535, 2143.0, 2157.0, -55.0, "Take down its pet!", 300688)
                            end
                            if okE and e == 235568 and not OnCooldown(p, "dom-approach", 600) then
                                SayAt(p, 235568, 80, 500, "Azerothians! Oh, you'll make exquisite trophies.", 300687)
                            end
                        end
                    end
                end
            end
        end
    end, 15000)
end

RegisterPlayerEvent(7, function(_, killer, victim)
    local okV, v = pcall(function() return victim:GetEntry() end)
    if not okV or v ~= 235570 then return end
    local okS, st = pcall(function() return killer:GetQuestStatus(86565) end)
    if not (okS and st == STATUS_INCOMPLETE) then return end
    pcall(function() PrintInfo("[ds86565] pet dead player=" .. killer:GetName()) end)
    if OnCooldown(killer, "pet-dead", 600) then return end
    SummonSay(killer, 235568, 2172.0, 2132.0, -55.0, "My, what a delicious bloodbath! But I'm afraid I must take my leave.", 300689)
    SummonSay(killer, 235535, 2172.0, 2136.0, -55.0, "No! After it!", 300690)
end)

-- Vortex: post-video says (45760 entries; quest vtedy complete)
local function VortexUse(_, player, _)
    pcall(function() PrintInfo("[ds86565] vortex use player=" .. player:GetName()) end)
    if OnCooldown(player, "vortex", 600) then return true end
    SayAt(player, 235606, 120, 8000, "One wrong move and I will sear you with the Light, fiend.", 300691)
    SayAt(player, 235600, 120, 14000, "Such strength and wisdom! Clearly, it would be foolish to defy you!", 300692)
    return true
end
pcall(RegisterGameObjectGossipEvent, 504677, 1, VortexUse)

-- Listen dialog (20 says; 243586 pri embers linke)
local function Dialogue(player, withCredit)
    if withCredit then pcall(function() player:KilledMonsterCredit(244305) end) end
    if OnCooldown(player, "listen-talk", 600) then return end
    local A, R = 235609, 235608
    SayAt(player, A, 80, 2000, "Tell me of Silvermoon, Arator. How bad was it?", 300693)
    SayAt(player, R, 80, 9000, "Honestly, if not for the Light forces intervening when they did, we would have lost everything.", 300694)
    SayAt(player, A, 80, 16000, "I see. And your father, is he well?", 300695)
    SayAt(player, R, 80, 23000, "He... I fear the Light... blinds him, Mother. In his rage, he... he struck down an innocent.", 300696)
    SayAt(player, A, 80, 30000, "Who, Arator?", 300697)
    SayAt(player, R, 80, 37000, "That... doesn't matter now. What matters is that if the Light can turn someone like him wrathful...", 300698)
    SayAt(player, A, 80, 44000, "You fear succumbing to it yourself.", 300699)
    SayAt(player, R, 80, 51000, "I already did, fighting the Void. You see these embers I bear? I burned myself in wrath. They remain as a reminder.", 300700)
    player:RegisterEvent(function(_, _, _, p)
        if p and p:IsInWorld() then pcall(function() p:KilledMonsterCredit(243586) end) end
    end, 56000, 1)
    SayAt(player, R, 80, 58000, "That thought terrifies me more than the Void ever could.", 300703)
    SayAt(player, A, 80, 65000, "If I've learned anything from fighting beside your father, it's that the Light is strongest when rooted in love and compassion.", 300705)
    SayAt(player, A, 80, 72000, "Those two things, Arator, just happen to be your greatest strengths. Stay true to yourself--", 300706)
    SayAt(player, R, 80, 79000, "And wrath cannot overtake me. Heh. Your counsel is comforting, mother.", 300707)
    SayAt(player, A, 80, 86000, "Well, I have had a thousand years of practice, kid.", 300708)
end

RegisterCreatureGossipEvent(235609, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86565] alleria player=%s menu=%s intid=%s q86565=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86565)))) end)
    if sender ~= 912046906 then return end
    if intid == 0 then Dialogue(player, true) else Dialogue(player, false) end
end)

-- Decimus gossip click log (kredit nie je treba - flavor)
RegisterCreatureGossipEvent(235607, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86565] decimus player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
end)

print("[no_prayer] loaded")
