-- =====================================================================
-- Quest 92895 Hagar's Invitation: accept scena + rootway + arrival.
-- Accept (Orweyna-253640 dava LEN 92895): Orweyna say + Lor'themar-235787 say.
-- Rootway-241792 hello -> KC 256649 (optional).
-- Orweyna-253654 hello (Den, len pri aktivnom 92895) -> KC 254857 + Orweyna say + Welcomer say.
-- Texty doslovne z Warcraft Wiki Hagar's_Invitation. Cooldown 60 s.
-- VO: vo_1207 kity (fid 7708057-7708067, SoundKitEntry 12.1.5) priradene 2026-10-18.
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
                return
            end
        end
    end, delayMs, 1)
end

local function HasActiveQuest(player, qid)
    local ok, st = pcall(function() return player:GetQuestStatus(qid) end)
    return ok and st == 3
end

-- Accept scena: Orweyna-253640 dava len 92895, kontrola ID netreba.
RegisterCreatureEvent(253640, 31, function(_, player, creature, quest)
    if OnCooldown(player, "hagar-accept") then return end
    SayAt(player, 253640, 60, 1000, "Elder Hagar has called on the elven leaders to join this gathering in Harandar. It is of great importance.", 337042)
    SayAt(player, 235787, 60, 7000, "It would be an honor. We will join you as soon as we can.", 337043)
end)

-- Rootway (optional).
RegisterCreatureGossipEvent(241792, 1, function(_, player, creature)
    pcall(function() player:KilledMonsterCredit(256649) end)
end)

-- Arrival v Dene.
RegisterCreatureGossipEvent(253654, 1, function(_, player, creature)
    if not HasActiveQuest(player, 92895) then return end
    pcall(function() player:KilledMonsterCredit(254857) end)
    if OnCooldown(player, "hagar-arrival") then return end
    SayAt(player, 257917, 60, 1000, "Good, you are here. The elders and others await you below.", 337044)
    SayAt(player, 253654, 60, 7000, "All manner of elves and trolls are here. We await only the blood elves and the Amani.", 337045)
end)

print("[hagar92895] loaded")
