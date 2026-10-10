-- Dabing questovych replik: retail BroadcastText ID so SoundKitID (Wowhead sounds / hotfixes.broadcast_text overene).
-- Lorthemar: approach 296383 (snd 308338), accept92061 296391 (snd 308339), accept86543 283069 (snd 300627), accept91967 295755 (snd 308314).
-- Turalyon: report 296430 (snd 308329), ambient 296425 (snd 308328).
-- Umbric 239944 accept + 249272 hello: 283069 / 295701 (snd 300627 / 308315). Koruth 250590: 296434 (snd 308332).
-- BEZ zvuku (nenajdene v DB): Bellamy 9100622 (0/1), Senn 248628, Terrace 235395, Diplomacy scena + Anduin scena (Eluna literaly - Eluna nema sound parameter!).
-- Klient musi mat Midnight VO subory, inak ticho (text ide vzdy).
-- NEPOUZIVAT pocas testu hraca; nasadit pred restartom (creature_text sa cita pri starte).
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 296383 WHERE `CreatureID` = 235787 AND `GroupID` = 0;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 296391 WHERE `CreatureID` = 235787 AND `GroupID` = 1;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 283069 WHERE `CreatureID` = 235787 AND `GroupID` = 2;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 295755 WHERE `CreatureID` = 235787 AND `GroupID` = 4;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 296430 WHERE `CreatureID` = 250580 AND `GroupID` = 0;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 296425 WHERE `CreatureID` = 250580 AND `GroupID` = 1;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 283069 WHERE `CreatureID` = 239944 AND `GroupID` = 0;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 295701 WHERE `CreatureID` = 249272 AND `GroupID` = 0;
UPDATE `world`.`creature_text` SET `BroadcastTextId` = 296434 WHERE `CreatureID` = 250590 AND `GroupID` = 0;
