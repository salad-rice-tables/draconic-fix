-- =====================================================================
-- Living world v4 (everything runs only near players):
--  1 Work routines: smiths hammer, miners mine, fishers fish, scribes read,
--    priests pray, cooks cook, farmhands work - by day. Children study in
--    the morning.
--  2 Taverns at night: inn folk dance, drink, sing; sometimes a brawl that a
--    guard breaks up.
--  3 Town criers: a herald in every capital announces server news
--    (WORLD_News from other scripts) and the hour.
--  4 Funerals for fallen Hardcore heroes in their capital; celebrations
--    with fireworks after defended villages.
--  5 Day and night: undead and night beasts grow stronger after dark,
--    bandits by day.
--  6 Town economy: escorted caravans make city services cheaper, raided
--    ones dearer (trade index per city, also in vendor talk).
--  8 Wildlife: herds graze together, young follow their mothers, predators
--    stalk prey.
--  9 Inn rooms: .room at an innkeeper rents a room for a day: hearth bound
--    there, +10% experience while it lasts, .room chest opens your bank.
-- 10 Travellers walk the caravan roads with rumors and escort missions.
-- (7 Road patrols and caravans: living_roads.sql + lw_engine / lw_patrol)
-- =====================================================================

-- Navmesh-only movement (custom core method MoveToSafe): never fly or cut
-- through walls when no walkable path exists. Falls back on older cores.
local function SafeMove(c, id, x, y, z)
    local ok, moved = pcall(function() return c:MoveToSafe(id, x, y, z) end)
    if ok then return moved end
    c:MoveTo(id, x, y, z, true)
    return true
end

local ENABLED = true
local HTAG = "|cffd4a017[Herald]|r "
local ITAG = "|cffc69b6d[Inn]|r "
local TTAG = "|cff9acd32[Traveller]|r "
local EMPOWER = 1402000
local CAPITALS = {[1637] = "Orgrimmar", [1519] = "Stormwind", [1537] = "Ironforge", [1638] = "Thunder Bluff", [1497] = "Undercity",
    [1657] = "Darnassus", [3487] = "Silvermoon", [3557] = "The Exodar", [3703] = "Shattrath", [4395] = "Dalaran", [7502] = "Dalaran",
    [13862] = "Valdrakken", [14771] = "Dornogal"}

-- Lua 5.2 here has no bit operators; npcflag can be a uint64 userdata
local function HasFlag(flags, bit)
    local n = tonumber(tostring(flags)) or 0
    return math.floor(n / bit) % 2 == 1
end
local function Flags(c)
    local ok, f = pcall(function() return c:GetNPCFlags() end)
    return ok and f or 0
end

-- Herny cas ako vsade inde (workday, patrol, guards); os.date by rozhadzoval den/noc systemov.
local function Hour()
    local ok, t = pcall(GetGameTime)
    if not ok or type(t) ~= "number" or t == 0 then t = os.time() end
    return math.floor(t / 3600) % 24
end
local _forceNightAt, _forceNight = 0, nil
local function ForceNight() -- GM test: world.lw_state force_night=1 (cached 30 s)
    if os.time() - _forceNightAt > 30 then
        _forceNightAt = os.time()
        local ok, r = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = 'force_night'")
        _forceNight = ok and r and r:GetString(0) == "1"
    end
    return _forceNight
end
local function IsNight() if ForceNight() then return true end; local h = Hour(); return h >= 21 or h < 6 end
-- Obsadenost: ostatne living-world systemy, war event a piraati. Workday narok s expirovanou
-- casovou znackou povazujeme za volny (vid workday.lua CLAIM_TTL).
local function ClaimedByOther(c)
    local ok, v = pcall(function() return c:Data():Get("lw_claim") end)
    if not ok or v == nil or v == "lw4" then return false end
    if v == "workday" then
        local okt, t = pcall(function() return c:Data():Get("lw_claim_t") end)
        if okt and type(t) == "number" and os.time() - t > 600 then return false end
    end
    return true
end
local function Claim(c) pcall(function() c:Data():Set("lw_claim", "lw4") end) end
local function Unclaim(c)
    pcall(function() if c:Data():Get("lw_claim") == "lw4" then c:Data():Set("lw_claim", nil) end end)
