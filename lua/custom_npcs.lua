-- Custom story NPCs. Elder Druid Zul'mari (9903010) stands in Darkspear Hold, a Troll Druid of the Claw in bear form (retail model 33655).
if IS_WORLD_STATE then return end

local DRUID = 9903010
local LINES = {
    {"Who are the Druids of the Claw?", "The Zandalari taught our shaman to hear the loa, but a few of us heard something older: the wild itself. We wear the bear's shape to protect this island, mon."},
    {"What happened to the Echo Isles?", "Zalazane's curse turned our brothers against us. We hid in the roots of Sen'jin and waited. When Vol'jin returned, the island remembered us."},
    {"Teach me about bear form.", "Bear form is not a gift, it is a promise. The bear carries the burden of the pack. Stand in front of those who cannot, and your skin will become the island's wall."},
    {"I wish to walk the path of the Witch Doctor.", "The Darkspear have always listened to the loa, mon. If you are a Conquest hero, speak the words .coa witchdoctor and the spirits will teach you their hexes, wards and brews. The Echo Isles remember every doctor who came before you."},
    {"Any advice for a young hero?", "Walk slowly, listen to the island, and never ignore a hungry cat. De Wildmane stalk quiet, mon."},
}

local function Hello(_, player, c)
    player:GossipClearMenu()
    for i, l in ipairs(LINES) do player:GossipMenuAddItem(0, l[1], 0, i) end
    player:GossipMenuAddItem(0, "Never mind.", 0, 99)
    player:GossipSendMenu(1, c)
end
local function Select(_, player, c, _, intid)
    player:GossipComplete()
    local l = LINES[intid]
    if l then c:SendUnitSay(l[2], 0) end
end
RegisterCreatureGossipEvent(DRUID, 1, Hello)
RegisterCreatureGossipEvent(DRUID, 2, Select)
print("[custom_npcs] loaded")
