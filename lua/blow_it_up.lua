-- =====================================================================
-- Quest 86540 Third, Blow It Up v1: Progress (DB) + accept scena + GO counter +
-- meet-kredit (marker 240494 nema ziadny trigger!). GO-use 504639 nativne;
-- Eluna pocita pouzitia (5x) a pri otvoreni 235649 da 240494 (meet = open pattern).
-- Accept scena (Wiki Notes, Mid'Ar 45764): Lothraxion (dabing) + Alleria.
-- DB: Custom/sql/20261016_abyss4041.sql (+undo).
-- Follow-up: Xal'atath/Salhadaar/T'era says (speakri), meet-up says, odmeny.
-- =====================================================================
if IS_WORLD_STATE then return end

local Uses = {}

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86540] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86540] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86540] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(235648, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86540) then return end
    pcall(function() PrintInfo("[ds86540] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235648, 80, 2000, "Arator, keep an eye on your mother and her smug hound. I don't want it out of the Light's presence.", 300857)
    SayAt(player, 235660, 80, 9000, "Direct your zeal at our foes, Lothraxion. And remember that I'm not one of them.", 300954)  -- bt 282996 vo_120_alleria_windrunner_38
end)

local function CellUse(_, player, _)
    local okQ, st = pcall(function() return player:GetQuestStatus(86540) end)
    if not (okQ and st == STATUS_INCOMPLETE) then return true end
    local key = player:GetName()
    Uses[key] = (Uses[key] or 0) + 1
    pcall(function() PrintInfo("[ds86540] manacell use n=" .. Uses[key] .. " player=" .. key) end)
    return true
end
pcall(RegisterGameObjectGossipEvent, 504639, 1, CellUse)

RegisterCreatureGossipEvent(235649, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86540] ender player=%s menu=%s intid=%s q86540=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86540)))) end)
    local key = player:GetName()
    if (Uses[key] or 0) >= 5 then
        pcall(function() player:KilledMonsterCredit(240494) end)
    end
end)

RegisterPlayerEvent(4, function(_, player) Uses[player:GetName()] = nil end)

print("[blow_it_up] loaded")
