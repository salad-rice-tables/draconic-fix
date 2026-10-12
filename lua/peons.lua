-- Lazy Peons (Valley of Trials, quest 37446 "Lazy Peons", item Foreman's Blackjack).
-- The core's npc_lazy_peon script never runs for these creatures, because the Lua creature overhaul gives every
-- creature Eluna's AI. So the quest is handled here: the peons sleep (aura 17743 + lying down), the blackjack's
-- Awaken Peon spell (19938) wakes one, gives the kill credit and sends it to work for a while.
if IS_WORLD_STATE then return end

local PEON, SLEEP_AURA, AWAKEN = 10556, 17743, 19938
local QUESTS = {37446, 25134, 5441}
local awake = {}   -- guid -> time it was woken

local function Sleep(peon)
    -- as TrinityCore's npc_lazy_peon: the peon carries the Sleeping aura (17743); Foreman's Blackjack (Awaken Peon, 19938) only works on a peon that has it
    pcall(function() peon:EmoteState(0) end)
    pcall(function() if not peon:HasAura(SLEEP_AURA) then peon:AddAura(SLEEP_AURA, peon) end end)
    pcall(function() peon:SetStandState(3) end)
    pcall(function() peon:Data():Set("lw_claim", "peon") end)   -- a sleeping peon belongs to the quest, not to work
end

-- the retail texts of creature 10556 (world.creature_text group 0): the wake-up lines and the muttering of a sleeping peon
local WORK_LINES = {"Ow!  OK, I'll get back to work, %s!", "OK boss, I get back to tree-hitting.", "Just was resting eyes!  Back to work now!"}
local SLEEP_LINES = {"Sleepy... so sleepy..."}
local CHOP = 234   -- EMOTE_STATE chopwood (ako retail praca s drevom)

local function Wake(peon, caster, via)
    if not peon or not caster or not caster.GetQuestStatus then return false end
    -- every version of the quest (current 37446, Cataclysm 25134, classic 5441) counts the same peon kill credit
    local active = false
    for _, q in ipairs(QUESTS) do
        local ok, status = pcall(function() return caster:GetQuestStatus(q) end)
        if ok and status == 3 then active = true end   -- QUEST_STATUS_INCOMPLETE
    end
    if active then pcall(function() caster:KilledMonsterCredit(PEON) end) end
    pcall(PrintInfo, "[peons] " .. caster:GetName() .. " woke peon " .. tostring(peon:GetGUIDLow()) .. " via " .. (via or "?") .. ", quest active: " .. tostring(active))
    awake[peon:GetGUIDLow()] = os.time()
    -- retail flow: dole aury, vstat, zanadavat, ist k lumberpile a rubat. Narok drzime (nie workday).
    pcall(function() peon:RemoveAura(SLEEP_AURA) end)       -- TrinityCore: me->RemoveAllAuras()
    pcall(function() peon:RemoveAura(18795) end)
    pcall(function() peon:EmoteState(0) end)
    pcall(function() peon:SetStandState(0) end)
    pcall(function() peon:Data():Set("lw_claim", "peon") end)
    pcall(function() peon:SendUnitSay((string.format(WORK_LINES[math.random(#WORK_LINES)], caster:GetName())), 0) end)
    pcall(function()
        local okG, pile = pcall(function() return peon:FindNearestGameObject(175784, 25) end)
        if okG and pile then
            local px, py, pz = pile:GetLocation()
            local px2, py2 = px - 1, py
            peon:MoveTo(1, px2, py2, pz, true)
            peon:RegisterEvent(function(_, _, _, c)
                if c and c:IsAlive() then
                    pcall(function() c:SetFacing(math.atan2(py - py2, px - px2)) end)
                    pcall(function() c:EmoteState(CHOP) end)
                end
            end, 6000, 1)
        else
            peon:RegisterEvent(function(_, _, _, c)
                if c and c:IsAlive() then pcall(function() c:EmoteState(CHOP) end) end
            end, 1500, 1)
        end
    end)
    return true
end

RegisterCreatureEvent(PEON, 14, function(_, peon, caster, spellId)   -- hit by a spell
    if spellId ~= AWAKEN then return end
    Wake(peon, caster, "spell")
    return false
end)

-- Foreman's Blackjack (16114) casts the real Awaken Peon (19938) at a sleeping peon; the hit is handled above (creature event 14).

-- keep the peons asleep around players (the aura runs out after a few minutes, a woken peon sleeps again after 2 min)
if MAP_Timer then
    MAP_Timer("peons.sleep", function()
        for _, p in ipairs(MAP_Players()) do
            local ok, list = pcall(function() return p:GetCreaturesInRange(80, PEON) end)
            if ok and list then
                for _, peon in ipairs(list) do
                    local t = awake[peon:GetGUIDLow()]
                    if not t or os.time() - t > 120 then
                        awake[peon:GetGUIDLow()] = nil
                        Sleep(peon)
                        if math.random(8) == 1 then pcall(function() peon:SendUnitSay(SLEEP_LINES[1], 0) end) end
                    end
                end
            end
        end
    end, 10000)
end
print("[peons] loaded")
