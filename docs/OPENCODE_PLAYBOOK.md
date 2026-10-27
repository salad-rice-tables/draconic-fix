# OPENCODE PLAYBOOK - how to repair quests in this server's DB and Lua (read together with the two SKILL.md files)

Everything here was learned while fixing the Midnight (Arator/Hammerfall/Burning Steppes) and Suramar (Nightborne) questlines.
Real examples live in `C:\WowServer\Custom\sql\2026102*.sql` and `lua\suramar_*.lua`, `hammerfall_*.lua`, `relics_*.lua`, `final_relic.lua`, `scarlet_power.lua`, `infusion_relics.lua`: COPY the pattern from the closest example.
Long history/quirks of every tested quest: `C:\Users\brani\.claude\projects\C--Games-Wow\memory\midnight-questline-progress.md` (70 KB, read the part about the questline you touch).

## A. Helper scripts (all in `C:\WowServer\Custom\tools`, run with `python`)
| Script | Use |
|---|---|
| `oc_questinfo.py QID [QID...]` | FIRST thing for every quest: template, chain, objectives with credit source, starters/enders with spawns, phase (cosmetic flag), gossip menu existence, dead SAI areatriggers, phase conditions, rewards |
| `oc_char.py [Name]` | character state: online/map/pos, quests in log, rewarded |
| `oc_db.py <db> "<sql>"` / `oc_db.py -f <db> file.sql` | run SQL (db: world, hotfixes, characters, tdb1210_world) |
| `oc_find_text.py "phrase"...` | retail BroadcastText ID + SoundKit for a line |
| `oc_lua_deploy.py lua\x.lua` / `--errors` | syntax warnings (invalid escapes, [dbg]), copy to server, list Eluna ERRORs after `.reload eluna` |
| `oc_clean_go.py <retailEntry> <newEntry> [name]` | clean own GO template copy that the client can click |
| `qaudit.py`, `qsurvey.py`, `restore_obj.py QID` | bulk static audit vs TDB; restore objectives from TDB (careful: Suramar world objectives deliberately differ for some quests, e.g. 44672, 40747) |
| `soap_cmd.py ".cmd"` | GM command over SOAP (never `.reload eluna`) |
| `restart_world.ps1` | restart worldserver (batch changes first, owner must re-login) |
| `wowctl.py` | drive the game client (see wow-computer-use) |
| `wh_search.py`, `wh_coords.py` | Wowhead lookups (playwright) |

## B. Diagnosis table: symptom -> cause -> fix
| Symptom | Likely cause | Fix |
|---|---|---|
| NPC not visible | spawn `PhaseId` not granted to this character; zone has only quest phases; spawn missing | section D (phasing); add `(AreaId,169)` to phase_area or move spawn to own phase 60010/60020; or spawn it |
| NPC visible, no "!"/not clickable | creature_template_gossip -> gossip_menu row missing; npcflag lacks 1/2; faction hostile; cosmetic phase; SmartAI blocks Lua | `INSERT gossip_menu (MenuID,TextID)`; point to menu `999999999` (exists, TextID 999999999); set npcflag; faction 35; AIName='' |
| Quest not offered | starter row missing; Prev/Exclusive/conditions; race restriction; level | check quest_template_addon, conditions type 19/20, creature_queststarter |
| Quest completes immediately | leftover SAI credit (e.g. on areatrigger/spell) or objective with credit NPC fired on accept | `DELETE FROM smart_scripts WHERE ...`; check Lua event 54 handlers |
| Quest can never complete | objective whose credit nothing gives (type 19/20/21 hidden, credit NPC without spawn, GO objective without click) | remove the dead objective row (documented in sql) or script the credit in Lua |
| Credit from SAI never fires | SAI source_type 12 entry (9106xxx) is not a real areatrigger (`oc_questinfo.py` says DOES NOT EXIST) | give credit in Lua: area event 47 (AreaTable id from `docs\wago_csv\AreaTable_*.csv`) or proximity timer |
| GO not clickable | (1) GO is ~20 yd ABOVE/below the real floor (retail copy from another map: compare Z with sibling spawns and stand on the floor with `.gps`; tooltip shows but right-click says too far) - FIRST check this; (2) goober template lock/spell/playerCondition cached by client; (3) cosmetic phase | (1) fix Z with `UPDATE gameobject SET position_z=...` / `.gobject move` at floor level; (2) `oc_clean_go.py`, `.reload gameobject_template`, re-spawn GO; (3) own phase |
| GO/NPC absent although spawn row exists | its `PhaseId` is in NO `phase_area` row (nobody gets the phase; `oc_questinfo.py` prints this) or phase_area was inserted after the server started | add phase_area + conditions, restart once, re-enter the area |
| Fresh character far from the quest hub | `playercreateinfo` start position differs (Nightborne start 288,3352 vs Thalyssra 1714,4631) | teleport at first login in Lua (`nightborne_start.lua`) |
| GO script never runs | wrong signature (must be `(event, player, go)`); GO spawned before script registered | fix signature; delete + `.gobject add` again |
| Lua script has no effect at all | compile error (e.g. `"\I"`) | `oc_lua_deploy.py --errors`; fix; `.reload eluna` |
| Talk objective never counts | used KilledMonsterCredit for a type 3 objective | `player:TalkedToCreature(entry, creature)` |
| Gossip option on an NPC that ends the in-progress quest never shows | client sends quest-hello to such NPCs | proximity watcher (RegisterEvent loop + GetNearestCreature) |
| Teleport loops/stuck loading | custom AreaTrigger re-teleports on arrival | arrive outside trigger radius, teleport once per quest |
| Progress vanished | worldserver restarted before save | re-accept quest |
| Char dead, commands ignored | ghost form | worldserver console `.revive <Name>` |

