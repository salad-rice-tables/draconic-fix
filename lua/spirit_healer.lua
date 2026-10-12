-- Spirit Healers: the stock hand-over to the client's confirmation dialog does not show on this client, so the dialog is ours (addon/Wildcard/SpiritHealer.lua).
-- Flow: ghost clicks the healer, picks "Return me to life", the window closes and the client asks "take up to 25% durability damage and 10 minutes of
-- Resurrection Sickness?"; on Accept the server (this file) checks that a Spirit Healer is close and resurrects with those penalties.
-- Walking to the corpse still resurrects without any penalty (stock behaviour, untouched).
local TAG = "|cffb0e0ff[Spirit Healer]|r "
local ENTRIES, SET = {}, {}
local ok, q = pcall(WorldDBQuery, "SELECT entry FROM creature_template WHERE name = 'Spirit Healer' AND (npcflag & 16384) = 16384")
if ok and q then repeat local e = q:GetUInt32(0); ENTRIES[#ENTRIES + 1] = e; SET[e] = true until not q:NextRow() end

local function Hello(_, player, creature)
    player:GossipClearMenu()
    if player:IsAlive() then player:GossipMenuAddItem(0, "I am not dead. (Come back when you are.)", 0, 0)
    else player:GossipMenuAddItem(0, "Return me to life.", 0, 1) end
    player:GossipSendMenu(1, creature)
end
local function Select(_, player, creature, _, intid)
    player:GossipComplete()
    if intid ~= 1 or player:IsAlive() then return end
    pcall(function() player:SendAddonMessage("WCARD", "SPIRITASK", 7, player) end)
end
for _, e in ipairs(ENTRIES) do
    RegisterCreatureGossipEvent(e, 1, Hello)
    RegisterCreatureGossipEvent(e, 2, Select)
end

RegisterServerEvent(30, function(_, sender, _, prefix, msg)   -- addon message
    if prefix ~= "WCARD" or msg ~= "SPIRITRES" then return end
    local ok1, isPlayer = pcall(function() return sender:GetGUIDLow() ~= nil and sender.LearnSpell ~= nil end)
    if not ok1 or not isPlayer or sender:IsAlive() then return end
    local near = false
    for _, e in ipairs(ENTRIES) do if sender:GetNearestCreature(15, e) then near = true break end end
    if not near then sender:SendBroadcastMessage(TAG .. "You are too far from a Spirit Healer."); return end
    sender:ResurrectPlayer(50, true)           -- half health and mana, with Resurrection Sickness
    pcall(function()                           -- the game scales the sickness down with the level: always the full ten minutes, as the window says
        local aura = sender:GetAura(15007)
        if aura then aura:SetDuration(600000); aura:SetMaxDuration(600000) end
    end)
    pcall(function() sender:DurabilityLossAll(0.25, true) end)   -- 25% durability, equipped and inventory
    sender:SendBroadcastMessage(TAG .. "The spirit healer returns you to life. You take 25% durability damage and Resurrection Sickness.")
end)
print("[spirit_healer] registered for " .. #ENTRIES .. " entries")
