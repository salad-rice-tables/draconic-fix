-- =====================================================================
-- Quest 86653 The Path of the Amani (Amani campaign intro, Zul'Aman)
--
-- Sources:
--   Warcraft Wiki "The Path of the Amani" (Notes / Stay awhile and listen)
--   hotfixes.broadcast_text build 66102
--   SoundKitEntry_12.1.5.70391.csv -> KIT_LEN (durations)
--
-- Real scene actors (not the autofill bank entries):
--   Zul'jarra 240186 phase 45658 (4226.60 -7566.59 168.30)
--   Zul'jarra 236126 phase 45677 (4226.52 -7565.90 168.30)
--   Kinduru   244479 phase 45658 (4219.37 -7559.10 167.69)
--   Kinduru   245720 phase 45677 (4220.58 -7546.64 167.69)
--   Zul'jarra 236140 phase 45659 (4078.83 -8261.61 226.40) = Akil'zon's Reach
--
-- Flow:
--   accept 86653 from Zul'jarra 240186/236126 -> Kinduru + Zul'jarra accept lines
--   gossip Kinduru -> "<Stay awhile and listen.>" -> 13-line story, KC 245697
--   gossip/turn in at Zul'jarra 236140 -> the gnarldin line (BT 283656)
--
-- No SQL: the gossip option is built in Eluna, so no DB rows are changed.
-- =====================================================================
if IS_WORLD_STATE or not MAP_Timer then return end

local Q = 86653
local ST_COMPLETE, ST_INCOMPLETE = 1, 3

local ZUL = { 240186, 236126, 236140 }
-- Only the two Kinduru actors co-located with Zul'jarra at the 86653 scene;
-- 237301/253804 are later-phase / autofill-bank NPCs and would play the story
-- in the wrong place.
local KIND = { 244479, 245720 }
local KIND_MENU = { [244479] = 39276, [245720] = 912046811 }

local ZUL_X, ZUL_Y, ZUL_Z, ZUL_O = 4226.52, -7565.90, 168.30, 5.50335
local KIND_X, KIND_Y, KIND_Z, KIND_O = 4219.37, -7559.10, 167.687, 5.51658

local FLAG = {}

-- ---------------------------------------------------------------- helpers
local function GUID(p) return tostring(p:GetGUID()) end
local function Name(p)
    local ok, n = pcall(function() return p:GetName() end)
    return ok and n or "friend"
end
local function Status(p, q)
    local ok, s = pcall(function() return p:GetQuestStatus(q) end)
    return ok and s or 0
end
local function Active(p) return Status(p, Q) == ST_INCOMPLETE end
local function Once(p, tag)
    local k = GUID(p) .. ":" .. tag
    if FLAG[k] then return false end
    FLAG[k] = true
    return true
end
local function Clear(p, tag) FLAG[GUID(p) .. ":" .. tag] = nil end
local function After(p, ms, fn)
    pcall(function()
        p:RegisterEvent(function() pcall(fn) end, math.max(0, math.floor(ms)), 1)
    end)
end
local function Near(p, entry, range)
    local ok, list = pcall(function() return p:GetCreaturesInRange(range or 40, entry) end)
    if ok and list then return list[1] end
    return nil
end
local function SpawnAt(src, entry, x, y, z, o, ms)
    local ok, c = pcall(function() return src:SpawnCreature(entry, x, y, z, o or 0, 8, 0) end)
    if ok and c and ms then pcall(function() c:DespawnOrUnsummon(ms) end) end
    return ok and c or nil
end
local function Say(c, text, kit, p)
    if not c then return end
    local n = Name(p)
    text = text:gsub("%$[nN]", n):gsub("<[Nn]ame>", n)
    pcall(function() c:SendUnitSay(text, 0) end)
    if kit and kit > 0 and p then pcall(function() c:PlayDistanceSound(kit, p) end) end
end
local function Dur(text, kit, gap)
    local ok, n = pcall(function() return KIT_LEN and KIT_LEN[kit] end)
    if ok and n then return math.floor(n * 1000) + (gap or 800) end
    return math.max(1800, math.min(10000, #text * 55 + 600))
end
local function Seq(p, steps)
    local t = 0
    for _, s in ipairs(steps) do
        local at, spk, txt, kit = t, s[1], s[2], s[3]
        After(p, at, function() Say(spk, txt, kit, p) end)
        t = t + Dur(txt, kit, s[4])
    end
    return t
end
local function Credit(p, entry) pcall(function() p:KilledMonsterCredit(entry) end) end
local function Msg(p, text) pcall(function() p:SendBroadcastMessage(text) end) end
local function ActiveFor(p, q) return Status(p, q) == ST_INCOMPLETE end

local function ZulNear(p)
    for _, e in ipairs(ZUL) do
        local c = Near(p, e, 40)
        if c then return c end
    end
    return nil
end
local function KindNear(p)
    for _, e in ipairs(KIND) do
        local c = Near(p, e, 40)
        if c then return c end
    end
    return nil
end

-- ---------------------------------------------------------------- dialogue
-- kind = Kinduru, zul = Zul'jarra. Texts are exactly broadcast_text Text/Text1.
local ACCEPT = {
    { "K", "Light de shrines on your way to de temple. And don't forget to leave Akil'zon an offerin'!", 307224 },
    { "Z", "De temple be overrun with gnarldin. Killin' dem will help us pass de time on de way. Come, \"hash'ura.\"", 307225 },
}

local STORY = {
    { "Z", "Uncle, de loa haven't spoken to you in years. Why you think dey will speak to us now?", 307227 },
    { "K", "You did not know de world with de loa in it, my child. Dey were our strength. Our hope.", 307228 },
    { "K", "Akil'zon bestowed on me a great honor when she made me her speaker.", 307229 },
    { "K", "I tried to instill in de both of you--you and Zul'jan--a love for de loa.", 307230 },
    { "Z", "I remember de stories about Akil'zon, Halazzi, Jan'alai, and Nalorakk, and how dey protected us.", 307231 },
    { "Z", "I loved listenin' to your stories, uncle. But even then I wondered if they were true.", 307232 },
    { "K", "How much do you remember about goin' to Akil'zon's temple?", 307233 },
    { "Z", "We climbed to de temple. Zul'jan fell. I did not get de loa's blessin'. And my mother died.", 307234 },
    { "K", "You saved your brother. And you defended your right to lead as Zul'jin's granddaughter--all on your own.", 307235 },
    { "K", "If anyone can get to de loa and get answers, it is you.", 307236 },
    { "Z", "As de \"hash'ey?\" I'm no priestess. No mystic or uniter.", 307237 },
    { "K", "No, my Jarra. As my niece. Because I know you have de fire. And I love you more than anythin'.", 307238 },
    { "Z", "Den I will go. For our people and for you, uncle.", 307239 },
}

local REACH_TEXT = "De Twilight's Blade pushed de gnarldin into our territory. We will have to fight through dem to get to de temple."
local REACH_KIT = 307226

-- ---------------------------------------------------------------- flows
local function StartAccept(p, zul)
    After(p, 1000, function()
        local kind = KindNear(p) or SpawnAt(p, 244479, KIND_X, KIND_Y, KIND_Z, KIND_O, 240000)
        local t = 0
        for _, s in ipairs(ACCEPT) do
            local spk = (s[1] == "K") and kind or zul
            local txt, kit = s[2], s[3]
            After(p, t, function() Say(spk, txt, kit, p) end)
            t = t + Dur(txt, kit, 900)
        end
    end)
end

local function StartStory(p, kind)
    local zul = ZulNear(p) or SpawnAt(p, 240186, ZUL_X, ZUL_Y, ZUL_Z, ZUL_O, 240000)
    if zul and kind then
        pcall(function() zul:SetFacingToObject(kind) end)
        pcall(function() kind:SetFacingToObject(zul) end)
    end
    local steps = {}
    for _, s in ipairs(STORY) do
        steps[#steps + 1] = { (s[1] == "K") and kind or zul, s[2], s[3] }
    end
    local t = Seq(p, steps)
    After(p, t + 900, function()
        Credit(p, 245697) -- Stay awhile and listen (optional)
        Msg(p, "|cff00ff00Kinduru has told you of the loa.|r Meet Zul'jarra at Akil'zon's Reach.")
    end)
end

-- ---------------------------------------------------------------- 86653 accept
for _, entry in ipairs({ 240186, 236126 }) do
    RegisterCreatureEvent(entry, 31, function(_, player, creature, quest)
        if not quest or quest:GetId() ~= Q then return end
        Clear(player, "86653_scene")
        Clear(player, "86653_reach")
        StartAccept(player, creature)
    end)
end

-- ---------------------------------------------------------------- Kinduru gossip
for entry, menu in pairs(KIND_MENU) do
    RegisterCreatureGossipEvent(entry, 1, function(_, player, creature)
        if not Active(player) then return end
        if FLAG[GUID(player) .. ":86653_scene"] then return end
        pcall(function()
            player:GossipClearMenu()
            player:GossipMenuAddItem(0, "<Stay awhile and listen.>", 0, 1)
            player:GossipSendMenu(1, creature)
        end)
        return false
    end)

    RegisterCreatureGossipEvent(entry, 2, function(_, player, creature, sender, intid)
        if intid ~= 1 then return end
        if not Active(player) then return end
        if not Once(player, "86653_scene") then return end
        pcall(function() player:GossipComplete() end)
        StartStory(player, creature)
        return false
    end)
end

-- ---------------------------------------------------------------- Akil'zon's Reach
RegisterCreatureGossipEvent(236140, 1, function(_, player, creature)
    if Status(player, Q) ~= ST_COMPLETE then return end
    if not Once(player, "86653_reach") then return end
    After(player, 600, function() Say(creature, REACH_TEXT, REACH_KIT, player) end)
end)

RegisterCreatureEvent(236140, 34, function(_, player, creature, quest)
    if not quest or quest:GetId() ~= Q then return end
    if not Once(player, "86653_reach") then return end
    After(player, 600, function() Say(creature, REACH_TEXT, REACH_KIT, player) end)
end)

-- ---------------------------------------------------------------- 86659 Breaching the Mist
-- Scenes from Warcraft Wiki "Breaching the Mist" (Notes). The escort itself and
-- the shrine gameobjects are missing from the world DB (only DNT kill credits
-- 245861/245863-245865/245871 exist); the accept and the two regroup lines are
-- therefore the only parts we can trigger safely.
local Q_MIST = 86659
local LIADRIN = 236158
local MIST_X, MIST_Y, MIST_Z = 6214.0, -6931.0, 222.0

local function LiadrinNear(p)
    return Near(p, 236158, 40) or Near(p, 236154, 40) or Near(p, 236128, 40)
end

RegisterCreatureEvent(244588, 31, function(_, player, creature, quest)
    if not quest or quest:GetId() ~= Q_MIST then return end
    Clear(player, "86659_shrine")
    Clear(player, "86659_end")
    After(player, 900, function()
        local liadrin = LiadrinNear(player) or
            SpawnAt(player, LIADRIN, MIST_X + 3, MIST_Y, MIST_Z, 5.5, 120000)
        local steps = {
            { liadrin, "What do we do now? This mist is... impenetrable.", 307300 },
            { creature, "We push forward. De hash'ey shrines will lead us to de Temple of Halazzi.", 307302 },
        }
        Seq(player, steps)
    end)
end)

-- Only the one Loa Incense that exists in the DB can fire the first-shrine bark.
-- The real Ancient Incense objects around the temple are absent, so this is a
-- best-effort trigger and is gated on the quest being active.
RegisterGameObjectEvent(516295, 14, function(_, _, player)
    if not ActiveFor(player, Q_MIST) then return end
    if not Once(player, "86659_shrine") then return end
    local ok, px, py, pz = pcall(function() return player:GetX(), player:GetY(), player:GetZ() end)
    if not ok or not px then px, py, pz = 6146, -6815, 236 end
    local liadrin = SpawnAt(player, LIADRIN, px + 2, py, pz, 5.5, 90000)
    local zul = SpawnAt(player, 244588, px - 2, py, pz, 5.5, 90000)
    Seq(player, {
        { liadrin, "A hash'ey shrine. Like those we lit near the Temple of Akil'zon.", 307304 },
        { zul, "Dat means we are close. Do you feel like we bein' watched?", 307306 },
    })
end)

RegisterCreatureGossipEvent(236155, 1, function(_, player, creature)
    if Status(player, Q_MIST) ~= ST_COMPLETE then return end
    if not Once(player, "86659_end") then return end
    After(player, 600, function()
        Say(creature, "You mean you were saved from de Vilebranch by de mist? Not lost in it?", 307307, player)
    end)
end)

RegisterCreatureEvent(236155, 34, function(_, player, creature, quest)
    if not quest or quest:GetId() ~= Q_MIST then return end
    if not Once(player, "86659_end") then return end
    After(player, 600, function()
        Say(creature, "You mean you were saved from de Vilebranch by de mist? Not lost in it?", 307307, player)
    end)
end)

print("[path_of_the_amani] loaded")
