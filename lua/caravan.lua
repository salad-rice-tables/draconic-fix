-- Supply Caravan: every 40 minutes a caravan leaves Razor Hill for Sen'jin Village. Raiders attack it on the way; players escort it.
-- Delivered: everyone near it gets a reward. Destroyed: the zone is told. Self-contained; starts from Orgnil Soulscar's spawn.
local TAG = "|cffffd200[Caravan]|r "
local ORGNIL = 3142
local CARAVAN = 9903950
local RAIDERS = {9903020, 9903021}               -- Khansguard raiders (custom hostile clones)
local DEST = {x = -812.0, y = -4915.0, z = 19.7}  -- Sen'jin Village, by Master Gadrin
local EVERY = 40 * 60 * 1000
local WAVE = 70 * 1000
local active = nil                                -- the current caravan (guid) or nil

local function Near(c, range)
    local out = {}
    local ok, list = pcall(function() return c:GetPlayersInRange(range) end)
    if ok and list then for _, p in ipairs(list) do out[#out + 1] = p end end
    return out
end

local function Launch(orgnil)
    if active then return end
    if not orgnil or not orgnil:IsInWorld() then return end
    if #Near(orgnil, 120) == 0 then return end      -- no one around to escort it: wait for the next time
    local x, y, z = orgnil:GetX() + 6, orgnil:GetY() - 6, orgnil:GetZ()
    local c = orgnil:SpawnCreature(CARAVAN, x, y, z, orgnil:GetO(), 1, 1500000)
    if not c then return end
    active = c:GetGUIDLow()
    pcall(function()
        c:SetScale(1.4); c:SetMaxHealth(60000); c:SetHealth(60000); c:SetWalk(true); c:SetLevel(20)
        c:SetNPCFlags(0)
        c:MoveTo(1, DEST.x, DEST.y, DEST.z)
        c:SendUnitYell("The supply caravan departs for Sen'jin Village! Guard it well!", 0)
    end)
    for _, p in ipairs(Near(c, 120)) do p:SendBroadcastMessage(TAG .. "The supply caravan leaves Razor Hill for Sen'jin Village. Escort it and the town will thank you.") end
    -- raiders every wave; checks for arrival and defeat
    c:RegisterEvent(function(_, _, _, car)
        if not car or not car:IsInWorld() then return end
        if not car:IsAlive() then
            active = nil
            for _, p in ipairs(Near(car, 150)) do p:SendBroadcastMessage(TAG .. "|cffff4040The caravan was destroyed!|r Razor Hill will have to wait for the next one.") end
            return
        end
        local dx, dy = car:GetX() - DEST.x, car:GetY() - DEST.y
        if dx * dx + dy * dy < 30 * 30 then
            active = nil
            car:SendUnitYell("The supplies have arrived! Sen'jin thanks you!", 0)
            for _, p in ipairs(Near(car, 80)) do
                p:ModifyMoney(p:GetLevel() * 8000)
                p:SendBroadcastMessage(TAG .. "|cff40ff40The caravan arrived!|r Reward: " .. p:GetLevel() * 80 .. " silver.")
            end
            car:DespawnOrUnsummon(15000)
            return
        end
        local ps = Near(car, 60)
        if #ps == 0 then return end
        for i = 1, 2 do
            local ang = math.random() * 6.2832
            local rx, ry = car:GetX() + 22 * math.cos(ang), car:GetY() + 22 * math.sin(ang)
            local r = car:SpawnCreature(RAIDERS[math.random(#RAIDERS)], rx, ry, car:GetMap():GetHeight(rx, ry) or car:GetZ(), ang + 3.14, 1, 120000)
            if r then pcall(function() r:SetLevel(math.max(8, ps[1]:GetLevel())); r:AttackStart(car) end) end
        end
    end, WAVE, 0)
end

pcall(RegisterCreatureEvent, ORGNIL, 5, function(_, orgnil)    -- ON_SPAWN
    orgnil:RegisterEvent(function(_, _, _, o) Launch(o) end, EVERY, 0)
end)