## B2. GameObject template Data fields depend on the TYPE
- type 10 goober: Data0 lock, Data1 quest, Data3 autoClose, Data10 spell, Data14 playerCondition -> any non-zero lock/spell/condition can block the click; use a clean copy.
- type 2 questgiver (e.g. Ancient Seed Holder, Moonshade Relic): Data0 lock/open, Data1 questList, Data10 conditionID1; Data14 unused. Do not apply the goober rule blindly; check Z/phase/ender row first.
- `gameobject_template_addon.flags` 36 (INTERACT_COND|NODESPAWN) on quest GOs is normal.
- Core sources for ground truth: `GameObjectData.h`, `GameObject.cpp`, `ObjectMgr.cpp` under the TrinityCore source tree (grep before guessing).

## B3. Misc facts
- Logs have timestamp suffixes: `Server_<date>_<time>.log`, `Eluna_<date>_<time>.log`, `GM_<date>_<time>.log` (GM log shows every GM command with the player position - use it to find who moved/added what). Use `oc_lua_deploy.py --errors` instead of guessing names.
- Table homes: `phase`, `area_table`, `area_trigger`, `broadcast_text` = `hotfixes`; `character_queststatus*` = `characters`; quests/creatures/GOs/conditions/phase_area = `world`.
- Phase data (phase_area, hotfixes.phase) is read at server start; check uptime (`soap_cmd.py ".server info"`) against when the row was inserted before blaming the data.
- A spawn that looks right in DB may sit at the GM's feet from `.gobject add/move`: validate Z against the floor.

## C. SQL cookbook (write all changes into `sql\YYYYMMDD_topic.sql`, idempotent: DELETE then INSERT; apply with `oc_db.py -f world file.sql`)

