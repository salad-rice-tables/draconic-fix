-- =====================================================================
-- Quest 92900 A Favor for Kinduru: Stay-awhile scenes (elf/troll) + join + Den credit.
-- Liadrin 253656/40427 opt0 -> KC 256013 + 10-say elf scene.
-- Rokhan 253661/40424 opt1 -> KC 260795 + 10-say troll scene.
-- Zul'jan 253653/40429 opt0 -> KC 254977 + join says.
-- Zul'jan hello in Den (46729) -> KC 254978 (interact misto proximity) + Orweyna say.
-- Accept-say riesi SmartAI (event 19). SmartAI 62->33 je ZALOHA kreditov.
-- Texty doslovne z Warcraft Wiki A_Favor_for_Kinduru. Cooldown sceny 300 s, single 60 s.
-- MEDZERA: ziadny vizualny escort (party uz stoji v 46729).
-- VO: vo_1207 kity (fid 7708057-7708234, SoundKitEntry 12.1.5) priradene 2026-10-18.
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}
local COOLDOWN_SAY = 60
local COOLDOWN_SCENE = 300

local function OnCooldown(player, key, secs)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < secs then return true end
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

-- Elf scene (Liadrin menu): Lor'themar -> Liadrin -> Lor'themar -> Liadrin -> Vereesa x6.
RegisterCreatureGossipEvent(253656, 2, function(_, player, _, sender, intid)
    if sender ~= 40427 then return end
    pcall(function() player:KilledMonsterCredit(256013) end)
    if OnCooldown(player, "favor-elf", COOLDOWN_SCENE) then return end
    SayAt(player, 253655, 60, 1500, "We share a lineage with the trolls? With the Amani? This... this is preposterous!", 337068)
    SayAt(player, 253656, 60, 7500, "These are shocking revelations. But I have fought beside them, Lor'themar. We share more in common than you may think.", 337067)
    SayAt(player, 253655, 60, 14000, "And what now? We open our gates to them? Welcome them into the very city they have long sought to burn to the ground?", 337069)
    SayAt(player, 253656, 60, 21000, "No one is suggesting that. This is merely a new perspective, a chance to--", 337070)
    SayAt(player, 258035, 60, 27000, "Liadrin. You of all people should understand the pain and loss the Amani have inflicted upon us.", 337071)
    SayAt(player, 258035, 60, 34000, "They destroyed our homes and slaughtered our families. They captured and tortured us when we fought back.", 337073)
    SayAt(player, 253656, 60, 41000, "I know, Vereesa. Believe me, I know. It... has not been easy for me to move past my anger. But it is a path worth walking.", 337075)
    SayAt(player, 258035, 60, 48000, "Then I admire your grace. You will find I am not as forgiving as a paladin of the Light.", 337076)
    SayAt(player, 258035, 60, 54000, "I will never regard the Amani as kin. Not after they robbed me of my true family.", 337077)
    SayAt(player, 258035, 60, 60000, "Selama ashal'anore, Blood Knight. Justice for our people.", 337078)
end)

-- Troll scene (Rokhan menu opt1): Talanji -> Zekhan x2 -> Rokhan -> Talanji -> Rokhan x3 -> Zekhan -> Talanji.
RegisterCreatureGossipEvent(253661, 2, function(_, player, _, sender, intid)
    if sender ~= 40424 or intid ~= 1 then return end
    pcall(function() player:KilledMonsterCredit(260795) end)
    if OnCooldown(player, "favor-troll", COOLDOWN_SCENE) then return end
    SayAt(player, 253660, 60, 1500, "I will have to tell the other tribes. They will not be pleased.", 337055)
    SayAt(player, 257934, 60, 7500, "This could be exciting news. We all come from an ancient line of hunters, and guardians of a secret world.", 337057)
    SayAt(player, 257934, 60, 14000, "What does it matter if de elves share dat ancestry?", 337058)
    SayAt(player, 253661, 60, 20000, "Heh. It matters plenty, Zekhan.", 337059)
    SayAt(player, 253660, 60, 26000, "Our people have clashed with de elves for millennia. Dey will not let go of old conflicts easily.", 337060)
    SayAt(player, 253661, 60, 33000, "If dey even believe what Hagar told us.", 337061)
    SayAt(player, 253661, 60, 39000, "Most trolls never seen a haranir, never even heard of dem.", 337062)
    SayAt(player, 253661, 60, 45000, "How do we tell a troll who never left de Echo Isles dat de elves are kin to us?", 337064)
    SayAt(player, 257934, 60, 52000, "De Horde brought many of us together, maybe...", 337065)
    SayAt(player, 253660, 60, 58000, "You cannot force a family. Even if we share blood, this will take time.", 337066)
end)

-- Join button (Zul'jan menu): credit + Zul'jan/Orweyna says.
RegisterCreatureGossipEvent(253653, 2, function(_, player, _, sender, intid)
    if sender ~= 40429 then return end
    pcall(function() player:GossipComplete() end)
    pcall(function() player:KilledMonsterCredit(254977) end)
    if OnCooldown(player, "favor-join", COOLDOWN_SAY) then return end
    SayAt(player, 253653, 60, 1500, "Orweyna. How do you know Hagar speaks the truth?", 337080)
    SayAt(player, 253654, 60, 7000, "We must go to the Den of Echoes. Follow me.", 337081)
end)

-- Den meetup: Zul'jan hello in 46729 grants the Den credit + Orweyna painting say.
RegisterCreatureGossipEvent(253653, 1, function(_, player, creature)
    local ok, entry = pcall(function() return creature:GetEntry() end)
    if not ok or entry ~= 253653 then return end
    pcall(function() player:KilledMonsterCredit(254978) end)
    if OnCooldown(player, "favor-den", COOLDOWN_SAY) then return end
    SayAt(player, 253654, 60, 1500, "The proof lies in one of the paintings within.", 337082)
end)

print("[afavor92900] loaded")
