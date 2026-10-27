-- The Waning Crescent: 40745 Shift Change, 42722 Friends in Cages, 42486 Little One Lost.
--
-- 40745: the basket spawns Guard Morgaine, who walks from the bazaar to the cage.
--        The player must stay close; at the cage the guard turns hostile. The Spell
--        Barrier consumes Control Orb 138147 and credits the cage objective.
-- 42722: each arcane containment field needs one Control Orb 138301 and must contain
--        a live accused citizen. Only then is the prisoner-freed proxy credited.
-- 42486: Korine (108075) follows the player, two Duskwatch ambushes trigger on the
--        bridge route, and the escort objective is credited only at Verene.
--
-- All quest progress is real objective credit; no quest is completed directly.

if IS_WORLD_STATE then return end

local Q40745, Q42486, Q42722 = 40745, 42486, 42722
local INCOMPLETE = 3
local BASKET = 9000001
local BARRIER = 250991
local CONTAINMENT = 251190
local CONTROL_ORB = 138147
local PRISON_ORB = 138301
local GUARD_WALK = 108616
local GUARD_TEXT = 107318
local KORINE_ESCORT = 108075
local KORINE_CAGE = 108063
local VERENE = 107712
local PRISONER_A, PRISONER_B = 108068, 108070
local PRISONER_PROXY = 108520
local BATTLEMASTER, SCION = 106032, 108096

-- Basket is at the quest POI north of the bazaar; these points follow the open street
-- to the cage at the Terrace of Order.
local BASKET_POS = { 528.0, 4086.0, 6.48, 4.71239 }
local GUARD_PATH = {
    { 549.0, 4105.0, 5.0 },
    { 590.0, 4090.0, 5.0 },
    { 635.0, 4105.0, 5.0 },
    { 680.0, 4130.0, 5.0 },
    { 720.0, 4160.0, 5.0 },
    { 743.0, 4202.9, 3.58 },
}
local CAGE_POS = { 743.0, 4202.9, 3.58, 3.14159 }

-- Escort route: cage bridge, lower bridge, then the Waning Crescent.
local AMBUSH_ONE = { 697.0, 4162.0 }
local AMBUSH_TWO = { 495.0, 4101.0 }
local VERENE_POS = { 363.5, 3975.2 }

local Waning = {}
local Escort = {}

local function K(p)
    return tostring(p:GetGUIDLow())
end

local function qstatus(p, q)
    local ok, st = pcall(function() return p:GetQuestStatus(q) end)
    return (ok and st) or -1
end

local function alive(c)
    if not c then return false end
    local ok, v = pcall(function() return c:IsInWorld() and c:IsAlive() end)
    return ok and v
end

local function after(p, ms, fn)
    pcall(function() p:RegisterEvent(function() fn() end, ms, 1) end)
end

local function say(c, text, kit)
    if not alive(c) then return end
    pcall(function() c:SendUnitSay(text, 0) end)
    if kit and kit > 0 then pcall(function() c:PlayDistanceSound(kit) end) end
end

local function despawn(c)
    if not c then return end
    pcall(function() if c:IsInWorld() then c:DespawnOrUnsummon(0) end end)
end

local function despawn_all(list)
    for _, c in ipairs(list or {}) do despawn(c) end
end

local function nearest(p, entry, range)
    local ok, list = pcall(function() return p:GetCreaturesInRange(range, entry, 0, 1) end)
    if ok and list and #list > 0 then return list[1] end
end

local function dist2d(p, x, y)
    local dx, dy = p:GetX() - x, p:GetY() - y
    return math.sqrt(dx * dx + dy * dy)
end

local function W(p)
    local k = K(p)
    Waning[k] = Waning[k] or {}
    return Waning[k]
end

local function cleanup_40745(p)
    local k = K(p)
    local s = Waning[k]
    if not s then return end
    despawn(s.guard)
    Waning[k] = nil
end

local function temp_guard(p, x, y, z, o)
    local g = p:SpawnCreature(GUARD_WALK, x, y, z, o, 8, 0)
    if not g then return nil end
    pcall(function()
        g:SetNPCFlags(0)
        g:SetFaction(35)
        g:SetReactState(0)
        g:SetWalk(true)
        g:SetLevel(math.max(1, p:GetLevel() + 1))
        g:SetMaxHealth(6000)
        g:SetHealth(6000)
    end)
    return g
