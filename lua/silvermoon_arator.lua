-- =====================================================================
-- Arator's Journey: Silvermoon (86833 A Bulwark Remade) + The Arcantina (86903)
--
-- Sources:
--   Warcraft Wiki "A Bulwark Remade" (cutscene "Forgiveness", post-scene dialogue)
--   Warcraft Wiki "The Arcantina" (arrival, round, joke, shield conversation)
--   hotfixes.broadcast_text build 66102 (text + SoundKitID1)
--   SoundKitEntry_12.1.5.70391.csv -> KIT_LEN (durations)
--
-- 86833: Faol 237511 (accept), Arator 237510 + Sons of Lothar at the Bazaar
--        (8537.26 -4473.21, area 15969, phases 45818-45820 are always active there).
--        Turalyon 236906 is not spawned in Silvermoon; the "Forgiveness" cutscene
--        (BT 307951-307978) uses a temporary scene actor that despawns itself.
-- 86903: Kurdran 253125 (accept, Silvermoon), Arcantina map 2195 / area 10473
--        (phase 45821): Arator 253988, Kurdran 253125, Danath 253124,
--        Eitrigg 253126, Bartender Bob 250495, drinks GO 584421.
--
-- No SQL: all NPCs and phases already exist. Fallback credits in
-- midnight_fallback_0data.lua stay as a safety net; this script only adds the
-- spoken scene and credits the scene objectives when it finishes.
-- =====================================================================
if IS_WORLD_STATE or not MAP_Timer then return end

local Q_FORGE, Q_ARC = 86833, 86903
local ST_COMPLETE, ST_INCOMPLETE = 1, 3

local FAOL, ARATOR_B, KURDRAN_B, EITRIGG_B, DANATH_B, TURALYON = 237511, 237510, 253125, 237224, 242120, 236906
local ARATOR_A, KURDRAN_A, EITRIGG_A, DANATH_A, BOB = 253988, 253125, 253126, 253124, 250495

local FORGE_GO = { 529716, 529717, 529718, 529719 }
local DRINK_GO = 584421

local FLAG = {}  -- [guid:tag] = true
local FORGE = {} -- [guid] = { [goEntry] = count, started = true, done = true }

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
local function Active(p, q) return Status(p, q) == ST_INCOMPLETE end
local function AvailableOrActive(p, q)
    local s = Status(p, q)
    return s == ST_COMPLETE or s == ST_INCOMPLETE
end
local function Once(p, tag)
    local k = GUID(p) .. ":" .. tag
    if FLAG[k] then return false end
    FLAG[k] = true
    return true
end
local function Clear(p, tag)
    local k = GUID(p) .. ":" .. tag
    FLAG[k] = nil
end
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
local function Actor(p, entry, x, y, z, o, ms)
    return Near(p, entry, 30) or SpawnAt(p, entry, x, y, z, o, ms or 260000)
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
-- steps: { speaker, text, soundKit, gapMs }
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
local function Msg(p, text)
    pcall(function() p:SendBroadcastMessage(text) end)
end
local function ForgeCount(k, go)
    local f = FORGE[k]
    return f and f[go] or 0
end
-- Only the three material gameobjects are real quest objectives:
-- quest_objectives 460987000/001/002 = 529719/529718/529717, Amount 3,
-- StorageIndex 2/3/4. 529716 (Steel Ingot) is the anvil/RP prop and has no
-- objective row, so it must not gate the cutscene.
local function ForgeDoneLive(k)
    return ForgeCount(k, 529717) >= 3 and ForgeCount(k, 529718) >= 3
       and ForgeCount(k, 529719) >= 3
end
local function ForgeDoneDB(p)
    local ok, res = pcall(CharDBQuery,
        "SELECT objective, data FROM character_queststatus_objectives WHERE guid = " ..
        tostring(p:GetGUIDLow()) .. " AND quest = " .. Q_FORGE ..
        " AND objective IN (2,3,4) AND data >= 3")
    if not ok or not res then return false end
    local n = 0
    repeat n = n + 1 until not res:NextRow()
    return n >= 3
end

-- ---------------------------------------------------------------- 86833: the forge
local FORGE_LINE = {
    [529716] = { "I need another steel ingot.", 305912 },
    [529717] = { "It's too hot! Pour some water on the shield to cool it.", 305871 },
    [529718] = { "Add a phoenix feather to increase the heat.", 305911 },
    [529719] = { "Add some wyrmdust to make it more powerful.", 305914 },
}

