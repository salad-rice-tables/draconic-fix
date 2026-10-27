-- Forgotten Pendant 548660: copy 990000000101167811 sat in phase 0 next to the quest-phase one (45608) in Umbric's lab, always visible.
CREATE TABLE IF NOT EXISTS bak_20261021_go_pendant AS SELECT * FROM gameobject WHERE guid=990000000101167811;
DELETE FROM gameobject WHERE guid=990000000101167811;