end

local function guard_wait_for_player(p, g, fn)
    if not alive(g) then return end
    local ok, d = pcall(function() return p:GetDistance(g) end)
    if ok and d and d <= 50 then
        W(p).warned = false
        fn()
        return
    end
    pcall(function() g:MoveIdle() end)
    local s = W(p)
    if not s.warned then
        s.warned = true
        say(g, "Stop following me!", 66316)
    end
    after(p, 2000, function() guard_wait_for_player(p, g, fn) end)
end

local guard_arrive

local function guard_step(p, g, idx)
    if not alive(g) then return end
    if qstatus(p, Q40745) ~= INCOMPLETE then despawn(g); return end
    if idx > #GUARD_PATH then guard_arrive(p, g); return end
    guard_wait_for_player(p, g, function()
        if not alive(g) then return end
        local pt = GUARD_PATH[idx]
        local ok = false
        pcall(function()
            g:SetWalk(true)
            ok = g:MoveToSafe(idx, pt[1], pt[2], pt[3])
        end)
        if not ok then
            pcall(function() g:MoveTo(idx, pt[1], pt[2], pt[3]) end)
        end
        local ticks = 0
        local function check()
            if not alive(g) then return end
            if qstatus(p, Q40745) ~= INCOMPLETE then despawn(g); return end
            local d = g:GetDistance(pt[1], pt[2], pt[3])
            if d and d < 4.0 then
                guard_step(p, g, idx + 1)
            elseif ticks < 45 then
                ticks = ticks + 1
                after(p, 1000, check)
            else
                guard_step(p, g, idx + 1)
            end
        end
        after(p, 1000, check)
    end)
end

guard_arrive = function(p, g)
    if not alive(g) then return end
    if qstatus(p, Q40745) ~= INCOMPLETE then despawn(g); return end
    local ok, d = pcall(function() return p:GetDistance(g) end)
    if ok and d and d > 50 then
        pcall(function() g:MoveIdle() end)
        after(p, 2000, function() guard_arrive(p, g) end)
        return
    end
    local s = W(p)
    s.follow = true
    s.guard = g
    s.basket = false
    pcall(function() p:KilledMonsterCredit(107318, 0) end)
    say(g, "Keep it down, brats. You will join the others soon.", 66315)
    after(p, 800, function()
        if alive(g) then
            pcall(function()
                g:SetFaction(2823)
                g:SetReactState(1)
                g:SetWalk(false)
            end)
        end
    end)
end

local function start_guard_walk(p)
    local g = temp_guard(p, BASKET_POS[1], BASKET_POS[2], BASKET_POS[3], BASKET_POS[4])
    if not g then
        p:SendBroadcastMessage("The guard does not appear. Try the basket again.")
        return
    end
    W(p).guard = g
    W(p).warned = false
    after(p, 1000, function() guard_step(p, g, 1) end)
end

local function spawn_hostile_guard(p)
    local g = temp_guard(p, CAGE_POS[1], CAGE_POS[2], CAGE_POS[3], CAGE_POS[4])
    if not g then return end
    W(p).guard = g
    pcall(function()
        g:SetFaction(2823)
        g:SetReactState(1)
        g:SetWalk(false)
    end)
end

RegisterGameObjectEvent(BASKET, 14, function(_, _, p)
    if not p then return true end
    if qstatus(p, Q40745) ~= INCOMPLETE then return false end
    local s = W(p)
    if alive(s.guard) then return true end
    if s.follow then
        spawn_hostile_guard(p)
        return true
    end
    start_guard_walk(p)
    if alive(W(p).guard) then
        pcall(function() p:KilledMonsterCredit(107474, 0) end)
    end
    return true
end)

RegisterGameObjectEvent(BARRIER, 14, function(_, go, p)
    if not p then return true end
    if qstatus(p, Q40745) ~= INCOMPLETE then return false end
    if not p:HasItem(CONTROL_ORB, 1) then
        p:SendBroadcastMessage("The spell barrier is sealed. A Control Orb is required.")
        return true
    end
    pcall(function() p:RemoveItem(CONTROL_ORB, 1) end)
    pcall(function() p:KillGOCredit(BARRIER) end)
    pcall(function() go:RemoveFromWorld(false) end)
    return true
end)

