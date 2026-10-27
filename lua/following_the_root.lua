-- 86643 Following the Root - retail flow (user-described + video DGoB3uGnnR0)
-- Arator kneels at the entrance totem; two Shrouding Totems ('Destroying' cast, spell 1254243) open the first Spirit Barrier and wake him
-- (he follows); Grimfire / Stranglemist totems are 'Destroying' spellclick; both destroyed -> second barrier opens, Arator moves on and kneels;
-- gossip 'Play Movie' plays the cinematic (SAI, scene 9108603), after-scene part is SAI timed list 23661002.
local QUEST, ARATOR, GO_TOTEM = 86643, 236610, 574602
local GRIMFIRE, STRANGLEMIST = 251863, 251866
local BARRIER_ENTRANCE, BARRIER_LOWER = 516342, 516343
local DESTROY_SPELL, CREDIT_WARDING = 1254243, 251873
local ENTRANCE = { x = 6033.5, y = -5175.3, z = 215.6, o = 1.12 }
local STAGE2   = { x = 6055.575, y = -5046.194, z = 195.977, o = 1.79 }
local RESET_MS = 300000
local ENTRANCE_TOTEMS = { { 6043.9, -5173.9, 215.5, 0.0 }, { 6034.8, -5172.2, 215.6, 0.0 } }
local GONE_S = 120   -- destroyed totems stay gone for 2 minutes (state is derived from what is still spawned: Eluna runs several Lua states)

local players = {}   -- [guidLow] = { totems = {}, n = 0, woke = false, grim = false, strang = false, lower = false }

local function state(player)
    local k = player:GetGUIDLow()
    players[k] = players[k] or { totems = {}, n = 0, woke = false, grim = false, strang = false, lower = false }
    return players[k]
end

local function arator(obj) return obj:GetNearestCreature(300, ARATOR) end

local function say(unit, player, text, kit)
    unit:SendUnitSay(text, 0)
    if kit then unit:PlayDirectSound(kit, player) end
end

local function armReset(ar)
    ar:RegisterEvent(function(_, _, _, u)
        u:MoveClear(); u:NearTeleport(ENTRANCE.x, ENTRANCE.y, ENTRANCE.z, ENTRANCE.o); u:SetStandState(8)
    end, RESET_MS, 1)
end

local function openBarrier(from, entry, range)
    local wall = from:GetNearestGameObject(range, entry)
    if wall then pcall(function() wall:SetRespawnTime(120); wall:Despawn() end) end
end

local function wakeArator(player, from)
    local ar = arator(from)
    if not ar then return end
    ar:SetStandState(0); ar:EmoteState(0)
    say(ar, player, "I suspect the Amani didn't want any uninvited guests. Lucky these wards are old.", 300087)
    ar:RegisterEvent(function(_, _, _, u)
        local p = u:GetNearestPlayer(60)
        if p then u:MoveClear(); u:MoveFollow(p, 3, 1.57) end
    end, 1500, 1)
    -- guard: stop following (and go back to the totem) when nobody on the quest is near any more
    local guardId
    guardId = ar:RegisterEvent(function(_, _, _, u)
        local p = u:GetNearestPlayer(80)
        if not p or not p:HasQuest(QUEST) then
            u:RemoveEventById(guardId)
            u:MoveClear(); u:NearTeleport(ENTRANCE.x, ENTRANCE.y, ENTRANCE.z, ENTRANCE.o); u:SetStandState(8)
        end
    end, 3000, 0)
end

local function lowerDone(player, from)
    openBarrier(from, BARRIER_LOWER, 60)
    local ar = arator(from)
    if ar then
        say(ar, player, "If they were this well guarded, we'll want to take care ahead. Follow me, and keep quiet.", 300088)
        ar:MoveClear(); ar:SetStandState(0); ar:EmoteState(0)
        ar:MoveTo(1, STAGE2.x, STAGE2.y, STAGE2.z)
        ar:RegisterEvent(function(_, _, _, u) u:SetFacing(STAGE2.o); u:SetStandState(8) end, 7000, 1)
        armReset(ar)
    end
end

local function wake(player, from)
    openBarrier(from, BARRIER_ENTRANCE, 40)
    wakeArator(player, from)
end

