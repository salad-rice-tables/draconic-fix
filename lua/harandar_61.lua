-- =====================================================================
-- Harandar: Stranger in a New Land (90961) a Choose a Path (94444/94445)
-- Spec: Obsidian vault "Harandar moje info/Initiation Day.md"
--   Hagar gossip "You have been marked by the goddess <name>..." (2 quest buttons) ->
--   kredit "Talk to Hagar about the Ceremony" (246603) + dialog (kity 305560-305564)
--   Rootway to Stormwind/Orgrimmar (GO 547188 / 547190): klik = teleport + kredit "Enter the rootway" (246596)
--   Stormwind Embassy: Alton Parsons (305565), Ambassador Moorgard sa pokloni, odovzdanie 90961,
--   Alton po 3 s "It is time to get back to my duties..." a odide
--   Choose a Path: Chromie TALKTO kredit riesi SAI akcia 153 (20261019_harandar_chromie.sql)
-- =====================================================================
if IS_WORLD_STATE or not MAP_Timer then return end

function HDBG(msg)
    local f = io.open("C:/WowServer/Custom/data/harandar_debug.txt", "a")
    if f then f:write(os.date("%H:%M:%S "), tostring(msg), "\n"); f:close() end
end

-- Sequenced NPC lines: every line starts when the previous one has been spoken to the end (length of its soundkit in
-- harandar_kit_len.lua) plus a short pause. lines = { {npc = creature | function, text, kit, talk = true, gap = ms}, ... }.
-- Returns the start time (ms) of every line and the end time of the whole sequence, so walks / credits can hang on it.
function HSeq(p, start, lines)
    local starts, t = {}, start
    for i, l in ipairs(lines) do
        starts[i] = t
        pcall(function()
            p:RegisterEvent(function()
                local c = l.npc
                if type(c) == "function" then c = c() end
                if not c then return end
                if l.talk then pcall(function() c:PerformEmote(1) end) end
                pcall(function() c:SendUnitSay(l.text, 0) end)
                if l.kit then pcall(function() c:PlayDirectSound(l.kit, p) end) end
                if HDBG then HDBG('seq ' .. tostring(l.text)) end
            end, t, 1)
        end)
        t = t + math.floor((((KIT_LEN and KIT_LEN[l.kit]) or 3.0) * 1000)) + (l.gap or 800)
    end
    return starts, t
end

local Q61 = 90961
local ST_COMPLETE, ST_INCOMPLETE = 1, 3
local HAGAR, DALNIR, ALTON, MOORGARD = 245097, 245102, 245104, 133362
local ROOTWAY_A, ROOTWAY_H = 547188, 547190
local C_TALK, C_ROOT = 246603, 246596

local SW_ARRIVAL = { 0, -8190.446, 779.71356, 72.432396, 0.5 }
local SW_ALTON   = { -8176.6123, 801.69366, 74.10984, 4.0 }
local SW_NEAR    = { -8180.497, 791.47656 }
local SW_LEAVE   = { {-8180.4575, 792.6426, 73.933846}, {-8183.774, 787.98444, 73.43865} }
local ORG_ARRIVAL = { 1, 1558.0, -4196.0, 53.7, 3.0 }   -- Orgrimmar, next to Ambassador Blackguard (position estimated)

local Flag = {}
local function K(p) return tostring(p:GetGUID()) end
local function Status(p, q)
    local ok, s = pcall(function() return p:GetQuestStatus(q) end)
    return ok and s or 0
end
local function Once(p, tag)
    local f = K(p) .. ":" .. tag
    if Flag[f] then return false end
    Flag[f] = true
    return true
end
local function Clear(p, tag) Flag[K(p) .. ":" .. tag] = nil end
local function Credit(p, entry) pcall(function() p:KilledMonsterCredit(entry) end) end
local function Say(c, text, kit, p)
    HDBG('say[61] ' .. tostring(text) .. ' c=' .. tostring(c))
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
local function After(p, ms, fn) pcall(function() p:RegisterEvent(function() pcall(fn) end, ms, 1) end) end
local function IsHorde(p)
    local ok, v = pcall(function() return p:IsHorde() end)
    return ok and v or false
end
local function Dist2(p, x, y)
    local px, py = p:GetLocation()
    return math.sqrt((px - x) ^ 2 + (py - y) ^ 2)
end

-- ---------------------------------------------------------------- Hagar: "Talk to Hagar about the Ceremony"
local OPT_MINE, OPT_STAY = 909801, 909802
-- called from the single hello hook of Hagar (harandar_90960.lua), so only one handler answers and decides about the default menu
function H61Hello(player, creature)
    if Status(player, Q61) ~= ST_INCOMPLETE or Flag[K(player) .. ":talk61"] then return false end
    pcall(function() player:GossipClearMenu() end)
    pcall(function() player:GossipMenuAddItem(2, "My journey is my own.", creature:GetEntry(), OPT_MINE) end)
    pcall(function() player:GossipMenuAddItem(2, "But I want to stay here. With our people.", creature:GetEntry(), OPT_STAY) end)
    pcall(function() player:GossipSendMenu(1000000014, creature) end)
    return true
