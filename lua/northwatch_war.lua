-- =====================================================================
-- The War of Northwatch Aggression (continues quest 25169): the Alliance garrison of Northwatch Hold plans to destroy Valley of Trials,
-- Sen'jin Village and the gates of Orgrimmar. While heroes are near one of those places, Northwatch forces march on it in waves
-- (infantry, sharpshooters, a siege engineer) and after the second wave Commander Aldric Vane (9903001, rare elite, the mini-boss) leads
-- the last assault. Every kill pays war points and Mystic Runes; the commander drops a Greater Essence Potion and a lot of runes.
-- Cooldown 40 minutes per target; the event ends after 14 minutes.
-- =====================================================================
if IS_WORLD_STATE then return end

local TAG = "|cffffa000[War]|r "
local TARGETS = {
    {name = "Valley of Trials",   map = 1, x = -600.0,  y = -4260.0, z = 38.0, noauto = true},   -- the Valley has its own event: valley_defense.lua
    {name = "Sen'jin Village",    map = 1, x = -832.0,  y = -4960.0, z = 19.0},
    {name = "the gates of Orgrimmar", map = 1, x = 1190.0, y = -4380.0, z = 24.0},
}
local ORIGIN = {map = 1, x = -1020.0, y = -4690.0, z = 17.0}      -- Northwatch Hold
local SCOUT = 39317
local SOLDIERS = {39267, 39268, 39260, 39261, 41361}
local ENGINEER, COMMANDER = 38327, 9903001
local COOLDOWN, DURATION = 40 * 60, 14 * 60
local last = {}      -- target index -> last start
local active = nil   -- {target, started, wave, creatures}

local function News(text)
    if WORLD_News then pcall(WORLD_News, text) end
end

local function Spawn(ref, entry, x, y, z, life)
    local ok, c = pcall(PerformIngameSpawn, 1, entry, 1, 0, x, y, z, 0, false, life or DURATION * 1000 + 60000)
    if ok and c then
        pcall(function() c:Data():Set("nw_war", true) end)
        return c
    end
end

