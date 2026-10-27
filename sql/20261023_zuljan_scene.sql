-- 86643: Arator "Play Movie" gossip plays retail scene (ScriptPackage 4551 Zul'jan First Appearance IGC, SceneId 3629) instead of the hand-made conversation 9108601
UPDATE smart_scripts SET action_type=129,action_param1=3629,comment='Gossip select: play scene 3629 (package 4551 Zul''jan First Appearance IGC)' WHERE source_type=0 AND entryorguid=236610 AND id=103;
