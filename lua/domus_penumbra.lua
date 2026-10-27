-- =====================================================================
-- Quest 86510 Domus Penumbra v1: accept scena + Anomander + bones-Umbric says.
-- Malloril talk-kredit SAI (DB). Bones GO-use nativne. Texty Wiki verbatim + dabing.
-- DB: Custom/sql/20261016_abyss6510.sql (+undo).
-- Follow-up: meat-lure, InnConv, elf-trigger, S02, vendor inventar.
-- =====================================================================
if IS_WORLD_STATE then return end

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86510] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86510] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86510] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(235697, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86510) then return end
    pcall(function() PrintInfo("[ds86510] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235697, 80, 2000, "Make yourself at home. Then we can discuss weakening the storm.", 301152)
    SayAt(player, 235473, 80, 8000, "Keep your weapons close. Trust nothing the Void offers.", 301063)
end)

RegisterCreatureGossipEvent(248328, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86510] anomander player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
    if sender ~= 42172 then return end
    SayAt(player, 248328, 60, 2000, "Being here is an opportunity. Our understanding of the Void will grow by leaps and bounds if we learn from the domanaar. Assist me when you are able.", nil)
end)

local function BonesUse(_, player, _)
    local okQ, st = pcall(function() return player:GetQuestStatus(86510) end)
    if not (okQ and st == STATUS_INCOMPLETE) then return true end
    pcall(function() PrintInfo("[ds86510] bones use player=" .. player:GetName()) end)
    SayAt(player, 235698, 80, 2000, "This is the most stable place for a portal, but Decimus's beast is in the way.", 301082)
    SayAt(player, 235698, 80, 9000, "The Void feels... honed here. Perhaps the work of Decimus?", 301050)
    return true
end
pcall(RegisterGameObjectGossipEvent, 90009383, 1, BonesUse)

print("[domus_penumbra] loaded")
