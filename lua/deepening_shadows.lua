-- =====================================================================
-- Quest 91854 Deepening Shadows: kredity na quest-buttonoch + accept scena + approach/yelly.
-- Dispute: Aeroknight 249175 (gossip, bez buttonu) + Vendor 249174 (button -> kredit 249174).
-- Prisoner: Venel 248630 (2 buttony -> kredit 248630 + say) + Tehd 249467 (gossip, yell on approach).
-- Doomsayers 248826 (3 buttony -> kredit 248826 + ambient yelly).
-- Accept scena (Wiki Notes): Aethas 249450 -> Koruth 248631. VO = retail SoundKitID z broadcast_text.
-- Texty doslovne z Warcraft Wiki Deepening_Shadows_(quest). Cooldown 300 s, yelly 150 s.
-- DB: Custom/sql/20261016_abyss91854.sql (+undo). Cultist-attack varianta = follow-up (treba sniff).
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}
local COOLDOWN = 300

local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or COOLDOWN) then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function QStatus(player, qid)
    local ok, st = pcall(function() return player:GetQuestStatus(qid) end)
    if ok then return st end
    return -1
end

-- range say s volitelnym VO kitom (diplomacy vzor: PlayDistanceSound)
local function SayAt(player, entry, range, delayMs, text, chatType, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then pcall(function() PrintInfo("[ds91854] say MISSED (player gone)") end) return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds91854] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err
                if chatType == "yell" then okS, err = pcall(function() c:SendUnitYell(text, 0) end)
                else okS, err = pcall(function() c:SendUnitSay(text, 0) end) end
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds91854] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds91854] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function CreditHandler(creditEntry, menuId, key, extraFn)
    return function(_, player, _, sender, intid)
        pcall(function() PrintInfo(string.format("[ds91854] player=%s npc=%d menu=%s intid=%s q91854=%s", player:GetName(), creditEntry, tostring(sender), tostring(intid), tostring(QStatus(player, 91854)))) end)
        if sender ~= menuId then return end
        pcall(function() player:KilledMonsterCredit(creditEntry) end)
        if OnCooldown(player, key) then return end
        if extraFn then extraFn(player) end
    end
end

-- Vendor: button -> kredit (post-text 912047203 je v DB okne nabuduce, netreba scenu)
RegisterCreatureGossipEvent(249174, 2, CreditHandler(249174, 40134, "vendor-dispute", nil))
-- Venel: oba buttony -> kredit + "Release the Void-wielders" (pohyb Tehd/grupy = follow-up)
RegisterCreatureGossipEvent(248630, 2, CreditHandler(248630, 40189, "venel-prisoner", function(player)
    SayAt(player, 248630, 60, 1500, "Release the Void-wielders. They may wander the city, but we will tolerate none of their taint near the Sunwell.", "say", 308308)
end))
-- Doomsayer: vsetky 3 odpovede -> kredit (back-down say varianta 1; attack-varianta = follow-up)
RegisterCreatureGossipEvent(248826, 2, CreditHandler(248826, 40105, "doom-rebuff", function(player)
    SayAt(player, 248826, 40, 1500, "I... concede your point.", "say", nil)
end))

-- Accept scena (Wiki Notes): Aethas -> Koruth, s retail dabingom
RegisterCreatureEvent(248631, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 91854) then return end
    pcall(function() PrintInfo("[ds91854] quest accepted by " .. player:GetName()) end)
    SayAt(player, 249450, 80, 1500, "We need to put a stop to these fights.", "say", 308309)
    SayAt(player, 248631, 80, 7000, "Agreed. This city's a powder keg ready to go.", "say", 308310)
end)

-- Approach + ambient: dispute Aeroknight say, Tehd yell, doomsayer yelly (vsetko Wiki verbatim + VO)
if MAP_Timer then
    local AEROKNIGHT_SAY = "This is for the Sunwell. We cannot survive on just mana biscuits."
    local TEHD_YELL = "I'm a Warlock, not a cultist."
    local DOOM_YELLS = {
        { "The Void is coming!", 308300 },
        { "The Vanguard will abandon us! They care nothing for the Sunwell!", 308302 },
        { "The Vanguard is making the Sunwell scream! Can you not feel it?!", 308304 },
        { "Ignore the lie! Look to the sky! Death is nigh!", 308306 },
    }
    MAP_Timer("deepening_shadows.approach", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 0 then
                local okS, st = pcall(function() return p:GetQuestStatus(91854) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okL, list = pcall(function() return p:GetCreaturesInRange(90) end)
                    if okL and list then
                        local near = {}
                        for _, c in ipairs(list) do
                            local okE, e = pcall(function() return c:GetEntry() end)
                            if okE then near[e] = c end
                        end
                        if near[249175] and not OnCooldown(p, "aero-approach") then
                            SayAt(p, 249175, 90, 500, AEROKNIGHT_SAY, "say", 308311)
                        end
                        if near[248630] and not OnCooldown(p, "tehd-approach") then
                            SayAt(p, 249467, 90, 500, TEHD_YELL, "yell", 308313)
                        end
                        if near[248826] and not OnCooldown(p, "doom-yell", 150) and math.random() < 0.4 then
                            local y = DOOM_YELLS[math.random(#DOOM_YELLS)]
                            SayAt(p, 248826, 90, 500, y[1], "yell", y[2])
                        end
                    end
                end
            end
        end
    end, 20000)
    RegisterPlayerEvent(4, function(_, player) SaidAt[player:GetName() .. ":aero-approach"] = nil end)
end

print("[deepening_shadows] loaded")
