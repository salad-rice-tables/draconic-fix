-- =====================================================================
-- Quest 86545 The Light's Brand Eluna v1: accept scena + gather + deliver +
-- healing + reveal says + find. Turn-in nativny. Texty Wiki The_Light's_Brand.
-- DB: Custom/sql/20261016_abyss6545.sql (+undo) a 20261016_abyss4455.sql.
-- Follow-up: post-gossip okna, paladin dialog, staff/ring vizualy, pohyby.
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
    text = text:gsub("<name>", player:GetName()):gsub("%$n", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86545] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86545] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86545] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

-- Accept scena (Wiki Notes, Locus): Alleria + Arator
RegisterCreatureEvent(235724, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86545) then return end
    pcall(function() PrintInfo("[ds86545] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235726, 80, 2000, "Arator! Stop them!", 300824)  -- bt 285421 vo_120_alleria_windrunner_23
    SayAt(player, 235792, 80, 8000, "We have to move!", 300848)
end)

-- Gather: proximity Burning Light 9100610 -> AddItem (cap 15)
if MAP_Timer then
    MAP_Timer("lightbrand.gather", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86545) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(14) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            if okE and e == 9100610 then
                                local okC, nc = pcall(function() return p:GetItemCount(240626) end)
                                if okC and nc < 15 and not OnCooldown(p, "gather", 5) then
                                    pcall(function() p:AddItem(240626, 1) end)
                                    pcall(function() p:SendBroadcastMessage("You gather the Burning Light. (" .. (nc + 1) .. "/15)") end)
                                    pcall(function() PrintInfo("[ds86545] gather n=" .. (nc + 1) .. " player=" .. p:GetName()) end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end, 5000)
end

-- Deliver + healing (Arator 235792, menu 39077)
RegisterCreatureGossipEvent(235792, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86545] arator player=%s menu=%s intid=%s q86545=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86545)))) end)
    if sender ~= 39077 then return end
    local okC, nc = pcall(function() return player:GetItemCount(240626) end)
    if okC and nc >= 15 and not OnCooldown(player, "deliver", 600) then
        pcall(function() player:RemoveItem(240626, 15) end)
        for _ = 1, 15 do pcall(function() player:KilledMonsterCredit(240626) end) end
        SayAt(player, 235792, 80, 2000, "Cease!", 300850)
        SayAt(player, 235792, 80, 8000, "By the Light's mercy, I command you both to yield! We have no shortage of enemies!", 300980)
        SayAt(player, 235726, 80, 15000, "And we need not create them where we might find allies. Decimus is more than they seem.", 300815)  -- bt 283052 vo_120_alleria_windrunner_21
    end
    pcall(function() player:KilledMonsterCredit(250369) end)
    local okH, mx = pcall(function() return player:GetMaxHealth() end)
    if okH then pcall(function() player:SetHealth(mx) end) end
end)

-- Reveal says (Decimus open = interact; kredit SAI nativne)
RegisterCreatureGossipEvent(240691, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86545] decimus-reveal player=%s", player:GetName())) end)
    if OnCooldown(player, "reveal", 600) then return end
    SayAt(player, 240691, 60, 2000, "... Gave myself away, did I?", 300876)
    SayAt(player, 235726, 60, 8000, "You seek power, Decimus. Xal'atath will not give you what you want, but her defeat might. Join us.", 300969)  -- bt 283054 vo_120_alleria_windrunner_40
    SayAt(player, 240691, 60, 15000, "Truly fascinating. You continue to defy expectations.", 300928)
    SayAt(player, 240673, 60, 22000, "This beast is off its leash!", 317557)
end)

-- Find: proximity outskirts (Wiki: Find Lothraxion and Decimus)
if MAP_Timer then
    MAP_Timer("lightbrand.find", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86545) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okX, x = pcall(function() return p:GetX() end)
                    local okY, y = pcall(function() return p:GetY() end)
                    if okX and okY then
                        local d = math.sqrt((x - 728) * (x - 728) + (y - 620) * (y - 620))
                        if d < 60 and not OnCooldown(p, "find", 600) then
                            pcall(function() p:KilledMonsterCredit(239571) end)
                            pcall(function() PrintInfo("[ds86545] find credit player=" .. p:GetName()) end)
                        end
                    end
                end
            end
        end
    end, 10000)
end

print("[light_brand] loaded")
