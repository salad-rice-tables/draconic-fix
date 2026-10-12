-- =====================================================================
-- Living World: town routines (pilot: Orgrimmar, zone 1637).
--  * Citizens walk with a purpose: shop at a vendor (short haggling
--    dialogue with the vendor, emotes), visit the bank or auction house,
--    go home. At night they go to the inn and sleep or sit; at dawn they
--    go home. Orphans play: they run after heroes and sleep at home.
--  * Vendors hawk their goods (by their profession) when players are near.
-- Questgivers, vendors, trainers, guards and delegations keep their posts.
-- Points of interest are read from the DB at startup (vendor/bank/AH/inn
-- spawns), so the same code works for any town listed in TOWNS.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

-- Towns with routines: whole zones (cities) or single areas (villages).
-- Navmesh-only movement (custom core method MoveToSafe): never fly or cut
-- through walls when no walkable path exists. Falls back on older cores.
local function SafeMove(c, id, x, y, z)
    local ok, moved = pcall(function() return c:MoveToSafe(id, x, y, z) end)
    if ok then return moved end
    c:MoveTo(id, x, y, z, true)
    return true
end

local TOWNS = {
    [1637] = "zone",   -- Orgrimmar
    [362]  = "area",   -- Razor Hill (Durotar)
    [367]  = "area",   -- Sen'jin Village (Durotar)
    [380]  = "area",   -- The Crossroads (Northern Barrens)
    -- living world v2: every capital and every village with an inn
    [1519] = "zone",
    [1537] = "zone",
    [1638] = "zone",
    [1497] = "zone",
    [1657] = "zone",
    [3487] = "zone",
    [15969] = "zone",   -- Silvermoon City (Midnight)
    [3557] = "zone",
    [3703] = "zone",
    [4395] = "zone",
    [7502] = "zone",
    [13862] = "zone",
    [14771] = "zone",
    [42] = "area",
    [69] = "area",
    [75] = "area",
    [108] = "area",
    [117] = "area",
    [147] = "area",
    [152] = "area",
    [159] = "area",
    [186] = "area",
    [193] = "area",
    [222] = "area",
    [228] = "area",
    [286] = "area",
    [320] = "area",
    [321] = "area",
    [349] = "area",
    [415] = "area",
    [420] = "area",
    [431] = "area",
    [460] = "area",
    [484] = "area",
    [496] = "area",
    [513] = "area",
    [608] = "area",
    [657] = "area",
    [1024] = "area",
    [1437] = "area",
    [1438] = "area",
    [1497] = "area",
    [1637] = "area",
    [1659] = "area",
    [1704] = "area",
    [1739] = "area",
    [1885] = "area",
    [1998] = "area",
    [2101] = "area",
    [2102] = "area",
    [2104] = "area",
    [2268] = "area",
    [2408] = "area",
    [2897] = "area",
    [3197] = "area",
    [3317] = "area",
    [3462] = "area",
    [3487] = "area",
    [3488] = "area",
    [3507] = "area",
    [3536] = "area",
    [3538] = "area",
    [3552] = "area",
    [3554] = "area",
    [3576] = "area",
    [3584] = "area",
    [3613] = "area",
    [3626] = "area",
    [3644] = "area",
    [3645] = "area",
    [3683] = "area",
    [3684] = "area",
    [3703] = "area",
    [3738] = "area",
    [3744] = "area",
    [3745] = "area",
    [3754] = "area",
    [3766] = "area",
    [3769] = "area",
    [3772] = "area",
    [3844] = "area",
    [3898] = "area",
    [3918] = "area",
    [3938] = "area",
    [3951] = "area",
    [3966] = "area",
    [3988] = "area",
    [3991] = "area",
    [4003] = "area",
    [4010] = "area",
    [4018] = "area",
    [4037] = "area",
    [4087] = "area",
    [4108] = "area",
    [4113] = "area",
    [4122] = "area",
    [4129] = "area",
    [4152] = "area",
    [4158] = "area",
    [4159] = "area",
    [4161] = "area",
    [4165] = "area",
    [4177] = "area",
    [4186] = "area",
    [4204] = "area",
    [4206] = "area",
    [4211] = "area",
    [4275] = "area",
    [4284] = "area",
    [4323] = "area",
    [4379] = "area",
    [4380] = "area",
    [4395] = "area",
    [4418] = "area",
    [4422] = "area",
    [4428] = "area",
    [4429] = "area",
    [4441] = "area",
    [4477] = "area",
    [4484] = "area",
    [4532] = "area",
    [4560] = "area",
    [4601] = "area",
    [4659] = "area",
    [4691] = "area",
    [4805] = "area",
    [4821] = "area",
    [4843] = "area",
    [4844] = "area",
    [4846] = "area",
    [4847] = "area",
    [4853] = "area",
    [4854] = "area",
    [4882] = "area",
    [4933] = "area",
    [4937] = "area",
    [4939] = "area",
    [4969] = "area",
    [4970] = "area",
    [4975] = "area",
    [4976] = "area",
    [4989] = "area",
    [4990] = "area",
    [5002] = "area",
    [5003] = "area",
    [5005] = "area",
    [5012] = "area",
    [5024] = "area",
    [5049] = "area",
    [5056] = "area",
    [5062] = "area",
    [5072] = "area",
    [5073] = "area",
    [5084] = "area",
    [5093] = "area",
    [5117] = "area",
    [5136] = "area",
    [5137] = "area",
    [5138] = "area",
    [5140] = "area",
    [5141] = "area",
    [5142] = "area",
    [5143] = "area",
    [5148] = "area",
    [5150] = "area",
    [5154] = "area",
    [5169] = "area",
    [5170] = "area",
    [5305] = "area",
    [5320] = "area",
    [5323] = "area",
    [5386] = "area",
    [5458] = "area",
    [5466] = "area",
    [5470] = "area",
    [5471] = "area",
    [5496] = "area",
    [5497] = "area",
    [5564] = "area",
    [5565] = "area",
    [5628] = "area",
    [5637] = "area",
    [5645] = "area",
    [5649] = "area",
    [5670] = "area",
    [5687] = "area",
    [5700] = "area",
    [5726] = "area",
    [5728] = "area",
    [5730] = "area",
    [5867] = "area",
    [5935] = "area",
    [5950] = "area",
    [6007] = "area",
    [6013] = "area",
    [6049] = "area",
    [6071] = "area",
    [6094] = "area",
    [6095] = "area",
    [6128] = "area",
    [6166] = "area",
    [6174] = "area",
    [6197] = "area",
    [6308] = "area",
    [6315] = "area",
    [6333] = "area",
    [6349] = "area",
    [6354] = "area",
    [6355] = "area",
    [6356] = "area",
    [6358] = "area",
    [6359] = "area",
    [6360] = "area",
    [6361] = "area",
    [6362] = "area",
    [6363] = "area",
    [6364] = "area",
    [6365] = "area",
    [6366] = "area",
    [6367] = "area",
    [6369] = "area",
    [6484] = "area",
    [6516] = "area",
    [6519] = "area",
    [6521] = "area",
    [6556] = "area",
    [6612] = "area",
    [6743] = "area",
    [6777] = "area",
    [6830] = "area",
    [6864] = "area",
    [6867] = "area",
    [6881] = "area",
    [6925] = "area",
    [7024] = "area",
    [7033] = "area",
    [7036] = "area",
    [7059] = "area",
    [7061] = "area",
    [7063] = "area",
    [7081] = "area",
    [7086] = "area",
    [7097] = "area",
    [7098] = "area",
    [7103] = "area",
    [7112] = "area",
    [7157] = "area",
    [7158] = "area",
    [7183] = "area",
    [7208] = "area",
    [7266] = "area",
    [7269] = "area",
    [7318] = "area",
    [7332] = "area",
    [7333] = "area",
    [7340] = "area",
    [7355] = "area",
    [7358] = "area",
    [7364] = "area",
    [7414] = "area",
    [7425] = "area",
    [7426] = "area",
    [7427] = "area",
    [7459] = "area",
    [7502] = "area",
    [7508] = "area",
    [7555] = "area",
    [7559] = "area",
    [7564] = "area",
    [7589] = "area",
    [7599] = "area",
    [7662] = "area",
    [7709] = "area",
    [7733] = "area",
    [7783] = "area",
    [7794] = "area",
    [7795] = "area",
    [7803] = "area",
    [7861] = "area",
    [7999] = "area",
    [8029] = "area",
    [8140] = "area",
    [8256] = "area",
    [8271] = "area",
    [8272] = "area",
    [8273] = "area",
    [8300] = "area",
    [8301] = "area",
    [8382] = "area",
    [8416] = "area",
    [8430] = "area",
    [8554] = "area",
    [8607] = "area",
    [8608] = "area",
    [8610] = "area",
    [8612] = "area",
    [8613] = "area",
    [8614] = "area",
    [8615] = "area",
    [8616] = "area",
    [8617] = "area",
    [8618] = "area",
    [8619] = "area",
    [8621] = "area",
    [8622] = "area",
    [8689] = "area",
    [8711] = "area",
    [8719] = "area",
    [8722] = "area",
    [8854] = "area",
    [8861] = "area",
    [8869] = "area",
    [8953] = "area",
    [8954] = "area",
    [8958] = "area",
    [8961] = "area",
    [8965] = "area",
    [9011] = "area",
    [9226] = "area",
    [9236] = "area",
    [9305] = "area",
    [9317] = "area",
    [9335] = "area",
    [9370] = "area",
    [9379] = "area",
    [9384] = "area",
    [9402] = "area",
    [9419] = "area",
    [9502] = "area",
    [9556] = "area",
    [9569] = "area",
    [9579] = "area",
    [9581] = "area",
    [9582] = "area",
    [9592] = "area",
    [9598] = "area",
    [9599] = "area",
    [9617] = "area",
    [9636] = "area",
    [9647] = "area",
    [9659] = "area",
    [9662] = "area",
    [9665] = "area",
    [9677] = "area",
    [9678] = "area",
    [9693] = "area",
    [9715] = "area",
    [9731] = "area",
    [9748] = "area",
    [9750] = "area",
    [9766] = "area",
    [9779] = "area",
    [9796] = "area",
    [9801] = "area",
    [9806] = "area",
    [9833] = "area",
    [9962] = "area",
    [10988] = "area",
    [11002] = "area",
    [11381] = "area",
    [11465] = "area",
    [11467] = "area",
    [11473] = "area",
    [11505] = "area",
    [11515] = "area",
    [11519] = "area",
    [11531] = "area",
    [12245] = "area",
    [12248] = "area",
    [12782] = "area",
    [12823] = "area",
    [12858] = "area",
    [12876] = "area",
    [13161] = "area",
    [13231] = "area",
    [13237] = "area",
    [13338] = "area",
    [13408] = "area",
    [13414] = "area",
    [13499] = "area",
    [13517] = "area",
    [13567] = "area",
    [13625] = "area",
    [13710] = "area",
    [13722] = "area",
    [13724] = "area",
    [13725] = "area",
    [13727] = "area",
    [13728] = "area",
    [13732] = "area",
    [13734] = "area",
    [13739] = "area",
    [13743] = "area",
    [13751] = "area",
    [13767] = "area",
    [13779] = "area",
    [13796] = "area",
    [13814] = "area",
    [13818] = "area",
    [13825] = "area",
    [13834] = "area",
    [13837] = "area",
    [13864] = "area",
    [13895] = "area",
    [13980] = "area",
    [14079] = "area",
    [14594] = "area",
}