local function Wave(ref, t, wave)
    if not active then return end
    -- the size follows the number of heroes around the target, so a lone hero is challenged, not crushed
    local near = 0
    for _, p in ipairs(MAP_Players() or {}) do
        if p:GetMapId() == t.map and (p:GetX() - t.x) ^ 2 + (p:GetY() - t.y) ^ 2 < 220 * 220 then near = near + 1 end
    end
    near = math.max(1, near)
    -- stage 220 yards from the target, on the Northwatch side
    local dx, dy = ORIGIN.x - t.x, ORIGIN.y - t.y
    local len = math.max(1, math.sqrt(dx * dx + dy * dy))
    local sx, sy = t.x + dx / len * 220, t.y + dy / len * 220
    local n = math.min(8, 2 + near * 2 + (wave > 1 and 1 or 0))
    for i = 1, n do
        local c = Spawn(ref, SOLDIERS[math.random(#SOLDIERS)], sx + (i % 3) * 3, sy + math.floor(i / 3) * 3, t.z)
        if c then
            active.creatures[#active.creatures + 1] = c:GetGUID()
            pcall(function() c:SetWalk(false); c:MoveTo(1, t.x + math.random(-6, 6), t.y + math.random(-6, 6), t.z, true) end)
        end
    end
    local eng = near >= 2 and Spawn(ref, ENGINEER, sx, sy + 4, t.z) or nil
    if eng then
        pcall(function() eng:MoveTo(1, t.x, t.y, t.z, true) end)
    end
    if wave >= 3 then
        local boss = Spawn(ref, COMMANDER, sx + 4, sy, t.z)
        if boss and near == 1 then
            pcall(function() local m = boss:GetMaxHealth(); boss:SetMaxHealth(math.floor(m * 0.45)); boss:SetHealth(math.floor(m * 0.45)) end)   -- a lone hero faces a weakened commander
        end
        if boss then
            pcall(function() boss:MoveTo(1, t.x, t.y, t.z, true) end)
            pcall(function() boss:SendUnitYell("For the Alliance! Burn them to the ground!", 0) end)
            News(TAG .. "|cffff4040Commander Aldric Vane|r leads the final assault on " .. t.name .. "!")
        end
    end
end

pcall(CharDBExecute, [[CREATE TABLE IF NOT EXISTS characters.hero_nw_plans (name VARCHAR(40) NOT NULL PRIMARY KEY, plans INT UNSIGNED NOT NULL DEFAULT 0, total INT UNSIGNED NOT NULL DEFAULT 0) ENGINE=InnoDB]])
local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end -- local: Eluna izoluje subory, zdielany global nefunguje

-- Scouts: stealthed Northwatch Scouts creep around the target before the assault. Each one carries a page of the Attack Plans.
local function SpawnScouts(ref, t)
    for i = 1, 3 do
        local ang = math.random() * math.pi * 2
        local d = math.random(60, 110)
        local c = Spawn(ref, SCOUT, t.x + math.cos(ang) * d, t.y + math.sin(ang) * d, t.z)
        if c then
            pcall(function() c:Data():Set("nw_scout", true) end)
            pcall(function() c:AddAura(1784, c) end)          -- Stealth
        end
    end
end

local function Start(idx, ref)
    local t = TARGETS[idx]
    active = {target = idx, started = os.time(), wave = 0, creatures = {}}
    SpawnScouts(ref, t)
    last[idx] = os.time()
    News(TAG .. "The Northwatch garrison marches on " .. t.name .. "! The Attack Plans were true. Defend it, heroes!")
    pcall(function() ref:SendBroadcastMessage(TAG .. "Northwatch soldiers approach " .. t.name .. "!") end)
end

local function Tick()
    local players = MAP_Players() or {}
    local now = os.time()
    if active then
        local t = TARGETS[active.target]
        local ref
        for _, p in ipairs(players) do
            if p:GetMapId() == t.map and (p:GetX() - t.x) ^ 2 + (p:GetY() - t.y) ^ 2 < 400 * 400 then ref = p break end
        end
        if now - active.started > DURATION or not ref then
            -- over, or nobody is left to see it
            active = nil
            return
        end
        local due = math.floor((now - active.started) / 150) + 1   -- a wave every 2.5 minutes, the commander on the third
        if due > active.wave and active.wave < 3 then
            active.wave = active.wave + 1
            Wave(ref, t, active.wave)
        end
        return
    end
    -- start: a hero near a target that has rested
    for _, p in ipairs(players) do
        if p:GetMapId() == 1 and p:GetLevel() >= 5 then
            for i, t in ipairs(TARGETS) do
                if not t.noauto and (p:GetX() - t.x) ^ 2 + (p:GetY() - t.y) ^ 2 < 200 * 200 and now - (last[i] or 0) > COOLDOWN and math.random(100) <= 25 then
                    Start(i, p)
                    return
                end
            end
        end
    end
end

RegisterPlayerEvent(7, function(_, killer, killed)
    if not killer or not killed then return end
    local okS, scout = pcall(function() return killed:Data():Get("nw_scout") end)
    if okS and scout then
        local name = Esc(killer:GetName())
        pcall(CharDBExecute, "INSERT INTO characters.hero_nw_plans (name, plans, total) VALUES ('" .. name .. "', 1, 1) ON DUPLICATE KEY UPDATE plans = plans + 1, total = total + 1")
        local q = CharDBQuery("SELECT plans, total FROM characters.hero_nw_plans WHERE name = '" .. name .. "'")
        local have = q and q:GetUInt32(0) or 1
        if have >= 3 then
            pcall(CharDBExecute, "UPDATE characters.hero_nw_plans SET plans = 0 WHERE name = '" .. name .. "'")
            local nxt = TARGETS[math.random(#TARGETS)]
            killer:SendBroadcastMessage(TAG .. "|cff40ff40You piece together the Northwatch Attack Plans!|r The next blow falls on " .. nxt.name .. ". Warn the defenders. +3 Mystic Runes.")
            pcall(function() killer:SendAddonMessage("WCARD", "TOAST;Attack Plans found;Northwatch will strike " .. nxt.name, 7, killer) end)
            if MYS_AddRunes then pcall(MYS_AddRunes, killer, 3) end
            pcall(function() killer:AddItem(9730012, 1) end)
        else
            killer:SendBroadcastMessage(TAG .. "A page of the Attack Plans: " .. have .. " / 3.")
        end
        return
    end
    local ok, mine = pcall(function() return killed:Data():Get("nw_war") end)
    if not (ok and mine) then return end
    local entry = killed:GetEntry()
    if WAR_AddPoints then pcall(WAR_AddPoints, killer, entry == COMMANDER and 40 or 3) end
    if MYS_AddRunes then
        if entry == COMMANDER then
            pcall(MYS_AddRunes, killer, 5)
            killer:SendBroadcastMessage(TAG .. "|cff40ff40Commander Aldric Vane has fallen!|r +5 Mystic Runes.")
            News(TAG .. "Commander Aldric Vane is dead. The Northwatch assault is broken!")
        elseif math.random(100) <= 30 then
            pcall(MYS_AddRunes, killer, 1)
        end
    end
end)

MAP_Timer("northwatch_war.tick", Tick, 30000)

-- GM: .lwgm nwar [1|2|3] [tier]   start the event at once at a target (1 Valley, 2 Sen'jin, 3 Orgrimmar)
if LW_QUEUE_HANDLERS then
    LW_QUEUE_HANDLERS["nwar"] = function(player, arg)
        if not player then return false end
        local a1, a2 = string.match(arg or "", "^(%d*)%s*(%d*)")
        local idx = tonumber(a1) or 1
        if idx == 1 then   -- .lwgm nwar 1 [tier 1-3]: the tier of the Valley event is picked by hand
            WorldDBExecute(string.format("INSERT INTO lw_queue (kind, name, arg) VALUES ('vdefense', '%s', '%s')", (string.gsub(player:GetName(), "'", "''")), tonumber(a2) or ""))
            player:SendBroadcastMessage("|cff00ff00[GM]|r The Valley of Trials has its own event now: starting Defense of the Valley.")
            return true
        end
        if TARGETS[idx] and not active then Start(idx, player); player:SendBroadcastMessage("|cff00ff00[GM]|r Northwatch war started at " .. TARGETS[idx].name .. ".")
        else player:SendBroadcastMessage("|cff00ff00[GM]|r Event already running or bad target.") end
        return true
    end
end
print("[northwatch_war] loaded")