RegisterCreatureEvent(GUARD_WALK, 1, function(_, c, target)
    if not c or not target then return end
    local ok, isPlayer = pcall(function() return target:IsPlayer() end)
    if not (ok and isPlayer) then return end
    if qstatus(target, Q40745) ~= INCOMPLETE then return end
    local s = W(target)
    if s.aggro then return end
    s.aggro = true
    say(c, "Where did you come from? Intruder!", 71950)
end)

-- 42722 -------------------------------------------------------------------
RegisterGameObjectEvent(CONTAINMENT, 14, function(_, go, p)
    if not p then return true end
    if qstatus(p, Q42722) ~= INCOMPLETE then return false end
    local prisoner = nearest(p, PRISONER_A, 8) or nearest(p, PRISONER_B, 8)
    local inside = false
    if prisoner then
        local ok, d = pcall(function() return prisoner:GetDistance(go) end)
        inside = ok and d and d < 4.5
    end
    if not inside then
        p:SendBroadcastMessage("The containment field is empty.")
        return true
    end
    if not p:HasItem(PRISON_ORB, 1) then
        p:SendBroadcastMessage("The containment field is sealed. A Control Orb is required.")
        return true
    end
    pcall(function() p:RemoveItem(PRISON_ORB, 1) end)
    pcall(function() p:KilledMonsterCredit(PRISONER_PROXY, 0) end)
    pcall(function() go:RemoveFromWorld(false) end)
    pcall(function() prisoner:DespawnOrUnsummon(5000) end)
    return true
end)

-- 42486 -------------------------------------------------------------------
local start_escort
local escort_poll
local escort_cleanup

local function clear_escort(p)
    local k = K(p)
    local s = Escort[k]
    if not s then return end
    despawn_all(s.mobs)
    despawn(s.korine)
    Escort[k] = nil
end

escort_cleanup = function(p)
    clear_escort(p)
end

local function escort_scene(p)
    local v = nearest(p, VERENE, 30)
    local k = nearest(p, KORINE_CAGE, 30)
    if k then say(k, "Mommy!", 66227) end
    if not v then return end
    after(p, 1200, function() say(nearest(p, VERENE, 30), "Oh my sweet little girl! Are you hurt? Were they mean to you?", 66378) end)
    after(p, 4000, function() say(nearest(p, KORINE_CAGE, 30), "They yelled and put me in a cage! I missed you...", 66251) end)
    after(p, 7000, function() say(nearest(p, VERENE, 30), "You're home now. Thank goodness.", 66379) end)
    after(p, 10000, function() say(nearest(p, VERENE, 30), "Thank -you-. I cannot begin to express my gratitude.", 66376) end)
end

local function finish_escort(p, s)
    if s.stage == 5 then return end
    s.stage = 5
    local k = s.korine
    s.korine = nil
    pcall(function() p:KilledMonsterCredit(KORINE_CAGE, 0) end)
    if alive(k) then
        pcall(function() k:MoveIdle() end)
        after(p, 800, function() despawn(k) end)
    end
    after(p, 1600, function() escort_scene(p) end)
    after(p, 3000, function()
        clear_escort(p)
    end)
end

local function check_ambush(p, s, which)
    if s.stage == 5 then return end
    local any = false
    for _, c in ipairs(s.mobs or {}) do
        if alive(c) then any = true end
    end
    if any then
        after(p, 2000, function() check_ambush(p, s, which) end)
        return
    end
    s.mobs = {}
    s.stage = (which == 1) and 2 or 4
    if alive(s.korine) then
        pcall(function()
            s.korine:MoveIdle()
            s.korine:MoveFollow(p, 2.0, 0)
        end)
    end
    after(p, 800, function() escort_poll(p) end)
end

