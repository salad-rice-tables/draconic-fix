-- =====================================================================
-- Rising Storm (92061): cross Wiki replies after the report button.
-- Turalyon report (menu 40410/opt 0) -> Lothraxion 235477 replies with a delay.
-- Bellamy report (menu 40411/opt 0) -> Koruth 250590 replies with a delay.
-- Says + CREDIT (KilledMonsterCredit, primary path - SmartAI rows stay as backup).
-- Texts verbatim from Warcraft Wiki Rising_Storm.
-- =====================================================================
if IS_WORLD_STATE then return end

-- Anti-spam guard: cross reply max once per 180 s per player (keyed by NPC).
local SaidAt = {}
local COOLDOWN = 180

local function SayDelayed(player, key, entry, delayMs, text)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < COOLDOWN then return end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(40) end)
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

RegisterCreatureGossipEvent(250580, 2, function(_, player, creature, sender, intid)
    pcall(function() PrintInfo(string.format("[abyss] player=%s npc=250580 menu=%s intid=%s q92061=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(92061)))) end)
    if intid == 0 then
        pcall(function() player:KilledMonsterCredit(250580) end)
        if creature then pcall(function() creature:SendUnitSay("The situation is dire! We will accept any help. Even from Magister Umbric.", 0) end) end
        SayDelayed(player, "lothraxion", 235477, 3000, "No! Those Void addicts are not our salvation. The Light is the only way to stop Xal'atath's evil.")
    end
end)

RegisterCreatureGossipEvent(9100622, 2, function(_, player, creature, sender, intid)
    pcall(function() PrintInfo(string.format("[abyss] player=%s npc=9100622 menu=%s intid=%s q92061=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(92061)))) end)
    if intid == 0 then
        pcall(function() player:KilledMonsterCredit(250587) end)
        if creature then pcall(function() creature:SendUnitSay("Lor'themar promised his Magisters would provide a solution. It's now or never!", 0) end) end
        SayDelayed(player, "koruth", 250590, 3000, "If we could just take the fight to Xal'atath, we'd give her such a drumming she'd hop back inside that knife.")
    end
end)

print("[rising_storm_chatter] loaded")

-- =====================================================================
-- Citizens ambience (Wiki: Silvermoon Citizens near Shining Span occasionally shout
-- while 92061 is in progress). No civilian spawn exists in phase 45749,
-- so we use phase-0 civilians in range of a player with an active quest.
-- =====================================================================
local YELLS = {
    "The Sunwell saved us! But for how long?",
    "The Void is coming! Can the paladins hold back that storm?",
    "We should evacuate. But where to?",
}
local CIVILIANS = {[250980] = true, [252569] = true, [252844] = true}
local YellAt = {}

if MAP_Timer then
    MAP_Timer("rising_storm.yells", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 0 then
                local okS, st = pcall(function() return p:GetQuestStatus(92061) end)
                if okS and st == STATUS_INCOMPLETE then
                    local nm = p:GetName()
                    if (YellAt[nm] or 0) + 150 < os.time() and math.random() < 0.35 then
                        local okL, list = pcall(function() return p:GetCreaturesInRange(90) end)
                        if okL and list then
                            local cands = {}
                            for _, c in ipairs(list) do
                                local okE, e = pcall(function() return c:GetEntry() end)
                                if okE and CIVILIANS[e] then cands[#cands + 1] = c end
                            end
                            if #cands > 0 then
                                YellAt[nm] = os.time()
                                pcall(function() cands[math.random(#cands)]:SendUnitYell(YELLS[math.random(#YELLS)], 0) end)
                            end
                        end
                    end
                end
            end
        end
    end, 20000)
    RegisterPlayerEvent(4, function(_, player) YellAt[player:GetName()] = nil end)
end
