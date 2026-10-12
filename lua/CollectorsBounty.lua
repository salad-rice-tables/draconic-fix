-- CollectorBounty.lua
-- Gives a flat +5% extra on certain boss drops if player has aura 1300000

local BUFF_SPELL  = 1300000
local BONUS_RATE  = 0.05  -- +5% flat extra roll

-- just map bossEntry -> itemID
local CollectorDrops = {
  { bossEntry = 11502, itemID = 17204 },  -- Ragnaros → Eye of Sulfuras
  { bossEntry = 12056, itemID = 18817 },  -- Garr → Bindings of the Windseeker
  { bossEntry = 12098, itemID = 18819 },  -- Geddon → Bindings of the Windseeker
  { bossEntry = 22917, itemID = 32837 },  -- Illidan → Warglaive of the Azzinoth (side 1)
  { bossEntry = 22917, itemID = 32838 },  -- Illidan → Warglaive of the Azzinoth (side 2)
  { bossEntry = 24882, itemID = 32897 },  -- Kil’jaeden → Thori’dal
  { bossEntry = 105503, itemID = 119211 }, -- Gul’dan → Hearthstone Card: Jaraxxus
  { bossEntry = 45412, itemID = 13335 }, --  Rivendare
  { bossEntry = 16152, itemID = 30480 }, -- Warhose Huntsman
  { bossEntry = 19622, itemID = 32458 }, -- Ashes Kael'thas
  { bossEntry = 23035, itemID = 32768 }, -- Ravenlord
  { bossEntry = 24664, itemID = 35513 }, -- White Hawkstriker Kael
  -- add more bossEntry/itemID pairs here…
}

local function OnPlayerKill(event, player, victim)
  if not player:HasAura(BUFF_SPELL) then
    return
  end

  local entry = victim:GetEntry()
  for _, cfg in ipairs(CollectorDrops) do
    if cfg.bossEntry == entry then
      if math.random() < BONUS_RATE then
        player:AddItem(cfg.itemID, 1)
        player:SendBroadcastMessage(
          "Collector's Bounty: bonus drop! ["..cfg.itemID.."]"
        )
      end
    end
  end
end

RegisterPlayerEvent(7, OnPlayerKill)  -- PLAYER_EVENT_ON_KILL
