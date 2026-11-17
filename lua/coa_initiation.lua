-- Necromancer initiation campaign (Valley of Trials -> custom Maldraxxus).
-- Flow:  Zal'thira gives Q1 -> reach the cave (quest becomes ready) -> Tome gossip (journal pages) turns Q1 in and gives Q2 (the corpse becomes lootable)
--        -> loot Vex'thal, equip the whole Maldraxxi Initiate set + staff -> Q2 completes by itself and Q3 starts -> touch the crystal (essence unlocked, portal appears)
--        -> use the portal (Q3 objective) -> Korthaz turns Q3 in (gossip) and gives Q4 "Report to the Archon".
-- Locations: lua/coa_init_config.lua (from data/necro_init/locations.json).  Progress: characters.coa_initiation(guid, stage, essence).
-- stage: 0 new, 1 Q1 done (Q2 active), 2 gear equipped (Q3 active), 3 crystal touched, 4 in Maldraxxus, 5 Q3 turned in (Q4 active)
local CAPTURE = "C:/WowServer/Custom/data/necro_init/captured.txt"
if IS_WORLD_STATE then   -- command hooks fire in the world Lua state
    RegisterPlayerEvent(42, function(_, player, command)
        local a = {}
        for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
        if string.lower(a[1] or "") ~= "ni" or player:GetGMRank() < 1 then return end
        local sub = string.lower(a[2] or "")
        local x, y, z, o = player:GetLocation()
        local line = string.format("%d %.3f %.3f %.3f %.3f", player:GetMapId(), x, y, z, o)
        if sub == "pos" then player:SendBroadcastMessage("[ni] map x y z o = " .. line)
        elseif sub == "here" and a[3] then
            local f = io.open(CAPTURE, "a")
            if f then f:write(a[3] .. " " .. line .. "\n"); f:close(); player:SendBroadcastMessage("[ni] saved '" .. a[3] .. "' = " .. line)
            else player:SendBroadcastMessage("[ni] cannot write: " .. line) end
        elseif sub == "stage" and a[3] then
            CharDBExecute(string.format("REPLACE INTO characters.coa_initiation (guid, stage, essence) VALUES (%s, %d, 0)", tostring(player:GetGUIDLow()), tonumber(a[3])))
            player:SendBroadcastMessage("[ni] stage = " .. a[3])
        else player:SendBroadcastMessage("[ni] .ni pos | .ni here <key> | .ni stage <n>") end
        return false
    end)
end
if IS_WORLD_STATE or not COA_SLOT_KEY then return end
COA_INIT = COA_INIT or {phase = {valley = 28813, maldraxxus = 26653, portal = 26556}, loc = {}}

local Q1, Q2, Q3, Q4, Q5 = 9330011, 9330012, 9330013, 9330014, 9330015
local TOME, CRYSTAL, PORTAL, KORTHAZ, CORPSE, ARCHON = 322354, 5080290, 376885, 163243, 161180, 9330301
local AURA = {valley = 7990101, maldraxxus = 7990102, portal = 7990105}
-- equipment slot -> item entry (the loot of the corpse)
local SET = {[0] = 9330101, [2] = 9330102, [4] = 9330103, [8] = 9330104, [9] = 9330105, [5] = 9330106, [6] = 9330107, [7] = 9330108, [14] = 9330109, [15] = 9330110}

local function IsNecro(p) return COA_KEY(p) == "necromancer" end
local function G(p) return tostring(p:GetGUIDLow()) end
pcall(CharDBExecute, "CREATE TABLE IF NOT EXISTS characters.coa_initiation (guid INT UNSIGNED NOT NULL PRIMARY KEY, stage TINYINT UNSIGNED NOT NULL DEFAULT 0, essence TINYINT UNSIGNED NOT NULL DEFAULT 0, updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)")
local function Row(p)
    local q = CharDBQuery("SELECT stage, essence FROM characters.coa_initiation WHERE guid = " .. G(p))
    if q then return q:GetUInt32(0), q:GetUInt32(1) end
    return 0, 0
