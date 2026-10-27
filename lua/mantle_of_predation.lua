-- =====================================================================
-- Quest 86518 The Mantle of Predation v1 (2026-10-17).
--  DB: Custom/sql/20261017_abyss18.sql (+ undo). Wiki: Warcraft Wiki 86518 Notes (verbatim).
--  1) Accept u Allerie 235502 (citadela, faza 45783, kit 301035):
--     "Make ready. It's time we claim the Mantle of Predation."
--  2) Listen gossip (Lothraxion 235504, menu 912046940, button GossipOptionID 912046940):
--     8 replik (kity 301055/301053/301118/301117/301116/301115/301114/301052)
--     + kredit 240741 (obj 461284 "Stay awhile and listen to Lothraxion", optional).
--     Arator 235503 stoji na citadele vo faze 45783 (672.6,-1384.5) - netreba summon.
--  3) Ready gossip (Alleria 235502, menu 38582, button GossipOptionID 38582):
--     kit 301113 + kredit 235502 (obj 459621 "Speak to Alleria when you're ready").
--     Povodny Oathstone auto-kredit (SAI id100 pri otvoreni okna) je zmazany v SQL -
--     kredit musi prist az po kliknuti buttonu.
--  4) Pecate: GO 504645 (Type2 obj 457976) - kredit ide NATIVNE cez GameObject::Use ->
--     KillCreditGO, preto Eluna handler VZDY vracia false (inak Use skonci pred kreditom).
--     Pecat A (x~226, kredit + Decimus 235697 kit 301067 + Lothraxion 235648 kit 301066),
--     pecat B (x~330, Arator 235503 kit 301065 + Alleria 235715 kit 301064 + Arator kit 301112).
--  5) Terminas' Vault (GO 523601, 177,-1737): trap scena - summon Terminas 235766
--     (Obscurion Overlord) kit 301111, Decimus 235718 kit 301110, Lothraxion 235504 kit 301109;
--     Alleria 235715 (realny spawn 186.1,-1730) kit 301107. Kredit 238381 (obj 457977).
--  Kity overene: hotfixes.broadcast_text (build 12.1.5.70391) + SoundKitEntry manifest.
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
                pcall(function() PrintInfo("[mantle] say " .. text:sub(1, 40) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[mantle] say MISSED entry=" .. entry) end)
    end, delayMs, 1)
end

local function SummonSay(player, entry, x, y, z, text, kit, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), 0, x, y, z, 0, false, 150000)
        if not (ok and c) then pcall(function() PrintInfo("[mantle] summon MISSED entry=" .. entry) end) return end
        pcall(function() c:SendUnitSay(text, 0) end)
        if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
        pcall(function() PrintInfo("[mantle] summon-say entry=" .. entry .. " kit=" .. tostring(kit)) end)
    end, delayMs, 1)
end

-- 1) Accept scena (citadela)
RegisterCreatureEvent(235502, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86518) then return end
    pcall(function() PrintInfo("[mantle] accept by " .. player:GetName()) end)
    SayAt(player, 235502, 80, 2000, "Make ready. It's time we claim the Mantle of Predation.", 301035)
end)

-- 2) Lothraxion Listen (citadela, menu 912046940)
RegisterCreatureGossipEvent(235504, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[mantle] lothraxion click player=%s menu=%s intid=%s q86518=%s", player:GetName(), tostring(sender), tostring(intid), tostring(QStatus(player, 86518)))) end)
    if sender ~= 912046940 then return end
    if QStatus(player, 86518) ~= STATUS_INCOMPLETE then return end
    pcall(function() player:KilledMonsterCredit(240741) end)
    if OnCooldown(player, "listen", 600) then return end
    SayAt(player, 235504, 80, 1500, "Soon we'll have all we need. We should strike down this wretch before their hunger turns on us.", 301055)
    SayAt(player, 235502, 80, 9000, "Don't you think we have enough enemies ahead of us? I'll take allies where I can get them.", 301053)
    SayAt(player, 235504, 80, 17000, "The Void holds allegiance to none!", 301118)
    SayAt(player, 235504, 80, 25000, "It corrupts and confounds, makes enemies of friends, twists right into wrong.", 301117)
    SayAt(player, 235503, 80, 33000, "The Light isn't harmless either. I've felt its fury. Seen the sacrifices it can compel us to make.", 301116)
    SayAt(player, 235504, 80, 41000, "I have served the Light for millennia. I understand sacrifice better than you ever could.", 301115)
    SayAt(player, 235503, 80, 49000, "Then don't become numb to it! We all fight for the same cause.", 301114)
    SayAt(player, 235504, 80, 57000, "Yet only I seem to understand what is at stake.", 301052)
end)

