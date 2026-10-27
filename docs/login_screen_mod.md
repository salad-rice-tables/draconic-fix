# Login screen – Classic hudba + džungľová scéna (Curse of Ula'tek vibe)

**Dátum:** 18.10.2026 (v2 – viacvrstvový bundle s diagnostikou)
**Klient:** 12.1.5.70448 (`C:\Games\Wow\World of Warcraft\_retail_`, `.build.info` potvrdzuje 70448)
**Typ:** client-side mod (3 nezávislé vrstvy) – žiadny zásah do servera.

## Čo to robí
- Login screen (a všetky glue obrazovky) hrá **pôvodnú Classic tému** „Legends of Azeroth“
  (`SOUNDKIT.MUS_1_0_MAINTITLE_ORIGINAL` = kit 47598 → fdid 53223).
- Pozadie login screenu je **džungľová 3D scéna** namiesto Midnight (Silvermoon) scény:
  `UI_MainMenu_Pandaria` (fdid 631713) s jemne zelenou hmlou (r 0.45 g 0.55 b 0.45).
- Midnight glue ambiencia (kit 315289/315290) sa prepne na Pandaren džungľovú (kit 25848 → fdid 604735).
- Presná „Curse of Ula'tek“ scéna v klientovi neexistuje (viď Fáza 2) – treba ju vyrobiť.

## Prečo 3 vrstvy (test = zistiť, ktorá cesta na 12.1.5 funguje)
Predchádzajúci test (v1: len launcher mapping na GlueParent.lua) **nefungoval** – príčina neznáma
(launcher je Native AOT – dekompilácia nemožná; konzola launcheru = jediný zdroj diagnostiky).
Preto je bundle postavený tak, aby každá vrstva vedela dosiahnuť výsledok sama a nechala za sebou stopu:

| Vrstva | Mechanizmus | Stopa pri úspechu |
|---|---|---|
| 1. Launcher interface mod | `mappings\light_plus.txt` → fdid 5612385 ← `files\Interface\AddOns\Blizzard_GlueParent\Mainline\GlueParent.lua` (tag **MOD**) | zelená hmla + `JUNGLE:MOD` pri verzi klienta |
| 2. Loose disk override | `_retail_\Interface\AddOns\Blizzard_GlueParent\Mainline\GlueParent.lua` (tag **DISK**) | zelená hmla + `JUNGLE:DISK` pri verzi klienta |
| 3. Launcher data replacement | `mappings\jungle.txt` → model 7550640/7673144 ← Pandaria M2 bajty; hudba 7713732/7670482 ← classic mp3 | Pandaria scéna (s **červenou** hmlou, ak Lua nevrstva neúčinkuje) + classic hudba |

Interpretácia výsledku:
- **Zelená hmla + JUNGLE:MOD** → funguje launcher interface replacement (najuniverzálnejšia cesta).
- **Zelená hmla + JUNGLE:DISK** → funguje loose disk override (jednoduchšia, bez launcheru).
- **Pandaria scéna + červená hmla, bez markera** → funguje len data replacement (model/hudba), interface nie.
- **Len classic hudba** → data replacement funguje len pre zvuk (alebo Lua hudobný riadok prešiel).
- **Nič sa nezmení** → mods pipeline launcheru nebeží vôbec (rozhodne zistiť z konzoly launcheru:
  hľadaj `Modding Mode:`, `Loading file mappings from '...'`, `Loaded N file mappings.`, `No custom files.`).

## Zmenené/nové súbory (v2)
1. **`_retail_\files\Interface\AddOns\Blizzard_GlueParent\Mainline\GlueParent.lua`** (MOD, 32 655 B)
   - **Základ: reálny súbor z CASC pre build 70448** (fdid 5612385, 31 181 B, 916 riadkov, CRLF;
     stiahnutý `pm_GlueParentAddon.bin` = identický s `GlueParent_70448.lua`).
     Pozor: starý v1 súbor mal základ z Gethe `live` (825 riadkov) – **bol stalejší ako klient**, preto rebuild.
   - Syntax OK (luaparse, Lua 5.1). Záloha v1: `GlueParent.lua.bak_20261018b`.
   - Zmeny:
     1. `GlueParent_UpdateScreenSound`: `local musicSoundKit = SOUNDKIT.MUS_1_0_MAINTITLE_ORIGINAL or 47598;` (classic)
     2. tamtiež: ambiencia – ak by hrala Midnight (315289/315290), nahradí sa `SOUNDKIT.AMB_GLUESCREEN_PANDAREN or 25848`
     3. `SetLoginScreenModel` prepísaná: `model:SetModel(DRACONIC_LOGIN_MODEL=631713, true)` + camera/sequence 0 + zelená hmla
     4. **diagnostický marker** (na konci súboru): pri verzii klienta (vpravo dole)
        zobrazí zelené `JUNGLE:MOD` (alebo `JUNGLE:DISK` v disk kópii) – dokazuje, ktorá kópia sa načítala.
