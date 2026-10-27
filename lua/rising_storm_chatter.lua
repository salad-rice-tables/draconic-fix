-- =====================================================================
-- Rising Storm (92061): krizove Wiki repliky po report buttone.
-- Turalyonov report (menu 40410/opt 0) -> Lothraxion 235477 odpovie s oneskorenim.
-- Bellamyho report (menu 40411/opt 0) -> Koruth 250590 odpovie s oneskorenim.
-- Len say + KREDIT (KilledMonsterCredit, primarna cesta - SmartAI riadky ostavaju ako zaloha).
-- Texty doslovne z Warcraft Wiki Rising_Storm.
-- =====================================================================
if IS_WORLD_STATE then return end

-- Anti-spam guard: a cross line at most once per 180 s per player (WNPC under key).
local SaidAt = {}
local COOLDOWN = 180

local function SayDelayed(player, key, entry, delayMs, text, kit)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < COOLDOWN then return end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then pcall(function() PrintInfo("[abyss] say MISSED (player gone) entry=" .. entry) end) return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(40) end)
        if not ok or not list then pcall(function() PrintInfo("[abyss] say MISSED (no range list) entry=" .. entry) end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[abyss] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[abyss] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureGossipEvent(250580, 2, function(_, player, creature, sender, intid)
    pcall(function() PrintInfo(string.format("[abyss] player=%s npc=250580 menu=%s intid=%s q92061=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(92061)))) end)
    if intid == 0 then
        pcall(function() player:KilledMonsterCredit(250580) end)
        if creature then
            pcall(function() creature:SendUnitSay("The situation is dire! We will accept any help. Even from Magister Umbric.", 0) end)
            pcall(function() creature:PlayDistanceSound(308329, player) end)
        end
        SayDelayed(player, "lothraxion", 235477, 8000, "No! Those Void addicts are not our salvation. The Light is the only way to stop Xal'atath's evil.", 308330)
    end
end)

RegisterCreatureGossipEvent(9100622, 2, function(_, player, creature, sender, intid)
    pcall(function() PrintInfo(string.format("[abyss] player=%s npc=9100622 menu=%s intid=%s q92061=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(92061)))) end)
    if intid == 0 then
        pcall(function() player:KilledMonsterCredit(250587) end)
        if creature then
            pcall(function() creature:SendUnitSay("Lor'themar promised his Magisters would provide a solution. It's now or never!", 0) end)
            pcall(function() creature:PlayDistanceSound(308333, player) end)  -- bt 296436 kit2 vo_120_amias_bellamy_18
        end
        SayDelayed(player, "koruth", 250590, 7000, "If we could just take the fight to Xal'atath, we'd give her such a drumming she'd hop back inside that knife.", 308332)
    end
end)

print("[rising_storm_chatter] loaded")

-- =====================================================================
-- Citizens ambience (Wiki: Silvermoon Citizens pri Shining Span obcas krical,
-- kym je 92061 rozpracovany). Ziadny civilian spawn vo faze 45749 nie je,
-- preto berieme phase-0 civilistov v dosahu hraca s aktivnym questom.
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
