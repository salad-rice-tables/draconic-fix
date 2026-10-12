-- =====================================================================
-- Stormwind Alive - ambient life for Stormwind City (map 0).
-- Same engine as Orgrimmar Alive: solo lines, neighbour dialogues,
-- greetings, race voice, day/night, gossip menus for guards.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

local CHECK_RANGE = 40
local MIN_DELAY   = 70000
local MAX_DELAY   = 200000
local TALK_CHANCE = 0.6
local DIALOGUE_CHANCE = 0.50
local AREA_QUIET_SECS = 30
local GREET_RANGE = 18
local GREET_COOLDOWN = 60
local CRITTER_RANGE = 12
local CRITTER_CHANCE = 0.25
local FORCE_NIGHT = false

local function GameHour()
    local t = 0
    if GetGameTime then
        local ok, v = pcall(GetGameTime)
        if ok and type(v) == "number" then t = v end
    end
    if t == 0 then t = os.time() % 86400 end
    return math.floor(t / 3600) % 24
end
local function IsNight()
    if FORCE_NIGHT then return true end
    local h = GameHour()
    return h >= 21 or h < 6
end

local LAST_AREA_TALK = {}
local function AreaQuiet(areaId)
    local now = os.time()
    local last = LAST_AREA_TALK[areaId] or 0
    if now - last < AREA_QUIET_SECS then return false end
    LAST_AREA_TALK[areaId] = now
    return true
end

local LINES = {
    guard = {
        "For the Alliance!",
        "King's honor, friend.",
        "Greetings, citizen.",
        "Move along.",
        "Stormwind stands.",
        "The Light protect you.",
        "State your business.",
        "The wall has never fallen. It never will.",
        "Keep your weapons sheathed in the city.",
        "Old Town is no place for heroes after dark.",
    },
    vendor = {
        "Finest goods in Stormwind! Come, browse!",
        "Dwarven steel, elven silk, fair prices.",
        "No refunds on enchanted items. House rules.",
    },
    innkeeper = {
        "Welcome to the Pig and Whistle!",
        "Ale's cold, stew's hot. Sit.",
        "Rooms upstairs. Mind the stairs.",
    },
    banker = {
        "Stormwind vault. State your business.",
        "Your gold is safe behind Alliance steel.",
    },
    trainer = {
        "Discipline first. Talent second.",
        "Again. Slower this time.",
        "Your stance is wrong. Fix it.",
    },
    flight = {
        "Gryphons ready. Where to?",
        "The sky over Elwynn is clear today.",
    },
    civilian = {
        "Lovely day in Stormwind.",
        "Did you hear about...? Never mind.",
        "Backbone of the Alliance, us folk.",
        "War is for heroes. I just bake bread.",
    },
    court = {
        "The Alliance endures.",
        "Stormwind stands with her allies.",
        "What news from the front?",
        "The Light guides our blades.",
        "For Lordaeron.",
        "The throne remembers every oath sworn before it.",
    },
}

local DIALOGUES = {
    guard = {
        {"Quiet shift.", "Quiet means the Alliance is feared. Good."},
        {"Remember the Fall of Stormwind? Never again.", "For the King, brother."},
        {"King's honor.", "And honor keeps the King."},
    },
    vendor = {
        {"Sold three blades before breakfast.", "Ha! I sold a haunted one. No refunds!"},
        {"Slow day?", "Tourists. They look, they touch, they leave."},
    },
    civilian = {
        {"Heard the price of bread?", "Everything costs gold these days."},
        {"My daughter wants a gryphon of her own.", "Tell her to start with chores. Like all of us."},
    },
    court = {
        {"The scouts report quiet borders.", "Quiet I don't trust. Double the watch."},
        {"Elune watch over these talks.", "And the Light guide them."},
        {"What does Ironforge say?", "The mountain stands with us, as always."},
    },
}

