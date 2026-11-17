-- CoA Character Advancement (Midnight port): class tree + specialization tree built from the exact CoA catalog (TalentData.lua, from the CoA client DBCs), Dragonflight node art.
-- Rules live on the server (coa_talents_main.lua).  client -> server COAUI "TAL;<id>" learn next rank | "UNL;<id>" remove a rank | "TRESET" | "TASK"
--                                                    server -> client COAUI "TS;<level>;<Tab>=<free>,...;<id>:<rank>|..."
local SLOT = {[1] = "barbarian", [2] = "suncleric", [3] = "ranger", [4] = "venomancer", [5] = "cultist", [6] = "necromancer", [7] = "witchdoctor", [8] = "runemaster", [9] = "sonofarugal", [10] = "monk", [11] = "primalist", [12] = "demonhunter", [13] = "chronomancer"}
local PREFIX = "COAUI"
local rank, free, plevel = {}, {}, 1
local W, H = 1500, 860
-- embedded in the Midnight spell window (P / N): CoA trees replace the retail Talents tab, CoA specs replace the Specialization tab
local f = CreateFrame("Frame", "CoATalentFrame", UIParent)
f:SetSize(W, H); f:SetPoint("CENTER"); f:Hide()   -- shown only inside the Talents tab (HookTabs)
local bg = f:CreateTexture(nil, "BACKGROUND", nil, 1); bg:SetPoint("TOPLEFT", 8, -62); bg:SetPoint("BOTTOMRIGHT", -8, 46); bg:SetVertexColor(0.8, 0.8, 0.8)
local locked = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge"); locked:SetPoint("CENTER"); locked:SetText("This feature becomes available at level 10"); locked:Hide()

local panels = {}
local function MakePanel(x)
	local p = CreateFrame("Frame", nil, f); p:SetSize(720, 690); p:SetPoint("TOPLEFT", x, -90)
	p.header = p:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge"); p.header:SetPoint("BOTTOM", p, "TOP", 0, 22)
	p.pts = p:CreateFontString(nil, "OVERLAY", "GameFontNormal"); p.pts:SetPoint("BOTTOM", p, "TOP", 0, 4)
	p.nodes, p.lines, p.gates = {}, {}, {}
	return p
end
panels[1] = MakePanel(20); panels[2] = MakePanel(760)
local specBtns = {}
local curSpec

local function Spent(tab)
	local s = 0
	for _, n in ipairs(tab.nodes) do s = s + (rank[n.id] or 0) * (tab.name == "Class" and n.ae or n.te) end
	return s
end
local function Gate(tab, n) return tab.name == "Class" and n.gae or n.gte end
local function Learned(id) return (rank[id] or 0) > 0 end

local function Available(tab, n, byId)
	local roots, any = true, false
	for _, r in ipairs(n.req) do if byId[r] then roots = false; if Learned(r) then any = true end end end
	if not roots and not any then return false end
	return Gate(tab, n) <= Spent(tab)
end

