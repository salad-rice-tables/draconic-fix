-- =====================================================================
-- Orgrimmar Alive - ambient life for Orgrimmar (map 1, zone 1637)
--  * solo say lines (only when players are near, randomized 90-240 s)
--  * two-line dialogues between nearby NPCs of the same kind
--  * lore gossip: "did you know...?" facts about the Warcraft world
--  * guard/peon gossip menus (directions, jokes)
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

local CHECK_RANGE = 40
local MIN_DELAY   = 70000
local MAX_DELAY   = 200000
local TALK_CHANCE = 0.6
local DIALOGUE_CHANCE = 0.50
local AREA_QUIET_SECS = 30   -- nobody else in the same area spoke recently

-- Day/night: game hour 21-05 counts as night.
local function GameHour()
    local t = 0
    if GetGameTime then
        local ok, v = pcall(GetGameTime)
        if ok and type(v) == "number" then t = v end
    end
    if t == 0 then t = os.time() % 86400 end
    return math.floor(t / 3600) % 24
end
local FORCE_NIGHT = false -- true = testing: force night mode
local _forceNightAt, _forceNight = 0, nil
local function ForceNight() -- GM test: world.lw_state force_night=1 (cached 30 s)
    if os.time() - _forceNightAt > 30 then
        _forceNightAt = os.time()
        local ok, r = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = 'force_night'")
        _forceNight = ok and r and r:GetString(0) == "1"
    end
    return _forceNight
end
local function IsNight()
    if FORCE_NIGHT or ForceNight() then return true end
    local h = GameHour()
    return h >= 21 or h < 6
end

-- Nobody talks over each other in the same area.
local LAST_AREA_TALK = {}
local function AreaQuiet(areaId)
    local now = os.time()
    local last = LAST_AREA_TALK[areaId] or 0
    if now - last < AREA_QUIET_SECS then return false end
    LAST_AREA_TALK[areaId] = now
    return true
end

local NIGHT_LINES = {
    grunt     = {"Night watch. Eyes open.", "The city sleeps. We don't."},
    vendor    = {"Closing up... come back at dawn."},
    innkeeper = {"Evening crowd's here! Ale for everyone!"},
    civilian  = {"Best get home before dark.", "The Drag isn't safe tonight."},
    tavern    = {},
    banker    = {"The vault never sleeps. Neither do we."},
    court     = {"The council ends at dusk. Leave us."},
    trainer   = {"Training's done for today. Rest."},
    flight    = {"Last flight before dark. Hurry."},
    crier     = {"Hear ye! Curfew bells at midnight!"},
    peon      = {"Night shift... work, work..."},
    lazy      = {"Finally. Nap time."},
    goblin    = {"Night market prices! Double!"},
    critter   = {},
}

local LINES = {
    grunt = {
        "Lok'tar ogar!",
        "For the Horde!",
        "Blood and thunder!",
        "For Doomhammer!",
        "Strength and honor, traveler.",
        "May your blades never dull.",
        "Hail, champion.",
        "Greetings. State your business.",
        "Move along.",
        "Trouble? Then trouble found the wrong city.",
        "I watch the gate. You watch your step.",
        "Keep your weapons sheathed in the city.",
        "The Drag is no place for heroes after dark.",
        "Patrol's quiet... too quiet.",
        "These walls have never fallen. They never will.",
        "Keep moving, citizen. Nothing to see here.",
        "I stood watch when Deathwing broke the world. This is nothing.",
        "Stay sharp. The Barrens breed trouble.",
    },
    peon = {
        "Work, work.",
        "Something need doing?",
        "Me not that kind of orc!",
        "Okie dokie.",
        "Zug-zug.",
    },
    lazy = {
        "Me sleep... just five more minutes.",
        "Work? Never heard of it.",
        "If overseer comes, you never saw me.",
    },
    vendor = {
        "Finest wares in Orgrimmar! Come, browse!",
        "Sharp steel, strong leather, fair prices.",
        "No refunds on cursed items. House rules.",
        "Everything a warrior needs, right here.",
    },
    innkeeper = {
        "Rest your blades, traveler. The beds are... mostly clean.",
        "Ale's cold, stew's hot. Sit.",
        "Rooms upstairs. Try not to bleed on the furs.",
    },
    banker = {
        "Your gold is safe behind Horde steel.",
        "Deposit? Withdrawal? Make it quick, the line grows.",
        "Interest? This is Orgrimmar, not Booty Bay.",
        "Sign here. And here. And... no, an X is fine.",
        "Every coin counted twice. Counted three times if you're a goblin.",
        "Vault inspection at dusk. Nobody touches the third shelf.",
        "Someone deposited a live scorpid again. Who does that?",
        "Gold, silver, copper... and one very suspicious tooth.",
        "The war tax is due at the end of the month. Don't shoot the messenger.",
        "We store your valuables, not your grudges. Next!",
        "If it's cursed, it goes in the iron box. House rules.",
        "Ten years at this counter. My back remembers every one.",
        "My feet ache. Bankers stand all day, you know.",
        "Lunch break? What's a lunch break?",
        "One day I'll retire to Ratchet. Sun, sea, no ledgers.",
        "My son wants to be a grunt. I told him the bank pays better.",
    },
    goblin = {
        "Time is money, friend!",
        "Everything's for sale. EVERYTHING.",
        "No refunds, no regrets, no problem!",
    },
    trainer = {
        "Discipline first. Talent second.",
        "Again. Slower this time.",
        "Your stance is wrong. Fix it.",
        "I trained Blademasters. Impress me.",
    },
    auction = {
        "Sold! To the goblin with the gold teeth!",
        "Going once... going twice...",
        "No shill bidding! ...today.",
    },
    flight = {
        "Wind riders ready. Where to?",
        "The sky over Durotar is clear today.",
        "Hold tight. These beasts bite strangers.",
    },
    civilian = {
        "Lovely day in Orgrimmar.",
        "Did you hear about...? Never mind.",
        "Backbone of the Horde, us folk.",
        "War is for heroes. I just sell bread.",
    },
    crier = {
        "Fresh fish, straight from the stream! Half price, today only!",
        "Sharpest blades in all of Kalimdor! See for yourself!",
        "Silks, spices, snake oil! Everything the discerning warrior needs!",
        "Toys! Novelties! Amaze your warband!",
    },
    drill = {
        "Is that all you've got?! Again, properly!",
        "My grandmother hits harder! And she's been dead for years!",
        "Again! Until your arms fall off, then switch arms!",
    },

    shaman = {
        "The elements are restless today.",
        "The earth speaks. Be still and listen.",
    },
    troll = {
        "Stay awhile, mon. Da Darkspear be watchin' over ya.",
    },
    tauren = {
        "The Earthmother provides, young one.",
    },
    earthen = {
        "The titans watch. So do I.",
        "Flesh is weak. Stone endures.",
        "My oath was sworn before your grandfather's birth.",
        "Order must be maintained.",
    },
    kalimdor = {
        "The road goes ever on.",
        "Mind the wilds beyond the post.",
        "Kalimdor remembers every war.",
        "Safe travels, stranger.",
    },
    durotar = {
        "Durotar sun burns fierce today.",
        "Quillboar raid the farms again.",
        "Water is life out here. Remember that.",
        "Dust gets everywhere. Even in dreams.",
        "Keep to the road. The wilds bite.",
        "Red rock, red sun. Home.",
    },
    court = {
        "The Horde endures.",
        "Speak, and be brief.",
        "Every blade in this city answers the call.",
        "The elements watch over the Hold.",
        "Diplomacy is war by other means.",
        "The throne remembers every oath sworn before it.",
    },
}

-- Hourly town announcements (criers) and shift changes (guards).
local function HourEventLine(pool)
    local h = GameHour()
    if pool == "crier" then
        if h == 8 then return "Hear ye! Market stalls open! Fresh wares daily!" end
        if h == 12 then return "Hear ye! Midday muster at the Valley of Honor!" end
        if h == 20 then return "Light the lamps! Night falls on Orgrimmar!" end
    end
    if pool == "grunt" then
        if h == 6 then return "Shift change! Day watch takes the wall!" end
        if h == 18 then return "Night watch forms up! Eyes open!" end
    end
    return nil
end

local DIALOGUES = {
    grunt = {
        {"Quiet shift.", "Quiet means the Horde is feared. Good."},
        {"Heard the Tirisfal zeppelin runs late.", "Forsaken business. Ask no questions."},
        {"Remember the Siege? Never again.", "Lok'tar ogar, brother."},
        {"Strength and honor.", "And honor brings strength, sister."},
        {"May your blades never dull.", "And your shield never splinter."},
        {"New recruit yesterday. Couldn't hold a spear.", "We all start as peons. Even you."},
        {"New shields arrived from the forge.", "About time. Mine's more dent than shield."},
        {"Rats in the granary again.", "Set the traps. And stop feeding them, recruit."},
        {"Captain wants the roster by dusk.", "Then the Captain can wait till dusk."},
        {"Wardens in Dolanaar, they say.", "Aye. Jailers playing at war. Times change."},
        {"Night elf wardens recruiting demon hunters?", "Heard it from a zeppelin hand. Go see, if you thirst."},
    },
    peon = {
        {"Me back hurt.", "You want me do your work AND mine?"},
        {"Overseer coming?", "Then look busy! Work, work!"},
        {"Dabu?", "Dabu!"},
    },
    vendor = {
        {"Sold three blades before breakfast.", "Ha! I sold a cursed one. No refunds!"},
        {"Slow day?", "Tourists. They look, they touch, they leave."},
        {"Two silver for that? The taxes bleed me dry!", "Then lower your prices, friend, and we both eat."},
        {"Finest silk! Feel it!", "Hm... it feels like burlap.", "Burlap?! That is premium Spider silk!"},
        {"Spices from Stranglethorn! Smell that?", "Smells like profit, friend."},
        {"This blade? Carried it myself. Nearly.", "Nearly carried, fully priced, eh?"},
    },
    kalimdor = {
        {"Heard the price of bread?", "Everything costs blood these days."},
    },
    civilian = {
        {"Heard the price of bread?", "Everything costs blood these days."},
        {"My daughter wants a wyvern of her own.", "Tell her to start with chores. Like all of us."},
        {"My cousin swears she saw a warden in Dolanaar!", "Recruiting, she says. Demon hunters, of all people!"},
        {"Dolanaar, they whisper. Wardens taking in outcasts.", "If you've the stomach, go listen yourself."},
    },
    earthen = {
        {"The edicts are clear.", "And yet the fleshlings improvise."},
        {"This city stands. Barely.", "Then we will shore it up. Stone by stone."},
    },
    durotar = {
        {"Seen any quillboar?", "South ridge. Big party of 'em."},
        {"Well's running low.", "Then we dig deeper. Like always."},
    },
    court = {
        {"Rash action built nothing that lasted.", "And hesitation built less, old friend."},
        {"True Horde bows to no one!", "Lok'tar ogar! Strength and honor!"},
        {"The northern patrols report quiet.", "Quiet I don't trust. Double the watch."},
        {"Da spirits be whisperin' of comin' war.", "Then we listen. And we prepare."},
        {"The armories overflow. The war machine is fed.", "Good. Hungry armies win nothing."},
        {"Silvermoon stands with the Horde.", "As do the tauren. As do we all."},
        {"The Earthmother frowns on this haste.", "Haste wins wars the patient lose, chieftain."},
        {"What news from the front?", "The banners hold. Barely. But they hold."},
    },
    innkeeper = {
        {"Another brawl last night?", "Same table. I charge extra for repairs now."},
    },
    banker = {
        {"Ledger balances?", "Off by three copper.", "Find them. Before the overseer does."},
        {"Busy morning.", "Payday at the barracks. Every grunt wants his coin at once."},
        {"That goblin asked for a loan again.", "Against what? His good looks?", "Ha! He offered his rocket boots."},
        {"Vault door's sticking.", "Oil it. Last time it took four peons to open."},
        {"Heard the Booty Bay bank lost a chest.", "Pirates. Or an inside job.", "Same thing in Booty Bay."},
        {"How's the family?", "Wife wants a bigger hut. On a banker's pay!", "Tell her to marry a goblin next time."},
        {"Did you eat?", "Not since dawn. The line never ends.", "I'll bring you some stew from the Broken Tusk."},
        {"Someone tried to deposit a cursed ring.", "Into the iron box?", "Into the iron box."},
        {"Count this stack again.", "Four hundred and twelve.", "I counted four hundred and eleven.", "...Then we count again."},
        {"Thinking of taking a day off.", "A day off? In this economy?"},
        {"Saw your daughter at the training grounds.", "She swings an axe better than she counts coins.", "Then let her be a warrior. We have enough bankers."},
        {"The new clerk keeps falling asleep.", "Put him on the night ledger. Nobody will notice."},
        {"War bonds are selling well.", "Fear sells. Always has."},
    },
}