local function TownFilter()
    local zones, areas = {}, {}
    for id, kind in pairs(TOWNS) do
        if kind == "zone" then zones[#zones + 1] = id else areas[#areas + 1] = id end
    end
    return string.format("(c.zoneId IN (%s) OR c.areaId IN (%s))",
        #zones > 0 and table.concat(zones, ",") or "0", #areas > 0 and table.concat(areas, ",") or "0")
end

-- Town key of a creature: its area if that area is a town, else its zone.
local function TownKey(c)
    local okA, area = pcall(function() return c:GetAreaId() end)
    if okA and TOWNS[area] == "area" then return area end
    local okZ, zone = pcall(function() return c:GetZoneId() end)
    if okZ and TOWNS[zone] == "zone" then return zone end
    return nil
end
local TICK = 2000
local ARRIVE = 3.5
local NIGHT_FROM, NIGHT_TO = 21, 6

local NPCFLAG_VENDOR, NPCFLAG_INNKEEPER, NPCFLAG_BANKER, NPCFLAG_AUCTIONEER = 128, 65536, 131072, 2097152
local NPCFLAG_GOSSIP, NPCFLAG_FLIGHT = 1, 8192
local CT_HUMANOID = 7
local STAND, SIT, SLEEP = 0, 1, 3
local EMOTE_STATE_CHOPWOOD = 234
local E_TALK, E_BOW, E_WAVE, E_QUESTION, E_LAUGH, E_POINT, E_YES, E_NO = 1, 2, 3, 6, 11, 25, 273, 274

-- Who keeps their post (never wanders, never sleeps).
local STAY_WORDS = {"guard", "grunt", "elite", "kor'kron", "protector", "deathguard", "delegation",
    "magister", "magistrix", "arcanist", "arcanital", "chieftain", "argent", "sentinel", "siegeworker",
    "headhunter", "watcher", "guardian", "bat rider", "wind rider", "shaman"}

-- What a vendor sells, from its subname. {keyword, goods word, hawk lines}
local TRADES = {
    {"food", "bread", {"Fresh bread, still warm!", "Roast boar ribs! Smell that!", "Kodo jerky for the road!"}},
    {"drink", "ale", {"Cold ale! Hot cider!", "Thirsty? Step right up!"}},
    {"cook", "spices", {"Spices from Stranglethorn!", "Salt, pepper, and secrets!"}},
    {"butcher", "meat", {"Fresh cuts! Raptor, boar, kodo!", "Meat for your stew!"}},
    {"weapon", "axe", {"Axes sharp enough to shave a kodo!", "Steel for every warrior!"}},
    {"armor", "mail shirt", {"Mail that stops a troll's spear!", "Armor! Protect your hide!"}},
    {"mail", "mail shirt", {"Chain and scale, forged right here!"}},
    {"plate", "breastplate", {"Plate that turns a blade!"}},
    {"leather", "leather", {"Supple leather, tough as a raptor's hide!", "Leather for armor and saddles!"}},
    {"cloth", "silk", {"Silk and wool, finest weave!", "Cloth for robes and bandages!"}},
    {"tailor", "thread", {"Thread, needles, dyes!"}},
    {"bow", "arrows", {"Bows and arrows by the quiver!", "True-flying arrows!"}},
    {"gun", "bullets", {"Guns! Powder! Shot!", "Goblin rifles, almost never explode!"}},
    {"herb", "herbs", {"Peacebloom! Silverleaf! Earthroot!", "Herbs for every ailment!"}},
    {"alchemy", "potions", {"Potions! Elixirs! Tonics!", "Healing in a bottle!"}},
    {"reagent", "reagents", {"Reagents for shaman and mage alike!", "Ankhs, powders, and runes!"}},
    {"poison", "poison", {"Poisons... quietly sold.", "Sharpen your blade with something nasty."}},
    {"fish", "bait", {"Bait and tackle! Fresh lures!", "Catch of the day!"}},
    {"mining", "pick", {"Mining picks, sturdy as stone!"}},
    {"blacksmith", "whetstone", {"Whetstones! Hammers! Flux!", "Blacksmithing supplies here!"}},
    {"trade", "supplies", {"Trade goods! Everything you need!", "Supplies for every craft!"}},
    {"general", "supplies", {"Torches, rope, bags! Everything for the road!", "General goods! Come look!"}},
    {"bag", "bag", {"Bags! Never run out of space again!"}},
}

local BUY_LINES = {
    {"How much for the %s?", "For you? A fair price, friend.", "Fair, he says. I'll take one."},
    {"Is this %s any good?", "Best in Orgrimmar. Ask anyone.", "Hm. I'll take two, then."},
    {"I need %s. The good kind.", "Only the good kind here.", "Then wrap it up."},
    {"Your %s was cheaper last week.", "Last week there was no war tax.", "There's always a war tax..."},
    {"Got any %s left?", "Last of the batch. Lucky you.", "Lucky me. Here's the coin."},
}

local CHILD_LINES = {"Are you a hero?!", "Can I see your weapon?", "Tell me a story! Please!",
    "When I grow up I'll be just like you!", "Did you fight a dragon?", "Race you!"}

-- ---------------------------------------------------------------- data

local POI = {}      -- zone -> {vendors = {...}, inns = {...}, banks = {...}}
local CITIZEN = {}  -- entry -> "citizen" | "child"
local TALKER = {}   -- entry -> true: gets the Living World gossip menu
local STATE = {}    -- per-creature state, keyed by "x:y" of the spawn point

local function TradeOf(subname)
    local s = string.lower(subname or "")
    if s == "" then return nil end
    for _, t in ipairs(TRADES) do
        if string.find(s, t[1], 1, true) then return t end
    end
    return nil
end

local function LoadTown(zone)
    local P = {vendors = {}, inns = {}, banks = {}, auctions = {}, flights = {}}
    -- kind: 1 inn, 2 bank/auction, 3 vendor (bit tests done in SQL, Lua 5.2 has no bit ops)
    local q = WorldDBQuery(string.format([[
        SELECT c.id, c.position_x, c.position_y, c.position_z,
               CASE WHEN (t.npcflag & %d) <> 0 THEN 1 WHEN (t.npcflag & %d) <> 0 THEN 2
                    WHEN (t.npcflag & %d) <> 0 THEN 4 WHEN (t.npcflag & %d) <> 0 THEN 5 ELSE 3 END,
               COALESCE(t.subname, '')
          FROM creature c JOIN creature_template t ON t.entry = c.id
         WHERE c.%s = %d AND c.PhaseId IN (0, 169, 9600) AND c.PhaseGroup = 0 AND c.guid < 3000000000
           AND (t.npcflag & %d) <> 0]], NPCFLAG_INNKEEPER, NPCFLAG_BANKER, NPCFLAG_AUCTIONEER, NPCFLAG_FLIGHT,
        TOWNS[zone] == "area" and "areaId" or "zoneId", zone,
        NPCFLAG_VENDOR + NPCFLAG_INNKEEPER + NPCFLAG_BANKER + NPCFLAG_AUCTIONEER + NPCFLAG_FLIGHT))
    if q then
        repeat
            local p = {entry = q:GetUInt32(0), x = q:GetFloat(1), y = q:GetFloat(2), z = q:GetFloat(3)}
            local kind, sub = q:GetUInt32(4), q:GetString(5)
            if kind == 1 then P.inns[#P.inns + 1] = p
            elseif kind == 2 then P.banks[#P.banks + 1] = p
            elseif kind == 4 then P.auctions[#P.auctions + 1] = p; P.banks[#P.banks + 1] = p
            elseif kind == 5 then P.flights[#P.flights + 1] = p
            else
                p.trade = TradeOf(sub)
                if p.trade then P.vendors[#P.vendors + 1] = p end
            end
        until not q:NextRow()
    end
    POI[zone] = P
    return P
end

local function LoadCitizens()
    local q = WorldDBQuery(string.format([[
        SELECT DISTINCT t.entry, LOWER(t.name),
               (SELECT COUNT(*) FROM creature_template_gossip g WHERE g.CreatureID = t.entry)
          FROM creature c JOIN creature_template t ON t.entry = c.id
          LEFT JOIN creature_addon a ON a.guid = c.guid
          LEFT JOIN creature_template_addon ta ON ta.entry = t.entry
         WHERE %s AND t.type = %d AND t.npcflag IN (0, 1) AND t.Classification = 0 AND t.name NOT REGEXP 'familiar|imp$|^imp |voidwalker|felhunter|succubus|felguard|infernal|doomguard|wisp|golem|elemental|skeleton|zombie|ghoul|abomination|spirit|ghost|treant|totem|spider|wolf|boar|bear|^cat$|bat$|rat$|dog|horse|kodo|raptor|hawk|snake|worg|hound|guardian|critter|bunny|scorpid|crab'
           AND c.MovementType IN (0, 1)
           AND COALESCE(a.PathId, 0) = 0 AND c.PhaseId IN (0, 169, 9600) AND c.PhaseGroup = 0
           -- NPCs that already work (emote state from the DB) keep working
           AND COALESCE(a.emote, 0) = 0 AND COALESCE(ta.emote, 0) = 0]],
        TownFilter(), CT_HUMANOID))
    if not q then return end
    repeat
        local entry, name, retailGossip = q:GetUInt32(0), q:GetString(1), q:GetUInt32(2)
        local stay = false
        for _, w in ipairs(STAY_WORDS) do
            if string.find(name, w, 1, true) and not string.find(name, "off-duty", 1, true) then stay = true break end
        end
        if not stay then
            CITIZEN[entry] = string.find(name, "orphan", 1, true) and "child"
                or string.find(name, "laborer", 1, true) and "worker" or "citizen"
            -- our talk menu only where Blizzard has none (and peons keep theirs)
            if retailGossip == 0 and not string.find(name, "peon", 1, true) then TALKER[entry] = true end
        end
    until not q:NextRow()
end

-- ---------------------------------------------------------------- helpers

local function IsNight()
    local ok, t = pcall(GetGameTime)
    if not ok or type(t) ~= "number" then t = os.time() end
    local h = math.floor(t / 3600) % 24
    return h >= NIGHT_FROM or h < NIGHT_TO
end

local function Near(p, r)
    local a, d = math.random() * 2 * math.pi, r or 3
    return p.x + math.cos(a) * d, p.y + math.sin(a) * d, p.z
end

-- ---------------------------------------------------------------- seats and spacing
-- Night: a citizen takes a free bed (sleeps) or chair/bench/stool (sits) near home,
-- one NPC per seat. With none free it goes home and stays indoors (hidden) until dawn,
-- so nobody piles up on one spot. Errands use spaced slots around a vendor or banker.
local SEAT_WORDS = {"chair", "bench", "stool", "seat", "throne"}
local BED_WORDS = {"bed"}
local CLAIMED = {}      -- seat key -> creature key
local SLOTS = {}        -- poi key -> {creature key -> slot}

local function SeatKey(go) return string.format("%d:%d:%d", math.floor(go:GetX() * 10), math.floor(go:GetY() * 10), math.floor(go:GetZ())) end

local function FindSeat(c, key)
    local best, bestKind, bestD
    for _, go in ipairs(c:GetGameObjectsInRange(60) or {}) do
        local okN, n = pcall(function() return string.lower(go:GetName() or "") end)
        if okN and not string.find(n, "bedroll", 1, true) then
            local kind
            for _, w in ipairs(BED_WORDS) do if string.find(n, w, 1, true) then kind = "bed" end end
            if not kind then for _, w in ipairs(SEAT_WORDS) do if string.find(n, w, 1, true) then kind = "seat" end end end
            if kind then
                local k = SeatKey(go)
                if not CLAIMED[k] or CLAIMED[k] == key then
                    local d = c:GetDistance(go) + (kind == "bed" and 0 or 15)   -- prefer beds
                    if not bestD or d < bestD then best, bestKind, bestD = go, kind, d end
                end
            end
        end
    end
    if best then
        CLAIMED[SeatKey(best)] = key
        return {x = best:GetX(), y = best:GetY(), z = best:GetZ(), o = best:GetO(), kind = bestKind, seat = SeatKey(best)}
    end
end

local function ReleaseSeat(st)
    if st.seat then CLAIMED[st.seat.seat] = nil; st.seat = nil end
end

-- spaced spot around a point of interest: 6 slots per ring, 1.8 yd apart or more
local function SlotNear(p, key, base)
    local pk = string.format("%d:%d", math.floor(p.x), math.floor(p.y))
    SLOTS[pk] = SLOTS[pk] or {}
    local used = {}
    for k, sl in pairs(SLOTS[pk]) do if k ~= key then used[sl] = true end end
    local slot = 0
    while used[slot] do slot = slot + 1 end
    SLOTS[pk][key] = slot
    local ring = math.floor(slot / 6)
    local a = (slot % 6) * (math.pi / 3) + ring * 0.5
    local d = (base or 2.5) + ring * 1.8
    return p.x + math.cos(a) * d, p.y + math.sin(a) * d, p.z, pk
end

local function ReleaseSlot(st, key)
    if st.slot and SLOTS[st.slot] then SLOTS[st.slot][key] = nil end
    st.slot = nil
end

local function Go(c, st, x, y, z, why, target)
    pcall(function() c:EmoteState(0) end)
    c:SetStandState(STAND)
    c:SetWalk(true)
    if not SafeMove(c, 0, x, y, z) then
        -- no walkable path there: never fly, pick something else
        if why == "sleep" then
            ReleaseSeat(st)
            if not SafeMove(c, 0, st.hx, st.hy, st.hz) then
                st.mode, st.why = "sleep", nil
                pcall(function() c:SetVisible(false) end)
                return
            end
            x, y, z = st.hx, st.hy, st.hz
        else
            st.mode, st.wait, st.why, st.target = "idle", math.random(10, 25), nil, nil
            return
        end
    end
    st.mode, st.tx, st.ty, st.tz, st.why, st.target = "walk", x, y, z, why, target
    st.reissue, st.timeout = 5, 60
end

local function Arrived(c, st)
    local x, y = c:GetLocation()
    return math.sqrt((x - st.tx) ^ 2 + (y - st.ty) ^ 2) <= ARRIVE
end

local function Pick(list) return (#list > 0) and list[math.random(#list)] or nil end

local function Say(u, line, emote)
    u:SendUnitSay(line, 0)
    if emote then u:PerformEmote(emote) end
end

local function Later(u, ms, line, emote)
    u:RegisterEvent(function(_, _, _, w) if w and w:IsAlive() then Say(w, line, emote) end end, ms, 1)
end

-- ---------------------------------------------------------------- scenes

local function Haggle(c, p)
    local vendors = c:GetCreaturesInRange(8, p.entry)
    local v = vendors and vendors[1]
    if not v then return end
    c:SetFacingToObject(v)
    v:SetFacingToObject(c)
    local b = BUY_LINES[math.random(#BUY_LINES)]
    Say(c, string.format(b[1], p.trade[2]), E_POINT)
    Later(v, math.random(3000, 5000), b[2], E_TALK)
    Later(c, math.random(7000, 9000), b[3], E_YES)
end

local function ChildPlay(c, st)
    local players = c:GetPlayersInRange(25)
    local p = players and #players > 0 and players[math.random(#players)]
    if not p then return false end
    Say(c, CHILD_LINES[math.random(#CHILD_LINES)], E_WAVE)
    c:SetWalk(false)
    c:MoveFollow(p, 2, math.random() * 2 * math.pi)
    st.mode, st.wait = "play", math.random(8, 15)
    return true
end

-- ---------------------------------------------------------------- brain

local function Brain(_, _, _, c)
    if not c or not c:IsAlive() or c:IsInCombat() then return end
    local st = STATE[c:Data():Get("lw_town")]
    if not st then return end
    local P = POI[st.zone]
    local night = IsNight()

    -- night: go to sleep (inn for citizens, home for children)
    local key = c:Data():Get("lw_town")
    if night and st.mode ~= "sleep" and st.why ~= "sleep" then
        ReleaseSlot(st, key)
        st.seat = FindSeat(c, key)
        local x, y, z = st.hx, st.hy, st.hz
        if st.seat then x, y, z = st.seat.x, st.seat.y, st.seat.z end
        Go(c, st, x, y, z, "sleep")
        return
    end
    if not night and (st.mode == "sleep" or st.why == "sleep") then
        pcall(function() c:SetVisible(true) end)
        ReleaseSeat(st)
        Say(c, "*yawn*", nil)
        Go(c, st, st.hx, st.hy, st.hz, "home")
        return
    end

    if st.mode == "walk" then
        st.timeout = st.timeout - 1
        if Arrived(c, st) or st.timeout <= 0 then
            if st.why == "sleep" then
                if st.seat then
                    pcall(function() c:NearTeleport(st.seat.x, st.seat.y, st.seat.z, st.seat.o) end)
                    pcall(function() c:SetFacing(st.seat.o) end)
                    c:SetStandState(st.seat.kind == "bed" and SLEEP or 5)     -- 5 = sit on a medium chair
                else
                    pcall(function() c:SetVisible(false) end)               -- gone indoors for the night
                end
                st.mode = "sleep"
            elseif st.why == "shop" and st.target then
                Haggle(c, st.target)
                st.mode, st.wait = "busy", math.random(10, 20)
            elseif st.why == "work" then
                pcall(function() c:EmoteState(EMOTE_STATE_CHOPWOOD) end)
                st.mode, st.wait = "work", math.random(8, 14)
            elseif st.why == "bank" then
                if st.target then
                    local b = c:GetCreaturesInRange(8, st.target.entry)
                    if b and b[1] then c:SetFacingToObject(b[1]) end
                end
                c:PerformEmote(E_TALK)
                st.mode, st.wait = "busy", math.random(8, 15)
            else
                st.mode, st.wait = "idle", math.random(20, 60)
            end
            st.why = nil
        else
            st.reissue = st.reissue - 1
            if st.reissue <= 0 then
                if not SafeMove(c, 0, st.tx, st.ty, st.tz) then st.timeout = 0 end
                st.reissue = 5
            end
        end
        return
    end

    if st.mode == "sleep" then return end

    st.wait = (st.wait or 0) - 1
    if st.wait > 0 then return end

    if st.mode == "play" then
        c:SetWalk(true)
        Go(c, st, st.hx, st.hy, st.hz, "home")
        return
    end

    if st.mode == "work" then
        pcall(function() c:EmoteState(0) end)
        Go(c, st, st.hx, st.hy, st.hz, "home")
        return
    end

    -- pick the next errand
    if st.role == "worker" then
        -- laborers chop and haul near their spot all day
        local x, y, z = Near({x = st.hx, y = st.hy, z = st.hz}, math.random(6, 12))
        Go(c, st, x, y, z, "work")
        return
    end
    if st.role == "child" then
        if math.random() < 0.5 and ChildPlay(c, st) then return end
        local x, y, z = Near({x = st.hx, y = st.hy, z = st.hz}, math.random(4, 12))
        Go(c, st, x, y, z, "home")
        return
    end
    local r = math.random()
    local v = Pick(P.vendors)
    local b = Pick(P.banks)
    ReleaseSlot(st, key)
    if r < 0.55 and v then
        local x, y, z, pk = SlotNear(v, key, 2.5)
        st.slot = pk
        Go(c, st, x, y, z, "shop", v)
    elseif r < 0.75 and b then
        local x, y, z, pk = SlotNear(b, key, 2.5)
        st.slot = pk
        Go(c, st, x, y, z, "bank", b)
    else
        Go(c, st, st.hx, st.hy, st.hz, "home")
    end
end

local function OnSpawn(_, c)
    local zone = TownKey(c)
    if not zone then return end
    local role = CITIZEN[c:GetEntry()]
    if not role then return end
    if not POI[zone] then LoadTown(zone) end
    local x, y, z = c:GetLocation()
    local key = string.format("%d:%d", math.floor(x), math.floor(y))
    c:Data():Set("lw_town", key)
    c:Data():Set("lw_claim", "town")
    if TALKER[c:GetEntry()] and tonumber(tostring(c:GetNPCFlags())) == 0 then c:SetNPCFlags(NPCFLAG_GOSSIP) end
    STATE[key] = {zone = zone, role = role, hx = x, hy = y, hz = z, mode = "idle", wait = math.random(5, 40)}
    c:RegisterEvent(Brain, TICK, 0)
end

-- ---------------------------------------------------------------- hawkers

local HAWK_RANGE, HAWK_COOLDOWN = 20, 50

local function Hawk(_, _, _, v)
    if not v or not v:IsAlive() then return end
    local last = v:Data():Get("lw_hawk") or 0
    if type(last) ~= "number" then last = 0 end
    if os.time() - last < HAWK_COOLDOWN or IsNight() then return end
    local players = v:GetPlayersInRange(HAWK_RANGE)
    if not players or #players == 0 or math.random() > 0.35 then return end
    local t = TRADES[v:Data():Get("lw_trade") or 0]
    if not t then return end
    v:Data():Set("lw_hawk", os.time())
    Say(v, t[3][math.random(#t[3])], E_TALK)
end

local function OnVendorSpawn(_, v)
    if not TownKey(v) then return end
    local okT, ct = pcall(function() return v:GetCreatureType() end)
    if not okT or ct ~= CT_HUMANOID then return end
    v:RegisterEvent(Hawk, 10000, 0)
end

-- ---------------------------------------------------------------- talk menu
-- Citizens without a Blizzard gossip get a small menu: city news (tied to
-- the living world: caravans, patrols, hero paths), their own life story,
-- directions with a map flag, and where to find work. One answer per click,
-- spoken aloud so people around hear it too.

local TALK_TEXT = 68 -- generic "Greetings, $N" npc_text

local NEWS = {
    "Caravan Master Grukk runs kodo wagons to Razor Hill and Sen'jin. Slower than a wind rider, cheaper too.",
    "Hero Master Arvenne by the gate trains heroes. Fel wardens, archmages, templars. Odd company, but strong.",
    "Fortuna by the gate rolls the Dice of Destiny. I lost a week's pay to her once. Worth it.",
    "Wardens recruiting in Dolanaar, they say. Night elves taking in demon hunters. Strange times.",
    "Razormane raiders hit a farm near Razor Hill. The road patrol marches twice as often now.",
    "The night watch walks the Drag after dark. If you see torches, that's them.",
    "The Burning Blade still hides in Skull Rock, right under our walls. Nobody goes in alone.",
    "A Kul Tiran ship was seen off the Durotar coast. Scouts, probably. Or worse.",
    "Dust storms out of the east this week. Cover your mouth on the road.",
    "The Darkspear are drumming on the Echo Isles. A festival, or a war council.",
    "Goblins in the Slums blew up another workshop. The third this month.",
    "Thunder Bluff sent an envoy. Tauren talk slow, so expect a long visit.",
}

local LIFE = {
    "Me? I haul water from the river. Not glorious, but the whole city drinks.",
    "I was a grunt once. An arrow in Ashenvale ended that. Now I keep the peace in my own home.",
    "I was born in the internment camps. Thrall freed us. I'll never forget it.",
    "My family came from Sen'jin. The city is loud, but the coin is good.",
    "I work the forges in the Valley of Honor. Ask me about burns. I have stories.",
    "I lost my brother in Northrend. Some nights I go to the Valley of Spirits and talk to him.",
    "I'm saving for a wolf. A real one, from the kennels. Two more months.",
    "I cook for the barracks. Three hundred grunts, one pot. Nobody complains twice.",
    "I came here from the Barrens with nothing. Now I have a roof. That's enough.",
    "My children want to be heroes, like you. I want them to be alive.",
    "I trade hides with the tauren. Honest folk. They never haggle, and I always lose.",
}

local WORK = {
    "Work? The guards at the gate always need hands. Or the Hero Master, if you're ambitious.",
    "Razor Hill pays for quillboar tusks. The Razormane won't hand them over nicely.",
    "The caravan needs guards on the road south. Talk to Grukk at the gate.",
    "The Valley of Honor trainers take anyone willing to bleed.",
    "Skull Rock could use a cleaning. Bring friends. And bandages.",
}

local function Nearest(player, list)
    local x, y = player:GetLocation()
    local best, bp = 1e12, nil
    for _, p in ipairs(list or {}) do
        local d = (p.x - x) ^ 2 + (p.y - y) ^ 2
        if d < best then best, bp = d, p end
    end
    return bp
end

local WHERE = {
    -- {label, answer, list name in POI or fixed point}
    {"The bank", "The bank? Follow the gold. I'll mark it on your map.", "banks"},
    {"The auction house", "Auction house, by the Drag. Mind the goblins.", "auctions"},
    {"The inn", "The inn is this way. Beds are... mostly clean.", "inns"},
    {"The wind rider master", "Wind riders roost up on the tower. Here, on your map.", "flights"},
    {"The Hero Master", "Hero Master Arvenne stands by the gate, next to Fortuna.", {x = 1437.5, y = -4417.5}},
    {"The caravan", "Grukk's caravan stops at the gate of Orgrimmar, in Razor Hill and in Sen'jin.", "caravan"},
}

local function TalkHello(_, player, c)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "What's new in the city?", 1, 1)
    player:GossipMenuAddItem(0, "Tell me about yourself.", 1, 2)
    player:GossipMenuAddItem(0, "Where can I find...", 1, 3)
    player:GossipMenuAddItem(0, "Any work for someone like me?", 1, 4)
    player:GossipMenuAddItem(0, "Farewell.", 1, 9)
    player:GossipSendMenu(TALK_TEXT, c)
end

local function TalkSelect(_, player, c, sender, intid)
    c:SetFacingToObject(player)
    if sender == 1 and intid == 3 then
        player:GossipClearMenu()
        for i, w in ipairs(WHERE) do player:GossipMenuAddItem(0, w[1], 2, i) end
        player:GossipMenuAddItem(0, "Never mind.", 1, 9)
        player:GossipSendMenu(TALK_TEXT, c)
        return
    end
    player:GossipComplete()
    local key = c:Data():Get("lw_town")
    local P = POI[(STATE[key] or {}).zone or 1637] or {}
    if sender == 2 then
        local w = WHERE[intid]
        if not w then return end
        local spot = (type(w[3]) == "table") and w[3]
            or (w[3] == "caravan" and Nearest(player, {{x = 1375, y = -4445}, {x = 330, y = -4718}, {x = -800, y = -4895}}))
            or Nearest(player, P[w[3]])
        Say(c, w[2], E_POINT)
        if spot then pcall(function() player:GossipSendPOI(spot.x, spot.y, 7, 99, 0, w[1]) end) end
        return
    end
    if intid == 1 then Say(c, NEWS[math.random(#NEWS)], E_TALK)
    elseif intid == 2 then Say(c, LIFE[math.random(#LIFE)], E_TALK)
    elseif intid == 4 then Say(c, WORK[math.random(#WORK)], E_POINT)
    else Say(c, "Strength and honor.", E_BOW) end
end

-- ---------------------------------------------------------------- register

LoadCitizens()
local n = 0
for entry in pairs(CITIZEN) do
  if not HAS_CPP_SCRIPT[entry] then
    RegisterCreatureEvent(entry, 5, OnSpawn)  -- ON_SPAWN
    if TALKER[entry] then
        RegisterCreatureGossipEvent(entry, 1, TalkHello)
        RegisterCreatureGossipEvent(entry, 2, TalkSelect)
    end
    n = n + 1
  end
end

-- vendors: register per entry with its trade index (subname read from DB)
local vq = WorldDBQuery(string.format([[
    SELECT DISTINCT t.entry, COALESCE(t.subname, '')
      FROM creature c JOIN creature_template t ON t.entry = c.id
     WHERE %s AND (t.npcflag & %d) <> 0 AND c.PhaseId IN (0, 169, 9600)]], TownFilter(), NPCFLAG_VENDOR))
local hv = 0
if vq then
    repeat
        local entry, sub = vq:GetUInt32(0), vq:GetString(1)
        local trade = TradeOf(sub)
        if trade and not HAS_CPP_SCRIPT[entry] then
            local idx
            for i, t in ipairs(TRADES) do if t == trade then idx = i break end end
            RegisterCreatureEvent(entry, 5, function(e, v)
                v:Data():Set("lw_trade", idx)
                OnVendorSpawn(e, v)
            end)
            hv = hv + 1
        end
    until not vq:NextRow()
end
print("[lw] town routines loaded: " .. n .. " citizen types, " .. hv .. " hawking vendor types")
