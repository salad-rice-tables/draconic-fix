-- .gear: puts back the gear that old logins mailed away ("Item(s) can not be equipped or stored..." mails): every item of those mails is
-- created again and worn in a free matching slot (anything that does not fit goes to the bags). Works once per character; afterwards delete the old mails.
local TAG = "|cffffd200[Gear]|r "
local SLOT = {[1] = 0, [2] = 1, [3] = 2, [5] = 4, [20] = 4, [6] = 5, [7] = 6, [8] = 7, [9] = 8, [10] = 9, [16] = 14, [13] = 15, [17] = 15, [21] = 15, [14] = 16, [22] = 16, [23] = 16, [15] = 17, [26] = 17}
local function Restore(p)
    local guid = tonumber(tostring(p:GetGUIDLow())) or 0
    local key = "gearrestore:" .. guid
    local done = WorldDBQuery("SELECT v FROM world.lw_state WHERE k = '" .. key .. "'")
    if done then p:SendBroadcastMessage(TAG .. "Already done for this character. Delete the old mails in your mailbox.") return end
    local q = CharDBQuery(string.format("SELECT ii.itemEntry FROM mail m JOIN mail_items mi ON mi.mail_id = m.id JOIN item_instance ii ON ii.guid = mi.item_guid WHERE m.receiver = %d AND m.subject LIKE 'Item(s) can not be equipped%%'", guid))
    if not q then p:SendBroadcastMessage(TAG .. "No mailed gear found.") return end
    WorldDBExecute("REPLACE INTO world.lw_state (k, v) VALUES ('" .. key .. "', '1')")
    local n, worn = 0, 0
    repeat
        local entry = q:GetUInt32(0)
        local it = WorldDBQuery("SELECT InventoryType FROM hotfixes.item_sparse WHERE ID = " .. entry)
        local inv = it and it:GetUInt32(0) or 0
        local item = p:AddItem(entry, 1)
        if item then
            n = n + 1
            local slot = SLOT[inv]
            if inv == 11 then slot = p:GetEquippedItemBySlot(10) and 11 or 10 end
            if inv == 12 then slot = p:GetEquippedItemBySlot(12) and 13 or 12 end
            if slot and not p:GetEquippedItemBySlot(slot) then
                if pcall(function() p:EquipItem(item, slot) end) then worn = worn + 1 end
            end
        end
    until not q:NextRow()
    p:SendBroadcastMessage(TAG .. n .. " items restored, " .. worn .. " of them worn. Delete the old mails now so you do not keep duplicates.")
end
RegisterPlayerEvent(42, function(event, player, command)
    if string.lower(command or "") == "gear" then Restore(player) return false end
end)
