-- 86770 Champions of Quel'Danas: recruit credit on gossip option select (retail), not on gossip open.
if IS_WORLD_STATE then return end

local MENU = { [236789] = 912046719, [237211] = 912046717, [236657] = 912046718 }  -- Alonsus Faol, Faerin Lothar, Lothraxion
for entry, menu in pairs(MENU) do
    RegisterCreatureGossipEvent(entry, 2, function(_, player, creature, sender, intid)
        if sender == menu and intid == 0 then
            pcall(function() player:KilledMonsterCredit(entry) end)
        end
        return false
    end)
end
print("[midnight_champions] loaded")
