-- One-off Hero spell audit: when the file spell_audit.run exists next to worldserver, every ability and talent of
-- wildcard.lua is checked for casting requirements (form, aura, weapon, stealth) and the result is written to
-- C:/WowServer/Custom/data/spell_audit.csv. The flag file is removed afterwards.
if not IS_WORLD_STATE or not GetSpellReq then return end

local function Run()
    local flag = io.open("spell_audit.run", "r")
    if not flag then return end
    flag:close()
    os.remove("spell_audit.run")
    local src = io.open("lua_scripts/wildcard.lua", "r")
    if not src then return end
    local text = src:read("*a")
    src:close()
    local out = io.open("C:/WowServer/Custom/data/spell_audit.csv", "w")
    out:write("spell,stances,stancesNot,casterAura,targetAura,equippedClass,stealth,exclCasterAura\n")
    local seen, n = {}, 0
    for id in string.gmatch(text, "{(%d+), \"") do
        id = tonumber(id)
        if not seen[id] then
            seen[id] = true
            local r = GetSpellReq(id)
            out:write(id .. "," .. string.gsub(r or "missing;;;;;;", ";", ",") .. "\n")
            n = n + 1
        end
    end
    out:close()
    -- visuals that are only shown for a specialization / condition (rows with a non-zero condition id)
    if GetSpellVisualRows then
        local vf = io.open("C:/WowServer/Custom/data/spell_visuals.csv", "w")
        vf:write("spell,ID,difficulty,visualId,probability,flags,priority,icon,activeIcon,viewerUnit,viewerPlayer,casterUnit,casterPlayer\n")
        local nv = io.open("C:/WowServer/Custom/data/spell_novisual.csv", "w")
        nv:write("spell\n")
        local total, cond = 0, 0
        for id in pairs(seen) do
            local rows = GetSpellVisualRows(id)
            if not rows or rows == "" then nv:write(id .. "\n") end
            for line in string.gmatch(rows or "", "[^\n]+") do
                total = total + 1
                local f = {}
                for v in string.gmatch(line, "[^;]+") do f[#f + 1] = v end
                if (tonumber(f[9]) or 0) ~= 0 or (tonumber(f[10]) or 0) ~= 0 or (tonumber(f[11]) or 0) ~= 0 or (tonumber(f[12]) or 0) ~= 0 then
                    cond = cond + 1
                    vf:write(id .. "," .. string.gsub(line, ";", ",") .. "\n")
                end
            end
        end
        vf:close()
        nv:close()
        print("[spell_audit] visuals: " .. total .. " rows, " .. cond .. " with conditions")
    end
    print("[spell_audit] wrote " .. n .. " spells")
end

RegisterServerEvent(14, function() pcall(Run) end)   -- server startup

-- CoA clone mode: dump every visual row of the source spells listed in coa_sources.txt (flag file coa_visuals.run)
local function RunClone()
    local flag = io.open("coa_visuals.run", "r")
    if not flag then return end
    flag:close()
    os.remove("coa_visuals.run")
    local src = io.open("C:/WowServer/Custom/data/coa_sources.txt", "r")
    if not src or not GetSpellVisualRows then return end
    local out = io.open("C:/WowServer/Custom/data/coa_visuals.csv", "w")
    out:write("spell,ID,difficulty,visualId,probability,flags,priority,icon,activeIcon,viewerUnit,viewerPlayer,casterUnit,casterPlayer\n")
    for line in src:lines() do
        local id = tonumber(line)
        if id then
            for row in string.gmatch(GetSpellVisualRows(id) or "", "[^\n]+") do
                out:write(id .. "," .. string.gsub(row, ";", ",") .. "\n")
            end
        end
    end
    src:close()
    out:close()
    print("[spell_audit] coa visuals dumped")
end
RegisterServerEvent(14, function() pcall(RunClone) end)
