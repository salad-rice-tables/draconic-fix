-- Wave 1: link 4 Nightborne creature_text rows to retail BroadcastText + SoundKit
-- Verified: retail BroadcastText SoundKitID1 is populated (SoundKitID2=0) for all 4.
-- Pattern matches existing voiced rows on same NPCs: Sound = populated kit, SoundPlayType=0.
-- Backup of current rows written to docs\vo_audit2\wave1_backup.sql via SELECT.

-- 1) First Arcanist Thalyssra (97140) group 8 "I..."  -> BT 210850 / kit 182102
UPDATE creature_text SET BroadcastTextId=210850, Sound=182102, SoundPlayType=0
WHERE CreatureID=97140 AND GroupID=8 AND ID=0;

-- 2) Archmage Khadgar (90417) group 2 "Be careful."  -> BT 234908 / kit 219900
UPDATE creature_text SET BroadcastTextId=234908, Sound=219900, SoundPlayType=0
WHERE CreatureID=90417 AND GroupID=2 AND ID=0;

-- 3) Chief Telemancer Oculeth (98548) group 3 "Ahh..." -> BT 194056 / kit 153923
UPDATE creature_text SET BroadcastTextId=194056, Sound=153923, SoundPlayType=0
WHERE CreatureID=98548 AND GroupID=3 AND ID=0;

-- 4) Ly'leth Lunastre (107632) group 4 "My lord..."   -> BT 69648 / kit 34170
UPDATE creature_text SET BroadcastTextId=69648, Sound=34170, SoundPlayType=0
WHERE CreatureID=107632 AND GroupID=4 AND ID=0;
