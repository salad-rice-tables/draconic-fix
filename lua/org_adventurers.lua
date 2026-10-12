-- =====================================================================
-- Portal-room adventurers (Orgrimmar + Stormwind).
-- Every 45-90 s a random adventurer teleports in near the portal room
-- (spell 1250804), walks to a random portal, casts again and despawns.
-- Max 2 active per city. Loads at worldserver start. (Eluna required)
-- =====================================================================

local PORTAL_SPELL = 1250804
local MAX_ACTIVE = 4

local ADVENTURERS = {149290, 149296, 149297, 149371, 149404, 149408,
                     149409, 198070, 225509, 150968, 255062}

-- {x, y, z} spawn aprons near each portal room (measured in-game via .gps)
local ORG_SPAWNS = {
    {1436.43, -4421.53, 25.45}, {1432.00, -4425.00, 25.45}, {1441.00, -4418.00, 25.45},
}
local SW_SPAWNS = {
    {-9055.0, 955.0, 68.3}, {-9045.0, 945.0, 68.3}, {-9060.0, 960.0, 68.3},
}

-- {x, y, z, "Destination name"} portal targets, Orgrimmar Valley of Spirits room
local ORG_PORTALS = {
    {1463.78, -4501.95, 20.3, "Azsuna"}, {1422.59, -4484.15, 20.2, "Dalaran"},
    {1416.71, -4505.75, 19.8, "the Jade Forest"}, {1438.87, -4455.36, 20.3, "Silvermoon"},
    {1445.05, -4513.05, 20.3, "Zuldazar"}, {1413.39, -4487.38, 20.3, "the Caverns of Time"},
    {1424.01, -4506.62, 20.3, "Shattrath"}, {1468.30, -4521.12, 20.3, "Oribos"},
    {1419.26, -4465.98, 20.3, "Warspear"}, {1473.25, -4499.73, 19.8, "Valdrakken"},
    {1427.42, -4525.20, 20.3, "Dornogal"}, {1464.12, -4479.89, 20.0, "Silvermoon City"},
}
-- Stormwind Mage Quarter portal room
local SW_PORTALS = {
    {-9095.99, 896.71, 68.7, "Oribos"}, {-9077.98, 873.45, 68.3, "Valdrakken"},
    {-9070.82, 1014.08, 73.6, "Boralus"}, {-9023.58, 952.49, 68.3, "Dalaran"},
    {-9006.19, 965.37, 68.2, "the Exodar"}, {-8989.06, 942.90, 68.7, "Shattrath"},
}

local activeOrg, activeSW = {}, {}
local directorOn = false

local function Alive(c)
    local ok, r = pcall(function() return c:IsAlive() end)
    return ok and r
end

local function SafeCast(c, spell)
    pcall(function() c:CastSpell(c, spell, true) end)
end

local wpIdCounter = 0
local function GoTo(c, x, y, z)
    wpIdCounter = wpIdCounter + 1
    if wpIdCounter > 4000000000 then wpIdCounter = 1 end
    local id = wpIdCounter
    -- genPath=false: straight line, no navmesh needed
    local ok, err = pcall(function() c:MoveTo(id, x, y, z, false) end)
    print("[adv] moveto entry=" .. tostring(c:GetEntry()) .. " ok=" .. tostring(ok) .. " err=" .. tostring(err))
end