-- Everyday city talk: greetings, work, prices, weather, plans.
-- Format: {speaker1 line, speaker2 line, [optional speaker1 closing line]}
local CHATTER = {
    {"Morning.", "Morning. Cold one.", "Cold means the forges burn hot. Good."},
    {"Bread prices up again?", "Blame the caravans. And the war. And the weather."},
    {"You headed to the front?", "Friday. If the zeppelin flies."},
    {"My boy wants to join the grunts.", "Tell him peeling potatoes first. Like all of us."},
    {"Smell that? Someone's burning dinner again.", "Third time this week. Sanzi's stew, probably."},
    {"Did the patrol come back?", "All accounted for. Quiet night."},
    {"I lost two teeth to that dice game.", "You lost them to the ale, friend."},
    {"When's the next market day?", "Saturday. Exotics from Thunder Bluff, they say."},
    {"My boots are falling apart.", "Kiro's shop. Tell him I sent you, he'll rob you fairly."},
    {"Rain again.", "Good for the Barrens. Bad for my roof."},
    {"Saw a wyvern land at dawn.", "Mail from Silvermoon, likely. Or bad news."},
    {"Evening, citizen.", "Evening. Quiet shift?", "Quiet means feared. Good."},
    {"The forge never cools in this city.", "Neither does its temper.", "Ha! True enough."},
    {"You hear about the races in the Barrens?", "Kodos. I lost ten silver.", "Never bet against a kodo."},
    {"This heat will kill me.", "You? Born in Durotar and complaining?", "Even the rocks sweat today."},
    {"My sister married a mage.", "Portals for family reunions, eh?", "Free travel! Best decision she ever made."},
    {"The pigs got out again.", "Third time! Someone fix that fence!"},
    {"Smell the roasting meat?", "Grommash festival tonight. Don't be late."},
    {"I need new boots.", "Kiro robs fairly. Others rob outright."},
    {"The wyverns look restless.", "Storm coming from the sea, I'd wager."},
    {"Did you sleep at all?", "Drums from the arena all night.", "Ah, the pits. Glorious noise."},
    {"Water caravan's late.", "Again? The wells run low as it is."},
    {"My boy wants a wolf of his own.", "Start him with chores. Like all of us."},
    {"Caravan from Ratchet came through the gate.", "Goblin goods. Check your purse twice."},
    {"The shaman says rain's coming.", "I'll believe it when my roof stops leaking."},
    {"You look tired, friend.", "Nightmares. Of the war. They never leave."},
    {"Heard the drums?", "Recruiting drive. The Horde always needs blades."},
    {"This city changes every year.", "And yet the spikes stay sharp. Good."},
    {"My mother sends stew.", "Share it, then. That's the law of the barracks."},
    {"Quietest week in years.", "Don't say it aloud! You'll jinx it."},
    {"The new smithy's work is fine.", "Aye, but his prices bite worse than his dogs."},
    {"Saw the Warchief's guard drill today.", "Makes our patrol look like a stroll."},
    {"Zeppelin from Tirisfal is late again.", "The goblins blame the wind.", "The goblins blame everything."},
    {"Busy day at the bank?", "Line out the door. Everyone's hoarding before the next war."},
    {"Heard the Valley of Spirits had visitors.", "Darkspear elders. Something about the Loa."},
    {"Your axe needs sharpening.", "My axe needs a vacation."},
    {"The Cleft of Shadow smells worse every year.", "That's the warlocks. Don't ask what they burn."},
    {"Who won the fight at the Ring of Valor?", "A tauren. Nobody bets against the tauren anymore."},
    {"Hot today.", "It's Orgrimmar. It's always hot.", "Hotter than always, then."},
    {"Blood elf merchant raised his prices.", "Silvermoon silk doesn't sell itself, he says."},
    {"My wolf chewed through his leash.", "Then he's smarter than your leash."},
    {"Did you see the new recruits?", "Kids. Every one of them.", "We were kids once too."},
    {"I'm thinking of joining an expedition.", "Where to?", "Wherever pays the most and kills the least."},
    {"The Drag was packed today.", "Festival rumors. Everyone's buying lanterns."},
    {"I miss the old Orgrimmar.", "Mud walls and leaky roofs? I don't."},
    {"Saw a goblin rocket crash into the Slums.", "Again? That's the third this month."},
    {"How's your shoulder?", "Healed. Shaman's work.", "Good. You owe her a drink."},
    {"Forsaken in the tavern last night.", "Paid in gold and drank nothing. Best customer ever."},
    {"The trolls are drumming in the Valley of Spirits.", "Means a ceremony. Or a party. With trolls, both."},
    {"Thunder Bluff sent another envoy.", "Tauren talk slow. Takes a week to say hello."},
    {"Mok'Nathal hunter came by the Valley of Honor.", "Rexxar's kin? Rare sight these days."},
    {"The kodo steaks are tough today.", "So was the kodo."},
}