2. **`_retail_\Interface\AddOns\Blizzard_GlueParent\Mainline\GlueParent.lua`** (DISK, 32 656 B)
   - tá istá úprava, len tag `DISK`; otestuje, či klient preferuje loose súbor na disku pre Blizzard addon.
   - Bez TOC (zámerne – aby sa nenačítal ako duplicitný user addon).
3. **`_retail_\mappings\jungle.txt`** (nový, 4 riadky, presná CASC case):
   ```
   7550640;INTERFACE/GLUES/MODELS/UI_MAINMENU_MIDNIGHT/UI_MainMenu_Midnight_02.m2
   7673144;INTERFACE/GLUES/MODELS/UI_MAINMENU_MIDNIGHT/UI_MainMenu_Midnight_02_LowBandwidth.m2
   7713732;Sound/Music/Midnight/MUS_120_Midnight_Maintitle.mp3
   7670482;Sound/Music/Midnight/MUS_120_Midnight_Maintitle_Beta.mp3
   ```
4. **`_retail_\files\INTERFACE\GLUES\MODELS\UI_MAINMENU_MIDNIGHT\`** – oba login modely ← Pandaria M2 (564 412 B)
5. **`_retail_\files\Sound\Music\Midnight\`** – obe Midnight titulky ← classic mp3 (3 225 984 B)
6. **`_retail_\mappings\light_plus.txt`** – riadok `5612385;Interface/AddOns/Blizzard_GlueParent/Mainline/GlueParent.lua` (z v1, ostáva)
7. **`_retail_\WoW-Privat.bat`** – `--portal 127.0.0.1 --mods Full` (z v1, ostáva)
8. **`_retail_\revert_login_mod.bat`** – úplný revert experimentov (zmazať jungle.txt, files\Interface\GLUES,
   files\Sound, loose Blizzard_GlueParent, obnoviť v1 GlueParent.lua z `.bak_20261018b`).

## Zistenia o mechanike (12.1.5)
- Aktívne glue súbory sú **Blizzard addony** (nie legacy `Interface/GlueXML`):
  `Blizzard_GlueParent/Mainline/GlueParent.lua` (fdid 5612385; TOC má `## AllowLoad: Glue`, `LoadFirst: 1`),
  `Blizzard_GlueXML/Mainline/AccountLogin.lua/.xml`.
- **User addony sa v glue prostredí načítať nedajú** – wiki TOC_format: `AllowLoad` je
  „functionally inoperable for addons, as only Blizzard code works in the glue screen environment“.
  (Potvrdzuje aj pozorovanie: user addony sa na login screene nenačítali – SavedVariables sa nepísali.)
  Preto addon-cesta neexistuje; ideme cez výmenu Blizzard súborov / data.
- Hudba login: DB2 `UiExpansionDisplayInfo` riadok 149 (ExpansionLevel 11 = Midnight):
  `HighResBackgroundID=7550640`, `LowResBackgroundID=7673144`, `GlueMusicSoundKit=325423`
  (→ SoundKitEntry → fdid **7713732** `MUS_120_Midnight_Maintitle.mp3`), `GlueAmbianceSoundKit=315290`.
  (Kit 325421 → fdid 7670482 `..._Beta.mp3` – tiež pokryté.)
- Model frame: `AccountLogin.xml` → `<ModelFFX name="LoginBackgroundModel" fogNear=0 fogFar=1200 glow=0.08>`
  s `<FogColor r=0.25 g=0.06 b=0.015>` (tmavá červená = Midnight tón). Pri data replacement
  (bez Lua) teda scéna zdědí červenú hmlu – to je očakávané a rozlišuje vrstvy.
