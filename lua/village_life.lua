-- =====================================================================
-- Village life: every village and town with an innkeeper gets small scenes while a player is near, so the place is never
-- just standing NPCs: a bard's tale with an audience, market day, a tavern brawl that the guards break up, hunters
-- returning with a tale, a drunk singing in the square. Actors are the village's own friendly creatures (same
-- faction, same look), cloned for a few minutes and then sent home. Every scene writes one line to the Eluna log
-- ("[village_life] ...") and GM ".lwgm village" starts one at your feet.
-- =====================================================================
if IS_WORLD_STATE then return end

local TICK_MS = 45000
local COOLDOWN = 4 * 60            -- seconds between scenes in the same village
local NEAR = 90                    -- a player must be this close to the village centre
local ACTOR_LIFE = 6 * 60 * 1000

local VILLAGES = {}
local FRIENDLY = 'Villager|Citizen|Peon|Peasant|Farmer|Laborer|Settler|Grunt|Guard|Footman|Scout|Hunter|Miner|Woodcutter|Fisherman|Merchant|Wanderer|Peacekeeper|Militia|Initiate|Trainer|Headhunter|Witch Doctor|Sentinel|Mountaineer'
local seenArea = {}
local function AddVillages(sql)
    local q = WorldDBQuery(sql)
    if q then repeat
        local area, map = q:GetUInt32(0), q:GetUInt32(1)
        if not seenArea[area .. ":" .. map] then
            seenArea[area .. ":" .. map] = true
            VILLAGES[#VILLAGES + 1] = {area = area, map = map, x = q:GetDouble(2), y = q:GetDouble(3), z = q:GetDouble(4), zone = q:GetUInt32(5), last = 0}
        end
    until not q:NextRow() end
end
-- towns and villages with an innkeeper
AddVillages([[
    SELECT c.areaId, c.map, AVG(c.position_x), AVG(c.position_y), MIN(c.position_z), MIN(c.zoneId) FROM creature c JOIN creature_template t ON t.entry = c.id
     WHERE (t.subname = 'Innkeeper' OR t.npcflag & 65536) AND c.areaId <> 0 AND IFNULL(c.PhaseId,0) IN (0, 169)
       AND c.zoneId NOT IN (1637,1519,1537,1638,1497,1657,3487,3557,3703,4395,7502,13862,14771)
     GROUP BY c.areaId, c.map]])
-- camps, outposts and training grounds: every 100-yard square with five or more friendly people (Sen'jin, Echo Isles, Valley of Trials...)
do
    local q = WorldDBQuery("SELECT c.map, AVG(c.position_x), AVG(c.position_y), AVG(c.position_z), MIN(c.zoneId) FROM creature c JOIN creature_template t ON t.entry = c.id " ..
        "WHERE c.map IN (0, 1, 530, 571) AND IFNULL(c.PhaseId,0) IN (0, 169) AND t.type = 7 AND t.npcflag = 0 AND t.Classification = 0 AND t.name REGEXP '" .. FRIENDLY ..
        "' AND c.zoneId NOT IN (1637,1519,1537,1638,1497,1657,3487,3557,3703,4395,7502,13862,14771) GROUP BY c.map, FLOOR(c.position_x / 100), FLOOR(c.position_y / 100) HAVING COUNT(*) >= 5")
    local n = 0
    if q then repeat
        n = n + 1
        local v = {area = 900000 + n, map = q:GetUInt32(0), x = q:GetDouble(1), y = q:GetDouble(2), z = q:GetDouble(3), zone = q:GetUInt32(4), last = 0}
        local dup = false
        for _, o in ipairs(VILLAGES) do if o.map == v.map and (o.x - v.x) ^ 2 + (o.y - v.y) ^ 2 < 70 * 70 then dup = true break end end
        if not dup then VILLAGES[#VILLAGES + 1] = v end
    until not q:NextRow() end
end

-- friendly local people of the village: entry list + ground points (where creatures already stand)
local function Cast(v)
    if v.cast then return v.cast end
    v.cast, v.spots = {}, {}
    local r = WorldDBQuery(string.format(
        "SELECT DISTINCT c.id, c.position_x, c.position_y, c.position_z FROM creature c JOIN creature_template t ON t.entry = c.id " ..
        "WHERE c.map = %d AND c.position_x BETWEEN %f AND %f AND c.position_y BETWEEN %f AND %f AND t.type = 7 AND t.npcflag = 0 AND t.Classification = 0 " ..
        "AND t.name REGEXP '%s' AND t.name NOT REGEXP 'Corpse|Dead|Riding|Swift' LIMIT 60",
        v.map, v.x - 90, v.x + 90, v.y - 90, v.y + 90, FRIENDLY))
    local tq = WorldDBQuery(string.format("SELECT COUNT(*) FROM creature c JOIN creature_template t ON t.entry = c.id WHERE c.map = %d AND c.position_x BETWEEN %f AND %f AND c.position_y BETWEEN %f AND %f AND t.name REGEXP 'Darkspear|Troll|Witch Doctor|Headhunter|Voodoo|Hexxer|Tiki'", v.map, v.x - 90, v.x + 90, v.y - 90, v.y + 90))
    v.troll = tq and tq:GetUInt32(0) >= 3 or false
    local seen = {}
    if r then repeat
        local e = r:GetUInt32(0)
        if not seen[e] then seen[e] = true; v.cast[#v.cast + 1] = e end
        v.spots[#v.spots + 1] = {r:GetFloat(1), r:GetFloat(2), r:GetFloat(3)}
    until not r:NextRow() end
    return v.cast
end

local function Pick(t) return t[math.random(#t)] end

local function Spawn(ref, entry, x, y, z, o)
    local ok, c = pcall(PerformIngameSpawn, 1, entry, ref:GetMapId(), 0, x, y, z, o or 0, false, ACTOR_LIFE)
    if ok and c then
        pcall(function() c:SetWalk(true) end)
        return c
    end
end

local function Say(c, text)
    if c and c:IsInWorld() then pcall(function() c:SendUnitSay(text, 0) end) end
end
local function Emote(c, id)
    if c and c:IsInWorld() then pcall(function() c:EmoteState(0); c:PerformEmote(id) end) end
end
local function Go(c, x, y, z)
    if c and c:IsInWorld() then pcall(function() c:MoveTo(1, x, y, z, true) end) end
end
local function Later(ref, ms, fn)
    pcall(function() ref:RegisterEvent(function(_, _, _, o) if o and o:IsInWorld() then pcall(fn, o) end end, ms, 1) end)
end

-- ---------------------------------------------------------------- scenes
local BARD = {
    "Listen well, friends, and I will tell of the days when the old war shook this land!",
    "They say the roads were safer once. Now bandits wait behind every second hill.",
    "A dragon once slept under these hills. Some say it still does. Do not dig too deep.",
    "I sing of heroes who carried no title, only a sword and a good boot for running.",
    "Three brothers set out to the mountain. Only the quiet one came home. Care for a coin?",
    "The Dark Portal burned once, and half the world forgot how to sleep.",
    "Raise a cup for those who guard the walls tonight, and another for those who forgot to!",
}
local MARKET = {
    "Fresh bread! Baked at dawn!", "Salted fish, best on the coast!", "Herbs and healing salves, fair prices!",
    "Sharp knives! Sharper than the guards' wit!", "Wool from the highlands, warm and cheap!", "Apples! Who wants an apple?",
    "Come close, the best of the harvest is here!",
}
local BRAWL_A = {"You spilled my ale, you oaf!", "Say that again, I dare you!", "I saw you cheat at dice!"}
local BRAWL_B = {"Then buy another, if you can afford it!", "Gladly! Louder, so the whole inn hears!", "You owe me three silver!"}
local GUARD = {"Enough! Take it outside or spend the night in a cell!", "Break it up, both of you! Go home and sleep it off.", "Not in my village. Cool your heads!"}
local HUNT = {
    "We tracked the beast three days. It nearly got Harl, you should have seen his face!",
    "Plenty of meat tonight. Come, share the fire!",
    "The woods are restless. Something drove the game toward the road.",
    "Stay out of the north pass. We saw tracks there, no honest creature leaves tracks like that.",
}
local DRUNK = {
    "*hic* ...and the king said, 'Sir, you are a barrel!'... *hic*",
    "Another round for the whole village! ...Who is paying? Not me!",
    "La la laaa... the road goes ever on... *hic*",
    "I swear the stars are moving. Or I am. Possibly the cup.",
}

local function Scene_Bard(v, ref, cast)
    local x, y, z = v.x, v.y, v.z
    local bard = Spawn(ref, Pick(cast), x, y, z)
    if not bard then return false end
    Say(bard, "Gather round, friends!")
    local n = 3 + math.random(0, 2)
    for i = 1, n do
        local a = math.pi * 2 * i / n
        local c = Spawn(ref, Pick(cast), x + math.cos(a) * 9, y + math.sin(a) * 9, z, a + math.pi)
        if c then
            Go(c, x + math.cos(a) * 4, y + math.sin(a) * 4, z)
            Later(c, 20000, function(o) o:SetFacing(a + math.pi) end)
            for k = 1, 4 do Later(c, 30000 + k * 35000 + math.random(0, 9000), function(o) Emote(o, math.random() < 0.5 and 21 or 4) end) end
        end
    end
    for k = 0, 5 do
        Later(bard, 12000 + k * 28000, function(o) Say(o, Pick(BARD)); Emote(o, 1) end)
    end
    return true
end

local function Scene_Market(v, ref, cast)
    local sp = v.spots
    if #sp < 3 then return false end
    for i = 1, 4 do
        local s = Pick(sp)
        local c = Spawn(ref, Pick(cast), s[1] + 3, s[2] + 2, s[3])
        if c then
            for k = 0, 4 do
                Later(c, 8000 + k * 40000 + i * 3000, function(o) Say(o, Pick(MARKET)); Emote(o, math.random() < 0.5 and 3 or 5) end)
            end
        end
    end
    return true
end

local function Scene_Brawl(v, ref, cast)
    local x, y, z = v.x, v.y, v.z
    local a = Spawn(ref, Pick(cast), x - 1.2, y, z, 0)
    local b = Spawn(ref, Pick(cast), x + 1.2, y, z, math.pi)
    local g = Spawn(ref, Pick(cast), x + 12, y + 6, z)
    if not (a and b and g) then return false end
    local i = math.random(#BRAWL_A)
    Later(a, 4000, function(o) Say(o, BRAWL_A[i]); Emote(o, 14) end)
    Later(b, 9000, function(o) Say(o, BRAWL_B[i]); Emote(o, 15) end)
    Later(a, 15000, function(o) Say(o, "Come here!"); Emote(o, 15) end)
    Later(g, 20000, function(o) Go(o, x, y + 3, z) end)
    Later(g, 30000, function(o) Say(o, Pick(GUARD)); Emote(o, 5) end)
    Later(a, 36000, function(o) Say(o, "...Fine. Sorry."); Emote(o, 18) end)
    Later(b, 40000, function(o) Say(o, "Bah. Next round is on you."); Emote(o, 66) end)
    return true
end

local function Scene_Hunters(v, ref, cast)
    local x, y, z = v.x, v.y, v.z
    local ang = math.random() * math.pi * 2
    local n = 3
    for i = 1, n do
        local c = Spawn(ref, Pick(cast), x + math.cos(ang) * 60 + i, y + math.sin(ang) * 60, z)
        if c then
            Go(c, x + i * 1.5, y + 2, z)
            Later(c, 40000 + i * 4000, function(o) Say(o, Pick(HUNT)); Emote(o, 1) end)
            Later(c, 90000 + i * 6000, function(o) Say(o, Pick(HUNT)); Emote(o, 1) end)
        end
    end
    return true
end

local function Scene_Drunk(v, ref, cast)
    local c = Spawn(ref, Pick(cast), v.x + 2, v.y + 1, v.z)
    if not c then return false end
    pcall(function() c:EmoteState(10) end)   -- dance, so he sways
    for k = 0, 5 do Later(c, 6000 + k * 30000, function(o) Say(o, Pick(DRUNK)) end) end
    return true
end


-- Dock work: where a village has boats or piers, hands load crates between the pier and the ship, a foreman shouts orders
local DOCK = {"Heave! Mind the rope!", "Crates to the left, barrels to the right!", "The tide will not wait for us!", "Careful with that one, it is fragile.", "Another load for the captain!"}
local function Scene_Dock(v, ref, cast)
    local boat
    local ok, gos = pcall(function() return ref:GetGameObjectsInRange(150) end)
    if ok and gos then
        local best = 1e9
        for _, go in ipairs(gos) do
            local n = string.lower(go:GetName() or "")
            if string.find(n, "boat", 1, true) or string.find(n, "ship", 1, true) or string.find(n, "pier", 1, true) or string.find(n, "dock", 1, true) then
                local d = (go:GetX() - v.x) ^ 2 + (go:GetY() - v.y) ^ 2
                if d < best then best, boat = d, go end
            end
        end
    end
    if not boat then return false end
    local bx, by, bz = boat:GetX(), boat:GetY(), boat:GetZ()
    local ang = math.atan2(v.y - by, v.x - bx)
    local px, py = bx + math.cos(ang) * 10, by + math.sin(ang) * 10     -- landward side of the boat
    local foreman = Spawn(ref, Pick(cast), px + 2, py + 2, v.z)
    if foreman then
        for k = 0, 5 do Later(foreman, 5000 + k * 45000, function(o) Say(o, Pick(DOCK)); Emote(o, 5) end) end
    end
    local made = 0
    for i = 1, 3 do
        local c = Spawn(ref, Pick(cast), v.x + i, v.y, v.z)
        if c then
            made = made + 1
            pcall(function() c:AddAura(52415, c) end)                     -- carrying a crate
            for trip = 0, 6 do
                Later(c, 6000 + trip * 50000 + i * 4000, function(o) Go(o, px, py, v.z) end)
                Later(c, 28000 + trip * 50000 + i * 4000, function(o) Go(o, v.x + i, v.y, v.z) end)
            end
        end
    end
    return made > 0
end


-- Pirate raid: Bloodsail / Defias / Corsair pirates land at the boats and the village's own defenders (same faction as the village) fight them.
-- Heroes who help get Mystic Runes for every pirate they kill. Pirates and defenders are temporary.
local PIRATE_LINES = {"Burn it all and take the gold!", "No quarter!", "The captain wants every barrel on this dock!", "Weapons up, lads!"}
local DEFEND_LINES = {"Pirates! To arms!", "Defend the village!", "Not one of them leaves the dock alive!"}
local function Pirates(v)
    if v.pirates then return v.pirates end
    v.pirates = {}
    local q = WorldDBQuery(string.format(
        "SELECT t.entry, COUNT(*) FROM creature c JOIN creature_template t ON t.entry = c.id WHERE c.map = %d AND c.position_x BETWEEN %f AND %f AND c.position_y BETWEEN %f AND %f " ..
        "AND t.npcflag = 0 AND t.type = 7 AND t.Classification = 0 AND t.name REGEXP 'Pirate|Bloodsail|Corsair|Buccaneer|Smuggler|Raider|Cutthroat|Brigand' GROUP BY t.entry ORDER BY COUNT(*) DESC LIMIT 5",
        v.map, v.x - 1200, v.x + 1200, v.y - 1200, v.y + 1200))
    if q then repeat v.pirates[#v.pirates + 1] = q:GetUInt32(0) until not q:NextRow() end
    return v.pirates
end
local function Scene_Raid(v, ref, cast)
    if math.random(100) > 25 then return false end        -- rarer than the ordinary scenes
    local pirates = Pirates(v)
    if #pirates == 0 then return false end
    local boat
    local ok, gos = pcall(function() return ref:GetGameObjectsInRange(160) end)
    if ok and gos then
        local best = 1e9
        for _, go in ipairs(gos) do
            local n = string.lower(go:GetName() or "")
            if string.find(n, "boat", 1, true) or string.find(n, "ship", 1, true) or string.find(n, "pier", 1, true) or string.find(n, "dock", 1, true) then
                local d = (go:GetX() - v.x) ^ 2 + (go:GetY() - v.y) ^ 2
                if d < best then best, boat = d, go end
            end
        end
    end
    if not boat then return false end
    local bx, by = boat:GetX(), boat:GetY()
    local ang = math.atan2(v.y - by, v.x - bx)
    local lx, ly = bx + math.cos(ang) * 9, by + math.sin(ang) * 9
    local foes, friends = {}, {}
    for i = 1, 4 do
        local c = Spawn(ref, Pick(pirates), lx + i, ly + (i % 2) * 2, v.z)
        if c then
            foes[#foes + 1] = c
            pcall(function() c:Data():Set("pirate_raid", true) end)
            if i == 1 then Say(c, Pick(PIRATE_LINES)) end
        end
    end
    for i = 1, 3 do
        local c = Spawn(ref, Pick(cast), v.x + i * 2, v.y + 2, v.z)
        if c then friends[#friends + 1] = c; if i == 1 then Say(c, Pick(DEFEND_LINES)) end end
    end
    if #foes == 0 then return false end
    for i, f in ipairs(foes) do
        local t = friends[(i % math.max(1, #friends)) + 1]
        if t then pcall(function() f:AttackStart(t) end) end
    end
    for i, d in ipairs(friends) do
        local t = foes[(i % #foes) + 1]
        if t then pcall(function() d:AttackStart(t) end) end
    end
    local msg = "|cffff8000[World]|r Pirates have landed at the docks of the village! Help the defenders!"
    pcall(function() ref:SendBroadcastMessage(msg) end)
    return true
end

-- Darkspear scenes (Echo Isles, Sen'jin, any troll camp): a drum circle and a voodoo ritual, in their own voice and with their own lore
local DRUM = {"Da drums call, mon! Come, dance wit us!", "Feel de beat, feel de island heartbeat!", "Vol'jin watches, so we dance!", "Dis be Darkspear way, mon!", "Da loa dance wit us tonight!"}
local RITUAL = {"Spirits of de Echo Isles, hear us!", "Zalazane's shadow be gone, but we remember, mon.", "Bwonsamdi, take no one from dis circle tonight.", "Da loa speak... listen close."}
local function Scene_Drums(v, ref, cast)
    if not v.troll then return false end
    local x, y, z = v.x, v.y, v.z
    local drummer = Spawn(ref, Pick(cast), x, y, z)
    if not drummer then return false end
    pcall(function() drummer:EmoteState(69) end)
    for k = 0, 6 do Later(drummer, 4000 + k * 30000, function(o) Say(o, Pick(DRUM)) end) end
    for i = 1, 4 do
        local a = math.pi * 2 * i / 4
        local c = Spawn(ref, Pick(cast), x + math.cos(a) * 5, y + math.sin(a) * 5, z, a + math.pi)
        if c then pcall(function() c:EmoteState(10) end) end          -- dance
    end
    return true
end
local function Scene_Ritual(v, ref, cast)
    if not v.troll then return false end
    local x, y, z = v.x, v.y, v.z
    local shaman = Spawn(ref, Pick(cast), x, y, z)
    if not shaman then return false end
    pcall(function() shaman:CastSpell(shaman, 75965, true) end)       -- shadow channeling beam
    for k = 0, 5 do Later(shaman, 6000 + k * 35000, function(o) Say(o, Pick(RITUAL)); Emote(o, 3) end) end
    for i = 1, 3 do
        local a = math.pi * 2 * i / 3
        local c = Spawn(ref, Pick(cast), x + math.cos(a) * 4, y + math.sin(a) * 4, z, a + math.pi)
        if c then pcall(function() c:EmoteState(16) end) end          -- kneel
    end
    return true
end

-- Darkspear training: a hunter throws spears at a tiki target; a handler calms a raptor
local TIKI = {"Steady aim, steady hand, mon!", "Dat one hit de heart!", "Again! Da Horde need good throwers!", "De spirits guide da spear!"}
local RAPTOR = {"Easy, little one. Easy.", "Good raptor. Dat be a good raptor.", "Dey bite less when dey trust ya, mon.", "Bloodtalon be proud animals, treat dem right."}
local function NearbyByName(ref, pattern, range)
    local ok, list = pcall(function() return ref:GetCreaturesInRange(range) end)
    if not (ok and list) then return nil end
    for _, c in ipairs(list) do
        local n = string.lower(c:GetName() or "")
        if string.find(n, pattern, 1, true) and c:IsAlive() then return c end
    end
end
local function Scene_Tiki(v, ref, cast)
    if not v.troll then return false end
    local target = NearbyByName(ref, "tiki", 120) or NearbyByName(ref, "dummy", 120)
    if not target then return false end
    local a = math.random() * math.pi * 2
    local c = Spawn(ref, Pick(cast), target:GetX() + math.cos(a) * 12, target:GetY() + math.sin(a) * 12, target:GetZ())
    if not c then return false end
    for k = 0, 8 do
        Later(c, 5000 + k * 12000, function(o)
            pcall(function() o:SetFacing(math.atan2(target:GetY() - o:GetY(), target:GetX() - o:GetX())) end)
            pcall(function() o:CastSpell(target, 2764, true) end)       -- Throw
            if k % 3 == 0 then Say(o, Pick(TIKI)) end
        end)
    end
    return true
end
local function Scene_Raptor(v, ref, cast)
    if not v.troll then return false end
    local r = NearbyByName(ref, "raptor", 120)
    if not r then return false end
    local c = Spawn(ref, Pick(cast), r:GetX() + 2, r:GetY() + 1, r:GetZ())
    if not c then return false end
    for k = 0, 6 do
        Later(c, 4000 + k * 20000, function(o)
            pcall(function() o:SetFacing(math.atan2(r:GetY() - o:GetY(), r:GetX() - o:GetX())) end)
            Emote(o, 66)
            if k % 2 == 0 then Say(o, Pick(RAPTOR)) end
        end)
    end
    return true
end

local SCENES = {{"tiki", Scene_Tiki}, {"raptor", Scene_Raptor}, {"drums", Scene_Drums}, {"ritual", Scene_Ritual}, {"raid", Scene_Raid}, {"dock", Scene_Dock}, {"bard", Scene_Bard}, {"market", Scene_Market}, {"brawl", Scene_Brawl}, {"hunters", Scene_Hunters}, {"drunk", Scene_Drunk}}

local function Run(v, ref, forceName)
    local cast = Cast(v)
    if #cast == 0 then return false end
    local order = {}
    for i, s in ipairs(SCENES) do order[i] = s end
    for i = #order, 2, -1 do local j = math.random(i); order[i], order[j] = order[j], order[i] end
    for _, s in ipairs(order) do
        if not forceName or forceName == s[1] then
            local ok, res = pcall(s[2], v, ref, cast)
            if ok and res then
                v.last = os.time()
                print(string.format("[village_life] %s in area %d (zone %d)", s[1], v.area, v.zone))
                return s[1]
            end
        end
    end
    return false
end

local function Director()
    local now = os.time()
    for _, p in ipairs(LW_Players() or {}) do
        for _, v in ipairs(VILLAGES) do
            if v.map == p:GetMapId() and now - v.last >= COOLDOWN and (v.x - p:GetX()) ^ 2 + (v.y - p:GetY()) ^ 2 < NEAR * NEAR then
                if math.random() < 0.7 then Run(v, p) else v.last = now - COOLDOWN + 60 end
                break
            end
        end
    end
end

RegisterPlayerEvent(7, function(_, killer, killed)    -- pirates of a raid: Mystic Runes for the hero
    if not killer or not killed then return end
    local ok, raid = pcall(function() return killed:Data():Get("pirate_raid") end)
    if ok and raid and MYS_AddRunes then pcall(MYS_AddRunes, killer, 1); killer:SendBroadcastMessage("|cffff8000[Raid]|r +1 Mystic Rune.") end
end)

MAP_Timer("village_life.Director", Director, TICK_MS)

-- GM: .lwgm village [bard|market|brawl|hunters|drunk]  starts a scene in the nearest village (queued from gm_panel.lua)
LW_QUEUE_HANDLERS["village"] = function(player, sub)
    if not player then return false end
    local best, bd = nil, 1e12
    for _, v in ipairs(VILLAGES) do
        if v.map == player:GetMapId() then
            local d = (v.x - player:GetX()) ^ 2 + (v.y - player:GetY()) ^ 2
            if d < bd then best, bd = v, d end
        end
    end
    if not best or bd > 400 * 400 then player:SendBroadcastMessage("|cff00ff00[GM]|r No village within 400 yards.") return true end
    local r = Run(best, player, (sub and sub ~= "") and sub or nil)
    player:SendBroadcastMessage("|cff00ff00[GM]|r " .. (r and ("Scene started: " .. r) or "Scene failed (no actors found here)."))
    return true
end
print("[village_life] " .. #VILLAGES .. " villages")
