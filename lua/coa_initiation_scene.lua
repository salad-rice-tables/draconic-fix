-- "Initiation of Death" (Q 9330014): students arrive at the House of Plagues academy while the player walks to Archon Vel'moth.
-- Started by Korthaz handing out the quest (coa_initiation.lua), driven every 3 s by SyncPhases -> COA_SCENE.Tick, resumes after relog.
-- NPCs are summoned by the player (inherit his phases, so the scene lives in the Maldraxxus phase) and despawn themselves; one scene per player.
-- Route points are the ones from the spec; only the final stand spots get a small ring offset so the crowd does not overlap.
local Q4, INIT, VET, ARCHON, MAPID = 9330014, 9330311, 9330312, 9330301, 2222
local A = {{1380.219971, -3225.459961, 3296.620117}, {1315.745972, -3115.123779, 3294.982422}, {1288.948975, -3086.730225, 3299.855713}, {1268.677856, -3062.880127, 3307.703613},
           {1244.629150, -3036.145508, 3314.010498}, {1224.501587, -3022.416260, 3313.676025}, {1199.042236, -3030.986572, 3310.285400}, {1168.066284, -3052.229004, 3309.448486},
           {1141.126953, -3031.141602, 3300.944824}, {1115.336670, -3015.409912, 3292.145264}, {1093.662720, -3014.799805, 3283.672363}}           -- initiates, lane A (points 1,3-12)
local B = {{1380.219971, -3225.459961, 3296.620117}, {1315.745972, -3115.123779, 3294.982422}, {1288.948975, -3086.730225, 3299.855713}, {1268.677856, -3062.880127, 3307.703613},
           {1244.629150, -3036.145508, 3314.010498}, {1224.501587, -3022.416260, 3313.676025}, {1195.310425, -3033.116943, 3310.314941}, {1170.821045, -3053.032959, 3309.755615},
           {1148.119507, -3042.155273, 3304.671631}, {1134.362061, -3023.243408, 3297.361084}, {1114.286499, -3035.823486, 3292.903076}, {1088.285645, -3066.087646, 3288.645508}}  -- lane B (1,3-7,13-18)
local V = {{1422.019409, -3207.102295, 3282.741455}, {1397.669312, -3193.619629, 3292.307861}, {1371.367920, -3168.508789, 3294.620850}, {1352.747803, -3149.243652, 3297.639893},
           {1314.502441, -3117.716797, 3295.177246}, {1299.564331, -3099.524414, 3296.120850}, {1279.681152, -3080.128662, 3303.227783}, {1255.634766, -3052.426270, 3312.753906},
           {1229.901978, -3028.175537, 3314.710938}, {1206.706177, -3030.023682, 3310.748779}}                                                           -- veterans
local TRIGGER = {1079.181641, -3045.407471, 3284.389893}   -- player enters: the Archon starts to speak
local LINES = {
    "Welcome, new students of the House of Plagues! Come in, come in - the academy has waited for you.",
    "A veteran returns from the field. Well met, Necromancer.",
    "More Initiates! Keep to the path and do not push, there is room for every one of you.",
    "Ah, fresh minds for the grave. Look well at your surroundings: this is where you will learn to command death.",
    "And another veteran! May your blades stay sharp and your dead obedient.",
    "Gather near, Initiates. Your instruction begins shortly.",
    "Good to see you back among the living, veteran. The Initiates could learn much from you.",
    "The last of the new students! Welcome. You chose a hard road, and a fitting one.",
    "The initiation is complete. Speak to me, Initiate, and report.",
}
local CR1, CR2 = 9330321, 9330322   -- quest credits: 1 Join the Initiates, 2 Wait for the Archon (3 Report = credit 9330323 given by his gossip)
pcall(CharDBExecute, "CREATE TABLE IF NOT EXISTS characters.coa_scene (guid INT UNSIGNED NOT NULL PRIMARY KEY, phase TINYINT UNSIGNED NOT NULL DEFAULT 0)")
local function Gid(p) return tostring(p:GetGUIDLow()) end   -- GetGUIDLow is a 64-bit userdata: only usable as a string
local function GetPhase(p) local q = CharDBQuery("SELECT phase FROM characters.coa_scene WHERE guid = " .. Gid(p)); return q and q:GetUInt32(0) or 0 end
local function SetPhase(p, v) CharDBExecute(string.format("REPLACE INTO characters.coa_scene (guid, phase) VALUES (%s, %d)", Gid(p), v)) end
local SC = {}   -- guid -> scene state
local function Dist(p, x, y) return math.sqrt((p:GetX() - x) ^ 2 + (p:GetY() - y) ^ 2) end