end
local ESS = {}   -- guid -> 0/1 cache: CapOf asks every second
local function Set(p, stage, essence)
    local s, e = Row(p)
    if essence then ESS[G(p)] = essence end
    CharDBExecute(string.format("REPLACE INTO characters.coa_initiation (guid, stage, essence) VALUES (%s, %d, %d)", G(p), stage or s, essence or e))
end
function CoaEssenceUnlocked(p) local k = G(p); if ESS[k] == nil then local _, e = Row(p); ESS[k] = e end; return ESS[k] == 1 end

local function Say(p, text) PrintInfo("[ni] " .. text) end   -- player-facing text lives in gossip pages (coa_init_texts.lua)
local function Go(p, key)
    local l = COA_INIT.loc[key]
    if not l then Say(p, "[Initiation] '" .. key .. "' is not configured (data/necro_init/locations.json)."); return false end
    p:Teleport(l.map, l.x, l.y, l.z, l.o or 0)
    return true
end
local function Try(what, f) local ok, e = pcall(f); if not ok then PrintError("[ni] " .. what .. ": " .. tostring(e)) end end
local function Give(p, q)
    PrintInfo(string.format("[ni] Give %d status=%d has=%s", q, p:GetQuestStatus(q), tostring(p:HasQuest(q))))
    if p:GetQuestStatus(q) == 0 and not p:HasQuest(q) then AddQuestLater(p, q) end
end
local function Done(p, q)   -- complete and turn in
    Try("CompleteQuest", function() p:CompleteQuest(q) end)
    Try("RewardQuest", function() p:RewardQuest(q, 0) end)   -- arg 2 (loot item type) is required in this Eluna
    PrintInfo(string.format("[ni] Done %d -> status=%d", q, p:GetQuestStatus(q)))
end

-- ---------------------------------------------------------------- phasing (only near the campaign spots, so the normal world stays visible)
local function Phase(p, name, on)
    local id = AURA[name]
    if on and not p:HasAura(id) then p:AddAura(id, p) elseif not on and p:HasAura(id) then p:RemoveAura(id) end
end
local function Near(p, key, r)
    local l = COA_INIT.loc[key]
    return l and p:GetMapId() == l.map and p:GetDistance(l.x, l.y, l.z) < r
end
local KSAID = {}
local function SyncPhases(p)
    if not p or not p:IsInWorld() then return end
    if not IsNecro(p) then for k in pairs(AURA) do Phase(p, k, false) end return end
    local stage = Row(p)
    local nearValley = Near(p, "vexthal_corpse", 80) or Near(p, "tome", 80) or Near(p, "anima_crystal", 80) or Near(p, "valley_portal", 80)
    Phase(p, "valley", nearValley and stage < 99)
    Phase(p, "portal", nearValley and stage >= 3)
    Phase(p, "maldraxxus", Near(p, "maldraxxus_arrival", 600) and stage >= 3)
    -- Q1 objective: arriving at the cave readies the quest for turn in at the Tome
    if stage == 0 and p:HasQuest(Q1) and p:GetQuestStatus(Q1) ~= 1 and Near(p, "tome", 15) then
        pcall(function() p:CompleteQuest(Q1) end)
        Say(p, "[Quest updated] You have found the source of the disturbance. Examine the Tome of Oblivion.")
    end
    if stage == 4 and Near(p, "korthaz", 30) and not KSAID[G(p)] then
        KSAID[G(p)] = true
        local c = p:GetNearestCreature(40, KORTHAZ)
        if c then pcall(function() c:PerformEmote(1); c:SendUnitSay("Vex'thal? You are back already? Three days only... and you walk out of the gateway alive. Speak - what of the crystal?", 0) end) end
    end
    -- Q3 objective: reaching Korthaz in Maldraxxus; he takes the turn in natively (quest ender) and offers Q4
    if stage == 4 and p:GetQuestStatus(Q3) == 3 and Near(p, "korthaz", 30) then
        pcall(function() p:CompleteQuest(Q3) end)
    elseif stage == 4 and p:GetQuestStatus(Q3) == 6 then Set(p, 5) end
    -- Q4 objective: reaching the Archon; he takes the turn in natively (quest ender)
    if stage == 5 and p:GetQuestStatus(Q4) == 3 and COA_SCENE then COA_SCENE.Tick(p) end   -- scene lives in coa_initiation_scene.lua
    -- Q4 handed in -> Q5 (placeholder: training starts, report back to Korthaz) -> stage 6
    if stage == 5 and p:GetQuestStatus(Q4) == 6 then Set(p, 6); AddQuestLater(p, Q5) end
    if stage == 6 and p:GetQuestStatus(Q5) == 3 and Near(p, "korthaz", 30) then
        pcall(function() p:CompleteQuest(Q5) end)
    end
