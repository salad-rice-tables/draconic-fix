-- Logs the difficulty of every dungeon/raid instance a player enters (to see which spawnDifficulties the custom dungeons need)
RegisterPlayerEvent(28, function(_, player)   -- ON_MAP_CHANGE
    local ok, map = pcall(function() return player:GetMap() end)
    if not ok or not map then return end
    local ok2, diff = pcall(function() return map:GetDifficulty() end)
    local ok3, inst = pcall(function() return map:IsDungeon() or map:IsRaid() end)
    if ok3 and inst then print("[difficulty] " .. player:GetName() .. " entered map " .. tostring(player:GetMapId()) .. " difficulty " .. tostring(ok2 and diff or "?")) end
end)
