-- 42229 Shal'Aran (Nightfallen intro): retail tour of Shal'Aran.
-- On accept, First Arcanist Thalyssra (RP walker 111863) walks to the central platform, lights the
-- side cavern, goes downstairs, examines the aperture, returns upstairs and finishes at her spot.
-- Hidden stage credits: Side Cavern Lights 111723, Bottom Lights 111724; main objective Explore 98312.
-- 40009 "Search Shal'Aran" used to be credited by 98312 SmartAI on gossip hello; that also completed
-- 42229 on a second click, so the SAI row is removed (sql/20261025_suramar_shalaran.sql) and 40009 is
-- credited here only while 40009 is in progress.
local Q = 42229
local Q_INTRO = 40009
local WALKER = 111863
local STARTER = 98312
local SIDE_CREDIT, BOTTOM_CREDIT, EXPLORE_CREDIT = 111723, 111724, 98312

-- Retail POI points (quest_poi/quest_poi_points 42229) and the post-quest Thalyssra spawn.
local UPPER = { 1714.92, 4631.01, 124.089 }
local LOWER = { 1730.00, 4606.00, 96.50 }
local END_SPOT = { 1706.66, 4625.23, 124.006 }

local st = {}
local function S(p)
    local k = tostring(p:GetGUIDLow())
    st[k] = st[k] or { credit = {} }
    return st[k]
end

local function alive(c)
    if not c then return false end
    local ok, v = pcall(function() return c:IsInWorld() and c:IsAlive() end)
    return ok and v
end

local function say(c, text, kit)
    if not alive(c) then return end
    pcall(function() c:SendUnitSay(text, 0) end)
    if kit and kit > 0 then pcall(function() c:PlayDistanceSound(kit) end) end
end

local function credit(p, entry)
    local s = S(p)
    if s.credit[entry] then return end
    s.credit[entry] = true
    p:KilledMonsterCredit(entry, 0)
end

local function after(p, ms, fn)
    p:RegisterEvent(function(_, _, _, pl) fn(pl or p) end, ms, 1)
end

local function move(c, id, spot, walk)
    if not alive(c) then return end
    pcall(function() c:SetWalk(walk and true or false) end)
    local ok = false
    pcall(function() ok = c:MoveToSafe(id, spot[1], spot[2], spot[3]) end)
    if not ok then
        pcall(function() c:MoveTo(id, spot[1], spot[2], spot[3]) end)
    end
end

local function stop(p)
    local s = S(p)
    s.tour = nil
    s.token = (s.token or 0) + 1
    if s.walker then
        pcall(function() if s.walker:IsInWorld() then s.walker:DespawnOrUnsummon(0) end end)
    end
    s.walker = nil
    s.credit = {}
end

-- Relative delays (ms), cumulative ~2 min 10 s. Movement is best effort; all credits are timer-based,
-- so the quest completes even if the walker cannot path (e.g. player waits upstairs like on retail).
local STEPS = {
    { 1,     function(p, w) move(w, 1, UPPER, true) end },
    { 0,     function(p, w) say(w, "What is this place?", 67382) end },
    { 4500,  function(p, w) say(w, "This chamber... I have never seen anything like it.", 67383) end },
    { 4500,  function(p, w) say(w, "So dark...", 67384) end },
    { 18000, function(p, w) say(w, "In'alah!", 67385) end },
    { 2000,  function(p, w) credit(p, SIDE_CREDIT) end },
    { 3000,  function(p, w) say(w, "Much better.", 67386) end },
    { 4000,  function(p, w) say(w, "Old teleporters. Not so different from the ones in Suramar city. Seems they are inactive.", 67387) end },
    { 5000,  function(p, w)
        say(w, "Let us explore downstairs. Watch your step.", 67388)
        move(w, 2, LOWER, false)
    end },
    { 15000, function(p, w) credit(p, BOTTOM_CREDIT) end },
    { 0,     function(p, w) say(w, "Strange. The floor looks like... a map?", 67389) end },
    { 5000,  function(p, w) say(w, "And we are at the center...", 67390) end },
    { 5000,  function(p, w) say(w, "One thing is certain - leyline energy is being fed into this chamber from elsewhere.", 67391) end },
    { 6000,  function(p, w) say(w, "What could have required such power? A weapon, perhaps?", 67392) end },
    { 6000,  function(p, w) say(w, "And those keepers protecting it... How long their vigil must have been...", 67393) end },
    { 5000,  function(p, w) say(w, "<Sigh.> I have more questions now than before!", 67394) end },
    { 5000,  function(p, w) move(w, 3, END_SPOT, false) end },
    { 15000, function(p, w) say(w, "For now, at least, we know the withered have learned to avoid this place.", 67395) end },
    { 5000,  function(p, w) say(w, "And nobody from the palace would think to search for us here.", 67396) end },
    { 5000,  function(p, w) say(w, "It is a perfect refuge. A temporary home, until I can return to Suramar.", 67397) end },
    { 5000,  function(p, w) say(w, "But first, I will need allies.", 67398) end },
    { 5000,  function(p, w) credit(p, EXPLORE_CREDIT) end },
    { 5000,  function(p, w) end },
}

local function run(p, w, i, token)
    local s = S(p)
    if s.token ~= token or not alive(w) then return end
    if i > #STEPS then
        s.tour = nil
        pcall(function() w:DespawnOrUnsummon(0) end)
        s.walker = nil
        return
    end
    after(p, STEPS[i][1], function()
        if S(p).token ~= token or not alive(w) then return end
        STEPS[i][2](p, w)
        run(p, w, i + 1, token)
    end)
end

local function start(p)
    local s = S(p)
    if s.tour then return end
    if p:GetQuestStatus(Q) ~= 3 then return end
    local x, y, z, o = p:GetLocation()
    local w = p:SpawnCreature(WALKER, x + 1.5 * math.cos(o), y + 1.5 * math.sin(o), z, o + math.pi, 8, 0)
    if not w then return end
    s.tour = true
    s.credit = {}
    s.token = (s.token or 0) + 1
    s.walker = w
    pcall(function()
        w:SetWalk(true)
        w:SetNPCFlags(0)
        w:SetReactState(0)
    end)
    run(p, w, 1, s.token)
end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= Q then return end
    if status == 3 then
        S(player).credit = {}
        start(player)
    elseif status == 0 then
        stop(player)
    end
end)

-- Relog while the tour is still in progress (the temporary walker is gone): start it again.
RegisterPlayerEvent(3, function(event, player)
    if player:GetQuestStatus(Q) ~= 3 then return end
    if player:GetZoneId() ~= 7637 and player:GetAreaId() ~= 7928 then return end
    after(player, 3000, function() start(player) end)
end)

RegisterPlayerEvent(4, function(event, player)
    local s = S(player)
    s.tour = nil
    s.walker = nil
end)

-- 40009 "Search Shal'Aran" (the old SAI shortcut): credit only while 40009 is in progress, never 42229.
RegisterCreatureGossipEvent(STARTER, 1, function(event, player, creature)
    if player:GetQuestStatus(Q_INTRO) == 3 and player:GetQuestStatus(Q) ~= 3 then
        player:KilledMonsterCredit(STARTER, 0)
    end
    return false
end)