-- "Forgiveness" cutscene, BT 307951-307978, in broadcast-text order.
local function ForgiveSteps(tur, ara)
    return {
        { tur, "My son...", 326981 },
        { tur, "Arator, I...", 326982 },
        { tur, "I was hoping to...", 326983 },
        { tur, "That we could--", 326984 },
        { ara, "Father.", 326985 },
        { ara, "I know you'd never willingly hurt me.", 326986 },
        { ara, "But in that moment,", 326987, 450 },
        { ara, "you lost control.", 326988 },
        { tur, "Could you ever forgive me?", 326989 },
        { ara, "I think...", 326991 },
        { ara, "It's time you forgave yourself.", 326992 },
        { ara, "I know what happened the day Lothar fell.", 326993 },
        { ara, "The guilt--", 326994, 450 },
        { ara, "--the rage--", 326995, 450 },
        { ara, "--you've carried all these years...", 326996 },
        { ara, "It's time to let it go.", 326997 },
        { tur, "My... my shield.", 326998 },
        { tur, "How? How did you--", 326999 },
        { ara, "Take it up again.", 327000 },
        { ara, "Be the paladin you were born to be.", 327001 },
        { tur, "I...", 327002 },
        { tur, "(sighs) I can't.", 327003 },
        { tur, "That part of me died with Lothar.", 327004 },
        { ara, "But not all of you.", 327005 },
        { ara, "Don't give up hope, father.", 327007 },
        { tur, "(sighs)", 327008 },
        { tur, "My son, some things...", 327009, 450 },
        { tur, "...can't ever be redeemed.", 327010 },
    }
end

local function StartForgiveness(p, arator)
    if not Once(p, "86833_cutscene") then return end
    local ara = arator or Actor(p, ARATOR_B, 8537.26, -4473.21, 18.8166, 2.68504)
    local tur = Near(p, TURALYON, 40) or SpawnAt(p, TURALYON, 8537.60, -4469.50, 18.8166, 3.2, 280000)
    if tur and ara then pcall(function() tur:SetFacingToObject(ara) end) end
    local faol = Actor(p, FAOL, 8540.22, -4475.35, 18.8155, 2.75733)
    local kur = Actor(p, KURDRAN_B, 8537.74, -4477.24, 18.8159, 1.90922)
    local t = Seq(p, ForgiveSteps(tur, ara))
    After(p, t + 1200, function()
        local post = {
            { faol, "Why do you still have the shield? Didn't you give it to your father?", 305874 },
            { ara, "I did. He said \"some things can't ever be redeemed\" and refused it.", 305868 },
            { faol, "That's... disappointing. I had hoped for a different reaction.", 312961 },
            { ara, "So did I... but a wise man once told me \"I can't change anything but how I feel.\"", 305861 },
            { ara, "So I'm going to focus on that. My father may not be ready to change, but I am.", 305860 },
            { faol, "Arator... Light be praised, perhaps this all happened for a reason.", 305859 },
            { ara, "I just need to figure out what to do with this shield.", 305858 },
            { kur, "I could use a hot meal and a drink while you ponder. Come with us, lad. You too, $n.", 305857 },
            { faol, "I must return to the Sunwell. The Vanguard needs my counsel.", 305856 },
        }
        local pt = Seq(p, post)
        After(p, pt + 1500, function()
            Credit(p, 253929) -- [DNT] Turalyon Conversation
            Credit(p, 250252) -- Kill Credit: Speak with Arator
            Msg(p, "|cff00ff00Turalyon has heard Arator out.|r Arator waits at the Bazaar; speak with him to finish the quest.")
        end)
    end)
end

for go, line in pairs(FORGE_LINE) do
    RegisterGameObjectEvent(go, 14, function(_, _, player)
        if not player or not Active(player, Q_FORGE) then return end
        local k = GUID(player)
        FORGE[k] = FORGE[k] or {}
        local n = (FORGE[k][go] or 0) + 1
        FORGE[k][go] = n
        local ara = Near(player, ARATOR_B, 30) or SpawnAt(player, ARATOR_B, 8537.26, -4473.21, 18.8166, 2.68504, 260000)
        if n == 1 then
            if not FORGE[k].started then
                FORGE[k].started = true
                Say(ara, "Let's do this! I'll hammer, you control the heat!", 305915, player)
                After(player, Dur("Let's do this! I'll hammer, you control the heat!", 305915, 500), function()
                    Say(ara, line[1], line[2], player)
                end)
            else
                Say(ara, line[1], line[2], player)
            end
        end
        if not FORGE[k].done and ForgeDoneLive(k) then
            FORGE[k].done = true
            After(player, 2500, function() StartForgiveness(player, ara) end)
        end
    end)
end

