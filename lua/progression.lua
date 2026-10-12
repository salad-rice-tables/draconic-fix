-- =====================================================================
-- Server progression and social systems:
--  * Intro: new heroes get a short guide on first login; .guide repeats it.
--  * Rebirth: at the level cap, .rebirth (or the Challenge Master) starts you
--    over at level 1. Collections, titles, runes and reputation stay; each
--    rebirth (max 5) gives +3% all stats and +10% experience for good.
--  * Leaderboards: .top [wf|mystic|manastorm|hardcore|rep|season|rebirth]
--  * Seasons: every month a new rule set and a points race; the top 3 of a
--    season get the title "Season Champion". .season
--  * Crafting: .salvage <item> turns a Worldforged item into Mystic Runes;
--    the Mystic Enchanter forges a Worldforged item from 10 runes;
--    gathering trade goods sometimes yields a rune.
--  * Guild villages: a guild master adopts a village (.guildvillage adopt);
--    its members earn double from defending it and the village knows them.
--  * World PvP: every 3 hours one High-Risk zone becomes a battlefield for
--    45 minutes; the faction with more kills wins runes and +10% XP there.
--  * Mentoring: grouping with a player 15+ levels lower gives them +25% XP
--    and the mentor Mystic Runes.
-- =====================================================================

local ENABLED = true
local ITAG = "|cff69ccf0[Guide]|r "
local RTAG = "|cffff8000[Rebirth]|r "
local TTAG = "|cffffd100[Top]|r "
local STAG = "|cff33ff99[Season]|r "
local CTAG = "|cffb08850[Crafting]|r "
local GTAG = "|cff40c040[Guild Village]|r "
local PTAG = "|cffff3030[Battlefield]|r "
local MTAG = "|cffa0a0ff[Mentor]|r "
local MAXLEVEL = 90
local REBIRTH_SPELL = 1402200

local function Key(player) return (string.gsub(player:GetName() or "", "'", "''")) end
local function Q1(db, sql)
    local ok, res = pcall(db, sql)
    if ok and res then return res end
end

-- ---------------------------------------------------------------- Intro
local GUIDE = {
    "Welcome, Hero! This world is wider and stranger than you remember. A few things to know:",
    "|cffff8000Hero path|r - choose Classless (buy any ability), Wildcard (the Dice decides) or Conquest (one of 21 Conquest classes). Talents come from Talent Essence from level 10. Open |cffffd100/ca|r any time.",
    "|cffc41e3aChallenges|r - before level 10 the Challenge Master offers Hardcore, Iron Man, Exile, Lone Wolf, Self-Made and Slow & Steady. Harder road, better rewards, titles at the cap.",
    "|cffff8000Worldforge|r - unique items are hidden all over the world and in dungeons. Nobody will tell you where. Explore, look behind rocks, open old chests.",
    "|cffa335eeMystic Enchants|r - scrolls lie everywhere too. Learn them, turn them on in /ca, and visit the Mystic Altar in any capital inn.",
    "|cff3fc7ebLiving world|r - villages get raided, caravans travel the roads, storms roll in. Bounty Masters in the inns have daily work and sagas. Rent a room with |cffffd100.room|r.",
    "Useful: |cffffd100.guide|r this text, |cffffd100.top|r leaderboards, |cffffd100.season|r the current season, |cffffd100.rep|r city reputation, |cffffd100.collection|r your collections. Good luck!",
}
local function ShowGuide(player, delayed)
    for i, line in ipairs(GUIDE) do
        if delayed then
            player:RegisterEvent(function(_, _, _, p) if p then p:SendBroadcastMessage(ITAG .. line) end end, 4000 + i * 3500, 1)
        else
            player:SendBroadcastMessage(ITAG .. line)
        end
    end
end

local function IntroCheck(player)
    if Q1(CharDBQuery, string.format("SELECT 1 FROM characters.hero_intro WHERE name = '%s'", Key(player))) then return end
    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.hero_intro (name) VALUES ('%s')", Key(player)))
    ShowGuide(player, false)   -- immediate: no timers from the login (world) state
end

-- ---------------------------------------------------------------- Rebirth
local function Rebirths(player)
    local r = Q1(CharDBQuery, string.format("SELECT count FROM characters.hero_rebirth WHERE name = '%s'", Key(player)))
    return r and r:GetUInt32(0) or 0
end

