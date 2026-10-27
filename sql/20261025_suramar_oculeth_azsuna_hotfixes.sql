-- Custom normal (non-cosmetic) phases for the 44873-44876 Azsuna segment.
-- VerifiedBuild matches the client build used by the other custom Suramar phases (60010, 60030-60036).
DELETE FROM phase WHERE ID BETWEEN 60043 AND 60047;
INSERT INTO phase (ID, Flags, VerifiedBuild) VALUES
(60043,8,70391),
(60044,8,70391),
(60045,8,70391),
(60046,8,70391),
(60047,8,70391);
