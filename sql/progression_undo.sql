-- Undo pre progression.sql
DELETE FROM `hotfixes`.`hotfix_data` WHERE `Id` = 1900190;
DELETE FROM `hotfixes`.`spell_effect` WHERE `SpellID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`spell_misc` WHERE `SpellID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`spell` WHERE `ID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`spell_name` WHERE `ID` IN (1402200,1402201,1402202,1402203,1402204);
DELETE FROM `hotfixes`.`char_titles` WHERE `ID` IN (1409, 1410);
DROP TABLE IF EXISTS `characters`.`hero_intro`;
DROP TABLE IF EXISTS `characters`.`hero_rebirth`;
DROP TABLE IF EXISTS `characters`.`season_points`;
DROP TABLE IF EXISTS `characters`.`season_awarded`;
DROP TABLE IF EXISTS `world`.`guild_village`;
DROP TABLE IF EXISTS `world`.`lw_news`;