local function ApplyRebirth(player)
    local n = Rebirths(player)
    for i = 0, math.min(5, n) - 1 do
        local ok, has = pcall(function() return player:HasSpell(REBIRTH_SPELL + i) end)
        if ok and not has then pcall(function() player:LearnSpell(REBIRTH_SPELL + i) end) end
    end
end

table.insert(XP_FACTORS, function(player)
    local n = math.min(5, Rebirths(player))
    return 1.0 + 0.10 * n
end)

function PROG_Rebirth(player)
    if player:GetLevel() < MAXLEVEL then player:SendBroadcastMessage(RTAG .. "Only heroes at level " .. MAXLEVEL .. " can be reborn.") return false end
    if player:IsInCombat() then return false end
    local n = Rebirths(player) + 1
    pcall(CharDBExecute, string.format("INSERT INTO characters.hero_rebirth (name, count) VALUES ('%s', 1) ON DUPLICATE KEY UPDATE count = count + 1", Key(player)))
    if HERO_ResetForRebirth then pcall(HERO_ResetForRebirth, player) end
    player:SetLevel(1)
    ApplyRebirth(player)
    pcall(function() player:SetKnownTitle(1409) end)
    if MYS_AddRunes then MYS_AddRunes(player, 10) end
    if SEASON_AddPoints then SEASON_AddPoints(player, 50) end
    player:SendBroadcastMessage(RTAG .. "You are reborn (rebirth " .. n .. ")! Your collections, titles, runes and reputation stay with you. " ..
        "Permanent bonus: +" .. 3 * math.min(5, n) .. "% all stats, +" .. 10 * math.min(5, n) .. "% experience. Unequip gear you can no longer use.")
    if WORLD_News then WORLD_News(player:GetName() .. " has been reborn for the " .. n .. ". time!") end
    return true
end

