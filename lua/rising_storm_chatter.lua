-- =====================================================================
-- Rising Storm (92061): krizove Wiki repliky po report buttone.
-- Turalyonov report (menu 40410/opt 0) -> Lothraxion 235477 odpovie s oneskorenim.
-- Bellamyho report (menu 40411/opt 0) -> Koruth 250590 odpovie s oneskorenim.
-- Len say + KREDIT (KilledMonsterCredit, primarna cesta - SmartAI riadky ostavaju ako zaloha).
-- Texty doslovne z Warcraft Wiki Rising_Storm.
-- =====================================================================
if IS_WORLD_STATE then return end

-- Stráž proti spamu: krížová replika max raz za 180 s na hráča (WNPC under key).
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

RegisterCreatureGossipEvent(250580, 2, function(_, player, creature, _, intid)
    if intid == 0 then
        pcall(function() player:KilledMonsterCredit(250580) end)
        if creature then pcall(function() creature:SendUnitSay("The situation is dire! We will accept any help. Even from Magister Umbric.", 0) end) end
        SayDelayed(player, "lothraxion", 235477, 3000, "No! Those Void addicts are not our salvation. The Light is the only way to stop Xal'atath's evil.")
    end
end)

RegisterCreatureGossipEvent(9100622, 2, function(_, player, creature, _, intid)
    if intid == 0 then
        pcall(function() player:KilledMonsterCredit(250587) end)
        if creature then pcall(function() creature:SendUnitSay("Lor'themar promised his Magisters would provide a solution. It's now or never!", 0) end) end
        SayDelayed(player, "koruth", 250590, 3000, "If we could just take the fight to Xal'atath, we'd give her such a drumming she'd hop back inside that knife.")
    end
end)

print("[rising_storm_chatter] loaded")
