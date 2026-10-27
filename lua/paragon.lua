-- =====================================================================
-- Paragon and Prestige. At the maximum level (90) the Hero is asked once:
--   * Paragon: keep playing. Kills grant Paragon XP; every Paragon level gives +2 maximum Essence and 3 Mystic Runes.
--   * Prestige: start again at level 1. The Hero keeps its Mystic collection, Paragon levels and every Legendary / Immortal /
--     Godly ability; all weaker abilities are forgotten and the path (Classless / Wildcard / Conquest) can be chosen again.
-- Addon messages (prefix WCARD, kind PARA): server -> client "PARA;ASK", client -> server "PARA;1" (Paragon) / "PARA;2" (Prestige) /
-- "PARA;INFO". characters.hero_paragon holds the state.
-- =====================================================================
local MAXL = 90
local CAP_PARAGON = 500

local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end -- local: Eluna izoluje subory, zdielany global nefunguje
local function SendC(p, msg) pcall(function() p:SendAddonMessage("WCARD", msg, 7, p) end) end

pcall(CharDBExecute, [[CREATE TABLE IF NOT EXISTS characters.hero_paragon (name VARCHAR(40) NOT NULL PRIMARY KEY,
  lvl INT UNSIGNED NOT NULL DEFAULT 0, xp BIGINT UNSIGNED NOT NULL DEFAULT 0, prestige INT UNSIGNED NOT NULL DEFAULT 0,
  choice TINYINT UNSIGNED NOT NULL DEFAULT 0) ENGINE=InnoDB]])

local function Get(p)
    local ok, q = pcall(CharDBQuery, "SELECT lvl, xp, prestige, choice FROM characters.hero_paragon WHERE name = '" .. Esc(p:GetName()) .. "'")
    if ok and q then return {lvl = q:GetUInt32(0), xp = tonumber(q:GetUInt64(1)) or 0, prestige = q:GetUInt32(2), choice = q:GetUInt32(3)} end
    return {lvl = 0, xp = 0, prestige = 0, choice = 0}
end
local function Put(p, t)
    pcall(CharDBExecute, string.format("REPLACE INTO characters.hero_paragon (name, lvl, xp, prestige, choice) VALUES ('%s', %d, %d, %d, %d)",
        Esc(p:GetName()), t.lvl, t.xp, t.prestige, t.choice))
end
local function Need(lvl) return 3000 + 300 * lvl end

if not IS_WORLD_STATE then
    -- ------------------------------------------------------------ map states: ask at level 90, Paragon XP from kills
    local CACHE = {}
    local function Cached(p)
        local c = CACHE[p:GetName()]
        if not c then c = Get(p); CACHE[p:GetName()] = c end
        return c
    end
    local function Apply(p) pcall(function() p:Data():Set("para_lvl", Cached(p).lvl) end) end

    RegisterPlayerEvent(13, function(_, player)                     -- level change
        if player:GetLevel() >= MAXL and Get(player).choice == 0 then SendC(player, "PARA;ASK") end
    end)
    RegisterPlayerEvent(28, function(_, player)                     -- map change: refresh the Paragon level the Essence code reads
        CACHE[player:GetName()] = nil
        Apply(player)
    end)
    RegisterPlayerEvent(4, function(_, player) CACHE[player:GetName()] = nil end)   -- logout

    RegisterPlayerEvent(7, function(_, killer, killed)              -- kill: Paragon XP
        if not killer or not killed or killer:GetLevel() < MAXL then return end
        local c = Cached(killer)
        if c.choice ~= 1 or c.lvl >= CAP_PARAGON then return end
        local kl = math.max(1, killed:GetLevel())
        if kl + 10 < killer:GetLevel() then return end              -- grey creatures give nothing
        local gain = kl
        local okE, elite = pcall(function() return killed:IsElite() end)
        if okE and elite then gain = gain * 4 end
        local okB, boss = pcall(function() return killed:IsWorldBoss() or killed:IsDungeonBoss() end)
        if okB and boss then gain = gain * 20 end
        c.xp = c.xp + gain
        local leveled = false
        while c.xp >= Need(c.lvl) and c.lvl < CAP_PARAGON do
            c.xp = c.xp - Need(c.lvl)
            c.lvl = c.lvl + 1
            leveled = true
            if MYS_AddRunes then pcall(MYS_AddRunes, killer, 3) end
            killer:SendBroadcastMessage("|cffffd200[Paragon]|r Paragon level |cff3de6ff" .. c.lvl .. "|r! +2 maximum Essence, +3 Mystic Runes.")
            SendC(killer, "TOAST;Paragon Level " .. c.lvl .. ";+2 max Essence and 3 Mystic Runes")
        end
        if leveled then Apply(killer) end
        if leveled or math.random(10) == 1 then Put(killer, c) end
    end)
    print("[paragon] map hooks loaded")
