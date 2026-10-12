-- =====================================================================
-- Workday: villagers with a trade go and do it, then come home. Laborers and woodcutters chop at a tree near the village,
-- miners go to a vein or rock, builders to scaffolding, planks and crates, cooks to a stove or cooking fire, farmers to crops, smiths to
-- the forge or anvil. They work the whole day (from 6:00 to 19:00 game time: work emote, an occasional line), walk home at dusk and
-- sleep there until dawn. Only creatures near a player are touched.
-- =====================================================================
if IS_WORLD_STATE then return end

local TICK_MS = 12000
local SCAN = 70                              -- creatures within this range of a player may get a job
local SITE = 70                              -- job sites within this range of the worker

-- job kinds by name keywords: {pattern for the worker's name, pattern for the site object's name, work emote, lines}
local JOBS = {
    {"Woodcutter|Lumberjack|Laborer|Logger|Peon|Axe", "tree|stump|log|trunk|lumber|wood", 234, {"Timber!", "One more and the pile is done.", "Good oak, this one."}, 52415},
    {"Miner|Prospector|Digger|Excavator", "ore|vein|rock|mineral|deposit|boulder|mine", 233, {"Ore, at last!", "My arms ache, but the cart is heavy.", "*clink clink*"}, 52415},
    {"Builder|Mason|Carpenter|Repair|Worker|Handyman", "scaffold|plank|crate|barrel|beam|ladder|brick|stone|wall|pallet", 173, {"Hand me that plank!", "This roof will not fix itself.", "Mind the scaffolding!"}, 52415, nil, 1281882},
    {"Cook|Baker|Chef|Brewer|Innkeeper's", "stove|oven|cauldron|pot|campfire|fire|grill|kettle|barbecue|spit", 69, {"Soup is almost ready!", "Needs more salt.", "Hot! Hot!"}, 102402, 36151},
    {"Farmer|Gardener|Herbalist|Harvester", "crop|field|corn|wheat|plant|pumpkin|cabbage|garden|bush|hay", 173, {"A good harvest this year.", "Weeds again!", "The soil is rich here."}},
    {"Smith|Blacksmith|Armorer|Weaponsmith|Forgemaster", "forge|anvil|furnace|bellows|grindstone", 173, {"Strike while it is hot!", "Needs a bit more tempering.", "*clang clang*"}, nil, 179361},
    {"Fisherman|Fisher|Angler", "dock|pier|boat|net|fishing|barrel", 173, {"Biting today!", "Nothing yet. Patience.", "A big one!"}},
}
local SKIP = 'Guard|Footman|Sentinel|Grunt|Vendor|Trainer|Innkeeper$|Corpse|Dead|Captive|Prisoner|Slave|Elder|Master$'

local STATE = {}   -- creature guid string -> {phase = go | work | back | sleep, ...}

local function GameHour()
    local ok, t = pcall(GetGameTime)
    if not ok or type(t) ~= "number" then t = os.time() end
    return math.floor(t / 3600) % 24
end
local function IsDay() local h = GameHour(); return h >= 6 and h < 19 end

local function Name(o) local ok, n = pcall(function() return o:GetName() end); return ok and (n or "") or "" end
local function Lower(s) return string.lower(s or "") end
local function Matches(name, pat)
    local ln = Lower(name)
    for word in string.gmatch(Lower(pat), "[^|]+") do
        if string.find(ln, word, 1, true) then return true end
    end
    return false
end