```sql
-- quest starter / ender
DELETE FROM creature_queststarter WHERE id=<npc> AND quest=<q>;  INSERT INTO creature_queststarter (id,quest) VALUES (<npc>,<q>);
DELETE FROM creature_questender   WHERE id=<npc> AND quest=<q>;  INSERT INTO creature_questender   (id,quest) VALUES (<npc>,<q>);
-- (same with gameobject_queststarter / gameobject_questender)

-- remove a dead / shortcut objective or SAI
DELETE FROM quest_objectives WHERE QuestID=<q> AND StorageIndex=<n>;
DELETE FROM smart_scripts WHERE source_type=12 AND entryorguid=<atid> AND id=<id>;     -- shortcut credit on an areatrigger
UPDATE creature_template SET AIName='' WHERE entry=<npc>;  DELETE FROM smart_scripts WHERE source_type=0 AND entryorguid=<npc>;   -- hand the NPC to Lua

-- gossip so the NPC is clickable and Lua hello works
INSERT INTO gossip_menu (MenuID,TextID,VerifiedBuild) VALUES (<menu>,<text>,0);          -- or reuse menu 999999999
DELETE FROM creature_template_gossip WHERE CreatureID=<npc>;
INSERT INTO creature_template_gossip (CreatureID,MenuID,VerifiedBuild) VALUES (<npc>,<menu>,0);
UPDATE creature_template SET npcflag=npcflag|1 WHERE entry=<npc>;                       -- gossip flag
INSERT INTO npc_text (ID,Probability0,BroadcastTextID0,VerifiedBuild) VALUES (<id>,1,<broadcastTextId>,0);   -- own ids 91088xx

-- phasing: visible only while quest is active/complete/rewarded
INSERT INTO phase_area (AreaId,PhaseId,Comment) VALUES (<area>,<phase>,'text');
INSERT INTO conditions (SourceTypeOrReferenceId,SourceGroup,SourceEntry,SourceId,ElseGroup,ConditionTypeOrReference,ConditionTarget,ConditionValue1,ConditionValue2,ConditionValue3,NegativeCondition,ErrorType,ErrorTextId,ScriptName,Comment)
VALUES (26,<phase>,<area>,0,0,47,0,<quest>,74,0,0,0,0,'','why');       -- 2 complete, 8 in progress, 64 rewarded, 74 = any; NegativeCondition=1 inverts; extra ElseGroup = OR
-- fresh character that skipped earlier quests: add ElseGroup rows for the quest being played (see sql\20261025_suramar_ancient_gift_start.sql)

-- spawn creature (columns: guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,modelid,equipment_id,position_x,y,z,orientation,spawntimesecs,wander_distance,currentwaypoint,curHealthPct,MovementType,npcflag,unit_flags,unit_flags2,unit_flags3,ScriptName,StringId,VerifiedBuild,size)
-- spawn GO     (guid,id,map,zoneId,areaId,spawnDifficulties,phaseUseFlags,PhaseId,PhaseGroup,terrainSwapMap,position_x,y,z,orientation,rotation0..3,spawntimesecs,animprogress,state,ScriptName,StringId,VerifiedBuild,size,visibility)
-- guids for own spawns: 9108xxxxxx range, check free first. Easiest for GOs: `.gobject add <entry>` in game at the right spot (writes the DB row).
-- a phase-0 spawn is the simplest and always visible; use it when visibility rules are not essential.
```
- `hotfixes.phase` Flags: 8 = normal, 20 = cosmetic (GOs in cosmetic phases were not clickable). Own phases 60010, 60020 are Flags 8. New phases need a hotfixes row (restart).
- Reload without restart (SOAP, `tools\soap_cmd.py`): `.reload conditions`, `quest_template`, `gameobject_template`, `creature_template`, `smart_scripts`, `creature_queststarter`, `creature_questender`. Restart needed for: creature/gameobject spawns done in SQL (live: `.gobject add`), phase_area, hotfixes tables, creature_template_gossip/AIName/npcflag changes on already-spawned creatures.

## D. Lua cookbook (deploy with `oc_lua_deploy.py`, reload `.reload eluna` in game, one file per questline, header comment says which quests/sources)

```lua
-- Standard helpers (copy)
local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or {}; return st[k] end
local function fill(t, p) return (t:gsub("%$n", p:GetName()):gsub("%$p", p:GetName())) end

-- Dialogue with pauses + soundkits (2-3 s pause after each line; text/sound from oc_find_text.py)
local function play(player, lines)       -- lines = { {npcEntry, "text", soundKit}, ... }
    local t = 100
    for _, l in ipairs(lines) do
        player:RegisterEvent(function(_, _, _, p)
            local n = p:GetNearestCreature(120, l[1])
            if n then n:SendUnitSay(fill(l[2], p), 0); n:PlayDistanceSound(l[3]) end
        end, t, 1)
        t = t + math.max(2000, #l[2] * 75) + 2500
    end
end

-- Quest accept/complete/abandon hook (3 accepted, 1 complete, 0 abandoned). Reset per-player state here.
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= QID then return end
    st[tostring(player:GetGUIDLow())] = nil
    if status == 3 then play(player, { {NPC, "text", 12345} }) end
end)

-- Creature gossip option -> credit (npc must have AIName='' and a gossip_menu row; use quest-hello caveat for enders)
RegisterCreatureGossipEvent(NPC, 1, function(event, player, creature)
    if not player:HasQuest(QID) or S(player).done then return false end      -- false = default behaviour
    player:GossipClearMenu(); player:GossipAddQuests(creature)
    player:GossipMenuAddItem(0, "(Quest) option text", 0, 1)
    player:GossipSendMenu(999999999, creature)                              -- npc_text id
    return true
end)
RegisterCreatureGossipEvent(NPC, 2, function(event, player, creature, sender, intid)
    player:GossipComplete()
    if S(player).done or not player:HasQuest(QID) then return end
    S(player).done = true
    player:KilledMonsterCredit(CREDIT_NPC, 0)         -- type 0 objective; TALKTO type 3: player:TalkedToCreature(entry, creature)
end)

-- GameObject click. Two DIFFERENT hooks, two argument orders (both verified in this core):
--   RegisterGameObjectGossipEvent(entry, 1, function(event, player, go))   -- gossip hello: PLAYER first (used by coils, seals, beacon: tested)
--   RegisterGameObjectEvent(entry, 14, function(event, go, player))        -- GAMEOBJECT_EVENT_ON_USE: GO first
-- Never mix them. Return true = handled. GO objective credit: player:KillGOCredit(goEntry)
RegisterGameObjectGossipEvent(GO, 1, function(event, player, go)
    if not player:HasQuest(QID) then return false end
    player:KillGOCredit(GO_CREDIT_ENTRY)
    return true
end)

-- Area credit (replaces dead SAI areatriggers): area ids from docs\wago_csv\AreaTable_*.csv, check live with a temporary SendBroadcastMessage of newArea
RegisterPlayerEvent(47, function(event, player, oldArea, newArea)
    if newArea == AREA and player:HasQuest(QID) then player:KilledMonsterCredit(CREDIT_NPC, 0) end
end)

-- Proximity watcher (needed when the NPC is the ender and gets quest-hello instead of gossip-hello)
player:RegisterEvent(function(id, _, _, p)
    if not p:HasQuest(QID) then p:RemoveEventById(id) return end
    if p:GetNearestCreature(8, NPC) then p:RemoveEventById(id); p:KilledMonsterCredit(CREDIT_NPC, 0) end
end, 2000, 0)

-- Kill-based credit for hidden objectives
RegisterCreatureEvent(MOB, 4, function(event, creature, killer) local p = killer and killer:ToPlayer(); if p and p:HasQuest(QID) then p:KilledMonsterCredit(CREDIT_NPC, 0) end end)

-- Teleport (once, after a short delay): player:Teleport(map, x, y, z, o)
-- Spawn a hostile helper mob: player:SpawnCreature(entry, x, y, z, o, 8, 60000)  -- then m:AttackStart(player)
-- Level change at first login: RegisterPlayerEvent(30, ...) + player:SetLevel(n)
```
Rules: never leave `[dbg]` output; keep state in `st` and reset it on quest status events; Lua state is lost on `.reload eluna` (re-derive from quest status when possible); `.reload eluna` between spawning a GO and testing it breaks its hook.