local GROUPS = {
    { entries = {9900113,9900114,9900112,9900115,9900116,144288,3296,156731,140750,173279,143964,5603,12789,12797,12798,30611,44871,44872,44874,44876,44877,44878,45827,47335,47336,50488,61845,69977,73151,88701,88702,88703,141767,149626,168459}, pool = "grunt" },
    { entries = {14901,40904,9900122}, pool = "peon" },
    { entries = {10556,41989}, pool = "lazy" },
    { entries = {3312,3313,3314,3315,3316,3317,3319,3321,3322,3323,3329,3330,3331,3333,3334,3335,3342,3346,3348,3350,3351,3356,3358,3359,3360,3361,3362,3364,3366,3367,3368,3369,3400,3405,3409,3413,4043,5188,5812,5816,5817,9988,12793,12795,12796,15354,27489,30723,42709,44779,44780,44788,44918,45008,45093,45094,45546,45549,45551,45552,45553,45558,45563,45566,45567,45789,46358,46359,46512,46555,46556,46572,46708,46718,46742,47764,48510,49737,50323,50477,50482,52032,52033,52036,54473,54657,57922,66022,69333,69978,146626,175050,185472,185473,199625,199643,199705,252312}, pool = "vendor" },
    { entries = {6929,44785,45565,45086,45563,46642,27815}, pool = "innkeeper" },
    { entries = {44853,44851,44856,44770,44852,44854,45081,45661,45662,46618,46619,46620,46621,46622}, pool = "banker" },
    { entries = {51307}, pool = "goblin" },
    { entries = {3324,3325,3326,3327,3328,3344,3345,3347,3352,3355,3357,3363,3399,3403,3404,4752,5815,7088,7230,7231,7311,11017,11177,11178,13417,30706,37072,44723,44725,44726,44735,44740,44743,44781,44782,44783,44919,44975,44978,45019,45023,45029,45095,45137,45138,45139,45337,45339,45347,45545,45548,45550,45559,45709,45713,45714,45717,45718,45720,46357,46675,46709,46716,46741,47233,47246,47247,47248,47253,47767,47771,47788,48513,52170,62445,63086,63626,70301,72939,88704,88705,88706,168628,202438}, pool = "trainer" },
    { entries = {44787,44865,44866,44867,44868,45082,45659,46637,46638,46639,46640}, pool = "auction" },
    { entries = {3310,44918,51346,141706,198096}, pool = "flight" },
    { entries = {135671,143682,154464,221293,225509}, pool = "earthen" },
    { entries = {543,1182,1322,1992,1993,2006,2007,2008,2009,2010,2011,2015,2017,2018,2019,2021,2039,2077,2078,2079,2080,2081,2082,2083,2084,2107,2150,2151,2152,2155,2162,2186,2192,2206,2207,2303,2616,2796,2798,2803,2852,2912,2947,2948,2949,2950,2951,2952,2962,2963,2964,2965,2976,2977,2978,2979,2980,2981,2985,2987,2988,2994,2995,2996,2997,2998,2999,3000,3001,3002,3003,3004,3005,3007,3008,3009,3010,3011,3012,3013,3014,3015,3016,3017,3018,3019,3020,3021,3022,3023,3024,3025,3026,3027,3028,3029,3033,3034,3036,3037,3038,3039,3040,3041,3042,3043,3044,3045,3046,3047,3048,3049,3050,3051,3052,3054,3055,3059,3060,3061,3062,3063,3064,3065,3067,3069,3072,3073,3074,3075,3076,3077,3078,3079,3080,3081,3083,3084,3092,3093,3095,3140,3143,3145,3153,3155,3156,3157,3158,3159,3160,3161,3184,3185,3186,3187,3188,3194,3209,3210,3211,3212,3213,3214,3215,3217,3218,3219,3220,3221,3222,3223,3224,3232,3233,3261,3269,3270,3271,3272,3273,3274,3275,3276,3277,3278,3279,3280,3282,3284,3285,3292,3297,3304,3306,3338,3339,3341,3374,3375,3376,3377,3378,3379,3380,3382,3383,3384,3385,3386,3387,3388,3389,3390,3391,3394,3396,3397,3411,3418,3419,3428,3429,3431,3432,3433,3439,3441,3442,3443,3445,3446,3447,3448,3449,3452,3453,3464,3465,3467,3468,3469,3471,3477,3478,3479,3480,3481,3482,3483,3484,3485,3486,3487,3488,3489,3490,3491,3492,3493,3494,3495,3496,3497,3498,3499,3500,3502,3514,3515,3517,3519,3561,3562,3567,3571,3572,3587,3588,3589,3590,3591,3592,3593,3594,3595,3596,3597,3598,3599,3600,3601,3602,3603,3604,3605,3607,3608,3609,3610,3611,3612,3613,3614,3615,3655,3658,3659,3665,3672,3685,3688,3690,3691,3694,3696,3698,3700,3703,3704,3705,3711,3713,3717,3725,3727,3728,3730,3733,3734,3736,3743,3745,3750,3779,3792,3797,3833,3838,3841,3845,3846,3847,3848,3880,3882,3883,3884,3885,3891,3892,3894,3897,3901,3916,3920,3921,3922,3924,3925,3926,3932,3933,3934,3936,3940,3941,3942,3943,3944,3951,3952,3953,3954,3956,3958,3959,3961,3962,3967,3969,3970,3978,3986,3987,3992,3993,3995,3996,4049,4050,4051,4052,4053,4054,4056,4057,4061,4070,4079,4082,4083,4087,4088,4089,4090,4091,4092,4138,4146,4155,4156,4159,4160,4161,4163,4164,4165,4167,4168,4169,4170,4171,4172,4173,4175,4177,4180,4181,4184,4187,4190,4194,4197,4202,4203,4204,4205,4208,4209,4210,4211,4212,4213,4214,4215,4216,4217,4218,4219,4220,4221,4222,4223,4225,4226,4228,4229,4230,4231,4232,4233,4234,4235,4236,4240,4241,4262,4265,4266,4267,4273,4312,4321,4359,4361,4362,4363,4364,4366,4368,4370,4371,4401,4403,4404,4407,4409,4489,4498,4500,4501,4502,4503,4521,4544,4638,4639,4640,4641,4642,4643,4644,4645,4646,4648,4651,4653,4654,4655,4656,4657,4658,4659,4663,4664,4665,4666,4667,4668,4705,4708,4711,4712,4713,4714,4715,4716,4718,4719,4721,4730,4753,4783,4784,4786,4791,4792,4794,4802,4834,4879,4880,4883,4884,4885,4886,4888,4889,4890,4891,4892,4893,4894,4895,4896,4897,4898,4899,4900,4901,4902,4921,4922,4923,4924,4926,4941,4943,4944,4948,4951,4964,4965,4966,4967,4968,4973,4979,4980,4983,5047,5054,5057,5083,5085,5086,5087,5089,5090,5091,5092,5093,5094,5095,5096,5184,5189,5191,5199,5200,5234,5236,5240,5249,5251,5253,5254,5255,5258,5327,5328,5343,5345,5346,5362,5366,5388,5390,5395,5396,5411,5412,5471,5472,5473,5474,5475,5501,5543,5594,5599,5601,5629,5638,5641,5642,5645,5646,5647,5649,5752,5769,5770,5771,5782,5786,5787,5835,5836,5837,5841,5863,5870,5871,5878,5887,5899,5901,5906,5907,5915,5930,5933,5938,5939,5940,5941,5942,5944,5952,5957,6019,6020,6028,6034,6087,6091,6094,6132,6142,6190,6193,6195,6196,6244,6247,6251,6252,6253,6254,6266,6272,6286,6287,6290,6292,6350,6370,6372,6387,6393,6408,6410,6546,6567,6568,6606,6649,6650,6651,6706,6731,6732,6735,6736,6738,6746,6747,6776,6780,6781,6791,6887,6909,7015,7016,7017,7089,7112,7113,7114,7115,7118,7120,7153,7154,7155,7156,7157,7158,7161,7233,7234,7235,7287,7288,7296,7307,7308,7313,7315,7316,7317,7318,7438,7439,7440,7441,7442,7450,7451,7452,7453,7454,7458,7459,7460,7714,7725,7726,7727,7730,7731,7733,7737,7740,7770,7772,7773,7775,7776,7799,7804,7823,7824,7854,7855,7858,7872,7873,7874,7875,7885,7886,7907,7916,7939,7940,7941,7942,7943,7945,7946,7947,7948,7949,7952,7953,7956,7957,7975,7999,8015,8016,8026,8115,8119,8124,8126,8128,8129,8131,8140,8141,8142,8143,8144,8145,8146,8147,8150,8151,8152,8153,8154,8157,8158,8159,8199,8203,8306,8307,8308,8356,8357,8358,8359,8360,8361,8362,8363,8364,8396,8398,8401,8408,8418,8496,8583,8584,8586,8610,8661,8664,8665,8669,8674,8722,8723,8736,8738,8878,9047,9076,9087,9116,9117,9118,9119,9270,9271,9272,9298,9316,9457,9460,9462,9517,9523,9524,9548,9549,9552,9558,9618,9619,9636,9796,9857,9981,9983,9985,9986,9990,9997,9998,9999,10036,10047,10048,10050,10051,10052,10054,10056,10059,10063,10085,10086,10089,10118,10176,10182,10278,10293,10301,10302,10305,10307,10369,10378,10380,10468,10559,10578,10583,10599,10600,10604,10606,10618,10637,10639,10676,10721,10738,10878,10881,10897,10916,10918,10920,10921,10922,10923,10924,10977,10978,10993,11019,11037,11041,11042,11047,11050,11051,11052,11070,11071,11074,11079,11081,11083,11084,11098,11103,11104,11105,11106,11118,11119,11137,11138,11139,11182,11183,11184,11185,11186,11187,11188,11189,11190,11191,11192,11193,11219,11259,11378,11401,11407,11438,11440,11442,11443,11498,11516,11546,11552,11553,11554,11555,11556,11557,11558,11559,11562,11563,11596,11624,11685,11696,11700,11701,11709,11711,11713,11715,11716,11717,11718,11720,11751,11752,11753,11754,11755,11756,11757,11795,11796,11797,11798,11799,11800,11801,11802,11803,11804,11805,11806,11811,11818,11820,11821,11822,11823,11824,11825,11829,11832,11857,11858,11877,11880,11881,11882,11883,11899,11901,11910,11911,11912,11913,11914,11915,11917,11918,11939,11942,11944,12019,12021,12022,12023,12024,12025,12026,12027,12028,12029,12030,12031,12032,12033,12034,12042,12043,12045,12160,12196,12277,12338,12340,12429,12578,12616,12696,12717,12719,12720,12721,12722,12723,12724,12737,12740,12757,12776,12816,12818,12837,12856,12858,12859,12863,12864,12866,12867,12877,12896,12897,12903,12919,12921,12939,12956,12959,12960,12961,12962,13220,13277,13431,13432,13476,13656,13697,13698,13699,13717,13718,13737,13917,14230,14347,14355,14373,14378,14379,14380,14395,14426,14427,14428,14429,14440,14441,14442,14567,14637,14715,14717,14718,14733,14742,14743,14753,14754,14781,14850,14857,14859,14872,14873,14874,14893,14908,14909,14963,14964,15131,15169,15174,15175,15176,15177,15178,15179,15180,15181,15182,15183,15184,15189,15190,15191,15194,15201,15202,15213,15270,15282,15293,15306,15308,15315,15395,15419,15441,15442,15443,15444,15498,15499,15500,15540,15541,15542,15545,15610,15614,15678,15679,15693,15722,15760,15892,15895,15898,15903,16014,16015,16072,16091,16227,16416,16417,16418,16543,17068,17080,17081,17082,17095,17100,17105,17106,17119,17287,17291,17303,17355,17406,17409,17412,17541,17765,18542,19173,19176,19444,19860,19908,19910,20053,20054,20055,20069,20080,20081,20082,20102,20278,21448,21643,22834,22835,22837,22931,22935,22936,23534,23535,23566,23567,23568,23570,23571,23572,23573,23579,23589,23590,23591,23592,23593,23594,23595,23600,23601,23602,23618,23620,23636,23637,23679,23704,23714,23720,23723,23797,23835,23841,23843,23892,23896,23905,23942,23949,23950,23951,23995,24005,24006,24007,24208,24734,24735,24736,24737,24738,24739,25863,25866,25899,25924,25949,27703,27704,28126,28601,28602,29865,29866,29867,29868,30567,30590,30709,30715,30724,30731,31111,32639,32799,32836,32855,32858,32859,32860,32861,32862,32863,32868,32869,32888,32899,32911,32912,32932,32959,32960,32963,32964,32965,32966,32967,32968,32969,32970,32971,32972,32973,32974,32977,32978,32979,32987,32988,32989,32990,33001,33021,33033,33035,33037,33043,33044,33048,33055,33057,33071,33079,33084,33091,33093,33094,33095,33106,33107,33115,33117,33119,33126,33175,33176,33177,33178,33187,33193,33195,33201,33204,33206,33207,33208,33209,33231,33232,33250,33253,33262,33263,33265,33266,33276,33277,33278,33281,33284,33294,33295,33334,33345,33347,33348,33356,33359,33375,33381,33389,33390,33407,33421,33440,33443,33445,33454,33727,33728,33760,33766,33777,33825,33980,34030,34041,34046,34103,34122,34163,34177,34195,34204,34205,34208,34239,34241,34242,34248,34251,34282,34283,34294,34301,34303,34309,34315,34326,34339,34340,34341,34342,34343,34345,34353,34354,34359,34366,34374,34377,34378,34385,34392,34395,34398,34399,34402,34403,34404,34405,34406,34413,34414,34415,34416,34419,34420,34422,34423,34426,34427,34429,34446,34479,34480,34485,34498,34499,34503,34504,34510,34513,34518,34523,34544,34559,34560,34563,34569,34578,34590,34591,34592,34596,34613,34617,34618,34624,34626,34634,34638,34651,34653,34654,34656,34674,34676,34681,34698,34706,34707,34711,34727,34733,34747,34749,34750,34752,34753,34754,34756,34757,34759,34761,34766,34804,34805,34807,34809,34832,34841,34843,34848,34855,34927,34943,34968,34969,34976,34978,34988,34989,35085,35087,35088,35091,35136,35137,35138,35139,35140,35141,35142,35151,35153,35154,35158,35159,35160,35161,35174,35187,35205,35250,35252,35257,35281,35286,35295,35298,35312,35315,35334,35450,35452,35478,35481,35605,35606,35632,35648,35657,35661,35754,35755,35756,35757,35773,35817,35827,35829,35831,35832,35833,35867,35880,35881,36012,36013,36015,36034,36048,36052,36056,36060,36061,36077,36134,36137,36146,36181,36182,36183,36185,36196,36208,36210,36329,36353,36370,36371,36372,36373,36374,36375,36376,36378,36379,36479,36506,36592,36593,36594,36596,36611,36614,36636,36637,36638,36644,36648,36660,36680,36687,36688,36694,36697,36708,36712,36722,36728,36729,36730,36744,36746,36748,36749,36752,36756,36787,36795,36803,36815,36816,36825,36827,36828,36832,36849,36850,36869,36870,36873,36884,36894,36895,36902,36903,36914,36919,36920,36922,36925,36931,36936,36942,36943,36956,36958,36959,36972,36973,36974,36975,36976,36987,36988,36989,36999,37005,37009,37010,37024,37061,37064,37136,37138,37140,37142,37152,37154,37157,37160,37161,37165,37166,37167,37170,37180,37204,37216,37220,37487,37511,37515,37516,37517,37560,37570,37585,37659,37660,37661,37679,37706,37717,37724,37737,37743,37811,37812,37817,37834,37835,37836,37847,37908,37909,37910,37922,37923,37924,37925,37926,37933,37940,37951,37969,37971,37977,37987,38005,38015,38033,38037,38070,38140,38142,38183,38217,38225,38237,38242,38243,38244,38245,38246,38247,38263,38268,38269,38270,38272,38274,38275,38276,38277,38278,38279,38280,38281,38282,38290,38300,38301,38306,38314,38323,38324,38326,38327,38329,38345,38378,38379,38380,38382,38383,38384,38385,38423,38437,38440,38442,38488,38502,38532,38534,38535,38561,38571,38578,38619,38620,38621,38622,38623,38624,38627,38636,38646,38648,38658,38659,38661,38663,38664,38697,38706,38714,38749,38800,38801,38804,38805,38826,38847,38849,38856,38871,38873,38875,38876,38880,38884,38913,38915,38922,38926,38927,38931,38934,38938,38939,38940,38941,38951,38952,38953,38966,38986,38988,38989,38990,38997,38998,39003,39005,39006,39007,39008,39020,39024,39025,39027,39028,39031,39032,39033,39034,39061,39062,39072,39083,39084,39085,39094,39096,39118,39124,39136,39138,39139,39144,39153,39154,39155,39156,39174,39175,39178,39191,39206,39210,39211,39212,39214,39215,39245,39249,39254,39256,39257,39260,39261,39279,39280,39281,39282,39314,39317,39322,39330,39340,39342,39377,39391,39399,39400,39406,39412,39413,39427,39429,39432,39433,39434,39435,39437,39442,39445,39451,39453,39618,39619,39621,39637,39642,39643,39644,39646,39653,39656,39657,39677,39697,39723,39725,39728,39733,39749,39752,39789,39828,39839,39840,39843,39846,39847,39857,39858,39865,39869,39879,39893,39894,39895,39896,39898,39925,39927,39928,39929,39930,39931,39932,39933,39946,39947,39949,39951,39952,39957,39963,39965,39972,39974,39992,40027,40028,40032,40035,40051,40052,40061,40062,40063,40078,40082,40092,40096,40109,40123,40129,40132,40139,40140,40148,40149,40150,40168,40185,40216,40224,40226,40254,40278,40289,40331,40332,40333,40336,40344,40345,40358,40360,40362,40367,40369,40409,40432,40449,40463,40465,40467,40473,40474,40475,40483,40487,40489,40491,40494,40496,40497,40498,40512,40528,40529,40530,40536,40552,40553,40554,40556,40558,40560,40562,40563,40564,40572,40573,40578,40580,40582,40583,40588,40589,40593,40619,40632,40635,40636,40662,40713,40726,40727,40747,40755,40757,40767,40768,40769,40772,40773,40776,40777,40778,40779,40799,40800,40809,40814,40815,40826,40827,40829,40832,40833,40834,40837,40838,40843,40845,40879,40881,40882,40885,40888,40894,40895,40896,40897,40898,40899,40900,40901,40902,40903,40905,40906,40907,40908,40913,40914,40915,40922,40926,40928,40942,40958,40959,40966,40967,40968,40969,40973,40997,41003,41004,41005,41006,41008,41023,41026,41027,41028,41039,41047,41053,41054,41060,41062,41070,41071,41076,41081,41082,41131,41135,41142,41184,41190,41196,41199,41204,41205,41214,41215,41229,41230,41233,41240,41246,41274,41275,41276,41277,41278,41282,41283,41286,41291,41311,41350,41351,41360,41361,41370,41381,41383,41392,41407,41408,41421,41431,41432,41434,41437,41439,41441,41444,41446,41447,41448,41452,41458,41482,41485,41486,41487,41488,41489,41490,41491,41492,41493,41497,41498,41499,41500,41502,41507,41509,41528,41563,41580,41605,41627,41631,41638,41664,41673,41674,41675,41676,41677,41678,41679,41680,41681,41743,41854,41860,41861,41864,41865,41870,41890,41891,41892,41893,41935,41937,41990,41991,41992,42023,42028,42032,42033,42039,42040,42047,42050,42091,42101,42618,42619,42640,42641,42643,42644,42646,42647,42775,42777,42786,42804,42836,42936,42968,42970,43001,43004,43005,43006,43013,43015,43017,43019,43021,43063,43073,43079,43085,43217,43301,43304,43328,43378,43379,43380,43381,43408,43410,43411,43418,43419,43420,43424,43425,43427,43428,43429,43431,43436,43439,43481,43487,43493,43494,43495,43547,43548,43550,43551,43554,43555,43563,43564,43565,43568,43599,43606,43615,43617,43619,43624,43625,43630,43633,43634,43637,43645,43646,43653,43657,43705,43708,43709,43710,43771,43772,43773,43774,43776,43795,43796,43845,43870,43872,43877,43880,43881,43882,43883,43887,43889,43892,43899,43945,43946,43951,43955,43964,43972,43980,43982,43987,43988,44027,44058,44168,44170,44177,44219,44267,44268,44270,44276,44277,44279,44280,44283,44285,44286,44287,44294,44296,44297,44299,44300,44301,44302,44303,44304,44305,44307,44346,44347,44348,44349,44354,44374,44376,44377,44378,44379,44381,44382,44383,44384,44385,44386,44391,44397,44398,44399,44400,44402,44417,44611,44612,44613,44617,44714,44762,44763,44869,44927,45181,45186,45190,45199,45205,45271,45272,45274,45381,45383,45385,45387,45410,45418,45438,45442,45715,45772,45799,45874,45905,45907,45949,46003,46041,46042,46134,46135,46136,46315,46333,46340,46401,46402,46496,46590,46592,46603,46617,46646,46692,46872,46875,46877,46878,46879,46880,46884,46888,46894,46908,46927,46974,46979,46980,46993,47005,47014,47042,47043,47044,47051,47057,47062,47176,47185,47187,47189,47193,47208,47209,47291,47306,47308,47318,47341,47383,47419,47420,47439,47461,47471,47472,47479,47487,47510,47514,47528,47546,47556,47567,47569,47572,47580,47583,47584,47585,47589,47594,47602,47617,47619,47620,47621,47625,47643,47645,47656,47670,47679,47684,47692,47696,47698,47699,47700,47707,47709,47715,47716,47718,47722,47725,47727,47729,47730,47738,47741,47742,47753,47755,47760,47762,47804,47810,47842,47843,47851,47923,47930,47931,47978,47981,47982,48007,48012,48028,48040,48041,48043,48113,48114,48126,48127,48203,48204,48205,48215,48216,48228,48235,48236,48237,48238,48258,48267,48273,48274,48275,48331,48332,48333,48339,48349,48374,48452,48453,48459,48461,48469,48491,48492,48493,48501,48512,48514,48518,48534,48548,48550,48551,48552,48553,48555,48556,48564,48573,48574,48577,48580,48581,48587,48599,48607,48608,48617,48622,48625,48626,48627,48629,48631,48668,48694,48697,48701,48722,48723,48726,48735,48736,48761,48764,48853,48856,48857,48858,48860,48861,48868,48874,48883,48884,48885,48886,48887,48965,49148,49156,49178,49214,49224,49228,49242,49244,49281,49396,49399,49400,49402,49406,49407,49408,49409,49410,49436,49444,49445,49477,49478,49479,49537,49748,49875,49876,49878,49879,49880,49881,49882,49883,49884,49886,49887,49888,49889,49890,49891,49892,49894,49895,49896,49900,49901,49902,49909,49923,49927,49939,49940,49942,49963,49968,49997,49998,50001,50002,50004,50006,50011,50015,50022,50027,50028,50029,50031,50032,50033,50034,50035,50043,50045,50053,50092,50094,50126,50129,50263,50299,50301,50305,50307,50314,50316,50325,50367,50483,50497,50498,50499,50500,50501,50502,50504,50505,50506,50507,50508,50509,50510,50513,50516,50517,50518,50519,50520,50521,50587,50588,50690,50714,50715,51142,51143,51217,51371,51372,51503,51504,51509,51511,51525,51637,51638,51639,51640,51648,51664,51717,51722,51733,51734,51735,51750,51753,51755,51756,51757,51758,51759,51787,51832,51839,51852,51853,51861,51867,51913,51924,51935,51936,51941,51942,51943,51944,51945,51946,51997,52008,52018,52060,52092,52093,52192,52196,52207,52227,52292,52338,52356,52357,52386,52448,52456,52562,52636,52637,52640,52641,52642,52643,52644,52645,52651,52655,52657,52658,52669,52670,52671,52791,52830,52838,52843,52844,52845,52846,52847,52848,52849,52863,52897,52898,52899,52900,52901,52903,52904,52907,53075,53076,53403,53404,53405,53407,53409,53410,53415,53418,53421,53436,53437,53518,53562,53779,53780,53781,53782,53783,53805,53823,53840,53841,53842,53844,54228,54313,54334,54392,54393,54401,54402,54654,54655,54656,55285,55396,55397,55398,55399,62450,63067,63070,63083,63296,63309,63310,63327,66352,66372,66819,68025,68038,68041,68044,68048,68077,68342,68394,68651,70906,71304,90113,99867,101064,103133,103136,103277,103281,103875,104659,106380,106597,106600,110034,110035,120173,129867,130030,130032,130033,130216,130711,131837,131838,131839,131907,131908,131946,131947,131952,131957,131963,132040,132042,132045,132055,132062,132064,132138,132139,132140,132141,132142,132147,132190,132192,132199,132203,132591,132606,132684,132886,132995,133019,133693,133755,134554,134573,134574,134578,134645,134657,135003,135350,135442,135443,135501,135591,135607,135668,135671,137878,139489,139915,139944,140315,140498,140499,140500,140608,140633,140686,140688,140719,140720,140721,140741,140748,140749,140751,140770,140784,140801,140805,140809,140877,141359,141365,141366,141367,141558,141828,141900,141999,142294,142299,142306,142310,142317,142402,142408,142621,142749,142943,142978,143409,143434,143445,143527,143637,143638,143639,143640,143682,143789,143881,143955,143993,144145,144146,144157,144183,144282,144290,144345,144346,144364,144365,144386,144387,144434,144442,144466,144476,144488,144490,145149,145151,145166,146373,146374,146375,146536,146577,147856,147894,149549,149550,149582,150309,150311,150620,150621,151129,151130,151134,151150,151151,151152,151214,151225,151787,151880,151960,152134,152233,152815,154424,154532,154958,155007,155096,155099,155100,155102,156181,157157,157170,158061,158192,159544,159548,159554,159560,159682,159705,159769,159770,159784,159803,159804,159813,159820,159821,159920,160301,160714,161031,161071,161110,161126,161128,161134,162141,162172,162181,164086,164088,164089,164196,197261,199739,199740,201313,202700,202701,202702,205905,205906,205907,205910,205937,205939,205940,207680,210207,210208,211351,211993,211994,223877,223881,223882,223884,223885,223887,223902,223962,223963,224035,224049,224121,224122,224220,224322,224431,224525,224590,224695,224696,225245,225343,226073,226097,226147,226164,226212,226251,226290,226368,226658,226666,226667,226668,226669,226683,226684,226694,226766,226770,226775,226803,226804,226805,226981,227429,227560,227663,227731,227816,227821,227822,228240,228241,228242,228243,228244,228245,228246,228247,228248,228249,228250,228251,228252,228256,228258,228259,228261,228262,228263,228269,228270,228271,228272,228273,228274,228275,228276,228280,228282,228283,229102,229394,229494,229630,229707,229710,229711,229749,229774,229775,229811,229987,229991,229993,229996,229997,229998,230838,230895,231342,231343,231344,231345,231346,231347,231348,231349,231350,231351,231352,231373,231431,231432,231433,231437,231656,231657,231688,232149,232412,232413,232496,232654,232655,232833,232834,233209,9000058,9000059,9100045}, pool = "kalimdor" },
    { entries = {2756,3101,3111,3112,3113,3114,3115,3116,3117,3118,3129,3139,3142,3163,3164,3165,3166,3167,3168,3169,3170,3171,3172,3173,3174,3175,3183,3189,3191,3193,3195,3196,3197,3198,3199,3203,3204,3208,3216,3265,3266,3267,3268,3283,3286,3287,3293,3294,3332,3336,3337,3365,3370,3371,3372,3412,3438,3501,3521,3620,3706,3881,4311,4485,5029,5034,5606,5609,5610,5611,5613,5614,5639,5640,5810,5822,5826,5875,5880,5892,5900,5909,5910,5943,5953,6027,6491,6586,6607,6787,6928,6986,6987,7010,7790,7792,7793,8576,8659,9317,9336,9987,10880,11025,11176,11681,11682,11683,11814,11943,12430,12790,12791,12794,13842,14304,14375,14376,14377,14392,14451,14498,14499,15012,15116,15188,15572,16868,16869,17304,19175,19850,23511,23533,23603,23604,23605,23606,23685,23696,23971,23973,24484,24492,24493,24495,24497,24498,24499,24501,24510,24527,24657,24711,27806,27810,27811,27812,27813,27814,27816,27817,27818,27819,27820,29346,32798,32837,34232,34233,34258,34261,34284,34382,34383,34477,34482,34545,34955,35086,35095,35251,35253,36384,36385,36673,37911,37912,39267,39268,39269,39270,39323,39324,39325,39326,39351,39352,39353,39379,39380,39408,39423,39590,39604,39609,40435,40890,40891,40892,40893,40948,40949,41140,41621,42506,42638,42650,42671,42672,42946,43062,43239,43949,43953,43956,43957,44013,44120,44380,45230,45244,45540,45544,45830,46080,46181,46891,46901,47418,47663,49573,49750,50550,51230,53081,53977,54004,54141,54142,54146,54170,54472,55054,55382,58193,61844,61846,61866,61867,61868,61869,62193,62194,62195,62196,62197,62198,62199,62200,63061,64105,65008,66437,67038,67040,71100,72282,72559,89175,95234,96199,100453,100866,100873,107554,107719,108787,108788,108789,113118,113547,113953,122065,126066,133407,133519,133523,134711,135202,135205,135206,135207,135208,135211,137762,139093,139500,139501,140176,141705,141707,141804,141826,141845,141961,143845,144323,145416,145417,145418,145531,145532,145533,146152,146268,146290,147259,147345,148242,148250,148263,148265,148768,148770,148795,149258,149270,149290,149296,149371,149404,149408,149409,149522,150909,152977,154464,155739,155784,155785,155786,155787,155788,155789,155926,155928,155929,156119,156120,156121,156125,156126,156528,157022,157023,157207,158131,158133,158141,158347,158789,160452,162190,167307,168431,168441,168540,168545,169177,171791,173281,173548,175084,176261,176554,180684,184786,184787,184793,184795,184796,185512,189389,189390,190535,193050,193450,195899,197279,197483,197767,198070,198391,198442,198461,198497,198536,198537,198538,198539,198540,198541,198552,199115,199164,199273,199275,199277,199280,199288,209803,212916,221293,225509,229257,229348,230720,234615,245588,248956,249139,252933,254688,900166,900167}, pool = "durotar" },
    { entries = {50302,3225,2966,36696,2620,29873,44338,49773,1420,4953,14881,5951,883,1412,49743,49837,42548,50939}, pool = "critter" },
    { entries = {3144,39605,86832,54870,17098,46140,46142,35068,46555,46556,58155,52034,88543,16012,49622,52382,42637,4047,23128,47571,145424,184664,184666}, pool = "court" },
    { entries = {89830,27815,52809,8404}, pool = "crier" },
    { entries = {46667,3354,3353}, pool = "drill" },
    { entries = {9900125, 19176}, pool = "tauren" },
    { entries = {9900120,9900121,9900123,9900124,1383,2855,2857,5811,6466,7951,9564,10266,11046,11066,12136,16076,19177,23635,26537,29143,34765,35364,44158,44160,45015,45211,45780,45814,45822,46078,46082,47321,57801,58199,74228,133186,144315,144318,144321,149279,149523,149616,150131,173386,186199,242550,242566}, pool = "civilian" },
}

