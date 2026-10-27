-- Jednorazovy placer NPC spawnov (Curse of Ula'tek, faza 1).
-- Bezi len ked vedla worldserver.exe existuje subor npc_place.run.
-- Pre kazdy riadok world.coa_npc_staging (done=0) na mape s hracmi:
--   zoberie zem cez Map:GetHeight, docasne spawne moba (hned vidno)
--   a zapise trvaly riadok do world.creature (plati po restarte).
-- Hotove riadky oznaci done=1, flag subor zmaze. Vzor: worldforge SpawnNear.
-- done=2: bez zeme (neopakovat), done=3: duplikat do 5 yd (2026-10-13 proximity check).
if IS_WORLD_STATE then return end

local function Place()
    local flag = io.open("npc_place.run", "r")
    if not flag then return end
    flag:close()
    -- flag sa maze az ked nezostane NIC neurobene (mapy bez hracov pockaju)
    local qc = WorldDBQuery("SELECT COUNT(*) FROM world.coa_npc_staging WHERE done = 0")
    local pending = 0
    if qc then pcall(function() pending = qc:GetUInt32(0) end) end
    if pending == 0 then os.remove("npc_place.run"); return end
    local q = WorldDBQuery("SELECT entry, map, x, y, o, guid FROM world.coa_npc_staging WHERE done = 0")
    if not q then return end
    local players = MAP_Players() or {}
    print("[npc_place] tick: players on map " .. tostring((players[1] and players[1]:GetMapId()) or "?") .. ": " .. #players)
    if #players == 0 then return end   -- na tejto mape zatial nikto: flag ostava
    local ref = players[1]
    local n, skip = 0, 0
    repeat
        local entry, map, x, y, o, guid = q:GetUInt32(0), q:GetUInt32(1), q:GetFloat(2),
            q:GetFloat(3), q:GetFloat(4), q:GetUInt32(5)
        -- len riadky TEJTO mapy (kazdy map state si riesi svoje)
        if map == ref:GetMapId() then
            local ok, z = pcall(function() return ref:GetMap():GetHeight(x, y, ref) end)
            -- DEBUG: typy hodnot (Eluna vracia obcas userdata/nil)
            print("[npc_place] row: entry=" .. tostring(entry) .. "(" .. type(entry) .. ") map=" ..
                tostring(map) .. " x=" .. tostring(x) .. " y=" .. tostring(y) .. " o=" ..
                tostring(o) .. " guid=" .. tostring(guid) .. "(" .. type(guid) .. ") z=" .. tostring(z))
            if ok and z then
                -- proximity check (2026-10-13): rovnake entry do 5 yd uz stoji -> duplikat, neukladat
                local dup = WorldDBQuery(string.format(
                    "SELECT guid FROM world.creature WHERE id = %d AND map = %d AND ABS(position_x - %f) < 5 AND ABS(position_y - %f) < 5 LIMIT 1",
                    entry, map, x, y))
                if dup then
                    print("[npc_place] skipped (dupe within 5 yd): " .. entry .. " " .. x .. "," .. y)
                    pcall(WorldDBExecute, string.format("UPDATE world.coa_npc_staging SET done = 3 WHERE guid = %.0f", guid))   -- 3 = duplikat, neopakovat
                    skip = skip + 1
                else
                -- docasny spawn (hned vidno, rucny despawn) + trvaly zaznam (po restarte).
                -- POZOR: guid > 2^31 sa do %d nezmesti (32-bit lua) - pouzi %.0f!
                -- maska: default all-difficulties (ako mapa 3004) - '0' by na instance mapach bolo neviditelne
                pcall(function() ref:SpawnCreature(entry, x, y, z, o, 8, 0) end)
                pcall(WorldDBExecute, string.format(
                    "INSERT IGNORE INTO world.creature (guid, id, map, zoneId, areaId, spawnDifficulties, phaseUseFlags, PhaseId, PhaseGroup, terrainSwapMap, modelid, equipment_id, position_x, position_y, position_z, orientation, spawntimesecs, wander_distance, currentwaypoint, curHealthPct, MovementType, npcflag, unit_flags, unit_flags2, unit_flags3, ScriptName, StringId, VerifiedBuild, size) VALUES (%.0f, %d, %d, 0, 0, '0,1,2,8,14,15,16,17,23,24,205', 0, 0, 0, -1, 0, 0, %f, %f, %f, %f, 300, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, '', '', 0, 0)",
                    guid, entry, map, x, y, z, o))
                pcall(WorldDBExecute, string.format(
                    "UPDATE world.coa_npc_staging SET done = 1 WHERE guid = %.0f", guid))
                n = n + 1
                end
            else
                print("[npc_place] skipped (no ground height there): " .. entry .. " " .. x .. "," .. y)
                pcall(WorldDBExecute, string.format("UPDATE world.coa_npc_staging SET done = 2 WHERE guid = %.0f", guid))   -- 2 = no ground, do not retry every tick
                skip = skip + 1
            end
        end
    until not q:NextRow()
    print("[npc_place] done: " .. n .. " spawns, skipped: " .. skip)
end

if MAP_Timer then
    -- chvilu po starte mapy (aby boli hraci nacitani), opakuje kym je flag
    MAP_Timer("npc_place.once", function()
        local ok, err = pcall(Place)
        if not ok then print("[npc_place] CHYBA: " .. tostring(err)) end
    end, 30000)
end
print("[npc_place] loaded (caka na npc_place.run)")
