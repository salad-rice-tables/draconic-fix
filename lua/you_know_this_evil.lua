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

local function SayAt(player, entry, range, delayMs, text)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                pcall(function() c:SendUnitSay(text, 0) end)
                return
            end
        end
    end, delayMs, 1)
end

local function PetitionHandler(creditEntry, key)
    return function(_, player, _, _, intid)
        if intid == 1 then
            pcall(function() player:KilledMonsterCredit(creditEntry) end)
            OnCooldown(player, key)
        end
    end
end

RegisterCreatureGossipEvent(249268, 2, PetitionHandler(249268, "loth-pet"))
RegisterCreatureGossipEvent(248628, 2, PetitionHandler(248628, "senn-pet"))
RegisterCreatureGossipEvent(249270, 2, PetitionHandler(249270, "rom-pet"))
RegisterCreatureGossipEvent(249289, 2, function(_, player, _, _, intid)
    if intid == 1 then
        pcall(function() player:KilledMonsterCredit(249289) end)
        if OnCooldown(player, "anduin-scene") then return end
        SayAt(player, 249289, 60, 2000, "High Commander. You will release Magister Umbric, if you please.")
        SayAt(player, 249268, 60, 6000, "No. This... elf... has made their allegiance known.")
        SayAt(player, 249289, 60, 10000, "They have. To me. Time and time again, Umbric and his ren'dorei have shown their loyalty to the Alliance despite persecution and distrust.")
        SayAt(player, 249289, 60, 15000, "You do not have the time to imprison him nor the grounds to execute him.")
        SayAt(player, 249270, 60, 19000, "But Umbric-")
        SayAt(player, 249289, 60, 22000, "Is fond of 'bold' actions. Is that what I heard you say, Grand Magister?")
        SayAt(player, 249289, 60, 26000, "Now is the time for bold actions. Release him, I accept full responsibility.")
        SayAt(player, 249268, 60, 30000, "Fine. On your head be it.")
    end
end)

print("[you_know_this_evil] loaded")