RegisterCreatureEvent(FAOL, 31, function(_, player, creature, quest)
    if not quest or quest:GetId() ~= Q_FORGE then return end
    local k = GUID(player)
    FORGE[k] = nil
    Clear(player, "86833_cutscene")
    After(player, 1000, function()
        local faol = Near(player, FAOL, 40) or creature
        Say(faol, "I'll pull Turalyon away from his duties. Not an easy feat by any means.", 305946, player)
        After(player, Dur("I'll pull Turalyon away from his duties. Not an easy feat by any means.", 305946, 900), function()
            Say(faol, "It will give Arator time to finish reforging his father's shield. He could use your assistance.", 305945, player)
        end)
    end)
end)

-- Gossip fallback: after a relog the live forge counters are gone, so the
-- character_queststatus_objectives table decides. The scene is only played
-- once per quest run; the next gossip opens the normal turn-in menu.
RegisterCreatureGossipEvent(ARATOR_B, 1, function(_, player, creature)
    if not AvailableOrActive(player, Q_FORGE) then return end
    local k = GUID(player)
    if FLAG[k .. ":86833_cutscene"] then return end
    if not (Status(player, Q_FORGE) == ST_COMPLETE or ForgeDoneLive(k) or ForgeDoneDB(player)) then
        Msg(player, "|cffffd200Arator|r: Help me with the forge first. Use the steel ingot, water, phoenix feather and wyrmdust.")
        pcall(function() player:GossipComplete() end)
        return false
    end
    StartForgiveness(player, creature)
    pcall(function() player:GossipComplete() end)
    return false
end)

-- Safety net: if the forge/cutscene was completed through the fallback path and
-- the player hands the quest in without the gossip hook firing, still play the
-- scene once (after the reward; the objective credits are already satisfied).
RegisterCreatureEvent(ARATOR_B, 34, function(_, player, creature, quest)
    if not quest or quest:GetId() ~= Q_FORGE then return end
    if not FLAG[GUID(player) .. ":86833_cutscene"] then
        StartForgiveness(player, creature)
    end
end)

-- ---------------------------------------------------------------- 86903: arrival
local function PlayArrival(p)
    if not Once(p, "86903_arrival") then return end
    local ara = Actor(p, ARATOR_A, 34.6063, 52.8850, -0.395222, 0.467556)
    local kur = Actor(p, KURDRAN_A, 38.0645, 52.5831, -0.395229, 2.70364)
    local dan = Actor(p, DANATH_A, 37.8413, 55.8230, -0.395222, 3.82936)
    local eit = Actor(p, EITRIGG_A, 33.8476, 55.9891, -0.395222, 6.02878)
    return Seq(p, {
        { ara, "Where is this place? It doesn't appear to be in Azeroth.", 306063 },
        { kur, "Khadgar introduced us. It's in some wizardy, hocus-pocus, dimensional whatzzuhthing. Hot food, cold drinks, magical access.", 306057 },
        { dan, "$n, could you get us the first round? Put it on my tab.", 306062 },
        { eit, "Take a look around. Horde, Alliance... this place is a refuge for those who've had enough of war.", 306059 },
    })
end

-- ---------------------------------------------------------------- 86903: joke + serve
local function PlayJoke(p)
    if not Once(p, "86903_joke") then return end
    local kur = Actor(p, KURDRAN_A, 38.0645, 52.5831, -0.395229, 2.70364)
    local eit = Actor(p, EITRIGG_A, 33.8476, 55.9891, -0.395222, 6.02878)
    local dan = Actor(p, DANATH_A, 37.8413, 55.8230, -0.395222, 3.82936)
    local ara = Actor(p, ARATOR_A, 34.6063, 52.8850, -0.395222, 0.467556)
    local t = Seq(p, {
        { kur, "...and so I said, \"If that's my gryphon, who's sitting on the egg?\"", 306061 },
        { kur, "HA! Ha ha ha ha!", nil },
        { eit, "Pfffft--Sitting on the egg! HA!", nil },
        { dan, "Ha ha ha--that doesn't make any sense. Ha ha ha.", 306052 },
        { ara, "Ha! Ha ha ha ha ha ha ha ha ha ha!", nil },
        { dan, "Thank you, $n. To old friends, and new.", nil },
        { eit, "Aka'magosh.", nil },
    })
    After(p, t + 600, function()
        Credit(p, 258899) -- [DNT] Joke
        Credit(p, 250262) -- Approach with Drinks
        Msg(p, "|cffffd200Danath|r: Arator, what are you going to do with Turalyon's shield?")
    end)
end

