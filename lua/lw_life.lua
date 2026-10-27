-- =====================================================================
-- Living World: errands and chores. People of a town do the things people do:
--   fishers fish at the water and sell the catch to cooks, innkeepers and grocers (they haggle),
--   builders and laborers repair buildings (hammer at scaffolding, planks, walls),
--   porters carry crates from a storage pile to a shopkeeper,
--   townsfolk fetch water at a well or fountain, sit down to eat at a bench or table,
--   two neighbours walk to another corner of the street and chat.
-- Everything runs only near players, one errand per person at a time, with a cool-down afterwards,
-- by day (6:00 to 21:00); night belongs to the sleeping routines of lw_town / workday.
-- Uses the shared claim (lw_claim) so that the other living-world systems leave a busy person alone.
-- Loads at worldserver start from lua_scripts/ (map state).
-- =====================================================================
if IS_WORLD_STATE then return end
if not MAP_Timer or not MAP_Players then return end

local TICK_MS      = 9000
local SCAN         = 55
local SITE         = 45
local MAX_STARTS   = 2        -- new errands per player per tick
local START_CHANCE = 0.35
local COOLDOWN     = 150      -- seconds a person rests after an errand
local OWNER        = "life"

-- emotes
local E_TALK, E_WAVE, E_QUESTION, E_EAT, E_POINT, E_YES, E_NO, E_LAUGH, E_BOW = 1, 3, 6, 7, 25, 273, 274, 11, 2
local HAMMER_AURA = 179361                        -- the smith hammer in hand (same aura as the smiths of workday.lua)
local S_WORK, S_USE, S_FISH = 173, 69, 379          -- emote states: hammering, using something, fishing

local STATE = {}   -- guid -> errand
local REST  = {}   -- guid -> time the person may be given an errand again

-- ---------------------------------------------------------------- helpers
local function Hour()
    local ok, t = pcall(GetGameTime)
    if not ok or type(t) ~= "number" or t == 0 then t = os.time() end
    return math.floor(t / 3600) % 24
end
local function IsDay() local h = Hour(); return h >= 6 and h < 21 end
local function Lower(s) return string.lower(s or "") end
local function Name(o) local ok, n = pcall(function() return o:GetName() end); return ok and Lower(n) or "" end
local SUB = {}
local function Sub(c)
    local ok, e = pcall(function() return c:GetEntry() end)
    if not ok or not e then return "" end
    if SUB[e] == nil then
        local q = WorldDBQuery(string.format("SELECT IFNULL(subname,'') FROM creature_template WHERE entry = %d", e))
        SUB[e] = (q and Lower(q:GetString(0))) or ""
    end
    return SUB[e]
end
local function Has(s, words) for w in string.gmatch(words, "[^|]+") do if string.find(s, w, 1, true) then return true end end return false end
local function Flags(c)
    local ok, f = pcall(function() return c:GetNPCFlags() end)
    return ok and (tonumber(tostring(f)) or 0) or 0
end
local function HasFlag(flags, bit) return math.floor(flags / bit) % 2 == 1 end
local function Move(c, id, x, y, z)
    local ok, moved = pcall(function() return c:MoveToSafe(id, x, y, z) end)
    if not ok or not moved then pcall(function() c:MoveTo(id, x, y, z, true) end) end
end
local function Dist2(c, x, y) return (c:GetX() - x) ^ 2 + (c:GetY() - y) ^ 2 end
local function Say(c, line) if c and line and c:IsInWorld() and c:IsAlive() then pcall(function() c:SendUnitSay(line, 0) end) end end
local function Emote(c, e) if c and c:IsInWorld() then pcall(function() c:PerformEmote(e) end) end end
local function Later(c, ms, fn) pcall(function() c:RegisterEvent(function(_, _, _, cc) if cc and cc:IsInWorld() and cc:IsAlive() then fn(cc) end end, ms, 1) end) end