local CHATTER = {
    {"Morning.", "Morning. Cold one.", "Cold means the forges burn hot. Good."},
    {"Bread prices up again?", "Blame the caravans. And the war. And the weather."},
    {"Take the tram?", "Mind the kobolds. You take the candle."},
    {"Smell that? Someone's burning dinner again.", "Third time this week. Pig and Whistle stew, probably."},
    {"Did the patrol come back?", "All accounted for. Quiet night."},
    {"My boots are falling apart.", "Dwarven row. Tell them I sent you."},
    {"Rain again.", "Good for Elwynn. Bad for my roof."},
    {"Saw a gryphon land at dawn.", "Mail from Ironforge, likely. Or bad news."},
}

local RACE_LINES = {
    [1]  = {"For Stormwind!", "King's honor!"},                        -- Human
    [3]  = {"Stone and ale!", "By Muradin's beard!"},                  -- Dwarf
    [4]  = {"Elune watch over you.", "Shan'do..."},                    -- Night Elf
    [7]  = {"Mind the machinery!", "Fascinating!"},                    -- Gnome
    [11] = {"The Light protects.", "Velen guides us."},               -- Draenei
    [22] = {"Careful. The beast stirs.", "For Gilneas!"},              -- Worgen
}

local NIGHT_LINES = {
    guard     = {"Night watch. Eyes open.", "The city sleeps. We don't."},
    vendor    = {"Closing up... come back at dawn."},
    innkeeper = {"Evening crowd's here! Ale for everyone!"},
    civilian  = {"Best get home before dark.", "Old Town isn't safe tonight."},
    banker    = {"The vault never sleeps. Neither do we."},
    court     = {"The council ends at dusk. Leave us."},
    trainer   = {"Training's done for today. Rest."},
    flight    = {"Last flight before dark. Hurry."},
}

local GREET_LINES = {
    guard     = {"Hail, traveler.", "Well met.", "Move along.", "Orgrimmar? Wrong city, friend."},
    vendor    = {"Come, look! Fresh wares!", "Traveler! Over here!"},
    innkeeper = {"Welcome in, welcome!", "Thirsty? Hungry? Both?"},
    banker    = {"Stormwind vault. State your business."},
    court     = {"Yes? Make it quick."},
    civilian  = {"Oh! Hello there.", "Lovely day, no?"},
    trainer   = {"You look soft. Train harder."},
    flight    = {"Need wings, traveler?"},
}

local NEWCOMER_LINES = {
    guard     = {"First time in Stormwind, little one? Stick to the road and you'll be fine."},
    vendor    = {"New in town? First browse is free, little one."},
    innkeeper = {"Young traveler! Come, sit - the stew's on me."},
    civilian  = {"Oh! A new face! Welcome to Stormwind!"},
}

local GREET_POOLS = { guard = true, vendor = true, innkeeper = true,
    banker = true, court = true, civilian = true, trainer = true, flight = true }

local GROUPS = {
    { entries = {68,261,1423,1642,12423,192535,192971}, pool = "grunt" },
    { entries = {54,66,74,151,258,295,383,384,465,844,894,896,955,958,959,1198,1249,1250,1430,1632,1645,1650,2046,3935,3937,6367,6749,11072,23482,23510,23511,32836,34682,34710,52497,53702,53728,63014,109685}, pool = "vendor" },
    { entries = {328,377,514,906,913,917,927,1103,1218,1430,1632,1651,2329,4732,6306,6374,11072,34710,46983,47384,63014}, pool = "trainer" },
    { entries = {295,6778}, pool = "innkeeper" },
    { entries = {42983,43000,192545}, pool = "flight" },
    { entries = {906,1423,6374,15760,23712,46983,47384,52548,54345}, pool = "civilian" },
    { entries = {1439,1440,1750,1751,1752,1756,2285,2504,4960,15187,17103,24729,34997,34998,35365,44238,44239,44241,44243,100399,100428,100429,100449,100454,100455,100456,100457,100458,100460,100471,100472,100675,100754,100973,100977,100978,100979,100980,100981,101055,102554,107574,120590,120594,120597,120599,120756,120788,139636,139642,151247,151249,151251,151255,151783,151784,155313,175137,198884,198885,198886}, pool = "court" },
}

