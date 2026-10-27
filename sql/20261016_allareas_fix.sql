-- ALL-AREAS batch 2026-10-16 rev2: len 1 oprava (ostatnych 12 riadkov SKIP - dovod nizsie).
-- q29406 'The Lesson of the Sandy Fist' ma starter+ender 53566 ale bez objektivov.
-- Objektiv 252339 ('Training Targets destroyed', TDB: quest 29406) visi na neexistujucom queste 90471
-- (ziaden template, ziadne linky) - retail-spravne prevesenie. UNDO: _undo.sql. RESTART nie je nutny (quest data sa citaju za behu? - worldserver reload quest_template; pre istotu restart).
UPDATE `quest_objectives` SET `QuestID`=29406 WHERE `ID`=252339;
-- SKIP 12 riadkov: retail questy 29419/29677/12842/49488/47952/57531/60129 maju LIVE custom klony
-- (ID*100+1: 2941901/2967701/1284201/4948800/4795200/5753100/6012900), ktore vlastnia rovnake objective-ID.
-- Pridanie retail kopii by zdvojilo ponuky questov (bug trieda z 10-10). Custom klon = hratelna verzia.
