-- Retail-parity fix for world.creature_text (text / BroadcastText / Sound)
-- 225 rows from docs/vo_verify/plan2.csv; undo in 20261022_vo_verify_undo.sql
-- backup: world.bak_20261022_vo_verify_ct

UPDATE world.creature_text SET Text='The strands of LIFE have been severed! The Dreamers must be avenged!', BroadcastTextId=10880, Sound=0 WHERE CreatureID=14887 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Hope is a DISEASE of the soul! This land shall wither and die!', BroadcastTextId=10885, Sound=0 WHERE CreatureID=14889 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='The western gate of the Horde Hold has been destroyed!', BroadcastTextId=35411, Sound=0 WHERE CreatureID=34775 AND GroupID=0 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='The western gate of the Horde Hold has been destroyed!', BroadcastTextId=35411, Sound=0 WHERE CreatureID=34776 AND GroupID=3 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='The western gate of the Horde Hold has been destroyed!', BroadcastTextId=35411, Sound=0 WHERE CreatureID=34777 AND GroupID=3 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='The western gate of the Horde Hold has been destroyed!', BroadcastTextId=35411, Sound=0 WHERE CreatureID=34802 AND GroupID=0 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='Turn ... back ...', BroadcastTextId=35860, Sound=0 WHERE CreatureID=35503 AND GroupID=0 AND ID=2; -- set_sound
UPDATE world.creature_text SET Text='Yeah', BroadcastTextId=1, Sound=0 WHERE CreatureID=36600 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='We took back our city... we took back...', BroadcastTextId=0, Sound=0 WHERE CreatureID=38474 AND GroupID=2 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I will take this life as an offering!', BroadcastTextId=44759, Sound=18914 WHERE CreatureID=39378 AND GroupID=2 AND ID=1; -- align_text
UPDATE world.creature_text SET Text='General Umbriss begins to cast ground siege.', BroadcastTextId=47798, Sound=18534 WHERE CreatureID=39625 AND GroupID=7 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Erudax cackles maniacally.', BroadcastTextId=47771, Sound=18639 WHERE CreatureID=40484 AND GroupID=3 AND ID=1; -- clear_bt
UPDATE world.creature_text SET Text='Listen', BroadcastTextId=1, Sound=0 WHERE CreatureID=42383 AND GroupID=11 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I didn''t see who killed ''em', BroadcastTextId=1, Sound=0 WHERE CreatureID=42383 AND GroupID=12 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Between you', BroadcastTextId=100, Sound=0 WHERE CreatureID=42383 AND GroupID=14 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Listen', BroadcastTextId=1, Sound=0 WHERE CreatureID=42384 AND GroupID=11 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I didn''t see who killed ''em', BroadcastTextId=1, Sound=0 WHERE CreatureID=42384 AND GroupID=12 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Between you', BroadcastTextId=100, Sound=0 WHERE CreatureID=42384 AND GroupID=14 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Listen', BroadcastTextId=1, Sound=0 WHERE CreatureID=42386 AND GroupID=11 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I didn''t see who killed ''em', BroadcastTextId=1, Sound=0 WHERE CreatureID=42386 AND GroupID=12 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Between you', BroadcastTextId=100, Sound=0 WHERE CreatureID=42386 AND GroupID=14 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='The sun has set on this mortal world', BroadcastTextId=23228, Sound=0 WHERE CreatureID=48572 AND GroupID=0 AND ID=1; -- clear_bt
UPDATE world.creature_text SET Text='Ji', BroadcastTextId=27792, Sound=0 WHERE CreatureID=54786 AND GroupID=4 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Aysa', BroadcastTextId=27793, Sound=0 WHERE CreatureID=54786 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='If we lose the healers', BroadcastTextId=27288, Sound=0 WHERE CreatureID=56418 AND GroupID=0 AND ID=3; -- relink_prefix
UPDATE world.creature_text SET Text='Bah', BroadcastTextId=27298, Sound=0 WHERE CreatureID=56660 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Shen-zin Su', BroadcastTextId=27434, Sound=0 WHERE CreatureID=56661 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Of course', BroadcastTextId=27436, Sound=0 WHERE CreatureID=56661 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='For 3', BroadcastTextId=27807, Sound=0 WHERE CreatureID=56686 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Now Shen-zin Su is ill', BroadcastTextId=27810, Sound=0 WHERE CreatureID=56686 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Aysa and Ji have retrieved the spirits and brought them here. You are to go with them', BroadcastTextId=27811, Sound=0 WHERE CreatureID=56686 AND GroupID=4 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='The Alliance? If the crashed ship is theirs', BroadcastTextId=27419, Sound=0 WHERE CreatureID=59986 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='We need to dislodge that ship', BroadcastTextId=27333, Sound=0 WHERE CreatureID=59988 AND GroupID=3 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Well', BroadcastTextId=27334, Sound=0 WHERE CreatureID=59988 AND GroupID=4 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Ji may kill Shen-zin Su if we let him go through with this! Come with me', BroadcastTextId=27412, Sound=0 WHERE CreatureID=60729 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Ji... if this is what you must do', BroadcastTextId=27416, Sound=0 WHERE CreatureID=60729 AND GroupID=4 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Aysa', BroadcastTextId=27329, Sound=0 WHERE CreatureID=60741 AND GroupID=0 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='Stand down', BroadcastTextId=27522, Sound=396 WHERE CreatureID=60889 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='They are ignorant', BroadcastTextId=30748, Sound=0 WHERE CreatureID=62087 AND GroupID=2 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Hahahah. I do not think you know what  you are getting into...', BroadcastTextId=0, Sound=0 WHERE CreatureID=63616 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='For Ironforge! For the Alliance!', BroadcastTextId=0, Sound=0 WHERE CreatureID=70279 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='The king''s champions have done it. The storm has ended! Forward Dark Irons! TO BATTLE WE MARCH!', BroadcastTextId=0, Sound=0 WHERE CreatureID=70279 AND GroupID=9 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='That they are', BroadcastTextId=37198, Sound=0 WHERE CreatureID=70279 AND GroupID=10 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='There''s only a few of us left; the ones they don''t eat', BroadcastTextId=37293, Sound=0 WHERE CreatureID=70744 AND GroupID=1 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Listen: The storm. We figured out what''s makin'' it. That sneaky Zandalari has these ice trolls makin'' blood sacrifices ta elemental spirits. There''s a cave north o'' here', BroadcastTextId=37295, Sound=0 WHERE CreatureID=70745 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Well', BroadcastTextId=37336, Sound=0 WHERE CreatureID=70799 AND GroupID=8 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='The nearest is just ahead. If ye can save him', BroadcastTextId=37263, Sound=0 WHERE CreatureID=70801 AND GroupID=1 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Ð', BroadcastTextId=38295, Sound=0 WHERE CreatureID=72561 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Fall back to the sanctum', BroadcastTextId=43553, Sound=0 WHERE CreatureID=74518 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Witness the TRUE power of the Iron Horde!', BroadcastTextId=82585, Sound=0 WHERE CreatureID=74715 AND GroupID=3 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Here! This location commands the entrance to our valley.', BroadcastTextId=0, Sound=0 WHERE CreatureID=79206 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I assure you', BroadcastTextId=44821, Sound=0 WHERE CreatureID=79470 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='It is good to see you', BroadcastTextId=45389, Sound=396 WHERE CreatureID=79635 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Here! This location commands the entrance to our valley.', BroadcastTextId=0, Sound=0 WHERE CreatureID=79635 AND GroupID=2 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Commander! You have built a most impressive garrison. I am eager to see your men in action.', BroadcastTextId=0, Sound=0 WHERE CreatureID=80078 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You''d better step back. I''m calling in the Bombsquad!', BroadcastTextId=0, Sound=0 WHERE CreatureID=80808 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You''d better step back. I''m calling in the Bombsquad!', BroadcastTextId=0, Sound=0 WHERE CreatureID=80808 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Ahhhhhhhh! I''m hit!', BroadcastTextId=0, Sound=0 WHERE CreatureID=80808 AND GroupID=2 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Huh', BroadcastTextId=43932, Sound=0 WHERE CreatureID=80962 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Impossible!', BroadcastTextId=99092, Sound=0 WHERE CreatureID=81254 AND GroupID=7 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Golad', BroadcastTextId=100, Sound=0 WHERE CreatureID=88972 AND GroupID=9 AND ID=9; -- clear_bt
UPDATE world.creature_text SET Text='Any disturbance should catalyze the sequence. Just', BroadcastTextId=67264, Sound=0 WHERE CreatureID=90417 AND GroupID=1 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Quickly', BroadcastTextId=57399, Sound=0 WHERE CreatureID=90474 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Brace yourselves', BroadcastTextId=53464, Sound=0 WHERE CreatureID=90713 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Ah', BroadcastTextId=54181, Sound=0 WHERE CreatureID=91784 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Structural integrity at 0%%!', BroadcastTextId=0, Sound=0 WHERE CreatureID=92122 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You know what to do', BroadcastTextId=1, Sound=0 WHERE CreatureID=92183 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Ich brauche Eure Hilfe', BroadcastTextId=57338, Sound=0 WHERE CreatureID=92718 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='With it', BroadcastTextId=55246, Sound=0 WHERE CreatureID=93011 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Ð­Ð¹', BroadcastTextId=50536, Sound=25 WHERE CreatureID=93023 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I am your judge', BroadcastTextId=55020, Sound=0 WHERE CreatureID=95226 AND GroupID=4 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='But the most important', BroadcastTextId=67336, Sound=396 WHERE CreatureID=97140 AND GroupID=2 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Ya veo que no hay forma de convencerte. Muy bien', BroadcastTextId=57297, Sound=0 WHERE CreatureID=97267 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Ahhhh', BroadcastTextId=57287, Sound=0 WHERE CreatureID=97617 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Es tut gut', BroadcastTextId=57287, Sound=0 WHERE CreatureID=97617 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Gather', BroadcastTextId=58648, Sound=0 WHERE CreatureID=98206 AND GroupID=6 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Come', BroadcastTextId=55214, Sound=0 WHERE CreatureID=98497 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Come', BroadcastTextId=55214, Sound=0 WHERE CreatureID=98497 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Wie Ihr Euch auch entscheidet', BroadcastTextId=55293, Sound=0 WHERE CreatureID=99045 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='FEL MASTERS', BroadcastTextId=65740, Sound=0 WHERE CreatureID=100301 AND GroupID=4 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='The battle is won', BroadcastTextId=61883, Sound=0 WHERE CreatureID=100578 AND GroupID=1 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='My', BroadcastTextId=67293, Sound=396 WHERE CreatureID=101116 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Well', BroadcastTextId=67419, Sound=0 WHERE CreatureID=101499 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='$n', BroadcastTextId=57307, Sound=0 WHERE CreatureID=102391 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Out here', BroadcastTextId=67480, Sound=0 WHERE CreatureID=102600 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='There... the Illidari. And', BroadcastTextId=60192, Sound=0 WHERE CreatureID=103660 AND GroupID=5 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='The Nightmare has corrupted dragons', BroadcastTextId=58726, Sound=0 WHERE CreatureID=103769 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='This is not up for debate', BroadcastTextId=67504, Sound=0 WHERE CreatureID=105342 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Aye', BroadcastTextId=63275, Sound=0 WHERE CreatureID=105689 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='You''ve done well so far', BroadcastTextId=70450, Sound=396 WHERE CreatureID=106468 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='From each of these pathways', BroadcastTextId=61374, Sound=0 WHERE CreatureID=106482 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Hearts are full of pity...', BroadcastTextId=112859, Sound=0 WHERE CreatureID=106616 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Crashing! Clashing!', BroadcastTextId=112860, Sound=0 WHERE CreatureID=106616 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Crashing! Clashing!', BroadcastTextId=112860, Sound=0 WHERE CreatureID=106616 AND GroupID=2 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I know everything Akama knows, and more. I look forward to us working together to destroy the Legion.', BroadcastTextId=910743, Sound=0 WHERE CreatureID=108090 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Forgive me Azshara!', BroadcastTextId=93656, Sound=0 WHERE CreatureID=108339 AND GroupID=0 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='Why did the queen leave us?', BroadcastTextId=93654, Sound=0 WHERE CreatureID=108340 AND GroupID=0 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='Perhaps it is your imperfection... that which grants you free will... that allows you to persevere against all cosmically calculated odds. You prevail where the Titan´s own perfect creations have failed.', BroadcastTextId=910721, Sound=0 WHERE CreatureID=109529 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='For now', BroadcastTextId=67395, Sound=0 WHERE CreatureID=111863 AND GroupID=13 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='For now', BroadcastTextId=67378, Sound=0 WHERE CreatureID=112146 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Hmm... a little tart', BroadcastTextId=67372, Sound=0 WHERE CreatureID=112147 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Get in', BroadcastTextId=67335, Sound=0 WHERE CreatureID=113114 AND GroupID=4 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='Of course', BroadcastTextId=77162, Sound=0 WHERE CreatureID=114251 AND GroupID=1 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='Ah', BroadcastTextId=58644, Sound=0 WHERE CreatureID=114262 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I don''t have any friends... well', BroadcastTextId=77154, Sound=0 WHERE CreatureID=114284 AND GroupID=1 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Oh no', BroadcastTextId=77105, Sound=0 WHERE CreatureID=114328 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='See that these people escape the city', BroadcastTextId=78557, Sound=0 WHERE CreatureID=115049 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Wie? Der Fremdling kommt', BroadcastTextId=82896, Sound=0 WHERE CreatureID=116484 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Debes acudir en su ayuda', BroadcastTextId=86160, Sound=0 WHERE CreatureID=120844 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Ah', BroadcastTextId=98483, Sound=0 WHERE CreatureID=121504 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Me refiero a tu amigo', BroadcastTextId=87852, Sound=0 WHERE CreatureID=121597 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Grenja', BroadcastTextId=100, Sound=0 WHERE CreatureID=122723 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Well', BroadcastTextId=99348, Sound=0 WHERE CreatureID=122795 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Die', BroadcastTextId=99421, Sound=0 WHERE CreatureID=122864 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Great to see you all made it back in one piece', BroadcastTextId=105701, Sound=0 WHERE CreatureID=123544 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='You can ride my rocket back to your base. It''s a one-way trip', BroadcastTextId=101334, Sound=0 WHERE CreatureID=125245 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Not bad', BroadcastTextId=109583, Sound=396 WHERE CreatureID=125342 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Brannon', BroadcastTextId=109171, Sound=0 WHERE CreatureID=125961 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='He was wrong. Oh dere was damage', BroadcastTextId=1, Sound=0 WHERE CreatureID=126009 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Vengan', BroadcastTextId=55214, Sound=0 WHERE CreatureID=126071 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Hey', BroadcastTextId=105467, Sound=0 WHERE CreatureID=126490 AND GroupID=8 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='A few years back', BroadcastTextId=98082, Sound=0 WHERE CreatureID=127222 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Well', BroadcastTextId=108402, Sound=0 WHERE CreatureID=127613 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Ah', BroadcastTextId=87810, Sound=25 WHERE CreatureID=127893 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='At last', BroadcastTextId=105832, Sound=0 WHERE CreatureID=128152 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Loa above! Just let me finish! Shadows twist de strings of fate', BroadcastTextId=103520, Sound=0 WHERE CreatureID=130344 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Sea to sea', BroadcastTextId=108751, Sound=0 WHERE CreatureID=130934 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I know not what darkness took your mind', BroadcastTextId=108793, Sound=0 WHERE CreatureID=130934 AND GroupID=19 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Keep moving', BroadcastTextId=104207, Sound=0 WHERE CreatureID=131640 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='$n', BroadcastTextId=103865, Sound=0 WHERE CreatureID=132134 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Alexander', BroadcastTextId=103418, Sound=0 WHERE CreatureID=132994 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='An ambush! Lucy', BroadcastTextId=103419, Sound=0 WHERE CreatureID=132994 AND GroupID=6 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Our forces are keeping de rest of de blood trolls at bay', BroadcastTextId=116582, Sound=0 WHERE CreatureID=133476 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Our forces are keeping de rest of de blood trolls at bay', BroadcastTextId=103847, Sound=0 WHERE CreatureID=133476 AND GroupID=1 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='The key is ours', BroadcastTextId=107773, Sound=0 WHERE CreatureID=134121 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Come', BroadcastTextId=106053, Sound=0 WHERE CreatureID=134132 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Horde infiltrators have breached the Stockades! Civilians are to remain in their homes until the threat has been subdued!', BroadcastTextId=910422, Sound=0 WHERE CreatureID=134195 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Activating cudgel retrieval.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Deploying cudgel.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Fluid evacuation in progress. Entering standby.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=2 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Fuel levels depleted. Shutting down...', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=3 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Hosts detected. Infection commencing.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=4 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Initiating blood dispersal of target host.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=5 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Initiating plasma collection.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=6 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Levels at maximum. Resume collection.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=7 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Specimen targeted for destruction.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=8 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Subjects primed for contamination.', BroadcastTextId=0, Sound=0 WHERE CreatureID=137119 AND GroupID=9 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Princess', BroadcastTextId=105557, Sound=0 WHERE CreatureID=140656 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='After you', BroadcastTextId=112421, Sound=0 WHERE CreatureID=140728 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Well', BroadcastTextId=152749, Sound=0 WHERE CreatureID=156280 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='You return', BroadcastTextId=152107, Sound=603 WHERE CreatureID=156698 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Gah! Well', BroadcastTextId=166616, Sound=0 WHERE CreatureID=157676 AND GroupID=10 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='First you bring war', BroadcastTextId=165006, Sound=0 WHERE CreatureID=158007 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Don''t keep Vyraz waiting. He''s not known for his patience.', BroadcastTextId=0, Sound=0 WHERE CreatureID=159065 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I hope you are not enjoying my hospitality too much', BroadcastTextId=157851, Sound=0 WHERE CreatureID=159946 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Of course', BroadcastTextId=157853, Sound=0 WHERE CreatureID=159946 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Sika', BroadcastTextId=156563, Sound=0 WHERE CreatureID=160280 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='The age of the Forsworn is at hand!', BroadcastTextId=0, Sound=0 WHERE CreatureID=162061 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='The Archon''s spear is mine to wield!', BroadcastTextId=0, Sound=0 WHERE CreatureID=162061 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Perish among the clouds!', BroadcastTextId=0, Sound=0 WHERE CreatureID=162061 AND GroupID=3 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='No! The path... must be... abandoned...', BroadcastTextId=0, Sound=0 WHERE CreatureID=162061 AND GroupID=4 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Our enemies surround us. Stay off the main road.', BroadcastTextId=0, Sound=0 WHERE CreatureID=162069 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You had best make this interesting.', BroadcastTextId=0, Sound=0 WHERE CreatureID=162329 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='My blade knows no equal.', BroadcastTextId=0, Sound=0 WHERE CreatureID=162329 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Cower before my might!', BroadcastTextId=0, Sound=0 WHERE CreatureID=162329 AND GroupID=2 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You! Show me what you can do.', BroadcastTextId=0, Sound=0 WHERE CreatureID=162329 AND GroupID=3 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='That was... a good... fight...', BroadcastTextId=0, Sound=0 WHERE CreatureID=162329 AND GroupID=4 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You will pay dearly for this.', BroadcastTextId=0, Sound=0 WHERE CreatureID=164450 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You will pay dearly for this.', BroadcastTextId=0, Sound=0 WHERE CreatureID=164450 AND GroupID=5 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Have you ever wished you could fly?', BroadcastTextId=0, Sound=0 WHERE CreatureID=164450 AND GroupID=6 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Hold this a moment.', BroadcastTextId=0, Sound=0 WHERE CreatureID=164450 AND GroupID=8 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I would step lightly if I were you.', BroadcastTextId=0, Sound=0 WHERE CreatureID=164450 AND GroupID=9 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='These are more than mere trinkets.', BroadcastTextId=0, Sound=0 WHERE CreatureID=164450 AND GroupID=12 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You strike... a hard... bargain...', BroadcastTextId=0, Sound=0 WHERE CreatureID=164450 AND GroupID=13 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I can predict your every maneuver.', BroadcastTextId=0, Sound=0 WHERE CreatureID=164517 AND GroupID=10 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I will not give up on my mother. But for now', BroadcastTextId=165938, Sound=0 WHERE CreatureID=164554 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I will not give up on my mother. But for now', BroadcastTextId=165938, Sound=0 WHERE CreatureID=164554 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Lord Admiral', BroadcastTextId=161966, Sound=0 WHERE CreatureID=165918 AND GroupID=24 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='No', BroadcastTextId=153652, Sound=0 WHERE CreatureID=166621 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='You three', BroadcastTextId=156954, Sound=0 WHERE CreatureID=166782 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Lord Admiral', BroadcastTextId=161966, Sound=0 WHERE CreatureID=166886 AND GroupID=24 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='This is dire news, Vesiphone. But the Archon has turned a deaf ear to such tidings in the past.', BroadcastTextId=9105797, Sound=0 WHERE CreatureID=167168 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Now', BroadcastTextId=1, Sound=0 WHERE CreatureID=167425 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='It is the Arbiter''s place to judge souls', BroadcastTextId=159784, Sound=0 WHERE CreatureID=167486 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='The winged kyrian of Bastion ferry souls from the mortal realm into the Shadowlands', BroadcastTextId=159779, Sound=0 WHERE CreatureID=167486 AND GroupID=5 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Recruit', BroadcastTextId=157174, Sound=0 WHERE CreatureID=167596 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I thought death was the end of existence. Here', BroadcastTextId=162389, Sound=0 WHERE CreatureID=167682 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Yeesh', BroadcastTextId=157215, Sound=0 WHERE CreatureID=168462 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='During my vigil upon the Frozen Throne', BroadcastTextId=161864, Sound=0 WHERE CreatureID=169076 AND GroupID=3 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='That is where you must go', BroadcastTextId=161865, Sound=0 WHERE CreatureID=169076 AND GroupID=4 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='When the helm rested upon my head', BroadcastTextId=161867, Sound=0 WHERE CreatureID=169076 AND GroupID=6 AND ID=0; -- align_text
UPDATE world.creature_text SET Text='Oh', BroadcastTextId=161379, Sound=0 WHERE CreatureID=169202 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='You have done well so far', BroadcastTextId=161608, Sound=0 WHERE CreatureID=172652 AND GroupID=4 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Acherus', BroadcastTextId=164951, Sound=0 WHERE CreatureID=176554 AND GroupID=5 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='When this comes to pass', BroadcastTextId=181330, Sound=0 WHERE CreatureID=177194 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I understand', BroadcastTextId=181163, Sound=0 WHERE CreatureID=177423 AND GroupID=1 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Even damaged', BroadcastTextId=181292, Sound=0 WHERE CreatureID=177562 AND GroupID=0 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='A dropped page remains', BroadcastTextId=181059, Sound=0 WHERE CreatureID=177610 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='We made it! Imagine the wonders to be found here', BroadcastTextId=180813, Sound=0 WHERE CreatureID=177819 AND GroupID=6 AND ID=0; -- relink_prefix
UPDATE world.creature_text SET Text='Ah', BroadcastTextId=180822, Sound=0 WHERE CreatureID=178069 AND GroupID=0 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Is it... over?', BroadcastTextId=0, Sound=0 WHERE CreatureID=181057 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='If this is where the Arbiter was made', BroadcastTextId=189363, Sound=0 WHERE CreatureID=181732 AND GroupID=4 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='I am past my breaking point!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='It is amusing how you stumble through space and time.', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=1 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Your agony amuses me.', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=3 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Your destruction is unavoidable!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=4 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You cannot even control where you stand!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=5 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You mortals cannot even bear a spark of my genius!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=6 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Ephemera is unbridled power!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=7 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='I wonder what effect folding space has on your flesh.', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=8 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='These stasis fields should keep you busy!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=9 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='This force will overtake you!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=10 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Gravity bends to my will!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=11 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='There is no limit to the wealth I can obtain!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=12 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Never test my expertise.', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=14 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='These stasis fields should keep you busy!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=15 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='This force will overtake you!', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=16 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Wait... we can make a deal...', BroadcastTextId=0, Sound=0 WHERE CreatureID=183501 AND GroupID=17 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Something is at the top of the rise. I will take a side route. Meet me up there!', BroadcastTextId=910552, Sound=0 WHERE CreatureID=187804 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Queen Alexstrasza is far more impressive than any statue you ll find in the Isles!', BroadcastTextId=910255, Sound=0 WHERE CreatureID=193913 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='May this brazier once more guide every peaceful denizen of Azeroth to these shores!', BroadcastTextId=910256, Sound=0 WHERE CreatureID=193917 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='You are awake! I am glad to see you are okay.', BroadcastTextId=910553, Sound=0 WHERE CreatureID=195024 AND GroupID=0 AND ID=0; -- set_sound
UPDATE world.creature_text SET Text='Escondidos', BroadcastTextId=86342, Sound=396 WHERE CreatureID=220388 AND GroupID=2 AND ID=0; -- clear_bt
UPDATE world.creature_text SET Text='Using a relic of the Void to breach the storm... It sounds risky, Umbric.', BroadcastTextId=283069, Sound=0 WHERE CreatureID=235787 AND GroupID=2 AND ID=0; -- relink_bt
UPDATE world.creature_text SET Text='Now', BroadcastTextId=27491, Sound=0 WHERE CreatureID=588750 AND GroupID=3 AND ID=0; -- clear_bt
