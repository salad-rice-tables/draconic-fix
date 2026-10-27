-- The Waning Crescent, second half: custom phases used by 20261025_suramar_waning_crescent_2.sql.
-- hotfixes.phase is keyed by (ID, VerifiedBuild); Flags=8 marks a server-defined phase.
DELETE FROM phase WHERE ID IN (60053,60055,60056);
INSERT INTO phase (ID,Flags,VerifiedBuild) VALUES
(60053,8,70391),
(60055,8,70391),
(60056,8,70391);
