-- =====================================================================
-- Quest 86544 Post-Mortem v1: accept scena + Listen dialog + 4 gossip kredity +
-- scout assist + return/yell. Texty Wiki Post-Mortem verbatim.
-- Hieron/Maella/Decimus/Lothraxion: DB menu + button (kredit Eluna + SAI zaloha).
-- Alleria Listen: DB button + 8-say dialog. Scouti: proximity (3 says poradie).
-- Turn-in yell: poll complete-stavu. DB: Custom/sql/20261016_abyss4455.sql (+undo).
-- Follow-up: Darkglen subdue verzia, presny poradie-displaye.
-- =====================================================================
if IS_WORLD_STATE then return end

local STATUS_COMPLETE = 1

local SaidAt = {}

local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or 300) then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text, kit)
    text = text:gsub("<name>", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86544] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86544] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86544] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function Credit(menuId, creditEntry, key)
    return function(_, player, _, sender, intid)
        pcall(function() PrintInfo(string.format("[ds86544] player=%s npc=%d menu=%s intid=%s", player:GetName(), creditEntry, tostring(sender), tostring(intid))) end)
        if sender ~= menuId then return end
        pcall(function() player:KilledMonsterCredit(creditEntry) end)
        return key
    end
end

-- Hieron: report + 2 says
RegisterCreatureGossipEvent(239724, 2, function(_, player, _, sender, intid)
    if Credit(38545, 240559)(_, player, _, sender, intid) then
        if OnCooldown(player, "hieron", 600) then return end
        SayAt(player, 239724, 60, 2000, "Stay with us, Astre. Feel my hand in yours.", 305246)
        SayAt(player, 239724, 60, 9000, "I'm sorry, but I need a little longer with them. Check with Maella. Her report is more thorough than mine anyway.", 322016)
    end
end)

-- Maella: report + 2 says (Wiki literaly, broadcast nema)
RegisterCreatureGossipEvent(240538, 2, function(_, player, _, sender, intid)
    if Credit(38544, 236630)(_, player, _, sender, intid) then
        if OnCooldown(player, "maella", 600) then return end
        SayAt(player, 240538, 60, 2000, "Here. Hieron is too modest. You can tell him I said that.", 300811)
        SayAt(player, 240538, 60, 9000, "The whispers grow evermore enticing, but we stand strong. Our mission demands it.", 300966)
    end
end)

-- Decimus: check + 2 says (dabing 300905/300961)
RegisterCreatureGossipEvent(235653, 2, function(_, player, _, sender, intid)
    if Credit(38552, 240572)(_, player, _, sender, intid) then
        if OnCooldown(player, "decimus", 600) then return end
        SayAt(player, 235653, 60, 2000, "You and Lady Windrunner are simply wonderful. I've not encountered such capable mortals in my many travels.", 300905)
        SayAt(player, 235653, 60, 9000, "I'm eager to see what violence you may next wreak.", 300961)
    end
end)

-- Lothraxion: check + 2 says (dabing 300863/300864)
RegisterCreatureGossipEvent(235725, 2, function(_, player, _, sender, intid)
    if Credit(38551, 240571)(_, player, _, sender, intid) then
        if OnCooldown(player, "lothraxion", 600) then return end
        SayAt(player, 235725, 60, 2000, "How could this have gone so wrong? We're no closer to bringing the forces of the Light to bear on this world.", 300863)
        SayAt(player, 235725, 60, 9000, "You must feel it too. A waiting betrayal. I know what must be done.", 300864)
    end
end)

-- Alleria Listen: kredit + 8-say dialog (Wiki Notes)
RegisterCreatureGossipEvent(235664, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86544] alleria player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
    if sender ~= 912046918 then return end
    pcall(function() player:KilledMonsterCredit(235664) end)
    if OnCooldown(player, "listen", 600) then return end
    local A, R = 235664, 235724
    SayAt(player, R, 80, 2000, "The dark naaru within you, mother... I never understood just how exhausting it must be to maintain control over it.", 300925)
    SayAt(player, R, 80, 9000, "Or how lonely it's been for you, protecting us from it.", 300837)
    SayAt(player, A, 80, 16000, "For you, my son, I could endure anything. I know at times, I have been somewhat... cold.", 300936)
    SayAt(player, R, 80, 23000, "Stop. Don't apologize for--", 300899)
    SayAt(player, A, 80, 30000, "I need you to hear me, Arator. Understand, it's not the naaru within me that creates the distance between us.", 300935)
    SayAt(player, R, 80, 37000, "It's the fight. I know.", 300906)
    SayAt(player, R, 80, 44000, "But you need to understand. You can't protect me from what's out there. And you can't scare me away, either. My fight is by your side.", 300941)
    SayAt(player, R, 80, 51000, "What comes, mother, we will face together.", 300900)
end)

-- Scouti: proximity, 3 says poradie (counter na hraca)
local SCOUT_SAYS = {
    { "You're right. I should sit with the others.", 300828 },
    { "W-Who's there? Stay away!", 300871 },
    { "These whispers suffocate my senses.", 300813 },
}
if MAP_Timer then
    MAP_Timer("postmortem.scouts", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86544) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(14) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            if okE and e == 240546 then
                                local key = p:GetName() .. ":scout"
                                local n = (SaidAt[key] or 0)
                                if n < 3 and not OnCooldown(p, "scouttouch", 5) then
                                    n = n + 1
                                    SaidAt[key] = n
                                    pcall(function() p:KilledMonsterCredit(240546) end)
                                    SayAt(p, 240546, 30, 1000, SCOUT_SAYS[n][1], SCOUT_SAYS[n][2])
                                    pcall(function() PrintInfo("[ds86544] scout assist n=" .. n .. " player=" .. p:GetName()) end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end, 5000)
    RegisterPlayerEvent(4, function(_, player) SaidAt[player:GetName() .. ":scout"] = nil end)
end

-- Accept scena (Wiki Notes): Alleria + Arator na Locuse
RegisterCreatureEvent(235724, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86544) then return end
    pcall(function() PrintInfo("[ds86544] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235664, 80, 2000, "Arator, you must ensure that no harm comes to Decimus. They have the answers we need. Trust me.", 300892)
    SayAt(player, 235724, 80, 8000, "I do. I will.", 300878)
end)

-- Turn-in yell: poll complete-stavu (Wiki: Upon completion)
if MAP_Timer then
    MAP_Timer("postmortem.yell", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86544) end)
                if okS and st == STATUS_COMPLETE and not OnCooldown(p, "yell", 3600) then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(100) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            if okE and e == 235725 then
                                pcall(function() c:SendUnitYell("You've been subverting us all along! Be eradicated, Decimus!", 0) end)
                                pcall(function() c:PlayDistanceSound(300865, p) end)
                                pcall(function() PrintInfo("[ds86544] completion yell player=" .. p:GetName()) end)
                                return
                            end
                        end
                    end
                end
            end
        end
    end, 15000)
end

print("[post_mortem] loaded")
