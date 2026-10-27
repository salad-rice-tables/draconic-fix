-- =====================================================================
-- Quest 86549 No Fear of the Dark v1: foci-linking + portal + Listen scena.
-- Wiki No_Fear_of_the_Dark verbatim. Foci 243071 (guidy ...624/25/26) = proximity
-- kredity 243066/67/68 v lubovolnom poradi ("pick one"), vsetky 3 -> 239477 +
-- Umbric "portal opened". Portal GO 504395 -> kredity 239600/239643 + Ingress says.
-- Listen (Lor'themar 235481, menu 40202) -> kredit 260106 + Rommath scena (8 replik).
-- Accept scena: Umbric -> Lor'themar x2 -> Arator -> Lothraxion (Wiki Notes).
-- DB: Custom/sql/20261016_abyss86549.sql (+undo).
-- Follow-up: beam vizualy, Overcome spell, dungeon queue 238157/1116.
-- =====================================================================
if IS_WORLD_STATE then return end

local FOCI = {
    [3000213624] = 243066,
    [3000213625] = 243067,
    [3000213626] = 243068,
}
local Touched = {}
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
        if not ok or not list then pcall(function() PrintInfo("[ds86549] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86549] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86549] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

-- Foci linking: dotyk v lubovolnom poradi, kazdy fokus svoj kredit; vsetky 3 -> 239477
if MAP_Timer then
    MAP_Timer("nofear.foci", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 0 then
                local okS, st = pcall(function() return p:GetQuestStatus(86549) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(12) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okG, g = pcall(function() return c:GetGUIDLow() end)
                            local credit = okG and FOCI[g]
                            if credit then
                                local key = p:GetName()
                                Touched[key] = Touched[key] or {}
                                if not Touched[key][credit] then
                                    Touched[key][credit] = true
                                    pcall(function() p:KilledMonsterCredit(credit) end)
                                    pcall(function() PrintInfo("[ds86549] focus touch credit=" .. credit .. " player=" .. key) end)
                                    local n = 0
                                    for _ in pairs(Touched[key]) do n = n + 1 end
                                    if n >= 3 then
                                        pcall(function() p:KilledMonsterCredit(239477) end)
                                        if not OnCooldown(p, "portal-open") then
                                            SayAt(p, 235405, 80, 2000, "The portal is opened. Gather your courage... only darkness awaits us on the other side.", 300644)
                                            SayAt(p, 235481, 80, 8000, "The fate of Silvermoon, of all of Azeroth, may rest on the outcome of this mission. Anu belore dela'na.", 300645)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end, 5000)
    RegisterPlayerEvent(4, function(_, player) Touched[player:GetName()] = nil end)
end

-- Portal: len po vsetkych 3 foci -> kredity + Ingress says (Wiki Notes verbatim)
local function PortalUse(_, player, go)
    local nm = player:GetName()
    pcall(function() PrintInfo("[ds86549] portal use player=" .. nm .. " q86549=" .. tostring(player:GetQuestStatus(86549))) end)
    local t = Touched[nm] or {}
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    if n < 3 then
        player:SendBroadcastMessage("The portal is not yet calibrated. Connect all three Shadow Foci first.")
        return true
    end
    pcall(function() player:KilledMonsterCredit(239600) end)
    pcall(function() player:KilledMonsterCredit(239643) end)
    if OnCooldown(player, "ingress") then return true end
    SayAt(player, 235405, 80, 2000, "So much--so much Void!", 300646)
    SayAt(player, 235405, 80, 9000, "Resist it, " .. nm .. "! You control the Shadow, it does not control you!", 308417)
    SayAt(player, 235479, 80, 15000, "Eyes forward!", 300647)  -- bt: arator_103
    SayAt(player, 239421, 80, 20000, "This-- this power! It's like nothing I've ever-- Ha! Ahahaha!!", 300649)  -- vo_120_voidlight_everdawn_01
    SayAt(player, 235477, 80, 26000, "Control yourselves!", 300650)  -- vo_120_lothraxion_02
    return true
end
pcall(RegisterGameObjectGossipEvent, 504395, 1, PortalUse)

-- Rommath "steps in": docasna kopia na mieste (village_life vzor) - jeho DB spawn je
-- faza 45747 (Harandar-gated), pocas 86549 nemusi byt vidiet. Kopie zdedi hracovu fazu.
local function SummonRommath(player)
    local ok, c = pcall(PerformIngameSpawn, 1, 240532, player:GetMapId(), 0, 8540.0, -4322.0, 21.7, 0, false, 120000)
    if ok and c then
        pcall(function() PrintInfo("[ds86549] rommath temp-summon OK") end)
        return c
    end
    pcall(function() PrintInfo("[ds86549] rommath temp-summon FAILED") end)
    return nil
end

local function RomSay(rom, player, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if rom and rom:IsInWorld() then
            local okS, err = pcall(function() rom:SendUnitSay(text, 0) end)
            if kit then pcall(function() rom:PlayDistanceSound(kit, p) end) end
            pcall(function() PrintInfo("[ds86549] rommath say " .. (okS and "SENT" or "FAILED:" .. tostring(err))) end)
        else
            pcall(function() PrintInfo("[ds86549] rommath say MISSED (despawned)") end)
        end
    end, delayMs, 1)
end

-- Listen: kredit + Rommath scena (Wiki Notes, temp-summon + stationarni speakri)
RegisterCreatureGossipEvent(235481, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds86549] player=%s menu=%s intid=%s q86549=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86549)))) end)
    if sender ~= 40202 then return end
    pcall(function() player:KilledMonsterCredit(260106) end)
    if OnCooldown(player, "rommath-scene") then return end
    local rom = SummonRommath(player)
    if rom then
        RomSay(rom, player, 2000, "How DARE you step into Magisters' Terrace, Umbric! You nearly destroyed us all, just like I knew you would!", 300631)
        SayAt(player, 235405, 80, 9000, "I have confidence in the strength of myself and my allies. Something you noticeably lack, Rommath.", 300632)
        RomSay(rom, player, 16000, "Confidence? Arrogance! The same arrogance that transformed those poor souls who follow you into void monstrosities!", 300633)
        SayAt(player, 235405, 80, 23000, "We are not monsters. We are in control. We are ren'dorei.", 300634)
        SayAt(player, 235481, 80, 30000, "Enough. It was a risk to let them near the Sunwell, yes. But we will not win this war without taking risks. The ren'dorei have not wavered yet.", 300635)
        RomSay(rom, player, 37000, "Yet. We shall see if this \"mission\" succeeds.", 300637)
        RomSay(rom, player, 43000, "You've always been reckless, Umbric. You leave calamity and ruin in your wake.", 300638)
        RomSay(rom, player, 49000, "At least try to make it back alive.", 300639)
    else
        SayAt(player, 240532, 80, 2000, "How DARE you step into Magisters' Terrace, Umbric! You nearly destroyed us all, just like I knew you would!", 300631)
        SayAt(player, 235405, 80, 9000, "I have confidence in the strength of myself and my allies. Something you noticeably lack, Rommath.", 300632)
        SayAt(player, 240532, 80, 16000, "Confidence? Arrogance! The same arrogance that transformed those poor souls who follow you into void monstrosities!", nil)
        SayAt(player, 235405, 80, 23000, "We are not monsters. We are in control. We are ren'dorei.", 300634)
        SayAt(player, 235481, 80, 30000, "Enough. It was a risk to let them near the Sunwell, yes. But we will not win this war without taking risks. The ren'dorei have not wavered yet.", 300635)
        SayAt(player, 240532, 80, 37000, "Yet. We shall see if this \"mission\" succeeds.", 300637)
        SayAt(player, 240532, 80, 43000, "You've always been reckless, Umbric. You leave calamity and ruin in your wake.", 300638)
        SayAt(player, 240532, 80, 49000, "At least try to make it back alive.", 300639)
    end
end)

-- Accept scena (Wiki Notes): Umbric -> Lor'themar x2 -> Arator -> Lothraxion
RegisterCreatureEvent(235405, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86549) then return end
    pcall(function() PrintInfo("[ds86549] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235405, 80, 1500, "Here, help me align the spell. It will anchor us back to Magisters' Terrace in case of disaster.", 300630)  -- bt 283077 kit vo_120_magister_umbric_62
    SayAt(player, 235481, 80, 8000, "High Commander Lothraxion has warred on countless far realms, so I have asked him to lead this mission.", 300640)
    SayAt(player, 235481, 80, 15000, "And young Arator has more than proven his worth. Together, I hope their Light will balance you within the shadow.", 300641)
    SayAt(player, 235479, 80, 22000, "You ren'dorei may be our greatest weapon against the Void. I swear to protect you all.", 300642)
    SayAt(player, 235477, 80, 29000, "The Light is our greatest weapon against the Void. Remember that, or succumb to corruption.", 300643)
end)

print("[no_fear_of_the_dark] loaded")
