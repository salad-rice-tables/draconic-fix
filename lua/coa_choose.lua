-- Conquest Hero (creation slot 13): after the character is created, the player picks any of the 21 Conquest of Azeroth classes in a gossip window.
-- The choice is stored in characters.wildcard_coa (name, class) and COA_KEY(player) (coa_class_slots.lua) returns it, so every CoA script treats the
-- character exactly like a creation-screen class. Spells are learned by coa_necromancer_main.lua (COA_LEARN) by level.
local MENU = 9900200
local function Key(p) return COA_KEY and COA_KEY(p) end
local function Esc(s) return (string.gsub(s or "", "'", "''")) end

local function Ask(player)
    player:GossipClearMenu()
    for i, c in ipairs(COA_CLASSES or {}) do
        player:GossipMenuAddItem(0, "|cffc41e3a" .. c.name .. "|r - " .. (c.desc or ""), 0, i, false, "Become a " .. c.name .. " for good?")
    end
    player:GossipSendMenu(1, player, MENU)
end

RegisterPlayerEvent(3, function(_, player)   -- ON_LOGIN (fires in the world state)
    if player:GetClass() ~= 13 or Key(player) then return end
    player:RegisterEvent(function(_, _, _, p)
        if p and p:IsInWorld() and not Key(p) then
            p:SendBroadcastMessage("|cffc41e3a[Conquest]|r Choose your Conquest of Azeroth class.")
            Ask(p)
        end
    end, 5000, 1)
end)

RegisterPlayerGossipEvent(MENU, 2, function(_, player, _, sender, intid)
    player:GossipComplete()
    if player:GetClass() ~= 13 or Key(player) then return end
    local c = (COA_CLASSES or {})[intid]
    if not c then return end
    pcall(CharDBExecute, string.format("REPLACE INTO characters.wildcard_coa (name, class) VALUES ('%s', '%s')", Esc(player:GetName()), c.key))
    if COA_CHOSEN then COA_CHOSEN[player:GetName()] = c.key end
    player:SendBroadcastMessage("|cffc41e3a[Conquest]|r You are now a |cffc41e3a" .. c.name .. "|r. " .. (c.desc or ""))
end)

-- map state: spells follow a few seconds after the choice (the choice is made in the world state)
RegisterPlayerEvent(28, function(_, player)
    if player:GetClass() ~= 13 then return end
    local tries = 0
    local function Poll(_, _, _, p)
        tries = tries + 1
        if not (p and p:IsInWorld()) then return end
        if Key(p) then if COA_LEARN then COA_LEARN(p) end return end
        if tries < 120 then p:RegisterEvent(Poll, 5000, 1) end
    end
    player:RegisterEvent(Poll, 8000, 1)
end)