-- Shrouding Totem (GO): hello hook fires when the 'Destroying' castbar completes
RegisterGameObjectGossipEvent(GO_TOTEM, 1, function(event, player, go)
    if player:HasQuest(QUEST) then
        if player:GetDistance(go) > 10 then return false end
        PrintInfo("[ftr86643] shrouding totem destroyed go=" .. tostring(go:GetGUIDLow()))
        player:KilledMonsterCredit(CREDIT_WARDING, 0)
        local x, y, z, o = go:GetX(), go:GetY(), go:GetZ(), go:GetO()
        local ar = arator(go)
        go:RegisterEvent(function(_, _, _, g)
            local p = g:GetNearestPlayer(40)
            g:RemoveFromWorld(false)
            if p then
                -- both entrance totems destroyed? (nearest remaining one within 20y of the player)
                local left = 0
                for _, o in ipairs(p:GetGameObjectsInRange(80, GO_TOTEM)) do
                    for _, spot in ipairs(ENTRANCE_TOTEMS) do
                        if math.abs(o:GetX() - spot[1]) < 3 and math.abs(o:GetY() - spot[2]) < 3 then left = left + 1 end
                    end
                end
                if left == 0 then wake(p, p) end
            end
            -- the totem comes back later for the next player
            if ar then
                ar:RegisterEvent(function(_, _, _, u) u:SummonGameObject(GO_TOTEM, x, y, z, o, 0) end, GONE_S * 1000, 1)
            end
        end, 500, 1)
    end
    return false
end)

-- Grimfire / Stranglemist: spellclick 'Destroying' (spell 147478, castbar); credit + despawn when the player's cast finishes
local DESTROYING = 147478
local function totemDone(player, creature)
    local entry = creature:GetEntry()
    PrintInfo("[ftr86643] creature totem destroyed " .. tostring(entry))
    player:KilledMonsterCredit(CREDIT_WARDING, 0)
    local other = (entry == GRIMFIRE) and STRANGLEMIST or GRIMFIRE
    local stillThere = creature:GetNearestCreature(150, other)
    creature:DespawnOrUnsummon(800)
    if not stillThere then lowerDone(player, player) end
end
RegisterPlayerEvent(5, function(event, player, spell, skipCheck)
    if spell:GetEntry() ~= DESTROYING then return end
    local t = spell:GetTarget() or player:GetSelection()
    PrintInfo('[ftr86643] Destroying cast hq=' .. tostring(player:HasQuest(QUEST)) .. ' target=' .. tostring(t and t:GetEntry()))
    if not player:HasQuest(QUEST) then return end
    if t and (t:GetEntry() == GRIMFIRE or t:GetEntry() == STRANGLEMIST) then
        if player:GetDistance(t) > 8 then
            player:SendBroadcastMessage("You are too far away.")
            PrintInfo("[ftr86643] Destroying ignored, too far: " .. tostring(player:GetDistance(t)))
            return
        end
        totemDone(player, t)
    end
end)

-- GM helper for testing: .ftrtotems respawns the two entrance Shrouding Totems
RegisterPlayerEvent(42, function(event, player, command)
    PrintInfo("[ftr86643] command=" .. tostring(command))
    if player and command == "ftrtotems" then
        for _, t in ipairs(ENTRANCE_TOTEMS) do
            local found = false
            for _, g in ipairs(player:GetGameObjectsInRange(60, GO_TOTEM)) do
                if math.abs(g:GetX() - t[1]) < 2 and math.abs(g:GetY() - t[2]) < 2 then found = true end
            end
            if not found then player:SummonGameObject(GO_TOTEM, t[1], t[2], t[3], t[4], 0) end
        end
        player:SendBroadcastMessage("Entrance totems respawned.")
        return false
    elseif player and command == "ftrwho" then
        for _, c in ipairs(player:GetCreaturesInRange(80, ARATOR)) do
            PrintInfo(string.format("[ftr86643] ARATOR db=%s x=%.1f y=%.1f z=%.1f dist=%.1f alive=%s", tostring(c:GetDBTableGUIDLow()), c:GetX(), c:GetY(), c:GetZ(), player:GetDistance(c), tostring(c:IsAlive())))
        end
        return false
    elseif player and command == "ftrlower" then
        lowerDone(player, player)
        player:SendBroadcastMessage("Lower barrier opened, Arator moved on.")
        return false
    elseif player and command == "ftrwake" then
        wake(player, player)
        player:SendBroadcastMessage("Entrance barrier opened, Arator woken.")
        return false
    end
end)
