-- =====================================================================
-- Wildcard v2 (Descend-inspired) for TrinityCore Retail + Eluna.
-- No core recompile, no client patch. Chat + Fortuna gossip UI.
-- v2: ~100 abilities from every class, rarity (Common/Uncommon/Rare/Epic)
--     weighted drafts, all races, invalid spell IDs filtered at startup.
--
-- Rules v1:
--  * Fresh hero (level <= START_MAX_LEVEL, no wildcard spells yet) learns
--    STARTING_ABILITIES random spells on first login (like Dice of Destiny).
--  * Every level-up rolls a draft of DRAFT_SIZE random spells
--    (level-gated, no duplicates, nothing you already own).
--    Pick one with:  .wc pick 1|2|3
--  * Reroll the pending draft (3 charges per level):  .wc reroll
--  * Other commands:  .wc build  (your wildcard spellbook)
--                     .wc status (charges + pending draft)
--  * State (charges + pending draft) persists in characters.wildcard_state.
--    Learned spells persist in the spellbook by themselves.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- POOL POUZIVA VLASTNE KLONY 1410xxx ("Hero's X", vsetko na Essence).
-- Generuje pool_build.py + clone_spells.py (hotfix push 1901800). Retail IDcka
-- sa v poole nepouzivaju; prestahovanie starych hracov robi MigratePoolSpells.
-- POOL POUZIVA VLASTNE KLONY 1410xxx ("Hero's X", vsetko na Essence).
-- Generuje pool_build.py + clone_spells.py (hotfix push 1901800). Retail IDcka
-- sa v poole nepouzivaju; prestahovanie starych hracov robi MigratePoolSpells.
-- =====================================================================
local ENABLED = true
local DRAFT_SIZE = 1          -- Descend style: one roll, Keep or Reroll
local LEVEL_CHOICES = 3       -- at every level up the Dice of Destiny offers three cards: pick one (or reroll all three)
local CHARGES_PER_LEVEL = 5
local FREE_REROLL_LEVEL = 10   -- unlimited rerolls up to this level
local STARTING_ABILITIES = 6
local START_MAX_LEVEL = 5
-- {spellId, "Name", minLevel, raceOnly(optional, 0 = all), rarity}
-- Rarity: 1 Common, 2 Uncommon, 3 Rare, 4 Epic. Retail 12.x spell IDs.
-- Cost note: rage/energy/rune/holy-power spenders stay out until the core
-- gives every class every resource (step 3). Mana spells only work for
-- characters with a mana bar; free-cost utility works for everyone.
-- Spells missing in this client build are dropped at startup (ValidatePool).
local C, U, R, E = 1, 2, 3, 4
local LG, IM, GD = 5, 7, 8   -- Legendary and Immortal abilities (rarity 5 and 7; 6 stays the Mystic Artifact quality)
local POOL = {
    {1410011, "Fireball", 1, 0, C}, {1410005, "Frostbolt", 1, 0, C}, {1410008, "Frost Nova", 8, 0, U}, {1410073, "Blink", 12, 0, R},
    {1410006, "Polymorph", 8, 0, U}, {1410053, "Arcane Intellect", 10, 0, C}, {1410081, "Counterspell", 12, 0, U}, {1410196, "Ice Block", 30, 0, E},
    {1410010, "Slow Fall", 6, 0, C}, {1410002, "Invisibility", 16, 0, R}, {1410222, "Mirror Image", 18, 0, R}, {1410666, "Alter Time", 30, 0, E},
    {1410025, "Shadow Word: Pain", 1, 0, C}, {1410077, "Flash Heal", 3, 0, C}, {1410000, "Power Word: Shield", 6, 0, U}, {1410165, "Power Word: Fortitude", 10, 0, C},
     {1410024, "Fade", 6, 0, C}, {1410124, "Psychic Scream", 12, 0, U}, {1410143, "Desperate Prayer", 10, 0, U},
    {1410243, "Leap of Faith", 20, 0, R}, {1410013, "Corruption", 1, 0, C},  {1410009, "Eye of Kilrogg", 12, 0, C},
    {1410309, "Unending Resolve", 16, 0, R}, {1410095, "Wrath", 1, 0, C}, {1410128, "Moonfire", 1, 0, C},
    {1410129, "Regrowth", 3, 0, C}, {1410037, "Rejuvenation", 4, 0, C}, {1410105, "Bear Form", 8, 0, U}, 
    {1410167, "Barkskin", 12, 0, R}, {1410069, "Dash", 10, 0, U}, {1410312, "Stampeding Roar", 20, 0, R}, {1410014, "Entangling Roots", 6, 0, U},
    {1410035, "Tranquility", 70, 0, IM}, {1410022, "Water Walking", 12, 0, C}, {1410085, "Ghost Wolf", 10, 0, U}, {1410087, "Bloodlust", 50, 0, LG},
    {1410229, "Wind Shear", 12, 0, U}, {1410315, "Astral Shift", 16, 0, R}, {1410460, "Chain Lightning", 12, 0, U}, {1410046, "Chain Heal", 12, 0, U},
    {1410211, "Hex", 12, 0, R}, {1410044, "Blessing of Protection", 12, 0, R}, {1410045, "Blessing of Freedom", 10, 0, U}, {1410026, "Lay on Hands", 70, 0, IM},
    {1410027, "Divine Shield", 50, 0, LG}, {1410040, "Hammer of Justice", 8, 0, U}, {1410451, "Aspect of the Cheetah", 10, 0, U},
    {1410102, "Feign Death", 16, 0, R}, {1410038, "Disengage", 8, 0, U}, {1410452, "Aspect of the Turtle", 50, 0, LG}, {1410318, "Exhilaration", 12, 0, R},
    {1410004, "Charge", 4, 0, U}, {1410016, "Taunt", 6, 0, C}, {1410114, "Heroic Leap", 14, 0, R}, {1410142, "Berserker Rage", 10, 0, U},
    {1410098, "Intimidating Shout", 12, 0, U}, {1410168, "Spell Reflection", 16, 0, R}, {1410066, "Stealth", 4, 0, U},
    {1410070, "Vanish", 14, 0, R}, {1410089, "Sprint", 6, 0, U}, {1410099, "Evasion", 12, 0, R}, {1410191, "Shadowstep", 12, 0, R},
    {1410181, "Cloak of Shadows", 30, 0, E}, {1410204, "Anti-Magic Shell", 14, 0, R}, {1410205, "Icebound Fortitude", 30, 0, E},
    {1410093, "Path of Frost", 6, 0, C},  {1410498, "Vengeful Retreat", 14, 0, U}, {1410442, "Throw Glaive", 20, 0, U},
    {1410497, "Blur", 16, 0, R}, {1410462, "Spectral Sight", 8, 0, C}, 
    {1410347, "Leg Sweep", 12, 0, R}, {1410635, "Touch of Death", 70, 0, IM}, {1410686, "Hover", 10, 0, U},
    {1410697, "Obsidian Scales", 16, 0, R}, {1410034, "Banish", 12, 10, U}, {1410133, "Evocation", 16, 10, R}, {1410178, "Spellsteal", 20, 10, R},
    {1410132, "Arcane Power", 30, 0, E}, {1410227, "Heroic Throw", 10, 0, C}, {1410115, "Pummel", 10, 0, U},
    {1410555, "Bladestorm", 35, 0, E}, {1410188, "Victory Rush", 5, 0, C}, {1410116, "Battle Shout", 10, 0, C}, {1410056, "Slam", 1, 0, C},
    {1410062, "Hamstring", 4, 0, C}, {1410169, "Shield Slam", 10, 0, U}, {1410101, "Execute", 10, 0, U},
    {1410060, "Whirlwind", 10, 0, U}, {1410584, "Sweeping Strikes", 20, 0, R}, {1410049, "Challenging Shout", 16, 0, U}, {1410280, "Raging Blow", 14, 0, U},
    {1410153, "Holy Shock", 20, 0, R}, {1410326, "Holy Prism", 20, 0, R}, {1410325, "Light's Hammer", 35, 0, E},
    {1410019, "Devotion Aura", 10, 0, U}, {1410438, "Retribution Aura", 10, 0, U}, {1410130, "Turn Evil", 10, 0, U}, {1410119, "Blessing of Sacrifice", 41, 0, R},
    {1410020, "Divine Protection", 26, 0, R},  {1410121, "Redemption", 13, 0, C}, {1410237, "Hand of Reckoning", 9, 0, C},
    {1410217, "Beacon of Light", 35, 0, E}, {1410239, "Ardent Defender", 35, 0, E}, {1410059, "Flare", 19, 0, C}, {1410343, "Binding Shot", 20, 0, R},
    {1410533, "Play Dead", 10, 0, U}, {1410225, "Steady Shot", 1, 0, C}, {1410578, "Hunter's Mark", 7, 0, C}, {1410484, "Wing Clip", 3, 0, C},
    {1410457, "Freezing Trap", 10, 0, U}, {1410422, "Steel Trap", 20, 0, R}, {1410471, "Harpoon", 14, 0, U}, {1410580, "Multi-Shot", 10, 0, U},
    {1410112, "Eagle Eye", 43, 0, C}, {1410476, "Hatchet Toss", 12, 0, C}, {1410065, "Kick", 10, 0, U}, {1410074, "Feint", 12, 0, U},
    {1410445, "Crimson Vial", 20, 0, R}, {1410228, "Tricks of the Trade", 48, 0, R}, {1410323, "Shroud of Concealment", 50, 0, LG}, {1410064, "Sinister Strike", 1, 0, C},
    {1410068, "Cheap Shot", 10, 0, U}, {1410117, "Sap", 11, 0, U}, {1410126, "Ambush", 10, 0, U}, {1410063, "Distract", 28, 0, C},
    {1410078, "Blind", 39, 0, R}, {1410001, "Backstab", 12, 0, C}, {1410322, "Shuriken Toss", 16, 0, C}, {1410213, "Fan of Knives", 19, 0, U},
    {1410450, "Pistol Shot", 12, 0, C}, {1410086, "Deadly Poison", 10, 0, U}, {1410091, "Crippling Poison", 10, 0, C},
    {1410033, "Garrote", 11, 0, U}, {1410042, "Pick Pocket", 24, 0, C}, {1410023, "Smite", 1, 0, C}, {1410075, "Resurrection", 10, 0, C},
    {1410018, "Mind Soothe", 18, 0, C}, {1410021, "Purify", 10, 0, C},  
    {1410138, "Silence", 26, 0, R}, {1410202, "Dispersion", 35, 0, E}, {1410540, "Mass Resurrection", 37, 0, U},
    {1410236, "Raise Ally", 20, 0, R}, {1410215, "Death and Decay", 10, 0, U}, {1410223, "Dark Command", 9, 0, C}, 
    {1410203, "Death's Advance", 10, 0, U}, {1410206, "Lichborne", 20, 0, R}, {1410198, "Raise Dead", 20, 0, R}, {1410517, "Consumption", 40, 0, E},
    {1410366, "Glide", 10, 0, U}, {1410473, "Metamorphosis", 35, 0, E}, {1410444, "Torment", 9, 0, C}, {1410463, "Infernal Strike", 20, 0, R},
    {1410672, "Demon's Bite", 1, 0, C}, {1410305, "Cenarion Ward", 20, 0, R}, {1410307, "Prowl", 10, 0, U}, 
    {1410234, "Typhoon", 10, 0, U}, {1410430, "Sunfire", 13, 0, C}, {1410154, "Rebirth", 70, 0, IM},
    {1410118, "Growl", 9, 0, C}, {1410048, "Mark of the Wild", 10, 0, U}, {1410292, "Nature's Cure", 10, 0, C}, {1410472, "Starfall", 35, 0, E},
    {1410541, "Revitalize", 47, 0, C}, 
    {1410698, "Blessing of the Bronze", 30, 0, U}, {1410694, "Azure Strike", 1, 0, C}, {1410701, "Tail Swipe", 10, 0, U}, {1410684, "Deep Breath", 35, 0, E},
    {1410691, "Return", 12, 0, C}, {1410269, "Time Warp", 80, 0, GD},  {1410626, "Fire Blast", 2, 0, C},
    {1410007, "Cone of Cold", 18, 0, U},   {1410478, "Phoenix's Flames", 20, 0, R},
    {1410303, "Spinning Crane Kick", 10, 0, U},  
    {1410302, "Flying Serpent Kick", 21, 0, R}, {1410353, "Touch of Karma", 35, 0, E}, {1410357, "Healing Sphere", 10, 0, U}, {1410358, "Zen Flight", 30, 0, U},
    {1410332, "Resuscitate", 13, 0, C}, {1410531, "Soothing Mist", 10, 0, C}, {1410340, "Vivify", 10, 0, U},
    {1410334, "Detox", 10, 0, C}, {1410111, "Far Sight", 14, 0, C}, {1410184, "Heroism", 50, 0, LG}, {1410183, "Stormstrike", 20, 0, R},
    {1410259, "Earthquake", 20, 0, R}, {1410076, "Ancestral Spirit", 13, 0, C}, {1410735, "Flame Shock", 3, 0, C}, {1410123, "Healing Surge", 4, 0, C},
    {1410214, "Water Shield", 12, 0, U},  {1410210, "Thunderstorm", 30, 0, R}, {1410659, "Primordial Wave", 48, 0, E},
    {1410107, "Unending Breath", 18, 0, C}, {1410161, "Soulstone", 20, 0, R}, {1410568, "Drain Life", 10, 0, U}, {1410047, "Subjugate Demon", 21, 0, R},
    {1410096, "Shred", 20, 0, R}, {1410187, "Mangle", 20, 0, R}, {1410244, "Primal Strike", 20, 0, R}, {1410311, "Thrash", 20, 0, R},
    {1410431, "Flap", 20, 0, R},
    
    
    
    
    
    
    
    
    
    
    -- BEGIN POOL_ALL (generated by pool_build.py: every player class spell, level-gated)
    {1410015, "Immolate", 1, 0, 1}, {1410028, "Shadow Bolt", 1, 0, 1},  
    {1410097, "Track Humanoids", 1, 0, 1}, {1410131, "Flametongue Attack", 1, 0, 1},
    {1410170, "Hammer of Wrath", 1, 0, 1}, {1410171, "Windfury Attack", 1, 0, 1},
    {1410182, "Avenging Wrath", 1, 0, 4}, {1410190, "Crusader Strike", 1, 0, 1}, {1410192, "Force of Nature", 1, 0, 1}, {1410221, "Frost Fever", 1, 0, 1},
    {1410226, "Detection", 1, 0, 1}, {1410261, "Echo of Light", 1, 0, 1}, 
    {1410287, "Main Gauche", 1, 0, 1}, {1410289, "Light of the Ancient Kings", 1, 0, 1}, {1410290, "Ancient Fury", 1, 0, 1},
     {1410297, "Protector of the Innocent", 1, 0, 1}, {1410299, "Tiger Palm", 1, 0, 1},
    {1410316, "Soul Leech", 1, 0, 1}, {1410321, "Bloodbath", 1, 0, 1},
    {1410324, "Windlash", 1, 0, 1}, {1410328, "Ancestral Guidance", 1, 0, 1}, 
    {1410341, "Bloodthirst Heal", 1, 0, 1}, {1410342, "Fists of Fury", 1, 0, 1}, 
    
    {1410413, "Ysera's Gift", 1, 0, 1}, {1410416, "Ravager", 1, 0, 1}, 
    {1410420, "Descend", 1, 0, 3}, {1410421, "Jailer's Judgment", 1, 0, 5},
    {1410429, "Chaos Strike", 1, 0, 1},  
    {1410456, "Chaos Barrage", 1, 0, 1}, {1410459, "Lightning Bolt", 1, 0, 1}, 
    
    {1410485, "Double Jump", 1, 0, 2}, {1410486, "Dimensional Rift", 1, 0, 1}, 
    {1410499, "Find Treasure", 1, 0, 1}, {1410500, "Tyr's Deliverance", 1, 0, 4}, 
    {1410506, "Fury of the Eagle", 1, 0, 1}, {1410508, "Neltharion's Fury", 1, 0, 4}, 
    {1410512, "Shear", 1, 0, 1}, {1410513, "Windburst", 1, 0, 4},  
    {1410518, "Wake of Ashes", 1, 0, 4},  {1410520, "Stormkeeper", 1, 0, 4}, {1410521, "Odyn's Fury", 1, 0, 4},
    {1410523, "Titan's Thunder", 1, 0, 4}, {1410525, "Soul Carver", 1, 0, 4}, {1410526, "Downpour", 1, 0, 1}, {1410527, "Light's Wrath", 1, 0, 4},
    {1410528, "Light of T'uure", 1, 0, 4}, {1410529, "Essence of G'Hanir", 1, 0, 4}, {1410530, "Eye of Tyr", 1, 0, 3}, {1410532, "Warbreaker", 1, 0, 4},
    {1410537, "Ashamane's Frenzy", 1, 0, 4}, {1410539, "Thal'kiel's Consumption", 1, 0, 4}, {1410542, "Ancestral Vision", 1, 0, 1},
    {1410545, "Create: Crimson Vial", 1, 0, 1},   
    {1410550, "Chaos Bolt", 1, 0, 1}, {1410551, "Trauma", 1, 0, 1},  {1410554, "Apocalypse", 1, 0, 4},
    {1410558, "Soul Cleave", 1, 0, 1},  {1410560, "Track Mechanicals", 1, 0, 1}, 
     {1410586, "Fracture", 1, 0, 1}, 
     {1410620, "Rune Strike", 1, 0, 1}, {1410628, "Thick Skin", 1, 0, 1}, {1410630, "Surge of Earth", 1, 0, 1},
    
    {1410671, "Bestial Wrath", 1, 0, 1},   
       {1410682, "Disintegrate", 1, 0, 1},
    {1410689, "Sense Power", 1, 0, 1},   
    
    
      {1410736, "Consume", 1, 0, 1},
    {1410218, "Shield of the Righteous", 2, 0, 1}, {1410300, "Blackout Kick", 2, 0, 1}, {1410447, "Arcane Shot", 2, 0, 1}, {1410489, "Eviscerate", 2, 0, 1},
    {1410029, "Summon Imp", 3, 0, 1}, {1410152, "Judgment", 3, 0, 1}, {1410057, "Track Beasts", 4, 0, 1},
    {1410144, "Flash of Light", 4, 0, 1}, {1410145, "Track Demons", 4, 0, 1}, {1410146, "Track Dragonkin", 4, 0, 1}, {1410147, "Track Elementals", 4, 0, 1},
    {1410148, "Track Giants", 4, 0, 1}, {1410149, "Track Undead", 4, 0, 1}, {1410150, "Track Hidden", 4, 0, 1}, {1410180, "Fleet Footed", 4, 0, 2},
    {1410012, "Mend Pet", 5, 0, 2}, {1410036, "Cat Form", 5, 0, 1}, {1410041, "Call Pet 1", 5, 0, 1}, {1410043, "Revive Pet", 5, 0, 1},
    {1410054, "Beast Lore", 5, 0, 1}, {1410058, "Tame Beast", 5, 0, 1}, {1410084, "Dismiss Pet", 5, 0, 1},
    {1410120, "Feed Pet", 5, 0, 2}, {1410346, "Crackling Jade Lightning", 5, 0, 1}, {1410032, "Curse of Weakness", 6, 0, 1}, {1410052, "Arcane Explosion", 6, 0, 1},
    {1410534, "Wake Up", 6, 0, 3}, {1410166, "Ferocious Bite", 7, 0, 1}, {1410281, "Word of Glory", 7, 0, 1}, 
    {1410634, "Expel Harm", 8, 0, 2}, {1410475, "Lightning Shield", 9, 0, 1}, {1410618, "Slice and Dice", 9, 0, 1}, {1410003, "Vanguard", 10, 0, 2},
    {1410031, "Summon Voidwalker", 10, 0, 1}, {1410094, "Cleanse", 10, 0, 1}, {1410106, "Sense Undead", 10, 0, 1}, 
    {1410137, "Mind Flay", 10, 0, 1}, {1410139, "Clearcasting", 10, 0, 1}, {1410151, "Devastate", 10, 0, 1}, {1410172, "Righteous Fury", 10, 0, 2},
    {1410177, "Incinerate", 10, 0, 1}, {1410179, "Arcane Blast", 10, 0, 1}, {1410189, "Vampiric Touch", 10, 0, 1}, {1410216, "Exotic Beasts", 10, 0, 1},
    {1410235, "Aspect of the Chameleon", 10, 0, 5},
    {1410252, "Purify Spirit", 10, 0, 1},   
      {1410258, "Healing Wave", 10, 0, 1},
     {1410275, "Call Pet 2", 10, 0, 1},  {1410282, "Festering Strike", 10, 0, 1},
    {1410288, "Dual Wield", 10, 0, 1}, {1410327, "Treant Form", 10, 0, 1},
       
    {1410361, "Corpse Exploder", 10, 0, 2}, {1410362, "Charm Woodland Creature", 10, 0, 3},
    {1410448, "Shadowstrike", 10, 0, 1}, 
      
     {1410535, "Mount Form", 10, 0, 2}, 
    {1410567, "Shadowform", 10, 0, 1}, {1410569, "Strength of the Wild", 10, 0, 1},
       
    {1410619, "Instant Poison", 10, 0, 1},  {1410688, "Naturalize", 10, 0, 1},
     
    
    {1410193, "Arcane Barrage", 11, 0, 1}, {1410199, "Titan's Grip", 11, 0, 1}, 
    {1410274, "Holy Light", 11, 0, 1}, {1410495, "Shuriken Storm", 11, 0, 1}, {1410581, "Immolation Aura", 11, 0, 1},
    {1410051, "Mutilate", 12, 0, 1},
    {1410582, "Chakrams", 12, 0, 1}, {1410017, "Kidney Shot", 13, 0, 3},
    {1410072, "Rupture", 13, 0, 1}, {1410135, "Blade Flurry", 13, 0, 3}, {1410197, "Chains of Ice", 13, 0, 1}, {1410208, "Revive", 13, 0, 1},
    {1410067, "Pick Lock", 14, 0, 1}, {1410079, "Mind Vision", 14, 0, 1},
    {1410461, "Blade Dance", 14, 0, 2}, 
    {1410490, "Feral Lunge", 14, 0, 3}, {1410625, "Black Powder", 14, 0, 1}, {1410162, "Spirit of Redemption", 15, 0, 3},
    {1410333, "Windstrike", 15, 0, 1}, {1410676, "Aegis of Light", 15, 0, 2}, {1410140, "Feral Instinct", 16, 0, 2}, 
    {1410732, "Skyfury", 16, 0, 1},
    {1410276, "Call Pet 3", 17, 0, 2}, {1410434, "Touch of Fatality", 17, 0, 3}, {1410616, "Between the Eyes", 17, 0, 3},
    
    {1410439, "Disrupt", 19, 0, 2}, {1410488, "Remorseless Winter", 19, 0, 2}, 
    {1410700, "Summon Sayaad", 19, 0, 1}, {1410708, "Intercession", 19, 0, 5}, 
    {1410080, "Dispatch", 22, 0, 2}, {1410185, "Envenom", 22, 0, 2},
    {1410446, "Shadow Dance", 22, 0, 2},  {1410030, "Summon Felhunter", 23, 0, 2}, {1410127, "Wound Poison", 23, 0, 2},
    {1410220, "Blood Plague", 23, 0, 2}, {1410482, "Death's Caress", 23, 0, 2}, 
    {1410453, "Aspect of the Eagle", 24, 0, 3}, 
     {1410071, "Safe Fall", 25, 0, 2}, 
    
    {1410419, "Riposte", 29, 0, 2},
    {1410449, "Poisoned Knife", 29, 0, 2}, {1410632, "Eyes of the Beast", 29, 0, 2}, 
    {1410566, "Improved Sprint", 31, 0, 3}, {1410110, "Shiv", 32, 0, 2}, 
    {1410690, "Mass Return", 38, 0, 2}, 
    {1410277, "Call Pet 4", 41, 0, 2}, {1410544, "Absolution", 44, 0, 2}, 
    {1410543, "Reawaken", 47, 0, 3}, {1410562, "Lightning Reflexes", 47, 0, 2}, {1410278, "Call Pet 5", 48, 0, 2}, 
    {1410674, "Fodder to the Flame", 48, 0, 2}, {1410707, "Fury of the Aspects", 48, 0, 7}, {1410733, "Harrier's Cry", 48, 0, 5}, 
    {1410652, "Dark Transformation", 52, 0, 2},
    {1410108, "Numbing Poison", 54, 0, 3}, {1410677, "Wailing Arrow", 60, 0, 3}, {1410501, "Plea", 80, 0, 3},
    -- END POOL_ALL
    -- BEGIN POOL_MOBILITY (extra movement abilities)
     {1410549, "Shimmer", 12, 0, R}, {1410306, "Wild Charge", 12, 0, R}, {1410573, "Tiger Dash", 12, 0, R}, {1410474, "Gust of Wind", 12, 0, R}, {1410230, "Spirit Walk", 12, 0, R}, {1410319, "Burning Rush", 12, 0, R}, 
    -- END POOL_MOBILITY
    -- BEGIN POOL_MIDNIGHT (mid_pool.py: Midnight spells picked by the owner)
    {1405001, "Ash Veil", 8, 0, R}, {1405002, "Translocator Recall", 8, 0, U}, {1407001, "Axe Throw", 4, 0, U}, {1407002, "Barbed Shot", 4, 0, U},
    {1407003, "Blood Bolt", 4, 0, U}, {1407004, "Acid Spray", 4, 0, U}, {1407005, "Brace", 4, 0, U}, {1407006, "Batten the Hatches", 6, 0, U},
    {1407007, "Air Bubble", 4, 0, U}, {1407008, "Bone Armor", 4, 0, U}, {1407009, "Arcane Eye", 4, 0, U}, {1407010, "Bloodthirsty Axe", 4, 0, U},
    {1407011, "Burning Presence", 10, 0, R}, {1407012, "Arc Lightning", 12, 0, R}, {1407013, "Arcane Anguish", 14, 0, R}, {1407014, "Arcane Flurry", 12, 0, R},
    {1407015, "Blink Nova", 14, 0, R}, {1407016, "Arcane Dome", 16, 0, R}, {1407017, "Bonestorm", 12, 0, R}, {1407018, "Bone Spikes", 18, 0, R},
    {1407019, "Anguish Grenade", 12, 0, R}, {1407020, "Blazing Boost", 12, 0, R}, {1407021, "Abyss Crush", 24, 0, E}, {1407022, "Breath of Halazzi", 12, 0, R},
    {1407023, "Blessing of Ula'tek", 12, 0, R}, {1407024, "Bloodburrow Rootbind", 12, 0, R}, {1407025, "Arcane Salvo", 12, 0, R}, {1407026, "Arcane Dissolution", 16, 0, R},
    {1407027, "Arcane Fusillade", 30, 0, E}, {1407028, "Breath of Jan'alai", 30, 0, E}, {1407029, "Bulwark of the Protector", 30, 0, E}, {1406001, "Backhand", 8, 0, R},
    {1406002, "Aggressive Headbutt", 10, 0, R}, {1406003, "Big Slam", 20, 0, R}, {1406004, "Arcane Fist", 12, 0, R}, {1406005, "Astral Wave", 14, 0, R},
    {1406006, "Ammolitic Burst", 6, 0, U}, {1406007, "Burning Sludge", 6, 0, U}, {1406009, "Addle Mind", 12, 0, R},
    {1406010, "Acidic Burst", 8, 0, U}, {1406011, "Anguished Cry", 18, 0, R}, {1406012, "Dark Reach", 2, 0, U}, {1406013, "Poisonous Bite", 5, 0, U},
    {1406014, "Petrifying Sting", 14, 0, R}, {1406015, "Corrosive Bilespear", 3, 0, U}, {1406016, "Void Toxin", 10, 0, U}, {1406017, "Soul Extinction", 30, 0, E},
    {1406018, "Serpent's Strike", 4, 0, U}, {1406019, "Helical Toxins", 16, 0, R}, {1406020, "Vitriolic Stasis", 10, 0, U}, 
    {1406022, "Unstable Miasma", 28, 0, E}, {1406024, "Ghastly Regeneration", 8, 0, U}, 
     {1406028, "Spirit Step", 10, 0, R}, {1406029, "Bestial Berserk", 14, 0, R},
    {1406030, "Medjai's Protection", 12, 0, R}, {1406031, "Arcane Bulwark", 16, 0, R}, {1406032, "Arcane Ward", 6, 0, U}, {1406033, "Vashnik's Mixture", 9, 0, U},
    {1406040, "Blessing of Flame", 10, 0, R}, {1406041, "Ancient Amani Mask", 22, 0, E}, {1406042, "Agitated Crystal", 16, 0, R}, {1406043, "Akil'zon's Rite", 20, 0, R},
    {1406044, "Midnight Salmon Feast", 5, 0, U}, {1406045, "Accumulate Charge", 14, 0, U}, {1406046, "Echo of Ula'tek", 36, 0, E}, {1406047, "Ula'tek's Dominance", 40, 0, E},
    {1406048, "Venom Coagulation", 18, 0, R},
    -- END POOL_MIDNIGHT
    -- BEGIN POOL_COVENANT (pool_extra.py: covenant and racial abilities)
    {1410606, "Spear of Bastion", 40, 0, E},  {1410607, "Resonating Arrow", 40, 0, E},
    {1410656, "Kindred Spirits", 40, 0, E}, {1410648, "Boon of the Ascended", 50, 0, LG}, {1410637, "Echoing Reprimand", 40, 0, E}, {1410605, "Radiant Spark", 40, 0, E},
    {1410609, "Weapons of Order", 40, 0, E}, {1410644, "Vesper Totem", 40, 0, E}, {1410611, "Shackle the Unworthy", 40, 0, E},
    {1410612, "Scouring Tithe", 40, 0, E}, {1410622, "Sinful Brand", 40, 0, E}, {1410624, "Condemn", 40, 0, E},
    {1410638, "Mindgames", 40, 0, E}, {1410643, "Flayed Shot", 40, 0, E}, {1410636, "Ravenous Frenzy", 50, 0, LG}, {1410610, "Swarming Mist", 40, 0, E},
    {1410639, "Convoke the Spirits", 40, 0, E}, {1410661, "Wild Spirits", 40, 0, E},
    {1410663, "Fae Transfusion", 40, 0, E}, 
    {1410615, "Shifting Power", 40, 0, E}, {1410662, "Sepsis", 40, 0, E}, {1410653, "Soul Rot", 40, 0, E}, 
    {1410655, "Primordial Wave", 40, 0, E},  {1410646, "Unholy Nova", 40, 0, E}, {1410627, "Bulk Extraction", 40, 0, E},
    {1410617, "Abomination Limb", 40, 0, E}, {1410642, "Conqueror's Banner", 40, 0, E}, {1410664, "Fleshcraft", 20, 0, U},
    {1410608, "Soulshape", 20, 0, U}, {1410645, "Flicker", 20, 0, U}, {1410156, "Blood Fury", 12, 0, R}, {1410155, "War Stomp", 12, 0, R},
    {1410173, "Berserking", 12, 0, R}, {1410122, "Will of the Forsaken", 12, 0, R}, {1410175, "Arcane Torrent", 12, 0, R}, {1410575, "Light's Judgment", 12, 0, R},
    {1410587, "Fireblood", 12, 0, R}, {1410597, "Haymaker", 12, 0, R}, {1410577, "Spatial Rift", 12, 0, R}, {1410576, "Bull Rush", 12, 0, R},
    {1410583, "Arcane Pulse", 12, 0, R}, {1410241, "Rocket Barrage", 12, 0, R}, {1410614, "Hyper Organic Light Originator", 12, 0, R},
     {1410685, "Wing Buffet", 12, 0, R},  
     {1410159, "Stoneform", 8, 0, U}, {1410231, "Shadowmeld", 8, 0, U},
    {1410313, "Quaking Palm", 8, 0, U}, {1410233, "Will to Survive", 8, 0, U}, {1410176, "Gift of the Naaru", 8, 0, U}, {1410242, "Rocket Jump", 8, 0, U},
    {1410240, "Darkflight", 8, 0, U}, {1410598, "Regeneratin'", 8, 0, U},
    -- END POOL_COVENANT
    -- BEGIN POOL_EXTRA2 (pool_extra.py: reviewed clones that were left out)
    {1410015, "Immolate", 2, 0, C}, {1410017, "Kidney Shot", 14, 0, R}, {1410028, "Shadow Bolt", 3, 0, C}, {1410051, "Mutilate", 4, 0, C},
    {1410052, "Arcane Explosion", 5, 0, C}, {1410072, "Rupture", 6, 0, C}, {1410080, "Dispatch", 8, 0, U}, 
    {1410094, "Cleanse", 8, 0, C}, {1410110, "Shiv", 10, 0, U}, {1410131, "Flametongue Attack", 2, 0, C}, {1410135, "Blade Flurry", 20, 0, R},
    {1410137, "Mind Flay", 3, 0, C}, {1410139, "Clearcasting", 4, 0, C}, {1410144, "Flash of Light", 5, 0, C}, {1410151, "Devastate", 6, 0, C},
    {1410152, "Judgment", 8, 0, C}, {1410166, "Ferocious Bite", 2, 0, C}, {1410170, "Hammer of Wrath", 3, 0, C}, {1410171, "Windfury Attack", 4, 0, C},
    {1410177, "Incinerate", 5, 0, C}, {1410179, "Arcane Blast", 6, 0, C}, {1410182, "Avenging Wrath", 26, 0, E}, {1410185, "Envenom", 8, 0, U},
    {1410189, "Vampiric Touch", 8, 0, C}, {1410190, "Crusader Strike", 2, 0, C}, {1410192, "Force of Nature", 3, 0, C}, {1410193, "Arcane Barrage", 4, 0, C},
    {1410197, "Chains of Ice", 5, 0, C}, {1410218, "Shield of the Righteous", 6, 0, C}, {1410220, "Blood Plague", 10, 0, U}, {1410221, "Frost Fever", 8, 0, C},
    {1410252, "Purify Spirit", 2, 0, C}, {1410258, "Healing Wave", 3, 0, C}, {1410261, "Echo of Light", 4, 0, C}, {1410274, "Holy Light", 5, 0, C},
    {1410281, "Word of Glory", 6, 0, C}, {1410282, "Festering Strike", 8, 0, C}, {1410287, "Main Gauche", 2, 0, C}, {1410289, "Light of the Ancient Kings", 3, 0, C},
    {1410290, "Ancient Fury", 4, 0, C}, {1410297, "Protector of the Innocent", 5, 0, C}, {1410299, "Tiger Palm", 6, 0, C}, {1410300, "Blackout Kick", 8, 0, C},
    {1410316, "Soul Leech", 2, 0, C}, {1410321, "Bloodbath", 3, 0, C}, {1410324, "Windlash", 4, 0, C}, {1410328, "Ancestral Guidance", 5, 0, C},
    {1410333, "Windstrike", 6, 0, C}, {1410341, "Bloodthirst Heal", 8, 0, C}, {1410342, "Fists of Fury", 2, 0, C}, {1410346, "Crackling Jade Lightning", 3, 0, C},
    {1410413, "Ysera's Gift", 4, 0, C}, {1410416, "Ravager", 5, 0, C}, {1410421, "Jailer's Judgment", 30, 0, E}, {1410429, "Chaos Strike", 6, 0, C},
    {1410434, "Touch of Fatality", 22, 0, R}, {1410439, "Disrupt", 12, 0, U}, {1410446, "Shadow Dance", 14, 0, U}, {1410447, "Arcane Shot", 8, 0, C},
    {1410448, "Shadowstrike", 2, 0, C}, {1410449, "Poisoned Knife", 8, 0, U}, {1410453, "Aspect of the Eagle", 14, 0, R}, {1410456, "Chaos Barrage", 3, 0, C},
    {1410459, "Lightning Bolt", 4, 0, C}, {1410461, "Blade Dance", 10, 0, U}, {1410475, "Lightning Shield", 6, 0, C},
    {1410482, "Death's Caress", 12, 0, U}, {1410486, "Dimensional Rift", 8, 0, C}, {1410488, "Remorseless Winter", 14, 0, U}, {1410489, "Eviscerate", 2, 0, C},
    {1410490, "Feral Lunge", 16, 0, R}, {1410495, "Shuriken Storm", 3, 0, C}, {1410500, "Tyr's Deliverance", 30, 0, E}, {1410501, "Plea", 18, 0, R},
    {1410506, "Fury of the Eagle", 4, 0, C}, {1410508, "Neltharion's Fury", 34, 0, E}, {1410513, "Windburst", 38, 0, E}, {1410515, "Void Torrent", 42, 0, E},
    {1410518, "Wake of Ashes", 26, 0, E}, {1410519, "Sheilun's Gift", 30, 0, E}, {1410520, "Stormkeeper", 34, 0, E}, {1410521, "Odyn's Fury", 38, 0, E},
    {1410523, "Titan's Thunder", 42, 0, E}, {1410525, "Soul Carver", 26, 0, E}, {1410526, "Downpour", 5, 0, C}, {1410527, "Light's Wrath", 30, 0, E},
    {1410528, "Light of T'uure", 34, 0, E}, {1410530, "Eye of Tyr", 20, 0, R}, {1410532, "Warbreaker", 38, 0, E}, {1410537, "Ashamane's Frenzy", 42, 0, E},
    {1410539, "Thal'kiel's Consumption", 26, 0, E}, {1410550, "Chaos Bolt", 6, 0, C}, {1410551, "Trauma", 8, 0, C}, {1410554, "Apocalypse", 30, 0, E},
    {1410558, "Soul Cleave", 2, 0, C}, {1410567, "Shadowform", 3, 0, C}, {1410569, "Strength of the Wild", 4, 0, C}, {1410581, "Immolation Aura", 5, 0, C},
    {1410582, "Chakrams", 6, 0, C}, {1410586, "Fracture", 8, 0, C}, {1410616, "Between the Eyes", 16, 0, R}, {1410618, "Slice and Dice", 2, 0, C},
    {1410620, "Rune Strike", 3, 0, C}, {1410625, "Black Powder", 4, 0, C}, {1410630, "Surge of Earth", 5, 0, C}, {1410634, "Expel Harm", 12, 0, U},
    {1410671, "Bestial Wrath", 6, 0, C}, {1410677, "Wailing Arrow", 18, 0, R}, {1410682, "Disintegrate", 8, 0, C}, {1410688, "Naturalize", 2, 0, C},
    {1410707, "Fury of the Aspects", 40, 0, E}, {1410733, "Harrier's Cry", 30, 0, E}, {1410736, "Consume", 3, 0, C},
    -- END POOL_EXTRA2
    -- BEGIN POOL_AZERITE (azerite powers and essences as castable spells, az_data.py)
    {1408001, "Concentrated Flame", 8, 0, U}, {1408002, "Focused Azerite Beam", 12, 0, R}, {1408003, "Azerite Spike", 6, 0, U}, {1408004, "Ruinous Bolt", 10, 0, U},
    {1408005, "Reaping Flames", 14, 0, R}, {1408006, "Blood of the Enemy", 20, 0, E}, {1408007, "The Unbound Force", 18, 0, R}, {1408008, "Gutripper", 12, 0, R},
    {1408009, "Heed My Call", 16, 0, R}, {1408010, "Thunderous Blast", 22, 0, E}, {1408011, "Spirit of Preservation", 14, 0, R}, {1408012, "Venom Ward", 14, 0, R}, {1408013, "Soulcoil Well", 18, 0, R},
    -- END POOL_AZERITE
    -- BEGIN POOL_PROXY (proxy_spells.py: class spells that cast the original retail spell)
    {1470000, "Rend", 8, 0, C}, {1470001, "Cleave", 8, 0, C}, {1470002, "Shield Wall", 8, 0, C}, {1470003, "Demoralizing Shout", 32, 0, R},
    {1470004, "Recklessness", 32, 0, R}, {1470005, "Intervene", 8, 0, C}, {1470006, "Thunder Clap", 8, 0, C}, {1470007, "Revenge", 8, 0, C},
    {1470008, "Overpower", 8, 0, C}, {1470009, "Mortal Strike", 8, 0, C}, {1470010, "Piercing Howl", 32, 0, R}, {1470011, "Last Stand", 48, 0, E},
    {1470012, "Bloodthirst", 8, 0, C}, {1470013, "Shockwave", 32, 0, R}, {1470014, "Shattering Throw", 48, 0, E}, {1470015, "Rallying Cry", 48, 0, E},
    {1470016, "Storm Bolt", 32, 0, R}, {1470017, "Avatar", 32, 0, R}, {1470018, "Die by the Sword", 48, 0, E}, {1470019, "Colossus Smash", 32, 0, R},
    {1470020, "Enraged Regeneration", 48, 0, E}, {1470021, "Rampage", 8, 0, C}, {1470022, "Ignore Pain", 8, 0, C}, {1470023, "Impending Victory", 16, 0, U},
    {1470024, "Skullsplitter", 16, 0, U}, {1470025, "Onslaught", 16, 0, U}, {1470026, "Martial Prowess", 8, 0, C}, {1470027, "Champion's Spear", 32, 0, R},
    {1470028, "Titanic Throw", 8, 0, C}, {1470029, "Berserker Shout", 32, 0, R}, {1470030, "Wrecking Throw", 32, 0, R}, {1470031, "Thunderous Roar", 1, 0, R},
    {1470032, "Shield Charge", 32, 0, R}, {1470033, "Disrupting Shout", 32, 0, R}, {1470034, "Battle Stance", 8, 0, C}, {1470035, "Berserker Stance", 8, 0, C},
    {1470036, "Defensive Stance", 8, 0, C}, {1470037, "Spell Block", 32, 0, R}, {1470038, "Demolish", 32, 0, R}, {1470039, "Interpose", 8, 0, C},
    {1470040, "Aura Mastery", 48, 0, E}, {1470041, "Avenger's Shield", 10, 0, U}, {1470042, "Crusader Aura", 8, 0, C}, {1470043, "Divine Storm", 8, 0, C},
    {1470044, "Hammer of the Righteous", 8, 0, C}, {1470045, "Light of Dawn", 34, 0, C}, {1470046, "Guardian of Ancient Kings", 39, 0, C}, {1470047, "Rebuke", 27, 0, U},
    {1470048, "Holy Avenger", 1, 0, E}, {1470049, "Blinding Light", 32, 0, R}, {1470050, "Barrier of Faith", 32, 0, R}, {1470051, "Eternal Flame", 1, 0, C},
    {1470052, "Beacon of Faith", 1, 0, C}, {1470053, "Blade of Justice", 19, 0, C}, {1470054, "Divine Steed", 8, 0, C}, {1470055, "Divine Hammer", 8, 0, C},
    {1470056, "Beacon of Virtue", 1, 0, U}, {1470057, "Blessing of Spellwarding", 1, 0, C}, {1470058, "Blessed Hammer", 8, 0, C}, {1470059, "Cleanse Toxins", 8, 0, C},
    {1470060, "Justicar's Vengeance", 8, 0, C}, {1470061, "Execution Sentence", 32, 0, R}, {1470062, "Final Reckoning", 32, 0, R}, {1470063, "Divine Toll", 32, 0, R},
    {1470064, "Final Verdict", 8, 0, C}, {1470065, "Blessing of Summer", 1, 0, R}, {1470066, "Sentinel", 48, 0, E}, {1470067, "Hammer of Retribution", 5, 0, R},
    {1470068, "Hand of Divinity", 8, 0, C}, {1470069, "Holy Bulwark", 8, 0, C}, {1470070, "Rite of Sanctification", 8, 0, C}, {1470071, "Rite of Adjuration", 8, 0, C},
    {1470072, "Scare Beast", 39, 0, C}, {1470073, "Concussive Shot", 13, 0, C}, {1470074, "Aimed Shot", 10, 0, C}, {1470075, "Intimidation", 33, 0, R},
    {1470076, "Tranquilizing Shot", 37, 0, U}, {1470077, "Kill Command", 10, 0, C}, {1470078, "Misdirection", 27, 0, R}, {1470079, "Kill Shot", 42, 0, C},
    {1470080, "Roar of Sacrifice", 48, 0, E}, {1470081, "Barrage", 1, 0, U}, {1470082, "A Murder of Crows", 1, 0, R}, {1470083, "Counter Shot", 18, 0, U},
    {1470084, "Raptor Strike", 10, 0, C}, {1470085, "Bursting Shot", 12, 0, R}, {1470086, "Tar Trap", 21, 0, R}, {1470087, "Carve", 23, 0, C},
    {1470088, "Cobra Shot", 14, 0, C}, {1470089, "Camouflage", 1, 0, R}, {1470090, "Stampede", 8, 0, C}, {1470091, "Explosive Shot", 1, 0, R},
    {1470092, "Butchery", 1, 0, C}, {1470093, "Scatter Shot", 1, 0, R}, {1470094, "High Explosive Trap", 32, 0, R}, {1470095, "Rapid Fire", 1, 0, U},
    {1470096, "Mongoose Bite", 1, 0, C}, {1470097, "Wildfire Bomb", 20, 0, C}, {1470098, "Volley", 1, 0, R}, {1470099, "Flanking Strike", 32, 0, R},
    {1470100, "Serpent Sting", 8, 0, C}, {1470101, "Trueshot", 1, 0, E}, {1470102, "Bloodshed", 10, 0, R}, {1470103, "Chimaera Shot", 8, 0, C},
    {1470104, "Call of the Wild", 48, 0, E}, {1470105, "Coordinated Assault", 1, 0, E}, {1470106, "Spearhead", 1, 0, R}, {1470107, "Chakram", 48, 0, R},
    {1470108, "Implosive Trap", 32, 0, R}, {1470109, "Black Arrow", 8, 0, C}, {1470110, "Takedown", 1, 0, R}, {1470111, "Boomstick", 32, 0, R},
    {1470112, "Wild Thrash", 8, 0, C}, {1470113, "Gouge", 46, 0, U}, {1470114, "Adrenaline Rush", 48, 0, E}, {1470115, "Killing Spree", 1, 0, E},
    {1470116, "Shadow Blades", 42, 0, R}, {1470117, "Marked for Death", 1, 0, R}, {1470118, "Grappling Hook", 16, 0, C}, {1470119, "Gloomblade", 1, 0, C},
    {1470120, "Blade Rush", 32, 0, R}, {1470121, "Roll the Bones", 19, 0, R}, {1470122, "Deathmark", 48, 0, E}, {1470123, "Atrophic Poison", 8, 0, C},
    {1470124, "Amplifying Poison", 8, 0, C}, {1470125, "Keep It Rolling", 48, 0, E}, {1470126, "Serrated Bone Spike", 8, 0, C}, {1470127, "Kingsbane", 32, 0, R},
    {1470128, "Goremaw's Bite", 32, 0, R}, {1470129, "Crimson Tempest", 8, 0, C}, {1470130, "Preparation", 48, 0, E}, {1470131, "Thistle Tea", 8, 0, C},
    {1470132, "Renew", 8, 0, C}, {1470133, "Dispel Magic", 24, 0, C}, {1470134, "Prayer of Healing", 8, 0, C}, {1470135, "Mind Control", 34, 0, C},
    {1470136, "Holy Word: Serenity", 8, 0, C}, {1470137, "Mind Blast", 8, 0, C}, {1470138, "Shackle Horror", 28, 0, C}, {1470139, "Power Infusion", 58, 0, E},
    {1470140, "Holy Fire", 16, 0, U}, {1470141, "Mass Dispel", 42, 0, E}, {1470142, "Shadow Word: Death", 14, 0, C}, {1470143, "Pain Suppression", 8, 0, C},
    {1470144, "Holy Word: Sanctify", 8, 0, C}, {1470145, "Guardian Spirit", 48, 0, E}, {1470146, "Power Word: Barrier", 48, 0, E}, {1470147, "Psychic Horror", 32, 0, R},
    {1470148, "Divine Hymn", 48, 0, E}, {1470149, "Holy Word: Chastise", 32, 0, R}, {1470150, "Void Shift", 50, 0, E}, {1470151, "Halo", 1, 0, R},
    {1470152, "Angelic Feather", 1, 0, C}, {1470153, "Mindbender", 1, 0, R}, {1470154, "Holy Nova", 31, 0, C}, {1470155, "Power Word: Radiance", 8, 0, C},
    {1470156, "Apotheosis", 1, 0, E}, {1470157, "Dominate Mind", 1, 0, R}, {1470158, "Purify Disease", 18, 0, C}, {1470159, "Voidform", 48, 0, E},
    {1470160, "Dark Void", 32, 0, R}, {1470161, "Holy Word: Salvation", 27, 0, E}, {1470162, "Shadow Word: Madness", 8, 0, C}, {1470163, "Divine Word", 32, 0, R},
    {1470164, "Power Word: Life", 16, 0, U}, {1470165, "Dark Descend", 32, 0, R}, {1470166, "Ultimate Penitence", 48, 0, E}, {1470167, "Evangelism", 32, 0, R},
    {1470168, "Tentacle Slam", 8, 0, C}, {1470169, "Army of the Dead", 32, 0, R}, {1470170, "Mind Freeze", 7, 0, U}, {1470171, "Empower Rune Weapon", 8, 0, C},
    {1470172, "Death Pact", 48, 0, E}, {1470173, "Obliterate", 14, 0, C}, {1470174, "Dancing Rune Weapon", 34, 0, E}, {1470175, "Frost Strike", 11, 0, C},
    {1470176, "Howling Blast", 10, 0, C}, {1470177, "Death Strike", 4, 0, C}, {1470178, "Blood Boil", 17, 0, C}, {1470179, "Anti-Magic Zone", 48, 0, E},
    {1470180, "Pillar of Frost", 32, 0, R}, {1470181, "Scourge Strike", 11, 0, C}, {1470182, "Vampiric Blood", 32, 0, R}, {1470183, "Outbreak", 8, 0, C},
    {1470184, "Gorefiend's Grasp", 32, 0, R}, {1470185, "Control Undead", 37, 0, C}, {1470186, "Breath of Sindragosa", 48, 0, E}, {1470187, "Defile", 8, 0, C},
    {1470188, "Marrowrend", 11, 0, C}, {1470189, "Heart Strike", 10, 0, C}, {1470190, "Blooddrinker", 32, 0, R}, {1470191, "Blinding Sleet", 1, 0, R},
    {1470192, "Frostscythe", 1, 0, C}, {1470193, "Unholy Assault", 32, 0, R}, {1470194, "Clawing Shadows", 8, 0, C}, {1470195, "Wraith Walk", 25, 0, R},
    {1470196, "Asphyxiate", 21, 0, R}, {1470197, "Frostwyrm's Fury", 44, 0, R}, {1470198, "Sacrificial Pact", 54, 0, E}, {1470199, "Soul Reaper", 16, 0, U},
    {1470200, "Graveyard", 8, 0, C}, {1470201, "Vile Contagion", 32, 0, R}, {1470202, "Reaper's Mark", 32, 0, R}, {1470203, "Putrefy", 8, 0, C},
    {1470204, "Purge", 10, 0, C}, {1470205, "Earth Shield", 10, 0, C}, {1470206, "Earth Shock", 10, 0, C}, {1470207, "Tremor Totem", 47, 0, R},
    {1470208, "Windfury Totem", 49, 0, C}, {1470209, "Mana Tide Totem", 38, 0, E}, {1470210, "Windfury Weapon", 10, 0, C}, {1470211, "Earthgrab Totem", 1, 0, R},
    {1470212, "Lava Burst", 11, 0, C}, {1470213, "Feral Spirit", 34, 0, R}, {1470214, "Cleanse Spirit", 18, 0, C}, {1470215, "Lava Lash", 11, 0, U},
    {1470216, "Riptide", 10, 0, C}, {1470217, "Unleash Life", 12, 0, C}, {1470218, "Healing Rain", 34, 0, U}, {1470219, "Spiritwalker's Grace", 44, 0, E},
    {1470220, "Spirit Link Totem", 43, 0, C}, {1470221, "Healing Tide Totem", 10, 0, E}, {1470222, "Totemic Recall", 48, 0, E}, {1470223, "Totemic Projection", 16, 0, U},
    {1470224, "Ascendance", 50, 0, E}, {1470225, "Elemental Blast", 8, 0, C}, {1470226, "Crash Lightning", 1, 0, C}, {1470227, "Capacitor Totem", 23, 0, R},
    {1470228, "Wind Rush Totem", 48, 0, E}, {1470229, "Liquid Magma Totem", 1, 0, R}, {1470230, "Storm Elemental", 1, 0, C}, {1470231, "Frost Shock", 17, 0, C},
    {1470232, "Sundering", 32, 0, R}, {1470233, "Wellspring", 16, 0, U}, {1470234, "Fire Elemental", 34, 0, C}, {1470235, "Earth Elemental", 37, 0, E},
    {1470236, "Earthen Wall Totem", 1, 0, R}, {1470237, "Ancestral Protection Totem", 1, 0, E}, {1470238, "Icefury", 1, 0, C}, {1470239, "Lightning Lasso", 5, 0, R},
    {1470240, "Flametongue Weapon", 7, 0, C}, {1470241, "Fire Nova", 1, 0, C}, {1470242, "Ice Strike", 1, 0, C}, {1470243, "Greater Purge", 10, 0, U},
    {1470244, "Earthliving Weapon", 8, 0, C}, {1470245, "Poison Cleansing Totem", 10, 0, E}, {1470246, "Stoneskin Totem", 10, 0, R}, {1470247, "Tranquil Air Totem", 10, 0, R},
    {1470248, "Doom Winds", 32, 0, R}, {1470249, "Ancestral Swiftness", 32, 0, R}, {1470250, "Thunderstrike Ward", 8, 0, C}, {1470251, "Voltaic Blaze", 16, 0, U},
    {1470252, "Remove Curse", 14, 0, C}, {1470253, "Conjure Mana Gem", 17, 0, C}, {1470254, "Flamestrike", 12, 0, C}, {1470255, "Scorch", 13, 0, C},
    {1470256, "Arcane Missiles", 13, 0, C}, {1470257, "Pyroblast", 12, 0, C}, {1470258, "Ice Barrier", 11, 0, C}, {1470259, "Icy Veins", 48, 0, E},
    {1470260, "Ice Lance", 10, 0, C}, {1470261, "Slow", 12, 0, C}, {1470262, "Dragon's Breath", 27, 0, R}, {1470263, "Summon Water Elemental", 12, 0, U},
    {1470264, "Living Bomb", 1, 0, R}, {1470265, "Flurry", 19, 0, C}, {1470266, "Frozen Orb", 32, 0, R}, {1470267, "Ice Floes", 1, 0, C},
    {1470268, "Greater Invisibility", 47, 0, E}, {1470269, "Ring of Frost", 1, 0, R}, {1470270, "Nether Tempest", 1, 0, C}, {1470271, "Meteor", 32, 0, R},
    {1470272, "Arcane Orb", 8, 0, C}, {1470273, "Supernova", 1, 0, R}, {1470274, "Blast Wave", 1, 0, R}, {1470275, "Ice Nova", 1, 0, U},
    {1470276, "Combustion", 29, 0, E}, {1470277, "Ray of Frost", 1, 0, C}, {1470278, "Presence of Mind", 32, 0, R}, {1470279, "Cold Snap", 10, 0, E},
    {1470280, "Blazing Barrier", 8, 0, C}, {1470281, "Prismatic Barrier", 11, 0, C}, {1470282, "Phoenix Flames", 19, 0, C}, {1470283, "Fire Ward", 33, 0, R},
    {1470284, "Touch of the Magi", 8, 0, C}, {1470285, "Arcane Surge", 10, 0, R}, {1470286, "Mass Polymorph", 32, 0, R}, {1470287, "Reflection", 8, 0, C},
    {1470288, "Mass Barrier", 48, 0, E}, {1470289, "Mass Invisibility", 48, 0, E}, {1470290, "Frostfire Bolt", 8, 0, C}, {1470291, "Doom", 32, 0, R},
    {1470292, "Agony", 10, 0, C}, {1470293, "Summon Infernal", 48, 0, E}, {1470294, "Curse of Tongues", 34, 0, C}, {1470295, "Howl of Terror", 1, 0, R},
    {1470296, "Rain of Fire", 8, 0, C}, {1470297, "Soul Fire", 32, 0, R}, {1470298, "Mortal Coil", 1, 0, R}, {1470299, "Shadowburn", 1, 0, C},
    {1470300, "Conflagrate", 8, 0, C}, {1470301, "Seed of Corruption", 8, 0, C}, {1470302, "Summon Felguard", 8, 0, C}, {1470303, "Shadowfury", 38, 0, R},
    {1470304, "Haunt", 16, 0, U}, {1470305, "Havoc", 32, 0, R}, {1470306, "Call Dreadstalkers", 16, 0, U}, {1470307, "Dark Pact", 1, 0, R},
    {1470308, "Grimoire of Sacrifice", 1, 0, R}, {1470309, "Demonic Gateway", 49, 0, U}, {1470310, "Grimoire: Felguard", 1, 0, E}, {1470311, "Cataclysm", 32, 0, R},
    {1470312, "Implosion", 16, 0, U}, {1470313, "Channel Demonfire", 16, 0, U}, {1470314, "Phantom Singularity", 32, 0, R}, {1470315, "Summon Darkglare", 48, 0, E},
    {1470316, "Soul Strike", 1, 0, U}, {1470317, "Summon Vilefiend", 1, 0, U}, {1470318, "Power Siphon", 32, 0, R}, {1470319, "Demonbolt", 8, 0, C},
    {1470320, "Summon Demonic Tyrant", 32, 0, R}, {1470321, "Demonic Strength", 1, 0, R}, {1470322, "Bilescourge Bombers", 1, 0, R}, {1470323, "Vile Taint", 32, 0, R},
    {1470324, "Malefic Rapture", 8, 0, C}, {1470325, "Amplify Curse", 1, 0, R}, {1470326, "Fel Domination", 48, 0, E}, {1470327, "Curse of Exhaustion", 12, 0, C},
    {1470328, "Shadowflame", 16, 0, U}, {1470329, "Soulburn", 8, 0, C}, {1470330, "Decimating Bolt", 48, 0, R}, {1470331, "Guillotine", 32, 0, R},
    {1470332, "Soul Swap", 32, 0, R}, {1470333, "Oblivion", 32, 0, R}, {1470334, "Dark Harvest", 32, 0, R}, {1470335, "Unstable Affliction", 10, 0, C},
    {1470336, "Blight of Tongues", 48, 0, E}, {1470337, "Grimoire: Imp Lord", 1, 0, E}, {1470338, "Grimoire: Fel Ravager", 48, 0, E}, {1470339, "Summon Doomguard", 48, 0, E},
    {1470340, "Transcendence", 32, 0, U}, {1470341, "Rising Sun Kick", 10, 0, C}, {1470342, "Chi Torpedo", 1, 0, C}, {1470343, "Paralysis", 22, 0, R},
    {1470344, "Renewing Mist", 8, 0, C}, {1470345, "Zen Meditation", 34, 0, E}, {1470346, "Breath of Fire", 29, 0, U}, {1470347, "Revival", 8, 0, C},
    {1470348, "Summon Jade Serpent Statue", 1, 0, U}, {1470349, "Summon Black Ox Statue", 1, 0, U}, {1470350, "Black Ox Brew", 1, 0, E}, {1470351, "Disable", 34, 0, C},
    {1470352, "Thunder Focus Tea", 8, 0, C}, {1470353, "Spear Hand Strike", 18, 0, U}, {1470354, "Tiger's Lust", 1, 0, R}, {1470355, "Ring of Peace", 25, 0, R},
    {1470356, "Rushing Jade Wind", 1, 0, C}, {1470357, "Life Cocoon", 8, 0, C}, {1470358, "Purifying Brew", 23, 0, C}, {1470359, "Keg Smash", 8, 0, C},
    {1470360, "Dampen Harm", 1, 0, E}, {1470361, "Healing Elixir", 1, 0, C}, {1470362, "Diffuse Magic", 1, 0, R}, {1470363, "Invoke Xuen, the White Tiger", 42, 0, E},
    {1470364, "Chi Burst", 1, 0, R}, {1470365, "Zen Pulse", 1, 0, R}, {1470366, "Enveloping Mist", 8, 0, C}, {1470367, "Invoke Niuzao, the Black Ox", 1, 0, E},
    {1470368, "Storm, Earth, and Fire", 27, 0, U}, {1470369, "Whirling Dragon Punch", 32, 0, R}, {1470370, "Refreshing Jade Wind", 1, 0, R}, {1470371, "Song of Chi-Ji", 1, 0, R},
    {1470372, "Invoke Yu'lon, the Jade Serpent", 48, 0, E}, {1470373, "Celestial Brew", 8, 0, C}, {1470374, "Clash", 54, 0, R}, {1470375, "Exploding Keg", 32, 0, R},
    {1470376, "Invoke Chi-Ji, the Red Crane", 1, 0, E}, {1470377, "Bonedust Brew", 48, 0, R}, {1470378, "Jadefire Stomp", 8, 0, C}, {1470379, "Restoral", 8, 0, C},
    {1470380, "Strike of the Windlord", 32, 0, R}, {1470381, "Celestial Conduit", 32, 0, R}, {1470382, "Rushing Wind Kick", 8, 0, C}, {1470383, "Slicing Winds", 32, 0, R},
    {1470384, "Celestial Infusion", 8, 0, C}, {1470385, "Zenith", 16, 0, U}, {1470386, "Incapacitating Roar", 28, 0, R}, {1470387, "Rip", 21, 0, C},
    {1470388, "Rake", 10, 0, C}, {1470389, "Hibernate", 38, 0, C}, {1470390, "Remove Corruption", 8, 0, C}, {1470391, "Soothe", 41, 0, U},
    {1470392, "Mighty Bash", 1, 0, R}, {1470393, "Tiger's Fury", 32, 0, R}, {1470394, "Maul", 10, 0, C}, {1470395, "Swiftmend", 11, 0, C},
    {1470396, "Maim", 28, 0, R}, {1470397, "Frenzied Regeneration", 21, 0, C}, {1470398, "Moonkin Form", 8, 0, C}, {1470399, "Innervate", 42, 0, E},
    {1470400, "Lifebloom", 21, 0, C}, {1470401, "Cyclone", 48, 0, C}, {1470402, "Wild Growth", 34, 0, U}, {1470403, "Berserk", 1, 0, E},
    {1470404, "Nourish", 8, 0, C}, {1470405, "Survival Instincts", 32, 0, C}, {1470406, "Starsurge", 12, 0, C}, {1470407, "Solar Beam", 32, 0, R},
    {1470408, "Wild Mushroom", 8, 0, C}, {1470409, "Ironbark", 12, 0, R}, {1470410, "Mass Entanglement", 1, 0, R}, {1470411, "Incarnation: Avatar of Ashamane", 1, 0, E},
    {1470412, "Incarnation: Guardian of Ursoc", 1, 0, E}, {1470413, "Incarnation: Chosen of Elune", 1, 0, C}, {1470414, "Ursol's Vortex", 28, 0, R}, {1470415, "Skull Bash", 26, 0, U},
    {1470416, "Renewal", 1, 0, R}, {1470417, "Nature's Swiftness", 32, 0, R}, {1470418, "Bristling Fur", 32, 0, R}, {1470419, "Ironfur", 18, 0, C},
    {1470420, "Starfire", 8, 0, C}, {1470421, "Celestial Alignment", 8, 0, C}, {1470422, "Rage of the Sleeper", 32, 0, R}, {1470423, "Brutal Slash", 1, 0, C},
    {1470424, "Stellar Flare", 8, 0, C}, {1470425, "Warrior of Elune", 32, 0, R}, {1470426, "Blessing of Elune", 8, 0, C}, {1470427, "Fury of Elune", 32, 0, R},
    {1470428, "Lunar Beam", 1, 0, R}, {1470429, "Swipe", 10, 0, C}, {1470430, "New Moon", 8, 0, C}, {1470431, "Feral Frenzy", 32, 0, R},
    {1470432, "Primal Wrath", 8, 0, C}, {1470433, "Adaptive Swarm", 48, 0, U}, {1470434, "Invigorate", 16, 0, U}, {1470435, "Raze", 8, 0, C},
    {1470436, "Symbiotic Relationship", 8, 0, C}, {1470437, "Frantic Frenzy", 32, 0, R}, {1470438, "Chomp", 16, 0, U}, {1470439, "Red Moon", 32, 0, R},
    {1470440, "Sundering Roar", 1, 0, R}, {1470441, "Heart of the Wild", 48, 0, E}, {1470442, "Chaos Nova", 32, 0, R}, {1470443, "Netherwalk", 8, 0, C},
    {1470444, "Darkness", 48, 0, E}, {1470445, "Eye Beam", 11, 0, R}, {1470446, "Sigil of Silence", 39, 0, C}, {1470447, "Fiery Brand", 1, 0, C},
    {1470448, "Sigil of Flame", 10, 0, C}, {1470449, "Sigil of Misery", 8, 0, C}, {1470450, "Fel Eruption", 23, 0, R}, {1470451, "Fel Devastation", 11, 0, R},
    {1470452, "Imprison", 34, 0, R}, {1470453, "Felblade", 16, 0, U}, {1470454, "Spirit Bomb", 16, 0, U}, {1470455, "Essence Break", 32, 0, R},
    {1470456, "Fel Barrage", 32, 0, R}, {1470457, "Consume Magic", 17, 0, U}, {1470458, "Glaive Tempest", 8, 0, C}, {1470459, "The Hunt", 48, 0, R},
    {1470460, "Sigil of Spite", 1, 0, C}, {1470461, "Void Ray", 8, 0, C}, {1470462, "Abyssal Breach", 60, 0, U}, {1470463, "Reap", 8, 0, C},
    {1470464, "Spinning Death", 32, 0, R}, {1470465, "Beckon", 8, 0, C}, {1470466, "Void Nova", 32, 0, R}, {1470467, "Sunder", 32, 0, R},
    {1470468, "Soul Immolation", 10, 0, C}, {1470469, "Voidblade", 8, 0, C}, {1470470, "Quell", 16, 0, U}, {1470471, "Dream Breath", 8, 0, C},
    {1470472, "Time Dilation", 8, 0, C}, {1470473, "Pyre", 8, 0, C}, {1470474, "Landslide", 32, 0, R}, {1470475, "Eternity Surge", 32, 0, R},
    {1470476, "Dream Flight", 48, 0, E}, {1470477, "Sleep Walk", 60, 0, C}, {1470478, "Blistering Scales", 32, 0, R}, {1470479, "Verdant Embrace", 8, 0, C},
    {1470480, "Rewind", 8, 0, C}, {1470481, "Echo", 8, 0, C}, {1470482, "Expunge", 10, 0, C}, {1470483, "Reversion", 8, 0, C},
    {1470484, "Spiritbloom", 32, 0, R}, {1470485, "Firestorm", 16, 0, U}, {1470486, "Source of Magic", 8, 0, C}, {1470487, "Stasis", 32, 0, R},
    {1470488, "Tip the Scales", 48, 0, E}, {1470489, "Rescue", 32, 0, R}, {1470490, "Emerald Communion", 48, 0, E}, {1470491, "Oppressing Roar", 60, 0, E},
    {1470492, "Temporal Anomaly", 16, 0, U}, {1470493, "Zephyr", 48, 0, E}, {1470494, "Cauterizing Flame", 59, 0, R}, {1470495, "Time Spiral", 48, 0, E},
    {1470496, "Dragonrage", 48, 0, E}, {1470497, "Ebon Might", 32, 0, R}, {1470498, "Eruption", 8, 0, C}, {1470499, "Upheaval", 32, 0, R},
    {1470500, "Breath of Eons", 48, 0, E}, {1470501, "Time Skip", 48, 0, E}, {1470502, "Spatial Paradox", 48, 0, E}, {1470503, "Bestow Weyrnstone", 32, 0, R},
    {1470504, "Prescience", 8, 0, C}, {1470505, "Timelessness", 8, 0, C}, {1470506, "Temporal Barrier", 16, 0, U},
    -- END POOL_PROXY
}
-- BEGIN TALENTS (generated by talents_build.py - do not edit by hand)
-- Hero talents. Generic ranks are custom spells 1400100+ (hero_talents.sql);
-- the rest are retail class talents that improve a Hero ability (req = abilities).
local TALENTS = {
    {1400100, "Hero's Fortitude 1", 10, 0, 1, prev = 0},
    {1400101, "Hero's Fortitude 2", 20, 0, 2, prev = 1400100},
    {1400102, "Hero's Fortitude 3", 30, 0, 3, prev = 1400101},
    {1400103, "Hero's Might 1", 10, 0, 1, prev = 0},
    {1400104, "Hero's Might 2", 20, 0, 2, prev = 1400103},
    {1400105, "Hero's Might 3", 30, 0, 3, prev = 1400104},
    {1400106, "Keen Edge 1", 10, 0, 1, prev = 0},
    {1400107, "Keen Edge 2", 20, 0, 2, prev = 1400106},
    {1400108, "Keen Edge 3", 30, 0, 3, prev = 1400107},
    {1400109, "Quickening 1", 10, 0, 1, prev = 0},
    {1400110, "Quickening 2", 20, 0, 2, prev = 1400109},
    {1400111, "Quickening 3", 30, 0, 3, prev = 1400110},
    {1400112, "Mending Hands 1", 10, 0, 1, prev = 0},
    {1400113, "Mending Hands 2", 20, 0, 2, prev = 1400112},
    {1400114, "Mending Hands 3", 30, 0, 3, prev = 1400113},
    {1400115, "Iron Hide 1", 10, 0, 1, prev = 0},
    {1400116, "Iron Hide 2", 20, 0, 2, prev = 1400115},
    {1400117, "Iron Hide 3", 30, 0, 3, prev = 1400116},
    {1400118, "Fleet Foot 1", 10, 0, 1, prev = 0},
    {1400119, "Fleet Foot 2", 20, 0, 2, prev = 1400118},
    {1400120, "Versatile Hero 1", 10, 0, 1, prev = 0},
    {1400121, "Versatile Hero 2", 20, 0, 2, prev = 1400120},
    {1400122, "Versatile Hero 3", 30, 0, 3, prev = 1400121},
    {1400123, "Lifebinder 1", 10, 0, 1, prev = 0},
    {1400124, "Lifebinder 2", 20, 0, 2, prev = 1400123},
    {1400125, "Essence Attunement 1", 10, 0, 1, prev = 0},
    {1400126, "Essence Attunement 2", 20, 0, 2, prev = 1400125},
    {1400127, "Essence Attunement 3", 30, 0, 3, prev = 1400126},
    {196103, "Absolute Corruption", 10, 0, 2, req = {1410013}},
    {391275, "Accelerated Blade", 20, 0, 2, req = {1410442}},
    {200733, "Airborne Irritant", 39, 0, 2, req = {1410078}},
    {382732, "Ancestral Reach", 12, 0, 2, req = {1410046}},
    {344359, "Ancient Arts", 12, 0, 3, req = {1410347}},
    {1250565, "Angelic Touch", 10, 0, 2, req = {1410077}},
    {205727, "Anti-Magic Barrier", 14, 0, 2, req = {1410204}},
    {429540, "Arcane Affinity", 10, 0, 2, req = {1410095, 1410472}},
    {375618, "Arcane Intensity", 10, 0, 3, req = {1410694}},
    {454983, "Arcane Reach", 10, 0, 2, req = {1410692}},
    {377933, "Astral Bulwark", 16, 0, 2, req = {1410315}},
    {197524, "Astral Influence", 10, 0, 2, req = {1410014, 1410035, 1410037, 1410095, 1410128, 1410129, 1410154, 1410234, 1410292, 1410305, 1410414, 1410472, 1410541, 1410731}},
    {381845, "Audacity", 10, 0, 2, req = {1410126}},
    {457034, "Bait and Switch", 10, 0, 2, req = {1410099, 1410181}},
    {383082, "Barbaric Training", 10, 0, 3, req = {1410056, 1410060}},
    {1271305, "Bask in Moonlight", 35, 0, 2, req = {1410472}},
    {424742, "Battlefield Commander", 12, 0, 2, req = {1410098, 1410298}},
    {1262758, "Benediction", 10, 0, 3, req = {1410000, 1410077}},
    {415416, "Benevolence", 10, 0, 2, req = {1410000, 1410077}},
    {215768, "Blaze of Light", 10, 0, 3, req = {1410023}},
    {469770, "Blessed Calling", 10, 0, 2, req = {1410044, 1410045, 1410119}},
    {445200, "Blessing of An'she", 20, 0, 2, req = {1410153}},
    {256165, "Blinding Powder", 39, 0, 2, req = {1410078}},
    {381626, "Bloody Mess", 11, 0, 2, req = {1410033}},
    {266921, "Born To Be Wild", 10, 0, 3, req = {1410451, 1410452}},
    {320386, "Bouncing Glaives", 20, 0, 2, req = {1410442}},
    {202163, "Bounding Stride", 14, 0, 2, req = {1410114}},
    {444020, "Burning Adrenaline", 20, 0, 2, req = {1410683}},
    {378241, "Call of Thunder", 12, 0, 2, req = {1410460}},
    {1258404, "Catlike Reflexes", 10, 0, 2, req = {1410451}},
    {1240185, "Celestial Fire", 13, 0, 2, req = {1410430}},
    {334308, "Chaining Storms", 12, 0, 2, req = {1410460}},
    {429211, "Champion of the Glaive", 20, 0, 2, req = {1410442}},
    {1244105, "Charm of Aegwynn", 10, 0, 2, req = {1410007, 1410008, 1410011, 1410626}},
    {450426, "Chi Proficiency", 10, 0, 3, req = {1410340}},
    {1291522, "Chronal Dynamo", 10, 0, 2, req = {1410692}},
    {400320, "Circle of Life and Death", 10, 0, 2, req = {1410037, 1410095, 1410129, 1410305, 1410430}},
    {474541, "Circle of the Heavens", 10, 0, 2, req = {1410095, 1410430}},
    {1248793, "Clear the Witnesses", 19, 0, 2, req = {1410213}},
    {1276679, "Clever Combatant", 12, 0, 2, req = {1410450}},
    {383115, "Concussive Blows", 10, 0, 2, req = {1410115}},
    {1253887, "Conditioning", 10, 0, 2, req = {1410451}},
    {379022, "Consecration in Flame", 10, 0, 3, req = {1410174}},
    {453096, "Contagion", 10, 0, 2, req = {1410013}},
    {400059, "Cosmic Rapidity", 13, 0, 3, req = {1410430}},
    {388848, "Crane Vortex", 10, 0, 3, req = {1410303}},
    {264000, "Creeping Death", 10, 0, 3, req = {1410013}},
    {390954, "Crisis Management", 10, 0, 2, req = {1410077}},
    {389306, "Critical Thinking", 10, 0, 3, req = {1410101}},
    {392777, "Cruel Strikes", 10, 0, 3, req = {1410101}},
    {382764, "Crushing Force", 10, 0, 2, req = {1410169}},
    {1253093, "Current Control", 12, 0, 2, req = {1410046}},
    {386659, "Dark Accord", 16, 0, 2, req = {1410309}},
    {382504, "Dark Brew", 10, 0, 2, req = {1410086, 1410091}},
    {391099, "Dark Evangelism", 10, 0, 2, req = {1410025}},
    {381542, "Deadly Precision", 10, 0, 2, req = {1410001, 1410033, 1410064, 1410126, 1410213, 1410322, 1410450}},
    {1266819, "Death Notes", 20, 0, 2, req = {1410236}},
    {437122, "Death's Messenger", 20, 0, 2, req = {1410198, 1410206}},
    {276079, "Death's Reach", 10, 0, 2, req = {1410207}},
    {453908, "Demonic Brutality", 10, 0, 3, req = {1410568}},
    {205411, "Desperate Instincts", 16, 0, 2, req = {1410497}},
    {454435, "Destiny Defined", 10, 0, 2, req = {1410086, 1410091}},
    {454735, "Devastation", 10, 0, 3, req = {1410568}},
    {387805, "Divine Glimpse", 20, 0, 2, req = {1410153}},
    {469476, "Divine Reach", 10, 0, 2, req = {1410019, 1410438}},
    {469409, "Divine Spurs", 14, 0, 2, req = {1410470}},
    {441415, "Don't Be Suspicious", 11, 0, 2, req = {1410042, 1410078, 1410117, 1410323}},
    {381801, "Dragon-Tempered Blades", 10, 0, 2, req = {1410086, 1410091}},
    {382900, "Dual Wield Specialization", 10, 0, 3, req = {1410056, 1410062, 1410169, 1410188, 1410227}},
    {1248014, "Dualcasting Adept", 10, 0, 2, req = {1410005, 1410007, 1410008, 1410626}},
    {468626, "Earthshatter", 20, 0, 2, req = {1410259}},
    {387801, "Echoing Blessings", 10, 0, 2, req = {1410044, 1410045, 1410119}},
    {410784, "Echoing Strike", 10, 0, 2, req = {1410694}},
    {1261047, "Efficiency", 10, 0, 2, req = {1410056}},
    {450989, "Efficient Training", 10, 0, 2, req = {1410303}},
    {431067, "Elemental Affinity", 10, 0, 2, req = {1410007, 1410008, 1410626}},
    {210853, "Elemental Assault", 20, 0, 3, req = {1410183}},
    {60188, "Elemental Fury", 10, 0, 2, req = {1410210, 1410259, 1410460, 1410735}},
    {1258895, "Elemental Resonance", 10, 0, 2, req = {1410183, 1410210, 1410259, 1410460, 1410735}},
    {1250364, "Elemental Tempo", 10, 0, 2, req = {1410259, 1410460, 1410735}},
    {388681, "Elusive Mists", 10, 0, 3, req = {1410531}},
    {79008, "Elusiveness", 10, 0, 2, req = {1410074, 1410099}},
    {1271689, "Empowered Drain Life", 10, 0, 2, req = {1410568}},
    {386027, "Enduring Defenses", 10, 0, 3, req = {1410083}},
    {370837, "Engulfing Blaze", 10, 0, 2, req = {1410692}},
    {375554, "Enkindled", 10, 0, 3, req = {1410692}},
    {238135, "Eternal Barrier", 10, 0, 2, req = {1410000}},
    {457022, "Ethereal Cloak", 16, 0, 2, req = {1410181}},
    {1265570, "Executioner's Wrath", 10, 0, 2, req = {1410101}},
    {375517, "Extended Flight", 10, 0, 3, req = {1410686}},
    {381708, "Eye of the Storm", 20, 0, 3, req = {1410259}},
    {1261543, "Fast Feet", 10, 0, 3, req = {1410303}},
    {388809, "Fast Feet", 10, 0, 2, req = {1410303}},
    {392384, "Fatal Concoction", 10, 0, 3, req = {1410086}},
    {394923, "Fatal Flying Guillotine", 22, 0, 2, req = {1410635}},
    {394123, "Fatal Touch", 22, 0, 3, req = {1410635}},
    {1271925, "Fearless", 10, 0, 2, req = {1410142}},
    {423683, "Featherfoot", 10, 0, 2, req = {1410089}},
    {1270062, "Feedback Loop", 10, 0, 3, req = {1410183, 1410210, 1410259, 1410460, 1410735}},
    {1270061, "Feedback Loop", 10, 0, 2, req = {1410183, 1410210, 1410259, 1410460, 1410735}},
    {387044, "Fervent Flickering", 10, 0, 2, req = {1410626}},
    {382886, "Fire and Ice", 10, 0, 2, req = {1410735}},
    {450831, "Fire's Ire", 10, 0, 3, req = {1410007, 1410008, 1410011, 1410626}},
    {234299, "Fist of Justice", 10, 0, 2, req = {1410040}},
    {378266, "Flames of the Cauldron", 10, 0, 2, req = {1410735}},
    {381784, "Flames of the Firelord", 10, 0, 2, req = {1410735}},
    {381936, "Flash of Lightning", 12, 0, 2, req = {1410460}},
    {1259492, "Flickering Steel", 10, 0, 2, req = {1410126}},
    {382039, "Flow of the Tides", 12, 0, 2, req = {1410046}},
    {439901, "Flower Walk", 12, 0, 2, req = {1410167}},
    {381631, "Flying Daggers", 19, 0, 2, req = {1410213}},
    {1249230, "Focused Power", 10, 0, 2, req = {1410023, 1410025}},
    {375783, "Font of Magic", 20, 0, 2, req = {1410683}},
    {411212, "Font of Magic", 20, 0, 2, req = {1410683}},
    {408083, "Font of Magic", 20, 0, 2, req = {1410683}},
    {393098, "Forbidden Technique", 22, 0, 2, req = {1410635}},
    {342344, "From the Ashes", 10, 0, 2, req = {1410626}},
    {377835, "Front of the Pack", 20, 0, 2, req = {1410312}},
    {431166, "Frostfire Infusion", 10, 0, 2, req = {1410005, 1410007, 1410626}},
    {400142, "Gale Winds", 10, 0, 2, req = {1410234}},
    {155675, "Germination", 10, 0, 3, req = {1410037}},
    {1270701, "Gorefiend's Avarice", 10, 0, 2, req = {1410568}},
    {1298779, "Grim Deliverance", 10, 0, 2, req = {1410077}},
    {429402, "Grove's Inspiration", 10, 0, 2, req = {1410095, 1410129}},
    {441180, "Hardened Scales", 16, 0, 2, req = {1410697}},
    {328670, "Hasty Provocation", 10, 0, 2, req = {1410335}},
    {1247166, "Healing Focus", 10, 0, 2, req = {1410077}},
    {1248002, "Heat Sink", 10, 0, 2, req = {1410626}},
    {381885, "Heavy Hitter", 10, 0, 3, req = {1410068, 1410126, 1410450}},
    {203177, "Heavy Repercussions", 10, 0, 2, req = {1410169}},
    {1311969, "Hedonic Gorging", 10, 0, 2, req = {1410568}},
    {453729, "Heightened Alteration", 35, 0, 2, req = {1410202}},
    {383281, "Hidden Opportunity", 10, 0, 2, req = {1410126}},
    {371038, "Honed Aggression", 10, 0, 3, req = {1410694}},
    {391271, "Honed Reflexes", 10, 0, 2, req = {1410115, 1410168}},
    {439868, "Hunt Beneath the Open Skies", 13, 0, 2, req = {1410430}},
    {383430, "Impale", 10, 0, 2, req = {1410056, 1410062, 1410169, 1410188, 1410227}},
    {1265386, "Implacable", 10, 0, 3, req = {1410033, 1410086}},
    {381620, "Improved Ambush", 10, 0, 2, req = {1410126}},
    {1258407, "Improved Aspect of the Cheetah", 10, 0, 2, req = {1410451}},
    {1258485, "Improved Aspect of the Turtle", 20, 0, 2, req = {1410452}},
    {319949, "Improved Backstab", 12, 0, 2, req = {1410001}},
    {327993, "Improved Barkskin", 12, 0, 2, req = {1410167}},
    {1244025, "Improved Conjuration", 18, 0, 3, req = {1410222}},
    {1270865, "Improved Counterspell", 12, 0, 2, req = {1410081}},
    {316405, "Improved Execute", 10, 0, 2, req = {1410101}},
    {316402, "Improved Execute", 10, 0, 2, req = {1410101}},
    {390670, "Improved Fade", 10, 0, 3, req = {1410024}},
    {1258486, "Improved Feign Death", 16, 0, 3, req = {1410102}},
    {393870, "Improved Flash Heal", 10, 0, 2, req = {1410077}},
    {343183, "Improved Frost Nova", 10, 0, 2, req = {1410008}},
    {381624, "Improved Poisons", 10, 0, 2, req = {1410086, 1410091}},
    {1270827, "Improved Spellsteal", 20, 0, 2, req = {1410178}},
    {231691, "Improved Sprint", 10, 0, 2, req = {1410089}},
    {288826, "Improved Stampeding Roar", 20, 0, 2, req = {1410312}},
    {383155, "Improved Sweeping Strikes", 20, 0, 2, req = {1410584}},
    {343247, "Improved Traps", 10, 0, 3, req = {1410457}},
    {231602, "Improved Vivify", 10, 0, 3, req = {1410340}},
    {400140, "Incessant Tempest", 10, 0, 2, req = {1410234}},
    {1259047, "Inferno Arc", 10, 0, 2, req = {1410735}},
    {390693, "Inner Focus", 10, 0, 2, req = {1410077}},
    {448278, "Inner Quietus", 10, 0, 2, req = {1410000, 1410025}},
    {469439, "Inspired Guard", 26, 0, 2, req = {1410020, 1410239}},
    {382310, "Inspiring Presence", 18, 0, 2, req = {1410298}},
    {1242862, "Instilled Doubt", 10, 0, 3, req = {1410025}},
    {1270350, "Instinctive Imbuements", 12, 0, 2, req = {1410214}},
    {288733, "Intangibility", 35, 0, 2, req = {1410202}},
    {1264649, "Intensity", 10, 0, 2, req = {1410129}},
    {450379, "Invigorating Pulse", 10, 0, 2, req = {1410225}},
    {1279350, "Invoked Nightmare", 10, 0, 2, req = {1410025}},
    {193546, "Iron Stomach", 20, 0, 2, req = {1410445}},
    {1271948, "Javelineer", 10, 0, 2, req = {1410227}},
    {405330, "Kindled Malice", 10, 0, 3, req = {1410013}},
    {382238, "Lethality", 10, 0, 3, req = {1410001, 1410033, 1410064, 1410126, 1410213, 1410322, 1410450}},
    {373450, "Light's Inspiration", 10, 0, 2, req = {1410143}},
    {462862, "Lightning Capacitor", 10, 0, 2, req = {1410210, 1410259, 1410460, 1410735}},
    {231040, "Lingering Healing", 10, 0, 2, req = {1410037}},
    {426702, "Liveliness", 10, 0, 2, req = {1410037, 1410095, 1410129, 1410305, 1410430}},
    {205024, "Lonely Winter", 10, 0, 2, req = {1410007, 1410008, 1410011, 1410626}},
    {389781, "Long Night", 24, 0, 2, req = {1410487}},
    {449185, "Lore of the Grove", 13, 0, 2, req = {1410430}},
    {389849, "Lost in Darkness", 10, 0, 2, req = {1410462}},
    {458431, "Lotus Infusion", 10, 0, 2, req = {1410331}},
    {431402, "Luminosity", 20, 0, 2, req = {1410153}},
    {443447, "Maelstrom Supremacy", 10, 0, 2, req = {1410046, 1410123, 1410259}},
    {453087, "Malediction", 10, 0, 2, req = {1410013}},
    {450875, "Manifestation", 20, 0, 2, req = {1410355}},
    {429638, "Martial Expert", 10, 0, 2, req = {1410056, 1410062, 1410169, 1410188, 1410227}},
    {378436, "Master Poisoner", 10, 0, 2, req = {1410091}},
    {210476, "Master of Escape", 16, 0, 2, req = {1410002}},
    {341167, "Mental Agility", 10, 0, 2, req = {1410021}},
    {391330, "Meridian Strikes", 22, 0, 2, req = {1410635}},
    {1240262, "Meteor Storm", 35, 0, 2, req = {1410472}},
    {1251029, "Mindpierce", 10, 0, 2, req = {1410023}},
    {441250, "Mirrors", 12, 0, 2, req = {1410074}},
    {238558, "Misery", 10, 0, 2, req = {1410025}},
    {429520, "Moon Guardian", 10, 0, 2, req = {1410128}},
    {429642, "Mountain of Muscle and Scars", 10, 0, 2, req = {1410056, 1410062, 1410169, 1410188, 1410227}},
    {1264691, "Natural Gift", 10, 0, 2, req = {1410210, 1410259, 1410460, 1410735}},
    {270581, "Natural Mending", 12, 0, 3, req = {1410318}},
    {381655, "Nature's Fury", 10, 0, 3, req = {1410046, 1410123, 1410210, 1410460, 1410735}},
    {427794, "Never Say Die", 20, 0, 2, req = {1410442}},
    {433934, "Newly Turned", 20, 0, 2, req = {1410236}},
    {378427, "Nimble Fingers", 12, 0, 2, req = {1410074, 1410445}},
    {441253, "Nimble Flyer", 10, 0, 2, req = {1410686}},
    {1279510, "Niskaran Methods", 10, 0, 2, req = {1410013}},
    {33873, "Nurturing Instinct", 10, 0, 3, req = {1410037, 1410095, 1410129, 1410305, 1410430}},
    {449191, "Oakskin", 12, 0, 2, req = {1410167}},
    {1250293, "Occultist", 10, 0, 2, req = {1410025}},
    {382895, "One-Handed Weapon Specialization", 10, 0, 3, req = {1410056, 1410062, 1410169, 1410188, 1410227}},
    {454835, "Osmosis", 14, 0, 2, req = {1410204}},
    {441844, "Pack's Endurance", 20, 0, 2, req = {1410312}},
    {390689, "Pain and Suffering", 10, 0, 3, req = {1410025}},
    {1251030, "Painful Invocation", 10, 0, 2, req = {1410025}},
    {1270592, "Patient Custodian", 10, 0, 2, req = {1410037, 1410129, 1410430}},
    {55676, "Petrifying Scream", 12, 0, 2, req = {1410124}},
    {378919, "Piercing Cold", 10, 0, 2, req = {1410005}},
    {389783, "Pitch Black", 24, 0, 2, req = {1410487}},
    {381647, "Planes Traveler", 16, 0, 2, req = {1410315}},
    {1261050, "Powerful Momentum", 20, 0, 2, req = {1410584}},
    {429647, "Practiced Strikes", 10, 0, 2, req = {1410056, 1410060, 1410169}},
    {390977, "Prayers of the Virtuous", 20, 0, 2, req = {1410186}},
    {428377, "Precision Shot", 12, 0, 2, req = {1410450}},
    {440662, "Preventive Measures", 10, 0, 2, req = {1410000, 1410023}},
    {369909, "Protracted Talons", 10, 0, 2, req = {1410694}},
    {196704, "Psychic Voice", 12, 0, 2, req = {1410124}},
    {275334, "Punish", 10, 0, 2, req = {1410169}},
    {1250218, "Purge the Wicked", 10, 0, 2, req = {1410023}},
    {382503, "Quick Decisions", 12, 0, 2, req = {1410191, 1410483}},
    {379391, "Quickened Invocation", 20, 0, 2, req = {1410326}},
    {1266845, "Quickened Pulse", 10, 0, 2, req = {1410025}},
    {404521, "Rampant Growth", 10, 0, 2, req = {1410129}},
    {393954, "Rattle the Stars", 35, 0, 2, req = {1410472}},
    {1249802, "Razor Wire", 11, 0, 2, req = {1410033}},
    {462454, "Reactive Warding", 12, 0, 2, req = {1410214}},
    {1272326, "Realized Potential", 10, 0, 2, req = {1410077}},
    {393618, "Reinforced Fur", 12, 0, 2, req = {1410167}},
    {1243660, "Resonant Voice", 10, 0, 2, req = {1410049, 1410098, 1410116}},
    {373003, "Revel in Darkness", 10, 0, 2, req = {1410025}},
    {1247743, "Rimecaster", 10, 0, 3, req = {1410005}},
    {1277651, "Rising Sunlight", 35, 0, 2, req = {1410217}},
    {387103, "Ruin", 10, 0, 3, req = {1410568}},
    {384820, "Sacrifice of the Just", 41, 0, 2, req = {1410119}},
    {386986, "Sacrolash's Dark Strike", 10, 0, 3, req = {1410013}},
    {449637, "Sataiel's Volition", 10, 0, 2, req = {1410013}},
    {378807, "Shadowrunner", 10, 0, 2, req = {1410066}},
    {383341, "Sharpened Blades", 10, 0, 3, req = {1410101}},
    {1267218, "Shell Wall", 20, 0, 2, req = {1410452}},
    {1261562, "Shield of Vengeance", 26, 0, 2, req = {1410020}},
    {457063, "Shroud of Night", 35, 0, 2, req = {1410323}},
    {385478, "Shrouded Suffocation", 11, 0, 2, req = {1410033}},
    {470021, "Signature Spell", 10, 0, 2, req = {1410005}},
    {452999, "Siphon Life", 10, 0, 2, req = {1410013}},
    {378310, "Skybreaker's Fiery Demise", 10, 0, 2, req = {1410735}},
    {444779, "Slayer's Malice", 10, 0, 2, req = {1410101}},
    {204909, "Soul Rending", 35, 0, 3, req = {1410473}},
    {370845, "Spellweaver's Dominance", 10, 0, 2, req = {1410694}},
    {1264899, "Spirit of the Thicket", 35, 0, 2, req = {1410472}},
    {56377, "Splitting Ice", 10, 0, 2, req = {1410005}},
    {469317, "Stand Against Evil", 10, 0, 2, req = {1410130}},
    {451211, "Starlight Conduit", 10, 0, 2, req = {1410095}},
    {423662, "Stillshroud", 35, 0, 2, req = {1410323}},
    {462695, "Storm Frenzy", 12, 0, 2, req = {1410460}},
    {1262761, "Storm Unleashed", 12, 0, 3, req = {1410460}},
    {382953, "Storm of Steel", 35, 0, 2, req = {1410555}},
    {388903, "Storm of Swords", 10, 0, 2, req = {1410056, 1410060}},
    {454021, "Stormcaller", 10, 0, 2, req = {1410210, 1410460, 1410735}},
    {439890, "Strategic Infusion", 10, 0, 2, req = {1410037, 1410129, 1410305}},
    {400803, "Strength of Arms", 10, 0, 3, req = {1410056}},
    {317138, "Strength of Will", 16, 0, 2, req = {1410309}},
    {437068, "Strength of the Mountain", 10, 0, 2, req = {1410169}},
    {423136, "Sudden Demise", 11, 0, 2, req = {1410033}},
    {453105, "Summoner's Embrace", 10, 0, 2, req = {1410568}},
    {423701, "Superior Mixture", 10, 0, 2, req = {1410091}},
    {203965, "Survival of the Fittest", 12, 0, 3, req = {1410167}},
    {381707, "Swelling Maelstrom", 20, 0, 2, req = {1410259}},
    {452902, "Swift Artifice", 10, 0, 2, req = {1410113, 1410161}},
    {383459, "Swift Strikes", 14, 0, 3, req = {1410280}},
    {1273129, "Take Aim", 10, 0, 3, req = {1410225, 1410422, 1410476, 1410580}},
    {1258899, "Tectonic Collapse", 20, 0, 2, req = {1410259}},
    {442743, "Temple Training", 10, 0, 2, req = {1410340}},
    {1217622, "Therazane's Resilience", 12, 0, 2, req = {1410214}},
    {447131, "Thriving Vegetation", 10, 0, 3, req = {1410129}},
    {381629, "Thrown Precision", 19, 0, 2, req = {1410213}},
    {1262635, "Thunder Capacitor", 12, 0, 2, req = {1410460}},
    {378779, "Thundershock", 30, 0, 2, req = {1410210}},
    {264348, "Tiger Tail Sweep", 12, 0, 3, req = {1410347}},
    {387807, "Time Manipulation", 10, 0, 2, req = {1410007, 1410008}},
    {414720, "Tirion's Devotion", 12, 0, 2, req = {1410026}},
    {1251077, "Twin Disciplines", 10, 0, 2, req = {1410000, 1410023, 1410025, 1410077}},
    {382896, "Two-Handed Weapon Specialization", 10, 0, 3, req = {1410056, 1410062, 1410169, 1410188, 1410227}},
    {383195, "Umbral Intensity", 10, 0, 3, req = {1410095}},
    {305394, "Unbound Freedom", 10, 0, 2, req = {1410045}},
    {114154, "Unbreakable Spirit", 12, 0, 2, req = {1410020, 1410026, 1410027, 1410239}},
    {389682, "Unholy Endurance", 20, 0, 2, req = {1410206}},
    {432990, "Unrelenting Charger", 14, 0, 2, req = {1410470}},
    {444780, "Unrelenting Onslaught", 35, 0, 2, req = {1410555}},
    {373456, "Unwavering Will", 10, 0, 3, req = {1410023, 1410077}},
    {457574, "Unyielding Will", 14, 0, 2, req = {1410204}},
    {393611, "Ursoc's Endurance", 12, 0, 2, req = {1410167}},
    {378425, "Uther's Counsel", 12, 0, 2, req = {1410026, 1410027}},
    {434028, "Vampiric Speed", 10, 0, 2, req = {1410203}},
    {382017, "Veiltouched", 10, 0, 2, req = {1410086}},
    {301768, "Verdant Heart", 12, 0, 2, req = {1410167}},
    {381543, "Virulent Poisons", 10, 0, 2, req = {1410086}},
    {1299572, "Vital Expenditure", 10, 0, 2, req = {1410531}},
    {471306, "Void Metamorphosis", 20, 0, 2, req = {1410442}},
    {454919, "Voltaic Surge", 12, 0, 2, req = {1410259, 1410460}},
    {204268, "Voodoo Mastery", 10, 0, 2, req = {1410211}},
    {1250923, "Ward of the Forest", 12, 0, 2, req = {1410167}},
    {440681, "Waste No Time", 10, 0, 2, req = {1410000}},
    {1243155, "Way of the Serpent", 10, 0, 2, req = {1410331, 1410340}},
    {388846, "Widening Whirl", 10, 0, 2, req = {1410303}},
    {406890, "Wild Surges", 10, 0, 2, req = {1410095}},
    {1254828, "Wildfire", 10, 0, 3, req = {1410626}},
    {439926, "Wildstalker's Power", 10, 0, 2, req = {1410037}},
    {1270447, "Windspeaker", 10, 0, 2, req = {1410046, 1410123}},
    {1272352, "Words of the Wise", 10, 0, 2, req = {1410077}},
    {460720, "Wrench Evil", 10, 0, 2, req = {1410130}},
    {440040, "Xalan's Cruelty", 10, 0, 2, req = {1410013, 1410568}},
}
-- END TALENTS

