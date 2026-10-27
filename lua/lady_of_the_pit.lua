-- =====================================================================
-- Quest 86514 Lady of the Pit v1.1: kompletne ozvucene (retail kity, 2026-10-17).
--  1) Accept u Allerie 236945 (kit 301126): "Challenge Torentia and claim her sigil..."
--  2) Pit fight Torentia 235708 (bud 45781):
--       enter-combat -> 301080 "I'll feed you to the beasts!"
--       <60% HP       -> 301079 "No! You won't take this from me!"
--       kill          -> 301125 yield "Wait! I bow to your strength! Let me serve you! Together we--"
--     potom Decimus (summon 235633): 301124 "Stirring. Some friendly advice..." + 301048
--     "Delicious. Already halfway to unlocking the Mantle."
--  3) Vault (areatrigger 9108444, zona ~325,-850,-214; timer 5 s):
--       Alleria 301123 -> Lothraxion 301122 -> Alleria 301121 -> Lothraxion 301119/301118/301117
--       -> Arator 301116 -> Lothraxion 301115 -> Arator 301114 -> Alleria 301113 -> Arator 301112.
--  Kity overene: transkripcia fids 7249334/7249344/7249347/7249351 (Alleria) + SoundKitEntry.
-- =====================================================================
if IS_WORLD_STATE then return end

local Said = {}
local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = Said[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or 300) then return true end
    Said[player:GetName() .. ":" .. key] = stamp
    return false
end

local function QStatus(player, q)
    local ok, st = pcall(function() return player:GetQuestStatus(q) end)
    return (ok and st) or -1
end

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ladyofthepit] say " .. text:sub(1, 40) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ladyofthepit] say MISSED entry=" .. entry) end)
    end, delayMs, 1)
end

local function SummonSay(player, entry, x, y, z, text, kit, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), 0, x, y, z, 0, false, 120000)
        if not (ok and c) then pcall(function() PrintInfo("[ladyofthepit] summon MISSED entry=" .. entry) end) return end
        pcall(function() c:SendUnitSay(text, 0) end)
        if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
        pcall(function() PrintInfo("[ladyofthepit] summon-say entry=" .. entry .. " kit=" .. tostring(kit)) end)
    end, delayMs, 1)
end

-- 1) Accept scena: Alleria (pit tabor)
RegisterCreatureEvent(236945, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86514) then return end
    SayAt(player, 236945, 80, 2000, "Challenge Torentia and claim her sigil. Arator, let's regroup with the others in the upper citadel.", 301126)
end)

-- 2) Pit fight: aggro
RegisterCreatureEvent(235708, 1, function(_, creature, target)
    if not (creature and target) then return end
    pcall(function() creature:SendUnitSay("I'll feed you to the beasts!", 0) end)
    pcall(function() creature:PlayDistanceSound(301080, target) end)
    pcall(function() PrintInfo("[ladyofthepit] pit aggro") end)
end)

-- 2b) Pit fight: nizke HP (raz za hraca)
RegisterCreatureEvent(235708, 9, function(_, creature, attacker)
    if not (creature and attacker) then return end
    if OnCooldown(attacker, "pitlow", 1800) then return end
    local okH, h = pcall(function() return creature:GetHealthPct() end)
    if not (okH and h) then
        local ok1, cur = pcall(function() return creature:GetHealth() end)
        local ok2, mx = pcall(function() return creature:GetMaxHealth() end)
        if ok1 and ok2 and mx and mx > 0 then h = cur / mx * 100 end
    end
    if h and h < 60 then
        pcall(function() creature:SendUnitSay("No! You won't take this from me!", 0) end)
        pcall(function() creature:PlayDistanceSound(301079, attacker) end)
        pcall(function() PrintInfo("[ladyofthepit] pit lowhp " .. math.floor(h) .. "%") end)
    end
end)

-- 2c) Kill: yield + Decimus komentar (video ~1:06-1:27)
RegisterPlayerEvent(7, function(_, killer, victim)
    local okV, v = pcall(function() return victim:GetEntry() end)
    if not (okV and v == 235708) then return end
    if QStatus(killer, 86514) ~= STATUS_INCOMPLETE then return end
    pcall(function() victim:SendUnitSay("Wait! I bow to your strength! Let me serve you! Together we--", 0) end)
    pcall(function() victim:PlayDistanceSound(301125, killer) end)
    local okX, x = pcall(function() return victim:GetX() end)
    local okY, y = pcall(function() return victim:GetY() end)
    local okZ, z = pcall(function() return victim:GetZ() end)
    if okX and okY and okZ then
        SummonSay(killer, 235633, x + 4.0, y, z, "Stirring. Some friendly advice: never trust a domanaar who feigns subservience.", 301124, 7000)
        SummonSay(killer, 235633, x + 4.0, y, z, "Delicious. Already halfway to unlocking the Mantle.", 301048, 15000)
    end
    pcall(function() PrintInfo("[ladyofthepit] pit kill by " .. killer:GetName()) end)
end)

-- 3) Vault scena (po nasavani sigilu v klenbe)
if MAP_Timer then
    MAP_Timer("ladyofthepit.vault", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local st = QStatus(p, 86514)
                if st == STATUS_INCOMPLETE or st == STATUS_COMPLETE then
                    local okX, x = pcall(function() return p:GetX() end)
                    local okY, y = pcall(function() return p:GetY() end)
                    if okX and okY then
                        local dx, dy = x - 325.0, y + 850.0
                        if dx * dx + dy * dy < 900 then
                            if not OnCooldown(p, "vaultscene", 3600) then
                                local bx, by, bz = 325.0, -850.0, -214.0
                                SummonSay(p, 236945, bx + 5, by + 2, bz, "You abandoned them?", 301123, 1500)
                                SummonSay(p, 235477, bx - 5, by + 2, bz, "Acceptable losses. The void elves knew the risks.", 301122, 9500)
                                SummonSay(p, 236945, bx + 5, by - 2, bz, "Remain here, Lothraxion. You've already put this mission at risk.", 301121, 17000)
                                SummonSay(p, 235477, bx - 5, by - 2, bz, "Risk? You trust the word of a domanaar over mine.", 301119, 25000)
                                SummonSay(p, 235477, bx - 5, by + 4, bz, "The Void holds allegiance to none!", 301118, 33000)
                                SummonSay(p, 235477, bx - 5, by + 4, bz, "It corrupts and confounds, makes enemies of friends, twists right into wrong.", 301117, 41000)
                                SummonSay(p, 235469, bx + 3, by - 5, bz, "The Light isn't harmless either. I've felt its fury. Seen the sacrifices it can compel us to make.", 301116, 49000)
                                SummonSay(p, 235477, bx - 5, by + 4, bz, "I have served the Light for millennia. I understand sacrifice better than you ever could.", 301115, 57000)
                                SummonSay(p, 235469, bx + 3, by - 5, bz, "Then don't become numb to it! We all fight for the same cause.", 301114, 65000)
                                SummonSay(p, 236945, bx + 5, by - 2, bz, "Stay together. No one fights alone, no one gets left behind.", 301113, 73000)
                                SummonSay(p, 235469, bx + 3, by - 5, bz, "Claim the Mantle. We'll watch your back.", 301112, 81000)
                                pcall(function() PrintInfo("[ladyofthepit] vault scene start player=" .. p:GetName()) end)
                            end
                        end
                    end
                end
            end
        end
    end, 5000)
end

print("[lady_of_the_pit] loaded")
