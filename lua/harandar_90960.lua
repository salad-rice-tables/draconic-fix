-- =====================================================================
-- Harandar 12.1: My Story, My Legacy (90960) — plna choreografia.
-- Nahrada za harandar_visions.lua (ten je vypnuty).
-- Retail: 3 Legacy Stones (GOOBER) + visions + Hagar talk + paint.
-- Ciele (world quest_objectives, sekvencne):
--   obj0 246474 TrueSelf insp | obj1 246456 Song concl (morph+whisper)
--   obj2 246490 TrueCall insp | obj3 246522 TrueCall concl (Orweyna + vision)
--   obj4 246543 Goddess insp  | obj5 246546 Melody concl (whisper)
--   obj6 245097 Talk to Hagar | obj7 GO 554966 painted (natívny Type2)
-- Spell: 1258333 Communing (castbar 1.5s), 1247258 Goddess' Call.
--
-- OVERENE 2026-10-19:
--   * Texty = Warcraft Wiki verbatim (Rooted in Traditions / 90960).
--   * Soundkity overene transkripciou (wago SoundKitEntry -> listfile ogg):
--       305550 Lor'themar "We stand together as one! For Quel'Thalas! For Azeroth!"
--       305556 Shandris  "We stand back to back. For Azeroth!"
--       305567 Galtra    "Lok'tar friend. Thank you."
--       305566 Alton     "Until we meet again."
--   * MODRA DUCHOVSKA AURA (2. kamen True Calling): spell 456478
--     "Vision Form" (client DB2: Effect=6 APPLY_AURA, EffectAura=4 DUMMY,
--     ImplicitTarget=self => cisto klientsky vizual, ziadne server efekty).
--     Retail pouziva server-side spawn data (z CDN nezistitelne), preto
--     berieme najmensie overene riziko. Fallbacky pri zlom vyzore:
--     168665 "Cosmetic - Ghost" (aura 95) / 8326 "Ghost" (aura 95, jadro
--     ji pouziva na ghost form hraca - Player.cpp:4497).
--   * FACTION PARITY (obe frakcie):
--       Alliance: Shandris 246486 (kit 305556), Alton 245104 (305566),
--                 portal Stormwind GO 205248 (type 5 GOOBER)
--       Horde:    Lor'themar 246487 (kit 305550), Galtra 246353 (305567),
--                 portal Orgrimmar GO 193427 (type 5 GOOBER)
-- =====================================================================
if IS_WORLD_STATE then return end

