-- 86710 The Line Must be Drawn Here (retail flow from video klnWHyXZSOQ)
-- accept: Liadrin line; Zul'jan gossip '(Quest) Return to Zul'Aman.' -> Zul'jan/Liadrin lines -> Void Beast (credit 'Calm the situation' on spawn, 'Void Beast slain' on death)
local QUEST, LIADRIN, ZULJAN, BEAST, MORDUUN = 86710, 236436, 249211, 249083, 236094
local NPC_TEXT, OPTION = 9108830, "(Quest) Return to Zul'Aman."
local CREDIT_SPEAK, CREDIT_CALM = 249211, 249115
local state = {}

local function say(p, entry, text, sound, yell)
    local c = p:GetNearestCreature(100, entry)
    if not c then return end
    if yell then c:SendUnitYell(text, 0) else c:SendUnitSay(text, 0) end
    if sound then c:PlayDirectSound(sound, p) end
end
local function later(p, ms, fn) p:RegisterEvent(function(_, _, _, pl) if pl and pl:IsInWorld() and pl:HasQuest(QUEST) then fn(pl) end end, ms, 1) end

RegisterPlayerEvent(54, function(event, player, questId, status)
    if questId ~= QUEST then return end
    state[tostring(player:GetGUIDLow())] = nil
    if status == 3 then
        -- something clears Zul'jan's/Liadrin's npc flags at runtime; keep them clickable while the quest is active
        player:RegisterEvent(function(eid, d, c, p)
            if not p or not p:IsInWorld() or not p:HasQuest(QUEST) then p:RemoveEventById(eid) return end
            for _, e in ipairs({ZULJAN, LIADRIN}) do
                local n = p:GetNearestCreature(60, e)
                if n and n:GetNPCFlags() ~= 3 then n:SetNPCFlags(3) end
            end
        end, 1000, 0)
        later(player, 500, function(p) say(p, LIADRIN, "There is no need for further bloodshed. Cease your raids, surrender the lightwood, and return to your lands.", 307084) end)
    end
end)

RegisterCreatureGossipEvent(ZULJAN, 1, function(event, player, creature)
    if not player:HasQuest(QUEST) or state[tostring(player:GetGUIDLow())] then return false end
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, OPTION, 0, 1)
    player:GossipSendMenu(NPC_TEXT, creature)
    return true
end)

RegisterCreatureGossipEvent(ZULJAN, 2, function(event, player, creature, sender, intid)
    if intid ~= 1 or not player:HasQuest(QUEST) then return end
    local key = tostring(player:GetGUIDLow())
    if state[key] then return end
    state[key] = true
    player:GossipComplete()
    player:KilledMonsterCredit(CREDIT_SPEAK, 0)
    say(player, ZULJAN, "Our lands? This was all once \"our lands.\" And everything on it!", 307085)
    later(player, 4500,  function(p) say(p, ZULJAN, "You will take de lightwood over my grave, gokinye. Lightwood weapons are--", 307086) end)
    later(player, 9000,  function(p) say(p, LIADRIN, "A void beast! Look out!", 307087) end)
    later(player, 11500, function(p) say(p, ZULJAN, "Warriors, attack!", 307089) end)
    later(player, 12500, function(p)
        local z = p:GetNearestCreature(100, ZULJAN)
        local x, y, zz, o = p:GetX(), p:GetY(), p:GetZ(), p:GetO()
        if z then x, y, zz = z:GetX() + 4, z:GetY(), z:GetZ() end
        local b = p:SpawnCreature(BEAST, x, y, zz, o, 3, 300000)
        if b then
            b:SetFaction(14); b:SetReactState(1); b:AttackStart(p)
            p:KilledMonsterCredit(CREDIT_CALM, 0)
        end
        local m = p:SpawnCreature(MORDUUN, x + 2, y + 2, zz, o, 3, 6000)
        if m then
            m:SetReactState(0); m:SendUnitYell("Destroy the Amani! Break them! Sow chaos for the glory of Xal'atath!", 0); m:PlayDirectSound(307094, p)
        end
    end)
end)
