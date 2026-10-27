-- 86643: scene identical to `.scene playpackage 4551` (Flags 0) for the Arator "Play Movie" gossip
DELETE FROM scene_template WHERE SceneId=9108603;
INSERT INTO scene_template (SceneId,Flags,ScriptPackageID,Encrypted,ScriptName,RTComment) VALUES (9108603,0,4551,0,'','12.0.0_[ZFA]_Zul''jan_First_Appearance_IGC (playpackage 4551, flags 0)');
UPDATE smart_scripts SET action_param1=9108603,comment='Gossip select: play scene 9108603 (package 4551 Zul''jan First Appearance IGC, flags 0)' WHERE source_type=0 AND entryorguid=236610 AND id=103;
