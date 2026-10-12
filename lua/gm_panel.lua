-- =====================================================================
-- GM panel for the custom systems: .lwgm [status|raid|storm|migration|warlord|traveller|news <text>]
-- Shows the state of every system and starts events by hand for testing. GM rank 1+.
-- =====================================================================
local TAG = "|cff00ff00[GM]|r "

local function Status(p)
    local players = MAP_Players()
    p:SendBroadcastMessage(TAG .. "Players online: " .. #players)
    if WE_GM then p:SendBroadcastMessage(TAG .. "World events - " .. WE_GM(p, "status")) end
    if MANASTORM_Status then p:SendBroadcastMessage(TAG .. "Manastorm - " .. MANASTORM_Status()) end
    if SEASON_Current then local s = SEASON_Current(); p:SendBroadcastMessage(TAG .. "Season - " .. s.name .. ": " .. s.desc) end
    local q = WorldDBQuery("SELECT COUNT(*), SUM(spawn_guid <> 0) FROM worldforge_item")
    if q then p:SendBroadcastMessage(TAG .. "Worldforge items: " .. q:GetUInt32(0) .. " (" .. (q:GetString(1) or "0") .. " placed)") end
    p:SendBroadcastMessage(TAG .. ".lwgm raid | storm | migration | warlord | traveller | news <text>   .lwperf for timings")
end

RegisterPlayerEvent(42, function(_, p, command)
    local cmd, rest = string.match(command or "", "^lwgm%s*(%a*)%s*(.*)$")
    if not cmd then return end
    if p:GetGMRank() < 1 then return end
    cmd = string.lower(cmd)
    if cmd == "" or cmd == "status" then Status(p)
    elseif cmd == "news" and rest ~= "" then if WORLD_News then WORLD_News(rest) end
    elseif cmd == "nwar" then LW_Queue("nwar", p:GetName(), rest or "")
    elseif cmd == "village" then LW_Queue("village", p:GetName(), rest or "")
    elseif cmd == "traveller" then LW_Queue("gmtrav", p:GetName(), "")
    else LW_Queue("gm", p:GetName(), cmd)   -- runs in the map state of the GM
    end
    return false
end)
