-- =====================================================================
-- Harandar intro: Initiation Day (90957), Roots Above All (90958), Traditional Duties (90959)
-- Zdroj pravdy: poznamky v Obsidian vaulte "Harandar moje info/Initiation Day.md"
-- (texty, soundkity, GPS body). 90960/90961 su v harandar_90960.lua.
--
-- 90957  Dalnir: pri priblizeni (quest hotovy) "Ah, the initiate! ..." (305522)
-- 90958  Withered Plant: vine pulling 1240769 -> rastlina zmizne, Withered Lasher (nepriatel)
--        Pesky Sludger: Kick 1240739 si da sam sebe -> odleti, despawn, kredit
--        Invasive Fungi: Removing Fungi 1240775 (GO) -> kredit
--        progress bar 100% -> Goddess' Call + emote text + sepot, Orweyna + Shield/Axe,
--        Outsider's gear (item 246129), potom hovory Dalnir/Orweyna
-- 90959  Orweyna: say 305535/305536, kredit 253478, Saptor/Alton scena, Den scena
-- Progress bar vahy (quest_objectives): sludger 8, plant 10, fungi 12, lasher 2 (spolu >= 100)
-- =====================================================================
if IS_WORLD_STATE or not MAP_Timer then return end

local Q57, Q58, Q59 = 90957, 90958, 90959
local ST_COMPLETE, ST_INCOMPLETE = 1, 3
local GODDESS, VINE, KICK, FUNGI = 1247258, 1240769, 1240739, 1240775

local DALNIR, ORW_START, ALTON, SAPTOR = 245102, 245879, 245104, 245114
local SLUDGER, LASHER, FUNGUS_GO = 245117, 248669, 553763
local PLANTS = { 246277, 255723, 251084 }
local GEAR_ITEM, GO_SHIELD, GO_AXE = 246129, 553793, 553844
local ITEM_SHIELD, ITEM_AXE = 246112, 246126

local WEIGHT = { sludger = 8, plant = 10, fungus = 12, lasher = 2 }

local GEAR_ORWEYNA = { 1256.18, 801.18, 1331.31, 2.1 }
local GEAR_OBJECT  = { 1258.27, 803.88, 1331.30, 2.1 }
local GEAR_WALK = { {1251.78, 806.76, 1330.28}, {1240.55, 814.75, 1328.41}, {1235.64, 831.50, 1328.61}, {1233.29, 841.38, 1328.66} }
local DALNIR_WALK = { {1344.74, 913.25, 1343.71}, {1340.15, 917.66, 1341.09}, {1335.49, 922.08, 1338.05} }
local SAPTOR_AREA = { 1152.69, 885.18 }
local GALTRA = 246353   -- Galtra Bloodcleave: the orc woman who is rescued by the Horde player (Alton Parsons is the Alliance one)
-- the lost outsider of the story is faction specific: Alton Parsons (Alliance) / Galtra Bloodcleave (Horde), with their own voices
local RESCUED = {
    A = { entry = 245104, name = "Alton", yell = "Get away, you overgrown cabbage!", yellKit = 305531,
          thanks = "I thought I was done for. Thank you for the rescue!", thanksKit = 305537,
          den = "I would have been dead if they didn't.", denKit = 305539 },
    H = { entry = 246353, name = "Galtra", yell = "You're lucky I don't have my axe, beast!", yellKit = 305532,
          thanks = "Thank you, stranger. I owe you my life.", thanksKit = 305538,
          den = "They saved my life!", denKit = 305541 },
}
local function Resc(p)
    local ok, h = pcall(function() return p:IsHorde() end)
    return (ok and h) and RESCUED.H or RESCUED.A
end
local ALTON_WALK = { {1130.63, 885.48, 1340.04}, {1149.28, 892.00, 1338.21} }
local DEN_AREA = { 1161.43, 977.39 }
local DEN_DALNIR = { 1171.50, 1000.85, 1341.01, 4.0 }

local LASTERR
local function DBG(msg)
    local f = io.open("C:/WowServer/Custom/data/harandar_debug.txt", "a")
    if f then f:write(os.date("%H:%M:%S "), tostring(msg), "\n"); f:close() end
