-- 2026-11-07 BfA dead-phase quest spawn stopgap (batch 1)
-- Scope: only unique BfA spawns of quest-critical NPCs whose PhaseId has no
-- phase_area row and no player_condition / areatrigger / spell-aura activation.
-- These NPCs were therefore unreachable and blocked their quests.
-- Phase 0 is a stopgap until a proper quest phase is proven from retail.
-- Restart worldserver to load these changes.
SET NAMES utf8mb4;
USE world;
START TRANSACTION;

-- 127669 Nokano - Q47442 Curse of Jani (objective)
UPDATE `creature` SET `PhaseId`=0
 WHERE `GUID`=210403156 AND `id`=127669 AND `PhaseId`=9464;

-- 130879 Vigil Hill Refugee - Q49405 Defenders of Daelin's Gate (objective)
UPDATE `creature` SET `PhaseId`=0
 WHERE `GUID` IN (
 210318409,210318412,210318420,210318427,210318430,210318588,
 210318605,210318708,210318714,210318814,210318956,210319025,
 210319152,210319153,210346766,210346768,210346769,210346858,
 210346860,210346864,210346865,210346874
 ) AND `id`=130879 AND `PhaseId`=49405;

-- 141078 Vigil Hill Refugee - ender Q49405, starter Q49869 / Q52431
UPDATE `creature` SET `PhaseId`=0
 WHERE `GUID`=210346867 AND `id`=141078 AND `PhaseId`=49405;

-- 132985 Zandalari Soldier - Q50081 The Road of Pain (objective x6)
UPDATE `creature` SET `PhaseId`=0
 WHERE `GUID` IN (
 210425104,210425105,210425109,210425115,
 210425123,210425129,210425139,210425169
 ) AND `id`=132985 AND `PhaseId`=133122;

-- 136183 Crushtacean - Q51901 Crushtacean (objective)
UPDATE `creature` SET `PhaseId`=0
 WHERE `GUID`=210325929 AND `id`=136183 AND `PhaseId`=50;

-- 141838 Galeheart - Q49741 Righteous Retribution (objective)
UPDATE `creature` SET `PhaseId`=0
 WHERE `GUID`=210319321 AND `id`=141838 AND `PhaseId`=50;

COMMIT;
