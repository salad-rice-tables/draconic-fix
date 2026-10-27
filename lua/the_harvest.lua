-- =====================================================================
-- Quest 86512 The Harvest v1 (Wiki Notes: accept-both scena + Torentia yell).
--  1) hrac prijme 86512 aj 86513 -> Decimus line "Break her toys..." (bcast 283749, kit 301081).
--  2) bar na 100 % -> Torentia yell "Filthy upstart! You'll bleed out like the rest."
--     (Wiki; retail bcast 287857 + dabing kit 301047 = vo_120_torentia_01_f.ogg, whisper overený).
--  DB: Custom/sql/20261017_abyss1213.sql (+undo). Texty Wiki verbatim.
-- =====================================================================
if IS_WORLD_STATE then return end

local KILL_SET = {
    [235638]=true, [235639]=true, [240736]=true, [238163]=true,
    [235640]=true, [242750]=true, [238162]=true, [240089]=true,
}

local SaidAt = {}

local function OnCooldown(player, key, cd)
    local k = player:GetName() .. ":" .. key
    local prev = SaidAt[k] or 0
    if os.time() - prev < (cd or 600) then return true end
    SaidAt[k] = os.time()
    return false
end

local function QStatus(player, q)
    local ok, st = pcall(function() return player:GetQuestStatus(q) end)
    return (ok and st) or -1
end

local function SayAt(player, entry, range, delayMs, text, kit, yell)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range, entry) end)
        if ok and list then
            for _, c in ipairs(list) do
                local okE, e = pcall(function() return c:GetEntry() end)
                if okE and e == entry then
                    if yell then
                        pcall(function() c:SendUnitYell(text, 0) end)
                    else
                        pcall(function() c:SendUnitSay(text, 0) end)
                    end
                    if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                    pcall(function() PrintInfo("[ds86512] say SENT entry=" .. entry .. " yell=" .. tostring(yell)) end)
                    return
                end
            end
        end
        pcall(function() PrintInfo("[ds86512] say MISSED entry=" .. entry) end)
    end, delayMs, 1)
end

local function CheckBothAccepted(player)
    local s12, s13 = QStatus(player, 86512), QStatus(player, 86513)
    if not ((s12 == STATUS_INCOMPLETE or s12 == STATUS_COMPLETE) and (s13 == STATUS_INCOMPLETE or s13 == STATUS_COMPLETE)) then return end
    if OnCooldown(player, "bothscene", 600) then return end
    pcall(function() PrintInfo("[ds86512] both accepted -> Decimus line for " .. player:GetName()) end)
    SayAt(player, 235633, 80, 2000,
        "Break her toys and fight to the top of the food chain. Dear little Torentia will take it as a challenge.", 301081)
end

local function OnAccept(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if ok then pcall(function() PrintInfo("[ds86512] accept q=" .. qid .. " by " .. player:GetName()) end) end
    CheckBothAccepted(player)
end

RegisterCreatureEvent(235633, 31, OnAccept)   -- Decimus (86512)
RegisterCreatureEvent(235469, 31, OnAccept)   -- Arator (camp, 86513)
RegisterCreatureEvent(236944, 31, OnAccept)   -- Arator (trench, 86513)

RegisterPlayerEvent(7, function(_, killer, victim)
    local okV, v = pcall(function() return victim:GetEntry() end)
    if not (okV and v and KILL_SET[v]) then return end
    if QStatus(killer, 86512) ~= STATUS_INCOMPLETE then return end
    local okC, can = pcall(function() return killer:CanCompleteQuest(86512) end)
    if not (okC and can) then return end
    if OnCooldown(killer, "torentia", 900) then return end
    pcall(function() PrintInfo("[ds86512] bar complete -> Torentia yell for " .. killer:GetName()) end)
    SayAt(killer, 235708, 300, 800, "Filthy upstart! You'll bleed out like the rest.", 301047, true)
end)

print("[the_harvest] loaded")