-- ---------------------------------------------------------------- 86903: shield conversation
local function StartShieldTalk(p, arator)
    local ara = arator or Actor(p, ARATOR_A, 34.6063, 52.8850, -0.395222, 0.467556)
    local kur = Actor(p, KURDRAN_A, 38.0645, 52.5831, -0.395229, 2.70364)
    local dan = Actor(p, DANATH_A, 37.8413, 55.8230, -0.395222, 3.82936)
    local eit = Actor(p, EITRIGG_A, 33.8476, 55.9891, -0.395222, 6.02878)
    local t = Seq(p, {
        { dan, "Arator, what are you going to do with Turalyon's shield?", 306055 },
        { ara, "Well... I've been giving it some thought. I'd like to hang it on the wall here. As a reminder.", 306050 },
        { ara, "We can all break, but we can put ourselves back together, and emerge stronger for it.", 306049 },
        { kur, "Bah! Terrible idea! Worst I've ever heard.", 306047 },
        { kur, "To have a fine piece of equipment like that, well made, well repaired, languish on the wall until it rusts? That's shameful.", 306046 },
        { dan, "He has a point, lad. A good shield like that yearns to protect a soldier, so they can protect others.", 306045 },
        { ara, "I... But it's not my shield.", 306044 },
        { eit, "Your father refused the legacy. It's yours if you want it.", 306043 },
        { ara, "It does feel right.", 306042 },
        { ara, "I'll do it. Faol told me that the Silver Hand was meant to protect the defenseless, during war as well as peace.", 306041 },
        { ara, "Maybe I can help to demonstrate that service to others, as Dezco has. This reforged shield can be a reminder to me, as I protect Azeroth.", 306040 },
        { ara, "Thank you. All of you. I won't let you down.", 306039 },
    })
    After(p, t + 700, function()
        Credit(p, 250268) -- [DNT] Shield Conversation
        Credit(p, 253391) -- Speak with Arator
        Msg(p, "|cff00ff00Arator equips Turalyon's reforged shield.|r Speak with Arator to finish the quest.")
    end)
end

RegisterCreatureEvent(KURDRAN_B, 31, function(_, player, _, quest)
    if not quest or quest:GetId() ~= Q_ARC then return end
    Clear(player, "86903_arrival")
    Clear(player, "86903_joke")
    Clear(player, "86903_shield")
    After(player, 1200, function()
        local dan = Near(player, DANATH_B, 40)
        if dan then
            Say(dan, "Honestly, Arator, we've wanted to show you the place for some time. Glad to finally get the chance.", 305854, player)
        end
    end)
    local tries = 0
    local function Poll()
        tries = tries + 1
        if not Active(player, Q_ARC) or FLAG[GUID(player) .. ":86903_arrival"] then return end
        local ok, map = pcall(function() return player:GetMapId() end)
        if ok and map == 2195 then
            PlayArrival(player)
        elseif tries < 75 then
            After(player, 2000, Poll)
        end
    end
    After(player, 2500, Poll)
end)

-- Bob is the first NPC every visitor talks to; if the map poll missed the
-- teleport (relog / reload), his gossip starts the arrival lines first.
RegisterCreatureGossipEvent(BOB, 1, function(_, player)
    if not Active(player, Q_ARC) then return end
    if FLAG[GUID(player) .. ":86903_arrival"] then return end
    PlayArrival(player)
    pcall(function() player:GossipComplete() end)
    return false
end)

RegisterGameObjectEvent(DRINK_GO, 14, function(_, _, player)
    if not player or not Active(player, Q_ARC) then return end
    if not FLAG[GUID(player) .. ":86903_arrival"] then
        local t = PlayArrival(player)
        After(player, (t or 20000) + 500, function() PlayJoke(player) end)
        return
    end
    PlayJoke(player)
end)

RegisterCreatureGossipEvent(ARATOR_A, 1, function(_, player, creature)
    if not Active(player, Q_ARC) then return end
    local k = GUID(player)
    if FLAG[k .. ":86903_shield"] then return end
    if not FLAG[k .. ":86903_arrival"] then
        PlayArrival(player)
        pcall(function() player:GossipComplete() end)
        return false
    end
    FLAG[k .. ":86903_shield"] = true
    StartShieldTalk(player, creature)
    pcall(function() player:GossipComplete() end)
    return false
end)

local function ArcTurnIn(_, player, creature, quest)
    if not quest or quest:GetId() ~= Q_ARC then return end
    After(player, 600, function()
        local ara = Near(player, ARATOR_A, 30) or creature
        Say(ara, "Thank you for helping me, $n. I think that our presence has been missed in Silvermoon. We should return.", 306065, player)
    end)
    Msg(player, "|cff00ff00Arator equips Turalyon's reforged shield.|r")
end
RegisterCreatureEvent(ARATOR_A, 34, ArcTurnIn)
RegisterCreatureEvent(235479, 34, ArcTurnIn)
RegisterCreatureEvent(236734, 34, ArcTurnIn)

print("[silvermoon_arator] loaded")
