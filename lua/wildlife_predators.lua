-- =====================================================================
-- Wildlife food chain: predators (wolves, big cats, bears, raptors, crocolisks, hyenas) hunt the small and grazing animals around them.
-- Near a player a predator picks prey, runs it down, the prey dies, the predator eats for a while and returns to its place. Prey is
-- critters and grazers (boars, deer, rabbits, sheep, squirrels...) that are weaker than the predator. Each predator hunts at most every
-- 5 minutes. Only creatures near a player are touched.
-- =====================================================================
if IS_WORLD_STATE then return end

local TICK_MS = 9000
local SCAN = 55
local COOLDOWN = 300

local CT_BEAST, CT_CRITTER = 1, 8
local PRED_FAMILY = {[1] = true, [2] = true, [4] = true, [6] = true, [11] = true, [25] = true, [27] = true}   -- wolf, cat, bear, crocolisk, raptor, hyena, ...
local PRED_WORDS = "wolf|worg|lion|tiger|panther|prowler|cat|bear|raptor|croc|hyena|lynx|stalker|saber|jaguar|snarler"
local PREY_WORDS = "boar|deer|elk|rabbit|hare|sheep|squirrel|chicken|goat|zebra|gazelle|hawk|toad|frog|rat|gull|crab|kodo|moth|bunny|fawn|stag"
local HUNT = {}    -- predator guid -> {phase, prey guid, until}
local LAST = {}    -- predator guid -> time of its last hunt

local function Name(c) local ok, n = pcall(function() return c:GetName() end); return string.lower((ok and n) or "") end
local function Has(name, words) for w in string.gmatch(words, "[^|]+") do if string.find(name, w, 1, true) then return true end end return false end

local function IsPredator(c, ctype, fam, n)
    if ctype ~= CT_BEAST then return false end
    if Has(n, PREY_WORDS) then return false end
    return PRED_FAMILY[fam] or Has(n, PRED_WORDS)
end
local function IsPrey(c, ctype, n)
    if ctype == CT_CRITTER then return not Has(n, "snake|scorpion|spider") end
    return ctype == CT_BEAST and Has(n, PREY_WORDS)
end

local function Dist(a, b) return math.sqrt((a:GetX() - b:GetX()) ^ 2 + (a:GetY() - b:GetY()) ^ 2) end

local function Tick()
    local now = os.time()
    for _, p in ipairs(MAP_Players() or {}) do
        local ok, list = pcall(function() return p:GetCreaturesInRange(SCAN) end)
        if ok and list then
            local preds, prey = {}, {}
            for _, c in ipairs(list) do
                if c:IsAlive() and not c:IsInCombat() then
                    local okT, ctype = pcall(function() return c:GetCreatureType() end)
                    if okT then
                        local fam = 0
                        pcall(function() fam = c:GetFamily() or 0 end)
                        local n = Name(c)
                        if IsPredator(c, ctype, fam, n) then preds[#preds + 1] = c
                        elseif IsPrey(c, ctype, n) then prey[#prey + 1] = c end
                    end
                end
            end
            -- run the hunts already in progress
            for _, c in ipairs(preds) do
                local guid = tostring(c:GetGUIDLow())
                local h = HUNT[guid]
                if h then
                    local target
                    for _, q in ipairs(prey) do if tostring(q:GetGUIDLow()) == h.prey then target = q break end end
                    if h.phase == "chase" then
                        if not target or now > h.deadline then
                            HUNT[guid] = nil
                        elseif Dist(c, target) < 5 then
                            pcall(function() c:SetFacing(math.atan2(target:GetY() - c:GetY(), target:GetX() - c:GetX())) end)
                            pcall(function() c:PerformEmote(36) end)                        -- attack swing
                            pcall(function() c:DealDamage(target, target:GetMaxHealth() + 1) end)
                            h.phase = "eat"; h.deadline = now + 18
                            pcall(function() c:EmoteState(7) end)                           -- eating
                        else
                            pcall(function() c:SetWalk(false); c:MoveChase(target) end)
                        end
                    elseif h.phase == "eat" then
                        if now >= h.deadline then
                            pcall(function() c:EmoteState(0) end)
                            pcall(function() local hx, hy, hz = c:GetHomePosition(); if hx then c:SetWalk(true); c:MoveTo(1, hx, hy, hz, true) end end)
                            HUNT[guid] = nil
                        end
                    end
                end
            end
            -- a new hunt (one per scan, a chance only)
            if #preds > 0 and #prey > 0 and math.random(100) <= 22 then
                local c = preds[math.random(#preds)]
                local guid = tostring(c:GetGUIDLow())
                if not HUNT[guid] and now - (LAST[guid] or 0) > COOLDOWN then
                    local best, bd = nil, 1e9
                    for _, q in ipairs(prey) do
                        local d = Dist(c, q)
                        if d < bd and d < 40 and q:GetLevel() <= c:GetLevel() + 1 then best, bd = q, d end
                    end
                    if best then
                        HUNT[guid] = {phase = "chase", prey = tostring(best:GetGUIDLow()), deadline = now + 25}
                        LAST[guid] = now
                        pcall(function() c:SetWalk(false); c:MoveChase(best) end)
                        pcall(function() best:MoveFleeing(c, 6000) end)                    -- the prey runs for its life
                    end
                end
            end
        end
    end
end

MAP_Timer("wildlife.predators", Tick, TICK_MS)
print("[wildlife] predators hunt prey")
