-- UNDO: 20261010_abyss_english.sql (vracia povodne deDE/frFR texty).
UPDATE `world`.`quest_template_locale` SET `LogTitle` = 'Terrasse der Magister: Heimkehr', `LogDescription` = 'Trefft Magister Umbric auf der Insel von Quel''Danas und schließt dann den Dungeon "Terrasse der Magister" ab.', `QuestDescription` = 'Durch das riesige Portal wissen wir, dass es innerhalb des Leerensturms eine Landmasse gibt. Wenn wir sie erreichen, könnten wir den Kampf zu Xal''atath tragen.

Ich habe den Schlüssel gefunden; ein Relikt, das man als Anziehungspunkt des Zwielichts kennt. Es zeigt unerreichbare Wege zu unendlichen unbekannten Welten und stellt uns schon seit Äonen vor ein Rätsel.

Laut meiner Forschung sollte ich mit seiner Hilfe einen Weg in den Sturm öffnen können.

Es gibt nur ein Problem: Der Anziehungspunkt des Zwielichts befindet sich auf der Terrasse der Magister, und ich... stehe im Moment nicht gerade in ihrer Gunst.', `AreaDescription` = '', `PortraitGiverText` = '', `PortraitGiverName` = '', `PortraitTurnInText` = '', `PortraitTurnInName` = '', `QuestCompletionLog` = 'Trefft Magister Umbric in der Dämmerglühgloriette in Silbermond.' WHERE `ID` = 86543 AND `locale` = 'deDE';
UPDATE `world`.`quest_template_locale` SET `LogTitle` = 'Leerensturm', `LogDescription` = 'Sprecht mit Magister Umbric im Sanktum des Lichts in Silbermond.', `QuestDescription` = 'Magister Umbric hat einen Plan, den Leerensturm zu infiltrieren und die Verschlingende Schar direkt zu bekämpfen.

Das wird keine einfache Aufgabe, und er stellt gerade eine kleine aber starke Truppe zusammen, um direkt ins Herz des Feindes vorzustoßen.', `AreaDescription` = '', `PortraitGiverText` = '', `PortraitGiverName` = '', `PortraitTurnInText` = '', `PortraitTurnInName` = '', `QuestCompletionLog` = '' WHERE `ID` = 89388 AND `locale` = 'deDE';
UPDATE `world`.`quest_template_locale` SET `LogTitle` = 'Gewitterfront', `LogDescription` = 'Deeskaliert die zunehmenden Spannungen in Silbermond.', `QuestDescription` = 'Das war eine entropische Welle. Wir haben sie gespürt, kurz bevor Xal''atath ihren Angriff auf den Sonnenbrunnen begonnen hat.

Champion, Ihr bewegt Euch schneller als meine besten Boten. Erkundigt Euch bei den Kommandanten der Vorhut, ob ihre Verteidigung diesem jüngsten Angriff von Xal''ataths Verschlingender Schar standhalten kann.', `AreaDescription` = '', `PortraitGiverText` = '', `PortraitGiverName` = '', `PortraitTurnInText` = '', `PortraitTurnInName` = '', `QuestCompletionLog` = '' WHERE `ID` = 92061 AND `locale` = 'deDE';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Trefft Magister Umbric auf der Insel von Quel''Danas' WHERE `ID` = 457696 AND `locale` = 'deDE';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Rencontrez le Magister Umbric sur l''île de Quel''Danas.' WHERE `ID` = 457696 AND `locale` = 'frFR';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Bergt den Anziehungspunkt des Zwielichts und schließt die Terrasse der Magister ab' WHERE `ID` = 457819 AND `locale` = 'deDE';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Récupérez le Cynosure du Crépuscule et nettoyez la Terrasse des Magistères' WHERE `ID` = 457819 AND `locale` = 'frFR';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Sprecht mit Umbric, um Euch in die Warteschlange für Anhängerdungeon einzureihen' WHERE `ID` = 457825 AND `locale` = 'deDE';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Parlez à Umbric pour vous inscrire dans la file d''attente du donjon des sujets.' WHERE `ID` = 457825 AND `locale` = 'frFR';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Hochexarch Turalyon konsultiert' WHERE `ID` = 464495 AND `locale` = 'deDE';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Le haut exarque Turalyon a été consulté.' WHERE `ID` = 464495 AND `locale` = 'frFR';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'Vorhut des Lichts konsultiert' WHERE `ID` = 464496 AND `locale` = 'deDE';
UPDATE `world`.`quest_objectives_locale` SET `Description` = 'L''Avant-garde de la Lumière a été consultée' WHERE `ID` = 464496 AND `locale` = 'frFR';
UPDATE `world`.`quest_offer_reward_locale` SET `RewardText` = 'Das hätte besser laufen können. 

Aber andererseits hat Rommath mich am Leben gelassen, es hätte also auch schlimmer laufen können.' WHERE `ID` = 86543 AND `locale` = 'deDE';
UPDATE `world`.`quest_offer_reward_locale` SET `RewardText` = 'Ça aurait pu mieux se passer. Mais bon, Rommath ne m''a pas encore tué. Ça aurait pu être pire.' WHERE `ID` = 86543 AND `locale` = 'frFR';
UPDATE `world`.`quest_offer_reward_locale` SET `RewardText` = 'Gut gemacht. Dieser Leerensturm löst in allen, die ihn sehen, Angst und Schrecken aus, auch in mir.

Aber ich habe mich dazu entschieden, mich dem Bösen zu stellen und ihm ins Gesicht zu spucken. Leider hatten nicht alle den Luxus, diese Entscheidung treffen zu können.' WHERE `ID` = 92061 AND `locale` = 'deDE';
UPDATE `world`.`quest_offer_reward_locale` SET `RewardText` = 'Bravo. Cette Tempête du Vide inspire la peur et la terreur à tous ceux qui la voient, moi y compris. Mais j''ai choisi cette vie où je lutte contre le mal et le défie. Malheureusement, tout le monde n''a pas eu cette chance.' WHERE `ID` = 92061 AND `locale` = 'frFR';
UPDATE `world`.`quest_request_items_locale` SET `CompletionText` = 'Les tensions sont vives.' WHERE `ID` = 92061 AND `locale` = 'frFR';