end
local Flag, Prog, Scene, Pulling, Poll = {}, {}, {}, {}, {}

-- ---------------------------------------------------------------- helpers
local function K(p) return tostring(p:GetGUID()) end
local function Status(p, q)
    local ok, s = pcall(function() return p:GetQuestStatus(q) end)
    return ok and s or 0
end
local function Active(p, q) return Status(p, q) == ST_INCOMPLETE end
local function Credit(p, entry) pcall(function() p:KilledMonsterCredit(entry) end) end
local function Say(c, text, kit, p)
    if HDBG then HDBG('say[intro] ' .. tostring(text) .. ' c=' .. tostring(c)) end
    if not c then return end
    pcall(function() c:SendUnitSay(text, 0) end)
    if kit then pcall(function() c:PlayDirectSound(kit, p) end) end
end
local function Talk(c) if c then pcall(function() c:PerformEmote(1) end) end end
local function Near(p, entry, r)
    local ok, list = pcall(function() return p:GetCreaturesInRange(r or 40, entry) end)
    if ok and list then return list[1] end
    return nil
end
local function Dist2(p, x, y)
    local px, py = p:GetLocation()
    return math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
end
local function After(p, ms, fn)
    pcall(function() p:RegisterEvent(function() pcall(fn) end, ms, 1) end)
end
local function Walk(c, pts, startMs, stepMs, p)
    if not c then return end
    pcall(function() c:SetWalk(true) end)
    for i, pt in ipairs(pts) do
        After(p, startMs + (i - 1) * stepMs, function()
            if c:IsInWorld() then c:MoveToSafe(i, pt[1], pt[2], pt[3]) end
        end)
    end
end
local function IsHorde(p)
    local ok, v = pcall(function() return p:IsHorde() end)
    return ok and v or false
end
-- orange "emote" line in chat (monster emote colour) and the pink whisper
local function FollowCall(p)
    local ok, g = pcall(function() return p:GetGender() end)
    pcall(function() p:PlayDirectSound((ok and g == 1) and 305528 or 305527, p) end)
end
local function EmoteLine(p, text) pcall(function() p:SendBroadcastMessage("|cffff8040" .. text .. "|r") end) end
local function WhisperLine(p, text) pcall(function() p:SendBroadcastMessage("|cffff80ff" .. text .. "|r") end) end

