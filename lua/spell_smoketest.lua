-- Wildcard smoke test: casts every spell of data/spell_dump_ids.txt on a training dummy (then on the tester himself) and records whether
-- ANYTHING observable happened. Runs only while the flag file "spell_smoke.run" exists next to worldserver.exe, in the map state of the
-- first GM (level 3+) player found. Progress is saved before every cast: after a crash the run resumes and marks the spell that was being
-- cast as CRASH.  Output: C:/WowServer/Custom/data/smoketest_results.csv   (spell;result;detail)
if IS_WORLD_STATE or not MAP_Timer then return end

local VISUAL = false
local IDS_FILE   = "C:/WowServer/Custom/data/spell_dump_ids.txt"
local OUT_FILE   = "C:/WowServer/Custom/data/smoketest_results.csv"
local PROG_FILE  = "C:/WowServer/Custom/data/smoketest_progress.txt"
do   -- the flag file may name a round: "round2" tests the class spells outside the pool (separate id list, results and progress)
    local f = io.open("spell_smoke.run", "r")
    local word = f and f:read("*l") or ""
    if f then f:close() end
    if word == "round2" then
        IDS_FILE  = "C:/WowServer/Custom/data/spell_ids_round2_class.txt"
        OUT_FILE  = "C:/WowServer/Custom/data/smoketest_results_round2.csv"
        PROG_FILE = "C:/WowServer/Custom/data/smoketest_progress_round2.txt"
    elseif word == "round3" then   -- everything else we have: class spells, hero extras, skill line spells, Wildcard talents (1 999 ids)
        IDS_FILE  = "C:/WowServer/Custom/data/spell_ids_round3_all.txt"
        OUT_FILE  = "C:/WowServer/Custom/data/smoketest_results_round3.csv"
        PROG_FILE = "C:/WowServer/Custom/data/smoketest_progress_round3.txt"
    elseif word == "visual" then   -- slow show mode: every spell is cast visibly with 3 seconds to watch it (pool, results in smoketest_results_visual.csv)
        OUT_FILE  = "C:/WowServer/Custom/data/smoketest_results_visual.csv"
        PROG_FILE = "C:/WowServer/Custom/data/smoketest_progress_visual.txt"
        VISUAL = true
    elseif word == "pool2" then   -- the pool again with damage/heal amounts and spell parameters in the results
        OUT_FILE  = "C:/WowServer/Custom/data/smoketest_results_pool2.csv"
        PROG_FILE = "C:/WowServer/Custom/data/smoketest_progress_pool2.txt"
    end
end
local DUMMY      = 31146      -- Raider's Training Dummy
local SKIP_EFFECTS = {[5] = true, [85] = true, [18] = true, [113] = true, [252] = true, [87] = true, [39] = true}   -- teleports, summon player, resurrects

local st = {i = 0, hold = 0, ids = nil, dummy = nil, phase = 0, started = false, wait = 0}

local function Append(spell, result, detail)
    local f = io.open(OUT_FILE, "a")
    if f then f:write(spell, ";", result, ";", detail or "", "\n"); f:close() end
end
local function Flag() local f = io.open("spell_smoke.run", "r"); if f then f:close(); return true end return false end
local function SaveProgress(i, id)
    local f = io.open(PROG_FILE, "w"); if f then f:write(i, ";", id or 0, "\n"); f:close() end
end
local function ReadProgress()
    local f = io.open(PROG_FILE, "r"); if not f then return 0, 0 end
    local l = f:read("*l") or ""; f:close()
    local a, b = string.match(l, "(%d+);(%d+)")
    return tonumber(a) or 0, tonumber(b) or 0
end

local TESTER_NAME = "Havik"   -- only this character is ever used; he is resurrected whenever he dies
local function Tester()
    for _, p in ipairs(MAP_Players()) do
        if p:GetName() == TESTER_NAME then
            if not p:IsAlive() then
                pcall(function() p:ResurrectPlayer(100, false) end)
                pcall(function() p:SpawnBones() end)
                return nil
            end
            return p
        end
    end
    return nil
