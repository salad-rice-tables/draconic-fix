-- Starter gear for characters that begin naked (Zandalari and other races the client outfit data does not cover): up to level 30, with nothing equipped,
-- a basic chest, legs, boots and the class's weapon(s) are added and worn once. Self-contained.
local TAG = "|cffffd200[Starter]|r "
local CLOTH   = {chest = 56,   legs = 1395, feet = 55}
local LEATHER = {chest = 60,   legs = 48,   feet = 47}
local MAIL    = {chest = 2379, legs = 48,   feet = 47}
local PLATE   = {chest = 3273, legs = 48,   feet = 47}
local ARMOR = {[1] = PLATE, [2] = PLATE, [3] = MAIL, [4] = LEATHER, [5] = CLOTH, [6] = PLATE, [7] = MAIL, [8] = CLOTH, [9] = CLOTH, [10] = LEATHER, [11] = LEATHER, [12] = LEATHER, [13] = MAIL}
-- {item, slot}: 15 main hand, 16 off hand
local WEAPONS = {
  [1] = {{25, 15}, {876, 16}}, [2] = {{36, 15}, {876, 16}}, [3] = {{2504, 15}}, [4] = {{2092, 15}, {2092, 16}}, [5] = {{36, 15}},
  [6] = {{1194, 15}}, [7] = {{36, 15}, {876, 16}}, [8] = {{35, 15}}, [9] = {{2092, 15}}, [10] = {{35, 15}}, [11] = {{35, 15}},
  [12] = {{2092, 15}, {2092, 16}}, [13] = {{35, 15}},
}
local SLOT = {chest = 4, legs = 6, feet = 7}

local function Naked(p)
    for s = 0, 18 do if s ~= 3 and s ~= 18 and p:GetEquippedItemBySlot(s) then return false end end   -- 3 shirt and 18 tabard do not count
    return true
end
local function Done(p)
    local ok, r = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = 'starter:" .. p:GetName() .. "'")
    return ok and r ~= nil
end

RegisterPlayerEvent(3, function(_, player)   -- login
    if player:GetLevel() > 30 then return end
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() or p:GetLevel() > 30 or Done(p) or not Naked(p) then return end
        pcall(WorldDBExecute, "REPLACE INTO world.lw_state (k, v) VALUES ('starter:" .. p:GetName() .. "', '1')")
        local cls = p:GetClass()
        local a = ARMOR[cls] or CLOTH
        for part, slot in pairs(SLOT) do
            local item = p:AddItem(a[part], 1)
            if item then pcall(function() p:EquipItem(item, slot) end) end
        end
        for _, w in ipairs(WEAPONS[cls] or {}) do
            local item = p:AddItem(w[1], 1)
            if item then pcall(function() p:EquipItem(item, w[2]) end) end
        end
        p:SendBroadcastMessage(TAG .. "You received a basic set of starting gear.")
    end, 6000, 1)
end)

-- Spells every hero has from the first minute, outside the Wildcard draft: Switch Flight Style (and its helper spell)
local ALWAYS = {436854, 1900000}
RegisterPlayerEvent(3, function(_, player)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        for _, s in ipairs(ALWAYS) do
            if not p:HasSpell(s) then pcall(function() p:LearnSpell(s) end) end
        end
    end, 5000, 1)
end)
