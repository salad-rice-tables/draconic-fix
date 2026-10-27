-- Boss tomes: bosses and mini-bosses drop a Tome (items 9731001+, world.boss_tome) that teaches a Hero its signature ability.
-- The tome's use effect is the shared dummy spell 1402330 (sql/boss_tomes.sql); the item is consumed by the core.
if IS_WORLD_STATE then return end

local DUMMY, HERO_AURA = 1402330, 1400010
local TOME = {}   -- item -> {spell, boss}
local q = WorldDBQuery("SELECT item, spell, boss_name FROM boss_tome")
if q then
    repeat TOME[q:GetUInt32(0)] = {q:GetUInt32(1), q:GetString(2)} until not q:NextRow()
end

local function Esc(s) return (string.gsub(tostring(s or ""), "'", "''")) end -- local: Eluna izoluje subory, zdielany global nefunguje

local function Study(_, caster, spellId, effIndex, itemObj)
    if not caster or not caster.LearnSpell or not itemObj then return true end
    local t = TOME[itemObj:GetEntry()]
    if not t then return true end
    if not caster:HasAura(HERO_AURA) then
        caster:SendBroadcastMessage("|cffff8000[Tome]|r Only Heroes can study these tomes.")
        caster:AddItem(itemObj:GetEntry(), 1)   -- give it back, the core already consumed it
        return true
    end
    if caster:HasSpell(t[1]) then
        caster:SendBroadcastMessage("|cffff8000[Tome]|r You already know that ability.")
        caster:AddItem(itemObj:GetEntry(), 1)
        return true
    end
    pcall(function() caster:LearnSpell(t[1]) end)
    pcall(CharDBExecute, string.format("INSERT IGNORE INTO characters.wildcard_classless (name, spell, cost) VALUES ('%s', %d, 0)", Esc(caster:GetName()), t[1]))
    pcall(function() caster:PlayDirectSound(888, caster) end)
    pcall(function() caster:SendAddonMessage("WCARD", "MREV;T;" .. t[1] .. ";" .. t[2] .. ";Boss ability", 7, caster) end)   -- the unlock window
    caster:SendBroadcastMessage("|cffffd200[Tome]|r You learned the ability of " .. t[2] .. "! (" .. (GetSpellLink and GetSpellLink(t[1]) or ("spell " .. t[1])) .. ")")
    return true
end

local n = 0
for item in pairs(TOME) do
    RegisterItemEvent(item, 1, Study)   -- ON_DUMMY_EFFECT
    n = n + 1
end
print("[tomes] " .. n .. " boss tomes loaded")