end

local function Snapshot(p, d)
    local s = {}
    s.pHp = p:GetHealth(); s.dHp = d:GetHealth()
    s.px, s.py, s.pz = p:GetLocation()
    s.dx, s.dy = d:GetLocation()
    s.cre = {}
    local ok, near = pcall(function() return p:GetCreaturesInRange(60, 0, 0, 1) end)
    if ok and near then for _, c in ipairs(near) do s.cre[tostring(c:GetGUID())] = true end end
    return s
end

local function Diff(p, d, id, before)
    local why = {}
    if d:GetHealth() < before.dHp then why[#why + 1] = "damage=" .. (before.dHp - d:GetHealth()) end
    if p:GetHealth() > before.pHp then why[#why + 1] = "heal=" .. (p:GetHealth() - before.pHp) end
    if p:HasAura(id) then why[#why + 1] = "self-aura" end
    if d:HasAura(id) then why[#why + 1] = "target-aura" end
    local x, y = p:GetLocation()
    if math.abs(x - before.px) + math.abs(y - before.py) > 1.5 then why[#why + 1] = "moved" end
    local dx, dy = d:GetLocation()
    if math.abs(dx - before.dx) + math.abs(dy - before.dy) > 1.0 then why[#why + 1] = "target-moved" end
    local ok, near = pcall(function() return p:GetCreaturesInRange(60, 0, 0, 1) end)
    if ok and near then
        for _, c in ipairs(near) do
            if not before.cre[tostring(c:GetGUID())] then
                why[#why + 1] = "summon"
                pcall(function() c:DespawnOrUnsummon(0) end)
            end
        end
    end
    return why
end

local function Cleanup(p, d, id, before, keepDummy)
    pcall(function() p:RemoveAura(id) end)
    if not keepDummy then
        pcall(function() d:DespawnOrUnsummon(0) end)   -- a fresh dummy per spell (RemoveAllAuras on it tripped a core assertion)
        st.dummy = nil
    end
    pcall(function() p:SetHealth(p:GetMaxHealth()) end)
    local x, y = p:GetLocation()
    if math.abs(x - before.px) + math.abs(y - before.py) > 1.0 then
        pcall(function() p:NearTeleport(before.px, before.py, before.pz, p:GetO()) end)
    end
    pcall(function() p:InterruptSpell(0) end)
    pcall(function() p:Dismount() end)
end

local function Tick()
    if not Flag() then return end
    local p = Tester()
    if not p then return end
    if st.hold and st.hold > 0 then st.hold = st.hold - 1 return end
    if not st.started then
        st.ids = {}
        for line in io.lines(IDS_FILE) do local n = tonumber(line); if n then st.ids[#st.ids + 1] = n end end
        local i, id = ReadProgress()
        if i > 0 then Append(id, "CRASH", "server went down while this spell was cast (or the test was interrupted)") end
        st.i = i; st.phase = 0; st.started = true
        print("[smoketest] starting at " .. (i + 1) .. " of " .. #st.ids .. " by " .. p:GetName())
    end
    if not st.dummy or not st.dummy:IsAlive() or not st.dummy:IsInWorld() then
        local x, y, z, o = p:GetLocation()
        local d = p:SpawnCreature(DUMMY, x + math.cos(o) * 6, y + math.sin(o) * 6, z, o + 3.14, 8, 0)
        if not d then Append(0, "ABORT", "cannot spawn dummy"); os.remove("spell_smoke.run"); return end
        pcall(function() d:SetMaxHealth(2000000000); d:SetHealth(2000000000) end)
        st.dummy = d
        return
    end
    local d = st.dummy
    if st.phase == 0 then
        st.i = st.i + 1
        if st.i > #st.ids then
            Append(0, "DONE", #st.ids .. " spells")
            os.remove("spell_smoke.run")
            pcall(function() d:DespawnOrUnsummon(0) end)
            print("[smoketest] finished")
            return
        end
        local id = st.ids[st.i]
        SaveProgress(st.i, id)
        if st.i % 25 == 0 then pcall(function() p:SendBroadcastMessage("|cff00ccff[Test]|r spell " .. st.i .. " / " .. #st.ids) end) end
        -- spells that teleport through a triggered spell (Death Gate, Portals, Recall...) cannot be recognised by their own effects: skip by name
        local okn, qn = pcall(WorldDBQuery, "SELECT name FROM world.hero_spell_names WHERE spell_id = " .. id .. " LIMIT 1")
        if okn and qn then
            local nm = string.lower(qn:GetString(0))
            if string.find(nm, "gate") or string.find(nm, "teleport") or string.find(nm, "portal") or string.find(nm, "recall") or string.find(nm, "pilgrimage")
               or string.find(nm, "dreamwalk") or string.find(nm, "door of") or string.find(nm, "return") or string.find(nm, "hearth") or string.find(nm, "wormhole")
               or string.find(nm, "summon player") or string.find(nm, "ritual of summoning") or string.find(nm, "astral") then
                Append(id, "SKIPPED", "teleport by name: " .. nm); return
            end
        end
        if id == 50977 then Append(id, "SKIPPED", "Death Gate"); return end
        local okfx, fx = pcall(DumpSpellEffects, id)
        if okfx and fx then
            for e, ta, tb in string.gmatch(fx, "%d+;(%d+);%d+;(%-?%d+);(%-?%d+)") do
                if SKIP_EFFECTS[tonumber(e)] then Append(id, "SKIPPED", "teleport/resurrect effect"); return end
                ta, tb = tonumber(ta), tonumber(tb)
                if ta == 23 or ta == 26 or tb == 23 or tb == 26 then Append(id, "SKIPPED", "needs an object/item target (would trip a core assertion)"); return end
            end
        end
        pcall(function() p:SetHealth(math.floor(p:GetMaxHealth() * 0.5)) end)
        st.before = Snapshot(p, d)
        st.id = id
        pcall(function() p:CastSpell(d, id, true) end)
        st.phase = 1
        if VISUAL then st.hold = 5 end
    elseif st.phase == 1 then
        local why = Diff(p, d, st.id, st.before)
        if #why > 0 then
            Append(st.id, "OK", table.concat(why, ","))
            Cleanup(p, d, st.id, st.before)
            st.phase = 0
        else
            Cleanup(p, d, st.id, st.before, true)
            pcall(function() p:SetHealth(math.floor(p:GetMaxHealth() * 0.5)) end)
            st.before = Snapshot(p, d)
            pcall(function() p:CastSpell(p, st.id, true) end)
            st.phase = 2
            if VISUAL then st.hold = 5 end
        end
    else
        local why = Diff(p, d, st.id, st.before)
        Append(st.id, #why > 0 and "OK" or "NOEFFECT", table.concat(why, ","))
        Cleanup(p, d, st.id, st.before)
        st.phase = 0
    end
end

MAP_Timer("smoketest", function() pcall(Tick) end, 500)
print("[smoketest] loaded (waits for spell_smoke.run)")

-- Emergency cleanup of the tester: with a spell_cleanup.run flag file every GM player on this map loses all auras, mount, root/stun and gets full health once.
MAP_Timer("smoketest.cleanup", function()
    local f = io.open("spell_cleanup.run", "r")
    if not f then return end
    f:close()
    local done = false
    for _, p in ipairs(MAP_Players()) do
        if p:GetName() == TESTER_NAME then
            pcall(function() p:RemoveAllAuras() end)
            pcall(function() p:Dismount() end)
            pcall(function() p:SetRooted(false) end)
            pcall(function() p:SetStunned(false) end)
            pcall(function() p:InterruptSpell(0) end)
            pcall(function() p:SetHealth(p:GetMaxHealth()) end)
            print("[smoketest] cleaned " .. p:GetName())
            done = true
        end
    end
    if done then os.remove("spell_cleanup.run") end
end, 1000)
