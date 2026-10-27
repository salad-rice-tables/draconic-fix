-- The Light's Summons: NPC says + voice kits (retail BroadcastText + SoundKit, text verbatim from Warcraft Wiki, ids from hotfixes.broadcast_text).
-- Say(speaker, line, player): speaker:SendUnitSay + PlayDistanceSound(kit, player). Accept = creature event 31, reward = 34.
if IS_WORLD_STATE then return end

local ARATOR, LORTHEMAR_SL, TURALYON, LIADRIN, XAYANN = 243091, 236961, 236978, 236693, 0
local function Name(p) local ok, n = pcall(function() return p:GetName() end); return ok and n or "friend" end
local function Say(speaker, text, kit, player)
    if not speaker then return end
    pcall(function() speaker:SendUnitSay((text:gsub("<[Nn]ame>", Name(player))), 0) end)
    if kit and kit > 0 and player then pcall(function() speaker:PlayDistanceSound(kit, player) end) end
end
local function Near(c, entry, range)
    local ok, n = pcall(function() return c:GetNearestCreature(range or 80, entry) end)
    return ok and n or nil
end
local function NearPlayer(c) local ok, p = pcall(function() return c:GetNearestPlayer(80) end); return ok and p or nil end
local function QuestId(q) local ok, id = pcall(function() return q:GetId() end); return ok and id or 0 end

-- ---- accept lines: [questgiver entry] = { [quest] = {speaker entry (0 = giver), text, kit} }
local ACCEPT = {
  [236896] = { [86805] = {ARATOR, "Come on, <name>. Let's clear a path for the survivors.", 308195} },
  [236961] = { [86806] = {0, "If we don't protect those ships, we'll have sent the people aboard them to die!", 308201} },
  [243091] = {
    [89012] = {0, "Come on, <name>. Let's clear a path for the survivors.", 308195},
    [86807] = {0, "Mount up, <name>. We must get to the gate before the Vanguard attacks!", 308210},
    [86834] = {0, "My father is eager to vanquish the Host, but charging forward won't be enough. We have to take out that pylon.", 308213},
    [91274] = {0, "My father is eager to vanquish the Host, but charging forward won't be enough. We have to take out that pylon.", 308213},
  },
  [236974] = { [91274] = {ARATOR, "My father is eager to vanquish the Host, but charging forward won't be enough. We have to take out that pylon.", 308213} },
}
for giver, quests in pairs(ACCEPT) do
    RegisterCreatureEvent(giver, 31, function(_, player, creature, quest)
        local q = quests[QuestId(quest)]
        if not q then return end
        local who = (q[1] == 0) and creature or Near(creature, q[1])
        Say(who, q[2], q[3], player)
    end)
end

-- ---- turn-in lines (reward = 34)
RegisterCreatureEvent(TURALYON, 34, function(_, player, creature, quest)
    local id = QuestId(quest)
    if id == 91274 or id == 86834 then Say(creature, "Arator! You broke formation.", 308219, player) end
end)
RegisterCreatureEvent(236896, 34, function(_, player, creature, quest)      -- Lor'themar: after Luminous Wings the boats escape
    if QuestId(quest) == 86806 then Say(creature, "Turalyon forgets that victory means nothing if it costs us everything in return.", 308209, player) end
end)
RegisterCreatureEvent(LORTHEMAR_SL, 34, function(_, player, creature, quest)
    if QuestId(quest) == 86806 then Say(creature, "Turalyon forgets that victory means nothing if it costs us everything in return.", 308209, player) end
end)

-- ---- bosses
RegisterCreatureEvent(240598, 1, function(_, c, target)     -- Latrunculon aggro
    Say(c, "The armies of the Void are vast and varied. You are not prepared for what awaits you!", 308162, NearPlayer(c))
end)
RegisterCreatureEvent(240598, 4, function(_, c, killer)     -- Latrunculon dies
    Say(c, "Xal'atath forgive... my failure.", 308434, NearPlayer(c))
end)
RegisterCreatureEvent(240601, 4, function(_, c, killer)     -- Blightclaw dies -> Arator
    local p = NearPlayer(c)
    Say(Near(c, ARATOR), "For all that creature's might, it was in such pain. When I was overcome by wrath, I lashed out in my pain. Is it the same for the Void as it is for the Light?", 308400, p)
end)
RegisterCreatureEvent(240478, 4, function(_, c, killer)     -- Gloomstress dies -> Arator
    Say(Near(c, ARATOR), "It is done. The way is clear.", 308199, NearPlayer(c))
end)

-- ---- Severing the Void: Arator comments as sentinels are activated (1 = first ... 4 = fourth)
local SENT = { 246227, 246239, 246245, 246251, 246255 }
local SAYS = {
  [1] = { {"Please forgive my father's tone. We don't always see eye-to-eye on things, to say the least.", 308214} },
  [2] = { {"High Exarch Turalyon is a vaunted battlefield commander. Though... I think he sometimes forgets how to be anything else.", 308215} },
  [3] = { {"The Vanguard has faith in the Light, and so do I. But I've also felt it fill me with wrath, and I... I'm not sure what to think when it does.", 308216} },
  [4] = { {"Let's... focus on activating the sentinels.", 308218} },
}
for _, e in ipairs(SENT) do
    RegisterCreatureEvent(e, 5, function(_, c) end)
    RegisterCreatureGossipEvent(e, 1, function(_, player, creature)
        local ok, n = pcall(function() return player:GetReqKillOrCastCurrentCount(91274, 246247) end)
        if not ok then return false end
        local l = SAYS[n + 1]
        if l then Say(Near(creature, ARATOR, 120), l[1][1], l[1][2], player) end
        return false
    end)
