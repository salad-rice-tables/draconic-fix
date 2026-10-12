-- Gravestones of the fallen: when a player dies in the open world, a gravestone stands where they fell for one hour.
-- Anyone who clicks it reads who fell, to what and when. Only reacts to deaths and clicks; no timers. Self-contained.
local TAG = "|cffb0b0b0[Gravestone]|r "
local GRAVE = 9712521
local TEXT = {}          -- gravestone guid -> inscription (lost on restart together with the stone)

local function Fell(killed, by)
    local ok = pcall(function()
        if killed:GetLevel() < 10 then return end
        local map = killed:GetMap()
        if map:IsDungeon() or map:IsRaid() or map:IsBattleground() then return end
        local go = killed:SummonGameObject(GRAVE, killed:GetX(), killed:GetY(), killed:GetZ(), killed:GetO(), 3600)
        if not go then return end
        local class = ({"Warrior", "Paladin", "Hunter", "Rogue", "Priest", "Death Knight", "Shaman", "Mage", "Warlock", "Monk", "Druid", "Demon Hunter", "Evoker"})[killed:GetClass()] or "Hero"
        TEXT[go:GetGUIDLow()] = "Here fell " .. class .. " " .. killed:GetName() .. " (level " .. killed:GetLevel() .. "), struck down by " .. (by or "an unknown foe") .. " at " .. os.date("%H:%M") .. "."
    end)
end
RegisterPlayerEvent(8, function(_, killer, killed) Fell(killed, killer and killer:GetName()) end)   -- killed by creature
RegisterPlayerEvent(6, function(_, killer, killed) Fell(killed, killer and killer:GetName()) end)   -- killed by player

pcall(RegisterGameObjectEvent, GRAVE, 14, function(_, go, player)
    if not player then return true end
    player:SendBroadcastMessage(TAG .. (TEXT[go:GetGUIDLow()] or "The inscription has faded."))
    pcall(function() player:AddAura(2379, player) end)   -- a short burst of speed: a moment of respect
    return true
end)