-- BEGIN SPELL_ROLE (generated by pool_build.py)
local SPELL_ROLE = {[1265330]="u", [1275804]="u", [1281377]="u", [1284739]="u", [1288878]="u", [1290743]="u", [1291158]="u", [1293513]="u", [1293959]="u", [1294137]="u", [1294539]="u", [1294902]="u", [1295994]="u", [1297065]="u", [1297778]="u", [1298401]="u", [1299310]="u", [1301764]="u", [1301851]="u", [1302646]="u", [1302769]="u", [1303542]="u", [1304372]="u", [1305761]="u", [1305764]="u", [1305766]="u", [1306516]="u", [1307485]="u", [1308655]="u", [1405001]="u", [1405002]="u", [1406001]="u", [1406002]="u", [1406003]="u", [1406004]="u", [1406005]="u", [1406006]="u", [1406007]="u", [1406008]="u", [1406009]="u", [1406010]="u", [1406011]="u", [1406012]="u", [1406013]="u", [1406014]="u", [1406015]="u", [1406016]="u", [1406017]="u", [1406018]="u", [1406019]="u", [1406020]="u", [1406021]="u", [1406022]="u", [1406023]="u", [1406024]="u", [1406025]="u", [1406026]="u", [1406027]="u", [1406028]="u", [1406029]="u", [1406030]="u", [1406031]="u", [1406032]="u", [1406033]="u", [1406040]="u", [1406041]="u", [1406042]="u", [1406043]="u", [1406044]="u", [1406045]="u", [1406046]="u", [1406047]="u", [1406048]="u", [1410000]="d", [1410001]="o", [1410002]="u", [1410003]="d", [1410004]="m", [1410005]="o", [1410006]="c", [1410007]="o", [1410008]="o", [1410009]="u", [1410010]="u", [1410011]="o", [1410012]="h", [1410013]="o", [1410014]="o", [1410015]="o", [1410016]="m", [1410017]="c", [1410018]="u", [1410019]="d", [1410020]="d", [1410021]="c", [1410022]="u", [1410023]="o", [1410024]="d", [1410025]="o", [1410026]="h", [1410027]="h", [1410028]="o", [1410029]="u", [1410030]="u", [1410031]="u", [1410032]="u", [1410033]="o", [1410034]="c", [1410035]="h", [1410036]="u", [1410037]="h", [1410038]="u", [1410039]="m", [1410040]="o", [1410041]="u", [1410042]="u", [1410043]="u", [1410044]="m", [1410045]="m", [1410046]="h", [1410047]="c", [1410048]="u", [1410049]="u", [1410051]="o", [1410052]="o", [1410053]="b", [1410054]="u", [1410055]="u", [1410056]="o", [1410057]="o", [1410058]="u", [1410059]="u", [1410060]="o", [1410062]="o", [1410063]="u", [1410064]="o", [1410065]="c", [1410066]="m", [1410067]="u", [1410068]="c", [1410069]="m", [1410070]="u", [1410071]="u", [1410072]="o", [1410073]="m", [1410074]="d", [1410075]="u", [1410076]="u", [1410077]="h", [1410078]="c", [1410079]="u", [1410080]="o", [1410081]="c", [1410082]="u", [1410083]="u", [1410084]="u", [1410085]="m", [1410086]="o", [1410087]="u", [1410088]="u", [1410089]="m", [1410090]="d", [1410091]="u", [1410093]="u", [1410094]="c", [1410095]="o", [1410096]="o", [1410097]="u", [1410098]="c", [1410099]="d", [1410100]="u", [1410101]="o", [1410102]="u", [1410103]="d", [1410105]="d", [1410106]="u", [1410107]="u", [1410108]="u", [1410110]="o", [1410111]="u", [1410112]="u", [1410113]="u", [1410114]="m", [1410115]="c", [1410116]="b", [1410117]="c", [1410118]="u", [1410119]="m", [1410120]="h", [1410121]="u", [1410122]="d", [1410123]="h", [1410124]="c", [1410125]="u", [1410126]="o", [1410127]="o", [1410128]="u", [1410129]="h", [1410130]="c", [1410131]="o", [1410132]="u", [1410133]="u", [1410135]="u", [1410136]="u", [1410137]="o", [1410138]="c", [1410139]="u", [1410140]="u", [1410141]="u", [1410142]="d", [1410143]="h", [1410144]="h", [1410145]="o", [1410146]="o", [1410147]="o", [1410148]="o", [1410149]="o", [1410150]="u", [1410151]="o", [1410152]="m", [1410153]="u", [1410154]="u", [1410155]="c", [1410156]="b", [1410158]="u", [1410159]="c", [1410160]="u", [1410161]="u", [1410162]="u", [1410163]="u", [1410164]="d", [1410165]="d", [1410166]="o", [1410167]="m", [1410168]="d", [1410169]="o", [1410170]="m", [1410171]="o", [1410172]="d", [1410173]="u", [1410174]="u", [1410175]="c", [1410176]="h", [1410177]="o", [1410178]="u", [1410179]="o", [1410180]="m", [1410181]="d", [1410182]="m", [1410183]="o", [1410184]="u", [1410185]="o", [1410186]="u", [1410187]="o", [1410188]="o", [1410189]="o", [1410190]="o", [1410191]="m", [1410192]="u", [1410193]="o", [1410194]="u", [1410195]="u", [1410196]="h", [1410197]="o", [1410198]="u", [1410199]="u", [1410202]="m", [1410203]="m", [1410204]="d", [1410205]="d", [1410206]="u", [1410207]="u", [1410208]="u", [1410209]="u", [1410210]="o", [1410211]="c", [1410212]="u", [1410213]="o", [1410214]="b", [1410215]="o", [1410216]="u", [1410217]="h", [1410218]="o", [1410219]="u", [1410220]="o", [1410221]="o", [1410222]="u", [1410223]="u", [1410224]="u", [1410225]="o", [1410226]="u", [1410227]="o", [1410228]="d", [1410229]="c", [1410230]="m", [1410231]="u", [1410232]="u", [1410233]="d", [1410234]="u", [1410235]="u", [1410236]="u", [1410237]="u", [1410238]="u", [1410239]="h", [1410240]="m", [1410241]="o", [1410242]="m", [1410243]="u", [1410244]="o", [1410252]="c", [1410258]="h", [1410259]="o", [1410261]="h", [1410267]="u", [1410268]="u", [1410269]="u", [1410270]="u", [1410271]="u", [1410272]="u", [1410273]="u", [1410274]="h", [1410275]="u", [1410276]="u", [1410277]="u", [1410278]="u", [1410280]="o", [1410281]="h", [1410282]="o", [1410283]="b", [1410284]="b", [1410285]="b", [1410286]="b", [1410287]="o", [1410288]="u", [1410289]="h", [1410290]="o", [1410292]="c", [1410293]="b", [1410294]="b", [1410295]="u", [1410296]="u", [1410297]="h", [1410298]="u", [1410299]="o", [1410300]="o", [1410301]="u", [1410302]="m", [1410303]="o", [1410304]="u", [1410305]="h", [1410306]="m", [1410307]="u", [1410308]="u", [1410309]="d", [1410310]="d", [1410311]="o", [1410312]="m", [1410313]="c", [1410314]="u", [1410315]="d", [1410316]="d", [1410318]="h", [1410319]="m", [1410320]="u", [1410321]="o", [1410322]="o", [1410323]="m", [1410324]="o", [1410325]="u", [1410326]="u", [1410327]="u", [1410328]="h", [1410329]="d", [1410331]="u", [1410332]="u", [1410333]="o", [1410334]="c", [1410335]="u", [1410337]="u", [1410338]="u", [1410339]="u", [1410340]="h", [1410341]="h", [1410342]="o", [1410343]="c", [1410346]="o", [1410347]="c", [1410348]="u", [1410350]="u", [1410351]="u", [1410352]="u", [1410353]="d", [1410354]="d", [1410355]="u", [1410356]="u", [1410357]="h", [1410358]="m", [1410360]="u", [1410361]="u", [1410362]="c", [1410364]="u", [1410366]="h", [1410413]="h", [1410414]="u", [1410416]="o", [1410417]="m", [1410418]="u", [1410419]="u", [1410420]="u", [1410421]="c", [1410422]="o", [1410429]="o", [1410430]="o", [1410431]="m", [1410432]="m", [1410434]="u", [1410436]="u", [1410437]="u", [1410438]="b", [1410439]="c", [1410441]="u", [1410442]="o", [1410444]="u", [1410445]="h", [1410446]="h", [1410447]="o", [1410448]="o", [1410449]="o", [1410450]="o", [1410451]="m", [1410452]="d", [1410453]="u", [1410454]="u", [1410455]="u", [1410456]="o", [1410457]="c", [1410458]="u", [1410459]="o", [1410460]="o", [1410461]="o", [1410462]="u", [1410463]="m", [1410464]="u", [1410466]="m", [1410468]="o", [1410469]="o", [1410470]="u", [1410471]="m", [1410472]="u", [1410473]="m", [1410474]="m", [1410475]="o", [1410476]="o", [1410478]="o", [1410482]="o", [1410483]="m", [1410484]="u", [1410485]="m", [1410486]="u", [1410487]="u", [1410488]="o", [1410489]="o", [1410490]="m", [1410491]="u", [1410492]="u", [1410493]="u", [1410495]="o", [1410496]="u", [1410497]="m", [1410498]="o", [1410499]="u", [1410500]="u", [1410501]="h", [1410502]="u", [1410503]="u", [1410504]="u", [1410505]="u", [1410506]="o", [1410507]="d", [1410508]="o", [1410509]="u", [1410512]="u", [1410513]="o", [1410514]="u", [1410517]="o", [1410518]="o", [1410520]="u", [1410521]="o", [1410522]="u", [1410523]="u", [1410525]="o", [1410526]="h", [1410527]="o", [1410528]="h", [1410529]="u", [1410530]="o", [1410531]="h", [1410532]="o", [1410533]="c", [1410534]="u", [1410535]="m", [1410536]="u", [1410537]="u", [1410538]="u", [1410539]="u", [1410540]="u", [1410541]="u", [1410542]="u", [1410543]="u", [1410544]="u", [1410545]="u", [1410549]="m", [1410550]="o", [1410551]="o", [1410552]="u", [1410554]="o", [1410555]="o", [1410556]="u", [1410557]="u", [1410558]="o", [1410560]="u", [1410561]="u", [1410562]="u", [1410563]="u", [1410564]="u", [1410565]="u", [1410566]="m", [1410567]="u", [1410568]="o", [1410569]="u", [1410571]="d", [1410572]="u", [1410573]="m", [1410574]="u", [1410575]="o", [1410576]="m", [1410577]="u", [1410578]="u", [1410580]="o", [1410581]="m", [1410582]="o", [1410583]="o", [1410584]="u", [1410586]="o", [1410587]="c", [1410591]="u", [1410592]="u", [1410593]="u", [1410594]="u", [1410596]="u", [1410597]="o", [1410598]="h", [1410601]="u", [1410602]="u", [1410604]="u", [1410605]="o", [1410606]="o", [1410607]="o", [1410608]="m", [1410609]="d", [1410610]="o", [1410611]="o", [1410612]="o", [1410614]="u", [1410615]="m", [1410616]="o", [1410617]="o", [1410618]="h", [1410619]="o", [1410620]="o", [1410621]="u", [1410622]="o", [1410624]="o", [1410625]="o", [1410626]="o", [1410627]="o", [1410628]="b", [1410629]="u", [1410630]="h", [1410631]="u", [1410632]="u", [1410633]="u", [1410634]="h", [1410635]="o", [1410636]="u", [1410637]="o", [1410638]="o", [1410639]="u", [1410640]="u", [1410641]="u", [1410642]="m", [1410643]="o", [1410644]="u", [1410645]="m", [1410646]="o", [1410647]="u", [1410648]="m", [1410649]="u", [1410650]="u", [1410652]="u", [1410653]="o", [1410655]="u", [1410656]="u", [1410657]="u", [1410658]="u", [1410659]="h", [1410660]="u", [1410661]="o", [1410662]="o", [1410663]="u", [1410664]="d", [1410665]="u", [1410666]="u", [1410670]="u", [1410671]="o", [1410672]="o", [1410674]="u", [1410676]="d", [1410677]="o", [1410678]="u", [1410682]="o", [1410683]="u", [1410684]="d", [1410685]="u", [1410686]="m", [1410688]="c", [1410689]="u", [1410690]="u", [1410691]="u", [1410692]="u", [1410694]="o", [1410697]="d", [1410698]="u", [1410699]="u", [1410700]="u", [1410701]="u", [1410702]="b", [1410703]="u", [1410704]="u", [1410705]="u", [1410706]="u", [1410707]="u", [1410708]="u", [1410710]="u", [1410711]="u", [1410713]="u", [1410714]="u", [1410715]="u", [1410716]="u", [1410717]="u", [1410718]="u", [1410719]="u", [1410720]="u", [1410726]="u", [1410728]="u", [1410731]="u", [1410732]="u", [1410733]="u", [1410734]="u", [1410735]="o", [1410736]="o", [1410061]="u", [1410092]="m", [1410109]="u", [1410157]="u", [1410200]="u", [1410201]="u", [1410279]="u", [1410317]="m", [1410330]="u", [1410349]="u", [1410363]="u", [1410367]="u", [1410412]="u", [1410435]="u", [1410465]="u", [1410479]="u", [1410480]="m", [1410481]="u", [1410510]="u", [1410524]="u", [1410553]="u", [1410559]="u", [1410570]="u", [1410579]="u", [1410590]="u", [1410595]="u", [1410599]="u", [1410600]="u", [1410603]="u", [1410613]="u", [1410623]="u", [1410654]="u", [1410667]="u", [1410668]="u", [1410687]="u", [1410727]="u", [1410729]="u", [1410730]="u",[1405001]="u",[1405002]="m",[1405003]="u",[1406001]="u",[1406002]="o",[1406003]="o",[1406004]="o",[1406005]="o",[1406006]="o",[1406007]="o",[1406008]="u",[1406009]="u",[1406010]="o",[1406011]="u",[1406012]="o",[1406013]="o",[1406014]="u",[1406015]="o",[1406016]="o",[1406017]="o",[1406018]="o",[1406019]="u",[1406020]="o",[1406021]="u",[1406022]="u",[1406023]="u",[1406024]="h",[1406025]="u",[1406026]="u",[1406027]="u",[1406028]="m",[1406029]="u",[1406030]="d",[1406031]="d",[1406032]="d",[1406033]="o",[1406040]="u",[1406041]="u",[1406042]="u",[1406043]="u",[1406044]="u",[1406045]="u",[1406046]="u",[1406047]="u",[1406048]="d",[1407001]="o",[1407002]="o",[1407003]="o",[1407004]="o",[1407005]="m",[1407006]="d",[1407007]="u",[1407008]="d",[1407009]="u",[1407010]="o",[1407011]="m",[1407012]="o",[1407013]="o",[1407014]="u",[1407015]="m",[1407016]="d",[1407017]="o",[1407018]="o",[1407019]="o",[1407020]="u",[1407021]="u",[1407022]="h",[1407023]="u",[1407024]="o",[1407025]="o",[1407026]="d",[1407027]="u",[1407028]="o",[1407029]="d",[1408001]="o",[1408002]="o",[1408003]="o",[1408004]="o",[1408005]="o",[1408006]="o",[1408007]="o",[1408008]="o",[1408009]="o",[1408010]="o",[1408011]="h",[1408012]="d",[1408013]="h"}
-- END SPELL_ROLE