else
    -- ------------------------------------------------------------ world state: the choice
    local function Say(p, text) p:SendBroadcastMessage("|cffffd200[Paragon]|r " .. text) end

    local function Prestige(p)
        local t = Get(p)
        t.prestige = t.prestige + 1
        t.choice = 0
        -- forget every ability that is not Legendary or better
        local name = Esc(p:GetName())
        local q = CharDBQuery("SELECT spell FROM characters.wildcard_classless WHERE name = '" .. name .. "'")
        local forgot = 0
        if q then
            local ids = {}
            repeat ids[#ids + 1] = q:GetUInt32(0) until not q:NextRow()
            for _, id in ipairs(ids) do
                local rar = HERO_SpellRarity and HERO_SpellRarity(id) or 0
                if rar < 5 then
                    pcall(function() p:RemoveSpell(id) end)
                    pcall(function() p:RemoveActionButtonsForSpell(id) end)
                    CharDBExecute(string.format("DELETE FROM characters.wildcard_classless WHERE name = '%s' AND spell = %d", name, id))
                    forgot = forgot + 1
                end
            end
        end
        CharDBExecute("DELETE FROM characters.wildcard_path WHERE name = '" .. name .. "'")     -- the path can be chosen again
        CharDBExecute("DELETE FROM characters.wildcard_state WHERE name = '" .. name .. "'")
        Put(p, t)
        -- back to the race's starting zone, level 1
        local q2 = WorldDBQuery(string.format("SELECT map, position_x, position_y, position_z, orientation FROM playercreateinfo WHERE race = %d AND class = %d", p:GetRace(), p:GetClass()))
        p:SetLevel(1)
        if q2 then pcall(function() p:Teleport(q2:GetUInt32(0), q2:GetFloat(1), q2:GetFloat(2), q2:GetFloat(3), q2:GetFloat(4)) end) end
        Say(p, "You ascend. Prestige " .. t.prestige .. ": you keep your Mystic collection, your " .. t.lvl .. " Paragon levels and every Legendary ability (" ..
            forgot .. " weaker ones were forgotten). A new path awaits.")
        SendC(p, "TOAST;Prestige " .. t.prestige .. ";A new beginning with your legacy")
        pcall(function() p:AddItem(9750004, 1) end)   -- Token of Prestige
        print("[paragon] " .. p:GetName() .. " prestiged (" .. t.prestige .. ")")
    end

    RegisterServerEvent(30, function(_, sender, _, prefix, msg)
        if prefix ~= "WCARD" or not msg or string.sub(msg, 1, 5) ~= "PARA;" then return end
        local ok, isPlayer = pcall(function() return sender:GetGUIDLow() ~= nil and sender.LearnSpell ~= nil end)
        if not ok or not isPlayer then return end
        local what = string.sub(msg, 6)
        local t = Get(sender)
        if what == "INFO" then
            Say(sender, string.format("Paragon level %d (%d / %d XP), Prestige %d, choice: %s",
                t.lvl, t.xp, Need(t.lvl), t.prestige, t.choice == 1 and "Paragon" or "not chosen"))
        elseif what == "ASK" then
            if sender:GetLevel() >= MAXL then SendC(sender, "PARA;ASK") end
        elseif sender:GetLevel() < MAXL then
            Say(sender, "You must reach level " .. MAXL .. " first.")
        elseif what == "1" then
            if t.choice == 1 then Say(sender, "You already walk the Paragon path.") return end
            t.choice = 1
            Put(sender, t)
            Say(sender, "You continue as a |cff3de6ffParagon|r: kill and quest on, every Paragon level gives +2 maximum Essence and 3 Mystic Runes. (/paragon shows your progress.)")
        elseif what == "2" then
            Prestige(sender)
        end
    end)
    RegisterPlayerEvent(42, function(_, player, command)
        local c = string.lower(command or "")
        if c == "paragon" then
            local t = Get(player)
            Say(player, string.format("Paragon level %d (%d / %d XP), Prestige %d.", t.lvl, t.xp, Need(t.lvl), t.prestige))
            if player:GetLevel() >= MAXL and t.choice == 0 then SendC(player, "PARA;ASK") end
            return false
        end
    end)
    print("[paragon] world hooks loaded")
end
