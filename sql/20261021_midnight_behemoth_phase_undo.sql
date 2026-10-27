UPDATE creature c JOIN bak_20261021_behemoth_cr b ON b.guid=c.guid SET c.PhaseId=b.PhaseId;
UPDATE creature_template t JOIN bak_20261021_behemoth_ct b ON b.entry=t.entry SET t.faction=b.faction, t.unit_flags=b.unit_flags;
