-- Living-world events that cost nothing between triggers: the Mysterious Wanderer (Fridays 20:00, one hour, hidden spot with a riddle)
-- and the Ancient Treasure Chests (daily 12:00, three chests hidden in the world). Everything is local to this file.
local TAG = "|cffffd200[Azeroth]|r "
local WANDERER, CHEST = 9903960, 9712520
local SPOTS = {   -- {zone name for the riddle, map, x, y, z}: spots on open ground
  {"Stonetalon Mountains", 1, 935.4, 631.2, 101.6, "Wind and stone, where the sky is thin."},
  {"Duskwood", 0, -10516.0, -1161.2, 28.1, "Where the night never really ends."},
  {"Durotar", 1, 338.6, -4038.4, 24.0, "Red dust, and the smell of old fires."},
  {"Deadwind Pass", 0, -11370.6, -2165.6, 22.3, "Beneath a tower that no one visits."},
  {"Felwood", 1, 4941.7, -740.2, 308.5, "Where the trees have turned and the air is thick."},
  {"Moonglade", 1, 7538.1, -3048.5, 463.4, "A quiet pool under a silver sky."},
  {"Tirisfal Glades", 0, 2400.1, 275.8, 28.9, "Among the pale fields, where the dead walk freely."},
  {"Camp Narache", 1, -3131.7, -30.6, 47.6, "Hooves and drums, on a mesa."},
}
-- what the Wanderer sells for gold (copper): a Hero item for each purse
local WARES = {
  {"Dice of Destiny", 9750003, 500000, "Roll the dice again."},
  {"Token of Prestige", 9750004, 1000000, "A mark of those who started over."},
  {"Ability Purge", 9750001, 200000, "Take back every ability."},
  {"Talent Purge", 9750002, 200000, "Take back every talent."},
  {"Bonzo Bolt", 9750006, 2000000, "Fifty gold for the Mystic Forge."},
}
local WORLD = (GetStateMapId and GetStateMapId() == -1)

if WORLD then
    local last = {wander = "", chests = ""}
    local function Announce(msg) pcall(SendWorldMessage, TAG .. msg) end
    CreateLuaEvent(function()
        local t = os.date("*t")
        local stamp = t.year .. "-" .. t.yday
        if t.wday == 6 and t.hour == 20 and t.min == 0 and last.wander ~= stamp then
            last.wander = stamp
            local s = SPOTS[math.random(#SPOTS)]
            local ok = pcall(PerformIngameSpawn, 1, WANDERER, s[2], 0, s[3], s[4], s[5], 0, false, 3600000)
            if ok then Announce("|cffffffffA Mysterious Wanderer has arrived for one hour. \"" .. s[6] .. "\"|r") end
        end
        if t.hour == 12 and t.min == 0 and last.chests ~= stamp then
            last.chests = stamp
            local used = {}
            for i = 1, 3 do
                local s
                repeat s = SPOTS[math.random(#SPOTS)] until not used[s] or #used >= #SPOTS
                used[s] = true
                local dx, dy = math.random(-60, 60), math.random(-60, 60)
                -- no runtime GameObject spawn: PerformIngameSpawn on a map with no players loaded crashes this core (GameObject::AddToWorld without a map)
            end
            Announce("|cffffffffThe wind whispers that three ancient chests were hidden in the lands of Azeroth.|r")
        end
    end, 60 * 1000, 0)
else
    -- the Wanderer sells through a gossip menu so the prices are ours
    pcall(RegisterCreatureGossipEvent, WANDERER, 1, function(_, player, creature)
        player:GossipClearMenu()
        for i, w in ipairs(WARES) do
            player:GossipMenuAddItem(0, w[1] .. " (" .. math.floor(w[3] / 10000) .. " gold) - " .. w[4], 0, i, false, "Buy " .. w[1] .. "?", w[3])
        end
        player:GossipSendMenu(1, creature)
    end)
    pcall(RegisterCreatureGossipEvent, WANDERER, 2, function(_, player, creature, _, intid)
        player:GossipComplete()
        local w = WARES[intid]
        if not w then return end
        if player:GetCoinage() < w[3] then player:SendBroadcastMessage(TAG .. "Not enough gold."); return end
        player:ModifyMoney(-w[3])
        player:AddItem(w[2], 1)
        player:SendBroadcastMessage(TAG .. "You bought " .. w[1] .. ".")
    end)
    -- the chests
    pcall(RegisterGameObjectEvent, CHEST, 14, function(_, go, player)
        if not player then return true end
        local lvl = player:GetLevel()
        player:ModifyMoney(lvl * 30000)
        player:AddItem(9750006, 1)                              -- Bonzo Bolt
        if math.random(100) <= 25 then player:AddItem(9750003, 1) end   -- sometimes the Dice of Destiny
        player:SendBroadcastMessage(TAG .. "|cff40ff40You found an ancient chest!|r " .. lvl * 300 .. " silver and a Bonzo Bolt.")
        pcall(SendWorldMessage, TAG .. player:GetName() .. " found an ancient chest!")
        go:Despawn()
        return true
    end)
end
