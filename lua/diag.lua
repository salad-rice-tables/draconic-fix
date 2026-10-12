-- Diagnostic commands (output goes to Eluna.log). .peondiag stands next to a Lazy Peon and reports its state.
if not IS_WORLD_STATE then return end   -- chat commands are handled in the world state

local function Say(player, text)
    player:SendBroadcastMessage("|cff00ccff[diag]|r " .. text)
    PrintInfo("[diag] " .. player:GetName() .. ": " .. text)
end

RegisterPlayerEvent(42, function(_, player, command)
    local cmd = string.lower(command or "")
    if cmd ~= "peondiag" and cmd ~= "peonfix" then return end
    local peon = player:GetNearestCreature(60, 10556)
    if not peon then Say(player, "no Lazy Peon within 60 yards") return false end
    local before = peon:HasAura(17743)
    -- 17743 v 12.1 klientovi ukazuje bombu nad hlavou: NIKDY nepridavat. Len odstranit + ulozit.
    pcall(function() peon:RemoveAura(17743) end)
    pcall(function() peon:RemoveAura(18795) end)
    if cmd == "peonfix" then
        pcall(function() peon:EmoteState(0) end)
        pcall(function() peon:SetStandState(3) end)
    end
    Say(player, string.format("peon guid %d: aura 17743 before=%s after=%s stand=%s",
        peon:GetGUIDLow(), tostring(before), tostring(peon:HasAura(17743)), tostring(peon:GetStandState())))
    return false
end)
print("[diag] loaded")
