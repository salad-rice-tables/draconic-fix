-- 86647 Beat of Blood: Arator waits at Amani Pass and greets the player on arrival (retail line + soundkit)
-- Arator uses SmartAI, so Eluna creature hooks don't fire on him; poll from the player instead.
local QUEST, ARATOR_PASS = 86647, 236611
local LINE, SOUND = "It's the Twilight's Blade! They're the true threat!", 300106
local greeted = {}

local function check(eventId, delay, calls, player)
    local key = tostring(player:GetGUIDLow())
    if not player:HasQuest(QUEST) then
        player:RemoveEventById(eventId)
        return
    end
    if greeted[key] then return end
    local ar = player:GetNearestCreature(15, ARATOR_PASS)
    if ar then
        greeted[key] = true
        ar:PerformEmote(1)
        ar:SendUnitSay(LINE, 0)
        ar:PlayDistanceSound(SOUND, player)
        player:RemoveEventById(eventId)
    end
end

local running = {}

local function start(player)
    local key = tostring(player:GetGUIDLow())
    if player:HasQuest(QUEST) and not greeted[key] and not running[key] then
        running[key] = player:RegisterEvent(function(id, d, c, p)
            check(id, d, c, p)
            if greeted[key] or not p:HasQuest(QUEST) then running[key] = nil end
        end, 2000, 0)
    end
end

RegisterPlayerEvent(3, function(event, player) start(player) end)            -- login
RegisterPlayerEvent(47, function(event, player) start(player) end)           -- area change
RegisterPlayerEvent(54, function(event, player, questId, status)              -- quest status change
    if questId ~= QUEST then return end
    greeted[tostring(player:GetGUIDLow())] = nil
    running[tostring(player:GetGUIDLow())] = nil
    if status ~= 0 then start(player) end
end)
