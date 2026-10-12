-- Vaults of Atal'Utek (map 2916), quest line "The Honored Med'jai" (95521-95525, 95954).
-- 1) Me'si: spawned with z = 0 (the client QuestPOI table has no height for him), the ground height is read when he appears.
-- 2) The statues and the plaque are credit NPCs in retail; here the guardian statues give the credits when you use them: Let'aka and Gal'fon for "The Unremembered",
--    Thaze'ala's statue for "Guardians of Death, Guardians in Stone". Credits 95522 = retail credit ids 261696 / 261713 / 264434 (from TDB 12.1), 95524 = 262385 ... 262121.
if IS_WORLD_STATE then return end
local function Snap(event, creature)
    if not creature or creature:GetMapId() ~= 2916 then return end
    local x, y, z, o = creature:GetLocation()
    if z and math.abs(z) > 0.5 then return end
    local ok, h = pcall(function() return creature:GetMap():GetHeight(x, y, creature) end)
    if ok and h and h > -500 and h < 2000 then creature:NearTeleport(x, y, h + 0.3, o) end
end
RegisterCreatureEvent(261659, 36, Snap)

local function Credits(player, ids)
    for _, id in ipairs(ids) do player:KilledMonsterCredit(id) end
end
local function Active(player, q) local s = player:GetQuestStatus(q); return s == 3 end   -- QUEST_STATUS_INCOMPLETE
local LETAKA = {262385, 262354, 262374, 262120}
local GALFON = {262283, 262323, 262121}
RegisterCreatureGossipEvent(263214, 1, function(_, player, creature)
    if Active(player, 95524) then
        player:SendBroadcastMessage("|cffffd200The gem glows. Incense burns on the statue of Let'aka, and the guardian is honored.|r")
        Credits(player, LETAKA)
    else player:SendBroadcastMessage("A weathered statue of an Amani guardian. Incense still smoulders at its feet.") end
    player:GossipComplete()
    return true
end)
RegisterCreatureGossipEvent(263215, 1, function(_, player, creature)
    if Active(player, 95524) then
        player:SendBroadcastMessage("|cffffd200You return Gal'fon's bow to the statue. The guardian is honored.|r")
        Credits(player, GALFON)
    else player:SendBroadcastMessage("A weathered statue of an Amani guardian, its bow long gone.") end
    player:GossipComplete()
    return true
end)
-- Thaze'ala (entry 262281) is also the quest giver of 95523: only when 95522 is open the hello grants the statue credits and then the normal quest window opens
RegisterCreatureGossipEvent(262281, 1, function(_, player, creature)
    if Active(player, 95522) then Credits(player, {261696, 261713, 264434}) end
    return false
end)
-- 95523: the Soulcoiler souls (credit 261945) drop from the Revenants; 95954: Jin'tal (credit 263253). The killer and the party members close by get the credit.
local function GroupCredit(killer, credit)
    if not killer or not killer.GetGroup then return end
    local p = killer
    local ok, owner = pcall(function() return killer:GetOwner() end)
    if ok and owner then p = owner end
    if not p.KilledMonsterCredit then return end
    local g = p:GetGroup()
    if g then
        for _, m in ipairs(g:GetMembers()) do if m:GetMapId() == p:GetMapId() and m:GetDistance(p) < 80 then m:KilledMonsterCredit(credit) end end
    else p:KilledMonsterCredit(credit) end
end
RegisterCreatureEvent(261376, 4, function(_, creature, killer) GroupCredit(killer, 261945) end)
RegisterCreatureEvent(263210, 4, function(_, creature, killer) GroupCredit(killer, 263253) end)
print("[medjai] loaded")
