-- CoA companion "Book of Ascension" (class trainer, creature 1488001) follows every CoA-class player.
-- (The Book of Artisans stays a minipet: Midnight allows only one minipet, so the second book is a follower creature.)
if not COA_SLOT_KEY then return end
local BOOK = 1488001
local mine = {}   -- player guid string -> book creature guid

local function Spawn(p)
    local ok, c = pcall(function() return p:SpawnCreature(BOOK, p:GetX() + 2, p:GetY() + 2, p:GetZ(), p:GetO(), 8, 0) end)   -- 8 = manual despawn
    if ok and c then
        pcall(function() c:SetOwnerGUID(p:GetGUID()) end)
        pcall(function() c:MoveFollow(p, 2.5, 1.6) end)
        mine[tostring(p:GetGUIDLow())] = c:GetGUID()
    end
end

local function Check(p)
    if not p or not p:IsInWorld() or not COA_KEY(p) then return end
    local key = tostring(p:GetGUIDLow())
    local book
    if mine[key] then
        local ok, o = pcall(function() return p:GetMap():GetWorldObject(mine[key]) end)
        book = ok and o or nil
    end
    if book and book:IsInWorld() and book:GetMapId() == p:GetMapId() and book:GetDistance(p) < 60 then return end
    if book then pcall(function() book:DespawnOrUnsummon(0) end) end   -- too far / other map: fetch a fresh one
    Spawn(p)
end

RegisterPlayerEvent(28, function(_, player)   -- enter world (map state): fetch the book now, then keep it close every 15 s
    player:RegisterEvent(function(_, _, _, p)
        Check(p)
        if p then p:RegisterEvent(function(_, _, _, pl) Check(pl) end, 15000, 0) end
    end, 6000, 1)
end)
print("[coa_books] loaded")