local function prune(list)
    local alive = {}
    for _, c in ipairs(list) do
        if Alive(c) then alive[#alive + 1] = c end
    end
    return alive
end

local function DoLeave(c, list, destName)
    print("[adv] leaving for " .. destName)
    c:SendUnitSay("Off to " .. destName .. "!", 0)
    SafeCast(c, PORTAL_SPELL)
    for i, o in ipairs(list) do
        if Alive(o) and o == c then table.remove(list, i) break end
    end
    local gone = c
    gone:RegisterEvent(function()
        pcall(function() gone:DespawnOrUnsummon() end)
    end, 2000, 1)
end

local function scheduleWalk(c, tx, ty, tz, list, destName)
    c:RegisterEvent(function()
        if not Alive(c) then return end
        local ok, x, y, z = pcall(function() return c:GetLocation() end)
        -- never die on a failed read: re-arm and try again
        if not ok or not x then
            scheduleWalk(c, tx, ty, tz, list, destName)
            return
        end
        local dx, dy = x - tx, y - ty
        local dz = (z and tz) and (z - tz) or 0
        local born = c:Data():Get("adv_born") or 0
        if type(born) ~= "number" then born = 0 end
        local age = os.time() - born
        -- 3D distance: XY close but other floor (Z far) is NOT arrived
        local dist2 = dx * dx + dy * dy + dz * dz
        -- arrived at portal: leave immediately, no waiting
        if dist2 < 100 then
            DoLeave(c, list, destName)
            return
        end
        -- failsafe: stuck too long -> leave from where it stands, free the slot
        if age > 120 then
            print("[adv] failsafe leave age=" .. age .. " dist=" .. string.format("%.1f", math.sqrt(dist2)))
            DoLeave(c, list, destName)
            return
        end
        -- still far: keep moving (re-issue MoveTo = unstick) and check again soon
        if tz then
            GoTo(c, tx, ty, tz)
        end
        scheduleWalk(c, tx, ty, tz, list, destName)
    end, 3000, 1)
end

local ARRIVE_LINES = {
    "Another adventure begins!",
    "New city, new bounties.",
    "Smells like... home. Sort of.",
}

-- Fixed story routes: [entry] = {spawn={x,y,z}, legs={{x,y,z}...}, portal={x,y,z,"Name"}}
-- Legs are walked in order (user-walked paths, wall-safe).
local ROUTES = {
    [225509] = {
        spawn = {1429.14, -4408.83, 25.45},
        legs = {
            {1436.84, -4424.61, 25.45}, {1437.98, -4433.28, 25.66},
            {1438.34, -4441.29, 23.91}, {1439.62, -4452.01, 20.28},
            {1440.70, -4459.89, 20.28}, {1441.90, -4469.80, 20.28},
            {1443.02, -4479.66, 20.28}, {1444.07, -4488.95, 20.03},
            {1445.14, -4498.47, 18.44}, {1451.92, -4505.00, 18.44},
            {1459.62, -4512.79, 18.55}, {1466.10, -4518.59, 20.33},
        },
        portal = {1427.42, -4525.20, 20.34, "Dornogal"},
    },
    [149290] = {
        spawn = {1435.93, -4420.63, 25.45},
        legs = {
            {1436.97, -4436.22, 25.66}, {1437.83, -4442.58, 23.40},
            {1439.10, -4452.08, 20.28}, {1440.19, -4460.19, 20.28},
            {1441.61, -4470.72, 20.28}, {1442.65, -4478.49, 20.28},
            {1443.77, -4486.83, 20.20}, {1444.14, -4496.86, 18.44},
            {1443.79, -4506.04, 18.44}, {1444.82, -4512.50, 18.63},
            {1445.84, -4518.96, 18.67}, {1447.26, -4524.15, 18.57},
            {1448.26, -4529.07, 19.09},
        },
        portal = {1448.57, -4532.04, 19.11, "Razorwind Shores"},
    },
    [149409] = {
      {
        spawn = {1440.53, -4412.49, 25.45},
        legs = {
            {1439.92, -4419.12, 25.45}, {1439.14, -4426.08, 25.45},
            {1438.75, -4429.56, 25.45}, {1438.75, -4438.40, 25.12},
            {1439.57, -4445.83, 21.98}, {1440.33, -4452.78, 20.28},
            {1440.72, -4456.26, 20.28}, {1441.48, -4463.22, 20.28},
            {1442.25, -4470.18, 20.28}, {1443.02, -4477.14, 20.28},
            {1443.78, -4484.09, 20.28}, {1444.17, -4487.57, 20.15},
            {1444.08, -4494.56, 18.65}, {1441.71, -4499.27, 18.44},
            {1437.39, -4497.57, 18.61}, {1433.83, -4494.35, 18.81},
            {1431.24, -4492.00, 18.71}, {1427.17, -4488.30, 19.80},
        },
        portal = {1424.48, -4485.86, 20.29, "Silvermoon (Old Portal)"},
      },
      {
        spawn = {1434.66, -4405.06, 25.45},
        legs = {
            {1435.51, -4412.72, 25.45}, {1436.08, -4419.70, 25.45},
            {1436.66, -4426.68, 25.45}, {1437.83, -4437.86, 25.37},
            {1438.37, -4441.32, 23.90}, {1438.91, -4444.77, 22.43},
            {1440.00, -4451.69, 20.28}, {1441.08, -4458.60, 20.28},
            {1442.71, -4468.98, 20.28}, {1443.79, -4475.89, 20.28},
            {1443.37, -4483.56, 20.28}, {1443.76, -4487.04, 20.19},
            {1444.29, -4491.80, 18.85}, {1444.68, -4495.28, 18.52},
            {1448.37, -4499.34, 18.44}, {1451.86, -4495.98, 18.65},
            {1454.03, -4493.24, 18.46}, {1457.23, -4489.21, 18.70},
            {1459.68, -4485.20, 19.37}, {1461.72, -4482.63, 20.00},
        },
        portal = {1463.39, -4480.53, 20.00, "Silvermoon City (Midnight)"},
      },
    },
}

local function walkLegs(c, legs, idx, portal, list, destName)
    if not Alive(c) then return end
    local function gotoPortal()
        local tx, ty = portal[1], portal[2]
        GoTo(c, tx, ty, portal[3])
        scheduleWalk(c, tx, ty, portal[3], list, destName)
    end
    if idx > #legs then gotoPortal() return end
    -- smooth waypoint following: steer to next leg when close in 3D
    -- (6 yd lookahead chains MoveTo before full stop; Z-check keeps
    --  upper ramp from skipping the whole lower floor through walls).
    local ok, x, y, z = pcall(function() return c:GetLocation() end)
    while ok and x and idx <= #legs do
        local dx, dy = x - legs[idx][1], y - legs[idx][2]
        local dz = (z and legs[idx][3]) and (z - legs[idx][3]) or 0
        if dx * dx + dy * dy + dz * dz > 36 then break end
        idx = idx + 1
    end
    if idx > #legs then gotoPortal() return end
    local leg = legs[idx]
    -- issue MoveTo only when the target leg changed: no stutter
    local lastIssued = c:Data():Get("adv_leg") or 0
    if type(lastIssued) ~= "number" then lastIssued = 0 end
    if lastIssued ~= idx then
        GoTo(c, leg[1], leg[2], leg[3])
        c:Data():Set("adv_leg", idx)
    end
    c:RegisterEvent(function()
        walkLegs(c, legs, idx, portal, list, destName)
    end, 1000, 1)
end

local function SpawnAdventurer(spawns, portals, active, mapId)    local entry = ADVENTURERS[math.random(#ADVENTURERS)]
    -- fixed story route wins over random pick (single table or list)
-- Shared player-walked tracks: entries WITHOUT their own route walk these.
local SHARED_ROUTES = {
    {
        spawn = {1435.55, -4417.02, 25.45},
        legs = {
            {1436.41, -4423.97, 25.45}, {1437.26, -4430.92, 25.66},
            {1438.12, -4437.87, 25.35}, {1439.40, -4448.29, 20.95},
            {1440.25, -4455.23, 20.28}, {1444.29, -4459.67, 20.61},
            {1450.79, -4458.86, 18.77}, {1454.73, -4458.36, 18.78},
            {1461.56, -4457.51, 13.60}, {1465.03, -4457.07, 11.01},
            {1471.98, -4456.20, 5.86}, {1475.59, -4455.75, 5.83},
            {1477.28, -4459.65, 5.84}, {1477.73, -4464.54, 3.29},
            {1478.22, -4469.76, -0.60}, {1478.64, -4474.32, -2.95},
            {1479.00, -4478.29, -2.95}, {1475.10, -4480.00, -2.60},
            {1471.68, -4480.70, -2.82}, {1465.49, -4482.00, -2.82},
            {1460.20, -4482.66, -2.84}, {1456.48, -4483.08, -3.00},
            {1453.11, -4483.45, -4.26}, {1448.92, -4483.92, -4.74},
            {1444.09, -4485.05, -4.78}, {1440.62, -4485.53, -4.78},
            {1433.08, -4486.57, -4.50}, {1428.03, -4486.68, -4.80},
            {1423.84, -4486.50, -4.68}, {1420.60, -4486.95, -4.30},
            {1417.02, -4487.44, -3.19},
        },
        portal = {1415.05, -4487.71, -2.69, "Caverns of Time"},
    },
    {
        spawn = {1437.99, -4396.39, 25.45},
        legs = {
            {1437.79, -4399.88, 25.45}, {1437.38, -4406.87, 25.45},
            {1436.98, -4413.86, 25.45}, {1436.77, -4417.35, 25.45},
            {1436.37, -4424.34, 25.45}, {1436.60, -4430.54, 25.45},
            {1437.15, -4434.00, 25.66}, {1437.92, -4438.85, 24.95},
            {1438.48, -4442.43, 23.43}, {1439.08, -4446.24, 21.81},
            {1439.76, -4450.52, 20.28}, {1440.38, -4454.44, 20.28},
            {1440.98, -4458.25, 20.28}, {1441.56, -4461.95, 20.28},
            {1442.11, -4465.40, 20.28}, {1443.31, -4488.10, 20.23},
            {1443.39, -4491.25, 19.08}, {1442.48, -4496.17, 18.55},
            {1438.95, -4500.32, 18.52}, {1433.91, -4502.76, 18.36},
            {1429.90, -4504.00, 18.67}, {1426.66, -4505.00, 18.54},
            {1424.17, -4505.07, 18.99}, {1421.16, -4505.47, 20.12},
        },
        portal = {1416.71, -4505.75, 19.84, "Jade Forest"},
    },
    {
        spawn = {1442.47, -4474.27, 20.41},
        legs = {
            {1442.92, -4477.74, 20.41}, {1443.78, -4484.48, 20.38},
            {1444.25, -4488.07, 20.22}, {1444.74, -4491.89, 18.82},
            {1446.53, -4496.63, 18.44}, {1450.49, -4500.05, 18.44},
            {1454.82, -4499.94, 18.72}, {1459.02, -4499.84, 18.35},
            {1462.65, -4499.75, 18.55}, {1465.81, -4499.67, 18.54},
            {1468.72, -4499.59, 19.79},
        },
        portal = {1473.25, -4499.73, 19.82, "Valdrakken"},
    },
    {
        spawn = {1476.52, -4460.52, 5.81},
        legs = {
            {1477.60, -4466.85, 1.59}, {1478.44, -4471.81, -2.12},
            {1479.16, -4476.08, -2.95}, {1476.33, -4479.29, -2.95},
            {1470.32, -4481.26, -2.82}, {1463.59, -4481.76, -2.82},
            {1457.62, -4482.90, -3.03}, {1453.26, -4483.73, -4.22},
            {1446.49, -4485.02, -4.78}, {1436.81, -4490.19, -4.69},
            {1433.73, -4494.01, -4.87}, {1430.95, -4497.47, -4.68},
            {1428.97, -4499.93, -4.69}, {1426.78, -4502.66, -3.10},
            {1423.99, -4506.13, -3.07},
        },
        portal = {1424.01, -4506.62, -3.09, "Shattrath"},
    },
    {
        spawn = {1431.50, -4414.24, 25.45},
        legs = {
            {1432.22, -4417.67, 25.45}, {1435.61, -4429.92, 25.45},
            {1437.63, -4436.48, 25.66}, {1438.20, -4439.93, 24.49},
            {1439.32, -4446.84, 21.56}, {1440.45, -4453.75, 20.28},
            {1441.26, -4459.70, 20.28}, {1446.56, -4458.93, 19.88},
            {1450.52, -4458.63, 18.77}, {1457.04, -4458.13, 16.97},
            {1460.53, -4457.87, 14.38}, {1467.51, -4457.34, 9.20},
            {1474.49, -4456.80, 5.83}, {1475.22, -4456.75, 5.83},
            {1476.88, -4459.98, 5.84}, {1476.97, -4463.47, 4.13},
            {1477.17, -4471.06, -1.47}, {1477.35, -4477.85, -2.95},
            {1475.17, -4479.90, -2.60}, {1471.77, -4480.71, -2.82},
            {1464.96, -4482.33, -2.82}, {1459.17, -4482.84, -2.92},
            {1454.61, -4482.69, -3.64}, {1451.11, -4482.58, -4.57},
            {1444.11, -4482.35, -4.78}, {1438.56, -4480.39, -4.78},
            {1434.96, -4478.20, -4.55}, {1431.67, -4476.19, -4.88},
            {1428.48, -4474.24, -4.68}, {1426.00, -4472.11, -4.69},
            {1423.70, -4470.13, -3.56},
        },
        portal = {1419.26, -4465.98, -2.98, "Warspear"},
    },
    {
        spawn = {1434.62, -4412.59, 25.45},
        legs = {
            {1434.99, -4415.96, 25.45}, {1435.74, -4418.71, 25.45},
            {1436.48, -4425.67, 25.45}, {1437.22, -4432.63, 25.66},
            {1437.92, -4439.18, 24.81}, {1438.29, -4442.66, 23.34},
            {1439.04, -4449.62, 20.40}, {1439.78, -4456.58, 20.28},
            {1443.04, -4459.37, 20.66}, {1447.67, -4459.47, 19.29},
            {1452.64, -4459.30, 18.98}, {1457.60, -4458.52, 16.59},
            {1464.28, -4457.04, 11.56}, {1468.93, -4456.53, 8.09},
            {1473.58, -4456.03, 5.83}, {1476.22, -4459.21, 5.84},
            {1477.32, -4464.35, 3.45}, {1478.44, -4471.58, -1.95},
            {1478.87, -4479.53, -2.95}, {1470.04, -4480.95, -2.82},
            {1463.97, -4481.52, -2.82}, {1458.51, -4482.03, -2.96},
            {1453.27, -4482.52, -4.17}, {1448.46, -4483.98, -4.77},
            {1444.38, -4490.06, -4.78}, {1444.22, -4495.91, -4.86},
            {1444.59, -4500.63, -4.55}, {1444.49, -4504.48, -4.69},
            {1444.40, -4508.10, -3.10},
        },
        portal = {1445.05, -4513.05, -3.03, "Zuldazar"},
    },
    {
        spawn = {1470.51, -4414.75, 25.45},
        legs = {
            {1463.88, -4417.02, 25.45}, {1457.26, -4419.29, 25.45},
            {1450.64, -4421.55, 25.45}, {1444.01, -4423.82, 25.45},
            {1440.70, -4424.95, 25.45}, {1437.30, -4435.03, 25.66},
            {1437.81, -4438.97, 24.91}, {1438.25, -4442.44, 23.44},
            {1439.58, -4452.86, 20.28}, {1440.02, -4456.33, 20.28},
            {1443.85, -4459.16, 20.64}, {1449.66, -4458.65, 18.77},
            {1453.74, -4458.29, 18.91}, {1460.14, -4457.73, 14.66},
            {1465.95, -4457.23, 10.34}, {1470.72, -4456.81, 6.79},
            {1476.20, -4456.33, 5.83}, {1476.80, -4460.48, 5.83},
            {1477.26, -4466.30, 2.02}, {1477.66, -4471.55, -1.87},
            {1478.05, -4476.57, -2.95}, {1478.32, -4479.95, -2.95},
            {1472.29, -4480.76, -2.82}, {1467.19, -4481.38, -2.82},
            {1462.54, -4481.95, -2.82}, {1458.02, -4482.50, -3.00},
            {1453.84, -4483.01, -4.02}, {1449.08, -4483.59, -4.72},
            {1446.73, -4479.85, -4.76}, {1444.09, -4474.78, -4.64},
            {1441.65, -4470.12, -4.65}, {1439.76, -4466.49, -4.68},
            {1439.27, -4463.38, -4.42}, {1439.03, -4460.59, -3.10},
            {1438.76, -4457.39, -2.89},
        },
        portal = {1438.87, -4455.36, -2.85, "Silvermoon (Burning Crusade)"},
    },
    {
        spawn = {1436.72, -4391.50, 25.45},
        legs = {
            {1436.45, -4400.36, 25.45}, {1436.33, -4403.86, 25.45},
            {1436.08, -4410.85, 25.45}, {1436.27, -4421.71, 25.45},
            {1437.16, -4428.65, 25.45}, {1438.05, -4435.59, 25.66},
            {1438.94, -4442.46, 23.40}, {1439.38, -4445.93, 21.94},
            {1440.27, -4452.88, 20.28}, {1441.09, -4459.26, 20.28},
            {1445.26, -4459.73, 20.51}, {1450.12, -4459.09, 18.77},
            {1457.08, -4458.17, 16.95}, {1462.29, -4457.49, 13.06},
            {1467.27, -4456.83, 9.34}, {1471.44, -4456.29, 6.24},
            {1475.28, -4455.78, 5.83}, {1476.94, -4458.88, 5.84},
            {1477.39, -4462.47, 4.84}, {1478.09, -4468.02, 0.69},
            {1478.65, -4472.44, -2.61}, {1479.44, -4478.71, -2.95},
            {1474.82, -4480.86, -2.82}, {1468.48, -4481.91, -2.82},
            {1463.62, -4482.71, -2.82}, {1459.12, -4483.45, -2.92},
            {1455.44, -4484.06, -3.30}, {1448.87, -4485.14, -4.72},
            {1447.98, -4490.00, -4.63}, {1452.97, -4494.19, -4.43},
            {1455.30, -4495.74, -4.52}, {1458.61, -4497.93, -4.25},
            {1462.23, -4500.69, -3.02},
        },
        portal = {1463.78, -4501.95, -2.91, "Azsuna"},
    },
    {
        spawn = {1430.04, -4410.98, 25.45},
        legs = {
            {1431.05, -4414.33, 25.45}, {1433.07, -4421.03, 25.45},
            {1435.09, -4427.74, 25.45}, {1436.86, -4433.58, 25.66},
            {1438.31, -4438.39, 25.12}, {1439.22, -4445.10, 22.29},
            {1439.56, -4448.58, 20.82}, {1440.25, -4455.55, 20.28},
            {1440.94, -4462.51, 20.28}, {1441.63, -4469.48, 20.28},
            {1442.32, -4476.45, 20.28}, {1443.03, -4483.59, 20.28},
            {1443.61, -4489.51, 19.80}, {1444.20, -4495.45, 18.52},
            {1444.56, -4499.05, 18.44}, {1449.13, -4503.23, 18.44},
            {1454.65, -4508.27, 18.48}, {1459.31, -4512.52, 18.56},
            {1463.27, -4516.14, 19.29}, {1465.86, -4518.50, 20.31},
        },
        portal = {1468.30, -4521.12, 20.26, "Oribos"},
    },
    {
        spawn = {1429.15, -4399.99, 25.45},
        legs = {
            {1432.08, -4408.86, 25.45}, {1436.15, -4423.73, 25.45},
            {1437.73, -4434.00, 25.66}, {1438.35, -4440.40, 24.28},
            {1438.86, -4445.63, 22.08}, {1439.51, -4452.26, 20.28},
            {1440.19, -4459.23, 20.28}, {1440.88, -4466.20, 20.28},
            {1441.56, -4473.16, 20.28}, {1442.24, -4480.13, 20.28},
            {1442.91, -4487.03, 20.20}, {1443.59, -4494.00, 18.73},
            {1443.22, -4500.17, 18.44}, {1438.72, -4498.70, 18.62},
            {1435.98, -4496.52, 18.46}, {1431.87, -4493.23, 18.70},
            {1426.87, -4488.60, 19.83}, {1425.21, -4486.32, 20.30},
        },
        portal = {1422.59, -4484.15, 20.21, "Dalaran"},
    },
}


    local rl = ROUTES[entry]
    local route = nil
    if rl then
        if rl.spawn and rl.portal then
            route = rl
        elseif #rl > 0 then
            local pick = rl[math.random(#rl)]
            if pick and pick.spawn and pick.portal then route = pick end
        end
    end
    local s, t, destName
    if not route and #SHARED_ROUTES > 0 then
        route = SHARED_ROUTES[math.random(#SHARED_ROUTES)]
    end
    if route and mapId == 1 then
        s = route.spawn
        t = route.portal
        destName = t[4] or "far lands"
    else
        s = spawns[math.random(#spawns)]
        t = portals[math.random(#portals)]
        destName = t[4] or "far lands"
    end
    local ok, c = pcall(PerformIngameSpawn, 1, entry, mapId, 0,
        s[1] + math.random(-200, 200) / 100,
        s[2] + math.random(-200, 200) / 100,
        s[3], math.random() * 6.28, false, 900000)
    if not ok or not c then return end
    SafeCast(c, PORTAL_SPELL)
    c:Data():Set("adv_born", os.time())
    print("[adv] spawned entry=" .. tostring(entry))
    pcall(function() c:SetWalk(false) end)
    active[#active + 1] = c
    -- look around briefly, then RUN (not walk) to the portal
    c:RegisterEvent(function()
        if not Alive(c) then return end
        c:SendUnitSay(ARRIVE_LINES[math.random(#ARRIVE_LINES)], 0)
        if route and route.legs then
            walkLegs(c, route.legs, 1, t, active, destName)
        else
            GoTo(c, t[1], t[2], t[3])
            scheduleWalk(c, t[1], t[2], t[3], active, destName)
        end
    end, math.random(1500, 2500), 1)
end

local function runDirector(anchor)
    if anchor and not Alive(anchor) then return end
    activeOrg = prune(activeOrg)
    activeSW = prune(activeSW)
    if #activeOrg < MAX_ACTIVE and math.random() < 0.85 then
        SpawnAdventurer(ORG_SPAWNS, ORG_PORTALS, activeOrg, 1)
    end
    -- Stormwind later: focus Orgrimmar first
    -- if #activeSW < MAX_ACTIVE and math.random() < 0.7 then
    --     SpawnAdventurer(SW_SPAWNS, SW_PORTALS, activeSW, 0)
    -- end
    if anchor and Alive(anchor) then
        anchor:RegisterEvent(function() runDirector(anchor) end,
            math.random(8000, 15000), 1)
    end
end

-- the director starts from a grunt spawn (map state; login is the world state)
-- fallback: also kick from grunt spawns (e.g. after .respawn)
RegisterCreatureEvent(3296, 5, function(_, creature)
    if not directorOn then
        directorOn = true
        creature:RegisterEvent(function() runDirector(creature) end, 15000, 1)
    end
end)

local lastNudgeRun = 0
function AdvDirectorNudge()
    local now = os.time()
    if now - lastNudgeRun < 60 then return end
    lastNudgeRun = now
    runDirector(nil)
end

-- Static DB adventurers standing around Orgrimmar also join the flow:
-- after a while they walk to a random portal, teleport out and despawn
-- (their DB respawn brings fresh ones later).
local STATIC_ADV = {149290, 149296, 149297, 149371, 149404, 149408,
                     149409, 198070, 225509, 150968, 255062}


-- find a shared track ending at the given portal coords (within 5 yd)
local function FindSharedTrack(tx, ty)
    for _, r in ipairs(SHARED_ROUTES) do
        local dx, dy = r.portal[1] - tx, r.portal[2] - ty
        if dx * dx + dy * dy < 25 and r.spawn and r.legs then
            return r
        end
    end
    return nil
end

for _, entry in ipairs(STATIC_ADV) do
    RegisterCreatureEvent(entry, 5, function(_, creature)
        creature:RegisterEvent(function()
            if not Alive(creature) then return end
            local t = ORG_PORTALS[math.random(#ORG_PORTALS)]
            creature:SendUnitSay(ARRIVE_LINES[math.random(#ARRIVE_LINES)], 0)
            pcall(function() creature:SetWalk(false) end)
            local tr = FindSharedTrack(t[1], t[2])
            if tr then
                -- start from the leg nearest to us, not from leg 1
                local startIdx = 1
                local ok0, cx, cy = pcall(function() return creature:GetLocation() end)
                if ok0 and cx then
                    local best, bi = nil, 1
                    for i, leg in ipairs(tr.legs) do
                        local dx, dy = cx - leg[1], cy - leg[2]
                        local d2 = dx * dx + dy * dy
                        if not best or d2 < best then best, bi = d2, i end
                    end
                    startIdx = bi
                end
                walkLegs(creature, tr.legs, startIdx, t, {}, t[4] or "far lands")
            else
                GoTo(creature, t[1], t[2], t[3])
                scheduleWalk(creature, t[1], t[2], t[3], {}, t[4] or "far lands")
            end
        end, math.random(60000, 180000), 1)
    end)
end

print("[Adventurers] loaded")
