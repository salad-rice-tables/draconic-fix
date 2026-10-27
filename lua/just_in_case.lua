-- =====================================================================
-- Quest 86541 Just In Case... v1: fragment-combine cez Eluna poll.
-- 242254 nema ziadny loot-zdroj: pri 8x 237895 -> -8 +1x 242254 (Wiki: Combine).
-- Loot fragmentov nativny. Turn-in nativny. Wiki mechanika nasleduje v dalsom kole.
-- =====================================================================
if IS_WORLD_STATE then return end

if MAP_Timer then
    MAP_Timer("justincase.combine", function()
        for _, p in ipairs(MAP_Players() or {}) do
            if p and p:IsInWorld() then
                local okS, st = pcall(function() return p:GetQuestStatus(86541) end)
                if okS and st == STATUS_INCOMPLETE then
                    local okF, nf = pcall(function() return p:GetItemCount(237895) end)
                    local okC, nc = pcall(function() return p:GetItemCount(242254) end)
                    if okF and okC and nf >= 8 and nc == 0 then
                        local okR = pcall(function() return p:RemoveItem(237895, 8) end)
                        if okR then
                            pcall(function() p:AddItem(242254, 1) end)
                            pcall(function() p:SendBroadcastMessage("You combine the fragments.") end)
                            pcall(function() PrintInfo("[ds86541] combined for " .. p:GetName()) end)
                        end
                    end
                end
            end
        end
    end, 30000)
end

print("[just_in_case] loaded")