-- 3) Alleria Ready (citadela, menu 38582)
RegisterCreatureGossipEvent(235502, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[mantle] alleria click player=%s menu=%s intid=%s q86518=%s", player:GetName(), tostring(sender), tostring(intid), tostring(QStatus(player, 86518)))) end)
    if sender ~= 38582 then return end
    if QStatus(player, 86518) ~= STATUS_INCOMPLETE then return end
    pcall(function() player:KilledMonsterCredit(235502) end)
    if OnCooldown(player, "ready", 300) then return end
    SayAt(player, 235502, 80, 1500, "Stay together. No one fights alone, no one gets left behind.", 301113)
end)

-- 4) Pecate GO 504645 - kredit je NATIVNE, handler VZDY vracia false
local function SealUse(_, player, go)
    if not player then return false end
    local x = -1.0
    pcall(function() x = go:GetX() end)
    pcall(function() PrintInfo(string.format("[mantle] seal use player=%s x=%.1f q86518=%s", player:GetName(), x, tostring(QStatus(player, 86518)))) end)
    if QStatus(player, 86518) ~= STATUS_INCOMPLETE then return false end
    if x > 280 then
        if not OnCooldown(player, "sealB", 600) then
            SayAt(player, 235503, 80, 1500, "That look in Lothraxion's eyes is the same I saw in father's.", 301065)
            SayAt(player, 235715, 80, 9000, "I wish Turalyon were here. Lothraxion might listen to him.", 301064)
            SayAt(player, 235503, 80, 17000, "Claim the Mantle. We'll watch your back.", 301112)
        end
    elseif x > 0 then
        if not OnCooldown(player, "sealA", 600) then
            SayAt(player, 235697, 80, 1500, "Can you feel it? The Mantle is close at hand.", 301067)
            SayAt(player, 235648, 80, 9000, "Don't look so eager, beast. You've fooled Alleria, but I see through you.", 301066)
        end
    end
    return false
end
pcall(RegisterGameObjectGossipEvent, 504645, 1, SealUse)

-- 5) Terminas' Vault GO 523601 - trap scena + kredit 238381
local function VaultUse(_, player, go)
    if not player then return false end
    pcall(function() PrintInfo(string.format("[mantle] vault use player=%s q86518=%s", player:GetName(), tostring(QStatus(player, 86518)))) end)
    if QStatus(player, 86518) ~= STATUS_INCOMPLETE then return false end
    if OnCooldown(player, "trapscene", 3600) then return false end
    pcall(function() player:KilledMonsterCredit(238381) end)
    SummonSay(player, 235766, 172.0, -1742.0, -30.6, "Away for but a moment and the vermin move in. You were right to alert me, Decimus.", 301111, 1500)
    SummonSay(player, 235718, 182.0, -1742.0, -30.6, "Do keep our magnificent lord entertained, friends. I'd so hate for him to lose interest.", 301110, 11000)
    SummonSay(player, 235504, 173.0, -1732.5, -30.6, "I warned you! This was always their plot!", 301109, 19000)
    SayAt(player, 235715, 60, 27000, "What did I miss? Why wait until now to betray us?", 301107)
    pcall(function() PrintInfo("[mantle] trap scene start player=" .. player:GetName()) end)
    return false
end
pcall(RegisterGameObjectGossipEvent, 523601, 1, VaultUse)

-- Cleanup cooldown tabulky pri odhlaseni
RegisterPlayerEvent(4, function(_, player)
    pcall(function()
        local n = player:GetName() .. ":"
        local del = {}
        for k in pairs(Said) do
            if k:sub(1, #n) == n then del[#del + 1] = k end
        end
        for _, k in ipairs(del) do Said[k] = nil end
    end)
end)

print("[mantle_of_predation] loaded")