local BAGS = {}
local function Bag(key, list)
    if not list or #list == 0 then return nil end
    local b = BAGS[key]
    if not b or b.pos > #b.order or b.n ~= #list then
        local o = {}
        for i = 1, #list do o[i] = i end
        for i = #o, 2, -1 do local j = math.random(i); o[i], o[j] = o[j], o[i] end
        if b and b.last and #o > 1 and o[1] == b.last then o[1], o[#o] = o[#o], o[1] end
        b = {order = o, pos = 1, n = #list}
        BAGS[key] = b
    end
    local idx = b.order[b.pos]; b.pos = b.pos + 1; b.last = idx
    return list[idx]
end

-- claim shared with workday / lw_town / living_world4 (a claim older than 10 minutes without refresh counts as free)
local function Claimed(c)
    local ok, v = pcall(function() return c:Data():Get("lw_claim") end)
    if not ok or v == nil or v == OWNER then return false end
    if v == "workday" then
        local okt, t = pcall(function() return c:Data():Get("lw_claim_t") end)
        if okt and type(t) == "number" and os.time() - t > 600 then return false end
    end
    return true
end
local function Claim(c) pcall(function() c:Data():Set("lw_claim", OWNER); c:Data():Set("lw_claim_t", os.time()) end) end
local function Unclaim(c) pcall(function() if c:Data():Get("lw_claim") == OWNER then c:Data():Set("lw_claim", nil) end end) end

-- find the nearest game object whose name contains one of the words
local function Site(c, words, range)
    local ok, gos = pcall(function() return c:GetGameObjectsInRange(range or SITE) end)
    if not ok or not gos then return nil end
    local best, bd = nil, 1e9
    for _, go in ipairs(gos) do
        local n = Name(go)
        if n ~= "" and Has(n, words) and not string.find(n, "dnt", 1, true) then
            local d = Dist2(c, go:GetX(), go:GetY())
            if d > 9 and d < bd then best, bd = go, d end
        end
    end
    return best
end

-- the nearest creature that matches a test
local function Buyer(c, test, range)
    local ok, list = pcall(function() return c:GetCreaturesInRange(range or 45) end)
    if not ok or not list then return nil end
    local best, bd = nil, 1e9
    for _, o in ipairs(list) do
        if o ~= c and o:IsAlive() and not o:IsInCombat() and test(o) then
            local d = Dist2(c, o:GetX(), o:GetY())
            if d > 16 and d < bd then best, bd = o, d end
        end
    end
    return best
end

-- ---------------------------------------------------------------- who is who
local SKIP = "guard|footman|sentinel|grunt|watch|captain|commander|champion|knight|soldier|vendor|trainer|master|corpse|dead|prisoner|captive|slave|elder|king|lord|lady|warchief|emissary|ambassador|spy"
local function Role(c)
    local okT, t = pcall(function() return c:GetCreatureType() end)
    if not okT or t ~= 7 then return nil end
    if c:IsInCombat() or c:IsMoving() or not c:IsAlive() then return nil end
    local n, s = Name(c), Sub(c)
    if Has(n, SKIP) or Has(s, "guard") then return nil end
    local fl = Flags(c)
    if fl ~= 0 and fl ~= 1 and not HasFlag(fl, 128) then return nil end          -- plain townsfolk or a shopkeeper who may walk (vendor flag)
    if Has(n .. " " .. s, "fisher|angler|fish vendor|fish seller") then return "fisher" end
    if Has(n .. " " .. s, "builder|mason|carpenter|laborer|handyman|repair|worker|stonemason") then return "builder" end
    if Has(n .. " " .. s, "porter|courier|dockhand|stevedore|messenger|delivery|loader|hauler") then return "porter" end
    if HasFlag(fl, 128) then return nil end                                        -- shopkeepers stay at their stalls
    if Has(n, "resident|citizen|local|villager|commoner|peasant|townsperson|visitor|farmhand|noble|tradeworker|gardener|academic|student|novice") then return "citizen" end
    return nil
end

-- ---------------------------------------------------------------- errands
-- each errand: Start(c, role) returns a table {phase="go", tx, ty, tz, face=?, ...} or nil
local LINES = {
    fish   = { "Not a nibble yet.", "Patience, patience.", "The big ones bite at dusk.", "Got one!", "The water is calm today.", "My grandfather fished this very spot." },
    sell_s = { "Fresh catch, still flapping!", "Best fish this side of the market.", "Pulled from the water an hour ago.", "A full basket today, friend." },
    sell_b = { "Let me see... heavy enough.", "Hm. Fair enough. I'll take them.", "Fresh? It smells fresh. Good.", "I'll take the whole basket." },
    sell_s2 = { "A pleasure doing business.", "Come back tomorrow, there will be more.", "For you, the best price." },
    sell_b2 = { "Same time tomorrow.", "Pay the man.", "My customers will be happy." },
    repair = { "This roof will not fix itself.", "Hand me that plank!", "One more nail and it holds.", "Mind the ladder!", "Measure twice, cut once.", "The wind took half the shingles." },
    deliver = { "Delivery for you!", "Where do you want these?", "Heavy, this one." },
    deliver2 = { "About time. Over there.", "Put them by the door.", "Careful with that." },
    water  = { "Cold and clear.", "The bucket is heavier every day.", "Good water, this.", "I fetch the water, the day is better." },
    eat    = { "Mm. Just what I needed.", "Lunch at last.", "Not bad.", "This bread is still warm." },
    stroll = { "Let us walk a bit.", "Fresh air does us good.", "Come, the sun is out." },
    stroll2 = { "Lovely day for a walk.", "I could do with the rest.", "Did you hear what happened at the market?" },
}

local ERRANDS = {}

-- fisher: fish at the water, or sell the catch
ERRANDS.fish = function(c)
    local site = Site(c, "dock|pier|boat|net|fishing|jetty|wharf|water")
    if not site then return nil end
    return { tx = site:GetX() + math.cos(math.random() * 6.28) * 1.6, ty = site:GetY() + math.sin(math.random() * 6.28) * 1.6, tz = site:GetZ(),
             face = site, act = "fish", dur = math.random(50, 110) }
end
ERRANDS.sell_fish = function(c)
    local b = Buyer(c, function(o)
        local fl = Flags(o)
        local n = Name(o) .. " " .. Sub(o)
        return HasFlag(fl, 128) or HasFlag(fl, 65536) or Has(n, "cook|baker|chef|innkeeper|grocer|provisions|food|fish")
    end, 60)
    if not b then return nil end
    return { tx = b:GetX() + math.cos(b:GetO() or 0) * 1.8, ty = b:GetY() + math.sin(b:GetO() or 0) * 1.8, tz = b:GetZ(), face = b, partner = b, act = "sell", dur = 20 }
end
-- builder: repair at scaffolding, planks, walls
ERRANDS.repair = function(c)
    local site = Site(c, "scaffold|plank|beam|ladder|brick|pallet|wood|lumber|crate|wall|roof")
    if not site then return nil end
    return { tx = site:GetX() + math.cos(math.random() * 6.28) * 1.2, ty = site:GetY() + math.sin(math.random() * 6.28) * 1.2, tz = site:GetZ(),
             face = site, act = "repair", dur = math.random(45, 100) }
end
-- porter: carry from a pile to a shopkeeper
ERRANDS.deliver = function(c)
    local pile = Site(c, "crate|barrel|sack|pallet|cargo")
    local b = Buyer(c, function(o) return HasFlag(Flags(o), 128) end, 55)
    if not pile or not b then return nil end
    return { tx = pile:GetX() + 1.2, ty = pile:GetY() + 1.2, tz = pile:GetZ(), face = pile, act = "deliver1", partner = b, dur = 6 }
end
-- citizens
ERRANDS.water = function(c)
    local site = Site(c, "well|fountain|pump|trough|spring")
    if not site then return nil end
    return { tx = site:GetX() + math.cos(math.random() * 6.28) * 1.5, ty = site:GetY() + math.sin(math.random() * 6.28) * 1.5, tz = site:GetZ(), face = site, act = "water", dur = math.random(14, 26) }
end
ERRANDS.eat = function(c)
    local site = Site(c, "bench|chair|stool|table|seat")
    if not site then return nil end
    return { tx = site:GetX(), ty = site:GetY(), tz = site:GetZ(), face = nil, act = "eat", dur = math.random(35, 70), sit = true }
end
ERRANDS.rest = function(c)
    local site = Site(c, "bench|chair|stool|seat")
    if not site then return nil end
    return { tx = site:GetX(), ty = site:GetY(), tz = site:GetZ(), face = nil, act = "rest", dur = math.random(40, 110), sit = true }
end
ERRANDS.stroll = function(c)
    local ok, list = pcall(function() return c:GetCreaturesInRange(12) end)
    if not ok or not list then return nil end
    local mate
    for _, o in ipairs(list) do
        if o ~= c and o:IsAlive() and Role(o) == "citizen" and not STATE[tostring(o:GetGUIDLow())] and not Claimed(o) then mate = o break end
    end
    if not mate then return nil end
    local ang = math.random() * 6.28
    return { tx = c:GetX() + math.cos(ang) * 18, ty = c:GetY() + math.sin(ang) * 18, tz = c:GetZ(), face = nil, act = "stroll", partner = mate, dur = 10 }
end

local PLAN = {
    fisher  = { "fish", "fish", "sell_fish", "sell_fish" },
    builder = { "repair", "repair", "repair", "deliver" },
    porter  = { "deliver", "deliver", "repair" },
    citizen = { "water", "eat", "rest", "stroll", "rest", "eat" },
}

-- ---------------------------------------------------------------- acting
local function Finish(c, st)
    pcall(function() c:EmoteState(0); c:SetStandState(0); c:RemoveAura(HAMMER_AURA) end)
    st.phase = "back"; st.deadline = os.time() + 90
    pcall(function() c:SetWalk(true) end)
    Move(c, 3, st.hx, st.hy, st.hz)
end

local function Act(c, st)
    st.phase = "act"
    st.endt = os.time() + st.dur
    if st.face then pcall(function() c:SetFacingToObject(st.face) end) end
    local a = st.act
    if a == "fish" then
        pcall(function() c:EmoteState(S_FISH) end); Say(c, Bag("l:fish", LINES.fish))
    elseif a == "repair" then
        pcall(function() c:AddAura(HAMMER_AURA, c) end)   -- hammer in hand
        pcall(function() c:EmoteState(S_WORK) end); Say(c, Bag("l:repair", LINES.repair))
    elseif a == "water" then
        pcall(function() c:EmoteState(S_USE) end); Say(c, Bag("l:water", LINES.water))
    elseif a == "rest" then
        pcall(function() c:SetStandState(1) end)
    elseif a == "eat" then
        pcall(function() c:SetStandState(1) end); Emote(c, E_EAT); Say(c, Bag("l:eat", LINES.eat))
    elseif a == "sell" then
        local b = st.partner
        if b then
            pcall(function() b:SetFacingToObject(c) end)
            Emote(c, E_WAVE); Say(c, Bag("l:sells", LINES.sell_s))
            Later(b, 3500, function(bb) Say(bb, Bag("l:sellb", LINES.sell_b)); Emote(bb, E_QUESTION) end)
            Later(c, 7500, function(cc) Say(cc, Bag("l:sells2", LINES.sell_s2)); Emote(cc, E_POINT) end)
            Later(b, 11000, function(bb) Say(bb, Bag("l:sellb2", LINES.sell_b2)); Emote(bb, E_YES) end)
        end
    elseif a == "deliver1" then
        Say(c, Bag("l:deliver", LINES.deliver)); pcall(function() c:EmoteState(S_USE) end)
    elseif a == "deliver2" then
        local b = st.partner
        if b then pcall(function() b:SetFacingToObject(c) end); Say(c, Bag("l:deliver", LINES.deliver)); Later(b, 3500, function(bb) Say(bb, Bag("l:deliver2", LINES.deliver2)); Emote(bb, E_POINT) end) end
    elseif a == "stroll" then
        local m = st.partner
        Say(c, Bag("l:stroll", LINES.stroll))
        if m then pcall(function() m:SetFacingToObject(c) end); Later(m, 4000, function(mm) Say(mm, Bag("l:stroll2", LINES.stroll2)); Emote(mm, E_TALK) end) end
        Emote(c, E_TALK)
    end
end

local function Start(c, role)
    local plan = PLAN[role]
    if not plan then return false end
    local kind = plan[math.random(#plan)]
    local e = ERRANDS[kind] and ERRANDS[kind](c)
    if not e then return false end
    local hx, hy, hz, ho = c:GetHomePosition()
    if not hx then return false end
    e.phase = "go"; e.hx, e.hy, e.hz, e.ho = hx, hy, hz, ho or 0; e.deadline = os.time() + 75; e.role = role
    STATE[tostring(c:GetGUIDLow())] = e
    Claim(c)
    pcall(function() c:SetStandState(0); c:SetWalk(true) end)
    Move(c, 2, e.tx, e.ty, e.tz)
    -- the stroll partner walks along
    if e.act == "stroll" and e.partner then
        local m = e.partner
        STATE[tostring(m:GetGUIDLow())] = { phase = "follow", leader = c, deadline = os.time() + 80, hx = m:GetX(), hy = m:GetY(), hz = m:GetZ(), ho = m:GetO() or 0 }
        Claim(m); pcall(function() m:SetWalk(true) end)
        Move(m, 2, e.tx + 1.5, e.ty + 1.5, e.tz)
    end
    return true
end

local function Release(c)
    pcall(function() c:EmoteState(0); c:SetStandState(0); c:RemoveAura(HAMMER_AURA) end)
    Unclaim(c)
end

local function Tick()
    if not IsDay() then return end
    local now = os.time()
    local seen = {}
    for _, p in ipairs(LW_Players() or {}) do
        local ok, list = pcall(function() return p:GetCreaturesInRange(SCAN) end)
        if ok and list then
            local started = 0
            for _, c in ipairs(list) do
                local guid = tostring(c:GetGUIDLow())
                local st = STATE[guid]
                if not c:IsAlive() or c:IsInCombat() then
                    if st then Release(c); STATE[guid] = nil end
                elseif st then
                    seen[guid] = true
                    pcall(function() c:Data():Set("lw_claim_t", now) end)
                    if st.phase == "go" then
                        if Dist2(c, st.tx, st.ty) < 12 or now > st.deadline then Act(c, st) end
                    elseif st.phase == "follow" then
                        if now > st.deadline or not st.leader or not st.leader:IsAlive() then
                            Release(c); STATE[guid] = nil
                        elseif Dist2(c, st.leader:GetX() + 1.5, st.leader:GetY() + 1.5) > 25 and not c:IsMoving() then
                            Move(c, 2, st.leader:GetX() + 1.5, st.leader:GetY() + 1.5, st.leader:GetZ())
                        end
                    elseif st.phase == "act" then
                        if now >= st.endt then
                            if st.act == "deliver1" and st.partner and st.partner:IsAlive() then
                                -- walk on to the shopkeeper with the goods
                                st.act = "deliver2"; st.phase = "go"; st.deadline = now + 60
                                st.tx, st.ty, st.tz = st.partner:GetX() + 1.6, st.partner:GetY() + 1.6, st.partner:GetZ(); st.face = nil; st.dur = 8
                                pcall(function() c:EmoteState(0) end); Move(c, 2, st.tx, st.ty, st.tz)
                            else
                                Finish(c, st)
                            end
                        end
                    elseif st.phase == "back" then
                        if Dist2(c, st.hx, st.hy) < 9 or now > st.deadline then
                            pcall(function() c:SetFacing(st.ho) end)
                            Release(c); STATE[guid] = nil
                            REST[guid] = now + COOLDOWN
                        end
                    end
                elseif started < MAX_STARTS and math.random() < START_CHANCE and (REST[guid] or 0) <= now and not Claimed(c) then
                    local role = Role(c)
                    if role and not (HAS_CPP_SCRIPT and HAS_CPP_SCRIPT[c:GetEntry()]) and Start(c, role) then
                        started = started + 1
                        seen[guid] = true
                    end
                end
            end
        end
    end
    for guid in pairs(STATE) do if not seen[guid] then STATE[guid] = nil end end
end

MAP_Timer("lw_life.tick", Tick, TICK_MS)
print("[lw_life] errands and chores: fishing and selling fish, repairs, deliveries, water, meals, strolls")
