local AIO = AIO or require("AIO")

if not AIO then
    print("Server: AIO library not loaded")
    return
end

print("Server: AIO library loaded")

local itemCost = 100

local function PurchaseItem(player, itemID, itemType)
    print("Server: PurchaseItem called with itemID:", itemID, "and itemType:", itemType)

    local itemCount = player:GetItemCount(500000)
    print("Server: Player has item count:", itemCount)

    if itemCount < itemCost then
        player:SendBroadcastMessage("You do not have enough Draconium.")
        print("Server: Not enough Draconium")
        return
    end

    player:RemoveItem(500000, itemCost)
    print("Server: Removed Draconium")

    local itemIDNumber = tonumber(itemID)
    if not itemIDNumber then
        print("Server: Invalid itemID:", itemID)
        player:SendBroadcastMessage("Invalid item ID.")
        return
    end

    player:AddItem(itemIDNumber, 1)
    print("Server: Added item:", itemIDNumber)

    player:SendBroadcastMessage(itemType:sub(1, 1):upper() .. itemType:sub(2) .. " purchased successfully!")
end

AIO.AddHandlers("collections", {
    PurchaseItem = function(player, itemID, itemType)
        print("Server: Received PurchaseItem with itemID:", itemID, "and itemType:", itemType)
        PurchaseItem(player, itemID, itemType)
    end
})

print("Server: AIO handler registered for 'collections'")