local function start_ambush(p, s, which)
    if alive(s.korine) then
        pcall(function()
            s.korine:MoveStop()
            s.korine:MoveIdle()
        end)
    end
    local x, y, z = p:GetX(), p:GetY(), p:GetZ()
    local mobs = {}
    for i = 1, 2 do
        local a = (i == 1) and 0.6 or 3.6
        local dx, dy = math.cos(a) * 3.0, math.sin(a) * 3.0
        local m = p:SpawnCreature(BATTLEMASTER, x + dx, y + dy, z, 0, 8, 0)
        if m then
            pcall(function()
                m:SetLevel(math.max(1, p:GetLevel() + 1))
                m:SetMaxHealth(2400)
                m:SetHealth(2400)
                m:SetReactState(1)
                m:Attack(p)
            end)
            table.insert(mobs, m)
        end
        local sx, sy = math.cos(a + 1.5) * 3.0, math.sin(a + 1.5) * 3.0
        local sc = p:SpawnCreature(SCION, x + sx, y + sy, z, 0, 8, 0)
        if sc then
            pcall(function()
                sc:SetLevel(math.max(1, p:GetLevel() + 1))
                sc:SetMaxHealth(1800)
                sc:SetHealth(1800)
                sc:SetReactState(1)
                sc:Attack(p)
            end)
            table.insert(mobs, sc)
        end
    end
    s.mobs = mobs
    if which == 1 then
        local sc = mobs[2]
        if alive(sc) then say(sc, "After her!", 66319) end
        if alive(s.korine) then after(p, 600, function() say(s.korine, "AH! NO!", 66240) end) end
    else
        local sc = mobs[2]
        if alive(sc) then say(sc, "Seize the child!", 0) end
        if alive(s.korine) then after(p, 600, function() say(s.korine, "Waaaah!", 66241) end) end
    end
    after(p, 2500, function() check_ambush(p, s, which) end)
end

escort_poll = function(p)
    local k = K(p)
    local s = Escort[k]
    if not s then return end
    if qstatus(p, Q42486) ~= INCOMPLETE then
        escort_cleanup(p)
        return
    end
    if not alive(s.korine) then
        escort_cleanup(p)
        return
    end
    if s.stage == 0 and dist2d(p, AMBUSH_ONE[1], AMBUSH_ONE[2]) < 18 then
        s.stage = 1
        start_ambush(p, s, 1)
        return
    elseif s.stage == 2 and dist2d(p, AMBUSH_TWO[1], AMBUSH_TWO[2]) < 18 then
        s.stage = 3
        start_ambush(p, s, 2)
        return
    elseif s.stage == 4 and dist2d(p, VERENE_POS[1], VERENE_POS[2]) < 20 then
        finish_escort(p, s)
        return
    end
    after(p, 1500, function() escort_poll(p) end)
end

start_escort = function(p, x, y, z, o)
    if qstatus(p, Q42486) ~= INCOMPLETE then return end
    local k = K(p)
    if Escort[k] and alive(Escort[k].korine) then return end
    clear_escort(p)
    local korine = p:SpawnCreature(KORINE_ESCORT, x, y, z, o or 0, 8, 0)
    if not korine then
        p:SendBroadcastMessage("Korine cannot follow you right now. Try again.")
        return
    end
    local s = { korine = korine, stage = 0, mobs = {} }
    Escort[k] = s
    pcall(function()
        korine:SetNPCFlags(0)
        korine:SetFaction(35)
        korine:SetReactState(0)
        korine:SetWalk(false)
        korine:SetLevel(math.max(1, p:GetLevel()))
        korine:SetMaxHealth(100000)
        korine:SetHealth(100000)
        korine:MoveFollow(p, 2.0, 0)
    end)
    after(p, 900, function() say(korine, "I want my mommy...", 66239) end)
    after(p, 2500, function() escort_poll(p) end)
end

RegisterCreatureEvent(KORINE_CAGE, 31, function(_, p, c, quest)
    if quest ~= Q42486 or not p or not c then return end
    local x, y, z, o = c:GetLocation()
    start_escort(p, x, y, z, o)
end)

RegisterPlayerEvent(3, function(_, p)
    after(p, 3000, function()
        if qstatus(p, Q42486) == INCOMPLETE and not Escort[K(p)] then
            local x, y, z, o = p:GetLocation()
            start_escort(p, x, y, z, o)
        end
    end)
end)

RegisterPlayerEvent(4, function(_, p)
    cleanup_40745(p)
    escort_cleanup(p)
end)

RegisterPlayerEvent(38, function(_, p, q)
    if q == Q40745 then cleanup_40745(p) end
    if q == Q42486 then escort_cleanup(p) end
end)

RegisterPlayerEvent(54, function(_, p, q, status)
    if q == Q40745 and status ~= INCOMPLETE then cleanup_40745(p) end
    if q == Q42486 and status ~= INCOMPLETE then escort_cleanup(p) end
end)

PrintInfo("[Suramar] Waning Crescent interactions loaded (40745, 42722, 42486).")
