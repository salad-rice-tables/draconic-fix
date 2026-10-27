-- Jednorazovy placer RETAIL NPC na Coiled Isle (affine mapa z 2 kotiev, 2026-10-14).
-- Bezi len ked vedla worldserver.exe existuje subor coiled_place.run.
-- Pre kazdy riadok world.coiled_retail_staging (done=0) na mape s hracmi:
--   zem cez Map:GetHeight, docasny spawn + trvaly riadok do world.creature.
-- done=1 hotovo, 2 = bez zeme, 3 = duplikat do 5 yd. Vzor: npc_place.lua.
if IS_WORLD_STATE then return end

local MASK = '0,1,2,8,14,15,16,17,23,24,205'

local function Place()
    local flag = io.open("coiled_place.run", "r")
    if not flag then return end
    flag:close()
    local qc = WorldDBQuery("SELECT COUNT(*) FROM world.coiled_retail_staging WHERE done = 0")
    local pending = 0
    if qc then pcall(function() pending = qc:GetUInt32(0) end) end
    if pending == 0 then os.remove("coiled_place.run"); return end
    local q = WorldDBQuery("SELECT entry, x, y, o, guid FROM world.coiled_retail_staging WHERE done = 0")
    if not q then return end
    local players = MAP_Players() or {}
    if #players == 0 then return end
    local ref = players[1]
    local map = ref:GetMapId()
    local n, skip = 0, 0
    repeat
        local entry, x, y, o, guid = q:GetUInt32(0), q:GetFloat(1),
            q:GetFloat(2), q:GetFloat(3), q:GetUInt32(4)
        local ok, z = pcall(function() return ref:GetMap():GetHeight(x, y, ref) end)
        if ok and z then
            local dup = WorldDBQuery(string.format(
                "SELECT guid FROM world.creature WHERE id = %d AND map = %d AND ABS(position_x - %f) < 5 AND ABS(position_y - %f) < 5 LIMIT 1",
                entry, map, x, y))
            if dup then
                print("[coiled_place] skipped (dupe within 5 yd): " .. entry .. " " .. x .. "," .. y)
                pcall(WorldDBExecute, string.format("UPDATE world.coiled_retail_staging SET done = 3 WHERE guid = %.0f", guid))
                skip = skip + 1
            else
                pcall(function() ref:SpawnCreature(entry, x, y, z, o, 8, 0) end)
                pcall(WorldDBExecute, string.format(
                    "INSERT IGNORE INTO world.creature (guid, id, map, zoneId, areaId, spawnDifficulties, phaseUseFlags, PhaseId, PhaseGroup, terrainSwapMap, modelid, equipment_id, position_x, position_y, position_z, orientation, spawntimesecs, wander_distance, currentwaypoint, curHealthPct, MovementType, npcflag, unit_flags, unit_flags2, unit_flags3, ScriptName, StringId, VerifiedBuild, size) VALUES (%.0f, %d, %d, 16365, 0, '" .. MASK .. "', 0, 0, 0, -1, 0, 0, %f, %f, %f, %f, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', '', 0, 0)",
                    guid, entry, map, x, y, z, o))
                pcall(WorldDBExecute, string.format(
                    "UPDATE world.coiled_retail_staging SET done = 1 WHERE guid = %.0f", guid))
                n = n + 1
            end
        else
            print("[coiled_place] skipped (no ground height there): " .. entry .. " " .. x .. "," .. y)
            pcall(WorldDBExecute, string.format("UPDATE world.coiled_retail_staging SET done = 2 WHERE guid = %.0f", guid))
            skip = skip + 1
        end
    until not q:NextRow()
    print("[coiled_place] done: " .. n .. " spawns, skipped: " .. skip)
end

if MAP_Timer then
    MAP_Timer("coiled_place.once", function()
        local ok, err = pcall(Place)
        if not ok then print("[coiled_place] CHYBA: " .. tostring(err)) end
    end, 30000)
end
print("[coiled_place] loaded (caka na coiled_place.run)")
