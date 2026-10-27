UPDATE creature c JOIN bak_20261021_slickette_cr b ON b.guid=c.guid SET c.PhaseId=b.PhaseId;
UPDATE creature_template t JOIN bak_20261021_slickette_ct b ON b.entry=t.entry SET t.AIName=b.AIName;
DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=241807;
