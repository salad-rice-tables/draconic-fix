-- GM test: .night prepne noc pre living-world systemy (hliadky, fakle, taverny,
-- night buffy). Citaju to vsetky lokalne IsNight() cez world.lw_state force_night.
-- POZOR: obloha ostava podla realneho casu (klient), toto prepina len logiku.
-- Vypnutie: .night znova (prepina 1/0). Ziadny restart netreba (.reload eluna staci).
if IS_WORLD_STATE then return end

RegisterPlayerEvent(42, function(_, player, command)
    if (command or "") ~= "night" then return end
    local okR, rank = pcall(function() return player:GetGMRank() end)
    if not okR or (rank or 0) < 1 then return end
    local ok, r = pcall(WorldDBQuery, "SELECT v FROM world.lw_state WHERE k = 'force_night'")
    local cur = (ok and r) and r:GetString(0) or "0"
    local nv = (cur == "1") and "0" or "1"
    pcall(WorldDBExecute, string.format("REPLACE INTO world.lw_state (k, v) VALUES ('force_night', '%s')", nv))
    player:SendBroadcastMessage("|cffffd200[Night]|r Testovacia noc: " .. (nv == "1" and "ZAPNUTA (do 30 s nabehne)" or "VYPNUTA (do 30 s)") .. ". Obloha ostava podla realneho casu.")
    return false
end)
print("[gm_night] .night toggle loaded")
