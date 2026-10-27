-- =====================================================================
-- Quests 86538 Second, The Fuel + 86537 Network Insecurity v1: accept scena,
-- konzoly (Echo-Missive says), Tempest Keeper, mob says. Loot/GO/turn-in nativne.
-- Post-quest gossip stromy v DB (menu 38434/38396 + submenu 38435-437).
-- Texty Wiki verbatim; dabing kde existuje (kits 300819/300877/300945/300946/300827).
-- DB: Custom/sql/20261016_abyss3837.sql (+undo).
-- Follow-up: videa (movie buttony), meet-back says, gear-choice odmeny.
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
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds3837] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds3837] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds3837] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function SummonSay(player, entry, x, y, z, text, kit, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), 0, x, y, z, 0, false, 120000)
        if not (ok and c) then pcall(function() PrintInfo("[ds3837] summon MISSED entry=" .. entry) end) return end
        local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
        if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
        pcall(function() PrintInfo("[ds3837] summon-say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
    end, delayMs, 1)
end

-- Accept oboch questov naraz: jedna scena (Wiki Notes, overlook 45762)
local function AcceptScene(player)
    if OnCooldown(player, "accept-scene", 600) then return end
    SayAt(player, 235389, 80, 2000, "Xal'atath doesn't spare her enemies without a reason. Find out what the ethereals are doing here.", 300951)  -- bt 282981 vo_120_alleria_windrunner_37
    SayAt(player, 235713, 80, 8000, "What does it matter? Salvage what we need and then raze this forge to the ground. They can burn with their secrets.", 300844)
end

RegisterCreatureEvent(235713, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if ok and qid == 86538 then
        pcall(function() PrintInfo("[ds3837] 86538 accepted by " .. player:GetName()) end)
        AcceptScene(player)
    end
end)

RegisterCreatureEvent(235717, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if ok and qid == 86537 then
        pcall(function() PrintInfo("[ds3837] 86537 accepted by " .. player:GetName()) end)
        AcceptScene(player)
    end
end)

-- Konzoly: Echo-Missive dialogy (temp-summon, Wiki poradie)
local CONSOLES = {
    [521829] = { x = 231.25, y = 1314.86,
        { 242620, "This is not what I was promised! We toil endlessly while your monsters monitor our every move!", 300945 },
        { 242619, "Such ingratitude is unbecoming of you Salhadaar. I have provided you with a rare gift: an opportunity to prove your right to rule.", nil } },
    [523393] = { x = 127.03, y = 1393.73,
        { 242620, "Do you think I cannot see the trap you have set? The peril that now faces my people should our operation at Mid'ar fail?", 300946 },
        { 242619, "Oh, there's no 'trap' to be sprung here. You need merely succeed at your task, and all will be well. For both you... and your people.", nil } },
    [523395] = { x = 278.72, y = 1386.07,
        { 242620, "The Shadowguard risk everything to strengthen the Devouring Host. Should Windrunner discover what we are doing--", 300827 },
        { 242619, "Then it would be in your best interest to eliminate her, wouldn't it? You've let her scurry around for far too long as it is.", nil } },
}
local function ConsoleUse(go, player)
    local okE, e = pcall(function() return go:GetEntry() end)
    if not okE then return true end
    local cfg = CONSOLES[e]
    if not cfg then return true end
    local okQ, st = pcall(function() return player:GetQuestStatus(86537) end)
    if not (okQ and st == STATUS_INCOMPLETE) then return true end
    if OnCooldown(player, "console" .. e, 600) then return true end
    pcall(function() PrintInfo("[ds3837] console use entry=" .. e .. " player=" .. player:GetName()) end)
    local d = 2000
    for i = 1, #cfg do
        local line = cfg[i]
        SummonSay(player, line[1], cfg.x + 3, cfg.y, -55.0, line[2], line[3], d)
        d = d + 8000
    end
    return true
end

for _e, _c in pairs(CONSOLES) do
    local _ee = _e
    pcall(RegisterGameObjectGossipEvent, _ee, 1, function(_, player, go) return ConsoleUse(go, player) end)
end

-- Final konzola: Keeper + Lothraxion (Wiki)
pcall(RegisterGameObjectGossipEvent, 90009381, 1, function(_, player, _)
    local okQ, st = pcall(function() return player:GetQuestStatus(86537) end)
    if not (okQ and st == STATUS_INCOMPLETE) then return true end
    if OnCooldown(player, "final-console", 600) then return true end
    pcall(function() PrintInfo("[ds3837] final console player=" .. player:GetName()) end)
    SayAt(player, 235388, 80, 2000, "More power. All will become Void.", 322210)
    SummonSay(player, 235713, 367.0, 1282.0, -55.0, "Burn in the Light, wretch!", 300929, 8000)
    return true
end)

-- Keeper kill: post-completion says (Wiki)
RegisterPlayerEvent(7, function(_, killer, victim)
    local okV, v = pcall(function() return victim:GetEntry() end)
    if not okV or v ~= 235388 then return end
    local okS, st = pcall(function() return killer:GetQuestStatus(86537) end)
    if not (okS and st == STATUS_INCOMPLETE) then return end
    if OnCooldown(killer, "keeper-dead", 600) then return end
    pcall(function() PrintInfo("[ds3837] keeper dead player=" .. killer:GetName()) end)
    SayAt(killer, 242620, 60, 3000, "Windrunner will not prevent me from turning the naaru to the Void. I will claim the power I was promised!", 300819)
    SayAt(killer, 235713, 100, 9000, "They've taken a naaru prisoner? We cannot allow these monsters to possess a being of pure Light!", 300877)
end)

-- Mob combat says (Wiki, pri kille s sanci)
local MOB_SAYS = {
    [238588] = { "So far from home...", nil },
    [239763] = { "So far from home...", nil },
    [236093] = { "This world is ours!", nil },
}
RegisterPlayerEvent(7, function(_, killer, victim)
    local okV, v = pcall(function() return victim:GetEntry() end)
    if not okV or not MOB_SAYS[v] then return end
    if math.random() > 0.35 then return end
    local okS, st = pcall(function() return killer:GetQuestStatus(86538) end)
    if not (okS and st == STATUS_INCOMPLETE) then return end
    if OnCooldown(killer, "mob-say", 60) then return end
    local line = MOB_SAYS[v]
    SayAt(killer, v, 60, 1500, line[1], line[2])
end)

-- Gossip klik log (Alleria/Lothraxion stromy su DB, bez kreditov)
RegisterCreatureGossipEvent(235717, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds3837] alleria player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
end)

RegisterCreatureGossipEvent(235713, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds3837] lothraxion player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
end)

print("[fuel_network] loaded")
