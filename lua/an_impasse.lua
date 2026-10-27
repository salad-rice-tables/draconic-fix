-- 86646 An Impasse: Vanatha (clone 9108860, no SmartAI so Eluna drives her)
-- hostile on spawn, aggro line + "Enter combat" credit, surrenders at 35% health
local QUEST, VANATHA = 86646, 9108860
local CREDIT_COMBAT, CREDIT_CONFRONT = 241368, 237386
local AGGRO_LINE, AGGRO_SOUND = "First blood was yours. You will die!", 300102
local SURRENDER_LINE, SURRENDER_SOUND = "Zul'jan... no...", 300103
local done = {}

local function questPlayers(creature)
    local list = {}
    for _, p in pairs(creature:GetPlayersInRange(60) or {}) do
        if p:HasQuest(QUEST) then list[#list + 1] = p end
    end
    return list
end

RegisterCreatureEvent(VANATHA, 5, function(event, creature)          -- spawn
    done[tostring(creature:GetGUIDLow())] = nil
    creature:SetFaction(16)
    creature:SetNPCFlags(0)
    creature:SetStandState(0)
    creature:SetReactState(2)                                         -- aggressive
end)

RegisterCreatureEvent(VANATHA, 1, function(event, creature, target)  -- enter combat
    if done[tostring(creature:GetGUIDLow())] then return end
    creature:SendUnitSay(AGGRO_LINE, 0)
    creature:PlayDistanceSound(AGGRO_SOUND)
    for _, p in ipairs(questPlayers(creature)) do p:KilledMonsterCredit(CREDIT_COMBAT, 0) end
end)

local function surrender(creature)
    done[tostring(creature:GetGUIDLow())] = true
    creature:SetFaction(35)
    creature:AttackStop()
    creature:ClearThreatList()
    creature:SetReactState(0)                                         -- passive
    creature:SetStandState(8)                                         -- kneel
    for _, p in ipairs(questPlayers(creature)) do p:KilledMonsterCredit(CREDIT_CONFRONT, 0) end
    creature:RegisterEvent(function(_, _, _, c)
        c:SendUnitSay(SURRENDER_LINE, 0)
        c:PlayDistanceSound(SURRENDER_SOUND)
    end, 3000, 1)
end

local function num(v) return tonumber(tostring(v)) or 0 end

RegisterCreatureEvent(VANATHA, 9, function(event, creature, attacker, damage)   -- damage taken
    if done[tostring(creature:GetGUIDLow())] then return true, 0 end
    local hp, maxhp, dmg = num(creature:GetHealth()), num(creature:GetMaxHealth()), num(damage)
    local floor = math.floor(maxhp * 0.35)
    if hp - dmg <= floor then
        local allowed = hp - floor
        if allowed < 0 then allowed = 0 end
        surrender(creature)
        return false, allowed
    end
end)
