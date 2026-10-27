-- Loss Reduction (Durotar, map 1, quest 25179) — retail flow in Lua.
-- Retail: the Injured Razor Hill Grunt (39270) is rescued by talking to him. The rescue gives the quest
-- objective credit (objective 256780 = kill credit 39270 x4), the grunt gets up, says an encouraging line,
-- follows the player for a while and then runs off (despawns). Gar'Thok (3139) takes the finished quest.
-- Why Lua: every creature on this realm runs Eluna's AI, so the SmartAI rows of 39270 never execute.
-- Texts: world.creature_text 39270 group 0 (id 4, bcast 39302) and group 2 ("returning / leaving" lines).
if IS_WORLD_STATE then return end

local GRUNT        = 39270
local QUEST        = 25179
local AURA_DROWNED = 75511  -- "Permanent Feign Death (Drowned State)" — carried until rescued; reapplied on respawn (addon auras)
local SAY_RESCUE   = "For the Warchief!  You lead, I will follow."           -- creature_text 0/4
local SAY_LEAVE    = {
    "Thank you again. I will return to Razor Hill now.",                     -- creature_text 2/0
    "I feel much better now.  For the Horde!",                               -- creature_text 2/1
    "You fight well.  I will leave you now.  Lok'tar ogar!",                 -- creature_text 2/3
}

local lastRescue = {}  -- guidLow -> time of the rescue (blocks a double credit from one spawn instance)

local function OnHello(event, player, creature)
    local ok, has = pcall(function() return player:HasQuest(QUEST) end)
    if not ok or not has then
        return false   -- no quest (or not taken yet): let the core do its default thing (quest offer / gossip)
    end

    local low = creature:GetGUIDLow()

    -- the same spawn must not give the credit twice: the rescue removes the feign death aura (only a respawn
    -- reapplies it) and we also remember the time, so a second click before the despawn does nothing
    local t = lastRescue[low]
    if t and os.time() - t < 150 then return true end
    local okAura, aura = pcall(function() return creature:HasAura(AURA_DROWNED) end)
    if okAura and not aura then return true end

    lastRescue[low] = os.time()

    -- credit only while the objective is still open (status 3 = incomplete)
    local okS, status = pcall(function() return player:GetQuestStatus(QUEST) end)
    if okS and status == 3 then pcall(function() player:KilledMonsterCredit(GRUNT) end) end
    pcall(PrintInfo, "[loss_reduction] " .. player:GetName() .. " rescued grunt " .. tostring(low) .. ", quest active: " .. tostring(okS and status == 3))

    -- the rescue itself: stand up, encouraging line, follow the player
    pcall(function() creature:Data():Set("lw_claim", "loss_grunt") end)   -- the scene belongs to the quest, not to living world routines
    pcall(function() creature:RemoveAura(AURA_DROWNED) end)
    pcall(function() creature:EmoteState(0) end)
    pcall(function() creature:SetStandState(0) end)
    pcall(function() creature:SendUnitSay(SAY_RESCUE, 0) end)
    pcall(function() creature:MoveFollow(player, 2.0, math.random() * 2 * math.pi) end)

    -- after a while: leaving line, run off and despawn (retail: "will then run off")
    creature:RegisterEvent(function(_, _, _, c)
        if not c then return end
        pcall(function() c:SendUnitSay(SAY_LEAVE[math.random(#SAY_LEAVE)], 1) end)
        local cx, cy, cz = c:GetLocation()
        local okP, px, py = pcall(function() local x, y = player:GetLocation(); return x, y end)
        if okP and px then
            local dx, dy = cx - px, cy - py
            local len = math.sqrt(dx * dx + dy * dy)
            if len > 0.5 then
                pcall(function() c:MoveClear() end)
                pcall(function() c:MoveTo(1, cx + dx / len * 15, cy + dy / len * 15, cz, true) end)
            end
        end
        pcall(function() c:DespawnOrUnsummon(3000) end)
    end, 8000, 1)

    pcall(function() player:GossipComplete() end)
    return true   -- handled here: no gossip window
end

RegisterCreatureGossipEvent(GRUNT, 1, OnHello)
print("[loss_reduction] loaded")