-- ---------------------------------------------------------------- Seasons
local SEASONS = {
    {key = "storms", name = "Season of Storms", desc = "Storms come twice as often and every elemental slain may drop a rune."},
    {key = "raiders", name = "Season of Raiders", desc = "Villages are raided more often and defenders earn double rewards."},
    {key = "mystic", name = "Season of the Mystic", desc = "Mystic Altars are half price and scrolls you know give two runes."},
    {key = "fortune", name = "Season of Fortune", desc = "Rare creatures drop Worldforged items twice as often."},
    {key = "manastorm", name = "Season of the Tempest", desc = "Manastorms give double runes and season points."},
    {key = "explorer", name = "Season of the Explorer", desc = "Every Worldforged find is worth triple season points."},
}
local function SeasonId() local t = os.date("*t"); return t.year * 100 + t.month end
function SEASON_Current()
    local t = os.date("*t")
    local s = SEASONS[((t.year * 12 + t.month) % #SEASONS) + 1]
    s.id = SeasonId()
    return s
end
function SEASON_Is(key) return SEASON_Current().key == key end

function SEASON_AddPoints(player, n)
    local s = SEASON_Current()
    if s.key == "explorer" and n == 2 then n = 6 end
    if s.key == "manastorm" and n == 20 then n = 40 end
    pcall(CharDBExecute, string.format(
        "INSERT INTO characters.season_points (name, season, points, faction) VALUES ('%s', %d, %d, %d) ON DUPLICATE KEY UPDATE points = points + %d",
        Key(player), s.id, n, player:IsHorde() and 1 or 0, n))
end

local function ShowSeason(player)
    local s = SEASON_Current()
    player:SendBroadcastMessage(STAG .. "|cff33ff99" .. s.name .. "|r - " .. s.desc)
    local r = Q1(CharDBQuery, string.format("SELECT name, points FROM characters.season_points WHERE season = %d ORDER BY points DESC LIMIT 5", s.id))
    local i = 0
    if r then repeat i = i + 1; player:SendBroadcastMessage(STAG .. i .. ". " .. r:GetString(0) .. " - " .. r:GetUInt32(1)) until not r:NextRow() end
    local me = Q1(CharDBQuery, string.format("SELECT points FROM characters.season_points WHERE season = %d AND name = '%s'", s.id, Key(player)))
    player:SendBroadcastMessage(STAG .. "Your points: " .. (me and me:GetUInt32(0) or 0) .. ". The top 3 earn the title Season Champion.")
end

local function SeasonAward(player)
    local cur = SeasonId()
    local prev = (cur % 100 == 1) and (cur - 100 + 11) or (cur - 1)
    local r = Q1(CharDBQuery, string.format("SELECT name FROM characters.season_points WHERE season = %d ORDER BY points DESC LIMIT 3", prev))
    if not r then return end
    repeat
        if r:GetString(0) == player:GetName() and not Q1(CharDBQuery, string.format("SELECT 1 FROM characters.season_awarded WHERE season = %d AND name = '%s'", prev, Key(player))) then
            pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.season_awarded (season, name) VALUES (%d, '%s')", prev, Key(player)))
            pcall(function() player:SetKnownTitle(1410) end)
            if MYS_AddRunes then MYS_AddRunes(player, 15) end
            player:SendBroadcastMessage(STAG .. "|cff33ff99You finished last season in the top 3! Title: Season Champion.|r")
        end
    until not r:NextRow()
end

-- ---------------------------------------------------------------- Leaderboards
local BOARDS = {
    wf = {"Worldforged items", "SELECT name, COUNT(*) c FROM characters.worldforge_looted GROUP BY name ORDER BY c DESC LIMIT 10"},
    mystic = {"Mystic Enchants", "SELECT name, COUNT(*) c FROM characters.mystic_collection GROUP BY name ORDER BY c DESC LIMIT 10"},
    manastorm = {"Manastorm runs", "SELECT name, runs FROM characters.manastorm ORDER BY runs DESC LIMIT 10"},
    hardcore = {"Hardcore heroes alive (level)", "SELECT h.name, c.level FROM characters.hero_challenge h JOIN characters.characters c ON c.name = h.name WHERE h.mode = 'hardcore' AND h.status IN (0, 2) ORDER BY c.level DESC LIMIT 10"},
    rep = {"City reputation", "SELECT name, SUM(rep) r FROM characters.city_rep GROUP BY name ORDER BY r DESC LIMIT 10"},
    rebirth = {"Rebirths", "SELECT name, count FROM characters.hero_rebirth ORDER BY count DESC LIMIT 10"},
}
local function ShowTop(player, which)
    if which == "season" then ShowSeason(player) return end
    local b = BOARDS[which]
    if not b then
        player:SendBroadcastMessage(TTAG .. ".top wf | mystic | manastorm | hardcore | rep | season | rebirth")
        return
    end
    player:SendBroadcastMessage(TTAG .. "|cffffd100" .. b[1] .. "|r")
    local r = Q1(CharDBQuery, b[2])
    local i = 0
    if r then repeat i = i + 1; player:SendBroadcastMessage(TTAG .. i .. ". " .. r:GetString(0) .. " - " .. r:GetString(1)) until not r:NextRow() end
    if i == 0 then player:SendBroadcastMessage(TTAG .. "Nobody yet. Be the first!") end
end

-- ---------------------------------------------------------------- Crafting
local SALVAGE = {[2] = 1, [3] = 2, [4] = 4, [5] = 6, [6] = 8}
local function Salvage(player, text)
    local id = tonumber(string.match(text or "", "item:(%d+)") or string.match(text or "", "(%d+)"))
    if not id or id < 9700001 or id > 9729999 then player:SendBroadcastMessage(CTAG .. "Usage: .salvage <shift-click a Worldforged item>") return end
    if player:GetItemCount(id) < 1 then player:SendBroadcastMessage(CTAG .. "You don't carry that item.") return end
    local q = WorldDBQuery(string.format("SELECT quality FROM worldforge_item WHERE item = %d", id))
    local runes = SALVAGE[q and q:GetUInt32(0) or 2] or 1
    if SEASON_Is("mystic") then runes = runes + 1 end
    player:RemoveItem(id, 1)
    if MYS_AddRunes then MYS_AddRunes(player, runes) end
    player:SendBroadcastMessage(CTAG .. "You break the Worldforged item down into Mystic Runes.")
end

function PROG_ForgeWorldforged(player)
    local cost = 10
    local ok, res = pcall(CharDBQuery, string.format("SELECT runes FROM characters.mystic_runes WHERE name = '%s'", Key(player)))
    local have = (ok and res) and res:GetUInt32(0) or 0
    if have < cost then player:SendBroadcastMessage(CTAG .. "The anvil needs " .. cost .. " Mystic Runes. You have " .. have .. ".") return end
    local lvl = player:GetLevel()
    local q = WorldDBQuery(string.format([[SELECT w.item FROM worldforge_item w JOIN hotfixes.item_sparse s ON s.ID = w.item
        WHERE w.object_name <> '' AND s.RequiredLevel BETWEEN %d AND %d ORDER BY RAND() LIMIT 20]], math.max(1, lvl - 8), lvl + 2))
    if not q then player:SendBroadcastMessage(CTAG .. "The anvil finds nothing fitting your level.") return end
    repeat
        local item = q:GetUInt32(0)
        if not Q1(CharDBQuery, string.format("SELECT 1 FROM characters.worldforge_looted WHERE name = '%s' AND item = %d", Key(player), item)) then
            if player:AddItem(item, 1) then
                pcall(CharDBExecute, string.format("UPDATE characters.mystic_runes SET runes = runes - %d WHERE name = '%s'", cost, Key(player)))
                pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.worldforge_looted (name, item) VALUES ('%s', %d)", Key(player), item))
                player:SendBroadcastMessage(CTAG .. "The Worldforge anvil rings: " .. (GetItemLink(item) or item) .. "!")
                if COLLECTION_Check then pcall(COLLECTION_Check, player) end
            end
            return
        end
    until not q:NextRow()
    player:SendBroadcastMessage(CTAG .. "You already own every Worldforged item the anvil can make for your level.")
end

local function OnLoot(event, player, item, count)
    local ok, cls = pcall(function() return item:GetClass() end)
    if ok and cls == 7 and math.random() < 0.01 and MYS_AddRunes then
        player:SendBroadcastMessage(CTAG .. "Something glimmers among the materials...")
        MYS_AddRunes(player, 1)
    end
end

-- ---------------------------------------------------------------- Guild villages
local function GuildVillage(player, sub)
    local gid = player:GetGuildId()
    if not gid or gid == 0 then player:SendBroadcastMessage(GTAG .. "You are not in a guild.") return end
    local own = Q1(WorldDBQuery, string.format("SELECT area_name, defenses FROM guild_village WHERE guild_id = %d", gid))
    if sub == "adopt" then
        if not player:IsGuildMaster() then player:SendBroadcastMessage(GTAG .. "Only the guild master can adopt a village.") return end
        if own then player:SendBroadcastMessage(GTAG .. "Your guild already protects " .. own:GetString(0) .. ".") return end
        local v, name = WE_VillageAt and WE_VillageAt(player)
        if not v then player:SendBroadcastMessage(GTAG .. "Stand in a village near its inn.") return end
        if Q1(WorldDBQuery, string.format("SELECT 1 FROM guild_village WHERE area = %d", v.area)) then player:SendBroadcastMessage(GTAG .. "Another guild already protects " .. name .. ".") return end
        local cost = 1000000
        if player:GetCoinage() < cost then player:SendBroadcastMessage(GTAG .. "Adopting a village costs 100 gold.") return end
        player:ModifyMoney(-cost)
        WorldDBExecute(string.format("INSERT INTO guild_village (guild_id, guild_name, area, area_name) VALUES (%d, '%s', %d, '%s')",
            gid, (string.gsub(player:GetGuildName() or "", "'", "''")), v.area, (string.gsub(name, "'", "''"))))
        if WORLD_News then WORLD_News("The guild <" .. (player:GetGuildName() or "?") .. "> has sworn to protect " .. name .. ".") end
        player:SendBroadcastMessage(GTAG .. "Your guild now protects " .. name .. ". Members earn double rewards defending it.")
    elseif sub == "abandon" then
        if not player:IsGuildMaster() then return end
        WorldDBExecute(string.format("DELETE FROM guild_village WHERE guild_id = %d", gid))
        player:SendBroadcastMessage(GTAG .. "Your guild no longer protects a village.")
    else
        if own then player:SendBroadcastMessage(GTAG .. "Your guild protects " .. own:GetString(0) .. " (" .. own:GetUInt32(1) .. " defenses).")
        else player:SendBroadcastMessage(GTAG .. "Your guild protects no village. Guild master: .guildvillage adopt (in a village, 100 gold).") end
    end
end

function GV_OnDefended(player, v)
    local gid = player:GetGuildId()
    if not gid or gid == 0 then return end
    local own = Q1(WorldDBQuery, string.format("SELECT area_name FROM guild_village WHERE guild_id = %d AND area = %d", gid, v.area))
    if not own then return end
    WorldDBExecute(string.format("UPDATE guild_village SET defenses = defenses + 1 WHERE guild_id = %d", gid))
    if MYS_AddRunes then MYS_AddRunes(player, 2) end
    player:ModifyMoney(2000 * math.max(1, player:GetLevel()))
    player:SendBroadcastMessage(GTAG .. own:GetString(0) .. " thanks its guardians of <" .. (player:GetGuildName() or "") .. ">! Double reward.")
end

-- ---------------------------------------------------------------- World PvP
local BATTLEFIELDS = {[46] = "Burning Steppes", [51] = "Searing Gorge", [4] = "Blasted Lands", [1377] = "Silithus", [139] = "Eastern Plaguelands",
    [3] = "Badlands", [361] = "Felwood", [618] = "Winterspring", [3523] = "Netherstorm", [210] = "Icecrown"}
local bf = nil            -- {zone, name, ends, kills = {[0]=alliance,[1]=horde}, players = {}}
local bfWinner = {}       -- zone -> {faction, until}
local lastBf = os.time()

local function BfStart()
    local zones = {}
    for z in pairs(BATTLEFIELDS) do zones[#zones + 1] = z end
    local z = zones[math.random(#zones)]
    bf = {zone = z, name = BATTLEFIELDS[z], ends = os.time() + 45 * 60, kills = {[0] = 0, [1] = 0}, players = {}}
    SendWorldMessage(PTAG .. "War breaks out in " .. bf.name .. "! For 45 minutes every Alliance and Horde kill there counts. The winning faction earns runes and +10% experience in the zone.")
    if WORLD_News then WORLD_News("Alliance and Horde clash in " .. bf.name .. "!") end
end

local function BfEnd()
    local a, h = bf.kills[0], bf.kills[1]
    local winner = (a > h) and 0 or ((h > a) and 1 or nil)
    local wname = winner == 0 and "the Alliance" or (winner == 1 and "the Horde" or "nobody")
    SendWorldMessage(PTAG .. "The battle for " .. bf.name .. " is over: " .. wname .. " wins (" .. a .. " : " .. h .. ").")
    if winner then
        bfWinner[bf.zone] = {faction = winner, ["until"] = os.time() + 3 * 3600}
        for name, f in pairs(bf.players) do
            local p = FindPlayer(name)
            if p and f == winner and MYS_AddRunes then MYS_AddRunes(p, 3) end
        end
    end
    bf = nil
end

table.insert(XP_FACTORS, function(player)
    local w = bfWinner[player:GetZoneId()]
    if w and w["until"] > os.time() and (player:IsHorde() and 1 or 0) == w.faction then return 1.10 end
    return 1.0
end)

local function OnPvPKill(event, killer, killed)
    -- map state: the battle itself lives in the world state, shared via lw_state
    local q = WorldDBQuery("SELECT v FROM lw_state WHERE k = 'battlefield'")
    local zone, ends = q and string.match(q:GetString(0), "^(%d+):(%d+)$")
    if not zone or tonumber(zone) ~= killer:GetZoneId() or tonumber(ends) < os.time() then return end
    local f = killer:IsHorde() and 1 or 0
    if (killed:IsHorde() and 1 or 0) == f then return end
    local s = WorldDBQuery("SELECT v FROM lw_state WHERE k = 'bfscore'")
    local a, h = 0, 0
    if s then local x, y = string.match(s:GetString(0), "^(%d+):(%d+)$"); a, h = tonumber(x) or 0, tonumber(y) or 0 end
    if f == 0 then a = a + 1 else h = h + 1 end
    WorldDBExecute(string.format("REPLACE INTO lw_state (k, v) VALUES ('bfscore', '%d:%d')", a, h))
    WorldDBExecute(string.format("REPLACE INTO lw_state (k, v) VALUES ('bfkill:%s', '%d')", (string.gsub(killer:GetName(), "'", "''")), f))
    if ((f == 0) and a or h) % 3 == 0 and MYS_AddRunes then MYS_AddRunes(killer, 1) end
    if SEASON_AddPoints then SEASON_AddPoints(killer, 3) end
end

-- ---------------------------------------------------------------- Mentoring
local MENTOR_GAP = 15
local mentorKills, mentorDay = {}, {}
local function Mentors(player)
    local okG, g = pcall(function() return player:GetGroup() end)
    if not (okG and g) then return {} end
    local out = {}
    for _, m in ipairs(g:GetMembers() or {}) do
        if m ~= player and m:IsInWorld() and m:GetMapId() == player:GetMapId() and m:GetDistance(player) < 100 and m:GetLevel() >= player:GetLevel() + MENTOR_GAP then
            out[#out + 1] = m
        end
    end
    return out
end
table.insert(XP_FACTORS, function(player) return (#Mentors(player) > 0) and 1.25 or 1.0 end)

local function MentorKill(killer, victim)
    -- the mentee killed something: each mentor nearby counts it
    for _, m in ipairs(Mentors(killer)) do
        local k, today = m:GetName(), os.date("%Y-%m-%d")
        if mentorDay[k] ~= today then mentorDay[k] = today; mentorKills[k] = {n = 0, runes = 0} end
        local s = mentorKills[k]
        s.n = s.n + 1
        if s.n % 25 == 0 and s.runes < 5 then
            s.runes = s.runes + 1
            m:SendBroadcastMessage(MTAG .. "Guiding " .. killer:GetName() .. " teaches you as well.")
            if MYS_AddRunes then MYS_AddRunes(m, 1) end
        end
    end
end

-- ---------------------------------------------------------------- hooks
local function Tick()
    local now = os.time()
    if bf and now >= bf.ends then BfEnd() end
    if not bf and now - lastBf >= 3 * 3600 and #MAP_Players() > 0 then lastBf = now; BfStart() end
    -- share the battle with the map states (they count the kills)
    WorldDBExecute(string.format("REPLACE INTO lw_state (k, v) VALUES ('battlefield', '%s')", bf and (bf.zone .. ":" .. bf.ends) or ""))
    if bf then
        local q = WorldDBQuery("SELECT k, v FROM lw_state WHERE k LIKE 'bfkill:%'")
        if q then repeat
            local name, f = string.match(q:GetString(0), "^bfkill:(.*)$"), tonumber(q:GetString(1))
            if name and f then bf.players[name] = f end
        until not q:NextRow() end
        local a = WorldDBQuery("SELECT v FROM lw_state WHERE k = 'bfscore'")
        if a then local x, y = string.match(a:GetString(0), "^(%d+):(%d+)$"); bf.kills[0], bf.kills[1] = tonumber(x) or 0, tonumber(y) or 0 end
    else
        WorldDBExecute("DELETE FROM lw_state WHERE k LIKE 'bfkill:%' OR k = 'bfscore'")
    end
end

if ENABLED then
    RegisterPlayerEvent(3, function(_, player)
        pcall(IntroCheck, player)
        pcall(ApplyRebirth, player)
        pcall(SeasonAward, player)
    end)
    RegisterPlayerEvent(32, OnLoot)
    RegisterPlayerEvent(6, OnPvPKill)
    RegisterPlayerEvent(7, function(_, killer, victim) if victim then MentorKill(killer, victim) end end)
    if IS_WORLD_STATE then CreateLuaEvent(PERF_Wrap("progression.Tick", Tick), 60000, 0) end   -- the battle is run by the world state
    RegisterPlayerEvent(42, function(_, player, command)
        local c = command or ""
        local lc = string.lower(c)
        if lc == "guide" then ShowGuide(player, false) return false end
        if lc == "rebirth" then
            player:SendBroadcastMessage(RTAG .. "Type .rebirth confirm to start over at level 1 (collections, titles, runes and reputation stay).")
            return false
        end
        if lc == "rebirth confirm" then PROG_Rebirth(player) return false end
        if lc == "season" then ShowSeason(player) return false end
        local top = string.match(lc, "^top%s*(%a*)$")
        if top then ShowTop(player, top) return false end
        if string.match(lc, "^salvage") then Salvage(player, c) return false end
        local gv = string.match(lc, "^guildvillage%s*(%a*)$")
        if gv then GuildVillage(player, gv) return false end
        if lc == "battlefield" then
            local q = WorldDBQuery("SELECT v FROM lw_state WHERE k = 'bfscore'")
            if bf and q then local x, y = string.match(q:GetString(0), "^(%d+):(%d+)$"); bf.kills[0], bf.kills[1] = tonumber(x) or 0, tonumber(y) or 0 end
            if bf then player:SendBroadcastMessage(PTAG .. "Battle for " .. bf.name .. ": Alliance " .. bf.kills[0] .. " - Horde " .. bf.kills[1] ..
                ", " .. math.floor((bf.ends - os.time()) / 60) .. " min left.")
            else player:SendBroadcastMessage(PTAG .. "No battle right now. One breaks out every 3 hours.") end
            return false
        end
    end)
    print("[progression] intro, rebirth, leaderboards, seasons (" .. SEASON_Current().name .. "), crafting, guild villages, world PvP, mentoring")
end