end
local function Key(player) return (string.gsub(player:GetName() or "", "'", "''")) end
local function Lower(c) local ok, n = pcall(function() return c:GetName() end); return ok and string.lower(n or "") or "" end
local SUBCACHE = {}   -- entry -> lower subname (SELECT raz, nie kazdy tick)
local function Sub(c)
    local okE, entry = pcall(function() return c:GetEntry() end)
    if not okE or not entry then return "" end
    if SUBCACHE[entry] == nil then
        local q = WorldDBQuery(string.format("SELECT IFNULL(subname,'') FROM creature_template WHERE entry = %d", entry))
        SUBCACHE[entry] = (q and string.lower(q:GetString(0))) or ""
    end
    return SUBCACHE[entry]
end
local function Has(s, list)
    if type(list) == "string" then   -- "a|b|c" keyword lists
        for w in string.gmatch(list, "[^|]+") do if string.find(s, w, 1, true) then return true end end
        return false
    end
    for _, w in ipairs(list) do if string.find(s, w, 1, true) then return true end end
    return false
end
local function TypeOf(c) local ok, t = pcall(function() return c:GetCreatureType() end); return ok and t or 0 end
local function Idle(c) return c:IsAlive() and not c:IsInCombat() and not c:IsMoving() end
local function Pick(t) return t[math.random(#t)] end

local HOSTILE = {}
do
    local q = WorldDBQuery("SELECT id FROM we_hostile_faction")
    if q then repeat HOSTILE[q:GetUInt32(0)] = true until not q:NextRow() end
end
local function Hostile(c) local ok, f = pcall(function() return c:GetFaction() end); return ok and HOSTILE[f] end

-- ---------------------------------------------------------------- 3 news + criers
local NEWS = {}
-- news go to the DB; every map state shows new ones to its players in capitals
function WORLD_News(text)
    WorldDBExecute(string.format("INSERT INTO lw_news (text) VALUES ('%s')", (string.gsub(string.sub(text, 1, 250), "'", "''"))))
end

local lastNewsId = nil
local function PollNews()
    local q
    if lastNewsId == nil then
        q = WorldDBQuery("SELECT MAX(id) FROM lw_news")
        lastNewsId = q and tonumber(q:GetString(0)) or 0
        q = WorldDBQuery("SELECT id, text FROM lw_news ORDER BY id DESC LIMIT 6")
        if q then repeat table.insert(NEWS, q:GetString(1)) until not q:NextRow() end
        return
    end
    q = WorldDBQuery(string.format("SELECT id, text FROM lw_news WHERE id > %d ORDER BY id", lastNewsId))
    if not q then return end
    repeat
        lastNewsId = q:GetUInt32(0)
        local text = q:GetString(1)
        table.insert(NEWS, 1, text)
        while #NEWS > 6 do table.remove(NEWS) end
        for _, p in ipairs(LW_Players()) do
            if CAPITALS[p:GetZoneId()] then p:SendBroadcastMessage(HTAG .. text) end
        end
    until not q:NextRow()
end

local function Herald(p)
    for _, c in ipairs(p:GetCreaturesInRange(35) or {}) do
        if TypeOf(c) == 7 and Idle(c) and not Hostile(c) then
            local news = NEWS[1] and Pick(NEWS) or nil
            local line = news and ("Hear ye! " .. news) or ("Hear ye! It is " .. Hour() .. " o'clock and all is well in " .. CAPITALS[p:GetZoneId()] .. "!")
            c:SendUnitYell(line, 0)
            return
        end
    end
end

-- ---------------------------------------------------------------- 4 funerals and celebrations
local FUNERAL_LINES = {"We gather to honor %s, who walked the hard road and fell.", "%s fought with no second chance. May the spirits guide them.",
    "Remember %s. The world is poorer for this loss."}
function LW_Funeral(name, horde)
    -- the capital may be on another map: its own map state holds the funeral
    LW_Queue("funeral", "", name .. ":" .. (horde and 1 or 0))
end
LW_QUEUE_HANDLERS["funeral"] = function(_, arg)
    local name, h = string.match(arg, "^(.*):(%d)$")
    local capital = (h == "1") and 1637 or 1519
    local mapOf = {[1637] = 1, [1519] = 0}
    if STATE_MAP ~= mapOf[capital] then return false end   -- not this map's job
    for _, p in ipairs(LW_Players()) do
        if p:GetZoneId() == capital then
            local spoke = false
            for _, c in ipairs(p:GetCreaturesInRange(30) or {}) do
                if TypeOf(c) == 7 and Idle(c) and not Hostile(c) then
                    if not spoke then c:SendUnitSay(string.format(Pick(FUNERAL_LINES), name), 0); spoke = true end
                    pcall(function() c:EmoteState(353) end)
                    c:RegisterEvent(function(_, _, _, cc) pcall(function() cc:EmoteState(0) end) end, 90000, 1)
                end
            end
        end
    end
    return true
end

local FIREWORKS = {11540, 11541, 11542, 11543, 11544, 26286, 26291, 26292, 26293, 26294, 26295}
function LW_Celebrate(ref)
    if not ref or not ref:IsInWorld() then return end
    for _, c in ipairs(ref:GetCreaturesInRange(60) or {}) do
        if TypeOf(c) == 7 and c:IsAlive() and not c:IsInCombat() and not Hostile(c) then
            pcall(function() c:PerformEmote(Pick({4, 21, 11})) end)
            if math.random() < 0.4 then
                for i = 1, 3 do
                    c:RegisterEvent(function(_, _, _, cc) pcall(function() cc:CastSpell(cc, Pick(FIREWORKS), true) end) end, i * 2500, 1)
                end
            end
        end
    end
end

-- ---------------------------------------------------------------- 6 economy
local TRADE = {}
do
    local q = WorldDBQuery("SELECT city, trade FROM lw_economy")
    if q then repeat TRADE[q:GetString(0)] = q:GetInt32(1) until not q:NextRow() end
end
function ECON_Change(city, n)
    if not city then return end
    TRADE[city] = math.max(-20, math.min(20, (TRADE[city] or 0) + n))
    WorldDBExecute(string.format("REPLACE INTO lw_economy (city, trade) VALUES ('%s', %d)", city, TRADE[city]))
end
function ECON_Factor(city) return 1.0 - 0.005 * (TRADE[city] or 0) end   -- -10% .. +10%
local ECON_GOOD = {"The caravans came through - prices are down this week!", "Goods are cheap, roads are safe. Buy now!"}
local ECON_BAD = {"Caravans got raided again. Prices are up, sorry.", "Short on stock - the roads aren't safe."}

-- ---------------------------------------------------------------- 1 work, 2 taverns, 5 day/night, 8 wildlife
local WORK = {
    {{"blacksmith", "weaponsmith", "armorsmith", "smith", "armorer", " forge"}, 173, "anvil|forge"}, {{"mining", "miner"}, 233}, {{"fish"}, 379},
    {{"scribe", "inscription", "librarian", "scholar", "historian", "lorekeeper"}, 483, "drafting|desk|lectern"}, {{"priest", "cleric", "chaplain", "brother", "sister", "acolyte"}, 353},
    {{"cook", "chef", "baker"}, 418, "fire|stove|oven"}, {{"farmer", "farmhand", "peasant", "laborer", "worker"}, 173}, {{"lumber", "woodcutter"}, 234},
    {{"alchem"}, 69, "alchemy"}, {{"engineer"}, 173, "workbench"}, {{"enchant"}, 69, "enchanting"},
}
-- face the workstation (anvil, forge, lab, bench...) of the trade when the work starts
local function FaceStation(c, pattern)
    if not pattern then return end
    local ok, gos = pcall(function() return c:GetGameObjectsInRange(7) end)
    if not ok or not gos then return end
    local best, bd = nil, 1e9
    for _, go in ipairs(gos) do
        local okn, n = pcall(function() return string.lower(go:GetName() or "") end)
        if okn and n ~= "" then
            for word in string.gmatch(pattern, "[^|]+") do
                if string.find(n, word, 1, true) then
                    local d = (go:GetX() - c:GetX()) ^ 2 + (go:GetY() - c:GetY()) ^ 2
                    if d < bd then best, bd = go, d end
                    break
                end
            end
        end
    end
    if best then pcall(function() c:SetFacingToObject(best) end) end
end
local CHILD = {"orphan", "child", " boy", " girl", "kid", "young "}
local SONGS = {"Oh, the road goes ever on, and the ale goes ever down!", "Raise your mugs, the night is long!", "Sing for the heroes who never came home!",
    "Fill it up, fill it up, the barkeep's on the floor!"}
local BANDIT = {"bandit", "thug", "raider", "thief", "defias", "marauder", "brigand", "rogue", "smuggler", "pirate"}
local NIGHTBEAST = {"wolf", "worg", "bat", "spider", "ghoul", "skeleton", "zombie", "ghost", "wraith", "specter"}
local HERBIVORE = {"deer", "stag", "doe", "gazelle", "zhevra", "kodo", "plainstrider", "elk", "talbuk", "clefthoof", "goat", "ram", "sheep", "cow", "boar"}
local PREDATOR = {"wolf", "lion", "cat", "panther", "tiger", "raptor", "hyena", "coyote", "bear", "jaguar", "lynx", "prowler", "stalker"}
local YOUNG = {"young ", "cub", "calf", "fawn", "pup", "kit", "whelp"}

local function Work(c, day)
    local tag = c:Data():Get("lw4_work")
    if tag == nil then
        local s = " " .. Sub(c) .. " " .. Lower(c)
        tag = 0
        local isGuard = Has(s, "guard|sentinel|footman|watchman|watch |soldier|defender|protector|warden|patrol|knight|captain|commander|champion|legionnaire|peacekeeper|sentry|marshal|enforcer|ranger")   -- guards stand and patrol, they never work (Ironforge Guard contains 'forge')
        for _, w in ipairs(isGuard and {} or WORK) do if Has(s, w[1]) then tag = w[2]; c:Data():Set("lw4_station", w[3] or false) break end end
        if tag == 0 and Has(" " .. Lower(c), CHILD) then tag = -1 end
        c:Data():Set("lw4_work", tag)
    end
    if tag == 0 or c:Data():Get("lw4_busy") then return end
    if ClaimedByOther(c) then return end
    local h = Hour()
    local state = 0
    if tag == -1 then state = (h >= 8 and h < 12) and 483 or 0          -- children: morning lessons
    elseif day then state = tag end
    if c:Data():Get("lw4_state") ~= state then
        c:Data():Set("lw4_state", state)
        if state ~= 0 then FaceStation(c, c:Data():Get("lw4_station") or nil) end
        pcall(function() c:EmoteState(state) end)
    end
    if state ~= 0 then Claim(c) else Unclaim(c) end
end

local function Tavern(p, now)
    local h = Hour()
    if not (h >= 20 or h < 2) then return end
    local inn
    for _, c in ipairs(p:GetCreaturesInRange(40) or {}) do
        if HasFlag(Flags(c), 65536) then inn = c break end
    end
    if not inn then return end
    local folk = {}
    for _, c in ipairs(inn:GetCreaturesInRange(25) or {}) do
        local fl = tonumber(tostring(Flags(c))) or 0
        if TypeOf(c) == 7 and Idle(c) and not Hostile(c) and (fl == 0 or fl == 1) and not Has(Lower(c), {"guard", "grunt", "watch"}) and not ClaimedByOther(c) then folk[#folk + 1] = c end
    end
    for _, c in ipairs(folk) do
        if not c:Data():Get("lw4_tavern") then
            c:Data():Set("lw4_tavern", true)
            Claim(c)
            local r = math.random()
            pcall(function() c:EmoteState(r < 0.35 and 10 or (r < 0.7 and 418 or 0)) end)
            c:RegisterEvent(function(_, _, _, cc) cc:Data():Set("lw4_tavern", nil); Unclaim(cc); pcall(function() cc:EmoteState(0) end) end, 240000, 1)
        end
    end
    if #folk > 0 and math.random() < 0.25 then Pick(folk):SendUnitSay(Pick(SONGS), 0) end
    if #folk >= 2 and math.random() < 0.06 then
        local a, b = folk[1], folk[2]
        pcall(function() a:SetFacingToObject(b); b:SetFacingToObject(a) end)
        a:SendUnitSay(Pick({"You spilled my drink!", "Say that again, I dare you!", "That's MY seat!"}), 0)
        pcall(function() a:PerformEmote(15); b:PerformEmote(15) end)
        b:RegisterEvent(function(_, _, _, bb) bb:SendUnitSay(Pick({"Outside, now!", "You want a piece of me?"}), 0) end, 2500, 1)
        inn:RegisterEvent(function(_, _, _, ii)
            for _, g in ipairs(ii:GetCreaturesInRange(60) or {}) do
                if Has(Lower(g), {"guard", "grunt", "watch", "sentinel", "deathguard", "peacekeeper"}) then
                    g:SendUnitYell(Pick({"Break it up, you two!", "Enough! Take it outside or sleep it off in a cell!"}), 0)
                    return
                end
            end
            ii:SendUnitSay("Not in my inn! Sit down, both of you!", 0)
        end, 5000, 1)
    end
end

local function DayNight(c, night)
    if not Hostile(c) then return end
    local n = Lower(c)
    local t = TypeOf(c)
    local want = (night and (t == 6 or Has(n, NIGHTBEAST))) or ((not night) and t == 7 and Has(n, BANDIT))
    local has = c:Data():Get("lw4_dn")
    if want and not has then
        c:Data():Set("lw4_dn", true)
        pcall(function() c:AddAura(EMPOWER, c) end)
    elseif has and not want then
        c:Data():Set("lw4_dn", nil)
        pcall(function() c:RemoveAura(EMPOWER) end)
    end
end

local function Wildlife(p)
    local beasts, herb, pred = {}, {}, {}
    for _, c in ipairs(p:GetCreaturesInRange(70) or {}) do
        if TypeOf(c) == 1 and Idle(c) and not ClaimedByOther(c) then
            local n = Lower(c)
            if Has(n, YOUNG) then beasts[#beasts + 1] = c
            elseif Has(n, HERBIVORE) then herb[#herb + 1] = c
            elseif Has(n, PREDATOR) then pred[#pred + 1] = c end
        end
    end
    for _, y in ipairs(beasts) do       -- young follow an adult of the same kind
        if not y:Data():Get("lw4_mom") then
            local base = string.gsub(Lower(y), "young ", "")
            for _, a in ipairs(herb) do
                if string.find(Lower(a), base, 1, true) or string.find(base, Lower(a), 1, true) then
                    y:Data():Set("lw4_mom", true)
                    pcall(function() y:MoveFollow(a, 2, math.random() * 3) end)
                    break
                end
            end
        end
    end
    for _, a in ipairs(herb) do         -- grazing
        if math.random() < 0.2 then pcall(function() a:PerformEmote(7) end) end
    end
    if #pred > 0 and #herb > 0 and math.random() < 0.15 then   -- a hunt
        local hunter, prey = Pick(pred), Pick(herb)
        if hunter:GetDistance(prey) < 50 then
            pcall(function() hunter:SetWalk(false); SafeMove(hunter, 0, prey:GetX(), prey:GetY(), prey:GetZ()) end)
            local dx, dy = prey:GetX() - hunter:GetX(), prey:GetY() - hunter:GetY()
            local len = math.max(1, math.sqrt(dx * dx + dy * dy))
            pcall(function() prey:SetWalk(false); SafeMove(prey, 1, prey:GetX() + dx / len * 35, prey:GetY() + dy / len * 35, prey:GetZ()) end)
            hunter:RegisterEvent(function(_, _, _, h) pcall(function() h:MoveHome() end) end, 9000, 1)
            prey:RegisterEvent(function(_, _, _, pr) pcall(function() pr:MoveHome() end) end, 15000, 1)
        end
    end
end

-- ---------------------------------------------------------------- 10 travellers
local ROAD = {}   -- list of {map, x, y, z, stop}
do
    local q = WorldDBQuery("SELECT route, idx, map, x, y, z, IFNULL(stop,'') FROM lw_route_node WHERE route >= 100 ORDER BY route, idx")
    if q then repeat
        local r = q:GetUInt32(0)
        ROAD[r] = ROAD[r] or {}
        table.insert(ROAD[r], {map = q:GetUInt32(2), x = q:GetFloat(3), y = q:GetFloat(4), z = q:GetFloat(5), stop = q:GetString(6)})
    until not q:NextRow() end
end
local TRAVELLERS = {9900135, 9900136, 9900137}
local RUMORS = {"They say something glints near %s. Worldforged, maybe.", "A scroll humming with power lies %s yards %s of here. I didn't dare touch it.",
    "Raiders were seen near the villages. Keep your blade sharp.", "The Manastorm Keepers in the capitals pay well for brave souls."}
local walkers = {}   -- guid string -> {route, i, dir, escort}

local function NearestRoad(p)
    local best
    for r, nodes in pairs(ROAD) do
        for i, n in ipairs(nodes) do
            if n.map == p:GetMapId() then
                local d = (n.x - p:GetX()) ^ 2 + (n.y - p:GetY()) ^ 2
                if d < 300 * 300 and (not best or d < best[1]) then best = {d, r, i} end
            end
        end
    end
    return best
end

local function WalkStep(c)
    local w = walkers[tostring(c:GetGUIDLow())]
    if not w then return end
    local nodes = ROAD[w.route]
    w.i = w.i + w.dir
    if w.i < 1 or w.i > #nodes then
        if w.escort then
            local p = FindPlayer(w.escort)
            if p and p:GetDistance(c) < 40 then
                c:SendUnitSay("We made it! Thank you, friend.", 0)
                if MYS_AddRunes then MYS_AddRunes(p, 1) end
                p:ModifyMoney(3000 * math.max(1, p:GetLevel()))
                if ECON_Change and CITY_RepOfZone then ECON_Change(CITY_RepOfZone(p, p:GetZoneId()), 1) end
            end
        end
        c:DespawnOrUnsummon(5000)
        walkers[tostring(c:GetGUIDLow())] = nil
        return
    end
    local n = nodes[w.i]
    pcall(function() c:SetWalk(true); SafeMove(c, w.i, n.x, n.y, n.z) end)
end

local function SpawnTraveller(p)
    local near = NearestRoad(p)
    if not near then return end
    local n = ROAD[near[2]][near[3]]
    local entry = Pick(TRAVELLERS)
    local ok, c = pcall(PerformIngameSpawn, 1, entry, n.map, 0, n.x, n.y, n.z + 1, 0, false, 1200000)
    if not (ok and c) then return end
    walkers[tostring(c:GetGUIDLow())] = {route = near[2], i = near[3], dir = math.random() < 0.5 and 1 or -1}
    c:RegisterEvent(function(_, _, _, cc)
        if not cc:IsInCombat() and not cc:IsMoving() then WalkStep(cc) end
    end, 4000, 0)
end

local function TravellerHello(_, player, c)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Any news from the road?", 0, 1)
    local w = walkers[tostring(c:GetGUIDLow())]
    if w and not w.escort then player:GossipMenuAddItem(0, "I'll escort you to the next town.", 0, 2) end
    player:GossipSendMenu(1, c)
end

local function TravellerSelect(_, player, c, _, intid)
    player:GossipComplete()
    if intid == 1 then
        local line = Pick(RUMORS)
        if string.find(line, "%%s yards") then
            local q = WorldDBQuery(string.format("SELECT wx, wy FROM worldforge_item WHERE map = %d AND wx BETWEEN %f AND %f AND wy BETWEEN %f AND %f LIMIT 1",
                c:GetMapId(), c:GetX() - 800, c:GetX() + 800, c:GetY() - 800, c:GetY() + 800))
            if q then
                local dx, dy = q:GetFloat(0) - c:GetX(), q:GetFloat(1) - c:GetY()
                local dir = (math.abs(dx) > math.abs(dy)) and (dx > 0 and "north" or "south") or (dy > 0 and "west" or "east")
                line = string.format(line, math.floor(math.sqrt(dx * dx + dy * dy) / 50) * 50, dir)
            else line = RUMORS[3] end
        elseif string.find(line, "%%s") then
            local okA, name = pcall(function() return GetAreaName(c:GetAreaId()) end)
            line = string.format(line, (okA and name) or "the old ruins")
        end
        c:SendUnitSay(line, 0)
    elseif intid == 2 then
        local w = walkers[tostring(c:GetGUIDLow())]
        if w then w.escort = player:GetName(); c:SendUnitSay("Bless you! Stay close, the road is dangerous.", 0) end
    end
end

-- ---------------------------------------------------------------- 9 inn rooms
local ROOM_HOURS = 24
local RCACHE = {}
function ROOM_XPFactor(player)
    local c = RCACHE[player:GetName()]
    if c and os.time() - c.t < 120 then return c.f end
    local f = 1.0
    local ok, res = pcall(CharDBQuery, string.format("SELECT until_ts FROM characters.inn_room WHERE name = '%s'", Key(player)))
    if ok and res and res:GetUInt32(0) > os.time() and player:HasItem(9730001) then f = 1.10 end
    RCACHE[player:GetName()] = {f = f, t = os.time()}
    return f
end

local function Innkeeper(p)
    for _, c in ipairs(p:GetCreaturesInRange(12) or {}) do
        if HasFlag(Flags(c), 65536) then return c end
    end
end

local ROOM_KEY, ROOM_DOOR = 9730001, 9709997

local function RentedHere(player, obj)
    local ok, res = pcall(CharDBQuery, string.format("SELECT map, x, y, until_ts FROM characters.inn_room WHERE name = '%s'", Key(player)))
    if not (ok and res) then return false, "You have no room. Buy a key from the innkeeper (.room)." end
    if res:GetUInt32(3) < os.time() then return false, "Your rent is over. Renew it at the innkeeper (.room)." end
    if res:GetUInt32(0) ~= obj:GetMapId() or (res:GetFloat(1) - obj:GetX()) ^ 2 + (res:GetFloat(2) - obj:GetY()) ^ 2 > 60 * 60 then
        return false, "This is not your inn. Your room is where you bought the key."
    end
    return true
end

-- Room Door (inn_rooms.sql): opens with the key while the rent lasts
local function OnDoor(event, go, player)
    if not player:HasItem(ROOM_KEY) then
        player:SendNotification("The door is locked.")
        player:SendBroadcastMessage(ITAG .. "The room is locked. Buy a key from the innkeeper (.room next to them).")
        return true
    end
    local ok, why = RentedHere(player, go)
    if not ok then player:SendBroadcastMessage(ITAG .. why) return true end
    player:SendBroadcastMessage(ITAG .. "You unlock your room. Your chest is here, and you rest well (+10% experience while the rent lasts).")
    player:SendShowBank(player)
    return true
end

local function Room(player, arg)
    local inn = Innkeeper(player)
    if arg == "chest" then
        local near = false
        for _, g in ipairs(player:GetGameObjectsInRange(8, ROOM_DOOR) or {}) do near = true end
        if not near then player:SendBroadcastMessage(ITAG .. "Your chest is behind your room door.") return end
        local ok, why = RentedHere(player, player)
        if not ok or not player:HasItem(ROOM_KEY) then player:SendBroadcastMessage(ITAG .. (why or "You need your room key.")) return end
        player:SendShowBank(player)
        return
    end
    if not inn then player:SendBroadcastMessage(ITAG .. "Stand next to an innkeeper and type .room to buy a room key.") return end
    local price = 1000 * math.max(1, player:GetLevel())
    if player:GetCoinage() < price then player:SendBroadcastMessage(ITAG .. "A room costs " .. math.floor(price / 100) .. " silver a day.") return end
    player:ModifyMoney(-price)
    local until_ts = os.time() + ROOM_HOURS * 3600
    pcall(CharDBExecute, string.format("REPLACE INTO characters.inn_room (name, map, x, y, z, area, until_ts) VALUES ('%s', %d, %f, %f, %f, %d, %d)",
        Key(player), player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetAreaId(), until_ts))
    pcall(function() player:SetBindPoint(player:GetX(), player:GetY(), player:GetZ(), player:GetMapId(), player:GetAreaId()) end)
    if not player:HasItem(ROOM_KEY) then player:AddItem(ROOM_KEY, 1) end
    inn:SendUnitSay("Here's your key, " .. player:GetName() .. ". The room door is " .. "just up the way. Sleep well!", 0)
    player:SendBroadcastMessage(ITAG .. "Room rented for " .. ROOM_HOURS .. " hours. Use the Room Door in this inn with your key: your own chest and +10% experience. " ..
        "Your hearthstone is bound here.")
end

-- ---------------------------------------------------------------- scheduler
local lastHerald, lastTraveller, lastEcon = 0, {}, 0
local LW4_SEEN = {}   -- guid -> tick ked bol tvor naposledy pri hracoch (proti zaseknutym emotom)
local function Tick()
    local now, night, day = os.time(), IsNight(), (Hour() >= 6 and Hour() < 19)
    local players = LW_Players()
    PollNews()
    if now - lastHerald >= 900 then
        lastHerald = now
        local done = {}
        for _, p in ipairs(players) do
            local z = p:GetZoneId()
            if CAPITALS[z] and not done[z] then done[z] = true; Herald(p) end
        end
    end
    local seen = {}
    for _, p in ipairs(players) do
        if p:IsInWorld() and not p:IsInCombat() then
            for _, c in ipairs(p:GetCreaturesInRange(45) or {}) do
                local okG, guid = pcall(function() return tostring(c:GetGUIDLow()) end)
                if okG and guid then seen[guid] = c end
                if TypeOf(c) == 7 and Idle(c) and not Hostile(c) then Work(c, day) end
                DayNight(c, night)
            end
            Tavern(p, now)
            Wildlife(p)
            local k = p:GetName()
            if (lastTraveller[k] or 0) + 600 < now and not CAPITALS[p:GetZoneId()] and math.random() < 0.3 then
                lastTraveller[k] = now
                SpawnTraveller(p)
            end
            if now - lastEcon >= 600 and CAPITALS[p:GetZoneId()] and CITY_RepOfZone then
                lastEcon = now
                local t = TRADE[CITY_RepOfZone(p, p:GetZoneId())] or 0
                if t ~= 0 then
                    for _, c in ipairs(p:GetCreaturesInRange(25) or {}) do
                        if HasFlag(Flags(c), 128) then c:SendUnitSay(Pick(t > 0 and ECON_GOOD or ECON_BAD), 0) break end
                    end
                end
            end
        end
    end
    -- kto zmizol z dohladu so zapnutym stavom: vycisti emote aj narok (nezaseknuty dedincan)
    for guid, c in pairs(LW4_SEEN) do
        if not seen[guid] then
            pcall(function()
                if c and c:IsInWorld() then
                    c:EmoteState(0)
                    if c:Data():Get("lw_claim") == "lw4" then c:Data():Set("lw_claim", nil) end
                end
            end)
            LW4_SEEN[guid] = nil
        end
    end
    for guid, c in pairs(seen) do LW4_SEEN[guid] = c end
end

if ENABLED then
    MAP_Timer("living_world4.Tick", Tick, 15000)
    local function RegisterDoor() RegisterGameObjectEvent(ROOM_DOOR, 14, OnDoor) end
    if not pcall(RegisterDoor) then RegisterServerEvent(14, RegisterDoor) end
    for _, e in ipairs(TRAVELLERS) do
        RegisterCreatureGossipEvent(e, 1, TravellerHello)
        RegisterCreatureGossipEvent(e, 2, TravellerSelect)
    end
    RegisterPlayerEvent(42, function(_, player, command)
        local c = string.lower(command or "")
        if c == "room" then Room(player) return false end
        if c == "room chest" then Room(player, "chest") return false end
    end)
    local n = 0
    for _ in pairs(ROAD) do n = n + 1 end
    print("[living world v4] work, taverns, criers, funerals, day/night, economy, wildlife, inn rooms, travellers on " .. n .. " roads")
end

function LW_GM_Traveller(player) SpawnTraveller(player) return "Traveller spawned (needs a road within 300 yd)." end

LW_QUEUE_HANDLERS["gmtrav"] = function(p) if not p then return false end p:SendBroadcastMessage("|cff00ff00[GM]|r " .. LW_GM_Traveller(p)) return true end
