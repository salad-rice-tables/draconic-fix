-- UNDO for 20261021_vo_fix_converge --
UPDATE creature_text SET Text='I propose this: We will march on the Twilight cult and extinguish any utterings of Deathwing''s name from this realm.  Your Earthen Ring will march with us.', BroadcastTextId=43875, Sound=21099 WHERE CreatureID=23257 AND GroupID=1 AND ID=0 AND Type=12;
UPDATE creature_text SET Text='You do this, and I will send Gorsik to the temple with our piece of the World Pillar.', BroadcastTextId=0, Sound=0 WHERE CreatureID=23257 AND GroupID=2 AND ID=0 AND Type=12;
UPDATE creature_text SET Text='Save your thanks.  We march upon the Twilight Precipice as soon as our forces are gathered. I expect to see you on the battlefield.', BroadcastTextId=43878, Sound=21102 WHERE CreatureID=23257 AND GroupID=3 AND ID=0 AND Type=12;
UPDATE creature_text SET Text='I felt myself slipping away...', BroadcastTextId=0, Sound=0 WHERE CreatureID=91150 AND GroupID=0 AND ID=0 AND Type=12;
UPDATE creature_text SET Text='Ahh, to breathe again!', BroadcastTextId=0, Sound=0 WHERE CreatureID=91150 AND GroupID=0 AND ID=1 AND Type=12;
UPDATE creature_text SET Text='Bless you, stranger!', BroadcastTextId=0, Sound=0 WHERE CreatureID=91150 AND GroupID=0 AND ID=2 AND Type=12;
UPDATE creature_text SET Text='Throg will spar with you for now. I must speak to the crew about the rain.', BroadcastTextId=0, Sound=0 WHERE CreatureID=166824 AND GroupID=0 AND ID=0 AND Type=12;
UPDATE creature_text SET Text='Throg will spar with you for now. I must speak to the crew about the rain.', BroadcastTextId=199040, Sound=156952 WHERE CreatureID=166824 AND GroupID=2 AND ID=0 AND Type=12;
