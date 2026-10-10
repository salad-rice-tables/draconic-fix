-- =====================================================================
-- Quest 86734 Diplomacy: listen/skip kredity + diskusna scena (Wiki Notes).
-- Menu 38452: opt0 Listen -> scena (8 replik) + kredit; opt1 Skip -> len kredit.
-- Scena: Lorthemar -> Halduron -> Umbric -> Rommath -> Umbric -> Turalyon -> Lorthemar -> Turalyon.
-- Ucastnici: 235787, 251587, 239944, 236583, 236778 (vsetci pri dvore). Cooldown 300 s.
-- =====================================================================
if IS_WORLD_STATE then return end

local SaidAt = {}
local COOLDOWN = 300

local function OnCooldown(player, key)
    local stamp = os.time()
    local prev = SaidAt[player:GetName() .. ":" .. key] or 0
    if stamp - prev < COOLDOWN then return true end
    SaidAt[player:GetName() .. ":" .. key] = stamp
    return false
end

local function SayAt(player, entry, range, delayMs, text)
    player:RegisterEvent(function(_, _, _, p)
        if not p or not p:IsInWorld() then return end
        local ok, list = pcall(function() return p:GetCreaturesInRange(range) end)
        if not ok or not list then return end
        for _, c in ipairs(list) do
            local okE, e = pcall(function() return c:GetEntry() end)
            if okE and e == entry then
                pcall(function() c:SendUnitSay(text, 0) end)
                return
            end
        end
    end, delayMs, 1)
end

RegisterCreatureGossipEvent(235787, 2, function(_, player, _, sender, intid)
    pcall(function() PrintInfo(string.format("[diplo] player=%s menu=%s intid=%s q86734=%s", player:GetName(), tostring(sender), tostring(intid), tostring(player:GetQuestStatus(86734)))) end)
    if sender ~= 38452 then return end
    pcall(function() player:KilledMonsterCredit(235787) end)
    if intid ~= 0 then return end
    if OnCooldown(player, "diplo-scene") then return end
    SayAt(player, 235787, 60, 0, "The Sunwell holds the Voidstorm at bay for now. But its current state cannot be sustained forever.")
    SayAt(player, 251587, 60, 4000, "And there's no telling how it could be affecting the rest of Eversong, especially the Lightbloom. We need an alternative course of action.")
    SayAt(player, 239944, 60, 8000, "We ren'dorei can aid you in finding one. Grant us entry into Silvermoon--")
    SayAt(player, 236583, 60, 12000, "Absolutely not! Your mere presence would risk defiling the Sunwell with Void magic.")
    SayAt(player, 239944, 60, 16000, "Then it seems we have nothing more to discuss. I'll continue my research in Tranquillien, should you choose to see reason.")
    SayAt(player, 236778, 60, 20000, "The Grand Magister is right about one thing--protecting the Sunwell is our top priority. The Vanguard of the Light will see to its defense.")
    SayAt(player, 235787, 60, 24000, "Your aid was timely and welcome, Turalyon. But remember that Silvermoon and the Sunwell belong to the sin'dorei. You are guests in our fair city.")
    SayAt(player, 236778, 60, 28000, "Guests, allies, and saviors, Lor'themar. Rest assured that we will guard your city and your people with the full strength of the Light.")
end)

print("[diplomacy86734] loaded")
