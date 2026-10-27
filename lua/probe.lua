-- probe.lua - temporary diagnostics for the Suramar work (remove when done)
-- .gh x y            ground height at x,y (map of the player)
-- .golist <entry> <range>  nearest gameobject of entry: pos, phase, distance
-- .face x y          turn the character toward x,y (best effort)
if not IS_WORLD_STATE then return end

local function say(player, text)
    PrintInfo("[probe] " .. text)
    pcall(function()
        local f = io.open("ProbeReport.txt", "a")
        if f then f:write(os.date("%H:%M:%S ") .. text .. "\n") f:close() end
    end)
    pcall(function() player:SendBroadcastMessage("|cff00ccff[probe]|r " .. text) end)
end

RegisterPlayerEvent(42, function(_, player, command)
    local cmd, rest = string.match(string.lower(command or ""), "^(%S+)%s*(.*)$")
    if cmd == "gh" then
        local sx, sy = string.match(rest, "([%-%d%.]+)%s+([%-%d%.]+)")
        local x, y = tonumber(sx), tonumber(sy)
        if not x or not y then say(player, "usage: .gh x y") return false end
        local ok, h = pcall(function() return player:GetMap():GetHeight(x, y, player) end)
        say(player, string.format("height %.2f %.2f -> %s (player z %.2f)", x, y,
            ok and h and string.format("%.2f", h) or ("ERR " .. tostring(h)), player:GetZ()))
        return false
    elseif cmd == "golist" then
        local se, sr = string.match(rest, "(%d+)%s*([%d%.]*)")
        local entry, range = tonumber(se), tonumber(sr) or 30
        if not entry then say(player, "usage: .golist <entry> [range]") return false end
        local g = player:GetNearestGameObject(range, entry)
        if not g then say(player, string.format("no GO %d within %d", entry, range)) return false end
        local x, y, z, o = g:GetLocation()
        say(player, string.format("GO %d guid %s pos %.2f %.2f %.2f phase %s dist %.2f inworld %s",
            entry, tostring(g:GetDBTableGUIDLow()), x, y, z, tostring(g:GetPhaseMask()),
            player:GetDistance(g), tostring(g:IsInWorld())))
        return false
    elseif cmd == "luaapi" then
        local pat = rest ~= "" and rest or "Quest"
        local mt = getmetatable(player)
        local idx = mt and mt.__index
        local names = {}
        if type(idx) == "table" then
            for k in pairs(idx) do
                if type(k) == "string" and string.find(string.lower(k), string.lower(pat)) then
                    names[#names + 1] = k
                end
            end
        end
        table.sort(names)
        say(player, "api " .. pat .. " (" .. #names .. "): " .. table.concat(names, ", "))
        return false
    elseif cmd == "face" then
        local sx, sy = string.match(rest, "([%-%d%.]+)%s+([%-%d%.]+)")
        local x, y = tonumber(sx), tonumber(sy)
        if not x or not y then say(player, "usage: .face x y") return false end
        local px, py = player:GetX(), player:GetY()
        local o = math.atan2(y - py, x - px)
        local ok, err = pcall(function() player:SetFacing(o) end)
        say(player, string.format("face %.3f -> %s", o, ok and "ok" or tostring(err)))
        return false
    end
end)
print("[probe] loaded")