local LOUD = { crier = true, drill = true }  -- these YELL instead of say

-- Body language that matches the line: questions shrug, shouts exclaim,
-- jokes laugh, greetings bow/salute, the rest gestures while talking.
local EMOTE_TALK, EMOTE_BOW, EMOTE_WAVE, EMOTE_CHEER, EMOTE_EXCLAIM, EMOTE_QUESTION =
    1, 2, 3, 4, 5, 6
local EMOTE_LAUGH, EMOTE_SALUTE, EMOTE_POINT, EMOTE_YES, EMOTE_NO = 11, 66, 25, 273, 274

local function EmoteFor(line)
    local l = string.lower(line)
    if string.find(l, "^%*") then return nil end -- *animal sound*
    if string.find(l, "^ha[!%.]") or string.find(l, "ha!") then return EMOTE_LAUGH end
    if string.find(l, "for the horde") or string.find(l, "lok'tar") or string.find(l, "victory") then return EMOTE_CHEER end
    if string.find(l, "^hail") or string.find(l, "strength and honor") or string.find(l, "throm%-ka") then return EMOTE_SALUTE end
    if string.find(l, "^ishnu") or string.find(l, "elune") or string.find(l, "^well met") or string.find(l, "^greetings") then return EMOTE_BOW end
    if string.find(l, "^hello") or string.find(l, "^morning") or string.find(l, "^evening") or string.find(l, "welcome") then return EMOTE_WAVE end
    if string.find(l, "^aye") or string.find(l, "^yes") or string.find(l, "^true") or string.find(l, "^good") then return EMOTE_YES end
    if string.find(l, "^no[%.!, ]") or string.find(l, "^never") then return EMOTE_NO end
    if string.find(l, "over here") or string.find(l, "north") or string.find(l, "south") or string.find(l, "ridge") then return EMOTE_POINT end
    if string.find(l, "%?$") then return EMOTE_QUESTION end
    if string.find(l, "!$") then return EMOTE_EXCLAIM end
    return EMOTE_TALK
end


-- Who may speak, and in what voice. Pets, familiars, summons and constructs never talk; the rest speaks in the voice of its role
-- (guard, vendor, trainer, innkeeper, banker, civilian) so a merchant does not bark like a sentry.
local NONSPEAK = {"familiar", "imp$", "^imp ", "voidwalker", "felhunter", "succubus", "felguard", "infernal", "doomguard", "wisp", "golem", "elemental",
    "skeleton", "ghoul", "zombie", "abomination", "gargoyle", "spirit", "ghost", "totem", "trigger", "dummy", "target", "minion", "guardian of", "pet$"}