- `ResetModel`/`ResetLighting` (SetGlow 0.3, ClearFog) sa volá len pre char-select/char-create,
  nie pre login – naša hmla na login screene ostáva.
- Launcher: Native AOT (ILSpy: „PE file does not contain any managed metadata“) → dekompilácia nemožná;
  jediná diagnostika = konzola launcheru (hbá `Modding Mode:` / `Loaded N file mappings.` / `No custom files.`).
- Launcher mods sa už používali pre data súbory: `files\world\expansion06\doodads\warden\*` (cavelighty, marec 2026).

## Výmena scény
V oboch `GlueParent.lua` (MOD aj DISK) zmeniť `local DRACONIC_LOGIN_MODEL = 631713;` na:
| fdid | scéna |
|---|---|
| `631713` | Mists of Pandaria – džungľa (default) |
| `2743642` | Zandalari (trollská džungľa, char-create vignette) |
| `429097` | Troll vignette |
| `7550638` | Midnight (oficiálna 12.x, Silvermoon) |
| `7550640` | Midnight_02 (oficiálna login scéna 12.x) |
| `236122` | Wrath of the Lich King |
| `131970` | Classic / Vanilla (Dark Portal) |

Hmla: `DRACONIC_LOGIN_FOG = nil` → ponechá XML hmlu (Midnight červená).
Všetky fdidy overené v builde 70448; Pandaria m2 + skiny 631713–631717 tiež.

## Test (18.10.2026 večer)
1. Spustiť `C:\Games\Wow\World of Warcraft\_retail_\WoW-Privat.bat`
   (dôležité – nie launcher exe priamo, ten ide bez `--mods`).
2. Sledovať login screen a nahlásiť:
   - scéna: Midnight vs Pandaria džungľa,
   - hmla: červená vs zelená,
   - text pri verzií klienta (vpravo dole): je tam zelené `JUNGLE:MOD` / `JUNGLE:DISK`?
   - hudba: Midnight vs „Legends of Azeroth“ (classic),
   - ambiencia: iná než obvykle?
3. **Skopírovať CELÝ text z konzoly launcheru** (ostáva otvorená vďaka `pause`) – hľadať
   `Modding Mode:`, `Loading file mappings from '`, `Loaded N file mappings.`, `No custom files.`
4. Ak sa login screen rozbije (čierna obrazovka/prázdno): `_retail_\revert_login_mod.bat` a napíš.

## Revert
- `_retail_\revert_login_mod.bat` = všetko naraz (viď vyššie).
- Manuálne: zmazať `mappings\jungle.txt`; zmazať `files\Interface\GLUES`, `files\Sound`;
  zmazať `Interface\AddOns\Blizzard_GlueParent`; obnoviť `files\...\GlueParent.lua` z `.bak_20261018b`.
- Launcher bez mods: spustiť exe priamo (default `--mods Disable`) alebo zmeniť bat na `--mods Basic`.

## Fáza 2 – pravá Ula'tek scéna (návrh, neriešené)
- V klientovi **žiadna hotová** Ula'tek/Coiled Isle glue scéna neexistuje
  (grep listfile: `Coiled`/`Ulatek` len v `world/`, `spells/`, `sound/` – nie v `interface/glues`).
- Možnosti:
  - (a) vyrobiť vlastný M2 dioráma z Coiled Isle assetov (dreviny/ruiny/socha) + pomalá kamera;
    launcher vie pridať nové súbory (nový fdid, napr. `928002xxx`);
  - (b) lacnejšia cesta: upraviť existujúcu scénu (napr. Pandaria) výmenou textúr za tmavšiu
    džungľu (blesk/portál?) – hodiny práce namiesto dní.
- Odhad: (b) ~hodiny, (a) deň+ a riskantné (moderný M2 formát + shader).

## Poznámky
- Hudba sa prehráva na **všetkých glue obrazovkách** (login, realm list, výber postavy) – Classic pocit.
- Ambiencia: Midnight → Pandaren len ak sa naozaj hrá Midnight kit (315289/315290); iné (napr. char-select
  rasové) ostávajú. Hodnoty z `Blizzard_SharedXML/Mainline/SoundKitConstants.lua`.
- Fáza 1 **neotestovaná v hre** – test robí hráč (agent klient nespúšťa).
- Súvisiace: create-crash fix (CollectionMgr) čaká na deploy/reštart worldservera; legacy Amani quest reťaz (92901–93012).