end
print("[ls_voices] loaded")

-- ================= Broken Sun (86850) and Light's Last Stand (86852): text from Warcraft Wiki, ids from hotfixes.broadcast_text, kit speaker paths checked in CASC
-- 86850 accept (giver Liadrin 237277): Liadrin, then Turalyon, then Arator ("$p! Mount up! Retreat to the Sunwell!" = bcast 286448 / kit 308239)
RegisterCreatureEvent(237277, 31, function(_, player, creature, quest)
    if QuestId(quest) ~= 86850 then return end
    Say(creature, "Turalyon! We must regroup at the Sunwell before it's too late!", 308237, player)
    player:RegisterEvent(function(_, _, _, p)
        local t = Near(creature, TURALYON, 40)
        Say(t, "Damn it all! Vanguard, fall back!", 308238, p)
    end, 3500, 1)
    player:RegisterEvent(function(_, _, _, p)
        Say(Near(creature, ARATOR, 40), "<name>! Mount up! Retreat to the Sunwell!", 308239, p)
    end, 6500, 1)
end)
-- after the dragonhawk lands: Arator "We made it!" (289052 / 308240) and Liadrin at the Sunwell "You are the last of the Vanguard to make it." (289060 / 308244)
for _, hawk in ipairs({ 237388, 245993 }) do
    RegisterCreatureGossipEvent(hawk, 2, function(_, player, creature, sender, intid)
        if sender ~= 912046707 then return false end
        player:RegisterEvent(function(_, _, _, p)
            local lia = Near(p, 237278, 80)
            Say(Near(p, ARATOR, 80), "We made it! Light preserve us.", 308240, p)
            if lia then p:RegisterEvent(function(_, _, _, pp) Say(lia, "You are the last of the Vanguard to make it.", 308244, pp) end, 4000, 1) end
        end, 6000, 1)
        return false
    end)
end

-- 86852 Imperatus (244088): aggro and 50% health (Eluna 9 = damage taken)
RegisterCreatureEvent(244088, 1, function(_, c) Say(c, "Pray to your petty well. It will not save you from Xal'atath!", 308248, NearPlayer(c)) end)
local half = {}
RegisterCreatureEvent(244088, 9, function(_, c, attacker, damage)
    local g = tostring(c:GetGUID())
    if not half[g] and c:GetHealthPct() <= 50 then half[g] = true; Say(c, "We will extinguish the Sunwell's radiance!", 308249, NearPlayer(c)) end
end)
RegisterCreatureEvent(244088, 4, function(_, c) half[tostring(c:GetGUID())] = nil end)
print("[ls_voices] part 2 loaded")

-- ================= Light's Arsenal / Wrath Unleashed / Light's Last Stand (speaker = CASC path of each kit: Turalyon 308223/308228/308234, Alonsus 308233, Arator 308246)
local function Active(p, q) local ok, st = pcall(function() return p:GetQuestStatus(q) end); return ok and st == 3 end
RegisterCreatureEvent(237253, 31, function(_, player, creature, quest)          -- Light's Arsenal accepted from Liadrin
    if QuestId(quest) == 86848 then
        Say(Near(creature, TURALYON, 60) or creature, "On that we agree. Arator, hold the line. <name>, seize those weapons!", 308223, player)
    end
end)
RegisterCreatureGossipEvent(237255, 2, function(_, player, creature, sender, intid)   -- Turalyon at the harbor: "(Quest) Let's drive this threat back!"
    if sender == 912046729 and Active(player, 86849) then
        Say(creature, "Vanguard of the Light! With me! Push these invaders back to the Void that spawned them!", 308228, player)
    end
    return false
end)
RegisterCreatureGossipEvent(243987, 1, function(_, player, creature)              -- Alonsus Faol at the harbor
    if Active(player, 86849) then Say(creature, "Hurry, <name>! We need your help against that behemoth!", 308233, player) end
    return false
end)
RegisterCreatureGossipEvent(237277, 1, function(_, player, creature)              -- Liadrin at the harbor ("Channel the Light")
    if Active(player, 86849) then Say(Near(creature, TURALYON, 40), "Channel the Light from the weapons you recovered! Drive this monster back to the Void!", 308234, player) end
    return false
end)
RegisterCreatureGossipEvent(237278, 1, function(_, player, creature)              -- Liadrin at the Sunwell: the ritual begins
    if Active(player, 86852) then Say(Near(creature, ARATOR, 60), "Leave it to us! We'll clear the chamber!", 308246, player) end
    return false
end)
print("[ls_voices] part 3 loaded")