end
-- Campaign notification: a Necromancer who has not taken the first quest yet is told where it is (the quest giver wears the campaign "!")
RegisterPlayerEvent(28, function(_, player)
    player:RegisterEvent(function(_, _, _, p)
        if not (p and p:IsInWorld() and IsNecro(p)) then return end
        if Row(p) == 0 and p:GetQuestStatus(Q1) == 0 and not p:HasQuest(Q1) then
            pcall(function() p:SendAreaTriggerMessage("New campaign quest: A Disturbance on a Hidden Path") end)
            p:SendBroadcastMessage("|cff3df2c8[Necromancer Campaign]|r A Disturbance on a Hidden Path - speak to Zal'thira to accept it.")
        end
    end, 7000, 1)
end)

MAP_Timer("coa_initiation_phases", function() for _, p in ipairs(MAP_Players()) do pcall(SyncPhases, p) end end, 3000)   -- survives .reload eluna

-- ---------------------------------------------------------------- gossip helper (a fresh menu id each time, otherwise the client keeps the old page)
local MENU_SEQ = 9330000
local function Menu(p, obj, key, rows, who)   -- one gossip page: text key from coa_init_texts.lua + option rows
    p:GossipClearMenu()
    for i, r in ipairs(rows) do p:GossipMenuAddItem(0, r, who, i) end
    MENU_SEQ = MENU_SEQ + 1
    p:GossipSendMenu(COA_INIT_TEXT[key], obj, MENU_SEQ)
end

-- ---------------------------------------------------------------- Tome of Oblivion: journal pages
local PAGE = {}   -- guid -> page number being read
local PAGES = {{"day1", "Read the next entry."}, {"day2", "Read the next entry."}, {"day3", "Close the journal."}}
local function TomeHello(_, p, obj)
    local stage = Row(p)
    if not IsNecro(p) then Menu(p, obj, "tome_stranger", {}, TOME); return end
    if stage ~= 0 then Menu(p, obj, "tome_done", {}, TOME); return end
    if p:GetQuestStatus(Q1) ~= 1 then Menu(p, obj, "tome_locked", {}, TOME); return end
    PAGE[G(p)] = 0
    Menu(p, obj, "tome_intro", {"Open the journal."}, TOME)
end
local function TomeSelect(_, p, obj)
    local page = PAGE[G(p)]
    if not page or Row(p) ~= 0 then p:GossipComplete(); return end
    if page < #PAGES then
        page = page + 1; PAGE[G(p)] = page
        Menu(p, obj, PAGES[page][1], {PAGES[page][2]}, TOME)
        return
    end
    p:GossipComplete()
    PAGE[G(p)] = nil
    Done(p, Q1)
    Set(p, 1, 1)   -- Life Force is granted by the first quest (the Tome turn-in); the crystal later only plays the awakening
    pcall(function() p:SendAddonMessage("COAUI", "LFUNLOCK", 7, p) end)   -- CoAUI plays the unlock effect
    Give(p, Q2)
    -- the corpse becomes a real lootable corpse: the player's own killing blow taps it
    local ok, list = pcall(function() return p:GetCreaturesInRange(60, CORPSE) end)
    for _, c in ipairs(ok and list or {}) do
        if c:IsAlive() then Try("DealDamage", function() p:DealDamage(c, 4000000000, false) end); break end
    end
