-- =====================================================================
-- Quest 86561 A Strange, Different World v1: Progress (DB) + accept scena.
-- Loot 242390 pada 100% z 10 mobov (core loot, netreba nic). Turn-in 235535
-- (faza 45758 opravena). Accept scena (Wiki Notes, Antius 45757): Alleria + Lothraxion.
-- DB: Custom/sql/20261016_abyss6162.sql (+undo).
-- =====================================================================
if IS_WORLD_STATE then return end

local function SayAt(player, entry, range, delayMs, text, kit)
    text = text:gsub("<name>", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds86561] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds86561] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds86561] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(235532, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 86561) then return end
    pcall(function() PrintInfo("[ds86561] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235532, 80, 1500, "We must be cautious. My attempts to infiltrate this place alone have been thwarted.", 300675)
    SayAt(player, 235530, 80, 8000, "The time for caution has passed. We will reach their leader and rip the information we need from it!", 300676)
end)

print("[strange_world] loaded")