local function Silent(creature)
    local okN, name = pcall(function() return creature:GetName() end)
    if not okN or type(name) ~= "string" then return false end
    name = string.lower(name)
    for _, pat in ipairs(NONSPEAK) do if string.find(name, pat) then return true end end
    local okS, summoned = pcall(function() return creature:GetOwner() ~= nil end)   -- a summon or pet belongs to someone
    return okS and summoned or false
end
local GUARD_NAMES = {"guard", "sentinel", "watchman", "watcher", "soldier", "grunt", "warden", "protector", "defender", "patrol", "legionnaire", "lookout", "sergeant", "captain", "footman", "militia", "scout"}
local function RoleOf(creature)
    local okF, flags = pcall(function() return creature:GetNPCFlags() end)
    flags = okF and tonumber(flags) or 0
    local function Has(bit) return math.floor(flags / bit) % 2 == 1 end   -- this Lua has no bitwise operators
    if Has(128) then return "vendor" end
    if Has(65536) then return "innkeeper" end
    if Has(131072) or Has(2097152) then return "banker" end
    if Has(16) then return "trainer" end
    local okN, name = pcall(function() return creature:GetName() end)
    name = okN and type(name) == "string" and string.lower(name) or ""
    for _, g in ipairs(GUARD_NAMES) do if string.find(name, g) then return "guard" end end
    return "civilian"
end
local ROLE_LINES = {
    vendor = {"Fresh stock came in this morning.", "Prices are fair. Mostly.", "Business is slow today.", "Care to look at my wares?", "Coin first, goods after. That is how it works.",
        "The caravans are late again. Supplies are thin.", "Everything is better than the last stall's. Ask anyone."},
    trainer = {"Practice makes the difference between a hero and a corpse.", "Footwork. Always footwork.", "A good student asks questions. A great one practises.",
        "Another batch of recruits. At least they are keen.", "Patience. Skill does not come in a day."},
    innkeeper = {"A warm bed and a hot meal, that is all a traveller needs.", "Stew is on, ale is cold.", "Mind the stairs, they creak.",
        "Rooms are full on market days.", "Every traveller has a story. I have heard them all."},
    banker = {"Your coin is safe with us.", "No loans. Not today, not ever.", "Counting never ends in this business.", "Vault keys are not toys."},
    civilian = {"Quiet day, for once.", "My feet hurt.", "I heard there was trouble on the road.", "The weather keeps changing.", "Have you eaten yet?",
        "Everyone is in a hurry these days.", "I should get back to work.", "Did you hear that noise last night?", "Markets are busier than ever.", "I hope the harvest holds."},
}

local function LoudSay(creature, line)
    if LOUD[creature:Data():Get("org_pool")] then
        creature:SendUnitYell(line, 0)
    else
        creature:SendUnitSay(line, 0)
    end
    local e = EmoteFor(line)
    if e and math.random() < 0.2 then pcall(function() creature:PerformEmote(e) end) end   -- an emote with one line in five, not with every line
end

local function SayLater(creature, line, delay)
    creature:RegisterEvent(function(_, _, _, c)
        if c and c:IsAlive() then LoudSay(c, line) end
    end, delay, 1)
end

-- Race voice: short greetings in the voice of each race.
-- Checked against lore; used for solo lines alongside role lines.
local RACE_LINES = {
    [2]  = {"Lok'tar ogar!", "Blood and thunder!"},                 -- Orc
    [5]  = {"Death is only the beginning.", "The Dark Lady watches over us."}, -- Undead
    [6]  = {"Walk with the Earthmother.", "The Earthmother provides."},         -- Tauren
    [8]  = {"Stay awhile, mon.", "Voodoo watch over ya, mon.", "Da loa be watchin' us, mon.", "Easy, mon. De sea be calm tonight.", "Sen'jin be proud, ya hear?", "Dis island, she be home, mon.", "De spirits whisper... listen close."},     -- Troll
    [9]  = {"Time is money, friend!", "Everything's for sale!"},    -- Goblin
    [10] = {"Anar'alah.", "Remember the Sunwell."},                 -- Blood Elf
}


-- Race of a creature: creatures carry no race, so it is read from the faction and the name (trolls speak like trolls, not like orcs).
local FACTION_RACE = {[126] = 8, [29] = 2, [85] = 2, [104] = 6, [68] = 5, [2] = 2, [1604] = 10, [1620] = 10, [1117] = 9, [11] = 1, [12] = 1, [55] = 3, [54] = 7, [79] = 4}
local function RaceOf(c)
    local okR, r = pcall(function() return c:GetRace() end)
    if okR and type(r) == "number" and r > 0 then return r end
    local okF, f = pcall(function() return c:GetFaction() end)
    if okF and FACTION_RACE[f] then return FACTION_RACE[f] end
    local n = string.lower(c:GetName() or "")
    if string.find(n, "darkspear", 1, true) or string.find(n, "troll", 1, true) or string.find(n, "witch doctor", 1, true) or string.find(n, "headhunter", 1, true) then return 8 end
    return 0
end

local CRITTER_RANGE = 12
local CRITTER_CHANCE = 0.25

-- Animal sounds by entry. Beasts never speak - they grunt, oink and hiss.
local CRITTER_LINES = {
    [50302] = {"*oink!*", "*snort snort*"},
    [3225]  = {"*oink!*", "*snort*"},
    [2966]  = {"*oink...*"},
    [36696] = {"*SNOORT!*"},
    [2620]  = {"*woof!*", "*bark bark!*"},
    [29873] = {"*mew.*", "*purr...*"},
    [44338] = {"*cluck cluck!*"},
    [49773] = {"*cluck!* *whirr*"},
    [1420]  = {"*ribbit.*"},
    [4953]  = {"*hisss...*"},
    [14881] = {"*skitter skitter*"},
    [5951]  = {"*sniff sniff*"},
    [883]   = {"*snort*"},
    [1412]  = {"*chitter!*"},
    [49743] = {"*click-click*", "*skitter*"},
    [49837] = {"*skitter*"},
    [42548] = {"*click...*"},
    [50939] = {"*bellow...*"},
}
local CRITTER_DEFAULT = {"*sniff*", "*scratch scratch*"}

-- =====================================================================
-- Regions: the pools above were written for Orgrimmar. Outside the city
-- an NPC speaks from its region pack instead, so a night elf in Dolanaar
-- never gossips about Ratchet caravans or Grommash festivals.
-- =====================================================================

local ZONE_REGION = {
    [1637] = "org",                                    -- Orgrimmar
    [14] = "durotar",                                  -- Durotar
    [17] = "barrens",                                  -- Northern Barrens
    [141] = "nightelf", [1657] = "nightelf",           -- Teldrassil, Darnassus
    [148] = "nightelf", [331] = "nightelf",            -- Darkshore, Ashenvale
    [493] = "nightelf",                                -- Moonglade
    -- capitals and their lands (living world v2)
    [1519] = "human",
    [12] = "human",
    [40] = "human",
    [44] = "human",
    [10] = "human",
    [4922] = "human",
    [1537] = "dwarf",
    [1] = "dwarf",
    [38] = "dwarf",
    [11] = "dwarf",
    [47] = "dwarf",
    [1497] = "forsaken",
    [85] = "forsaken",
    [130] = "forsaken",
    [267] = "forsaken",
    [1638] = "tauren",
    [215] = "tauren",
    [3487] = "sindorei",
    [3430] = "sindorei",
    [3433] = "sindorei",
    [3557] = "draenei",
    [3524] = "draenei",
    [3525] = "draenei",
    [3703] = "shattrath",
    [3519] = "shattrath",
    [4395] = "dalaran",
    [7502] = "dalaran",
    [13862] = "valdrakken",
    [13644] = "valdrakken",
    [14717] = "earthen",
    [14771] = "earthen",
}

local CT_BEAST, CT_HUMANOID, CT_CRITTER = 1, 7, 8

local function RegionOf(creature)
    local ok, zone = pcall(function() return creature:GetZoneId() end)
    if not ok then return "neutral" end
    return ZONE_REGION[zone] or "neutral"
end

local function RegionKey(creature)
    local pool = creature:Data():Get("org_pool")
    if pool == "troll" or pool == "tauren" then return pool end
    return RegionOf(creature)
end

local function TypeOf(creature)
    local ok, t = pcall(function() return creature:GetCreatureType() end)
    return ok and t or 0
end

