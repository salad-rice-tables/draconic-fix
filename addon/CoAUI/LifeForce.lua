-- Necromancer Life Force orb (CoA look): flipbook orb that fills with free capacity + "free/capacity" text, on the Necro bar art.
-- Server: aura 1400011 "Life Force"; its stack count = FREE capacity (aura missing = 0 free); capacity = highest stack seen (login stack = capacity).
local LF_AURA = 1400011
local f = CreateFrame("Frame", "CoALifeForceFrame", UIParent)
f:SetSize(230, 56)
f:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 210)   -- default above the action bars; drag the orb / bar to move it
f:SetFrameStrata("MEDIUM")
f:Hide()
CoAUI.MakeMovable(f, "lifeforce")

local bgL = f:CreateTexture(nil, "BACKGROUND"); CoAUI.SetAtlas(bgL, "NecroBarLeft"); bgL:SetSize(25, 55); bgL:SetPoint("LEFT")
local bgR = f:CreateTexture(nil, "BACKGROUND"); CoAUI.SetAtlas(bgR, "NecroBarRight"); bgR:SetSize(25, 55); bgR:SetPoint("RIGHT")
local bgM = f:CreateTexture(nil, "BACKGROUND"); CoAUI.SetAtlas(bgM, "NecroBarMiddle"); bgM:SetPoint("TOPLEFT", bgL, "TOPRIGHT"); bgM:SetPoint("BOTTOMRIGHT", bgR, "BOTTOMLEFT")

local orb = CreateFrame("Frame", nil, f)
orb:SetSize(56, 56); orb:SetPoint("LEFT", f, "LEFT", 6, 4); orb:SetFrameLevel(f:GetFrameLevel() + 5)
local fill = orb:CreateTexture(nil, "ARTWORK"); fill:SetAllPoints()
local over = orb:CreateTexture(nil, "OVERLAY"); over:SetPoint("CENTER", -1, 0); over:SetSize(54, 54)
local art = orb:CreateTexture(nil, "OVERLAY", nil, 2); CoAUI.SetAtlas(art, "NecroResourceArtwork"); art:SetSize(89, 89); art:SetPoint("CENTER", -9, -9)
local text = orb:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); text:SetPoint("CENTER", 0, 0)

local cap, free, frame, ovFrame = 0, 0, 1, 1
orb:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine("Life Force", 1, 1, 1)
	GameTooltip:AddLine("You may Raise minions from the dead with Life Force.", 1, 0.82, 0, true)
	GameTooltip:AddLine(string.format("%d / %d free", free, cap), 0, 0.8, 1)
	GameTooltip:AddLine("Drag to move", 0.6, 0.6, 0.6)
	GameTooltip:Show()
end)
orb:SetScript("OnLeave", GameTooltip_Hide)
orb:EnableMouse(true); orb:RegisterForDrag("LeftButton")
orb:SetScript("OnDragStart", function() f:StartMoving() end)
orb:SetScript("OnDragStop", function() f:StopMovingOrSizing(); local p, _, rp, x, y = f:GetPoint(); CoAUIDB.lifeforce = {p, rp, x, y} end)

local acc = 0
orb:SetScript("OnUpdate", function(_, dt)
	acc = acc + dt
	if acc < 0.05 then return end
	acc = 0
	frame = frame % 64 + 1
	CoAUI.SetFlipFrame(fill, "NecroResourceFlipBook", 128, 128, frame)
	local target = cap > 0 and math.ceil(48 * (1 - free / cap)) + 1 or 48   -- overlay frame 1 = full, 48 = empty
	target = math.min(48, math.max(1, target))
	if ovFrame < target then ovFrame = ovFrame + 1 elseif ovFrame > target then ovFrame = ovFrame - 1 end
	CoAUI.SetFlipFrame(over, "NecroResourceOverlayFlipBook", 128, 128, ovFrame)
end)

-- data comes from the server as an addon message "LF;free;capacity" (prefix COAUI): aura fields can be secret values on Midnight
C_ChatInfo.RegisterAddonMessagePrefix("COAUI")
local function Show()
	if select(2, UnitClass("player")) ~= "DEATHKNIGHT" or cap <= 0 then f:Hide(); return end   -- slot 6 = Necromancer
	text:SetText(free .. "/" .. cap)
	f:Show()
