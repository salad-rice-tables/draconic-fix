-- 86838 Renewal for the Weary: Faol's Benediction (spell 1224826) on a selected Sunwell channeler renews it.
-- Credit 237563 per distinct channeler (10), Velen comments at 2 and 7 blessed (retail lines + soundkits).
local QUEST, SPELL, CREDIT, VELEN, RANGE = 86838, 1224826, 237563, 239623, 18
local CHANNELER = { [242608] = true, [242609] = true, [242610] = true, [242614] = true, [242615] = true,
                    [244867] = true, [248317] = true, [248321] = true, [248324] = true, [248326] = true }
local LINE_TIRED  = { "I know you are tired. It is hard to continue, but we must!", 305882 }
local LINE_FALL   = { "Should the Sunwell fall, we have no way to stop the Devouring Host!", 305883 }
local LINE_PURPOSE = { "We have taken different paths to reach the Light, but together we assemble for the same purpose. To protect Azeroth!", 305881 }

local state = {}   -- [playerGuid] = { count = n, done = { [spawnGuid] = true } }

local function st(player)
    local k = tostring(player:GetGUIDLow())
    state[k] = state[k] or { count = 0, done = {} }
    return state[k]
end

local function velenSays(npc, line)
    local v = npc:GetNearestCreature(80, VELEN)
    if v then
        v:SendUnitSay(line[1], 0)
        v:PlayDistanceSound(line[2])
    end
end

RegisterPlayerEvent(5, function(event, player, spell, skipCheck)
    if spell:GetEntry() ~= SPELL or not player:HasQuest(QUEST) then return end
    local t = player:GetSelection()
    if not t or not CHANNELER[t:GetEntry()] or player:GetDistance(t) > RANGE then return end
    local s = st(player)
    local g = tostring(t:GetDBTableGUIDLow())
    if s.done[g] then return end
    s.done[g] = true
    s.count = s.count + 1
    local n = s.count
    player:KilledMonsterCredit(CREDIT, 0)
    t:SetFacingToObject(player)
    t:PerformEmote(1)
    t:RegisterEvent(function(_, _, _, c)
        if n == 2 then velenSays(c, LINE_TIRED)
        elseif n == 7 then velenSays(c, LINE_FALL)
        else velenSays(c, LINE_PURPOSE) end
    end, 2500, 1)
end)

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == QUEST then state[tostring(player:GetGUIDLow())] = nil end
end)
