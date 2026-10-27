-- =====================================================================
-- Eversong batch 1 (86733-86745): accept scenes and cross lines (Wiki).
-- 86733: accept -> Turalyon 236778 immediate + Lorthemar 236779 delayed 5s (both guid-direct).
--   (VO: bcast 290883 -> kit 299859 Turalyon, 290413 -> kit 299860 Lorthemar; PlayDistanceSound 2026-10-17.)
-- =====================================================================
if IS_WORLD_STATE then return end

RegisterCreatureEvent(236779, 31, function(_, player, creature, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86733) then return end
    local turalyonGuid = 3000208477
    local okM, map = pcall(function() return player:GetMap() end)
    if okM and map then
        local okC, c = pcall(function() return map:GetCreature(turalyonGuid) end)
        if okC and c and c:IsInWorld() then
            pcall(function() c:SendUnitSay("The Vanguard of the Light will need quarters and supplies.", 0) end)
            pcall(function() c:PlayDistanceSound(299859, player) end)
        end
    end
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local okM2, map2 = pcall(function() return p:GetMap() end)
        if not okM2 or not map2 then return end
        local okC2, c2 = pcall(function() return map2:GetCreature(3000208518) end)
        if okC2 and c2 and c2:IsInWorld() then
            pcall(function() c2:SendUnitSay("I will consider it, after I have consulted with the others.", 0) end)
            pcall(function() c2:PlayDistanceSound(299860, p) end)
            pcall(function() PrintInfo("[eversong] 86733 accept scene played") end)
        else
            pcall(function() PrintInfo("[eversong] 86733 Lorthemar guid not visible") end)
        end
    end, 5000, 1)
end)

-- 86769 escort pilot: accept -> Liadrin say + walk A(11127,-4477) -> B Parhelion Plaza(11014,-4409).
-- MoveToSafe = navmesh (custom core method, vzor lw_engine.lua), fallback MoveTo. Turn-in u B spawnu.
RegisterCreatureEvent(236693, 31, function(_, player, creature, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86769) then return end
    if not creature or not creature:IsInWorld() then return end
    pcall(function() creature:SendUnitSay("We prayed for a miracle, and the Vanguard of Light answered the call. But the battle yet rages on.", 0) end)
    pcall(function() creature:PlayDistanceSound(308173, player) end)  -- bt 283614 kit2 vo_120_lady_liadrin_104_f
    pcall(function() creature:SetWalk(true) end)
    local moved = pcall(function() return creature:MoveToSafe(1, 11014.7, -4409.02, 79.78) end)
    if not moved then
        pcall(function() creature:MoveTo(1, 11014.7, -4409.02, 79.78, true) end)
    end
    pcall(function() PrintInfo("[eversong] 86769 escort started") end)
end)

print("[eversong_b1] loaded")
