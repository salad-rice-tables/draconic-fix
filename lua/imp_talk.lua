-- Imps, Vile Familiars and other little demons chatter in their own way (instead of the town folk lines).
if IS_WORLD_STATE then return end

local IDLE = {
    "Hee hee hee!", "Burn, burn, burn!", "Imp is bored... imp wants to burn something.",
    "Shiny! Give imp the shiny!", "Heh heh. The warm ones taste best.", "Imp is a very good imp!", "Fel fire! Pretty fel fire!",
    "Nobody pays attention to the imp.", "Imp has secrets. Many secrets.", "Imp is free! Free, free, free!",
    "No master! No leash! Hee hee!", "Imp found a mushroom. Imp does not share.",
}
local COMBAT = {
    "Burn!", "Feel the fire!", "Imp will burn you!", "Hee hee! You can't catch me!", "Run away, run away!", "Imp bites back!",
}
local DEATH = {"Imp goes back to the Nether!", "Noooo! My fire!", "Imp... was... a good imp..."}

local ENTRIES = {}
local q = WorldDBQuery([[SELECT entry FROM creature_template WHERE npcflag IN (0, 1, 2) AND ScriptName = ''
    AND name REGEXP 'familiar|imp$|^imp |^imp$|firebolt|wrathguard']])
if q then
    repeat
        local e = q:GetUInt32(0)
        ENTRIES[e] = true
        RegisterCreatureEvent(e, 1, function(_, c) if math.random() < 0.5 then pcall(function() c:SendUnitSay(COMBAT[math.random(#COMBAT)], 0) end) end end)
        RegisterCreatureEvent(e, 4, function(_, c) if math.random() < 0.4 then pcall(function() c:SendUnitSay(DEATH[math.random(#DEATH)], 0) end) end end)
    until not q:NextRow()
end

local last = {}
if MAP_Timer then
    MAP_Timer("imp_talk.idle", function()
        local now = os.time()
        for _, p in ipairs(MAP_Players()) do
            local ok, list = pcall(function() return p:GetCreaturesInRange(25) end)
            if ok and list then
                for _, c in ipairs(list) do
                    if ENTRIES[c:GetEntry()] and c:IsAlive() and not c:IsInCombat() then
                        local g = c:GetGUIDLow()
                        if (last[g] or 0) + 60 < now and math.random() < 0.2 then
                            last[g] = now
                            pcall(function() c:SendUnitSay(IDLE[math.random(#IDLE)], 0) end)
                        end
                    end
                end
            end
        end
    end, 8000)
end
print("[imps] imp chatter loaded")