end
RegisterGameObjectGossipEvent(TOME, 1, TomeHello)
RegisterGameObjectGossipEvent(TOME, 2, TomeSelect)

-- ---------------------------------------------------------------- equipping the whole set completes Q2 and starts Q3
local function CheckSet(p)
    if not p or not p:IsInWorld() or not IsNecro(p) or Row(p) ~= 1 then return end
    for slot, entry in pairs(SET) do
        local it = p:GetItemByPos(255, slot)
        if not it or it:GetEntry() ~= entry then return end
    end
    Say(p, "[Quest updated] You wear the complete set of the fallen Necromancer.")
    Done(p, Q2)
    Set(p, 2)
    Give(p, Q3)
    Say(p, "[Quest] Touch the Anima Crystal.")
end
RegisterPlayerEvent(29, function(_, player) player:RegisterEvent(function(_, _, _, p) CheckSet(p) end, 600, 1) end)   -- ON_EQUIP

-- ---------------------------------------------------------------- Anima Crystal: the awakening
local function CrystalHello(_, p, obj)
    local stage = Row(p)
    if not IsNecro(p) or stage < 2 then Menu(p, obj, "crystal_locked", {}, CRYSTAL); return end
    if stage >= 3 then Menu(p, obj, "crystal_known", {}, CRYSTAL); return end
    Menu(p, obj, "crystal_intro", {"Touch the crystal."}, CRYSTAL)
end
local function CrystalSelect(_, p, obj)
    if not IsNecro(p) or Row(p) ~= 2 then p:GossipComplete(); return end   -- once per character
    Set(p, 3, 1)                                         -- stage first so a double click cannot repeat it; Life Force unlocked here
    pcall(function() p:SendAddonMessage("COAUI", "LFUNLOCK", 7, p) end)   -- CoAUI plays the unlock effect
    pcall(function() p:SetAchievement(9011001) end)      -- Touched by Death
    pcall(function()                                      -- crystal turns into the awakened model (overlay object, original rests 60 s)
        p:SummonGameObject(354682, obj:GetX(), obj:GetY(), obj:GetZ(), obj:GetO(), 60)
        obj:SetLootState(3); obj:SetRespawnTime(60)
    end)
    Phase(p, "portal", true)
    Menu(p, obj, "crystal_touch", {}, CRYSTAL)
end
RegisterGameObjectGossipEvent(CRYSTAL, 1, CrystalHello)
RegisterGameObjectGossipEvent(CRYSTAL, 2, CrystalSelect)

-- ---------------------------------------------------------------- portal (both directions)
local function PortalHello(_, p, obj)
    local stage = Row(p)
    if not IsNecro(p) or stage < 3 then return end
    if Near(p, "maldraxxus_arrival", 600) then
        Menu(p, obj, "portal_out", {"Return to the Valley of Trials."}, PORTAL)
    else
        Menu(p, obj, "portal_in", {"Enter Maldraxxus."}, PORTAL)
    end
end
local function PortalSelect(_, p, obj)
    p:GossipComplete()
    local stage = Row(p)
    if not IsNecro(p) or stage < 3 then return end
    if Near(p, "maldraxxus_arrival", 600) then
        Go(p, "return_destination")
    else
        if stage == 3 then Set(p, 4) end   -- before the teleport: a cross-map teleport invalidates p in this Lua state
        Phase(p, "maldraxxus", true)
        Go(p, "maldraxxus_arrival")
    end
end
RegisterGameObjectGossipEvent(PORTAL, 1, PortalHello)
RegisterGameObjectGossipEvent(PORTAL, 2, PortalSelect)

