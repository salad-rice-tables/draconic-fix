# Necromancer Runic Power audit (2026-11-17)

**Where the bar is:** thin blue bar directly under the health bar of the player frame ("0 / 100"). The pool is 1000 internally, the UI shows it /10 (spell data uses the same 1000 scale: cost 300 = 30 RP).

**Verified in game (Haluash, lvl 80):**
- Glacial Tap (CoA 805369, energize 300) raises the bar 0 -> 276 (decays out of combat like every runic power pool, ~5-6 per second).
- A real, paid cast of Harvest Plague (cost 200) spends exactly 200 (259 -> 59). Spending works.

**Data audit (CoA spell data vs ours):**
- 16 Necromancer spells cost Runic Power in CoA: Plaguebomb 9999, Expunge 999, Harvest Plague 200, NYI 400, Crypt Plague 150, Ice Barrage 300, Lich Bolt 400, Plague of Undeath 300, Unholy Command 250, Noxious Corpserot 300, Lichplague 300, Ray of Rot 300, Animate: Skeletal Smith 100. All identical in our `spell_power`.
- 17 energize-runic effects exist in CoA data; all are present in ours (Glacial Tap 300, Parasitic Infestation 32, Crypt Swarm tick 29, Putrefy 150, ...).
- Periodic energize: only Lich Form (30 per 5 s). Everything else "generating Runic Power" is an energize helper spell triggered by the parent (Flesh to Worms -> 804272, Crypt Swarm -> 800344, Soulfreeze -> 800344, Putrefy -> 804559, Lichfrost -> 804112): helper rows exist.

**Not ported (CoA C++ only):** Runic Power from Harvest Plague siphon (`HarvestPlagueSiphon`), Corpse-rot drain (562210, drained/2), 561138 (+300), 805649 (+100 on Command), refunds of Ray of Rot style spells (500307) and the talents that change costs (Command cost -5). Needs the Lua port of AscensionNecromancerAuras/Abilities.
