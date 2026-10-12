-- =====================================================================
-- Campaign mob taunts: aggro yell (group 0) + death yell (group 1) via
-- SmartAI, for all 13 campaign combat NPCs. Idempotent. Reloads live
-- (`reload smart_scripts`? else restart).
-- =====================================================================

DELETE FROM `world`.`smart_scripts` WHERE `entryorguid` IN (95114, 95115, 95116, 95124, 95125, 95126, 95127, 95128, 95129, 95140, 95215, 95218, 95252) AND `source_type` = 0 AND `id` IN (0, 1);
INSERT INTO `world`.`smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param7`, `action_param_string`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(95114, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felsong Renegade - On Aggro - Yell'),
(95114, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felsong Renegade - On Death - Yell'),
(95115, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Shadowfen Betrayer - On Aggro - Yell'),
(95115, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Shadowfen Betrayer - On Death - Yell'),
(95116, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Talonbreaker Renegade - On Aggro - Yell'),
(95116, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Talonbreaker Renegade - On Death - Yell'),
(95124, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Ashenfall Betrayer - On Aggro - Yell'),
(95124, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Ashenfall Betrayer - On Death - Yell'),
(95125, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Pineshadow Turncloak - On Aggro - Yell'),
(95125, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Pineshadow Turncloak - On Death - Yell'),
(95126, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felbriar Warden - On Aggro - Yell'),
(95126, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felbriar Warden - On Death - Yell'),
(95127, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Duskwarden Turncoat - On Aggro - Yell'),
(95127, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Duskwarden Turncoat - On Death - Yell'),
(95128, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felsworn Warden - On Aggro - Yell'),
(95128, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felsworn Warden - On Death - Yell'),
(95129, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Sarthis - On Aggro - Yell'),
(95129, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Sarthis - On Death - Yell'),
(95140, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felbound Hound - On Aggro - Yell'),
(95140, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felbound Hound - On Death - Yell'),
(95215, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felwing Terror - On Aggro - Yell'),
(95215, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felwing Terror - On Death - Yell'),
(95218, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Fel Lasher - On Aggro - Yell'),
(95218, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Fel Lasher - On Death - Yell'),
(95252, 0, 0, 0, '0', 4, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felsworn Marauder - On Aggro - Yell'),
(95252, 0, 1, 0, '0', 6, 0, 100, 0, 0, 0, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, '', 0, 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Felsworn Marauder - On Death - Yell');

DELETE FROM `world`.`creature_text` WHERE `CreatureID` IN (95114, 95115, 95116, 95124, 95125, 95126, 95127, 95128, 95129, 95140, 95215, 95218, 95252) AND `GroupID` IN (0, 1);
INSERT INTO `world`.`creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundPlayType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(95114, 0, 0, 'The fel sings in me! Listen!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Felsong aggro'),
(95114, 1, 0, 'The song... fades...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Felsong death'),
(95115, 0, 0, 'The fen takes you!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Shadowfen aggro'),
(95115, 1, 0, 'Sinking... into shadow...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Shadowfen death'),
(95116, 0, 0, 'I was Warden once! Now I am talon!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Talonbreaker aggro'),
(95116, 1, 0, 'The dance... ends...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Talonbreaker death'),
(95124, 0, 0, 'The pines burn for us!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Ashenfall aggro'),
(95124, 1, 0, 'Ashes... to ashes...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Ashenfall death'),
(95125, 0, 0, 'You walk blind among shadows!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Pineshadow aggro'),
(95125, 1, 0, 'Darkness... takes me...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Pineshadow death'),
(95126, 0, 0, 'The briar drinks deep!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Felbriar aggro'),
(95126, 1, 0, 'Severed... at last...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Felbriar death'),
(95127, 0, 0, 'Dusk falls on you!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Duskwarden aggro'),
(95127, 1, 0, 'Night... eternal...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Duskwarden death'),
(95128, 0, 0, 'Fel guides my glaive!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Felsworn aggro'),
(95128, 1, 0, 'Sworn... unsworn...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Felsworn death'),
(95129, 0, 0, 'Come, little hunter. The dreadlord sends regards.', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Sarthis aggro'),
(95129, 1, 0, 'Master... I hear only... silence...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Sarthis death'),
(95140, 0, 0, 'Rrrraaagh! Fresh meat!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Hound aggro'),
(95140, 1, 0, 'Whimper...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Hound death'),
(95215, 0, 0, 'Screee! Eyes for the master!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Bat aggro'),
(95215, 1, 0, 'Falling...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Bat death'),
(95218, 0, 0, 'Roots... hunger...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Lasher aggro'),
(95218, 1, 0, 'Uprooted...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Lasher death'),
(95252, 0, 0, 'Felwood feeds! You feed it next!', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Marauder aggro'),
(95252, 1, 0, 'Marauded... no more...', 12, 7, 100, 0, 0, 0, 0, 0, 0, 'Marauder death');
