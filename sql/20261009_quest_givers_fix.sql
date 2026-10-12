-- Quest giver/ender fix 2026-10-09: junk GO odkazy prec, realnym doplnene sablony.
-- Spawny chybaju VSETKYM (0 spawnov) - questy odkazu na objekty co nie su vo svete;
-- umiestnenie spawnov je follow-up (treba wowhead suradnice). Idempotentne.
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 35843 AND `quest` = 233291;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 63258 AND `quest` = 31143;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 82195 AND `quest` = 443532;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 97140 AND `quest` = 45316;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 177958 AND `quest` = 64723;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 199185 AND `quest` = 72534;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 199404 AND `quest` = 72661;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 255406 AND `quest` = 93051;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900035 AND `quest` = 90150;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900036 AND `quest` = 90151;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900037 AND `quest` = 90154;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900051 AND `quest` = 90201;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900052 AND `quest` = 90202;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900053 AND `quest` = 90203;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900054 AND `quest` = 90204;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900055 AND `quest` = 90205;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900059 AND `quest` = 90209;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900060 AND `quest` = 90210;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900061 AND `quest` = 90211;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900062 AND `quest` = 90212;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900063 AND `quest` = 90213;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900064 AND `quest` = 90214;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900065 AND `quest` = 90215;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900066 AND `quest` = 90216;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900097 AND `quest` = 90276;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900107 AND `quest` = 90301;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900117 AND `quest` = 90315;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900143 AND `quest` = 90350;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900144 AND `quest` = 90351;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900145 AND `quest` = 90352;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900146 AND `quest` = 90353;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900147 AND `quest` = 90354;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900148 AND `quest` = 90355;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900149 AND `quest` = 90356;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900150 AND `quest` = 90357;
DELETE FROM `world`.`gameobject_queststarter` WHERE `id` = 900151 AND `quest` = 90358;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 2655 AND `quest` = 636;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 97140 AND `quest` = 44756;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 97140 AND `quest` = 45316;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 101547 AND `quest` = 44500;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 124417 AND `quest` = 47982;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 124417 AND `quest` = 51547;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 124922 AND `quest` = 47978;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 187310 AND `quest` = 66279;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 199185 AND `quest` = 72534;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 199370 AND `quest` = 72660;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 199404 AND `quest` = 72661;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 209655 AND `quest` = 29767;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 223082 AND `quest` = 33409;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 226766 AND `quest` = 33844;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 227001 AND `quest` = 33932;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 229220 AND `quest` = 34413;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 246809 AND `quest` = 41027;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 252818 AND `quest` = 43810;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900035 AND `quest` = 90149;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900036 AND `quest` = 90150;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900037 AND `quest` = 90153;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900047 AND `quest` = 90180;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900051 AND `quest` = 90200;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900052 AND `quest` = 90201;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900053 AND `quest` = 90202;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900054 AND `quest` = 90203;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900055 AND `quest` = 90204;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900056 AND `quest` = 90207;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900057 AND `quest` = 90206;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900059 AND `quest` = 90208;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900060 AND `quest` = 90209;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900061 AND `quest` = 90210;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900062 AND `quest` = 90211;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900063 AND `quest` = 90212;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900064 AND `quest` = 90213;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900065 AND `quest` = 90214;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900066 AND `quest` = 90215;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900097 AND `quest` = 90277;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900107 AND `quest` = 90300;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900117 AND `quest` = 57190;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900125 AND `quest` = 90323;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900143 AND `quest` = 60287;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900144 AND `quest` = 90350;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900145 AND `quest` = 90351;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900146 AND `quest` = 90352;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900147 AND `quest` = 90353;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900148 AND `quest` = 90354;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900149 AND `quest` = 90355;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900150 AND `quest` = 90356;
DELETE FROM `world`.`gameobject_questender` WHERE `id` = 900151 AND `quest` = 90357;
-- klon 369354 -> 230253 APPROX goober
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 230253;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (230253, 10, 51936, 'Sack of Strange Soil', 'inspect', '', '', 0.85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27102, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 369354, 0, 0, 0, 0, 0, 0, '', '', NULL, 40906);
-- klon 232398 -> 307068 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307068;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307068, 2, 17676, 'Bounty Board', 'Interact', '', '', 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 232398, 0, 0, 0, 0, 0, 0, '', '', NULL, 22522);
-- klon 3643 -> 307070 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307070;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307070, 2, 8, 'Old Footlocker', 'Interact', '', '', 1.0, 0, 252, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3643, 0, 0, 0, 0, 0, 0, 'SmartGameObjectAI', '', NULL, 63305);
-- klon 287147 -> 307277 APPROX jug
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307277;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307277, 5, 48803, 'Jug', 'Interact', '', '', 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 287147, 0, 0, 0, 0, 0, 0, '', '', NULL, 65893);
-- klon 36 -> 307307 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307307;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307307, 2, 9, 'Broken Barrel', 'Interact', '', '', 1.0, 43, 77, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 0, 0, 0, 0, 0, 0, '', '', NULL, 19342);
-- klon 35 -> 307330 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307330;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307330, 2, 8, 'Captain\'s Footlocker', 'Interact', '', '', 1.0, 43, 78, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 0, '', '', NULL, 19034);
-- klon 33 -> 307340 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307340;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307340, 2, 1, 'Locked Chest', 'Interact', '', '', 1.33, 43, 75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0, 0, 0, 0, 0, 0, '', '', NULL, 19034);
-- klon 36 -> 307619 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307619;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307619, 2, 9, 'Broken Barrel', 'Interact', '', '', 1.0, 43, 77, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 36, 0, 0, 0, 0, 0, 0, '', '', NULL, 19342);
-- klon 287147 -> 307621 APPROX jug
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307621;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307621, 5, 48803, 'Jug', 'Interact', '', '', 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 287147, 0, 0, 0, 0, 0, 0, '', '', NULL, 65893);
-- klon 33 -> 307623 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 307623;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (307623, 2, 1, 'Locked Chest', 'Interact', '', '', 1.33, 43, 75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33, 0, 0, 0, 0, 0, 0, '', '', NULL, 19034);
-- klon 188216 -> 309498 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 309498;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (309498, 5, 7736, 'Armor Stand', 'Interact', '', '', 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 188216, 0, 0, 0, 0, 0, 0, '', '', NULL, 63305);
-- klon 311218 -> 311885 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 311885;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (311885, 2, 53752, 'Xal\'atath, Blade of the Black Empire', 'questinteract', '', '', 1.0, 0, 22645, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 311218, 0, 0, 0, 0, 0, 0, '', '', NULL, 35662);
-- klon 311218 -> 316443 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 316443;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (316443, 2, 53752, 'Xal\'atath, Blade of the Black Empire', 'questinteract', '', '', 1.0, 0, 22645, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 311218, 0, 0, 0, 0, 0, 0, '', '', NULL, 35662);
-- klon 330212 -> 325853 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 325853;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (325853, 5, 55948, 'Empty Bookcase', 'quest', '', '', 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 330212, 0, 0, 0, 0, 0, 0, '', '', NULL, 35662);
-- klon 369354 -> 341831 APPROX goober
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 341831;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (341831, 10, 51936, 'Sack of Strange Soil', 'inspect', '', '', 0.85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27102, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 369354, 0, 0, 0, 0, 0, 0, '', '', NULL, 40906);
-- klon 369354 -> 352909 APPROX goober
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 352909;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (352909, 10, 51936, 'Sack of Strange Soil', 'inspect', '', '', 0.85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27102, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 369354, 0, 0, 0, 0, 0, 0, '', '', NULL, 40906);
-- klon 369354 -> 369288 
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 369288;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (369288, 10, 51936, 'Sack of Strange Soil', 'inspect', '', '', 0.85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27102, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 369354, 0, 0, 0, 0, 0, 0, '', '', NULL, 40906);
-- klon 369354 -> 369342 APPROX goober
DELETE FROM `world`.`gameobject_template` WHERE `entry` = 369342;
INSERT INTO `world`.`gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `Data6`, `Data7`, `Data8`, `Data9`, `Data10`, `Data11`, `Data12`, `Data13`, `Data14`, `Data15`, `Data16`, `Data17`, `Data18`, `Data19`, `Data20`, `Data21`, `Data22`, `Data23`, `Data24`, `Data25`, `Data26`, `Data27`, `Data28`, `Data29`, `Data30`, `Data31`, `Data32`, `Data33`, `Data34`, `ContentTuningId`, `RequiredLevel`, `AIName`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES (369342, 10, 51936, 'Sack of Strange Soil', 'inspect', '', '', 0.85, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 27102, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 369354, 0, 0, 0, 0, 0, 0, '', '', NULL, 40906);
-- 84684 Ratts' Race ender 466128 (neexistuje) -> 226775 Ratts
DELETE FROM `world`.`creature_questender` WHERE `quest` = 84684;
INSERT INTO `world`.`creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES (226775, 84684, 0);
UPDATE `world`.`creature` SET `npcflag` = 2 WHERE `guid` = 3000146322;
