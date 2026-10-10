# Gossip-kredit quest (vzor Rising Storm 92061)

Overený funkčný postup pre quest typu „poraď sa s NPC cez gossip button → kredit + say".
Kredit ide PRIMÁRNE cez Elunu (jediná overená cesta kliku), SmartAI riadky len ako záloha.

## 1. DB: gossip menu + text (odoslovne z Wiki)

- `hotfixes.broadcast_text` (ID 99xxxxx): `Text` = text okna, **`LanguageID = 0`** (nie 7!
  Common scrambluje Horde hráčom), `Text1 = ''`.
- `world.npc_text` (ID 95xxxxx): `Probability0 = 1`, `BroadcastTextID0` = broadcast ID.
- `world.gossip_menu` (MenuID 40xxx, voľné): `TextID` = npc_text ID.
- `world.gossip_menu_option`: `OptionNpc = 0` (None! 3 = Trainer = mŕtvy button),
  **`GossipOptionID = MenuID`** (pri 0 jadro autogeneruje záporné ID a SmartAI
  `(menu,action)` sa nikdy nezhoduje — pozri `GossipDef.cpp`, `NPCHandler.cpp:344`),
  `OptionID = 0`, `OptionText` = text buttonu.
- `world.creature_template_gossip`: `CreatureID → MenuID` (BEZ linku button neexistuje!).

## 2. Eluna: kredit + repliky (`Custom/lua/*.lua`, po zmene reštart kopíruje)

```lua
local SaidAt, COOLDOWN = {}, 180 -- krizova replika max raz za 180 s na hraca
RegisterCreatureGossipEvent(NPC_ENTRY, 2, function(_, player, creature, _, intid)
    if intid == 0 then
        pcall(function() player:KilledMonsterCredit(CREDIT_ENTRY) end)
        if creature then pcall(function() creature:SendUnitSay("...", 0) end) end
        -- krizova replika ineho NPC o 3000 ms (player:RegisterEvent, GetCreaturesInRange), len mimo cooldown
    end
end)
```

Pozor: Eluna select-hook beží PRED SmartAI (`NPCHandler.cpp`) a môže ho blokovať —
preto kredit NIKDY nespoliehať len na SmartAI.

## 3. SmartAI záloha (nepovinná, kredit je idempotentný)

`smart_scripts`: `(ENTRY, 0, 0, link, '', 62, 0, 100, 0, MENUID, 0, ...)` akcia 33
(`CALL_KILLEDMONSTER`, target 7 = invoker). **POZOR: `entryorguid` KLADNÉ = entry šablóny**
(všetky spawny); záporné = konkrétny spawn guid a riadok sa nenačíta
(`SmartScriptMgr.cpp`, `LoadSmartAIFromDB`, chyba `guid (X) does not exist`)!
Say-cez-SmartAI po buttone NEPOUŽÍVAŤ (duplicita s Elunou) — say patria do Eluny.

## 4. Fázy a viditeľnosť

- Každé questové NPC musí mať spawn vo fáze, kde quest prebieha ( retail fázy: `phase_name`,
  kľúčové `45749 'Rising Storm'`). Chýbajúci spawn = aditívny custom spawn
  (nový guid 3001001xxx, kópia retail riadka, len iné `PhaseId`).
- POI body (`quest_poi`/`quest_poi_points`) musia sedieť na spawny (kontrola SELECTom).
- POZOR na dvojníkov: rovnaké meno ≠ rovnaké entry (Bellamy 250587 faction 14
  vs 9100622 faction 35) — overiť `creature_template.faction` + Wowhead tooltip.

## 5. Jazyky

- Vlastné texty len anglicky, BEZ locale riadkov (fallback = default).
- Retail quest-locale riadky (deDE/frFR v `quest_template_locale`, `quest_objectives_locale`,
  `quest_offer_reward_locale`, `quest_request_items_locale`) prepisujú klienta:
  pre EN-vždy prepísať default-angličtinou (JOIN UPDATE), originál do undo súboru.

## 6. Nasadenie + overenie

1. SQL súbor + `_undo.sql` (konvencia `Custom/sql/RRRRMMDD_nazov.sql`).
2. Aplikovať, overiť SELECTom (linky, menu→text→button, smart riadky).
3. Reštart `Custom/tools/restart_world.ps1` (gossip/smart/lua sa čítajú pri štarte).
4. Kontrola: `ready` v Server.logu, `DBErrors` prázdny, Eluna `Successfully loaded`.
5. Herný test: text okna EN → button kliká → kredit + say NPC + say vedľajšieho NPC.
