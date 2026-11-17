-- CoA multicast (Necromancer minion bar): 4 slots right of the Life Force orb. Left click = cast the slot's raise spell,
-- right click (or the small arrow) = flyout with every known raise spell to put into that slot. Saved per character (CoAUIDB.slots).
local SLOTS = 6
local RAISE = {7500970, 7504901, 7500971, 7500331, 7500332, 7500969, 7500335, 7500329, 7504859, 7504861, 7500989, 7531130, 7804681, 7805032, 7805044, 7805048, 7805428, 7803139, 7504682, 7600992}   -- every CoA necromancer Raise / Animate spell (+7000000)   -- CoA raise spells + 7000000
local parent = CoALifeForceFrame
local buttons = {}

local function Known(id) return IsPlayerSpell(id) or (C_SpellBook and C_SpellBook.IsSpellKnown and C_SpellBook.IsSpellKnown(id)) end

local flyout = CreateFrame("Frame", "CoAMinionFlyout", UIParent, "BackdropTemplate")
flyout:SetFrameStrata("DIALOG"); flyout:Hide()
flyout:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12, insets = {left = 3, right = 3, top = 3, bottom = 3}})
flyout:SetBackdropColor(0, 0.08, 0.08, 0.9)
local fbtns = {}

local function SetSlot(i, spell)
	if InCombatLockdown() then return end
	CoAUIDB.slots = CoAUIDB.slots or {}
	CoAUIDB.slots[i] = spell
	local b = buttons[i]
	b:SetAttribute("type1", spell and "spell" or nil)
	b:SetAttribute("spell1", spell)
	local tex = spell and C_Spell.GetSpellTexture(spell)
	b.icon:SetTexture(tex or 136222); b.icon:SetDesaturated(not spell)
end

local function OpenFlyout(i)
	local list = {}
	for _, id in ipairs(RAISE) do if Known(id) then list[#list + 1] = id end end
	for _, fb in ipairs(fbtns) do fb:Hide() end
	table.insert(list, 1, false)   -- bottom entry = empty slot
	for n, id in ipairs(list) do
		local fb = fbtns[n]
		if not fb then
			fb = CreateFrame("Button", nil, flyout); fb:SetSize(28, 28)
			fb.icon = fb:CreateTexture(nil, "ARTWORK"); fb.icon:SetAllPoints()
			fb:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square", "ADD")
			fb:SetScript("OnEnter", function(s) GameTooltip:SetOwner(s, "ANCHOR_RIGHT"); if s.spell ~= 0 then GameTooltip:SetSpellByID(s.spell) else GameTooltip:AddLine("Empty", 1, 1, 1) end GameTooltip:Show() end)
			fb:SetScript("OnLeave", GameTooltip_Hide)
			fbtns[n] = fb
		end
		fb.spell = id or 0
		fb.icon:SetTexture(id and C_Spell.GetSpellTexture(id) or 136222)
		fb:SetScript("OnClick", function() SetSlot(i, id or nil); flyout:Hide() end)
		fb:ClearAllPoints(); fb:SetPoint("BOTTOM", flyout, "BOTTOM", 0, 6 + (n - 1) * 30); fb:Show()
	end
	flyout:SetSize(38, 12 + #list * 30)
	flyout:ClearAllPoints(); flyout:SetPoint("BOTTOM", buttons[i], "TOP", 0, 4); flyout:Show()
end

for i = 1, SLOTS do
	local b = CreateFrame("Button", "CoAMinionSlot" .. i, parent, "SecureActionButtonTemplate")
	b:SetSize(32, 32)
	b:SetPoint("LEFT", parent, "LEFT", 74 + (i - 1) * 38, 2)
	b:RegisterForClicks("AnyUp", "AnyDown")
	b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetAllPoints(); b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	local border = b:CreateTexture(nil, "OVERLAY"); border:SetAllPoints(); border:SetAtlas("UI-HUD-ActionBar-IconFrame"); border:SetVertexColor(0, 1, 1)
	b:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square", "ADD")
	b:HookScript("OnClick", function(_, btn, down) if btn == "RightButton" and not down then if flyout:IsShown() then flyout:Hide() else OpenFlyout(i) end end end)
	b:SetScript("OnEnter", function(s)
		GameTooltip:SetOwner(s, "ANCHOR_TOP")
		local sp = CoAUIDB.slots and CoAUIDB.slots[i]
		if sp then GameTooltip:SetSpellByID(sp) else GameTooltip:AddLine("Empty minion slot", 1, 1, 1) end
		GameTooltip:AddLine("Right click: choose a minion", 0, 0.8, 1)
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", GameTooltip_Hide)
	b.arrow = CreateFrame("Button", nil, b); b.arrow:SetSize(22, 12); b.arrow:SetPoint("BOTTOM", b, "TOP", 0, 1); b.arrow:Hide()
	b.arrow.tex = b.arrow:CreateTexture(nil, "ARTWORK"); b.arrow.tex:SetAllPoints(); b.arrow.tex:SetAtlas("UI-HUD-ActionBar-Flyout-Up") ; b.arrow.tex:SetVertexColor(1, 0.82, 0)
	b.arrow:SetScript("OnClick", function() if flyout:IsShown() then flyout:Hide() else OpenFlyout(i) end end)
	b:HookScript("OnEnter", function(s) s.arrow:Show() end)
	b:HookScript("OnLeave", function(s) C_Timer.After(0.6, function() if not s:IsMouseOver() and not s.arrow:IsMouseOver() and not flyout:IsMouseOver() then s.arrow:Hide() end end) end)
	buttons[i] = b
end
local pendingLayout
local function Layout()
	if InCombatLockdown() then pendingLayout = true; return end   -- the slots are secure buttons: no show / hide / resize in combat
	pendingLayout = nil
	local cap = math.max(2, math.min(SLOTS, CoALifeForceCapacity or 2))
	for i = 1, SLOTS do buttons[i]:SetShown(i <= cap) end
	parent:SetWidth(74 + cap * 38 + 12)
end
Layout()
CoAMinionLayout = Layout

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD"); ev:RegisterEvent("SPELLS_CHANGED"); ev:RegisterEvent("PLAYER_REGEN_ENABLED")
local function Sync()
	if InCombatLockdown() then return end
	if pendingLayout then Layout() end
	CoAUIDB.slots = CoAUIDB.slots or {}
	for i = 1, SLOTS do
		local sp = CoAUIDB.slots[i]
		if not sp then   -- first time: fill empty slots with known raise spells
			for _, id in ipairs(RAISE) do
				local used = false
				for j = 1, SLOTS do if CoAUIDB.slots[j] == id then used = true end end
				if Known(id) and not used then sp = id; break end
			end
		end
		SetSlot(i, sp)
	end
end
ev:SetScript("OnEvent", function(_, event)
	Sync()
	if event == "PLAYER_ENTERING_WORLD" then   -- spells are taught a few seconds after login: re-sync so the first click already works
		for _, t in ipairs({3, 8, 15}) do C_Timer.After(t, Sync) end
	end
end)