local function Despawn(st)
    for _, c in ipairs(st.mobs) do pcall(function() c:DespawnOrUnsummon(0) end) end
    st.mobs = {}
end
local function Speak(p, st, text)
    local a = p:GetNearestCreature(150, ARCHON)
    if a then pcall(function() a:PerformEmote(1); a:SendUnitSay(text, 0) end) end
end
local function Walk(p, st, c, route, k, kind, n)
    local pt = route[k]
    local last = k == #route
    local x, y, z = pt[1], pt[2], pt[3]
    if last then                                          -- ring of stand spots around the final point, 1.6 yd apart per ring
        local ang = (n % 6) * math.pi / 3 + math.floor(n / 6) * 0.5
        local r = 1.4 + math.floor(n / 6) * 1.6
        x, y = x + math.cos(ang) * r, y + math.sin(ang) * r
    end
    pcall(function() c:MoveTo(k, x, y, z) end)
    local d = math.sqrt((c:GetX() - x) ^ 2 + (c:GetY() - y) ^ 2)
    c:RegisterEvent(function(_, _, _, cc)
        if last then
            cc:RegisterEvent(function(_, _, _, c3) pcall(function() c3:DespawnOrUnsummon(0) end) end, 12000, 1)   -- stay a while, then leave
        else pcall(Walk, p, st, cc, route, k + 1, kind, n) end
    end, math.floor(d / 7.5 * 1000) + 400, 1)             -- run speed of a regular NPC ~7.1-8 yd/s
end
local function SpawnOne(p, st, kind)
    local route, entry
    if kind == "vet" then route, entry = V, VET else route, entry = (st.lane % 2 == 0) and A or B, INIT; st.lane = st.lane + 1 end
    local f = route[1]
    local ok, c = pcall(function() return p:SpawnCreature(entry, f[1], f[2], f[3], 0, 3, 300000) end)
    PrintInfo(string.format("[scene] spawn %s ok=%s c=%s", kind, tostring(ok), tostring(c)))
    if not ok or not c then return end
    st.mobs[#st.mobs + 1] = c; st.total = st.total + 1
    local n = st.total
    pcall(function() c:SetFacing(0) end)
    pcall(Walk, p, st, c, route, 2, kind, n)
end

COA_SCENE = {}
function COA_SCENE.Reset(p) SetPhase(p, 0); COA_SCENE.Start(p) end   -- the quest was just handed out
function COA_SCENE.Phase(p) return GetPhase(p) end
function COA_SCENE.Start(p)
    local g = Gid(p)
    if SC[g] then Despawn(SC[g]) end                       -- never two scenes for one player (re-accept / relog)
    PrintInfo("[scene] start " .. g)
    SC[g] = {mobs = {}, line = 0, lane = 0, total = 0, tick = 0}
end
local function TickBody(p)
    local g = Gid(p)
    if p:GetMapId() ~= MAPID then return end
    local st = SC[g]
    if not st then COA_SCENE.Start(p); st = SC[g] end
    local ph = GetPhase(p)
    if ph == 0 and (Dist(p, TRIGGER[1], TRIGGER[2]) < 30 or Dist(p, 1036, -3021) < 30) then   -- the marker area, or already at the Archon            -- objective 1: join the Initiates
        ph = 1; SetPhase(p, 1); pcall(function() p:KilledMonsterCredit(CR1) end); st.line = 0
    end
    if ph == 1 then                                                       -- objective 2: the Archon speaks, one line per 6 s
        st.tick = st.tick + 1
        if st.tick % 2 == 0 then
            st.line = st.line + 1
            Speak(p, st, LINES[st.line])
            if st.line >= #LINES then SetPhase(p, 2); pcall(function() p:KilledMonsterCredit(CR2) end) end
        end
    end
    if ph < 2 and st.total < 60 and #st.mobs < 24 then                    -- crowd: two initiates, then a veteran; they only walk, the quest does not depend on them
        SpawnOne(p, st, (st.total % 3 == 2) and "vet" or "init")
    end
    local alive = {}
    for _, c in ipairs(st.mobs) do
        local ok, live = pcall(function() return c:IsAlive() and c:IsInWorld() end)
        if ok and live then alive[#alive + 1] = c end
    end
    st.mobs = alive
end
function COA_SCENE.Tick(p)   -- the caller's pcall hides errors: log them
    local ok, e = xpcall(TickBody, debug.traceback, p)
    if not ok then PrintError("[scene] " .. tostring(e)) end
end
print("[coa_initiation_scene] loaded")