-- BEGIN SPELL_CLASS (generated by pool_build.py)
local SPELL_CLASS = {[1265330]=0, [1275804]=0, [1281377]=0, [1284739]=0, [1288878]=0, [1290743]=0, [1291158]=0, [1293513]=0, [1293959]=0, [1294137]=0, [1294539]=0, [1294902]=0, [1295994]=0, [1297065]=0, [1297778]=0, [1298401]=0, [1299310]=0, [1301764]=0, [1301851]=0, [1302646]=0, [1302769]=0, [1303542]=0, [1304372]=0, [1305761]=0, [1305764]=0, [1305766]=0, [1306516]=0, [1307485]=0, [1308655]=0, [1405001]=0, [1405002]=0, [1406001]=0, [1406002]=0, [1406003]=0, [1406004]=0, [1406005]=0, [1406006]=0, [1406007]=0, [1406008]=0, [1406009]=0, [1406010]=0, [1406011]=0, [1406012]=0, [1406013]=0, [1406014]=0, [1406015]=0, [1406016]=0, [1406017]=0, [1406018]=0, [1406019]=0, [1406020]=0, [1406021]=0, [1406022]=0, [1406023]=0, [1406024]=0, [1406025]=0, [1406026]=0, [1406027]=0, [1406028]=0, [1406029]=0, [1406030]=0, [1406031]=0, [1406032]=0, [1406033]=0, [1406040]=0, [1406041]=0, [1406042]=0, [1406043]=0, [1406044]=0, [1406045]=0, [1406046]=0, [1406047]=0, [1406048]=0, [1410000]=5, [1410001]=4, [1410002]=8, [1410003]=1, [1410004]=1, [1410005]=8, [1410006]=8, [1410007]=8, [1410008]=8, [1410009]=9, [1410010]=8, [1410011]=8, [1410012]=3, [1410013]=9, [1410014]=11, [1410015]=9, [1410016]=1, [1410017]=4, [1410018]=5, [1410019]=2, [1410020]=2, [1410021]=5, [1410022]=7, [1410023]=5, [1410024]=0, [1410025]=5, [1410026]=2, [1410027]=2, [1410028]=9, [1410029]=9, [1410030]=9, [1410031]=9, [1410032]=9, [1410033]=4, [1410034]=0, [1410035]=0, [1410036]=11, [1410037]=0, [1410038]=3, [1410039]=11, [1410040]=2, [1410041]=3, [1410042]=4, [1410043]=3, [1410044]=2, [1410045]=2, [1410046]=0, [1410047]=9, [1410048]=11, [1410049]=1, [1410051]=4, [1410052]=8, [1410053]=8, [1410054]=3, [1410055]=0, [1410056]=1, [1410057]=3, [1410058]=3, [1410059]=3, [1410060]=1, [1410062]=1, [1410063]=4, [1410064]=4, [1410065]=4, [1410066]=4, [1410067]=4, [1410068]=4, [1410069]=11, [1410070]=4, [1410071]=4, [1410072]=4, [1410073]=8, [1410074]=4, [1410075]=5, [1410076]=7, [1410077]=5, [1410078]=4, [1410079]=5, [1410080]=4, [1410081]=8, [1410082]=7, [1410083]=1, [1410084]=3, [1410085]=7, [1410086]=0, [1410087]=7, [1410088]=4, [1410089]=4, [1410090]=1, [1410091]=4, [1410093]=6, [1410094]=2, [1410095]=11, [1410096]=11, [1410097]=11, [1410098]=0, [1410099]=4, [1410100]=1, [1410101]=1, [1410102]=3, [1410103]=11, [1410105]=11, [1410106]=2, [1410107]=9, [1410108]=4, [1410110]=4, [1410111]=7, [1410112]=3, [1410113]=9, [1410114]=0, [1410115]=1, [1410116]=1, [1410117]=4, [1410118]=11, [1410119]=2, [1410120]=3, [1410121]=2, [1410122]=0, [1410123]=7, [1410124]=0, [1410125]=10, [1410126]=4, [1410127]=4, [1410128]=11, [1410129]=11, [1410130]=2, [1410131]=7, [1410132]=0, [1410133]=0, [1410135]=4, [1410136]=5, [1410137]=5, [1410138]=5, [1410139]=11, [1410140]=11, [1410141]=11, [1410142]=1, [1410143]=0, [1410144]=2, [1410145]=3, [1410146]=3, [1410147]=3, [1410148]=3, [1410149]=3, [1410150]=3, [1410151]=1, [1410152]=2, [1410153]=0, [1410154]=11, [1410155]=0, [1410156]=0, [1410158]=0, [1410159]=0, [1410160]=7, [1410161]=9, [1410162]=5, [1410163]=11, [1410164]=11, [1410165]=5, [1410166]=11, [1410167]=11, [1410168]=0, [1410169]=1, [1410170]=2, [1410171]=7, [1410172]=2, [1410173]=0, [1410174]=2, [1410175]=0, [1410176]=0, [1410177]=9, [1410178]=0, [1410179]=8, [1410180]=4, [1410181]=4, [1410182]=2, [1410183]=7, [1410184]=7, [1410185]=4, [1410186]=5, [1410187]=11, [1410188]=1, [1410189]=5, [1410190]=2, [1410191]=0, [1410192]=11, [1410193]=8, [1410194]=8, [1410195]=5, [1410196]=0, [1410197]=6, [1410198]=6, [1410199]=1, [1410202]=5, [1410203]=6, [1410204]=6, [1410205]=0, [1410206]=6, [1410207]=6, [1410208]=11, [1410209]=6, [1410210]=7, [1410211]=0, [1410212]=4, [1410213]=4, [1410214]=7, [1410215]=6, [1410216]=3, [1410217]=2, [1410218]=2, [1410219]=2, [1410220]=6, [1410221]=6, [1410222]=0, [1410223]=6, [1410224]=8, [1410225]=3, [1410226]=4, [1410227]=1, [1410228]=4, [1410229]=0, [1410230]=0, [1410231]=0, [1410232]=6, [1410233]=0, [1410234]=11, [1410235]=3, [1410236]=6, [1410237]=2, [1410238]=5, [1410239]=2, [1410240]=0, [1410241]=0, [1410242]=0, [1410243]=0, [1410244]=7, [1410252]=7, [1410258]=7, [1410259]=7, [1410261]=5, [1410267]=7, [1410268]=4, [1410269]=8, [1410270]=1, [1410271]=6, [1410272]=6, [1410273]=6, [1410274]=2, [1410275]=3, [1410276]=3, [1410277]=3, [1410278]=3, [1410280]=0, [1410281]=2, [1410282]=6, [1410283]=9, [1410284]=4, [1410285]=7, [1410286]=1, [1410287]=4, [1410288]=7, [1410289]=2, [1410290]=2, [1410292]=11, [1410293]=8, [1410294]=5, [1410295]=3, [1410296]=9, [1410297]=2, [1410298]=0, [1410299]=10, [1410300]=10, [1410301]=9, [1410302]=10, [1410303]=10, [1410304]=0, [1410305]=11, [1410306]=0, [1410307]=11, [1410308]=11, [1410309]=9, [1410310]=2, [1410311]=11, [1410312]=0, [1410313]=0, [1410314]=10, [1410315]=0, [1410316]=9, [1410318]=3, [1410319]=0, [1410320]=0, [1410321]=1, [1410322]=4, [1410323]=4, [1410324]=7, [1410325]=0, [1410326]=0, [1410327]=11, [1410328]=7, [1410329]=10, [1410331]=10, [1410332]=10, [1410333]=7, [1410334]=10, [1410335]=10, [1410337]=2, [1410338]=10, [1410339]=10, [1410340]=10, [1410341]=1, [1410342]=10, [1410343]=3, [1410346]=10, [1410347]=10, [1410348]=10, [1410350]=8, [1410351]=10, [1410352]=2, [1410353]=10, [1410354]=1, [1410355]=0, [1410356]=3, [1410357]=10, [1410358]=10, [1410360]=10, [1410361]=6, [1410362]=11, [1410364]=10, [1410366]=12, [1410413]=11, [1410414]=0, [1410416]=1, [1410417]=10, [1410418]=4, [1410419]=6, [1410420]=5, [1410421]=2, [1410422]=3, [1410429]=12, [1410430]=11, [1410431]=11, [1410432]=11, [1410434]=10, [1410436]=6, [1410437]=12, [1410438]=2, [1410439]=12, [1410441]=1, [1410442]=12, [1410444]=12, [1410445]=4, [1410446]=4, [1410447]=3, [1410448]=4, [1410449]=4, [1410450]=4, [1410451]=3, [1410452]=3, [1410453]=3, [1410454]=5, [1410455]=12, [1410456]=9, [1410457]=3, [1410458]=7, [1410459]=7, [1410460]=0, [1410461]=12, [1410462]=12, [1410463]=12, [1410464]=12, [1410466]=8, [1410468]=6, [1410469]=6, [1410470]=2, [1410471]=3, [1410472]=11, [1410473]=12, [1410474]=0, [1410475]=7, [1410476]=3, [1410478]=8, [1410482]=6, [1410483]=4, [1410484]=3, [1410485]=12, [1410486]=9, [1410487]=0, [1410488]=6, [1410489]=4, [1410490]=7, [1410491]=4, [1410492]=6, [1410493]=11, [1410495]=4, [1410496]=11, [1410497]=12, [1410498]=0, [1410499]=4, [1410500]=2, [1410501]=5, [1410502]=12, [1410503]=7, [1410504]=12, [1410505]=10, [1410506]=3, [1410507]=12, [1410508]=1, [1410509]=12, [1410512]=12, [1410513]=3, [1410514]=12, [1410517]=6, [1410518]=2, [1410520]=7, [1410521]=1, [1410522]=12, [1410523]=3, [1410525]=12, [1410526]=7, [1410527]=5, [1410528]=5, [1410529]=11, [1410530]=2, [1410531]=10, [1410532]=1, [1410533]=3, [1410534]=3, [1410535]=11, [1410536]=8, [1410537]=11, [1410538]=8, [1410539]=9, [1410540]=5, [1410541]=11, [1410542]=7, [1410543]=10, [1410544]=2, [1410545]=4, [1410549]=0, [1410550]=9, [1410551]=1, [1410552]=10, [1410554]=6, [1410555]=0, [1410556]=5, [1410557]=5, [1410558]=12, [1410560]=3, [1410561]=11, [1410562]=11, [1410563]=11, [1410564]=10, [1410565]=2, [1410566]=4, [1410567]=5, [1410568]=9, [1410569]=11, [1410571]=10, [1410572]=9, [1410573]=0, [1410574]=12, [1410575]=0, [1410576]=0, [1410577]=0, [1410578]=3, [1410580]=3, [1410581]=12, [1410582]=3, [1410583]=0, [1410584]=1, [1410586]=12, [1410587]=0, [1410591]=0, [1410592]=11, [1410593]=6, [1410594]=1, [1410596]=5, [1410597]=0, [1410598]=0, [1410601]=11, [1410602]=11, [1410604]=0, [1410605]=0, [1410606]=0, [1410607]=0, [1410608]=0, [1410609]=0, [1410610]=0, [1410611]=0, [1410612]=0, [1410614]=0, [1410615]=0, [1410616]=4, [1410617]=0, [1410618]=4, [1410619]=4, [1410620]=6, [1410621]=0, [1410622]=0, [1410624]=0, [1410625]=4, [1410626]=8, [1410627]=0, [1410628]=12, [1410629]=12, [1410630]=7, [1410631]=12, [1410632]=3, [1410633]=0, [1410634]=10, [1410635]=10, [1410636]=0, [1410637]=0, [1410638]=0, [1410639]=0, [1410640]=10, [1410641]=0, [1410642]=0, [1410643]=0, [1410644]=0, [1410645]=0, [1410646]=0, [1410647]=0, [1410648]=0, [1410649]=3, [1410650]=0, [1410652]=6, [1410653]=0, [1410655]=0, [1410656]=0, [1410657]=0, [1410658]=0, [1410659]=7, [1410660]=0, [1410661]=0, [1410662]=0, [1410663]=0, [1410664]=0, [1410665]=9, [1410666]=0, [1410670]=10, [1410671]=3, [1410672]=12, [1410674]=12, [1410676]=2, [1410677]=3, [1410678]=13, [1410682]=13, [1410683]=13, [1410684]=13, [1410685]=0, [1410686]=13, [1410688]=13, [1410689]=13, [1410690]=13, [1410691]=13, [1410692]=13, [1410694]=13, [1410697]=0, [1410698]=13, [1410699]=13, [1410700]=9, [1410701]=13, [1410702]=6, [1410703]=2, [1410704]=7, [1410705]=13, [1410706]=10, [1410707]=13, [1410708]=2, [1410710]=13, [1410711]=13, [1410713]=13, [1410714]=5, [1410715]=1, [1410716]=13, [1410717]=2, [1410718]=2, [1410719]=11, [1410720]=13, [1410726]=0, [1410728]=10, [1410731]=11, [1410732]=7, [1410733]=3, [1410734]=11, [1410735]=7, [1410736]=12, [1410061]=5, [1410092]=0, [1410109]=9, [1410157]=0, [1410200]=5, [1410201]=6, [1410279]=2, [1410317]=10, [1410330]=0, [1410349]=9, [1410363]=3, [1410367]=8, [1410412]=3, [1410435]=3, [1410465]=8, [1410479]=6, [1410480]=12, [1410481]=8, [1410510]=12, [1410524]=6, [1410553]=9, [1410559]=11, [1410570]=3, [1410579]=0, [1410590]=3, [1410595]=4, [1410599]=1, [1410600]=1, [1410603]=0, [1410613]=0, [1410623]=6, [1410654]=0, [1410667]=8, [1410668]=8, [1410687]=0, [1410727]=5, [1410729]=7, [1410730]=2,[1408001]=0,[1408002]=0,[1408003]=0,[1408004]=0,[1408005]=0,[1408006]=0,[1408007]=0,[1408008]=0,[1408009]=0,[1408010]=0,[1408011]=0,[1408012]=0,[1408013]=0}
-- END SPELL_CLASS
-- BEGIN PROXY_MAPS (proxy_spells.py)
for id, c in pairs({[1470000]=1, [1470001]=1, [1470002]=1, [1470003]=1, [1470004]=1, [1470005]=1, [1470006]=1, [1470007]=1, [1470008]=1, [1470009]=1, [1470010]=1, [1470011]=1, [1470012]=1, [1470013]=1, [1470014]=1, [1470015]=1, [1470016]=1, [1470017]=1, [1470018]=1, [1470019]=1, [1470020]=1, [1470021]=1, [1470022]=1, [1470023]=1, [1470024]=1, [1470025]=1, [1470026]=1, [1470027]=1, [1470028]=1, [1470029]=1, [1470030]=1, [1470031]=1, [1470032]=1, [1470033]=1, [1470034]=1, [1470035]=1, [1470036]=1, [1470037]=1, [1470038]=1, [1470039]=1, [1470040]=2, [1470041]=2, [1470042]=2, [1470043]=2, [1470044]=2, [1470045]=2, [1470046]=2, [1470047]=2, [1470048]=2, [1470049]=2, [1470050]=2, [1470051]=2, [1470052]=2, [1470053]=2, [1470054]=2, [1470055]=2, [1470056]=2, [1470057]=2, [1470058]=2, [1470059]=2, [1470060]=2, [1470061]=2, [1470062]=2, [1470063]=2, [1470064]=2, [1470065]=2, [1470066]=2, [1470067]=2, [1470068]=2, [1470069]=2, [1470070]=2, [1470071]=2, [1470072]=3, [1470073]=3, [1470074]=3, [1470075]=3, [1470076]=3, [1470077]=3, [1470078]=3, [1470079]=3, [1470080]=3, [1470081]=3, [1470082]=3, [1470083]=3, [1470084]=3, [1470085]=3, [1470086]=3, [1470087]=3, [1470088]=3, [1470089]=3, [1470090]=3, [1470091]=3, [1470092]=3, [1470093]=3, [1470094]=3, [1470095]=3, [1470096]=3, [1470097]=3, [1470098]=3, [1470099]=3, [1470100]=3, [1470101]=3, [1470102]=3, [1470103]=3, [1470104]=3, [1470105]=3, [1470106]=3, [1470107]=3, [1470108]=3, [1470109]=3, [1470110]=3, [1470111]=3, [1470112]=3, [1470113]=4, [1470114]=4, [1470115]=4, [1470116]=4, [1470117]=4, [1470118]=4, [1470119]=4, [1470120]=4, [1470121]=4, [1470122]=4, [1470123]=4, [1470124]=4, [1470125]=4, [1470126]=4, [1470127]=4, [1470128]=4, [1470129]=4, [1470130]=4, [1470131]=4, [1470132]=5, [1470133]=5, [1470134]=5, [1470135]=5, [1470136]=5, [1470137]=5, [1470138]=5, [1470139]=5, [1470140]=5, [1470141]=5, [1470142]=5, [1470143]=5, [1470144]=5, [1470145]=5, [1470146]=5, [1470147]=5, [1470148]=5, [1470149]=5, [1470150]=5, [1470151]=5, [1470152]=5, [1470153]=5, [1470154]=5, [1470155]=5, [1470156]=5, [1470157]=5, [1470158]=5, [1470159]=5, [1470160]=5, [1470161]=5, [1470162]=5, [1470163]=5, [1470164]=5, [1470165]=5, [1470166]=5, [1470167]=5, [1470168]=5, [1470169]=6, [1470170]=6, [1470171]=6, [1470172]=6, [1470173]=6, [1470174]=6, [1470175]=6, [1470176]=6, [1470177]=6, [1470178]=6, [1470179]=6, [1470180]=6, [1470181]=6, [1470182]=6, [1470183]=6, [1470184]=6, [1470185]=6, [1470186]=6, [1470187]=6, [1470188]=6, [1470189]=6, [1470190]=6, [1470191]=6, [1470192]=6, [1470193]=6, [1470194]=6, [1470195]=6, [1470196]=6, [1470197]=6, [1470198]=6, [1470199]=6, [1470200]=6, [1470201]=6, [1470202]=6, [1470203]=6, [1470204]=7, [1470205]=7, [1470206]=7, [1470207]=7, [1470208]=7, [1470209]=7, [1470210]=7, [1470211]=7, [1470212]=7, [1470213]=7, [1470214]=7, [1470215]=7, [1470216]=7, [1470217]=7, [1470218]=7, [1470219]=7, [1470220]=7, [1470221]=7, [1470222]=7, [1470223]=7, [1470224]=7, [1470225]=7, [1470226]=7, [1470227]=7, [1470228]=7, [1470229]=7, [1470230]=7, [1470231]=7, [1470232]=7, [1470233]=7, [1470234]=7, [1470235]=7, [1470236]=7, [1470237]=7, [1470238]=7, [1470239]=7, [1470240]=7, [1470241]=7, [1470242]=7, [1470243]=7, [1470244]=7, [1470245]=7, [1470246]=7, [1470247]=7, [1470248]=7, [1470249]=7, [1470250]=7, [1470251]=7, [1470252]=8, [1470253]=8, [1470254]=8, [1470255]=8, [1470256]=8, [1470257]=8, [1470258]=8, [1470259]=8, [1470260]=8, [1470261]=8, [1470262]=8, [1470263]=8, [1470264]=8, [1470265]=8, [1470266]=8, [1470267]=8, [1470268]=8, [1470269]=8, [1470270]=8, [1470271]=8, [1470272]=8, [1470273]=8, [1470274]=8, [1470275]=8, [1470276]=8, [1470277]=8, [1470278]=8, [1470279]=8, [1470280]=8, [1470281]=8, [1470282]=8, [1470283]=8, [1470284]=8, [1470285]=8, [1470286]=8, [1470287]=8, [1470288]=8, [1470289]=8, [1470290]=8, [1470291]=9, [1470292]=9, [1470293]=9, [1470294]=9, [1470295]=9, [1470296]=9, [1470297]=9, [1470298]=9, [1470299]=9, [1470300]=9, [1470301]=9, [1470302]=9, [1470303]=9, [1470304]=9, [1470305]=9, [1470306]=9, [1470307]=9, [1470308]=9, [1470309]=9, [1470310]=9, [1470311]=9, [1470312]=9, [1470313]=9, [1470314]=9, [1470315]=9, [1470316]=9, [1470317]=9, [1470318]=9, [1470319]=9, [1470320]=9, [1470321]=9, [1470322]=9, [1470323]=9, [1470324]=9, [1470325]=9, [1470326]=9, [1470327]=9, [1470328]=9, [1470329]=9, [1470330]=9, [1470331]=9, [1470332]=9, [1470333]=9, [1470334]=9, [1470335]=9, [1470336]=9, [1470337]=9, [1470338]=9, [1470339]=9, [1470340]=10, [1470341]=10, [1470342]=10, [1470343]=10, [1470344]=10, [1470345]=10, [1470346]=10, [1470347]=10, [1470348]=10, [1470349]=10, [1470350]=10, [1470351]=10, [1470352]=10, [1470353]=10, [1470354]=10, [1470355]=10, [1470356]=10, [1470357]=10, [1470358]=10, [1470359]=10, [1470360]=10, [1470361]=10, [1470362]=10, [1470363]=10, [1470364]=10, [1470365]=10, [1470366]=10, [1470367]=10, [1470368]=10, [1470369]=10, [1470370]=10, [1470371]=10, [1470372]=10, [1470373]=10, [1470374]=10, [1470375]=10, [1470376]=10, [1470377]=10, [1470378]=10, [1470379]=10, [1470380]=10, [1470381]=10, [1470382]=10, [1470383]=10, [1470384]=10, [1470385]=10, [1470386]=11, [1470387]=11, [1470388]=11, [1470389]=11, [1470390]=11, [1470391]=11, [1470392]=11, [1470393]=11, [1470394]=11, [1470395]=11, [1470396]=11, [1470397]=11, [1470398]=11, [1470399]=11, [1470400]=11, [1470401]=11, [1470402]=11, [1470403]=11, [1470404]=11, [1470405]=11, [1470406]=11, [1470407]=11, [1470408]=11, [1470409]=11, [1470410]=11, [1470411]=11, [1470412]=11, [1470413]=11, [1470414]=11, [1470415]=11, [1470416]=11, [1470417]=11, [1470418]=11, [1470419]=11, [1470420]=11, [1470421]=11, [1470422]=11, [1470423]=11, [1470424]=11, [1470425]=11, [1470426]=11, [1470427]=11, [1470428]=11, [1470429]=11, [1470430]=11, [1470431]=11, [1470432]=11, [1470433]=11, [1470434]=11, [1470435]=11, [1470436]=11, [1470437]=11, [1470438]=11, [1470439]=11, [1470440]=11, [1470441]=11, [1470442]=12, [1470443]=12, [1470444]=12, [1470445]=12, [1470446]=12, [1470447]=12, [1470448]=12, [1470449]=12, [1470450]=12, [1470451]=12, [1470452]=12, [1470453]=12, [1470454]=12, [1470455]=12, [1470456]=12, [1470457]=12, [1470458]=12, [1470459]=12, [1470460]=12, [1470461]=12, [1470462]=12, [1470463]=12, [1470464]=12, [1470465]=12, [1470466]=12, [1470467]=12, [1470468]=12, [1470469]=12, [1470470]=13, [1470471]=13, [1470472]=13, [1470473]=13, [1470474]=13, [1470475]=13, [1470476]=13, [1470477]=13, [1470478]=13, [1470479]=13, [1470480]=13, [1470481]=13, [1470482]=13, [1470483]=13, [1470484]=13, [1470485]=13, [1470486]=13, [1470487]=13, [1470488]=13, [1470489]=13, [1470490]=13, [1470491]=13, [1470492]=13, [1470493]=13, [1470494]=13, [1470495]=13, [1470496]=13, [1470497]=13, [1470498]=13, [1470499]=13, [1470500]=13, [1470501]=13, [1470502]=13, [1470503]=13, [1470504]=13, [1470505]=13, [1470506]=13}) do SPELL_CLASS[id] = c end
for id, r in pairs({[1470000]="o", [1470001]="o", [1470002]="u", [1470003]="u", [1470004]="u", [1470005]="u", [1470006]="o", [1470007]="o", [1470008]="o", [1470009]="o", [1470010]="u", [1470011]="h", [1470012]="o", [1470013]="o", [1470014]="u", [1470015]="u", [1470016]="o", [1470017]="u", [1470018]="u", [1470019]="o", [1470020]="u", [1470021]="u", [1470022]="u", [1470023]="o", [1470024]="o", [1470025]="u", [1470026]="u", [1470027]="u", [1470028]="o", [1470029]="u", [1470030]="u", [1470031]="o", [1470032]="u", [1470033]="u", [1470034]="u", [1470035]="u", [1470036]="u", [1470037]="u", [1470038]="h", [1470039]="u", [1470040]="u", [1470041]="o", [1470042]="u", [1470043]="o", [1470044]="o", [1470045]="h", [1470046]="u", [1470047]="u", [1470048]="u", [1470049]="u", [1470050]="h", [1470051]="h", [1470052]="h", [1470053]="o", [1470054]="u", [1470055]="u", [1470056]="h", [1470057]="u", [1470058]="u", [1470059]="u", [1470060]="o", [1470061]="u", [1470062]="o", [1470063]="u", [1470064]="o", [1470065]="u", [1470066]="u", [1470067]="o", [1470068]="u", [1470069]="u", [1470070]="u", [1470071]="u", [1470072]="u", [1470073]="u", [1470074]="o", [1470075]="u", [1470076]="u", [1470077]="u", [1470078]="u", [1470079]="o", [1470080]="u", [1470081]="u", [1470082]="h", [1470083]="u", [1470084]="o", [1470085]="o", [1470086]="u", [1470087]="o", [1470088]="o", [1470089]="u", [1470090]="u", [1470091]="o", [1470092]="o", [1470093]="o", [1470094]="u", [1470095]="h", [1470096]="o", [1470097]="u", [1470098]="h", [1470099]="u", [1470100]="o", [1470101]="u", [1470102]="u", [1470103]="u", [1470104]="u", [1470105]="u", [1470106]="u", [1470107]="u", [1470108]="u", [1470109]="o", [1470110]="u", [1470111]="u", [1470112]="u", [1470113]="u", [1470114]="h", [1470115]="h", [1470116]="u", [1470117]="u", [1470118]="u", [1470119]="o", [1470120]="u", [1470121]="u", [1470122]="o", [1470123]="u", [1470124]="u", [1470125]="u", [1470126]="o", [1470127]="o", [1470128]="u", [1470129]="o", [1470130]="u", [1470131]="u", [1470132]="h", [1470133]="u", [1470134]="h", [1470135]="u", [1470136]="h", [1470137]="o", [1470138]="u", [1470139]="u", [1470140]="o", [1470141]="u", [1470142]="o", [1470143]="u", [1470144]="h", [1470145]="u", [1470146]="u", [1470147]="u", [1470148]="u", [1470149]="o", [1470150]="u", [1470151]="u", [1470152]="u", [1470153]="u", [1470154]="o", [1470155]="h", [1470156]="h", [1470157]="u", [1470158]="u", [1470159]="u", [1470160]="o", [1470161]="h", [1470162]="o", [1470163]="u", [1470164]="h", [1470165]="h", [1470166]="u", [1470167]="u", [1470168]="u", [1470169]="u", [1470170]="u", [1470171]="o", [1470172]="h", [1470173]="u", [1470174]="u", [1470175]="u", [1470176]="o", [1470177]="o", [1470178]="o", [1470179]="u", [1470180]="u", [1470181]="o", [1470182]="u", [1470183]="u", [1470184]="u", [1470185]="u", [1470186]="u", [1470187]="h", [1470188]="o", [1470189]="o", [1470190]="u", [1470191]="u", [1470192]="o", [1470193]="o", [1470194]="o", [1470195]="u", [1470196]="u", [1470197]="u", [1470198]="h", [1470199]="o", [1470200]="u", [1470201]="u", [1470202]="o", [1470203]="u", [1470204]="u", [1470205]="u", [1470206]="o", [1470207]="u", [1470208]="u", [1470209]="u", [1470210]="u", [1470211]="u", [1470212]="u", [1470213]="u", [1470214]="u", [1470215]="o", [1470216]="h", [1470217]="h", [1470218]="h", [1470219]="h", [1470220]="u", [1470221]="h", [1470222]="u", [1470223]="u", [1470224]="u", [1470225]="o", [1470226]="o", [1470227]="u", [1470228]="u", [1470229]="u", [1470230]="u", [1470231]="o", [1470232]="o", [1470233]="u", [1470234]="u", [1470235]="u", [1470236]="u", [1470237]="u", [1470238]="o", [1470239]="u", [1470240]="u", [1470241]="u", [1470242]="o", [1470243]="u", [1470244]="u", [1470245]="u", [1470246]="u", [1470247]="u", [1470248]="u", [1470249]="u", [1470250]="u", [1470251]="u", [1470252]="u", [1470253]="u", [1470254]="o", [1470255]="o", [1470256]="h", [1470257]="o", [1470258]="u", [1470259]="u", [1470260]="u", [1470261]="u", [1470262]="o", [1470263]="u", [1470264]="u", [1470265]="u", [1470266]="u", [1470267]="u", [1470268]="u", [1470269]="u", [1470270]="o", [1470271]="u", [1470272]="u", [1470273]="o", [1470274]="o", [1470275]="o", [1470276]="h", [1470277]="o", [1470278]="u", [1470279]="u", [1470280]="u", [1470281]="u", [1470282]="u", [1470283]="u", [1470284]="u", [1470285]="o", [1470286]="u", [1470287]="u", [1470288]="u", [1470289]="u", [1470290]="u", [1470291]="o", [1470292]="o", [1470293]="u", [1470294]="u", [1470295]="u", [1470296]="h", [1470297]="o", [1470298]="u", [1470299]="o", [1470300]="o", [1470301]="o", [1470302]="u", [1470303]="u", [1470304]="o", [1470305]="u", [1470306]="u", [1470307]="h", [1470308]="u", [1470309]="u", [1470310]="u", [1470311]="o", [1470312]="u", [1470313]="h", [1470314]="h", [1470315]="u", [1470316]="u", [1470317]="u", [1470318]="u", [1470319]="o", [1470320]="u", [1470321]="u", [1470322]="u", [1470323]="u", [1470324]="u", [1470325]="u", [1470326]="u", [1470327]="u", [1470328]="u", [1470329]="u", [1470330]="u", [1470331]="u", [1470332]="u", [1470333]="o", [1470334]="u", [1470335]="o", [1470336]="u", [1470337]="u", [1470338]="u", [1470339]="u", [1470340]="u", [1470341]="u", [1470342]="u", [1470343]="u", [1470344]="u", [1470345]="u", [1470346]="o", [1470347]="h", [1470348]="u", [1470349]="u", [1470350]="u", [1470351]="h", [1470352]="u", [1470353]="u", [1470354]="u", [1470355]="u", [1470356]="u", [1470357]="u", [1470358]="u", [1470359]="o", [1470360]="u", [1470361]="h", [1470362]="u", [1470363]="h", [1470364]="u", [1470365]="u", [1470366]="h", [1470367]="u", [1470368]="u", [1470369]="h", [1470370]="u", [1470371]="u", [1470372]="h", [1470373]="u", [1470374]="u", [1470375]="o", [1470376]="u", [1470377]="u", [1470378]="u", [1470379]="h", [1470380]="u", [1470381]="h", [1470382]="u", [1470383]="u", [1470384]="u", [1470385]="u", [1470386]="u", [1470387]="o", [1470388]="o", [1470389]="u", [1470390]="u", [1470391]="u", [1470392]="u", [1470393]="u", [1470394]="o", [1470395]="h", [1470396]="o", [1470397]="u", [1470398]="u", [1470399]="u", [1470400]="h", [1470401]="u", [1470402]="h", [1470403]="u", [1470404]="h", [1470405]="u", [1470406]="o", [1470407]="u", [1470408]="u", [1470409]="u", [1470410]="o", [1470411]="u", [1470412]="u", [1470413]="u", [1470414]="u", [1470415]="u", [1470416]="h", [1470417]="u", [1470418]="u", [1470419]="u", [1470420]="o", [1470421]="u", [1470422]="u", [1470423]="o", [1470424]="o", [1470425]="u", [1470426]="u", [1470427]="u", [1470428]="u", [1470429]="u", [1470430]="o", [1470431]="h", [1470432]="o", [1470433]="u", [1470434]="u", [1470435]="o", [1470436]="u", [1470437]="u", [1470438]="o", [1470439]="o", [1470440]="o", [1470441]="u", [1470442]="o", [1470443]="u", [1470444]="u", [1470445]="u", [1470446]="u", [1470447]="o", [1470448]="u", [1470449]="u", [1470450]="o", [1470451]="u", [1470452]="u", [1470453]="u", [1470454]="u", [1470455]="o", [1470456]="u", [1470457]="u", [1470458]="u", [1470459]="u", [1470460]="u", [1470461]="u", [1470462]="u", [1470463]="u", [1470464]="u", [1470465]="u", [1470466]="o", [1470467]="u", [1470468]="h", [1470469]="u", [1470470]="u", [1470471]="u", [1470472]="u", [1470473]="u", [1470474]="u", [1470475]="u", [1470476]="u", [1470477]="u", [1470478]="u", [1470479]="u", [1470480]="h", [1470481]="h", [1470482]="u", [1470483]="h", [1470484]="u", [1470485]="u", [1470486]="u", [1470487]="u", [1470488]="u", [1470489]="u", [1470490]="h", [1470491]="u", [1470492]="u", [1470493]="u", [1470494]="h", [1470495]="u", [1470496]="u", [1470497]="h", [1470498]="o", [1470499]="u", [1470500]="u", [1470501]="u", [1470502]="h", [1470503]="u", [1470504]="u", [1470505]="u", [1470506]="u"}) do SPELL_ROLE[id] = r end
-- END PROXY_MAPS

