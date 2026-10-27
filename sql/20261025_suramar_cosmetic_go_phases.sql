-- Suramar: quest gameobjects were spawned in cosmetic phases (hotfixes.phase.Flags = 20).
-- The server never grants cosmetic phases to players, so those GOs were visible client-side
-- but not interactable (same class of bug as the Ancient Seed Holder 265435 / phase 60010).
-- Fix: give each GO its own non-cosmetic phase (Flags = 8) and replicate the original
-- phase_area row (zone 7637) and quest-status conditions exactly.
--
-- Affected quests:
--   40320 Band of Blood Brothers      GO 245321 Katarine's Cage      old phase 41164
--   40745 Shift Change                GO 250991 Spell Barrier        old phase 41096
--   40927 Jandvik's Last Hope         GO 246923 Toryl's Cage         old phase 41168
--   42841 A Big Score                 GO 251626 Thousand-Year Arcwine old phase 41108
--   44727 Smuggled!                   GO 265521 Felsoul Cage x10     old phase 45525
--   44740 Staging Point               GO 266009 Telemancy Beacon     old phase 45552
--   44918 A Message From Our Enemies  GO 266207 Mysterious Crystal   old phase 45561
--
-- Restart required (phase_area + hotfixes.phase + spawn PhaseId are start-up data).
-- Idempotent: delete-then-insert / unconditional updates.

-- 1) non-cosmetic phases
DELETE FROM hotfixes.phase WHERE ID IN (60030,60031,60032,60033,60034,60035,60036);
INSERT INTO hotfixes.phase (ID,Flags,VerifiedBuild) VALUES
 (60030,8,70391),(60031,8,70391),(60032,8,70391),(60033,8,70391),
 (60034,8,70391),(60035,8,70391),(60036,8,70391);

-- 2) area binding (all seven old phases were bound to Suramar zone 7637 only)
DELETE FROM phase_area WHERE PhaseId IN (60030,60031,60032,60033,60034,60035,60036);
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES
 (7637,60030,'40320 Band of Blood Brothers - Katarine Cage (non-cosmetic)'),
 (7637,60031,'40745 Shift Change - Spell Barrier (non-cosmetic)'),
 (7637,60032,'40927 Jandviks Last Hope - Toryl Cage (non-cosmetic)'),
 (7637,60033,'42841 A Big Score - Thousand-Year Arcwine (non-cosmetic)'),
 (7637,60034,'44727 Smuggled! - Felsoul Cages (non-cosmetic)'),
 (7637,60035,'44740 Staging Point - Telemancy Beacon (non-cosmetic)'),
 (7637,60036,'44918 A Message From Our Enemies - Mysterious Crystal (non-cosmetic)');

-- 3) quest-status conditions, copied 1:1 from the cosmetic phases
DELETE FROM conditions WHERE SourceTypeOrReferenceId=26 AND SourceGroup IN (60030,60031,60032,60033,60034,60035,60036);
INSERT INTO conditions
 (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,
  ConditionValue1,ConditionValue2,ConditionValue3,ConditionStringValue1,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment)
VALUES
 (26,60030,7637,0,0,47,0,40320,66,0,'',1,0,0,'','40320 Katarine Cage while quest active'),
 (26,60031,7637,0,0,47,0,40745,66,0,'',1,0,0,'','40745 Spell Barrier while quest active'),
 (26,60032,7637,0,0,47,0,40927,66,0,'',1,0,0,'','40927 Toryl Cage while quest active'),
 (26,60033,7637,0,0,47,0,42841,8,0,'',0,0,0,'','42841 Arcwine while quest in progress'),
 (26,60034,7637,0,0,47,0,44725,66,0,'',0,0,0,'','44727 Felsoul Cages: 44725 complete/rewarded'),
 (26,60034,7637,0,0,47,0,44814,64,0,'',1,0,0,'','44727 Felsoul Cages: hide once 44814 rewarded'),
 (26,60035,7637,0,0,47,0,44740,66,0,'',1,0,0,'','44740 Telemancy Beacon while quest active'),
 (26,60036,7637,0,0,47,0,44918,74,0,'',0,0,0,'','44918 Mysterious Crystal (any status)');

-- 4) move only the affected GO spawns to the new phases
UPDATE gameobject SET PhaseId=60030 WHERE id=245321;
UPDATE gameobject SET PhaseId=60031 WHERE id=250991;
UPDATE gameobject SET PhaseId=60032 WHERE id=246923;
UPDATE gameobject SET PhaseId=60033 WHERE id=251626;
UPDATE gameobject SET PhaseId=60034 WHERE id=265521;
UPDATE gameobject SET PhaseId=60035 WHERE id=266009;
UPDATE gameobject SET PhaseId=60036 WHERE id=266207;
