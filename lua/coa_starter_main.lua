-- CoA starter gear: on a fresh slot-class character replace the retail outfit by the CoA starter items, equipped (data: coa_starter.lua)
if COA_STARTER and COA_SLOT_KEY and not IS_WORLD_STATE then
    local function strip(p)
        local drop = {}
        for s = 0, 18 do local it = p:GetEquippedItemBySlot(s); if it then drop[#drop + 1] = it:GetEntry() end end
        for s = 23, 38 do local it = p:GetItemByPos(255, s); if it then drop[#drop + 1] = it:GetEntry() end end
        for _, e in ipairs(drop) do p:RemoveItem(e, 1) end
        for s = 19, 22 do local it = p:GetItemByPos(255, s); if it then p:RemoveItem(it:GetEntry(), 1) end end
    end
    RegisterPlayerEvent(28, function(_, player)   -- enter world (map state); event 3 fires only in the world state
        player:RegisterEvent(function(_, _, _, p)
            if not p or not p:IsInWorld() then return end
            local key = COA_KEY(p)
            local set = key and COA_STARTER[key]
            if not set or p:GetLevel() > 1 or p:GetTotalPlayedTime() > 300 or p:HasItem(set[1][1]) then return end   -- ponytail: "fresh" = level 1, <5 min played
            strip(p)
            for _, e in ipairs(set) do
                local it = p:AddItem(e[1], 1)
                local slot = COA_EQUIP_SLOT[e[2]]
                if it and slot and not p:EquipItem(it, slot) and (slot == 10 or slot == 12) then p:EquipItem(it, slot + 1) end
            end
        end, 3000, 1)
    end)
end
