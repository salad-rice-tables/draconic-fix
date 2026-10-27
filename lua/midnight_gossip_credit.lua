-- Midnight main campaign: credit "speak to" objectives on gossip OPTION select (retail), not on gossip open.
if IS_WORLD_STATE then return end

-- entry = { MenuID, OptionID }
local NPC = {
    [239349] = { 38390, 0 },        -- Riftblade Maella
    [235664] = { 912046918, 0 },    -- Alleria Windrunner
    [235522] = { 38425, 0 },        -- Lothraxion
    [244840] = { 912046750, 1 },    -- Quartermaster Lymel
    [239457] = { 912046749, 1 },    -- Guard Captain Leonic
    [239406] = { 912046752, 1 },    -- Ranger Belonis
    [242568] = { 912046751, 1 },    -- Matron Narsilla
    [251540] = { 912046763, 0 },    -- Apprentice Erilia
    [251542] = { 912046762, 0 },    -- Outrunner Alarion
    [251539] = { 912046764, 0 },    -- Magistrix Silanna
    [251543] = { 912046761, 0 },    -- Trainee Solanin
    [240936] = { 912046732, 1 },    -- Guard Captain Goldblade
    [248629] = { 912046731, 1 },    -- General Amias Bellamy
    [236149] = { 25248, 2 },        -- Innkeeper Kalarin (86624)
    [239630] = { 25248, 2 },        -- Innkeeper Jovia (86735/86736)
}
-- Rational Explanation (86624): each questioned townsperson also counts for credit 239460
local ASKED = {}
local TOWNSFOLK = { [239457]=true, [239406]=true, [242568]=true, [244840]=true }
for entry, m in pairs(NPC) do
    RegisterCreatureGossipEvent(entry, 2, function(_, player, creature, sender, intid)
        if sender == m[1] and intid == m[2] then
            pcall(function() player:KilledMonsterCredit(entry) end)
            if TOWNSFOLK[entry] then
                local key = tostring(player:GetGUIDLow()) .. ":" .. entry
                if not ASKED[key] then ASKED[key] = true; pcall(function() player:KilledMonsterCredit(239460) end) end
            end  -- 86624 "Townsfolk questioned"
        end
        return false
    end)
end
print("[midnight_gossip_credit] loaded")


-- Magistrix Nizara (86736 "Check in with Magistrix Nizara"): retail option text unknown, credit on hello (vendor menu only)
RegisterCreatureGossipEvent(240940, 1, function(_, player, creature)
    pcall(function() player:KilledMonsterCredit(240940) end)
    return false
end)
