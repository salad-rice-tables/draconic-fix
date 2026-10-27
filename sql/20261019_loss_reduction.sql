-- =====================================================================
-- Loss Reduction (quest 25179, Durotar) — retail doplnenie
-- Retail (wowhead + warcraft.wiki.gg/wiki/Loss_Reduction):
--   * quest začína na Injured Razor Hill Grunt (39270)   [svet: bol len Gar'Thok 3139]
--   * odovzdáva sa Gar'Thokovi (3139)                     [bez zmeny]
--   * dostupný až po dokončení 25173 "From Bad to Worse"  [svet: PrevQuestID = 0]
-- Vlastný priebeh záchrany grunta (kredit do objektívu 256780, vstanie,
-- replika, sledovanie hráča, odbehnutie/despawn) je v lua/loss_reduction.lua —
-- SmartAI je na tomto jadre nahradené Eluna AI (SAI riadky sú mŕtve).
-- Undo: 20261019_loss_reduction_undo.sql
-- =====================================================================

-- 1) retail požiadavka reťazca: 25179 je dostupný až po dokončení 25173
UPDATE `quest_template_addon` SET `PrevQuestID` = 25173 WHERE `ID` = 25179 AND `PrevQuestID` = 0;

-- 2) retail štartér: Injured Razor Hill Grunt (39270)
--    (Gar'Thokov riadok 3139 nechávame — add-only; vďaka PrevQuestID je aj on
--     korektne viazaný na dokončený 25173)
INSERT IGNORE INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES (39270, 25179, 66384);
