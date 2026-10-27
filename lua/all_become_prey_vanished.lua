-- =====================================================================
-- Quests 86516 All Become Prey + 86517 Vanished in the Void v1
-- 86516: Carrion Essence (237807) on-use na Slavering Ultradon (235498):
--        kredit 239657 (obj 459858), 1-dmg tap, blizke bestie zautocia,
--        swarm dotlcie ultradona (hrac je tapper -> nativny kredit), spotreba 1.
--        Spell 1218405 "Marked as Prey" je importnuty v SQL (item-use gate).
-- 86517: prichod k Maelle (238531): kredit 242933 (obj 461134) + yell 297414 (kit 301037)
--        + battle ultradon (3000214318) padne (kill z Maelle, bez kreditu hracovi).
--        Klik na gossipe: Maella 38407 -> kredit 238531 + say 283754 (kit 301076)
--                         Darkglen 38408 -> kredit 241170 + say 283755 (kit 321957)
--                         Hieron 38410 -> kredit 238530 + say 283753 (kit 322020) + zmizne
--        Prichod k Hieronovi (238530): kredit 250069 (obj 464326) + say 297415 (kit 322019).
-- Turn-in (86516/86517): Arator 283627 (kit 301084) + Lothraxion 283628 (kit 301083),
--        raz na hraca (shared guard "reward1617").
-- SQL: Custom/sql/20261017_abyss1617.sql (+undo). Texty: wiki verbatim.
-- =====================================================================
if IS_WORLD_STATE then return end

local STATUS_INCOMPLETE = 3

local SaidAt = {}

local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or 300) then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text, kit)
    text = text:gsub("%$p", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then
            pcall(function() PrintInfo("[abyss1617] say MISSED (no range) entry=" .. entry) end)
            return
        end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[abyss1617] say " .. (okS and "SENT" or "FAILED: " .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[abyss1617] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function KillNear(player, attackerEntry, victimEntry, range, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local attacker, victim
        local okL, list = pcall(function() return p:GetCreaturesInRange(range or 30) end)
        if not okL or not list then return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE then
                if e == attackerEntry and not attacker then attacker = c end
                if e == victimEntry and not victim then victim = c end
            end
        end
        if victim and victim:IsAlive() then
            local a = attacker or victim
            local okK, err = pcall(function() a:Kill(victim, false) end)
            pcall(function() PrintInfo("[abyss1617] kill " .. (okK and "OK" or "FAILED: " .. tostring(err)) .. " victim=" .. victimEntry) end)
        end
    end, delayMs or 1000, 1)
end

-- ------------------------------------------------ 86516 Carrion Essence
local BEAST_SET = {}
for _, e in ipairs({ 235636, 235637, 235639, 238163, 240488, 240492, 240497, 243658, 243797 }) do
    BEAST_SET[e] = true
end

local function MarkUltradon(player, ultradon)
    -- kredit 239657 = objektiv 459858 (zabitie oznaceneho ultradona)
    pcall(function() player:KilledMonsterCredit(239657) end)
    -- 1-dmg tap -> hrac bude tapper, ked ultradona dorazia bestie
    pcall(function() player:DealDamage(ultradon, 1, false) end)
    -- bestie v okoli zautocia (best effort - rovnaka frakcia to moze odmietnut)
    local okL, list = pcall(function() return ultradon:GetCreaturesInRange(40) end)
    if okL and list then
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and BEAST_SET[e] then
                pcall(function() c:SetInCombatWith(ultradon) end)
                pcall(function() c:AttackStart(ultradon) end)
                pcall(function() ultradon:SetInCombatWith(c) end)
            end
        end
    end
    -- swarm: kym bestie same nedobehnu, doticame ultradona z okolia
    ultradon:RegisterEvent(function(_, _, _, u)
        if not u or not u:IsInWorld() or not u:IsAlive() then return end
        local okB, blog = pcall(function() return u:GetCreaturesInRange(40) end)
        if not okB or not blog then return end
        for _, c in ipairs(blog) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and BEAST_SET[e] and c:IsAlive() then
                local dmg = math.max(1, math.floor(u:GetMaxHealth() * 0.03))
                pcall(function() c:DealDamage(u, dmg, false) end)
            end
        end
    end, 1200, 14)
    -- spotreba 1 essence
    pcall(function() player:RemoveItem(237807, 1) end)
    pcall(function() PrintInfo("[abyss1617] ultradon marked by " .. player:GetName()) end)
end

