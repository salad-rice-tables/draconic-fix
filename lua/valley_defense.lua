-- =====================================================================
-- Defense of the Valley (Valley of Trials, Orcs and Trolls): a mini event for the first levels. Northwatch soldiers march into the Valley from the
-- south and the north in three tiers, by how many heroes take part: tier 1 (1-2 heroes) a small squad, tier 2 (3-4) a stronger one, tier 3 (5 or more)
-- the biggest force and Commander Aldric Vane. Nobody has to talk to anybody: every hero in the Valley gets the event quest "Defense of the Valley" by
-- himself and every kill near him counts. War horns and drums play for all of them, the soldiers yell for everyone to hear, and the reward is
-- starter gear from the loot of the level band (common and uncommon) plus Mystic Runes. Epic and Legendary gear belongs to the dungeons.
-- =====================================================================
if IS_WORLD_STATE then return end

local TAG = "|cffffa000[Defense of the Valley]|r "
local CENTER = {x = -599.7, y = -4364.1, z = 38.95}               -- the camp (rally point of the defenders)
local SPAWNS = {{x = -604.9, y = -4621.2, z = 40.6}, {x = -734.3, y = -4170.9, z = 30.1}}   -- south road and north pass
local RADIUS = 260                                                -- heroes within this range of the camp take part
local QUEST, CREDIT = 9500101, 9903901
local SOLDIERS = {39267, 39268, 39260, 39261, 41361}
local COMMANDER = 9903001
local COOLDOWN, MAXTIME = 12 * 60, 9 * 60
-- music: war horn + drums (sound kits)
local SND_HORN, SND_DRUM_HIT, SND_HORN2, SND_DRUM_BOSS = 137950, 217877, 81223, 218010
local TIERS = {
    {name = "Tier 1", soldiers = 6, flank = 0, boss = false, items = 1, gold = 30},
    {name = "Tier 2", soldiers = 10, flank = 4, boss = false, items = 2, gold = 80},
    {name = "Tier 3", soldiers = 14, flank = 8, boss = true, items = 3, gold = 200},
}
local YELLS = {"For the Alliance! Push into the Valley!", "Burn their huts! The Horde has no place here!", "Orcs! Trolls! Stand and die!",
    "Northwatch, forward! Take the camp!", "Spread out! Leave nothing standing!", "The Horde will bleed for Azshara!"}
local BOSS_YELLS = {"I am Commander Vane! Your Valley falls today!", "Kill them all, and the Barrens are ours!", "You trained these welps? Pathetic!"}

local ev = nil            -- {tier, started, creatures = {guid..}, killed, need, players = {name = true}, boss}
local lastEnd = 0

