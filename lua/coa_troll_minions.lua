-- Necromancer minion looks (cosmetic only: stats and abilities stay CoA). A look = the display of a retail creature.
-- Each minion has pools per owner race (default pool otherwise); one is picked at random on spawn unless the player chose one: .look <minion> <creatureId> | .look <minion> reset
-- minion keys: lesser greater mage abomination      Troll / Zandalari skeletons also wield a Zandalari Machete + Loa-Blessed Warshield.
local OFF = 7000000
local ENTRY = {lesser = 7050065, greater = 7051065, mage = 7050075, abomination = 7050068, archer = 7050076}
local TROLL = {[8] = true, [31] = true}
local SWORD, SHIELD = 158133, 159813
local DEFAULT_UNDEAD = {785, 1110, 10952, 17902, 18521, 18524, 37012, 47143}

local POOLS = {   -- minion -> race -> creature ids ("any" = fallback)
    lesser = {
        [8] = {255483, 136997, 133120, 135586, 136317, 131805}, [31] = {255483, 136997, 133120, 135586, 136317, 131805},
        [2] = {76264, 76270, 82271, 84327, 124856}, [10] = {76264, 76270, 82271, 84327, 124856},
        [1] = {135514, 138900, 85605, 156330, 158809}, [3] = {154590, 156330}, [7] = {150194, 156330}, [9] = {134444, 156330},
        [5] = {785, 1110, 10952, 17902, 18521, 18524}, any = {156330, 136997, 85605, 785, 10952},
    },
    greater = {
        [8] = {261747, 126107}, [31] = {261747, 126107}, [5] = {1788, 32467, 36877, 37012, 47143},
        any = {1788, 32467, 36877, 165197},
    },
    mage = {[31] = {255571, 16805}, [8] = {255571, 16805}, any = {16805}},
    abomination = {
        [5] = {23562, 23575, 25684, 27605, 28564, 158299, 159499, 162652, 163611, 164617}, [31] = {133007, 246841, 122965},
        [8] = {133007, 28748, 122965}, any = {122965, 158299, 159499, 164617},
    },
}
POOLS.archer = POOLS.lesser   -- Skeletal Archers (3 per Animate: Skeletal Archer, not counted in Life Force) use the skeleton looks, each with a bow
local BOW, ARROW = 2504, 7800609   -- Worn Shortbow, CoA 'Skeletal Arrow'
local SCALE = {[122965] = 0.6}   -- Vol'kaal is huge: 40 % smaller

pcall(CharDBExecute, "CREATE TABLE IF NOT EXISTS characters.coa_minion_look (guid INT UNSIGNED NOT NULL, minion VARCHAR(16) NOT NULL, creature INT UNSIGNED NOT NULL, PRIMARY KEY (guid, minion))")

local displays = {}   -- creature id -> {display ids} (read once from the world DB)
local function Displays(cid)
    if displays[cid] == nil then
        displays[cid] = {}
        local q = WorldDBQuery("SELECT CreatureDisplayID FROM creature_template_model WHERE CreatureID = " .. cid)
        if q then repeat displays[cid][#displays[cid] + 1] = q:GetUInt32(0) until not q:NextRow() end
    end
    return displays[cid]
end

local function Chosen(p, minion)
    local q = CharDBQuery(string.format("SELECT creature FROM characters.coa_minion_look WHERE guid = %s AND minion = '%s'", tostring(p:GetGUIDLow()), minion))
    return q and q:GetUInt32(0) or nil
end

for minion, entry in pairs(ENTRY) do
    RegisterCreatureEvent(entry, 5, function(_, creature)   -- ON_SPAWN
        creature:RegisterEvent(function(_, _, _, c)   -- the owner is set right after spawn
            local o = c:GetOwner()
            if not (o and o.GetRace) then return end
            local race = o:GetRace()
            local pool = POOLS[minion][race] or POOLS[minion].any
            local cid = Chosen(o, minion) or pool[math.random(#pool)]
            local d = Displays(cid)
            if #d > 0 then
                local display = d[math.random(#d)]
                c:SetDisplayId(display)
                pcall(c.SetNativeDisplayId, c, display)
            end
            c:SetScale(SCALE[cid] or 1)
            if minion == "archer" then
                pcall(c.SetEquipmentSlots, c, 0, 0, BOW)
                c:RegisterEvent(function(_, _, _, a)   -- shoot the owner's target (CoA archers: ranged auto attack)
                    local ow = a:GetOwner()
                    local t = ow and (ow:GetVictim() or a:GetVictim())
                    if t and t:IsAlive() and a:IsAlive() and a:GetDistance(t) < 35 then
                        pcall(function() a:SetFacingToObject(t); a:CastSpell(t, ARROW, false) end)
                    end
                end, 2500, 0)
            end
            if TROLL[race] and (minion == "lesser" or minion == "greater") then pcall(c.SetEquipmentSlots, c, SWORD, SHIELD, 0) end
        end, 50, 1)
    end)
end

RegisterPlayerEvent(42, function(_, player, command)   -- .look <minion> <creatureId|reset>
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "look" then return end
    local minion, arg = string.lower(a[2] or ""), a[3]
    if not ENTRY[minion] or not arg then
        player:SendBroadcastMessage("|cff66ccff.look <lesser|greater|mage|abomination> <creatureId|reset>|r")
        return false
    end
    if arg == "reset" then
        CharDBExecute(string.format("DELETE FROM characters.coa_minion_look WHERE guid = %s AND minion = '%s'", tostring(player:GetGUIDLow()), minion))
        player:SendBroadcastMessage("Look reset to random.")
    else
        local cid = tonumber(arg)
        if not cid or #Displays(cid) == 0 then player:SendBroadcastMessage("Unknown creature id."); return false end
        CharDBExecute(string.format("REPLACE INTO characters.coa_minion_look (guid, minion, creature) VALUES (%s, '%s', %d)", tostring(player:GetGUIDLow()), minion, cid))
        player:SendBroadcastMessage("Your " .. minion .. " will look like creature " .. cid .. " from the next raise.")
    end
    return false
end)
print("[coa_minion_looks] loaded")
