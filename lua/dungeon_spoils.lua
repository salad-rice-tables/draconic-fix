-- Dungeon Spoils: when a dungeon boss falls and you are in a group of two or more, every member in the dungeon receives a Dungeon Spoils (once per
-- dungeon run). Opening it gives gear better than the world drops (an epic of your level band), 5 Marks of Ascension and a Mystic Rune.
-- Self-contained; item 9750010.
if IS_WORLD_STATE then return end
local TAG = "|cffffd200[Dungeon]|r "
local SPOILS, MARK = 9750010, 9750009

local function Done(name, inst)
    local ok, r = pcall(WorldDBQuery, string.format("SELECT v FROM world.lw_state WHERE k = 'spoils:%s:%d'", name, inst))
    return ok and r ~= nil
end

RegisterPlayerEvent(7, function(_, killer, victim)   -- a player kills a creature
    local ok = pcall(function()
        local map = killer:GetMap()
        if not map:IsDungeon() or map:IsRaid() then return end
        if not victim:IsDungeonBoss() then return end
        -- solo aj group (2026-10-16: povodny group>=2 gate bral solo hracom Marks/Spoils)
        local group = killer:GetGroup()
        local members
        if group then
            members = group:GetMembers()
        else
            members = {killer}
        end
        if not members then return end
        local inst = map:GetInstanceId()
        for _, m in ipairs(members) do
            if m:GetMapId() == killer:GetMapId() and m:GetInstanceId() == inst and not Done(m:GetName(), inst) then
                pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('spoils:%s:%d', '1')", m:GetName(), inst))
                m:AddItem(SPOILS, 1)
                m:SendBroadcastMessage(TAG .. "The dungeon yields |cffa335eeDungeon Spoils|r!")
            end
        end
    end)
end)

RegisterItemEvent(SPOILS, 1, function(_, caster)   -- using the item
    if not caster or not caster.GetName then return true end
    local lvl = math.max(1, math.min(90, caster:GetLevel()))
    local bi = math.floor((lvl - 1) / 5)
    local ok, r = pcall(WorldDBQuery, string.format("SELECT Item FROM world.reference_loot_template WHERE Entry = %d ORDER BY RAND() LIMIT 1", 9994001 + bi))
    local gear = ok and r and r:GetUInt32(0) or 0
    if gear > 0 then caster:AddItem(gear, 1) end
    caster:AddItem(MARK, 5)
    if MYS_AddRunes then pcall(MYS_AddRunes, caster, 1) end
    caster:SendBroadcastMessage(TAG .. "You open the spoils: gear, 5 Marks of Ascension and a Mystic Rune.")
    return true
end)
print("[dungeon_spoils] ready")
