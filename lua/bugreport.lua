-- Bug reports: `.bug <what is wrong>` in chat (or /bug <text> from the Hero UI addon) saves everything useful about the
-- moment into world.bug_reports: who, where, target, nearby NPC, Essence, Hero state, the latest Lua errors of the server
-- and (from the addon) the latest Lua errors of the client. Claude reads them straight from the database.
if not IS_WORLD_STATE then return end   -- chat commands and addon messages are handled in the world state

pcall(WorldDBExecute, [[CREATE TABLE IF NOT EXISTS world.bug_reports (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  player VARCHAR(40), level INT, class INT, race INT, map INT, zone INT, area INT,
  x FLOAT, y FLOAT, z FLOAT, text TEXT, server_info TEXT, client_info TEXT,
  status VARCHAR(12) NOT NULL DEFAULT 'new') ENGINE=InnoDB]])

local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end -- local: Eluna izoluje subory, zdielany global nefunguje

local function LogErrors()
    local out = {}
    local f = io.open("Eluna.log", "r")
    if not f then return "" end
    local size = f:seek("end")
    f:seek("set", math.max(0, size - 60000))
    local text = f:read("*a") or ""
    f:close()
    for line in string.gmatch(text, "[^\r\n]+") do
        if string.find(line, "attempt to") or string.find(line, "bad argument") or string.find(line, "lua_scripts/.-:%d+:") then
            out[#out + 1] = line
        end
    end
    local last = {}
    for i = math.max(1, #out - 6), #out do last[#last + 1] = string.sub(out[i], 1, 220) end
    return table.concat(last, "\n")
end

local function Info(player)
    local t = {}
    local function add(k, v) t[#t + 1] = k .. ": " .. tostring(v) end
    local function try(k, fn) local ok, v = pcall(fn); add(k, ok and v or ("n/a (" .. tostring(v) .. ")")) end
    try("essence", function() return player:GetPower(10) .. "/" .. player:GetMaxPower(10) end)
    try("hero aura", function() return player:HasAura(1400010) end)
    try("in combat", function() return player:IsInCombat() end)
    try("team", function() return player:GetTeam() end)
    try("gold", function() return math.floor(player:GetCoinage() / 10000) end)
    try("target", function()
        local o = player:GetSelection()
        if not o then return "none" end
        local entry = 0
        pcall(function() entry = o:GetEntry() end)
        local name = ""
        pcall(function() name = o:GetName() end)
        local sleeping = false
        pcall(function() sleeping = o:HasAura(17743) end)
        return string.format("%s entry=%d guid=%d dist=%.1f sleepAura=%s", name, entry, o:GetGUIDLow(), player:GetDistance(o), tostring(sleeping))
    end)
    try("nearest NPC", function()
        local c = player:GetNearestCreature(15)
        if not c then return "none" end
        return string.format("%s entry=%d dist=%.1f", c:GetName(), c:GetEntry(), player:GetDistance(c))
    end)
    local q = CharDBQuery(string.format("SELECT path FROM characters.wildcard_path WHERE name = '%s'", Esc(player:GetName())))
    add("hero path", q and q:GetUInt32(0) or "none")
    local s = CharDBQuery(string.format("SELECT charges, draft FROM characters.wildcard_state WHERE name = '%s'", Esc(player:GetName())))
    add("dice", s and (s:GetUInt32(0) .. " rerolls, draft=" .. tostring(s:GetString(1))) or "none")
    local c = CharDBQuery(string.format("SELECT COUNT(*) FROM characters.wildcard_classless WHERE name = '%s'", Esc(player:GetName())))
    add("hero spells", c and c:GetUInt32(0) or 0)
    local errs = LogErrors()
    add("recent server Lua errors", errs == "" and "none" or ("\n" .. errs))
    return table.concat(t, "\n")
end

-- called from the command and from the addon (wildcard.lua passes the client's latest errors)
function BUG_Report(player, text, clientInfo)
    local ok, info = pcall(Info, player)
    if not ok then info = "info failed: " .. tostring(info) end
    local sql = string.format(
        "INSERT INTO world.bug_reports (player, level, class, race, map, zone, area, x, y, z, text, server_info, client_info) VALUES " ..
        "('%s', %d, %d, %d, %d, %d, %d, %f, %f, %f, '%s', '%s', '%s')",
        Esc(player:GetName()), player:GetLevel(), player:GetClass(), player:GetRace(), player:GetMapId(), player:GetZoneId(), player:GetAreaId(),
        player:GetX(), player:GetY(), player:GetZ(), Esc(string.sub(text or "", 1, 1500)), Esc(info), Esc(string.sub(clientInfo or "", 1, 1500)))
    WorldDBExecute(sql)
    player:SendBroadcastMessage("|cff00ccff[Bug report]|r Saved with everything about this moment. Thank you!")
    PrintInfo("[bug] report from " .. player:GetName() .. ": " .. string.sub(text or "", 1, 120))
end

RegisterPlayerEvent(42, function(_, player, command)
    local cmd, rest = string.match(command or "", "^(%S+)%s*(.*)$")
    if not cmd or string.lower(cmd) ~= "bug" then return end
    if rest == "" then
        player:SendBroadcastMessage("|cff00ccff[Bug report]|r Write what is wrong:  .bug <description>  (everything else is collected automatically)")
        return false
    end
    BUG_Report(player, rest, "")
    return false
end)
-- test-realm notice for everybody at login
RegisterPlayerEvent(3, function(_, player)
    player:RegisterEvent(function(_, _, _, p)
        if p and p:IsInWorld() then
            p:SendBroadcastMessage("|cffff8800[TEST REALM]|r This is a test realm. Please report every bug you find: |cff00ccff/bug <what is wrong>|r (or .bug). Lua errors are reported automatically.")
        end
    end, 6000, 1)
end)

-- GMs: .bugs lists the newest reports
RegisterPlayerEvent(42, function(_, player, command)
    if string.lower(command or "") ~= "bugs" or player:GetGMRank() < 1 then return end
    local q = WorldDBQuery("SELECT id, player, map, text FROM world.bug_reports WHERE status='new' ORDER BY id DESC LIMIT 10")
    if not q then player:SendBroadcastMessage("No new bug reports.") return false end
    repeat player:SendBroadcastMessage(string.format("#%d %s (map %d): %s", q:GetUInt32(0), q:GetString(1), q:GetUInt32(2), string.sub(q:GetString(3), 1, 90))) until not q:NextRow()
    return false
end)
print("[bug] reports loaded (.bug <text>, .bugs)")