end
-- unlock effect (first initiation quest): banner + sound + the orb grows in with a glow
local glow = orb:CreateTexture(nil, "OVERLAY", nil, 3); glow:SetTexture("Interface/Cooldown/star4"); glow:SetBlendMode("ADD"); glow:SetVertexColor(0.4, 1, 0.6); glow:SetSize(160, 160); glow:SetPoint("CENTER"); glow:SetAlpha(0)
local ag = f:CreateAnimationGroup()
local a1 = ag:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(1.2)
local s1 = ag:CreateAnimation("Scale"); s1:SetScaleFrom(0.3, 0.3); s1:SetScaleTo(1, 1); s1:SetDuration(1.2); s1:SetSmoothing("OUT")
local gg = orb:CreateAnimationGroup()
local g1 = gg:CreateAnimation("Alpha"); g1:SetTarget(glow); g1:SetFromAlpha(0); g1:SetToAlpha(1); g1:SetDuration(0.6); g1:SetStartDelay(0.6)
local g2 = gg:CreateAnimation("Rotation"); g2:SetTarget(glow); g2:SetDegrees(-180); g2:SetDuration(2.4); g2:SetStartDelay(0.6)
local g3 = gg:CreateAnimation("Alpha"); g3:SetTarget(glow); g3:SetFromAlpha(1); g3:SetToAlpha(0); g3:SetDuration(1.2); g3:SetStartDelay(1.8)
function CoALifeForceUnlock()
	PlaySound(888)   -- LEVELUP
	RaidNotice_AddMessage(RaidBossEmoteFrame, "|cff40ff80Life Force unlocked|r", ChatTypeInfo["RAID_BOSS_EMOTE"], 5)
	UIErrorsFrame:AddMessage("You may now raise minions from the dead.", 0.6, 1, 0.7)
	C_Timer.After(0.3, function() if f:IsShown() then ag:Play(); gg:Play() end end)
end

f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, event, prefix, msg)
	if event == "PLAYER_ENTERING_WORLD" then Show(); return end
	if prefix ~= "COAUI" or type(msg) ~= "string" then return end
	msg = msg:gsub("^COAUI	", "")
	if msg == "LFUNLOCK" then CoALifeForceUnlock(); return end
	local fr, cp = msg:match("^LF;(%d+);(%d+)")
	if fr then free, cap = tonumber(fr), tonumber(cp); CoALifeForceCapacity = cap; if CoAMinionLayout then CoAMinionLayout() end; Show() end
end)

-- the retail Death Knight rune pips do not belong to the Necromancer
local function HideRunes()
	if RuneFrame and select(2, UnitClass("player")) == "DEATHKNIGHT" then RuneFrame:SetAlpha(0) end
end
C_Timer.After(2, HideRunes)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
hooksecurefunc("PlayerFrame_UpdateArt", HideRunes)

-- /lf reset | /lf <x> <y> : put the Life Force bar back / at an offset from the bottom centre of the screen
SLASH_COALF1 = "/lf"
SlashCmdList.COALF = function(msg)
	local a, b = msg:match("^(-?%d+)%s+(-?%d+)")
	f:ClearAllPoints()
	if a then f:SetPoint("BOTTOM", UIParent, "BOTTOM", tonumber(a), tonumber(b)) else f:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 210) end
	local p, _, rp, x, y = f:GetPoint(); CoAUIDB.lifeforce = {p, rp, x, y}
end
-- shift + drag on a minion slot moves the whole bar too (the slots are clickable buttons, so plain drag stays free for the flyout)
local mv = CreateFrame("Frame"); mv:RegisterEvent("PLAYER_ENTERING_WORLD")
mv:SetScript("OnEvent", function()
	for i = 1, 6 do
		local b = _G["CoAMinionSlot" .. i]
		if b and not b.coaDrag then
			b.coaDrag = true; b:RegisterForDrag("LeftButton")
			b:HookScript("OnDragStart", function() if IsShiftKeyDown() and not InCombatLockdown() then f:StartMoving(); f.coaMoving = true end end)
			b:HookScript("OnDragStop", function() if f.coaMoving then f.coaMoving = nil; f:StopMovingOrSizing(); local p, _, rp, x, y = f:GetPoint(); CoAUIDB.lifeforce = {p, rp, x, y} end end)
		end
	end
end)