end
RegisterCreatureGossipEvent(HAGAR, 2, function(_, player, creature, sender, intid)
    if intid ~= OPT_MINE and intid ~= OPT_STAY then return false end
    pcall(function() player:GossipComplete() end)
    if Status(player, Q61) ~= ST_INCOMPLETE then return true end
    if intid == OPT_STAY then
        Say(creature, "The goddess has chosen you. Her song will not wait.", nil, player)   -- text not on Wowhead: neutral line
        return true
    end
    if not Once(player, "talk61") then return true end
    Credit(player, C_TALK)
    local name = player:GetName()
    HSeq(player, 0, {
        { npc = creature, text = "Keep the rootway open, Orweyna.", kit = 305560, talk = true },
        { npc = creature, text = "The outsider, the song, everything that happened here today --", kit = 305561 },
        { npc = function() return Near(player, DALNIR, 30) end, text = "We cannot! Tradition dictates that we remain in Harandar!", kit = 305562, talk = true },
        { npc = creature, text = "Tradition dictates that we follow the goddess' song, Dalnir.", kit = 305563, talk = true },
        { npc = creature, text = name .. ", follow the visions. Follow your heart. Find the Goddess.", kit = 305564 },
    })
    return true
end)

-- ---------------------------------------------------------------- Rootway: kredit "Enter the rootway" + teleport
local function Rootway(_, go, player)
    if not (go and player) then return false end
    if Status(player, Q61) ~= ST_INCOMPLETE then return true end
    local dest = IsHorde(player) and ORG_ARRIVAL or SW_ARRIVAL
    Credit(player, C_ROOT)
    pcall(function() player:Teleport(dest[1], dest[2], dest[3], dest[4], dest[5]) end)
    return true
end
RegisterGameObjectEvent(ROOTWAY_A, 14, Rootway)
RegisterGameObjectEvent(ROOTWAY_H, 14, Rootway)
-- the visual gates are NPCs "Rootway to Stormwind" / "Rootway to Orgrimmar" (9100801 / 9100802): click = gossip hello = same behaviour
for _, gateEntry in ipairs({ 9100801, 9100802 }) do
    RegisterCreatureGossipEvent(gateEntry, 1, function(_, player, gate)
        if Status(player, Q61) ~= ST_INCOMPLETE then return false end
        Rootway(nil, gate, player)
        pcall(function() player:GossipComplete() end)
        return true
    end)
end

-- ---------------------------------------------------------------- Stormwind Embassy scene
RegisterCreatureEvent(MOORGARD, 34, function(_, player, creature, quest)
    local ok, id = pcall(function() return quest:GetId() end)
    if not ok or id ~= Q61 then return end
    local alton = Near(player, ALTON, 30)
    After(player, 3000, function()
        Talk(alton)
        Say(alton, "It is time to get back to my duties, I will see you around. Maybe get a drink at the Recluse.", nil, player)
        if alton then
            pcall(function() alton:SetWalk(true) end)
            for i, pt in ipairs(SW_LEAVE) do
                After(player, 3500 * i, function() if alton:IsInWorld() then alton:MoveToSafe(i, pt[1], pt[2], pt[3]) end end)
            end
            After(player, 10500, function() if alton:IsInWorld() then alton:DespawnOrUnsummon(800) end end)
        end
    end)
end)

local function Proximity(p)
    if p:GetMapId() ~= 0 then return end
    local s = Status(p, Q61)
    if s ~= ST_INCOMPLETE and s ~= ST_COMPLETE then Clear(p, "sw_alton"); Clear(p, "sw_greet"); return end
    if Dist2(p, SW_ARRIVAL[2], SW_ARRIVAL[3]) > 45 then return end

    -- Alton is not a permanent Embassy spawn: temp summon where the user measured him
    if not Near(p, ALTON, 25) and Once(p, "sw_alton") then
        p:SpawnCreature(ALTON, SW_ALTON[1], SW_ALTON[2], SW_ALTON[3], SW_ALTON[4], 3, 600000)
    end
    if Dist2(p, SW_NEAR[1], SW_NEAR[2]) < 7 and Once(p, "sw_greet") then
        local alton = Near(p, ALTON, 25)
        Say(alton, "That's the one I told you about. Over here, " .. p:GetName() .. ".", 305565, p)
        local moor = Near(p, MOORGARD, 25)
        if moor then pcall(function() moor:PerformEmote(2) end) end   -- bow
    end
end

MAP_Timer("harandar_61", function()
    for _, p in ipairs(MAP_Players()) do
        if p:IsInWorld() then pcall(Proximity, p) end
    end
end, 1000)

print("[harandar_61] loaded")
