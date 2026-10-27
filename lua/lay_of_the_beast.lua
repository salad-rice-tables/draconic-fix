-- =====================================================================
-- Quest 90571 The Lay of the Beast v1: scry proximity + area says + Listen dialog.
-- Scry body (Ciphus/vehicle) = follow-up (treba spelly); body sa daju prejst peso,
-- kredity cez proximity. Terminas-catch skip. Texty Wiki verbatim.
-- DB: Custom/sql/20261016_abyss0571.sql (+undo).
-- =====================================================================
if IS_WORLD_STATE then return end

local STATUS_COMPLETE = 1

local SaidAt = {}

local function OnCooldown(player, key, cd)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < (cd or 300) then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text, kit)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[ds90571] say MISSED (no range list)") end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[ds90571] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[ds90571] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end

local function SummonSay(player, entry, x, y, z, text, kit, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, c = pcall(PerformIngameSpawn, 1, entry, p:GetMapId(), 0, x, y, z, 0, false, 120000)
        if not (ok and c) then pcall(function() PrintInfo("[ds90571] summon MISSED entry=" .. entry) end) return end
        local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
        if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
        pcall(function() PrintInfo("[ds90571] summon-say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
    end, delayMs, 1)
end

RegisterCreatureEvent(235697, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if not (ok and qid == 90571) then return end
    pcall(function() PrintInfo("[ds90571] quest accepted by " .. player:GetName()) end)
    SayAt(player, 235697, 100, 2000, "Borrow my pet's sight. I'll tell you how to weaken the storm.", 301046)
end)

-- Scry body: proximity kredity + area says (sprievodcovia cez scry = summon)
local SCRY = {
    { x = 1484.0, y = -29.0, z = -289.0, credit = 239741, says = {
        { 235697, "The key to weakening the storm is an artifact known as the Mantle of Predation.", 301147 },
        { 235697, "With it, you may enter a nexus-point and simply shut it down. Doing so will nullify the others in a cascade.", 301146 } } },
    { x = 1658.0, y = -212.0, z = -236.0, credit = 239742, says = {
        { 235473, "Why merely shut down the nexus-points? We should raze them from within.", 301149 },
        { 235697, "And cause an energy surge that would obliterate precious Silvermoon? Shut them down safely, spare your poor city.", 301148 } } },
    { x = 1863.0, y = -425.0, z = -276.0, credit = 239743, says = {
        { 235697, "Ah. \"Lord\" Terminas. He keeps the Mantle at the Obscurion Citadel.", 301145 },
        { 235697, "How fortunate that he's busy here, leaving his vault unguarded.", 301144 } } },
}

if MAP_Timer then
    MAP_Timer("laybeast.scry", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() and p:GetMapId() == 2771 then
                local okS, st = pcall(function() return p:GetQuestStatus(90571) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okX, x = pcall(function() return p:GetX() end)
                    local okY, y = pcall(function() return p:GetY() end)
                    if okX and okY then
                        for i, s in ipairs(SCRY) do
                            local d = math.sqrt((x - s.x) * (x - s.x) + (y - s.y) * (y - s.y))
                            if d < 60 and not OnCooldown(p, "scry" .. i, 600) then
                                pcall(function() p:KilledMonsterCredit(s.credit) end)
                                pcall(function() PrintInfo("[ds90571] scry credit " .. s.credit .. " player=" .. p:GetName()) end)
                                local dd = 2000
                                for _, line in ipairs(s.says) do
                                    SummonSay(p, line[1], s.x + 4, s.y, s.z, line[2], line[3], dd)
                                    dd = dd + 8000
                                end
                            end
                        end
                    end
                end
            end
        end
    end, 10000)
end

-- Listen: Arator button + 10-say dialog (Wiki)
RegisterCreatureGossipEvent(235469, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[ds90571] arator player=%s menu=%s intid=%s", player:GetName(), tostring(sender), tostring(intid))) end)
    if sender ~= 912046930 then return end
    pcall(function() player:KilledMonsterCredit(240725) end)
    if OnCooldown(player, "listen", 600) then return end
    local A, D, L = 235469, 235697, 235473
    SayAt(player, A, 80, 2000, "Why are you so eager to help us?", 301141)
    SayAt(player, D, 80, 9000, "I am a creature of passion.", 301139)
    SayAt(player, L, 80, 16000, "A creature without purpose. Like every fiend from the Void.", 301138)
    SayAt(player, D, 80, 23000, "Watching your struggles blazing bright against an uncaring cosmos--it's delicious.", 301137)
    SayAt(player, D, 80, 30000, "Xal'atath would devour your world. All worlds. Even the stars.", 301136)
    SayAt(player, D, 80, 37000, "She would leave nothing but an empty abyss. Can you imagine anything more dull?", 301135)
    SayAt(player, L, 80, 44000, "Loyalty is so contrary to the Void that you'd betray your master out of boredom?", 301134)
    SayAt(player, D, 80, 51000, "I need no master. We should all obey our own appetites.", 301133)
    SayAt(player, L, 80, 58000, "Some of us serve greater purposes than hunger, beast.", 301132)
    SayAt(player, D, 80, 65000, "The cosmos is a feast, lightling. Why not enjoy it?", 301131)
end)

-- Completion say (turn-in u Decimusa)
if MAP_Timer then
    MAP_Timer("laybeast.done", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() then
                local okS, st = pcall(function() return p:GetQuestStatus(90571) end)
                if okS and st == STATUS_COMPLETE and not OnCooldown(p, "done", 3600) then
                    SayAt(p, 235697, 100, 3000, "Steal the Mantle of Predation, enter a Nexus-Point, and weaken the storm. Oh, Terminas will be humiliated.", 301143)
                end
            end
        end
    end, 20000)
end

print("[lay_of_the_beast] loaded")
