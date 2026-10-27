DELETE FROM creature WHERE guid IN (3000500830,3000500831);
DELETE FROM gossip_menu_option WHERE MenuID=912046759 AND OptionID IN (1,2,3);
DELETE FROM conditions WHERE SourceTypeOrReferenceId=15 AND SourceGroup=912046759 AND SourceEntry IN (1,2,3);
DELETE FROM smart_scripts WHERE entryorguid=242099 AND source_type=0 AND id IN (110,111,112);
