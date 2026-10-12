-- =====================================================================
-- Quest 92899 History Lesson: delegate insight kredity + response says (Wiki Notes).
-- Menu 40419 Orweyna (movie button -> KC 254887) + 40420/21/23/24/25/26 insight
-- (Shandris/Umbric/Vereesa/Rokhan/Talanji/Thalyssra -> KC 254886 + say).
-- Zekhan 40422 bez buttonov (len lore). Talanji opt1 troops = lore say bez kreditu.
-- Accept-say riesi SmartAI (event 19). SmartAI 62->33 je ZALOHA kreditov. Cooldown 60 s.
-- Texty doslovne z Warcraft Wiki History_Lesson. Ziadny dabing (SoundKit 0 v DB).
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}
local COOLDOWN = 60

local function OnCooldown(player, key)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < COOLDOWN then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                pcall(function() c:SendUnitSay(text, 0) end)
                return
            end
        end
    end, delayMs, 1)
end

local function InsightHandler(entry, menuId, key, sayText)
    return function(_, player, _, sender, intid)
        if sender ~= menuId then return end
        pcall(function() player:KilledMonsterCredit(254886) end)
        if OnCooldown(player, key) then return end
        SayAt(player, entry, 60, 1500, sayText)
    end
end

-- Orweyna: (Play Movie) button -> KC Speak to Orweyna + zavriet okno (film by ho zavrel).
RegisterCreatureGossipEvent(253654, 2, function(_, player, _, sender, intid)
    if sender ~= 40419 then return end
    pcall(function() player:GossipComplete() end)
    pcall(function() player:KilledMonsterCredit(254887) end)
end)

RegisterCreatureGossipEvent(253659, 2, InsightHandler(253659, 40420, "hist-shandris",
    "The kaldorei will do what we must for the preservation of this world... and the protection of our people."))

RegisterCreatureGossipEvent(253657, 2, InsightHandler(253657, 40421, "hist-umbric",
    "For a group that has avoided trolls and elves for so long, the haranir seem rather rushed to tell us something."))

RegisterCreatureGossipEvent(258035, 2, InsightHandler(258035, 40423, "hist-vereesa",
    "I am told the Amani have been invited as well. Do not expect me to break bread with those murderers."))

RegisterCreatureGossipEvent(253661, 2, InsightHandler(253661, 40424, "hist-rokhan",
    "De Darkspear spilled blood with some of de trolls and elves here. But I be willing to set aside old rivalries for de common good."))

RegisterCreatureGossipEvent(253660, 2, function(_, player, _, sender, intid)
    if sender ~= 40425 then return end
    if intid == 1 then
        -- Lore follow-up bez kreditu (Wiki: Why did you bring so many troops?).
        if OnCooldown(player, "hist-talanji-troops") then return end
        SayAt(player, 253660, 60, 1500, "So many? It is a fraction of my honor guard. If anything, I brought fewer. De Zandalari are a proud people. Sometimes so proud, we believe we are Invincible. No longer. I have made it my priority to never underestimate our enemies. Surprise attacks, assassinations--we will not be caught unaware again. I have not forgotten what the Alliance did to my father. And I never will.")
        return
    end
    pcall(function() player:KilledMonsterCredit(254886) end)
    if OnCooldown(player, "hist-talanji") then return end
    SayAt(player, 253660, 60, 1500, "All of Azeroth respects de haranir for fighting against de Void. But to bring so many old enemies to one place? Watch carefully.")
end)

RegisterCreatureGossipEvent(253658, 2, InsightHandler(253658, 40426, "hist-thalyssra",
    "Many kaldorei still view us with scorn. To them, we are either cowards who hid from the Legion or traitors who joined the Horde."))

print("[historylesson92899] loaded")