-- NOTE: pool key "grunt" covers Stormwind guards (entry list above).

local BAGSW = {}
local function PickSW(list, key)
    if not list or #list == 0 then return nil end
    if #list == 1 then return list[1] end
    local b = BAGSW[key]
    if not b or b.pos > #b.order or b.n ~= #list then
        local o = {}
        for i = 1, #list do o[i] = i end
        for i = #o, 2, -1 do local j = math.random(i); o[i], o[j] = o[j], o[i] end
        if b and b.last and o[1] == b.last then o[1], o[#o] = o[#o], o[1] end
        b = {order = o, pos = 1, n = #list}
        BAGSW[key] = b
    end
    local idx = b.order[b.pos]; b.pos = b.pos + 1; b.last = idx
    return list[idx]
end

local LOUD = {}

local function LoudSay(creature, line)
    creature:SendUnitSay(line, 0)
end

local function SayLater(creature, line, delay)
    creature:RegisterEvent(function(_, _, _, c)
        if c and c:IsAlive() then LoudSay(c, line) end
    end, delay, 1)
end

local function StormwindTalk(eventId, delay, repeats, creature)
    if not creature or not creature:IsAlive() then return end
    local pool = creature:Data():Get("sw_pool")
    local players = creature:GetPlayersInRange(CHECK_RANGE)
    if players and #players > 0 and math.random() < TALK_CHANCE then
        local okA, areaId = pcall(creature.GetAreaId, creature)
        if not okA or type(areaId) ~= "number" then areaId = 0 end
        if not AreaQuiet(areaId) then
            -- someone nearby already spoke; stay quiet this round
        else
        -- gather up to two nearby same-kind speakers (neighbours talk)
        local cast = { creature }
        local partners = creature:GetCreaturesInRange(25)
        if partners then
            for _, o in ipairs(partners) do
                if #cast >= 3 then break end
                if o and o ~= creature and o:IsAlive() and o:Data():Get("sw_pool") == pool then
                    cast[#cast + 1] = o
                end
            end
        end
        if #cast >= 2 and math.random() < DIALOGUE_CHANCE + 0.15 then
            local roll = math.random()
            local conv
            if roll < 0.45 then
                conv = PickSW(CHATTER, "sw:chatter")
            else
                local dlg = DIALOGUES[pool]
                if dlg then conv = PickSW(dlg, "sw:dlg:" .. tostring(pool)) end
            end
            if conv then
                for i, line in ipairs(conv) do
                    local speaker = cast[((i - 1) % #cast) + 1]
                    if i == 1 then
                        LoudSay(speaker, line)
                    else
                        SayLater(speaker, line, (i - 1) * math.random(4000, 7000))
                    end
                end
            end
        else
            -- alone: night lines first, then race voice, then role line
            local acted = false
            if IsNight() then
                local nl = NIGHT_LINES[pool]
                if nl and math.random() < 0.5 then
                    LoudSay(creature, PickSW(nl, "sw:night:" .. tostring(pool)))
                    acted = true
                end
            end
            if not acted then
                local race = creature.GetRace and creature:GetRace() or 0
                local rl = RACE_LINES[race]
                if rl and math.random() < 0.35 then
                    LoudSay(creature, PickSW(rl, "sw:race:" .. tostring(race)))
                else
                    local lines = LINES[pool]
                    if lines then
                        LoudSay(creature, PickSW(lines, "sw:solo:" .. tostring(pool)))
                    end
                end
            end
        end
        end
    end
    creature:RegisterEvent(StormwindTalk, math.random(MIN_DELAY, MAX_DELAY), 1)
end

local GreetWatchSW
local function StormwindSpawn(event, creature)
    creature:RegisterEvent(StormwindTalk, math.random(60000, 180000), 1)
    local pool = creature:Data():Get("sw_pool")
    if pool and GREET_POOLS[pool] then
        creature:RegisterEvent(GreetWatchSW, 12000, 1)
    end
end

local function StormwindDeath(event, creature)
    creature:RemoveEvents()
end

for _, g in ipairs(GROUPS) do
    for _, entry in ipairs(g.entries) do
      if not HAS_CPP_SCRIPT[entry] then
        local pool = g.pool
        RegisterCreatureEvent(entry, 5, function(e, c) c:Data():Set("sw_pool", pool) StormwindSpawn(e, c) end)
        RegisterCreatureEvent(entry, 4, StormwindDeath)
      end
    end
end

print("[StormwindAlive] talk loaded")

-- =====================================================================
-- Greetings: guards and innkeepers greet passers-by.
-- =====================================================================

function GreetWatchSW(_, _, _, creature)
    if not creature or not creature:IsAlive() then return end
    local pool = creature:Data():Get("sw_pool")
    if pool and GREET_POOLS[pool] then
        local players = creature:GetPlayersInRange(GREET_RANGE)
        if players and #players > 0 then
            local now = os.time()
            local last = creature:Data():Get("sw_greet") or 0
            if type(last) ~= "number" then last = 0 end
            if now - last >= GREET_COOLDOWN then
                creature:Data():Set("sw_greet", now)
                local mini = 100
                for _, p in ipairs(players) do
                    local okL, lv = pcall(function() return p:GetLevel() end)
                    if okL and type(lv) == "number" and lv < mini then mini = lv end
                end
                if mini < 10 and NEWCOMER_LINES[pool] then
                    local nl = NEWCOMER_LINES[pool]
                    LoudSay(creature, PickSW(nl, "sw:night:" .. tostring(pool)))
                else
                    local lines = GREET_LINES[pool]
                    if lines then
                        LoudSay(creature, PickSW(lines, "sw:solo:" .. tostring(pool)))
                    end
                end
            end
        end
    end
    creature:RegisterEvent(GreetWatchSW, 12000, 1)
end

-- =====================================================================
-- Gossip: guards give directions. Vendors/trainers keep default windows.
-- =====================================================================

local DIRECTIONS = {
    [1] = "The bank? North, past the auction house. Follow the gold, citizen.",
    [2] = "Auction house is in the Trade District. Follow the coins.",
    [3] = "Need rest? The Pig and Whistle, Old Town. Mind the stairs.",
    [4] = "Mage Quarter portal room? East, past the fountain.",
    [5] = "The tram to Ironforge? Dwarven District, down the ramp.",
}

local function GuardHello(event, player, creature)
    player:GossipMenuAddItem(0, "Where is the bank?", 1, 1)
    player:GossipMenuAddItem(0, "Where is the auction house?", 1, 2)
    player:GossipMenuAddItem(0, "Where can I rest?", 1, 3)
    player:GossipMenuAddItem(0, "Where are the portals?", 1, 4)
    player:GossipMenuAddItem(0, "Where is the tram?", 1, 5)
    player:GossipMenuAddItem(0, "Never mind.", 1, 6)
    player:GossipSendMenu(1, creature)
end

local function GuardSelect(event, player, creature, sender, intid, code)
    if intid == 6 then
        player:GossipComplete()
        return
    end
    local line = DIRECTIONS[intid]
    if line then
        creature:SendUnitSay(line, 0)
    end
    player:GossipComplete()
end

local SW_GUARDS = {68, 261, 1423, 1642, 12423, 192535, 192971}

for _, entry in ipairs(SW_GUARDS) do
    RegisterCreatureGossipEvent(entry, 1, GuardHello)
    RegisterCreatureGossipEvent(entry, 2, GuardSelect)
end

print("[StormwindAlive] loaded")
