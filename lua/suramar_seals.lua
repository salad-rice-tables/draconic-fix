-- 42225 Breaking the Seal: the two arcane coils (tall / short beam) cycle their beam over the three seals;
-- with both beams on one seal it can be broken, and a Moonfall Stalker drops from the webbing.
local Q = 42225
local COIL_TALL, COIL_SHORT = 9108872, 9108873
local SEALS = { [9108874] = { "Tides", 107816 }, [9108875] = { "Earth", 107817 }, [9108876] = { "Sky", 107818 } }
local ORDER = { 9108874, 9108875, 9108876 }
local STALKER = 107398
local CREDIT_BEAM = 102760

local st = {}
local function S(p) local k = tostring(p:GetGUIDLow()); st[k] = st[k] or { broken = {} }; return st[k] end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId == Q then st[tostring(player:GetGUIDLow())] = nil end
end)

local function coil(which)
    return function(event, player, go)
        if not player:HasQuest(Q) then return false end
        local s = S(player)
        s[which] = ((s[which] or 0) % 3) + 1
        local name = SEALS[ORDER[s[which]]][1]
        player:SendBroadcastMessage("The " .. (which == "tall" and "tall blue" or "short purple") .. " beam now strikes the Seal of the " .. name .. ".")
        if not s["c" .. which] then s["c" .. which] = true; player:KilledMonsterCredit(CREDIT_BEAM, 0) end
        return true
    end
end
RegisterGameObjectGossipEvent(COIL_TALL, 1, coil("tall"))
RegisterGameObjectGossipEvent(COIL_SHORT, 1, coil("short"))

for entry, info in pairs(SEALS) do
    RegisterGameObjectGossipEvent(entry, 1, function(event, player, go)
        if not player:HasQuest(Q) then return false end
        local s = S(player)
        if s.broken[entry] then return true end
        local idx
        for i, e in ipairs(ORDER) do if e == entry then idx = i end end
        if s.tall ~= idx or s.short ~= idx then
            player:SendBroadcastMessage("The seal holds. Both beams must be focused on it.")
            return true
        end
        s.broken[entry] = true
        player:KilledMonsterCredit(info[2], 0)
        local x, y, z, o = go:GetLocation()
        local m = player:SpawnCreature(STALKER, x, y, z + 2, o, 8, 60000)
        if m then m:AttackStart(player) end
        return true
    end)
end
