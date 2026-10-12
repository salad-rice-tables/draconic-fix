-- =====================================================================
-- Faction wars: every outdoor zone has a control score for Alliance and Horde. Heroes earn points for their faction in the zone they are in:
-- killing hostile creatures (1), elites (4), bosses and chieftains (20), finishing side quests (5) and defending villages (via bonus calls).
-- Scores reset every Monday. The faction with more points owns the zone: its heroes get +10% experience there and a gold bonus for kills; the other
-- side sees "contested". .war shows the zones around you, .war top the leading zones. World News announces a change of control.
-- Table characters.war_zone (zone, alliance, horde, week).
-- =====================================================================
if not IS_WORLD_STATE then
    -- map states: points from kills (experience bonus is applied here too)
    local TAG = "|cffff8000[War]|r "
    local CACHE = {}    -- zone -> {a, h, week, dirty, last}
    local function Week() return math.floor((os.time() + 3 * 86400) / (7 * 86400)) end   -- Monday-based week number
    local function Load(zone)
        local c = CACHE[zone]
        if c and c.week == Week() then return c end
        c = {a = 0, h = 0, week = Week(), dirty = false, last = 0}
        local ok, q = pcall(CharDBQuery, string.format("SELECT alliance, horde, week FROM characters.war_zone WHERE zone = %d", zone))
        if ok and q and q:GetUInt32(2) == Week() then c.a, c.h = q:GetUInt32(0), q:GetUInt32(1) end
        CACHE[zone] = c
        return c
    end
    local function Owner(c)
        if c.a > c.h + 20 then return "A" elseif c.h > c.a + 20 then return "H" end
        return nil
    end
    local function Flush(zone, c)
        pcall(CharDBExecute, string.format("REPLACE INTO characters.war_zone (zone, alliance, horde, week) VALUES (%d, %d, %d, %d)", zone, c.a, c.h, c.week))
        c.dirty, c.last = false, os.time()
    end
    local function Team(p) local ok, t = pcall(function() return p:GetTeam() end); return ok and t == 1 and "H" or "A" end

    function WAR_AddPoints(player, n)
        local zone = player:GetZoneId()
        if not zone or zone == 0 then return end
        local c = Load(zone)
        local before = Owner(c)
        if Team(player) == "H" then c.h = c.h + n else c.a = c.a + n end
        local after = Owner(c)
        c.dirty = true
        if after ~= before and after then
            local name = GetAreaName and GetAreaName(zone) or ("zone " .. zone)
            local msg = TAG .. (after == "H" and "|cffff4040Horde|r" or "|cff4080ffAlliance|r") .. " now controls " .. name .. "!"
            pcall(function() if WORLD_News then WORLD_News(msg) end end)
            Flush(zone, c)
        elseif os.time() - c.last > 120 then Flush(zone, c) end
    end
    function WAR_Owner(zone) return Owner(Load(zone)) end

    RegisterPlayerEvent(7, function(_, killer, killed)
        if not killer or not killed then return end
        if killed:GetLevel() + 12 < killer:GetLevel() then return end
        local pts = 1
        local okE, elite = pcall(function() return killed:IsElite() end)
        if okE and elite then pts = 4 end
        local okB, boss = pcall(function() return killed:IsWorldBoss() or killed:IsDungeonBoss() end)
        if (okB and boss) or (killed:GetEntry() >= 9901001 and killed:GetEntry() <= 9901999) then pts = 20 end
        WAR_AddPoints(killer, pts)
        local zone = killer:GetZoneId()
        if zone and zone ~= 0 and Owner(Load(zone)) == Team(killer) then
            pcall(function() killer:ModifyMoney(math.max(1, math.floor(killed:GetLevel() * 2))) end)
        end
    end)
    RegisterPlayerEvent(12, function(_, player, xp, victim)         -- ON_GIVE_XP: +10% experience in a zone your faction controls
        local zone = player:GetZoneId()
        if zone and zone ~= 0 and Owner(Load(zone)) == Team(player) and type(xp) == "number" then return math.floor(xp * 1.10) end
    end)
    print("[war] zone control loaded")
else
    -- world state: commands
    pcall(CharDBExecute, [[CREATE TABLE IF NOT EXISTS characters.war_zone (zone INT UNSIGNED NOT NULL PRIMARY KEY, alliance INT UNSIGNED NOT NULL DEFAULT 0,
      horde INT UNSIGNED NOT NULL DEFAULT 0, week INT UNSIGNED NOT NULL DEFAULT 0) ENGINE=InnoDB]])
    local function Week() return math.floor((os.time() + 3 * 86400) / (7 * 86400)) end
    RegisterPlayerEvent(42, function(_, player, command)
        local c = string.lower(command or "")
        if c ~= "war" and c ~= "war top" then return end
        local q
        if c == "war top" then
            q = CharDBQuery("SELECT zone, alliance, horde FROM characters.war_zone WHERE week = " .. Week() .. " ORDER BY alliance + horde DESC LIMIT 8")
            player:SendBroadcastMessage("|cffff8000[War]|r Most contested zones this week:")
        else
            q = CharDBQuery("SELECT zone, alliance, horde FROM characters.war_zone WHERE week = " .. Week() .. " AND zone = " .. player:GetZoneId())
            player:SendBroadcastMessage("|cffff8000[War]|r This zone:")
        end
        if not q then player:SendBroadcastMessage("  no battles yet this week") return false end
        repeat
            local z, a, h = q:GetUInt32(0), q:GetUInt32(1), q:GetUInt32(2)
            local name = GetAreaName and GetAreaName(z) or tostring(z)
            player:SendBroadcastMessage(string.format("  %s: |cff4080ffAlliance %d|r vs |cffff4040Horde %d|r %s", name, a, h,
                (a > h + 20 and "(Alliance control)") or (h > a + 20 and "(Horde control)") or "(contested)"))
        until not q:NextRow()
        return false
    end)
    print("[war] commands loaded")
end
