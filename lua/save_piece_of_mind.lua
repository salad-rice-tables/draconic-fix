-- =====================================================================
-- Quest 86558 Save a Piece of Mind v1: loci GO-use + accept scena + Arator gossip (DB).
-- Loci 524828 (3x, mapa 2771): use -> marker podla polohy (Darkglen 240249 / Astre 240252 /
-- Maella 240244) + Darkglen say (speaker pri loci). Ostatne says bez speakrov = follow-up.
-- Accept scena (Wiki Notes, Sanctum): Everdawn say (Maella par skip - chyba speaker).
-- Arator gossip (Wiki verbatim): DB menu 40204 (custom broadcast 9900152).
-- Odmeny (gear 260836-39) uz v DB. DB: Custom/sql/20261016_abyss655758.sql (+undo).
-- Follow-up: Maella/Astre says (speakri), scout split-up pohyb, Everdawn odchod.
-- =====================================================================
if IS_WORLD_STATE then return end

-- locus XY -> marker (DB guids: 478=(1668.9,1274.2) Astre, 938=(1718.6,1121.8) Darkglen, 939=(1577,1119.5) Maella)
local LOCI = {
    { x = 1668.9, y = 1274.2, credit = 240252 },
    { x = 1718.6, y = 1121.8, credit = 240249 },
    { x = 1577.0, y = 1119.5, credit = 240244 },
}

local function SayAt(player, entry, range, delayMs, text)
    text = text:gsub("<name>", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86558] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                pcall(function() PrintInfo("[ds86558] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86558] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function LocusUse(_, player, go)
    local okQ, st = pcall(function() return player:GetQuestStatus(86558) end)
    if not (okQ and st == STATUS_INCOMPLETE) then return true end
    local okX, gx = pcall(function() return go:GetX() end)
    local okY, gy = pcall(function() return go:GetY() end)
    if not (okX and okY) then return true end
    local best, bestD = nil, 60
    for _, l in ipairs(LOCI) do
        local d = math.sqrt((gx - l.x) * (gx - l.x) + (gy - l.y) * (gy - l.y))
        if d < bestD then best, bestD = l, d end
    end
    if not best then return true end
    pcall(function() player:KilledMonsterCredit(best.credit) end)
    pcall(function() PrintInfo(string.format("[ds86558] locus use credit=%d player=%s", best.credit, player:GetName())) end)
    if best.credit == 240249 then
        SayAt(player, 239616, 80, 2000, "Fear not for my sanity, <name>. My minion and I are well used to such madness.", 321966)  -- bt 289002 kit2 vo_120_generic_lady_darkglen_21
    end
    return true
end
pcall(RegisterGameObjectGossipEvent, 524828, 1, LocusUse)

RegisterCreatureEvent(235411, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86558) then return end
    pcall(function() PrintInfo("[ds86558] quest accepted by " .. player:GetName()) end)
    SayAt(player, 240831, 80, 3000, "We must scout... yes. Yes, scout ahead...", 300652)  -- bt 283094 kit2 vo_120_voidlight_everdawn_02
end)

print("[save_piece_of_mind] loaded")
