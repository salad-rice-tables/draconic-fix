-- City teleports are found, not rolled: the Teleport spell of a city is learned the first time you step into that city.
-- (Before, the Hero system gave them out of boss kills; Wildcard never drafts them.) Self-contained.
local TAG = "|cff69ccf0[Teleport]|r "
local CITY = {   -- spell -> area ids that count as arriving in that city
  [3561] = {1519,8234,8456,9553,9672},   -- Teleport: Stormwind
  [3562] = {1537},   -- Teleport: Ironforge
  [3563] = {1497,9959},   -- Teleport: Undercity
  [3565] = {1657},   -- Teleport: Darnassus
  [3566] = {1638,5345},   -- Teleport: Thunder Bluff
  [3567] = {1637,11402},   -- Teleport: Orgrimmar
  [18960] = {493,8092},   -- Teleport: Moonglade
  [32271] = {3557,8277,8700,8842},   -- Teleport: Exodar
  [32272] = {9313,15969,16311,16666,16773},   -- Teleport: Silvermoon (Burning Crusade)
  [49358] = {75},   -- Teleport: Stonard
  [49359] = {513,6042,6502,8839},   -- Teleport: Theramore
  [53140] = {4395,6611,7502,7881,8589,15177},   -- Teleport: Dalaran - Northrend
  [88342] = {5095,5389,8309},   -- Teleport: Tol Barad
  [88344] = {5095,5389,8309},   -- Teleport: Tol Barad
  [120145] = {4395,6611,7502,7881,8589,15177},   -- Ancient Teleport: Dalaran
  [132621] = {5840,6651,6733,9105},   -- Teleport: Vale of Eternal Blossoms
  [132627] = {5840,6651,6733,9105},   -- Teleport: Vale of Eternal Blossoms
  [176242] = {7333},   -- Teleport: Warspear
  [176248] = {7332},   -- Teleport: Stormshield
  [193759] = {7879},   -- Teleport: Hall of the Guardian
  [224869] = {4395,6611,7502,7881,8589,15177},   -- Teleport: Dalaran - Broken Isles
  [281403] = {8568,8717,10364,13548},   -- Teleport: Boralus
  [281404] = {8670,9571,10371},   -- Teleport: Dazar'alor
  [344587] = {10565,13863},   -- Teleport: Oribos
  [395277] = {13862},   -- Teleport: Valdrakken
  [446540] = {14771},   -- Teleport: Dornogal
  [1259190] = {9313,15969,16311,16666,16773},   -- Teleport: Silvermoon City
  [33690] = {3703},   -- Teleport: Shattrath
  [35715] = {3703},   -- Teleport: Shattrath
}
-- area id -> spells
local BY_AREA = {}
for spell, areas in pairs(CITY) do
    for _, a in ipairs(areas) do BY_AREA[a] = BY_AREA[a] or {}; table.insert(BY_AREA[a], spell) end
end
local function Check(player)
    if not player or not player:IsInWorld() then return end
    local list = BY_AREA[player:GetAreaId()] or BY_AREA[player:GetZoneId()]
    if not list then return end
    for _, spell in ipairs(list) do
        if not player:HasSpell(spell) then
            pcall(function() player:LearnSpell(spell) end)
            player:SendBroadcastMessage(TAG .. "You have learned a new way home: a city teleport.")
        end
    end
end
RegisterPlayerEvent(27, function(_, player) Check(player) end)   -- zone change
RegisterPlayerEvent(28, function(_, player) player:RegisterEvent(function(_, _, _, p) Check(p) end, 3000, 1) end)   -- map change / login
