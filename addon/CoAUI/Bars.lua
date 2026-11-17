-- Necromancer player frame (CoA): health, runic power bar (brown) under the main bar, mana as the main power bar. Life Force orb is LifeForce.lua.
local RUNIC = 6
local bar = CreateFrame("StatusBar", "CoARunicPowerBar", UIParent)
bar:SetStatusBarTexture("Interface/TargetingFrame/UI-StatusBar")
bar:SetStatusBarColor(0.0, 0.82, 1.0)   -- light blue, the colour of the original Runic Power bar
bar:SetSize(124, 10); bar:SetMinMaxValues(0, 100); bar:SetValue(0)
bar:SetFrameStrata("MEDIUM"); bar:Hide()
local bg = bar:CreateTexture(nil, "BACKGROUND"); bg:SetAllPoints(); bg:SetColorTexture(0.0, 0.1, 0.15, 0.8)
local txt = bar:CreateFontString(nil, "OVERLAY", "TextStatusBarText"); txt:SetPoint("CENTER")

local function ManaBar()
	local pf = PlayerFrame
	local c = pf and pf.PlayerFrameContent and pf.PlayerFrameContent.PlayerFrameContentMain
	local area = c and c.ManaBarArea
	return area and area.ManaBar or (pf and pf.manabar) or PlayerFrameManaBar
end

local function Place()
	local mb = ManaBar()
	bar:ClearAllPoints()
	if mb then   -- same width as the main power bar, directly under it
		bar:SetParent(PlayerFrame)
		bar:SetPoint("TOPLEFT", mb, "BOTTOMLEFT", 0, -1)
		bar:SetPoint("TOPRIGHT", mb, "BOTTOMRIGHT", 0, -1)
		bar:SetHeight(10)
	elseif PlayerFrame then
		bar:SetPoint("TOPLEFT", PlayerFrame, "BOTTOMLEFT", 92, 32)
	end
end

local function Update()
	if select(2, UnitClass("player")) ~= "DEATHKNIGHT" then bar:Hide(); return end
	local max = UnitPowerMax("player", RUNIC)
	local cur = UnitPower("player", RUNIC)
	bar:SetMinMaxValues(0, max > 0 and max or 100)
	bar:SetValue(cur)
	txt:SetText(cur .. " / " .. (max > 0 and max or 100))
	bar:Show()
end
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterUnitEvent("UNIT_POWER_FREQUENT", "player")
bar:RegisterUnitEvent("UNIT_MAXPOWER", "player")
bar:SetScript("OnEvent", function(_, e) if e == "PLAYER_ENTERING_WORLD" then Place(); C_Timer.After(1, Place) end Update() end)