-- BEGIN WORLD_DROPS (generated by pool_build.py: teleports/mounts, learned from boss kills, never drafted)
WORLD_DROPS = {{556, "Astral Recall"}, {698, "Ritual of Summoning"}, {5784, "Felsteed"}, {13819, "Summon Warhorse"}, {23161, "Dreadsteed"}, {23214, "Summon Charger"}, {29893, "Create Soulwell"}, {32223, "Crusader Aura"}, {34767, "Summon Thalassian Charger"}, {34769, "Summon Thalassian Warhorse"}, {50977, "Death Gate"}, {51986, "On a Pale Horse"}, {69820, "Summon Sunwalker Kodo"}, {69826, "Summon Great Sunwalker Kodo"}, {73629, "Summon Exarch's Elekk"}, {73630, "Summon Great Exarch's Elekk"}, {126892, "Zen Pilgrimage"}, {193753, "Dreamwalk"}, {270562, "Summon Darkforge Ram"}, {270564, "Summon Dawnforge Ram"}, {290608, "Crusader's Direhorn"}, {300728, "Door of Shadows"}, {342601, "Ritual of Doom"}, {363613, "Summon Lightforged Ruinstrider"}, {453785, "Earthen Ordinant's Ramolith"}}
-- END WORLD_DROPS

