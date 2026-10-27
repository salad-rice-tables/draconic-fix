-- =====================================================================
-- Quest 86509 Friend or Fiend v1: accept scena + travel + Listen dialog.
-- Accept (Decimus 240691): Lothraxion + Decimus says (dabing 301008/301070).
-- Travel (714,-424): kredit 241126 + Decimus say (dabing 301153).
-- Listen (Lothraxion 235473, menu 40206): kredit 243760 + 9-say dialog (Wiki).
-- Turn-in Decimus 235697 nativny (45775 OK).
-- DB: Custom/sql/20261016_abyss6509.sql (+undo).
-- Follow-up: party odchod pohyb.
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
        if not ok or not list then pcall(function() PrintInfo("[ds86509] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86509] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86509] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(240691, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86509) then return end
    pcall(function() PrintInfo("[ds86509] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235473, 80, 2000, "You'd follow this creature to its foul den?", 301008)
    SayAt(player, 240691, 80, 8000, "If you prefer to keep throwing naaru at Nexus-Points, don't let me stop you.", 301070)
end)

if MAP_Timer then
    MAP_Timer("friendfiend.travel", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86509) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okX, x = pcall(function() return p:GetX() end)
                    local okY, y = pcall(function() return p:GetY() end)
                    if okX and okY then
                        local d = math.sqrt((x - 714) * (x - 714) + (y + 424) * (y + 424))
                        if d < 50 and not OnCooldown(p, "travel", 600) then
                            pcall(function() p:KilledMonsterCredit(241126) end)
                            SayAt(p, 235697, 100, 2000, "Ah, the rest of our party arrives. Were there time, I'd have you for dinner.", 301153)
                            pcall(function() PrintInfo("[ds86509] travel credit player=" .. p:GetName()) end)
                        end
                    end
                end
            end
        end
    end, 10000)
end

RegisterCreatureGossipEvent(235473, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86509] lothraxion player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
    if sender ~= 40206 then return end
    pcall(function() player:KilledMonsterCredit(243760) end)
    if OnCooldown(player, "listen", 600) then return end
    local L, A = 235473, 235726
    SayAt(player, L, 80, 2000, "A naaru! Dead! Now we're to trust this monstrosity?", 301167)
    SayAt(player, A, 80, 9000, "No, but we need them. They've had every opportunity to betray us.", 301168)
    SayAt(player, L, 80, 16000, "And they will.", 301169)
    SayAt(player, L, 80, 23000, "Have you learned nothing from K'aresh? What did your mentor's trust in the Void bring him?", 301170)
    SayAt(player, A, 80, 30000, "Careful. The Void never offers fair choices. Locus-Walker understood that better than anyone.", 301171)
    SayAt(player, A, 80, 37000, "After his demise, I asked myself again and again what I could have done to prevent it.", 301172)
    SayAt(player, A, 80, 44000, "But then I came to realize what Locus-Walker knew from the start. It didn't matter that Xal'atath was always going to turn on us.", 301173)
    SayAt(player, A, 80, 51000, "If the only way to stop one monster is to work with another, what choice is there?", 300851)
    SayAt(player, L, 80, 58000, "We've fought together for a thousand years. Do you not trust me?", 300810)
    SayAt(player, A, 80, 65000, "I do, Lothraxion. When Decimus does betray us, I trust you to put them down.", 300852)
end)

print("[friend_or_fiend] loaded")