## E. Complete fix procedure (follow literally)
1. `python oc_questinfo.py <QID...>`; read every `!!` line. Compare objectives with Wowhead/warcraft.wiki.gg (retail truth). Check `docs\nightfallen_audit.txt` / `docs\suramar_survey.txt` for known flags of the chain.
2. For each problem choose the fix from section B. Write `sql\YYYYMMDD_<topic>.sql` and `lua\<topic>.lua` (copy the closest existing example). Texts/sounds only from `oc_find_text.py`.
3. Apply: `python oc_db.py -f world sql\...sql`; SOAP reloads from section C; `python oc_lua_deploy.py lua\<topic>.lua`; in game `.reload eluna`; then `python oc_lua_deploy.py --errors` must show 0 new errors.
4. Anything that needs a restart goes to a batch list; do all non-restart work first, restart ONCE (`restart_world.ps1`), tell the owner (Slovak) to log in, wait.
5. Test in the real game start to finish (wow-quest-verify section 4). Fix, retest. Clean up temporary spawns/debug.
6. Update `midnight-questline-progress.md` (one bullet per quest: what was wrong, what fixed, how tested, quirks) and the work queue in `C:\Games\Wow\START_PROMPT.md` section 8.
7. If a tool/script/instruction was wrong or missing, fix it or add it (new helper -> tools\oc_*.py + row in section A) so the next session benefits.

## F. Known retail-fidelity limits (do not fake, just report)
- No Eluna currency API: quests that cost/give currencies (e.g. Ancient Mana) cannot charge/credit it.
- Many Legion lines have no soundkit in hotfixes (play text only).
- Retail cutscenes/scenes/movies: only play what exists (turn-in cutscenes already work); if a PlayMovie ID is needed, ask the owner to run it in game and describe it.
- Nightborne start: they begin at level 45 via `lua\nightborne_start.lua`, Thalyssra offers 40324 directly, no race lock.

## G. Autonomy contract
You may without asking: read anything, query DBs, edit/create files under `C:\WowServer\Custom`, copy Lua to the server, SOAP reloads (not eluna), test in game with GM helpers listed in the SKILL, record notes.
Ask the owner (Slovak, short) before: restarting worldserver, deleting anything you did not create, altering unrelated systems, anything needing his login, any outside-the-machine action.
Work in loops: audit -> fix -> test -> record -> next quest. Keep going until the queue in START_PROMPT.md section 8 is empty; refresh that queue from `docs\nightfallen_audit.txt` and the questline CSVs when you run out.