-- ---------------------------------------------------------------- Korthaz: waits on the other side, takes the player for Vex'thal
local KOR = {"kor_1", "kor_2", "kor_3"}
local KROWS = {"I have returned.", "What was the purpose of the expedition?", "What happened to the expedition?"}
local function KorthazMenu(p, c, key)
    p:GossipClearMenu()
    local rows = {table.unpack(KROWS)}
    if Row(p) == 4 then rows[#rows + 1] = "I came through the gateway. (Complete quest)" end
    local offer = Row(p) == 5 and p:GetQuestStatus(Q4) == 0 and not p:HasQuest(Q4)
    if Row(p) >= 5 then rows = {} end
    for i, r in ipairs(rows) do p:GossipMenuAddItem(0, r, KORTHAZ, i) end
    if offer then p:GossipAddQuests(c) end   -- Initiation of Death through the native quest entry (a real quest giver, so accepting works)
    MENU_SEQ = MENU_SEQ + 1
    p:GossipSendMenu(COA_INIT_TEXT[key], c, MENU_SEQ)
end
local function KorthazHello(_, p, c)
    if not IsNecro(p) then Menu(p, c, "kor_stranger", {}, KORTHAZ); return end
    KorthazMenu(p, c, Row(p) >= 5 and "kor_4" or "kor_hello")
end
local function KorthazSelect(_, p, c, sender, intid)
    if KOR[intid] and Row(p) < 5 then KorthazMenu(p, c, KOR[intid]); return end
    if intid == 4 and Row(p) == 4 then
        Done(p, Q3)
        Set(p, 5)
        KorthazMenu(p, c, "kor_4")   -- Q4 is now offered by Korthaz himself (menu option / quest marker)
    else p:GossipComplete() end
end
RegisterCreatureEvent(KORTHAZ, 31, function(_, p, c, q)   -- Initiation of Death accepted: the arrival scene starts
    if q and q:GetId() == Q4 and COA_SCENE then COA_SCENE.Reset(p) end
end)
RegisterCreatureGossipEvent(KORTHAZ, 1, KorthazHello)
RegisterCreatureGossipEvent(KORTHAZ, 2, KorthazSelect)
-- ---------------------------------------------------------------- Archon Vel'moth: quest end through gossip
local function ArchonHello(_, p, c)
    p:GossipClearMenu()
    if IsNecro(p) and Row(p) == 5 and COA_SCENE and COA_SCENE.Phase(p) >= 2 then
        if p:GetQuestStatus(Q4) == 3 then pcall(function() p:KilledMonsterCredit(9330323) end) end   -- objective 3: report to the Archon
        if p:GetQuestStatus(Q4) == 1 then p:GossipMenuAddItem(0, "I have witnessed the initiation. (Complete quest)", ARCHON, 1) end
    end
    MENU_SEQ = MENU_SEQ + 1
    p:GossipSendMenu(COA_INIT_TEXT["archon_hello"] or COA_INIT_TEXT["kor_hello"], c, MENU_SEQ)
end
local function ArchonSelect(_, p, c, sender, intid)
    p:GossipComplete()
    if intid == 1 and Row(p) == 5 and p:GetQuestStatus(Q4) == 1 then Done(p, Q4) end   -- SyncPhases then moves stage 5 -> 6 and hands out Q5
end
RegisterCreatureGossipEvent(ARCHON, 1, ArchonHello)
RegisterCreatureGossipEvent(ARCHON, 2, ArchonSelect)
-- Zal'thira: Talk emote + line when the first quest is accepted
RegisterCreatureEvent(139829, 31, function(_, p, c, q)
    if q and q:GetId() == Q1 then pcall(function() c:PerformEmote(1); c:SendUnitSay("Follow the Hidden Path beyond the Valley of Trials. Something dead has stirred there, and it is not ours.", 0) end) end
end)
print("[coa_initiation] loaded")
