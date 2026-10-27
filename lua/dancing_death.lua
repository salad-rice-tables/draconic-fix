-- =====================================================================
-- Quest 86562 Dancing with Death v1: boss approach-apparitions + regroup say.
-- Wiki Notes: priblizenie k bossovi = speaker "sa objavi" (temp-summon, village_life
-- vzor, 2 min zivot) + 2 says; vsetky 3 dead -> regroup say. Kills idu nativne
-- (objektivy = mob-entry, Scytheryp faza opravena 243142->45756).
-- DB: Custom/sql/20261016_abyss6162.sql (+undo, len fazy/texty/linky).
-- =====================================================================
if IS_WORLD_STATE then return end

local BOSSES = {
    [243142] = { entry = 235530, x = 2026.47, y = 1972.56, z = -69.57,
        says = { { "These vile monsters are no match for us, <name>!", 300682 }, { "Ha! Kill and kill, yet no alarm is raised. They seem used to this chaos.", 300683 } } },
    [243141] = { entry = 235532, x = 2051.23, y = 2148.94, z = -68.78,
        says = { { "They will even shackle their own kind? Interesting. Some even seem willing.", 300684 }, { "There, base of the tower. That's the one in charge.", 300685 } } },
    [243140] = { entry = 235523, x = 2243.22, y = 1949.22, z = -61.99,
        says = { { "Right ahead, <name>! Let's take it down together!", 300680 }, { "All the creatures here seem to be immersed in Void, down to the smallest mite. Stay sharp.", 300681 } } },
}
local Dead = {}
local SaidAt = {}

local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or 300) then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function AppearSay(player, entry, x, y, z, text, kit, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), 0, x, y, z, 0, false, 120000)
        if not (ok and c) then pcall(function() PrintInfo("[ds86562] summon MISSED entry=" .. entry) end) return end
        pcall(function() PrintInfo("[ds86562] summon OK entry=" .. entry) end)
        local t = text:gsub("<name>", p:GetName())
        local okS, err = pcall(function() c:SendUnitSay(t, 0) end)
        if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
        pcall(function() PrintInfo("[ds86562] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
    end, delayMs, 1)
end

if MAP_Timer then
    MAP_Timer("dancing_death.approach", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(86562) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(80) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            local b = okE and BOSSES[e]
                            if b and not OnCooldown(p, "boss" .. e) then
                                AppearSay(p, b.entry, b.x, b.y, b.z, b.says[1][1], b.says[1][2], 500)
                                AppearSay(p, b.entry, b.x, b.y, b.z, b.says[2][1], b.says[2][2], 8000)
                            end
                        end
                    end
                end
            end
        end
    end, 15000)
end

RegisterPlayerEvent(7, function(_, killer, victim)
    local okV, v = pcall(function() return victim:GetEntry() end)
    if not okV or not BOSSES[v] then return end
    local okS, st = pcall(function() return killer:GetQuestStatus(86562) end)
    if not (okS and st == STATUS_INCOMPLETE) then return end
    local key = killer:GetName()
    Dead[key] = Dead[key] or {}
    Dead[key][v] = true
    local n = 0
    for _ in pairs(Dead[key]) do n = n + 1 end
    pcall(function() PrintInfo("[ds86562] boss dead " .. v .. " count=" .. n .. " player=" .. key) end)
    if n >= 3 and not OnCooldown(killer, "regroup", 600) then
        local okP, px = pcall(function() return killer:GetX() end)
        local okY, py = pcall(function() return killer:GetY() end)
        local okZ, pz = pcall(function() return killer:GetZ() end)
        if okP and okY and okZ then
            AppearSay(killer, 235530, px + 3, py, pz, "You intend to take it prisoner? I would rather incinerate it.", 300677, 3000)
        end
    end
    if n >= 3 then Dead[key] = nil end
end)

print("[dancing_death] loaded")
