-- GM test command ".scn <name>": plays a CoA gameplay scenario (data/coa/scenarios/<name>.json, copied from the CoA repo apps/coa-gameplay-test) on the GM's own character.
-- It only INTERPRETS data: a JSON file is parsed and a fixed whitelist of steps is executed (learn, unlearn, cast, reset_cooldown, set_power, set_health, wait, assert).
-- Nothing from the file is ever executed as code. Unknown steps / metrics are reported as SKIP. Result: Custom/logs/scn_<name>.txt and the GM's chat.
-- CoA spell / creature ids (>= 100000) get the Midnight offset +7000000. GM rank 1+ only.
local DIR = "C:/WowServer/Custom/data/coa/scenarios/"
local OUT = "C:/WowServer/Custom/logs/scn_"
local OFF = 7000000

-- ---- minimal JSON decoder (data only)
local function Decode(s)
    local i = 1
    local function ws() i = s:find("[^ \t\r\n]", i) or (#s + 1) end
    local val
    local function str()
        local j = i + 1; local out = {}
        while true do
            local c = s:sub(j, j)
            if c == '"' then i = j + 1; return table.concat(out) end
            if c == "\\" then
                local n = s:sub(j + 1, j + 1)
                local map = { n = "\n", t = "\t", r = "\r", b = "\b", f = "\f", ["/"] = "/", ["\\"] = "\\", ['"'] = '"' }
                if n == "u" then out[#out + 1] = "?"; j = j + 6 else out[#out + 1] = map[n] or n; j = j + 2 end
            else out[#out + 1] = c; j = j + 1 end
        end
    end
    function val()
        ws(); local c = s:sub(i, i)
        if c == "{" then
            local t = {}; i = i + 1; ws()
            if s:sub(i, i) == "}" then i = i + 1; return t end
            while true do
                ws(); local k = str(); ws(); i = i + 1   -- ':'
                t[k] = val(); ws()
                local d = s:sub(i, i); i = i + 1
                if d == "}" then return t end
            end
        elseif c == "[" then
            local t = {}; i = i + 1; ws()
            if s:sub(i, i) == "]" then i = i + 1; return t end
            while true do
                t[#t + 1] = val(); ws()
                local d = s:sub(i, i); i = i + 1
                if d == "]" then return t end
            end
        elseif c == '"' then return str()
        elseif s:sub(i, i + 3) == "true" then i = i + 4; return true
        elseif s:sub(i, i + 4) == "false" then i = i + 5; return false
        elseif s:sub(i, i + 3) == "null" then i = i + 4; return nil
        else
            local num = s:match("^-?%d+%.?%d*[eE]?[+-]?%d*", i); i = i + #num; return tonumber(num)
        end
    end
    return val()
end

local function Num(v) return tonumber(tostring(v)) or 0 end
local function Sp(id) id = tonumber(id) or 0; if id >= 100000 then return id + OFF end return id end

local function Run(player, name, onDone)
    local f = io.open(DIR .. name .. ".json", "r")
    if not f then player:SendBroadcastMessage("[scn] not found: " .. name); return end
    local text = f:read("*a"); f:close()
    text = text:gsub("^\239\187\191", "")
    local ok, sc = pcall(Decode, text)
    if not ok or type(sc) ~= "table" then player:SendBroadcastMessage("[scn] cannot parse " .. name); return end
    local guid = Num(player:GetGUIDLow())
    local res, pass, fail, skip = {}, 0, 0, 0
    local spawned = {}
    local function log(s) res[#res + 1] = s end
    log("SCENARIO " .. tostring(sc.name))
    -- creatures of the scenario (hostile target dummies near the player)
    for _, c in ipairs(sc.creatures or {}) do
        local d = tonumber(c.distance) or 6
        local o = player:GetO()
        local cr = player:SpawnCreature(Sp(c.entry), player:GetX() + d * math.cos(o), player:GetY() + d * math.sin(o), player:GetZ(), o + math.pi, 8)
        if cr then
            pcall(function() cr:SetFaction(14); cr:SetMaxHealth(Num(c.health) > 0 and Num(c.health) or 1000000); cr:SetHealth(Num(c.health) > 0 and Num(c.health) or 1000000) end)
            spawned[#spawned + 1] = cr; spawned[c.id or #spawned] = cr
        end
    end
    local function target() return spawned[1] end
    local steps = sc.steps or {}
    local idx, waited = 0, 0
    local actorId = sc.players and sc.players[1] and sc.players[1].id or "n"

    local function Metric(st)
        local m = st.metric
        local sp = Sp(st.spell)
        if m == "aura" then
            return player:HasAura(sp) and 1 or 0
        elseif m == "aura_stacks" then
            local a = player:GetAura(sp); return a and a:GetStackAmount() or 0
        elseif m == "owned_creature_count" then
            local n = 0
            local ok2, list = pcall(function() return player:GetCreaturesInRange(60) end)
            local seen, owners = 0, {}
            if ok2 and list then for _, c in ipairs(list) do
                if c:GetEntry() ~= Sp(st.entry) then goto continue end
                seen = seen + 1
                local okc, ow = pcall(function() return c:GetOwner() end)
                local og = (okc and ow) and tostring(Num(ow:GetGUIDLow())) or "none"
                owners[#owners + 1] = og
                if c:IsAlive() and (not okc or not ow or tonumber(og) == guid) then n = n + 1 end   -- owner unknown (guardian) counts too
                ::continue::
            end end
            LASTDBG = string.format("range query ok=%s found=%d owners=%s me=%d", tostring(ok2), seen, table.concat(owners, ","), guid)
            return n
        elseif m == "cooldown_ms" then return Num(player:GetSpellCooldownDelay(sp))
        elseif m == "health" then return Num(player:GetHealth())
        elseif m == "power" then return Num(player:GetPower(st.power or 0))
        end
        return nil
    end

    local function Finish()
        for _, c in ipairs(spawned) do pcall(function() c:DespawnOrUnsummon(0) end) end
        log(string.format("PASS %d  FAIL %d  SKIP %d", pass, fail, skip))
        local o = io.open(OUT .. name .. ".txt", "w")
        if o then o:write(table.concat(res, "\n") .. "\n"); o:close() end
        pcall(function() player:SendBroadcastMessage(string.format("[scn] %s: PASS %d FAIL %d SKIP %d (Custom/logs/scn_%s.txt)", name, pass, fail, skip, name)) end)
        if onDone then player:RegisterEvent(function() onDone(pass, fail, skip) end, 1500, 1) end
    end

    local function Step()
        idx = idx + 1
        local st = steps[idx]
        if not st then Finish(); return end
        local a, delay = st.action, 100
        if a == "wait" then delay = math.min(tonumber(st.ms) or 500, 1000)
        elseif a == "learn" then pcall(function() player:LearnSpell(Sp(st.spell)) end)
        elseif a == "unlearn" then pcall(function() player:RemoveSpell(Sp(st.spell)) end)
        elseif a == "reset_cooldown" then pcall(function() player:ResetSpellCooldown(Sp(st.spell), true) end)
        elseif a == "set_power" then pcall(function() player:SetPower(tonumber(st.value) or 0, tonumber(st.power) or 0) end)
        elseif a == "set_health" then pcall(function() player:SetHealth(tonumber(st.value) or 1) end)
        elseif a == "cast" then
            local t = target() or player
            pcall(function() player:SetSelection(t:GetGUID()) end)
            pcall(function() player:CastSpell(t, Sp(st.spell), true) end)
            delay = 300
        elseif a == "assert" then
            if st.actor and st.actor ~= actorId then
                skip = skip + 1; log("SKIP   " .. tostring(st.label) .. "  [actor " .. tostring(st.actor) .. "]")
            else
                local actual, want = Metric(st)
                if actual == nil then skip = skip + 1; log("SKIP   " .. tostring(st.label) .. "  [metric " .. tostring(st.metric) .. "]")
                else
                    local good
                    if st.equals ~= nil then good = (actual == tonumber(st.equals)) or (type(st.equals) == "boolean" and actual == (st.equals and 1 or 0))
                    else good = (st.min == nil or actual >= st.min) and (st.max == nil or actual <= st.max) end
                    if not good and waited < math.min(tonumber(st.within_ms) or 0, 2000) then
                        waited = waited + 250; idx = idx - 1; delay = 250   -- poll again until within_ms has passed
                    else
                        waited = 0
                        if good then pass = pass + 1; log("PASS   " .. tostring(st.label))
                        else fail = fail + 1; log("FAIL   " .. tostring(st.label) .. (LASTDBG and ("  {" .. LASTDBG .. "}") or "") .. "  [" .. tostring(st.metric) .. " actual " .. tostring(actual) .. " expected " .. tostring(st.equals or ("min " .. tostring(st.min) .. " max " .. tostring(st.max))) .. "]") end
                    end
                end
            end
        else skip = skip + 1; log("SKIP   step " .. tostring(a)) end
        player:RegisterEvent(function(_, _, _, p) Step() end, delay, 1)
    end
    Step()
end

RegisterPlayerEvent(42, function(_, player, command)
    if not player then return end
    local a = {}
    for w in string.gmatch(tostring(command or ""), "%S+") do a[#a + 1] = w end
    if string.lower(a[1] or "") ~= "scn" or player:GetGMRank() < 1 then return end
    if not a[2] then player:SendBroadcastMessage("[scn] usage: .scn <scenario-file-name-without-.json>"); return false end
    if a[2] == "all" then   -- ".scn all [prefix]": every scenario of the index (optionally only names starting with prefix), one after the other, summary in logs/scn_summary.txt
        local f = io.open(DIR .. "index.txt", "r")
        if not f then player:SendBroadcastMessage("[scn] no index.txt"); return false end
        local names = {}
        for l in f:lines() do l = l:gsub("%s+$", ""); if l ~= "" and (not a[3] or l:sub(1, #a[3]) == a[3]) then names[#names + 1] = l end end
        f:close()
        local sum, i = {}, 0
        local function Next()
            i = i + 1
            if not names[i] then
                local o = io.open("C:/WowServer/Custom/logs/scn_summary.txt", "w"); if o then o:write(table.concat(sum, "\n") .. "\n"); o:close() end
                player:SendBroadcastMessage("[scn] all done: " .. #names .. " scenarios, summary in logs/scn_summary.txt"); return
            end
            Run(player, names[i], function(p, fl, sk) sum[#sum + 1] = string.format("%-70s PASS %3d FAIL %3d SKIP %3d", names[i], p, fl, sk); Next() end)
        end
        Next(); return false
    end
    Run(player, a[2])
    return false
end)
