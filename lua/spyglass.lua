-- =====================================================================
-- Spyglass receiver: stores client-reported C_Spell.GetSpellInfo answers
-- (prefix SPYGLASS) into characters.spyglass for admin verification.
-- Read-only probe, no gameplay effect.
-- Loads at worldserver start from lua_scripts/. (Eluna must be enabled)
-- =====================================================================

local function SpyglassOnAddon(event, sender, _type, prefix, msg, target)
    if prefix ~= "SPYGLASS" then return end
    local who = "?"
    pcall(function() who = sender:GetName() end)
    if who == "?" then who = tostring(sender) or "?" end
    who = string.gsub(tostring(who), "'", "''")
    local clean = string.gsub(tostring(msg or ""), "'", "''")
    if #clean > 250 then clean = string.sub(clean, 1, 250) end
    pcall(CharDBExecute, "INSERT INTO characters.spyglass (sender, msg) VALUES ('" ..
        who .. "', '" .. clean .. "')")
end

if CharDBExecute ~= nil then
    RegisterServerEvent(30, SpyglassOnAddon)
    print("[spyglass] loaded: listening on SPYGLASS addon prefix")
else
    print("[spyglass] DISABLED: no CharDB access")
end