local function Refresh()
	for pi, p in ipairs(panels) do
		local tab = p.tab
		if tab then
			local byId = {}
			for _, n in ipairs(tab.nodes) do byId[n.id] = n end
			for _, n in ipairs(tab.nodes) do
				local b = p.nodes[n.id]
				local have, can = Learned(n.id), (n.auto == 0 and Available(tab, n, byId) and (n.lvl or 0) <= plevel)
				local state = (have and "yellow") or (can and "selectable" or "gray")
				if n.auto == 1 then state = plevel >= 10 and "yellow" or "gray" end
				b:SetState(state)
				b.rank:SetText((n.auto == 0 and (#n.ranks > 1 or have)) and ((rank[n.id] or 0) .. "/" .. #n.ranks) or "")
			end
			for _, ln in ipairs(p.lines) do
				local on = Learned(ln.a) and Learned(ln.b)
				ln:SetColorTexture(on and 1 or 0.35, on and 0.82 or 0.35, on and 0.2 or 0.35, on and 0.9 or 0.6)
			end
			local n = free[tab.name] or 0
			p.pts:SetText(n > 0 and ("|cff00ff00" .. n .. "|r") or ("|cff888888" .. n .. "|r"))
			local spent = Spent(tab)
			for _, g in ipairs(p.gates) do
				local left = g.need - spent
				g.text:SetText(left > 0 and left or ""); g:SetShown(left > 0)
			end
		end
	end
	locked:SetShown(plevel < 10)
end

local function Build(p, tab, label)
	p.tab = tab; p.header:SetText(label)
	for _, b in pairs(p.nodes) do b:Hide() end
	for _, l in ipairs(p.lines) do l:Hide() end
	for _, g in ipairs(p.gates) do g:Hide() end
	wipe(p.lines); wipe(p.gates)
	local maxY = 1
	for _, n in ipairs(tab.nodes) do if n.y > maxY then maxY = n.y end end
	local CW, CH, X0, Y0 = 70, math.min(70, 640 / maxY), 20, 10
	local pos = {}
	for _, n in ipairs(tab.nodes) do pos[n.id] = {X0 + (n.x - 1) * CW + 19, -(Y0 + (n.y - 1) * CH) - 19} end
	for _, n in ipairs(tab.nodes) do
		local ups = {}
		for _, r in ipairs(n.req) do ups[#ups + 1] = r end
		for _, r in ipairs(n.lk or {}) do ups[#ups + 1] = r end
		for _, r in ipairs(ups) do
			local a, b = pos[r], pos[n.id]
			if a and b then
				local ln = p:CreateLine(nil, "BACKGROUND"); ln:SetThickness(2)
				ln:SetStartPoint("TOPLEFT", p, a[1], a[2]); ln:SetEndPoint("TOPLEFT", p, b[1], b[2]); ln.a, ln.b = r, n.id
				tinsert(p.lines, ln)
			end
		end
	end
	local gateRow = {}
	for _, n in ipairs(tab.nodes) do
		local g = Gate(tab, n)
		if g > 0 and (not gateRow[g] or n.y < gateRow[g]) then gateRow[g] = n.y end
		local b = p.nodes[n.id]
		if not b then
			b = CreateFrame("Button", nil, p); b:SetSize(40, 40); b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
			local shape = (n.sh == "s") and "square" or ((n.sh == "h") and "choice" or "circle")
			b.shadow = b:CreateTexture(nil, "BACKGROUND"); b.shadow:SetPoint("CENTER"); b.shadow:SetSize(60, 60); b.shadow:SetAtlas("talents-node-" .. shape .. "-shadow")
			b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetPoint("TOPLEFT", 6, -6); b.icon:SetPoint("BOTTOMRIGHT", -6, 6)
			b.ring = b:CreateTexture(nil, "OVERLAY"); b.ring:SetPoint("CENTER"); b.ring:SetSize(52, 52)
			b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
			b.rank = b:CreateFontString(nil, "OVERLAY", "NumberFont_OutlineThick_Mono_Small"); b.rank:SetPoint("BOTTOMRIGHT", 2, -2)
			b.SetState = function(s, state) s.ring:SetAtlas("talents-node-" .. shape .. "-" .. state); s.icon:SetDesaturated(state ~= "yellow"); s.icon:SetAlpha(state == "gray" and 0.45 or 1) end
			p.nodes[n.id] = b
		end
		b.node, b.tab = n, tab
		local sid = n.ranks[math.max(1, rank[n.id] or 1)] or n.ranks[1]
		local tex = (n.ic and n.ic > 0 and n.ic) or (sid and C_Spell.GetSpellTexture(sid))
		b.icon:SetTexture(tex or 134400)
		b:ClearAllPoints(); b:SetPoint("CENTER", p, "TOPLEFT", pos[n.id][1], pos[n.id][2]); b:Show()
		b:SetScript("OnEnter", function(s)
			GameTooltip:SetOwner(s, "ANCHOR_RIGHT")
			local nn = s.node
			local sp = nn.ranks[math.max(1, rank[nn.id] or 1)] or nn.ranks[1]
			if sp and C_Spell.GetSpellInfo(sp) then GameTooltip:SetSpellByID(sp) else GameTooltip:AddLine(nn.name, 1, 1, 1) end
			GameTooltip:AddLine((rank[nn.id] or 0) .. "/" .. #nn.ranks .. " ranks", 1, 0.82, 0)
			if nn.lvl and nn.lvl > 0 then GameTooltip:AddLine("Requires level " .. nn.lvl, 1, 0.3, 0.3) end
			if nn.auto == 0 then GameTooltip:AddLine("Left click: learn   Right click: unlearn", 0.7, 0.7, 0.7) end
			GameTooltip:Show()
		end)
		b:SetScript("OnLeave", GameTooltip_Hide)
		b:SetScript("OnClick", function(s, btn) if s.node.auto == 0 then C_ChatInfo.SendAddonMessage(PREFIX, (btn == "RightButton" and "UNL;" or "TAL;") .. s.node.id, "WHISPER", UnitName("player")) end end)
	end
	for need, row in pairs(gateRow) do   -- red number = points still missing in this tree, at the row where the gate starts
		local g = CreateFrame("Frame", nil, p); g:SetSize(60, 16); g.need = need
		g:SetPoint("LEFT", p, "TOPLEFT", -12, -(Y0 + (row - 1) * CH) + CH / 2 + 4)
		g.line = g:CreateTexture(nil, "ARTWORK"); g.line:SetPoint("LEFT", 22, 0); g.line:SetSize(40, 2); g.line:SetColorTexture(0.8, 0.2, 0.1, 0.8)
		g.text = g:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); g.text:SetPoint("LEFT", 0, 0); g.text:SetTextColor(1, 0.35, 0.25)
		tinsert(p.gates, g)
	end
end

local function Show(spec)
	local key = SLOT[select(3, UnitClass("player"))]
	local tree = key and CoAUI_Trees and CoAUI_Trees[key]
	if not tree then return end
	local class, specs = nil, {}
	for _, t in ipairs(tree.tabs) do if t.name == "Class" then class = t else specs[#specs + 1] = t end end
	curSpec = spec or curSpec or (specs[1] and specs[1].name)
	Build(panels[1], class, (UnitClass("player")))
	for _, t in ipairs(specs) do if t.name == curSpec then Build(panels[2], t, t.name) end end
	for i, t in ipairs(specs) do
		local b = specBtns[i]
		if not b then b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); b:SetSize(120, 24); b:SetPoint("BOTTOMLEFT", 780 + (i - 1) * 124, 18); specBtns[i] = b end
		b:SetText(t.name); b:SetScript("OnClick", function() Show(t.name) end); b:Show()
	end
	local okb = CoAUI.SetAtlas(bg, ("talents-background-%s-%s"):format(key, (curSpec or ""):lower()))
	if not okb then bg:SetColorTexture(0.05, 0.08, 0.1, 0.9) end
	Refresh()
end

local reset = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); reset:SetSize(120, 24); reset:SetPoint("BOTTOMLEFT", 20, 18); reset:SetText("Reset Trees")
reset:SetScript("OnClick", function() C_ChatInfo.SendAddonMessage(PREFIX, "TRESET", "WHISPER", UnitName("player")) end)

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON"); ev:RegisterEvent("PLAYER_LOGIN"); ev:RegisterEvent("PLAYER_ENTERING_WORLD"); ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:SetScript("OnEvent", function(_, e, prefix, msg)
	if e == "PLAYER_LOGIN" then
		C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
		C_Timer.After(1, function() WildcardCA_Toggle = function() CoATalents_Toggle() end end)   -- the N key (Wildcard binding) opens this window
	elseif e == "PLAYER_ENTERING_WORLD" or e == "PLAYER_LEVEL_UP" then
		plevel = UnitLevel("player")
		C_Timer.After(4, function() C_ChatInfo.SendAddonMessage(PREFIX, "TASK", "WHISPER", UnitName("player")) end)
	elseif prefix == PREFIX and type(msg) == "string" then
		msg = msg:gsub("^COAUI\t", "")
		local lv, pts, list = msg:match("^TS;(%d+);([^;]*);(.*)$")
		if lv then
			plevel = tonumber(lv); wipe(free); wipe(rank)
			for name, n in pts:gmatch("([^,=]+)=(%d+)") do free[name] = tonumber(n) end
			for id, r in list:gmatch("(%d+):(%d+)") do rank[tonumber(id)] = tonumber(r) end
			if f:IsVisible() then Show(curSpec) end
		end
	end
end)

function CoATalents_Toggle()
	local U = PlayerSpellsUtil
	if not (U and pcall(function() if PlayerSpellsFrame and PlayerSpellsFrame:IsShown() and PlayerSpellsFrame.TalentsFrame:IsShown() then HideUIPanel(PlayerSpellsFrame) else U.OpenToClassTalentsTab() end end)) then TogglePlayerSpellsFrame() end
end
SLASH_COATALENTS1 = "/coa"; SlashCmdList.COATALENTS = CoATalents_Toggle

local function Cover(host)    -- opaque layer (sibling of the retail tab, drawn above it) that carries our content; the retail tab itself is made invisible
	local pf = PlayerSpellsFrame
	local c = CreateFrame("Frame", nil, pf)
	c:SetPoint("TOPLEFT", pf, "TOPLEFT", 6, -28); c:SetPoint("BOTTOMRIGHT", pf, "BOTTOMRIGHT", -6, 6); c:SetFrameLevel(9000); c:EnableMouse(true)
	local t = c:CreateTexture(nil, "BACKGROUND"); t:SetAllPoints(); t:SetColorTexture(0.04, 0.05, 0.07, 1)
	local function Sync() host:SetAlpha(0); c:SetShown(host:IsShown()) end
	host:HookScript("OnShow", Sync); host:HookScript("OnHide", Sync); Sync()
	return c
end

local specCover
local function BuildSpecs()
	local n = GetNumSpecializations and GetNumSpecializations() or 0
	local cur = GetSpecialization and GetSpecialization() or 0
	local key = SLOT[select(3, UnitClass("player"))]
	specCover.cards = specCover.cards or {}
	for i = 1, math.max(n, 3) do
		local id, name, desc, icon, role = GetSpecializationInfo(i)
		local card = specCover.cards[i]
		if not card then
			card = CreateFrame("Frame", nil, specCover); card:SetSize(420, 560)
			card.art = card:CreateTexture(nil, "BACKGROUND"); card.art:SetAllPoints()
			card.icon = card:CreateTexture(nil, "ARTWORK"); card.icon:SetSize(72, 72); card.icon:SetPoint("TOP", 0, -30)
			card.name = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge"); card.name:SetPoint("TOP", card.icon, "BOTTOM", 0, -10)
			card.role = card:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); card.role:SetPoint("TOP", card.name, "BOTTOM", 0, -6)
			card.desc = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); card.desc:SetWidth(360); card.desc:SetPoint("TOP", card.role, "BOTTOM", 0, -16); card.desc:SetJustifyH("CENTER")
			card.btn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate"); card.btn:SetSize(180, 30); card.btn:SetPoint("BOTTOM", 0, 30)
			card:SetPoint("CENTER", specCover, "CENTER", (i - 2) * 440, 0); card:SetScale(specCover:GetWidth() > 0 and math.min(specCover:GetWidth() / 1360, specCover:GetHeight() / 640) or 1)
			specCover.cards[i] = card
		end
		if id then
			card:Show()
			if not (CoAUI and CoAUI.SetAtlas and CoAUI.SetAtlas(card.art, ("talents-background-%s-%s"):format(key or "", name:lower()))) then card.art:SetColorTexture(0.08, 0.1, 0.14, 0.9) end
			card.icon:SetTexture(icon); card.name:SetText(name)
			card.role:SetText(role == "TANK" and "Tank" or role == "HEALER" and "Healer" or "Damage")
			card.desc:SetText(desc)
			card.btn:SetText(i == cur and "Active" or "Activate"); card.btn:SetEnabled(i ~= cur)
			card.btn:SetScript("OnClick", function() local f2 = (C_SpecializationInfo and C_SpecializationInfo.SetSpecialization) or SetSpecialization; pcall(f2, i); C_Timer.After(1, BuildSpecs) end)
		else card:Hide() end
	end
end

local function HookTabs()
	local pf = PlayerSpellsFrame
	if not pf or pf.coaHooked or not pf.TalentsFrame then return end
	pf.coaHooked = true
	local tc = Cover(pf.TalentsFrame)
	f:SetParent(tc); f:ClearAllPoints(); f:SetPoint("CENTER", tc, "CENTER", 0, 0); f:Show()
	bg:ClearAllPoints(); bg:SetPoint("TOPLEFT", tc, "TOPLEFT", 0, 0); bg:SetPoint("BOTTOMRIGHT", tc, "BOTTOMRIGHT", 0, 0)   -- the art fills the whole tab
	local function Fit() local w, h = tc:GetSize(); if w and w > 0 then f:SetScale(math.min(w / W, h / H)) end end   -- the trees fill the whole tab
	tc:SetScript("OnSizeChanged", Fit); Fit()
	pf.TalentsFrame:HookScript("OnShow", function() tc:Show(); pcall(function() pf:SetSize(1500, 900) end); if SLOT[select(3, UnitClass("player"))] then plevel = UnitLevel("player"); Show() end end)
end
local hk = CreateFrame("Frame"); hk:RegisterEvent("ADDON_LOADED"); hk:RegisterEvent("PLAYER_ENTERING_WORLD")
hk:SetScript("OnEvent", function() HookTabs() end)
SLASH_COADUMP1 = "/coadump"
SlashCmdList.COADUMP = function()
	CoAUIDB = CoAUIDB or {}; local o = {}
	for pi, p in ipairs(panels) do
		o[#o + 1] = "panel" .. pi .. " " .. p:GetWidth() .. "x" .. p:GetHeight() .. " tab=" .. tostring(p.tab and p.tab.name)
		local c = 0
		for id, b in pairs(p.nodes) do c = c + 1; if c < 6 then local pt, rel, rp, x, y = b:GetPoint(); o[#o + 1] = id .. " " .. tostring(pt) .. " " .. tostring(rp) .. " " .. tostring(x) .. "," .. tostring(y) .. " y=" .. tostring(b.node.y) .. " x=" .. tostring(b.node.x) end end
	end
	CoAUIDB.dump = o
end
