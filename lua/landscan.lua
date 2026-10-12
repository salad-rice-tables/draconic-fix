-- .landscan : GM command. Samples the ground height of the Coiled Isle box on a 40-yard grid and stores it in world.isle_land, so the population
-- script (tools/coiled_populate.py) knows where there is land. Stand on the isle (the map must be loaded around you; the height query works for the whole map).
if not IS_WORLD_STATE then return end
pcall(WorldDBExecute, [[CREATE TABLE IF NOT EXISTS world.isle_land (gx INT NOT NULL, gy INT NOT NULL, x FLOAT NOT NULL, y FLOAT NOT NULL, z FLOAT NOT NULL, PRIMARY KEY (gx, gy)) ENGINE=InnoDB]])

RegisterPlayerEvent(42, function(_, player, command)
    if string.lower(command or "") ~= "landscan" then return end
    local okR, rank = pcall(function() return player:GetGMRank() end)
    if not okR or (rank or 0) < 2 then return false end
    local map = player:GetMap()
    if not map or map:GetMapId() ~= 0 then
        player:SendBroadcastMessage("|cffff0000[landscan]|r Stand on the Coiled Isle (Eastern Kingdoms map).")
        return false
    end
    local X0, X1, Y0, Y1, STEP = 3500, 8500, -14500, -9500, 40
    local rows, n, land = {}, 0, 0
    WorldDBExecute("DELETE FROM isle_land")
    for gx = 0, math.floor((X1 - X0) / STEP) do
        for gy = 0, math.floor((Y1 - Y0) / STEP) do
            local x, y = X0 + gx * STEP, Y0 + gy * STEP
            local ok, h = pcall(function() return map:GetHeight(x, y, player) end)
            n = n + 1
            if ok and h and h > 2 and h < 1000 then
                land = land + 1
                rows[#rows + 1] = string.format("(%d,%d,%d,%d,%.2f)", gx, gy, x, y, h)
                if #rows >= 200 then
                    WorldDBExecute("INSERT INTO isle_land (gx,gy,x,y,z) VALUES " .. table.concat(rows, ","))
                    rows = {}
                end
            end
        end
    end
    if #rows > 0 then WorldDBExecute("INSERT INTO isle_land (gx,gy,x,y,z) VALUES " .. table.concat(rows, ",")) end
    player:SendBroadcastMessage(string.format("|cff00ff96[landscan]|r %d samples, %d land points saved to world.isle_land.", n, land))
    return false
end)
print("[landscan] loaded")
