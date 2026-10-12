-- Jednorazovy dump skutocnych SpellInfo efektov (DB2 + hotfix merge, to co vidi
-- C++ validacia). Spusti sa len ked vedla worldserver.exe existuje subor
-- spell_dump.run. Vystup: C:/WowServer/Custom/data/spell_merged.csv
-- Format: spell;exists;idx:eff:aura:t1:t2|...
-- Po dobehnuti sa flag subor zmaze. (Vzor: spell_audit.lua.)
if not DumpSpellEffects then return end

local function Run()
    local flag = io.open("spell_dump.run", "r")
    if not flag then return end
    flag:close()
    os.remove("spell_dump.run")
    local ids = {}
    for line in io.lines("C:/WowServer/Custom/data/spell_dump_ids.txt") do
        local id = tonumber(line)
        if id then ids[#ids + 1] = id end
    end
    local out = io.open("C:/WowServer/Custom/data/spell_merged.csv", "w")
    out:write("spell;exists;effects\n")
    for _, id in ipairs(ids) do
        local ok, fx = pcall(DumpSpellEffects, id)
        if ok and fx and fx ~= "" then
            out:write(id .. ";1;" .. string.gsub(fx, "\n", "|") .. "\n")
        else
            out:write(id .. ";0;\n")
        end
    end
    out:close()
    print("[spell_dump] hotovo")
end

RegisterServerEvent(14, function() pcall(Run) end)   -- server startup