local PACKS = {
    durotar = {
        solo = {
            "Durotar sun burns fierce today.",
            "Razormane raiders hit the southern farms again.",
            "Water is life out here. Remember that.",
            "Keep to the road. The scorpids don't care who you are.",
            "Red rock, red sun. Home.",
            "Burning Blade cultists in Skull Rock. Nobody goes in alone.",
            "Kul Tiran sails off the coast again. Tiragarde Keep watches us.",
            "Sen'jin's trolls fish better than any orc I know.",
            "The Valley of Trials still makes warriors out of whelps.",
            "Razor Hill holds. It always holds.",
            "Thunder Ridge rumbles at night. Something big lives up there.",
            "Drygulch Ravine is crawling with harpies. Stay clear.",
            "A good wolf is worth more than a good sword out here.",
            "The Southfury runs low this season.",
            "Dust storm coming from the east. Cover your eyes.",
            "Crops won't grow in this soil. We grow warriors instead.",
            "Bloodtalon raptors hunt along the shore. Watch your back.",
            "Thrall named this land for his father. Remember that.",
            "Caravans from the Barrens come slower every year.",
            "The Echo Isles are quiet now. The Darkspear made sure of it.",
            "My kodo threw a shoe. Again.",
            "Smell that? Rain, maybe. Or just wishful thinking.",
            "Quillboar tracks by the river. Fresh ones.",
            "Another day guarding rocks. Glorious.",
        },
        dialogues = {
            {"Seen any quillboar?", "South ridge. Big party of 'em."},
            {"Well's running low.", "Then we dig deeper. Like always."},
            {"Cultists at Skull Rock again?", "Burning Blade never learns.", "Then we keep teaching them."},
            {"Kul Tiran ship spotted off the coast.", "Let them come. The rocks hunger."},
            {"Raptor took one of the goats.", "Bloodtalons. Set a watch tonight."},
            {"Heading to Razor Hill?", "If my wolf doesn't quit on me first."},
            {"The harpies are bolder this year.", "Hungry. Like everything in this land."},
            {"Troll fishermen want salt.", "Trade them for it. Their fish is worth it."},
            {"Storm on the horizon.", "Dry storm. All wind, no water.", "Typical Durotar."},
            {"How's the new recruit?", "Survived the Valley of Trials. Barely."},
            {"Smell of smoke from the north.", "Probably the smithies in the city.", "Or trouble. Keep your axe close."},
            {"My boy found a scorpid in his boot.", "Lucky it was only his boot."},
        },
        greet = {"Throm-ka.", "Safe travels on the road.", "Watch for raiders, stranger.", "Lok'tar."},
    },
    nightelf = {
        solo = {
            "Elune's light guides us, even in the darkest hour.",
            "Ishnu-alah.",
            "The forest is uneasy tonight.",
            "The Gnarlpine were our friends once. Something poisoned them.",
            "The Sentinels keep their watch. We sleep because they do not.",
            "Shan'do Stormrage still walks the Emerald Dream, they say.",
            "The moon is bright. A good omen.",
            "Even the wisps seem restless lately.",
            "Lake Al'Ameth was calm this morning. Peaceful.",
            "The hippogryphs are restless. Weather is turning.",
            "Ten thousand years, and still the forest teaches me something new.",
            "Ban'ethil Barrow Den should be sealed. Nothing good sleeps there.",
            "I miss the old forests of Hyjal.",
            "Walk softly. The trees remember every footstep.",
            "The druids say the Dream is troubled.",
            "Tyrande's priestesses pray through the night.",
            "Nightsabers hunt by the old ruins. Keep your distance.",
            "The timbermaw do not trust us. Perhaps they are wise.",
            "Another dawn. Another vigil.",
            "The boats to Darkshore run late again.",
            "The Wardens are watching again. Strange times.",
            "Our immortality is gone. Every season matters now.",
            "Cenarius would weep to see the forests burn.",
            "Moonwell water heals what blades cannot.",
            "The harpies are building nests near the cliffs again.",
        },
        dialogues = {
            {"Ishnu-alah, sister.", "Ishnu-dal-dieb. Elune guide you."},
            {"Did you hear the owls last night?", "They warned of something. I only wish I knew what."},
            {"The Gnarlpine attacked a traveler near the road.", "Corruption spreads. The druids must act."},
            {"Have you seen the Wardens in Dolanaar?", "Velarys keeps to herself.", "As Wardens always have."},
            {"The moonwell glows brighter tonight.", "Elune is close. Good."},
            {"Will you go to Darnassus for the festival?", "If my watch allows it. It rarely does."},
            {"The nightsabers took another deer.", "The forest feeds itself. Let it be."},
            {"Strange tracks near the barrow den.", "Furbolg?", "Too large for a furbolg."},
            {"My bow string snapped this morning.", "Spider silk. It holds better than anything."},
            {"The Dream feels distant lately.", "The druids say the same.", "Then we keep faith until it returns."},
            {"Do you miss the old ways?", "Every day. But the old ways nearly destroyed us."},
            {"A hippogryph landed with news from Auberdine.", "Good news, I hope.", "Is there any other kind lately?", "...Sadly, yes."},
            {"The young ones are training with the Sentinels.", "Good. Our numbers are thin."},
        },
        greet = {"Ishnu-alah.", "Elune-adore.", "Walk with Elune, traveler.", "Welcome, friend."},
    },
    barrens = {
        solo = {
            "Another dust storm rolling in from the south.",
            "Kolkar centaur raided a caravan near the Stagnant Oasis.",
            "The Crossroads stands. It has stood through worse than centaurs.",
            "Water from the oasis tastes like mud. Still better than nothing.",
            "Harpies in the Dry Hills again. Keep away from the cliffs.",
            "The Razormane are pushing north. Quillboar think this land is theirs.",
            "Goblins in Ratchet will sell you anything. Even your own boots.",
            "Zhevra herds are thin this year. Hunters went too far south.",
            "Wailing Caverns... the druids went in and never came out right.",
            "Kodo bones as far as you can see out east. Don't go there at night.",
            "Caravans come in dusty and leave dustier.",
            "The tauren say the land remembers. Out here, it remembers thirst.",
            "Hot wind, red sun, long road. Barrens life.",
        },
        dialogues = {
            {"Centaur sign on the south road.", "Kolkar or Magram?", "Does it matter? Both shoot first."},
            {"Water's low in the troughs.", "Then the kodos drink first. Then us."},
            {"Heard Ratchet's raising tariffs.", "Goblins. They'd tax the wind if they could."},
            {"Watch tower saw lights at the Lushwater Oasis.", "Druids, maybe.", "Or something wearing a druid's skin."},
            {"My cousin went to the Wailing Caverns.", "And?", "He hasn't stopped screaming in his sleep since."},
            {"Long caravan coming in from Camp Taurajo.", "Good. We need grain more than gossip."},
            {"Dust in my boots, dust in my bread.", "Welcome to the Barrens, friend."},
        },
        greet = {"Welcome to the Crossroads.", "Shade's by the inn, traveler.", "Safe roads.", "Lok'tar, stranger."},
    },
    tauren = {
        solo = {
            "The Earthmother watches over all who walk these plains.",
            "Walk softly. The land hears every step.",
            "My herd waits in Mulgore. I will return before the rains.",
            "An'she rises, Mu'sha follows. All is in balance.",
            "The winds carry the voices of our ancestors.",
            "Patience, young one. The plains were not grown in a day.",
            "Thunder Bluff is far, but the spirits travel with me.",
            "A kodo remembers every road it has walked. So do I.",
        },
        dialogues = {
            {"The grass is thin this season.", "The Earthmother gives what she can. We take only what we need."},
            {"Have you heard from Thunder Bluff?", "The elders are troubled. They speak of the Grimtotem again."},
            {"The orcs are loud.", "They are young. Give them a few thousand years."},
            {"Will you hunt with us tomorrow?", "If the spirits allow it. And if my knees allow it."},
        },
        greet = {"Walk with the Earthmother.", "Peace be with you, traveler.", "May the winds guide you."},
    },
    troll = {
        solo = {
            "Ya be welcome here, mon. Just keep ya hands where I can see 'em.",
            "Da Loa be watchin' dis city. Every corner, every shadow.",
            "Darkspear never die, mon. We bend, but we never break.",
            "Vol'jin be gone, but his spirit walk wit' us still.",
            "Bwonsamdi be waitin' for all of us... but not today.",
            "Da Echo Isles be home. Dis city just be where da work is.",
            "Too loud here for a troll's ears. Orcs, dey shout even when dey whisper.",
            "Ya smell dat? Somebody be burnin' da good herbs.",
            "Spirits be restless tonight, mon. Somethin' be comin'.",
            "Sen'jin taught us: a troll who stand alone, fall alone.",
            "Keep away from da voodoo shop if ya don't know what ya doin'.",
            "Zandalari envoys walkin' around like dey own da place. Hmph.",
            "Ya got da look of a hero. Or a fool. Hard to tell wit' you outsiders.",
            "Me grandmudda say: never trust a smilin' goblin.",
            "Stay sharp, mon. Even in da city, da jungle be watchin'.",
            "Hah! Ya walk like ya never seen a troll before.",
        },
        dialogues = {
            {"Ya hear da drums last night, mon?", "Da Loa be talkin'. Somebody gonna get a vision.", "As long as it not be me."},
            {"Dese orcs, always shoutin'.", "Dat be how dey say hello, mon.", "Hah! Den dey say hello all day."},
            {"Ya miss da Echo Isles?", "Every day, mon. Da sea, da sand, da raptors.", "Da raptors? Ya miss da raptors?", "...Some of dem."},
            {"Zandalari came by da Valley again.", "Dey want somethin'. Dey always want somethin'.", "Den we give 'em nothin', mon."},
            {"Ya got any of dat jerky left?", "Raptor or boar?", "Whatever don't bite back."},
            {"Watch shift be long tonight.", "Long shift, good pay. Bwonsamdi don't pay at all, mon."},
            {"Saw a hero trip on da stairs.", "Hah! Da mighty fall, mon.", "Right on dey face!"},
            {"Ya think Vol'jin be proud of us?", "We still standin', mon. Dat be enough."},
        },
        greet = {"Ya mon.", "Welcome, mon.", "Stay outta trouble, mon.", "Da Loa be wit' ya.", "Hey dere, hero."},
    },
    neutral = {
        solo = {
            "Long road ahead.",
            "Weather's turning.",
            "Keep an eye on the treeline.",
            "Safe travels.",
            "Quiet day. I'll take it.",
            "These lands were peaceful, once.",
            "Something's been spooking the wildlife.",
            "I could use a hot meal and a dry bed.",
            "Bandits on the road last week. Stay alert.",
            "Strange lights in the sky last night.",
            "My feet ache. Too many miles.",
            "Rain soon. I can feel it in my knees.",
            "The wilds bite the careless.",
            "Another day, another coin.",
        },
        dialogues = {
            {"Anything on the road?", "Tracks. Nothing that walked on two legs."},
            {"You look tired.", "Long watch. Longer night."},
            {"Heard any news?", "Only rumors. Rumors and more rumors."},
            {"Weather's turning.", "It always does when you need it not to."},
            {"Supplies come in?", "Half of them. The other half, who knows."},
        },
        greet = {"Well met.", "Safe travels.", "Greetings, traveler."},
    },
    human = {
        solo = {
            "Light bless you, friend.",
            "The Stockades are full again. Defias, mostly.",
            "Westfall farmers came begging for grain this morning.",
            "The Cathedral bells will ring at noon.",
            "My cousin joined the Stormwind Guard. Mother cried for a week.",
            "Tavern in the Trade District has the best stew in the city.",
            "The canals stink in summer. Every summer.",
            "Gnomes at the tram again. Something exploded, I think.",
            "King Anduin spoke at the Keep yesterday. Fine words.",
            "The Redridge bridge is finally repaired, they say.",
            "Murlocs in Elwynn's lakes again. Mrglglgl, all night long.",
            "Goldshire's inn is never quiet. Never.",
            "The harbor is busy. Ships from Kul Tiras, Boralus coin.",
            "Kobolds in the Fargodeep Mine. Don't take the candle.",
            "Price of bread went up again.",
            "The Old Town veterans never stop telling war stories.",
            "Night watch says something howls in Duskwood.",
            "Mages' Quarter smells of brimstone today.",
            "Lion's Pride Inn. Best place to hear rumors.",
            "SI:7 agents everywhere. Or nowhere. Hard to tell.",
        },
        dialogues = {
            {"Heading to Goldshire?", "Only if the road's clear of kobolds.", "It never is."},
            {"Did you hear the Defias are back?", "They never left. Just hid better."},
            {"Fine weather for the market.", "Fine weather for taxes, you mean."},
            {"My boy wants to be a paladin.", "Light keep him. It's a hard road."},
            {"The guard doubled at the gates.", "Orc spies, they say.", "Or just the Captain being nervous."},
            {"Ship from Kul Tiras docked last night.", "Fresh fish at the market, then!"},
            {"Have you seen the new statue in the Valley of Heroes?", "Taller than the last one. Prouder too."},
            {"Westfall's harvest failed again.", "Then Stormwind feeds them. As always."},
            {"Duskwood's gone darker than ever.", "Worgen, ghouls, and worse.", "I'll stay in the city, thanks."},
            {"The tram to Ironforge broke down.", "Gnomes will fix it.", "Gnomes broke it."},
        },
        greet = {"Good day to you.", "Light be with you.", "Welcome to Stormwind, traveler.", "Mind the canals."},
    },
    dwarf = {
        solo = {
            "Another round, and make it Thunderbrew!",
            "The Great Forge never sleeps, lad.",
            "Bronzebeard, Wildhammer, Dark Iron - the Council holds, aye.",
            "Snow in the pass again. Bring a warm cloak.",
            "Explorers' League found another Titan ruin. Third this month.",
            "Troggs in the old mines. Nasty wee beasts.",
            "Loch Modan's dam still holds. Built proper, it was.",
            "Ram's got a limp. Poor beast.",
            "Nothing like the warmth of the forge on a cold morning.",
            "My beard's longer than my brother's now. Don't tell him.",
            "Gnomeregan... someday the gnomes'll take it back.",
            "The Deeprun Tram rattles worse every day.",
            "Wildhammers flying gryphons over the Hinterlands again.",
            "A good hammer, a good ale, and a good fight. That's life.",
            "Dark Irons at the Forge. Strange times, but they work hard.",
            "Frostmane trolls in the hills. Keep yer axe close.",
        },
        dialogues = {
            {"Fancy a pint?", "Is the sky blue? Is the forge hot?", "Aye, then."},
            {"Heard the Explorers found a vault in Uldaman.", "Titans again? Ach, my head hurts already."},
            {"Ye look half frozen, lad.", "Dun Morogh in winter. Need I say more?"},
            {"My ram threw me in the snow.", "Then ye deserved it. Treat her better."},
            {"The Dark Irons drink more than we do now.", "Impossible.", "I've seen it with me own eyes!"},
            {"Gnomes blew up the tram again.", "They say it was an 'improvement'."},
            {"The Great Forge burns brighter tonight.", "Big order for the Alliance, they say."},
            {"Ever been to Grim Batol?", "Never. And never will.", "Smart dwarf."},
        },
        greet = {"Well met!", "Ho there, friend!", "Welcome to Ironforge!", "Mind yer head, lad."},
    },
    forsaken = {
        solo = {
            "The living stare. Let them.",
            "The apothecaries are busy again. Do not ask with what.",
            "Lordaeron was beautiful once. I remember.",
            "Our Banshee Queen is gone. We remain.",
            "Scarlet zealots burned another of us at Brill.",
            "Death is not the end. Merely an inconvenience.",
            "The bats are restless tonight.",
            "Tirisfal's fog never lifts. Good.",
            "The Royal Quarter echoes with old memories.",
            "I used to eat bread. I don't miss it.",
            "The Val'kyr are gone. Every death is final now.",
            "Silverpine's worgen howl all night.",
            "The plague cauldrons are cold. For now.",
            "Free will. That is what we fought for.",
        },
        dialogues = {
            {"Still rotting?", "Slowly. You?", "Gracefully."},
            {"The Scarlets hit Brill again.", "Then we bury them. And raise them."},
            {"Remember the sun on the palace walls?", "Every day. It is all I have left."},
            {"Apothecary Lydon wants volunteers.", "For what?", "He didn't say. That's never good."},
            {"The living came to trade.", "Take their coin. Mind your fingers."},
            {"Do you dream?", "We don't sleep.", "Then I suppose not."},
        },
        greet = {"Dark Lady watch over you.", "Victory for the Forsaken.", "What do you want, living one?", "Welcome to the Undercity."},
    },
    sindorei = {
        solo = {
            "Silvermoon shines again. As it should.",
            "The Sunwell's light fills me with strength.",
            "Shorel'aran.",
            "The Scourge scars in Eversong are almost healed.",
            "Magisters argue in the Court of the Sun again.",
            "The arcane guardians need maintenance. Again.",
            "Ghostlands are still haunted. Avoid Deatholme.",
            "Fine silks from the Bazaar. Exquisite.",
            "We survived the Third War. We survive anything.",
            "The Farstriders watch the borders. Always.",
            "Zul'Aman's trolls stir in the east.",
            "The Shepherd's Gate stands. Barely.",
        },
        dialogues = {
            {"Have you seen the new robes in the Bazaar?", "Gaudy. I bought three."},
            {"The Sunwell feels stronger today.", "Light and Void both. Strange times."},
            {"Another trader from the Horde in the city.", "Orcs in Silvermoon. Who would have thought."},
            {"Will you attend the magisters' gala?", "Only if the wine is from Quel'Danas."},
            {"Farstriders found trolls near the border.", "Amani never learn."},
        },
        greet = {"Bal'a dash, malanore.", "Shorel'aran.", "Welcome to Silvermoon.", "Sinu a'manore."},
    },
    draenei = {
        solo = {
            "The Light guides us, as it always has.",
            "The Exodar hums with naaru song.",
            "Velen sees paths none of us can.",
            "The crystals heal what they can. The rest heals with time.",
            "Bloodmyst's corruption fades slowly.",
            "We fled Argus. We fled Draenor. Azeroth is home now.",
            "The vindicators train at dawn.",
            "Satyrs in the woods near Azure Watch. Be careful.",
            "Mother says the stars look different here.",
            "Every world we flee teaches us something.",
        },
        dialogues = {
            {"May the Light embrace you.", "And you, friend.", "Always."},
            {"The engines of the Exodar sing again.", "Repairs go well, then. Good."},
            {"Have you visited Shattrath?", "Once. It reminded me of home.", "Which one?"},
            {"The naaru spoke today.", "What did it say?", "Hope. It always says hope."},
            {"Our children speak Common better than Draenei now.", "Then Azeroth truly is home."},
        },
        greet = {"Light be with you.", "Good fortune to you.", "Welcome to the Exodar.", "Archenon poros."},
    },
    shattrath = {
        solo = {
            "A'dal watches over all of us.",
            "Aldor and Scryer bicker again.",
            "Refugees from every corner of Outland gather here.",
            "The Lower City is crowded but safe.",
            "The naaru light keeps the demons out.",
            "Arakkoa traders came down from Skettis. Odd folk.",
            "Hellfire still burns on the horizon.",
            "The World's End Tavern never closes.",
        },
        dialogues = {
            {"Aldor or Scryer?", "Neither. I like my neck where it is."},
            {"Have you seen the naaru up close?", "Once. I wept and didn't know why."},
            {"Ogres at the gates again.", "They want trade, not war. This time."},
            {"Netherstorm is falling apart.", "Then we hold on to what remains."},
        },
        greet = {"Peace of the naaru be with you.", "Welcome to Shattrath.", "Light shine on you.", "Watch your purse in the Lower City."},
    },
    dalaran = {
        solo = {
            "Mind the floating books, they bite.",
            "The Kirin Tor convene again. Endless meetings.",
            "Somebody turned the fountain into lemonade. Again.",
            "Magic is not a toy, apprentice!",
            "The Violet Citadel glows brighter tonight.",
            "Portals to every corner of the world. Pick one.",
            "The sewers are full of rogues and worse.",
            "Antonidas would be proud of this city.",
            "Another apprentice turned into a sheep. Third today.",
            "The Underbelly? Never heard of it.",
        },
        dialogues = {
            {"Who left this portal open?", "Not me.", "It's always 'not me' in Dalaran."},
            {"The archmages argued all night.", "About what?", "About what to argue about."},
            {"My familiar ate my spellbook.", "Then you'll have to learn it by heart."},
            {"Have you seen Khadgar?", "He was here a moment ago.", "That's Khadgar for you."},
        },
        greet = {"Welcome to Dalaran.", "Mind the portals.", "Greetings, traveler.", "Watch for enchanted brooms."},
    },
    valdrakken = {
        solo = {
            "The Aspects hold council in the Seat of the Aspects.",
            "Drakes overhead. You get used to it.",
            "The Dragon Isles are waking after ten thousand years.",
            "Tuskarr trade fish for everything.",
            "Centaur raiders in the Ohn'ahran Plains again.",
            "The Primalists were defeated. Mostly.",
            "Dracthyr walk among us now. Fascinating.",
            "The Ruby Lifeshrine pulses with life.",
        },
        dialogues = {
            {"Have you flown with the drakes?", "Once. I'm never doing it again.", "Liar. You loved it."},
            {"Alexstrasza spoke at the Seat.", "Life finds a way, she said.", "She always says that."},
            {"Tuskarr soup again tonight?", "Is there anything else in this city?"},
        },
        greet = {"Welcome to Valdrakken.", "May the Aspects watch over you.", "Mind the dragons, traveler.", "Safe skies."},
    },
    earthen = {
        solo = {
            "The stone remembers.",
            "Dornogal stands strong on the Isle of Dorn.",
            "The Coreway runs deep beneath us.",
            "The nerubians stir below. We watch.",
            "Machine Speakers argue about the old protocols again.",
            "Every earthen has a purpose. Some still search for theirs.",
            "Hallowfall's light reaches even here.",
        },
        dialogues = {
            {"Do you dream of the Titans?", "We do not dream.", "Then what is it I see at night?"},
            {"The nerubians attacked a caravan in the deeps.", "Then we send more guards. Stone does not yield."},
            {"Have you seen the surface folk?", "Loud. Short-lived. Interesting."},
        },
        greet = {"Welcome to Dornogal.", "Stone endure.", "Greetings, surface dweller.", "Walk firmly."},
    },
}