local Q = 90960
local INCOMPLETE = 3
local COMMUNE = 1258333   -- Communing (castbar)
local GODDESS = 1247258   -- [DNT] Goddess' Call
local CITIZEN = 124541    -- Haranir Citizen display (morph "true self")
local VISION_AURA = 406331 -- "Ancient Ghost Visual" - the spirit aura of the True Calling vision NPCs (Orweyna, Lor'themar, Shandris)

-- bytosti
local HAGAR_ACCEPT = 245096   -- Dene (dava quest, odide)
local HAGAR_TURN   = 245097   -- mural komora (talk + turn-in)
local SONG         = 246456   -- True Self vision
local MELODY       = 246546   -- Goddess Guidance vision
local ORWEYNA_V    = 246485   -- True Calling vision
local SHANDRIS_V   = 246486   -- True Calling vision (Alliance)
local LORTHEMAR_V  = 246487   -- True Calling vision (Horde)
local DALNIR       = 245102   -- ceremónia (summon pre obj6/obj7 + accept)
local ORWEYNA_CER  = 245881   -- ceremónia (static spawn v Dene + summon)
local ALTON        = 245104   -- Parsons (Alliance farewell)
local GALTRA       = 246353   -- Bloodcleave (Horde farewell)

-- portály (obe type 5 GOOBER - cisto vizualne)
local GO_PORTAL_SW = 547188   -- "Rootway to Stormwind" (goober; klik = teleport, riesi harandar_61.lua)
local GO_PORTAL_ORG = 547190  -- "Rootway to Orgrimmar"

-- kredity (Objective ObjectID)
local O_TSI = 246474
local O_TSC = 246456
local O_TCI = 246490
local O_TCC = 246522
local O_GSI = 246543
local O_GSC = 246546
local O_TALK = 245097
local O_PAINT = 554966

-- pozície (map 2694)
local POS = {
  hagarAccept = {1170.05, 1002.73, 1341.35, 4.04663},
  hagarTurn   = {1145.0, 1163.0, 1310.0, 5.31911},
  song        = {1105.48, 1034.83, 1339.13, 3.08145},
  melody      = {1144.0, 1125.0, 1313.0, 0.0},
  stoneSelf   = {1098.16, 1033.8, 1339.0},
  stoneCall   = {1144.68, 1057.51, 1320.92},
  stoneGod    = {1142.4, 1130.06, 1310.26},
  -- Hagar accept walk-away (Den)
  hagarWalk = { {1163.19,1003.63,1341.43}, {1157.84,1006.17,1341.57}, {1153.55,1008.89,1341.52} },
}

local Cool = {}   -- per-player cooldown (anti spam)
local ConcludeMelody   -- forward declaration (defined with the Melody handlers)

local function HasQuest(p)
  local ok, st = pcall(function() return p:GetQuestStatus(Q) end)
  return ok and st == INCOMPLETE
end
local function Credit(p, entry)
  pcall(function() p:KilledMonsterCredit(entry) end)
end
local function Say(c, text, kit, p)
  if HDBG then HDBG('say[90960] ' .. tostring(text) .. ' c=' .. tostring(c)) end
  pcall(function() c:SendUnitSay(text, 0) end)
  if kit then pcall(function() c:PlayDirectSound(kit, p) end) end
end
local function KitFor(p, male, female)
  local ok, g = pcall(function() return p:GetGender() end)
  if ok and g == 1 then return female end
  return male
end
local function Whisper(c, p, text, kit)
  pcall(function() c:SendUnitWhisper(text, 0, p) end)
  if kit then pcall(function() c:PlayDirectSound(kit, p) end) end
end
local function Talk(c) if c then pcall(function() c:PerformEmote(1) end) end end
local function Cooldown(p, key, sec)
  local k = p:GetName() .. ':' .. key
  local now = os.time()
  if (Cool[k] or 0) + (sec or 3) > now then return true end
  Cool[k] = now
  return false
end
-- najdi bytost podla entry v okoli (pre hovory ceremonialnych NPC)
local function NearCreature(p, entry, range)
  local ok, list = pcall(function() return p:GetCreaturesInRange(range or 40, entry) end)
  if not ok or not list then return nil end
  return list[1] or nil
end

-- spawn pomocnej bytosti pri pozícii (type 8 = TEMPSUMMON_MANUAL_DESPAWN)
local function SpawnAt(src, entry, x, y, z, o)
  local ok, c = pcall(function() return src:SpawnCreature(entry, x, y, z, o or 0, 8, 0) end)
  if ok then return c end
  return nil
end

-- frakcia hraca (IsHorde primarne; fallback IsAlliance / GetTeam)
local function IsHorde(p)
  local ok, v = pcall(function() return p:IsHorde() end)
  if ok and v ~= nil then return v end
  local ok2, a = pcall(function() return p:IsAlliance() end)
  if ok2 and a ~= nil then return not a end
  return false
end

-- modra duchovska aura na vision bytost
local function VisionAura(c)
  if c then pcall(function() c:CastSpell(c, VISION_AURA, true) end) end
end

-- =====================================================================
-- ACCEPT SCENA (245096 Hagar v Dene, event 31 = ON_QUEST_ACCEPT)
-- Wiki: Dalnir "Stay focused this time, <name>!" ->
--       Orweyna "They did what was right" ->
--       Hagar "Hush! Both of you! And you, outsider, follow me."
-- Nasledne Hagar postupne odide GPS -> vrati sa MoveHome.
-- =====================================================================
RegisterCreatureEvent(HAGAR_ACCEPT, 31, function(_, player, creature, quest)
  if not (player and creature) then return end
  if quest then
    local ok, qid = pcall(function() return quest:GetId() end)
    if not ok or qid ~= Q then return end
  end
  if Cooldown(player, 'accept', 5) then return end

  local name = player:GetName()
  -- all four actors are temp summons in the player's phase (EnsureDen, harandar_intro.lua)
  local den = EnsureDen and EnsureDen(player) or {}
  local dal, orw, alt = den.dal, den.orw, den.alt
  local WALKS = {
    hagar  = { {1163.1937, 1003.6261, 1341.4349}, {1157.8442, 1006.17474, 1341.5673}, {1153.5525, 1008.89264, 1341.5181} },
    orw    = { {1163.4149, 1005.34155, 1341.5009}, {1158.6129, 1008.4434, 1341.6105}, {1154.8381, 1010.6177, 1341.5594} },
    dalnir = { {1166.8724, 1001.2474, 1341.4761}, {1161.6995, 1002.28784, 1341.4323}, {1155.9917, 1004.2129, 1341.6786}, {1151.1727, 1007.69104, 1341.6832} },
    alton  = { {1163.234, 1001.3471, 1341.2106}, {1159.3257, 1003.74884, 1341.5901}, {1155.9421, 1006.801, 1341.5806}, {1152.7201, 1009.67664, 1341.5638} },
  }
  local function go(c, pts, startMs, stepMs)
    if not c then return end
    pcall(function() c:SetWalk(true) end)
    for i, pt in ipairs(pts) do
      player:RegisterEvent(function()
        if c:IsInWorld() then pcall(function() c:MoveToSafe(i, pt[1], pt[2], pt[3]) end) end
      end, startMs + (i - 1) * stepMs, 1)
    end
    -- smooth despawn on the last point
    player:RegisterEvent(function()
      if c:IsInWorld() then pcall(function() c:DespawnOrUnsummon(1200) end) end
    end, startMs + #pts * stepMs + 300, 1)
  end

  -- 3 s after accepting Dalnir speaks, then Orweyna, then Hagar - each one waits until the previous voice has finished
  local starts, total = HSeq(player, 3000, {
    { npc = dal, text = "Stay focused this time, " .. name .. "!", kit = 305551, talk = true },
    { npc = orw, text = "They did what was right.", kit = 305552, talk = true },
    { npc = creature, text = "Hush! Both of you! And you, outsider, follow me.", kit = 305553, talk = true },
  })
  -- everyone sets off when Hagar's line is about to end ("... follow me"), one after the other
  local go0 = starts[3] + 2600
  go(creature, WALKS.hagar, go0, 1900)
  go(orw, WALKS.orw, go0 + 1000, 1900)
  go(dal, WALKS.dalnir, go0 + 2000, 1700)
  go(alt, WALKS.alton, go0 + 3300, 1700)
end)

-- =====================================================================
-- STONE: True Self (554679) -> Communing -> obj0 + Goddess + Song sa "prebudi"
-- =====================================================================
RegisterGameObjectEvent(554679, 14, function(_, go, player)
  if not (go and player) then return false end
  if not HasQuest(player) then return false end
  if Cooldown(player, 'stone_self', 4) then return false end

  -- Communing MA mat GO target (ImplicitTarget1=23 TARGET_GAMEOBJECT_TARGET)!
  -- cast na self by skoncil "Invalid Target" (presne to videl user v .cast)
  pcall(function() player:CastSpell(go, COMMUNE, false) end)  -- castbar ~1.5s
  player:RegisterEvent(function(_, _, _, p)
    if not (p and p:IsInWorld()) then return end
    if not HasQuest(p) then return end
    Credit(p, O_TSI)                              -- obj0: inspected
    pcall(function() p:CastSpell(p, GODDESS, true) end)
    -- Forgotten Song appears only now (temp summon in the player's phase) and sings
    local sp = POS.song
    local song = SpawnAt(p, SONG, sp[1], sp[2], sp[3], sp[4])
    if song then
      pcall(function() song:SetFacingToObject(p) end)
      pcall(function() song:PlayDirectSound(KitFor(p, 305557, 305558), p) end)
      pcall(function() song:DespawnOrUnsummon(180000) end)
    end
  end, 1500, 1)
  return false
end)

-- =====================================================================
-- FORGOTTEN SONG (246456) gossip -> morph + whisper + obj1 + despawn
-- Wiki: header "You feel a silent song in your heart..." (npc_text
-- 1000000011), option "Reach out and touch the song."
-- Whisper: "Is this really who you are <name>? Search for your truth."
-- =====================================================================
RegisterCreatureGossipEvent(SONG, 1, function(_, player, creature)
  if not (player and creature) then return end
  if not HasQuest(player) then return end
  pcall(function() player:GossipClearMenu() end)
  pcall(function() player:GossipMenuAddItem(2, "Reach out and touch the song.", creature:GetEntry(), 909601) end)
  pcall(function() player:GossipSendMenu(1000000011, creature) end)
  return true
end)
RegisterCreatureGossipEvent(SONG, 2, function(_, player, creature, sender, intid)
  if not (player and creature) then return end
  pcall(function() player:GossipComplete() end)
  if intid ~= 909601 then return end
  if not HasQuest(player) then return end
  if Cooldown(player, 'song', 4) then return end

  -- the Song takes the shape of the player (a mirror: male Haranir for a male player, female for a female one) and whispers;
  -- when the voice has finished the objective is credited and the vision fades
  -- Har'maran Citizen models: female 245237 -> display 124541, male 245238 -> display 124542
  local okg, gender = pcall(function() return player:GetGender() end)
  local mirror = (okg and gender == 1) and 124541 or 124542
  pcall(function() creature:SetDisplayId(mirror) end)
  pcall(function() creature:SetFacingToObject(player) end)
  local kit = KitFor(player, 305557, 305558)
  Whisper(creature, player,
    "Is this really who you are " .. player:GetName() .. "? Search for your truth.", kit)
  local wait = math.floor(((KIT_LEN and KIT_LEN[kit]) or 4.0) * 1000) + 600
  player:RegisterEvent(function(_, _, _, p)
    if p and p:IsInWorld() and HasQuest(p) then Credit(p, O_TSC) end   -- obj1: concluded
    if creature and creature:IsInWorld() then pcall(function() creature:DespawnOrUnsummon(800) end) end
  end, wait, 1)
  -- NE despawnujeme: 246456 je retail persistentny spawn (spawntimesecs=300
  -- -> 5-min lockout obj1 pre dalsich hracov).
end)

-- =====================================================================
-- STONE: True Calling (546728) -> Communing -> obj2 + spawn Orweyna + vision
--   OBA dostanu modru duchovsku auru (Vision Form 456478).
--   Wiki repliky:
--     Orweyna  "I stand with you!"                    (kit 305554)
--     Shandris "We stand back to back. For Azeroth!"   (kit 305556, A)
--     Lor'themar "We stand together as one! For Quel'Thalas! For Azeroth!"
--                                                       (kit 305550, H)
--   -> obj3 + despawn oboch
-- =====================================================================
RegisterGameObjectEvent(546728, 14, function(_, go, player)
  if not (go and player) then return false end
  if not HasQuest(player) then return false end
  if Cooldown(player, 'stone_call', 4) then return false end

  pcall(function() player:CastSpell(go, COMMUNE, false) end)  -- GO target!
  player:RegisterEvent(function(_, _, _, p)
    if not (p and p:IsInWorld()) then return end
    if not HasQuest(p) then return end
    Credit(p, O_TCI)                       -- obj2: inspected
    pcall(function() p:CastSpell(p, GODDESS, true) end)

    local sx, sy, sz = POS.stoneCall[1], POS.stoneCall[2], POS.stoneCall[3]
    local orw = SpawnAt(p, ORWEYNA_V, 1141.29, 1065.68, 1320.89, 5.1)

    -- frakcny vision NPC (Alliance = Shandris / Horde = Lor'themar)
    local vis, visText, visKit
    if IsHorde(p) then
      vis = SpawnAt(p, LORTHEMAR_V, 1143.89, 1066.33, 1320.62, 4.8)
      visText = "We stand together as one! For Quel'Thalas! For Azeroth!"
      visKit = 305550
    else
      vis = SpawnAt(p, SHANDRIS_V, 1143.89, 1066.33, 1320.62, 4.8)
      visText = "We stand back to back. For Azeroth!"
      visKit = 305556
    end

    -- MODRA DUCHOVSKA AURA (retail: vision NPC su duchovia)
    VisionAura(orw)
    VisionAura(vis)

    local _, vend = HSeq(p, 1200, {
      { npc = orw, text = "I stand with you!", kit = 305554 },
      { npc = vis, text = visText, kit = visKit },
    })
    -- obj3 (concluded) + oboch preč
    p:RegisterEvent(function()
      if not p or not p:IsInWorld() then return end
      if HasQuest(p) then Credit(p, O_TCC) end
      if orw then pcall(function() orw:DespawnOrUnsummon(1000) end) end
      if vis then pcall(function() vis:DespawnOrUnsummon(1000) end) end
    end, vend + 800, 1)
  end, 1500, 1)
  return false
end)

-- =====================================================================
-- STONE: Goddess Guidance (554848) -> Communing -> obj4 + Goddess + whisper
--   Melody uz spawnuta nearby; dalsi klik na Melody -> obj5 + despawn
--   Wiki stone3 whisper: "A tree is more than just its roots.
--   There is much more to this world than Harandar alone."
-- =====================================================================
RegisterGameObjectEvent(554848, 14, function(_, go, player)
  if not (go and player) then return false end
  if not HasQuest(player) then return false end
  if Cooldown(player, 'stone_god', 4) then return false end

  pcall(function() player:CastSpell(go, COMMUNE, false) end)  -- GO target!
  player:RegisterEvent(function(_, _, _, p)
    if not (p and p:IsInWorld()) then return end
    if not HasQuest(p) then return end
    Credit(p, O_GSI)                       -- obj4: inspected
    pcall(function() p:CastSpell(p, GODDESS, true) end)
    local mp = POS.melody
    local mel = SpawnAt(p, MELODY, mp[1], mp[2], mp[3], mp[4])
    if mel then
      Whisper(mel, p,
        "A tree is more than just its roots. There is much more to this world than Harandar alone.",
        KitFor(p, 305545, 305546))
      pcall(function() mel:SetFacingToObject(p) end)
      pcall(function() mel:DespawnOrUnsummon(180000) end)
    end
  end, 1500, 1)
  return false
end)

-- FORGOTTEN MELODY (246546): click = Communing castbar on the nearby Legacy Stone -> obj5 + she fades.
-- If the player does not touch her, the vision concludes by itself 12 s after her whisper (video: credit, then she despawns).
local MelDone = {}
ConcludeMelody = function(player, creature)
  if not (player and player:IsInWorld()) then return end
  local k = tostring(player:GetGUID())
  if MelDone[k] or not HasQuest(player) then return end
  MelDone[k] = true
  local stone
  local ok, golist = pcall(function() return player:GetGameObjectsInRange(25, 554848) end)
  if ok and golist then stone = golist[1] end
  if stone then
    pcall(function() player:CastSpell(stone, COMMUNE, false) end)
  else
    pcall(function() player:CastSpell(player, GODDESS, true) end)
  end
  player:RegisterEvent(function(_, _, _, p)
    if not (p and p:IsInWorld()) then return end
    if HasQuest(p) then Credit(p, O_GSC) end   -- obj5: concluded
    MelDone[tostring(p:GetGUID())] = nil
    if creature and creature:IsInWorld() then pcall(function() creature:DespawnOrUnsummon(500) end) end
  end, 1600, 1)
end
-- Melody: gossip with one quest option (retail); choosing it starts the Communing castbar and gives the credit.
local MELODY_OPT = 909605
RegisterCreatureGossipEvent(MELODY, 1, function(_, player, creature)
  if not (player and creature) then return false end
  if not HasQuest(player) then return false end
  pcall(function() player:GossipClearMenu() end)
  pcall(function() player:GossipMenuAddItem(2, "Reach out and touch the melody.", creature:GetEntry(), MELODY_OPT) end)
  pcall(function() player:GossipSendMenu(1000000010, creature) end)
  return true
end)
RegisterCreatureGossipEvent(MELODY, 2, function(_, player, creature, sender, intid)
  if intid ~= MELODY_OPT then return false end
  pcall(function() player:GossipComplete() end)
  if HasQuest(player) then ConcludeMelody(player, creature) end
  return true
end)

-- =====================================================================
-- TALK TO HAGAR (245097 gossip) -> WIKY menu (2 polozky):
--   "I am not ready yet." (flavor, menu zostane) /
--   "Tell Hagar of the visions." -> obj6 + Dalnir/Orweyna says
-- Hagar greeting (wiki verbatim, vrátane druhej vety).
-- =====================================================================
local function SendHagarMenu(player, creature)
  pcall(function() player:GossipClearMenu() end)
  pcall(function() player:GossipMenuAddItem(0, "My Story, My Legacy.", creature:GetEntry(), 909610) end)
  pcall(function() player:GossipMenuAddItem(0, "I am not ready yet.", creature:GetEntry(), 909611) end)
  pcall(function() player:GossipMenuAddItem(2, "Tell Hagar of the visions.", creature:GetEntry(), 909612) end)
  pcall(function() player:GossipSendMenu(1000000012, creature) end)   -- header: "It is almost the end of your ceremony, <name>. What have you seen? ..."
end

RegisterCreatureGossipEvent(HAGAR_TURN, 1, function(_, player, creature)
  if not (player and creature) then return false end
  if H61Hello and H61Hello(player, creature) then return true end   -- 90961 menu (talk about the ceremony)
  if not HasQuest(player) then return false end   -- quest complete => default turn-in gossip of the core
  SendHagarMenu(player, creature)
  return true   -- without this the core opens its own (empty) menu on top of ours
end)
RegisterCreatureGossipEvent(HAGAR_TURN, 2, function(_, player, creature, sender, intid)
  if not (player and creature) then return end
  if intid == 909610 then
    pcall(function() player:GossipComplete() end)   -- plain talk entry: only the story of the quest, no action
    return
  end
  if intid == 909611 then
    -- flavor: Hagar zareaguje a menu ostane otvorene (znovu poslane)
    -- (text nie je na wiki - overit in-game)
    pcall(function() creature:SendUnitSay("Take your time. The visions will wait.", 0) end)
    SendHagarMenu(player, creature)
    return
  end
  pcall(function() player:GossipComplete() end)
  if intid ~= 909612 then return end
  if not HasQuest(player) then return end
  if Cooldown(player, 'talk_hagar', 60) then return end  -- 60s: ochrana proti duplicitnemu summonu Dalnir/Orweyna

  Credit(player, O_TALK)   -- obj6

  -- summon Dalnir + Orweyna pri Hagar (mural komora)
  local hx, hy, hz = POS.hagarTurn[1], POS.hagarTurn[2], POS.hagarTurn[3]
  local dal = NearCreature(player, DALNIR, 30) or SpawnAt(player, DALNIR, 1149.32, 1158.22, 1309.90, 2.30)
  local orw = NearCreature(player, ORWEYNA_CER, 30) or SpawnAt(player, ORWEYNA_CER, 1151.57, 1163.52, 1309.95, 3.14)
  local name = player:GetName()

  HSeq(player, 600, {
    { npc = dal, text = "Melody? Outsiders? These distractions have tainted " .. name .. "'s mind!", kit = 305542, talk = true },
    { npc = orw, text = "The paintings speak differently for each of us.", kit = 305543, talk = true },
    { npc = creature, text = name .. ", it is time for you to paint your story.", kit = 305544 },
  })
  -- Dalnir/Orweyna ostanu az do paint; neskor zmiznu (viď complete)
end)

-- =====================================================================
-- PAINT Legacy Stone (554966) -> Communing "Painting Mural" -> obj7 (natívny) + says
-- =====================================================================
RegisterGameObjectEvent(554966, 14, function(_, go, player)
  if not (go and player) then return false end
  if not HasQuest(player) then return false end
  if Cooldown(player, 'paint', 5) then return false end

  pcall(function() player:CastSpell(go, COMMUNE, false) end)  -- "castbar" (GO target)
  player:RegisterEvent(function(_, _, _, p)
    if not (p and p:IsInWorld()) then return end
    pcall(function() p:CastSpell(p, GODDESS, true) end)
    -- obj7 je Type2 GAMEOBJECT (GO 554966) — MUSI ist cez KillGOCredit!
    -- (KilledMonsterCredit credituje LEN Type0 MONSTER, nie GAMEOBJECT)
    pcall(function() p:KillGOCredit(O_PAINT) end)

    -- Dalnir/Orweyna/Hagar reakcia
    HSeq(p, 0, {
      { npc = function() return NearCreature(p, DALNIR, 30) end, text = "What was that melody?", kit = 305547 },
      { npc = function() return NearCreature(p, ORWEYNA_CER, 30) end, text = "The Goddess!", kit = 305548 },
      { npc = function() return NearCreature(p, HAGAR_TURN, 30) end, text = "I heard it as well.", kit = 305549 },
    })
  end, 1500, 1)
  return false
end)

-- =====================================================================
-- ON 90960 COMPLETE (245097 Hagar, event 34 = ON_QUEST_REWARD; 32 neexistuje)
-- Wiki: Orweyna "Ah yes, journeys, it is time for you to go home."
--       + VYTVORI PORTAL do Stormwind (A) / Orgrimmar (H)
--       Alton "Until we meet again." (A) / Galtra "Lok'tar friend. Thank you." (H)
--       -> host prejde cez portál a zmizne.
-- 90961 sa otvori (starter 245097).
-- =====================================================================
RegisterCreatureEvent(HAGAR_TURN, 34, function(_, player, creature, quest, reward)
  if not (player and creature) then return end
  if quest then
    local ok, qid = pcall(function() return quest:GetId() end)
    if not ok or qid ~= Q then return end
  end
  if Cooldown(player, 'complete', 10) then return end

  local hx, hy, hz = POS.hagarTurn[1], POS.hagarTurn[2], POS.hagarTurn[3]
  local horde = IsHorde(player)

  -- uprac Orweynu z obj6 sceny (inak by stali 2 Orweyny pocas farewell)
  local okr, leftovers = pcall(function() return player:GetCreaturesInRange(30, ORWEYNA_CER) end)
  if okr and leftovers then
    for _, c in ipairs(leftovers) do pcall(function() c:DespawnOrUnsummon(500) end) end
  end
  local orw = SpawnAt(creature, ORWEYNA_CER, hx+2.6, hy+1.2, hz, 2.2)

  -- frakcny farewell host
  local guest, gText, gKit
  if horde then
    guest = SpawnAt(player, GALTRA, 1148.9, 1171.2, 1310.2, 0.2)
    gText = "Lok'tar friend. Thank you."
    gKit = 305567
  else
    guest = SpawnAt(player, ALTON, 1148.9, 1171.2, 1310.2, 0.2)
    gText = "Until we meet again."
    gKit = 305566
  end

  -- 1) Orweyna speaks; 2) when she has finished she casts the rootway spell and the gate appears at the user's spot;
  -- 3) only then the guest (Alton / Galtra) speaks and walks into the gate
  local gx, gy, gz, go = 1153.3019, 1168.6178, 1310.239, 4.4
  local cstarts, oend = HSeq(player, 1000, {
    { npc = orw, text = "Ah yes, journeys, it is time for you to go home.", kit = 305555, talk = true },
  })
  local portal
  player:RegisterEvent(function()
    -- Orweyna's cast: "[DNT] Rootway Burst - Portal" (1247532)
    if orw and orw:IsInWorld() then pcall(function() orw:CastSpell(orw, 1247532, true) end) end
  end, oend, 1)
  player:RegisterEvent(function()
    -- retail look: the green thorny gate is an NPC (display 131796, scale 1.5) named by faction: "Rootway to Stormwind" (9100801)
    -- or "Rootway to Orgrimmar" (9100802), clones of "Rootway to Azeroth" 248839; clickable through gossip (harandar_61.lua teleports)
    local ok, gate = pcall(function() return creature:SpawnCreature(horde and 9100802 or 9100801, gx, gy, gz, go, 3, 240000) end)
    if ok and gate then
      pcall(function() gate:SetNPCFlags(1) end)
      pcall(function() gate:SetReactState(0) end)
      pcall(function() gate:CastSpell(gate, 1247530, true) end)   -- "[DNT] Rootways - Portal" aura (visual)
      portal = gate
    end
  end, oend + 900, 1)

  if guest then
    local gstarts, gend = HSeq(player, oend + 2600, {
      { npc = guest, text = gText, kit = gKit, talk = true },
    })
    player:RegisterEvent(function()
      if guest and guest:IsInWorld() then
        pcall(function() guest:SetWalk(true) end)
        pcall(function() guest:MoveToSafe(1, gx, gy, gz) end)
      end
    end, gstarts[1] + 1500, 1)
    player:RegisterEvent(function()
      if guest and guest:IsInWorld() then pcall(function() guest:DespawnOrUnsummon(800) end) end
    end, gend + 3500, 1)
  end

  -- Dalnir and Orweyna stay beside Hagar: they are needed for the 90961 conversation ("We cannot! Tradition dictates...", "Keep the rootway open, Orweyna.")
end)

print("[harandar_90960] loaded")