-- navrat false = spell sa nesesiluje (Eluna vsetko riesi sama); vsetko ostatne
-- (kredit/tap/swarm/spotreba) bezi len pri platnom targete - ultradon 235498
RegisterItemEvent(237807, 2, function(_, player, item, target)
    pcall(function()
        PrintInfo(string.format("[abyss1617] essence use player=%s target=%s",
            player and player:GetName() or "?", tostring(target and target.GetEntry and target:GetEntry() or "none")))
    end)
    pcall(function()
        if not player or not player:IsInWorld() then return end
        local unit = target
        if not unit or not unit.GetEntry then return end
        if unit:GetEntry() ~= 235498 then return end
        MarkUltradon(player, unit)
    end)
    return false
end)

-- ------------------------------------------------ 86517 gossip clicky
local function GossipCredit(npcEntry, menuId, creditEntry)
    return function(_, player, _, sender, intid)
        pcall(function()
            PrintInfo(string.format("[abyss1617] gossip npc=%d player=%s menu=%s intid=%s",
                npcEntry, player and player:GetName() or "?", tostring(sender), tostring(intid)))
        end)
        if sender ~= menuId then return false end
        pcall(function() player:KilledMonsterCredit(creditEntry) end)
        return true
    end
end

-- Maella: "I was separated from Hieron and Lady Darkglen. You must find them."
RegisterCreatureGossipEvent(238531, 2, function(_, player, _, sender, intid)
    if not GossipCredit(238531, 38407, 238531)(_, player, _, sender, intid) then return false end
    if not OnCooldown(player, "maella-found", 600) then
        SayAt(player, 238531, 60, 1000, "I was separated from Hieron and Lady Darkglen. You must find them.", 301076)
    end
    return true
end)

-- Darkglen: "Find that old fool. I'll give him an earful for playing hero."
RegisterCreatureGossipEvent(241170, 2, function(_, player, _, sender, intid)
    if not GossipCredit(241170, 38408, 241170)(_, player, _, sender, intid) then return false end
    if not OnCooldown(player, "darkglen-found", 600) then
        SayAt(player, 241170, 60, 1000, "Find that old fool. I'll give him an earful for playing hero.", 321957)
    end
    return true
end)

-- Hieron: "Good. Tell Astre I'm sorry. I don't think I'll make it back in time for tea." + zmizne
RegisterCreatureGossipEvent(238530, 2, function(_, player, _, sender, intid)
    if not GossipCredit(238530, 38410, 238530)(_, player, _, sender, intid) then return false end
    if not OnCooldown(player, "hieron-found", 600) then
        SayAt(player, 238530, 60, 1000, "Good. Tell Astre I'm sorry. I don't think I'll make it back in time for tea.", 322020)
        player:RegisterEvent(function(_, _, _, p)
            if not p or not p:IsInWorld() then return end
            local ok, list = pcall(function() return p:GetCreaturesInRange(60) end)
            if not ok or not list then return end
            for _, c in ipairs(list) do
                local okE, e = pcall(function() return c:GetEntry() end)
                if okE and e == 238530 then
                    pcall(function() c:DespawnOrUnsummon(0) end)
                    pcall(function() PrintInfo("[abyss1617] hieron vanished") end)
                    return
                end
            end
        end, 5500, 1)
    end
    return true
end)

-- ------------------------------------------------ 86517 prichody (scena)
if MAP_Timer then
    MAP_Timer("abyss1617.approach", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86517) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(20) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            if okE and e == 238531 and not OnCooldown(p, "maella-approach", 3600) then
                                pcall(function() p:KilledMonsterCredit(242933) end)
                                pcall(function() c:SendUnitYell("Stop wasting my time!", 0) end)
                                pcall(function() c:PlayDistanceSound(301037, p) end)
                                KillNear(p, 238531, 235498, 30, 1200)
                                pcall(function() PrintInfo("[abyss1617] maella approach " .. p:GetName()) end)
                            elseif okE and e == 238530 and not OnCooldown(p, "hieron-approach", 3600) then
                                pcall(function() p:KilledMonsterCredit(250069) end)
                                SayAt(p, 238530, 40, 1200, "Tried to lure them away. Worked a little too well.", 322019)
                                pcall(function() PrintInfo("[abyss1617] hieron approach " .. p:GetName()) end)
                            end
                        end
                    end
                end
            end
        end
    end, 4000)
end

-- ------------------------------------------------ turn-in scena 86516/86517
local function RewardScene(_, player, _, quest, opt)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and (qid == 86516 or qid == 86517)) then return end
    if OnCooldown(player, "reward1617", 3600) then return end
    pcall(function() PrintInfo(string.format("[abyss1617] reward quest=%d player=%s", qid, player:GetName())) end)
    SayAt(player, 235503, 80, 2000, "$p, where's Hieron? Is he...?", 301084)
    SayAt(player, 235504, 80, 9000, "War is no place for a tender heart, boy.", 301083)
end
RegisterCreatureEvent(235502, 34, RewardScene)
RegisterCreatureEvent(235503, 34, RewardScene)

print("[abyss1617] loaded")
