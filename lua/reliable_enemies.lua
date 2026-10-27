-- =====================================================================
-- Quest 86536 Reliable Enemies v1: interrogacia + meet + post-movie says.
-- Decimus 235607 (menu 38620): 2 buttony -> simulovana interrogacia (faction 35,
-- damage bez sniffu nespravime; Wiki poradie says) + kredit 242210 na konci.
-- Meet 9100609: proximity (710,1070). Talk: native (SAI 235392->260236).
-- Decimus 235392 movie button: Alleria + Decimus post-short says (bez videa).
-- VO kits 300751-300803 + 300853. Texty Wiki Reliable_Enemies verbatim.
-- DB: Custom/sql/20261016_abyss86536.sql (+undo).
-- Follow-up: skutocny damage + Supremacy video.
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
        if not ok or not list then pcall(function() PrintInfo("[ds86536] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86536] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86536] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

-- Interrogacia: Wiki poradie (simulacia, bez damage-sniffu by neslo)
RegisterCreatureGossipEvent(235607, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86536] decimus player=%s menu=%s intid=%s q86536=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86536)))) end)
    if sender ~= 38620 then return end
    if intid ~= 1 and intid ~= 2 then return end
    if OnCooldown(player, "interrogate", 600) then return end
    SayAt(player, 235607, 60, 2000, "My. Let's have it, then.", 300803)
    SayAt(player, 235607, 60, 12000, "Oh. Now that is something.", 300761)
    SayAt(player, 235607, 60, 20000, "Ow. Ha. Hahaha.", 300762)
    SayAt(player, 235607, 60, 28000, "Mercy won't get you far out here. But I'll consider it offered in good faith.", 300781)
    SayAt(player, 235607, 60, 36000, "No more, no more. How can I deny you after a display like that?", 300763)
    SayAt(player, 235607, 60, 44000, "On the fringes of this world, you will find Nexus-Points. They keep the storm churning.", 300756)
    SayAt(player, 235606, 80, 50000, "Then we will destroy them. And the ethereals will provide our ordnance.", 300757)
    player:RegisterEvent(function(_, _, _, p)
        if p and p:IsInWorld() then pcall(function() p:KilledMonsterCredit(242210) end) end
    end, 52000, 1)
end)

-- Meet: proximity overlook (custom marker, iny trigger nie je)
if MAP_Timer then
    MAP_Timer("reliable.meet", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86536) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okX, x = pcall(function() return p:GetX() end)
                    local okY, y = pcall(function() return p:GetY() end)
                    if okX and okY then
                        local d = math.sqrt((x - 710) * (x - 710) + (y - 1070) * (y - 1070))
                        if d < 45 and not OnCooldown(p, "meet", 600) then
                            pcall(function() p:KilledMonsterCredit(9100609) end)
                            pcall(function() PrintInfo("[ds86536] meet credit player=" .. p:GetName()) end)
                        end
                    end
                end
            end
        end
    end, 10000)
end

-- Post-short: Alleria + Decimus (bez videa, follow-up)
RegisterCreatureGossipEvent(235392, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86536] decimus2 player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
    if sender ~= 38393 then return end
    if OnCooldown(player, "postshort", 600) then return end
    SayAt(player, 235389, 80, 2000, "Xal'atath... was once mortal?", 300826)  -- bt 297519 vo_120_alleria_windrunner_24
    SayAt(player, 235392, 80, 8000, "That's what she told Salhadaar. Perhaps it was even the truth.", 300853)
end)

print("[reliable_enemies] loaded")
