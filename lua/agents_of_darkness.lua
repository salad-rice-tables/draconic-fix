-- =====================================================================
-- Quest 88768 Agents of Darkness v1: elite approach/kill says + meet-up says.
-- Watcher 239807 / Unbound 239808 / Protector 244153 / Inventor 242995 (vsetci spawnuti).
-- Accept scena je v blow_it_up.lua (zdielany moment). Turn-in nativny.
-- Texty Wiki Agents_of_Darkness verbatim + dabing (kits 321405/6, 318670/74/85-87).
-- DB: len unlink 235662 (Custom/sql/20261016_abyss6842.sql +undo).
-- Follow-up: T'era whisper (ziadna API).
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}

local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or 300) then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text, kit)
    text = text:gsub("<name>", player:GetName())
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds88768] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds88768] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds88768] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local Dead = {}

if MAP_Timer then
    MAP_Timer("agents.approach", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(88768) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(70) end)
                    if okL and list then
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            if okE and e == 239807 and not OnCooldown(p, "watcher") then
                                SayAt(p, 239807, 90, 500, "HUNGER. WITHOUT. END.", 321406)
                            elseif okE and e == 239808 and not OnCooldown(p, "unbound") then
                                SayAt(p, 239808, 90, 500, "The Void... unmakes us...", 318674)
                            elseif okE and e == 242995 and not OnCooldown(p, "inventor") then
                                SayAt(p, 242995, 90, 500, "A Mortal! Your soul shall renew my creation!", 318685)
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
    if not okV then return end
    local okS, st = pcall(function() return killer:GetQuestStatus(88768) end)
    if not (okS and st == STATUS_INCOMPLETE) then return end
    local key = killer:GetName()
    if v == 239807 then
        SayAt(killer, 239807, 90, 2000, "EAT... OR BE...", 321405)
        Dead[key] = Dead[key] or {}
        Dead[key][v] = true
    elseif v == 239808 then
        SayAt(killer, 239808, 90, 2000, "Was there... no other way...?", 318670)
        Dead[key] = Dead[key] or {}
        Dead[key][v] = true
    elseif v == 244153 then
        SayAt(killer, 242995, 90, 2000, "NO! I'll kill you for that!", 318687)
        Dead[key] = Dead[key] or {}
        Dead[key][v] = true
    elseif v == 242995 then
        SayAt(killer, 242995, 90, 2000, "Relief... At last...", 318686)
    end
    local n = 0
    if Dead[key] then for _ in pairs(Dead[key]) do n = n + 1 end end
    if n >= 3 then
        Dead[key] = nil
        if not OnCooldown(killer, "meetup", 600) then
            SayAt(killer, 235649, 120, 3000, "This is taking too long. Stand aside, I'll smash the damned thing.", 300833)
            SayAt(killer, 235662, 120, 9000, "No, Lothraxion! <name>, we need your eyes.", 300955)  -- bt 283004 kit2 vo_120_alleria_windrunner_39
        end
    end
end)

print("[agents_of_darkness] loaded")
