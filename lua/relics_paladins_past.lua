-- 86841 Relics of Paladins Past: "Enter Light's Hope Chapel" credit (246279) when the player is inside the chapel areas
local QUEST, CREDIT = 86841, 246279
local AREAS = { [2268] = true, [7638] = true, [8357] = true }

local function check(player, area)
    if player:HasQuest(QUEST) and AREAS[area] then
        player:KilledMonsterCredit(CREDIT, 0)
    end
end

RegisterPlayerEvent(47, function(event, player, newZone, newArea) check(player, newArea) end)
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == QUEST and status == 3 then
        player:RegisterEvent(function(_, _, _, p) check(p, p:GetAreaId()) end, 1500, 1)
    end
end)
