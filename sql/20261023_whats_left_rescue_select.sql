-- 86639: rescue credit on gossip option select (not on open)
UPDATE smart_scripts SET event_type=62,event_param1=912046764,event_param2=0,comment=REPLACE(comment,'Gossip hello','Gossip select') WHERE source_type=0 AND entryorguid=251539 AND id IN (101,102);
UPDATE smart_scripts SET event_type=62,event_param1=912046763,event_param2=0,comment=REPLACE(comment,'Gossip hello','Gossip select') WHERE source_type=0 AND entryorguid=251540 AND id IN (101,102);
UPDATE smart_scripts SET event_type=62,event_param1=912046762,event_param2=0,comment=REPLACE(comment,'Gossip hello','Gossip select') WHERE source_type=0 AND entryorguid=251542 AND id IN (101,102);
UPDATE smart_scripts SET event_type=62,event_param1=912046761,event_param2=0,comment=REPLACE(comment,'Gossip hello','Gossip select') WHERE source_type=0 AND entryorguid=251543 AND id IN (101,102);
