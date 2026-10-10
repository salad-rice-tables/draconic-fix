-- =====================================================================
-- Quest 86734 Diplomacy (Lor'themar Theron, Silvermoon): retail flow.
--   1. Accept the quest -> the quest list window closes.
--   2. Talk to Lor'themar again -> a window with ONLY the Diplomacy text and two buttons
--      (menu 38452: 0 = Listen to the discussion, 1 = Skip conversation). Retail does this with a second,
--      phased Lor'themar; here the quest state (incomplete) selects the window.
--   3. Listen -> 8 lines, each said by its NPC with the retail voice (BroadcastText 285180-285189, SoundKit
--      299863-299870 = the numbers on Wowhead /sound=), kill credit 235787 after Umbric has finished and dissolved (49.5 s).
--      Skip -> credit at once.
-- Speakers: 235787 Lor'themar, 251587 Halduron, 239944 Umbric, 236583 Rommath, 236778 Turalyon (all at the court).
-- Umbric: his own phase (sql/20261011_diplo_umbric_phase.sql) exists only while the quest is incomplete; the credit at 49.5 s (after he has finished his last line and dissolved) ends it for that player only.
-- Cooldown 60 s per player so scenes do not overlap.
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}
local COOLDOWN = 60

local function OnCooldown(player, key)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < COOLDOWN then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text, voFile)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then pcall(function() PrintInfo("[diplo] say MISSED (player gone) entry=" .. entry) end) return end
        local kit = voFile   -- retail SoundKit ids of the BroadcastTexts 285180-285189 (299863-299870): the same voice lines Blizzard plays
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then pcall(function() PrintInfo("[diplo] say MISSED (no range list) entry=" .. entry) end) return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                local okS, err = pcall(function() c:SendUnitSay(text, 0) end)
                if kit then pcall(function() c:PlayDistanceSound(kit, p) end) end
                pcall(function() PrintInfo("[diplo] say " .. (okS and "SENT" or "FAILED:" .. tostring(err)) .. " entry=" .. entry) end)
                return
            end
        end
        pcall(function() PrintInfo("[diplo] say MISSED (entry not in range) entry=" .. entry) end)
    end, delayMs, 1)
end


-- Umbric dissolves with the cosmetic Arcane Dissolve Out (1244360) right after his last line; the credit then ends his phase for this player.
local function UmbricDissolve(player, delayMs)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(60) end)
        if not ok or not list then return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == 239944 then pcall(function() c:CastSpell(c, 1244360, true) end) return end
        end
    end, delayMs, 1)
end

RegisterCreatureGossipEvent(235787, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[diplo] player=%s menu=%s intid=%s q86734=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86734)))) end)
    if sender ~= 38452 then return end
    pcall(function() player:GossipComplete() end)
    if intid ~= 0 then pcall(function() player:KilledMonsterCredit(235787) end) return end   -- Skip conversation: credit at once
    if OnCooldown(player, "diplo-scene") then pcall(function() player:KilledMonsterCredit(235787) end) return end
    player:RegisterEvent(function(_, _, _, p) if p and p:IsInWorld() then pcall(function() p:KilledMonsterCredit(235787) end) end end, 49500, 1)   -- Listen: credit after Umbric has finished his last line and dissolved: the quest state flips, his phase (9600002) ends for this player and he is gone (he leaves, retail)
    SayAt(player, 235787, 60, 1000, "The Sunwell holds the Voidstorm at bay for now. But its current state cannot be sustained forever.", 299863)
    SayAt(player, 251587, 60, 9000, "And there's no telling how it could be affecting the rest of Eversong, especially the Lightbloom. We need an alternative course of action.", 299864)
    SayAt(player, 239944, 60, 21000, "We ren'dorei can aid you in finding one. Grant us entry into Silvermoon--", 299865)
    SayAt(player, 236583, 60, 28000, "Absolutely not! Your mere presence would risk defiling the Sunwell with Void magic.", 299866)
    SayAt(player, 239944, 60, 37000, "Then it seems we have nothing more to discuss. I'll continue my research in Tranquillien, should you choose to see reason.", 299867)
    SayAt(player, 236778, 60, 48000, "The Grand Magister is right about one thing--protecting the Sunwell is our top priority. The Vanguard of the Light will see to its defense.", 299868)
    SayAt(player, 235787, 60, 60000, "Your aid was timely and welcome, Turalyon. But remember that Silvermoon and the Sunwell belong to the sin'dorei. You are guests in our fair city.", 299869)
    UmbricDissolve(player, 47000)
    SayAt(player, 236778, 60, 73000, "Guests, allies, and saviors, Lor'themar. Rest assured that we will guard your city and your people with the full strength of the Light.", 299870)
end)


-- Retail: while Diplomacy is active, Lor'themar shows ONLY the Diplomacy window (text + Listen / Skip); his normal window with the quest list is shown otherwise.
-- (Retail does it with a second, phased Lor'themar; the quest-state check gives the same result without a phase.)
RegisterCreatureGossipEvent(235787, 1, function(_, player, creature)
    if player:GetQuestStatus(86734) ~= 3 then return false end   -- false = the core opens his normal window (quest list)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "<Listen to the discussion.>", 38452, 0)
    player:GossipMenuAddItem(0, "<Skip conversation> I expect you'll sort things out.", 38452, 1)
    player:GossipSendMenu(9500132, creature)
    return true   -- we sent our own window
end)

print("[diplomacy86734] loaded")

-- Retail: accepting the quest closes the gossip window (only 86734, other quests unchanged).
RegisterCreatureEvent(235787, 31, function(_, player, _, quest)
    local ok, qid = pcall(function() return quest:GetId() end)
    if ok and qid == 86734 then
        pcall(function() player:GossipComplete() end)
    end
end)