local function Participants()
    local list = {}
    for _, p in ipairs(MAP_Players() or {}) do
        if p:GetMapId() == 1 and p:IsAlive() and (p:GetX() - CENTER.x) ^ 2 + (p:GetY() - CENTER.y) ^ 2 < RADIUS * RADIUS then list[#list + 1] = p end
    end
    return list
end
local function Each(list, fn) for _, p in ipairs(list) do pcall(fn, p) end end
local function Sound(list, id) Each(list, function(p) p:PlayDirectSound(id, p) end) end
local function Broadcast(list, text) Each(list, function(p) p:SendBroadcastMessage(TAG .. text) end) end
local function Spawn(entry, pt, life)
    local ok, c = pcall(PerformIngameSpawn, 1, entry, 1, 0, pt.x + math.random(-6, 6), pt.y + math.random(-6, 6), pt.z, 0, false, life or (MAXTIME + 60) * 1000)
    if ok and c then
        pcall(function() c:Data():Set("vd_event", true); c:Data():Set("lw_claim", "event") end)
        return c
    end
end
local function March(c)
    pcall(function()
        c:SetWalk(false)
        c:MoveTo(1, CENTER.x + math.random(-8, 8), CENTER.y + math.random(-8, 8), CENTER.z, true)
    end)
end
local function Join(p)
    if ev.players[p:GetName()] then return end
    ev.players[p:GetName()] = true
    pcall(function() if p:GetQuestStatus(QUEST) == 0 then p:AddQuest(QUEST) end end)
    p:SendBroadcastMessage(TAG .. "|cffff4040The Valley is under attack!|r " .. ev.tier.name .. ": drive the Northwatch soldiers out. Kills near you count.")
    pcall(function() p:SendAddonMessage("WCARD", "TOAST;Defense of the Valley;" .. ev.tier.name .. " - Northwatch attacks!", 7, p) end)
end

local function Start(forceTier)
    local heroes = Participants()
    if #heroes == 0 and not forceTier then return false end
    local n = #heroes
    local tier = forceTier or (n >= 5 and 3 or (n >= 3 and 2 or 1))
    local T = TIERS[tier]
    ev = {tier = T, tierNo = tier, started = os.time(), creatures = {}, killed = 0, players = {}, boss = nil, need = T.soldiers + T.flank + (T.boss and 1 or 0)}
    -- the Valley gets a bit more crowded when more heroes join: +1 soldier per hero beyond the tier minimum, at most +6
    local extra = math.min(6, math.max(0, n - (tier == 3 and 5 or (tier == 2 and 3 or 1))))
    for i = 1, T.soldiers + extra do
        local c = Spawn(SOLDIERS[math.random(#SOLDIERS)], SPAWNS[1])
        if c then ev.creatures[#ev.creatures + 1] = c:GetGUID(); March(c); if i == 1 then pcall(function() c:SendUnitYell(YELLS[math.random(#YELLS)], 0) end) end end
    end
    for i = 1, T.flank do
        local c = Spawn(SOLDIERS[math.random(#SOLDIERS)], SPAWNS[2])
        if c then ev.creatures[#ev.creatures + 1] = c:GetGUID(); March(c); if i == 1 then pcall(function() c:SendUnitYell(YELLS[math.random(#YELLS)], 0) end) end end
    end
    if T.boss then
        local b = Spawn(COMMANDER, SPAWNS[1])
        if b then
            ev.boss = b:GetGUID(); ev.creatures[#ev.creatures + 1] = b:GetGUID(); March(b)
            pcall(function() b:SendUnitYell(BOSS_YELLS[math.random(#BOSS_YELLS)], 0) end)
        end
    end
    ev.need = T.soldiers + extra + T.flank + (T.boss and 1 or 0)
    Sound(heroes, SND_HORN); Sound(heroes, SND_DRUM_HIT)
    if T.boss then Sound(heroes, SND_HORN2); Sound(heroes, SND_DRUM_BOSS) end
    Each(heroes, Join)
    if WORLD_News then pcall(WORLD_News, TAG .. "Northwatch attacks the Valley of Trials (" .. T.name .. ")! Defenders, to the camp!") end
    return true
end

local function Finish(win)
    local heroes = Participants()
    local T = ev.tier
    for _, p in ipairs(heroes) do
        if ev.players[p:GetName()] then
            if win then
                pcall(function() p:CompleteQuest(QUEST) end)
                pcall(function() p:RewardQuest(QUEST, 0) end)
                p:ModifyMoney(T.gold * 100)
                -- starter gear from the loot band of the level: the common and uncommon pieces of every expansion
                local lvl = p:GetLevel()
                local ref = 9991001 + math.max(0, math.min(17, math.floor((lvl - 1) / 5)))
                for i = 1, T.items do
                    local q = WorldDBQuery("SELECT Item FROM reference_loot_template WHERE Entry = " .. ref .. " ORDER BY RAND() LIMIT 1")
                    if q then pcall(function() p:AddItem(q:GetUInt32(0), 1) end) end
                end
                if MYS_AddRunes then pcall(MYS_AddRunes, p, T.items) end
                if WAR_AddPoints then pcall(WAR_AddPoints, p, 5 * T.items) end
                p:SendBroadcastMessage(TAG .. "|cff40ff40The Valley is saved!|r Reward: " .. T.gold .. " silver-worth of coin, " .. T.items .. " piece(s) of gear, Mystic Runes.")
            else
                p:SendBroadcastMessage(TAG .. "The attack has ended.")
            end
        end
    end
    Sound(heroes, win and SND_HORN2 or SND_DRUM_HIT)
    if win and WORLD_News then pcall(WORLD_News, TAG .. "The Valley of Trials is saved (" .. T.name .. ")!") end
    for _, g in ipairs(ev.creatures) do
        local ok, c = pcall(GetCreatureByGUID, 1, g)   -- leftovers leave
        if ok and c and c:IsAlive() and not win then pcall(function() c:DespawnOrUnsummon(2000) end) end
    end
    ev = nil
    lastEnd = os.time()
end

local function Tick()
    local now = os.time()
    if not ev then
        if now - lastEnd > COOLDOWN and math.random(100) <= 35 and #Participants() > 0 then Start() end
        return
    end
    local heroes = Participants()
    if #heroes == 0 or now - ev.started > MAXTIME then Finish(false) return end
    for _, p in ipairs(heroes) do
        if not ev.players[p:GetName()] then Join(p) end          -- late joiners are welcome
    end
    if ev.killed >= ev.need then Finish(true) end
end
MAP_Timer("valley_defense.tick", Tick, 10000)

RegisterPlayerEvent(7, function(_, killer, killed)   -- kill: credit for every defender near the soldier
    if not ev or not killer or not killed then return end
    local ok, mine = pcall(function() return killed:Data():Get("vd_event") end)
    if not (ok and mine) then return end
    ev.killed = ev.killed + 1
    local kx, ky = killed:GetX(), killed:GetY()
    for _, p in ipairs(Participants()) do
        if (p:GetX() - kx) ^ 2 + (p:GetY() - ky) ^ 2 < 70 * 70 then pcall(function() p:KilledMonsterCredit(CREDIT) end) end
    end
    if killed:GetEntry() == COMMANDER then
        for _, p in ipairs(Participants()) do p:SendBroadcastMessage(TAG .. "|cff40ff40Commander Aldric Vane has fallen!|r") end
    end
end)

-- the soldiers yell when they meet a hero (every defender hears it)
local last = {}
local function OnAggro(_, c, target)
    if not ev then return end
    local ok, mine = pcall(function() return c:Data():Get("vd_event") end)
    if not (ok and mine) then return end
    local g = c:GetGUIDLow()
    if os.time() - (last[g] or 0) < 25 or math.random(100) > 35 then return end
    last[g] = os.time()
    pcall(function() c:SendUnitYell((c:GetEntry() == COMMANDER) and BOSS_YELLS[math.random(#BOSS_YELLS)] or YELLS[math.random(#YELLS)], 0) end)
end
for _, e in ipairs(SOLDIERS) do RegisterCreatureEvent(e, 1, OnAggro) end

-- GM: .lwgm nwar 1 [tier]   start the Valley event at once
if LW_QUEUE_HANDLERS then
    LW_QUEUE_HANDLERS["vdefense"] = function(player, arg)
        if not player then return false end
        if ev then player:SendBroadcastMessage("|cff00ff00[GM]|r The Valley event is already running.") return true end
        local t = tonumber(arg)
        if Start(t and TIERS[t] and t or nil) then player:SendBroadcastMessage("|cff00ff00[GM]|r Defense of the Valley started.")
        else player:SendBroadcastMessage("|cff00ff00[GM]|r Nobody is in the Valley.") end
        return true
    end
end
print("[valley_defense] loaded")
