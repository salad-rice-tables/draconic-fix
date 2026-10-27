-- 86644 Gods Before Us: Carved Tile memory puzzle (retail, per user description)
-- 9 Carved Tiles (creature 236650): click reveals a rune creature above the tile (no gossip). One tile casts Hex (frog) on the player.
-- Pairs of runes: red dragonhawk, purple lynx, white eagle, green bear. Mismatch hides both runes, match keeps them and spawns a third rune.
local QUEST, TILE, ARATOR = 86644, 236650, 236610
local HEX, MARKER = 1239172, 1254243
local RUNE = { red = 244879, purple = 244877, white = 240703, green = 240701 }
local MATCH_CREDIT = { red = 240689, purple = 240695, white = 240705, green = 240706 }
local TILES_CREDIT = 240667

-- tile spawn guid (DB) -> kind
local TILE_KIND = {
    ["3000209891"] = "hex",
    ["3000209889"] = "red",   ["3000209883"] = "red",
    ["3000209884"] = "purple", ["3000209887"] = "purple",
    ["3000209890"] = "white", ["3000209888"] = "white",
    ["3000209885"] = "green", ["3000209886"] = "green",
}
-- third rune shown when a pair is matched (x, y, z)
local THIRD = {
    red    = { 6012.2153, -4900.521, 192.84097 },
    purple = { 6010.7656, -4914.251, 192.84097 },
    white  = { 6012.0796, -4900.1724, 196.34798 },
    green  = { 6010.5674, -4914.0063, 196.34798 },
}

local state = {}   -- [playerGuidLow string] = { first = tileGuid, shown = {}, matched = {}, pairs = 0, lock = false }

local function st(player)
    local k = tostring(player:GetGUIDLow())
    state[k] = state[k] or { first = nil, shown = {}, matched = {}, pairs = 0, lock = false, tiles = {} }
    return state[k]
end

local function untouchable(c)
    pcall(function() c:SetDisableGravity(true) end)
    pcall(function() c:SetCanFly(true) end)
    pcall(function() c:SetHover(true) end)
    pcall(function() c:SetUnitFlag(0x2000000) end)  -- NOT_SELECTABLE
    pcall(function() c:SetUnitFlag(0x2) end)        -- NON_ATTACKABLE
    pcall(function() c:SetUnitFlag(0x4000) end)     -- UNINTERACTIBLE
    pcall(function() c:SetNPCFlags(0) end)
end

local function runeNear(tile, entry)
    return tile:GetNearestCreature(4, entry)
end

local function hideRune(tile, kind)
    local r = tile:GetNearestCreature(4, RUNE[kind])
    PrintInfo("[gbu] hideRune "..tostring(kind).." found="..tostring(r ~= nil))
    if r then r:DespawnOrUnsummon(0) end
end

local function showRune(tile, kind)
    local x, y, z, o = tile:GetX(), tile:GetY(), tile:GetZ(), tile:GetO()
    local c = tile:SpawnCreature(RUNE[kind], x, y, z + 2.1, o, 3, 1800000)
    if c then untouchable(c) end
end

local function spawnThird(player, kind)
    local p = THIRD[kind]
    local c = player:SpawnCreature(RUNE[kind], p[1], p[2], p[3], 0, 3, 1800000)
    if c then untouchable(c) end
end

local function onTileClick(event, player, tile)
    player:GossipComplete()
    if not player:HasQuest(QUEST) then return true end
    local s = st(player)
    local id = tostring(tile:GetDBTableGUIDLow())
    local kind = TILE_KIND[id]
    PrintInfo("[gbu] click "..id.." kind="..tostring(kind).." first="..tostring(s.first).." lock="..tostring(s.lock).." shown="..tostring(s.shown[id]))
    if not kind or s.lock or s.matched[id] or s.shown[id] then return true end

    if kind == "hex" then
        player:AddAura(HEX, player)
        return true
    end

    showRune(tile, kind)
    s.shown[id] = true
    s.tiles[id] = tile
    if not s.first then
        s.first = id
        return true
    end

    local firstId = s.first
    local firstTile = s.tiles[firstId]
    s.first = nil
    if TILE_KIND[firstId] == kind then
        s.matched[firstId] = true
        s.matched[id] = true
        s.pairs = s.pairs + 1
        player:KilledMonsterCredit(MATCH_CREDIT[kind], 0)
        spawnThird(player, kind)
        if s.pairs >= 4 then
            player:KilledMonsterCredit(TILES_CREDIT, 0)
            -- final Arator line is driven by quest SAI (objective 459563 complete)
        end
    else
        s.lock = true
        local k1 = TILE_KIND[firstId]
        tile:RegisterEvent(function(_, _, _, t)
            if firstTile then hideRune(firstTile, k1) end
            hideRune(t, kind)
            s.shown[firstId] = nil
            s.shown[id] = nil
            s.lock = false
        end, 1500, 1)
    end
    return true
end
RegisterCreatureGossipEvent(TILE, 1, onTileClick)

-- fresh puzzle state whenever the quest is (re)accepted; Arator stops following when it is abandoned
RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= QUEST then return end
    PrintInfo("[gbu] quest status "..tostring(status))
    state[tostring(player:GetGUIDLow())] = nil
    if status == 0 then
        local ar = player:GetNearestCreature(300, ARATOR)
        if ar then ar:MoveClear(); ar:MoveHome() end
    elseif status == 3 then
        for _, entry in pairs(RUNE) do
            for _, c in pairs(player:GetCreaturesInRange(150, entry) or {}) do c:DespawnOrUnsummon(0) end
        end
    end
end)
