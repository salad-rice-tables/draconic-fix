-- creation slot (client class id) -> CoA class key; generated from data/coa/coa_class_slots.json (tools/coa_class_slots.py)
COA_SLOT_KEY = {[1] = "barbarian", [2] = "suncleric", [3] = "ranger", [4] = "venomancer", [5] = "cultist", [6] = "necromancer", [7] = "witchdoctor", [8] = "runemaster", [9] = "sonofarugal", [10] = "monk", [11] = "primalist", [12] = "demonhunter"}

-- Slot 13 is the free-choice slot: the player picks any of the 21 CoA classes in game (stored in characters.wildcard_coa by wildcard.lua ChooseCoa).
-- Every script asks COA_KEY(player) instead of COA_SLOT_KEY[class], so the chosen class behaves exactly like a creation-screen class.
COA_CHOSEN = COA_CHOSEN or {}
function COA_KEY(p)
    local k = COA_SLOT_KEY[p:GetClass()]
    if k then return k end
    if p:GetClass() ~= 13 then return nil end
    local name = p:GetName() or ""
    local c = COA_CHOSEN[name]
    if c == nil then
        local ok, res = pcall(CharDBQuery, string.format("SELECT class FROM characters.wildcard_coa WHERE name = '%s'", (string.gsub(name, "'", "''"))))
        c = (ok and res) and res:GetString(0) or false
        if c then COA_CHOSEN[name] = c end   -- only a real choice is cached: the choice is saved by another Lua state
    end
    return c or nil
end