local function ResetQuest(p, tag)
    local k = K(p)
    for f in pairs(Flag) do
        if string.sub(f, 1, #k + 1) == k .. ":" and (tag == nil or string.find(f, ":" .. tag, 1, true)) then Flag[f] = nil end
    end
end
local function Once(p, tag)
    local f = K(p) .. ":" .. tag
    if Flag[f] then return false end
    Flag[f] = true
    return true
end

-- ---------------------------------------------------------------- 90958: progress bar finished
local function OnBarComplete(p)
    if not Once(p, "bar58") then return end
    pcall(function() p:CastSpell(p, GODDESS, true) end)
    EmoteLine(p, "You feel a pressure in your chest as a faint song can be heard in the depths of your mind.")
    After(p, 5000, function()
        WhisperLine(p, "Faint song whispers: Follow the call. Follow your heart.")
        FollowCall(p)
    end)
    -- Orweyna + Alliance Shield / Horde Axe where the outsider fell
    local g, o = GEAR_ORWEYNA, GEAR_OBJECT
    local orw = p:SpawnCreature(ORW_START, g[1], g[2], g[3], g[4], 3, 900000)
    local item = p:SummonGameObject(IsHorde(p) and GO_AXE or GO_SHIELD, o[1], o[2], o[3], o[4], 900)
    DBG('barcomplete orw=' .. tostring(orw) .. ' go=' .. tostring(item))
    Scene[K(p)] = { orw = orw, go = item }
end

local function AddProgress(p, what)
    if not Active(p, Q58) then return end
    local k = K(p)
    Prog[k] = (Prog[k] or 0) + WEIGHT[what]
    if Prog[k] >= 100 then OnBarComplete(p) end
end

-- ---------------------------------------------------------------- 90958: sludger / plants / fungi
-- Kick: the sludger casts it on itself and flies away (the player is not moved)
RegisterCreatureGossipEvent(SLUDGER, 1, function(_, player, creature)
    DBG('sludger hello by ' .. player:GetName() .. ' status58=' .. tostring(Status(player, Q58)))
    pcall(function() player:GossipComplete() end)
    if not Active(player, Q58) then return end
    local k = tostring(creature:GetGUID())
    if Pulling[k] then return end
    Pulling[k] = true
    pcall(function() creature:CastSpell(creature, KICK, true) end)
    Credit(player, SLUDGER)
    AddProgress(player, "sludger")
    pcall(function() creature:DespawnOrUnsummon(2000) end)
    After(player, 3000, function() Pulling[k] = nil end)
end)
RegisterCreatureEvent(SLUDGER, 4, function(_, creature, killer)
    if killer and killer.GetQuestStatus and Active(killer, Q58) then AddProgress(killer, "sludger") end
end)

-- Withered Plant: Vine Pulling cast on the plant, then it is pulled out and a Withered Lasher appears
for _, plantId in ipairs(PLANTS) do
    RegisterCreatureGossipEvent(plantId, 1, function(_, player, plant)
        DBG('plant hello ' .. plantId .. ' by ' .. player:GetName())
        pcall(function() player:GossipComplete() end)
        if not Active(player, Q58) then return end
        local k = tostring(plant:GetGUID())
        if Pulling[k] then return end
        Pulling[k] = true
        pcall(function() player:CastSpell(plant, VINE, false) end)
        local waited = 0
        local function Check()
            waited = waited + 500
            if not (plant:IsInWorld() and player:IsInWorld()) then Pulling[k] = nil return end
            local px, py = player:GetLocation()
            local x, y, z, o = plant:GetLocation()
            if waited >= 2500 and math.sqrt((px - x) ^ 2 + (py - y) ^ 2) >= 7 then
                Pulling[k] = nil
                Credit(player, 246277)
                AddProgress(player, "plant")
                plant:DespawnOrUnsummon(0)
                local lasher = player:SpawnCreature(LASHER, x, y, z, o, 3, 180000)
                if lasher then pcall(function() lasher:AttackStart(player) end) end
            elseif waited >= 20000 then
                Pulling[k] = nil
            else
                After(player, 500, Check)
            end
        end
        After(player, 500, Check)
    end)
end
RegisterCreatureEvent(LASHER, 4, function(_, creature, killer)
    if killer and killer.GetQuestStatus and Active(killer, Q58) then AddProgress(killer, "lasher") end
end)

-- Invasive Fungi: Removing Fungi cast on the object
RegisterGameObjectEvent(FUNGUS_GO, 14, function(_, go, player)
    if not (go and player) or not Active(player, Q58) then return false end
    if Once(player, "fungus" .. tostring(go:GetGUID())) == false then return true end
    pcall(function() player:CastSpell(go, FUNGI, false) end)
    After(player, 1700, function()
        Flag[K(player) .. ":fungus" .. tostring(go:GetGUID())] = nil
        if not (go:IsInWorld() and player:IsInWorld()) then return end
        pcall(function() player:KillGOCredit(FUNGUS_GO) end)
        AddProgress(player, "fungus")
        go:Despawn()
    end)
    return true
end)

-- Outsider's gear: retail chests Shield 553793 (Alliance) / Axe 553844 (Horde) with their own loot; once the weapon is looted
-- (checked in Proximity) the quest item 246129 is granted and Orweyna comments
local function OnGearLooted(p)
    local k = K(p)
    pcall(function() p:AddItem(GEAR_ITEM, 1) end)
    local sc = Scene[k]
    local orw = sc and sc.orw or Near(p, ORW_START, 30)
    After(p, 3000, function()
        Talk(orw)
        Say(orw, "This is an outsider's war gear. Without it they could be easy prey, even for small predators. That's concerning.", 305530, p)
    end)
    After(p, 9000, function() Walk(orw, GEAR_WALK, 0, 2500, p) end)
    After(p, 22000, function() if orw and orw:IsInWorld() then orw:DespawnOrUnsummon(500) end end)
end

-- Orweyna (quest giver of 90959) by the gear: gossip text only; no button
RegisterCreatureGossipEvent(ORW_START, 1, function(_, player, creature)
    if not Active(player, Q58) then return false end
    pcall(function() player:GossipClearMenu() end)
    pcall(function() player:GossipSendMenu(1000000015, creature) end)   -- gossip text only, no button
    return true
end)

-- ---------------------------------------------------------------- 90958 turn-in scene at Dalnir
RegisterCreatureEvent(DALNIR, 31, function(_, player, creature, quest)
    local ok, id = pcall(function() return quest:GetId() end)
    if ok and id == Q58 then
        Prog[K(player)] = 0
        ResetQuest(player, "bar58")
        ResetQuest(player, "b58")
        ResetQuest(player, "gear58")
        ResetQuest(player, "e58")
    end
end)
RegisterCreatureEvent(DALNIR, 34, function(_, player, creature, quest)
    local ok, id = pcall(function() return quest:GetId() end)
    if not ok or id ~= Q58 then return end
    local starts, total = HSeq(player, 4500, {
        { npc = creature, text = "You must focus on a traditional ceremony, not careless adventures!", kit = 305523, talk = true },
        { npc = creature, text = "Come to the Den of Remembrance to finish your initiation.", kit = 305524, talk = true },
    })
    -- he walks away while saying the second line and disappears at the last point
    Walk(creature, DALNIR_WALK, starts[2] + 300, 2500, player)
    After(player, starts[2] + 300 + #DALNIR_WALK * 2500 + 800, function()
        if creature:IsInWorld() then creature:DespawnOrUnsummon(800) end
    end)
end)

-- ---------------------------------------------------------------- 90959: Traditional Duties
RegisterCreatureEvent(ORW_START, 31, function(_, player, creature, quest)
    local ok, id = pcall(function() return quest:GetId() end)
    if not ok or id ~= Q59 then return end
    ResetQuest(player, "d59"); ResetQuest(player, "f59")
    local starts, total = HSeq(player, 0, {
        { npc = creature, text = "I will search for the outlander.", kit = 305535, talk = true },
        { npc = creature, text = "But they should be safe until after your initiation ceremony.", kit = 305536, talk = true },
    })
    -- the credit and the Goddess' Call come when she starts the second line; "Follow the call" after she has finished
    After(player, starts[2], function()
        Credit(player, 253478)                       -- Dalnir met at the Den of Remembrance
        pcall(function() player:CastSpell(player, GODDESS, true) end)
        EmoteLine(player, "You feel slightly off-balance as a faint song plays deep within your mind.")
    end)
    After(player, total, function() FollowCall(player) end)
end)

-- gossip of the rescued outsider (Alton Parsons / Galtra Bloodcleave): "Tell <him/her> to head to the Den of Remembrance for help."
local ALTON_OPT = 909701
for _, rescuedEntry in ipairs({ 245104, 246353 }) do
    RegisterCreatureGossipEvent(rescuedEntry, 1, function(_, player, creature)
        local r = Resc(player)
        if creature:GetEntry() ~= r.entry then return false end
        if not Active(player, Q59) or Flag[K(player) .. ":alton_done"] then return false end
        pcall(function() player:GossipClearMenu() end)
        pcall(function() player:GossipMenuAddItem(2, "Tell " .. r.name .. " to head to the Den of Remembrance for help.", creature:GetEntry(), ALTON_OPT) end)
        pcall(function() player:GossipSendMenu(rescuedEntry == 245104 and 1000000013 or 1000000010, creature) end)
        return true
    end)
    RegisterCreatureGossipEvent(rescuedEntry, 2, function(_, player, creature, sender, intid)
        if intid ~= ALTON_OPT then return false end
        pcall(function() player:GossipComplete() end)
        if not Active(player, Q59) then return true end
        if not Once(player, "alton_done") then return true end
        local r = Resc(player)
        Credit(player, 246360)                           -- Outsider directed to safety
        Talk(creature)
        Say(creature, r.thanks, r.thanksKit, player)
        Walk(creature, ALTON_WALK, 1500, 2500, player)
        pcall(function() creature:SetWalk(false) end)   -- he/she runs away
        After(player, 9000, function() if creature:IsInWorld() then creature:DespawnOrUnsummon(800) end end)
        return true
    end)
end

-- ---------------------------------------------------------------- proximity scenes (once per player per quest run)
-- one actor per place: reuse a creature of this entry that already stands there (also a temp copy that survived a Lua reload)
local function SpawnOnce(p, entry, x, y, z, o, ms)
    local ok, list = pcall(function() return p:GetCreaturesInRange(80, entry) end)
    if ok and list then
        for _, c in ipairs(list) do
            local cx, cy = c:GetLocation()
            if (cx - x) ^ 2 + (cy - y) ^ 2 < 64 then return c end
        end
    end
    return p:SpawnCreature(entry, x, y, z, o, 3, ms or 600000)
end

-- Den of Remembrance: Hagar 245096, Orweyna 245881 and Alton are static retail spawns that the retail phase
-- conditions show only while 90959 is complete/rewarded and 90960 is not done. Dalnir has no Den spawn at all:
-- he is a temporary summon in the player's phase (single shared copy while alive).
local Den = {}
Mural = Mural or {}
local function Alive(c) return c and pcall(function() return c:IsInWorld() end) and c:IsInWorld() end
function EnsureDen(p)
    if not Alive(Den.dal) then
        Den.dal = SpawnOnce(p, DALNIR, DEN_DALNIR[1], DEN_DALNIR[2], DEN_DALNIR[3], DEN_DALNIR[4], 900000)
    end
    -- statics are used when the player's phase shows them; when it does not (Near finds nothing) a temp copy is summoned
    -- in the player's own phase so the turn-in NPC (Orweyna 245881) and the scene actors are always there
    local spec = {
        orw = { 245881, 1168.00, 1004.00, 1342.00, 5.36787 },
        hag = { 245096, 1170.05, 1002.73, 1341.35, 4.04663 },
        alt = { Resc(p).entry, 1166.88, 999.531, 1341.35, 1.32568 },
    }
    for key, t in pairs(spec) do
        local c = Near(p, t[1], 40)
        if not c then
            if not Alive(Den[key .. "_t"]) then
                Den[key .. "_t"] = SpawnOnce(p, t[1], t[2], t[3], t[4], t[5], 900000)
            end
            c = Den[key .. "_t"]
        end
        Den[key] = c
    end
    return Den
end

local TICK = 0
AltonSaptor, SaptorTemp = nil, nil
local function Proximity(p)
    TICK = TICK + 1
    if TICK % 20 == 1 then DBG('tick ' .. p:GetName() .. ' s58=' .. tostring(Status(p, Q58)) .. ' map=' .. tostring(p:GetMapId())) end
    local s57, s58, s59 = Status(p, Q57), Status(p, Q58), Status(p, Q59)
    if s57 ~= ST_COMPLETE then Flag[K(p) .. ":a57"] = nil end
    if s58 ~= ST_COMPLETE then Flag[K(p) .. ":b58"] = nil end
    local name = p:GetName()

    -- 90957 done -> Dalnir greets the initiate
    if s57 == ST_COMPLETE then
        local dal = Near(p, DALNIR, 12)
        if dal and Once(p, "a57") then
            Talk(dal)
            Say(dal, "Ah, the initiate! We take a big step for you today.", 305522, p)
        end
    end

    -- Orweyna (245879) must already stand beside Dalnir when 90958 is turned in (they talk to each other), and she is the giver
    -- of 90959: when the player's phase does not show the static spawn, a temp copy is summoned on its spot
    if (s58 == ST_COMPLETE or (s58 == 6 and s59 ~= ST_COMPLETE and s59 ~= 6)) and Dist2(p, 1340, 907) < 60 then
        SpawnOnce(p, ORW_START, 1337.48, 906.046, 1345.59, 0.249486, 600000)
    end

    -- 90958 done -> Dalnir / Orweyna talk about the outsider before the turn-in
    if s58 == ST_COMPLETE then
        local dal = Near(p, DALNIR, 12)
        if dal and Once(p, "b58") then
            HSeq(p, 0, {
                { npc = dal, text = "Outsiders shouldn't be here, especially not today.", kit = 305525, talk = true },
                { npc = function() return Near(p, ORW_START, 30) end, text = "They do not understand the dangers of Harandar. We must find them.", kit = 305526, talk = true },
            })
        end
    end

    -- 90958: progress bar finished outside this script's own counter (GM credit, relog, reload):
    -- every 15 s save the player and sum the stored objective counts with the bar weights
    if s58 == ST_INCOMPLETE and not Flag[K(p) .. ":bar58"] then
        Poll[K(p)] = (Poll[K(p)] or 0) + 1
        if Poll[K(p)] % 15 == 0 then
            pcall(function() p:SaveToDB() end)
            local okq, res = pcall(CharDBQuery, "SELECT objective, data FROM character_queststatus_objectives WHERE guid = " ..
                tostring(p:GetGUIDLow()) .. " AND quest = " .. Q58)
            DBG('poll ' .. p:GetName() .. ' q=' .. tostring(okq) .. ' res=' .. tostring(res))
            if okq and res then
                local total = 0
                repeat
                    local w = ({ [0] = WEIGHT.sludger, [1] = WEIGHT.plant, [2] = WEIGHT.fungus, [4] = WEIGHT.lasher })[res:GetUInt32(0)]
                    if w then total = total + w * res:GetInt32(1) end
                until not res:NextRow()
                DBG('poll total=' .. total)
                if total >= 100 then OnBarComplete(p) end
            end
        end
    end

    -- 90958: weapon looted from the chest -> quest item + Orweyna reacts
    if s58 == ST_INCOMPLETE and Flag[K(p) .. ":bar58"] and not Flag[K(p) .. ":gear58"] then
        local weapon = IsHorde(p) and ITEM_AXE or ITEM_SHIELD
        local okh, has = pcall(function() return p:HasItem(weapon) end)
        if okh and has and Once(p, "gear58") then OnGearLooted(p) end
    end

    -- 90958 bar done: Orweyna by the gear notices the player
    local sc = Scene[K(p)]
    if sc and sc.orw and s58 == ST_INCOMPLETE and Flag[K(p) .. ":bar58"] and sc.orw:IsInWorld() then
        if Dist2(p, GEAR_ORWEYNA[1], GEAR_ORWEYNA[2]) < 14 and Once(p, "e58") then
            Talk(sc.orw)
            Say(sc.orw, "What brings you here? Did you hear the...? Hmm.", 305529, p)
        end
    end

    -- 90959: the rescued Alton (static spawn, 5 min respawn after he ran off) must be there for every repeat of the quest:
    -- if the player is near the Saptor and no Alton / Saptor is visible, summon temp copies in the player's phase
    if s59 == ST_INCOMPLETE and Dist2(p, 1120, 882) < 70 then
        local r = Resc(p)
        if not Near(p, r.entry, 15) and not Alive(AltonSaptor) then
            AltonSaptor = p:SpawnCreature(r.entry, 1115.41, 882.898, 1345.77, 6.00636, 3, 600000)
            -- Galtra has no gossip flag of her own in the template: give it to the temp copy so she can be talked to
            if r.entry == 246353 and AltonSaptor then pcall(function() AltonSaptor:SetNPCFlags(1) end) end
        end
        if not Near(p, SAPTOR, 25) and not Alive(SaptorTemp) then
            SaptorTemp = p:SpawnCreature(SAPTOR, 1126.87, 880.087, 1340.66, 2.46753, 3, 600000)
        end
    end

    -- 90959 Outsider found: area around the Vicious Saptor (Alton stands ~35 yd away from the trigger point)
    if s59 == ST_INCOMPLETE and Dist2(p, SAPTOR_AREA[1], SAPTOR_AREA[2]) < 22 then
        if Once(p, "d59") then Credit(p, 247257) end
        local r = Resc(p)
        local alton = Near(p, r.entry, 90)
        if alton and Once(p, "d59say") then
            -- Alton stands ~35 yd from the trigger point: normal /say only carries 25 yd, so yell it and play the voice straight to the player
            pcall(function() alton:SendUnitYell(r.yell, 0) end)
            pcall(function() p:PlayDirectSound(r.yellKit, p) end)
            HDBG('cabbage yelled by ' .. tostring(alton))
            local sap = Near(p, SAPTOR, 90)
            if sap then
                pcall(function() sap:MoveToSafe(1, 1120.3241, 882.3195, 1344.0564) end)
                After(p, 3500, function() pcall(function() sap:PerformEmote(15) end) end)
            end
        end
    end

    -- Den of Remembrance: the static Den spawns sit in phases this client never sees, so the scene actors are
    -- temporary summons in the player's own phase (shared while alive)
    -- mural room (My Story, My Legacy): Dalnir and Orweyna stand beside Hagar from the moment the player arrives
    if Status(p, 90960) == ST_INCOMPLETE and Dist2(p, 1145, 1163) < 45 then
        if not Alive(Mural.dal) then Mural.dal = SpawnOnce(p, DALNIR, 1149.32, 1158.22, 1309.90, 2.30, 900000) end
        if not Alive(Mural.orw) then Mural.orw = SpawnOnce(p, 245881, 1151.57, 1163.52, 1309.95, 3.14, 900000) end
        -- remove stale temp copies (older positions / survivors of a Lua reload): only the ones on the final spot stay
        for _, spec in ipairs({ { DALNIR, 1149.32, 1158.22 }, { 245881, 1151.57, 1163.52 } }) do
            local entry, tx, ty = spec[1], spec[2], spec[3]
            local okl, list = pcall(function() return p:GetCreaturesInRange(30, entry) end)
            if okl and list then
                for _, c in ipairs(list) do
                    local cx, cy = c:GetLocation()
                    if (cx - tx) ^ 2 + (cy - ty) ^ 2 > 9 and (cx - 1148) ^ 2 + (cy - 1160) ^ 2 < 900 then
                        pcall(function() c:DespawnOrUnsummon(0) end)
                    end
                end
            end
        end
        if Once(p, "dbgmural") then HDBG('mural actors for ' .. name .. ' dal=' .. tostring(Mural.dal) .. ' orw=' .. tostring(Mural.orw)) end
    end

    local s60 = Status(p, 90960)
    local denQuest = s59 == ST_INCOMPLETE or s59 == ST_COMPLETE or s60 == ST_INCOMPLETE or (s59 == 6 and s60 == 0)
    if denQuest and Dist2(p, 1169, 1002) < 50 then
        local den = EnsureDen(p)
        if Once(p, "dbgden") then DBG('den actors for ' .. name .. ' s59=' .. tostring(s59) .. ' s60=' .. tostring(s60) .. ' dal=' .. tostring(den.dal) .. ' alt=' .. tostring(den.alt)) end
        if (s59 == ST_INCOMPLETE or s59 == ST_COMPLETE) and Dist2(p, DEN_AREA[1], DEN_AREA[2]) < 40 and Once(p, "f59") then
            HSeq(p, 0, {
                { npc = den.dal, text = name .. "! You were to come directly here, not interfere in outsider affairs.", kit = 305540 },
                { npc = den.alt, text = Resc(p).den, kit = Resc(p).denKit },
            })
        end
    end
end

MAP_Timer("harandar_intro", function()
    for _, p in ipairs(MAP_Players()) do
        if p:IsInWorld() then
            local ok, err = pcall(Proximity, p)
            if not ok and err ~= LASTERR then LASTERR = err; DBG('ERROR ' .. tostring(err)) end
        end
    end
end, 1000)

print("[harandar_intro] loaded")
