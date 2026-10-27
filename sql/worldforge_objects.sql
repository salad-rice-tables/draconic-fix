-- =====================================================================
-- Worldforge objekty: 1380 klikatelnych objektov (goober, entry = ID itemu),
-- poloha z classic map (Ascension), meno z AzerothHub. Spawn robi worldforge.lua
-- (vysku Z dopocita v hre) - spawny su v `gameobject` s id 9700004-9701383.
-- Undo: worldforge_objects_undo.sql
-- =====================================================================
-- worldforge_item vznika v worldforge_items.sql; tieto stlpce pridava tento subor
ALTER TABLE `world`.`worldforge_item`
  ADD COLUMN `map` smallint unsigned NOT NULL DEFAULT 0,
  ADD COLUMN `wx` float NOT NULL DEFAULT 0,
  ADD COLUMN `wy` float NOT NULL DEFAULT 0,
  ADD COLUMN `zone_id` int unsigned NOT NULL DEFAULT 0,
  ADD COLUMN `object_name` varchar(100) NOT NULL DEFAULT '',
  ADD COLUMN `spawn_guid` bigint unsigned NOT NULL DEFAULT 0;
CREATE TABLE IF NOT EXISTS `characters`.`worldforge_looted` (
  `name` varchar(12) NOT NULL, `item` int unsigned NOT NULL, `at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`name`, `item`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
DELETE FROM `world`.`gameobject_template` WHERE `entry` BETWEEN 9700004 AND 9701383;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `VerifiedBuild`) VALUES
(9700004, 10, 259, 'Alteraci Avenger', 'Interact', '', '', 0.8, 0),
(9700005, 10, 259, 'Alteraci Avenger', 'Interact', '', '', 0.8, 0),
(9700006, 10, 259, 'Alteraci Band', 'Interact', '', '', 0.8, 0),
(9700007, 10, 259, 'Antique Alteraci Skirt', 'Interact', '', '', 0.8, 0),
(9700008, 10, 259, 'Battleplate of Crimson Resolve', 'Interact', '', '', 0.8, 0),
(9700009, 10, 259, 'Blood Soaked Spike', 'Interact', '', '', 0.8, 0),
(9700010, 10, 259, 'Blood Soaked Spike', 'Interact', '', '', 0.8, 0),
(9700011, 10, 259, 'Chain of the Forgotten Prisoner', 'Interact', '', '', 0.8, 0),
(9700012, 10, 259, 'Charred Greaves', 'Interact', '', '', 0.8, 0),
(9700013, 10, 259, 'Coldridge Crusher', 'Interact', '', '', 0.8, 0),
(9700014, 10, 259, 'Coldridge Crusher', 'Interact', '', '', 0.8, 0),
(9700015, 10, 18, 'Crater''s Silk Drape', 'Interact', '', '', 0.9, 0),
(9700016, 10, 259, 'Crushridge Fingerguards', 'Interact', '', '', 0.8, 0),
(9700017, 10, 259, 'Dalaran Mage Garb', 'Interact', '', '', 0.8, 0),
(9700018, 10, 259, 'Dandred''s Harvester', 'Interact', '', '', 0.8, 0),
(9700019, 10, 259, 'Dandred''s Harvester', 'Interact', '', '', 0.8, 0),
(9700020, 10, 259, 'Dusty Sorcerer Hat', 'Interact', '', '', 0.8, 0),
(9700021, 10, 259, 'Embrace of the Fifth', 'Interact', '', '', 0.8, 0),
(9700022, 10, 259, 'Infernal Tender', 'Interact', '', '', 0.8, 0),
(9700023, 10, 259, 'Enchanted Scribe''s Feather', 'Interact', '', '', 0.8, 0),
(9700024, 10, 259, 'Feline''s Grasp', 'Interact', '', '', 0.8, 0),
(9700025, 10, 259, 'Forgotten Warrior''s Pauldrons', 'Interact', '', '', 0.8, 0),
(9700026, 10, 259, 'Frostwatch Defender', 'Interact', '', '', 0.8, 0),
(9700027, 10, 259, 'Frostwatch Defender', 'Interact', '', '', 0.8, 0),
(9700028, 10, 130, 'Grandpa''s Scarlet Blade', 'Interact', '', '', 0.7, 0),
(9700029, 10, 259, 'Heisen’s Loop', 'Interact', '', '', 0.8, 0),
(9700030, 10, 259, 'Hercular''s Unstable Orb', 'Interact', '', '', 0.8, 0),
(9700031, 10, 259, 'Hercular''s Unstable Orb', 'Interact', '', '', 0.8, 0),
(9700032, 10, 259, 'Ice-Forged Gauntlets', 'Interact', '', '', 0.8, 0),
(9700033, 10, 130, 'Icecracker', 'Interact', '', '', 0.7, 0),
(9700034, 10, 130, 'Icecracker', 'Interact', '', '', 0.7, 0),
(9700035, 10, 259, 'Libram of the Third Host', 'Interact', '', '', 0.8, 0),
(9700036, 10, 259, 'Libram of the Third Host', 'Interact', '', '', 0.8, 0),
(9700037, 10, 130, 'Muckrake''s Soup Bowl', 'Interact', '', '', 0.7, 0),
(9700038, 10, 259, 'Ogre Toothpick', 'Interact', '', '', 0.8, 0),
(9700039, 10, 18, 'Snow Buried Shipment', 'Interact', '', '', 0.9, 0),
(9700040, 10, 130, 'Muckrake''s Soup Bowl', 'Interact', '', '', 0.7, 0),
(9700041, 10, 259, 'Runed Pantaloons', 'Interact', '', '', 0.8, 0),
(9700042, 10, 259, 'Sentry Shot', 'Interact', '', '', 0.8, 0),
(9700043, 10, 259, 'Sentry Shot', 'Interact', '', '', 0.8, 0),
(9700044, 10, 259, 'Shredder''s Medallion', 'Interact', '', '', 0.8, 0),
(9700045, 10, 130, 'Staff of Argus', 'Interact', '', '', 0.7, 0),
(9700046, 10, 130, 'Staff of Argus', 'Interact', '', '', 0.7, 0),
(9700047, 10, 259, 'Stolen Rot Hide Circlet', 'Interact', '', '', 0.8, 0),
(9700048, 10, 130, 'Syndicate Chopping Axe', 'Interact', '', '', 0.7, 0),
(9700049, 10, 130, 'Syndicate Chopping Axe', 'Interact', '', '', 0.7, 0),
(9700050, 10, 130, 'Syndicate Crossbow', 'Interact', '', '', 0.7, 0),
(9700051, 10, 130, 'Syndicate Crossbow', 'Interact', '', '', 0.7, 0),
(9700052, 10, 259, 'Syndicate Slicer', 'Interact', '', '', 0.8, 0),
(9700053, 10, 259, 'Syndicate Slicer', 'Interact', '', '', 0.8, 0),
(9700054, 10, 18, 'Syndicate Cobbler''s Supplies', 'Interact', '', '', 0.9, 0),
(9700055, 10, 130, 'Tombbound Warhammer', 'Interact', '', '', 0.7, 0),
(9700056, 10, 130, 'Tombbound Warhammer', 'Interact', '', '', 0.7, 0),
(9700057, 10, 259, 'Totem of the Flowing River', 'Interact', '', '', 0.8, 0),
(9700058, 10, 130, 'Tracker''s Scope', 'Interact', '', '', 0.7, 0),
(9700059, 10, 130, 'Tracker''s Scope', 'Interact', '', '', 0.7, 0),
(9700060, 10, 259, 'Abandonded Wristguard', 'Interact', '', '', 0.8, 0),
(9700061, 10, 130, 'Ancient Dark Iron Mace', 'Interact', '', '', 0.7, 0),
(9700062, 10, 259, 'Ancient Wavepiercer', 'Interact', '', '', 0.8, 0),
(9700063, 10, 259, 'Arcane Impaler', 'Interact', '', '', 0.8, 0),
(9700064, 10, 130, 'Blade of the Syndicate Lord', 'Interact', '', '', 0.7, 0),
(9700065, 10, 130, 'Boarder''s Axe', 'Interact', '', '', 0.7, 0),
(9700066, 10, 259, 'Brumn''s Unfinished Project', 'Interact', '', '', 0.8, 0),
(9700067, 10, 259, 'Caretaker''s Burden', 'Interact', '', '', 0.8, 0),
(9700068, 10, 259, 'Caretaker''s Burden', 'Interact', '', '', 0.8, 0),
(9700069, 10, 259, 'Circle of Waves Idol', 'Interact', '', '', 0.8, 0),
(9700070, 10, 259, 'Circle of Waves Idol', 'Interact', '', '', 0.8, 0),
(9700071, 10, 259, 'Commode Cleaver', 'Interact', '', '', 0.8, 0),
(9700072, 10, 259, 'Dark Iron Blaster', 'Interact', '', '', 0.8, 0),
(9700073, 10, 259, 'Dark Iron Blaster', 'Interact', '', '', 0.8, 0),
(9700074, 10, 259, 'Deadweight Pauldrons', 'Interact', '', '', 0.8, 0),
(9700075, 10, 259, 'Desperate Defense', 'Interact', '', '', 0.8, 0),
(9700076, 10, 259, 'Earth Infused Offering', 'Interact', '', '', 0.8, 0),
(9700077, 10, 259, 'Earth Reverent''s Sash', 'Interact', '', '', 0.8, 0),
(9700078, 10, 259, 'Flame Infused Offering Band', 'Interact', '', '', 0.8, 0),
(9700079, 10, 259, 'Forgotten Fitted Pants', 'Interact', '', '', 0.8, 0),
(9700080, 10, 259, 'Grave Spite', 'Interact', '', '', 0.8, 0),
(9700081, 10, 130, 'Hammerfall Wristguards', 'Interact', '', '', 0.7, 0),
(9700082, 10, 130, 'Heavy Tempered Blade', 'Interact', '', '', 0.7, 0),
(9700083, 10, 259, 'Interlinked Fingerguards', 'Interact', '', '', 0.8, 0),
(9700084, 10, 259, 'Interlinked Fingerguards', 'Interact', '', '', 0.8, 0),
(9700085, 10, 259, 'Mountain Climbers', 'Interact', '', '', 0.8, 0),
(9700086, 10, 259, 'Muffled Boots', 'Interact', '', '', 0.8, 0),
(9700087, 10, 259, 'Musty Horse Blanket', 'Interact', '', '', 0.8, 0),
(9700088, 10, 259, 'Offering Pendant', 'Interact', '', '', 0.8, 0),
(9700089, 10, 259, 'Onestone''s One Stone', 'Interact', '', '', 0.8, 0),
(9700090, 10, 259, 'Peace of the Dead', 'Interact', '', '', 0.8, 0),
(9700091, 10, 259, 'Peace of the Dead', 'Interact', '', '', 0.8, 0),
(9700092, 10, 259, 'Plains Bolter', 'Interact', '', '', 0.8, 0),
(9700093, 10, 259, 'Plains Bolter', 'Interact', '', '', 0.8, 0),
(9700094, 10, 130, 'Poacher''s Bow', 'Interact', '', '', 0.7, 0),
(9700095, 10, 130, 'Poacher''s Bow', 'Interact', '', '', 0.7, 0),
(9700096, 10, 259, 'Rough Weathered Ring', 'Interact', '', '', 0.8, 0),
(9700097, 10, 130, 'Mysterious Hammer', 'Interact', '', '', 0.7, 0),
(9700098, 10, 293, 'Skullknocker', 'Interact', '', '', 1.0, 0),
(9700099, 10, 259, 'Stolen War Pendant', 'Interact', '', '', 0.8, 0),
(9700100, 10, 259, 'Stromgarde Buckler', 'Interact', '', '', 0.8, 0),
(9700101, 10, 137, 'Stromgarde Spell Tome', 'Interact', '', '', 0.6, 0),
(9700102, 10, 259, 'Suprisingly Sturdy Helm', 'Interact', '', '', 0.8, 0),
(9700103, 10, 259, 'Syndicate Shanker', 'Interact', '', '', 0.8, 0),
(9700104, 10, 259, 'Syndicate Shanker', 'Interact', '', '', 0.8, 0),
(9700105, 10, 259, 'Syndiclap', 'Interact', '', '', 0.8, 0),
(9700106, 10, 259, 'The Withered Totem', 'Interact', '', '', 0.8, 0),
(9700107, 10, 259, 'Thunder Infused Offering', 'Interact', '', '', 0.8, 0),
(9700108, 10, 259, 'Band of Scales', 'Interact', '', '', 0.8, 0),
(9700109, 10, 259, 'Watchguard''s Prized Plate', 'Interact', '', '', 0.8, 0),
(9700110, 10, 259, 'Water Drawing Cap', 'Interact', '', '', 0.8, 0),
(9700111, 10, 259, 'Witherbark Headsmasher', 'Interact', '', '', 0.8, 0),
(9700112, 10, 259, 'Witherbark Headsmasher', 'Interact', '', '', 0.8, 0),
(9700113, 10, 259, 'Withered Trollkin Shoulders', 'Interact', '', '', 0.8, 0),
(9700114, 10, 130, 'Assassin''s Crossbow', 'Interact', '', '', 0.7, 0),
(9700115, 10, 259, 'Bathran''s Cursed Twig', 'Interact', '', '', 0.8, 0),
(9700116, 10, 130, 'Blade of Severed Souls', 'Interact', '', '', 0.7, 0),
(9700117, 10, 259, 'Bleakheart Piercer', 'Interact', '', '', 0.8, 0),
(9700118, 10, 259, 'Bloodtooth Neck', 'Interact', '', '', 0.8, 0),
(9700119, 10, 259, 'Bloodtooth Neck', 'Interact', '', '', 0.8, 0),
(9700120, 10, 259, 'Cursed Fire Scar Pendant', 'Interact', '', '', 0.8, 0),
(9700121, 10, 259, 'Cursed Fire Scar Pendant', 'Interact', '', '', 0.8, 0),
(9700122, 10, 259, 'Dirge of the Dead', 'Interact', '', '', 0.8, 0),
(9700123, 10, 259, 'Dirge of the Dead', 'Interact', '', '', 0.8, 0),
(9700124, 10, 259, 'Echo of Aessina', 'Interact', '', '', 0.8, 0),
(9700125, 10, 259, 'Echo of Aessina', 'Interact', '', '', 0.8, 0),
(9700126, 10, 259, 'Elune Tear Fragment', 'Interact', '', '', 0.8, 0),
(9700127, 10, 259, 'Elune Tear Fragment', 'Interact', '', '', 0.8, 0),
(9700128, 10, 259, 'Elven Militia Crown', 'Interact', '', '', 0.8, 0),
(9700129, 10, 259, 'Endless Moonwell Chalice', 'Interact', '', '', 0.8, 0),
(9700130, 10, 259, 'Endless Moonwell Chalice', 'Interact', '', '', 0.8, 0),
(9700131, 10, 259, 'Fel Infused Band', 'Interact', '', '', 0.8, 0),
(9700132, 10, 259, 'Felforged Meteor Fragment', 'Interact', '', '', 0.8, 0),
(9700133, 10, 259, 'Fine Silk Wraps', 'Interact', '', '', 0.8, 0),
(9700134, 10, 259, 'Guide to Elven Restoration - Vol. I', 'Interact', '', '', 0.8, 0),
(9700135, 10, 259, 'Guide to Elven Restoration - Vol. I', 'Interact', '', '', 0.8, 0),
(9700136, 10, 259, 'Hunter''s Tunic', 'Interact', '', '', 0.8, 0),
(9700137, 10, 130, 'Infiltrator''s Shield', 'Interact', '', '', 0.7, 0),
(9700138, 10, 130, 'Maestra''s Training Longbow', 'Interact', '', '', 0.7, 0),
(9700139, 10, 130, 'Maestra''s Training Longbow', 'Interact', '', '', 0.7, 0),
(9700140, 10, 259, 'Malorne''s Girdle', 'Interact', '', '', 0.8, 0),
(9700141, 10, 259, 'Mystral Compass', 'Interact', '', '', 0.8, 0),
(9700142, 10, 130, 'Mystral Staff', 'Interact', '', '', 0.7, 0),
(9700143, 10, 130, 'Mystral Staff', 'Interact', '', '', 0.7, 0),
(9700144, 10, 130, 'Nightsong Waraxe', 'Interact', '', '', 0.7, 0),
(9700145, 10, 130, 'Nightsong Waraxe', 'Interact', '', '', 0.7, 0),
(9700146, 10, 259, 'Pristine Tortoise Carapace', 'Interact', '', '', 0.8, 0),
(9700147, 10, 259, 'Rock Smasher', 'Interact', '', '', 0.8, 0),
(9700148, 10, 259, 'Rosebud Ring', 'Interact', '', '', 0.8, 0),
(9700149, 10, 259, 'Sharpened Pike', 'Interact', '', '', 0.8, 0),
(9700150, 10, 130, 'Silverwing Grovekeeper''s Bow', 'Interact', '', '', 0.7, 0),
(9700151, 10, 130, 'Silverwing Grovekeeper''s Bow', 'Interact', '', '', 0.7, 0),
(9700152, 10, 259, 'Stardust Scoured Helmet', 'Interact', '', '', 0.8, 0),
(9700153, 10, 259, 'Stardust Scoured Helmet', 'Interact', '', '', 0.8, 0),
(9700154, 10, 259, 'Thistlefur Fur Shroud', 'Interact', '', '', 0.8, 0),
(9700155, 10, 259, 'Expedition Bracers', 'Interact', '', '', 0.8, 0),
(9700156, 10, 259, 'Ursangous'' Claw', 'Interact', '', '', 0.8, 0),
(9700157, 10, 259, 'Ursangous'' Claw', 'Interact', '', '', 0.8, 0),
(9700158, 10, 259, 'Woodbreaker Mallet', 'Interact', '', '', 0.8, 0),
(9700159, 10, 259, 'Woodbreaker Mallet', 'Interact', '', '', 0.8, 0),
(9700160, 10, 130, 'Assassin''s Crossbow', 'Interact', '', '', 0.7, 0),
(9700161, 10, 259, 'Cliffwalker Legplates', 'Interact', '', '', 0.8, 0),
(9700162, 10, 130, 'Crystalized Shield', 'Interact', '', '', 0.7, 0),
(9700163, 10, 130, 'Crystalized Shield', 'Interact', '', '', 0.7, 0),
(9700164, 10, 259, 'Drape of the Lost', 'Interact', '', '', 0.8, 0),
(9700165, 10, 259, 'Drape of the Lost', 'Interact', '', '', 0.8, 0),
(9700166, 10, 259, 'Hydra Hide Belt', 'Interact', '', '', 0.8, 0),
(9700167, 10, 259, 'Idol of the Ocean''s Depths', 'Interact', '', '', 0.8, 0),
(9700168, 10, 259, 'Ish''thel Falesh, Gaze of Eldara', 'Interact', '', '', 0.8, 0),
(9700169, 10, 259, 'Ish''thel Falesh, Gaze of Eldara', 'Interact', '', '', 0.8, 0),
(9700170, 10, 259, 'Legashi Bracers', 'Interact', '', '', 0.8, 0),
(9700171, 10, 259, 'Lyre of the Grand Scribe', 'Interact', '', '', 0.8, 0),
(9700172, 10, 259, 'Might of Azshara', 'Interact', '', '', 0.8, 0),
(9700173, 10, 259, 'Might of Azshara', 'Interact', '', '', 0.8, 0),
(9700174, 10, 259, 'Sacrificial Carver', 'Interact', '', '', 0.8, 0),
(9700175, 10, 259, 'Shoulderguards of Zin-Malor', 'Interact', '', '', 0.8, 0),
(9700176, 10, 259, 'Shoulderguards of Zin-Malor', 'Interact', '', '', 0.8, 0),
(9700177, 10, 259, 'The Wrath of Arkkoroc', 'Interact', '', '', 0.8, 0),
(9700178, 10, 259, 'The Wrath of Arkkoroc', 'Interact', '', '', 0.8, 0),
(9700179, 10, 259, 'Vuna''thell', 'Interact', '', '', 0.8, 0),
(9700180, 10, 259, 'Vuna''thell', 'Interact', '', '', 0.8, 0),
(9700181, 10, 259, 'Bloodstained Helm', 'Interact', '', '', 0.8, 0),
(9700182, 10, 259, 'Bloodstained Pendant', 'Interact', '', '', 0.8, 0),
(9700183, 10, 293, 'Bone Carver', 'Interact', '', '', 1.0, 0),
(9700184, 10, 259, 'Cowl of the Stone Summoner', 'Interact', '', '', 0.8, 0),
(9700185, 10, 130, 'Cracked Earth Vest', 'Interact', '', '', 0.7, 0),
(9700186, 10, 259, 'Deflector''s Wargreaves', 'Interact', '', '', 0.8, 0),
(9700187, 10, 259, 'Duststorm Sash', 'Interact', '', '', 0.8, 0),
(9700188, 10, 259, 'Earth Bindings', 'Interact', '', '', 0.8, 0),
(9700189, 10, 259, 'Garek''s Comfortable Robe', 'Interact', '', '', 0.8, 0),
(9700190, 10, 259, 'Hanging Ogre Scraps', 'Interact', '', '', 0.8, 0),
(9700191, 10, 259, 'Ogre Fire Poker', 'Interact', '', '', 0.8, 0),
(9700192, 10, 259, 'Ogre Fire Poker', 'Interact', '', '', 0.8, 0),
(9700193, 10, 293, 'Real Big Bone', 'Interact', '', '', 1.0, 0),
(9700194, 10, 293, 'Real Big Bone', 'Interact', '', '', 1.0, 0),
(9700195, 10, 259, 'Rock Runners', 'Interact', '', '', 0.8, 0),
(9700196, 10, 259, 'Safety Gloves', 'Interact', '', '', 0.8, 0),
(9700197, 10, 130, 'Sandworn Arcanist Staff', 'Interact', '', '', 0.7, 0),
(9700198, 10, 130, 'Shadowforge Shotgun', 'Interact', '', '', 0.7, 0),
(9700199, 10, 130, 'Shadowforge Shotgun', 'Interact', '', '', 0.7, 0),
(9700200, 10, 259, 'Shadowforged Deflector', 'Interact', '', '', 0.8, 0),
(9700201, 10, 259, 'Shadowforged Deflector', 'Interact', '', '', 0.8, 0),
(9700202, 10, 259, 'Spark of Infernus', 'Interact', '', '', 0.8, 0),
(9700203, 10, 259, 'Spark of Infernus', 'Interact', '', '', 0.8, 0),
(9700204, 10, 259, 'Spellpiercing Cloak', 'Interact', '', '', 0.8, 0),
(9700205, 10, 130, 'Staff of the Earth Guardian', 'Interact', '', '', 0.7, 0),
(9700206, 10, 259, 'Stonebloom Idol', 'Interact', '', '', 0.8, 0),
(9700207, 10, 259, 'Sunscorched Thrower', 'Interact', '', '', 0.8, 0),
(9700208, 10, 259, 'The Rock Binder', 'Interact', '', '', 0.8, 0),
(9700209, 10, 259, 'The Rock Binder', 'Interact', '', '', 0.8, 0),
(9700210, 10, 259, 'Thorkaf''s Prototype', 'Interact', '', '', 0.8, 0),
(9700211, 10, 130, 'Toe Hammer', 'Interact', '', '', 0.7, 0),
(9700212, 10, 259, 'Tomb Seeker', 'Interact', '', '', 0.8, 0),
(9700213, 10, 130, 'Gravesword', 'Interact', '', '', 0.7, 0),
(9700214, 10, 259, 'Wand of the Ancients', 'Interact', '', '', 0.8, 0),
(9700215, 10, 130, 'Wind-Worn Longbow', 'Interact', '', '', 0.7, 0),
(9700216, 10, 259, 'Bloodmage Coil', 'Interact', '', '', 0.8, 0),
(9700217, 10, 259, 'Portal Fragment', 'Interact', '', '', 0.8, 0),
(9700218, 10, 259, 'Ashen Cape', 'Interact', '', '', 0.8, 0),
(9700219, 10, 259, 'Ashenpeak Band', 'Interact', '', '', 0.8, 0),
(9700220, 10, 130, 'Blackbreach Handaxe', 'Interact', '', '', 0.7, 0),
(9700221, 10, 259, 'Burnscorch Wand', 'Interact', '', '', 0.8, 0),
(9700222, 10, 130, 'Charblaze Rifle', 'Interact', '', '', 0.7, 0),
(9700223, 10, 259, 'Charred Signet', 'Interact', '', '', 0.8, 0),
(9700224, 10, 259, 'Cinderthread Sash', 'Interact', '', '', 0.8, 0),
(9700225, 10, 259, 'Darkflight Totem', 'Interact', '', '', 0.8, 0),
(9700226, 10, 259, 'Emberstep Sabatons', 'Interact', '', '', 0.8, 0),
(9700227, 10, 259, 'Empty Ogre Loot Sack', 'Interact', '', '', 0.8, 0),
(9700228, 10, 259, 'Firebrand Libram', 'Interact', '', '', 0.8, 0),
(9700229, 10, 259, 'Grave Offering', 'Interact', '', '', 0.8, 0),
(9700230, 10, 259, 'Grave Offering', 'Interact', '', '', 0.8, 0),
(9700231, 10, 259, 'Inferno Gavel', 'Interact', '', '', 0.8, 0),
(9700232, 10, 130, 'Lava Absorbing Blade', 'Interact', '', '', 0.7, 0),
(9700233, 10, 259, 'Magmaweave Pantaloons', 'Interact', '', '', 0.8, 0),
(9700234, 10, 259, 'Obsidian Boltthrower', 'Interact', '', '', 0.8, 0),
(9700235, 10, 259, 'The Final Strike', 'Interact', '', '', 0.8, 0),
(9700236, 10, 259, 'Volcanic Aegis', 'Interact', '', '', 0.8, 0),
(9700237, 10, 259, 'Ancient Family Heirloom', 'Interact', '', '', 0.8, 0),
(9700238, 10, 137, 'Ancient Highborne Tome', 'Interact', '', '', 0.6, 0),
(9700239, 10, 259, 'Auberdine Scimitar', 'Interact', '', '', 0.8, 0),
(9700240, 10, 259, 'Blackwood Torch', 'Interact', '', '', 0.8, 0),
(9700241, 10, 259, 'Blackwood Torch', 'Interact', '', '', 0.8, 0),
(9700242, 10, 259, 'Enchanted Flora Waist', 'Interact', '', '', 0.8, 0),
(9700243, 10, 259, 'Hidden Chest', 'Interact', '', '', 0.8, 0),
(9700244, 10, 130, 'Fanatic''s Cursed Blade', 'Interact', '', '', 0.7, 0),
(9700245, 10, 259, 'Faulty Stone Golem', 'Interact', '', '', 0.8, 0),
(9700246, 10, 259, 'Forsaken Stone Braid', 'Interact', '', '', 0.8, 0),
(9700247, 10, 259, 'Furbolg War-drum', 'Interact', '', '', 0.8, 0),
(9700248, 10, 259, 'Highborne Trousers', 'Interact', '', '', 0.8, 0),
(9700249, 10, 259, 'Hunk of Darkshore Driftwood', 'Interact', '', '', 0.8, 0),
(9700250, 10, 293, 'Moon-knawed Bone Spire', 'Interact', '', '', 1.0, 0),
(9700251, 10, 259, 'Moonrest Slippers', 'Interact', '', '', 0.8, 0),
(9700252, 10, 130, 'Relicseeker Staff', 'Interact', '', '', 0.7, 0),
(9700253, 10, 18, 'Shipwrecked Crate', 'Interact', '', '', 0.9, 0),
(9700254, 10, 259, 'Shorebreeze Sabatons', 'Interact', '', '', 0.8, 0),
(9700255, 10, 259, 'Stormscale Guard', 'Interact', '', '', 0.8, 0),
(9700256, 10, 259, 'Tide Turner', 'Interact', '', '', 0.8, 0),
(9700257, 10, 259, 'Twilight Bands', 'Interact', '', '', 0.8, 0),
(9700258, 10, 259, 'Twilight Vale', 'Interact', '', '', 0.8, 0),
(9700259, 10, 259, 'Unpleasant Ring', 'Interact', '', '', 0.8, 0),
(9700260, 10, 259, 'Washed Ashore Bottle', 'Interact', '', '', 0.8, 0),
(9700261, 10, 130, 'Wild Longbow', 'Interact', '', '', 0.7, 0),
(9700262, 10, 259, 'Windshaper Wraps', 'Interact', '', '', 0.8, 0),
(9700263, 10, 323, 'Bag of Folding', 'Interact', '', '', 1.0, 0),
(9700264, 10, 259, 'Abandoned Boots', 'Interact', '', '', 0.8, 0),
(9700265, 10, 259, 'Alchemy Visceral Juice', 'Interact', '', '', 0.8, 0),
(9700266, 10, 259, 'Ambereye Amulet', 'Interact', '', '', 0.8, 0),
(9700267, 10, 130, 'Blade of Dread', 'Interact', '', '', 0.7, 0),
(9700268, 10, 130, 'Blade of Dread', 'Interact', '', '', 0.7, 0),
(9700269, 10, 130, 'Blade of Thunder', 'Interact', '', '', 0.7, 0),
(9700270, 10, 130, 'Blade of Thunder', 'Interact', '', '', 0.7, 0),
(9700271, 10, 293, 'Bone Harvester', 'Interact', '', '', 1.0, 0),
(9700272, 10, 293, 'Bone Harvester', 'Interact', '', '', 1.0, 0),
(9700273, 10, 293, 'Bone Splitter', 'Interact', '', '', 1.0, 0),
(9700274, 10, 293, 'Bone Splitter', 'Interact', '', '', 1.0, 0),
(9700275, 10, 259, 'Buried Bracers', 'Interact', '', '', 0.8, 0),
(9700276, 10, 130, 'Burning Blade Ritual Knife', 'Interact', '', '', 0.7, 0),
(9700277, 10, 130, 'Burning Blade Ritual Knife', 'Interact', '', '', 0.7, 0),
(9700278, 10, 259, 'Burning Gauntlets', 'Interact', '', '', 0.8, 0),
(9700279, 10, 259, 'Caravan Guard Pauldrons', 'Interact', '', '', 0.8, 0),
(9700280, 10, 259, 'Caravan Guard Vest', 'Interact', '', '', 0.8, 0),
(9700281, 10, 259, 'Circlet of Desolation', 'Interact', '', '', 0.8, 0),
(9700282, 10, 259, 'Circlet of Desolation', 'Interact', '', '', 0.8, 0),
(9700283, 10, 259, 'Crown of the Great Khan', 'Interact', '', '', 0.8, 0),
(9700284, 10, 259, 'Crown of the Great Khan', 'Interact', '', '', 0.8, 0),
(9700285, 10, 259, 'Diving Boots', 'Interact', '', '', 0.8, 0),
(9700286, 10, 259, 'Diving Boots', 'Interact', '', '', 0.8, 0),
(9700287, 10, 259, 'Doomwarden', 'Interact', '', '', 0.8, 0),
(9700288, 10, 259, 'Doomwarden', 'Interact', '', '', 0.8, 0),
(9700289, 10, 259, 'Dustscour Courier Belt', 'Interact', '', '', 0.8, 0),
(9700290, 10, 130, 'Flamescoured Bow', 'Interact', '', '', 0.7, 0),
(9700291, 10, 130, 'Flamescoured Bow', 'Interact', '', '', 0.7, 0),
(9700292, 10, 259, 'Gelkis Cleaver', 'Interact', '', '', 0.8, 0),
(9700293, 10, 259, 'Gloves of Patience', 'Interact', '', '', 0.8, 0),
(9700294, 10, 130, 'Greataxe of Kolk', 'Interact', '', '', 0.7, 0),
(9700295, 10, 293, 'Hatefury Skull Totem', 'Interact', '', '', 1.0, 0),
(9700296, 10, 293, 'Hatefury Skull Totem', 'Interact', '', '', 1.0, 0),
(9700297, 10, 259, 'Hatefury Wand', 'Interact', '', '', 0.8, 0),
(9700298, 10, 259, 'Hatefury Wand', 'Interact', '', '', 0.8, 0),
(9700299, 10, 259, 'Heretical Libram', 'Interact', '', '', 0.8, 0),
(9700300, 10, 259, 'Heretical Libram', 'Interact', '', '', 0.8, 0),
(9700301, 10, 259, 'Icon of Khan Maraudos', 'Interact', '', '', 0.8, 0),
(9700302, 10, 130, 'Jairal''Kesh, Staff of Summoning', 'Interact', '', '', 0.7, 0),
(9700303, 10, 130, 'Jairal''Kesh, Staff of Summoning', 'Interact', '', '', 0.7, 0);
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `VerifiedBuild`) VALUES
(9700304, 10, 259, 'Kodo Hide Cloak', 'Interact', '', '', 0.8, 0),
(9700305, 10, 259, 'Kodo Hunter', 'Interact', '', '', 0.8, 0),
(9700306, 10, 259, 'Kodo Hunter', 'Interact', '', '', 0.8, 0),
(9700307, 10, 259, 'Lost Mariner Bracers', 'Interact', '', '', 0.8, 0),
(9700308, 10, 259, 'Lost Mariner Leggings', 'Interact', '', '', 0.8, 0),
(9700309, 10, 130, 'Magram Hatchet', 'Interact', '', '', 0.7, 0),
(9700310, 10, 130, 'Magram Hatchet', 'Interact', '', '', 0.7, 0),
(9700311, 10, 259, 'Maraudine Breastplate', 'Interact', '', '', 0.8, 0),
(9700312, 10, 259, 'Maraudine Cape', 'Interact', '', '', 0.8, 0),
(9700313, 10, 259, 'Maraudine Gloves', 'Interact', '', '', 0.8, 0),
(9700314, 10, 323, 'Moonglow Bag', 'Interact', '', '', 1.0, 0),
(9700315, 10, 323, 'Moonglow Bag', 'Interact', '', '', 1.0, 0),
(9700316, 10, 259, 'Offering to Azshara', 'Interact', '', '', 0.8, 0),
(9700317, 10, 259, 'Offering to Azshara', 'Interact', '', '', 0.8, 0),
(9700318, 10, 259, 'Orb of Dawn', 'Interact', '', '', 0.8, 0),
(9700319, 10, 259, 'Orb of Dawn', 'Interact', '', '', 0.8, 0),
(9700320, 10, 259, 'Pillaged Legguards', 'Interact', '', '', 0.8, 0),
(9700321, 10, 259, 'Ring of Arakosh', 'Interact', '', '', 0.8, 0),
(9700322, 10, 259, 'Ring of Korvaix', 'Interact', '', '', 0.8, 0),
(9700323, 10, 259, 'Ritual Robes', 'Interact', '', '', 0.8, 0),
(9700324, 10, 259, 'Shadowbreaker', 'Interact', '', '', 0.8, 0),
(9700325, 10, 259, 'Shadowbreaker', 'Interact', '', '', 0.8, 0),
(9700326, 10, 323, 'Shadowprey Bag', 'Interact', '', '', 1.0, 0),
(9700327, 10, 323, 'Shadowprey Bag', 'Interact', '', '', 1.0, 0),
(9700328, 10, 130, 'Shadowshard Shield', 'Interact', '', '', 0.7, 0),
(9700329, 10, 130, 'Shell Cracker', 'Interact', '', '', 0.7, 0),
(9700330, 10, 130, 'Shell Cracker', 'Interact', '', '', 0.7, 0),
(9700331, 10, 259, 'Shoulderpads of the Conjuror', 'Interact', '', '', 0.8, 0),
(9700332, 10, 259, 'Sorrow of the Kodo', 'Interact', '', '', 0.8, 0),
(9700333, 10, 259, 'Sorrow of the Kodo', 'Interact', '', '', 0.8, 0),
(9700334, 10, 130, 'Spear of Hatred', 'Interact', '', '', 0.7, 0),
(9700335, 10, 130, 'Spear of Hatred', 'Interact', '', '', 0.7, 0),
(9700336, 10, 259, 'Stormpiercer', 'Interact', '', '', 0.8, 0),
(9700337, 10, 259, 'Stormpiercer', 'Interact', '', '', 0.8, 0),
(9700338, 10, 259, 'Sunken Ring', 'Interact', '', '', 0.8, 0),
(9700339, 10, 259, 'Sunken Ring', 'Interact', '', '', 0.8, 0),
(9700340, 10, 259, 'The Undying Eye', 'Interact', '', '', 0.8, 0),
(9700341, 10, 259, 'The Undying Eye', 'Interact', '', '', 0.8, 0),
(9700342, 10, 259, 'The Winning Javelin', 'Interact', '', '', 0.8, 0),
(9700343, 10, 259, 'The Winning Javelin', 'Interact', '', '', 0.8, 0),
(9700344, 10, 259, 'Warcaster Slippers', 'Interact', '', '', 0.8, 0),
(9700345, 10, 259, 'Water Seer''s Headdress', 'Interact', '', '', 0.8, 0),
(9700346, 10, 259, 'Water Seer''s Headdress', 'Interact', '', '', 0.8, 0),
(9700347, 10, 130, 'Wind Ritual Staff', 'Interact', '', '', 0.7, 0),
(9700348, 10, 259, 'Woven Flowers', 'Interact', '', '', 0.8, 0),
(9700349, 10, 259, 'Woven Flowers', 'Interact', '', '', 0.8, 0),
(9700350, 10, 259, 'Zelyn''Theris', 'Interact', '', '', 0.8, 0),
(9700351, 10, 259, 'Arctic Imbued Stick', 'Interact', '', '', 0.8, 0),
(9700352, 10, 259, 'Claw of Vagash', 'Interact', '', '', 0.8, 0),
(9700353, 10, 259, 'Claw Scarred Mail', 'Interact', '', '', 0.8, 0),
(9700354, 10, 259, 'Claw of Vagash', 'Interact', '', '', 0.8, 0),
(9700355, 10, 259, 'Claw of Vagash', 'Interact', '', '', 0.8, 0),
(9700356, 10, 259, 'Coldhewn Tanning Gloves', 'Interact', '', '', 0.8, 0),
(9700357, 10, 259, 'Dark Iron Vest', 'Interact', '', '', 0.8, 0),
(9700358, 10, 259, 'Fire Poker', 'Interact', '', '', 0.8, 0),
(9700359, 10, 323, 'Forgotten Knapsack', 'Interact', '', '', 1.0, 0),
(9700360, 10, 130, 'Frostmane Axe', 'Interact', '', '', 0.7, 0),
(9700361, 10, 259, 'Frostmane Totem', 'Interact', '', '', 0.8, 0),
(9700362, 10, 259, 'Frostmane Totem', 'Interact', '', '', 0.8, 0),
(9700363, 10, 259, 'Frozen Finger', 'Interact', '', '', 0.8, 0),
(9700364, 10, 259, 'Glinting Necklace', 'Interact', '', '', 0.8, 0),
(9700365, 10, 259, 'Gnomeregan Spanner', 'Interact', '', '', 0.8, 0),
(9700366, 10, 259, 'Intact Wagon Wheel', 'Interact', '', '', 0.8, 0),
(9700367, 10, 259, 'Lost Adventurer''s Ring', 'Interact', '', '', 0.8, 0),
(9700368, 10, 130, 'Lost Mountaineer''s Bow', 'Interact', '', '', 0.7, 0),
(9700369, 10, 130, 'Lost Mountaineer''s Bow', 'Interact', '', '', 0.7, 0),
(9700370, 10, 130, 'Lumber Axe', 'Interact', '', '', 0.7, 0),
(9700371, 10, 259, 'Magnus'' Mug', 'Interact', '', '', 0.8, 0),
(9700372, 10, 259, 'Officer''s Pike', 'Interact', '', '', 0.8, 0),
(9700373, 10, 259, 'Officer''s Pike', 'Interact', '', '', 0.8, 0),
(9700374, 10, 259, 'Rabbit''s Paw', 'Interact', '', '', 0.8, 0),
(9700375, 10, 259, 'Repelling Necklace', 'Interact', '', '', 0.8, 0),
(9700376, 10, 259, 'Rider''s Ring', 'Interact', '', '', 0.8, 0),
(9700377, 10, 259, 'Sailor''s Ring', 'Interact', '', '', 0.8, 0),
(9700378, 10, 259, 'Salvaged Cannon', 'Interact', '', '', 0.8, 0),
(9700379, 10, 259, 'Snow Shovel', 'Interact', '', '', 0.8, 0),
(9700380, 10, 259, 'Spicy Candle', 'Interact', '', '', 0.8, 0),
(9700381, 10, 259, 'Thawed Boots', 'Interact', '', '', 0.8, 0),
(9700382, 10, 259, 'Throwing Rock', 'Interact', '', '', 0.8, 0),
(9700383, 10, 259, 'Throwing Rock', 'Interact', '', '', 0.8, 0),
(9700384, 10, 259, 'Warm Whoolies', 'Interact', '', '', 0.8, 0),
(9700385, 10, 323, 'Abandoned Peon''s Sack', 'Interact', '', '', 1.0, 0),
(9700386, 10, 130, 'Apprentice Staff', 'Interact', '', '', 0.7, 0),
(9700387, 10, 259, 'Apprentice''s Harpoon', 'Interact', '', '', 0.8, 0),
(9700388, 10, 259, 'Apprentice''s Harpoon', 'Interact', '', '', 0.8, 0),
(9700389, 10, 259, 'Bloodtalon Vestments', 'Interact', '', '', 0.8, 0),
(9700390, 10, 130, 'Bramble Shield', 'Interact', '', '', 0.7, 0),
(9700391, 10, 130, 'Burning Blade Ring', 'Interact', '', '', 0.7, 0),
(9700392, 10, 130, 'Centaur Axe', 'Interact', '', '', 0.7, 0),
(9700393, 10, 130, 'Centaur Axe', 'Interact', '', '', 0.7, 0),
(9700394, 10, 259, 'Champion''s Band', 'Interact', '', '', 0.8, 0),
(9700395, 10, 259, 'Champion''s Band', 'Interact', '', '', 0.8, 0),
(9700396, 10, 259, 'Charred Battlegreaves', 'Interact', '', '', 0.8, 0),
(9700397, 10, 259, 'Earthshatterer Gavel', 'Interact', '', '', 0.8, 0),
(9700398, 10, 259, 'Farm Hands', 'Interact', '', '', 0.8, 0),
(9700399, 10, 259, 'Firestarter', 'Interact', '', '', 0.8, 0),
(9700400, 10, 259, 'Firestarter', 'Interact', '', '', 0.8, 0),
(9700401, 10, 130, 'Grunt''s Old Knife', 'Interact', '', '', 0.7, 0),
(9700402, 10, 259, 'Harpy Hunter', 'Interact', '', '', 0.8, 0),
(9700403, 10, 259, 'Harpy Hunter', 'Interact', '', '', 0.8, 0),
(9700404, 10, 259, 'Kul Tiras Armplates', 'Interact', '', '', 0.8, 0),
(9700405, 10, 259, 'Kul Tiras Handwraps', 'Interact', '', '', 0.8, 0),
(9700406, 10, 137, 'Logsplitter', 'Interact', '', '', 0.6, 0),
(9700407, 10, 137, 'Logsplitter', 'Interact', '', '', 0.6, 0),
(9700408, 10, 259, 'Margoz'' Spare Stompers', 'Interact', '', '', 0.8, 0),
(9700409, 10, 259, 'Orcish Fishing Device', 'Interact', '', '', 0.8, 0),
(9700410, 10, 130, 'Quilbow', 'Interact', '', '', 0.7, 0),
(9700411, 10, 259, 'Raptorscale Cloak', 'Interact', '', '', 0.8, 0),
(9700412, 10, 323, 'Ravine Sack', 'Interact', '', '', 1.0, 0),
(9700413, 10, 259, 'Redrock Sash', 'Interact', '', '', 0.8, 0),
(9700414, 10, 259, 'Retired Grunt''s Chainmail', 'Interact', '', '', 0.8, 0),
(9700415, 10, 130, 'Retired Shadow Blade', 'Interact', '', '', 0.7, 0),
(9700416, 10, 259, 'Sailor''s Cuffs', 'Interact', '', '', 0.8, 0),
(9700417, 10, 259, 'Sailor''s Gambeson', 'Interact', '', '', 0.8, 0),
(9700418, 10, 259, 'Sailor''s Gambeson', 'Interact', '', '', 0.8, 0),
(9700419, 10, 323, 'Scalper''s Sack', 'Interact', '', '', 1.0, 0),
(9700420, 10, 323, 'Scalper''s Sack', 'Interact', '', '', 1.0, 0),
(9700421, 10, 293, 'Skull Ring', 'Interact', '', '', 1.0, 0),
(9700422, 10, 130, 'Skull Sword', 'Interact', '', '', 0.7, 0),
(9700423, 10, 259, 'Southfury Totem', 'Interact', '', '', 0.8, 0),
(9700424, 10, 259, 'Southfury Totem', 'Interact', '', '', 0.8, 0),
(9700425, 10, 130, 'Stormwitch Staff', 'Interact', '', '', 0.7, 0),
(9700426, 10, 130, 'Stormwitch Staff', 'Interact', '', '', 0.7, 0),
(9700427, 10, 259, 'String of Ears', 'Interact', '', '', 0.8, 0),
(9700428, 10, 259, 'Thunder Hide Tailspike', 'Interact', '', '', 0.8, 0),
(9700429, 10, 130, 'Totem Charged Mace', 'Interact', '', '', 0.7, 0),
(9700430, 10, 130, 'Totem Charged Mace', 'Interact', '', '', 0.7, 0),
(9700431, 10, 259, 'Treasured Cutlass', 'Interact', '', '', 0.8, 0),
(9700432, 10, 259, 'Wristguards of the Elements', 'Interact', '', '', 0.8, 0),
(9700433, 10, 259, 'Catacombs Relic Torch', 'Interact', '', '', 0.8, 0),
(9700434, 10, 32, 'Casket Will', 'Interact', '', '', 0.9, 0),
(9700435, 10, 259, 'Catacombs Relic Torch', 'Interact', '', '', 0.8, 0),
(9700436, 10, 259, 'Cursed Toy', 'Interact', '', '', 0.8, 0),
(9700437, 10, 259, 'Cursed Toy', 'Interact', '', '', 0.8, 0),
(9700438, 10, 259, 'Catacombs Torch', 'Interact', '', '', 0.8, 0),
(9700439, 10, 130, 'Defias Night Blade', 'Interact', '', '', 0.7, 0),
(9700440, 10, 259, 'Haunted Bouquet', 'Interact', '', '', 0.8, 0),
(9700441, 10, 259, 'Eliza''s Pendant', 'Interact', '', '', 0.8, 0),
(9700442, 10, 259, 'Eliza''s Pendant', 'Interact', '', '', 0.8, 0),
(9700443, 10, 259, 'Emerald Shard', 'Interact', '', '', 0.8, 0),
(9700444, 10, 259, 'Hazard Mantle', 'Interact', '', '', 0.8, 0),
(9700445, 10, 259, 'Jack''s Toothpicker', 'Interact', '', '', 0.8, 0),
(9700446, 10, 323, 'Lohgan''s Best Bag', 'Interact', '', '', 1.0, 0),
(9700447, 10, 137, 'Madness Cursed Notes', 'Interact', '', '', 0.6, 0),
(9700448, 10, 323, 'Munitions Delivery Package', 'Interact', '', '', 1.0, 0),
(9700449, 10, 259, 'Nightshot', 'Interact', '', '', 0.8, 0),
(9700450, 10, 259, 'Nightshot', 'Interact', '', '', 0.8, 0),
(9700451, 10, 259, 'Nightwatch Circlet', 'Interact', '', '', 0.8, 0),
(9700452, 10, 259, 'Nightwatch Circlet', 'Interact', '', '', 0.8, 0),
(9700453, 10, 323, 'Pack Lead Bone Ring', 'Interact', '', '', 1.0, 0),
(9700454, 10, 259, 'Peculiar Root', 'Interact', '', '', 0.8, 0),
(9700455, 10, 259, 'Peculiar Root', 'Interact', '', '', 0.8, 0),
(9700456, 10, 259, 'Hazard Mantle', 'Interact', '', '', 0.8, 0),
(9700457, 10, 259, 'Raven Hill Backscratcher', 'Interact', '', '', 0.8, 0),
(9700458, 10, 259, 'Roland''s Striker', 'Interact', '', '', 0.8, 0),
(9700459, 10, 259, 'Roland''s Striker', 'Interact', '', '', 0.8, 0),
(9700460, 10, 259, 'Ruby Skeletal Ring', 'Interact', '', '', 0.8, 0),
(9700461, 10, 259, 'Ruby Skeletal Ring', 'Interact', '', '', 0.8, 0),
(9700462, 10, 323, 'Sack of Regenerating Provisions', 'Interact', '', '', 1.0, 0),
(9700463, 10, 259, 'Silky Spaulders', 'Interact', '', '', 0.8, 0),
(9700464, 10, 259, 'Suspiciously Brown Trousers', 'Interact', '', '', 0.8, 0),
(9700465, 10, 259, 'The Dark Soul', 'Interact', '', '', 0.8, 0),
(9700466, 10, 259, 'The Jitters', 'Interact', '', '', 0.8, 0),
(9700467, 10, 259, 'The Jitters', 'Interact', '', '', 0.8, 0),
(9700468, 10, 259, 'Tiloa''s Flowers', 'Interact', '', '', 0.8, 0),
(9700469, 10, 259, 'Venom Sample', 'Interact', '', '', 0.8, 0),
(9700470, 10, 259, 'Vul''Gol Torch', 'Interact', '', '', 0.8, 0),
(9700471, 10, 259, 'Vul''Gol Torch', 'Interact', '', '', 0.8, 0),
(9700472, 10, 259, 'Beezil''s Pants', 'Interact', '', '', 0.8, 0),
(9700473, 10, 259, 'Blackhoof Warmaul', 'Interact', '', '', 0.8, 0),
(9700474, 10, 259, 'Blackhoof Warmaul', 'Interact', '', '', 0.8, 0),
(9700475, 10, 259, 'Bloodfen Prowler Vest', 'Interact', '', '', 0.8, 0),
(9700476, 10, 259, 'Raptor Talon', 'Interact', '', '', 0.8, 0),
(9700477, 10, 259, 'Burnt Spaulders', 'Interact', '', '', 0.8, 0),
(9700478, 10, 259, 'Buzzcoil Tongs', 'Interact', '', '', 0.8, 0),
(9700479, 10, 259, 'Corrupted Dragon Eye', 'Interact', '', '', 0.8, 0),
(9700480, 10, 259, 'Crokolisk Hunter', 'Interact', '', '', 0.8, 0),
(9700481, 10, 259, 'Cylla''s Endless Potion', 'Interact', '', '', 0.8, 0),
(9700482, 10, 259, 'Cylla''s Endless Potion', 'Interact', '', '', 0.8, 0),
(9700483, 10, 259, 'Denflame Channeler', 'Interact', '', '', 0.8, 0),
(9700484, 10, 259, 'Drywallow Gloves', 'Interact', '', '', 0.8, 0),
(9700485, 10, 259, 'Durn''s Loot Bag', 'Interact', '', '', 0.8, 0),
(9700486, 10, 259, 'Emberheart Talisman', 'Interact', '', '', 0.8, 0),
(9700487, 10, 130, 'Emberscale Greatsword', 'Interact', '', '', 0.7, 0),
(9700488, 10, 130, 'Emberstring Drakebow', 'Interact', '', '', 0.7, 0),
(9700489, 10, 130, 'Emberstring Drakebow', 'Interact', '', '', 0.7, 0),
(9700490, 10, 293, 'Enchanted Dragon Bone', 'Interact', '', '', 1.0, 0),
(9700491, 10, 259, 'Inscribed Sash', 'Interact', '', '', 0.8, 0),
(9700492, 10, 259, 'Last Guardian', 'Interact', '', '', 0.8, 0),
(9700493, 10, 259, 'Last Guardian', 'Interact', '', '', 0.8, 0),
(9700494, 10, 259, 'Marshfall Mantle', 'Interact', '', '', 0.8, 0),
(9700495, 10, 259, 'Missing Apprentice Wand', 'Interact', '', '', 0.8, 0),
(9700496, 10, 259, 'Missing Apprentice Wand', 'Interact', '', '', 0.8, 0),
(9700497, 10, 259, 'Mudcrush Shoulders', 'Interact', '', '', 0.8, 0),
(9700498, 10, 259, 'Northpoint Helmet', 'Interact', '', '', 0.8, 0),
(9700499, 10, 259, 'Primitive Murloc Skewer', 'Interact', '', '', 0.8, 0),
(9700500, 10, 259, 'Primitive Murloc Skewer', 'Interact', '', '', 0.8, 0),
(9700501, 10, 130, 'Salt Scoured Boarding Axe', 'Interact', '', '', 0.7, 0),
(9700502, 10, 259, 'Scorched Bindings', 'Interact', '', '', 0.8, 0),
(9700503, 10, 259, 'Seed of Overgrowth', 'Interact', '', '', 0.8, 0),
(9700504, 10, 259, 'Singed Flintlock', 'Interact', '', '', 0.8, 0),
(9700505, 10, 130, 'Spotter''s Rifle', 'Interact', '', '', 0.7, 0),
(9700506, 10, 130, 'Spotter''s Rifle', 'Interact', '', '', 0.7, 0),
(9700507, 10, 259, 'Stonemaul Crusher’s Girdle', 'Interact', '', '', 0.8, 0),
(9700508, 10, 259, 'Sturdy Coffin Lid', 'Interact', '', '', 0.8, 0),
(9700509, 10, 259, 'Sturdy Coffin Lid', 'Interact', '', '', 0.8, 0),
(9700510, 10, 259, 'Swamplight Concoction', 'Interact', '', '', 0.8, 0),
(9700511, 10, 259, 'Theramore Girdle', 'Interact', '', '', 0.8, 0),
(9700512, 10, 259, 'Tidefury Cutlass', 'Interact', '', '', 0.8, 0),
(9700513, 10, 130, 'Venomsilk Spellblade', 'Interact', '', '', 0.7, 0),
(9700514, 10, 259, 'Singed Flintlock', 'Interact', '', '', 0.8, 0),
(9700515, 10, 130, 'Woodcleaving Axe', 'Interact', '', '', 0.7, 0),
(9700516, 10, 130, 'Woodcleaving Axe', 'Interact', '', '', 0.7, 0),
(9700517, 10, 259, 'Argent Sentry Pauldrons', 'Interact', '', '', 0.8, 0),
(9700518, 10, 259, 'Assisting Hand', 'Interact', '', '', 0.8, 0),
(9700519, 10, 259, 'Blight Bomber', 'Interact', '', '', 0.8, 0),
(9700520, 10, 259, 'Bubbling Blood of Heroes', 'Interact', '', '', 0.8, 0),
(9700521, 10, 259, 'Severed Talon', 'Interact', '', '', 0.8, 0),
(9700522, 10, 259, 'Deadcapitator', 'Interact', '', '', 0.8, 0),
(9700523, 10, 259, 'Deathguard Vambraces', 'Interact', '', '', 0.8, 0),
(9700524, 10, 259, 'Deathwhisper Wand', 'Interact', '', '', 0.8, 0),
(9700525, 10, 259, 'Forbidden Fruit', 'Interact', '', '', 0.8, 0),
(9700526, 10, 259, 'Fungal Cleaver', 'Interact', '', '', 0.8, 0),
(9700527, 10, 259, 'Gravewood Belt', 'Interact', '', '', 0.8, 0),
(9700528, 10, 259, 'Eboncrypt Band', 'Interact', '', '', 0.8, 0),
(9700529, 10, 259, 'Malleus Haereticorum', 'Interact', '', '', 0.8, 0),
(9700530, 10, 259, 'Plague Fiend Chain', 'Interact', '', '', 0.8, 0),
(9700531, 10, 259, 'Plague Purger', 'Interact', '', '', 0.8, 0),
(9700532, 10, 130, 'Plaguebloom Spear', 'Interact', '', '', 0.7, 0),
(9700533, 10, 259, 'Plagued Pitchfork', 'Interact', '', '', 0.8, 0),
(9700534, 10, 259, 'Quel''thalas Commander Aegis', 'Interact', '', '', 0.8, 0),
(9700535, 10, 130, 'Ravenridge Shotgun', 'Interact', '', '', 0.7, 0),
(9700536, 10, 259, 'Cryptfiend Fang', 'Interact', '', '', 0.8, 0),
(9700537, 10, 259, 'Resilient Stompers', 'Interact', '', '', 0.8, 0),
(9700538, 10, 259, 'Revival Garments', 'Interact', '', '', 0.8, 0),
(9700539, 10, 259, 'Ring of Memorial', 'Interact', '', '', 0.8, 0),
(9700540, 10, 130, 'Scarlet Crossbow', 'Interact', '', '', 0.7, 0),
(9700541, 10, 259, 'Scarlet Doctrine', 'Interact', '', '', 0.8, 0),
(9700542, 10, 130, 'Scorched Runeblade', 'Interact', '', '', 0.7, 0),
(9700543, 10, 259, 'Scourge Cloak', 'Interact', '', '', 0.8, 0),
(9700544, 10, 259, 'Spiritwoven Vestments', 'Interact', '', '', 0.8, 0),
(9700545, 10, 130, 'Tainted Wasteblade', 'Interact', '', '', 0.7, 0),
(9700546, 10, 130, 'The Silver Blade', 'Interact', '', '', 0.7, 0),
(9700547, 10, 259, 'Wailing Spirit Amulet', 'Interact', '', '', 0.8, 0),
(9700548, 10, 259, 'Watchman Helm', 'Interact', '', '', 0.8, 0),
(9700549, 10, 259, 'Boar Harvester', 'Interact', '', '', 0.8, 0),
(9700550, 10, 293, 'Bones to Gnaw', 'Interact', '', '', 1.0, 0),
(9700551, 10, 293, 'Bones to Munch', 'Interact', '', '', 1.0, 0),
(9700552, 10, 259, 'Decayed Breeches', 'Interact', '', '', 0.8, 0),
(9700553, 10, 259, 'Defias Cowl', 'Interact', '', '', 0.8, 0),
(9700554, 10, 259, 'Defias Cowl', 'Interact', '', '', 0.8, 0),
(9700555, 10, 259, 'Defias Shanker', 'Interact', '', '', 0.8, 0),
(9700556, 10, 259, 'Defias Shanker', 'Interact', '', '', 0.8, 0),
(9700557, 10, 259, 'Defias Special Bucket', 'Interact', '', '', 0.8, 0),
(9700558, 10, 259, 'Eastvale Buckler', 'Interact', '', '', 0.8, 0),
(9700559, 10, 259, 'Enchanted Kobold Lantern', 'Interact', '', '', 0.8, 0),
(9700560, 10, 259, 'Enchanted Kobold Lantern', 'Interact', '', '', 0.8, 0),
(9700561, 10, 259, 'Enchanted Straw Appendage', 'Interact', '', '', 0.8, 0),
(9700562, 10, 259, 'Fisherman''s Jerkin', 'Interact', '', '', 0.8, 0),
(9700563, 10, 259, 'Heavy Iron Pan', 'Interact', '', '', 0.8, 0),
(9700564, 10, 259, 'Heavy Iron Pan', 'Interact', '', '', 0.8, 0),
(9700565, 10, 137, 'Heavy Logsplitter', 'Interact', '', '', 0.6, 0),
(9700566, 10, 259, 'Jack''s Toothpicker', 'Interact', '', '', 0.8, 0),
(9700567, 10, 259, 'Lexicon Ring', 'Interact', '', '', 0.8, 0),
(9700568, 10, 259, 'Lookout Scope', 'Interact', '', '', 0.8, 0),
(9700569, 10, 259, 'Loop of the Sly Rogue', 'Interact', '', '', 0.8, 0),
(9700570, 10, 259, 'Loop of the Sly Rogue', 'Interact', '', '', 0.8, 0),
(9700571, 10, 259, 'Mauled Armplates', 'Interact', '', '', 0.8, 0),
(9700572, 10, 259, 'Murder Machete', 'Interact', '', '', 0.8, 0),
(9700573, 10, 259, 'Murder Machete', 'Interact', '', '', 0.8, 0),
(9700574, 10, 130, 'Murloc Ritual Staff', 'Interact', '', '', 0.7, 0),
(9700575, 10, 259, 'Murloc Voodoo Doll', 'Interact', '', '', 0.8, 0),
(9700576, 10, 259, 'Party Pants', 'Interact', '', '', 0.8, 0),
(9700577, 10, 259, 'Plundered Goldshire Vanguard', 'Interact', '', '', 0.8, 0),
(9700578, 10, 130, 'Poacher''s Crossbow', 'Interact', '', '', 0.7, 0),
(9700579, 10, 259, 'Riding Cloak', 'Interact', '', '', 0.8, 0),
(9700580, 10, 259, 'Riding Cloak', 'Interact', '', '', 0.8, 0),
(9700581, 10, 259, 'Smuggled Stormwind Choker', 'Interact', '', '', 0.8, 0),
(9700582, 10, 259, 'Stormwind Memento', 'Interact', '', '', 0.8, 0),
(9700583, 10, 259, 'The Vanishing Strap', 'Interact', '', '', 0.8, 0),
(9700584, 10, 130, 'Thunder Falls Finest Gun Selection', 'Interact', '', '', 0.7, 0),
(9700585, 10, 259, 'Traveler''s Forest Cloak', 'Interact', '', '', 0.8, 0),
(9700586, 10, 323, 'Wax Stained Bag', 'Interact', '', '', 1.0, 0),
(9700587, 10, 259, 'Worn Shovel', 'Interact', '', '', 0.8, 0),
(9700588, 10, 259, 'Worn Shovel', 'Interact', '', '', 0.8, 0),
(9700589, 10, 259, 'Acid Bolter', 'Interact', '', '', 0.8, 0),
(9700590, 10, 259, 'Bubbling Fel Mixture', 'Interact', '', '', 0.8, 0),
(9700591, 10, 259, 'Emerald Circle Charm', 'Interact', '', '', 0.8, 0),
(9700592, 10, 259, 'Fallen Sentinel''s Leggings', 'Interact', '', '', 0.8, 0),
(9700593, 10, 259, 'Felhound Tendril', 'Interact', '', '', 0.8, 0),
(9700594, 10, 259, 'Heart of the Warpwood', 'Interact', '', '', 0.8, 0),
(9700595, 10, 259, 'Infernal Tender', 'Interact', '', '', 0.8, 0),
(9700596, 10, 259, 'Jadefire Piercer', 'Interact', '', '', 0.8, 0),
(9700597, 10, 259, 'Jaednar Spire', 'Interact', '', '', 0.8, 0),
(9700598, 10, 18, 'Lost Shipment Wristguards', 'Interact', '', '', 0.9, 0),
(9700599, 10, 259, 'Ror''s Wrecker', 'Interact', '', '', 0.8, 0),
(9700600, 10, 259, 'Talonbranch Sweeper', 'Interact', '', '', 0.8, 0),
(9700601, 10, 259, 'Timbermaw Defender', 'Interact', '', '', 0.8, 0),
(9700602, 10, 259, 'Timbermaw Girdle', 'Interact', '', '', 0.8, 0),
(9700603, 10, 259, 'Timelost Vestments ', 'Interact', '', '', 0.8, 0);
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `VerifiedBuild`) VALUES
(9700604, 10, 259, 'Accursed Yeti Horn', 'Interact', '', '', 0.8, 0),
(9700605, 10, 259, 'Accursed Yeti Horn', 'Interact', '', '', 0.8, 0),
(9700606, 10, 259, 'Ambercoil Pendant', 'Interact', '', '', 0.8, 0),
(9700607, 10, 323, 'Ancient Elvish Bag', 'Interact', '', '', 1.0, 0),
(9700608, 10, 259, 'Band of Scales', 'Interact', '', '', 0.8, 0),
(9700609, 10, 259, 'Bench Breaker', 'Interact', '', '', 0.8, 0),
(9700610, 10, 259, 'Bloodscorn Ritual Kris', 'Interact', '', '', 0.8, 0),
(9700611, 10, 259, 'Buccaneer''s Barrier', 'Interact', '', '', 0.8, 0),
(9700612, 10, 259, 'Crown of Stone', 'Interact', '', '', 0.8, 0),
(9700613, 10, 259, 'Crown of Stone', 'Interact', '', '', 0.8, 0),
(9700614, 10, 259, 'Denrunner Tomahawk', 'Interact', '', '', 0.8, 0),
(9700615, 10, 259, 'Dormant Dreamscale', 'Interact', '', '', 0.8, 0),
(9700616, 10, 259, 'Dormant Dreamscale', 'Interact', '', '', 0.8, 0),
(9700617, 10, 259, 'Gilded Stone Bulwark', 'Interact', '', '', 0.8, 0),
(9700618, 10, 259, 'Gnoll Stompers', 'Interact', '', '', 0.8, 0),
(9700619, 10, 293, 'Gnoll-Gnawed Bone Bat', 'Interact', '', '', 1.0, 0),
(9700620, 10, 293, 'Gnoll-Gnawed Bone Bat', 'Interact', '', '', 1.0, 0),
(9700621, 10, 259, 'Ogre Chest', 'Interact', '', '', 0.8, 0),
(9700622, 10, 259, 'Ogre Cleaver', 'Interact', '', '', 0.8, 0),
(9700623, 10, 259, 'Grim Totem', 'Interact', '', '', 0.8, 0),
(9700624, 10, 259, 'Grim Totem', 'Interact', '', '', 0.8, 0),
(9700625, 10, 259, 'Grimtotem Outrider’s Vest', 'Interact', '', '', 0.8, 0),
(9700626, 10, 259, 'Grimtotem Relic', 'Interact', '', '', 0.8, 0),
(9700627, 10, 259, 'Hatestrike', 'Interact', '', '', 0.8, 0),
(9700628, 10, 259, 'Hatestrike', 'Interact', '', '', 0.8, 0),
(9700629, 10, 259, 'Heartwood Cleaver', 'Interact', '', '', 0.8, 0),
(9700630, 10, 259, 'Isildien Tender''s Wand', 'Interact', '', '', 0.8, 0),
(9700631, 10, 259, 'Lakebottom Treads', 'Interact', '', '', 0.8, 0),
(9700632, 10, 259, 'Moon-Infused Breeches', 'Interact', '', '', 0.8, 0),
(9700633, 10, 259, 'Moonlight Infused Band', 'Interact', '', '', 0.8, 0),
(9700634, 10, 259, 'Necklace of the Sunken Empire', 'Interact', '', '', 0.8, 0),
(9700635, 10, 259, 'Night Sentinel''s Aim', 'Interact', '', '', 0.8, 0),
(9700636, 10, 130, 'Nightfallen Longbow', 'Interact', '', '', 0.7, 0),
(9700637, 10, 130, 'Nightfallen Longbow', 'Interact', '', '', 0.7, 0),
(9700638, 10, 259, 'Ogre Cleaver', 'Interact', '', '', 0.8, 0),
(9700639, 10, 259, 'Ogre Kneepad', 'Interact', '', '', 0.8, 0),
(9700640, 10, 259, 'Orb of Isildien Echoes', 'Interact', '', '', 0.8, 0),
(9700641, 10, 259, 'Ravenwind Codex', 'Interact', '', '', 0.8, 0),
(9700642, 10, 259, 'Ravenwind Codex', 'Interact', '', '', 0.8, 0),
(9700643, 10, 130, 'Ravenwind Fangblade', 'Interact', '', '', 0.7, 0),
(9700644, 10, 259, 'Runestone Figurine', 'Interact', '', '', 0.8, 0),
(9700645, 10, 130, 'Savage Crossbow', 'Interact', '', '', 0.7, 0),
(9700646, 10, 259, 'Seamstress Scissors', 'Interact', '', '', 0.8, 0),
(9700647, 10, 259, 'Secluded Soothsayer''s Pipes', 'Interact', '', '', 0.8, 0),
(9700648, 10, 259, 'Secluded Soothsayer''s Pipes', 'Interact', '', '', 0.8, 0),
(9700649, 10, 130, 'Shattered Highborne Blade', 'Interact', '', '', 0.7, 0),
(9700650, 10, 130, 'Shattered Highborne Blade', 'Interact', '', '', 0.7, 0),
(9700651, 10, 259, 'Shen''dralar Slicer', 'Interact', '', '', 0.8, 0),
(9700652, 10, 130, 'Shen''dralar Staff', 'Interact', '', '', 0.7, 0),
(9700653, 10, 130, 'Shen''dralar Staff', 'Interact', '', '', 0.7, 0),
(9700654, 10, 259, 'Shimmering Silithid Carapace', 'Interact', '', '', 0.8, 0),
(9700655, 10, 130, 'Silithid Husk Shield', 'Interact', '', '', 0.7, 0),
(9700656, 10, 259, 'Solarsal Pendant', 'Interact', '', '', 0.8, 0),
(9700657, 10, 130, 'Staff of Twin Blossoms', 'Interact', '', '', 0.7, 0),
(9700658, 10, 259, 'Stolen Highborne Spaulders', 'Interact', '', '', 0.8, 0),
(9700659, 10, 259, 'Strider Shot', 'Interact', '', '', 0.8, 0),
(9700660, 10, 259, 'Tanner Gloves', 'Interact', '', '', 0.8, 0),
(9700661, 10, 259, 'Tidebaron’s Sigil', 'Interact', '', '', 0.8, 0),
(9700662, 10, 137, 'Tome of the Valiant', 'Interact', '', '', 0.6, 0),
(9700663, 10, 259, 'Torn Hide Spaulders', 'Interact', '', '', 0.8, 0),
(9700664, 10, 130, 'Wild Tracker Bindings', 'Interact', '', '', 0.7, 0),
(9700665, 10, 130, 'Woodpaw Greatblade', 'Interact', '', '', 0.7, 0),
(9700666, 10, 130, 'Woodpaw Greatblade', 'Interact', '', '', 0.7, 0),
(9700667, 10, 259, 'Worn Angler Cord', 'Interact', '', '', 0.8, 0),
(9700668, 10, 259, 'Yeti Napkin', 'Interact', '', '', 0.8, 0),
(9700669, 10, 259, 'Yeti Napkin', 'Interact', '', '', 0.8, 0),
(9700670, 10, 259, 'Zaetar''s Lost Heirloom', 'Interact', '', '', 0.8, 0),
(9700671, 10, 259, 'Zapping Rod', 'Interact', '', '', 0.8, 0),
(9700672, 10, 259, 'Ancient Durnholde Girdle', 'Interact', '', '', 0.8, 0),
(9700673, 10, 259, 'Bear Decapitator', 'Interact', '', '', 0.8, 0),
(9700674, 10, 130, 'Camouflaged Bow', 'Interact', '', '', 0.7, 0),
(9700675, 10, 130, 'Camouflaged Bow', 'Interact', '', '', 0.7, 0),
(9700676, 10, 130, 'Daggerspine Rod', 'Interact', '', '', 0.7, 0),
(9700677, 10, 259, 'Darrow Silverband', 'Interact', '', '', 0.8, 0),
(9700678, 10, 130, 'Deadman''s Dagger', 'Interact', '', '', 0.7, 0),
(9700679, 10, 130, 'Deadman''s Dagger', 'Interact', '', '', 0.7, 0),
(9700680, 10, 259, 'Deathstalker Cloak', 'Interact', '', '', 0.8, 0),
(9700681, 10, 259, 'Armor-Piercing Ammo Cache', 'Interact', '', '', 0.8, 0),
(9700682, 10, 259, 'Eroded Pit Fighter Knuckles', 'Interact', '', '', 0.8, 0),
(9700683, 10, 259, 'Eroded Pit Fighter Knuckles', 'Interact', '', '', 0.8, 0),
(9700684, 10, 259, 'Mysterious Crystal', 'Interact', '', '', 0.8, 0),
(9700685, 10, 259, 'Helcular''s Pendant', 'Interact', '', '', 0.8, 0),
(9700686, 10, 259, 'Heavy Shovel', 'Interact', '', '', 0.8, 0),
(9700687, 10, 259, 'Leftover Mining Trousers', 'Interact', '', '', 0.8, 0),
(9700688, 10, 259, 'Mismatched Shoulderpads', 'Interact', '', '', 0.8, 0),
(9700689, 10, 259, 'Misplaced Pitchfork', 'Interact', '', '', 0.8, 0),
(9700690, 10, 259, 'Misplaced Pitchfork', 'Interact', '', '', 0.8, 0),
(9700691, 10, 259, 'Mudsnout Effigy', 'Interact', '', '', 0.8, 0),
(9700692, 10, 259, 'Old Snapjaw Shell', 'Interact', '', '', 0.8, 0),
(9700693, 10, 130, 'Oracle''s Fishy Staff', 'Interact', '', '', 0.7, 0),
(9700694, 10, 259, 'Ray''s Farmhand', 'Interact', '', '', 0.8, 0),
(9700695, 10, 259, 'Syndicate Treads', 'Interact', '', '', 0.8, 0),
(9700696, 10, 130, 'Tarantula Hunter Rifle', 'Interact', '', '', 0.7, 0),
(9700697, 10, 130, 'Timelost Captain Shield', 'Interact', '', '', 0.7, 0),
(9700698, 10, 130, 'Abandoned Greatsword', 'Interact', '', '', 0.7, 0),
(9700699, 10, 130, 'Abandoned Greatsword', 'Interact', '', '', 0.7, 0),
(9700700, 10, 259, 'Brother''s Special Gift', 'Interact', '', '', 0.8, 0),
(9700701, 10, 259, 'Dark Iron Collar', 'Interact', '', '', 0.8, 0),
(9700702, 10, 259, 'Dark Iron Collar', 'Interact', '', '', 0.8, 0),
(9700703, 10, 259, 'Drowned Pendant', 'Interact', '', '', 0.8, 0),
(9700704, 10, 259, 'Dwarven Mail Gauntlets', 'Interact', '', '', 0.8, 0),
(9700705, 10, 259, 'Dwarven Sandals', 'Interact', '', '', 0.8, 0),
(9700706, 10, 259, 'Earthenwind Band', 'Interact', '', '', 0.8, 0),
(9700707, 10, 259, 'Frayed Backwrap', 'Interact', '', '', 0.8, 0),
(9700708, 10, 259, 'Frenzy Fin', 'Interact', '', '', 0.8, 0),
(9700709, 10, 293, 'Galgosh''s Other Bone', 'Interact', '', '', 1.0, 0),
(9700710, 10, 293, 'Galgosh''s Other Bone', 'Interact', '', '', 1.0, 0),
(9700711, 10, 259, 'Grizlak''s Candle', 'Interact', '', '', 0.8, 0),
(9700712, 10, 259, 'Grizlak''s Candle', 'Interact', '', '', 0.8, 0),
(9700713, 10, 130, 'Heavy Ogre Axe', 'Interact', '', '', 0.7, 0),
(9700714, 10, 130, 'Heavy Ogre Axe', 'Interact', '', '', 0.7, 0),
(9700715, 10, 259, 'Large Buzzard Talon', 'Interact', '', '', 0.8, 0),
(9700716, 10, 259, 'Large Buzzard Talon', 'Interact', '', '', 0.8, 0),
(9700717, 10, 259, 'Lost Traveler''s Ring', 'Interact', '', '', 0.8, 0),
(9700718, 10, 259, 'Miner''s League Vest', 'Interact', '', '', 0.8, 0),
(9700719, 10, 259, 'Miner''s League Vest', 'Interact', '', '', 0.8, 0),
(9700720, 10, 130, 'Mountaineer Hatchet', 'Interact', '', '', 0.7, 0),
(9700721, 10, 259, 'Chok''sul''s Basket', 'Interact', '', '', 0.8, 0),
(9700722, 10, 259, 'Ol'' Blunderbuss', 'Interact', '', '', 0.8, 0),
(9700723, 10, 259, 'Ol'' Blunderbuss', 'Interact', '', '', 0.8, 0),
(9700724, 10, 259, 'Old Stitched Bindings', 'Interact', '', '', 0.8, 0),
(9700725, 10, 130, 'Scrap Shield', 'Interact', '', '', 0.7, 0),
(9700726, 10, 259, 'Sinter Wive''s Rope', 'Interact', '', '', 0.8, 0),
(9700727, 10, 259, 'Sinter Wive''s Rope', 'Interact', '', '', 0.8, 0),
(9700728, 10, 259, 'Spider Silk Vestments', 'Interact', '', '', 0.8, 0),
(9700729, 10, 259, 'Stolen Mountaineer Chest', 'Interact', '', '', 0.8, 0),
(9700730, 10, 259, 'Stoneflow Handwraps', 'Interact', '', '', 0.8, 0),
(9700731, 10, 130, 'Sword of Stone', 'Interact', '', '', 0.7, 0),
(9700732, 10, 130, 'Sword of Stone', 'Interact', '', '', 0.7, 0),
(9700733, 10, 259, 'Tattered Shoulders', 'Interact', '', '', 0.8, 0),
(9700734, 10, 259, 'Tunnel Rat Pike', 'Interact', '', '', 0.8, 0),
(9700735, 10, 259, 'Tunnel Rat Pike', 'Interact', '', '', 0.8, 0),
(9700736, 10, 130, 'Vermin Staff', 'Interact', '', '', 0.7, 0),
(9700737, 10, 259, 'Aloof Tauren''s Herbs', 'Interact', '', '', 0.8, 0),
(9700738, 10, 130, 'Ancestor''s Axe', 'Interact', '', '', 0.7, 0),
(9700739, 10, 259, 'Bloodied Torn Bracers', 'Interact', '', '', 0.8, 0),
(9700740, 10, 259, 'Bristleback Quill', 'Interact', '', '', 0.8, 0),
(9700741, 10, 130, 'Bristleback Staff', 'Interact', '', '', 0.7, 0),
(9700742, 10, 130, 'Bristleback Staff', 'Interact', '', '', 0.7, 0),
(9700743, 10, 259, 'Cord of Reverence', 'Interact', '', '', 0.8, 0),
(9700744, 10, 259, 'Dakota Steppe Greaves', 'Interact', '', '', 0.8, 0),
(9700745, 10, 259, 'Discarded Wagon Wheel', 'Interact', '', '', 0.8, 0),
(9700746, 10, 259, 'Pauldrons of Shadow', 'Interact', '', '', 0.8, 0),
(9700747, 10, 259, 'Galak Smasher', 'Interact', '', '', 0.8, 0),
(9700748, 10, 130, 'Golden Plains Crossbow', 'Interact', '', '', 0.7, 0),
(9700749, 10, 259, 'Hawkrunner Bracers', 'Interact', '', '', 0.8, 0),
(9700750, 10, 259, 'Interloper''s Loop', 'Interact', '', '', 0.8, 0),
(9700751, 10, 259, 'Interloper''s Loop', 'Interact', '', '', 0.8, 0),
(9700752, 10, 259, 'Kodo Beast Idol', 'Interact', '', '', 0.8, 0),
(9700753, 10, 293, 'Large Kodo Bone', 'Interact', '', '', 1.0, 0),
(9700754, 10, 130, 'Long Fishing Spear', 'Interact', '', '', 0.7, 0),
(9700755, 10, 130, 'Long Fishing Spear', 'Interact', '', '', 0.7, 0),
(9700756, 10, 130, 'Pilfered Bloodhoof Bow', 'Interact', '', '', 0.7, 0),
(9700757, 10, 130, 'Plainsblade', 'Interact', '', '', 0.7, 0),
(9700758, 10, 259, 'Snaggle''s Engage Whistle', 'Interact', '', '', 0.8, 0),
(9700759, 10, 259, 'Snaggle''s Engage Whistle', 'Interact', '', '', 0.8, 0),
(9700760, 10, 130, 'Steppereaver Hatchet', 'Interact', '', '', 0.7, 0),
(9700761, 10, 259, 'Stolen Tauren Cloak', 'Interact', '', '', 0.8, 0),
(9700762, 10, 130, 'Sunchaser Blade', 'Interact', '', '', 0.7, 0),
(9700763, 10, 259, 'Thornmantle Quills', 'Interact', '', '', 0.8, 0),
(9700764, 10, 259, 'Thunderwalk Breastplate', 'Interact', '', '', 0.8, 0),
(9700765, 10, 323, 'Travel Sack', 'Interact', '', '', 1.0, 0),
(9700766, 10, 259, 'Venture Co. Ring', 'Interact', '', '', 0.8, 0),
(9700767, 10, 259, 'Venture Co. Unique Concoction', 'Interact', '', '', 0.8, 0),
(9700768, 10, 259, 'Venture Co. Unique Concoction', 'Interact', '', '', 0.8, 0),
(9700769, 10, 259, 'Windfury Harpy Claw', 'Interact', '', '', 0.8, 0),
(9700770, 10, 130, 'Adventurer''s Crossbow', 'Interact', '', '', 0.7, 0),
(9700771, 10, 259, 'Alther''s Chain Wrap', 'Interact', '', '', 0.8, 0),
(9700772, 10, 259, 'Aqualon''s Bolt', 'Interact', '', '', 0.8, 0),
(9700773, 10, 259, 'Blackrock Render', 'Interact', '', '', 0.8, 0),
(9700774, 10, 259, 'Blackrock Summoner''s Garb', 'Interact', '', '', 0.8, 0),
(9700775, 10, 130, 'Blackrock Waraxe', 'Interact', '', '', 0.7, 0),
(9700776, 10, 259, 'Dirtpaw Trousers', 'Interact', '', '', 0.8, 0),
(9700777, 10, 259, 'Dragon Matriarch Cloak', 'Interact', '', '', 0.8, 0),
(9700778, 10, 259, 'Everstill Claymore', 'Interact', '', '', 0.8, 0),
(9700779, 10, 259, 'Gnoll Cap', 'Interact', '', '', 0.8, 0),
(9700780, 10, 259, 'Gnoll Crafted Spaulder', 'Interact', '', '', 0.8, 0),
(9700781, 10, 130, 'Mongrel Blade', 'Interact', '', '', 0.7, 0),
(9700782, 10, 259, 'Mrrrllrl Stick', 'Interact', '', '', 0.8, 0),
(9700783, 10, 259, 'Old Redridge Buckler', 'Interact', '', '', 0.8, 0),
(9700784, 10, 137, 'Old War Tome', 'Interact', '', '', 0.6, 0),
(9700785, 10, 259, 'Red Mage Wand', 'Interact', '', '', 0.8, 0),
(9700786, 10, 259, 'Ring of the Lexicon', 'Interact', '', '', 0.8, 0),
(9700787, 10, 130, 'Rusty Redridge Rifle', 'Interact', '', '', 0.7, 0),
(9700788, 10, 259, 'Stonewatch Handwraps', 'Interact', '', '', 0.8, 0),
(9700789, 10, 259, 'Cultivated Blazethorn', 'Interact', '', '', 0.8, 0),
(9700790, 10, 259, 'Stonewatch Handwraps', 'Interact', '', '', 0.8, 0),
(9700791, 10, 259, 'Maddening Aura', 'Interact', '', '', 0.8, 0),
(9700792, 10, 259, 'Three Corner Cape', 'Interact', '', '', 0.8, 0),
(9700793, 10, 259, 'Three Corner Coil', 'Interact', '', '', 0.8, 0),
(9700794, 10, 130, 'Tidecaller''s Hammer', 'Interact', '', '', 0.7, 0),
(9700795, 10, 259, 'Yowler''s Howl', 'Interact', '', '', 0.8, 0),
(9700796, 10, 259, 'Break-time Gloves', 'Interact', '', '', 0.8, 0),
(9700797, 10, 130, 'Burned Blade Shiv', 'Interact', '', '', 0.7, 0),
(9700798, 10, 130, 'Caravan Crossbow', 'Interact', '', '', 0.7, 0),
(9700799, 10, 259, 'Cogbolt''s Special', 'Interact', '', '', 0.8, 0),
(9700800, 10, 259, 'Contraband Magician Rod', 'Interact', '', '', 0.8, 0),
(9700801, 10, 259, 'Dark Iron Hood', 'Interact', '', '', 0.8, 0),
(9700802, 10, 259, 'Dark Iron Leatherpads', 'Interact', '', '', 0.8, 0),
(9700803, 10, 259, 'Dark Iron Legplates', 'Interact', '', '', 0.8, 0),
(9700804, 10, 259, 'Dark Iron Loop', 'Interact', '', '', 0.8, 0),
(9700805, 10, 259, 'Dark Iron Scorcher', 'Interact', '', '', 0.8, 0),
(9700806, 10, 259, 'Dark Iron Slippers', 'Interact', '', '', 0.8, 0),
(9700807, 10, 259, 'Dark Iron Wristbands', 'Interact', '', '', 0.8, 0),
(9700808, 10, 130, 'Disciplinary Rifle', 'Interact', '', '', 0.7, 0),
(9700809, 10, 130, 'Dorius'' Shield', 'Interact', '', '', 0.7, 0),
(9700810, 10, 259, 'Elder Pipe', 'Interact', '', '', 0.8, 0),
(9700811, 10, 259, 'Eye of Twilight', 'Interact', '', '', 0.8, 0),
(9700812, 10, 259, 'Freedom Falchion', 'Interact', '', '', 0.8, 0),
(9700813, 10, 259, 'Glassweb Ward Shroud', 'Interact', '', '', 0.8, 0),
(9700814, 10, 259, 'Golem Chunk', 'Interact', '', '', 0.8, 0),
(9700815, 10, 259, 'Heavy War Golem Rune', 'Interact', '', '', 0.8, 0),
(9700816, 10, 293, 'Incendosaur Bone String', 'Interact', '', '', 1.0, 0),
(9700817, 10, 259, 'Magma Petting Mittens', 'Interact', '', '', 0.8, 0),
(9700818, 10, 259, 'Molten Fang Tooth', 'Interact', '', '', 0.8, 0),
(9700819, 10, 259, 'Overseer''s Mystic Wrench', 'Interact', '', '', 0.8, 0),
(9700820, 10, 130, 'Scorched Greatblade', 'Interact', '', '', 0.7, 0),
(9700821, 10, 259, 'Scorched Mail Tunic', 'Interact', '', '', 0.8, 0),
(9700822, 10, 259, 'Scorching Lodepebble', 'Interact', '', '', 0.8, 0),
(9700823, 10, 259, 'Shadowsilk Seared Cuirass', 'Interact', '', '', 0.8, 0),
(9700824, 10, 259, 'Sharp Chain Belt', 'Interact', '', '', 0.8, 0),
(9700825, 10, 259, 'Shoulderpads of Deep Thinking', 'Interact', '', '', 0.8, 0),
(9700826, 10, 259, 'Slave Band', 'Interact', '', '', 0.8, 0),
(9700827, 10, 259, 'Slave Worker Pantaloons', 'Interact', '', '', 0.8, 0),
(9700828, 10, 259, 'Stomped Diary', 'Interact', '', '', 0.8, 0),
(9700829, 10, 259, 'Ancient Sentinel Headdress', 'Interact', '', '', 0.8, 0),
(9700830, 10, 259, 'Bracers of the Bound Storm', 'Interact', '', '', 0.8, 0),
(9700831, 10, 130, 'Darnell''s Blade', 'Interact', '', '', 0.7, 0),
(9700832, 10, 259, 'Geo Band', 'Interact', '', '', 0.8, 0),
(9700833, 10, 259, 'Idol of Shifting Sands', 'Interact', '', '', 0.8, 0),
(9700834, 10, 259, 'Lost Cenarion Bolter', 'Interact', '', '', 0.8, 0),
(9700835, 10, 259, 'Purple Steppers', 'Interact', '', '', 0.8, 0),
(9700836, 10, 259, 'Sandstone Sniper', 'Interact', '', '', 0.8, 0),
(9700837, 10, 259, 'Sandstorm Shaper', 'Interact', '', '', 0.8, 0),
(9700838, 10, 259, 'Scarab Smasher', 'Interact', '', '', 0.8, 0),
(9700839, 10, 130, 'Standard Cenarion Spear', 'Interact', '', '', 0.7, 0),
(9700840, 10, 259, 'Twilight''s Presence', 'Interact', '', '', 0.8, 0),
(9700841, 10, 259, 'Wind Pendant', 'Interact', '', '', 0.8, 0),
(9700842, 10, 137, 'Alchemy Research Notes', 'Interact', '', '', 0.6, 0),
(9700843, 10, 259, 'Arcane Glinting Shard', 'Interact', '', '', 0.8, 0),
(9700844, 10, 259, 'Chain Belt of the Elements', 'Interact', '', '', 0.8, 0),
(9700845, 10, 259, 'Darkstrand Kilt', 'Interact', '', '', 0.8, 0),
(9700846, 10, 259, 'Fenris Ring', 'Interact', '', '', 0.8, 0),
(9700847, 10, 259, 'Gilnean Bolter', 'Interact', '', '', 0.8, 0),
(9700848, 10, 259, 'Gilnean Lance', 'Interact', '', '', 0.8, 0),
(9700849, 10, 259, 'Gilnean Monocle', 'Interact', '', '', 0.8, 0),
(9700850, 10, 259, 'Thule''s Curse Parchment', 'Interact', '', '', 0.8, 0),
(9700851, 10, 259, 'Grimson Cloak', 'Interact', '', '', 0.8, 0),
(9700852, 10, 293, 'Ivar''s Femur', 'Interact', '', '', 1.0, 0),
(9700853, 10, 259, 'Lordamere Cuffs', 'Interact', '', '', 0.8, 0),
(9700854, 10, 259, 'Dirt Covered Gown', 'Interact', '', '', 0.8, 0),
(9700855, 10, 259, 'Old Valgan Slippers', 'Interact', '', '', 0.8, 0),
(9700856, 10, 259, 'Poison Unguent Extract', 'Interact', '', '', 0.8, 0),
(9700857, 10, 293, 'Ravenclaw Bone Necklace', 'Interact', '', '', 1.0, 0),
(9700858, 10, 259, 'Ravenous Eye', 'Interact', '', '', 0.8, 0),
(9700859, 10, 259, 'Rot Hide Harness', 'Interact', '', '', 0.8, 0),
(9700860, 10, 259, 'Rot Hide Mantle', 'Interact', '', '', 0.8, 0),
(9700861, 10, 323, 'Sack of Pine Seeds', 'Interact', '', '', 1.0, 0),
(9700862, 10, 259, 'Small Claw of the Meat Wagon', 'Interact', '', '', 0.8, 0),
(9700863, 10, 259, 'Stolen Rot Hide Circlet', 'Interact', '', '', 0.8, 0),
(9700864, 10, 259, 'Thule''s Curse Parchment', 'Interact', '', '', 0.8, 0),
(9700865, 10, 32, 'Barrel Smasher', 'Interact', '', '', 0.9, 0),
(9700866, 10, 259, 'Bloodfury Feather Cloak', 'Interact', '', '', 0.8, 0),
(9700867, 10, 259, 'Boulder Greaves', 'Interact', '', '', 0.8, 0),
(9700868, 10, 259, 'Breastplate of the Current', 'Interact', '', '', 0.8, 0),
(9700869, 10, 259, 'Charred Spaulders', 'Interact', '', '', 0.8, 0),
(9700870, 10, 259, 'Cliffwalker Cuffs', 'Interact', '', '', 0.8, 0),
(9700871, 10, 259, 'Fire Strike', 'Interact', '', '', 0.8, 0),
(9700872, 10, 259, 'Fire Strike', 'Interact', '', '', 0.8, 0),
(9700873, 10, 259, 'Flower of Tranquility', 'Interact', '', '', 0.8, 0),
(9700874, 10, 259, 'Flower of Tranquility', 'Interact', '', '', 0.8, 0),
(9700875, 10, 259, 'Grim Sorcerer Totem', 'Interact', '', '', 0.8, 0),
(9700876, 10, 259, 'Grimtotem Striker', 'Interact', '', '', 0.8, 0),
(9700877, 10, 259, 'Grimtotem Striker', 'Interact', '', '', 0.8, 0),
(9700878, 10, 259, 'Huntress Threads', 'Interact', '', '', 0.8, 0),
(9700879, 10, 259, 'Resonite Band', 'Interact', '', '', 0.8, 0),
(9700880, 10, 259, 'Resonite Band', 'Interact', '', '', 0.8, 0),
(9700881, 10, 32, 'Barrel Smasher', 'Interact', '', '', 0.9, 0),
(9700882, 10, 130, 'Staff of Talons', 'Interact', '', '', 0.7, 0),
(9700883, 10, 130, 'Staff of Talons', 'Interact', '', '', 0.7, 0),
(9700884, 10, 259, 'Talon Idol', 'Interact', '', '', 0.8, 0),
(9700885, 10, 259, 'Talon Idol', 'Interact', '', '', 0.8, 0),
(9700886, 10, 323, 'Unclaimed Sack', 'Interact', '', '', 1.0, 0),
(9700887, 10, 323, 'Unclaimed Sack', 'Interact', '', '', 1.0, 0),
(9700888, 10, 259, 'Vengeful Heart', 'Interact', '', '', 0.8, 0),
(9700889, 10, 130, 'Venture Co. Logging Axe', 'Interact', '', '', 0.7, 0),
(9700890, 10, 259, 'Venture Co. Union Buster', 'Interact', '', '', 0.8, 0),
(9700891, 10, 259, 'Venture Co. Union Buster', 'Interact', '', '', 0.8, 0),
(9700892, 10, 259, 'Wind Shearer', 'Interact', '', '', 0.8, 0),
(9700893, 10, 259, 'Wind Shearer', 'Interact', '', '', 0.8, 0),
(9700894, 10, 130, 'Windsong Shortbow', 'Interact', '', '', 0.7, 0),
(9700895, 10, 259, 'Woven Ceremonial Belt', 'Interact', '', '', 0.8, 0),
(9700896, 10, 259, 'Wyvern Vest', 'Interact', '', '', 0.8, 0),
(9700897, 10, 259, 'Ziz''s Alchemy Goggles', 'Interact', '', '', 0.8, 0),
(9700898, 10, 259, 'Ziz''s Alchemy Goggles', 'Interact', '', '', 0.8, 0),
(9700899, 10, 259, 'A Guide to a Succubus'' Darkest Secrets', 'Interact', '', '', 0.8, 0),
(9700900, 10, 259, 'Ancient Sea-dweller Charm', 'Interact', '', '', 0.8, 0),
(9700901, 10, 130, 'Axe Swingers', 'Interact', '', '', 0.7, 0),
(9700902, 10, 259, 'Blackwater Booty Band', 'Interact', '', '', 0.8, 0),
(9700903, 10, 259, 'Bloodsail Decksweeper', 'Interact', '', '', 0.8, 0);
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `VerifiedBuild`) VALUES
(9700904, 10, 259, 'Bloodsail Decksweeper', 'Interact', '', '', 0.8, 0),
(9700905, 10, 130, 'Bloodsail Longbow', 'Interact', '', '', 0.7, 0),
(9700906, 10, 259, 'Bloodscalp Cord', 'Interact', '', '', 0.8, 0),
(9700907, 10, 293, 'Bloodscalp Skullpiercer', 'Interact', '', '', 1.0, 0),
(9700908, 10, 259, 'Bloodscalper', 'Interact', '', '', 0.8, 0),
(9700909, 10, 259, 'Bloodscalper', 'Interact', '', '', 0.8, 0),
(9700910, 10, 259, 'Buccaneer Shiv', 'Interact', '', '', 0.8, 0),
(9700911, 10, 259, 'Cannon Loaders', 'Interact', '', '', 0.8, 0),
(9700912, 10, 259, 'Cogwheel Band', 'Interact', '', '', 0.8, 0),
(9700913, 10, 259, 'Encased Amulet', 'Interact', '', '', 0.8, 0),
(9700914, 10, 130, 'Crystallized Shield', 'Interact', '', '', 0.7, 0),
(9700915, 10, 130, 'Crystallized Shield', 'Interact', '', '', 0.7, 0),
(9700916, 10, 259, 'Crystallized Wristguards', 'Interact', '', '', 0.8, 0),
(9700917, 10, 259, 'Depleted Elemental Lodestone', 'Interact', '', '', 0.8, 0),
(9700918, 10, 130, 'Fallen Gladiator''s Shield', 'Interact', '', '', 0.7, 0),
(9700919, 10, 130, 'Fallen Gladiator''s Shield', 'Interact', '', '', 0.7, 0),
(9700920, 10, 259, 'Gorilla Pelt', 'Interact', '', '', 0.8, 0),
(9700921, 10, 130, 'Grom''gol Hunting Rifle', 'Interact', '', '', 0.7, 0),
(9700922, 10, 130, 'Gurubashi Trainee Hatchet', 'Interact', '', '', 0.7, 0),
(9700923, 10, 259, 'Hull Breaker', 'Interact', '', '', 0.8, 0),
(9700924, 10, 259, 'Hull Breaker', 'Interact', '', '', 0.8, 0),
(9700925, 10, 259, 'Jose''s Best Slacks', 'Interact', '', '', 0.8, 0),
(9700926, 10, 259, 'Jubuwal Witchdoctor Amulet', 'Interact', '', '', 0.8, 0),
(9700927, 10, 259, 'Jungle Medicine Compendium', 'Interact', '', '', 0.8, 0),
(9700928, 10, 259, 'Jungle Defender', 'Interact', '', '', 0.8, 0),
(9700929, 10, 259, 'Jungle Defender', 'Interact', '', '', 0.8, 0),
(9700930, 10, 259, 'Jungle Medicine Compendium', 'Interact', '', '', 0.8, 0),
(9700931, 10, 259, 'Jungle Stalker Pauldrons', 'Interact', '', '', 0.8, 0),
(9700932, 10, 259, 'Jungle Stalker Pauldrons', 'Interact', '', '', 0.8, 0),
(9700933, 10, 259, 'Keelhaul''s Saber', 'Interact', '', '', 0.8, 0),
(9700934, 10, 259, 'Kurzen Eviscerator', 'Interact', '', '', 0.8, 0),
(9700935, 10, 259, 'Kurzen Eviscerator', 'Interact', '', '', 0.8, 0),
(9700936, 10, 130, 'Kurzen Madness Blade', 'Interact', '', '', 0.7, 0),
(9700937, 10, 259, 'Lazy Hat', 'Interact', '', '', 0.8, 0),
(9700938, 10, 259, 'Mangled Wraps', 'Interact', '', '', 0.8, 0),
(9700939, 10, 137, 'Martyr Cross Book', 'Interact', '', '', 0.6, 0),
(9700940, 10, 259, 'Mind''s Eye Fragment', 'Interact', '', '', 0.8, 0),
(9700941, 10, 259, 'Mok''rash''s Circlet', 'Interact', '', '', 0.8, 0),
(9700942, 10, 259, 'Mosh''Ogg Stave', 'Interact', '', '', 0.8, 0),
(9700943, 10, 259, 'Mosh''Ogg Totem', 'Interact', '', '', 0.8, 0),
(9700944, 10, 259, 'Mystic Druid Idol', 'Interact', '', '', 0.8, 0),
(9700945, 10, 259, 'Naga Throwing Trident', 'Interact', '', '', 0.8, 0),
(9700946, 10, 259, 'Nature''s Defiance', 'Interact', '', '', 0.8, 0),
(9700947, 10, 130, 'Nesingwary Tracking Boots', 'Interact', '', '', 0.7, 0),
(9700948, 10, 259, 'Panther Shredders', 'Interact', '', '', 0.8, 0),
(9700949, 10, 259, 'Pilfered Plate Pants', 'Interact', '', '', 0.8, 0),
(9700950, 10, 259, 'Premium Banana', 'Interact', '', '', 0.8, 0),
(9700951, 10, 259, 'Pristine Tethis Feather', 'Interact', '', '', 0.8, 0),
(9700952, 10, 259, 'Ravaged Shoulderpads', 'Interact', '', '', 0.8, 0),
(9700953, 10, 259, 'Rebel Runners', 'Interact', '', '', 0.8, 0),
(9700954, 10, 259, 'Riverheart Crest', 'Interact', '', '', 0.8, 0),
(9700955, 10, 259, 'Riverheart Crest', 'Interact', '', '', 0.8, 0),
(9700956, 10, 259, 'Sea Cleaver', 'Interact', '', '', 0.8, 0),
(9700957, 10, 259, 'Sharpened Raptor Tooth', 'Interact', '', '', 0.8, 0),
(9700958, 10, 259, 'Shiv of Warm Greetings', 'Interact', '', '', 0.8, 0),
(9700959, 10, 259, 'Shiv of Warm Greetings', 'Interact', '', '', 0.8, 0),
(9700960, 10, 130, 'Skullsplitter Crossbow', 'Interact', '', '', 0.7, 0),
(9700961, 10, 130, 'Skullsplitter Crossbow', 'Interact', '', '', 0.7, 0),
(9700962, 10, 259, 'Sky Shot Cloak', 'Interact', '', '', 0.8, 0),
(9700963, 10, 259, 'South Sea Dress', 'Interact', '', '', 0.8, 0),
(9700964, 10, 259, 'Special Seashell', 'Interact', '', '', 0.8, 0),
(9700965, 10, 259, 'Splinter Guard', 'Interact', '', '', 0.8, 0),
(9700966, 10, 259, 'Splinter Guard', 'Interact', '', '', 0.8, 0),
(9700967, 10, 259, 'Stonesplitter', 'Interact', '', '', 0.8, 0),
(9700968, 10, 259, 'Stonesplitter', 'Interact', '', '', 0.8, 0),
(9700969, 10, 259, 'The Compliance Crusher', 'Interact', '', '', 0.8, 0),
(9700970, 10, 259, 'The Ironjaw', 'Interact', '', '', 0.8, 0),
(9700971, 10, 259, 'The Ironjaw', 'Interact', '', '', 0.8, 0),
(9700972, 10, 259, 'The Wrangler', 'Interact', '', '', 0.8, 0),
(9700973, 10, 259, 'The Wrangler', 'Interact', '', '', 0.8, 0),
(9700974, 10, 259, 'Tinkering Belt', 'Interact', '', '', 0.8, 0),
(9700975, 10, 323, 'Traveler''s Lost Bag', 'Interact', '', '', 1.0, 0),
(9700976, 10, 259, 'Tribal Pads', 'Interact', '', '', 0.8, 0),
(9700977, 10, 293, 'Voodoo Bonemaker', 'Interact', '', '', 1.0, 0),
(9700978, 10, 293, 'Voodoo Bonemaker', 'Interact', '', '', 1.0, 0),
(9700979, 10, 259, 'Witchdoctor Mixing Gloves', 'Interact', '', '', 0.8, 0),
(9700980, 10, 259, 'Wizard Cuffs', 'Interact', '', '', 0.8, 0),
(9700981, 10, 293, 'Yojamba Hex Skull', 'Interact', '', '', 1.0, 0),
(9700982, 10, 259, 'Zul''Kunda Blood Ring', 'Interact', '', '', 0.8, 0),
(9700983, 10, 259, 'Zul''Kunda Blood Ring', 'Interact', '', '', 0.8, 0),
(9700984, 10, 259, 'Zul''Kunda Scout Vest', 'Interact', '', '', 0.8, 0),
(9700985, 10, 259, 'Zul''Kunda Tribe Trophy', 'Interact', '', '', 0.8, 0),
(9700986, 10, 130, 'Ancestral Warblade', 'Interact', '', '', 0.7, 0),
(9700987, 10, 259, 'Ancient Wagon Wheel', 'Interact', '', '', 0.8, 0),
(9700988, 10, 259, 'Ancient Wagon Wheel', 'Interact', '', '', 0.8, 0),
(9700989, 10, 130, 'Betrayer''s Blade', 'Interact', '', '', 0.7, 0),
(9700990, 10, 130, 'Betrayer''s Blade', 'Interact', '', '', 0.7, 0),
(9700991, 10, 259, 'Captain''s Compass', 'Interact', '', '', 0.8, 0),
(9700992, 10, 259, 'Captain''s Compass', 'Interact', '', '', 0.8, 0),
(9700993, 10, 259, 'Carapace Carver', 'Interact', '', '', 0.8, 0),
(9700994, 10, 259, 'Cyclok''s Sanity', 'Interact', '', '', 0.8, 0),
(9700995, 10, 259, 'Deadman Gauntlets', 'Interact', '', '', 0.8, 0),
(9700996, 10, 259, 'Deadman Gauntlets', 'Interact', '', '', 0.8, 0),
(9700997, 10, 259, 'Desert Gambeson', 'Interact', '', '', 0.8, 0),
(9700998, 10, 259, 'Dunecaller''s Spire', 'Interact', '', '', 0.8, 0),
(9700999, 10, 259, 'Dunecaller''s Spire', 'Interact', '', '', 0.8, 0),
(9701000, 10, 259, 'Dunemaul Crusher', 'Interact', '', '', 0.8, 0),
(9701001, 10, 259, 'Dunemaul Warbelt', 'Interact', '', '', 0.8, 0),
(9701002, 10, 259, 'Duneshot Armguards', 'Interact', '', '', 0.8, 0),
(9701003, 10, 259, 'Dustwhisper Legguards', 'Interact', '', '', 0.8, 0),
(9701004, 10, 130, 'Executioner''s Axe', 'Interact', '', '', 0.7, 0),
(9701005, 10, 130, 'Executioner''s Axe', 'Interact', '', '', 0.7, 0),
(9701006, 10, 259, 'Explorer''s Last Wish', 'Interact', '', '', 0.8, 0),
(9701007, 10, 259, 'Fisher''s Misfortune', 'Interact', '', '', 0.8, 0),
(9701008, 10, 259, 'Fisher''s Misfortune', 'Interact', '', '', 0.8, 0),
(9701009, 10, 130, 'High Seas Axe', 'Interact', '', '', 0.7, 0),
(9701010, 10, 130, 'High Seas Axe', 'Interact', '', '', 0.7, 0),
(9701011, 10, 259, 'Hivebreakers’ Ward', 'Interact', '', '', 0.8, 0),
(9701012, 10, 259, 'Wooden Plank', 'Interact', '', '', 0.8, 0),
(9701013, 10, 259, 'Inventor''s Sand Band', 'Interact', '', '', 0.8, 0),
(9701014, 10, 259, 'Last Stand', 'Interact', '', '', 0.8, 0),
(9701015, 10, 259, 'Lens of Questionable Visions', 'Interact', '', '', 0.8, 0),
(9701016, 10, 259, 'Lid of the Dead', 'Interact', '', '', 0.8, 0),
(9701017, 10, 259, 'Noon''s Shade Relic', 'Interact', '', '', 0.8, 0),
(9701018, 10, 259, 'Noon''s Shade Relic', 'Interact', '', '', 0.8, 0),
(9701019, 10, 259, 'Sand Cover', 'Interact', '', '', 0.8, 0),
(9701020, 10, 259, 'Sand Cover', 'Interact', '', '', 0.8, 0),
(9701021, 10, 259, 'Sand Polished Pauldrons', 'Interact', '', '', 0.8, 0),
(9701022, 10, 259, 'Sand Stompers', 'Interact', '', '', 0.8, 0),
(9701023, 10, 259, 'Sandfury Boomerang', 'Interact', '', '', 0.8, 0),
(9701024, 10, 259, 'Sandfury Boomerang', 'Interact', '', '', 0.8, 0),
(9701025, 10, 130, 'Sandfury Ritual Mace', 'Interact', '', '', 0.7, 0),
(9701026, 10, 130, 'Sandfury Ritual Mace', 'Interact', '', '', 0.7, 0),
(9701027, 10, 259, 'Sandswept Binding', 'Interact', '', '', 0.8, 0),
(9701028, 10, 259, 'Shellsplitter Girdle', 'Interact', '', '', 0.8, 0),
(9701029, 10, 259, 'Sky Guard''s Cuirass', 'Interact', '', '', 0.8, 0),
(9701030, 10, 259, 'Sorrow Bolter', 'Interact', '', '', 0.8, 0),
(9701031, 10, 259, 'Southmoon Amulet', 'Interact', '', '', 0.8, 0),
(9701032, 10, 259, 'Southmoon Amulet', 'Interact', '', '', 0.8, 0),
(9701033, 10, 259, 'Southsea Raider Gloves', 'Interact', '', '', 0.8, 0),
(9701034, 10, 259, 'Stylish Racing Hat', 'Interact', '', '', 0.8, 0),
(9701035, 10, 259, 'Tender''s Hat', 'Interact', '', '', 0.8, 0),
(9701036, 10, 259, 'Umbral Tear', 'Interact', '', '', 0.8, 0),
(9701037, 10, 259, 'The Wingman', 'Interact', '', '', 0.8, 0),
(9701038, 10, 259, 'The Wingman', 'Interact', '', '', 0.8, 0),
(9701039, 10, 259, 'Time Stream Slasher', 'Interact', '', '', 0.8, 0),
(9701040, 10, 259, 'Time Stream Slasher', 'Interact', '', '', 0.8, 0),
(9701041, 10, 259, 'Treasure Seeker''s Gloves', 'Interact', '', '', 0.8, 0),
(9701042, 10, 259, 'Treasure Seeking Lodestone', 'Interact', '', '', 0.8, 0),
(9701043, 10, 259, 'Venom-Infused Screwdriver', 'Interact', '', '', 0.8, 0),
(9701044, 10, 259, 'Wastewander Alchemist’s Robe', 'Interact', '', '', 0.8, 0),
(9701045, 10, 259, 'Watcher''s Mantle', 'Interact', '', '', 0.8, 0),
(9701046, 10, 259, 'Watcher''s Mantle', 'Interact', '', '', 0.8, 0),
(9701047, 10, 259, 'Water Binder', 'Interact', '', '', 0.8, 0),
(9701048, 10, 259, 'Water Binder', 'Interact', '', '', 0.8, 0),
(9701049, 10, 259, 'Wave Wraps', 'Interact', '', '', 0.8, 0),
(9701050, 10, 259, 'Winkey''s Misplaced Wrench', 'Interact', '', '', 0.8, 0),
(9701051, 10, 259, 'Arlithrien Moon Orb', 'Interact', '', '', 0.8, 0),
(9701052, 10, 259, 'Arlithrien Moon Orb', 'Interact', '', '', 0.8, 0),
(9701053, 10, 130, 'Blade of the Submerged Moon', 'Interact', '', '', 0.7, 0),
(9701054, 10, 259, 'Bloodfeather Wand', 'Interact', '', '', 0.8, 0),
(9701055, 10, 130, 'Chipped Sentinel Blade', 'Interact', '', '', 0.7, 0),
(9701056, 10, 259, 'Dewleaf Piercer', 'Interact', '', '', 0.8, 0),
(9701057, 10, 259, 'Furbolg War Drum', 'Interact', '', '', 0.8, 0),
(9701058, 10, 259, 'Gnarlpine Jerkin', 'Interact', '', '', 0.8, 0),
(9701059, 10, 259, 'Groveprowler Gloves', 'Interact', '', '', 0.8, 0),
(9701060, 10, 259, 'Harpy Feather Drape', 'Interact', '', '', 0.8, 0),
(9701061, 10, 259, 'Jar of Spiders', 'Interact', '', '', 0.8, 0),
(9701062, 10, 130, 'Lifesap Blade', 'Interact', '', '', 0.7, 0),
(9701063, 10, 137, 'Lunar Tome', 'Interact', '', '', 0.6, 0),
(9701064, 10, 137, 'Lunar Tome', 'Interact', '', '', 0.6, 0),
(9701065, 10, 259, 'Moonbathed Necklace', 'Interact', '', '', 0.8, 0),
(9701066, 10, 259, 'Moonwell Cane', 'Interact', '', '', 0.8, 0),
(9701067, 10, 259, 'Patched Verdant Cloak', 'Interact', '', '', 0.8, 0),
(9701068, 10, 259, 'Rootbark Girdle', 'Interact', '', '', 0.8, 0),
(9701069, 10, 259, 'Saplingweave Handwraps', 'Interact', '', '', 0.8, 0),
(9701070, 10, 259, 'Starfall Edge', 'Interact', '', '', 0.8, 0),
(9701071, 10, 259, 'Teldrassil Begonias', 'Interact', '', '', 0.8, 0),
(9701072, 10, 259, 'Thornpaw Trousers', 'Interact', '', '', 0.8, 0),
(9701073, 10, 259, 'Timber Maul', 'Interact', '', '', 0.8, 0),
(9701074, 10, 130, 'Timberbane Axe', 'Interact', '', '', 0.7, 0),
(9701075, 10, 130, 'Timberling Dagger', 'Interact', '', '', 0.7, 0),
(9701076, 10, 137, 'Torn Spellbook Page', 'Interact', '', '', 0.6, 0),
(9701077, 10, 137, 'Torn Spellbook Page', 'Interact', '', '', 0.6, 0),
(9701078, 10, 259, 'Trickster''s Signet', 'Interact', '', '', 0.8, 0),
(9701079, 10, 259, 'Whisperwind Boots', 'Interact', '', '', 0.8, 0),
(9701080, 10, 259, 'Whisperwind Heirloom', 'Interact', '', '', 0.8, 0),
(9701081, 10, 259, 'Affray Cuirras', 'Interact', '', '', 0.8, 0),
(9701082, 10, 259, 'Blackthorn Splitter', 'Interact', '', '', 0.8, 0),
(9701083, 10, 259, 'Bloody Wedding Ring', 'Interact', '', '', 0.8, 0),
(9701084, 10, 130, 'Bramblestaff', 'Interact', '', '', 0.7, 0),
(9701085, 10, 259, 'Bristleback Thorn', 'Interact', '', '', 0.8, 0),
(9701086, 10, 259, 'Captain''s Spyglass', 'Interact', '', '', 0.8, 0),
(9701087, 10, 259, 'Conscript''s Wraps', 'Interact', '', '', 0.8, 0),
(9701088, 10, 259, 'Drudger Smash', 'Interact', '', '', 0.8, 0),
(9701089, 10, 8, 'Forgotten Trunks', 'Interact', '', '', 0.9, 0),
(9701090, 10, 259, 'Giant Qiraji Scale', 'Interact', '', '', 0.8, 0),
(9701091, 10, 259, 'Grunt''s Chain Leggings', 'Interact', '', '', 0.8, 0),
(9701092, 10, 130, 'Honor Blade', 'Interact', '', '', 0.7, 0),
(9701093, 10, 259, 'Kodo Stompers', 'Interact', '', '', 0.8, 0),
(9701094, 10, 259, 'Loded Ring', 'Interact', '', '', 0.8, 0),
(9701095, 10, 259, 'Malgin''s Barback', 'Interact', '', '', 0.8, 0),
(9701096, 10, 259, 'Muck Trudgers', 'Interact', '', '', 0.8, 0),
(9701097, 10, 259, 'Northwatch Hand Cannon', 'Interact', '', '', 0.8, 0),
(9701098, 10, 130, 'Overwatch Bow', 'Interact', '', '', 0.7, 0),
(9701099, 10, 259, 'Peon Motivator', 'Interact', '', '', 0.8, 0),
(9701100, 10, 259, 'Plainstalker Vest', 'Interact', '', '', 0.8, 0),
(9701101, 10, 259, 'Razorthorn Claymore', 'Interact', '', '', 0.8, 0),
(9701102, 10, 259, 'Savannah Cowl', 'Interact', '', '', 0.8, 0),
(9701103, 10, 259, 'Sharpened Pike', 'Interact', '', '', 0.8, 0),
(9701104, 10, 259, 'Special Excavation Lantern', 'Interact', '', '', 0.8, 0),
(9701105, 10, 259, 'Steelrider Girdle', 'Interact', '', '', 0.8, 0),
(9701106, 10, 259, 'Stormcall Totem', 'Interact', '', '', 0.8, 0),
(9701107, 10, 259, 'Stump Biter', 'Interact', '', '', 0.8, 0),
(9701108, 10, 259, 'Stylish Cloak', 'Interact', '', '', 0.8, 0),
(9701109, 10, 259, 'Swashbuckler''s Chain', 'Interact', '', '', 0.8, 0),
(9701110, 10, 259, 'Takar''s Old Wand', 'Interact', '', '', 0.8, 0),
(9701111, 10, 130, 'Thornweaver Mace', 'Interact', '', '', 0.7, 0),
(9701112, 10, 259, 'Venture Co. Boots', 'Interact', '', '', 0.8, 0),
(9701113, 10, 259, 'Venture Co. Dirk', 'Interact', '', '', 0.8, 0),
(9701114, 10, 259, 'Venture Co. Sabatons', 'Interact', '', '', 0.8, 0),
(9701115, 10, 259, 'Venture Co. Spaulders', 'Interact', '', '', 0.8, 0),
(9701116, 10, 259, 'Vial of Dread Water', 'Interact', '', '', 0.8, 0),
(9701117, 10, 259, 'Warsong Timbercleaver', 'Interact', '', '', 0.8, 0),
(9701118, 10, 137, 'Waterlogged Gloves', 'Interact', '', '', 0.6, 0),
(9701119, 10, 259, 'Aerie Faith Vambraces', 'Interact', '', '', 0.8, 0),
(9701120, 10, 259, 'Ancient Vilebranch Gloves', 'Interact', '', '', 0.8, 0),
(9701121, 10, 130, 'Blood Keeper''s Staff', 'Interact', '', '', 0.7, 0),
(9701122, 10, 130, 'Blood Keeper''s Staff', 'Interact', '', '', 0.7, 0),
(9701123, 10, 259, 'Brood Caller’s Raiment', 'Interact', '', '', 0.8, 0),
(9701124, 10, 259, 'Broodsilk Gloves', 'Interact', '', '', 0.8, 0),
(9701125, 10, 259, 'Dwarven Drinking Pants', 'Interact', '', '', 0.8, 0),
(9701126, 10, 259, 'Featherbeard’s Bulwark Blaster', 'Interact', '', '', 0.8, 0),
(9701127, 10, 259, 'Flayer''s Edge', 'Interact', '', '', 0.8, 0),
(9701128, 10, 259, 'Fleshcarver Athame', 'Interact', '', '', 0.8, 0),
(9701129, 10, 259, 'Floodworn Shoulderguards', 'Interact', '', '', 0.8, 0),
(9701130, 10, 259, 'Floodworn Shoulderguards', 'Interact', '', '', 0.8, 0),
(9701131, 10, 259, 'Fort Defender Band', 'Interact', '', '', 0.8, 0),
(9701132, 10, 259, 'Fort Defender Band', 'Interact', '', '', 0.8, 0),
(9701133, 10, 259, 'Fractured Shoulderpads', 'Interact', '', '', 0.8, 0),
(9701134, 10, 259, 'Anchorfoot Greaves', 'Interact', '', '', 0.8, 0),
(9701135, 10, 259, 'Hexcall Gavel', 'Interact', '', '', 0.8, 0),
(9701136, 10, 259, 'Hexweave Robes', 'Interact', '', '', 0.8, 0),
(9701137, 10, 259, 'Hide Piercer', 'Interact', '', '', 0.8, 0),
(9701138, 10, 259, 'High Cascade Cord', 'Interact', '', '', 0.8, 0),
(9701139, 10, 259, 'Highnest Repeater', 'Interact', '', '', 0.8, 0),
(9701140, 10, 130, 'Highvale Ranger Bow', 'Interact', '', '', 0.7, 0),
(9701141, 10, 259, 'Highvale Wellband', 'Interact', '', '', 0.8, 0),
(9701142, 10, 259, 'Highvale Wellband', 'Interact', '', '', 0.8, 0),
(9701143, 10, 259, 'Idol of the Aerie', 'Interact', '', '', 0.8, 0),
(9701144, 10, 259, 'Idol of the Aerie', 'Interact', '', '', 0.8, 0),
(9701145, 10, 259, 'Idol of the Broodmother', 'Interact', '', '', 0.8, 0),
(9701146, 10, 259, 'Libram of Resolute Light', 'Interact', '', '', 0.8, 0),
(9701147, 10, 259, 'Lost Scout''s Idol', 'Interact', '', '', 0.8, 0),
(9701148, 10, 259, 'Ooze Cleansed Shoulderpads', 'Interact', '', '', 0.8, 0),
(9701149, 10, 259, 'Ooze Cleansed Shoulderpads', 'Interact', '', '', 0.8, 0),
(9701150, 10, 130, 'Overwatch Longrifle', 'Interact', '', '', 0.7, 0),
(9701151, 10, 130, 'Overwatch Longrifle', 'Interact', '', '', 0.7, 0),
(9701152, 10, 259, 'Elven Necklace', 'Interact', '', '', 0.8, 0),
(9701153, 10, 259, 'Hidden Stash', 'Interact', '', '', 0.8, 0),
(9701154, 10, 259, 'Sash of Contemplation', 'Interact', '', '', 0.8, 0),
(9701155, 10, 259, 'Seabreeze Hauberk', 'Interact', '', '', 0.8, 0),
(9701156, 10, 259, 'Shadowpounce Cowl', 'Interact', '', '', 0.8, 0),
(9701157, 10, 259, 'Shadowpounce Cowl', 'Interact', '', '', 0.8, 0),
(9701158, 10, 293, 'Partially Digested Corpse', 'Interact', '', '', 1.0, 0),
(9701159, 10, 293, 'Partially Digested Corpse', 'Interact', '', '', 1.0, 0),
(9701160, 10, 259, 'Soothsayer Shroud', 'Interact', '', '', 0.8, 0),
(9701161, 10, 259, 'Terrapine Carapace', 'Interact', '', '', 0.8, 0),
(9701162, 10, 259, 'Terrapine Carapace', 'Interact', '', '', 0.8, 0),
(9701163, 10, 259, 'The Blood Talon', 'Interact', '', '', 0.8, 0),
(9701164, 10, 130, 'Tiki Shield', 'Interact', '', '', 0.7, 0),
(9701165, 10, 130, 'Tiki Shield', 'Interact', '', '', 0.7, 0),
(9701166, 10, 259, 'Trapper’s Lone Band', 'Interact', '', '', 0.8, 0),
(9701167, 10, 259, 'Vilebranch Beastlance', 'Interact', '', '', 0.8, 0),
(9701168, 10, 259, 'Vilebranch Beastlance', 'Interact', '', '', 0.8, 0),
(9701169, 10, 130, 'Vilebranch Ritual Dagger', 'Interact', '', '', 0.7, 0),
(9701170, 10, 259, 'Vilebranch Warthrower', 'Interact', '', '', 0.8, 0),
(9701171, 10, 259, 'Vilebranch Warthrower', 'Interact', '', '', 0.8, 0),
(9701172, 10, 259, 'Wand of the Broodbound', 'Interact', '', '', 0.8, 0),
(9701173, 10, 259, 'Abandoned Moonshine', 'Interact', '', '', 0.8, 0),
(9701174, 10, 259, 'Abandoned Moonshine', 'Interact', '', '', 0.8, 0),
(9701175, 10, 130, 'Ancient Jeweler''s Staff', 'Interact', '', '', 0.7, 0),
(9701176, 10, 259, 'Caravaner''s Bracers', 'Interact', '', '', 0.8, 0),
(9701177, 10, 130, 'Centaur Mining Axe', 'Interact', '', '', 0.7, 0),
(9701178, 10, 259, 'Cloud Serpent Feather', 'Interact', '', '', 0.8, 0),
(9701179, 10, 259, 'Cloud Serpent Feather', 'Interact', '', '', 0.8, 0),
(9701180, 10, 259, 'Cursed Elemental Scepter', 'Interact', '', '', 0.8, 0),
(9701181, 10, 259, 'Darkcloud Braid', 'Interact', '', '', 0.8, 0),
(9701182, 10, 259, 'Darkcloud Totem', 'Interact', '', '', 0.8, 0),
(9701183, 10, 259, 'Darkcloud Totem', 'Interact', '', '', 0.8, 0),
(9701184, 10, 259, 'Deadman''s Signet', 'Interact', '', '', 0.8, 0),
(9701185, 10, 259, 'Deadman''s Signet', 'Interact', '', '', 0.8, 0),
(9701186, 10, 259, 'Drowned Diver''s Helm', 'Interact', '', '', 0.8, 0),
(9701187, 10, 259, 'Engine Safety Belt', 'Interact', '', '', 0.8, 0),
(9701188, 10, 259, 'Failed Parachute', 'Interact', '', '', 0.8, 0),
(9701189, 10, 259, 'Forgotten Pauldron', 'Interact', '', '', 0.8, 0),
(9701190, 10, 259, 'Forgotten Pauldron', 'Interact', '', '', 0.8, 0),
(9701191, 10, 259, 'Freewind Gloves', 'Interact', '', '', 0.8, 0),
(9701192, 10, 259, 'Galak Chicken Smasher', 'Interact', '', '', 0.8, 0),
(9701193, 10, 130, 'Galak Shortbow', 'Interact', '', '', 0.7, 0),
(9701194, 10, 130, 'Galak Shortbow', 'Interact', '', '', 0.7, 0),
(9701195, 10, 259, 'Goblin Racing Boots', 'Interact', '', '', 0.8, 0),
(9701196, 10, 130, 'Grimtotem Darkblade', 'Interact', '', '', 0.7, 0),
(9701197, 10, 259, 'Grimtotem Jaw Smasher', 'Interact', '', '', 0.8, 0),
(9701198, 10, 259, 'Highlands Vest', 'Interact', '', '', 0.8, 0),
(9701199, 10, 259, 'Highperch Necklace', 'Interact', '', '', 0.8, 0),
(9701200, 10, 259, 'Isolated Inventor''s Bulk', 'Interact', '', '', 0.8, 0),
(9701201, 10, 259, 'Kodo War Drum', 'Interact', '', '', 0.8, 0),
(9701202, 10, 130, 'Needlewind Crossbow', 'Interact', '', '', 0.7, 0),
(9701203, 10, 130, 'Needlewind Crossbow', 'Interact', '', '', 0.7, 0);
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `VerifiedBuild`) VALUES
(9701204, 10, 323, 'Pack Kodo Satchel', 'Interact', '', '', 1.0, 0),
(9701205, 10, 259, 'Pip''s Rad Stone', 'Interact', '', '', 0.8, 0),
(9701206, 10, 259, 'Pirate''s Mail', 'Interact', '', '', 0.8, 0),
(9701207, 10, 259, 'Runway Scraper', 'Interact', '', '', 0.8, 0),
(9701208, 10, 259, 'Runway Scraper', 'Interact', '', '', 0.8, 0),
(9701209, 10, 130, 'Scuba Slayer''s Blade', 'Interact', '', '', 0.7, 0),
(9701210, 10, 130, 'Scuba Slayer''s Blade', 'Interact', '', '', 0.7, 0),
(9701211, 10, 259, 'Silithid Bug Blaster', 'Interact', '', '', 0.8, 0),
(9701212, 10, 293, 'Slightly Magical Kodo Bone', 'Interact', '', '', 1.0, 0),
(9701213, 10, 130, 'Staff of the Wind Sisters', 'Interact', '', '', 0.7, 0),
(9701214, 10, 259, 'Survivor''s Trousers', 'Interact', '', '', 0.8, 0),
(9701215, 10, 259, 'Tahonda Gauntlets', 'Interact', '', '', 0.8, 0),
(9701216, 10, 259, 'The Tickler', 'Interact', '', '', 0.8, 0),
(9701217, 10, 259, 'U.L.T.R.A Racing Goggles', 'Interact', '', '', 0.8, 0),
(9701218, 10, 130, 'Wyvern Trapper Spear', 'Interact', '', '', 0.7, 0),
(9701219, 10, 259, 'Adventurer Gloves', 'Interact', '', '', 0.8, 0),
(9701220, 10, 259, 'Agamand Farmer Trousers', 'Interact', '', '', 0.8, 0),
(9701221, 10, 259, 'Agamand Sharpshooter', 'Interact', '', '', 0.8, 0),
(9701222, 10, 259, 'Agamand Walking Stick', 'Interact', '', '', 0.8, 0),
(9701223, 10, 259, 'Apothecary''s Lantern', 'Interact', '', '', 0.8, 0),
(9701224, 10, 130, 'Butchery Blade', 'Interact', '', '', 0.7, 0),
(9701225, 10, 130, 'Captain''s Shield', 'Interact', '', '', 0.7, 0),
(9701226, 10, 259, 'Coastline Vest', 'Interact', '', '', 0.8, 0),
(9701227, 10, 323, 'Empty Satchel', 'Interact', '', '', 1.0, 0),
(9701228, 10, 259, 'Faded Gravecloth Cuffs', 'Interact', '', '', 0.8, 0),
(9701229, 10, 259, 'Maggot Eye Musket', 'Interact', '', '', 0.8, 0),
(9701230, 10, 259, 'Ghostmoor Cloak', 'Interact', '', '', 0.8, 0),
(9701231, 10, 259, 'Gravedigger''s Delight', 'Interact', '', '', 0.8, 0),
(9701232, 10, 130, 'Haunted Mace', 'Interact', '', '', 0.7, 0),
(9701233, 10, 259, 'Haunted Ring', 'Interact', '', '', 0.8, 0),
(9701234, 10, 259, 'Maggot Eye Musket', 'Interact', '', '', 0.8, 0),
(9701235, 10, 259, 'Nightfallen Jerkin', 'Interact', '', '', 0.8, 0),
(9701236, 10, 259, 'Old Arcanus Robe', 'Interact', '', '', 0.8, 0),
(9701237, 10, 259, 'Old Wagon Wheel', 'Interact', '', '', 0.8, 0),
(9701238, 10, 137, 'Old Waterlogged Boots', 'Interact', '', '', 0.6, 0),
(9701239, 10, 130, 'Puddle-jumper Dagger', 'Interact', '', '', 0.7, 0),
(9701240, 10, 259, 'Rattlecage Warplate', 'Interact', '', '', 0.8, 0),
(9701241, 10, 259, 'Scarlet Insignia', 'Interact', '', '', 0.8, 0),
(9701242, 10, 259, 'Silkwrapped Cloak', 'Interact', '', '', 0.8, 0),
(9701243, 10, 259, 'Solliden Family Broom', 'Interact', '', '', 0.8, 0),
(9701244, 10, 259, 'Ulag''s Cleaver', 'Interact', '', '', 0.8, 0),
(9701245, 10, 137, 'Waterlogged Sparkler', 'Interact', '', '', 0.6, 0),
(9701246, 10, 259, 'Campsite Shrapnel', 'Interact', '', '', 0.8, 0),
(9701247, 10, 259, 'Cenarion Dreamcatcher', 'Interact', '', '', 0.8, 0),
(9701248, 10, 259, 'Fossilized Smasher', 'Interact', '', '', 0.8, 0),
(9701249, 10, 259, 'Goblin Plant Slicer', 'Interact', '', '', 0.8, 0),
(9701250, 10, 259, 'Lucky Fisherman''s Breeches', 'Interact', '', '', 0.8, 0),
(9701251, 10, 130, 'Pylon Charged Staff', 'Interact', '', '', 0.7, 0),
(9701252, 10, 259, 'Silverback Cape', 'Interact', '', '', 0.8, 0),
(9701253, 10, 259, 'Slightly Sticky Cloak', 'Interact', '', '', 0.8, 0),
(9701254, 10, 259, 'Tongs of Miscalibration', 'Interact', '', '', 0.8, 0),
(9701255, 10, 259, 'Flesh Flayer Hook', 'Interact', '', '', 0.8, 0),
(9701256, 10, 259, 'Andorhal Manual', 'Interact', '', '', 0.8, 0),
(9701257, 10, 259, 'Apothecary Cowl', 'Interact', '', '', 0.8, 0),
(9701258, 10, 259, 'Bloodied Pants', 'Interact', '', '', 0.8, 0),
(9701259, 10, 130, 'Bonescourge Dagger', 'Interact', '', '', 0.7, 0),
(9701260, 10, 259, 'Brightflame Codex', 'Interact', '', '', 0.8, 0),
(9701261, 10, 259, 'Burning Judgement', 'Interact', '', '', 0.8, 0),
(9701262, 10, 259, 'Charred Slicer', 'Interact', '', '', 0.8, 0),
(9701263, 10, 259, 'Ebonblight Slippers', 'Interact', '', '', 0.8, 0),
(9701264, 10, 130, 'Fetid Mace', 'Interact', '', '', 0.7, 0),
(9701265, 10, 259, 'Flayer''s Helmet', 'Interact', '', '', 0.8, 0),
(9701266, 10, 259, 'Graveyard Striker', 'Interact', '', '', 0.8, 0),
(9701267, 10, 259, 'Libram of Remembrance', 'Interact', '', '', 0.8, 0),
(9701268, 10, 130, 'Northridge Hatchet', 'Interact', '', '', 0.7, 0),
(9701269, 10, 259, 'Phylactery Shard', 'Interact', '', '', 0.8, 0),
(9701270, 10, 259, 'Plague Mask', 'Interact', '', '', 0.8, 0),
(9701271, 10, 259, 'Scarlet Blunderbuss', 'Interact', '', '', 0.8, 0),
(9701272, 10, 259, 'Scarlet Pauldrons', 'Interact', '', '', 0.8, 0),
(9701273, 10, 130, 'Scarlet Shield', 'Interact', '', '', 0.7, 0),
(9701274, 10, 259, 'Scourgestalker’s Girdle', 'Interact', '', '', 0.8, 0),
(9701275, 10, 259, 'Sentinel Sharpshooter', 'Interact', '', '', 0.8, 0),
(9701276, 10, 259, 'Shimmering Scarlet Cane', 'Interact', '', '', 0.8, 0),
(9701277, 10, 259, 'Shimmering Scarlet Cane', 'Interact', '', '', 0.8, 0),
(9701278, 10, 259, 'Skeletal Club', 'Interact', '', '', 0.8, 0),
(9701279, 10, 293, 'Skippy''s Bone', 'Interact', '', '', 1.0, 0),
(9701280, 10, 259, 'Spiced Rum', 'Interact', '', '', 0.8, 0),
(9701281, 10, 259, 'Sticky Sabatons', 'Interact', '', '', 0.8, 0),
(9701282, 10, 130, 'Tracker''s Plagued Spike', 'Interact', '', '', 0.7, 0),
(9701283, 10, 293, 'Wraithbone Ring', 'Interact', '', '', 1.0, 0),
(9701284, 10, 259, 'Blessed Mail Wraps', 'Interact', '', '', 0.8, 0),
(9701285, 10, 130, 'Burial Blade', 'Interact', '', '', 0.7, 0),
(9701286, 10, 259, 'Corroded Quel''thalas Ring ', 'Interact', '', '', 0.8, 0),
(9701287, 10, 259, 'Defias Apothecary Pants', 'Interact', '', '', 0.8, 0),
(9701288, 10, 259, 'Defias Handshake', 'Interact', '', '', 0.8, 0),
(9701289, 10, 259, 'Defias Handshake', 'Interact', '', '', 0.8, 0),
(9701290, 10, 259, 'Defias Honorcode Memento', 'Interact', '', '', 0.8, 0),
(9701291, 10, 130, 'Defias Magus Staff', 'Interact', '', '', 0.7, 0),
(9701292, 10, 130, 'Defias Magus Staff', 'Interact', '', '', 0.7, 0),
(9701293, 10, 130, 'Defias Throwing Knife', 'Interact', '', '', 0.7, 0),
(9701294, 10, 130, 'Defias Throwing Knife', 'Interact', '', '', 0.7, 0),
(9701295, 10, 130, 'Defias Toe Knife', 'Interact', '', '', 0.7, 0),
(9701296, 10, 130, 'Defias Toe Knife', 'Interact', '', '', 0.7, 0),
(9701297, 10, 259, 'Field Boots', 'Interact', '', '', 0.8, 0),
(9701298, 10, 259, 'Field Boots', 'Interact', '', '', 0.8, 0),
(9701299, 10, 259, 'Field Trousers', 'Interact', '', '', 0.8, 0),
(9701300, 10, 259, 'Fisherman''s Last Wish', 'Interact', '', '', 0.8, 0),
(9701301, 10, 259, 'Fisherman''s Last Wish', 'Interact', '', '', 0.8, 0),
(9701302, 10, 259, 'Flexible Gloves', 'Interact', '', '', 0.8, 0),
(9701303, 10, 259, 'Gnoll Cleaver', 'Interact', '', '', 0.8, 0),
(9701304, 10, 259, 'Gnoll Cleaver', 'Interact', '', '', 0.8, 0),
(9701305, 10, 259, 'Harvest Scythe', 'Interact', '', '', 0.8, 0),
(9701306, 10, 259, 'Harvester’s Aegis', 'Interact', '', '', 0.8, 0),
(9701307, 10, 293, 'Heavy Bone', 'Interact', '', '', 1.0, 0),
(9701308, 10, 293, 'Heavy Bone', 'Interact', '', '', 1.0, 0),
(9701309, 10, 259, 'Heavy Boots', 'Interact', '', '', 0.8, 0),
(9701310, 10, 259, 'Leyline Channeling Rod', 'Interact', '', '', 0.8, 0),
(9701311, 10, 259, 'Liquid Arcane', 'Interact', '', '', 0.8, 0),
(9701312, 10, 259, 'Liquid Arcane', 'Interact', '', '', 0.8, 0),
(9701313, 10, 137, 'Madness Cursed Notes', 'Interact', '', '', 0.6, 0),
(9701314, 10, 259, 'Murky Quel''thalas Drape', 'Interact', '', '', 0.8, 0),
(9701315, 10, 130, 'Old Defias Gun', 'Interact', '', '', 0.7, 0),
(9701316, 10, 259, 'Old Quel''thalas Brooch', 'Interact', '', '', 0.8, 0),
(9701317, 10, 259, 'Peculiar Gold Nugget', 'Interact', '', '', 0.8, 0),
(9701318, 10, 259, 'Peculiar Gold Nugget', 'Interact', '', '', 0.8, 0),
(9701319, 10, 130, 'People''s Militia Crossbow', 'Interact', '', '', 0.7, 0),
(9701320, 10, 259, 'Pumpkin Smashers', 'Interact', '', '', 0.8, 0),
(9701321, 10, 259, 'Quarry Sledge', 'Interact', '', '', 0.8, 0),
(9701322, 10, 259, 'Quarry Sledge', 'Interact', '', '', 0.8, 0),
(9701323, 10, 259, 'Rehomed Belt', 'Interact', '', '', 0.8, 0),
(9701324, 10, 259, 'Rower''s Jerkin', 'Interact', '', '', 0.8, 0),
(9701325, 10, 259, 'Rusty Quel''thalas Circlet', 'Interact', '', '', 0.8, 0),
(9701326, 10, 259, 'Salma''s Summer Dress', 'Interact', '', '', 0.8, 0),
(9701327, 10, 130, 'Sentinel''s Blade', 'Interact', '', '', 0.7, 0),
(9701328, 10, 130, 'Sentinel''s Blade', 'Interact', '', '', 0.7, 0),
(9701329, 10, 259, 'Sharpened Chopper', 'Interact', '', '', 0.8, 0),
(9701330, 10, 259, 'Sharpened Chopper', 'Interact', '', '', 0.8, 0),
(9701331, 10, 259, 'Soldier''s Mail', 'Interact', '', '', 0.8, 0),
(9701332, 10, 259, 'Stolen Thunderbrew Flask', 'Interact', '', '', 0.8, 0),
(9701333, 10, 259, 'Wizard Wraps', 'Interact', '', '', 0.8, 0),
(9701334, 10, 259, 'Worn Quel''thalas Heirloom', 'Interact', '', '', 0.8, 0),
(9701335, 10, 130, 'Arakor Mace', 'Interact', '', '', 0.7, 0),
(9701336, 10, 259, 'Balgaras''s Foul Amulet', 'Interact', '', '', 0.8, 0),
(9701337, 10, 259, 'Balgaras''s Foul Amulet', 'Interact', '', '', 0.8, 0),
(9701338, 10, 259, 'Borrowed Dark Iron Signet', 'Interact', '', '', 0.8, 0),
(9701339, 10, 259, 'Chewed Wrappings', 'Interact', '', '', 0.8, 0),
(9701340, 10, 259, 'Crimson Dragonscale', 'Interact', '', '', 0.8, 0),
(9701341, 10, 259, 'Crude Bluegill Totem', 'Interact', '', '', 0.8, 0),
(9701342, 10, 259, 'Crude Bluegill Totem', 'Interact', '', '', 0.8, 0),
(9701343, 10, 259, 'Cursed Cape of the Wave Mistress', 'Interact', '', '', 0.8, 0),
(9701344, 10, 259, 'Cursed Legguards of the Intrepid', 'Interact', '', '', 0.8, 0),
(9701345, 10, 259, 'Dark Iron Harvester', 'Interact', '', '', 0.8, 0),
(9701346, 10, 130, 'Dragonmaw Ritual Staff', 'Interact', '', '', 0.7, 0),
(9701347, 10, 130, 'Dragonmaw Ritual Staff', 'Interact', '', '', 0.7, 0),
(9701348, 10, 259, 'Dwarven Demolition Kit', 'Interact', '', '', 0.8, 0),
(9701349, 10, 259, 'Etched Tablet', 'Interact', '', '', 0.8, 0),
(9701350, 10, 130, 'Ironbeard''s Axe', 'Interact', '', '', 0.7, 0),
(9701351, 10, 259, 'Miner Handwraps', 'Interact', '', '', 0.8, 0),
(9701352, 10, 259, 'Mirefin Belt', 'Interact', '', '', 0.8, 0),
(9701353, 10, 259, 'Mossy Hide Armor', 'Interact', '', '', 0.8, 0),
(9701354, 10, 293, 'Old Dragon Bone', 'Interact', '', '', 1.0, 0),
(9701355, 10, 293, 'Old Dragon Bone', 'Interact', '', '', 1.0, 0),
(9701356, 10, 259, 'Old Dragonmaw Cleaver', 'Interact', '', '', 0.8, 0),
(9701357, 10, 259, 'Old Dragonmaw Cleaver', 'Interact', '', '', 0.8, 0),
(9701358, 10, 130, 'Pilfered Stormpike Polearm', 'Interact', '', '', 0.7, 0),
(9701359, 10, 130, 'Pilfered Stormpike Polearm', 'Interact', '', '', 0.7, 0),
(9701360, 10, 259, 'Raptor-Gnawed Cap', 'Interact', '', '', 0.8, 0),
(9701361, 10, 259, 'Raptor-Gnawed Cap', 'Interact', '', '', 0.8, 0),
(9701362, 10, 259, 'Stubborn Dwarf Slippers', 'Interact', '', '', 0.8, 0),
(9701363, 10, 259, 'Swiftgear Sniper', 'Interact', '', '', 0.8, 0),
(9701364, 10, 259, 'Swiftgear Sniper', 'Interact', '', '', 0.8, 0),
(9701365, 10, 130, 'Thelsamar Bow', 'Interact', '', '', 0.7, 0),
(9701366, 10, 130, 'Thelsamar Bow', 'Interact', '', '', 0.7, 0),
(9701367, 10, 259, 'Vestments of the Unbound', 'Interact', '', '', 0.8, 0),
(9701368, 10, 137, 'Waterlogged Musket', 'Interact', '', '', 0.6, 0),
(9701369, 10, 259, 'Wyrmscale Spaulders', 'Interact', '', '', 0.8, 0),
(9701370, 10, 259, 'Wyrmscale Spaulders', 'Interact', '', '', 0.8, 0),
(9701371, 10, 259, 'Chillbane Cleaver', 'Interact', '', '', 0.8, 0),
(9701372, 10, 259, 'Cold Wristguards', 'Interact', '', '', 0.8, 0),
(9701373, 10, 259, 'Flattened Shoulderpad', 'Interact', '', '', 0.8, 0),
(9701374, 10, 259, 'Frostglade Saber', 'Interact', '', '', 0.8, 0),
(9701375, 10, 259, 'Icemaw Greatmaul', 'Interact', '', '', 0.8, 0),
(9701376, 10, 259, 'Maddening Signet', 'Interact', '', '', 0.8, 0),
(9701377, 10, 259, 'Researcher''s Dish', 'Interact', '', '', 0.8, 0),
(9701378, 10, 259, 'The Leaping Arc', 'Interact', '', '', 0.8, 0),
(9701379, 10, 259, 'Thermal Pendant', 'Interact', '', '', 0.8, 0),
(9701380, 10, 259, 'Timbermaw Idol', 'Interact', '', '', 0.8, 0),
(9701381, 10, 259, 'Windsong Totem', 'Interact', '', '', 0.8, 0),
(9701382, 10, 130, 'Winterfall Dagger', 'Interact', '', '', 0.7, 0),
(9701383, 10, 259, 'Wintergale Cloak', 'Interact', '', '', 0.8, 0);
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 529.33, `wy` = -224.67, `zone_id` = 36, `object_name` = 'Alteraci Avenger' WHERE `item` = 9700004;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 529.33, `wy` = -224.67, `zone_id` = 36, `object_name` = 'Alteraci Avenger' WHERE `item` = 9700005;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 492.0, `wy` = -168.67, `zone_id` = 36, `object_name` = 'Alteraci Band' WHERE `item` = 9700006;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 716.0, `wy` = -308.67, `zone_id` = 36, `object_name` = 'Antique Alteraci Skirt' WHERE `item` = 9700007;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 902.67, `wy` = -560.67, `zone_id` = 36, `object_name` = 'Battleplate of Crimson Resolve' WHERE `item` = 9700008;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 230.67, `wy` = -840.67, `zone_id` = 36, `object_name` = 'Blood Soaked Spike' WHERE `item` = 9700009;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 230.67, `wy` = -840.67, `zone_id` = 36, `object_name` = 'Blood Soaked Spike' WHERE `item` = 9700010;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -105.33, `wy` = 195.33, `zone_id` = 36, `object_name` = 'Chain of the Forgotten Prisoner' WHERE `item` = 9700011;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 81.33, `wy` = 419.33, `zone_id` = 36, `object_name` = 'Charred Greaves' WHERE `item` = 9700012;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 734.67, `wy` = -252.67, `zone_id` = 36, `object_name` = 'Coldridge Crusher' WHERE `item` = 9700013;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 734.67, `wy` = -252.67, `zone_id` = 36, `object_name` = 'Coldridge Crusher' WHERE `item` = 9700014;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 305.33, `wy` = 167.33, `zone_id` = 36, `object_name` = 'Crater''s Silk Drape' WHERE `item` = 9700015;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 641.33, `wy` = -728.67, `zone_id` = 36, `object_name` = 'Crushridge Fingerguards' WHERE `item` = 9700016;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -49.33, `wy` = 279.33, `zone_id` = 36, `object_name` = 'Dalaran Mage Garb' WHERE `item` = 9700017;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1108.0, `wy` = -336.67, `zone_id` = 36, `object_name` = 'Dandred''s Harvester' WHERE `item` = 9700018;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1108.0, `wy` = -336.67, `zone_id` = 36, `object_name` = 'Dandred''s Harvester' WHERE `item` = 9700019;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 417.33, `wy` = 279.33, `zone_id` = 36, `object_name` = 'Dusty Sorcerer Hat' WHERE `item` = 9700020;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Embrace of the Fifth' WHERE `item` = 9700021;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 753.33, `wy` = -392.67, `zone_id` = 36, `object_name` = 'Infernal Tender' WHERE `item` = 9700022;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 734.67, `wy` = -448.67, `zone_id` = 36, `object_name` = 'Enchanted Scribe''s Feather' WHERE `item` = 9700023;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -198.67, `wy` = -308.67, `zone_id` = 36, `object_name` = 'Feline''s Grasp' WHERE `item` = 9700024;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 641.33, `wy` = -532.67, `zone_id` = 36, `object_name` = 'Forgotten Warrior''s Pauldrons' WHERE `item` = 9700025;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 380.0, `wy` = -336.67, `zone_id` = 36, `object_name` = 'Frostwatch Defender' WHERE `item` = 9700026;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 380.0, `wy` = -336.67, `zone_id` = 36, `object_name` = 'Frostwatch Defender' WHERE `item` = 9700027;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 884.0, `wy` = -112.67, `zone_id` = 36, `object_name` = 'Grandpa''s Scarlet Blade' WHERE `item` = 9700028;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 678.67, `wy` = -896.67, `zone_id` = 36, `object_name` = 'Heisen’s Loop' WHERE `item` = 9700029;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 268.0, `wy` = -252.67, `zone_id` = 36, `object_name` = 'Hercular''s Unstable Orb' WHERE `item` = 9700030;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 268.0, `wy` = -252.67, `zone_id` = 36, `object_name` = 'Hercular''s Unstable Orb' WHERE `item` = 9700031;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 286.67, `wy` = -392.67, `zone_id` = 36, `object_name` = 'Ice-Forged Gauntlets' WHERE `item` = 9700032;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Icecracker' WHERE `item` = 9700033;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 436.0, `wy` = -616.67, `zone_id` = 36, `object_name` = 'Icecracker' WHERE `item` = 9700034;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Libram of the Third Host' WHERE `item` = 9700035;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 753.33, `wy` = -980.67, `zone_id` = 36, `object_name` = 'Libram of the Third Host' WHERE `item` = 9700036;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 622.67, `wy` = -308.67, `zone_id` = 36, `object_name` = 'Muckrake''s Soup Bowl' WHERE `item` = 9700037;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Ogre Toothpick' WHERE `item` = 9700038;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 585.33, `wy` = -336.67, `zone_id` = 36, `object_name` = 'Snow Buried Shipment' WHERE `item` = 9700039;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 660.0, `wy` = -336.67, `zone_id` = 36, `object_name` = 'Muckrake''s Soup Bowl' WHERE `item` = 9700040;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 100.0, `wy` = 363.33, `zone_id` = 36, `object_name` = 'Runed Pantaloons' WHERE `item` = 9700041;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Sentry Shot' WHERE `item` = 9700042;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 940.0, `wy` = -868.67, `zone_id` = 36, `object_name` = 'Sentry Shot' WHERE `item` = 9700043;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 604.0, `wy` = -140.67, `zone_id` = 36, `object_name` = 'Shredder''s Medallion' WHERE `item` = 9700044;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Staff of Argus' WHERE `item` = 9700045;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1145.33, `wy` = -560.67, `zone_id` = 36, `object_name` = 'Staff of Argus' WHERE `item` = 9700046;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 809.33, `wy` = 167.33, `zone_id` = 36, `object_name` = 'Stolen Rot Hide Circlet' WHERE `item` = 9700047;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 697.33, `wy` = -840.67, `zone_id` = 36, `object_name` = 'Syndicate Chopping Axe' WHERE `item` = 9700048;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 697.33, `wy` = -840.67, `zone_id` = 36, `object_name` = 'Syndicate Chopping Axe' WHERE `item` = 9700049;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 678.67, `wy` = -896.67, `zone_id` = 36, `object_name` = 'Syndicate Crossbow' WHERE `item` = 9700050;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 678.67, `wy` = -896.67, `zone_id` = 36, `object_name` = 'Syndicate Crossbow' WHERE `item` = 9700051;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Syndicate Slicer' WHERE `item` = 9700052;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -30.67, `wy` = -560.67, `zone_id` = 36, `object_name` = 'Syndicate Slicer' WHERE `item` = 9700053;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1201.33, `wy` = -252.67, `zone_id` = 36, `object_name` = 'Syndicate Cobbler''s Supplies' WHERE `item` = 9700054;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Tombbound Warhammer' WHERE `item` = 9700055;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 790.67, `wy` = -420.67, `zone_id` = 36, `object_name` = 'Tombbound Warhammer' WHERE `item` = 9700056;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 398.67, `wy` = -1512.67, `zone_id` = 36, `object_name` = 'Totem of the Flowing River' WHERE `item` = 9700057;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1500.0, `wy` = 783.33, `zone_id` = 36, `object_name` = 'Tracker''s Scope' WHERE `item` = 9700058;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 436.0, `wy` = -980.67, `zone_id` = 36, `object_name` = 'Tracker''s Scope' WHERE `item` = 9700059;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1477.33, `wy` = -2630.67, `zone_id` = 45, `object_name` = 'Abandonded Wristguard' WHERE `item` = 9700060;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2365.33, `wy` = -2450.67, `zone_id` = 45, `object_name` = 'Ancient Dark Iron Mace' WHERE `item` = 9700061;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2293.33, `wy` = -1622.67, `zone_id` = 45, `object_name` = 'Ancient Wavepiercer' WHERE `item` = 9700062;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1429.33, `wy` = -3386.67, `zone_id` = 45, `object_name` = 'Arcane Impaler' WHERE `item` = 9700063;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1717.33, `wy` = -1802.67, `zone_id` = 45, `object_name` = 'Blade of the Syndicate Lord' WHERE `item` = 9700064;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2173.33, `wy` = -1622.67, `zone_id` = 45, `object_name` = 'Boarder''s Axe' WHERE `item` = 9700065;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1213.33, `wy` = -1874.67, `zone_id` = 45, `object_name` = 'Brumn''s Unfinished Project' WHERE `item` = 9700066;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -133.33, `wy` = -866.67, `zone_id` = 45, `object_name` = 'Caretaker''s Burden' WHERE `item` = 9700067;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1573.33, `wy` = -1910.67, `zone_id` = 45, `object_name` = 'Caretaker''s Burden' WHERE `item` = 9700068;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -133.33, `wy` = -866.67, `zone_id` = 45, `object_name` = 'Circle of Waves Idol' WHERE `item` = 9700069;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2053.33, `wy` = -2162.67, `zone_id` = 45, `object_name` = 'Circle of Waves Idol' WHERE `item` = 9700070;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -997.33, `wy` = -2918.67, `zone_id` = 45, `object_name` = 'Commode Cleaver' WHERE `item` = 9700071;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -133.33, `wy` = -866.67, `zone_id` = 45, `object_name` = 'Dark Iron Blaster' WHERE `item` = 9700072;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2245.33, `wy` = -2594.67, `zone_id` = 45, `object_name` = 'Dark Iron Blaster' WHERE `item` = 9700073;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1669.33, `wy` = -3062.67, `zone_id` = 45, `object_name` = 'Deadweight Pauldrons' WHERE `item` = 9700074;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1861.33, `wy` = -4106.67, `zone_id` = 45, `object_name` = 'Desperate Defense' WHERE `item` = 9700075;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1501.33, `wy` = -2162.67, `zone_id` = 45, `object_name` = 'Earth Infused Offering' WHERE `item` = 9700076;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1021.33, `wy` = -3098.67, `zone_id` = 45, `object_name` = 'Earth Reverent''s Sash' WHERE `item` = 9700077;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -877.33, `wy` = -1802.67, `zone_id` = 45, `object_name` = 'Flame Infused Offering Band' WHERE `item` = 9700078;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1597.33, `wy` = -2378.67, `zone_id` = 45, `object_name` = 'Forgotten Fitted Pants' WHERE `item` = 9700079;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1309.33, `wy` = -3170.67, `zone_id` = 45, `object_name` = 'Grave Spite' WHERE `item` = 9700080;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1477.33, `wy` = -3134.67, `zone_id` = 45, `object_name` = 'Hammerfall Wristguards' WHERE `item` = 9700081;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1165.33, `wy` = -1982.67, `zone_id` = 45, `object_name` = 'Heavy Tempered Blade' WHERE `item` = 9700082;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1573.33, `wy` = -2522.67, `zone_id` = 45, `object_name` = 'Interlinked Fingerguards' WHERE `item` = 9700083;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1597.33, `wy` = -2558.67, `zone_id` = 45, `object_name` = 'Interlinked Fingerguards' WHERE `item` = 9700084;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -661.33, `wy` = -2234.67, `zone_id` = 45, `object_name` = 'Mountain Climbers' WHERE `item` = 9700085;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1693.33, `wy` = -1838.67, `zone_id` = 45, `object_name` = 'Muffled Boots' WHERE `item` = 9700086;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -853.33, `wy` = -2054.67, `zone_id` = 45, `object_name` = 'Musty Horse Blanket' WHERE `item` = 9700087;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -925.33, `wy` = -3098.67, `zone_id` = 45, `object_name` = 'Offering Pendant' WHERE `item` = 9700088;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1789.33, `wy` = -1514.67, `zone_id` = 45, `object_name` = 'Onestone''s One Stone' WHERE `item` = 9700089;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -133.33, `wy` = -866.67, `zone_id` = 45, `object_name` = 'Peace of the Dead' WHERE `item` = 9700090;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1501.33, `wy` = -1874.67, `zone_id` = 45, `object_name` = 'Peace of the Dead' WHERE `item` = 9700091;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -133.33, `wy` = -866.67, `zone_id` = 45, `object_name` = 'Plains Bolter' WHERE `item` = 9700092;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -877.33, `wy` = -2414.67, `zone_id` = 45, `object_name` = 'Plains Bolter' WHERE `item` = 9700093;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -133.33, `wy` = -866.67, `zone_id` = 45, `object_name` = 'Poacher''s Bow' WHERE `item` = 9700094;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -613.33, `wy` = -1802.67, `zone_id` = 45, `object_name` = 'Poacher''s Bow' WHERE `item` = 9700095;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -829.33, `wy` = -3278.67, `zone_id` = 45, `object_name` = 'Rough Weathered Ring' WHERE `item` = 9700096;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1285.33, `wy` = -2738.67, `zone_id` = 45, `object_name` = 'Mysterious Hammer' WHERE `item` = 9700097;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1213.33, `wy` = -2198.67, `zone_id` = 45, `object_name` = 'Skullknocker' WHERE `item` = 9700098;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -805.33, `wy` = -3890.67, `zone_id` = 45, `object_name` = 'Stolen War Pendant' WHERE `item` = 9700099;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1549.33, `wy` = -1658.67, `zone_id` = 45, `object_name` = 'Stromgarde Buckler' WHERE `item` = 9700100;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1597.33, `wy` = -1874.67, `zone_id` = 45, `object_name` = 'Stromgarde Spell Tome' WHERE `item` = 9700101;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1261.33, `wy` = -1622.67, `zone_id` = 45, `object_name` = 'Suprisingly Sturdy Helm' WHERE `item` = 9700102;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -133.33, `wy` = -866.67, `zone_id` = 45, `object_name` = 'Syndicate Shanker' WHERE `item` = 9700103;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1621.33, `wy` = -1910.67, `zone_id` = 45, `object_name` = 'Syndicate Shanker' WHERE `item` = 9700104;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -901.33, `wy` = -2054.67, `zone_id` = 45, `object_name` = 'Syndiclap' WHERE `item` = 9700105;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1813.33, `wy` = -3422.67, `zone_id` = 45, `object_name` = 'The Withered Totem' WHERE `item` = 9700106;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1333.33, `wy` = -2738.67, `zone_id` = 45, `object_name` = 'Thunder Infused Offering' WHERE `item` = 9700107;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1357.33, `wy` = -1910.67, `zone_id` = 45, `object_name` = 'Band of Scales' WHERE `item` = 9700108;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1693.33, `wy` = -1802.67, `zone_id` = 45, `object_name` = 'Watchguard''s Prized Plate' WHERE `item` = 9700109;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1669.33, `wy` = -1946.67, `zone_id` = 45, `object_name` = 'Water Drawing Cap' WHERE `item` = 9700110;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2053.33, `wy` = -3278.67, `zone_id` = 45, `object_name` = 'Witherbark Headsmasher' WHERE `item` = 9700111;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2053.33, `wy` = -3278.67, `zone_id` = 45, `object_name` = 'Witherbark Headsmasher' WHERE `item` = 9700112;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1237.33, `wy` = -1982.67, `zone_id` = 45, `object_name` = 'Withered Trollkin Shoulders' WHERE `item` = 9700113;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1790.1, `wy` = -3778.33, `zone_id` = 331, `object_name` = 'Assassin''s Crossbow' WHERE `item` = 9700114;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3865.73, `wy` = -145.33, `zone_id` = 331, `object_name` = 'Bathran''s Cursed Twig' WHERE `item` = 9700115;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1790.1, `wy` = -2682.67, `zone_id` = 331, `object_name` = 'Blade of Severed Souls' WHERE `item` = 9700116;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2751.04, `wy` = -2971.0, `zone_id` = 331, `object_name` = 'Bleakheart Piercer' WHERE `item` = 9700117;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Bloodtooth Neck' WHERE `item` = 9700118;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1597.92, `wy` = -1471.67, `zone_id` = 331, `object_name` = 'Bloodtooth Neck' WHERE `item` = 9700119;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2366.67, `wy` = 258.33, `zone_id` = 331, `object_name` = 'Cursed Fire Scar Pendant' WHERE `item` = 9700120;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2366.67, `wy` = 258.33, `zone_id` = 331, `object_name` = 'Cursed Fire Scar Pendant' WHERE `item` = 9700121;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Dirge of the Dead' WHERE `item` = 9700122;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3788.85, `wy` = -145.33, `zone_id` = 331, `object_name` = 'Dirge of the Dead' WHERE `item` = 9700123;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2635.73, `wy` = 431.33, `zone_id` = 331, `object_name` = 'Echo of Aessina' WHERE `item` = 9700124;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2635.73, `wy` = 431.33, `zone_id` = 331, `object_name` = 'Echo of Aessina' WHERE `item` = 9700125;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2904.79, `wy` = -952.67, `zone_id` = 331, `object_name` = 'Elune Tear Fragment' WHERE `item` = 9700126;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2904.79, `wy` = -952.67, `zone_id` = 331, `object_name` = 'Elune Tear Fragment' WHERE `item` = 9700127;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3635.1, `wy` = 1181.0, `zone_id` = 331, `object_name` = 'Elven Militia Crown' WHERE `item` = 9700128;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Endless Moonwell Chalice' WHERE `item` = 9700129;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2904.79, `wy` = -1414.0, `zone_id` = 331, `object_name` = 'Endless Moonwell Chalice' WHERE `item` = 9700130;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1982.29, `wy` = -3086.33, `zone_id` = 331, `object_name` = 'Fel Infused Band' WHERE `item` = 9700131;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3904.17, `wy` = 719.67, `zone_id` = 331, `object_name` = 'Felforged Meteor Fragment' WHERE `item` = 9700132;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3173.85, `wy` = -1817.67, `zone_id` = 331, `object_name` = 'Fine Silk Wraps' WHERE `item` = 9700133;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3827.29, `wy` = 200.67, `zone_id` = 331, `object_name` = 'Guide to Elven Restoration - Vol. I' WHERE `item` = 9700134;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3827.29, `wy` = 200.67, `zone_id` = 331, `object_name` = 'Guide to Elven Restoration - Vol. I' WHERE `item` = 9700135;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2443.54, `wy` = -2682.67, `zone_id` = 331, `object_name` = 'Hunter''s Tunic' WHERE `item` = 9700136;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1790.1, `wy` = -2740.33, `zone_id` = 331, `object_name` = 'Infiltrator''s Shield' WHERE `item` = 9700137;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Maestra''s Training Longbow' WHERE `item` = 9700138;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3096.98, `wy` = 143.0, `zone_id` = 331, `object_name` = 'Maestra''s Training Longbow' WHERE `item` = 9700139;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2558.85, `wy` = -1241.0, `zone_id` = 331, `object_name` = 'Malorne''s Girdle' WHERE `item` = 9700140;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1943.85, `wy` = -1356.33, `zone_id` = 331, `object_name` = 'Mystral Compass' WHERE `item` = 9700141;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Mystral Staff' WHERE `item` = 9700142;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1982.29, `wy` = -1241.0, `zone_id` = 331, `object_name` = 'Mystral Staff' WHERE `item` = 9700143;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Nightsong Waraxe' WHERE `item` = 9700144;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2212.92, `wy` = -3144.0, `zone_id` = 331, `object_name` = 'Nightsong Waraxe' WHERE `item` = 9700145;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3596.67, `wy` = 892.67, `zone_id` = 331, `object_name` = 'Pristine Tortoise Carapace' WHERE `item` = 9700146;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2212.92, `wy` = -1414.0, `zone_id` = 331, `object_name` = 'Rock Smasher' WHERE `item` = 9700147;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2789.48, `wy` = -1529.33, `zone_id` = 331, `object_name` = 'Rosebud Ring' WHERE `item` = 9700148;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1251.98, `wy` = -2163.67, `zone_id` = 331, `object_name` = 'Sharpened Pike' WHERE `item` = 9700149;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Silverwing Grovekeeper''s Bow' WHERE `item` = 9700150;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1482.6, `wy` = -1875.33, `zone_id` = 331, `object_name` = 'Silverwing Grovekeeper''s Bow' WHERE `item` = 9700151;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Stardust Scoured Helmet' WHERE `item` = 9700152;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2097.6, `wy` = -260.67, `zone_id` = 331, `object_name` = 'Stardust Scoured Helmet' WHERE `item` = 9700153;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Thistlefur Fur Shroud' WHERE `item` = 9700154;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3366.04, `wy` = -491.33, `zone_id` = 331, `object_name` = 'Expedition Bracers' WHERE `item` = 9700155;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Ursangous'' Claw' WHERE `item` = 9700156;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2251.35, `wy` = -722.0, `zone_id` = 331, `object_name` = 'Ursangous'' Claw' WHERE `item` = 9700157;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4672.92, `wy` = 1700.0, `zone_id` = 331, `object_name` = 'Woodbreaker Mallet' WHERE `item` = 9700158;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2904.79, `wy` = -1933.0, `zone_id` = 331, `object_name` = 'Woodbreaker Mallet' WHERE `item` = 9700159;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'Assassin''s Crossbow' WHERE `item` = 9700160;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4766.85, `wy` = -7536.58, `zone_id` = 16, `object_name` = 'Cliffwalker Legplates' WHERE `item` = 9700161;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'Crystalized Shield' WHERE `item` = 9700162;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2670.48, `wy` = -5964.62, `zone_id` = 16, `object_name` = 'Crystalized Shield' WHERE `item` = 9700163;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'Drape of the Lost' WHERE `item` = 9700164;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2704.29, `wy` = -3987.0, `zone_id` = 16, `object_name` = 'Drape of the Lost' WHERE `item` = 9700165;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2163.29, `wy` = -6421.0, `zone_id` = 16, `object_name` = 'Hydra Hide Belt' WHERE `item` = 9700166;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3989.17, `wy` = -7130.92, `zone_id` = 16, `object_name` = 'Idol of the Ocean''s Depths' WHERE `item` = 9700167;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'Ish''thel Falesh, Gaze of Eldara' WHERE `item` = 9700168;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3820.1, `wy` = -5508.25, `zone_id` = 16, `object_name` = 'Ish''thel Falesh, Gaze of Eldara' WHERE `item` = 9700169;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4766.85, `wy` = -6623.83, `zone_id` = 16, `object_name` = 'Legashi Bracers' WHERE `item` = 9700170;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4158.23, `wy` = -7840.83, `zone_id` = 16, `object_name` = 'Lyre of the Grand Scribe' WHERE `item` = 9700171;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'Might of Azshara' WHERE `item` = 9700172;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3617.23, `wy` = -4899.75, `zone_id` = 16, `object_name` = 'Might of Azshara' WHERE `item` = 9700173;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4496.35, `wy` = -6370.29, `zone_id` = 16, `object_name` = 'Sacrificial Carver' WHERE `item` = 9700174;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'Shoulderguards of Zin-Malor' WHERE `item` = 9700175;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3549.6, `wy` = -5305.42, `zone_id` = 16, `object_name` = 'Shoulderguards of Zin-Malor' WHERE `item` = 9700176;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'The Wrath of Arkkoroc' WHERE `item` = 9700177;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3853.92, `wy` = -7181.62, `zone_id` = 16, `object_name` = 'The Wrath of Arkkoroc' WHERE `item` = 9700178;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5341.67, `wy` = -3277.08, `zone_id` = 16, `object_name` = 'Vuna''thell' WHERE `item` = 9700179;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3583.42, `wy` = -6218.17, `zone_id` = 16, `object_name` = 'Vuna''thell' WHERE `item` = 9700180;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6271.0, `wy` = -3745.79, `zone_id` = 3, `object_name` = 'Bloodstained Helm' WHERE `item` = 9700181;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6287.58, `wy` = -3745.79, `zone_id` = 3, `object_name` = 'Bloodstained Pendant' WHERE `item` = 9700182;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6901.17, `wy` = -2477.17, `zone_id` = 3, `object_name` = 'Bone Carver' WHERE `item` = 9700183;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7266.0, `wy` = -2128.92, `zone_id` = 3, `object_name` = 'Cowl of the Stone Summoner' WHERE `item` = 9700184;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6602.67, `wy` = -2651.29, `zone_id` = 3, `object_name` = 'Cracked Earth Vest' WHERE `item` = 9700185;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7033.83, `wy` = -3621.42, `zone_id` = 3, `object_name` = 'Deflector''s Wargreaves' WHERE `item` = 9700186;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6950.92, `wy` = -2402.54, `zone_id` = 3, `object_name` = 'Duststorm Sash' WHERE `item` = 9700187;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7299.17, `wy` = -3198.54, `zone_id` = 3, `object_name` = 'Earth Bindings' WHERE `item` = 9700188;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6785.08, `wy` = -3646.29, `zone_id` = 3, `object_name` = 'Garek''s Comfortable Robe' WHERE `item` = 9700189;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7149.92, `wy` = -2427.42, `zone_id` = 3, `object_name` = 'Hanging Ogre Scraps' WHERE `item` = 9700190;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5889.58, `wy` = -2079.17, `zone_id` = 3, `object_name` = 'Ogre Fire Poker' WHERE `item` = 9700191;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6834.83, `wy` = -2825.42, `zone_id` = 3, `object_name` = 'Ogre Fire Poker' WHERE `item` = 9700192;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5889.58, `wy` = -2079.17, `zone_id` = 3, `object_name` = 'Real Big Bone' WHERE `item` = 9700193;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6950.92, `wy` = -4069.17, `zone_id` = 3, `object_name` = 'Real Big Bone' WHERE `item` = 9700194;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7249.42, `wy` = -3472.17, `zone_id` = 3, `object_name` = 'Rock Runners' WHERE `item` = 9700195;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6619.25, `wy` = -2725.92, `zone_id` = 3, `object_name` = 'Safety Gloves' WHERE `item` = 9700196;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6735.33, `wy` = -2526.92, `zone_id` = 3, `object_name` = 'Sandworn Arcanist Staff' WHERE `item` = 9700197;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5889.58, `wy` = -2079.17, `zone_id` = 3, `object_name` = 'Shadowforge Shotgun' WHERE `item` = 9700198;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6337.33, `wy` = -3074.17, `zone_id` = 3, `object_name` = 'Shadowforge Shotgun' WHERE `item` = 9700199;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5889.58, `wy` = -2079.17, `zone_id` = 3, `object_name` = 'Shadowforged Deflector' WHERE `item` = 9700200;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6320.75, `wy` = -3099.04, `zone_id` = 3, `object_name` = 'Shadowforged Deflector' WHERE `item` = 9700201;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5889.58, `wy` = -2079.17, `zone_id` = 3, `object_name` = 'Spark of Infernus' WHERE `item` = 9700202;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6337.33, `wy` = -3123.92, `zone_id` = 3, `object_name` = 'Spark of Infernus' WHERE `item` = 9700203;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7166.5, `wy` = -3347.79, `zone_id` = 3, `object_name` = 'Spellpiercing Cloak' WHERE `item` = 9700204;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6818.25, `wy` = -3994.54, `zone_id` = 3, `object_name` = 'Staff of the Earth Guardian' WHERE `item` = 9700205;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7348.92, `wy` = -2352.79, `zone_id` = 3, `object_name` = 'Stonebloom Idol' WHERE `item` = 9700206;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6768.5, `wy` = -3123.92, `zone_id` = 3, `object_name` = 'Sunscorched Thrower' WHERE `item` = 9700207;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5889.58, `wy` = -2079.17, `zone_id` = 3, `object_name` = 'The Rock Binder' WHERE `item` = 9700208;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6470.0, `wy` = -2502.04, `zone_id` = 3, `object_name` = 'The Rock Binder' WHERE `item` = 9700209;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6851.42, `wy` = -3646.29, `zone_id` = 3, `object_name` = 'Thorkaf''s Prototype' WHERE `item` = 9700210;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6453.42, `wy` = -3397.54, `zone_id` = 3, `object_name` = 'Toe Hammer' WHERE `item` = 9700211;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6602.67, `wy` = -3422.42, `zone_id` = 3, `object_name` = 'Tomb Seeker' WHERE `item` = 9700212;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7100.17, `wy` = -3497.04, `zone_id` = 3, `object_name` = 'Gravesword' WHERE `item` = 9700213;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6785.08, `wy` = -3422.42, `zone_id` = 3, `object_name` = 'Wand of the Ancients' WHERE `item` = 9700214;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6967.5, `wy` = -2850.29, `zone_id` = 3, `object_name` = 'Wind-Worn Longbow' WHERE `item` = 9700215;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10879.33, `wy` = -2916.67, `zone_id` = 4, `object_name` = 'Bloodmage Coil' WHERE `item` = 9700216;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11683.33, `wy` = -3184.67, `zone_id` = 4, `object_name` = 'Portal Fragment' WHERE `item` = 9700217;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7480.23, `wy` = -2112.04, `zone_id` = 46, `object_name` = 'Ashen Cape' WHERE `item` = 9700218;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8085.37, `wy` = -1643.37, `zone_id` = 46, `object_name` = 'Ashenpeak Band' WHERE `item` = 9700219;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7519.27, `wy` = -1262.58, `zone_id` = 46, `object_name` = 'Blackbreach Handaxe' WHERE `item` = 9700220;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7968.25, `wy` = -2112.04, `zone_id` = 46, `object_name` = 'Burnscorch Wand' WHERE `item` = 9700221;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7890.17, `wy` = -1555.5, `zone_id` = 46, `object_name` = 'Charblaze Rifle' WHERE `item` = 9700222;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7792.56, `wy` = -1145.42, `zone_id` = 46, `object_name` = 'Charred Signet' WHERE `item` = 9700223;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8163.46, `wy` = -735.33, `zone_id` = 46, `object_name` = 'Cinderthread Sash' WHERE `item` = 9700224;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8124.42, `wy` = -2961.5, `zone_id` = 46, `object_name` = 'Darkflight Totem' WHERE `item` = 9700225;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7714.48, `wy` = -1701.96, `zone_id` = 46, `object_name` = 'Emberstep Sabatons' WHERE `item` = 9700226;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7968.25, `wy` = -2727.17, `zone_id` = 46, `object_name` = 'Empty Ogre Loot Sack' WHERE `item` = 9700227;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8026.81, `wy` = -1262.58, `zone_id` = 46, `object_name` = 'Firebrand Libram' WHERE `item` = 9700228;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7031.25, `wy` = -266.67, `zone_id` = 46, `object_name` = 'Grave Offering' WHERE `item` = 9700229;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7987.77, `wy` = -2375.67, `zone_id` = 46, `object_name` = 'Grave Offering' WHERE `item` = 9700230;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7831.6, `wy` = -1848.42, `zone_id` = 46, `object_name` = 'Inferno Gavel' WHERE `item` = 9700231;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7636.4, `wy` = -2317.08, `zone_id` = 46, `object_name` = 'Lava Absorbing Blade' WHERE `item` = 9700232;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7968.25, `wy` = -1321.17, `zone_id` = 46, `object_name` = 'Magmaweave Pantaloons' WHERE `item` = 9700233;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7460.71, `wy` = -2199.92, `zone_id` = 46, `object_name` = 'Obsidian Boltthrower' WHERE `item` = 9700234;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7655.92, `wy` = -2199.92, `zone_id` = 46, `object_name` = 'The Final Strike' WHERE `item` = 9700235;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7773.04, `wy` = -2053.46, `zone_id` = 46, `object_name` = 'Volcanic Aegis' WHERE `item` = 9700236;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6237.33, `wy` = 976.67, `zone_id` = 148, `object_name` = 'Ancient Family Heirloom' WHERE `item` = 9700237;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 7329.0, `wy` = -791.83, `zone_id` = 148, `object_name` = 'Ancient Highborne Tome' WHERE `item` = 9700238;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5189.33, `wy` = 256.17, `zone_id` = 148, `object_name` = 'Auberdine Scimitar' WHERE `item` = 9700239;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4665.33, `wy` = 59.67, `zone_id` = 148, `object_name` = 'Blackwood Torch' WHERE `item` = 9700240;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4665.33, `wy` = 59.67, `zone_id` = 148, `object_name` = 'Blackwood Torch' WHERE `item` = 9700241;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 7984.0, `wy` = -1119.33, `zone_id` = 148, `object_name` = 'Enchanted Flora Waist' WHERE `item` = 9700242;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6674.0, `wy` = -71.33, `zone_id` = 148, `object_name` = 'Hidden Chest' WHERE `item` = 9700243;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 7154.33, `wy` = -726.33, `zone_id` = 148, `object_name` = 'Fanatic''s Cursed Blade' WHERE `item` = 9700244;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4534.33, `wy` = 583.67, `zone_id` = 148, `object_name` = 'Faulty Stone Golem' WHERE `item` = 9700245;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5669.67, `wy` = 59.67, `zone_id` = 148, `object_name` = 'Forsaken Stone Braid' WHERE `item` = 9700246;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6848.67, `wy` = -464.33, `zone_id` = 148, `object_name` = 'Furbolg War-drum' WHERE `item` = 9700247;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5626.0, `wy` = 256.17, `zone_id` = 148, `object_name` = 'Highborne Trousers' WHERE `item` = 9700248;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5800.67, `wy` = 583.67, `zone_id` = 148, `object_name` = 'Hunk of Darkshore Driftwood' WHERE `item` = 9700249;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5364.0, `wy` = 125.17, `zone_id` = 148, `object_name` = 'Moon-knawed Bone Spire' WHERE `item` = 9700250;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5495.0, `wy` = 518.17, `zone_id` = 148, `object_name` = 'Moonrest Slippers' WHERE `item` = 9700251;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6892.33, `wy` = 387.17, `zone_id` = 148, `object_name` = 'Relicseeker Staff' WHERE `item` = 9700252;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 7154.33, `wy` = 321.67, `zone_id` = 148, `object_name` = 'Shipwrecked Crate' WHERE `item` = 9700253;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4927.33, `wy` = 583.67, `zone_id` = 148, `object_name` = 'Shorebreeze Sabatons' WHERE `item` = 9700254;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 7329.0, `wy` = -922.83, `zone_id` = 148, `object_name` = 'Stormscale Guard' WHERE `item` = 9700255;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4665.33, `wy` = 780.17, `zone_id` = 148, `object_name` = 'Tide Turner' WHERE `item` = 9700256;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4534.33, `wy` = 387.17, `zone_id` = 148, `object_name` = 'Twilight Bands' WHERE `item` = 9700257;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4185.0, `wy` = 452.67, `zone_id` = 148, `object_name` = 'Twilight Vale' WHERE `item` = 9700258;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6193.67, `wy` = 190.67, `zone_id` = 148, `object_name` = 'Unpleasant Ring' WHERE `item` = 9700259;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 7329.0, `wy` = -333.33, `zone_id` = 148, `object_name` = 'Washed Ashore Bottle' WHERE `item` = 9700260;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5102.0, `wy` = 256.17, `zone_id` = 148, `object_name` = 'Wild Longbow' WHERE `item` = 9700261;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5975.33, `wy` = 321.67, `zone_id` = 148, `object_name` = 'Windshaper Wraps' WHERE `item` = 9700262;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11150.0, `wy` = -1958.33, `zone_id` = 41, `object_name` = 'Bag of Folding' WHERE `item` = 9700263;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 32.37, `wy` = 1805.58, `zone_id` = 405, `object_name` = 'Abandoned Boots' WHERE `item` = 9700264;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1796.35, `wy` = 366.92, `zone_id` = 405, `object_name` = 'Alchemy Visceral Juice' WHERE `item` = 9700265;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1496.56, `wy` = 2749.71, `zone_id` = 405, `object_name` = 'Ambereye Amulet' WHERE `item` = 9700266;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -597.19, `wy` = 816.5, `zone_id` = 405, `object_name` = 'Blade of Dread' WHERE `item` = 9700267;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -597.19, `wy` = 816.5, `zone_id` = 405, `object_name` = 'Blade of Dread' WHERE `item` = 9700268;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Blade of Thunder' WHERE `item` = 9700269;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -387.33, `wy` = 1850.54, `zone_id` = 405, `object_name` = 'Blade of Thunder' WHERE `item` = 9700270;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Bone Harvester' WHERE `item` = 9700271;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -807.04, `wy` = 2390.04, `zone_id` = 405, `object_name` = 'Bone Harvester' WHERE `item` = 9700272;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Bone Splitter' WHERE `item` = 9700273;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1286.71, `wy` = 1940.46, `zone_id` = 405, `object_name` = 'Bone Splitter' WHERE `item` = 9700274;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1166.79, `wy` = 2255.17, `zone_id` = 405, `object_name` = 'Buried Bracers' WHERE `item` = 9700275;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Burning Blade Ritual Knife' WHERE `item` = 9700276;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1706.42, `wy` = 1985.42, `zone_id` = 405, `object_name` = 'Burning Blade Ritual Knife' WHERE `item` = 9700277;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -477.27, `wy` = 1805.58, `zone_id` = 405, `object_name` = 'Burning Gauntlets' WHERE `item` = 9700278;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1406.62, `wy` = 1490.87, `zone_id` = 405, `object_name` = 'Caravan Guard Pauldrons' WHERE `item` = 9700279;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -747.08, `wy` = 1445.92, `zone_id` = 405, `object_name` = 'Caravan Guard Vest' WHERE `item` = 9700280;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -417.31, `wy` = 1131.21, `zone_id` = 405, `object_name` = 'Circlet of Desolation' WHERE `item` = 9700281;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -417.31, `wy` = 1131.21, `zone_id` = 405, `object_name` = 'Circlet of Desolation' WHERE `item` = 9700282;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Crown of the Great Khan' WHERE `item` = 9700283;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1976.23, `wy` = 1266.08, `zone_id` = 405, `object_name` = 'Crown of the Great Khan' WHERE `item` = 9700284;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Diving Boots' WHERE `item` = 9700285;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -57.56, `wy` = 2659.79, `zone_id` = 405, `object_name` = 'Diving Boots' WHERE `item` = 9700286;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2006.21, `wy` = 1940.46, `zone_id` = 405, `object_name` = 'Doomwarden' WHERE `item` = 9700287;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2006.21, `wy` = 1940.46, `zone_id` = 405, `object_name` = 'Doomwarden' WHERE `item` = 9700288;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -717.1, `wy` = 1445.92, `zone_id` = 405, `object_name` = 'Dustscour Courier Belt' WHERE `item` = 9700289;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -327.37, `wy` = 1670.71, `zone_id` = 405, `object_name` = 'Flamescoured Bow' WHERE `item` = 9700290;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -327.37, `wy` = 1670.71, `zone_id` = 405, `object_name` = 'Flamescoured Bow' WHERE `item` = 9700291;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2335.98, `wy` = 2435.0, `zone_id` = 405, `object_name` = 'Gelkis Cleaver' WHERE `item` = 9700292;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1616.48, `wy` = 1490.87, `zone_id` = 405, `object_name` = 'Gloves of Patience' WHERE `item` = 9700293;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1346.67, `wy` = 2929.54, `zone_id` = 405, `object_name` = 'Greataxe of Kolk' WHERE `item` = 9700294;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Hatefury Skull Totem' WHERE `item` = 9700295;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -237.44, `wy` = 1041.29, `zone_id` = 405, `object_name` = 'Hatefury Skull Totem' WHERE `item` = 9700296;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Hatefury Wand' WHERE `item` = 9700297;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -87.54, `wy` = 771.54, `zone_id` = 405, `object_name` = 'Hatefury Wand' WHERE `item` = 9700298;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1886.29, `wy` = 1805.58, `zone_id` = 405, `object_name` = 'Heretical Libram' WHERE `item` = 9700299;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1886.29, `wy` = 1805.58, `zone_id` = 405, `object_name` = 'Heretical Libram' WHERE `item` = 9700300;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1436.6, `wy` = 3019.46, `zone_id` = 405, `object_name` = 'Icon of Khan Maraudos' WHERE `item` = 9700301;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Jairal''Kesh, Staff of Summoning' WHERE `item` = 9700302;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1976.23, `wy` = 546.75, `zone_id` = 405, `object_name` = 'Jairal''Kesh, Staff of Summoning' WHERE `item` = 9700303;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1406.62, `wy` = 2075.33, `zone_id` = 405, `object_name` = 'Kodo Hide Cloak' WHERE `item` = 9700304;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Kodo Hunter' WHERE `item` = 9700305;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1346.67, `wy` = 951.37, `zone_id` = 405, `object_name` = 'Kodo Hunter' WHERE `item` = 9700306;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -447.29, `wy` = 2614.83, `zone_id` = 405, `object_name` = 'Lost Mariner Bracers' WHERE `item` = 9700307;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -537.23, `wy` = 2749.71, `zone_id` = 405, `object_name` = 'Lost Mariner Leggings' WHERE `item` = 9700308;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1766.37, `wy` = 951.37, `zone_id` = 405, `object_name` = 'Magram Hatchet' WHERE `item` = 9700309;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1766.37, `wy` = 951.37, `zone_id` = 405, `object_name` = 'Magram Hatchet' WHERE `item` = 9700310;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1526.54, `wy` = 2839.62, `zone_id` = 405, `object_name` = 'Maraudine Breastplate' WHERE `item` = 9700311;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1376.65, `wy` = 2659.79, `zone_id` = 405, `object_name` = 'Maraudine Cape' WHERE `item` = 9700312;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1376.65, `wy` = 2749.71, `zone_id` = 405, `object_name` = 'Maraudine Gloves' WHERE `item` = 9700313;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Moonglow Bag' WHERE `item` = 9700314;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 212.25, `wy` = 1356.0, `zone_id` = 405, `object_name` = 'Moonglow Bag' WHERE `item` = 9700315;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Offering to Azshara' WHERE `item` = 9700316;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 242.23, `wy` = 2974.5, `zone_id` = 405, `object_name` = 'Offering to Azshara' WHERE `item` = 9700317;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Orb of Dawn' WHERE `item` = 9700318;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -357.35, `wy` = 2479.96, `zone_id` = 405, `object_name` = 'Orb of Dawn' WHERE `item` = 9700319;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2306.0, `wy` = 2614.83, `zone_id` = 405, `object_name` = 'Pillaged Legguards' WHERE `item` = 9700320;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -717.1, `wy` = 591.71, `zone_id` = 405, `object_name` = 'Ring of Arakosh' WHERE `item` = 9700321;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 62.35, `wy` = 2120.29, `zone_id` = 405, `object_name` = 'Ring of Korvaix' WHERE `item` = 9700322;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -357.35, `wy` = 1760.62, `zone_id` = 405, `object_name` = 'Ritual Robes' WHERE `item` = 9700323;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Shadowbreaker' WHERE `item` = 9700324;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1856.31, `wy` = 591.71, `zone_id` = 405, `object_name` = 'Shadowbreaker' WHERE `item` = 9700325;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1586.5, `wy` = 3154.33, `zone_id` = 405, `object_name` = 'Shadowprey Bag' WHERE `item` = 9700326;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1586.5, `wy` = 3154.33, `zone_id` = 405, `object_name` = 'Shadowprey Bag' WHERE `item` = 9700327;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1166.79, `wy` = 2974.5, `zone_id` = 405, `object_name` = 'Shadowshard Shield' WHERE `item` = 9700328;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1946.25, `wy` = 3064.42, `zone_id` = 405, `object_name` = 'Shell Cracker' WHERE `item` = 9700329;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1946.25, `wy` = 3064.42, `zone_id` = 405, `object_name` = 'Shell Cracker' WHERE `item` = 9700330;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -87.54, `wy` = 1670.71, `zone_id` = 405, `object_name` = 'Shoulderpads of the Conjuror' WHERE `item` = 9700331;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1436.6, `wy` = 1985.42, `zone_id` = 405, `object_name` = 'Sorrow of the Kodo' WHERE `item` = 9700332;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1436.6, `wy` = 1985.42, `zone_id` = 405, `object_name` = 'Sorrow of the Kodo' WHERE `item` = 9700333;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Spear of Hatred' WHERE `item` = 9700334;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 62.35, `wy` = 906.42, `zone_id` = 405, `object_name` = 'Spear of Hatred' WHERE `item` = 9700335;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Stormpiercer' WHERE `item` = 9700336;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1166.79, `wy` = 2884.58, `zone_id` = 405, `object_name` = 'Stormpiercer' WHERE `item` = 9700337;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Sunken Ring' WHERE `item` = 9700338;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1976.23, `wy` = 2255.17, `zone_id` = 405, `object_name` = 'Sunken Ring' WHERE `item` = 9700339;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2216.06, `wy` = 1400.96, `zone_id` = 405, `object_name` = 'The Undying Eye' WHERE `item` = 9700340;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2216.06, `wy` = 1400.96, `zone_id` = 405, `object_name` = 'The Undying Eye' WHERE `item` = 9700341;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'The Winning Javelin' WHERE `item` = 9700342;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -986.92, `wy` = 1670.71, `zone_id` = 405, `object_name` = 'The Winning Javelin' WHERE `item` = 9700343;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1976.23, `wy` = 2659.79, `zone_id` = 405, `object_name` = 'Warcaster Slippers' WHERE `item` = 9700344;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Water Seer''s Headdress' WHERE `item` = 9700345;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -207.46, `wy` = 2749.71, `zone_id` = 405, `object_name` = 'Water Seer''s Headdress' WHERE `item` = 9700346;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -807.04, `wy` = 951.37, `zone_id` = 405, `object_name` = 'Wind Ritual Staff' WHERE `item` = 9700347;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 452.08, `wy` = 4233.33, `zone_id` = 405, `object_name` = 'Woven Flowers' WHERE `item` = 9700348;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1016.9, `wy` = 861.46, `zone_id` = 405, `object_name` = 'Woven Flowers' WHERE `item` = 9700349;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 32.37, `wy` = 2569.87, `zone_id` = 405, `object_name` = 'Zelyn''Theris' WHERE `item` = 9700350;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5584.42, `wy` = 669.33, `zone_id` = 1, `object_name` = 'Arctic Imbued Stick' WHERE `item` = 9700351;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5387.42, `wy` = -1300.67, `zone_id` = 1, `object_name` = 'Claw of Vagash' WHERE `item` = 9700352;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5321.75, `wy` = -118.67, `zone_id` = 1, `object_name` = 'Claw Scarred Mail' WHERE `item` = 9700353;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3877.08, `wy` = 1802.08, `zone_id` = 1, `object_name` = 'Claw of Vagash' WHERE `item` = 9700354;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5387.42, `wy` = -1300.67, `zone_id` = 1, `object_name` = 'Claw of Vagash' WHERE `item` = 9700355;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5781.42, `wy` = -1349.92, `zone_id` = 1, `object_name` = 'Coldhewn Tanning Gloves' WHERE `item` = 9700356;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5879.92, `wy` = -1990.17, `zone_id` = 1, `object_name` = 'Dark Iron Vest' WHERE `item` = 9700357;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6076.92, `wy` = 423.08, `zone_id` = 1, `object_name` = 'Fire Poker' WHERE `item` = 9700358;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6405.25, `wy` = 373.83, `zone_id` = 1, `object_name` = 'Forgotten Knapsack' WHERE `item` = 9700359;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5584.42, `wy` = 718.58, `zone_id` = 1, `object_name` = 'Frostmane Axe' WHERE `item` = 9700360;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3877.08, `wy` = 1802.08, `zone_id` = 1, `object_name` = 'Frostmane Totem' WHERE `item` = 9700361;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5026.25, `wy` = -217.17, `zone_id` = 1, `object_name` = 'Frostmane Totem' WHERE `item` = 9700362;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5650.08, `wy` = -118.67, `zone_id` = 1, `object_name` = 'Frozen Finger' WHERE `item` = 9700363;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6142.58, `wy` = 78.33, `zone_id` = 1, `object_name` = 'Glinting Necklace' WHERE `item` = 9700364;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5288.92, `wy` = 472.33, `zone_id` = 1, `object_name` = 'Gnomeregan Spanner' WHERE `item` = 9700365;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5059.08, `wy` = -20.17, `zone_id` = 1, `object_name` = 'Intact Wagon Wheel' WHERE `item` = 9700366;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6503.75, `wy` = 324.58, `zone_id` = 1, `object_name` = 'Lost Adventurer''s Ring' WHERE `item` = 9700367;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5912.75, `wy` = 29.08, `zone_id` = 1, `object_name` = 'Lost Mountaineer''s Bow' WHERE `item` = 9700368;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5912.75, `wy` = 29.08, `zone_id` = 1, `object_name` = 'Lost Mountaineer''s Bow' WHERE `item` = 9700369;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6044.08, `wy` = -414.17, `zone_id` = 1, `object_name` = 'Lumber Axe' WHERE `item` = 9700370;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5617.25, `wy` = -512.67, `zone_id` = 1, `object_name` = 'Magnus'' Mug' WHERE `item` = 9700371;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3877.08, `wy` = 1802.08, `zone_id` = 1, `object_name` = 'Officer''s Pike' WHERE `item` = 9700372;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5485.92, `wy` = -2433.42, `zone_id` = 1, `object_name` = 'Officer''s Pike' WHERE `item` = 9700373;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5288.92, `wy` = 78.33, `zone_id` = 1, `object_name` = 'Rabbit''s Paw' WHERE `item` = 9700374;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5814.25, `wy` = -266.42, `zone_id` = 1, `object_name` = 'Repelling Necklace' WHERE `item` = 9700375;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5518.75, `wy` = -1399.17, `zone_id` = 1, `object_name` = 'Rider''s Ring' WHERE `item` = 9700376;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5584.42, `wy` = -1990.17, `zone_id` = 1, `object_name` = 'Sailor''s Ring' WHERE `item` = 9700377;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6044.08, `wy` = -217.17, `zone_id` = 1, `object_name` = 'Salvaged Cannon' WHERE `item` = 9700378;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5617.25, `wy` = -709.67, `zone_id` = 1, `object_name` = 'Snow Shovel' WHERE `item` = 9700379;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6241.08, `wy` = 176.83, `zone_id` = 1, `object_name` = 'Spicy Candle' WHERE `item` = 9700380;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5354.58, `wy` = -1005.17, `zone_id` = 1, `object_name` = 'Thawed Boots' WHERE `item` = 9700381;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5124.75, `wy` = -2334.92, `zone_id` = 1, `object_name` = 'Throwing Rock' WHERE `item` = 9700382;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5124.75, `wy` = -2334.92, `zone_id` = 1, `object_name` = 'Throwing Rock' WHERE `item` = 9700383;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5748.58, `wy` = -364.92, `zone_id` = 1, `object_name` = 'Warm Whoolies' WHERE `item` = 9700384;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -412.42, `wy` = -4341.87, `zone_id` = 14, `object_name` = 'Abandoned Peon''s Sack' WHERE `item` = 9700385;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -271.42, `wy` = -4289.0, `zone_id` = 14, `object_name` = 'Apprentice Staff' WHERE `item` = 9700386;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1046.92, `wy` = -4764.87, `zone_id` = 14, `object_name` = 'Apprentice''s Harpoon' WHERE `item` = 9700387;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1046.92, `wy` = -4764.87, `zone_id` = 14, `object_name` = 'Apprentice''s Harpoon' WHERE `item` = 9700388;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1364.17, `wy` = -5135.0, `zone_id` = 14, `object_name` = 'Bloodtalon Vestments' WHERE `item` = 9700389;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 433.58, `wy` = -4236.12, `zone_id` = 14, `object_name` = 'Bramble Shield' WHERE `item` = 9700390;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -59.92, `wy` = -4183.25, `zone_id` = 14, `object_name` = 'Burning Blade Ring' WHERE `item` = 9700391;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Centaur Axe' WHERE `item` = 9700392;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -905.92, `wy` = -4500.5, `zone_id` = 14, `object_name` = 'Centaur Axe' WHERE `item` = 9700393;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Champion''s Band' WHERE `item` = 9700394;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 186.83, `wy` = -3971.75, `zone_id` = 14, `object_name` = 'Champion''s Band' WHERE `item` = 9700395;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 186.83, `wy` = -5082.12, `zone_id` = 14, `object_name` = 'Charred Battlegreaves' WHERE `item` = 9700396;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 574.58, `wy` = -4553.37, `zone_id` = 14, `object_name` = 'Earthshatterer Gavel' WHERE `item` = 9700397;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1244.33, `wy` = -4500.5, `zone_id` = 14, `object_name` = 'Farm Hands' WHERE `item` = 9700398;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Firestarter' WHERE `item` = 9700399;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 45.83, `wy` = -4236.12, `zone_id` = 14, `object_name` = 'Firestarter' WHERE `item` = 9700400;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -835.42, `wy` = -4553.37, `zone_id` = 14, `object_name` = 'Grunt''s Old Knife' WHERE `item` = 9700401;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 645.08, `wy` = -4553.37, `zone_id` = 14, `object_name` = 'Harpy Hunter' WHERE `item` = 9700402;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 645.08, `wy` = -4553.37, `zone_id` = 14, `object_name` = 'Harpy Hunter' WHERE `item` = 9700403;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -271.42, `wy` = -5135.0, `zone_id` = 14, `object_name` = 'Kul Tiras Armplates' WHERE `item` = 9700404;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1646.17, `wy` = -5293.62, `zone_id` = 14, `object_name` = 'Kul Tiras Handwraps' WHERE `item` = 9700405;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Logsplitter' WHERE `item` = 9700406;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 750.83, `wy` = -4289.0, `zone_id` = 14, `object_name` = 'Logsplitter' WHERE `item` = 9700407;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1103.33, `wy` = -4923.5, `zone_id` = 14, `object_name` = 'Margoz'' Spare Stompers' WHERE `item` = 9700408;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 997.58, `wy` = -3918.87, `zone_id` = 14, `object_name` = 'Orcish Fishing Device' WHERE `item` = 9700409;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 116.33, `wy` = -4500.5, `zone_id` = 14, `object_name` = 'Quilbow' WHERE `item` = 9700410;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -800.17, `wy` = -5399.37, `zone_id` = 14, `object_name` = 'Raptorscale Cloak' WHERE `item` = 9700411;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 786.08, `wy` = -4553.37, `zone_id` = 14, `object_name` = 'Ravine Sack' WHERE `item` = 9700412;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -800.17, `wy` = -4764.87, `zone_id` = 14, `object_name` = 'Redrock Sash' WHERE `item` = 9700413;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 574.58, `wy` = -4130.37, `zone_id` = 14, `object_name` = 'Retired Grunt''s Chainmail' WHERE `item` = 9700414;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 609.83, `wy` = -4923.5, `zone_id` = 14, `object_name` = 'Retired Shadow Blade' WHERE `item` = 9700415;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 222.08, `wy` = -5240.75, `zone_id` = 14, `object_name` = 'Sailor''s Cuffs' WHERE `item` = 9700416;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Sailor''s Gambeson' WHERE `item` = 9700417;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -59.92, `wy` = -4976.37, `zone_id` = 14, `object_name` = 'Sailor''s Gambeson' WHERE `item` = 9700418;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Scalper''s Sack' WHERE `item` = 9700419;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -729.67, `wy` = -5610.87, `zone_id` = 14, `object_name` = 'Scalper''s Sack' WHERE `item` = 9700420;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -941.17, `wy` = -4024.62, `zone_id` = 14, `object_name` = 'Skull Ring' WHERE `item` = 9700421;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -412.42, `wy` = -3284.37, `zone_id` = 14, `object_name` = 'Skull Sword' WHERE `item` = 9700422;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Southfury Totem' WHERE `item` = 9700423;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -236.17, `wy` = -3918.87, `zone_id` = 14, `object_name` = 'Southfury Totem' WHERE `item` = 9700424;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Stormwitch Staff' WHERE `item` = 9700425;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1103.33, `wy` = -4659.12, `zone_id` = 14, `object_name` = 'Stormwitch Staff' WHERE `item` = 9700426;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1152.67, `wy` = -5558.0, `zone_id` = 14, `object_name` = 'String of Ears' WHERE `item` = 9700427;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 962.33, `wy` = -4289.0, `zone_id` = 14, `object_name` = 'Thunder Hide Tailspike' WHERE `item` = 9700428;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1808.33, `wy` = -1962.5, `zone_id` = 14, `object_name` = 'Totem Charged Mace' WHERE `item` = 9700429;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -271.42, `wy` = -3971.75, `zone_id` = 14, `object_name` = 'Totem Charged Mace' WHERE `item` = 9700430;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -236.17, `wy` = -5293.62, `zone_id` = 14, `object_name` = 'Treasured Cutlass' WHERE `item` = 9700431;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -941.17, `wy` = -4289.0, `zone_id` = 14, `object_name` = 'Wristguards of the Elements' WHERE `item` = 9700432;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10328.67, `wy` = 401.33, `zone_id` = 10, `object_name` = 'Catacombs Relic Torch' WHERE `item` = 9700433;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10364.67, `wy` = 320.33, `zone_id` = 10, `object_name` = 'Casket Will' WHERE `item` = 9700434;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10328.67, `wy` = 401.33, `zone_id` = 10, `object_name` = 'Catacombs Relic Torch' WHERE `item` = 9700435;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9716.67, `wy` = 833.33, `zone_id` = 10, `object_name` = 'Cursed Toy' WHERE `item` = 9700436;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10724.67, `wy` = 320.33, `zone_id` = 10, `object_name` = 'Cursed Toy' WHERE `item` = 9700437;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10364.67, `wy` = 374.33, `zone_id` = 10, `object_name` = 'Catacombs Torch' WHERE `item` = 9700438;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11138.67, `wy` = -435.67, `zone_id` = 10, `object_name` = 'Defias Night Blade' WHERE `item` = 9700439;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11048.67, `wy` = -1326.67, `zone_id` = 10, `object_name` = 'Haunted Bouquet' WHERE `item` = 9700440;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9716.67, `wy` = 833.33, `zone_id` = 10, `object_name` = 'Eliza''s Pendant' WHERE `item` = 9700441;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10310.67, `wy` = -3.67, `zone_id` = 10, `object_name` = 'Eliza''s Pendant' WHERE `item` = 9700442;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10868.67, `wy` = -435.67, `zone_id` = 10, `object_name` = 'Emerald Shard' WHERE `item` = 9700443;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10274.67, `wy` = 185.33, `zone_id` = 10, `object_name` = 'Hazard Mantle' WHERE `item` = 9700444;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9770.67, `wy` = -1569.67, `zone_id` = 10, `object_name` = 'Jack''s Toothpicker' WHERE `item` = 9700445;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10544.67, `wy` = -1191.67, `zone_id` = 10, `object_name` = 'Lohgan''s Best Bag' WHERE `item` = 9700446;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11120.67, `wy` = 536.33, `zone_id` = 10, `object_name` = 'Madness Cursed Notes' WHERE `item` = 9700447;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10850.67, `wy` = -462.67, `zone_id` = 10, `object_name` = 'Munitions Delivery Package' WHERE `item` = 9700448;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9716.67, `wy` = 833.33, `zone_id` = 10, `object_name` = 'Nightshot' WHERE `item` = 9700449;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11030.67, `wy` = 266.33, `zone_id` = 10, `object_name` = 'Nightshot' WHERE `item` = 9700450;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9716.67, `wy` = 833.33, `zone_id` = 10, `object_name` = 'Nightwatch Circlet' WHERE `item` = 9700451;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10652.67, `wy` = -1272.67, `zone_id` = 10, `object_name` = 'Nightwatch Circlet' WHERE `item` = 9700452;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11048.67, `wy` = -894.67, `zone_id` = 10, `object_name` = 'Pack Lead Bone Ring' WHERE `item` = 9700453;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10166.67, `wy` = 320.33, `zone_id` = 10, `object_name` = 'Peculiar Root' WHERE `item` = 9700454;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10166.67, `wy` = 320.33, `zone_id` = 10, `object_name` = 'Peculiar Root' WHERE `item` = 9700455;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10292.67, `wy` = 158.33, `zone_id` = 10, `object_name` = 'Hazard Mantle' WHERE `item` = 9700456;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10562.67, `wy` = 266.33, `zone_id` = 10, `object_name` = 'Raven Hill Backscratcher' WHERE `item` = 9700457;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9716.67, `wy` = 833.33, `zone_id` = 10, `object_name` = 'Roland''s Striker' WHERE `item` = 9700458;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11138.67, `wy` = -1164.67, `zone_id` = 10, `object_name` = 'Roland''s Striker' WHERE `item` = 9700459;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9716.67, `wy` = 833.33, `zone_id` = 10, `object_name` = 'Ruby Skeletal Ring' WHERE `item` = 9700460;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10256.67, `wy` = 239.33, `zone_id` = 10, `object_name` = 'Ruby Skeletal Ring' WHERE `item` = 9700461;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10724.67, `wy` = -1110.67, `zone_id` = 10, `object_name` = 'Sack of Regenerating Provisions' WHERE `item` = 9700462;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10562.67, `wy` = -1488.67, `zone_id` = 10, `object_name` = 'Silky Spaulders' WHERE `item` = 9700463;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10814.67, `wy` = -1380.67, `zone_id` = 10, `object_name` = 'Suspiciously Brown Trousers' WHERE `item` = 9700464;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10454.67, `wy` = -813.67, `zone_id` = 10, `object_name` = 'The Dark Soul' WHERE `item` = 9700465;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10724.67, `wy` = 374.33, `zone_id` = 10, `object_name` = 'The Jitters' WHERE `item` = 9700466;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10724.67, `wy` = 374.33, `zone_id` = 10, `object_name` = 'The Jitters' WHERE `item` = 9700467;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10364.67, `wy` = -1245.67, `zone_id` = 10, `object_name` = 'Tiloa''s Flowers' WHERE `item` = 9700468;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10922.67, `wy` = 428.33, `zone_id` = 10, `object_name` = 'Venom Sample' WHERE `item` = 9700469;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9716.67, `wy` = 833.33, `zone_id` = 10, `object_name` = 'Vul''Gol Torch' WHERE `item` = 9700470;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11228.67, `wy` = -165.67, `zone_id` = 10, `object_name` = 'Vul''Gol Torch' WHERE `item` = 9700471;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3888.33, `wy` = -3862.5, `zone_id` = 15, `object_name` = 'Beezil''s Pants' WHERE `item` = 9700472;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2033.33, `wy` = -975.0, `zone_id` = 15, `object_name` = 'Blackhoof Warmaul' WHERE `item` = 9700473;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2593.33, `wy` = -3232.5, `zone_id` = 15, `object_name` = 'Blackhoof Warmaul' WHERE `item` = 9700474;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4343.33, `wy` = -2655.0, `zone_id` = 15, `object_name` = 'Bloodfen Prowler Vest' WHERE `item` = 9700475;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4343.33, `wy` = -2602.5, `zone_id` = 15, `object_name` = 'Raptor Talon' WHERE `item` = 9700476;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4378.33, `wy` = -3075.0, `zone_id` = 15, `object_name` = 'Burnt Spaulders' WHERE `item` = 9700477;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3993.33, `wy` = -3810.0, `zone_id` = 15, `object_name` = 'Buzzcoil Tongs' WHERE `item` = 9700478;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4448.33, `wy` = -3600.0, `zone_id` = 15, `object_name` = 'Corrupted Dragon Eye' WHERE `item` = 9700479;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3223.33, `wy` = -2760.0, `zone_id` = 15, `object_name` = 'Crokolisk Hunter' WHERE `item` = 9700480;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3643.33, `wy` = -3442.5, `zone_id` = 15, `object_name` = 'Cylla''s Endless Potion' WHERE `item` = 9700481;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4378.33, `wy` = -3915.0, `zone_id` = 15, `object_name` = 'Cylla''s Endless Potion' WHERE `item` = 9700482;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4448.33, `wy` = -2917.5, `zone_id` = 15, `object_name` = 'Denflame Channeler' WHERE `item` = 9700483;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3223.33, `wy` = -3022.5, `zone_id` = 15, `object_name` = 'Drywallow Gloves' WHERE `item` = 9700484;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4728.33, `wy` = -4020.0, `zone_id` = 15, `object_name` = 'Durn''s Loot Bag' WHERE `item` = 9700485;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4658.33, `wy` = -3915.0, `zone_id` = 15, `object_name` = 'Emberheart Talisman' WHERE `item` = 9700486;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5008.33, `wy` = -3862.5, `zone_id` = 15, `object_name` = 'Emberscale Greatsword' WHERE `item` = 9700487;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2033.33, `wy` = -975.0, `zone_id` = 15, `object_name` = 'Emberstring Drakebow' WHERE `item` = 9700488;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4308.33, `wy` = -3022.5, `zone_id` = 15, `object_name` = 'Emberstring Drakebow' WHERE `item` = 9700489;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4763.33, `wy` = -3285.0, `zone_id` = 15, `object_name` = 'Enchanted Dragon Bone' WHERE `item` = 9700490;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4448.33, `wy` = -3915.0, `zone_id` = 15, `object_name` = 'Inscribed Sash' WHERE `item` = 9700491;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2033.33, `wy` = -975.0, `zone_id` = 15, `object_name` = 'Last Guardian' WHERE `item` = 9700492;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2663.33, `wy` = -4072.5, `zone_id` = 15, `object_name` = 'Last Guardian' WHERE `item` = 9700493;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3468.33, `wy` = -2865.0, `zone_id` = 15, `object_name` = 'Marshfall Mantle' WHERE `item` = 9700494;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2033.33, `wy` = -975.0, `zone_id` = 15, `object_name` = 'Missing Apprentice Wand' WHERE `item` = 9700495;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2768.33, `wy` = -2865.0, `zone_id` = 15, `object_name` = 'Missing Apprentice Wand' WHERE `item` = 9700496;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3363.33, `wy` = -2812.5, `zone_id` = 15, `object_name` = 'Mudcrush Shoulders' WHERE `item` = 9700497;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2663.33, `wy` = -3547.5, `zone_id` = 15, `object_name` = 'Northpoint Helmet' WHERE `item` = 9700498;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2593.33, `wy` = -4020.0, `zone_id` = 15, `object_name` = 'Primitive Murloc Skewer' WHERE `item` = 9700499;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2593.33, `wy` = -4020.0, `zone_id` = 15, `object_name` = 'Primitive Murloc Skewer' WHERE `item` = 9700500;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3643.33, `wy` = -4072.5, `zone_id` = 15, `object_name` = 'Salt Scoured Boarding Axe' WHERE `item` = 9700501;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4553.33, `wy` = -3600.0, `zone_id` = 15, `object_name` = 'Scorched Bindings' WHERE `item` = 9700502;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3538.33, `wy` = -2812.5, `zone_id` = 15, `object_name` = 'Seed of Overgrowth' WHERE `item` = 9700503;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3748.33, `wy` = -2550.0, `zone_id` = 15, `object_name` = 'Singed Flintlock' WHERE `item` = 9700504;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2033.33, `wy` = -975.0, `zone_id` = 15, `object_name` = 'Spotter''s Rifle' WHERE `item` = 9700505;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3993.33, `wy` = -3967.5, `zone_id` = 15, `object_name` = 'Spotter''s Rifle' WHERE `item` = 9700506;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4378.33, `wy` = -3285.0, `zone_id` = 15, `object_name` = 'Stonemaul Crusher’s Girdle' WHERE `item` = 9700507;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2033.33, `wy` = -975.0, `zone_id` = 15, `object_name` = 'Sturdy Coffin Lid' WHERE `item` = 9700508;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3538.33, `wy` = -4335.0, `zone_id` = 15, `object_name` = 'Sturdy Coffin Lid' WHERE `item` = 9700509;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2943.33, `wy` = -3915.0, `zone_id` = 15, `object_name` = 'Swamplight Concoction' WHERE `item` = 9700510;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2873.33, `wy` = -3442.5, `zone_id` = 15, `object_name` = 'Theramore Girdle' WHERE `item` = 9700511;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4238.33, `wy` = -3915.0, `zone_id` = 15, `object_name` = 'Tidefury Cutlass' WHERE `item` = 9700512;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2733.33, `wy` = -2602.5, `zone_id` = 15, `object_name` = 'Venomsilk Spellblade' WHERE `item` = 9700513;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3713.33, `wy` = -2497.5, `zone_id` = 15, `object_name` = 'Singed Flintlock' WHERE `item` = 9700514;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2033.33, `wy` = -975.0, `zone_id` = 15, `object_name` = 'Woodcleaving Axe' WHERE `item` = 9700515;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3083.33, `wy` = -3075.0, `zone_id` = 15, `object_name` = 'Woodcleaving Axe' WHERE `item` = 9700516;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2173.81, `wy` = -3617.62, `zone_id` = 139, `object_name` = 'Argent Sentry Pauldrons' WHERE `item` = 9700517;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3412.04, `wy` = -3467.05, `zone_id` = 139, `object_name` = 'Assisting Hand' WHERE `item` = 9700518;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2044.75, `wy` = -3037.0, `zone_id` = 139, `object_name` = 'Blight Bomber' WHERE `item` = 9700519;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2328.69, `wy` = -3075.71, `zone_id` = 139, `object_name` = 'Bubbling Blood of Heroes' WHERE `item` = 9700520;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2879.78, `wy` = -2392.12, `zone_id` = 139, `object_name` = 'Severed Talon' WHERE `item` = 9700521;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3141.78, `wy` = -4694.88, `zone_id` = 139, `object_name` = 'Deadcapitator' WHERE `item` = 9700522;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2657.28, `wy` = -4577.98, `zone_id` = 139, `object_name` = 'Deathguard Vambraces' WHERE `item` = 9700523;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2992.33, `wy` = -2899.2, `zone_id` = 139, `object_name` = 'Deathwhisper Wand' WHERE `item` = 9700524;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1735.77, `wy` = -3641.24, `zone_id` = 139, `object_name` = 'Forbidden Fruit' WHERE `item` = 9700525;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2669.15, `wy` = -3581.63, `zone_id` = 139, `object_name` = 'Fungal Cleaver' WHERE `item` = 9700526;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1904.33, `wy` = -4379.79, `zone_id` = 139, `object_name` = 'Gravewood Belt' WHERE `item` = 9700527;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3325.57, `wy` = -3182.16, `zone_id` = 139, `object_name` = 'Eboncrypt Band' WHERE `item` = 9700528;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1738.36, `wy` = -5359.11, `zone_id` = 139, `object_name` = 'Malleus Haereticorum' WHERE `item` = 9700529;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2018.94, `wy` = -3540.21, `zone_id` = 139, `object_name` = 'Plague Fiend Chain' WHERE `item` = 9700530;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3447.66, `wy` = -4740.94, `zone_id` = 139, `object_name` = 'Plague Purger' WHERE `item` = 9700531;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2044.75, `wy` = -4585.33, `zone_id` = 139, `object_name` = 'Plaguebloom Spear' WHERE `item` = 9700532;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3047.82, `wy` = -2731.2, `zone_id` = 139, `object_name` = 'Plagued Pitchfork' WHERE `item` = 9700533;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3431.91, `wy` = -4048.45, `zone_id` = 139, `object_name` = 'Quel''thalas Commander Aegis' WHERE `item` = 9700534;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2277.06, `wy` = -5049.83, `zone_id` = 139, `object_name` = 'Ravenridge Shotgun' WHERE `item` = 9700535;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3032.85, `wy` = -2500.12, `zone_id` = 139, `object_name` = 'Cryptfiend Fang' WHERE `item` = 9700536;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2442.26, `wy` = -3951.29, `zone_id` = 139, `object_name` = 'Resilient Stompers' WHERE `item` = 9700537;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1778.62, `wy` = -3121.0, `zone_id` = 139, `object_name` = 'Revival Garments' WHERE `item` = 9700538;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1565.93, `wy` = -3542.14, `zone_id` = 139, `object_name` = 'Ring of Memorial' WHERE `item` = 9700539;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1842.64, `wy` = -4937.97, `zone_id` = 139, `object_name` = 'Scarlet Crossbow' WHERE `item` = 9700540;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1910.52, `wy` = -5189.96, `zone_id` = 139, `object_name` = 'Scarlet Doctrine' WHERE `item` = 9700541;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2685.67, `wy` = -5338.21, `zone_id` = 139, `object_name` = 'Scorched Runeblade' WHERE `item` = 9700542;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3028.46, `wy` = -3104.35, `zone_id` = 139, `object_name` = 'Scourge Cloak' WHERE `item` = 9700543;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2735.49, `wy` = -5129.19, `zone_id` = 139, `object_name` = 'Spiritwoven Vestments' WHERE `item` = 9700544;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2195.49, `wy` = -4050.77, `zone_id` = 139, `object_name` = 'Tainted Wasteblade' WHERE `item` = 9700545;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2655.99, `wy` = -3985.35, `zone_id` = 139, `object_name` = 'The Silver Blade' WHERE `item` = 9700546;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2354.5, `wy` = -2804.75, `zone_id` = 139, `object_name` = 'Wailing Spirit Amulet' WHERE `item` = 9700547;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1987.19, `wy` = -4982.48, `zone_id` = 139, `object_name` = 'Watchman Helm' WHERE `item` = 9700548;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9860.69, `wy` = 355.33, `zone_id` = 12, `object_name` = 'Boar Harvester' WHERE `item` = 9700549;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10115.29, `wy` = 667.71, `zone_id` = 12, `object_name` = 'Bones to Gnaw' WHERE `item` = 9700550;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8981.15, `wy` = -824.75, `zone_id` = 12, `object_name` = 'Bones to Munch' WHERE `item` = 9700551;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9328.33, `wy` = 181.79, `zone_id` = 12, `object_name` = 'Decayed Breeches' WHERE `item` = 9700552;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7939.58, `wy` = 1535.42, `zone_id` = 12, `object_name` = 'Defias Cowl' WHERE `item` = 9700553;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9305.19, `wy` = -304.12, `zone_id` = 12, `object_name` = 'Defias Cowl' WHERE `item` = 9700554;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9675.52, `wy` = -61.17, `zone_id` = 12, `object_name` = 'Defias Shanker' WHERE `item` = 9700555;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9675.52, `wy` = -61.17, `zone_id` = 12, `object_name` = 'Defias Shanker' WHERE `item` = 9700556;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9143.17, `wy` = -269.42, `zone_id` = 12, `object_name` = 'Defias Special Bucket' WHERE `item` = 9700557;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9559.79, `wy` = -1414.79, `zone_id` = 12, `object_name` = 'Eastvale Buckler' WHERE `item` = 9700558;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9235.75, `wy` = -720.62, `zone_id` = 12, `object_name` = 'Enchanted Kobold Lantern' WHERE `item` = 9700559;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9235.75, `wy` = -720.62, `zone_id` = 12, `object_name` = 'Enchanted Kobold Lantern' WHERE `item` = 9700560;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9768.1, `wy` = -859.46, `zone_id` = 12, `object_name` = 'Enchanted Straw Appendage' WHERE `item` = 9700561;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9420.92, `wy` = 320.62, `zone_id` = 12, `object_name` = 'Fisherman''s Jerkin' WHERE `item` = 9700562;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7939.58, `wy` = 1535.42, `zone_id` = 12, `object_name` = 'Heavy Iron Pan' WHERE `item` = 9700563;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9490.35, `wy` = -26.46, `zone_id` = 12, `object_name` = 'Heavy Iron Pan' WHERE `item` = 9700564;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9420.92, `wy` = -1310.67, `zone_id` = 12, `object_name` = 'Heavy Logsplitter' WHERE `item` = 9700565;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9791.25, `wy` = -1553.62, `zone_id` = 12, `object_name` = 'Jack''s Toothpicker' WHERE `item` = 9700566;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9559.79, `wy` = -720.62, `zone_id` = 12, `object_name` = 'Lexicon Ring' WHERE `item` = 9700567;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9768.1, `wy` = -1380.08, `zone_id` = 12, `object_name` = 'Lookout Scope' WHERE `item` = 9700568;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7939.58, `wy` = 1535.42, `zone_id` = 12, `object_name` = 'Loop of the Sly Rogue' WHERE `item` = 9700569;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9444.06, `wy` = 459.46, `zone_id` = 12, `object_name` = 'Loop of the Sly Rogue' WHERE `item` = 9700570;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9444.06, `wy` = -963.58, `zone_id` = 12, `object_name` = 'Mauled Armplates' WHERE `item` = 9700571;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7939.58, `wy` = 1535.42, `zone_id` = 12, `object_name` = 'Murder Machete' WHERE `item` = 9700572;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9397.77, `wy` = -130.58, `zone_id` = 12, `object_name` = 'Murder Machete' WHERE `item` = 9700573;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9490.35, `wy` = -373.54, `zone_id` = 12, `object_name` = 'Murloc Ritual Staff' WHERE `item` = 9700574;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9930.12, `wy` = -1171.83, `zone_id` = 12, `object_name` = 'Murloc Voodoo Doll' WHERE `item` = 9700575;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9629.23, `wy` = 702.42, `zone_id` = 12, `object_name` = 'Party Pants' WHERE `item` = 9700576;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9467.21, `wy` = 285.92, `zone_id` = 12, `object_name` = 'Plundered Goldshire Vanguard' WHERE `item` = 9700577;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9791.25, `wy` = 702.42, `zone_id` = 12, `object_name` = 'Poacher''s Crossbow' WHERE `item` = 9700578;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7939.58, `wy` = 1535.42, `zone_id` = 12, `object_name` = 'Riding Cloak' WHERE `item` = 9700579;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9490.35, `wy` = -1345.37, `zone_id` = 12, `object_name` = 'Riding Cloak' WHERE `item` = 9700580;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9768.1, `wy` = -442.96, `zone_id` = 12, `object_name` = 'Smuggled Stormwind Choker' WHERE `item` = 9700581;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9120.02, `wy` = -1067.71, `zone_id` = 12, `object_name` = 'Stormwind Memento' WHERE `item` = 9700582;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9606.08, `wy` = 667.71, `zone_id` = 12, `object_name` = 'The Vanishing Strap' WHERE `item` = 9700583;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9282.04, `wy` = 667.71, `zone_id` = 12, `object_name` = 'Thunder Falls Finest Gun Selection' WHERE `item` = 9700584;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9582.94, `wy` = -928.87, `zone_id` = 12, `object_name` = 'Traveler''s Forest Cloak' WHERE `item` = 9700585;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8749.69, `wy` = -165.29, `zone_id` = 12, `object_name` = 'Wax Stained Bag' WHERE `item` = 9700586;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8610.81, `wy` = -95.88, `zone_id` = 12, `object_name` = 'Worn Shovel' WHERE `item` = 9700587;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9559.79, `wy` = 528.87, `zone_id` = 12, `object_name` = 'Worn Shovel' WHERE `item` = 9700588;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3913.33, `wy` = -1118.33, `zone_id` = 361, `object_name` = 'Acid Bolter' WHERE `item` = 9700589;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4795.0, `wy` = -370.83, `zone_id` = 361, `object_name` = 'Bubbling Fel Mixture' WHERE `item` = 9700590;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4028.33, `wy` = -1290.83, `zone_id` = 361, `object_name` = 'Emerald Circle Charm' WHERE `item` = 9700591;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6290.0, `wy` = -600.83, `zone_id` = 361, `object_name` = 'Fallen Sentinel''s Leggings' WHERE `item` = 9700592;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4756.67, `wy` = -600.83, `zone_id` = 361, `object_name` = 'Felhound Tendril' WHERE `item` = 9700593;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6443.33, `wy` = -1693.33, `zone_id` = 361, `object_name` = 'Heart of the Warpwood' WHERE `item` = 9700594;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5561.67, `wy` = -715.83, `zone_id` = 361, `object_name` = 'Infernal Tender' WHERE `item` = 9700595;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4565.0, `wy` = -255.83, `zone_id` = 361, `object_name` = 'Jadefire Piercer' WHERE `item` = 9700596;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5063.33, `wy` = -485.83, `zone_id` = 361, `object_name` = 'Jaednar Spire' WHERE `item` = 9700597;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 4335.0, `wy` = -945.83, `zone_id` = 361, `object_name` = 'Lost Shipment Wristguards' WHERE `item` = 9700598;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3530.0, `wy` = -1118.33, `zone_id` = 361, `object_name` = 'Ror''s Wrecker' WHERE `item` = 9700599;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6213.33, `wy` = -1865.83, `zone_id` = 361, `object_name` = 'Talonbranch Sweeper' WHERE `item` = 9700600;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6826.67, `wy` = -2095.83, `zone_id` = 361, `object_name` = 'Timbermaw Defender' WHERE `item` = 9700601;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6980.0, `wy` = -2095.83, `zone_id` = 361, `object_name` = 'Timbermaw Girdle' WHERE `item` = 9700602;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 3836.67, `wy` = -1635.83, `zone_id` = 361, `object_name` = 'Timelost Vestments ' WHERE `item` = 9700603;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Accursed Yeti Horn' WHERE `item` = 9700604;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3942.0, `wy` = 1688.67, `zone_id` = 357, `object_name` = 'Accursed Yeti Horn' WHERE `item` = 9700605;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5285.67, `wy` = 20.67, `zone_id` = 357, `object_name` = 'Ambercoil Pendant' WHERE `item` = 9700606;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2830.0, `wy` = 2800.67, `zone_id` = 357, `object_name` = 'Ancient Elvish Bag' WHERE `item` = 9700607;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4729.67, `wy` = 3426.17, `zone_id` = 357, `object_name` = 'Band of Scales' WHERE `item` = 9700608;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4961.33, `wy` = 507.17, `zone_id` = 357, `object_name` = 'Bench Breaker' WHERE `item` = 9700609;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3849.33, `wy` = 1688.67, `zone_id` = 357, `object_name` = 'Bloodscorn Ritual Kris' WHERE `item` = 9700610;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4868.67, `wy` = 2036.17, `zone_id` = 357, `object_name` = 'Buccaneer''s Barrier' WHERE `item` = 9700611;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3432.33, `wy` = 2661.67, `zone_id` = 357, `object_name` = 'Crown of Stone' WHERE `item` = 9700612;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3432.33, `wy` = 2661.67, `zone_id` = 357, `object_name` = 'Crown of Stone' WHERE `item` = 9700613;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4776.0, `wy` = 854.67, `zone_id` = 357, `object_name` = 'Denrunner Tomahawk' WHERE `item` = 9700614;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Dormant Dreamscale' WHERE `item` = 9700615;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3293.33, `wy` = 1897.17, `zone_id` = 357, `object_name` = 'Dormant Dreamscale' WHERE `item` = 9700616;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2922.67, `wy` = 2592.17, `zone_id` = 357, `object_name` = 'Gilded Stone Bulwark' WHERE `item` = 9700617;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4915.0, `wy` = 298.67, `zone_id` = 357, `object_name` = 'Gnoll Stompers' WHERE `item` = 9700618;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Gnoll-Gnawed Bone Bat' WHERE `item` = 9700619;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4081.0, `wy` = 437.67, `zone_id` = 357, `object_name` = 'Gnoll-Gnawed Bone Bat' WHERE `item` = 9700620;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3571.33, `wy` = 229.17, `zone_id` = 357, `object_name` = 'Ogre Chest' WHERE `item` = 9700621;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3756.67, `wy` = 229.17, `zone_id` = 357, `object_name` = 'Ogre Cleaver' WHERE `item` = 9700622;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Grim Totem' WHERE `item` = 9700623;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4127.33, `wy` = 785.17, `zone_id` = 357, `object_name` = 'Grim Totem' WHERE `item` = 9700624;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4173.67, `wy` = 576.67, `zone_id` = 357, `object_name` = 'Grimtotem Outrider’s Vest' WHERE `item` = 9700625;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4173.67, `wy` = 576.67, `zone_id` = 357, `object_name` = 'Grimtotem Relic' WHERE `item` = 9700626;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Hatestrike' WHERE `item` = 9700627;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5656.33, `wy` = 3426.17, `zone_id` = 357, `object_name` = 'Hatestrike' WHERE `item` = 9700628;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4173.67, `wy` = -187.83, `zone_id` = 357, `object_name` = 'Heartwood Cleaver' WHERE `item` = 9700629;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5563.67, `wy` = 1480.17, `zone_id` = 357, `object_name` = 'Isildien Tender''s Wand' WHERE `item` = 9700630;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4590.67, `wy` = -48.83, `zone_id` = 357, `object_name` = 'Lakebottom Treads' WHERE `item` = 9700631;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4498.0, `wy` = 1271.67, `zone_id` = 357, `object_name` = 'Moon-Infused Breeches' WHERE `item` = 9700632;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4173.67, `wy` = -743.83, `zone_id` = 357, `object_name` = 'Moonlight Infused Band' WHERE `item` = 9700633;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5888.0, `wy` = 1758.17, `zone_id` = 357, `object_name` = 'Necklace of the Sunken Empire' WHERE `item` = 9700634;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3664.0, `wy` = 1827.67, `zone_id` = 357, `object_name` = 'Night Sentinel''s Aim' WHERE `item` = 9700635;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5193.0, `wy` = 715.67, `zone_id` = 357, `object_name` = 'Nightfallen Longbow' WHERE `item` = 9700636;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5193.0, `wy` = 715.67, `zone_id` = 357, `object_name` = 'Nightfallen Longbow' WHERE `item` = 9700637;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3710.33, `wy` = 229.17, `zone_id` = 357, `object_name` = 'Ogre Cleaver' WHERE `item` = 9700638;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5517.33, `wy` = 1341.17, `zone_id` = 357, `object_name` = 'Ogre Kneepad' WHERE `item` = 9700639;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4915.0, `wy` = 1202.17, `zone_id` = 357, `object_name` = 'Orb of Isildien Echoes' WHERE `item` = 9700640;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Ravenwind Codex' WHERE `item` = 9700641;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3108.0, `wy` = 2731.17, `zone_id` = 357, `object_name` = 'Ravenwind Codex' WHERE `item` = 9700642;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2830.0, `wy` = 2383.67, `zone_id` = 357, `object_name` = 'Ravenwind Fangblade' WHERE `item` = 9700643;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5656.33, `wy` = 1341.17, `zone_id` = 357, `object_name` = 'Runestone Figurine' WHERE `item` = 9700644;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4868.67, `wy` = 90.17, `zone_id` = 357, `object_name` = 'Savage Crossbow' WHERE `item` = 9700645;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4637.0, `wy` = -396.33, `zone_id` = 357, `object_name` = 'Seamstress Scissors' WHERE `item` = 9700646;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Secluded Soothsayer''s Pipes' WHERE `item` = 9700647;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5378.33, `wy` = 90.17, `zone_id` = 357, `object_name` = 'Secluded Soothsayer''s Pipes' WHERE `item` = 9700648;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Shattered Highborne Blade' WHERE `item` = 9700649;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5795.33, `wy` = 1202.17, `zone_id` = 357, `object_name` = 'Shattered Highborne Blade' WHERE `item` = 9700650;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4590.67, `wy` = 1619.17, `zone_id` = 357, `object_name` = 'Shen''dralar Slicer' WHERE `item` = 9700651;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4081.0, `wy` = 159.67, `zone_id` = 357, `object_name` = 'Shen''dralar Staff' WHERE `item` = 9700652;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4081.0, `wy` = 159.67, `zone_id` = 357, `object_name` = 'Shen''dralar Staff' WHERE `item` = 9700653;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5471.0, `wy` = 90.17, `zone_id` = 357, `object_name` = 'Shimmering Silithid Carapace' WHERE `item` = 9700654;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5285.67, `wy` = -48.83, `zone_id` = 357, `object_name` = 'Silithid Husk Shield' WHERE `item` = 9700655;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4776.0, `wy` = 3634.67, `zone_id` = 357, `object_name` = 'Solarsal Pendant' WHERE `item` = 9700656;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3525.0, `wy` = 2870.17, `zone_id` = 357, `object_name` = 'Staff of Twin Blossoms' WHERE `item` = 9700657;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3988.33, `wy` = 298.67, `zone_id` = 357, `object_name` = 'Stolen Highborne Spaulders' WHERE `item` = 9700658;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3942.0, `wy` = 2661.67, `zone_id` = 357, `object_name` = 'Strider Shot' WHERE `item` = 9700659;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3942.0, `wy` = 1897.17, `zone_id` = 357, `object_name` = 'Tanner Gloves' WHERE `item` = 9700660;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5424.67, `wy` = 3704.17, `zone_id` = 357, `object_name` = 'Tidebaron’s Sigil' WHERE `item` = 9700661;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3942.0, `wy` = -118.33, `zone_id` = 357, `object_name` = 'Tome of the Valiant' WHERE `item` = 9700662;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4868.67, `wy` = 924.17, `zone_id` = 357, `object_name` = 'Torn Hide Spaulders' WHERE `item` = 9700663;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4081.0, `wy` = -396.33, `zone_id` = 357, `object_name` = 'Wild Tracker Bindings' WHERE `item` = 9700664;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Woodpaw Greatblade' WHERE `item` = 9700665;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4961.33, `wy` = 646.17, `zone_id` = 357, `object_name` = 'Woodpaw Greatblade' WHERE `item` = 9700666;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4498.0, `wy` = 159.67, `zone_id` = 357, `object_name` = 'Worn Angler Cord' WHERE `item` = 9700667;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2366.67, `wy` = 5441.67, `zone_id` = 357, `object_name` = 'Yeti Napkin' WHERE `item` = 9700668;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5193.0, `wy` = 1827.67, `zone_id` = 357, `object_name` = 'Yeti Napkin' WHERE `item` = 9700669;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2505.67, `wy` = 2244.67, `zone_id` = 357, `object_name` = 'Zaetar''s Lost Heirloom' WHERE `item` = 9700670;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4359.0, `wy` = 2314.17, `zone_id` = 357, `object_name` = 'Zapping Rod' WHERE `item` = 9700671;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -304.0, `wy` = -885.33, `zone_id` = 267, `object_name` = 'Ancient Durnholde Girdle' WHERE `item` = 9700672;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -752.0, `wy` = -373.33, `zone_id` = 267, `object_name` = 'Bear Decapitator' WHERE `item` = 9700673;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 400.0, `wy` = 1066.67, `zone_id` = 267, `object_name` = 'Camouflaged Bow' WHERE `item` = 9700674;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -346.67, `wy` = -725.33, `zone_id` = 267, `object_name` = 'Camouflaged Bow' WHERE `item` = 9700675;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1029.33, `wy` = -757.33, `zone_id` = 267, `object_name` = 'Daggerspine Rod' WHERE `item` = 9700676;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -496.0, `wy` = 106.67, `zone_id` = 267, `object_name` = 'Darrow Silverband' WHERE `item` = 9700677;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 400.0, `wy` = 1066.67, `zone_id` = 267, `object_name` = 'Deadman''s Dagger' WHERE `item` = 9700678;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -602.67, `wy` = -1077.33, `zone_id` = 267, `object_name` = 'Deadman''s Dagger' WHERE `item` = 9700679;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -645.33, `wy` = 394.67, `zone_id` = 267, `object_name` = 'Deathstalker Cloak' WHERE `item` = 9700680;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1285.33, `wy` = -1237.33, `zone_id` = 267, `object_name` = 'Armor-Piercing Ammo Cache' WHERE `item` = 9700681;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -474.67, `wy` = -1557.33, `zone_id` = 267, `object_name` = 'Eroded Pit Fighter Knuckles' WHERE `item` = 9700682;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -730.67, `wy` = -1461.33, `zone_id` = 267, `object_name` = 'Eroded Pit Fighter Knuckles' WHERE `item` = 9700683;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -858.67, `wy` = 74.67, `zone_id` = 267, `object_name` = 'Mysterious Crystal' WHERE `item` = 9700684;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -176.0, `wy` = -341.33, `zone_id` = 267, `object_name` = 'Helcular''s Pendant' WHERE `item` = 9700685;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -389.33, `wy` = -53.33, `zone_id` = 267, `object_name` = 'Heavy Shovel' WHERE `item` = 9700686;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -816.0, `wy` = 170.67, `zone_id` = 267, `object_name` = 'Leftover Mining Trousers' WHERE `item` = 9700687;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -112.0, `wy` = -1141.33, `zone_id` = 267, `object_name` = 'Mismatched Shoulderpads' WHERE `item` = 9700688;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -197.33, `wy` = -885.33, `zone_id` = 267, `object_name` = 'Misplaced Pitchfork' WHERE `item` = 9700689;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -197.33, `wy` = -885.33, `zone_id` = 267, `object_name` = 'Misplaced Pitchfork' WHERE `item` = 9700690;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -901.33, `wy` = -853.33, `zone_id` = 267, `object_name` = 'Mudsnout Effigy' WHERE `item` = 9700691;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -560.0, `wy` = -853.33, `zone_id` = 267, `object_name` = 'Old Snapjaw Shell' WHERE `item` = 9700692;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1072.0, `wy` = -117.33, `zone_id` = 267, `object_name` = 'Oracle''s Fishy Staff' WHERE `item` = 9700693;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -346.67, `wy` = 10.67, `zone_id` = 267, `object_name` = 'Ray''s Farmhand' WHERE `item` = 9700694;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -602.67, `wy` = -1429.33, `zone_id` = 267, `object_name` = 'Syndicate Treads' WHERE `item` = 9700695;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -1008.0, `wy` = 42.67, `zone_id` = 267, `object_name` = 'Tarantula Hunter Rifle' WHERE `item` = 9700696;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -901.33, `wy` = -1493.33, `zone_id` = 267, `object_name` = 'Timelost Captain Shield' WHERE `item` = 9700697;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Abandoned Greatsword' WHERE `item` = 9700698;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5903.98, `wy` = -3731.5, `zone_id` = 38, `object_name` = 'Abandoned Greatsword' WHERE `item` = 9700699;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5756.81, `wy` = -3428.08, `zone_id` = 38, `object_name` = 'Brother''s Special Gift' WHERE `item` = 9700700;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Dark Iron Collar' WHERE `item` = 9700701;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4745.04, `wy` = -3621.17, `zone_id` = 38, `object_name` = 'Dark Iron Collar' WHERE `item` = 9700702;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5020.98, `wy` = -3593.58, `zone_id` = 38, `object_name` = 'Drowned Pendant' WHERE `item` = 9700703;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5536.06, `wy` = -2710.92, `zone_id` = 38, `object_name` = 'Dwarven Mail Gauntlets' WHERE `item` = 9700704;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6014.35, `wy` = -2490.25, `zone_id` = 38, `object_name` = 'Dwarven Sandals' WHERE `item` = 9700705;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4984.19, `wy` = -3510.83, `zone_id` = 38, `object_name` = 'Earthenwind Band' WHERE `item` = 9700706;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5296.92, `wy` = -2683.33, `zone_id` = 38, `object_name` = 'Frayed Backwrap' WHERE `item` = 9700707;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4837.02, `wy` = -3317.75, `zone_id` = 38, `object_name` = 'Frenzy Fin' WHERE `item` = 9700708;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Galgosh''s Other Bone' WHERE `item` = 9700709;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5720.02, `wy` = -3979.75, `zone_id` = 38, `object_name` = 'Galgosh''s Other Bone' WHERE `item` = 9700710;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4984.19, `wy` = -2931.58, `zone_id` = 38, `object_name` = 'Grizlak''s Candle' WHERE `item` = 9700711;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4984.19, `wy` = -2931.58, `zone_id` = 38, `object_name` = 'Grizlak''s Candle' WHERE `item` = 9700712;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4929.0, `wy` = -3897.0, `zone_id` = 38, `object_name` = 'Heavy Ogre Axe' WHERE `item` = 9700713;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4929.0, `wy` = -3897.0, `zone_id` = 38, `object_name` = 'Heavy Ogre Axe' WHERE `item` = 9700714;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Large Buzzard Talon' WHERE `item` = 9700715;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5867.19, `wy` = -4117.67, `zone_id` = 38, `object_name` = 'Large Buzzard Talon' WHERE `item` = 9700716;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5480.87, `wy` = -3483.25, `zone_id` = 38, `object_name` = 'Lost Traveler''s Ring' WHERE `item` = 9700717;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Miner''s League Vest' WHERE `item` = 9700718;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4984.19, `wy` = -2959.17, `zone_id` = 38, `object_name` = 'Miner''s League Vest' WHERE `item` = 9700719;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4818.62, `wy` = -2683.33, `zone_id` = 38, `object_name` = 'Mountaineer Hatchet' WHERE `item` = 9700720;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4763.44, `wy` = -4172.83, `zone_id` = 38, `object_name` = 'Chok''sul''s Basket' WHERE `item` = 9700721;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Ol'' Blunderbuss' WHERE `item` = 9700722;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4763.44, `wy` = -3317.75, `zone_id` = 38, `object_name` = 'Ol'' Blunderbuss' WHERE `item` = 9700723;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5204.94, `wy` = -3097.08, `zone_id` = 38, `object_name` = 'Old Stitched Bindings' WHERE `item` = 9700724;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5370.5, `wy` = -3731.5, `zone_id` = 38, `object_name` = 'Scrap Shield' WHERE `item` = 9700725;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Sinter Wive''s Rope' WHERE `item` = 9700726;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5204.94, `wy` = -3510.83, `zone_id` = 38, `object_name` = 'Sinter Wive''s Rope' WHERE `item` = 9700727;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5444.08, `wy` = -4200.42, `zone_id` = 38, `object_name` = 'Spider Silk Vestments' WHERE `item` = 9700728;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5903.98, `wy` = -2959.17, `zone_id` = 38, `object_name` = 'Stolen Mountaineer Chest' WHERE `item` = 9700729;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5278.52, `wy` = -4145.25, `zone_id` = 38, `object_name` = 'Stoneflow Handwraps' WHERE `item` = 9700730;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Sword of Stone' WHERE `item` = 9700731;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5609.65, `wy` = -3014.33, `zone_id` = 38, `object_name` = 'Sword of Stone' WHERE `item` = 9700732;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5683.23, `wy` = -3290.17, `zone_id` = 38, `object_name` = 'Tattered Shoulders' WHERE `item` = 9700733;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4487.5, `wy` = -1993.75, `zone_id` = 38, `object_name` = 'Tunnel Rat Pike' WHERE `item` = 9700734;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4781.83, `wy` = -2986.75, `zone_id` = 38, `object_name` = 'Tunnel Rat Pike' WHERE `item` = 9700735;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -5076.17, `wy` = -2710.92, `zone_id` = 38, `object_name` = 'Vermin Staff' WHERE `item` = 9700736;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3423.92, `wy` = -161.21, `zone_id` = 215, `object_name` = 'Aloof Tauren''s Herbs' WHERE `item` = 9700737;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3355.42, `wy` = -983.21, `zone_id` = 215, `object_name` = 'Ancestor''s Axe' WHERE `item` = 9700738;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2396.42, `wy` = 301.17, `zone_id` = 215, `object_name` = 'Bloodied Torn Bracers' WHERE `item` = 9700739;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -820.92, `wy` = -7.08, `zone_id` = 215, `object_name` = 'Bristleback Quill' WHERE `item` = 9700740;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -272.92, `wy` = 2047.92, `zone_id` = 215, `object_name` = 'Bristleback Staff' WHERE `item` = 9700741;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1505.92, `wy` = 352.54, `zone_id` = 215, `object_name` = 'Bristleback Staff' WHERE `item` = 9700742;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3047.17, `wy` = -1137.33, `zone_id` = 215, `object_name` = 'Cord of Reverence' WHERE `item` = 9700743;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2464.92, `wy` = -1137.33, `zone_id` = 215, `object_name` = 'Dakota Steppe Greaves' WHERE `item` = 9700744;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1677.17, `wy` = -1137.33, `zone_id` = 215, `object_name` = 'Discarded Wagon Wheel' WHERE `item` = 9700745;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1814.17, `wy` = -212.58, `zone_id` = 215, `object_name` = 'Pauldrons of Shadow' WHERE `item` = 9700746;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2122.42, `wy` = -1085.96, `zone_id` = 215, `object_name` = 'Galak Smasher' WHERE `item` = 9700747;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1060.67, `wy` = 558.04, `zone_id` = 215, `object_name` = 'Golden Plains Crossbow' WHERE `item` = 9700748;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1266.17, `wy` = -623.58, `zone_id` = 215, `object_name` = 'Hawkrunner Bracers' WHERE `item` = 9700749;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -272.92, `wy` = 2047.92, `zone_id` = 215, `object_name` = 'Interloper''s Loop' WHERE `item` = 9700750;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1026.42, `wy` = -1137.33, `zone_id` = 215, `object_name` = 'Interloper''s Loop' WHERE `item` = 9700751;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1608.67, `wy` = -572.21, `zone_id` = 215, `object_name` = 'Kodo Beast Idol' WHERE `item` = 9700752;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3012.92, `wy` = -161.21, `zone_id` = 215, `object_name` = 'Large Kodo Bone' WHERE `item` = 9700753;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2396.42, `wy` = -315.33, `zone_id` = 215, `object_name` = 'Long Fishing Spear' WHERE `item` = 9700754;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2396.42, `wy` = -315.33, `zone_id` = 215, `object_name` = 'Long Fishing Spear' WHERE `item` = 9700755;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1882.67, `wy` = 352.54, `zone_id` = 215, `object_name` = 'Pilfered Bloodhoof Bow' WHERE `item` = 9700756;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2190.92, `wy` = -109.83, `zone_id` = 215, `object_name` = 'Plainsblade' WHERE `item` = 9700757;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -272.92, `wy` = 2047.92, `zone_id` = 215, `object_name` = 'Snaggle''s Engage Whistle' WHERE `item` = 9700758;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2738.92, `wy` = -469.46, `zone_id` = 215, `object_name` = 'Snaggle''s Engage Whistle' WHERE `item` = 9700759;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -752.42, `wy` = -161.21, `zone_id` = 215, `object_name` = 'Steppereaver Hatchet' WHERE `item` = 9700760;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3184.17, `wy` = -1085.96, `zone_id` = 215, `object_name` = 'Stolen Tauren Cloak' WHERE `item` = 9700761;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1711.42, `wy` = 198.42, `zone_id` = 215, `object_name` = 'Sunchaser Blade' WHERE `item` = 9700762;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2910.17, `wy` = -1240.08, `zone_id` = 215, `object_name` = 'Thornmantle Quills' WHERE `item` = 9700763;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -992.17, `wy` = -572.21, `zone_id` = 215, `object_name` = 'Thunderwalk Breastplate' WHERE `item` = 9700764;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3047.17, `wy` = -520.83, `zone_id` = 215, `object_name` = 'Travel Sack' WHERE `item` = 9700765;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1848.42, `wy` = -1085.96, `zone_id` = 215, `object_name` = 'Venture Co. Ring' WHERE `item` = 9700766;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1916.92, `wy` = -674.96, `zone_id` = 215, `object_name` = 'Venture Co. Unique Concoction' WHERE `item` = 9700767;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2327.92, `wy` = -418.08, `zone_id` = 215, `object_name` = 'Venture Co. Unique Concoction' WHERE `item` = 9700768;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2636.17, `wy` = -1342.83, `zone_id` = 215, `object_name` = 'Windfury Harpy Claw' WHERE `item` = 9700769;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9096.25, `wy` = -2721.37, `zone_id` = 44, `object_name` = 'Adventurer''s Crossbow' WHERE `item` = 9700770;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9139.69, `wy` = -2677.96, `zone_id` = 44, `object_name` = 'Alther''s Chain Wrap' WHERE `item` = 9700771;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9385.83, `wy` = -2808.21, `zone_id` = 44, `object_name` = 'Aqualon''s Bolt' WHERE `item` = 9700772;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9820.21, `wy` = -3264.08, `zone_id` = 44, `object_name` = 'Blackrock Render' WHERE `item` = 9700773;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8676.35, `wy` = -2308.92, `zone_id` = 44, `object_name` = 'Blackrock Summoner''s Garb' WHERE `item` = 9700774;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9052.81, `wy` = -2612.83, `zone_id` = 44, `object_name` = 'Blackrock Waraxe' WHERE `item` = 9700775;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8777.71, `wy` = -1983.29, `zone_id` = 44, `object_name` = 'Dirtpaw Trousers' WHERE `item` = 9700776;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9096.25, `wy` = -2526.0, `zone_id` = 44, `object_name` = 'Dragon Matriarch Cloak' WHERE `item` = 9700777;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9313.44, `wy` = -2526.0, `zone_id` = 44, `object_name` = 'Everstill Claymore' WHERE `item` = 9700778;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9110.73, `wy` = -2395.75, `zone_id` = 44, `object_name` = 'Gnoll Cap' WHERE `item` = 9700779;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9487.19, `wy` = -1939.87, `zone_id` = 44, `object_name` = 'Gnoll Crafted Spaulder' WHERE `item` = 9700780;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9603.02, `wy` = -2504.29, `zone_id` = 44, `object_name` = 'Mongrel Blade' WHERE `item` = 9700781;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9458.23, `wy` = -3329.21, `zone_id` = 44, `object_name` = 'Mrrrllrl Stick' WHERE `item` = 9700782;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9631.98, `wy` = -3481.17, `zone_id` = 44, `object_name` = 'Old Redridge Buckler' WHERE `item` = 9700783;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9487.19, `wy` = -2265.5, `zone_id` = 44, `object_name` = 'Old War Tome' WHERE `item` = 9700784;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9675.42, `wy` = -1961.58, `zone_id` = 44, `object_name` = 'Red Mage Wand' WHERE `item` = 9700785;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9284.48, `wy` = -3329.21, `zone_id` = 44, `object_name` = 'Ring of the Lexicon' WHERE `item` = 9700786;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9371.35, `wy` = -2026.71, `zone_id` = 44, `object_name` = 'Rusty Redridge Rifle' WHERE `item` = 9700787;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9371.35, `wy` = -3090.42, `zone_id` = 44, `object_name` = 'Stonewatch Handwraps' WHERE `item` = 9700788;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8806.67, `wy` = -2178.67, `zone_id` = 44, `object_name` = 'Cultivated Blazethorn' WHERE `item` = 9700789;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9356.87, `wy` = -3047.0, `zone_id` = 44, `object_name` = 'Stonewatch Handwraps' WHERE `item` = 9700790;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.31, `wy` = -3068.71, `zone_id` = 44, `object_name` = 'Maddening Aura' WHERE `item` = 9700791;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9965.0, `wy` = -1983.29, `zone_id` = 44, `object_name` = 'Three Corner Cape' WHERE `item` = 9700792;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9617.5, `wy` = -3003.58, `zone_id` = 44, `object_name` = 'Three Corner Coil' WHERE `item` = 9700793;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9327.92, `wy` = -2829.92, `zone_id` = 44, `object_name` = 'Tidecaller''s Hammer' WHERE `item` = 9700794;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -8879.06, `wy` = -2178.67, `zone_id` = 44, `object_name` = 'Yowler''s Howl' WHERE `item` = 9700795;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6828.87, `wy` = -1349.29, `zone_id` = 51, `object_name` = 'Break-time Gloves' WHERE `item` = 9700796;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6754.5, `wy` = -1260.04, `zone_id` = 51, `object_name` = 'Burned Blade Shiv' WHERE `item` = 9700797;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6933.0, `wy` = -2018.67, `zone_id` = 51, `object_name` = 'Caravan Crossbow' WHERE `item` = 9700798;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6828.87, `wy` = -1237.73, `zone_id` = 51, `object_name` = 'Cogbolt''s Special' WHERE `item` = 9700799;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6873.5, `wy` = -1103.85, `zone_id` = 51, `object_name` = 'Contraband Magician Rod' WHERE `item` = 9700800;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6873.5, `wy` = -1282.35, `zone_id` = 51, `object_name` = 'Dark Iron Hood' WHERE `item` = 9700801;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7096.62, `wy` = -1460.85, `zone_id` = 51, `object_name` = 'Dark Iron Leatherpads' WHERE `item` = 9700802;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6561.12, `wy` = -1260.04, `zone_id` = 51, `object_name` = 'Dark Iron Legplates' WHERE `item` = 9700803;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6709.87, `wy` = -1148.48, `zone_id` = 51, `object_name` = 'Dark Iron Loop' WHERE `item` = 9700804;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6814.0, `wy` = -1550.1, `zone_id` = 51, `object_name` = 'Dark Iron Scorcher' WHERE `item` = 9700805;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7290.0, `wy` = -791.48, `zone_id` = 51, `object_name` = 'Dark Iron Slippers' WHERE `item` = 9700806;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6427.25, `wy` = -1237.73, `zone_id` = 51, `object_name` = 'Dark Iron Wristbands' WHERE `item` = 9700807;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6918.12, `wy` = -1416.23, `zone_id` = 51, `object_name` = 'Disciplinary Rifle' WHERE `item` = 9700808;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7007.37, `wy` = -1750.92, `zone_id` = 51, `object_name` = 'Dorius'' Shield' WHERE `item` = 9700809;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6665.25, `wy` = -1193.1, `zone_id` = 51, `object_name` = 'Elder Pipe' WHERE `item` = 9700810;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6680.12, `wy` = -903.04, `zone_id` = 51, `object_name` = 'Eye of Twilight' WHERE `item` = 9700811;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7052.0, `wy` = -947.67, `zone_id` = 51, `object_name` = 'Freedom Falchion' WHERE `item` = 9700812;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6769.37, `wy` = -1795.54, `zone_id` = 51, `object_name` = 'Glassweb Ward Shroud' WHERE `item` = 9700813;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6605.75, `wy` = -1862.48, `zone_id` = 51, `object_name` = 'Golem Chunk' WHERE `item` = 9700814;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6858.62, `wy` = -1036.92, `zone_id` = 51, `object_name` = 'Heavy War Golem Rune' WHERE `item` = 9700815;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6457.0, `wy` = -1416.23, `zone_id` = 51, `object_name` = 'Incendosaur Bone String' WHERE `item` = 9700816;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7304.87, `wy` = -1572.42, `zone_id` = 51, `object_name` = 'Magma Petting Mittens' WHERE `item` = 9700817;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6397.5, `wy` = -1393.92, `zone_id` = 51, `object_name` = 'Molten Fang Tooth' WHERE `item` = 9700818;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6635.5, `wy` = -1304.67, `zone_id` = 51, `object_name` = 'Overseer''s Mystic Wrench' WHERE `item` = 9700819;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7319.75, `wy` = -1103.85, `zone_id` = 51, `object_name` = 'Scorched Greatblade' WHERE `item` = 9700820;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6918.12, `wy` = -1170.79, `zone_id` = 51, `object_name` = 'Scorched Mail Tunic' WHERE `item` = 9700821;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7185.87, `wy` = -1193.1, `zone_id` = 51, `object_name` = 'Scorching Lodepebble' WHERE `item` = 9700822;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6546.25, `wy` = -1639.35, `zone_id` = 51, `object_name` = 'Shadowsilk Seared Cuirass' WHERE `item` = 9700823;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6680.12, `wy` = -1326.98, `zone_id` = 51, `object_name` = 'Sharp Chain Belt' WHERE `item` = 9700824;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6367.75, `wy` = -1907.1, `zone_id` = 51, `object_name` = 'Shoulderpads of Deep Thinking' WHERE `item` = 9700825;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6962.75, `wy` = -1237.73, `zone_id` = 51, `object_name` = 'Slave Band' WHERE `item` = 9700826;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -6903.25, `wy` = -1215.42, `zone_id` = 51, `object_name` = 'Slave Worker Pantaloons' WHERE `item` = 9700827;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -7200.75, `wy` = -1974.04, `zone_id` = 51, `object_name` = 'Stomped Diary' WHERE `item` = 9700828;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7259.17, `wy` = 343.0, `zone_id` = 1377, `object_name` = 'Ancient Sentinel Headdress' WHERE `item` = 9700829;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6422.92, `wy` = 1457.67, `zone_id` = 1377, `object_name` = 'Bracers of the Bound Storm' WHERE `item` = 9700830;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7282.4, `wy` = 1144.17, `zone_id` = 1377, `object_name` = 'Darnell''s Blade' WHERE `item` = 9700831;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7003.65, `wy` = 1144.17, `zone_id` = 1377, `object_name` = 'Geo Band' WHERE `item` = 9700832;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7212.71, `wy` = 900.33, `zone_id` = 1377, `object_name` = 'Idol of Shifting Sands' WHERE `item` = 9700833;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7073.33, `wy` = 621.67, `zone_id` = 1377, `object_name` = 'Lost Cenarion Bolter' WHERE `item` = 9700834;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6678.44, `wy` = 1562.17, `zone_id` = 1377, `object_name` = 'Purple Steppers' WHERE `item` = 9700835;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6957.19, `wy` = 134.0, `zone_id` = 1377, `object_name` = 'Sandstone Sniper' WHERE `item` = 9700836;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6469.38, `wy` = 1597.0, `zone_id` = 1377, `object_name` = 'Sandstorm Shaper' WHERE `item` = 9700837;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8072.19, `wy` = 1631.83, `zone_id` = 1377, `object_name` = 'Scarab Smasher' WHERE `item` = 9700838;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6748.13, `wy` = 830.67, `zone_id` = 1377, `object_name` = 'Standard Cenarion Spear' WHERE `item` = 9700839;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7863.13, `wy` = 1910.5, `zone_id` = 1377, `object_name` = 'Twilight''s Presence' WHERE `item` = 9700840;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6167.4, `wy` = 1771.17, `zone_id` = 1377, `object_name` = 'Wind Pendant' WHERE `item` = 9700841;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 938.67, `wy` = 594.0, `zone_id` = 130, `object_name` = 'Alchemy Research Notes' WHERE `item` = 9700842;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 630.67, `wy` = 384.0, `zone_id` = 130, `object_name` = 'Arcane Glinting Shard' WHERE `item` = 9700843;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 462.67, `wy` = 1896.0, `zone_id` = 130, `object_name` = 'Chain Belt of the Elements' WHERE `item` = 9700844;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1050.67, `wy` = 1602.0, `zone_id` = 130, `object_name` = 'Darkstrand Kilt' WHERE `item` = 9700845;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 490.67, `wy` = 930.0, `zone_id` = 130, `object_name` = 'Fenris Ring' WHERE `item` = 9700846;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1190.67, `wy` = 1056.0, `zone_id` = 130, `object_name` = 'Gilnean Bolter' WHERE `item` = 9700847;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 210.67, `wy` = 1602.0, `zone_id` = 130, `object_name` = 'Gilnean Lance' WHERE `item` = 9700848;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 854.67, `wy` = 1896.0, `zone_id` = 130, `object_name` = 'Gilnean Monocle' WHERE `item` = 9700849;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 994.67, `wy` = 678.0, `zone_id` = 130, `object_name` = 'Thule''s Curse Parchment' WHERE `item` = 9700850;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 406.67, `wy` = 1014.0, `zone_id` = 130, `object_name` = 'Grimson Cloak' WHERE `item` = 9700851;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1274.67, `wy` = 1266.0, `zone_id` = 130, `object_name` = 'Ivar''s Femur' WHERE `item` = 9700852;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 714.67, `wy` = 930.0, `zone_id` = 130, `object_name` = 'Lordamere Cuffs' WHERE `item` = 9700853;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1022.67, `wy` = 1560.0, `zone_id` = 130, `object_name` = 'Dirt Covered Gown' WHERE `item` = 9700854;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 966.67, `wy` = 1224.0, `zone_id` = 130, `object_name` = 'Old Valgan Slippers' WHERE `item` = 9700855;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1442.67, `wy` = 1938.0, `zone_id` = 130, `object_name` = 'Poison Unguent Extract' WHERE `item` = 9700856;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 154.67, `wy` = 1518.0, `zone_id` = 130, `object_name` = 'Ravenclaw Bone Necklace' WHERE `item` = 9700857;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1022.67, `wy` = 720.0, `zone_id` = 130, `object_name` = 'Ravenous Eye' WHERE `item` = 9700858;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 994.67, `wy` = 594.0, `zone_id` = 130, `object_name` = 'Rot Hide Harness' WHERE `item` = 9700859;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 770.67, `wy` = 678.0, `zone_id` = 130, `object_name` = 'Rot Hide Mantle' WHERE `item` = 9700860;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1302.67, `wy` = 1098.0, `zone_id` = 130, `object_name` = 'Sack of Pine Seeds' WHERE `item` = 9700861;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1246.67, `wy` = 1938.0, `zone_id` = 130, `object_name` = 'Small Claw of the Meat Wagon' WHERE `item` = 9700862;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 798.67, `wy` = 174.0, `zone_id` = 130, `object_name` = 'Stolen Rot Hide Circlet' WHERE `item` = 9700863;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 994.67, `wy` = 678.0, `zone_id` = 130, `object_name` = 'Thule''s Curse Parchment' WHERE `item` = 9700864;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1418.79, `wy` = 1243.67, `zone_id` = 406, `object_name` = 'Barrel Smasher' WHERE `item` = 9700865;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 669.85, `wy` = 1927.33, `zone_id` = 406, `object_name` = 'Bloodfury Feather Cloak' WHERE `item` = 9700866;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -144.21, `wy` = 169.33, `zone_id` = 406, `object_name` = 'Boulder Greaves' WHERE `item` = 9700867;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1614.17, `wy` = 169.33, `zone_id` = 406, `object_name` = 'Breastplate of the Current' WHERE `item` = 9700868;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 734.98, `wy` = 1439.0, `zone_id` = 406, `object_name` = 'Charred Spaulders' WHERE `item` = 9700869;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1386.23, `wy` = 1048.33, `zone_id` = 406, `object_name` = 'Cliffwalker Cuffs' WHERE `item` = 9700870;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Fire Strike' WHERE `item` = 9700871;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 572.17, `wy` = 706.5, `zone_id` = 406, `object_name` = 'Fire Strike' WHERE `item` = 9700872;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2623.6, `wy` = 1341.33, `zone_id` = 406, `object_name` = 'Flower of Tranquility' WHERE `item` = 9700873;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2623.6, `wy` = 1341.33, `zone_id` = 406, `object_name` = 'Flower of Tranquility' WHERE `item` = 9700874;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 18.6, `wy` = -416.67, `zone_id` = 406, `object_name` = 'Grim Sorcerer Totem' WHERE `item` = 9700875;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Grimtotem Striker' WHERE `item` = 9700876;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 116.29, `wy` = -856.17, `zone_id` = 406, `object_name` = 'Grimtotem Striker' WHERE `item` = 9700877;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 734.98, `wy` = 315.83, `zone_id` = 406, `object_name` = 'Huntress Threads' WHERE `item` = 9700878;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Resonite Band' WHERE `item` = 9700879;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -46.52, `wy` = 267.0, `zone_id` = 406, `object_name` = 'Resonite Band' WHERE `item` = 9700880;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1418.79, `wy` = 1292.5, `zone_id` = 406, `object_name` = 'Barrel Smasher' WHERE `item` = 9700881;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Staff of Talons' WHERE `item` = 9700882;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2493.35, `wy` = 1927.33, `zone_id` = 406, `object_name` = 'Staff of Talons' WHERE `item` = 9700883;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Talon Idol' WHERE `item` = 9700884;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1418.79, `wy` = -612.0, `zone_id` = 406, `object_name` = 'Talon Idol' WHERE `item` = 9700885;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Unclaimed Sack' WHERE `item` = 9700886;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2721.29, `wy` = 1487.83, `zone_id` = 406, `object_name` = 'Unclaimed Sack' WHERE `item` = 9700887;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1614.17, `wy` = 853.0, `zone_id` = 406, `object_name` = 'Vengeful Heart' WHERE `item` = 9700888;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1255.98, `wy` = -26.0, `zone_id` = 406, `object_name` = 'Venture Co. Logging Axe' WHERE `item` = 9700889;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Venture Co. Union Buster' WHERE `item` = 9700890;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1158.29, `wy` = 169.33, `zone_id` = 406, `object_name` = 'Venture Co. Union Buster' WHERE `item` = 9700891;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Wind Shearer' WHERE `item` = 9700892;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 865.23, `wy` = -319.0, `zone_id` = 406, `object_name` = 'Wind Shearer' WHERE `item` = 9700893;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 507.04, `wy` = 1780.83, `zone_id` = 406, `object_name` = 'Windsong Shortbow' WHERE `item` = 9700894;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -176.77, `wy` = -319.0, `zone_id` = 406, `object_name` = 'Woven Ceremonial Belt' WHERE `item` = 9700895;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1483.92, `wy` = 608.83, `zone_id` = 406, `object_name` = 'Wyvern Vest' WHERE `item` = 9700896;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 2916.67, `wy` = 3245.83, `zone_id` = 406, `object_name` = 'Ziz''s Alchemy Goggles' WHERE `item` = 9700897;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 865.23, `wy` = 364.67, `zone_id` = 406, `object_name` = 'Ziz''s Alchemy Goggles' WHERE `item` = 9700898;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13423.46, `wy` = 689.33, `zone_id` = 33, `object_name` = 'A Guide to a Succubus'' Darkest Secrets' WHERE `item` = 9700899;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12827.87, `wy` = 434.08, `zone_id` = 33, `object_name` = 'Ancient Sea-dweller Charm' WHERE `item` = 9700900;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11934.5, `wy` = -586.92, `zone_id` = 33, `object_name` = 'Axe Swingers' WHERE `item` = 9700901;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14529.54, `wy` = -12.6, `zone_id` = 33, `object_name` = 'Blackwater Booty Band' WHERE `item` = 9700902;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Bloodsail Decksweeper' WHERE `item` = 9700903;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14869.87, `wy` = 51.21, `zone_id` = 33, `object_name` = 'Bloodsail Decksweeper' WHERE `item` = 9700904;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13466.0, `wy` = 178.83, `zone_id` = 33, `object_name` = 'Bloodsail Longbow' WHERE `item` = 9700905;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11849.42, `wy` = 51.21, `zone_id` = 33, `object_name` = 'Bloodscalp Cord' WHERE `item` = 9700906;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11594.17, `wy` = 625.52, `zone_id` = 33, `object_name` = 'Bloodscalp Skullpiercer' WHERE `item` = 9700907;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Bloodscalper' WHERE `item` = 9700908;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11977.04, `wy` = 306.46, `zone_id` = 33, `object_name` = 'Bloodscalper' WHERE `item` = 9700909;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14146.67, `wy` = 497.9, `zone_id` = 33, `object_name` = 'Buccaneer Shiv' WHERE `item` = 9700910;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14954.96, `wy` = 242.65, `zone_id` = 33, `object_name` = 'Cannon Loaders' WHERE `item` = 9700911;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11977.04, `wy` = -459.29, `zone_id` = 33, `object_name` = 'Cogwheel Band' WHERE `item` = 9700912;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13253.29, `wy` = -331.67, `zone_id` = 33, `object_name` = 'Encased Amulet' WHERE `item` = 9700913;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Crystallized Shield' WHERE `item` = 9700914;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11849.42, `wy` = -905.98, `zone_id` = 33, `object_name` = 'Crystallized Shield' WHERE `item` = 9700915;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13380.92, `wy` = -395.48, `zone_id` = 33, `object_name` = 'Crystallized Wristguards' WHERE `item` = 9700916;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12232.29, `wy` = 816.96, `zone_id` = 33, `object_name` = 'Depleted Elemental Lodestone' WHERE `item` = 9700917;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Fallen Gladiator''s Shield' WHERE `item` = 9700918;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13253.29, `wy` = 306.46, `zone_id` = 33, `object_name` = 'Fallen Gladiator''s Shield' WHERE `item` = 9700919;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14614.62, `wy` = -204.04, `zone_id` = 33, `object_name` = 'Gorilla Pelt' WHERE `item` = 9700920;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12189.75, `wy` = 242.65, `zone_id` = 33, `object_name` = 'Grom''gol Hunting Rifle' WHERE `item` = 9700921;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11977.04, `wy` = -905.98, `zone_id` = 33, `object_name` = 'Gurubashi Trainee Hatchet' WHERE `item` = 9700922;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14699.71, `wy` = 497.9, `zone_id` = 33, `object_name` = 'Hull Breaker' WHERE `item` = 9700923;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14699.71, `wy` = 497.9, `zone_id` = 33, `object_name` = 'Hull Breaker' WHERE `item` = 9700924;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13678.71, `wy` = 370.27, `zone_id` = 33, `object_name` = 'Jose''s Best Slacks' WHERE `item` = 9700925;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13380.92, `wy` = -12.6, `zone_id` = 33, `object_name` = 'Jubuwal Witchdoctor Amulet' WHERE `item` = 9700926;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11551.62, `wy` = -586.92, `zone_id` = 33, `object_name` = 'Jungle Medicine Compendium' WHERE `item` = 9700927;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11764.33, `wy` = -140.23, `zone_id` = 33, `object_name` = 'Jungle Defender' WHERE `item` = 9700928;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11764.33, `wy` = -140.23, `zone_id` = 33, `object_name` = 'Jungle Defender' WHERE `item` = 9700929;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11551.62, `wy` = -586.92, `zone_id` = 33, `object_name` = 'Jungle Medicine Compendium' WHERE `item` = 9700930;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12742.79, `wy` = 178.83, `zone_id` = 33, `object_name` = 'Jungle Stalker Pauldrons' WHERE `item` = 9700931;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12742.79, `wy` = 178.83, `zone_id` = 33, `object_name` = 'Jungle Stalker Pauldrons' WHERE `item` = 9700932;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14912.42, `wy` = 370.27, `zone_id` = 33, `object_name` = 'Keelhaul''s Saber' WHERE `item` = 9700933;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Kurzen Eviscerator' WHERE `item` = 9700934;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11338.92, `wy` = -969.79, `zone_id` = 33, `object_name` = 'Kurzen Eviscerator' WHERE `item` = 9700935;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11636.71, `wy` = -714.54, `zone_id` = 33, `object_name` = 'Kurzen Madness Blade' WHERE `item` = 9700936;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12445.0, `wy` = -459.29, `zone_id` = 33, `object_name` = 'Lazy Hat' WHERE `item` = 9700937;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13678.71, `wy` = 625.52, `zone_id` = 33, `object_name` = 'Mangled Wraps' WHERE `item` = 9700938;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13083.12, `wy` = -586.92, `zone_id` = 33, `object_name` = 'Martyr Cross Book' WHERE `item` = 9700939;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12359.92, `wy` = -1161.23, `zone_id` = 33, `object_name` = 'Mind''s Eye Fragment' WHERE `item` = 9700940;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14231.75, `wy` = 689.33, `zone_id` = 33, `object_name` = 'Mok''rash''s Circlet' WHERE `item` = 9700941;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12487.54, `wy` = -140.23, `zone_id` = 33, `object_name` = 'Mosh''Ogg Stave' WHERE `item` = 9700942;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12317.37, `wy` = -905.98, `zone_id` = 33, `object_name` = 'Mosh''Ogg Totem' WHERE `item` = 9700943;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12700.25, `wy` = -459.29, `zone_id` = 33, `object_name` = 'Mystic Druid Idol' WHERE `item` = 9700944;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13933.96, `wy` = 434.08, `zone_id` = 33, `object_name` = 'Naga Throwing Trident' WHERE `item` = 9700945;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12359.92, `wy` = -714.54, `zone_id` = 33, `object_name` = 'Nature''s Defiance' WHERE `item` = 9700946;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11594.17, `wy` = -12.6, `zone_id` = 33, `object_name` = 'Nesingwary Tracking Boots' WHERE `item` = 9700947;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11806.87, `wy` = 434.08, `zone_id` = 33, `object_name` = 'Panther Shredders' WHERE `item` = 9700948;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13678.71, `wy` = -267.85, `zone_id` = 33, `object_name` = 'Pilfered Plate Pants' WHERE `item` = 9700949;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13806.33, `wy` = -12.6, `zone_id` = 33, `object_name` = 'Premium Banana' WHERE `item` = 9700950;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13083.12, `wy` = 370.27, `zone_id` = 33, `object_name` = 'Pristine Tethis Feather' WHERE `item` = 9700951;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11891.96, `wy` = 178.83, `zone_id` = 33, `object_name` = 'Ravaged Shoulderpads' WHERE `item` = 9700952;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11338.92, `wy` = -267.85, `zone_id` = 33, `object_name` = 'Rebel Runners' WHERE `item` = 9700953;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11551.62, `wy` = -204.04, `zone_id` = 33, `object_name` = 'Riverheart Crest' WHERE `item` = 9700954;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11551.62, `wy` = -204.04, `zone_id` = 33, `object_name` = 'Riverheart Crest' WHERE `item` = 9700955;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14827.33, `wy` = 561.71, `zone_id` = 33, `object_name` = 'Sea Cleaver' WHERE `item` = 9700956;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13253.29, `wy` = 753.15, `zone_id` = 33, `object_name` = 'Sharpened Raptor Tooth' WHERE `item` = 9700957;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Shiv of Warm Greetings' WHERE `item` = 9700958;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11509.08, `wy` = -714.54, `zone_id` = 33, `object_name` = 'Shiv of Warm Greetings' WHERE `item` = 9700959;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Skullsplitter Crossbow' WHERE `item` = 9700960;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12870.42, `wy` = -842.17, `zone_id` = 33, `object_name` = 'Skullsplitter Crossbow' WHERE `item` = 9700961;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11721.79, `wy` = 242.65, `zone_id` = 33, `object_name` = 'Sky Shot Cloak' WHERE `item` = 9700962;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14784.79, `wy` = -459.29, `zone_id` = 33, `object_name` = 'South Sea Dress' WHERE `item` = 9700963;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -14657.17, `wy` = 178.83, `zone_id` = 33, `object_name` = 'Special Seashell' WHERE `item` = 9700964;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11977.04, `wy` = -523.1, `zone_id` = 33, `object_name` = 'Splinter Guard' WHERE `item` = 9700965;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11977.04, `wy` = -523.1, `zone_id` = 33, `object_name` = 'Splinter Guard' WHERE `item` = 9700966;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13210.75, `wy` = -459.29, `zone_id` = 33, `object_name` = 'Stonesplitter' WHERE `item` = 9700967;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13210.75, `wy` = -459.29, `zone_id` = 33, `object_name` = 'Stonesplitter' WHERE `item` = 9700968;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11891.96, `wy` = -331.67, `zone_id` = 33, `object_name` = 'The Compliance Crusher' WHERE `item` = 9700969;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'The Ironjaw' WHERE `item` = 9700970;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13210.75, `wy` = -586.92, `zone_id` = 33, `object_name` = 'The Ironjaw' WHERE `item` = 9700971;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'The Wrangler' WHERE `item` = 9700972;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11594.17, `wy` = -714.54, `zone_id` = 33, `object_name` = 'The Wrangler' WHERE `item` = 9700973;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -13083.12, `wy` = -459.29, `zone_id` = 33, `object_name` = 'Tinkering Belt' WHERE `item` = 9700974;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12785.33, `wy` = -267.85, `zone_id` = 33, `object_name` = 'Traveler''s Lost Bag' WHERE `item` = 9700975;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12615.17, `wy` = -140.23, `zone_id` = 33, `object_name` = 'Tribal Pads' WHERE `item` = 9700976;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11168.75, `wy` = 2220.83, `zone_id` = 33, `object_name` = 'Voodoo Bonemaker' WHERE `item` = 9700977;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -12998.04, `wy` = 178.83, `zone_id` = 33, `object_name` = 'Voodoo Bonemaker' WHERE `item` = 9700978;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11381.46, `wy` = -778.35, `zone_id` = 33, `object_name` = 'Witchdoctor Mixing Gloves' WHERE `item` = 9700979;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11679.25, `wy` = 944.58, `zone_id` = 33, `object_name` = 'Wizard Cuffs' WHERE `item` = 9700980;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11806.87, `wy` = 1391.27, `zone_id` = 33, `object_name` = 'Yojamba Hex Skull' WHERE `item` = 9700981;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11509.08, `wy` = 753.15, `zone_id` = 33, `object_name` = 'Zul''Kunda Blood Ring' WHERE `item` = 9700982;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11509.08, `wy` = 753.15, `zone_id` = 33, `object_name` = 'Zul''Kunda Blood Ring' WHERE `item` = 9700983;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11721.79, `wy` = 689.33, `zone_id` = 33, `object_name` = 'Zul''Kunda Scout Vest' WHERE `item` = 9700984;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11679.25, `wy` = 561.71, `zone_id` = 33, `object_name` = 'Zul''Kunda Tribe Trophy' WHERE `item` = 9700985;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8083.0, `wy` = -4565.75, `zone_id` = 440, `object_name` = 'Ancestral Warblade' WHERE `item` = 9700986;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8727.0, `wy` = -4289.75, `zone_id` = 440, `object_name` = 'Ancient Wagon Wheel' WHERE `item` = 9700987;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8727.0, `wy` = -4289.75, `zone_id` = 440, `object_name` = 'Ancient Wagon Wheel' WHERE `item` = 9700988;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7439.0, `wy` = -4082.75, `zone_id` = 440, `object_name` = 'Betrayer''s Blade' WHERE `item` = 9700989;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7439.0, `wy` = -4082.75, `zone_id` = 440, `object_name` = 'Betrayer''s Blade' WHERE `item` = 9700990;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'Captain''s Compass' WHERE `item` = 9700991;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8037.0, `wy` = -5186.75, `zone_id` = 440, `object_name` = 'Captain''s Compass' WHERE `item` = 9700992;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9049.0, `wy` = -3668.75, `zone_id` = 440, `object_name` = 'Carapace Carver' WHERE `item` = 9700993;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8359.0, `wy` = -3047.75, `zone_id` = 440, `object_name` = 'Cyclok''s Sanity' WHERE `item` = 9700994;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7531.0, `wy` = -3599.75, `zone_id` = 440, `object_name` = 'Deadman Gauntlets' WHERE `item` = 9700995;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7531.0, `wy` = -3599.75, `zone_id` = 440, `object_name` = 'Deadman Gauntlets' WHERE `item` = 9700996;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7393.0, `wy` = -3875.75, `zone_id` = 440, `object_name` = 'Desert Gambeson' WHERE `item` = 9700997;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'Dunecaller''s Spire' WHERE `item` = 9700998;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9463.0, `wy` = -2357.75, `zone_id` = 440, `object_name` = 'Dunecaller''s Spire' WHERE `item` = 9700999;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8543.0, `wy` = -3047.75, `zone_id` = 440, `object_name` = 'Dunemaul Crusher' WHERE `item` = 9701000;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8267.0, `wy` = -2909.75, `zone_id` = 440, `object_name` = 'Dunemaul Warbelt' WHERE `item` = 9701001;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7715.0, `wy` = -4634.75, `zone_id` = 440, `object_name` = 'Duneshot Armguards' WHERE `item` = 9701002;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8635.0, `wy` = -2564.75, `zone_id` = 440, `object_name` = 'Dustwhisper Legguards' WHERE `item` = 9701003;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7163.0, `wy` = -3944.75, `zone_id` = 440, `object_name` = 'Executioner''s Axe' WHERE `item` = 9701004;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7163.0, `wy` = -3944.75, `zone_id` = 440, `object_name` = 'Executioner''s Axe' WHERE `item` = 9701005;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9693.0, `wy` = -1943.75, `zone_id` = 440, `object_name` = 'Explorer''s Last Wish' WHERE `item` = 9701006;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6933.0, `wy` = -4910.75, `zone_id` = 440, `object_name` = 'Fisher''s Misfortune' WHERE `item` = 9701007;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6933.0, `wy` = -4910.75, `zone_id` = 440, `object_name` = 'Fisher''s Misfortune' WHERE `item` = 9701008;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'High Seas Axe' WHERE `item` = 9701009;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7025.0, `wy` = -4772.75, `zone_id` = 440, `object_name` = 'High Seas Axe' WHERE `item` = 9701010;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8589.0, `wy` = -2219.75, `zone_id` = 440, `object_name` = 'Hivebreakers’ Ward' WHERE `item` = 9701011;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8083.0, `wy` = -5324.75, `zone_id` = 440, `object_name` = 'Wooden Plank' WHERE `item` = 9701012;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8267.0, `wy` = -5048.75, `zone_id` = 440, `object_name` = 'Inventor''s Sand Band' WHERE `item` = 9701013;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9187.0, `wy` = -3944.75, `zone_id` = 440, `object_name` = 'Last Stand' WHERE `item` = 9701014;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6749.0, `wy` = -4703.75, `zone_id` = 440, `object_name` = 'Lens of Questionable Visions' WHERE `item` = 9701015;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7761.0, `wy` = -3047.75, `zone_id` = 440, `object_name` = 'Lid of the Dead' WHERE `item` = 9701016;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6933.0, `wy` = -4358.75, `zone_id` = 440, `object_name` = 'Noon''s Shade Relic' WHERE `item` = 9701017;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6933.0, `wy` = -4358.75, `zone_id` = 440, `object_name` = 'Noon''s Shade Relic' WHERE `item` = 9701018;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'Sand Cover' WHERE `item` = 9701019;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9003.0, `wy` = -2840.75, `zone_id` = 440, `object_name` = 'Sand Cover' WHERE `item` = 9701020;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8129.0, `wy` = -3185.75, `zone_id` = 440, `object_name` = 'Sand Polished Pauldrons' WHERE `item` = 9701021;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7853.0, `wy` = -3599.75, `zone_id` = 440, `object_name` = 'Sand Stompers' WHERE `item` = 9701022;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'Sandfury Boomerang' WHERE `item` = 9701023;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7025.0, `wy` = -2771.75, `zone_id` = 440, `object_name` = 'Sandfury Boomerang' WHERE `item` = 9701024;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7209.0, `wy` = -2978.75, `zone_id` = 440, `object_name` = 'Sandfury Ritual Mace' WHERE `item` = 9701025;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7209.0, `wy` = -2978.75, `zone_id` = 440, `object_name` = 'Sandfury Ritual Mace' WHERE `item` = 9701026;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7715.0, `wy` = -3254.75, `zone_id` = 440, `object_name` = 'Sandswept Binding' WHERE `item` = 9701027;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9785.0, `wy` = -3668.75, `zone_id` = 440, `object_name` = 'Shellsplitter Girdle' WHERE `item` = 9701028;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9279.0, `wy` = -2288.75, `zone_id` = 440, `object_name` = 'Sky Guard''s Cuirass' WHERE `item` = 9701029;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6933.0, `wy` = -3116.75, `zone_id` = 440, `object_name` = 'Sorrow Bolter' WHERE `item` = 9701030;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'Southmoon Amulet' WHERE `item` = 9701031;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9279.0, `wy` = -3047.75, `zone_id` = 440, `object_name` = 'Southmoon Amulet' WHERE `item` = 9701032;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7899.0, `wy` = -5186.75, `zone_id` = 440, `object_name` = 'Southsea Raider Gloves' WHERE `item` = 9701033;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7025.0, `wy` = -3530.75, `zone_id` = 440, `object_name` = 'Stylish Racing Hat' WHERE `item` = 9701034;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8865.0, `wy` = -2219.75, `zone_id` = 440, `object_name` = 'Tender''s Hat' WHERE `item` = 9701035;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9923.0, `wy` = -3806.75, `zone_id` = 440, `object_name` = 'Umbral Tear' WHERE `item` = 9701036;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -10061.0, `wy` = -4151.75, `zone_id` = 440, `object_name` = 'The Wingman' WHERE `item` = 9701037;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -10061.0, `wy` = -4151.75, `zone_id` = 440, `object_name` = 'The Wingman' WHERE `item` = 9701038;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'Time Stream Slasher' WHERE `item` = 9701039;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8267.0, `wy` = -4634.75, `zone_id` = 440, `object_name` = 'Time Stream Slasher' WHERE `item` = 9701040;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8865.0, `wy` = -3461.75, `zone_id` = 440, `object_name` = 'Treasure Seeker''s Gloves' WHERE `item` = 9701041;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -10061.0, `wy` = -4013.75, `zone_id` = 440, `object_name` = 'Treasure Seeking Lodestone' WHERE `item` = 9701042;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6427.0, `wy` = -4082.75, `zone_id` = 440, `object_name` = 'Venom-Infused Screwdriver' WHERE `item` = 9701043;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7669.0, `wy` = -4289.75, `zone_id` = 440, `object_name` = 'Wastewander Alchemist’s Robe' WHERE `item` = 9701044;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5875.0, `wy` = -218.75, `zone_id` = 440, `object_name` = 'Watcher''s Mantle' WHERE `item` = 9701045;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -9647.0, `wy` = -2840.75, `zone_id` = 440, `object_name` = 'Watcher''s Mantle' WHERE `item` = 9701046;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8175.0, `wy` = -5048.75, `zone_id` = 440, `object_name` = 'Water Binder' WHERE `item` = 9701047;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8175.0, `wy` = -5048.75, `zone_id` = 440, `object_name` = 'Water Binder' WHERE `item` = 9701048;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -7853.0, `wy` = -4910.75, `zone_id` = 440, `object_name` = 'Wave Wraps' WHERE `item` = 9701049;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -8819.0, `wy` = -4772.75, `zone_id` = 440, `object_name` = 'Winkey''s Misplaced Wrench' WHERE `item` = 9701050;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 11831.25, `wy` = 3814.58, `zone_id` = 141, `object_name` = 'Arlithrien Moon Orb' WHERE `item` = 9701051;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9557.44, `wy` = 1625.17, `zone_id` = 141, `object_name` = 'Arlithrien Moon Orb' WHERE `item` = 9701052;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9930.75, `wy` = 912.33, `zone_id` = 141, `object_name` = 'Blade of the Submerged Moon' WHERE `item` = 9701053;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10643.44, `wy` = 2083.42, `zone_id` = 141, `object_name` = 'Bloodfeather Wand' WHERE `item` = 9701054;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10100.44, `wy` = 1472.42, `zone_id` = 141, `object_name` = 'Chipped Sentinel Blade' WHERE `item` = 9701055;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10405.88, `wy` = 1625.17, `zone_id` = 141, `object_name` = 'Dewleaf Piercer' WHERE `item` = 9701056;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9659.25, `wy` = 454.08, `zone_id` = 141, `object_name` = 'Furbolg War Drum' WHERE `item` = 9701057;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9557.44, `wy` = 1879.75, `zone_id` = 141, `object_name` = 'Gnarlpine Jerkin' WHERE `item` = 9701058;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10270.12, `wy` = 1217.83, `zone_id` = 141, `object_name` = 'Groveprowler Gloves' WHERE `item` = 9701059;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10371.94, `wy` = 1930.67, `zone_id` = 141, `object_name` = 'Harpy Feather Drape' WHERE `item` = 9701060;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10948.88, `wy` = 963.25, `zone_id` = 141, `object_name` = 'Jar of Spiders' WHERE `item` = 9701061;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10881.0, `wy` = 2083.42, `zone_id` = 141, `object_name` = 'Lifesap Blade' WHERE `item` = 9701062;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9828.94, `wy` = 454.08, `zone_id` = 141, `object_name` = 'Lunar Tome' WHERE `item` = 9701063;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9828.94, `wy` = 454.08, `zone_id` = 141, `object_name` = 'Lunar Tome' WHERE `item` = 9701064;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10711.31, `wy` = 810.5, `zone_id` = 141, `object_name` = 'Moonbathed Necklace' WHERE `item` = 9701065;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9862.88, `wy` = 606.83, `zone_id` = 141, `object_name` = 'Moonwell Cane' WHERE `item` = 9701066;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10032.56, `wy` = 301.33, `zone_id` = 141, `object_name` = 'Patched Verdant Cloak' WHERE `item` = 9701067;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9896.81, `wy` = 403.17, `zone_id` = 141, `object_name` = 'Rootbark Girdle' WHERE `item` = 9701068;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10643.44, `wy` = 1625.17, `zone_id` = 141, `object_name` = 'Saplingweave Handwraps' WHERE `item` = 9701069;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9964.69, `wy` = 1981.58, `zone_id` = 141, `object_name` = 'Starfall Edge' WHERE `item` = 9701070;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9761.06, `wy` = 97.67, `zone_id` = 141, `object_name` = 'Teldrassil Begonias' WHERE `item` = 9701071;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9116.25, `wy` = 1828.83, `zone_id` = 141, `object_name` = 'Thornpaw Trousers' WHERE `item` = 9701072;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9455.62, `wy` = 1065.08, `zone_id` = 141, `object_name` = 'Timber Maul' WHERE `item` = 9701073;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 10914.94, `wy` = 1421.5, `zone_id` = 141, `object_name` = 'Timberbane Axe' WHERE `item` = 9701074;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9285.94, `wy` = 1065.08, `zone_id` = 141, `object_name` = 'Timberling Dagger' WHERE `item` = 9701075;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 11831.25, `wy` = 3814.58, `zone_id` = 141, `object_name` = 'Torn Spellbook Page' WHERE `item` = 9701076;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9421.69, `wy` = 1217.83, `zone_id` = 141, `object_name` = 'Torn Spellbook Page' WHERE `item` = 9701077;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9795.0, `wy` = 2999.92, `zone_id` = 141, `object_name` = 'Trickster''s Signet' WHERE `item` = 9701078;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 9523.5, `wy` = 759.58, `zone_id` = 141, `object_name` = 'Whisperwind Boots' WHERE `item` = 9701079;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 11254.31, `wy` = 1574.25, `zone_id` = 141, `object_name` = 'Whisperwind Heirloom' WHERE `item` = 9701080;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1630.5, `wy` = -4369.08, `zone_id` = 17, `object_name` = 'Affray Cuirras' WHERE `item` = 9701081;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3995.19, `wy` = -2038.42, `zone_id` = 17, `object_name` = 'Blackthorn Splitter' WHERE `item` = 9701082;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1765.63, `wy` = -2342.42, `zone_id` = 17, `object_name` = 'Bloody Wedding Ring' WHERE `item` = 9701083;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 58.56, `wy` = -2646.42, `zone_id` = 17, `object_name` = 'Bramblestaff' WHERE `item` = 9701084;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2035.88, `wy` = -2747.75, `zone_id` = 17, `object_name` = 'Bristleback Thorn' WHERE `item` = 9701085;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1427.81, `wy` = -3963.75, `zone_id` = 17, `object_name` = 'Captain''s Spyglass' WHERE `item` = 9701086;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 193.69, `wy` = -3558.42, `zone_id` = 17, `object_name` = 'Conscript''s Wraps' WHERE `item` = 9701087;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1004.44, `wy` = -3051.75, `zone_id` = 17, `object_name` = 'Drudger Smash' WHERE `item` = 9701088;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 126.12, `wy` = -1937.08, `zone_id` = 17, `object_name` = 'Forgotten Trunks' WHERE `item` = 9701089;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3319.56, `wy` = -1835.75, `zone_id` = 17, `object_name` = 'Giant Qiraji Scale' WHERE `item` = 9701090;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 869.31, `wy` = -1329.08, `zone_id` = 17, `object_name` = 'Grunt''s Chain Leggings' WHERE `item` = 9701091;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -76.56, `wy` = -1430.42, `zone_id` = 17, `object_name` = 'Honor Blade' WHERE `item` = 9701092;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2914.19, `wy` = -2139.75, `zone_id` = 17, `object_name` = 'Kodo Stompers' WHERE `item` = 9701093;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1409.81, `wy` = -3457.08, `zone_id` = 17, `object_name` = 'Loded Ring' WHERE `item` = 9701094;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4062.75, `wy` = -2443.75, `zone_id` = 17, `object_name` = 'Malgin''s Barback' WHERE `item` = 9701095;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2373.69, `wy` = -3761.08, `zone_id` = 17, `object_name` = 'Muck Trudgers' WHERE `item` = 9701096;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1968.31, `wy` = -3659.75, `zone_id` = 17, `object_name` = 'Northwatch Hand Cannon' WHERE `item` = 9701097;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3657.38, `wy` = -1734.42, `zone_id` = 17, `object_name` = 'Overwatch Bow' WHERE `item` = 9701098;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -549.5, `wy` = -3153.08, `zone_id` = 17, `object_name` = 'Peon Motivator' WHERE `item` = 9701099;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -414.38, `wy` = -1835.75, `zone_id` = 17, `object_name` = 'Plainstalker Vest' WHERE `item` = 9701100;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4468.13, `wy` = -1734.42, `zone_id` = 17, `object_name` = 'Razorthorn Claymore' WHERE `item` = 9701101;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -617.06, `wy` = -2241.08, `zone_id` = 17, `object_name` = 'Savannah Cowl' WHERE `item` = 9701102;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1207.12, `wy` = -2241.08, `zone_id` = 17, `object_name` = 'Sharpened Pike' WHERE `item` = 9701103;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4197.88, `wy` = -2342.42, `zone_id` = 17, `object_name` = 'Special Excavation Lantern' WHERE `item` = 9701104;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 261.25, `wy` = -3051.75, `zone_id` = 17, `object_name` = 'Steelrider Girdle' WHERE `item` = 9701105;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2306.13, `wy` = -2241.08, `zone_id` = 17, `object_name` = 'Stormcall Totem' WHERE `item` = 9701106;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3589.81, `wy` = -2342.42, `zone_id` = 17, `object_name` = 'Stump Biter' WHERE `item` = 9701107;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1022.44, `wy` = -1633.08, `zone_id` = 17, `object_name` = 'Stylish Cloak' WHERE `item` = 9701108;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1427.81, `wy` = -3659.75, `zone_id` = 17, `object_name` = 'Swashbuckler''s Chain' WHERE `item` = 9701109;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -2238.56, `wy` = -2443.75, `zone_id` = 17, `object_name` = 'Takar''s Old Wand' WHERE `item` = 9701110;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1833.19, `wy` = -1937.08, `zone_id` = 17, `object_name` = 'Thornweaver Mace' WHERE `item` = 9701111;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1274.69, `wy` = -3558.42, `zone_id` = 17, `object_name` = 'Venture Co. Boots' WHERE `item` = 9701112;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1207.12, `wy` = -2950.42, `zone_id` = 17, `object_name` = 'Venture Co. Dirk' WHERE `item` = 9701113;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 58.56, `wy` = -1734.42, `zone_id` = 17, `object_name` = 'Venture Co. Sabatons' WHERE `item` = 9701114;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 869.31, `wy` = -2747.75, `zone_id` = 17, `object_name` = 'Venture Co. Spaulders' WHERE `item` = 9701115;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 328.81, `wy` = -2241.08, `zone_id` = 17, `object_name` = 'Vial of Dread Water' WHERE `item` = 9701116;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 1072.0, `wy` = -2139.75, `zone_id` = 17, `object_name` = 'Warsong Timbercleaver' WHERE `item` = 9701117;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -1225.13, `wy` = -2950.42, `zone_id` = 17, `object_name` = 'Waterlogged Gloves' WHERE `item` = 9701118;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 465.67, `wy` = -3346.0, `zone_id` = 47, `object_name` = 'Aerie Faith Vambraces' WHERE `item` = 9701119;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 29.33, `wy` = -3769.5, `zone_id` = 47, `object_name` = 'Ancient Vilebranch Gloves' WHERE `item` = 9701120;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1466.67, `wy` = -1575.0, `zone_id` = 47, `object_name` = 'Blood Keeper''s Staff' WHERE `item` = 9701121;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -278.67, `wy` = -3461.5, `zone_id` = 47, `object_name` = 'Blood Keeper''s Staff' WHERE `item` = 9701122;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -253.0, `wy` = -2807.0, `zone_id` = 47, `object_name` = 'Brood Caller’s Raiment' WHERE `item` = 9701123;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -227.33, `wy` = -3115.0, `zone_id` = 47, `object_name` = 'Broodsilk Gloves' WHERE `item` = 9701124;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 209.0, `wy` = -2614.5, `zone_id` = 47, `object_name` = 'Dwarven Drinking Pants' WHERE `item` = 9701125;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 55.0, `wy` = -2075.5, `zone_id` = 47, `object_name` = 'Featherbeard’s Bulwark Blaster' WHERE `item` = 9701126;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -253.0, `wy` = -3885.0, `zone_id` = 47, `object_name` = 'Flayer''s Edge' WHERE `item` = 9701127;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -253.0, `wy` = -3846.5, `zone_id` = 47, `object_name` = 'Fleshcarver Athame' WHERE `item` = 9701128;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -47.67, `wy` = -3153.5, `zone_id` = 47, `object_name` = 'Floodworn Shoulderguards' WHERE `item` = 9701129;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -47.67, `wy` = -3153.5, `zone_id` = 47, `object_name` = 'Floodworn Shoulderguards' WHERE `item` = 9701130;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 337.33, `wy` = -4116.0, `zone_id` = 47, `object_name` = 'Fort Defender Band' WHERE `item` = 9701131;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 337.33, `wy` = -4116.0, `zone_id` = 47, `object_name` = 'Fort Defender Band' WHERE `item` = 9701132;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 157.67, `wy` = -3076.5, `zone_id` = 47, `object_name` = 'Fractured Shoulderpads' WHERE `item` = 9701133;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 311.67, `wy` = -2691.5, `zone_id` = 47, `object_name` = 'Anchorfoot Greaves' WHERE `item` = 9701134;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 106.33, `wy` = -3461.5, `zone_id` = 47, `object_name` = 'Hexcall Gavel' WHERE `item` = 9701135;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -227.33, `wy` = -2537.5, `zone_id` = 47, `object_name` = 'Hexweave Robes' WHERE `item` = 9701136;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -22.0, `wy` = -2807.0, `zone_id` = 47, `object_name` = 'Hide Piercer' WHERE `item` = 9701137;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 696.67, `wy` = -3307.5, `zone_id` = 47, `object_name` = 'High Cascade Cord' WHERE `item` = 9701138;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -586.67, `wy` = -4154.5, `zone_id` = 47, `object_name` = 'Highnest Repeater' WHERE `item` = 9701139;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 363.0, `wy` = -2807.0, `zone_id` = 47, `object_name` = 'Highvale Ranger Bow' WHERE `item` = 9701140;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1466.67, `wy` = -1575.0, `zone_id` = 47, `object_name` = 'Highvale Wellband' WHERE `item` = 9701141;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 209.0, `wy` = -2730.0, `zone_id` = 47, `object_name` = 'Highvale Wellband' WHERE `item` = 9701142;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -47.67, `wy` = -4886.0, `zone_id` = 47, `object_name` = 'Idol of the Aerie' WHERE `item` = 9701143;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -47.67, `wy` = -4886.0, `zone_id` = 47, `object_name` = 'Idol of the Aerie' WHERE `item` = 9701144;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -407.0, `wy` = -2884.0, `zone_id` = 47, `object_name` = 'Idol of the Broodmother' WHERE `item` = 9701145;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -689.33, `wy` = -3769.5, `zone_id` = 47, `object_name` = 'Libram of Resolute Light' WHERE `item` = 9701146;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 979.0, `wy` = -2191.0, `zone_id` = 47, `object_name` = 'Lost Scout''s Idol' WHERE `item` = 9701147;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1466.67, `wy` = -1575.0, `zone_id` = 47, `object_name` = 'Ooze Cleansed Shoulderpads' WHERE `item` = 9701148;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 388.67, `wy` = -3307.5, `zone_id` = 47, `object_name` = 'Ooze Cleansed Shoulderpads' WHERE `item` = 9701149;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 209.0, `wy` = -2653.0, `zone_id` = 47, `object_name` = 'Overwatch Longrifle' WHERE `item` = 9701150;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 209.0, `wy` = -2653.0, `zone_id` = 47, `object_name` = 'Overwatch Longrifle' WHERE `item` = 9701151;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 234.67, `wy` = -2845.5, `zone_id` = 47, `object_name` = 'Elven Necklace' WHERE `item` = 9701152;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -740.67, `wy` = -4462.5, `zone_id` = 47, `object_name` = 'Hidden Stash' WHERE `item` = 9701153;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 157.67, `wy` = -3384.5, `zone_id` = 47, `object_name` = 'Sash of Contemplation' WHERE `item` = 9701154;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -355.67, `wy` = -4616.5, `zone_id` = 47, `object_name` = 'Seabreeze Hauberk' WHERE `item` = 9701155;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1466.67, `wy` = -1575.0, `zone_id` = 47, `object_name` = 'Shadowpounce Cowl' WHERE `item` = 9701156;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 80.67, `wy` = -4385.5, `zone_id` = 47, `object_name` = 'Shadowpounce Cowl' WHERE `item` = 9701157;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 363.0, `wy` = -3808.0, `zone_id` = 47, `object_name` = 'Partially Digested Corpse' WHERE `item` = 9701158;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 363.0, `wy` = -3808.0, `zone_id` = 47, `object_name` = 'Partially Digested Corpse' WHERE `item` = 9701159;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 465.67, `wy` = -3615.5, `zone_id` = 47, `object_name` = 'Soothsayer Shroud' WHERE `item` = 9701160;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 55.0, `wy` = -4655.0, `zone_id` = 47, `object_name` = 'Terrapine Carapace' WHERE `item` = 9701161;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 55.0, `wy` = -4655.0, `zone_id` = 47, `object_name` = 'Terrapine Carapace' WHERE `item` = 9701162;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -253.0, `wy` = -3615.5, `zone_id` = 47, `object_name` = 'The Blood Talon' WHERE `item` = 9701163;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1466.67, `wy` = -1575.0, `zone_id` = 47, `object_name` = 'Tiki Shield' WHERE `item` = 9701164;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 414.33, `wy` = -4847.5, `zone_id` = 47, `object_name` = 'Tiki Shield' WHERE `item` = 9701165;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 106.33, `wy` = -4116.0, `zone_id` = 47, `object_name` = 'Trapper’s Lone Band' WHERE `item` = 9701166;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 234.67, `wy` = -4308.5, `zone_id` = 47, `object_name` = 'Vilebranch Beastlance' WHERE `item` = 9701167;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 234.67, `wy` = -4308.5, `zone_id` = 47, `object_name` = 'Vilebranch Beastlance' WHERE `item` = 9701168;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -535.33, `wy` = -3885.0, `zone_id` = 47, `object_name` = 'Vilebranch Ritual Dagger' WHERE `item` = 9701169;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1466.67, `wy` = -1575.0, `zone_id` = 47, `object_name` = 'Vilebranch Warthrower' WHERE `item` = 9701170;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -227.33, `wy` = -4000.5, `zone_id` = 47, `object_name` = 'Vilebranch Warthrower' WHERE `item` = 9701171;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -766.33, `wy` = -3808.0, `zone_id` = 47, `object_name` = 'Wand of the Broodbound' WHERE `item` = 9701172;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3966.67, `wy` = -433.33, `zone_id` = 400, `object_name` = 'Abandoned Moonshine' WHERE `item` = 9701173;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6108.0, `wy` = -3601.33, `zone_id` = 400, `object_name` = 'Abandoned Moonshine' WHERE `item` = 9701174;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6460.0, `wy` = -3557.33, `zone_id` = 400, `object_name` = 'Ancient Jeweler''s Staff' WHERE `item` = 9701175;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4700.0, `wy` = -1445.33, `zone_id` = 400, `object_name` = 'Caravaner''s Bracers' WHERE `item` = 9701176;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4934.67, `wy` = -2369.33, `zone_id` = 400, `object_name` = 'Centaur Mining Axe' WHERE `item` = 9701177;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5404.0, `wy` = -2897.33, `zone_id` = 400, `object_name` = 'Cloud Serpent Feather' WHERE `item` = 9701178;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5404.0, `wy` = -2897.33, `zone_id` = 400, `object_name` = 'Cloud Serpent Feather' WHERE `item` = 9701179;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4758.67, `wy` = -2149.33, `zone_id` = 400, `object_name` = 'Cursed Elemental Scepter' WHERE `item` = 9701180;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4993.33, `wy` = -2017.33, `zone_id` = 400, `object_name` = 'Darkcloud Braid' WHERE `item` = 9701181;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4993.33, `wy` = -2105.33, `zone_id` = 400, `object_name` = 'Darkcloud Totem' WHERE `item` = 9701182;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4993.33, `wy` = -2105.33, `zone_id` = 400, `object_name` = 'Darkcloud Totem' WHERE `item` = 9701183;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5609.33, `wy` = -2061.33, `zone_id` = 400, `object_name` = 'Deadman''s Signet' WHERE `item` = 9701184;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5609.33, `wy` = -2061.33, `zone_id` = 400, `object_name` = 'Deadman''s Signet' WHERE `item` = 9701185;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4964.0, `wy` = -2281.33, `zone_id` = 400, `object_name` = 'Drowned Diver''s Helm' WHERE `item` = 9701186;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6225.33, `wy` = -3953.33, `zone_id` = 400, `object_name` = 'Engine Safety Belt' WHERE `item` = 9701187;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4700.0, `wy` = -1841.33, `zone_id` = 400, `object_name` = 'Failed Parachute' WHERE `item` = 9701188;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3966.67, `wy` = -433.33, `zone_id` = 400, `object_name` = 'Forgotten Pauldron' WHERE `item` = 9701189;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5404.0, `wy` = -3337.33, `zone_id` = 400, `object_name` = 'Forgotten Pauldron' WHERE `item` = 9701190;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5374.67, `wy` = -2237.33, `zone_id` = 400, `object_name` = 'Freewind Gloves' WHERE `item` = 9701191;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4582.67, `wy` = -1269.33, `zone_id` = 400, `object_name` = 'Galak Chicken Smasher' WHERE `item` = 9701192;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5022.67, `wy` = -2193.33, `zone_id` = 400, `object_name` = 'Galak Shortbow' WHERE `item` = 9701193;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5022.67, `wy` = -2193.33, `zone_id` = 400, `object_name` = 'Galak Shortbow' WHERE `item` = 9701194;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6372.0, `wy` = -4129.33, `zone_id` = 400, `object_name` = 'Goblin Racing Boots' WHERE `item` = 9701195;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5198.67, `wy` = -2149.33, `zone_id` = 400, `object_name` = 'Grimtotem Darkblade' WHERE `item` = 9701196;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4993.33, `wy` = -1885.33, `zone_id` = 400, `object_name` = 'Grimtotem Jaw Smasher' WHERE `item` = 9701197;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6108.0, `wy` = -2809.33, `zone_id` = 400, `object_name` = 'Highlands Vest' WHERE `item` = 9701198;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5169.33, `wy` = -1225.33, `zone_id` = 400, `object_name` = 'Highperch Necklace' WHERE `item` = 9701199;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6372.0, `wy` = -4129.33, `zone_id` = 400, `object_name` = 'Isolated Inventor''s Bulk' WHERE `item` = 9701200;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5873.33, `wy` = -3425.33, `zone_id` = 400, `object_name` = 'Kodo War Drum' WHERE `item` = 9701201;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3966.67, `wy` = -433.33, `zone_id` = 400, `object_name` = 'Needlewind Crossbow' WHERE `item` = 9701202;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5580.0, `wy` = -2721.33, `zone_id` = 400, `object_name` = 'Needlewind Crossbow' WHERE `item` = 9701203;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4934.67, `wy` = -1357.33, `zone_id` = 400, `object_name` = 'Pack Kodo Satchel' WHERE `item` = 9701204;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5814.67, `wy` = -3909.33, `zone_id` = 400, `object_name` = 'Pip''s Rad Stone' WHERE `item` = 9701205;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5580.0, `wy` = -4041.33, `zone_id` = 400, `object_name` = 'Pirate''s Mail' WHERE `item` = 9701206;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -3966.67, `wy` = -433.33, `zone_id` = 400, `object_name` = 'Runway Scraper' WHERE `item` = 9701207;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5785.33, `wy` = -4041.33, `zone_id` = 400, `object_name` = 'Runway Scraper' WHERE `item` = 9701208;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4934.67, `wy` = -2281.33, `zone_id` = 400, `object_name` = 'Scuba Slayer''s Blade' WHERE `item` = 9701209;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -4934.67, `wy` = -2281.33, `zone_id` = 400, `object_name` = 'Scuba Slayer''s Blade' WHERE `item` = 9701210;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6518.67, `wy` = -3249.33, `zone_id` = 400, `object_name` = 'Silithid Bug Blaster' WHERE `item` = 9701211;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5081.33, `wy` = -1357.33, `zone_id` = 400, `object_name` = 'Slightly Magical Kodo Bone' WHERE `item` = 9701212;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5316.0, `wy` = -1797.33, `zone_id` = 400, `object_name` = 'Staff of the Wind Sisters' WHERE `item` = 9701213;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5902.67, `wy` = -4305.33, `zone_id` = 400, `object_name` = 'Survivor''s Trousers' WHERE `item` = 9701214;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6577.33, `wy` = -3909.33, `zone_id` = 400, `object_name` = 'Tahonda Gauntlets' WHERE `item` = 9701215;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5609.33, `wy` = -1577.33, `zone_id` = 400, `object_name` = 'The Tickler' WHERE `item` = 9701216;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5668.0, `wy` = -3689.33, `zone_id` = 400, `object_name` = 'U.L.T.R.A Racing Goggles' WHERE `item` = 9701217;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -5169.33, `wy` = -917.33, `zone_id` = 400, `object_name` = 'Wyvern Trapper Spear' WHERE `item` = 9701218;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3054.25, `wy` = -265.35, `zone_id` = 85, `object_name` = 'Adventurer Gloves' WHERE `item` = 9701219;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2753.0, `wy` = 773.96, `zone_id` = 85, `object_name` = 'Agamand Farmer Trousers' WHERE `item` = 9701220;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2933.75, `wy` = 954.71, `zone_id` = 85, `object_name` = 'Agamand Sharpshooter' WHERE `item` = 9701221;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3054.25, `wy` = 638.4, `zone_id` = 85, `object_name` = 'Agamand Walking Stick' WHERE `item` = 9701222;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2632.5, `wy` = 1045.08, `zone_id` = 85, `object_name` = 'Apothecary''s Lantern' WHERE `item` = 9701223;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2481.87, `wy` = 5.77, `zone_id` = 85, `object_name` = 'Butchery Blade' WHERE `item` = 9701224;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3084.37, `wy` = -581.67, `zone_id` = 85, `object_name` = 'Captain''s Shield' WHERE `item` = 9701225;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3054.25, `wy` = 5.77, `zone_id` = 85, `object_name` = 'Coastline Vest' WHERE `item` = 9701226;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2271.0, `wy` = 819.15, `zone_id` = 85, `object_name` = 'Empty Satchel' WHERE `item` = 9701227;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1668.5, `wy` = -355.73, `zone_id` = 85, `object_name` = 'Faded Gravecloth Cuffs' WHERE `item` = 9701228;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2873.5, `wy` = 367.27, `zone_id` = 85, `object_name` = 'Maggot Eye Musket' WHERE `item` = 9701229;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2331.25, `wy` = 457.65, `zone_id` = 85, `object_name` = 'Ghostmoor Cloak' WHERE `item` = 9701230;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1879.37, `wy` = 1045.08, `zone_id` = 85, `object_name` = 'Gravedigger''s Delight' WHERE `item` = 9701231;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2030.0, `wy` = -536.48, `zone_id` = 85, `object_name` = 'Haunted Mace' WHERE `item` = 9701232;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2542.12, `wy` = 548.02, `zone_id` = 85, `object_name` = 'Haunted Ring' WHERE `item` = 9701233;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2903.62, `wy` = 367.27, `zone_id` = 85, `object_name` = 'Maggot Eye Musket' WHERE `item` = 9701234;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2060.12, `wy` = 50.96, `zone_id` = 85, `object_name` = 'Nightfallen Jerkin' WHERE `item` = 9701235;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2572.25, `wy` = -39.42, `zone_id` = 85, `object_name` = 'Old Arcanus Robe' WHERE `item` = 9701236;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2090.25, `wy` = 638.4, `zone_id` = 85, `object_name` = 'Old Wagon Wheel' WHERE `item` = 9701237;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2301.12, `wy` = -84.6, `zone_id` = 85, `object_name` = 'Old Waterlogged Boots' WHERE `item` = 9701238;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3024.12, `wy` = 276.9, `zone_id` = 85, `object_name` = 'Puddle-jumper Dagger' WHERE `item` = 9701239;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2542.12, `wy` = 773.96, `zone_id` = 85, `object_name` = 'Rattlecage Warplate' WHERE `item` = 9701240;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1789.0, `wy` = 683.58, `zone_id` = 85, `object_name` = 'Scarlet Insignia' WHERE `item` = 9701241;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3084.37, `wy` = 1632.52, `zone_id` = 85, `object_name` = 'Silkwrapped Cloak' WHERE `item` = 9701242;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2331.25, `wy` = 1316.21, `zone_id` = 85, `object_name` = 'Solliden Family Broom' WHERE `item` = 9701243;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2391.5, `wy` = 322.08, `zone_id` = 85, `object_name` = 'Ulag''s Cleaver' WHERE `item` = 9701244;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2542.12, `wy` = 1451.77, `zone_id` = 85, `object_name` = 'Waterlogged Sparkler' WHERE `item` = 9701245;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6879.33, `wy` = -1982.67, `zone_id` = 490, `object_name` = 'Campsite Shrapnel' WHERE `item` = 9701246;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6336.67, `wy` = -650.67, `zone_id` = 490, `object_name` = 'Cenarion Dreamcatcher' WHERE `item` = 9701247;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6534.0, `wy` = -1871.67, `zone_id` = 490, `object_name` = 'Fossilized Smasher' WHERE `item` = 9701248;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6756.0, `wy` = -1686.67, `zone_id` = 490, `object_name` = 'Goblin Plant Slicer' WHERE `item` = 9701249;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6583.33, `wy` = -761.67, `zone_id` = 490, `object_name` = 'Lucky Fisherman''s Breeches' WHERE `item` = 9701250;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6262.67, `wy` = -1538.67, `zone_id` = 490, `object_name` = 'Pylon Charged Staff' WHERE `item` = 9701251;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6410.67, `wy` = -1908.67, `zone_id` = 490, `object_name` = 'Silverback Cape' WHERE `item` = 9701252;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6854.67, `wy` = -1242.67, `zone_id` = 490, `object_name` = 'Slightly Sticky Cloak' WHERE `item` = 9701253;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = -6386.0, `wy` = -1945.67, `zone_id` = 490, `object_name` = 'Tongs of Miscalibration' WHERE `item` = 9701254;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1417.33, `wy` = -1260.33, `zone_id` = 28, `object_name` = 'Flesh Flayer Hook' WHERE `item` = 9701255;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1360.0, `wy` = -1432.33, `zone_id` = 28, `object_name` = 'Andorhal Manual' WHERE `item` = 9701256;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1245.33, `wy` = -3023.33, `zone_id` = 28, `object_name` = 'Apothecary Cowl' WHERE `item` = 9701257;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2678.67, `wy` = -1948.33, `zone_id` = 28, `object_name` = 'Bloodied Pants' WHERE `item` = 9701258;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1675.33, `wy` = -1389.33, `zone_id` = 28, `object_name` = 'Bonescourge Dagger' WHERE `item` = 9701259;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2994.0, `wy` = -1561.33, `zone_id` = 28, `object_name` = 'Brightflame Codex' WHERE `item` = 9701260;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2850.67, `wy` = -1475.33, `zone_id` = 28, `object_name` = 'Burning Judgement' WHERE `item` = 9701261;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2076.67, `wy` = -1905.33, `zone_id` = 28, `object_name` = 'Charred Slicer' WHERE `item` = 9701262;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1589.33, `wy` = -1518.33, `zone_id` = 28, `object_name` = 'Ebonblight Slippers' WHERE `item` = 9701263;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1732.67, `wy` = -2335.33, `zone_id` = 28, `object_name` = 'Fetid Mace' WHERE `item` = 9701264;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1761.33, `wy` = -1131.33, `zone_id` = 28, `object_name` = 'Flayer''s Helmet' WHERE `item` = 9701265;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1847.33, `wy` = -2163.33, `zone_id` = 28, `object_name` = 'Graveyard Striker' WHERE `item` = 9701266;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1044.67, `wy` = -1819.33, `zone_id` = 28, `object_name` = 'Libram of Remembrance' WHERE `item` = 9701267;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2420.67, `wy` = -1475.33, `zone_id` = 28, `object_name` = 'Northridge Hatchet' WHERE `item` = 9701268;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1847.33, `wy` = -1561.33, `zone_id` = 28, `object_name` = 'Phylactery Shard' WHERE `item` = 9701269;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1130.67, `wy` = -1647.33, `zone_id` = 28, `object_name` = 'Plague Mask' WHERE `item` = 9701270;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1876.0, `wy` = -1303.33, `zone_id` = 28, `object_name` = 'Scarlet Blunderbuss' WHERE `item` = 9701271;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2105.33, `wy` = -1518.33, `zone_id` = 28, `object_name` = 'Scarlet Pauldrons' WHERE `item` = 9701272;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2994.0, `wy` = -1475.33, `zone_id` = 28, `object_name` = 'Scarlet Shield' WHERE `item` = 9701273;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1302.67, `wy` = -2206.33, `zone_id` = 28, `object_name` = 'Scourgestalker’s Girdle' WHERE `item` = 9701274;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2736.0, `wy` = -1647.33, `zone_id` = 28, `object_name` = 'Sentinel Sharpshooter' WHERE `item` = 9701275;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 3366.67, `wy` = 416.67, `zone_id` = 28, `object_name` = 'Shimmering Scarlet Cane' WHERE `item` = 9701276;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2105.33, `wy` = -1819.33, `zone_id` = 28, `object_name` = 'Shimmering Scarlet Cane' WHERE `item` = 9701277;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1274.0, `wy` = -2378.33, `zone_id` = 28, `object_name` = 'Skeletal Club' WHERE `item` = 9701278;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1388.67, `wy` = -1088.33, `zone_id` = 28, `object_name` = 'Skippy''s Bone' WHERE `item` = 9701279;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1216.67, `wy` = -1346.33, `zone_id` = 28, `object_name` = 'Spiced Rum' WHERE `item` = 9701280;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1790.0, `wy` = -1217.33, `zone_id` = 28, `object_name` = 'Sticky Sabatons' WHERE `item` = 9701281;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 2822.0, `wy` = -1819.33, `zone_id` = 28, `object_name` = 'Tracker''s Plagued Spike' WHERE `item` = 9701282;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = 1073.33, `wy` = -1905.33, `zone_id` = 28, `object_name` = 'Wraithbone Ring' WHERE `item` = 9701283;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10403.33, `wy` = 951.67, `zone_id` = 40, `object_name` = 'Blessed Mail Wraps' WHERE `item` = 9701284;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11266.67, `wy` = 1021.67, `zone_id` = 40, `object_name` = 'Burial Blade' WHERE `item` = 9701285;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9586.67, `wy` = 1266.67, `zone_id` = 40, `object_name` = 'Corroded Quel''thalas Ring ' WHERE `item` = 9701286;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11150.0, `wy` = 566.67, `zone_id` = 40, `object_name` = 'Defias Apothecary Pants' WHERE `item` = 9701287;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Defias Handshake' WHERE `item` = 9701288;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10753.33, `wy` = 881.67, `zone_id` = 40, `object_name` = 'Defias Handshake' WHERE `item` = 9701289;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10986.67, `wy` = 1616.67, `zone_id` = 40, `object_name` = 'Defias Honorcode Memento' WHERE `item` = 9701290;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Defias Magus Staff' WHERE `item` = 9701291;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10753.33, `wy` = 1651.67, `zone_id` = 40, `object_name` = 'Defias Magus Staff' WHERE `item` = 9701292;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10333.33, `wy` = 1231.67, `zone_id` = 40, `object_name` = 'Defias Throwing Knife' WHERE `item` = 9701293;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10333.33, `wy` = 1231.67, `zone_id` = 40, `object_name` = 'Defias Throwing Knife' WHERE `item` = 9701294;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Defias Toe Knife' WHERE `item` = 9701295;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10496.67, `wy` = 1336.67, `zone_id` = 40, `object_name` = 'Defias Toe Knife' WHERE `item` = 9701296;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Field Boots' WHERE `item` = 9701297;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9843.33, `wy` = 916.67, `zone_id` = 40, `object_name` = 'Field Boots' WHERE `item` = 9701298;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10146.67, `wy` = 1056.67, `zone_id` = 40, `object_name` = 'Field Trousers' WHERE `item` = 9701299;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9773.33, `wy` = 2141.67, `zone_id` = 40, `object_name` = 'Fisherman''s Last Wish' WHERE `item` = 9701300;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9773.33, `wy` = 2141.67, `zone_id` = 40, `object_name` = 'Fisherman''s Last Wish' WHERE `item` = 9701301;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10800.0, `wy` = 2036.67, `zone_id` = 40, `object_name` = 'Flexible Gloves' WHERE `item` = 9701302;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Gnoll Cleaver' WHERE `item` = 9701303;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9703.33, `wy` = 1441.67, `zone_id` = 40, `object_name` = 'Gnoll Cleaver' WHERE `item` = 9701304;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10216.67, `wy` = 1441.67, `zone_id` = 40, `object_name` = 'Harvest Scythe' WHERE `item` = 9701305;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10030.0, `wy` = 1441.67, `zone_id` = 40, `object_name` = 'Harvester’s Aegis' WHERE `item` = 9701306;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Heavy Bone' WHERE `item` = 9701307;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10076.67, `wy` = 1546.67, `zone_id` = 40, `object_name` = 'Heavy Bone' WHERE `item` = 9701308;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10776.67, `wy` = 1406.67, `zone_id` = 40, `object_name` = 'Heavy Boots' WHERE `item` = 9701309;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10263.33, `wy` = 1756.67, `zone_id` = 40, `object_name` = 'Leyline Channeling Rod' WHERE `item` = 9701310;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9843.33, `wy` = 1056.67, `zone_id` = 40, `object_name` = 'Liquid Arcane' WHERE `item` = 9701311;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9843.33, `wy` = 1056.67, `zone_id` = 40, `object_name` = 'Liquid Arcane' WHERE `item` = 9701312;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11126.67, `wy` = 496.67, `zone_id` = 40, `object_name` = 'Madness Cursed Notes' WHERE `item` = 9701313;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11430.0, `wy` = 1826.67, `zone_id` = 40, `object_name` = 'Murky Quel''thalas Drape' WHERE `item` = 9701314;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11010.0, `wy` = 1476.67, `zone_id` = 40, `object_name` = 'Old Defias Gun' WHERE `item` = 9701315;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10030.0, `wy` = 2001.67, `zone_id` = 40, `object_name` = 'Old Quel''thalas Brooch' WHERE `item` = 9701316;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10543.33, `wy` = 2001.67, `zone_id` = 40, `object_name` = 'Peculiar Gold Nugget' WHERE `item` = 9701317;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11080.0, `wy` = 1651.67, `zone_id` = 40, `object_name` = 'Peculiar Gold Nugget' WHERE `item` = 9701318;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11453.33, `wy` = 1511.67, `zone_id` = 40, `object_name` = 'People''s Militia Crossbow' WHERE `item` = 9701319;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9866.67, `wy` = 1301.67, `zone_id` = 40, `object_name` = 'Pumpkin Smashers' WHERE `item` = 9701320;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10426.67, `wy` = 1931.67, `zone_id` = 40, `object_name` = 'Quarry Sledge' WHERE `item` = 9701321;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10426.67, `wy` = 1931.67, `zone_id` = 40, `object_name` = 'Quarry Sledge' WHERE `item` = 9701322;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10963.33, `wy` = 1021.67, `zone_id` = 40, `object_name` = 'Rehomed Belt' WHERE `item` = 9701323;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11500.0, `wy` = 1756.67, `zone_id` = 40, `object_name` = 'Rower''s Jerkin' WHERE `item` = 9701324;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11126.67, `wy` = 2106.67, `zone_id` = 40, `object_name` = 'Rusty Quel''thalas Circlet' WHERE `item` = 9701325;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10100.0, `wy` = 1056.67, `zone_id` = 40, `object_name` = 'Salma''s Summer Dress' WHERE `item` = 9701326;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Sentinel''s Blade' WHERE `item` = 9701327;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10496.67, `wy` = 1021.67, `zone_id` = 40, `object_name` = 'Sentinel''s Blade' WHERE `item` = 9701328;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9400.0, `wy` = 3016.67, `zone_id` = 40, `object_name` = 'Sharpened Chopper' WHERE `item` = 9701329;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10310.0, `wy` = 1406.67, `zone_id` = 40, `object_name` = 'Sharpened Chopper' WHERE `item` = 9701330;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9913.33, `wy` = 811.67, `zone_id` = 40, `object_name` = 'Soldier''s Mail' WHERE `item` = 9701331;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -11243.33, `wy` = 1161.67, `zone_id` = 40, `object_name` = 'Stolen Thunderbrew Flask' WHERE `item` = 9701332;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -10520.0, `wy` = 1581.67, `zone_id` = 40, `object_name` = 'Wizard Wraps' WHERE `item` = 9701333;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -9773.33, `wy` = 1791.67, `zone_id` = 40, `object_name` = 'Worn Quel''thalas Heirloom' WHERE `item` = 9701334;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3277.98, `wy` = -1506.15, `zone_id` = 11, `object_name` = 'Arakor Mace' WHERE `item` = 9701335;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2147.92, `wy` = -389.58, `zone_id` = 11, `object_name` = 'Balgaras''s Foul Amulet' WHERE `item` = 9701336;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2919.67, `wy` = -2994.9, `zone_id` = 11, `object_name` = 'Balgaras''s Foul Amulet' WHERE `item` = 9701337;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3911.92, `wy` = -3036.25, `zone_id` = 11, `object_name` = 'Borrowed Dark Iron Signet' WHERE `item` = 9701338;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3415.79, `wy` = -1506.15, `zone_id` = 11, `object_name` = 'Chewed Wrappings' WHERE `item` = 9701339;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4049.73, `wy` = -3449.79, `zone_id` = 11, `object_name` = 'Crimson Dragonscale' WHERE `item` = 9701340;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2147.92, `wy` = -389.58, `zone_id` = 11, `object_name` = 'Crude Bluegill Totem' WHERE `item` = 9701341;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3222.85, `wy` = -1009.9, `zone_id` = 11, `object_name` = 'Crude Bluegill Totem' WHERE `item` = 9701342;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2809.42, `wy` = -1009.9, `zone_id` = 11, `object_name` = 'Cursed Cape of the Wave Mistress' WHERE `item` = 9701343;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2974.79, `wy` = -968.54, `zone_id` = 11, `object_name` = 'Cursed Legguards of the Intrepid' WHERE `item` = 9701344;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4297.79, `wy` = -3036.25, `zone_id` = 11, `object_name` = 'Dark Iron Harvester' WHERE `item` = 9701345;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3415.79, `wy` = -2415.94, `zone_id` = 11, `object_name` = 'Dragonmaw Ritual Staff' WHERE `item` = 9701346;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3415.79, `wy` = -2415.94, `zone_id` = 11, `object_name` = 'Dragonmaw Ritual Staff' WHERE `item` = 9701347;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2644.04, `wy` = -2333.23, `zone_id` = 11, `object_name` = 'Dwarven Demolition Kit' WHERE `item` = 9701348;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3498.48, `wy` = -1836.98, `zone_id` = 11, `object_name` = 'Etched Tablet' WHERE `item` = 9701349;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2836.98, `wy` = -2250.52, `zone_id` = 11, `object_name` = 'Ironbeard''s Axe' WHERE `item` = 9701350;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3085.04, `wy` = -3284.37, `zone_id` = 11, `object_name` = 'Miner Handwraps' WHERE `item` = 9701351;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3277.98, `wy` = -2705.42, `zone_id` = 11, `object_name` = 'Mirefin Belt' WHERE `item` = 9701352;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2974.79, `wy` = -1712.92, `zone_id` = 11, `object_name` = 'Mossy Hide Armor' WHERE `item` = 9701353;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3222.85, `wy` = -1423.44, `zone_id` = 11, `object_name` = 'Old Dragon Bone' WHERE `item` = 9701354;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3222.85, `wy` = -1423.44, `zone_id` = 11, `object_name` = 'Old Dragon Bone' WHERE `item` = 9701355;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2147.92, `wy` = -389.58, `zone_id` = 11, `object_name` = 'Old Dragonmaw Cleaver' WHERE `item` = 9701356;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3415.79, `wy` = -3077.6, `zone_id` = 11, `object_name` = 'Old Dragonmaw Cleaver' WHERE `item` = 9701357;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2892.1, `wy` = -2581.35, `zone_id` = 11, `object_name` = 'Pilfered Stormpike Polearm' WHERE `item` = 9701358;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2892.1, `wy` = -2581.35, `zone_id` = 11, `object_name` = 'Pilfered Stormpike Polearm' WHERE `item` = 9701359;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3608.73, `wy` = -1382.08, `zone_id` = 11, `object_name` = 'Raptor-Gnawed Cap' WHERE `item` = 9701360;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3608.73, `wy` = -1382.08, `zone_id` = 11, `object_name` = 'Raptor-Gnawed Cap' WHERE `item` = 9701361;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3608.73, `wy` = -2788.12, `zone_id` = 11, `object_name` = 'Stubborn Dwarf Slippers' WHERE `item` = 9701362;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2147.92, `wy` = -389.58, `zone_id` = 11, `object_name` = 'Swiftgear Sniper' WHERE `item` = 9701363;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2754.29, `wy` = -1547.5, `zone_id` = 11, `object_name` = 'Swiftgear Sniper' WHERE `item` = 9701364;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2147.92, `wy` = -389.58, `zone_id` = 11, `object_name` = 'Thelsamar Bow' WHERE `item` = 9701365;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3029.92, `wy` = -2415.94, `zone_id` = 11, `object_name` = 'Thelsamar Bow' WHERE `item` = 9701366;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -2864.54, `wy` = -2374.58, `zone_id` = 11, `object_name` = 'Vestments of the Unbound' WHERE `item` = 9701367;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -3801.67, `wy` = -2457.29, `zone_id` = 11, `object_name` = 'Waterlogged Musket' WHERE `item` = 9701368;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4187.54, `wy` = -2374.58, `zone_id` = 11, `object_name` = 'Wyrmscale Spaulders' WHERE `item` = 9701369;
UPDATE `world`.`worldforge_item` SET `map` = 0, `wx` = -4187.54, `wy` = -2374.58, `zone_id` = 11, `object_name` = 'Wyrmscale Spaulders' WHERE `item` = 9701370;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6403.33, `wy` = -2801.67, `zone_id` = 618, `object_name` = 'Chillbane Cleaver' WHERE `item` = 9701371;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6782.0, `wy` = -5073.67, `zone_id` = 618, `object_name` = 'Cold Wristguards' WHERE `item` = 9701372;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6782.0, `wy` = -3582.67, `zone_id` = 618, `object_name` = 'Flattened Shoulderpad' WHERE `item` = 9701373;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6545.33, `wy` = -4008.67, `zone_id` = 618, `object_name` = 'Frostglade Saber' WHERE `item` = 9701374;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6592.67, `wy` = -3511.67, `zone_id` = 618, `object_name` = 'Icemaw Greatmaul' WHERE `item` = 9701375;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6687.33, `wy` = -4505.67, `zone_id` = 618, `object_name` = 'Maddening Signet' WHERE `item` = 9701376;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6308.67, `wy` = -2446.67, `zone_id` = 618, `object_name` = 'Researcher''s Dish' WHERE `item` = 9701377;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 5172.67, `wy` = -4576.67, `zone_id` = 618, `object_name` = 'The Leaping Arc' WHERE `item` = 9701378;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6829.33, `wy` = -2375.67, `zone_id` = 618, `object_name` = 'Thermal Pendant' WHERE `item` = 9701379;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6924.0, `wy` = -2304.67, `zone_id` = 618, `object_name` = 'Timbermaw Idol' WHERE `item` = 9701380;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6498.0, `wy` = -3156.67, `zone_id` = 618, `object_name` = 'Windsong Totem' WHERE `item` = 9701381;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 6829.33, `wy` = -5073.67, `zone_id` = 618, `object_name` = 'Winterfall Dagger' WHERE `item` = 9701382;
UPDATE `world`.`worldforge_item` SET `map` = 1, `wx` = 7255.33, `wy` = -4079.67, `zone_id` = 618, `object_name` = 'Wintergale Cloak' WHERE `item` = 9701383;