local function Say(c, lines) if c and c:IsInWorld() then pcall(function() c:SendUnitSay(lines[math.random(#lines)], 0) end) end end

-- Obsadenost napriec living-world systemami: kto si NPC vezme, oznaci ho.
-- Ostatne systemy (ambient, town, living_world4, patrol...) obsadene preskakuju.
local CLAIM_TTL = 600   -- narok bez dozoru po 10 min exspiruje (NPC odisiel z dohladu)
local function ClaimedByOther(c)
    local ok, v = pcall(function() return c:Data():Get("lw_claim") end)
    if not ok or v == nil or v == "workday" then return false end
    return true
end
local function Claim(c)
    pcall(function() c:Data():Set("lw_claim", "workday"); c:Data():Set("lw_claim_t", os.time()) end)
end
local function Unclaim(c) pcall(function() c:Data():Set("lw_claim", nil) end) end
local function ClaimAlive(c)
    -- obnovenie casovej znacky vlastneho naroku (volat pri kazdom Tick manazmente)
    pcall(function()
        if c:Data():Get("lw_claim") == "workday" then c:Data():Set("lw_claim_t", os.time()) end
    end)
end
local function SafeMoveTo(c, id, x, y, z)
    local ok, moved = pcall(function() return c:MoveToSafe(id, x, y, z) end)
    if not ok or not moved then pcall(function() c:MoveTo(id, x, y, z, true) end) end
end
local function Release(c, st)
    if st.workaura then pcall(function() c:RemoveAura(st.workaura) end) end
    if st.carry then pcall(function() c:RemoveAura(st.carry) end) end
    pcall(function() c:EmoteState(0) end)
    Unclaim(c)
end

local function GoHome(c, st)
    pcall(function() c:EmoteState(0) end)
    if st.workaura then pcall(function() c:RemoveAura(st.workaura) end) end
    if st.carry then pcall(function() c:AddAura(st.carry, c) end) end
    st.phase = "back"
    st.deadline = os.time() + 120
    pcall(function() c:SetWalk(true) end)
    SafeMoveTo(c, 2, st.hx, st.hy, st.hz)
end

local function Sleep(c, st)
    st.phase = "sleep"
    if st.carry then pcall(function() c:RemoveAura(st.carry) end) end
    pcall(function() c:SetFacing(st.ho or 0); c:SetStandState(3) end)   -- UNIT_STAND_STATE_SLEEP
end

local function FindJob(c)
    local name = Name(c)
    if name == "" or Matches(name, SKIP) then return nil end
    -- Lazy Peon (10556) ma vlastny quest system v peons.lua (spi / vstane na blackjack).
    -- Workday by ho nutlil rubat v lahu. Vylucit.
    local okE, entry = pcall(function() return c:GetEntry() end)
    if okE and entry == 10556 then return nil end
    if ClaimedByOther(c) then return nil end
    local lname = string.lower(name or "")
    for _, w in ipairs({"guard", "sentinel", "footman", "watchman", "soldier", "defender", "protector", "warden", "patrol", "knight", "captain", "commander", "champion", "legionnaire", "peacekeeper", "sentry", "marshal", "ranger"}) do
        if string.find(lname, w, 1, true) then return nil end   -- guards stand and patrol, they never work
    end
    for _, job in ipairs(JOBS) do
        if Matches(name, job[1]) then
            local okS, gos = pcall(function() return c:GetGameObjectsInRange(SITE) end)
            local site, best = nil, 1e9
            if okS and gos then
                for _, go in ipairs(gos) do
                    if Matches(Name(go), job[2]) then
                        local d = (go:GetX() - c:GetX()) ^ 2 + (go:GetY() - c:GetY()) ^ 2
                        if d > 25 and d < best then best, site = d, go end
                    end
                end
            end
            return job, site
        end
    end
end

local function Tick()
    local day = IsDay()
    local now = os.time()
    local seen = {}
    for _, p in ipairs(MAP_Players() or {}) do
        local ok, list = pcall(function() return p:GetCreaturesInRange(SCAN) end)
        if ok and list then
            local started = 0
            for _, c in ipairs(list) do
                local guid = tostring(c:GetGUIDLow())
                local st = STATE[guid]
                if not c:IsAlive() then
                    Release(c, st or {})
                    STATE[guid] = nil
                elseif c:IsInCombat() then
                    -- v boji nerob nic, narok drzime (po boji pokracuje)
                elseif st then
                    seen[guid] = true
                    ClaimAlive(c)
                    if st.phase == "go" then
                        local d = math.sqrt((c:GetX() - st.sx) ^ 2 + (c:GetY() - st.sy) ^ 2)
                        if d < 3.5 or now > st.deadline then
                            st.phase = "work"
                            if st.carry then pcall(function() c:RemoveAura(st.carry) end) end
                            if st.workaura then pcall(function() c:AddAura(st.workaura, c) end) end
                            pcall(function() c:SetFacing(math.atan2(st.sy - c:GetY(), st.sx - c:GetX())) end)
                            pcall(function() c:EmoteState(st.emote) end)
                            Say(c, st.lines)
                            if st.workcast then pcall(function() c:CastSpell(c, st.workcast, true) end) end
                        end
                        if not day then GoHome(c, st) end
                    elseif st.phase == "work" then
                        if not day then
                            Say(c, {"That is the day done.", "Time to rest.", "My bed is calling."})
                            GoHome(c, st)
                        elseif math.random(14) == 1 then
                            Say(c, st.lines)
                            if st.workcast then pcall(function() c:CastSpell(c, st.workcast, true) end) end
                        end
                    elseif st.phase == "back" then
                        local d = math.sqrt((c:GetX() - st.hx) ^ 2 + (c:GetY() - st.hy) ^ 2)
                        if d < 2.5 or now > st.deadline then
                            if day then
                                pcall(function() c:SetFacing(st.ho or 0) end)
                                Unclaim(c)
                                STATE[guid] = nil
                            else Sleep(c, st) end
                        end
                    elseif st.phase == "sleep" then
                        if day then
                            pcall(function() c:SetStandState(0) end)
                            Unclaim(c)
                            STATE[guid] = nil     -- next tick they walk to work
                        end
                    end
                elseif c:IsAlive() and not c:IsMoving() then
                    local job, site = FindJob(c)
                    if job then
                        seen[guid] = true
                        local hx, hy, hz, ho = c:GetHomePosition()
                        if hx and day and site and started < 6 then
                            local sx, sy = site:GetX(), site:GetY()
                            local ang = math.atan2(c:GetY() - sy, c:GetX() - sx)
                            local tx, ty = sx + math.cos(ang) * 1.2, sy + math.sin(ang) * 1.2
                            STATE[guid] = {phase = "go", sx = sx, sy = sy, hx = hx, hy = hy, hz = hz, ho = ho or 0, emote = job[3], lines = job[4], carry = job[5], workaura = job[6], workcast = job[7], deadline = now + 60}
                            Claim(c)
                            if job[5] then pcall(function() c:AddAura(job[5], c) end) end
                            pcall(function() c:SetStandState(0); c:SetWalk(true) end)
                            SafeMoveTo(c, 1, tx, ty, site:GetZ())
                            started = started + 1
                        elseif hx and not day then
                            -- a worker seen at night near his home: asleep
                            if (c:GetX() - hx) ^ 2 + (c:GetY() - hy) ^ 2 < 25 then
                                STATE[guid] = {phase = "sleep", hx = hx, hy = hy, hz = hz, ho = ho or 0}
                                Claim(c)
                                Sleep(c, STATE[guid])
                            end
                        end
                    end
                end
            end
        end
    end
    for guid in pairs(STATE) do
        if not seen[guid] then STATE[guid] = nil end   -- narok exspiruje sam (lw_claim_t + 600s)
    end
end

MAP_Timer("workday.tick", Tick, TICK_MS)
print("[workday] villagers work at job sites near villages")
