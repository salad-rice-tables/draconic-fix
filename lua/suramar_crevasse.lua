-- 42227 Into the Crevasse: the SAI areatriggers that should give "Follow Valewalker Farodin" / "Enter Falanaar Tunnels" don't exist,
-- so credit comes from the Falanaar Tunnels areas instead (Farodin stands at the tunnel entrance, phase 41087).
local Q = 42227
local AREAS = { [8158] = true, [8160] = true, [8189] = true, [8404] = true, [8163] = true }
RegisterPlayerEvent(47, function(event, player, oldArea, newArea)
    if AREAS[newArea] and player:HasQuest(Q) then
        player:KilledMonsterCredit(107126, 0)
        player:RegisterEvent(function(_, _, _, p) if p:HasQuest(Q) then p:KilledMonsterCredit(107918, 0) end end, 1500, 1)
    end
end)

-- 42228 The Hidden City: hidden "Orathiss Scene 1/2" credits (SAI areatriggers missing) -> scene 1 when reaching the queen's hall, scene 2 at her death
local Q2, ORATHISS = 42228, 107959
RegisterCreatureEvent(ORATHISS, 4, function(event, creature, killer)      -- 4 = died
    local p = killer and killer:ToPlayer()
    if p and p:HasQuest(Q2) then p:KilledMonsterCredit(107975, 0) end
end)
local watching = {}
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= Q2 or status ~= 3 then return end
    local k = player:GetGUIDLow()
    if watching[k] then return end
    watching[k] = true
    player:RegisterEvent(function(id, _, _, p)
        if not p:HasQuest(Q2) then p:RemoveEventById(id); watching[k] = nil; return end
        if p:GetNearestCreature(45, ORATHISS) then
            p:KilledMonsterCredit(107974, 0)
            p:RemoveEventById(id); watching[k] = nil
        end
    end, 1500, 0)
end)

-- 42230 The Valewalker's Burden: Fal'adora Beacon (own copy 9108877) -> GO credit, then Shal'Aran next to the Ancient Seed Holder
local Q3, BEACON, BEACON_CREDIT = 42230, 9108877, 251047
local DEST = { 1220, 1723.5, 4611.5, 116.6, 0.0 }
RegisterGameObjectGossipEvent(BEACON, 1, function(event, player, go)
    if not player:HasQuest(Q3) then return false end
    player:KillGOCredit(BEACON_CREDIT)
    player:RegisterEvent(function(_, _, _, p) p:Teleport(DEST[1], DEST[2], DEST[3], DEST[4], DEST[5]) end, 3000, 1)
    return true
end)