-- No-repeat picker: remembers the last half of every list it drew from,
-- so the same line never comes back until most others were used.
local RECENT = {}
local function Pick(list, key)
    if not list or #list == 0 then return nil end
    if #list == 1 then return list[1] end
    local mem = RECENT[key]
    if not mem then mem = {} RECENT[key] = mem end
    local free = {}
    for i = 1, #list do
        local used = false
        for _, j in ipairs(mem) do if j == i then used = true break end end
        if not used then free[#free + 1] = i end
    end
    local idx = free[math.random(#free)]
    mem[#mem + 1] = idx
    while #mem > math.floor(#list / 2) do table.remove(mem, 1) end
    return list[idx]
end

local function PlayLines(cast, conv)
    -- speakers turn to each other before talking
    if #cast >= 2 then
        pcall(function()
            cast[1]:SetFacingToObject(cast[2])
            for k = 2, #cast do cast[k]:SetFacingToObject(cast[1]) end
        end)
    end
    for i, line in ipairs(conv) do
        local speaker = cast[((i - 1) % #cast) + 1]
        if i == 1 then
            LoudSay(speaker, line)
        else
            SayLater(speaker, line, (i - 1) * math.random(4000, 7000))
        end
    end
end

-- Up to two nearby talkers that pass the filter join the conversation.
local function GatherCast(creature, accept)
    local cast = { creature }
    local partners = creature:GetCreaturesInRange(25)
    if partners then
        for _, o in ipairs(partners) do
            if #cast >= 3 then break end
            if o and o ~= creature and o:IsAlive() and not Silent(o) and accept(o) then
                cast[#cast + 1] = o
            end
        end
    end
    return cast
end

local function RegionTalk(creature, region)
    local pack = PACKS[region]
    local cast = GatherCast(creature, function(o)
        return o:Data():Get("org_pool") ~= nil and TypeOf(o) == CT_HUMANOID and RegionKey(o) == region
    end)
    if #cast >= 2 and math.random() < DIALOGUE_CHANCE then
        local conv = Pick(pack.dialogues, region .. ":dlg")
        if conv then PlayLines(cast, conv) return end
    end
    local role = creature:Data():Get("org_role") or "civilian"
    if role ~= "guard" and ROLE_LINES[role] and math.random() < 0.85 then
        LoudSay(creature, Pick(ROLE_LINES[role], "role:" .. role))
        return
    end
    local line = Pick(pack.solo, region .. ":solo")
    if line then LoudSay(creature, line) end
end

local function OrgTalk(creature, pool)
    local cast = GatherCast(creature, function(o)
        return o:Data():Get("org_pool") == pool and TypeOf(o) == CT_HUMANOID
    end)
    if #cast >= 2 and math.random() < DIALOGUE_CHANCE + 0.15 then
        -- paired or trio talk: everyday chatter or own-pool dialogue
        local conv
        if math.random() < 0.45 then
            conv = Pick(CHATTER, "org:chatter")
        elseif DIALOGUES[pool] then
            conv = Pick(DIALOGUES[pool], "org:dlg:" .. pool)
        end
        if conv then PlayLines(cast, conv) return end
    end
    if HourEventLine(pool) ~= nil then
        LoudSay(creature, HourEventLine(pool))
        return
    end
    -- alone (or no dialogue): night lines first, then race voice, then role line
    local nl = IsNight() and NIGHT_LINES[pool] or nil
    if nl and #nl > 0 and math.random() < 0.5 then
        LoudSay(creature, Pick(nl, "org:night:" .. pool))
        return
    end
    local race = RaceOf(creature)
    local rl = RACE_LINES[race]
    if rl and math.random() < 0.35 then
        LoudSay(creature, Pick(rl, "org:race:" .. race))
        return
    end
    local lines = LINES[pool]
    if lines then LoudSay(creature, Pick(lines, "org:" .. pool)) end
end

local function OrgrimmarTalk(eventId, delay, repeats, creature)
    if not creature or not creature:IsAlive() then return end
    if AdvDirectorNudge then pcall(AdvDirectorNudge) end
    local pool = creature:Data():Get("org_pool")
    if Silent(creature) then return end
    local ctype = TypeOf(creature)
    -- Only humanoids speak. Beasts and critters make animal sounds, the rest stays silent.
    local animal = pool == "critter" or ctype == CT_BEAST or ctype == CT_CRITTER
    if not animal and ctype ~= CT_HUMANOID then return end
    local talkRange = animal and CRITTER_RANGE or CHECK_RANGE
    local talkChance = animal and CRITTER_CHANCE or TALK_CHANCE
    local players = creature:GetPlayersInRange(talkRange)
    if players and #players > 0 and math.random() < talkChance then
        local okA, areaId = pcall(creature.GetAreaId, creature)
        if not okA or type(areaId) ~= "number" then areaId = 0 end
        if AreaQuiet(areaId) then
            if animal then
                local cl = CRITTER_LINES[creature:GetEntry()] or CRITTER_DEFAULT
                creature:SendUnitSay(cl[math.random(#cl)], 0)
            else
                local region = RegionKey(creature)
                if region == "org" then
                    OrgTalk(creature, pool)
                else
                    RegionTalk(creature, region)
                end
            end
        end
    end
    creature:RegisterEvent(OrgrimmarTalk, math.random(MIN_DELAY, MAX_DELAY), 1)
end

-- MUTE: entries that must NEVER talk (dummies, targets, triggers).
-- Checked against DB: none of these are in talk pools, this is a guard.
local MUTE = {
    [31144] = true, [31146] = true, [32666] = true, [32667] = true,
    [46647] = true,
}

-- =====================================================================
-- Greetings: city-facing NPC greet passers-by instead of waiting for timers.
-- 12 s proximity watch, one greeting per ~2 min per NPC.
-- =====================================================================

local GREET_RANGE = 18
local GREET_COOLDOWN = 60

local GREET_LINES = {
    grunt     = {"Hail, traveler.", "Well met.", "Move along.", "Stormwind? Wrong city, friend."},
    vendor    = {"Come, look! Fresh wares!", "Traveler! Over here!"},
    innkeeper = {"Welcome in, welcome!", "Thirsty? Hungry? Both?"},
    banker    = {"Horde bank. State your business."},
    crier     = {"Hear ye! Hear ye!"},
    court     = {"Yes? Make it quick."},
    civilian  = {"Oh! Hello there.", "Lovely day, no?"},
    trainer   = {"You look soft. Train harder."},
    flight    = {"Need wings, traveler?"},
}

-- Newcomers (under level 10) get a warmer welcome.
local NEWCOMER_LINES = {
    grunt     = {"First time in Orgrimmar, little one? Stick to the road and you'll be fine."},
    vendor    = {"New in town? First browse is free, little one."},
    innkeeper = {"Young traveler! Come, sit - the stew's on me."},
    civilian  = {"Oh! A new face! Welcome to Orgrimmar!"},
}

local GREET_POOLS = { grunt = true, vendor = true, innkeeper = true,
    banker = true, crier = true, court = true, civilian = true,
    trainer = true, flight = true, troll = true, tauren = true }

local function GreetWatch(_, _, _, creature)
    if not creature or not creature:IsAlive() then return end
    local pool = creature:Data():Get("org_pool")
    if Silent(creature) then return end
    if pool == "grunt" or pool == "troll" then TorchCheck(creature) end
    if pool and GREET_POOLS[pool] then
        local players = creature:GetPlayersInRange(GREET_RANGE)
        if players and #players > 0 then
            local now = os.time()
            local last = creature:Data():Get("org_greet") or 0
            if type(last) ~= "number" then last = 0 end
            if now - last >= GREET_COOLDOWN then
                creature:Data():Set("org_greet", now)
                -- newcomers get a personal welcome
                local mini = 100
                for _, p in ipairs(players) do
                    local okL, lv = pcall(function() return p:GetLevel() end)
                    if okL and type(lv) == "number" and lv < mini then mini = lv end
                end
                local region = RegionKey(creature)
                if TypeOf(creature) ~= CT_HUMANOID then
                    -- not a speaker
                elseif region ~= "org" then
                    LoudSay(creature, Pick(PACKS[region].greet, region .. ":greet"))
                elseif mini < 10 and NEWCOMER_LINES[pool] then
                    LoudSay(creature, Pick(NEWCOMER_LINES[pool], "org:new:" .. pool))
                elseif GREET_LINES[pool] then
                    LoudSay(creature, Pick(GREET_LINES[pool], "org:greet:" .. pool))
                end
            end
        end
    end
    creature:RegisterEvent(GreetWatch, 12000, 1)
end
local function OrgrimmarSpawn(event, creature)
    if MUTE[creature:GetEntry()] then return end
    creature:Data():Set("org_role", RoleOf(creature))
    creature:RegisterEvent(OrgrimmarTalk, math.random(60000, 180000), 1)
    local pool = creature:Data():Get("org_pool")
    if pool and GREET_POOLS[pool] then
        creature:RegisterEvent(GreetWatch, 12000, 1)
    end
end

-- Night torches: gate-area guards carry Flickering Torch (spell 445981).
-- The aura lasts 10 minutes, so it is refreshed while night lasts.
-- Box covers the gate patrol route. Aura removed at day.
local TORCH_SPELL = 445981
function TorchCheck(creature)
    -- every grunt carries a torch at night (city, gates, road patrols)
    if IsNight() then
        local hasOk, has = pcall(function() return creature:HasAura(TORCH_SPELL) end)
        if hasOk and not has then
            print("[torch] ON entry=" .. tostring(creature:GetEntry()))
            pcall(function() creature:AddAura(TORCH_SPELL, creature) end)
        elseif not hasOk then
            -- no aura query API: re-apply blindly every tick is wasteful,
            -- fall back to 9-minute refresh cycle
            local last = creature:Data():Get("org_torch") or 0
            if type(last) ~= "number" then last = 0 end
            if os.time() - last > 540 then
                print("[torch] ON entry=" .. tostring(creature:GetEntry()))
            pcall(function() creature:AddAura(TORCH_SPELL, creature) end)
                creature:Data():Set("org_torch", os.time())
            end
        end
    else
        pcall(function() creature:RemoveAura(TORCH_SPELL) end)
        creature:Data():Set("org_torch", 0)
    end
end

local function OrgrimmarDeath(event, creature)
    creature:RemoveEvents()
end

-- Trolls speak like trolls (Darkspear, Sen'jin, headhunters, witch doctors...).
local TROLL_WORDS = {"darkspear", "troll", "headhunter", "sen'jin", "witch doctor", "shadow hunter", "zandalari", "berserker"}
TROLL_VOICE = { civilian = true, kalimdor = true, durotar = true, grunt = true }
function IsTrollName(c)
    local n = string.lower(c:GetName() or "")
    for _, w in ipairs(TROLL_WORDS) do
        if string.find(n, w, 1, true) then return true end
    end
    return false
end

-- Living world v2: every humanoid in a capital or a village (an area with an inn)
-- speaks from its region pack. Entries already in a pool above keep their pool.
local CITY_ZONES = {1637, 1519, 1537, 1638, 1497, 1657, 3487, 3557, 3703, 4395, 7502, 13862, 14771}
local VILLAGE_AREAS = {42, 69, 75, 108, 117, 147, 152, 159, 186, 193, 222, 228, 286, 320, 321, 349, 362, 380, 415, 420, 431, 460, 484, 496, 513, 608, 657, 1024, 1437, 1438, 1497, 1637, 1659, 1704, 1739, 1885, 1998, 2101, 2102, 2104, 2268, 2408, 2897, 3197, 3317, 3462, 3487, 3488, 3507, 3536, 3538, 3552, 3554, 3576, 3584, 3613, 3626, 3644, 3645, 3683, 3684, 3703, 3738, 3744, 3745, 3754, 3766, 3769, 3772, 3844, 3898, 3918, 3938, 3951, 3966, 3988, 3991, 4003, 4010, 4018, 4037, 4087, 4108, 4113, 4122, 4129, 4152, 4158, 4159, 4161, 4165, 4177, 4186, 4204, 4206, 4211, 4275, 4284, 4323, 4379, 4380, 4395, 4418, 4422, 4428, 4429, 4441, 4477, 4484, 4532, 4560, 4601, 4659, 4691, 4805, 4821, 4843, 4844, 4846, 4847, 4853, 4854, 4882, 4933, 4937, 4939, 4969, 4970, 4975, 4976, 4989, 4990, 5002, 5003, 5005, 5012, 5024, 5049, 5056, 5062, 5072, 5073, 5084, 5093, 5117, 5136, 5137, 5138, 5140, 5141, 5142, 5143, 5148, 5150, 5154, 5169, 5170, 5305, 5320, 5323, 5386, 5458, 5466, 5470, 5471, 5496, 5497, 5564, 5565, 5628, 5637, 5645, 5649, 5670, 5687, 5700, 5726, 5728, 5730, 5867, 5935, 5950, 6007, 6013, 6049, 6071, 6094, 6095, 6128, 6166, 6174, 6197, 6308, 6315, 6333, 6349, 6354, 6355, 6356, 6358, 6359, 6360, 6361, 6362, 6363, 6364, 6365, 6366, 6367, 6369, 6484, 6516, 6519, 6521, 6556, 6612, 6743, 6777, 6830, 6864, 6867, 6881, 6925, 7024, 7033, 7036, 7059, 7061, 7063, 7081, 7086, 7097, 7098, 7103, 7112, 7157, 7158, 7183, 7208, 7266, 7269, 7318, 7332, 7333, 7340, 7355, 7358, 7364, 7414, 7425, 7426, 7427, 7459, 7502, 7508, 7555, 7559, 7564, 7589, 7599, 7662, 7709, 7733, 7783, 7794, 7795, 7803, 7861, 7999, 8029, 8140, 8256, 8271, 8272, 8273, 8300, 8301, 8382, 8416, 8430, 8554, 8607, 8608, 8610, 8612, 8613, 8614, 8615, 8616, 8617, 8618, 8619, 8621, 8622, 8689, 8711, 8719, 8722, 8854, 8861, 8869, 8953, 8954, 8958, 8961, 8965, 9011, 9226, 9236, 9305, 9317, 9335, 9370, 9379, 9384, 9402, 9419, 9502, 9556, 9569, 9579, 9581, 9582, 9592, 9598, 9599, 9617, 9636, 9647, 9659, 9662, 9665, 9677, 9678, 9693, 9715, 9731, 9748, 9750, 9766, 9779, 9796, 9801, 9806, 9833, 9962, 10988, 11002, 11381, 11465, 11467, 11473, 11505, 11515, 11519, 11531, 12245, 12248, 12782, 12823, 12858, 12876, 13161, 13231, 13237, 13338, 13408, 13414, 13499, 13517, 13567, 13625, 13710, 13722, 13724, 13725, 13727, 13728, 13732, 13734, 13739, 13743, 13751, 13767, 13779, 13796, 13814, 13818, 13825, 13834, 13837, 13864, 13895, 13980, 14079, 14594}
do
    local known = {}
    for _, g in ipairs(GROUPS) do for _, e in ipairs(g.entries) do known[e] = true end end
    local q = WorldDBQuery(string.format([[
        SELECT DISTINCT c.id FROM creature c JOIN creature_template t ON t.entry = c.id
         WHERE (c.zoneId IN (%s) OR c.areaId IN (%s)) AND t.type = 7 AND t.ScriptName = '' AND t.name NOT REGEXP 'familiar|imp$|^imp |voidwalker|felhunter|succubus|felguard|infernal|doomguard|wisp|golem|elemental|skeleton|zombie|ghoul|abomination|spirit|ghost|treant|totem|spider|wolf|boar|bear|^cat$|bat$|rat$|dog|horse|kodo|raptor|hawk|snake|worg|hound|guardian|critter|bunny|scorpid|crab'
           AND IFNULL(c.PhaseId, 0) IN (0, 169, 9600) AND t.npcflag & 8192 = 0]],
        table.concat(CITY_ZONES, ","), table.concat(VILLAGE_AREAS, ",")))
    local extra = {}
    if q then repeat
        local e = q:GetUInt32(0)
        if not known[e] and not MUTE[e] then extra[#extra + 1] = e end
    until not q:NextRow() end
    GROUPS[#GROUPS + 1] = { entries = extra, pool = "civilian" }
    print("[alive] living world v2: " .. #extra .. " city and village speakers")
end

for _, g in ipairs(GROUPS) do
    for _, entry in ipairs(g.entries) do
      if not HAS_CPP_SCRIPT[entry] then
        local pool = g.pool
        RegisterCreatureEvent(entry, 5, function(e, c)
            c:Data():Set("org_pool", TROLL_VOICE[pool] and IsTrollName(c) and "troll" or pool)
            OrgrimmarSpawn(e, c)
        end)
        RegisterCreatureEvent(entry, 4, OrgrimmarDeath)
      end
    end
end

print("[OrgrimmarAlive] talk loaded")

-- =====================================================================
-- Gossip: guards give directions, peons joke around.
-- Vendors/trainers/innkeepers/bankers keep default windows - untouched.
-- =====================================================================

local DIRECTIONS = {
    [1] = "The bank? Northwest, past the auction house. Follow the gold, citizen.",
    [2] = "Auction house is in the Goblin Slums. Follow the smell of coins.",
    [3] = "Need rest? The Broken Tusk, Valley of Strength. Mind the stairs.",
    [4] = "Zeppelin tower, rear of the city, top floor. Tirisfal and Stranglethorn.",
}

local function GuardHello(event, player, creature)
    player:GossipMenuAddItem(0, "Where is the bank?", 1, 1)
    player:GossipMenuAddItem(0, "Where is the auction house?", 1, 2)
    player:GossipMenuAddItem(0, "Where can I rest?", 1, 3)
    player:GossipMenuAddItem(0, "Where is the zeppelin?", 1, 4)
    player:GossipMenuAddItem(0, "Never mind.", 1, 5)
    player:GossipSendMenu(1, creature)
end

local function GuardSelect(event, player, creature, sender, intid, code)
    if intid == 5 then
        player:GossipComplete()
        return
    end
    local line = DIRECTIONS[intid]
    if line then
        creature:SendUnitSay(line, 0)
    end
    player:GossipComplete()
end

local function PeonHello(event, player, creature)
    player:GossipMenuAddItem(0, "Why are you so lazy?", 1, 1)
    player:GossipMenuAddItem(0, "Back to work!", 1, 2)
    player:GossipSendMenu(1, creature)
end

local function PeonSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        creature:SendUnitSay("Me delegate! Delegating is important work.", 0)
    else
        creature:SendUnitSay("Okie dokie. Work, work...", 0)
        creature:PerformEmote(7)
    end
    player:GossipComplete()
end

local GOSSIP_GUARDS = {144288, 3296, 156731, 140750, 173279, 143964}
local GOSSIP_PEONS  = {14901, 41989, 40904}   -- 10556 Lazy Peon: C++ npc_lazy_peon (zone_durotar), ziadny Eluna hook (nahradil by C++ AI)

for _, entry in ipairs(GOSSIP_GUARDS) do
    RegisterCreatureGossipEvent(entry, 1, GuardHello)
    RegisterCreatureGossipEvent(entry, 2, GuardSelect)
end
for _, entry in ipairs(GOSSIP_PEONS) do
    RegisterCreatureGossipEvent(entry, 1, PeonHello)
    RegisterCreatureGossipEvent(entry, 2, PeonSelect)
end

print("[OrgrimmarAlive] gossip loaded")

-- =====================================================================
-- Gate patrol salute: guards on path 900001 salute at waypoint 4.
-- =====================================================================

local function PatrolSalute(event, creature, waypointId)
    if waypointId == 4 and creature:IsAlive() then
        creature:PerformEmote(66)
        if math.random() < 0.5 then
            creature:SendUnitSay("Gate secure. For the Horde!", 0)
        end
    end
end

RegisterCreatureEvent(3296, 6, PatrolSalute)

print("[OrgrimmarAlive] patrol loaded")

-- =====================================================================
-- Training ground coach: when a dummy takes a hit, a nearby drill
-- sergeant shouts a tip. Dummies themselves stay silent, as they should.
-- =====================================================================

local DUMMY_ENTRIES = {31144, 31146, 32666, 32667, 46647}
local COACH_LINES = {
    "Keep your guard up!",
    "Again! Feet apart!",
    "Strike through, not at!",
    "Good form! Again!",
    "Watch the footing, recruit!",
}

local function DummyHit(event, creature, attacker, damage)
    if not creature or not creature:IsAlive() then return end
    local now = os.time()
    local last = creature:Data():Get("org_coach") or 0
    if type(last) ~= "number" then last = 0 end
    if now - last < 45 then return end
    local coaches = creature:GetCreaturesInRange(40)
    if coaches then
        for _, o in ipairs(coaches) do
            if o and o ~= creature and o:IsAlive() and o:Data():Get("org_pool") == "drill" then
                creature:Data():Set("org_coach", now)
                o:SendUnitYell(COACH_LINES[math.random(#COACH_LINES)], 0)
                return
            end
        end
    end
end

for _, entry in ipairs(DUMMY_ENTRIES) do
    RegisterCreatureEvent(entry, 9, DummyHit)
end

print("[OrgrimmarAlive] coach loaded")
