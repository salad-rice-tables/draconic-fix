-- Restore retail Sound kits (hotfixes.creature_text snapshot) for 412 silent rows
-- source: retail creature_text DB2 snapshot, gate: same line or own voice folder

UPDATE world.creature_text SET Sound=103730 WHERE CreatureID=137104 AND GroupID=0 AND ID=0; -- Orc Raider bt-text-match
UPDATE world.creature_text SET Sound=65819 WHERE CreatureID=109670 AND GroupID=1 AND ID=0; -- Chronarch Defender bt-text-match
UPDATE world.creature_text SET Sound=66004 WHERE CreatureID=116360 AND GroupID=3 AND ID=0; -- Duskwatch Scryer bt-text-match
UPDATE world.creature_text SET Sound=8896 WHERE CreatureID=16065 AND GroupID=1 AND ID=0; -- Lady Blaumeux bt-text-match
UPDATE world.creature_text SET Sound=53431 WHERE CreatureID=120198 AND GroupID=3 AND ID=0; -- Bradensbrook Villager bt-text-match
UPDATE world.creature_text SET Sound=98569 WHERE CreatureID=124628 AND GroupID=0 AND ID=0; -- Ren'Zuli bt-text-match
UPDATE world.creature_text SET Sound=46572 WHERE CreatureID=81859 AND GroupID=3 AND ID=0; -- Fangraal bt-text-match
UPDATE world.creature_text SET Sound=65803 WHERE CreatureID=111619 AND GroupID=1 AND ID=0; -- Duskwatch Shroud bt-text-match
UPDATE world.creature_text SET Sound=65778 WHERE CreatureID=109408 AND GroupID=3 AND ID=0; -- Lieutenant Piet bt-text-match
UPDATE world.creature_text SET Sound=62762 WHERE CreatureID=91131 AND GroupID=1 AND ID=0; -- Runas the Shamed own-voice-folder
UPDATE world.creature_text SET Sound=56967 WHERE CreatureID=92450 AND GroupID=0 AND ID=4; -- Eredar Riftweaver bt-text-match
UPDATE world.creature_text SET Sound=54897 WHERE CreatureID=93846 AND GroupID=0 AND ID=0; -- Mayla Highmountain bt-text-match
UPDATE world.creature_text SET Sound=9321 WHERE CreatureID=15690 AND GroupID=2 AND ID=2; -- Prince Malchezaar bt-text-match
UPDATE world.creature_text SET Sound=1108 WHERE CreatureID=72953 AND GroupID=4 AND ID=0; -- Grimfrost Wolfslayer bt-text-match
UPDATE world.creature_text SET Sound=63555 WHERE CreatureID=107866 AND GroupID=3 AND ID=0; -- Watcher Fraizer bt-text-match
UPDATE world.creature_text SET Sound=52684 WHERE CreatureID=90109 AND GroupID=1 AND ID=0; -- Hatecoil Slavemaster bt-text-match
UPDATE world.creature_text SET Sound=46152 WHERE CreatureID=78509 AND GroupID=1 AND ID=0; -- Bleeding Hollow Berserker bt-text-match
UPDATE world.creature_text SET Sound=27391 WHERE CreatureID=61792 AND GroupID=0 AND ID=0; -- Aysa Cloudsinger bt-text-match
UPDATE world.creature_text SET Sound=56997 WHERE CreatureID=118783 AND GroupID=0 AND ID=0; -- Dreadflame Corruptor bt-text-match
UPDATE world.creature_text SET Sound=10537 WHERE CreatureID=18702 AND GroupID=3 AND ID=0; -- Auchenai Necromancer bt-text-match
UPDATE world.creature_text SET Sound=66336 WHERE CreatureID=110654 AND GroupID=3 AND ID=0; -- Frightened Laborer bt-text-match
UPDATE world.creature_text SET Sound=56997 WHERE CreatureID=119516 AND GroupID=1 AND ID=0; -- Frenzied Dedicant bt-text-match
UPDATE world.creature_text SET Sound=2992 WHERE CreatureID=73465 AND GroupID=0 AND ID=0; -- Dark Acolyte bt-text-match
UPDATE world.creature_text SET Sound=37730 WHERE CreatureID=79128 AND GroupID=4 AND ID=0; -- Wor'gol Cold-Singer bt-text-match
UPDATE world.creature_text SET Sound=60124 WHERE CreatureID=103685 AND GroupID=4 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=87810 WHERE CreatureID=127883 AND GroupID=1 AND ID=0; -- Echo of Valok bt-text-match
UPDATE world.creature_text SET Sound=83023 WHERE CreatureID=118412 AND GroupID=0 AND ID=0; -- Kirin Tor Mage bt-text-match
UPDATE world.creature_text SET Sound=68078 WHERE CreatureID=112797 AND GroupID=2 AND ID=0; -- Dvalen Ironrune own-voice-folder
UPDATE world.creature_text SET Sound=11966 WHERE CreatureID=23543 AND GroupID=1 AND ID=0; -- Shade of the Horseman bt-text-match
UPDATE world.creature_text SET Sound=66004 WHERE CreatureID=109670 AND GroupID=2 AND ID=0; -- Chronarch Defender bt-text-match
UPDATE world.creature_text SET Sound=68275 WHERE CreatureID=110564 AND GroupID=1 AND ID=0; -- Alonsus Faol bt-text-match
UPDATE world.creature_text SET Sound=15775 WHERE CreatureID=33134 AND GroupID=1 AND ID=2; -- Sara bt-text-match
UPDATE world.creature_text SET Sound=12521 WHERE CreatureID=26246 AND GroupID=3 AND ID=0; -- Prophet Velen bt-text-match
UPDATE world.creature_text SET Sound=3434 WHERE CreatureID=38455 AND GroupID=3 AND ID=0; -- Ace bt-text-match
UPDATE world.creature_text SET Sound=45035 WHERE CreatureID=76877 AND GroupID=4 AND ID=0; -- Gruul bt-text-match
UPDATE world.creature_text SET Sound=61244 WHERE CreatureID=95152 AND GroupID=1 AND ID=0; -- Wormtalon Huntress bt-text-match
UPDATE world.creature_text SET Sound=43198 WHERE CreatureID=76190 AND GroupID=3 AND ID=0; -- Liberated Soul bt-text-match
UPDATE world.creature_text SET Sound=57006 WHERE CreatureID=119516 AND GroupID=0 AND ID=0; -- Frenzied Dedicant bt-text-match
UPDATE world.creature_text SET Sound=62044 WHERE CreatureID=98074 AND GroupID=3 AND ID=0; -- Junior Trainee bt-text-match
UPDATE world.creature_text SET Sound=9319 WHERE CreatureID=15690 AND GroupID=3 AND ID=2; -- Prince Malchezaar bt-text-match
UPDATE world.creature_text SET Sound=38065 WHERE CreatureID=71865 AND GroupID=11 AND ID=0; -- Garrosh Hellscream bt-text-match
UPDATE world.creature_text SET Sound=13390 WHERE CreatureID=89101 AND GroupID=3 AND ID=0; -- Prince Oceanus bt-text-match
UPDATE world.creature_text SET Sound=52347 WHERE CreatureID=95727 AND GroupID=0 AND ID=3; -- Darkfiend Corruptor bt-text-match
UPDATE world.creature_text SET Sound=65869 WHERE CreatureID=101784 AND GroupID=1 AND ID=0; -- Nightborne Infiltrator bt-text-match
UPDATE world.creature_text SET Sound=74741 WHERE CreatureID=102100 AND GroupID=0 AND ID=2; -- Skyhorn Pathfinder bt-text-match
UPDATE world.creature_text SET Sound=82712 WHERE CreatureID=119839 AND GroupID=0 AND ID=0; -- Wrathsteed of Xoroth bt-text-match
UPDATE world.creature_text SET Sound=88349 WHERE CreatureID=118791 AND GroupID=1 AND ID=0; -- Sturdy Love Fool bt-text-match
UPDATE world.creature_text SET Sound=57006 WHERE CreatureID=119490 AND GroupID=0 AND ID=2; -- Skycaller Drez'mal bt-text-match
UPDATE world.creature_text SET Sound=28332 WHERE CreatureID=56884 AND GroupID=1 AND ID=0; -- Taran Zhu bt-text-match
UPDATE world.creature_text SET Sound=98462 WHERE CreatureID=134983 AND GroupID=1 AND ID=0; -- Samuel Williams bt-text-match
UPDATE world.creature_text SET Sound=43955 WHERE CreatureID=102194 AND GroupID=0 AND ID=0; -- Dread Crewman bt-text-match
UPDATE world.creature_text SET Sound=98963 WHERE CreatureID=132708 AND GroupID=0 AND ID=0; -- Zeb'ahari Mender bt-text-match
UPDATE world.creature_text SET Sound=66003 WHERE CreatureID=108871 AND GroupID=3 AND ID=0; -- Vineyard Warden bt-text-match
UPDATE world.creature_text SET Sound=65799 WHERE CreatureID=100431 AND GroupID=1 AND ID=0; -- Duskwatch Orbitist bt-text-match
UPDATE world.creature_text SET Sound=46573 WHERE CreatureID=80485 AND GroupID=2 AND ID=0; -- Shani Freezewind bt-text-match
UPDATE world.creature_text SET Sound=77166 WHERE CreatureID=114802 AND GroupID=1 AND ID=0; -- Spectral Journeyman bt-text-match
UPDATE world.creature_text SET Sound=66151 WHERE CreatureID=109409 AND GroupID=0 AND ID=1; -- Nightborne Wretch bt-text-match
UPDATE world.creature_text SET Sound=12007 WHERE CreatureID=34830 AND GroupID=4 AND ID=0; -- Defiant Troll bt-text-match
UPDATE world.creature_text SET Sound=55369 WHERE CreatureID=90317 AND GroupID=3 AND ID=0; -- Jace Darkweaver bt-text-match
UPDATE world.creature_text SET Sound=98458 WHERE CreatureID=137197 AND GroupID=0 AND ID=0; -- Azshj'thul the Drowned bt-text-match
UPDATE world.creature_text SET Sound=34679 WHERE CreatureID=67647 AND GroupID=3 AND ID=0; -- Kor'kron Assassin bt-text-match
UPDATE world.creature_text SET Sound=56982 WHERE CreatureID=117018 AND GroupID=1 AND ID=0; -- Demonic Instructor bt-text-match
UPDATE world.creature_text SET Sound=3434 WHERE CreatureID=38455 AND GroupID=4 AND ID=0; -- Ace bt-text-match
UPDATE world.creature_text SET Sound=83023 WHERE CreatureID=120028 AND GroupID=3 AND ID=0; -- Kirin Tor Mage bt-text-match
UPDATE world.creature_text SET Sound=85239 WHERE CreatureID=115844 AND GroupID=2 AND ID=0; -- Goroth bt-text-match
UPDATE world.creature_text SET Sound=65906 WHERE CreatureID=113849 AND GroupID=0 AND ID=0; -- Duskwatch Saberguard bt-text-match
UPDATE world.creature_text SET Sound=6529 WHERE CreatureID=76862 AND GroupID=0 AND ID=0; -- Gog'rak bt-text-match
UPDATE world.creature_text SET Sound=31957 WHERE CreatureID=82320 AND GroupID=2 AND ID=0; -- Ephial bt-text-match
UPDATE world.creature_text SET Sound=5871 WHERE CreatureID=8440 AND GroupID=1 AND ID=0; -- Shade of Hakkar bt-text-match
UPDATE world.creature_text SET Sound=5805 WHERE CreatureID=7849 AND GroupID=1 AND ID=0; -- Mobile Alert System bt-text-match
UPDATE world.creature_text SET Sound=11819 WHERE CreatureID=79766 AND GroupID=0 AND ID=0; -- Caregiver Felaani bt-text-match
UPDATE world.creature_text SET Sound=44120 WHERE CreatureID=72783 AND GroupID=4 AND ID=0; -- All-Seeing Eye bt-text-match
UPDATE world.creature_text SET Sound=12019 WHERE CreatureID=23574 AND GroupID=6 AND ID=0; -- Akil'zon own-voice-folder
UPDATE world.creature_text SET Sound=10454 WHERE CreatureID=17860 AND GroupID=2 AND ID=0; -- Durnholde Veteran bt-text-match
UPDATE world.creature_text SET Sound=103696 WHERE CreatureID=140801 AND GroupID=0 AND ID=1; -- Forsaken Assassin bt-text-match
UPDATE world.creature_text SET Sound=81239 WHERE CreatureID=94138 AND GroupID=2 AND ID=0; -- Princess Tess Greymane bt-text-match
UPDATE world.creature_text SET Sound=28333 WHERE CreatureID=56884 AND GroupID=2 AND ID=0; -- Taran Zhu bt-text-match
UPDATE world.creature_text SET Sound=65862 WHERE CreatureID=111869 AND GroupID=2 AND ID=0; -- Leyline Hunter bt-text-match
UPDATE world.creature_text SET Sound=98377 WHERE CreatureID=124688 AND GroupID=0 AND ID=0; -- Natha'vor Cannibal bt-text-match
UPDATE world.creature_text SET Sound=9299 WHERE CreatureID=16151 AND GroupID=1 AND ID=2; -- Midnight bt-text-match
UPDATE world.creature_text SET Sound=52234 WHERE CreatureID=115502 AND GroupID=2 AND ID=0; -- Nightborne Rebel bt-text-match
UPDATE world.creature_text SET Sound=68513 WHERE CreatureID=99070 AND GroupID=9 AND ID=0; -- Sashj'tar Diviner bt-text-match
UPDATE world.creature_text SET Sound=88169 WHERE CreatureID=121254 AND GroupID=0 AND ID=0; -- Darkfallen Slave bt-text-match
UPDATE world.creature_text SET Sound=14214 WHERE CreatureID=25301 AND GroupID=3 AND ID=0; -- Counselor Talbot bt-text-match
UPDATE world.creature_text SET Sound=82821 WHERE CreatureID=32451 AND GroupID=3 AND ID=0; -- Dalaran Citizen bt-text-match
UPDATE world.creature_text SET Sound=10246 WHERE CreatureID=16699 AND GroupID=1 AND ID=0; -- Shattered Hand Reaver bt-text-match
UPDATE world.creature_text SET Sound=179682 WHERE CreatureID=177924 AND GroupID=7 AND ID=0; -- Concerned Attendant bt-text-match
UPDATE world.creature_text SET Sound=153444 WHERE CreatureID=164450 AND GroupID=4 AND ID=0; -- Dealer Xy'exa own-voice-folder
UPDATE world.creature_text SET Sound=12007 WHERE CreatureID=34830 AND GroupID=5 AND ID=0; -- Defiant Troll bt-text-match
UPDATE world.creature_text SET Sound=15772 WHERE CreatureID=33134 AND GroupID=0 AND ID=1; -- Sara bt-text-match
UPDATE world.creature_text SET Sound=98459 WHERE CreatureID=137197 AND GroupID=1 AND ID=0; -- Azshj'thul the Drowned bt-text-match
UPDATE world.creature_text SET Sound=29074 WHERE CreatureID=56636 AND GroupID=1 AND ID=0; -- Commander Ri'mok bt-text-match
UPDATE world.creature_text SET Sound=68560 WHERE CreatureID=115785 AND GroupID=8 AND ID=0; -- Direbeak Hatchling bt-text-match
UPDATE world.creature_text SET Sound=58794 WHERE CreatureID=104154 AND GroupID=19 AND ID=0; -- Gul'dan own-voice-folder
UPDATE world.creature_text SET Sound=44873 WHERE CreatureID=82188 AND GroupID=4 AND ID=0; -- Mumper bt-text-match
UPDATE world.creature_text SET Sound=11418 WHERE CreatureID=23418 AND GroupID=2 AND ID=1; -- Essence of Suffering bt-text-match
UPDATE world.creature_text SET Sound=27747 WHERE CreatureID=56843 AND GroupID=7 AND ID=0; -- Lorewalker Stonestep bt-text-match
UPDATE world.creature_text SET Sound=87810 WHERE CreatureID=127892 AND GroupID=1 AND ID=0; -- Ancient Citizen bt-text-match
UPDATE world.creature_text SET Sound=55147 WHERE CreatureID=117973 AND GroupID=0 AND ID=2; -- Firecaller Rok'duun bt-text-match
UPDATE world.creature_text SET Sound=50518 WHERE CreatureID=90409 AND GroupID=11 AND ID=0; -- Gorebound Felcaster bt-text-match
UPDATE world.creature_text SET Sound=40019 WHERE CreatureID=91419 AND GroupID=0 AND ID=0; -- Mr. Shackle bt-text-match
UPDATE world.creature_text SET Sound=67141 WHERE CreatureID=127671 AND GroupID=1 AND ID=0; -- Radix bt-text-match
UPDATE world.creature_text SET Sound=14069 WHERE CreatureID=55564 AND GroupID=3 AND ID=0; -- Reclaimer A'zak bt-text-match
UPDATE world.creature_text SET Sound=15794 WHERE CreatureID=33579 AND GroupID=3 AND ID=0; -- Brann Bronzebeard bt-text-match
UPDATE world.creature_text SET Sound=11421 WHERE CreatureID=23417 AND GroupID=0 AND ID=0; -- Reliquary Combat Trigger bt-text-match
UPDATE world.creature_text SET Sound=103746 WHERE CreatureID=138582 AND GroupID=0 AND ID=0; -- Chief Engineer Grizz bt-text-match
UPDATE world.creature_text SET Sound=12494 WHERE CreatureID=25166 AND GroupID=6 AND ID=0; -- Grand Warlock Alythess own-voice-folder
UPDATE world.creature_text SET Sound=3408 WHERE CreatureID=25211 AND GroupID=3 AND ID=0; -- Cleaver Bmurglbrm bt-text-match
UPDATE world.creature_text SET Sound=37190 WHERE CreatureID=70279 AND GroupID=2 AND ID=0; -- Moira Thaurissan own-voice-folder
UPDATE world.creature_text SET Sound=2992 WHERE CreatureID=72674 AND GroupID=3 AND ID=0; -- Grogal the Harvester bt-text-match
UPDATE world.creature_text SET Sound=416 WHERE CreatureID=25197 AND GroupID=3 AND ID=0; -- King Mrgl-Mrgl bt-text-match
UPDATE world.creature_text SET Sound=46573 WHERE CreatureID=80486 AND GroupID=4 AND ID=0; -- Necrolord Azael bt-text-match
UPDATE world.creature_text SET Sound=68512 WHERE CreatureID=99770 AND GroupID=1 AND ID=0; -- Sashj'tar Deep Witch bt-text-match
UPDATE world.creature_text SET Sound=55191 WHERE CreatureID=90401 AND GroupID=7 AND ID=0; -- Allari the Souleater bt-text-match
UPDATE world.creature_text SET Sound=67213 WHERE CreatureID=117362 AND GroupID=1 AND ID=0; -- Nighthuntress Lexera bt-text-match
UPDATE world.creature_text SET Sound=68513 WHERE CreatureID=101783 AND GroupID=5 AND ID=0; -- Nightborne Siegecaster bt-text-match
UPDATE world.creature_text SET Sound=61236 WHERE CreatureID=113124 AND GroupID=2 AND ID=0; -- Screeching Hag-Sister bt-text-match
UPDATE world.creature_text SET Sound=107262 WHERE CreatureID=142830 AND GroupID=0 AND ID=0; -- Captured Vulpera bt-text-match
UPDATE world.creature_text SET Sound=98367 WHERE CreatureID=124688 AND GroupID=1 AND ID=0; -- Natha'vor Cannibal bt-text-match
UPDATE world.creature_text SET Sound=60134 WHERE CreatureID=103685 AND GroupID=7 AND ID=2; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=82425 WHERE CreatureID=120814 AND GroupID=3 AND ID=0; -- Master Bu bt-text-match
UPDATE world.creature_text SET Sound=19174 WHERE CreatureID=121121 AND GroupID=3 AND ID=0; -- Priestess of Eyir bt-text-match
UPDATE world.creature_text SET Sound=60123 WHERE CreatureID=103685 AND GroupID=1 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=60125 WHERE CreatureID=103685 AND GroupID=4 AND ID=1; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=8036 WHERE CreatureID=12018 AND GroupID=3 AND ID=0; -- Majordomo Executus own-voice-folder
UPDATE world.creature_text SET Sound=20849 WHERE CreatureID=47296 AND GroupID=5 AND ID=0; -- Helix Gearbreaker bt-text-match
UPDATE world.creature_text SET Sound=65802 WHERE CreatureID=100431 AND GroupID=3 AND ID=0; -- Duskwatch Orbitist bt-text-match
UPDATE world.creature_text SET Sound=66488 WHERE CreatureID=108793 AND GroupID=0 AND ID=0; -- Human Archmage bt-text-match
UPDATE world.creature_text SET Sound=43903 WHERE CreatureID=83697 AND GroupID=2 AND ID=0; -- Grom'kar Deckhand bt-text-match
UPDATE world.creature_text SET Sound=65896 WHERE CreatureID=102670 AND GroupID=3 AND ID=0; -- Duskwatch Defender bt-text-match
UPDATE world.creature_text SET Sound=38393 WHERE CreatureID=72248 AND GroupID=4 AND ID=0; -- Warlord Zaela own-voice-folder
UPDATE world.creature_text SET Sound=41813 WHERE CreatureID=79415 AND GroupID=4 AND ID=0; -- Durotan bt-text-match
UPDATE world.creature_text SET Sound=98675 WHERE CreatureID=130822 AND GroupID=0 AND ID=0; -- Zeth'jir Enthraller bt-text-match
UPDATE world.creature_text SET Sound=52726 WHERE CreatureID=90985 AND GroupID=0 AND ID=1; -- Lost Tormenter bt-text-match
UPDATE world.creature_text SET Sound=29068 WHERE CreatureID=66905 AND GroupID=3 AND ID=0; -- Pandaren Cannoneer bt-text-match
UPDATE world.creature_text SET Sound=46219 WHERE CreatureID=74478 AND GroupID=2 AND ID=0; -- Death's Head Shadowmender bt-text-match
UPDATE world.creature_text SET Sound=3580 WHERE CreatureID=56208 AND GroupID=3 AND ID=0; -- Francis the Shepherd Boy bt-text-match
UPDATE world.creature_text SET Sound=12457 WHERE CreatureID=24892 AND GroupID=5 AND ID=0; -- Sathrovarr the Corruptor bt-text-match
UPDATE world.creature_text SET Sound=66003 WHERE CreatureID=112006 AND GroupID=3 AND ID=0; -- Stelleris Vigilant bt-text-match
UPDATE world.creature_text SET Sound=10410 WHERE CreatureID=17862 AND GroupID=2 AND ID=1; -- Captain Skarloc bt-text-match
UPDATE world.creature_text SET Sound=11174 WHERE CreatureID=20977 AND GroupID=3 AND ID=0; -- Millhouse Manastorm own-voice-folder
UPDATE world.creature_text SET Sound=35296 WHERE CreatureID=96483 AND GroupID=3 AND ID=0; -- Jepetto Joybuzz bt-text-match
UPDATE world.creature_text SET Sound=74741 WHERE CreatureID=102100 AND GroupID=0 AND ID=3; -- Skyhorn Pathfinder bt-text-match
UPDATE world.creature_text SET Sound=12492 WHERE CreatureID=25166 AND GroupID=7 AND ID=0; -- Grand Warlock Alythess own-voice-folder
UPDATE world.creature_text SET Sound=17151 WHERE CreatureID=37581 AND GroupID=3 AND ID=0; -- Gorkun Ironskull bt-text-match
UPDATE world.creature_text SET Sound=56970 WHERE CreatureID=92450 AND GroupID=0 AND ID=1; -- Eredar Riftweaver bt-text-match
UPDATE world.creature_text SET Sound=107102 WHERE CreatureID=134162 AND GroupID=0 AND ID=0; -- Julwaba bt-text-match
UPDATE world.creature_text SET Sound=98675 WHERE CreatureID=123453 AND GroupID=0 AND ID=0; -- Vilescale Sorceress bt-text-match
UPDATE world.creature_text SET Sound=61236 WHERE CreatureID=94207 AND GroupID=0 AND ID=0; -- Stoneblood Ravager bt-text-match
UPDATE world.creature_text SET Sound=65893 WHERE CreatureID=102670 AND GroupID=2 AND ID=0; -- Duskwatch Defender bt-text-match
UPDATE world.creature_text SET Sound=38397 WHERE CreatureID=72248 AND GroupID=3 AND ID=0; -- Warlord Zaela own-voice-folder
UPDATE world.creature_text SET Sound=57006 WHERE CreatureID=120704 AND GroupID=0 AND ID=0; -- Annihilan Warden bt-text-match
UPDATE world.creature_text SET Sound=80777 WHERE CreatureID=112005 AND GroupID=4 AND ID=0; -- Stelleris Libertine bt-text-match
UPDATE world.creature_text SET Sound=64828 WHERE CreatureID=99676 AND GroupID=0 AND ID=0; -- Mogu'shan Secret-Keeper bt-text-match
UPDATE world.creature_text SET Sound=98367 WHERE CreatureID=127298 AND GroupID=1 AND ID=0; -- Zardrax the Empowerer bt-text-match
UPDATE world.creature_text SET Sound=82426 WHERE CreatureID=120814 AND GroupID=4 AND ID=0; -- Master Bu bt-text-match
UPDATE world.creature_text SET Sound=60121 WHERE CreatureID=103685 AND GroupID=2 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=61236 WHERE CreatureID=110949 AND GroupID=4 AND ID=0; -- Screeching Harridan bt-text-match
UPDATE world.creature_text SET Sound=18075 WHERE CreatureID=107302 AND GroupID=12 AND ID=0; -- Pearlhunter Phin bt-text-match
UPDATE world.creature_text SET Sound=8353 WHERE CreatureID=73465 AND GroupID=3 AND ID=0; -- Dark Acolyte bt-text-match
UPDATE world.creature_text SET Sound=9322 WHERE CreatureID=15690 AND GroupID=4 AND ID=1; -- Prince Malchezaar bt-text-match
UPDATE world.creature_text SET Sound=98683 WHERE CreatureID=131409 AND GroupID=1 AND ID=0; -- Stranded Battalion Soldier bt-text-match
UPDATE world.creature_text SET Sound=65803 WHERE CreatureID=112489 AND GroupID=3 AND ID=0; -- Callus bt-text-match
UPDATE world.creature_text SET Sound=67109 WHERE CreatureID=93071 AND GroupID=3 AND ID=0; -- Bonespeaker Mystic bt-text-match
UPDATE world.creature_text SET Sound=409 WHERE CreatureID=28658 AND GroupID=2 AND ID=0; -- Gothik the Harvester bt-text-match
UPDATE world.creature_text SET Sound=65896 WHERE CreatureID=102670 AND GroupID=4 AND ID=0; -- Duskwatch Defender bt-text-match
UPDATE world.creature_text SET Sound=53408 WHERE CreatureID=90716 AND GroupID=2 AND ID=0; -- Gelbin Mekkatorque own-voice-folder
UPDATE world.creature_text SET Sound=38399 WHERE CreatureID=72248 AND GroupID=5 AND ID=0; -- Warlord Zaela own-voice-folder
UPDATE world.creature_text SET Sound=20289 WHERE CreatureID=43686 AND GroupID=4 AND ID=0; -- Ignacious bt-text-match
UPDATE world.creature_text SET Sound=45094 WHERE CreatureID=81505 AND GroupID=4 AND ID=0; -- Vol'jin's Pride Grunt bt-text-match
UPDATE world.creature_text SET Sound=108968 WHERE CreatureID=124638 AND GroupID=0 AND ID=0; -- Ashvane Prospector bt-text-match
UPDATE world.creature_text SET Sound=11819 WHERE CreatureID=79758 AND GroupID=3 AND ID=0; -- Caregiver Felaani bt-text-match
UPDATE world.creature_text SET Sound=66336 WHERE CreatureID=110654 AND GroupID=0 AND ID=0; -- Frightened Laborer bt-text-match
UPDATE world.creature_text SET Sound=50483 WHERE CreatureID=91349 AND GroupID=6 AND ID=0; -- Mannoroth bt-text-match
UPDATE world.creature_text SET Sound=3684 WHERE CreatureID=88911 AND GroupID=3 AND ID=0; -- Bilgerudder bt-text-match
UPDATE world.creature_text SET Sound=82280 WHERE CreatureID=116497 AND GroupID=6 AND ID=0; -- Torvald own-voice-folder
UPDATE world.creature_text SET Sound=46818 WHERE CreatureID=83954 AND GroupID=1 AND ID=0; -- Nagrand Skirmisher bt-text-match
UPDATE world.creature_text SET Sound=52145 WHERE CreatureID=93111 AND GroupID=0 AND ID=1; -- Darkfiend Defiler bt-text-match
UPDATE world.creature_text SET Sound=98373 WHERE CreatureID=127224 AND GroupID=0 AND ID=0; -- Empowered Worshipper bt-text-match
UPDATE world.creature_text SET Sound=10311 WHERE CreatureID=16809 AND GroupID=0 AND ID=0; -- Warbringer O'mrogg own-voice-folder
UPDATE world.creature_text SET Sound=15804 WHERE CreatureID=34054 AND GroupID=0 AND ID=0; -- Bronzebeard Radio bt-text-match
UPDATE world.creature_text SET Sound=67683 WHERE CreatureID=106656 AND GroupID=0 AND ID=0; -- Seeker of Wisdom bt-text-match
UPDATE world.creature_text SET Sound=66756 WHERE CreatureID=106072 AND GroupID=3 AND ID=0; -- Sylendra Gladesong bt-text-match
UPDATE world.creature_text SET Sound=45661 WHERE CreatureID=81152 AND GroupID=3 AND ID=0; -- Scout Valdez bt-text-match
UPDATE world.creature_text SET Sound=43876 WHERE CreatureID=78529 AND GroupID=0 AND ID=0; -- Frostwolf Slave bt-text-match
UPDATE world.creature_text SET Sound=50825 WHERE CreatureID=93931 AND GroupID=1 AND ID=0; -- Gorebound Felcaster bt-text-match
UPDATE world.creature_text SET Sound=107261 WHERE CreatureID=142854 AND GroupID=0 AND ID=0; -- Captured Vulpera bt-text-match
UPDATE world.creature_text SET Sound=43672 WHERE CreatureID=75358 AND GroupID=4 AND ID=0; -- Arnokk the Burner bt-text-match
UPDATE world.creature_text SET Sound=46401 WHERE CreatureID=82005 AND GroupID=3 AND ID=0; -- Challe Tebrilinde bt-text-match
UPDATE world.creature_text SET Sound=68512 WHERE CreatureID=102828 AND GroupID=1 AND ID=0; -- Sashj'tar Sandcrusher bt-text-match
UPDATE world.creature_text SET Sound=98369 WHERE CreatureID=127385 AND GroupID=0 AND ID=0; -- Image of Zardrax the Empowerer bt-text-match
UPDATE world.creature_text SET Sound=52077 WHERE CreatureID=95727 AND GroupID=0 AND ID=0; -- Darkfiend Corruptor bt-text-match
UPDATE world.creature_text SET Sound=61249 WHERE CreatureID=95123 AND GroupID=1 AND ID=0; -- Grelda the Hag bt-text-match
UPDATE world.creature_text SET Sound=87170 WHERE CreatureID=120604 AND GroupID=3 AND ID=0; -- Zealous Echo bt-text-match
UPDATE world.creature_text SET Sound=52078 WHERE CreatureID=95727 AND GroupID=0 AND ID=4; -- Darkfiend Corruptor bt-text-match
UPDATE world.creature_text SET Sound=15750 WHERE CreatureID=33242 AND GroupID=3 AND ID=0; -- Thorim own-voice-folder
UPDATE world.creature_text SET Sound=68493 WHERE CreatureID=111514 AND GroupID=1 AND ID=0; -- Alonsus Faol own-voice-folder
UPDATE world.creature_text SET Sound=12378 WHERE CreatureID=24689 AND GroupID=0 AND ID=0; -- Wretched Bruiser bt-text-match
UPDATE world.creature_text SET Sound=52292 WHERE CreatureID=94046 AND GroupID=5 AND ID=0; -- Risen Assassin bt-text-match
UPDATE world.creature_text SET Sound=11419 WHERE CreatureID=23418 AND GroupID=2 AND ID=2; -- Essence of Suffering bt-text-match
UPDATE world.creature_text SET Sound=65802 WHERE CreatureID=105759 AND GroupID=0 AND ID=0; -- High Mage of the Duskwatch bt-text-match
UPDATE world.creature_text SET Sound=1044 WHERE CreatureID=41302 AND GroupID=3 AND ID=0; -- Galak Mauler bt-text-match
UPDATE world.creature_text SET Sound=82688 WHERE CreatureID=116361 AND GroupID=1 AND ID=0; -- Silver Hand Recruit bt-text-match
UPDATE world.creature_text SET Sound=81715 WHERE CreatureID=119923 AND GroupID=1 AND ID=0; -- Helblaze Soulmender bt-text-match
UPDATE world.creature_text SET Sound=12456 WHERE CreatureID=24892 AND GroupID=4 AND ID=1; -- Sathrovarr the Corruptor bt-text-match
UPDATE world.creature_text SET Sound=98965 WHERE CreatureID=122903 AND GroupID=0 AND ID=0; -- Torcalin Cleric bt-text-match
UPDATE world.creature_text SET Sound=61862 WHERE CreatureID=100452 AND GroupID=3 AND ID=0; -- Dark Ranger Velonara bt-text-match
UPDATE world.creature_text SET Sound=55372 WHERE CreatureID=126199 AND GroupID=1 AND ID=0; -- Vrax'thul bt-text-match
UPDATE world.creature_text SET Sound=44400 WHERE CreatureID=76809 AND GroupID=5 AND ID=0; -- Foreman Feldspar bt-text-match
UPDATE world.creature_text SET Sound=88169 WHERE CreatureID=121246 AND GroupID=3 AND ID=0; -- Darkfallen Slave bt-text-match
UPDATE world.creature_text SET Sound=69825 WHERE CreatureID=107350 AND GroupID=1 AND ID=0; -- Cyrille bt-text-match
UPDATE world.creature_text SET Sound=11135 WHERE CreatureID=18805 AND GroupID=4 AND ID=0; -- High Astromancer Solarian own-voice-folder
UPDATE world.creature_text SET Sound=28334 WHERE CreatureID=56884 AND GroupID=0 AND ID=0; -- Taran Zhu bt-text-match
UPDATE world.creature_text SET Sound=71090 WHERE CreatureID=111307 AND GroupID=1 AND ID=0; -- Master Mathias Shaw bt-text-match
UPDATE world.creature_text SET Sound=12378 WHERE CreatureID=24690 AND GroupID=1 AND ID=0; -- Wretched Husk bt-text-match
UPDATE world.creature_text SET Sound=14428 WHERE CreatureID=29621 AND GroupID=5 AND ID=0; -- Grand Admiral Westwind bt-text-match
UPDATE world.creature_text SET Sound=12007 WHERE CreatureID=34830 AND GroupID=3 AND ID=0; -- Defiant Troll bt-text-match
UPDATE world.creature_text SET Sound=54822 WHERE CreatureID=96615 AND GroupID=3 AND ID=0; -- Feltotem Demonkindre bt-text-match
UPDATE world.creature_text SET Sound=60135 WHERE CreatureID=103685 AND GroupID=9 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=68513 WHERE CreatureID=102841 AND GroupID=0 AND ID=0; -- Commander Malt'his bt-text-match
UPDATE world.creature_text SET Sound=6528 WHERE CreatureID=75336 AND GroupID=0 AND ID=0; -- Outcast Shadeweaver bt-text-match
UPDATE world.creature_text SET Sound=44860 WHERE CreatureID=82263 AND GroupID=4 AND ID=0; -- Agios Lumen bt-text-match
UPDATE world.creature_text SET Sound=8660 WHERE CreatureID=15276 AND GroupID=2 AND ID=0; -- Emperor Vek'lor bt-text-match
UPDATE world.creature_text SET Sound=38136 WHERE CreatureID=73330 AND GroupID=14 AND ID=0; -- Lorewalker Cho own-voice-folder
UPDATE world.creature_text SET Sound=8606 WHERE CreatureID=15341 AND GroupID=8 AND ID=0; -- General Rajaxx own-voice-folder
UPDATE world.creature_text SET Sound=3684 WHERE CreatureID=89072 AND GroupID=3 AND ID=0; -- Bilgerudder bt-text-match
UPDATE world.creature_text SET Sound=13225 WHERE CreatureID=23953 AND GroupID=5 AND ID=0; -- Prince Keleseth own-voice-folder
UPDATE world.creature_text SET Sound=67684 WHERE CreatureID=106656 AND GroupID=2 AND ID=0; -- Seeker of Wisdom bt-text-match
UPDATE world.creature_text SET Sound=15807 WHERE CreatureID=33579 AND GroupID=1 AND ID=0; -- Brann Bronzebeard bt-text-match
UPDATE world.creature_text SET Sound=11967 WHERE CreatureID=23543 AND GroupID=0 AND ID=0; -- Shade of the Horseman bt-text-match
UPDATE world.creature_text SET Sound=55370 WHERE CreatureID=115697 AND GroupID=0 AND ID=0; -- Desperate Refugee bt-text-match
UPDATE world.creature_text SET Sound=56982 WHERE CreatureID=92450 AND GroupID=0 AND ID=2; -- Eredar Riftweaver bt-text-match
UPDATE world.creature_text SET Sound=153436 WHERE CreatureID=164450 AND GroupID=1 AND ID=0; -- Dealer Xy'exa own-voice-folder
UPDATE world.creature_text SET Sound=65820 WHERE CreatureID=113738 AND GroupID=1 AND ID=0; -- Duskwatch Moonmage bt-text-match
UPDATE world.creature_text SET Sound=56973 WHERE CreatureID=109403 AND GroupID=0 AND ID=0; -- Niskaran Doombringer bt-text-match
UPDATE world.creature_text SET Sound=71091 WHERE CreatureID=111307 AND GroupID=2 AND ID=0; -- Master Mathias Shaw bt-text-match
UPDATE world.creature_text SET Sound=104248 WHERE CreatureID=130078 AND GroupID=3 AND ID=0; -- Captured Farmer bt-text-match
UPDATE world.creature_text SET Sound=11227 WHERE CreatureID=20909 AND GroupID=1 AND ID=0; -- Sulfuron Magma-Thrower bt-text-match
UPDATE world.creature_text SET Sound=61244 WHERE CreatureID=98306 AND GroupID=1 AND ID=0; -- Cliffclutch Screecher bt-text-match
UPDATE world.creature_text SET Sound=98671 WHERE CreatureID=130824 AND GroupID=0 AND ID=0; -- Zeth'jir Seacaller bt-text-match
UPDATE world.creature_text SET Sound=20847 WHERE CreatureID=47296 AND GroupID=3 AND ID=0; -- Helix Gearbreaker bt-text-match
UPDATE world.creature_text SET Sound=725 WHERE CreatureID=23177 AND GroupID=3 AND ID=0; -- Tarren Mill Lookout bt-text-match
UPDATE world.creature_text SET Sound=61693 WHERE CreatureID=112717 AND GroupID=3 AND ID=0; -- Ginger Blockgear bt-text-match
UPDATE world.creature_text SET Sound=14429 WHERE CreatureID=29621 AND GroupID=6 AND ID=0; -- Grand Admiral Westwind bt-text-match
UPDATE world.creature_text SET Sound=52488 WHERE CreatureID=111393 AND GroupID=1 AND ID=0; -- Deathcaller Mystic bt-text-match
UPDATE world.creature_text SET Sound=45013 WHERE CreatureID=77915 AND GroupID=3 AND ID=0; -- Throm'var Villager bt-text-match
UPDATE world.creature_text SET Sound=43903 WHERE CreatureID=83697 AND GroupID=0 AND ID=0; -- Grom'kar Deckhand bt-text-match
UPDATE world.creature_text SET Sound=8041 WHERE CreatureID=12018 AND GroupID=6 AND ID=0; -- Majordomo Executus own-voice-folder
UPDATE world.creature_text SET Sound=65819 WHERE CreatureID=114868 AND GroupID=3 AND ID=0; -- Felborne Enforcer bt-text-match
UPDATE world.creature_text SET Sound=20166 WHERE CreatureID=43687 AND GroupID=4 AND ID=0; -- Feludius bt-text-match
UPDATE world.creature_text SET Sound=9174 WHERE CreatureID=16812 AND GroupID=0 AND ID=0; -- Barnes own-voice-folder
UPDATE world.creature_text SET Sound=52903 WHERE CreatureID=108339 AND GroupID=1 AND ID=0; -- Ancient Flamecaller bt-text-match
UPDATE world.creature_text SET Sound=21846 WHERE CreatureID=43689 AND GroupID=4 AND ID=0; -- Terrastra bt-text-match
UPDATE world.creature_text SET Sound=57007 WHERE CreatureID=123658 AND GroupID=1 AND ID=0; -- Highguard Captain bt-text-match
UPDATE world.creature_text SET Sound=14212 WHERE CreatureID=25301 AND GroupID=1 AND ID=0; -- Counselor Talbot bt-text-match
UPDATE world.creature_text SET Sound=153435 WHERE CreatureID=164450 AND GroupID=2 AND ID=0; -- Dealer Xy'exa own-voice-folder
UPDATE world.creature_text SET Sound=45511 WHERE CreatureID=80833 AND GroupID=3 AND ID=0; -- Beastmaster Tagh bt-text-match
UPDATE world.creature_text SET Sound=47208 WHERE CreatureID=91755 AND GroupID=3 AND ID=0; -- Orgrimmar Soldier bt-text-match
UPDATE world.creature_text SET Sound=82424 WHERE CreatureID=120814 AND GroupID=2 AND ID=0; -- Master Bu bt-text-match
UPDATE world.creature_text SET Sound=57341 WHERE CreatureID=97346 AND GroupID=3 AND ID=0; -- Sira Moonwarden bt-text-match
UPDATE world.creature_text SET Sound=82688 WHERE CreatureID=115883 AND GroupID=2 AND ID=0; -- Corrine the Devout bt-text-match
UPDATE world.creature_text SET Sound=131775 WHERE CreatureID=167425 AND GroupID=2 AND ID=0; -- Overseer Kah-Delen bt-text-match
UPDATE world.creature_text SET Sound=74741 WHERE CreatureID=102100 AND GroupID=0 AND ID=0; -- Skyhorn Pathfinder bt-text-match
UPDATE world.creature_text SET Sound=20241 WHERE CreatureID=43688 AND GroupID=4 AND ID=0; -- Arion bt-text-match
UPDATE world.creature_text SET Sound=43550 WHERE CreatureID=74979 AND GroupID=1 AND ID=0; -- Frightened Prisoner bt-text-match
UPDATE world.creature_text SET Sound=20848 WHERE CreatureID=47296 AND GroupID=4 AND ID=0; -- Helix Gearbreaker own-voice-folder
UPDATE world.creature_text SET Sound=52072 WHERE CreatureID=95727 AND GroupID=0 AND ID=5; -- Darkfiend Corruptor bt-text-match
UPDATE world.creature_text SET Sound=60122 WHERE CreatureID=103685 AND GroupID=5 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=10449 WHERE CreatureID=18094 AND GroupID=0 AND ID=0; -- Tarren Mill Lookout bt-text-match
UPDATE world.creature_text SET Sound=60132 WHERE CreatureID=103685 AND GroupID=8 AND ID=1; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=60608 WHERE CreatureID=60968 AND GroupID=11 AND ID=0; -- Xuen bt-text-match
UPDATE world.creature_text SET Sound=97839 WHERE CreatureID=134472 AND GroupID=0 AND ID=0; -- Coven Hexcaller bt-text-match
UPDATE world.creature_text SET Sound=17671 WHERE CreatureID=72967 AND GroupID=4 AND ID=0; -- Guttra Wolfchew bt-text-match
UPDATE world.creature_text SET Sound=74741 WHERE CreatureID=102100 AND GroupID=0 AND ID=4; -- Skyhorn Pathfinder bt-text-match
UPDATE world.creature_text SET Sound=65819 WHERE CreatureID=105759 AND GroupID=0 AND ID=1; -- High Mage of the Duskwatch bt-text-match
UPDATE world.creature_text SET Sound=52495 WHERE CreatureID=111328 AND GroupID=1 AND ID=0; -- Helarjar Soulhunter bt-text-match
UPDATE world.creature_text SET Sound=65771 WHERE CreatureID=114470 AND GroupID=0 AND ID=0; -- Duskwatch Orbitist bt-text-match
UPDATE world.creature_text SET Sound=65802 WHERE CreatureID=109670 AND GroupID=3 AND ID=0; -- Chronarch Defender bt-text-match
UPDATE world.creature_text SET Sound=44807 WHERE CreatureID=81654 AND GroupID=3 AND ID=0; -- Garrison Laborer bt-text-match
UPDATE world.creature_text SET Sound=1044 WHERE CreatureID=41204 AND GroupID=3 AND ID=0; -- Khan Ablinh bt-text-match
UPDATE world.creature_text SET Sound=11178 WHERE CreatureID=20908 AND GroupID=2 AND ID=0; -- Akkiris Lightning-Waker bt-text-match
UPDATE world.creature_text SET Sound=43903 WHERE CreatureID=81432 AND GroupID=0 AND ID=0; -- Grom'kar Technician bt-text-match
UPDATE world.creature_text SET Sound=82423 WHERE CreatureID=120814 AND GroupID=1 AND ID=0; -- Master Bu bt-text-match
UPDATE world.creature_text SET Sound=69514 WHERE CreatureID=110861 AND GroupID=1 AND ID=0; -- Vaultwarden Umbra bt-text-match
UPDATE world.creature_text SET Sound=14213 WHERE CreatureID=25301 AND GroupID=2 AND ID=0; -- Counselor Talbot bt-text-match
UPDATE world.creature_text SET Sound=51732 WHERE CreatureID=91571 AND GroupID=1 AND ID=0; -- Thane Wildsky bt-text-match
UPDATE world.creature_text SET Sound=56982 WHERE CreatureID=125158 AND GroupID=1 AND ID=0; -- Talgathi Portal Keeper bt-text-match
UPDATE world.creature_text SET Sound=179681 WHERE CreatureID=177924 AND GroupID=6 AND ID=0; -- Concerned Attendant bt-text-match
UPDATE world.creature_text SET Sound=65817 WHERE CreatureID=102670 AND GroupID=1 AND ID=0; -- Duskwatch Defender bt-text-match
UPDATE world.creature_text SET Sound=67683 WHERE CreatureID=106516 AND GroupID=1 AND ID=0; -- Empyrean Astrologer bt-text-match
UPDATE world.creature_text SET Sound=38395 WHERE CreatureID=72248 AND GroupID=2 AND ID=0; -- Warlord Zaela own-voice-folder
UPDATE world.creature_text SET Sound=65857 WHERE CreatureID=101784 AND GroupID=2 AND ID=0; -- Nightborne Infiltrator bt-text-match
UPDATE world.creature_text SET Sound=66003 WHERE CreatureID=112531 AND GroupID=3 AND ID=0; -- Leleyna bt-text-match
UPDATE world.creature_text SET Sound=51704 WHERE CreatureID=115291 AND GroupID=0 AND ID=0; -- Helarjar Soulthief bt-text-match
UPDATE world.creature_text SET Sound=41809 WHERE CreatureID=74329 AND GroupID=3 AND ID=0; -- Thunderlord Invader bt-text-match
UPDATE world.creature_text SET Sound=19697 WHERE CreatureID=38768 AND GroupID=3 AND ID=0; -- Lorna Crowley bt-text-match
UPDATE world.creature_text SET Sound=68461 WHERE CreatureID=102496 AND GroupID=3 AND ID=0; -- Shal'dorei Servant bt-text-match
UPDATE world.creature_text SET Sound=60126 WHERE CreatureID=103685 AND GroupID=6 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=25873 WHERE CreatureID=54548 AND GroupID=1 AND ID=0; -- Thrall own-voice-folder
UPDATE world.creature_text SET Sound=10440 WHERE CreatureID=15608 AND GroupID=6 AND ID=0; -- Medivh own-voice-folder
UPDATE world.creature_text SET Sound=56997 WHERE CreatureID=120852 AND GroupID=1 AND ID=0; -- Doomsworn Harbinger bt-text-match
UPDATE world.creature_text SET Sound=107772 WHERE CreatureID=138228 AND GroupID=0 AND ID=0; -- Vulpera Kid bt-text-match
UPDATE world.creature_text SET Sound=12070 WHERE CreatureID=23576 AND GroupID=4 AND ID=0; -- Nalorakk own-voice-folder
UPDATE world.creature_text SET Sound=30411 WHERE CreatureID=56572 AND GroupID=3 AND ID=0; -- Li Li bt-text-match
UPDATE world.creature_text SET Sound=98369 WHERE CreatureID=128267 AND GroupID=0 AND ID=0; -- Crawg Rider bt-text-match
UPDATE world.creature_text SET Sound=60131 WHERE CreatureID=103685 AND GroupID=0 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=66005 WHERE CreatureID=111992 AND GroupID=3 AND ID=0; -- Stelleris Vigilant bt-text-match
UPDATE world.creature_text SET Sound=57006 WHERE CreatureID=118135 AND GroupID=0 AND ID=0; -- Rakeeshi Honor Guard bt-text-match
UPDATE world.creature_text SET Sound=51704 WHERE CreatureID=91575 AND GroupID=3 AND ID=0; -- Kvaldir Soulflayer bt-text-match
UPDATE world.creature_text SET Sound=56973 WHERE CreatureID=109403 AND GroupID=0 AND ID=1; -- Niskaran Doombringer bt-text-match
UPDATE world.creature_text SET Sound=15559 WHERE CreatureID=33213 AND GroupID=3 AND ID=0; -- Hodir own-voice-folder
UPDATE world.creature_text SET Sound=8849 WHERE CreatureID=28919 AND GroupID=3 AND ID=0; -- Noth the Plaguebringer bt-text-match
UPDATE world.creature_text SET Sound=4415 WHERE CreatureID=88696 AND GroupID=3 AND ID=0; -- Officer Rumsfeld bt-text-match
UPDATE world.creature_text SET Sound=98463 WHERE CreatureID=134983 AND GroupID=3 AND ID=0; -- Samuel Williams bt-text-match
UPDATE world.creature_text SET Sound=19174 WHERE CreatureID=94346 AND GroupID=3 AND ID=0; -- Ensign Ward bt-text-match
UPDATE world.creature_text SET Sound=10408 WHERE CreatureID=17862 AND GroupID=1 AND ID=1; -- Captain Skarloc bt-text-match
UPDATE world.creature_text SET Sound=24571 WHERE CreatureID=53691 AND GroupID=3 AND ID=1; -- Shannox bt-text-match
UPDATE world.creature_text SET Sound=11173 WHERE CreatureID=20977 AND GroupID=2 AND ID=0; -- Millhouse Manastorm own-voice-folder
UPDATE world.creature_text SET Sound=101799 WHERE CreatureID=127935 AND GroupID=1 AND ID=0; -- Summoner Yarz bt-text-match
UPDATE world.creature_text SET Sound=10283 WHERE CreatureID=17308 AND GroupID=5 AND ID=0; -- Omor the Unscarred own-voice-folder
UPDATE world.creature_text SET Sound=60133 WHERE CreatureID=103685 AND GroupID=7 AND ID=0; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=187953 WHERE CreatureID=181057 AND GroupID=0 AND ID=0; -- Echo of Argus own-voice-folder
UPDATE world.creature_text SET Sound=65866 WHERE CreatureID=110679 AND GroupID=1 AND ID=0; -- Aurore bt-text-match
UPDATE world.creature_text SET Sound=65907 WHERE CreatureID=111485 AND GroupID=0 AND ID=0; -- Duskwatch Spellshield bt-text-match
UPDATE world.creature_text SET Sound=66046 WHERE CreatureID=108004 AND GroupID=1 AND ID=0; -- Haunting Protector bt-text-match
UPDATE world.creature_text SET Sound=12007 WHERE CreatureID=34830 AND GroupID=6 AND ID=0; -- Defiant Troll bt-text-match
UPDATE world.creature_text SET Sound=2991 WHERE CreatureID=72785 AND GroupID=3 AND ID=0; -- Twisted Ancient bt-text-match
UPDATE world.creature_text SET Sound=4415 WHERE CreatureID=108628 AND GroupID=3 AND ID=0; -- Armond Thaco bt-text-match
UPDATE world.creature_text SET Sound=11228 WHERE CreatureID=20911 AND GroupID=1 AND ID=0; -- Blackwing Drakonaar bt-text-match
UPDATE world.creature_text SET Sound=9318 WHERE CreatureID=15690 AND GroupID=3 AND ID=1; -- Prince Malchezaar bt-text-match
UPDATE world.creature_text SET Sound=52901 WHERE CreatureID=89117 AND GroupID=3 AND ID=0; -- Warlord Parjesh own-voice-folder
UPDATE world.creature_text SET Sound=10187 WHERE CreatureID=16700 AND GroupID=3 AND ID=0; -- Shattered Hand Legionnaire bt-text-match
UPDATE world.creature_text SET Sound=57400 WHERE CreatureID=86535 AND GroupID=2 AND ID=0; -- Overseer Lykill bt-text-match
UPDATE world.creature_text SET Sound=50419 WHERE CreatureID=90378 AND GroupID=0 AND ID=0; -- Kilrogg Deadeye bt-text-match
UPDATE world.creature_text SET Sound=74741 WHERE CreatureID=102100 AND GroupID=0 AND ID=1; -- Skyhorn Pathfinder bt-text-match
UPDATE world.creature_text SET Sound=14427 WHERE CreatureID=29621 AND GroupID=4 AND ID=0; -- Grand Admiral Westwind bt-text-match
UPDATE world.creature_text SET Sound=45391 WHERE CreatureID=79799 AND GroupID=3 AND ID=0; -- Draenei Refugee bt-text-match
UPDATE world.creature_text SET Sound=14345 WHERE CreatureID=30385 AND GroupID=3 AND ID=0; -- Twilight Volunteer bt-text-match
UPDATE world.creature_text SET Sound=8038 WHERE CreatureID=12018 AND GroupID=4 AND ID=0; -- Majordomo Executus own-voice-folder
UPDATE world.creature_text SET Sound=30541 WHERE CreatureID=116823 AND GroupID=3 AND ID=0; -- Shadowdirge Soul Reaper bt-text-match
UPDATE world.creature_text SET Sound=60555 WHERE CreatureID=96527 AND GroupID=2 AND ID=0; -- Thrall own-voice-folder
UPDATE world.creature_text SET Sound=74741 WHERE CreatureID=102100 AND GroupID=0 AND ID=5; -- Skyhorn Pathfinder bt-text-match
UPDATE world.creature_text SET Sound=65910 WHERE CreatureID=111485 AND GroupID=1 AND ID=0; -- Duskwatch Spellshield bt-text-match
UPDATE world.creature_text SET Sound=8475 WHERE CreatureID=25201 AND GroupID=3 AND ID=0; -- Winterfin Tadpole bt-text-match
UPDATE world.creature_text SET Sound=13211 WHERE CreatureID=23954 AND GroupID=3 AND ID=0; -- Ingvar the Plunderer own-voice-folder
UPDATE world.creature_text SET Sound=45094 WHERE CreatureID=81428 AND GroupID=4 AND ID=0; -- Fort Wrynn Footman bt-text-match
UPDATE world.creature_text SET Sound=77637 WHERE CreatureID=92539 AND GroupID=9 AND ID=0; -- Havi bt-text-match
UPDATE world.creature_text SET Sound=78625 WHERE CreatureID=115079 AND GroupID=0 AND ID=0; -- Victoire bt-text-match
UPDATE world.creature_text SET Sound=57005 WHERE CreatureID=116281 AND GroupID=1 AND ID=0; -- Doomsworn Harbinger bt-text-match
UPDATE world.creature_text SET Sound=153638 WHERE CreatureID=166451 AND GroupID=0 AND ID=0; -- Forsworn Swiftblade bt-text-match
UPDATE world.creature_text SET Sound=87973 WHERE CreatureID=127085 AND GroupID=3 AND ID=0; -- Talgath bt-text-match
UPDATE world.creature_text SET Sound=50420 WHERE CreatureID=90378 AND GroupID=7 AND ID=0; -- Kilrogg Deadeye bt-text-match
UPDATE world.creature_text SET Sound=51704 WHERE CreatureID=105526 AND GroupID=4 AND ID=0; -- Helmouth Soulflayer bt-text-match
UPDATE world.creature_text SET Sound=52234 WHERE CreatureID=115507 AND GroupID=1 AND ID=0; -- Nightfallen Rebel bt-text-match
UPDATE world.creature_text SET Sound=20844 WHERE CreatureID=47296 AND GroupID=0 AND ID=0; -- Helix Gearbreaker bt-text-match
UPDATE world.creature_text SET Sound=53237 WHERE CreatureID=98975 AND GroupID=0 AND ID=0; -- Doomherald Ak'vesh bt-text-match
UPDATE world.creature_text SET Sound=29469 WHERE CreatureID=64563 AND GroupID=3 AND ID=0; -- Talking Skull bt-text-match
UPDATE world.creature_text SET Sound=52291 WHERE CreatureID=94046 AND GroupID=4 AND ID=0; -- Risen Assassin bt-text-match
UPDATE world.creature_text SET Sound=45972 WHERE CreatureID=84225 AND GroupID=0 AND ID=0; -- Proximity Alarm-o-Bot 2000 bt-text-match
UPDATE world.creature_text SET Sound=45759 WHERE CreatureID=76039 AND GroupID=1 AND ID=0; -- Twilight Aquamancer bt-text-match
UPDATE world.creature_text SET Sound=81716 WHERE CreatureID=118690 AND GroupID=1 AND ID=0; -- Wrathguard Invader bt-text-match
UPDATE world.creature_text SET Sound=15774 WHERE CreatureID=33134 AND GroupID=1 AND ID=1; -- Sara bt-text-match
UPDATE world.creature_text SET Sound=43955 WHERE CreatureID=102192 AND GroupID=0 AND ID=0; -- Dread Sharpshooter bt-text-match
UPDATE world.creature_text SET Sound=37730 WHERE CreatureID=76289 AND GroupID=1 AND ID=0; -- Thunderlord Ranger bt-text-match
UPDATE world.creature_text SET Sound=41946 WHERE CreatureID=75114 AND GroupID=3 AND ID=0; -- Razorfen Kraulshaper bt-text-match
UPDATE world.creature_text SET Sound=20846 WHERE CreatureID=47296 AND GroupID=2 AND ID=0; -- Helix Gearbreaker bt-text-match
UPDATE world.creature_text SET Sound=98680 WHERE CreatureID=123539 AND GroupID=0 AND ID=0; -- Injured Sailor bt-text-match
UPDATE world.creature_text SET Sound=12484 WHERE CreatureID=25165 AND GroupID=0 AND ID=0; -- Lady Sacrolash own-voice-folder
UPDATE world.creature_text SET Sound=98464 WHERE CreatureID=134983 AND GroupID=5 AND ID=0; -- Samuel Williams bt-text-match
UPDATE world.creature_text SET Sound=66279 WHERE CreatureID=108931 AND GroupID=1 AND ID=0; -- Vineyard Laborer bt-text-match
UPDATE world.creature_text SET Sound=60128 WHERE CreatureID=103685 AND GroupID=6 AND ID=1; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=9298 WHERE CreatureID=16151 AND GroupID=1 AND ID=1; -- Midnight bt-text-match
UPDATE world.creature_text SET Sound=41809 WHERE CreatureID=78533 AND GroupID=4 AND ID=0; -- Wor'gol Defender bt-text-match
UPDATE world.creature_text SET Sound=86717 WHERE CreatureID=120764 AND GroupID=1 AND ID=1; -- Echo of Khazaduum bt-text-match
UPDATE world.creature_text SET Sound=68513 WHERE CreatureID=89350 AND GroupID=4 AND ID=0; -- Oublion bt-text-match
UPDATE world.creature_text SET Sound=18240 WHERE CreatureID=72783 AND GroupID=1 AND ID=0; -- All-Seeing Eye bt-text-match
UPDATE world.creature_text SET Sound=15779 WHERE CreatureID=33134 AND GroupID=3 AND ID=1; -- Sara bt-text-match
UPDATE world.creature_text SET Sound=52342 WHERE CreatureID=95727 AND GroupID=0 AND ID=2; -- Darkfiend Corruptor bt-text-match
UPDATE world.creature_text SET Sound=56847 WHERE CreatureID=90401 AND GroupID=3 AND ID=0; -- Allari the Souleater bt-text-match
UPDATE world.creature_text SET Sound=12104 WHERE CreatureID=23597 AND GroupID=3 AND ID=0; -- Amani'shi Guardian bt-text-match
UPDATE world.creature_text SET Sound=20845 WHERE CreatureID=47296 AND GroupID=1 AND ID=0; -- Helix Gearbreaker bt-text-match
UPDATE world.creature_text SET Sound=98371 WHERE CreatureID=124688 AND GroupID=2 AND ID=0; -- Natha'vor Cannibal bt-text-match
UPDATE world.creature_text SET Sound=44862 WHERE CreatureID=78559 AND GroupID=0 AND ID=0; -- Archmage Khadgar own-voice-folder
UPDATE world.creature_text SET Sound=12488 WHERE CreatureID=25165 AND GroupID=7 AND ID=0; -- Lady Sacrolash own-voice-folder
UPDATE world.creature_text SET Sound=44094 WHERE CreatureID=76669 AND GroupID=4 AND ID=0; -- Durotan bt-text-match
UPDATE world.creature_text SET Sound=82370 WHERE CreatureID=118447 AND GroupID=1 AND ID=0; -- Commander Jarod Shadowsong bt-text-match
UPDATE world.creature_text SET Sound=38391 WHERE CreatureID=72248 AND GroupID=0 AND ID=0; -- Warlord Zaela own-voice-folder
UPDATE world.creature_text SET Sound=86795 WHERE CreatureID=126492 AND GroupID=1 AND ID=0; -- Netherguard Adept bt-text-match
UPDATE world.creature_text SET Sound=1108 WHERE CreatureID=72955 AND GroupID=4 AND ID=0; -- Grimfrost Drudge bt-text-match
UPDATE world.creature_text SET Sound=12007 WHERE CreatureID=34830 AND GroupID=7 AND ID=0; -- Defiant Troll bt-text-match
UPDATE world.creature_text SET Sound=15777 WHERE CreatureID=33134 AND GroupID=2 AND ID=1; -- Sara bt-text-match
UPDATE world.creature_text SET Sound=81679 WHERE CreatureID=115852 AND GroupID=0 AND ID=0; -- Morta the Wretch bt-text-match
UPDATE world.creature_text SET Sound=414 WHERE CreatureID=28375 AND GroupID=3 AND ID=0; -- Glrglrglr bt-text-match
UPDATE world.creature_text SET Sound=60130 WHERE CreatureID=103685 AND GroupID=7 AND ID=1; -- Tichondrius bt-text-match
UPDATE world.creature_text SET Sound=72571 WHERE CreatureID=97193 AND GroupID=0 AND ID=0; -- Apprentice Warlock bt-text-match
UPDATE world.creature_text SET Sound=10360 WHERE CreatureID=17797 AND GroupID=0 AND ID=0; -- Hydromancer Thespia own-voice-folder
UPDATE world.creature_text SET Sound=31787 WHERE CreatureID=56701 AND GroupID=0 AND ID=0; -- Pearlfin Poolwatcher bt-text-match
UPDATE world.creature_text SET Sound=98678 WHERE CreatureID=125392 AND GroupID=0 AND ID=0; -- Vilescale Mana Taster bt-text-match
UPDATE world.creature_text SET Sound=103862 WHERE CreatureID=132230 AND GroupID=1 AND ID=0; -- Warmother Molaka bt-text-match
UPDATE world.creature_text SET Sound=61244 WHERE CreatureID=95138 AND GroupID=1 AND ID=0; -- Wormtalon Witch bt-text-match
UPDATE world.creature_text SET Sound=98329 WHERE CreatureID=120606 AND GroupID=0 AND ID=0; -- Blood Troll Hexxer bt-text-match
UPDATE world.creature_text SET Sound=10285 WHERE CreatureID=17693 AND GroupID=1 AND ID=0; -- Shattered Hand Scout bt-text-match
UPDATE world.creature_text SET Sound=65819 WHERE CreatureID=113738 AND GroupID=0 AND ID=0; -- Duskwatch Moonmage bt-text-match
UPDATE world.creature_text SET Sound=50426 WHERE CreatureID=90378 AND GroupID=9 AND ID=0; -- Kilrogg Deadeye bt-text-match
UPDATE world.creature_text SET Sound=37192 WHERE CreatureID=70279 AND GroupID=4 AND ID=0; -- Moira Thaurissan own-voice-folder
UPDATE world.creature_text SET Sound=57965 WHERE CreatureID=94261 AND GroupID=1 AND ID=0; -- Bitestone Rockbeater bt-text-match
UPDATE world.creature_text SET Sound=65866 WHERE CreatureID=111489 AND GroupID=1 AND ID=0; -- Loyalist Sycophant bt-text-match
UPDATE world.creature_text SET Sound=50371 WHERE CreatureID=90199 AND GroupID=8 AND ID=0; -- Gorefiend bt-text-match
UPDATE world.creature_text SET Sound=11363 WHERE CreatureID=19044 AND GroupID=4 AND ID=0; -- Gruul the Dragonkiller own-voice-folder
UPDATE world.creature_text SET Sound=44144 WHERE CreatureID=73225 AND GroupID=3 AND ID=0; -- Throm'var Villager bt-text-match
UPDATE world.creature_text SET Sound=82427 WHERE CreatureID=120814 AND GroupID=5 AND ID=0; -- Master Bu bt-text-match
UPDATE world.creature_text SET Sound=67109 WHERE CreatureID=118402 AND GroupID=4 AND ID=0; -- Succubus bt-text-match
