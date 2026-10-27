-- =====================================================================
-- Quest 91967 You Know This Evil?: petition kredity + Anduinova scena prepustenia.
-- 4 petitioneri (Lothraxion 249268, Senn 248628, Rommath 249270, Anduin 249289):
-- kredit na "researching" buttone (opt1). Umbric 249272: bez buttonov (Find = otvorenie).
-- Anduinova scena po jeho buttone (Wiki Notes, vsetci stoja pokope): Anduin->Lothraxion->Anduin x3->Rommath->Anduin x2->Lothraxion.
-- Texty doslovne z Warcraft Wiki You_Know_This_Evil. Cooldown 300 s na hraca.
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}
local COOLDOWN = 300

local function OnCooldown(player, key)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < COOLDOWN then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then pcall(function() PrintInfo("[evil] say MISSED (player gone)") end) return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[evil] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[evil] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[evil] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function SayGuid(player, guidList, delayMs, text)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then pcall(function() PrintInfo("[evil] say MISSED (player gone)") end) return end
        local okM, map = pcall(function() return p:GetMap() end)
        if not okM or not map then pcall(function() PrintInfo("[evil] say MISSED (no map)") end) return end
        for _, g in ipairs(guidList) do
            local okC, c = pcall(function() return map:GetCreature(g) end)
            if okC and c and c:IsInWorld() then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                pcall(function() PrintInfo("[evil] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " guid=" .. g) end)
                return
            end
        end
        pcall(function() PrintInfo("[evil] say MISSED (no spawn visible)") end)
    end, delayMs, 1)
end

local function QStatus(player, qid)
    local ok, st = pcall(function() return player:GetQuestStatus(qid) end)
    if ok then return tostring(st) end
    return "?"
end

local function PetitionHandler(creditEntry, menuId, key)
    return function(_, player, _, sender, intid)
        pcall(function() PrintInfo(string.format("[evil] player=%s npc=%d menu=%s intid=%s q91967=%s", player:GetName(), creditEntry, tostring(sender), tostring(intid), QStatus(player, 91967))) end)
        if sender == menuId then
            pcall(function() player:KilledMonsterCredit(creditEntry) end)
            OnCooldown(player, key)
        end
    end
end

RegisterCreatureGossipEvent(249268, 2, PetitionHandler(249268, 40158, "loth-pet"))
RegisterCreatureGossipEvent(248628, 2, PetitionHandler(248628, 40154, "senn-pet"))
RegisterCreatureGossipEvent(249270, 2, PetitionHandler(249270, 40147, "rom-pet"))
RegisterCreatureGossipEvent(249289, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[evil] player=%s npc=249289 menu=%s intid=%s q91967=%s", player:GetName(), tostring(sender), tostring(intid), QStatus(player, 91967))) end)
    if sender ~= 40163 then return end
        pcall(function() player:KilledMonsterCredit(249289) end)
        if OnCooldown(player, "anduin-scene") then return end
        SayAt(player, 249289, 60, 1000, "High Commander. You will release Magister Umbric, if you please.", 308317)
        SayAt(player, 249268, 60, 7000, "No. This... elf... has made their allegiance known.", 308318)
        SayAt(player, 249289, 60, 12000, "They have. To me. Time and time again, Umbric and his ren'dorei have shown their loyalty to the Alliance despite persecution and distrust.", 308319)
        SayAt(player, 249289, 60, 24000, "You do not have the time to imprison him nor the grounds to execute him.", 308320)
        SayAt(player, 249270, 60, 31000, "But Umbric-", 308321)
        SayAt(player, 249289, 60, 33000, "Is fond of 'bold' actions. Is that what I heard you say, Grand Magister?", 308322)
        SayAt(player, 249289, 60, 40000, "Now is the time for bold actions. Release him, I accept full responsibility.", 308323)
        SayAt(player, 249268, 60, 47000, "Fine. On your head be it.", 308324)
end)

print("[you_know_this_evil] loaded")
