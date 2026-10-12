-- Where Mystic Runes and Mystic Enchants come from (besides rares, bounties, Manastorm and the other sources elsewhere):
--  * creatures killed by a Hero drop a Mystic Rune now and then (elites often, bosses always) and, rarely, an enchant,
--  * every completed quest pays Mystic Runes (more at higher levels) and has a small chance of an enchant.
-- A roll at the Mystic Altar costs 3 Runes, so roughly: 60 kills or 3 quests per roll.
local HERO_AURA = 1400010

local function Rune(player, n)
    if MYS_AddRunes then pcall(MYS_AddRunes, player, n) end
end
local function Enchant(player)
    if MYS_GiveRandomEnchant then pcall(MYS_GiveRandomEnchant, player) end
end

-- (creature drops of runes and scrolls are now normal loot: sql/loot_*.sql)

RegisterPlayerEvent(54, function(_, player, questId, status)   -- quest status changed
    if status ~= 6 then return end                             -- QUEST_STATUS_REWARDED: handed in
    if not player:HasAura(HERO_AURA) then return end
    Rune(player, 1 + math.floor(player:GetLevel() / 25))
    if math.random() * 100 < 1 then Enchant(player) end
end)
print("[mystic] runes and enchants drop from creatures and quests")