local RARITY = {
    [C] = {name = "Common",   color = "ffffffff", weight = 60},
    [U] = {name = "Uncommon", color = "ff1eff00", weight = 25},
    [R] = {name = "Rare",     color = "ff0070dd", weight = 11},
    [E] = {name = "Epic",     color = "ffa335ee", weight = 4},
    [LG] = {name = "Legendary", color = "ffff8000", weight = 1.5},
    [IM] = {name = "Immortal",  color = "ffff3a3a", weight = 0.5},
    [GD] = {name = "Godly",     color = "ff3de6ff", weight = 0.15},
}

-- Drop spells this client build does not know (removed/renumbered IDs).
local function ValidatePool()
    if not GetSpellInfo then return 0 end
    local kept, dropped = {}, 0
    for _, e in ipairs(POOL) do
        local ok, info = pcall(GetSpellInfo, e[1])
        if ok and info then kept[#kept + 1] = e else dropped = dropped + 1 end
    end
    POOL = kept
    local tk = {}
    for _, e in ipairs(TALENTS) do
        local ok, info = pcall(GetSpellInfo, e[1])
        if ok and info then tk[#tk + 1] = e else dropped = dropped + 1 end
    end
    TALENTS = tk
    return dropped
end
local DROPPED = ValidatePool()
local TALENT_BY_ID = {}
for _, e in ipairs(TALENTS) do TALENT_BY_ID[e[1]] = e end
local function IsTalent(id) return TALENT_BY_ID[id] ~= nil end

local function Alive(p)
    local ok, r = pcall(function() return p:IsAlive() end)
    return ok and r
end

local function HasSQL()
    return CharDBQuery ~= nil and CharDBExecute ~= nil
end

local function SpellLink(id, name, rarity)
    local r = RARITY[rarity or 1] or RARITY[1]
    return "|c" .. r.color .. "|Hspell:" .. id .. "|h[" .. name .. "]|h|r"
end

local function ById(id)
    for _, e in ipairs(POOL) do
        if e[1] == id then return e end
    end
    return TALENT_BY_ID[id]
end
function HERO_SpellRarity(id) local e = ById(id); return e and e[5] or 0 end   -- used by paragon.lua (Prestige keeps Legendary or better)

local function OwnedCount(player)
    local n = 0
    for _, e in ipairs(POOL) do
        local ok, has = pcall(function() return player:HasSpell(e[1]) end)
        if ok and has then n = n + 1 end
    end
    return n
end

-- Character key: name (unique per realm). NOTE: GetGUIDLow() returns
-- userdata in this Eluna build, so guids cannot be used with string.format.
local function CharKey(player)
    local name = player:GetName() or ""
    return (string.gsub(name, "'", "''"))
end

local function DbGet(key)
    local q = string.format("SELECT charges, draft FROM characters.wildcard_state WHERE name = '%s'", key)
    local ok, res = pcall(CharDBQuery, q)
    if ok and res then
        local ook, charges = pcall(function() return res:GetUInt32(0) end)
        local dok, draft = pcall(function() return res:GetString(1) end)
        if ook and dok then
            return {charges = charges, draft = draft or "", fresh = false}
        end
    end
    return {charges = 0, draft = "", fresh = true}
end

local function DbPut(key, charges, draft)
    local q = string.format(
        "REPLACE INTO characters.wildcard_state (name, charges, draft) VALUES ('%s', %d, '%s')",
        key, charges, draft or "")
    pcall(CharDBExecute, q)
end

local function ParseDraft(draft)
    local ids = {}
    for num in string.gmatch(draft or "", "(%d+)") do
        ids[#ids + 1] = tonumber(num)
    end
    return ids
end

-- ---------------------------------------------------------------- hero paths
-- Every character picks ONE path for good (Descend Hero):
--   1 Classless: buy any ability with Ability Essence (AE), unlearn = refund
--   2 Wildcard : the Dice of Destiny rolls abilities, Keep or Reroll
local PATH_NONE, PATH_CLASSLESS, PATH_WILDCARD, PATH_CONQUEST = 0, 1, 2, 3
local AE_COST = {[1] = 1, [2] = 2, [3] = 3, [4] = 5, [5] = 7, [7] = 10, [8] = 14}   -- by rarity
local CTAG = "|cff00ccff[Classless]|r "

local function GetPath(key)
    local ok, res = pcall(CharDBQuery, string.format("SELECT path FROM characters.wildcard_path WHERE name = '%s'", key))
    if ok and res then return res:GetUInt32(0) end
    return PATH_NONE
end

local function SetPath(key, path)
    pcall(CharDBExecute, string.format("REPLACE INTO characters.wildcard_path (name, path) VALUES ('%s', %d)", key, path))
end

-- 3 AE at level 1, +1 per level from 4 (as in mod-classless-wildcard)
local function AETotal(player) return 3 + math.max(0, player:GetLevel() - 3) end

local function AESpent(key)
    local ok, res = pcall(CharDBQuery, string.format("SELECT COALESCE(SUM(cost), 0) FROM characters.wildcard_classless WHERE name = '%s'", key))
    if ok and res then return tonumber(res:GetString(0)) or 0 end
    return 0
end

local function AEFree(player) return AETotal(player) - AESpent(CharKey(player)) end

local function ClasslessOwned(key, spell)
    local ok, res = pcall(CharDBQuery, string.format("SELECT cost FROM characters.wildcard_classless WHERE name = '%s' AND spell = %d", key, spell))
    if ok and res then return res:GetUInt32(0) end
    return nil
end

-- ---------------------------------------------------------------- Hero talents
-- Talent Essence (TE): 1 per level from 10 (Descend). A talent rank costs 1 TE.
-- Wildcard heroes roll talents instead: from level 10 every even level is a talent roll.
local TTAG = "|cffb048f8[Talents]|r "
local TALENT_START = 10

local function TETotal(player) return math.max(0, player:GetLevel() - (TALENT_START - 1)) end

local function HeroTalents(key)
    local t = {}
    local ok, res = pcall(CharDBQuery, string.format("SELECT spell, cost FROM characters.hero_talents WHERE name = '%s'", key))
    if ok and res then repeat t[res:GetUInt32(0)] = res:GetUInt32(1) until not res:NextRow() end
    return t
end

local function TESpent(key)
    local n = 0
    for _, c in pairs(HeroTalents(key)) do n = n + c end
    return n
end

local function TEFree(player) return TETotal(player) - TESpent(CharKey(player)) end

local function Knows(player, id)
    local ok, has = pcall(function() return player:HasSpell(id) end)
    return ok and has
end

-- why a talent cannot be taken (nil = it can)
local function TalentBlock(player, e, owned)
    if owned[e[1]] then return "You already have that talent." end
    if player:GetLevel() < e[3] then return "Requires level " .. e[3] .. "." end
    if e.prev and e.prev ~= 0 and not owned[e.prev] then return "Take the previous rank first." end
    if e.req then
        for _, r in ipairs(e.req) do if Knows(player, r) then return nil end end
        local n = ById(e.req[1])
        return "Requires the ability " .. (n and n[2] or e.req[1]) .. "."
    end
    return nil
end

local function GiveTalent(player, id, cost)
    pcall(function() player:LearnSpell(id) end)
    pcall(CharDBExecute, string.format("REPLACE INTO characters.hero_talents (name, spell, cost) VALUES ('%s', %d, %d)", CharKey(player), id, cost))
end

-- C++ turns the retail talent tree off when Hero Essence is applied, which can take a
-- shared spell away; give every Hero talent back.
local function RestoreTalents(player)
    for id in pairs(HeroTalents(CharKey(player))) do
        if not Knows(player, id) then pcall(function() player:LearnSpell(id) end) end
    end
end

local function TalentRanks(player, name)
    local n = 0
    for _, e in ipairs(TALENTS) do
        if e[2]:find(name, 1, true) == 1 and Knows(player, e[1]) then n = n + 1 end
    end
    return n
end

-- ---------------------------------------------------------------- Hero Essence
-- Hero abilities cost Essence (alt power bar 9990, hotfix hero_essence.sql).
-- Aura 1400010 turns the bar on; Essence regenerates here, faster out of combat.
local HERO_AURA = 1400010
local POWER_ALT = 10
local ESSENCE_MAX = 100          -- level 1; the pool grows with level (EssenceMaxFor)
-- Essence pool: 100 at level 1, +3 per level (340 at 80). Regeneration and the kill bonus scale with it.
local function EssenceMaxFor(player)
    local para = 0
    pcall(function() para = player:Data():Get("para_lvl") or 0 end)
    return 100 + 3 * math.max(0, (player:GetLevel() or 1) - 1) + 2 * para
end

local function IsHero(player) return GetPath(CharKey(player)) ~= PATH_NONE end

local function EssenceTick(_, _, _, player)
    if not player or not player:IsInWorld() then return end
    if not player:HasAura(HERO_AURA) then
        -- level-ups and map changes can drop the aura: a Hero always gets its Essence bar back
        local okP, path = pcall(function() return GetPath(CharKey(player)) end)
        if okP and path and path ~= PATH_NONE then
            pcall(function() player:AddAura(HERO_AURA, player); player:SetMaxPower(POWER_ALT, EssenceMaxFor(player)); player:SetPower(EssenceMaxFor(player), POWER_ALT) end)
        end
        return
    end
    -- a level-up resets the bar's maximum to 0 ("not enough Essence" until the next login): put it back
    local okM, mx = pcall(function() return player:GetMaxPower(POWER_ALT) end)
    local maxE = EssenceMaxFor(player)
    if okM and mx and mx ~= maxE then
        pcall(function() player:SetMaxPower(POWER_ALT, maxE); if mx < maxE then player:SetPower(math.min(maxE, player:GetPower(POWER_ALT) + (maxE - mx)), POWER_ALT) end end)
    end
    local cur = player:GetPower(POWER_ALT)
    if cur >= maxE then return end
    local add = math.floor(maxE * (player:IsInCombat() and 0.07 or 0.15)) + (player:Data():Get("hero_attune") or 0)
    player:SetPower(math.min(maxE, cur + add), POWER_ALT)
end

-- Remember every ability the Hero system gave (Classless buys have a cost,
-- Wildcard rolls cost 0), so stripping class spells never takes them away.
local function RememberHeroSpell(player, id, cost)
    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.wildcard_classless (name, spell, cost) VALUES ('%s', %d, %d)",
        CharKey(player), id, cost or 0))
end

-- Pure Hero: the class is only a body. Its spells (world.hero_class_spells)
-- are removed; everything a Hero casts comes from the Hero pool.
local CLASS_SPELLS = {}   -- class -> {spell ids}, loaded once per Lua state
local function ClassSpellList(cls)
    if not CLASS_SPELLS[cls] then
        local list = {}
        local q = WorldDBQuery(string.format("SELECT spell FROM hero_class_spells WHERE class = %d", cls))
        if q then repeat list[#list + 1] = q:GetUInt32(0) until not q:NextRow() end
        CLASS_SPELLS[cls] = list
    end
    return CLASS_SPELLS[cls]
end

local function StripClassSpells(player)
    local key = CharKey(player)
    local list = ClassSpellList(player:GetClass())
    local present = {}
    for _, id in ipairs(list) do
        local okH, has = pcall(function() return player:HasSpell(id) end)
        if okH and has then present[#present + 1] = id end
    end
    if #present == 0 then return 0 end
    local keep = {}
    local ok, res = pcall(CharDBQuery, string.format("SELECT spell FROM characters.wildcard_classless WHERE name = '%s'", key))
    if ok and res then repeat keep[res:GetUInt32(0)] = true until not res:NextRow() end
    for id in pairs(HeroTalents(key)) do keep[id] = true end
    -- active Mystic Enchants (worldforge.lua) may be retail class passives too
    local okM, rm = pcall(WorldDBQuery, string.format("SELECT e.spell FROM world.mystic_enchant e JOIN characters.mystic_collection c ON c.enchant = e.id WHERE c.name = '%s' AND c.active = 1", key))
    if okM and rm then repeat keep[rm:GetUInt32(0)] = true until not rm:NextRow() end
    local removed = 0
    for _, id in ipairs(present) do
        if not keep[id] then
            pcall(function() player:RemoveSpell(id) end)
            removed = removed + 1
        end
    end
    return removed
end

-- Everything the Hero system ever gave (Classless buys, Wildcard rolls, starters) is re-learned when it is missing.
-- every change a Hero makes to its own abilities (forget, unlearn, respec) marks the time so the safety net below does not undo it
function HERO_Touch(player) pcall(function() player:Data():Set("hero_touch", os.time()); player:Data():Set("hero_cache_t", 0) end) end

local function RestoreHeroSpells(player)
    local ok, res = pcall(CharDBQuery, string.format("SELECT spell FROM characters.wildcard_classless WHERE name = '%s'", CharKey(player)))
    if not (ok and res) then return end
    repeat
        local id = res:GetUInt32(0)
        if not Knows(player, id) then pcall(function() player:LearnSpell(id) end) end
    until not res:NextRow()
end

-- Retail puts the spells it grants at a level-up on the action bar; Heroes lose those spells again, so the buttons go too.
local function CleanClassButtons(player)
    for _, id in ipairs(ClassSpellList(player:GetClass())) do
        local okK, known = pcall(function() return player:HasSpell(id) end)
        if not (okK and known) then pcall(function() player:RemoveActionButtonsForSpell(id) end) end
    end
end

-- Every Hero may wear and wield everything from the start: armor classes, shields and all weapon skills (retail proficiency spells).
local PROFICIENCIES = {750, 8737, 9077, 9116, 196, 197, 198, 199, 200, 201, 202, 227, 264, 266, 5011, 1180, 15590, 2567, 5009, 674}
local PROF_SKILLS = {293, 413, 414, 415, 433, 44, 172, 45, 46, 54, 160, 229, 43, 55, 136, 226, 173, 473, 176, 228, 118}   -- plate, mail, leather, cloth, shield, all weapons, dual wield
local function GrantProficiencies(player)
    for _, sk in ipairs(PROF_SKILLS) do
        local okS, has = pcall(function() return player:HasSkill(sk) end)
        if okS and not has then pcall(function() player:SetSkill(sk, 1, 1, 1) end) end
    end
    for _, id in ipairs(PROFICIENCIES) do
        local ok, has = pcall(function() return player:HasSpell(id) end)
        if ok and not has then pcall(function() player:LearnSpell(id) end) end
    end
end

local function EnterHero(player)
    if not player:HasAura(HERO_AURA) then player:AddAura(HERO_AURA, player) end
    pcall(function() player:SetMaxPower(POWER_ALT, EssenceMaxFor(player)) end)
    player:SetPower(EssenceMaxFor(player), POWER_ALT)
    RestoreTalents(player)
    RestoreHeroSpells(player)
    GrantProficiencies(player)
    player:Data():Set("hero_attune", TalentRanks(player, "Essence Attunement"))
    local n = StripClassSpells(player)
    CleanClassButtons(player)
    PrintInfo(string.format("[wildcard] EnterHero %s: aura=%s class=%d stripped=%d", player:GetName(), tostring(player:HasAura(HERO_AURA)), player:GetClass(), n))
    if n > 0 then
        player:SendBroadcastMessage("|cffff8000[Hero]|r Your class is only a body now: " .. n ..
            " class abilities faded. Every ability you use comes from the Hero pool and costs Essence.")
    end
end

-- Retail hands out class spells at level-ups and zone changes: Heroes lose them again within seconds.
local function HeroStripTick(p)
    local okP, path = pcall(function() return GetPath(CharKey(p)) end)
    if okP and path and path ~= PATH_NONE then
        pcall(StripClassSpells, p)
        -- safety net: choosing a specialization (or any core reset) removes learned spells; give every Hero ability back
        local t = 0
        pcall(function() t = p:Data():Get("hero_touch") or 0 end)
        if type(t) ~= "number" then t = 0 end
        if os.time() - t > 8 then
            -- cheap check: the hero's ability ids are cached (refreshed from the DB at most every 60 s); only a missing one costs more
            local now = os.time()
            local ct = p:Data():Get("hero_cache_t") or 0
            if type(ct) ~= "number" then ct = 0 end
            local cache = p:Data():Get("hero_cache")
            if type(cache) ~= "string" or now - ct > 60 then
                local ids = {}
                local okQ, res = pcall(CharDBQuery, string.format("SELECT spell FROM characters.wildcard_classless WHERE name = '%s'", CharKey(p)))
                if okQ and res then repeat ids[#ids + 1] = res:GetUInt32(0) until not res:NextRow() end
                cache = table.concat(ids, ",")
                p:Data():Set("hero_cache", cache)
                p:Data():Set("hero_cache_t", now)
            end
            for id in string.gmatch(cache, "%d+") do
                local sid = tonumber(id)
                local okK, known = pcall(function() return p:HasSpell(sid) end)
                if okK and not known then pcall(function() p:LearnSpell(sid) end) end
            end
        end
    end
end
if MAP_Timer then
    MAP_Timer("wildcard.Strip", function()
        for _, p in ipairs(MAP_Players()) do HeroStripTick(p) end
    end, 4000)
end

-- Essence regeneration: one timer per map state over its players (multistate safe)
if MAP_Timer then
    MAP_Timer("wildcard.Essence", function()
        for _, p in ipairs(MAP_Players()) do pcall(EssenceTick, nil, nil, nil, p) end
    end, 2000)
end

-- spells the client cannot resolve (shown as "Spell 1234" with a ? icon) are never rolled
-- RETAIL SPELLS: the pool uses the original retail spell ids. The core pays every pool spell with Essence (world.hero_spell_cost), so no
-- clones and no Lua triggers are needed. hotfixes.hero_spell_map: old clone id -> retail id (used for the pool and for moving old heroes).
local CLONE_TO_RETAIL = {}
do
    local q = WorldDBQuery("SELECT clone, retail FROM hotfixes.hero_spell_map")
    if q then repeat CLONE_TO_RETAIL[q:GetUInt32(0)] = q:GetUInt32(1) until not q:NextRow() end
    local seen, out = {}, {}
    for _, e in ipairs(POOL) do
        local r = CLONE_TO_RETAIL[e[1]]
        if r then
            if not seen[r] then
                seen[r] = true
                out[#out + 1] = {r, e[2], e[3], e[4], e[5]}
                if SPELL_ROLE[e[1]] then SPELL_ROLE[r] = SPELL_ROLE[e[1]] end
            end
        else
            out[#out + 1] = e
        end
    end
    for i = #POOL, 1, -1 do POOL[i] = nil end
    for i, e in ipairs(out) do POOL[i] = e end
end

-- retail names for the pool, and a ban list of internal spells that are not abilities (spec placeholders, hotbar slots, passives...)
do
    local names, banned = {}, {}
    local q = WorldDBQuery("SELECT spell_id, name FROM world.hero_spell_names")
    if q then repeat names[q:GetUInt32(0)] = q:GetString(1) until not q:NextRow() end
    local qb = WorldDBQuery("SELECT spell_id FROM world.hero_pool_banned")
    if qb then repeat banned[qb:GetUInt32(0)] = true until not qb:NextRow() end
    local out = {}
    for _, e in ipairs(POOL) do
        if not banned[e[1]] then
            if names[e[1]] and names[e[1]] ~= "?" then e[2] = names[e[1]] end
            out[#out + 1] = e
        end
    end
    for i = #POOL, 1, -1 do POOL[i] = nil end
    for i, e in ipairs(out) do POOL[i] = e end
end

-- extra retail abilities (covenant, Azerite essences, class spells the old pool missed): world.hero_pool_extra
do
    local q = WorldDBQuery("SELECT spell_id, name, minlevel, rarity, role FROM world.hero_pool_extra")
    local known = {}
    for _, e in ipairs(POOL) do known[e[1]] = true end
    if q then
        repeat
            local id = q:GetUInt32(0)
            if not known[id] then
                POOL[#POOL + 1] = {id, q:GetString(1), q:GetUInt32(2), 0, q:GetUInt32(3)}
                SPELL_ROLE[id] = q:GetString(4)
            end
        until not q:NextRow()
    end
end

local function BadSpells()
    local bad = {}
    local ok, res = pcall(WorldDBQuery, "SELECT k FROM world.lw_state WHERE k LIKE 'bad:%'")
    if ok and res then repeat bad[tonumber(string.sub(res:GetString(0), 5))] = true until not res:NextRow() end
    return bad
end

local function RollDraft(player, n, talents, exclude, role)
    local lvl = player:GetLevel()
    local race = player:GetRace()
    local cand = {}
    local bad = BadSpells()
    if talents then
        local owned = HeroTalents(CharKey(player))
        for _, e in ipairs(TALENTS) do
            if not bad[e[1]] and not TalentBlock(player, e, owned) then cand[#cand + 1] = e end
        end
    end
    for _, e in ipairs(talents and {} or POOL) do
        if not bad[e[1]] and not (exclude and exclude[e[1]]) and (not role or SPELL_ROLE[e[1]] == role or (role == "u" and SPELL_ROLE[e[1]] == "m")) and e[3] <= lvl and (not e[4] or e[4] == 0 or e[4] == race) then
            local ok, has = pcall(function() return player:HasSpell(e[1]) end)
            if ok and not has then cand[#cand + 1] = e end
        end
    end
    -- each card: roll a rarity by weight, then a random unowned spell of it
    local out = {}
    while #out < n and #cand > 0 do
        local total = 0
        for _, e in ipairs(cand) do total = total + RARITY[e[5] or 1].weight end
        local pick, i = math.random() * total, 1
        for k, e in ipairs(cand) do
            pick = pick - RARITY[e[5] or 1].weight
            if pick <= 0 then i = k break end
        end
        out[#out + 1] = cand[i][1]
        local nm = cand[i][2]
        table.remove(cand, i)
        -- never two abilities with the same name in one roll (Polymorph variants, retail duplicates)
        for k = #cand, 1, -1 do if cand[k][2] == nm then table.remove(cand, k) end end
    end
    return out
end

-- The starting set: one offensive, one defensive, one heal and one utility ability (falls back to any spell
-- when a kind has nothing left). Slot k always keeps its kind when it is rolled again.
local SET_ROLES = {"o", "o", "d", "d", "m", "u"}   -- two offensive, two defensive, one mobility, one utility
-- One round of the starting abilities: three cards of the kind this round is about (offence, offence, defence, defence, mobility, utility), any ability fills up
local function StartCards(player)
    local role = SET_ROLES[math.min(OwnedCount(player) + 1, #SET_ROLES)]
    local ids = RollDraft(player, LEVEL_CHOICES, false, nil, role)
    if #ids < LEVEL_CHOICES then
        local ex = {}
        for _, x in ipairs(ids) do ex[x] = true end
        for _, x in ipairs(RollDraft(player, LEVEL_CHOICES - #ids, false, ex)) do ids[#ids + 1] = x end
    end
    return ids
end
-- Rotacia roli pri levelupe: kazdy level rolluje inu rolu dokola
-- (offense, defensive, mobility, heal, buff, control, utility).
-- Ked rola nema co ponuknut, pada sa na neobmedzeny roll (vid nizsie).
local LEVEL_ROLES = {"o", "d", "m", "h", "b", "c", "u"}
local function RollSetSlot(player, k, exclude)
    local r = RollDraft(player, 1, false, exclude, SET_ROLES[k])[1]
    if not r then r = RollDraft(player, 1, false, exclude)[1] end
    return r
end

local function RollSet(player, n)
    local ex, out = {}, {}
    for k = 1, math.min(n, #SET_ROLES) do
        local r = RollSetSlot(player, k, ex)
        if r then out[#out + 1] = r; ex[r] = true end
    end
    return out
end

-- Client UI (Custom/addon/Wildcard): draft cards over the addon channel.
local UI_PREFIX = "WCARD"
local CHAT_MSG_WHISPER = 7

local function SendClient(player, msg)
    pcall(function() player:SendAddonMessage(UI_PREFIX, msg, CHAT_MSG_WHISPER, player) end)
end

-- Players with the client UI (they send UI/HELLO at login) get real windows instead of gossip.
-- Stored in world.lw_state so every Lua state (world and maps) sees it.
local function UIKey(player) return "ui:" .. player:GetName() end
local function SetUI(player, on)
    if on then pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('%s', '1')", UIKey(player)))
    else pcall(WorldDBExecute, string.format("DELETE FROM world.lw_state WHERE k = '%s'", UIKey(player))) end
end
local function HasUI(player)
    local ok, res = pcall(WorldDBQuery, string.format("SELECT v FROM world.lw_state WHERE k = '%s'", UIKey(player)))
    return ok and res ~= nil
end
HERO_HasUI = HasUI

local function SendDraftUI(player, ids, charges)
    if #ids == 0 then
        SendClient(player, "NONE;" .. (charges or 0))
        return
    end
    local parts = {}
    for _, id in ipairs(ids) do
        local e = ById(id)
        parts[#parts + 1] = id .. ":" .. (e and e[5] or 1)
    end
    local pick = #ids > 1   -- three cards of a level up: choose one
    charges = 99   -- rerolls are unlimited   -- 99 = unlimited for the client
    -- remember what was shown: a Keep for a spell that was offered always learns it, even when the stored draft moved on
    local okO, res = pcall(WorldDBQuery, string.format("SELECT v FROM world.lw_state WHERE k = 'offer:%s'", player:GetName()))
    local recent = {}
    if okO and res then for x in string.gmatch(res:GetString(0), "%d+") do recent[#recent + 1] = x end end
    for _, id in ipairs(ids) do
        local dup = false
        for _, x in ipairs(recent) do if tonumber(x) == id then dup = true end end
        if not dup then recent[#recent + 1] = tostring(id) end
    end
    while #recent > 8 do table.remove(recent, 1) end
    pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('offer:%s', '%s')", player:GetName(), table.concat(recent, ",")))
    SendClient(player, "DRAFT;" .. (charges or 0) .. ";" .. table.concat(parts, ",") .. (pick and ";P" or ""))
end

local function AnnounceDraft(player, ids, charges)
    if HERO_DraftWindow and #ids > 0 then pcall(HERO_DraftWindow, player) else SendDraftUI(player, ids, charges) end
    if #ids == 0 then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r No new spells available at your level. Pool exhausted!")
        return
    end
    -- Descend styl: mozes vziat jednu (.wc pick N) alebo vsetky (.wc keep)
    player:SendBroadcastMessage("|cffffd200[Wildcard]|r The dice offers you a draft - .wc pick 1|2|3 (one) or .wc keep (all):")
    for i, id in ipairs(ids) do
        local e = ById(id)
        local label = e and e[2] or ("spell " .. id)
        local r = RARITY[e and e[5] or 1]
        player:SendBroadcastMessage("  [" .. i .. "] " .. SpellLink(id, label, e and e[5]) .. "  |c" .. r.color .. r.name .. "|r")
    end
    player:SendBroadcastMessage("Rerolls left this level: " .. charges .. "  (.wc reroll = new cards, locked stay in UI)")
end

-- Zober VSETKY karty z aktualneho draftu naraz (Descend styl: keep).
-- Pouziva chat (.wc keep) aj addon tlacidlo (KEEPALL sprava).
local function LearnAllDraft(player)
    local guid = CharKey(player)
    if GetPath(guid) ~= PATH_WILDCARD then return end
    local st = DbGet(guid)
    local ids = ParseDraft(st.draft)
    if #ids == 0 then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r No pending draft to keep.")
        return
    end
    for _, id in ipairs(ids) do
        if IsTalent(id) then
            GiveTalent(player, id, 0)
        else
            pcall(function() player:LearnSpell(id) end)
            RememberHeroSpell(player, id, 0)
        end
        local e = ById(id)
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r Learned " ..
            SpellLink(id, e and e[2] or ("spell " .. id), e and e[5]) .. "!")
    end
    player:Data():Set("hero_attune", TalentRanks(player, "Essence Attunement"))
    DbPut(guid, st.charges, "")
    pcall(function() player:PlayDirectSound(888, player) end)
    SendClient(player, "LEARNED;" .. ids[1])
    SHOWN[guid] = nil
    SendClient(player, "NONE;" .. st.charges)
    print("[wildcard] " .. player:GetName() .. " kept whole draft (" .. #ids .. " spells)")
end

SHOWN = {}   -- per character: cards already shown since the last pick, so rerolls never walk back to an earlier card
local function LearnDraftPick(player, idx, forceId)
    local guid = CharKey(player)
    if GetPath(guid) ~= PATH_WILDCARD then return end
    local st = DbGet(guid)
    local ids = ParseDraft(st.draft)
    if not forceId then
        if #ids == 0 then
            player:SendBroadcastMessage("|cffffd200[Wildcard]|r No pending draft. Level up to roll a new one.")
            return
        end
        if not idx or idx < 1 or idx > #ids then
            player:SendBroadcastMessage("|cffffd200[Wildcard]|r Usage: .wc pick 1 | .wc pick 2 | .wc pick 3")
            return
        end
    end
    local id = forceId or ids[idx]
    if IsTalent(id) then
        GiveTalent(player, id, 0)
        player:Data():Set("hero_attune", TalentRanks(player, "Essence Attunement"))
    else
        pcall(function() player:LearnSpell(id) end)
        RememberHeroSpell(player, id, 0)
        if not Knows(player, id) then
            print("[wildcard] WARNING: LearnSpell(" .. id .. ") did not stick for " .. player:GetName())
            player:RegisterEvent(function(_, _, _, p) if p then pcall(function() p:LearnSpell(id) end) end end, 500, 1)
        end
    end
    pcall(function() player:PlayDirectSound(888, player) end)   -- the level-up fanfare
    local e = ById(id)
    player:SendBroadcastMessage("|cffffd200[Wildcard]|r Learned " ..
        SpellLink(id, e and e[2] or ("spell " .. id), e and e[5]) .. "!")
    SHOWN[guid] = nil
    DbPut(guid, st.charges, "")
    SendClient(player, "LEARNED;" .. id)
    SendClient(player, "NONE;" .. st.charges)
    -- the starting abilities are STARTING_ABILITIES rounds of "pick one of three"
    if player:GetLevel() <= START_MAX_LEVEL and OwnedCount(player) < STARTING_ABILITIES then
        player:RegisterEvent(function(_, _, _, p)
            if not p then return end
            local g = CharKey(p)
            if #ParseDraft(DbGet(g).draft) > 0 or OwnedCount(p) >= STARTING_ABILITIES then return end
            local nx = StartCards(p)
            if #nx > 0 then DbPut(g, CHARGES_PER_LEVEL, table.concat(nx, ",")); AnnounceDraft(p, nx, CHARGES_PER_LEVEL) end
        end, 800, 1)
    end
    print("[wildcard] " .. player:GetName() .. " picked spell " .. id)
end

local function RerollDraft(player, lockMask)
    lockMask = lockMask or 0
    local guid = CharKey(player)
    if GetPath(guid) ~= PATH_WILDCARD then return end
    local st = DbGet(guid)
    local ids = ParseDraft(st.draft)
    if #ids == 0 then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r No pending draft to reroll.")
        return
    end
    local free = true   -- unlimited rerolls   -- free while the starting set is rolled; three-card level ups cost a reroll charge
    if st.charges <= 0 and not free then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r No rerolls left this level.")
        return
    end
    local fresh
    if #ids > 1 then
        -- starting set: locked slots stay, the others are rolled again.
        -- Sucasny set je cely excludnuty, takze reroll nikdy nevrati to iste
        -- (Descend styl: zle karty vymen za nove, dobre si zamkni v UI).
        local ex, open = {}, 0
        local hist = SHOWN[guid] or {}
        SHOWN[guid] = hist
        for _, cur in ipairs(ids) do ex[cur] = true; hist[cur] = true end   -- the cards on the table now (locked or not) are never offered again
        for h in pairs(hist) do ex[h] = true end
        for k, id in ipairs(ids) do
            if math.floor(lockMask / 2 ^ (k - 1)) % 2 == 1 then open = open + 0 else open = open + 1 end
        end
        fresh = {}
        for k, id in ipairs(ids) do
            if math.floor(lockMask / 2 ^ (k - 1)) % 2 == 1 then fresh[k] = id
            else
                local r = RollSetSlot(player, k, ex)
                if not r then   -- history exhausted this slot: allow earlier cards, but never the one on the table
                    local ex2 = {}
                    for _, cur in ipairs(ids) do ex2[cur] = true end
                    for _, f in pairs(fresh) do ex2[f] = true end
                    r = RollSetSlot(player, k, ex2)
                end
                fresh[k] = r or id
                ex[fresh[k]] = true
                hist[fresh[k]] = true
            end
        end
    else
        -- single karta: aktualnu vyluc, aby reroll nevratil to iste; a locked card stays
        if lockMask % 2 == 1 then
            player:SendBroadcastMessage("|cffffd200[Wildcard]|r The card is locked and stays. Unlock it to reroll.")
            return
        end
        local hist = SHOWN[guid] or {}
        SHOWN[guid] = hist
        hist[ids[1]] = true
        local ex1 = {}
        for h in pairs(hist) do ex1[h] = true end
        fresh = RollDraft(player, DRAFT_SIZE, IsTalent(ids[1]), ex1)
        if #fresh == 0 then fresh = RollDraft(player, DRAFT_SIZE, IsTalent(ids[1]), {[ids[1]] = true}) end
        if #fresh == 0 then fresh = ids end
        for _, f in ipairs(fresh) do hist[f] = true end   -- pool vycerpany: nechaj povodnu kartu
    end
    if #fresh == 0 then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r Nothing left to roll.")
        return
    end
    local left = free and st.charges or st.charges - 1
    DbPut(guid, left, table.concat(fresh, ","))
    AnnounceDraft(player, fresh, left)
    print("[wildcard] " .. player:GetName() .. " rerolled draft: " .. table.concat(ids, ",") .. " -> " .. table.concat(fresh, ",") .. " (lock mask " .. tostring(lockMask) .. ")")
end
-- ============================================================ prestahovanie na klony
-- POOL_MAP: retail ID -> vlastny klon (prestahovanie hracov po nasadeni klonov).
-- Generovane z pool_map.csv - needitovat rucne.
POOL_MAP = {[17]=1410000, [53]=1410001, [66]=1410002, [71]=1410003, [100]=1410004, [116]=1410005, [118]=1410006, [120]=1410007, [122]=1410008, [126]=1410009, [130]=1410010, [133]=1410011, [136]=1410012, [172]=1410013, [339]=1410014, [348]=1410015, [355]=1410016, [408]=1410017, [453]=1410018, [465]=1410019, [498]=1410020, [527]=1410021, [546]=1410022, [585]=1410023, [586]=1410024, [589]=1410025, [633]=1410026, [642]=1410027, [686]=1410028, [688]=1410029, [691]=1410030, [697]=1410031, [702]=1410032, [703]=1410033, [710]=1410034, [740]=1410035, [768]=1410036, [774]=1410037, [781]=1410038, [783]=1410039, [853]=1410040, [883]=1410041, [921]=1410042, [982]=1410043, [1022]=1410044, [1044]=1410045, [1064]=1410046, [1098]=1410047, [1126]=1410048, [1161]=1410049, [1178]=1410050, [1329]=1410051, [1449]=1410052, [1459]=1410053, [1462]=1410054, [1463]=1410055, [1464]=1410056, [1494]=1410057, [1515]=1410058, [1543]=1410059, [1680]=1410060, [1706]=1410061, [1715]=1410062, [1725]=1410063, [1752]=1410064, [1766]=1410065, [1784]=1410066, [1804]=1410067, [1833]=1410068, [1850]=1410069, [1856]=1410070, [1860]=1410071, [1943]=1410072, [1953]=1410073, [1966]=1410074, [2006]=1410075, [2008]=1410076, [2061]=1410077, [2094]=1410078, [2096]=1410079, [2098]=1410080, [2139]=1410081, [2484]=1410082, [2565]=1410083, [2641]=1410084, [2645]=1410085, [2823]=1410086, [2825]=1410087, [2836]=1410088, [2983]=1410089, [3127]=1410090, [3408]=1410091, [3411]=1410092, [3714]=1410093, [4987]=1410094, [5176]=1410095, [5221]=1410096, [5225]=1410097, [5246]=1410098, [5277]=1410099, [5301]=1410100, [5308]=1410101, [5384]=1410102, [5420]=1410103, [5421]=1410104, [5487]=1410105, [5502]=1410106, [5697]=1410107, [5761]=1410108, [5782]=1410109, [5938]=1410110, [6196]=1410111, [6197]=1410112, [6201]=1410113, [6544]=1410114, [6552]=1410115, [6673]=1410116, [6770]=1410117, [6795]=1410118, [6940]=1410119, [6991]=1410120, [7328]=1410121, [7744]=1410122, [8004]=1410123, [8122]=1410124, [8647]=1410125, [8676]=1410126, [8679]=1410127, [8921]=1410128, [8936]=1410129, [10326]=1410130, [10444]=1410131, [12042]=1410132, [12051]=1410133, [12846]=1410134, [13877]=1410135, [15286]=1410136, [15407]=1410137, [15487]=1410138, [16870]=1410139, [16949]=1410140, [16974]=1410141, [18499]=1410142, [19236]=1410143, [19750]=1410144, [19878]=1410145, [19879]=1410146, [19880]=1410147, [19882]=1410148, [19884]=1410149, [19885]=1410150, [20243]=1410151, [20271]=1410152, [20473]=1410153, [20484]=1410154, [20549]=1410155, [20572]=1410156, [20577]=1410157, [20589]=1410158, [20594]=1410159, [20608]=1410160, [20707]=1410161, [20711]=1410162, [20719]=1410163, [21178]=1410164, [21562]=1410165, [22568]=1410166, [22812]=1410167, [23920]=1410168, [23922]=1410169, [24275]=1410170, [25504]=1410171, [25780]=1410172, [26297]=1410173, [26573]=1410174, [28730]=1410175, [28880]=1410176, [29722]=1410177, [30449]=1410178, [30451]=1410179, [31209]=1410180, [31224]=1410181, [31884]=1410182, [32175]=1410183, [32182]=1410184, [32645]=1410185, [33076]=1410186, [33917]=1410187, [34428]=1410188, [34914]=1410189, [35395]=1410190, [36554]=1410191, [37846]=1410192, [44425]=1410193, [44448]=1410194, [45243]=1410195, [45438]=1410196, [45524]=1410197, [46584]=1410198, [46917]=1410199, [47540]=1410200, [47541]=1410201, [47585]=1410202, [48265]=1410203, [48707]=1410204, [48792]=1410205, [49039]=1410206, [49576]=1410207, [50769]=1410208, [51462]=1410209, [51490]=1410210, [51514]=1410211, [51667]=1410212, [51723]=1410213, [52127]=1410214, [52212]=1410215, [53270]=1410216, [53563]=1410217, [53600]=1410218, [53651]=1410219, [55078]=1410220, [55095]=1410221, [55342]=1410222, [56222]=1410223, [56384]=1410224, [56641]=1410225, [56814]=1410226, [57755]=1410227, [57934]=1410228, [57994]=1410229, [58875]=1410230, [58984]=1410231, [59057]=1410232, [59752]=1410233, [61391]=1410234, [61648]=1410235, [61999]=1410236, [62124]=1410237, [63733]=1410238, [66235]=1410239, [68992]=1410240, [69041]=1410241, [69070]=1410242, [73325]=1410243, [73899]=1410244, [76657]=1410245, [76671]=1410246, [76803]=1410247, [76806]=1410248, [76808]=1410249, [76856]=1410250, [76857]=1410251, [77130]=1410252, [77215]=1410253, [77219]=1410254, [77220]=1410255, [77223]=1410256, [77226]=1410257, [77472]=1410258, [77478]=1410259, [77485]=1410260, [77489]=1410261, [77493]=1410262, [77495]=1410263, [77513]=1410264, [77514]=1410265, [77515]=1410266, [77756]=1410267, [79096]=1410268, [80353]=1410269, [81099]=1410270, [81136]=1410271, [81229]=1410272, [81333]=1410273, [82326]=1410274, [83242]=1410275, [83243]=1410276, [83244]=1410277, [83245]=1410278, [85256]=1410279, [85288]=1410280, [85673]=1410281, [85948]=1410282, [86091]=1410283, [86092]=1410284, [86099]=1410285, [86101]=1410286, [86392]=1410287, [86629]=1410288, [86678]=1410289, [86704]=1410290, [88163]=1410291, [88423]=1410292, [89744]=1410293, [89745]=1410294, [93321]=1410295, [93375]=1410296, [94289]=1410297, [97462]=1410298, [100780]=1410299, [100784]=1410300, [101508]=1410301, [101545]=1410302, [101546]=1410303, [101643]=1410304, [102352]=1410305, [102401]=1410306, [102547]=1410307, [102794]=1410308, [104773]=1410309, [105805]=1410310, [106830]=1410311, [106898]=1410312, [107079]=1410313, [107500]=1410314, [108271]=1410315, [108366]=1410316, [109132]=1410317, [109304]=1410318, [111400]=1410319, [111771]=1410320, [113344]=1410321, [114014]=1410322, [114018]=1410323, [114089]=1410324, [114158]=1410325, [114165]=1410326, [114282]=1410327, [114911]=1410328, [115069]=1410329, [115098]=1410330, [115151]=1410331, [115178]=1410332, [115356]=1410333, [115450]=1410334, [115546]=1410335, [115636]=1410336, [115675]=1410337, [116092]=1410338, [116645]=1410339, [116670]=1410340, [117313]=1410341, [117418]=1410342, [117526]=1410343, [117906]=1410344, [117907]=1410345, [117952]=1410346, [119381]=1410347, [119650]=1410348, [119898]=1410349, [121039]=1410350, [121128]=1410351, [121183]=1410352, [122470]=1410353, [123829]=1410354, [123986]=1410355, [125050]=1410356, [125355]=1410357, [125883]=1410358, [126893]=1410359, [126895]=1410360, [127344]=1410361, [127757]=1410362, [127933]=1410363, [128595]=1410364, [130610]=1410365, [131347]=1410366, [131784]=1410367, [137005]=1410368, [137006]=1410369, [137007]=1410370, [137008]=1410371, [137009]=1410372, [137010]=1410373, [137011]=1410374, [137012]=1410375, [137013]=1410376, [137014]=1410377, [137015]=1410378, [137016]=1410379, [137017]=1410380, [137018]=1410381, [137019]=1410382, [137020]=1410383, [137021]=1410384, [137023]=1410385, [137024]=1410386, [137025]=1410387, [137026]=1410388, [137027]=1410389, [137028]=1410390, [137029]=1410391, [137030]=1410392, [137031]=1410393, [137032]=1410394, [137033]=1410395, [137034]=1410396, [137035]=1410397, [137036]=1410398, [137037]=1410399, [137038]=1410400, [137039]=1410401, [137040]=1410402, [137041]=1410403, [137042]=1410404, [137043]=1410405, [137044]=1410406, [137046]=1410407, [137047]=1410408, [137048]=1410409, [137049]=1410410, [137050]=1410411, [138430]=1410412, [145109]=1410413, [145205]=1410414, [155783]=1410415, [156287]=1410416, [157361]=1410417, [157442]=1410418, [161797]=1410419, [161862]=1410420, [162056]=1410421, [162487]=1410422, [162697]=1410423, [162698]=1410424, [162699]=1410425, [162700]=1410426, [162701]=1410427, [162702]=1410428, [162794]=1410429, [164815]=1410430, [164862]=1410431, [165962]=1410432, [168534]=1410433, [169340]=1410434, [175686]=1410435, [178819]=1410436, [178940]=1410437, [183435]=1410438, [183752]=1410439, [183997]=1410440, [184361]=1410441, [185123]=1410442, [185164]=1410443, [185245]=1410444, [185311]=1410445, [185313]=1410446, [185358]=1410447, [185438]=1410448, [185565]=1410449, [185763]=1410450, [186257]=1410451, [186265]=1410452, [186289]=1410453, [186440]=1410454, [186452]=1410455, [187394]=1410456, [187650]=1410457, [187828]=1410458, [188196]=1410459, [188443]=1410460, [188499]=1410461, [188501]=1410462, [189110]=1410463, [189926]=1410464, [190336]=1410465, [190427]=1410466, [190740]=1410467, [190778]=1410468, [190780]=1410469, [190784]=1410470, [190925]=1410471, [191034]=1410472, [191427]=1410473, [192063]=1410474, [192106]=1410475, [193265]=1410476, [193468]=1410477, [194466]=1410478, [194913]=1410479, [195072]=1410480, [195283]=1410481, [195292]=1410482, [195457]=1410483, [195645]=1410484, [196055]=1410485, [196586]=1410486, [196718]=1410487, [196770]=1410488, [196819]=1410489, [196884]=1410490, [196912]=1410491, [197147]=1410492, [197490]=1410493, [197692]=1410494, [197835]=1410495, [197911]=1410496, [198589]=1410497, [198793]=1410498, [199736]=1410499, [200652]=1410500, [200829]=1410501, [201467]=1410502, [201845]=1410503, [202138]=1410504, [202577]=1410505, [203413]=1410506, [203513]=1410507, [203524]=1410508, [203555]=1410509, [203720]=1410510, [203747]=1410511, [203783]=1410512, [204147]=1410513, [204596]=1410514, [205065]=1410515, [205154]=1410516, [205223]=1410517, [205273]=1410518, [205406]=1410519, [205495]=1410520, [205545]=1410521, [206478]=1410522, [207068]=1410523, [207317]=1410524, [207407]=1410525, [207778]=1410526, [207946]=1410527, [208065]=1410528, [208253]=1410529, [209202]=1410530, [209525]=1410531, [209577]=1410532, [209997]=1410533, [210000]=1410534, [210053]=1410535, [210086]=1410536, [210722]=1410537, [210726]=1410538, [211714]=1410539, [212036]=1410540, [212040]=1410541, [212048]=1410542, [212051]=1410543, [212056]=1410544, [212205]=1410545, [212611]=1410546, [212612]=1410547, [212613]=1410548, [212653]=1410549, [215279]=1410550, [215537]=1410551, [216519]=1410552, [216698]=1410553, [220143]=1410554, [227847]=1410555, [228264]=1410556, [228266]=1410557, [228477]=1410558, [228545]=1410559, [229533]=1410560, [231042]=1410561, [231065]=1410562, [231437]=1410563, [231602]=1410564, [231642]=1410565, [231691]=1410566, [232698]=1410567, [234153]=1410568, [236716]=1410569, [242155]=1410570, [245013]=1410571, [246985]=1410572, [252216]=1410573, [255260]=1410574, [255647]=1410575, [255654]=1410576, [256948]=1410577, [257284]=1410578, [257537]=1410579, [257620]=1410580, [258920]=1410581, [259398]=1410582, [260364]=1410583, [260708]=1410584, [263135]=1410585, [263642]=1410586, [265221]=1410587, [267316]=1410588, [271534]=1410589, [272651]=1410590, [274738]=1410591, [276012]=1410592, [278107]=1410593, [279423]=1410594, [280719]=1410595, [280752]=1410596, [287712]=1410597, [291944]=1410598, [294184]=1410599, [294189]=1410600, [300346]=1410601, [300349]=1410602, [304971]=1410603, [306830]=1410604, [307443]=1410605, [307865]=1410606, [308491]=1410607, [310143]=1410608, [310454]=1410609, [311648]=1410610, [312202]=1410611, [312321]=1410612, [312411]=1410613, [312924]=1410614, [314791]=1410615, [315341]=1410616, [315443]=1410617, [315496]=1410618, [315584]=1410619, [316239]=1410620, [316958]=1410621, [317009]=1410622, [317214]=1410623, [317349]=1410624, [319175]=1410625, [319836]=1410626, [320341]=1410627, [320380]=1410628, [320639]=1410629, [320747]=1410630, [320962]=1410631, [321297]=1410632, [321792]=1410633, [322101]=1410634, [322109]=1410635, [323546]=1410636, [323547]=1410637, [323673]=1410638, [323764]=1410639, [323999]=1410640, [324128]=1410641, [324143]=1410642, [324149]=1410643, [324386]=1410644, [324701]=1410645, [324724]=1410646, [324739]=1410647, [325013]=1410648, [325028]=1410649, [325216]=1410650, [325446]=1410651, [325554]=1410652, [325640]=1410653, [325727]=1410654, [326059]=1410655, [326434]=1410656, [326860]=1410657, [327104]=1410658, [327163]=1410659, [327661]=1410660, [328231]=1410661, [328305]=1410662, [328923]=1410663, [331180]=1410664, [334591]=1410665, [342245]=1410666, [343127]=1410667, [343140]=1410668, [343690]=1410669, [343731]=1410670, [344572]=1410671, [344859]=1410672, [346104]=1410673, [350570]=1410674, [353167]=1410675, [353367]=1410676, [354831]=1410677, [355913]=1410678, [356809]=1410679, [356810]=1410680, [356816]=1410681, [356995]=1410682, [357208]=1410683, [357210]=1410684, [357214]=1410685, [358267]=1410686, [358385]=1410687, [360823]=1410688, [361021]=1410689, [361178]=1410690, [361227]=1410691, [361469]=1410692, [362170]=1410693, [362969]=1410694, [362980]=1410695, [363510]=1410696, [363916]=1410697, [364342]=1410698, [365262]=1410699, [366222]=1410700, [368970]=1410701, [374721]=1410702, [376996]=1410703, [378776]=1410704, [381773]=1410705, [388023]=1410706, [390386]=1410707, [391054]=1410708, [393014]=1410709, [395153]=1410710, [396043]=1410711, [396186]=1410712, [396571]=1410713, [397527]=1410714, [397708]=1410715, [400006]=1410716, [404752]=1410717, [404834]=1410718, [405834]=1410719, [406041]=1410720, [406380]=1410721, [417191]=1410722, [417374]=1410723, [417382]=1410724, [417383]=1410725, [436344]=1410726, [440006]=1410727, [440008]=1410728, [440012]=1410729, [440013]=1410730, [440015]=1410731, [462854]=1410732, [466904]=1410733, [468146]=1410734, [470411]=1410735, [473662]=1410736}

-- Jednorazova (idempotentna) migracia hraca z retail ID na klony.
-- Bezi pri kazdom logine, ale po prvom prejdeni uz nema co robit.
-- Len Wildcard/Classless: Conquest kity ostavaju retail (tie riesi coa_kits.lua).
local function MigratePoolSpells(player)
    local path = GetPath(CharKey(player))
    if path ~= PATH_WILDCARD and path ~= PATH_CLASSLESS then return end
    local key = CharKey(player)
    -- 1. ulozene ability: retail -> klon (cena AE sa zachova)
    local ok, res = pcall(CharDBQuery, string.format(
        "SELECT spell, cost FROM characters.wildcard_classless WHERE name = '%s'", key))
    if ok and res then
        repeat
            local old, cost = res:GetUInt32(0), res:GetUInt32(1)
            local new = POOL_MAP[old]
            if new then
                pcall(CharDBExecute, string.format(
                    "DELETE FROM characters.wildcard_classless WHERE name = '%s' AND spell = %d", key, old))
                pcall(CharDBExecute, string.format(
                    "INSERT IGNORE INTO characters.wildcard_classless (name, spell, cost) VALUES ('%s', %d, %d)",
                    key, new, cost))
                if Knows(player, old) and not Knows(player, new) then
                    pcall(function() player:LearnSpell(new) end)
                end
                pcall(function() player:RemoveSpell(old) end)
            end
        until not res:NextRow()
    end
    -- 2. rozpracovany draft: retail ID -> klon
    local st = DbGet(key)
    local ids = ParseDraft(st.draft)
    if #ids > 0 then
        local changed = false
        for i, id in ipairs(ids) do
            if POOL_MAP[id] then ids[i] = POOL_MAP[id]; changed = true end
        end
        if changed then DbPut(key, st.charges, table.concat(ids, ",")) end
    end
end

-- One-time (idempotent) move of a hero from the old clones (1410xxx / 1470xxx) to the retail spells.
local function MigrateToRetail(player)
    local path = GetPath(CharKey(player))
    if path ~= PATH_WILDCARD and path ~= PATH_CLASSLESS then return end
    local key = CharKey(player)
    local ok, res = pcall(CharDBQuery, string.format("SELECT spell, cost FROM characters.wildcard_classless WHERE name = '%s'", key))
    if ok and res then
        local moves = {}
        repeat
            local old, cost = res:GetUInt32(0), res:GetUInt32(1)
            if CLONE_TO_RETAIL[old] then moves[#moves + 1] = {old, CLONE_TO_RETAIL[old], cost} end
        until not res:NextRow()
        for _, m in ipairs(moves) do
            pcall(CharDBExecute, string.format("DELETE FROM characters.wildcard_classless WHERE name = '%s' AND spell = %d", key, m[1]))
            pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.wildcard_classless (name, spell, cost) VALUES ('%s', %d, %d)", key, m[2], m[3]))
            if not Knows(player, m[2]) then pcall(function() player:LearnSpell(m[2]) end) end
            pcall(function() player:RemoveSpell(m[1]) end)
        end
    end
    local st = DbGet(key)
    local ids = ParseDraft(st.draft)
    local changed = false
    for i, id in ipairs(ids) do if CLONE_TO_RETAIL[id] then ids[i] = CLONE_TO_RETAIL[id]; changed = true end end
    if changed then DbPut(key, st.charges, table.concat(ids, ",")) end
end

-- Odmena za bossa: nahodne este neobjavene WORLD_DROPS kouzlo (teleport/mount).
-- Vola descend_world.lua z OnKill (rare/boss). Len pool hrdinovia, Conquest nie.
function WORLD_DROP_TryGive(player)
    if true then return end   -- travel and mount spells are learned at the Mystic Altar now (worldforge.lua), not from boss kills
    if not player or not WORLD_DROPS or #WORLD_DROPS == 0 then return end
    local path = GetPath(CharKey(player))
    if path ~= PATH_WILDCARD and path ~= PATH_CLASSLESS then return end
    local cand = {}
    for _, e in ipairs(WORLD_DROPS) do
        if not Knows(player, e[1]) then cand[#cand + 1] = e end
    end
    if #cand == 0 then return end
    local pick = cand[math.random(#cand)]
    pcall(function() player:LearnSpell(pick[1]) end)
    RememberHeroSpell(player, pick[1], 0)
    player:SendBroadcastMessage("|cffff8000[Hero]|r The fallen foe yields a lost art: "
        .. SpellLink(pick[1], pick[2], 5) .. "!")
end


-- Wildcard: forget an ability you no longer want and roll a fresh choice for its place (costs a reroll after FREE_REROLL_LEVEL).
local function ForgetAbility(player, id)
    HERO_Touch(player)
    local guid = CharKey(player)
    if GetPath(guid) ~= PATH_WILDCARD then return end
    local function Err(m) player:SendBroadcastMessage("|cffffd200[Wildcard]|r " .. m); SendClient(player, "ERR;" .. m) end
    local e = ById(id)
    if not e or IsTalent(id) or not Knows(player, id) then Err("You do not know that ability.") return end
    local st = DbGet(guid)
    if #ParseDraft(st.draft) > 0 then Err("Pick or reroll your pending choice first.") return end
    local free = true   -- unlimited rerolls
    if not free and st.charges <= 0 then Err("You need a reroll to forget an ability (you earn one every level).") return end
    pcall(function() player:RemoveSpell(id) end)
    pcall(CharDBExecute, string.format("DELETE FROM characters.wildcard_classless WHERE name = '%s' AND spell = %d", guid, id))
    pcall(function() player:RemoveActionButtonsForSpell(id) end)
    local fresh = RollDraft(player, LEVEL_CHOICES, false, {[id] = true})
    if #fresh == 0 then
        pcall(function() player:LearnSpell(id) end); RememberHeroSpell(player, id, 0)
        Err("Nothing else to roll, the ability was kept.")
        return
    end
    local left = free and st.charges or st.charges - 1
    DbPut(guid, left, table.concat(fresh, ","))
    player:SendBroadcastMessage("|cffffd200[Wildcard]|r You forgot " .. SpellLink(id, e[2], e[5]) .. ". Choose a new ability!")
    AnnounceDraft(player, fresh, left)
    SendClient(player, "BUILD;" .. "")
    print("[wildcard] " .. player:GetName() .. " forgot spell " .. id)
end

local function ShowBuild(player)
    local names = {}
    for _, e in ipairs(POOL) do
        local ok, has = pcall(function() return player:HasSpell(e[1]) end)
        if ok and has then names[#names + 1] = SpellLink(e[1], e[2], e[5]) end
    end
    if #names == 0 then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r Your wildcard spellbook is empty.")
        return
    end
    player:SendBroadcastMessage("|cffffd200[Wildcard]|r Your build (" .. #names .. "):")
    player:SendBroadcastMessage(table.concat(names, ", "))
end

local function ShowStatus(player)
    local guid = CharKey(player)
    local st = DbGet(guid)
    local ids = ParseDraft(st.draft)
    player:SendBroadcastMessage("|cffffd200[Wildcard]|r Owned: " .. OwnedCount(player) ..
        " / " .. #POOL .. "   Rerolls: " .. st.charges)
    if #ids > 0 then
        local parts = {}
        for i, id in ipairs(ids) do
            local e = ById(id)
            parts[#parts + 1] = "[" .. i .. "] " .. (e and e[2] or id)
        end
        player:SendBroadcastMessage("Pending draft: " .. table.concat(parts, "  ") .. "  (.wc pick N)")
    else
        player:SendBroadcastMessage("No pending draft.")
    end
end

local function ClasslessLearn(player, id)
    local e = ById(id)
    if not e then return false, "That ability is not in the Hero pool." end
    if player:GetLevel() < e[3] then return false, "Requires level " .. e[3] .. "." end
    if e[4] and e[4] ~= 0 and e[4] ~= player:GetRace() then return false, "Your race cannot learn that." end
    local okH, has = pcall(function() return player:HasSpell(id) end)
    if okH and has then return false, "You already know " .. e[2] .. "." end
    local cost = AE_COST[e[5] or 1] or 1
    if AEFree(player) < cost then return false, "Not enough Ability Essence (" .. cost .. " needed)." end
    pcall(function() player:LearnSpell(id) end)
    pcall(CharDBExecute, string.format("REPLACE INTO characters.wildcard_classless (name, spell, cost) VALUES ('%s', %d, %d)", CharKey(player), id, cost))
    player:SendBroadcastMessage(CTAG .. "Learned " .. SpellLink(id, e[2], e[5]) .. " for " .. cost .. " AE. Left: " .. AEFree(player) .. " AE.")
    SendClient(player, "LEARNED;" .. id)
    return true
end

local function ClasslessUnlearn(player, id)
    HERO_Touch(player)
    local key = CharKey(player)
    local cost = ClasslessOwned(key, id)
    if not cost then return false, "You did not buy that ability with Essence." end
    pcall(function() player:RemoveSpell(id) end)
    pcall(CharDBExecute, string.format("DELETE FROM characters.wildcard_classless WHERE name = '%s' AND spell = %d", key, id))
    local e = ById(id)
    player:SendBroadcastMessage(CTAG .. "Unlearned " .. (e and e[2] or id) .. ", refunded " .. cost .. " AE.")
    SendClient(player, "NONE;0")
    return true
end

local function ClasslessRespec(player)
    HERO_Touch(player)
    local key = CharKey(player)
    local ok, res = pcall(CharDBQuery, string.format("SELECT spell FROM characters.wildcard_classless WHERE name = '%s'", key))
    if ok and res then
        repeat
            local id = res:GetUInt32(0)
            pcall(function() player:RemoveSpell(id) end)
        until not res:NextRow()
    end
    pcall(CharDBExecute, string.format("DELETE FROM characters.wildcard_classless WHERE name = '%s'", key))
    player:SendBroadcastMessage(CTAG .. "All Essence refunded: " .. AEFree(player) .. " AE to spend.")
    SendClient(player, "NONE;0")
end

local function TalentLearn(player, id)
    local e = TALENT_BY_ID[id]
    if not e then return false, "That is not a Hero talent." end
    local owned = HeroTalents(CharKey(player))
    local why = TalentBlock(player, e, owned)
    if why then return false, why end
    if TEFree(player) < 1 then return false, "Not enough Talent Essence (you get 1 per level from " .. TALENT_START .. ")." end
    GiveTalent(player, id, 1)
    player:Data():Set("hero_attune", TalentRanks(player, "Essence Attunement"))
    player:SendBroadcastMessage(TTAG .. "Learned " .. SpellLink(id, e[2], e[5]) .. ". Talent Essence left: " .. TEFree(player) .. ".")
    SendClient(player, "LEARNED;" .. id)
    return true
end

local function TalentUnlearn(player, id)
    HERO_Touch(player)
    local key = CharKey(player)
    local owned = HeroTalents(key)
    local cost = owned[id]
    if not cost or cost == 0 then return false, "You did not buy that talent with Talent Essence." end
    for _, e in ipairs(TALENTS) do
        if e.prev == id and owned[e[1]] then return false, "Unlearn the higher rank first." end
    end
    pcall(function() player:RemoveSpell(id) end)
    pcall(CharDBExecute, string.format("DELETE FROM characters.hero_talents WHERE name = '%s' AND spell = %d", key, id))
    player:Data():Set("hero_attune", TalentRanks(player, "Essence Attunement"))
    local e = TALENT_BY_ID[id]
    player:SendBroadcastMessage(TTAG .. "Unlearned " .. (e and e[2] or id) .. ", refunded " .. cost .. " TE.")
    SendClient(player, "NONE;0")
    return true
end

local function TalentRespec(player)
    HERO_Touch(player)
    local key = CharKey(player)
    for id, cost in pairs(HeroTalents(key)) do
        if cost > 0 then pcall(function() player:RemoveSpell(id) end) end
    end
    pcall(CharDBExecute, string.format("DELETE FROM characters.hero_talents WHERE name = '%s' AND cost > 0", key))
    player:Data():Set("hero_attune", TalentRanks(player, "Essence Attunement"))
    player:SendBroadcastMessage(TTAG .. "Talents reset: " .. TEFree(player) .. " Talent Essence to spend.")
    SendClient(player, "NONE;0")
end

-- hero currency items (hero_items.lua): Ability Purge, Talent Purge, Dice of Destiny
function HERO_AbilityPurge(player)
    if GetPath(CharKey(player)) == PATH_CLASSLESS then ClasslessRespec(player) return true end
    return false, "Ability Purge only works for a Classless hero."
end
function HERO_TalentPurge(player)
    if GetPath(CharKey(player)) == PATH_NONE then return false, "Choose a Hero path first." end
    TalentRespec(player)
    return true
end
function HERO_DiceOfDestiny(player)
    if GetPath(CharKey(player)) ~= PATH_WILDCARD then return false, "The Dice of Destiny only work for a Wildcard hero." end
    local key = CharKey(player)
    local st = DbGet(key)
    DbPut(key, (st.charges or 0) + 5, st.draft)
    SendClient(player, "NONE;" .. ((st.charges or 0) + 5))
    player:SendBroadcastMessage("|cffff8000[Wildcard]|r The Dice of Destiny give you 5 more rerolls (" .. ((st.charges or 0) + 5) .. ").")
    if HERO_DraftWindow then pcall(HERO_DraftWindow, player) end
    return true
end

local function AskPath(player)
    SendClient(player, "CHOOSE")
    player:SendBroadcastMessage("|cffff8000[Hero]|r You are a Hero. Choose your path for good:")
    player:SendBroadcastMessage("  |cff00ccffClassless|r - buy any ability from any class with Ability Essence:  .path classless")
    player:SendBroadcastMessage("  |cffff8000Wildcard|r - the Dice of Destiny rolls your abilities:  .path wildcard")
    player:SendBroadcastMessage("  |cffc41e3aConquest|r - one of 21 Conquest of Azeroth classes:  .path conquest")
end

-- ---------------------------------------------------------------- Conquest of Azeroth (coa_kits.lua)
local COA_TAG = "|cffc41e3a[Conquest]|r "
local COA_MENU = 9900200
local COA_BY_KEY = {}
for _, c in ipairs(COA_CLASSES or {}) do COA_BY_KEY[c.key] = c end

local function GetCoa(key)
    local ok, res = pcall(CharDBQuery, string.format("SELECT class FROM characters.wildcard_coa WHERE name = '%s'", key))
    if ok and res then return COA_BY_KEY[res:GetString(0)] end
    return nil
end

local function LearnKit(player)
    local c = GetCoa(CharKey(player))
    if not c then return 0 end
    local n = 0
    for _, k in ipairs(c.kit) do
        if player:GetLevel() >= k[2] then
            local okH, has = pcall(function() return player:HasSpell(k[1]) end)
            if okH and not has then
                pcall(function() player:LearnSpell(k[1]) end)
                RememberHeroSpell(player, k[1], 0)
                local e = ById(k[1])
                player:SendBroadcastMessage(COA_TAG .. "New " .. c.name .. " ability: " .. SpellLink(k[1], e and e[2] or ("spell " .. k[1]), e and e[5]) .. ".")
                n = n + 1
            end
        end
    end
    return n
end

local function AskCoa(player)
    if HasUI(player) then       -- the addon shows the Conquest class window; without the addon the class menu is a gossip window
        SendClient(player, "COAASK")
        player:SendBroadcastMessage(COA_TAG .. "Choose your Conquest of Azeroth class in the window (or .coa <name>).")
        return
    end
    player:GossipClearMenu()
    for i, c in ipairs(COA_CLASSES or {}) do
        player:GossipMenuAddItem(0, "|cffc41e3a" .. c.name .. "|r - " .. c.desc, 0, i, false, "Become a " .. c.name .. " for good?")
    end
    player:GossipSendMenu(1, player, COA_MENU)
    player:SendBroadcastMessage(COA_TAG .. "Choose your Conquest of Azeroth class (or .coa <name>).")
end

local function ChooseCoa(player, c)
    local key = CharKey(player)
    if GetCoa(key) then player:SendBroadcastMessage(COA_TAG .. "Your class is already chosen.") return end
    pcall(CharDBExecute, string.format("REPLACE INTO characters.wildcard_coa (name, class) VALUES ('%s', '%s')", key, c.key))
    player:SendBroadcastMessage(COA_TAG .. "You are now a |cffc41e3a" .. c.name .. "|r. " .. c.desc)
    LearnKit(player)
end

local OnLogin  -- forward declaration: choosing Wildcard runs the Wildcard login flow


-- the starting set (STARTING_ABILITIES cards you keep) is offered ONCE per character; every later draft is the three-card level-up draft (pick one)
local function StartDone(guid)
    local ok, r = pcall(WorldDBQuery, string.format("SELECT v FROM world.lw_state WHERE k = 'wcstart:%s'", tostring(guid)))
    return ok and r ~= nil
end
local function MarkStartDone(guid) pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('wcstart:%s', '1')", tostring(guid))) end

local function ChoosePath(player, path)
    local key = CharKey(player)
    if GetPath(key) ~= PATH_NONE then
        player:SendBroadcastMessage("|cffff8000[Hero]|r Your path is already chosen.")
        return
    end
    if path ~= PATH_CLASSLESS and path ~= PATH_WILDCARD and path ~= PATH_CONQUEST then return end
    SetPath(key, path)
    print("[wildcard] " .. player:GetName() .. " chose path " .. path)
    EnterHero(player)
    if path ~= PATH_WILDCARD and HERO_Home then pcall(HERO_Home, player) end
    if path == PATH_CLASSLESS then
        player:SendBroadcastMessage(CTAG .. "You walk the Classless path. You have " .. AEFree(player) ..
            " Ability Essence. Open the Character Advancement panel (/ca) or use .cl learn <spellId>.")
        SendClient(player, "NONE;0")
    elseif path == PATH_CONQUEST then
        AskCoa(player)
    else
        OnLogin(nil, player)
    end
end

function OnLogin(event, player)
    if not ENABLED or not HasSQL() then return end
    local guid = CharKey(player)
    local path = GetPath(guid)
    if path == PATH_NONE then
        -- every character is a Hero from the start: no class spells even before the path is chosen
        StripClassSpells(player)
        AskPath(player)
        return
    end
    EnterHero(player)
    if path == PATH_CONQUEST then
        if not GetCoa(guid) then AskCoa(player) else LearnKit(player) end
        return
    end
    if path == PATH_CLASSLESS then
        local free = AEFree(player)
        if free > 0 then player:SendBroadcastMessage(CTAG .. "You have " .. free .. " Ability Essence to spend (/ca).") end
        return
    end
    local st = DbGet(guid)
    if st.fresh then
        DbPut(guid, 0, "")
        if player:GetLevel() <= START_MAX_LEVEL and OwnedCount(player) == 0 then
            -- a new Hero rolls its first abilities with the Dice (STARTING_ABILITIES rolls, one after another)
            local ids = StartCards(player)
            MarkStartDone(guid)
            DbPut(guid, CHARGES_PER_LEVEL, table.concat(ids, ","))
            player:SendBroadcastMessage("|cffffd200[Wildcard]|r The Dice of Destiny waits for you: pick one of three, " .. STARTING_ABILITIES .. " times, to build your starting abilities.")
            AnnounceDraft(player, ids, CHARGES_PER_LEVEL)
        else
            -- existing characters join the Wildcard system with a welcome draft
            local ids = RollDraft(player, LEVEL_CHOICES)
            MarkStartDone(guid)
            DbPut(guid, CHARGES_PER_LEVEL, table.concat(ids, ","))
            player:SendBroadcastMessage("|cffffd200[Wildcard]|r The Dice of Destiny has found you. Pick one of three:")
            AnnounceDraft(player, ids, CHARGES_PER_LEVEL)
        end
        return
    end
    local ids = ParseDraft(st.draft)
    if #ids == 0 and OwnedCount(player) < STARTING_ABILITIES and player:GetLevel() <= START_MAX_LEVEL and not StartDone(guid) then
        -- the starting rolls were never offered (one time only): the Dice waits with them
        MarkStartDone(guid)
        ids = StartCards(player)
        if #ids > 0 then DbPut(guid, CHARGES_PER_LEVEL, table.concat(ids, ",")); st.charges = CHARGES_PER_LEVEL end
    end
    if #ids > 0 then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r You still have an unpicked draft:")
        AnnounceDraft(player, ids, st.charges)
    end
end

-- ------------------------------------------------------------------ Golden Skill Cards and Hands of Fate
-- A Golden Skill Card (item 9750007, from bosses and mini bosses) reveals a random ability of Rare or better that you do not know; at your next level up
-- it is one of the cards on offer. A Hand of Fate (9750008) adds one card to every level up for good (two Hands at most).
local function LwGet(k)
    local ok, r = pcall(WorldDBQuery, string.format("SELECT v FROM world.lw_state WHERE k = '%s'", k))
    if ok and r then return r:GetString(0) end
    return nil
end
local function LwSet(k, v) pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('%s', '%s')", k, v)) end
local function CardList(player)
    local out = {}
    for x in string.gmatch(LwGet("card:" .. player:GetName()) or "", "%d+") do out[#out + 1] = tonumber(x) end
    return out
end
local function FateCount(player) return math.min(2, tonumber(LwGet("fate:" .. player:GetName()) or "0") or 0) end

function HERO_SkillCard(player)
    if GetPath(CharKey(player)) ~= PATH_WILDCARD then return false, "Skill Cards are for the Wildcard path." end
    local have = CardList(player)
    if #have >= 3 then return false, "You already hold three cards." end
    local lvl = player:GetLevel()
    local held = {}
    for _, x in ipairs(have) do held[x] = true end
    local cand = {}
    for _, e in ipairs(POOL) do
        if (e[5] or 1) >= 3 and (e[3] or 1) <= lvl + 8 and not held[e[1]] and not Knows(player, e[1]) and not IsTalent(e[1]) then cand[#cand + 1] = e end
    end
    if #cand == 0 then return false, "No card you could use at this level." end
    local pick = cand[math.random(#cand)]
    have[#have + 1] = pick[1]
    LwSet("card:" .. player:GetName(), table.concat(have, ","))
    player:SendBroadcastMessage("|cffffd200[Wildcard]|r The Golden Skill Card shows |cffffd200" .. pick[2] .. "|r. At your next level up it will be one of your cards.")
    return true
end
function HERO_HandOfFate(player)
    if GetPath(CharKey(player)) ~= PATH_WILDCARD then return false, "Hands of Fate are for the Wildcard path." end
    local n = FateCount(player)
    if n >= 2 then return false, "You already carry two Hands of Fate." end
    LwSet("fate:" .. player:GetName(), tostring(n + 1))
    player:SendBroadcastMessage("|cffffd200[Wildcard]|r A Hand of Fate guides you: " .. (LEVEL_CHOICES + n + 1) .. " cards at every level up.")
    return true
end
-- the cards a player holds replace the first cards of a fresh draft
local function ApplyCards(player, ids)
    local cards = CardList(player)
    if #cards == 0 then return ids end
    local out, used = {}, {}
    for _, c in ipairs(cards) do
        if not Knows(player, c) and #out < #ids then out[#out + 1] = c; used[c] = true end
    end
    for _, x in ipairs(ids) do if #out < #ids and not used[x] then out[#out + 1] = x end end
    LwSet("card:" .. player:GetName(), "")
    return out
end

local function OnLevelChange(event, player, oldLevel)
    if not ENABLED or not HasSQL() then return end
    local newLevel = player:GetLevel()
    if not newLevel or not oldLevel or newLevel <= oldLevel then return end
    if not Alive(player) then return end
    local guid = CharKey(player)
    local path = GetPath(guid)
    for _, ms in ipairs({500, 1500, 3500}) do
        player:RegisterEvent(function(_, _, _, p) if p then pcall(StripClassSpells, p); pcall(CleanClassButtons, p) end end, ms, 1)
    end
    player:RegisterEvent(function(_, _, _, p)
        if p and p:HasAura(HERO_AURA) then pcall(function() p:SetMaxPower(POWER_ALT, EssenceMaxFor(p)); p:SetPower(EssenceMaxFor(p), POWER_ALT) end) end
    end, 800, 1)
    if path == PATH_CLASSLESS then
        local te = newLevel >= TALENT_START and (" and " .. TEFree(player) .. " Talent Essence") or ""
        player:RegisterEvent(function(_, _, _, p) if p and HERO_Home then HERO_Home(p) end end, 2500, 1)
        player:SendBroadcastMessage(CTAG .. "Level " .. newLevel .. "! You have " .. AEFree(player) .. " Ability Essence" .. te .. " (/ca).")
        SendClient(player, "NONE;0")
        return
    elseif path == PATH_CONQUEST then
        player:RegisterEvent(function(_, _, _, p) if p then LearnKit(p) end end, 2000, 1)
        if newLevel >= TALENT_START then
            player:SendBroadcastMessage(COA_TAG .. "Level " .. newLevel .. "! Talent Essence: " .. TEFree(player) .. ".")
            player:RegisterEvent(function(_, _, _, p) if p and HERO_Home then HERO_Home(p) end end, 3000, 1)
        end
        return
    elseif path ~= PATH_WILDCARD then
        return
    end
    local st = DbGet(guid)
    if #ParseDraft(st.draft) > 0 then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r Unpicked draft replaced by a fresh level " ..
            newLevel .. " roll.")
    end
    local talentRoll = newLevel >= TALENT_START and newLevel % 2 == 0
    local ids
    if talentRoll then
        local n = math.min(6, LEVEL_CHOICES + FateCount(player))
        ids = RollDraft(player, n, talentRoll)
        if #ids < n then   -- never fewer than the usual cards: top up with abilities when the talent pool runs short
            local ex = {}
            for _, x in ipairs(ids) do ex[x] = true end
            for _, x in ipairs(RollDraft(player, n - #ids, false, ex)) do ids[#ids + 1] = x end
        end
    else
        -- the role rotates with the level (o/d/m/h/b/c/u): the three cards share it, the pool falls back to any ability
        local role = LEVEL_ROLES[(newLevel % #LEVEL_ROLES) + 1]
        local want = math.min(6, LEVEL_CHOICES + FateCount(player))
        ids = RollDraft(player, want, false, nil, role)
        if #ids < want then
            local ex = {}
            for _, x in ipairs(ids) do ex[x] = true end
            for _, x in ipairs(RollDraft(player, want - #ids, false, ex)) do ids[#ids + 1] = x end
        end
    end
    ids = ApplyCards(player, ids)
    DbPut(guid, CHARGES_PER_LEVEL, table.concat(ids, ","))
    if #ids > 0 and IsTalent(ids[1]) then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r Level " .. newLevel .. ": the Dice of Destiny rolls a |cffb048f8talent|r.")
    end
    AnnounceDraft(player, ids, CHARGES_PER_LEVEL)
    print("[wildcard] level " .. newLevel .. " draft for " .. player:GetName())
end

local function OnCommand(event, player, command)
    if not ENABLED then return end
    local args = {}
    for w in string.gmatch(string.lower(command or ""), "%S+") do
        args[#args + 1] = w
    end
    if args[1] == "ca" or args[1] == "hero" then
        if HERO_Home then HERO_Home(player) end
        return false
    end
    if args[1] == "path" then
        if not args[2] and GetPath(CharKey(player)) == PATH_NONE and HERO_PathWindow then HERO_PathWindow(player) return false end
        if args[2] == "classless" then ChoosePath(player, PATH_CLASSLESS)
        elseif args[2] == "wildcard" then ChoosePath(player, PATH_WILDCARD)
        elseif args[2] == "conquest" then ChoosePath(player, PATH_CONQUEST)
        else AskPath(player) end
        return false
    end
    if args[1] == "coa" then
        if GetPath(CharKey(player)) ~= PATH_CONQUEST then player:SendBroadcastMessage(COA_TAG .. "Only Conquest heroes pick a class. (.path conquest)") return false end
        local want = table.concat(args, "", 2)
        for _, c in ipairs(COA_CLASSES or {}) do
            if c.key == want or string.lower(string.gsub(c.name, "[^%a]", "")) == want then ChooseCoa(player, c) return false end
        end
        AskCoa(player)
        return false
    end
    if args[1] == "cl" or args[1] == "classless" then
        if GetPath(CharKey(player)) ~= PATH_CLASSLESS then
            player:SendBroadcastMessage(CTAG .. "Only Classless heroes buy abilities. (.path)")
            return false
        end
        local id = tonumber(args[3] or "")
        local ok, err = true, nil
        if args[2] == "learn" and id then ok, err = ClasslessLearn(player, id)
        elseif args[2] == "unlearn" and id then ok, err = ClasslessUnlearn(player, id)
        elseif args[2] == "respec" then ClasslessRespec(player)
        elseif args[2] == "talent" and id then ok, err = TalentLearn(player, id)
        elseif args[2] == "untalent" and id then ok, err = TalentUnlearn(player, id)
        elseif args[2] == "trespec" then TalentRespec(player)
        else player:SendBroadcastMessage(CTAG .. "AE: " .. AEFree(player) .. "/" .. AETotal(player) ..
            ".  .cl learn <spellId>  .cl unlearn <spellId>  .cl respec") end
        if not ok and err then player:SendBroadcastMessage(CTAG .. err) end
        return false
    end
    if args[1] ~= "wc" and args[1] ~= "wildcard" then return end
    if not HasSQL() then
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r System unavailable (no CharDB access).")
        return false
    end
    local sub = args[2]
    if sub == "pick" then
        LearnDraftPick(player, tonumber(args[3]))
    elseif sub == "keep" or sub == "take" or sub == "all" then
        LearnAllDraft(player)
    elseif sub == "reroll" then
        RerollDraft(player)
    elseif sub == "build" then
        ShowBuild(player)
    elseif sub == "status" then
        ShowStatus(player)
    elseif not sub then
        if HERO_DraftWindow then HERO_DraftWindow(player) end
    else
        player:SendBroadcastMessage("|cffffd200[Wildcard]|r Commands: .wc (window)  .wc pick 1  .wc keep (take all)  .wc reroll  .wc build  .wc status   .ca Character Advancement")
    end
    return false -- handled, hide "unknown command"
end

local function OnAddonMessage(event, sender, msgType, prefix, msg, target)
    if prefix ~= UI_PREFIX or not ENABLED then return end
    local ok, isPlayer = pcall(function() return sender:GetGUIDLow() ~= nil and sender.LearnSpell ~= nil end)
    if not ok or not isPlayer then return end
    local kind, arg = string.match(msg or "", "^(%a+);?(%d*)")
    local path = GetPath(CharKey(sender))
    if kind == "UI" then
        SetUI(sender, true)
        return
    elseif kind == "BUG" then
        local text, client = string.match(msg or "", "^BUG;([^;]*);?(.*)$")
        if BUG_Report then pcall(BUG_Report, sender, text or "", client or "") end
        return
    elseif kind == "FX" then
        -- the level-up glow when a roll starts (cosmetic spell, no level is given)
        pcall(function() sender:RemoveAura(24312) end)   -- the old Level Up aura also scales the character
        pcall(function() sender:CastSpell(sender, 47292, true) end)
        return
    elseif kind == "BAD" then
        local list = string.match(msg or "", "^BAD;([%d,]+)")
        local hit = false
        local st0 = DbGet(CharKey(sender))
        local cur = ParseDraft(st0.draft)
        for sid in string.gmatch(list or "", "%d+") do
            pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('bad:%s', '1')", sid))
            for _, c in ipairs(cur) do if c == tonumber(sid) then hit = true end end
        end
        if hit and path == PATH_WILDCARD and #cur > 1 then
            -- starting set: only the unknown slots are rolled again
            local badIds = {}
            for sid in string.gmatch(list or "", "%d+") do badIds[tonumber(sid)] = true end
            local ex = {}
            for _, c in ipairs(cur) do ex[c] = true end
            local fresh = {}
            for k, c in ipairs(cur) do
                if badIds[c] then
                    local r = RollDraft(sender, 1, false, ex)[1]
                    fresh[k] = r or c
                    if r then ex[r] = true end
                else fresh[k] = c end
            end
            DbPut(CharKey(sender), st0.charges, table.concat(fresh, ","))
            AnnounceDraft(sender, fresh, st0.charges)
        elseif hit and path == PATH_WILDCARD and #cur > 0 then
            local fresh = RollDraft(sender, DRAFT_SIZE, IsTalent(cur[1]))
            if #fresh > 0 then
                DbPut(CharKey(sender), st0.charges, table.concat(fresh, ","))
                AnnounceDraft(sender, fresh, st0.charges)
            end
        end
        return
    elseif kind == "CHOOSE" then
        ChoosePath(sender, tonumber(arg))
        return
    elseif kind == "COA" then
        if GetPath(CharKey(sender)) ~= PATH_CONQUEST then return end
        for _, c in ipairs(COA_CLASSES or {}) do
            if c.key == arg then ChooseCoa(sender, c) break end
        end
        return
    elseif kind == "LEARN" or kind == "UNLEARN" then
        if path ~= PATH_CLASSLESS then return end
        local ok, err
        if kind == "LEARN" then ok, err = ClasslessLearn(sender, tonumber(arg) or 0)
        else ok, err = ClasslessUnlearn(sender, tonumber(arg) or 0) end
        if not ok and err then sender:SendBroadcastMessage(CTAG .. err); SendClient(sender, "ERR;" .. err) end
        return
    elseif kind == "RESPEC" then
        if path == PATH_CLASSLESS then ClasslessRespec(sender) end
        return
    elseif kind == "TLEARN" or kind == "TUNLEARN" then
        if path ~= PATH_CLASSLESS and path ~= PATH_CONQUEST then return end
        local ok, err
        if kind == "TLEARN" then ok, err = TalentLearn(sender, tonumber(arg) or 0)
        else ok, err = TalentUnlearn(sender, tonumber(arg) or 0) end
        if not ok and err then sender:SendBroadcastMessage(TTAG .. err); SendClient(sender, "ERR;" .. err) end
        return
    elseif kind == "TRESPEC" then
        if path == PATH_CLASSLESS or path == PATH_CONQUEST then TalentRespec(sender) end
        return
    end
    if kind == "HELLO" then
        SetUI(sender, true)
        RestoreHeroSpells(sender)
        if path == PATH_NONE then AskPath(sender) return end
        if path == PATH_CLASSLESS then SendClient(sender, "NONE;0") return end
        local st = DbGet(CharKey(sender))
        SendDraftUI(sender, ParseDraft(st.draft), st.charges)
    elseif kind == "PICK" then
        -- PICK;<index>;<spell the client showed>: never learn something else than what was on screen
        local _, sid = string.match(msg or "", "^PICK;(%d+);(%d+)")
        local ids = ParseDraft(DbGet(CharKey(sender)).draft)
        if sid and tonumber(sid) ~= 0 and ids[tonumber(arg) or 1] ~= tonumber(sid) then
            -- the stored draft moved on: honour the spell that was on screen if it really was offered to this player
            local offered = false
            local okO, res = pcall(WorldDBQuery, string.format("SELECT v FROM world.lw_state WHERE k = 'offer:%s'", sender:GetName()))
            if okO and res then for x in string.gmatch(res:GetString(0), "%d+") do if tonumber(x) == tonumber(sid) then offered = true end end end
            if offered and not Knows(sender, tonumber(sid)) then
                LearnDraftPick(sender, 1, tonumber(sid))
                return
            end
            SendDraftUI(sender, ids, DbGet(CharKey(sender)).charges)   -- out of date: show the real roll
            return
        end
        LearnDraftPick(sender, tonumber(arg))
    elseif kind == "FORGET" then
        ForgetAbility(sender, tonumber(arg) or 0)
    elseif kind == "REROLL" then
        RerollDraft(sender, tonumber(string.match(msg or "", "^REROLL;(%d+)")) or 0)
    elseif kind == "KEEPALL" then
        -- the starting set: keep every ability that is on screen (shared with .wc keep)
        if path ~= PATH_WILDCARD then return end
        do   -- the client says which cards it shows; if the stored draft is shorter, trust the screen (starting set only)
            local shown = {}
            for sid in string.gmatch(string.match(msg or "", "^KEEPALL;(.*)$") or "", "%d+") do shown[#shown + 1] = tonumber(sid) end
            local stK = DbGet(CharKey(sender))
            local cur = ParseDraft(stK.draft)
            print("[wildcard] " .. sender:GetName() .. " KEEPALL draft=" .. #cur .. " shown=" .. #shown)
            if #shown > #cur and #shown <= STARTING_ABILITIES and OwnedCount(sender) == 0 then
                local ok = true
                for _, id in ipairs(shown) do if not ById(id) then ok = false end end
                if ok then DbPut(CharKey(sender), stK.charges, table.concat(shown, ",")) end
            end
        end
        LearnAllDraft(sender)
        local st = DbGet(CharKey(sender))
        SendClient(sender, "NONE;" .. st.charges)
    elseif kind == "LIST" then
        -- Character Advancement panel: the whole pool, the player's build and state.
        -- Addon messages are capped at 255 bytes, so the pool goes out in chunks.
        local chunk, n, n2 = {}, 0, 0
        for _, e in ipairs(POOL) do
            chunk[#chunk + 1] = e[1] .. ":" .. e[3] .. ":" .. (e[5] or 1) .. ":" .. (SPELL_CLASS[e[1]] or 0) .. ":" .. (SPELL_ROLE[e[1]] or "u")
            if #chunk == 12 then
                n = n + 1
                SendClient(sender, "POOL;" .. n .. ";" .. table.concat(chunk, ","))
                chunk = {}
            end
        end
        if #chunk > 0 then n = n + 1; SendClient(sender, "POOL;" .. n .. ";" .. table.concat(chunk, ",")) end
        local owned = {}
        for _, e in ipairs(POOL) do
            local okH, has = pcall(function() return sender:HasSpell(e[1]) end)
            if okH and has then owned[#owned + 1] = e[1] end
        end
        for i = 1, #owned, 20 do
            SendClient(sender, "BUILD;" .. table.concat(owned, ",", i, math.min(i + 19, #owned)))
        end
        -- talents: id:level:rarity:prev:req1/req2
        chunk = {}
        for _, e in ipairs(TALENTS) do
            chunk[#chunk + 1] = e[1] .. ":" .. e[3] .. ":" .. (e[5] or 1) .. ":" .. (e.prev or 0) .. ":" .. (e.req and table.concat(e.req, "/") or "") .. ":" .. (SPELL_CLASS[e[1]] or 0)
            if #chunk == 5 then
                n2 = n2 + 1
                SendClient(sender, "TAL;" .. n2 .. ";" .. table.concat(chunk, ","))
                chunk = {}
            end
        end
        if #chunk > 0 then n2 = n2 + 1; SendClient(sender, "TAL;" .. n2 .. ";" .. table.concat(chunk, ",")) end
        local tl = {}
        for id in pairs(HeroTalents(CharKey(sender))) do tl[#tl + 1] = id end
        for i = 1, #tl, 20 do
            SendClient(sender, "TBUILD;" .. table.concat(tl, ",", i, math.min(i + 19, #tl)))
        end
        local st = DbGet(CharKey(sender))
        SendClient(sender, "STATE;" .. sender:GetLevel() .. ";" .. st.charges .. ";" .. #ParseDraft(st.draft) .. ";" .. n ..
            ";" .. path .. ";" .. AEFree(sender) .. ";" .. AETotal(sender) .. ";" .. TEFree(sender) .. ";" .. TETotal(sender))
    end
end

-- Fortuna Fatecaller gossip UI (entry 95000): clickable draft, no commands.
local FORTUNA_ENTRY = 95000
local FORTUNA_TEXT = 95000

local function FortunaShow(player, creature)
    player:GossipClearMenu()
    local st = DbGet(CharKey(player))
    local ids = ParseDraft(st.draft)
    if #ids > 0 then
        for i, id in ipairs(ids) do
            local e = ById(id)
            player:GossipMenuAddItem(0, "Accept: |c" .. RARITY[e and e[5] or 1].color .. (e and e[2] or ("spell " .. id)) .. "|r (" .. RARITY[e and e[5] or 1].name .. ")", 0, i)
        end
        player:GossipMenuAddItem(0, "Reroll the dice (" .. st.charges .. " left)", 0, 10)
    else
        player:GossipMenuAddItem(0, "No pending draft. Level up to roll.", 0, 0)
    end
    player:GossipMenuAddItem(0, "Show my build.", 0, 20)
    player:GossipSendMenu(FORTUNA_TEXT, creature)
end

local function FortunaHello(event, player, creature)
    FortunaShow(player, creature)
end

local function FortunaSelect(event, player, creature, sender, intid, code, menu_id)
    if intid and intid >= 1 and intid <= DRAFT_SIZE then
        LearnDraftPick(player, intid)
    elseif intid == 10 then
        RerollDraft(player)
    elseif intid == 20 then
        ShowBuild(player)
    end
    FortunaShow(player, creature)
end

-- Rebirth (progression.lua): forget the whole Hero build, then start over at level 1.
function HERO_ResetForRebirth(player)
    local key = CharKey(player)
    local ok, res = pcall(CharDBQuery, string.format("SELECT spell FROM characters.wildcard_classless WHERE name = '%s'", key))
    if ok and res then repeat pcall(function() player:RemoveSpell(res:GetUInt32(0)) end) until not res:NextRow() end
    for id in pairs(HeroTalents(key)) do pcall(function() player:RemoveSpell(id) end) end
    for _, e in ipairs(POOL) do pcall(function() player:RemoveSpell(e[1]) end) end
    pcall(CharDBExecute, string.format("DELETE FROM characters.wildcard_classless WHERE name = '%s'", key))
    pcall(CharDBExecute, string.format("DELETE FROM characters.hero_talents WHERE name = '%s'", key))
    pcall(CharDBExecute, string.format("DELETE FROM characters.wildcard_state WHERE name = '%s'", key))
    OnLogin(nil, player)
end

-- ---------------------------------------------------------------- in-game windows (no addon needed)
-- Every Hero screen also works as a normal dialog window (gossip sent by the player
-- to themselves): path choice, the Dice of Destiny roll, Character Advancement
-- (.ca / .hero): abilities, talents, Mystic Enchants. The client addon is optional.
local UI_MENU = 9900210
local PAGE = 8
local A_PATH, A_PATHINFO, A_KEEP, A_REROLL, A_LATER = 1, 2, 3, 4, 5
local A_ABIL, A_TAL, A_MYS, A_MYABIL, A_MYTAL, A_LEARN, A_UNLEARN, A_TLEARN, A_TUNLEARN, A_MTOGGLE, A_PAGE, A_HOME, A_CLOSE, A_RESPEC, A_TRESPEC =
    10, 11, 12, 13, 14, 20, 21, 22, 23, 24, 30, 31, 32, 33, 34
local UI = {}   -- player name -> {view, page}

local function Enc(action, arg) return action * 1000000 + (arg or 0) end
local function Dec(intid) return math.floor(intid / 1000000), intid % 1000000 end
local function Rar(r) local x = RARITY[r or 1] or RARITY[1]; return "|c" .. x.color .. x.name .. "|r" end
local function Name(id) local e = ById(id); return e and e[2] or ("Spell " .. id) end

local function Send(player, title)
    player:GossipSendMenu(1, player, UI_MENU)
    if title then player:SendBroadcastMessage(title) end
end

function HERO_PathWindow(player)
    if HasUI(player) then SendClient(player, "CHOOSE") return end
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "|cff00ccffClassless|r - buy exactly the abilities you want from every class with Ability Essence.", 0, Enc(A_PATH, PATH_CLASSLESS), false,
        "Walk the Classless path for good?")
    player:GossipMenuAddItem(0, "|cffff8000Wildcard|r - the Dice of Destiny rolls a random ability every level. Keep it or reroll.", 0, Enc(A_PATH, PATH_WILDCARD), false,
        "Walk the Wildcard path for good?")
    player:GossipMenuAddItem(0, "|cffc41e3aConquest|r - become one of 21 Conquest of Azeroth classes (Necromancer, Tinker, Reaper...).", 0, Enc(A_PATH, PATH_CONQUEST), false,
        "Walk the Conquest path for good?")
    player:GossipMenuAddItem(0, "Tell me more about the paths.", 0, Enc(A_PATHINFO))
    Send(player, "|cffff8000[Hero]|r Choose your path in the window. (.path opens it again)")
end

function HERO_DraftWindow(player)
    local st = DbGet(CharKey(player))
    local ids = ParseDraft(st.draft)
    if HasUI(player) then SendDraftUI(player, ids, st.charges) return end
    player:GossipClearMenu()
    if #ids == 0 then
        player:GossipMenuAddItem(0, "No roll waiting. The Dice rolls again at your next level.", 0, Enc(A_CLOSE))
    else
        local id = ids[1]
        local e = ById(id)
        player:GossipMenuAddItem(0, "|cffffd200The Dice of Destiny rolls:|r " .. Name(id) .. "  (" .. Rar(e and e[5]) .. (IsTalent(id) and ", talent" or "") .. ")", 0, Enc(A_KEEP, 1))
        player:GossipMenuAddItem(0, "Keep it - learn " .. Name(id) .. ".", 0, Enc(A_KEEP, 1))
        if st.charges > 0 then player:GossipMenuAddItem(0, "Reroll (" .. st.charges .. " left this level).", 0, Enc(A_REROLL)) end
        player:GossipMenuAddItem(0, "Decide later (.wc).", 0, Enc(A_LATER))
    end
    Send(player)
end

local function Header(player, path)
    if path == PATH_CLASSLESS then return "Ability Essence " .. AEFree(player) .. "/" .. AETotal(player) .. ", Talent Essence " .. TEFree(player) .. "/" .. TETotal(player) end
    if path == PATH_CONQUEST then return "Talent Essence " .. TEFree(player) .. "/" .. TETotal(player) end
    return "Wildcard hero"
end

local function Home(player)
    local path = GetPath(CharKey(player))
    if path == PATH_NONE then HERO_PathWindow(player) return end
    if HasUI(player) then SendClient(player, "OPEN;home") return end
    UI[player:GetName()] = {view = "home", page = 1}
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "|cffffd100Character Advancement|r - " .. Header(player, path), 0, Enc(A_HOME))
    if path == PATH_CLASSLESS then player:GossipMenuAddItem(0, "Learn abilities", 0, Enc(A_ABIL, 1)) end
    player:GossipMenuAddItem(0, "My abilities", 0, Enc(A_MYABIL, 1))
    if path ~= PATH_WILDCARD then player:GossipMenuAddItem(0, "Learn talents", 0, Enc(A_TAL, 1)) end
    player:GossipMenuAddItem(0, "My talents", 0, Enc(A_MYTAL, 1))
    player:GossipMenuAddItem(0, "Mystic Enchants", 0, Enc(A_MYS, 1))
    if path == PATH_WILDCARD then player:GossipMenuAddItem(0, "My Dice of Destiny roll", 0, Enc(A_LATER + 100)) end
    if path == PATH_CLASSLESS then player:GossipMenuAddItem(0, "Reset abilities (free)", 0, Enc(A_RESPEC), false, "Unlearn every Classless ability and get all Ability Essence back?") end
    if path ~= PATH_WILDCARD then player:GossipMenuAddItem(0, "Reset talents (free)", 0, Enc(A_TRESPEC), false, "Unlearn every Hero talent and get all Talent Essence back?") end
    Send(player)
end
HERO_Home = Home

local function Paged(player, list, page, action, label, nav)
    local pages = math.max(1, math.ceil(#list / PAGE))
    page = math.min(math.max(1, page), pages)
    player:GossipClearMenu()
    for i = (page - 1) * PAGE + 1, math.min(#list, page * PAGE) do
        local it = list[i]
        player:GossipMenuAddItem(0, it.text, 0, Enc(action, it.id), false, it.popup)
    end
    if page < pages then player:GossipMenuAddItem(0, "Next page (" .. (page + 1) .. "/" .. pages .. ")", 0, Enc(A_PAGE, (nav * 1000) + page + 1)) end
    if page > 1 then player:GossipMenuAddItem(0, "Previous page", 0, Enc(A_PAGE, (nav * 1000) + page - 1)) end
    player:GossipMenuAddItem(0, "<< Back", 0, Enc(A_HOME))
    UI[player:GetName()] = {view = label, page = page}
    Send(player)
end

local VIEWS = {}
VIEWS[1] = function(player, page)   -- learnable abilities (Classless)
    local list, lvl, race = {}, player:GetLevel(), player:GetRace()
    for _, e in ipairs(POOL) do
        if e[3] <= lvl and (not e[4] or e[4] == 0 or e[4] == race) then
            local okH, has = pcall(function() return player:HasSpell(e[1]) end)
            if okH and not has then
                local cost = AE_COST[e[5] or 1] or 1
                list[#list + 1] = {id = e[1], text = e[2] .. "  (" .. Rar(e[5]) .. ", " .. cost .. " AE)", popup = "Learn " .. e[2] .. " for " .. cost .. " Ability Essence?"}
            end
        end
    end
    table.sort(list, function(a, b) return a.text < b.text end)
    Paged(player, list, page, A_LEARN, "abil", 1)
end
VIEWS[2] = function(player, page)   -- owned abilities
    local list, key = {}, CharKey(player)
    for _, e in ipairs(POOL) do
        local okH, has = pcall(function() return player:HasSpell(e[1]) end)
        if okH and has then
            local cost = ClasslessOwned(key, e[1])
            list[#list + 1] = {id = e[1], text = e[2] .. "  (" .. Rar(e[5]) .. ")" .. ((cost and cost > 0) and "  - click to unlearn" or ""),
                popup = (cost and cost > 0) and ("Unlearn " .. e[2] .. " and get " .. cost .. " Ability Essence back?") or nil}
        end
    end
    Paged(player, list, page, A_UNLEARN, "myabil", 2)
end
VIEWS[3] = function(player, page)   -- learnable talents
    local list, owned = {}, HeroTalents(CharKey(player))
    for _, e in ipairs(TALENTS) do
        if not TalentBlock(player, e, owned) then
            list[#list + 1] = {id = e[1], text = e[2] .. "  (" .. Rar(e[5]) .. ", 1 TE)", popup = "Learn the talent " .. e[2] .. " for 1 Talent Essence?"}
        end
    end
    table.sort(list, function(a, b) return a.text < b.text end)
    Paged(player, list, page, A_TLEARN, "tal", 3)
end
VIEWS[4] = function(player, page)   -- owned talents
    local list = {}
    for id, cost in pairs(HeroTalents(CharKey(player))) do
        local e = TALENT_BY_ID[id]
        list[#list + 1] = {id = id, text = (e and e[2] or id) .. ((cost > 0) and "  - click to unlearn" or ""),
            popup = (cost > 0) and ("Unlearn " .. (e and e[2] or id) .. " and get 1 Talent Essence back?") or nil}
    end
    table.sort(list, function(a, b) return a.text < b.text end)
    Paged(player, list, page, A_TUNLEARN, "mytal", 4)
end
VIEWS[5] = function(player, page)   -- Mystic Enchants
    if not MYS_GetList then return Home(player) end
    local col, used, slots = MYS_GetList(player)
    local list = {}
    for _, m in ipairs(col) do
        list[#list + 1] = {id = m.id, text = (m.active and "|cff00a000[ON]|r " or "") .. m.name .. "  (" .. Rar(math.min(4, m.q)) .. ")"}
    end
    if #list == 0 then list[1] = {id = 0, text = "No Mystic Enchants yet - find Mystic Scrolls in the world."} end
    player:SendBroadcastMessage("|cffa335ee[Mystic]|r Active " .. used .. " / " .. slots .. ". Click an enchant to turn it on or off.")
    Paged(player, list, page, A_MTOGGLE, "mys", 5)
end

local function Select(event, player, _, sender, intid)
    local action, arg = Dec(intid)
    local function Again(view) local u = UI[player:GetName()] or {page = 1}; VIEWS[view](player, u.page or 1) end
    local function Report(ok, err) if not ok and err then player:SendBroadcastMessage("|cffff8000[Hero]|r " .. err) end end
    if action == A_PATH then player:GossipComplete(); ChoosePath(player, arg)
    elseif action == A_PATHINFO then
        player:SendBroadcastMessage("|cff00ccff[Classless]|r 3 Ability Essence at level 1, +1 every level from 4. Abilities cost 1-5 by rarity. Unlearn any time for a refund.")
        player:SendBroadcastMessage("|cffff8000[Wildcard]|r 6 abilities at level 1 (2 offensive, 2 defensive, mobility, utility) and a new roll every level; 3 rerolls per level. From level 10 even levels roll talents.")
        player:SendBroadcastMessage("|cffc41e3a[Conquest]|r Pick one of 21 Conquest of Azeroth classes; its abilities come as you level.")
        player:SendBroadcastMessage("|cffb048f8[Talents]|r Every path earns Talent Essence from level 10. Your class becomes a body only: all abilities come from the Hero pool and use Hero Essence.")
        HERO_PathWindow(player)
    elseif action == A_KEEP then LearnDraftPick(player, 1); HERO_DraftWindow(player)
    elseif action == A_REROLL then RerollDraft(player); HERO_DraftWindow(player)
    elseif action == A_LATER then player:GossipComplete()
    elseif action == A_LATER + 100 then HERO_DraftWindow(player)
    elseif action == A_HOME then Home(player)
    elseif action == A_ABIL then VIEWS[1](player, arg)
    elseif action == A_MYABIL then VIEWS[2](player, arg)
    elseif action == A_TAL then VIEWS[3](player, arg)
    elseif action == A_MYTAL then VIEWS[4](player, arg)
    elseif action == A_MYS then VIEWS[5](player, arg)
    elseif action == A_PAGE then VIEWS[math.floor(arg / 1000)](player, arg % 1000)
    elseif action == A_LEARN then Report(ClasslessLearn(player, arg)); Again(1)
    elseif action == A_UNLEARN then if ClasslessOwned(CharKey(player), arg) then Report(ClasslessUnlearn(player, arg)) end; Again(2)
    elseif action == A_TLEARN then Report(TalentLearn(player, arg)); Again(3)
    elseif action == A_TUNLEARN then Report(TalentUnlearn(player, arg)); Again(4)
    elseif action == A_MTOGGLE then
        if arg > 0 and MYS_GetList then
            local active = false
            for _, m in ipairs((MYS_GetList(player))) do if m.id == arg then active = m.active end end
            Report(MYS_Toggle(player, arg, not active))
        end
        Again(5)
    elseif action == A_RESPEC then ClasslessRespec(player); Home(player)
    elseif action == A_TRESPEC then TalentRespec(player); Home(player)
    else player:GossipComplete() end
end
RegisterPlayerGossipEvent(UI_MENU, 2, Select)
function HERO_MysticWindow(player)
    if HasUI(player) then SendClient(player, "OPEN;mystic") return end
    VIEWS[5](player, 1)
end

-- Hero's Codex (hero_codex.sql): use it (or its action bar key) to open Character Advancement
local CODEX = 9730002
RegisterItemEvent(CODEX, 2, function(_, player) Home(player) return false end)
-- Dice of Destiny (dice_item.sql): every Hero carries it; using it opens the Dice roll (Wildcard) or Character Advancement
local DICE = 9730003
RegisterItemEvent(DICE, 2, function(_, player)
    local path = GetPath(CharKey(player))
    if path == PATH_WILDCARD then
        if HasUI(player) then SendClient(player, "OPEN;dice") else pcall(HERO_DraftWindow, player) end
    else Home(player) end
    return false
end)
RegisterPlayerEvent(3, function(_, player)
    pcall(MigrateToRetail, player) -- clones -> retail spells (idempotent)
    SetUI(player, false) -- the client re-announces its UI after loading
    if not player:HasItem(DICE, 1, true) then
        if player:AddItem(DICE, 1) then
            player:SendBroadcastMessage("|cffff8000[Hero]|r You received the |cffa335ee[Dice of Destiny]|r. Use it to roll, and press N for Character Advancement.")
        end
    end
end)

-- open the right window a few seconds after entering the world (map state: timers are safe here)
RegisterPlayerEvent(28, function(_, player)
    if IS_WORLD_STATE then return end
    -- asked again a few times: Exile's Reach (any cinematic) can swallow the first message
    for i = 1, 5 do
        player:RegisterEvent(function(_, _, _, p)
            if not p or not p:IsInWorld() then return end
            local path = GetPath(CharKey(p))
            if path == PATH_NONE then HERO_PathWindow(p)
            elseif i == 1 and path == PATH_WILDCARD and #ParseDraft(DbGet(CharKey(p)).draft) > 0 then HERO_DraftWindow(p) end
        end, 9000 + (i - 1) * 15000, 1)
    end
end)

-- Hero Trainer (entry 9900131, every capital inn, mystic_altars.sql): respecs and rerolls.
local TRAINER_ENTRY = 9900131
local function RerollPrice(player)   -- 20 silver per level, cheaper with city reputation (world_events.lua)
    return math.floor(2000 * math.max(1, player:GetLevel()) * (CITY_PriceFactor and CITY_PriceFactor(player) or 1))
end

local function TrainerShow(player, creature)
    player:GossipClearMenu()
    local path = GetPath(CharKey(player))
    if path == PATH_NONE then
        player:GossipMenuAddItem(0, "I want to choose my Hero path.", 0, 1)
    elseif path == PATH_CONQUEST then
        player:GossipMenuAddItem(0, "Reset my talents (refund all Talent Essence).", 0, 3, false, "Unlearn every Hero talent?")
        if not GetCoa(CharKey(player)) then player:GossipMenuAddItem(0, "Choose my Conquest class.", 0, 7) end
    elseif path == PATH_CLASSLESS then
        player:GossipMenuAddItem(0, "Reset my abilities (refund all Ability Essence).", 0, 2, false, "Unlearn every Classless ability?")
        player:GossipMenuAddItem(0, "Reset my talents (refund all Talent Essence).", 0, 3, false, "Unlearn every Hero talent?")
        player:GossipMenuAddItem(0, "How much Essence do I have?", 0, 5)
    else
        local g = RerollPrice(player)
        player:GossipMenuAddItem(3, "Buy a Dice of Destiny reroll (" .. math.floor(g / 10000) .. "g " .. math.floor(g % 10000 / 100) .. "s).", 0, 4, false,
            "Buy one more reroll?", g)
        player:GossipMenuAddItem(0, "Show my rolls and build.", 0, 6)
    end
    player:GossipSendMenu(1, creature)
end

local function TrainerSelect(event, player, creature, sender, intid)
    if intid == 1 then AskPath(player)
    elseif intid == 2 then ClasslessRespec(player)
    elseif intid == 3 then TalentRespec(player)
    elseif intid == 4 then
        local g = RerollPrice(player)
        if player:GetCoinage() < g then player:SendNotification("You cannot afford that.")
        else
            local key = CharKey(player)
            local st = DbGet(key)
            player:ModifyMoney(-g)
            DbPut(key, st.charges + 1, st.draft)
            player:SendBroadcastMessage("|cffffd200[Wildcard]|r +1 reroll. Rerolls: " .. (st.charges + 1) .. ".")
            SendDraftUI(player, ParseDraft(st.draft), st.charges + 1)
        end
    elseif intid == 5 then
        player:SendBroadcastMessage(CTAG .. "Ability Essence " .. AEFree(player) .. "/" .. AETotal(player) .. ", Talent Essence " .. TEFree(player) .. "/" .. TETotal(player) .. ".")
    elseif intid == 6 then ShowStatus(player); ShowBuild(player)
    elseif intid == 7 then player:GossipComplete(); AskCoa(player); return
    end
    TrainerShow(player, creature)
end

if ENABLED then
    if not HasSQL() then
        print("[wildcard] DISABLED: CharDBQuery/CharDBExecute not available in this Eluna build")
    else
        math.randomseed(os.time())
        RegisterPlayerEvent(3, OnLogin)       -- ON_LOGIN
        RegisterPlayerEvent(13, OnLevelChange) -- ON_LEVEL_CHANGE
        RegisterPlayerEvent(42, OnCommand)     -- ON_COMMAND
        RegisterPlayerEvent(7, function(_, killer)  -- ON_KILL_CREATURE: Essence bonus
            if killer and killer:HasAura(HERO_AURA) then
                killer:SetPower(math.min(EssenceMaxFor(killer), killer:GetPower(POWER_ALT) + math.floor(EssenceMaxFor(killer) * 0.08)), POWER_ALT)
            end
        end)
        RegisterServerEvent(30, OnAddonMessage) -- ADDON message (client UI)
        RegisterCreatureEvent(FORTUNA_ENTRY, 1, FortunaHello)  -- GOSSIP_HELLO
        RegisterCreatureEvent(FORTUNA_ENTRY, 2, FortunaSelect) -- GOSSIP_SELECT
        RegisterCreatureGossipEvent(TRAINER_ENTRY, 1, function(_, player, creature) TrainerShow(player, creature) end)
        RegisterCreatureGossipEvent(TRAINER_ENTRY, 2, TrainerSelect)
        RegisterPlayerGossipEvent(COA_MENU, 2, function(_, player, _, sender, intid)
            player:GossipComplete()
            local c = (COA_CLASSES or {})[intid]
            if c and GetPath(CharKey(player)) == PATH_CONQUEST then ChooseCoa(player, c) end
        end)
        print("[wildcard] loaded: " .. #POOL .. " spells, " .. #TALENTS .. " talents (" .. DROPPED .. " unknown dropped), draft " .. DRAFT_SIZE ..
            ", " .. CHARGES_PER_LEVEL .. " rerolls/level")
    end
end
