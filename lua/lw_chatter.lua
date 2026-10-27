-- =====================================================================
-- Living World chatter engine (shared by silvermoon_alive.lua and any other city).
--  * Every NPC speaks only when a player is near and only a few times an hour:
--    first spoken line after 60-180 s, then every 70-200 s, and never when another NPC
--    of the same area spoke in the last 30 s.
--  * Lines are drawn from shuffle bags: a line does not come back until the whole
--    pool was used, so the same sentence is not heard twice in a row.
--  * Guards speak about the part of the city they stand in (area lines), about what is
--    happening in the city (news) and about their duty. Other roles speak about their
--    trade. Neighbours of the same kind hold short dialogues.
-- Config:  LWChatter.Register{ key="sm", roles={ guard={entries...}, ...}, lines={...} }
-- Loads at worldserver start from lua_scripts/ (map state, creature hooks).
-- =====================================================================
if IS_WORLD_STATE then return end

LWChatter = LWChatter or {}

local BAGS = {}
-- no-repeat picker: a shuffled copy of the list is consumed line by line, then reshuffled (the first line of a new round differs from the last of the old one)
function LWChatter.Bag(key, list)
    if not list or #list == 0 then return nil end
    if #list == 1 then return list[1] end
    local bag = BAGS[key]
    if not bag or bag.pos > #bag.order or bag.n ~= #list then
        local order = {}
        for i = 1, #list do order[i] = i end
        for i = #order, 2, -1 do local j = math.random(i); order[i], order[j] = order[j], order[i] end
        if bag and bag.last and order[1] == bag.last then order[1], order[#order] = order[#order], order[1] end
        bag = { order = order, pos = 1, n = #list }
        BAGS[key] = bag
    end
    local idx = bag.order[bag.pos]
    bag.pos = bag.pos + 1
    bag.last = idx
    return list[idx]
end

local function Hour()
    local t = 0
    if GetGameTime then
        local ok, v = pcall(GetGameTime)
        if ok and type(v) == "number" then t = v end
    end
    if t == 0 then t = os.time() % 86400 end
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

local LAST_AREA_TALK = {}

function LWChatter.Register(cfg)
    local KEY = cfg.key
    local CHECK_RANGE = cfg.range or 40
    local FIRST_MIN, FIRST_MAX = cfg.first_min or 60000, cfg.first_max or 180000
    local MIN_DELAY, MAX_DELAY = cfg.min_delay or 70000, cfg.max_delay or 200000
    local TALK_CHANCE = cfg.talk_chance or 0.6
    local DIALOGUE_CHANCE = cfg.dialogue_chance or 0.5
    local QUIET = cfg.area_quiet or 30
    local GREET_RANGE, GREET_COOLDOWN = 16, 90
    local L = cfg.lines
    local roleOf = {}
    for role, entries in pairs(cfg.roles) do
        for _, e in ipairs(entries) do roleOf[e] = role end
    end

    local function Say(creature, line)
        if line then creature:SendUnitSay(line, 0) end
    end
    local function SayLater(creature, line, delay)
        creature:RegisterEvent(function(_, _, _, c) if c and c:IsAlive() then Say(c, line) end end, delay, 1)
    end

    -- one solo line for a role
    local function SoloLine(creature, role)
        local set = L[role]
        if not set then return nil end
        if IsNight() and set.night and math.random() < 0.4 then return LWChatter.Bag(KEY .. ":" .. role .. ":night", set.night) end
        if role == "guard" then
            local roll = math.random()
            local ok, area = pcall(creature.GetAreaId, creature)
            local alines = ok and set.area and set.area[area]
            if alines and roll < 0.45 then return LWChatter.Bag(KEY .. ":guard:area:" .. area, alines) end
            if set.news and roll < 0.75 then return LWChatter.Bag(KEY .. ":guard:news", set.news) end
            return LWChatter.Bag(KEY .. ":guard:duty", set.duty or set.solo)
        end
        return LWChatter.Bag(KEY .. ":" .. role .. ":solo", set.solo)
    end

    local function Talk(eventId, delay, repeats, creature)
        if not creature or not creature:IsAlive() then return end
        local role = creature:Data():Get(KEY .. "_role")
        local players = creature:GetPlayersInRange(CHECK_RANGE)
        if role and players and #players > 0 and math.random() < TALK_CHANCE then
            local okA, areaId = pcall(creature.GetAreaId, creature)
            if not okA or type(areaId) ~= "number" then areaId = 0 end
            local now = os.time()
            if now - (LAST_AREA_TALK[areaId] or 0) >= QUIET then
                LAST_AREA_TALK[areaId] = now
                local cast = { creature }
                local near = creature:GetCreaturesInRange(20)
                if near then
                    for _, o in ipairs(near) do
                        if #cast >= 2 then break end
                        if o and o ~= creature and o:IsAlive() and o:Data():Get(KEY .. "_role") == role then cast[#cast + 1] = o end
                    end
                end
                local conv
                if #cast >= 2 and math.random() < DIALOGUE_CHANCE then
                    local dl = L[role] and L[role].dialogues
                    if dl and (math.random() < 0.7 or not L.chatter) then conv = LWChatter.Bag(KEY .. ":" .. role .. ":dlg", dl)
                    elseif L.chatter then conv = LWChatter.Bag(KEY .. ":chatter", L.chatter) end
                end
                if conv then
                    pcall(function() cast[1]:SetFacingToObject(cast[2]); cast[2]:SetFacingToObject(cast[1]) end)
                    for i, line in ipairs(conv) do
                        local speaker = cast[((i - 1) % #cast) + 1]
                        if i == 1 then Say(speaker, line) else SayLater(speaker, line, (i - 1) * math.random(4000, 7000)) end
                    end
                else
                    Say(creature, SoloLine(creature, role))
                end
            end
        end
        creature:RegisterEvent(Talk, math.random(MIN_DELAY, MAX_DELAY), 1)
    end

    local function Greet(eventId, delay, repeats, creature)
        if not creature or not creature:IsAlive() then return end
        local role = creature:Data():Get(KEY .. "_role")
        local set = role and L[role]
        if set and set.greet then
            local players = creature:GetPlayersInRange(GREET_RANGE)
            if players and #players > 0 then
                local now = os.time()
                local last = creature:Data():Get(KEY .. "_greet") or 0
                if type(last) ~= "number" then last = 0 end
                if now - last >= GREET_COOLDOWN then
                    creature:Data():Set(KEY .. "_greet", now)
                    Say(creature, LWChatter.Bag(KEY .. ":" .. role .. ":greet", set.greet))
                end
            end
        end
        creature:RegisterEvent(Greet, 15000, 1)
    end

    for entry, role in pairs(roleOf) do
      if not (HAS_CPP_SCRIPT and HAS_CPP_SCRIPT[entry]) then   -- registering an Eluna event would replace the C++ AI of such a creature
        RegisterCreatureEvent(entry, 5, function(e, c)
            c:Data():Set(KEY .. "_role", role)
            c:RegisterEvent(Talk, math.random(FIRST_MIN, FIRST_MAX), 1)
            if L[role] and L[role].greet then c:RegisterEvent(Greet, 20000, 1) end
        end)
        RegisterCreatureEvent(entry, 4, function(e, c) c:RemoveEvents() end)
      end
    end

    -- guard gossip: directions (area name per menu entry)
    if cfg.directions then
        local ids = cfg.roles.guard or {}
        local function Hello(event, player, creature)
            for i, d in ipairs(cfg.directions) do player:GossipMenuAddItem(0, d.q, 1, i) end
            player:GossipMenuAddItem(0, "Never mind.", 1, 99)
            player:GossipSendMenu(1, creature)
        end
        local function Select(event, player, creature, sender, intid)
            local d = cfg.directions[intid]
            if d then creature:SendUnitSay(d.a, 0) end
            player:GossipComplete()
        end
        for _, e in ipairs(ids) do
            RegisterCreatureGossipEvent(e, 1, Hello)
            RegisterCreatureGossipEvent(e, 2, Select)
        end
    end
    print("[LWChatter] " .. KEY .. " registered")
end
