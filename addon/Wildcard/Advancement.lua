-- =====================================================================
-- Character Advancement, Descend layout: class banners down the left side (plus Summary), an open book in the
-- middle (left page Ability Essence, right page Talent Essence) and a spell list on the right (Spells | Specs).
-- Bottom: Rapid Rolling, the Ability Essence orb and the window tabs. Opens with N (Bindings.xml), the Hero's
-- Codex, or when the server sends OPEN;home / OPEN;mystic.
-- Data: LIST -> POOL / TAL / BUILD / TBUILD / STATE, MLIST -> MYS / MSTATE.
-- =====================================================================

local PREFIX = "WCARD"
local W, H = 1200, 790
local COLS, ROWS = 2, 8
local PER_PAGE = COLS * ROWS
local LIST_ROWS = 11
local RAR = {
    [1] = {name = "Common",    hex = "ffffffff"},
    [2] = {name = "Uncommon",  hex = "ff1eff00"},
    [3] = {name = "Rare",      hex = "ff0070dd"},
    [4] = {name = "Epic",      hex = "ffa335ee"},
    [5] = {name = "Legendary", hex = "ffff8000"},
    [6] = {name = "Artifact",  hex = "ffe6cc80"},
    [7] = {name = "Immortal",  hex = "ffff3a3a"},
    [8] = {name = "Godly",     hex = "ff3de6ff"},
}
local LISTHEX = {[1] = "ffffffff", [2] = "ff1eff00", [3] = "ff0070dd", [4] = "ffa335ee", [5] = "ffff8000", [6] = "ffe6cc80", [7] = "ffff3a3a", [8] = "ff3de6ff"}
local PATH_NAME = {[1] = "Classless", [2] = "Wildcard", [3] = "Conquest"}
local AE_COST = {[1] = 1, [2] = 2, [3] = 3, [4] = 5, [5] = 7, [7] = 10, [8] = 14}
local GOLD = {0.85, 0.68, 0.28}

local data = {pool = {}, build = {}, owned = {}, level = 1, rerolls = 0, pending = 0, path = 0, ae = 0, aeTotal = 0,
    tal = {}, towned = {}, te = 0, teTotal = 0, chains = {}, trees = {}, chainByFirst = {},
    mys = {}, mslots = 0, mused = 0, mleg = 0, mepic = 0, flash = {}}
-- cls 0 = Summary (your build); 1-13 = class
local view = {mode = "ca", cls = 0, tab = 1, page = 1, mpage = 1, lpage = 1, rtab = "spells", search = ""}

local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, msg, "WHISPER", UnitName("player")) end
-- icons for the Dice of Destiny reel (Wildcard.lua)
function WildcardPoolIcons()
    if #data.pool < 12 then return nil end
    local out = {}
    for i = 1, 40 do
        local e = data.pool[math.random(#data.pool)]
        local info = C_Spell.GetSpellInfo(e.id)
        if info and info.iconID then out[#out + 1] = info.iconID end
    end
    return #out > 0 and out or nil
end
local function SpellName(id) local i = C_Spell.GetSpellInfo(id); return i and i.name or ("Spell " .. id) end
local function SpellIcon(id) local i = C_Spell.GetSpellInfo(id); return i and i.iconID or 134400 end
local function ClassName(c)
    if c == 0 then return "Summary" end
    return (GetClassInfo(c)) or ("Class " .. c)
end
local function Confirm(key, text, fn)
    StaticPopupDialogs[key] = {text = text, button1 = YES, button2 = NO, OnAccept = fn,
        timeout = 0, whileDead = true, hideOnEscape = true}
    StaticPopup_Show(key)
end
local function Owned(c) local n = 0; for _, e in ipairs(c.ranks) do if data.towned[e.id] then n = n + 1 end end; return n end

-- ---------------------------------------------------------------- frame

-- Blizzard's own portrait panel (PortraitFrameTemplate): their nine-slice frame, bronze border, inset and close button; our content keeps its layout
local ok, f = pcall(CreateFrame, "Frame", "WildcardAdvancementFrame", UIParent, "PortraitFrameTemplate")
local blizz = ok and f ~= nil
if not blizz then f = CreateFrame("Frame", "WildcardAdvancementFrame", UIParent, "BackdropTemplate") end
f:SetSize(W, H)
f:SetPoint("CENTER", 0, 10)
f:SetFrameStrata("HIGH")
f:SetToplevel(true)
f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton"); f:SetClampedToScreen(true)
f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
if not blizz then
    f:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background-Dark", edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11}})
    f:SetBackdropColor(1, 1, 1, 1)
else
    if f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, 133741) end   -- the Hero emblem in the frame's own portrait
    if f.Inset then f.Inset:Hide() end
end
f:Hide()
tinsert(UISpecialFrames, "WildcardAdvancementFrame")

local titleBar = f:CreateTexture(nil, "ARTWORK")
titleBar:SetPoint("TOPLEFT", 6, -6); titleBar:SetPoint("TOPRIGHT", -6, -6); titleBar:SetHeight(26)
titleBar:SetColorTexture(0, 0, 0, 0)
local title = {SetText = function(_, t) if f.SetTitle then f:SetTitle(t) end end}   -- the title bar is Blizzard's own
local info = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
info:SetPoint("TOPRIGHT", -34, -9)

local close = blizz and f.CloseButton or CreateFrame("Button", nil, f, "UIPanelCloseButton")
if not blizz then close:SetPoint("TOPRIGHT", -2, -3) end

-- click area over the portrait (opens the help)
local portrait = CreateFrame("Button", nil, f)
portrait:SetSize(60, 60); portrait:SetPoint("TOPLEFT", -6, 6)
portrait:SetFrameLevel(f:GetFrameLevel() + 6)

local openAG = f:CreateAnimationGroup()
local fade = openAG:CreateAnimation("Alpha"); fade:SetFromAlpha(0); fade:SetToAlpha(1); fade:SetDuration(0.2)
local grow = openAG:CreateAnimation("Scale"); grow:SetScaleFrom(0.94, 0.94); grow:SetScaleTo(1, 1); grow:SetDuration(0.2)
grow:SetSmoothing("OUT")

local Render

-- ---------------------------------------------------------------- class banners (left column)

-- alphabetical like Descend: classes, then Summary
local ORDER = {6, 12, 11, 13, 3, 8, 10, 2, 5, 4, 7, 9, 1, 0}
local classBtns = {}
local function SetClassIcon(tex, cls)
    local _, file = GetClassInfo(cls)
    if file and C_Texture.GetAtlasInfo("classicon-" .. file:lower()) then
        tex:SetAtlas("classicon-" .. file:lower())
    elseif file and CLASS_ICON_TCOORDS and CLASS_ICON_TCOORDS[file] then
        tex:SetTexture("Interface/TargetingFrame/UI-Classes-Circles")
        tex:SetTexCoord(unpack(CLASS_ICON_TCOORDS[file]))
    else
        tex:SetTexture(134400)
    end
end
local listInset = CreateFrame("Frame", nil, f, "InsetFrameTemplate")   -- Blizzard inset behind the class list
listInset:SetPoint("TOPLEFT", 6, -64); listInset:SetSize(148, #ORDER * 41 + 8)
for i, cls in ipairs(ORDER) do
    local b = CreateFrame("Button", nil, f)
    b:SetSize(136, 38)
    b:SetPoint("TOPLEFT", 11, -68 - (i - 1) * 41)
    local _, file = GetClassInfo(cls ~= 0 and cls or 1)
    local col = cls ~= 0 and RAID_CLASS_COLORS[file] or {r = 1, g = 0.82, b = 0}
    b.col = col
    b.icon = b:CreateTexture(nil, "ARTWORK")
    b.icon:SetSize(30, 30); b.icon:SetPoint("LEFT", 4, 0)
    if cls ~= 0 then SetClassIcon(b.icon, cls) else b.icon:SetTexture(133741) end
    b.label = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    b.label:SetPoint("LEFT", b.icon, "RIGHT", 6, 0)
    b.label:SetText(ClassName(cls)); b.label:SetTextColor(col.r, col.g, col.b)
    b.sel = b:CreateTexture(nil, "BACKGROUND")
    b.sel:SetAllPoints(); b.sel:SetAtlas("Options_List_Active"); b.sel:Hide()
    b.badge = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    b.badge:SetPoint("RIGHT", -6, 0)
    b:SetHighlightAtlas("Options_List_Hover")
    b.cls = cls
    b:SetScript("OnClick", function(self)
        view.cls = self.cls
        view.page, view.tab, view.lpage = 1, 1, 1
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        Render()
    end)
    classBtns[i] = b
end

-- ---------------------------------------------------------------- the book

local PAGE_TEX = {383588, 383589}   -- Blizzard's own book pages (Professions book, left and right)
local pageNo = 0
local function Page(x, w)
    pageNo = pageNo + 1
    local p = CreateFrame("Frame", nil, f)
    p:SetPoint("TOPLEFT", x, -46)
    p:SetSize(w, 664)
    WildcardSkin(p, 0.92)                        -- Blizzard inset border over a dark body
    p.bg = p:CreateTexture(nil, "BACKGROUND", nil, -6)
    p.bg:SetPoint("TOPLEFT", 3, -3); p.bg:SetPoint("BOTTOMRIGHT", -3, 3)
    p.bg:SetColorTexture(0, 0, 0, 0)
    p.spine = p:CreateTexture(nil, "BORDER")
    p.spine:SetColorTexture(0, 0, 0, 0)
    p.head = p:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    p.head:SetPoint("TOP", 0, -14)
    p.head:SetTextColor(1, 0.82, 0)
    return p
end
local left = Page(152, 392)
local right = Page(546, 392)
left.spine:SetPoint("TOPRIGHT", -3, -3); left.spine:SetPoint("BOTTOMRIGHT", -3, 3); left.spine:SetWidth(30)
right.spine:SetPoint("TOPLEFT", 3, -3); right.spine:SetPoint("BOTTOMLEFT", 3, 3); right.spine:SetWidth(30)

local function Arrow(parent, dir)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(26, 26)
    b:SetNormalTexture("Interface/Buttons/UI-SpellbookIcon-" .. dir .. "Page-Up")
    b:SetPushedTexture("Interface/Buttons/UI-SpellbookIcon-" .. dir .. "Page-Down")
    b:SetDisabledTexture("Interface/Buttons/UI-SpellbookIcon-" .. dir .. "Page-Disabled")
    b:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight", "ADD")
    return b
end
local prev, nxt = Arrow(left, "Prev"), Arrow(left, "Next")
prev:SetPoint("BOTTOMLEFT", 12, 8); nxt:SetPoint("BOTTOMRIGHT", -34, 8)
local pageText = left:CreateFontString(nil, "OVERLAY", "GameFontNormal")
pageText:SetPoint("BOTTOM", -10, 14); pageText:SetTextColor(0.9, 0.9, 0.9)

-- header icons on the left page: the class (or Hero) badge and the learned abilities as a row
local classBadge = CreateFrame("Frame", nil, left)
classBadge:SetSize(40, 40); classBadge:SetPoint("TOPLEFT", 14, -44)
classBadge.tex = classBadge:CreateTexture(nil, "ARTWORK"); classBadge.tex:SetAllPoints()
classBadge.name = classBadge:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
classBadge.name:SetPoint("TOP", classBadge, "BOTTOM", 0, 0); classBadge.name:SetTextColor(1, 0.82, 0)

local function MakeCell(parent, w, h)
    local c = CreateFrame("Button", nil, parent)
    c:SetSize(w, h)
    c:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    c.icon = c:CreateTexture(nil, "ARTWORK")
    c.icon:SetSize(h - 8, h - 8); c.icon:SetPoint("LEFT", 2, 0)
    c.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    c.frame = c:CreateTexture(nil, "OVERLAY")
    c.frame:SetAtlas("UI-HUD-ActionBar-IconFrame")
    c.frame:SetSize(h + 12, h + 12); c.frame:SetPoint("CENTER", c.icon, "CENTER")
    c.own = c:CreateTexture(nil, "OVERLAY", nil, 2)
    c.own:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); c.own:SetBlendMode("ADD")
    c.own:SetSize(h + 22, h + 22); c.own:SetPoint("CENTER", c.icon, "CENTER"); c.own:SetVertexColor(0.3, 1, 0.3); c.own:Hide()
    c.name = c:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    c.name:SetPoint("TOPLEFT", c.icon, "TOPRIGHT", 8, -2); c.name:SetJustifyH("LEFT")
    c.name:SetWidth(w - h - 6); c.name:SetWordWrap(false)
    c.info = c:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    c.info:SetPoint("TOPLEFT", c.name, "BOTTOMLEFT", 0, -1); c.info:SetJustifyH("LEFT")
    c:SetHighlightAtlas("search-highlight", "ADD")
    c.glow = c:CreateTexture(nil, "OVERLAY", nil, 3)
    c.glow:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); c.glow:SetBlendMode("ADD")
    c.glow:SetSize(h + 40, h + 40); c.glow:SetPoint("CENTER", c.icon, "CENTER"); c.glow:SetVertexColor(1, 0.85, 0.3); c.glow:SetAlpha(0)
    c.ag = c.glow:CreateAnimationGroup()
    local a1 = c.ag:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(0.15); a1:SetOrder(1)
    local a2 = c.ag:CreateAnimation("Alpha"); a2:SetFromAlpha(1); a2:SetToAlpha(0); a2:SetDuration(0.9); a2:SetOrder(2)
    c:SetScript("OnEnter", function(self)
        if not self.spellId then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(self.spellId)
        if self.hint then GameTooltip:AddLine(" "); GameTooltip:AddLine(self.hint, 0.2, 1, 0.2, true) end
        if self.warn then GameTooltip:AddLine(self.warn, 1, 0.3, 0.3, true) end
        GameTooltip:Show()
    end)
    c:SetScript("OnLeave", GameTooltip_Hide)
    return c
end

-- starter row (learned abilities) on the left page and the ability grid under it
local starters = {}
for i = 1, 8 do
    local b = CreateFrame("Button", nil, left)
    b:SetSize(36, 36)
    b:SetPoint("TOPLEFT", 66 + (i - 1) * 40, -46)
    b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetPoint("TOPLEFT", 2, -2); b.icon:SetPoint("BOTTOMRIGHT", -2, 2)
    b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    b.frame = b:CreateTexture(nil, "OVERLAY")
    b.frame:SetAtlas("UI-HUD-ActionBar-IconFrame"); b.frame:SetPoint("TOPLEFT", -8, 8); b.frame:SetPoint("BOTTOMRIGHT", 8, -8)
    b:SetScript("OnEnter", function(self)
        if not self.spellId then return end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM"); GameTooltip:SetSpellByID(self.spellId); GameTooltip:Show()
    end)
    b:SetScript("OnLeave", GameTooltip_Hide)
    starters[i] = b
end

local cells = {}
for i = 1, PER_PAGE do
    local c = MakeCell(left, 176, 40)
    local col, row = (i - 1) % COLS, math.floor((i - 1) / COLS)
    c:SetPoint("TOPLEFT", 14 + col * 186, -120 - row * 56)
    cells[i] = c
end

-- talent grid (right page)
local nodes = {}
local GRID_W, GRID_H = 340, 470
for i = 1, 96 do
    local n = CreateFrame("Button", nil, right)
    n:SetSize(40, 40)
    n:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    n.icon = n:CreateTexture(nil, "ARTWORK")
    n.icon:SetPoint("TOPLEFT", 3, -3); n.icon:SetPoint("BOTTOMRIGHT", -3, 3)
    n.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    n.frame = n:CreateTexture(nil, "OVERLAY")
    n.frame:SetAtlas("UI-HUD-ActionBar-IconFrame")
    n.frame:SetPoint("TOPLEFT", -8, 8); n.frame:SetPoint("BOTTOMRIGHT", 8, -8)
    n.rank = n:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    n.rank:SetPoint("BOTTOMRIGHT", 3, -3)
    n.rank:SetShadowColor(0, 0, 0, 1); n.rank:SetShadowOffset(1, -1)
    n.own = n:CreateTexture(nil, "OVERLAY", nil, 2)
    n.own:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); n.own:SetBlendMode("ADD")
    n.own:SetPoint("TOPLEFT", -14, 14); n.own:SetPoint("BOTTOMRIGHT", 14, -14); n.own:SetVertexColor(1, 0.85, 0.2); n.own:Hide()
    n.glow = n:CreateTexture(nil, "OVERLAY", nil, 3)
    n.glow:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); n.glow:SetBlendMode("ADD")
    n.glow:SetPoint("TOPLEFT", -26, 26); n.glow:SetPoint("BOTTOMRIGHT", 26, -26); n.glow:SetVertexColor(1, 0.95, 0.5); n.glow:SetAlpha(0)
    n.ag = n.glow:CreateAnimationGroup()
    local a1 = n.ag:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(0.15); a1:SetOrder(1)
    local a2 = n.ag:CreateAnimation("Alpha"); a2:SetFromAlpha(1); a2:SetToAlpha(0); a2:SetDuration(0.9); a2:SetOrder(2)
    n:SetHighlightAtlas("search-highlight", "ADD")
    n:SetScript("OnEnter", function(self)
        if not self.spellId then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(self.spellId)
        if self.hint then GameTooltip:AddLine(" "); GameTooltip:AddLine(self.hint, 0.2, 1, 0.2, true) end
        if self.warn then GameTooltip:AddLine(self.warn, 1, 0.3, 0.3, true) end
        GameTooltip:Show()
    end)
    n:SetScript("OnLeave", GameTooltip_Hide)
    nodes[i] = n
end
local emptyText = right:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
emptyText:SetPoint("CENTER", 0, 0); emptyText:SetTextColor(0.7, 0.7, 0.7)

-- right page header + tree tabs under it (Class / Hero)
local rightEss = right:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
rightEss:SetPoint("TOP", 0, -14); rightEss:SetTextColor(1, 0.82, 0)
local treeTabs = {}
for i = 1, 3 do
    local b = CreateFrame("Button", nil, right, "UIPanelButtonTemplate")
    b:SetSize(112, 22)
    b:SetPoint("TOPLEFT", 40 + (i - 1) * 118, -44)
    b:SetNormalFontObject("GameFontHighlightSmall")
    b:SetScript("OnClick", function() view.tab = i; PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN); Render() end)
    treeTabs[i] = b
end

-- ---------------------------------------------------------------- right panel: Spells | Specs list

local panel = CreateFrame("Frame", nil, f, "BackdropTemplate")
panel:SetPoint("TOPLEFT", 944, -46)
panel:SetSize(246, 664)
WildcardSkin(panel, 0.85)

local rtabs = {}
for i, t in ipairs({{"spells", "Spells"}, {"specs", "Specs"}}) do
    local b = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    b:SetSize(92, 22); b:SetPoint("TOPLEFT", 40 + (i - 1) * 96, -8)
    b:SetText(t[2]); b:SetNormalFontObject("GameFontNormalSmall")
    b:SetScript("OnClick", function() view.rtab = t[1]; view.lpage = 1; Render() end)
    rtabs[t[1]] = b
end
local pHeadIcon = panel:CreateTexture(nil, "ARTWORK")
pHeadIcon:SetSize(34, 34); pHeadIcon:SetPoint("TOPLEFT", 10, -36)
pHeadIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
local pHead = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
pHead:SetPoint("LEFT", pHeadIcon, "RIGHT", 10, 0)
local search = CreateFrame("EditBox", nil, panel, "SearchBoxTemplate")
search:SetSize(140, 20); search:SetPoint("TOPLEFT", 18, -138)
search:SetScript("OnTextChanged", function(self)
    SearchBoxTemplate_OnTextChanged(self)
    view.search = (self:GetText() or ""):lower(); view.lpage = 1; Render()
end)
local filterBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
filterBtn:SetSize(70, 20); filterBtn:SetPoint("LEFT", search, "RIGHT", 6, 0); filterBtn:SetText("Filter")
filterBtn:SetNormalFontObject("GameFontNormalSmall")
local filterMine = false
filterBtn:SetScript("OnClick", function() filterMine = not filterMine; filterBtn:SetText(filterMine and "My level" or "Filter"); view.lpage = 1; Render() end)


-- ---------------------------------------------------------------- primary stat (Strength / Agility / Intellect / Spirit)
-- server: PSTAT;n (1-4) chooses, answered with PSTAT;n (primary_stat.lua). One of four hidden auras with a bonus that grows with the level.
local PSTATS = {
    {"Strength", 136101, "Focuses on heavy hits.", "Grants bonus Strength that grows with your level, a little Parry and +4% physical damage."},
    {"Agility", 132307, "Focuses on fast strikes and critical hits.", "Grants bonus Agility that grows with your level and +2% critical strike chance."},
    {"Intellect", 135932, "Focuses on spell damage.", "Grants bonus Intellect, extra Spell Power that grows with your level and +6% casting speed."},
    {"Spirit", 135920, "Focuses on healing.", "Grants bonus Spirit, extra Healing Power that grows with your level and +2% spell critical strike chance."},
}
local pstatHead = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
pstatHead:SetPoint("TOP", panel, "TOP", 0, -78); pstatHead:SetText("Choose a Primary Stat")
local pstatBtns = {}
for i, ps in ipairs(PSTATS) do
    local b = CreateFrame("Button", nil, panel)
    b:SetSize(38, 38); b:SetPoint("TOPLEFT", panel, "TOPLEFT", 20 + (i - 1) * 52, -94)
    b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetAllPoints(); b.icon:SetTexture(ps[2]); b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    b.frame = b:CreateTexture(nil, "OVERLAY"); b.frame:SetAtlas("UI-HUD-ActionBar-IconFrame"); b.frame:SetPoint("TOPLEFT", -3, 3); b.frame:SetPoint("BOTTOMRIGHT", 3, -3)
    b.sel = b:CreateTexture(nil, "OVERLAY", nil, 2); b.sel:SetAtlas("search-highlight"); b.sel:SetBlendMode("ADD")
    b.sel:SetPoint("TOPLEFT", -9, 9); b.sel:SetPoint("BOTTOMRIGHT", 9, -9); b.sel:Hide()
    b:SetHighlightAtlas("UI-HUD-ActionBar-IconFrame-Mouseover", "ADD")
    b:SetScript("OnClick", function() Send("PSTAT;" .. i); PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN) end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
        GameTooltip:AddLine("Primary Stat: " .. ps[1], 1, 1, 1)
        GameTooltip:AddLine(ps[3], 1, 0.82, 0, true)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(ps[4], 1, 0.82, 0, true)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(i == data.pstat and "Chosen. Click another one to change it." or "Click to choose.", 0.3, 1, 0.3)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", GameTooltip_Hide)
    pstatBtns[i] = b
end
function WildcardRefreshPrimaryStat()
    for i, b in ipairs(pstatBtns) do
        local on = data.pstat == i
        b.sel:SetShown(on)
        b.icon:SetDesaturated(data.pstat ~= nil and data.pstat > 0 and not on)
    end
end

local lrows = {}
for i = 1, LIST_ROWS do
    local r = CreateFrame("Button", nil, panel)
    r:SetSize(214, 38)
    r:SetPoint("TOPLEFT", 8, -164 - (i - 1) * 39)
    r:RegisterForClicks("LeftButtonUp")
    r.bg = r:CreateTexture(nil, "BACKGROUND"); r.bg:SetAllPoints(); r.bg:SetColorTexture(1, 1, 1, i % 2 == 0 and 0.05 or 0.02)
    r.icon = r:CreateTexture(nil, "ARTWORK"); r.icon:SetSize(30, 30); r.icon:SetPoint("LEFT", 4, 0)
    r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    r.ring = r:CreateTexture(nil, "OVERLAY"); r.ring:SetAtlas("UI-HUD-ActionBar-IconFrame")
    r.ring:SetSize(44, 44); r.ring:SetPoint("CENTER", r.icon, "CENTER")
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormal"); r.name:SetPoint("LEFT", r.icon, "RIGHT", 8, 0)
    r.name:SetWidth(112); r.name:SetJustifyH("LEFT"); r.name:SetWordWrap(false)
    r.lock = r:CreateTexture(nil, "OVERLAY"); r.lock:SetSize(16, 16); r.lock:SetPoint("RIGHT", -34, 0)
    r.lock:SetAtlas("QuestSharing-Padlock")
    r.cost = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); r.cost:SetPoint("RIGHT", -8, 0)
    r:SetHighlightAtlas("search-highlight", "ADD")
    r:SetScript("OnEnter", function(self)
        if not self.spellId then return end
        GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetSpellByID(self.spellId)
        if self.hint then GameTooltip:AddLine(" "); GameTooltip:AddLine(self.hint, 0.2, 1, 0.2, true) end
        if self.warn then GameTooltip:AddLine(self.warn, 1, 0.3, 0.3, true) end
        GameTooltip:Show()
    end)
    r:SetScript("OnLeave", GameTooltip_Hide)
    lrows[i] = r
end
local lprev, lnext = Arrow(panel, "Prev"), Arrow(panel, "Next")
lprev:SetPoint("BOTTOMLEFT", 10, 34); lnext:SetPoint("BOTTOMRIGHT", -10, 34)
local lpageText = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal"); lpageText:SetPoint("BOTTOM", 0, 40)
local counters = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); counters:SetPoint("BOTTOM", 0, 10)

-- ---------------------------------------------------------------- bottom: Rapid Rolling, orb, tabs

local function RedButton(parent, w, text)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(140, 24); b:SetText(text)   -- every button of these windows has the same size
    b:SetNormalFontObject("GameFontHighlight")
    return b
end
local rollBtn = RedButton(f, 190, "Rapid Rolling")
local mysRollBtn = RedButton(f, 190, "Roll (3 Runes)"); mysRollBtn:Hide()
rollBtn:SetPoint("BOTTOM", f, "BOTTOM", -60, 14)
mysRollBtn:SetPoint("BOTTOM", f, "BOTTOM", -60, 14)
local helpBtn = RedButton(f, 80, "Help"); helpBtn:SetPoint("BOTTOMLEFT", 160, 14)
local respecBtn = RedButton(f, 100, "Respec"); respecBtn:SetPoint("BOTTOMRIGHT", -298, 14)
local tresetBtn = RedButton(f, 120, "Reset Talents"); tresetBtn:SetPoint("BOTTOMRIGHT", -150, 14)
local refreshBtn = RedButton(f, 80, "Refresh"); refreshBtn:SetPoint("BOTTOMRIGHT", -446, 14)

-- the Ability Essence (or Rerolls) counter, bottom left: plain Blizzard text, no art
local orb = CreateFrame("Frame", nil, f)
orb:SetSize(140, 44); orb:SetPoint("BOTTOMLEFT", 14, 10)
orb.label = orb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); orb.label:SetPoint("TOPLEFT", 0, 0); orb.label:SetTextColor(1, 0.82, 0)
orb.count = orb:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge"); orb.count:SetPoint("TOPLEFT", orb.label, "BOTTOMLEFT", 0, -2)

-- the three Hero windows share one tab bar (UI.lua); this is the switcher both windows call
local Tabs = WildcardTabs(f, 1)
function WildcardSwitchTab(i)
    PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
    if i == 4 then
        f:Hide()
        if WildcardMysticCodexHide then WildcardMysticCodexHide() end
        if WildcardGuideShow then WildcardGuideShow() end
        return
    end
    if WildcardGuideHide then WildcardGuideHide() end
    if i == 2 then
        f:Hide()
        if WildcardMysticCodexShow then WildcardMysticCodexShow() elseif WildcardMysticCodexToggle then WildcardMysticCodexToggle() end
        return
    end
    if WildcardMysticCodexHide then WildcardMysticCodexHide() end
    view.mode = (i == 3) and "cards" or "ca"; view.page, view.lpage = 1, 1
    f:Show()
    Render()
end

-- help overlay
local help = CreateFrame("Frame", nil, f, "BackdropTemplate")
help:SetPoint("TOPLEFT", 260, -170); help:SetPoint("BOTTOMRIGHT", -260, 90)
help:SetFrameLevel(f:GetFrameLevel() + 20)
WildcardSkin(help, 0.97)
help:EnableMouse(true); help:Hide()
help.text = help:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
help.text:SetPoint("TOPLEFT", 30, -30); help.text:SetPoint("BOTTOMRIGHT", -30, 60)
help.text:SetJustifyH("LEFT"); help.text:SetJustifyV("TOP"); help.text:SetSpacing(4)
help.text:SetText(table.concat({
    "|cffffd100Character Advancement|r  (key: |cffffffffN|r)",
    " ",
    "|cff00ccffClassless|r: click an ability to learn it with Ability Essence (Common 1, Uncommon 2, Rare 3, Epic 5). Click a learned one to unlearn it for a full refund.",
    "|cffff8000Wildcard|r: the Dice of Destiny rolls your abilities. Rapid Rolling opens the roll.",
    "|cffc41e3aConquest|r: your class kit is learned as you level.",
    " ",
    "|cffffd100Talents|r (right page): one Talent Essence per level from 10. Left-click learns, right-click removes.",
    "The class banners on the left choose whose spells and talents you see. Summary shows only what you own.",
    "|cffa335eeMystic Enchants|r: scrolls found in the world. One more slot every 10 levels.",
}, "\n"))
local helpClose = RedButton(help, 100, "Close"); helpClose:SetPoint("BOTTOM", 0, 20)
helpClose:SetScript("OnClick", function() help:Hide() end)

-- ---------------------------------------------------------------- Skill Cards (your starter abilities as cards)

local cardsF = CreateFrame("Frame", nil, f, "BackdropTemplate")
cardsF:SetPoint("TOPLEFT", 8, -64); cardsF:SetPoint("BOTTOMRIGHT", -8, 62)   -- the whole window while the Skill Cards tab is open
WildcardSkin(cardsF, 0.95)
cardsF:Hide()
-- Descend "Card Packs and Cards" layout: a dark spell-room panel, a progress bar on top, the cards in rows, the pack slots at the bottom
local cardsBg = cardsF:CreateTexture(nil, "BACKGROUND", nil, -5)
cardsBg:SetPoint("TOPLEFT", 4, -4); cardsBg:SetPoint("BOTTOMRIGHT", -4, 4)
cardsBg:SetTexture("Interface/AddOns/Wildcard/art/bg_cards"); cardsBg:SetAlpha(0.8)
local cardsHead = cardsF:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
cardsHead:SetPoint("TOP", 0, -16); cardsHead:SetText("Skill Cards")
local cardsBar = CreateFrame("StatusBar", nil, cardsF)
cardsBar:SetSize(300, 14); cardsBar:SetPoint("TOP", 0, -50)
cardsBar:SetStatusBarTexture("Interface/TargetingFrame/UI-StatusBar"); cardsBar:SetStatusBarColor(0.6, 0.3, 0.9, 1)
cardsBar:SetMinMaxValues(0, 1)
cardsBar.bg = cardsBar:CreateTexture(nil, "BACKGROUND"); cardsBar.bg:SetAllPoints(); cardsBar.bg:SetColorTexture(0, 0, 0, 0.7)
cardsBar.txt = cardsBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); cardsBar.txt:SetPoint("CENTER")
local cardSlots = {}
local CARD_W, CARD_H = 140, 190
for i = 1, 6 do
    local b = CreateFrame("Button", nil, cardsF, "BackdropTemplate")
    b:SetSize(CARD_W, CARD_H)
    b:SetPoint("TOP", cardsF, "TOP", (((i - 1) % 3) - 1) * 200, -100 - math.floor((i - 1) / 3) * 230)
    WildcardSkin(b, 0.95)
    b.frameGlow = b:CreateTexture(nil, "OVERLAY"); b.frameGlow:SetAtlas("search-highlight"); b.frameGlow:SetAllPoints(); b.frameGlow:SetBlendMode("ADD"); b.frameGlow:SetAlpha(0.6)
    b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetSize(64, 64); b.icon:SetPoint("TOP", 0, -26)
    b.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    b.iconFrame = b:CreateTexture(nil, "OVERLAY", nil, 2); b.iconFrame:SetAtlas("UI-HUD-ActionBar-IconFrame-Border")
    b.iconFrame:SetSize(72, 72); b.iconFrame:SetPoint("CENTER", b.icon)
    b.strip = b:CreateTexture(nil, "ARTWORK", nil, 1); b.strip:SetAtlas("bonusobjectives-title-bg")
    b.strip:SetPoint("TOPLEFT", b.icon, "BOTTOMLEFT", -34, -12); b.strip:SetPoint("TOPRIGHT", b.icon, "BOTTOMRIGHT", 34, -12); b.strip:SetHeight(28)
    b.name = b:CreateFontString(nil, "OVERLAY", "GameFontNormal"); b.name:SetPoint("CENTER", b.strip, "CENTER", 0, 0); b.name:SetWidth(CARD_W - 16)
    b.sub = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); b.sub:SetPoint("TOP", b.strip, "BOTTOM", 0, -8); b.sub:SetWidth(CARD_W - 16)
    b.flip = b:CreateAnimationGroup()
    local sc = b.flip:CreateAnimation("Scale"); sc:SetScaleFrom(0.05, 1); sc:SetScaleTo(1, 1); sc:SetDuration(0.28); sc:SetOrigin("CENTER", 0, 0)
    sc:SetStartDelay((i - 1) * 0.12)
    b:SetScript("OnEnter", function(self)
        if not self.spellId then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetSpellByID(self.spellId); GameTooltip:Show()
    end)
    b:SetScript("OnLeave", GameTooltip_Hide)
    cardSlots[i] = b
end
-- pack slots (left: Skill Cards, right: Golden Skill Cards)
local function PackSlot(x, label)
    local s = CreateFrame("Frame", nil, cardsF)
    s:SetSize(44, 44); s:SetPoint("BOTTOMLEFT", x, 22)
    s.ic = s:CreateTexture(nil, "ARTWORK"); s.ic:SetAllPoints(); s.ic:SetTexture(134328); s.ic:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    s.fr = s:CreateTexture(nil, "OVERLAY"); s.fr:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); s.fr:SetAllPoints()
    s.lbl = s:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); s.lbl:SetPoint("BOTTOMLEFT", s, "TOPLEFT", 0, 4); s.lbl:SetText(label)
    return s
end
PackSlot(60, "Skill Cards"); PackSlot(120, "")
local g1 = PackSlot(580, "Golden Skill Cards"); g1.ic:SetVertexColor(1, 0.85, 0.3)
local g2 = PackSlot(640, ""); g2.ic:SetVertexColor(1, 0.85, 0.3)

-- ---------------------------------------------------------------- views

local function Flash(c)
    if c.spellId and data.flash[c.spellId] and GetTime() - data.flash[c.spellId] < 1.5 then
        data.flash[c.spellId] = nil
        c.ag:Stop(); c.ag:Play()
    end
end

local function AbilityList()
    local out = {}
    if view.mode == "mys" then
        for _, e in ipairs(data.mys) do out[#out + 1] = e end
        table.sort(out, function(a, b)
            if a.rar ~= b.rar then return a.rar > b.rar end
            return SpellName(a.id) < SpellName(b.id)
        end)
        return out
    end
    for _, e in ipairs(data.pool) do
        if view.cls == 0 then
            if data.owned[e.id] then out[#out + 1] = e end
        elseif e.cls == view.cls then out[#out + 1] = e end
    end
    table.sort(out, function(a, b)
        local oa, ob = data.owned[a.id] and 0 or 1, data.owned[b.id] and 0 or 1
        if oa ~= ob then return oa < ob end
        return SpellName(a.id) < SpellName(b.id)
    end)
    return out
end

local function FillCell(c, e)
    c.hint, c.warn, c.enchantId = nil, nil, nil
    if not e then c:Hide(); c.spellId = nil; return end
    local rr = RAR[e.rar] or RAR[1]
    c.spellId = e.id
    c.icon:SetTexture(SpellIcon(e.id))
    c.name:SetText("|c" .. rr.hex .. SpellName(e.id) .. "|r")
    if e.enchant then
        c.enchantId, c.active = e.enchant, e.active
        c.icon:SetDesaturated(not e.active)
        c.info:SetText("|c" .. rr.hex .. rr.name .. "|r  " .. (e.active and "|cff40ff40Active|r" or "|cff9d9d9dInactive|r"))
        c.own:SetShown(e.active)
        c.hint = e.active and "Click to turn it off." or "Click to turn it on."
        c:Show(); Flash(c)
        return
    end
    local owned = data.owned[e.id]
    c.icon:SetDesaturated(not owned)
    local lv = e.lvl > data.level and ("|cffff5050Lv " .. e.lvl .. "|r") or ("|cffbfbfbfLv " .. e.lvl .. "|r")
    local extra = ""
    if data.path == 1 and not owned then
        local cost = AE_COST[e.rar] or 1
        extra = "  " .. (cost <= data.ae and "|cffffd100" or "|cffff5050") .. cost .. " AE|r"
        if e.lvl > data.level then c.warn = "Requires level " .. e.lvl .. "." else c.hint = "Click to learn." end
    elseif data.path == 1 and owned then
        c.hint = "Click to unlearn (full refund)."
    end
    local ROLE = {o = "|cffe05a2aOffensive|r", d = "|cff3a8ee0Defensive|r", h = "|cff3ac03aHealing|r", u = "|cffb0a040Utility|r", m = "|cff9a5ae0Mobility|r"}
    c.info:SetText(lv .. extra .. ((e.role and ROLE[e.role]) and ("  " .. ROLE[e.role]) or ""))
    c.own:SetShown(owned and true or false)
    c:Show(); Flash(c)
end

-- spell list on the right (spells of the chosen class; Specs lists the talent trees)
local function ListItems()
    local out = {}
    if view.rtab == "specs" then
        for _, t in ipairs(WildcardTrees or {}) do
            if view.cls == 0 or t.class == view.cls then
                out[#out + 1] = {tree = t, name = ClassName(t.class) .. " - " .. t.label}
            end
        end
        return out
    end
    for _, e in ipairs(data.pool) do
        if (view.cls == 0 or e.cls == view.cls) and (not filterMine or e.lvl <= data.level) then
            local n = SpellName(e.id)
            if view.search == "" or n:lower():find(view.search, 1, true) then out[#out + 1] = e end
        end
    end
    table.sort(out, function(a, b) return SpellName(a.id) < SpellName(b.id) end)
    return out
end

local function FillRow(r, e)
    r.hint, r.warn = nil, nil
    if not e then r:Hide(); r.spellId = nil; r.entry = nil; return end
    r.entry = e
    r:Show()
    if e.tree then
        r.spellId = nil
        r.icon:SetTexture(134400); r.name:SetText("|cffffd100" .. e.name .. "|r")
        r.lock:Hide(); r.cost:SetText("")
        return
    end
    local owned = data.owned[e.id]
    r.spellId = e.id
    r.icon:SetTexture(SpellIcon(e.id)); r.icon:SetDesaturated(not owned)
    r.name:SetText("|c" .. (LISTHEX[e.rar] or LISTHEX[1]) .. SpellName(e.id) .. "|r")
    r.lock:SetShown(not owned)
    r.lock:SetVertexColor(e.lvl > data.level and 1 or 0.8, e.lvl > data.level and 0.3 or 0.7, e.lvl > data.level and 0.3 or 0.2)
    local cost = AE_COST[e.rar] or 1
    r.cost:SetText(owned and "|cff00ff00ok|r" or ("|cffffffff" .. cost .. "|r"))
    if data.path == 1 and not owned then
        if e.lvl > data.level then r.warn = "Requires level " .. e.lvl .. "." else r.hint = "Click to learn." end
    elseif data.path == 1 then r.hint = "Click to unlearn (full refund)." end
end

local function TreesFor(cls)
    local out = {}
    for _, t in ipairs(WildcardTrees or {}) do
        if t.class == cls then out[#out + 1] = {label = t.label, nodes = t.nodes, cols = t.cols, rows = t.rows} end
    end
    local gen, col = {}, 0
    for _, c in ipairs(data.chains) do
        if c.cls == 0 and #c.ranks > 1 then
            col = col + 1
            for r, e in ipairs(c.ranks) do gen[#gen + 1] = {e.id, col - 1, r - 1} end
        end
    end
    if #gen > 0 then out[#out + 1] = {label = "Hero", nodes = gen, cols = col, rows = 3} end
    return out
end

local function FillNode(n, id)
    n.hint, n.warn = nil, nil
    local c = data.chainByFirst[id]
    if not c then n:Hide(); n.spellId = nil; n.chain = nil; return false end
    local have, max = Owned(c), #c.ranks
    local nextE = c.ranks[math.min(have + 1, max)]
    n.chain = c
    n.spellId = nextE.id
    n.icon:SetTexture(SpellIcon(c.ranks[1].id))
    n.icon:SetDesaturated(have == 0)
    n.rank:SetText(max > 1 and (have .. "/" .. max) or (have > 0 and "1/1" or ""))
    n.own:SetShown(have > 0)
    if have == 0 and nextE.lvl > data.level then n.icon:SetVertexColor(0.6, 0.35, 0.35) else n.icon:SetVertexColor(1, 1, 1) end
    if data.path == 1 or data.path == 3 then
        if have < max then n.hint = "Left-click: learn" .. (max > 1 and (" rank " .. (have + 1)) or "") .. " (1 Talent Essence)." end
        n.hint = (n.hint and n.hint .. "\n" or "") .. "Right-click: menu (" .. (have < max and "Learn" or "") .. (have < max and have > 0 and " / " or "") .. (have > 0 and "Unlearn" or "") .. ")."
    end
    if have < max and nextE.lvl > data.level then n.warn = "Requires level " .. nextE.lvl .. "." end
    if nextE.req and have < max then
        local ok = false
        for _, rq in ipairs(nextE.req) do if data.owned[rq] then ok = true end end
        if not ok then n.warn = "Requires the ability " .. SpellName(nextE.req[1]) .. "." end
    end
    n:Show()
    if data.flash[n.spellId] and GetTime() - data.flash[n.spellId] < 1.5 then
        data.flash[n.spellId] = nil; n.ag:Stop(); n.ag:Play()
    end
    return true
end

function Render()
    if not f:IsShown() then return end
    local mys = view.mode == "mys"
    mysRollBtn:SetShown(mys)
    rollBtn:SetShown(not mys)
    mysRollBtn:SetText("Roll (" .. (data.runes or 0) .. " runes)")
    local cardsMode = view.mode == "cards"
    left:SetShown(not cardsMode); right:SetShown(not cardsMode); cardsF:SetShown(cardsMode)
    panel:SetShown(not cardsMode); listInset:SetShown(not cardsMode)
    for _, cb in ipairs(classBtns) do cb:SetShown(not cardsMode) end
    if cardsMode then
        title:SetText("Skill Cards"); info:SetText("Level " .. data.level)
        local got = 0
        for i, b in ipairs(cardSlots) do
            local id = data.build[i]
            b.spellId = id
            if id then
                got = got + 1
                local first = not b.shown
                b.shown = true
                b.icon:SetTexture(SpellIcon(id)); b.icon:Show(); b.icon:SetDesaturated(false); b.name:SetText(SpellName(id)); b.sub:SetText("")
                b.strip:SetVertexColor(1, 0.85, 0.4); b.frameGlow:Show()
                if first then b.flip:Stop(); b.flip:Play() end
            else
                b.shown = false
                b.icon:SetTexture(134400); b.icon:SetDesaturated(true); b.name:SetText("|cff888888Empty|r"); b.sub:SetText("Unlocks at level " .. (i * 2 + 4) .. "+")
                b.strip:SetVertexColor(0.5, 0.5, 0.5); b.frameGlow:Hide()
            end
        end
        cardsBar:SetValue(got / 6); cardsBar.txt:SetText(math.floor(got / 6 * 100) .. "%")
    end
    local pname = PATH_NAME[data.path]
    title:SetText(cardsMode and "Skill Cards" or (mys and "Mystic Enchants" or ("Character Advancement" .. (pname and (" - " .. pname) or ""))))
    info:SetText("Level " .. data.level .. (data.path == 2 and ("   Rerolls: " .. (data.rerolls >= 99 and "free" or data.rerolls)) or ""))

    -- banners
    local perClass = {}
    for _, e in ipairs(data.pool) do if data.owned[e.id] then perClass[e.cls] = (perClass[e.cls] or 0) + 1 end end
    for _, c in ipairs(data.chains) do if Owned(c) > 0 then perClass[c.cls] = (perClass[c.cls] or 0) + 1 end end
    for _, b in ipairs(classBtns) do
        local sel = view.cls == b.cls
        b.sel:SetShown(sel)
        b.badge:SetText(b.cls ~= 0 and perClass[b.cls] and ("|cffffd100" .. perClass[b.cls] .. "|r") or "")
    end

    -- left page: Ability Essence (or Collection in Mystic mode)
    left.head:SetText(mys and "Collection" or ("Ability Essence: |cff" .. (data.ae > 0 and "40ff40" or "9d9d9d") .. data.ae .. "|r"))
    if view.cls == 0 or mys then
        classBadge.tex:SetTexture(133741); classBadge.name:SetText("Hero")
    else
        SetClassIcon(classBadge.tex, view.cls); classBadge.name:SetText(ClassName(view.cls))
    end
    for i, b in ipairs(starters) do
        local id = data.build[i]
        if id and not mys then
            b.spellId = id; b.icon:SetTexture(SpellIcon(id)); b:Show()
        else b.spellId = nil; b:Hide() end
    end
    local list = AbilityList()
    local pages = math.max(1, math.ceil(#list / PER_PAGE))
    view.page = math.min(math.max(1, view.page), pages)
    for i = 1, PER_PAGE do FillCell(cells[i], list[(view.page - 1) * PER_PAGE + i]) end
    pageText:SetText(view.page .. " / " .. pages)
    prev:SetEnabled(view.page > 1); nxt:SetEnabled(view.page < pages)

    -- right page: Talent Essence (or active enchants)
    for _, n in ipairs(nodes) do n:Hide() end
    emptyText:SetText("")
    for _, b in ipairs(treeTabs) do b:Hide() end
    if mys then
        rightEss:SetText("Active: " .. data.mused .. " / " .. data.mslots)
        local act = {}
        for _, e in ipairs(data.mys) do if e.active then act[#act + 1] = e end end
        emptyText:SetText(#act == 0 and "No enchant is active.\nClick an enchant in the collection." or "")
    else
        rightEss:SetText("Talent Essence: |cff" .. (data.te > 0 and "c77dff" or "9d9d9d") .. data.te .. "|r")
        local trees = view.cls == 0 and {} or TreesFor(view.cls)
        view.tab = math.min(math.max(1, view.tab), math.max(1, #trees))
        for i, b in ipairs(treeTabs) do
            local t = trees[i]
            b:SetShown(t ~= nil)
            if t then b:SetText(t.label == "Class" and (ClassName(view.cls)) or t.label); b:SetEnabled(i ~= view.tab) end
        end
        local t = trees[view.tab]
        if view.cls == 0 then
            emptyText:SetText("Choose a class on the left\nto see its talents.")
        elseif not t then
            emptyText:SetText("No talents here yet.")
        else
            -- the retail layout is a sparse 20-column canvas that makes icons tiny and overlapping; lay the same talents out as a compact, readable grid (retail order: top to bottom, left to right)
            for _, hn in ipairs(nodes) do hn:Hide() end
            local ordered = {}
            for _, nd in ipairs(t.nodes) do ordered[#ordered + 1] = nd end
            table.sort(ordered, function(a, b) if a[3] ~= b[3] then return a[3] < b[3] end return a[2] < b[2] end)
            local perRow = 7
            local step, size = 52, 44
            local ox = (392 - step * perRow) / 2 + (step - size) / 2
            local k = 0
            for idx, nd in ipairs(ordered) do
                k = k + 1
                local n = nodes[k]
                if not n then break end
                n:SetSize(size, size)
                n:ClearAllPoints()
                n:SetPoint("TOPLEFT", ox + ((idx - 1) % perRow) * step, -90 - math.floor((idx - 1) / perRow) * step)
                FillNode(n, nd[1])
            end
        end
    end

    -- spell list panel
    rtabs.spells:SetEnabled(view.rtab ~= "spells"); rtabs.specs:SetEnabled(view.rtab ~= "specs")
    if view.cls == 0 then
        pHeadIcon:SetTexture(133741); pHead:SetText("Your build")
    else
        SetClassIcon(pHeadIcon, view.cls); pHead:SetText(ClassName(view.cls))
    end
    local items = ListItems()
    local lp = math.max(1, math.ceil(#items / LIST_ROWS))
    view.lpage = math.min(math.max(1, view.lpage), lp)
    for i = 1, LIST_ROWS do FillRow(lrows[i], items[(view.lpage - 1) * LIST_ROWS + i]) end
    lpageText:SetText(view.lpage .. " / " .. lp)
    lprev:SetEnabled(view.lpage > 1); lnext:SetEnabled(view.lpage < lp)
    counters:SetText("|cff00ff00" .. data.ae .. "|r Ability Essence    |cffb048f8" .. data.te .. "|r Talent Essence")

    -- bottom
    WildcardSelectTab(f, view.mode == "cards" and 3 or 1)
    rollBtn:SetShown(data.path == 2 and not mys)
    respecBtn:SetShown(data.path == 1 and not mys)
    tresetBtn:SetShown((data.path == 1 or data.path == 3) and not mys)
    orb.label:SetText(data.path == 2 and "REROLLS" or "ABILITY ESSENCE")
    orb.count:SetText(data.path == 2 and (data.rerolls >= 99 and "inf" or tostring(data.rerolls)) or tostring(data.ae))
end

-- ---------------------------------------------------------------- clicks

local function ClickAbility(c)
    if not c.spellId then return end
    if c.enchantId then Send((c.active and "MOFF;" or "MON;") .. c.enchantId) return end
    if data.path == 2 and data.owned[c.spellId] then
        Confirm("WILDCARD_FORGET", "Forget " .. SpellName(c.spellId) .. " and roll a new ability in its place? (Costs one reroll after level 10.)",
            function() Send("FORGET;" .. c.spellId) end)
        return
    end
    if data.path ~= 1 then return end
    if data.owned[c.spellId] then
        Confirm("WILDCARD_UNLEARN", "Unlearn " .. SpellName(c.spellId) .. " and get its Ability Essence back?",
            function() Send("UNLEARN;" .. c.spellId) end)
    else
        Send("LEARN;" .. c.spellId)
    end
end
for _, c in ipairs(cells) do c:SetScript("OnClick", function(self) ClickAbility(self) end) end
for _, r in ipairs(lrows) do
    r:SetScript("OnClick", function(self)
        if self.entry and self.entry.tree then
            for i, t in ipairs(TreesFor(self.entry.tree.class)) do if t.label == self.entry.tree.label then view.tab = i end end
            view.cls = self.entry.tree.class; Render()
        elseif self.spellId then ClickAbility(self) end
    end)
end

local function NodeLearn(c, have) Send("TLEARN;" .. c.ranks[have + 1].id) end
local function NodeUnlearn(c, have)
    Confirm("WILDCARD_TUNLEARN", "Remove " .. SpellName(c.ranks[1].id) .. " and get its Talent Essence back?",
        function() Send("TUNLEARN;" .. c.ranks[have].id) end)
end
for _, n in ipairs(nodes) do
    n:SetScript("OnClick", function(self, button)
        local c = self.chain
        if not c or (data.path ~= 1 and data.path ~= 3) then return end
        local have = Owned(c)
        if button == "RightButton" then
            -- right-click menu as on Descend: Learn (costs Talent Essence) when you do not know it yet, Unlearn when you do
            if MenuUtil and MenuUtil.CreateContextMenu then
                MenuUtil.CreateContextMenu(self, function(_, root)
                    root:CreateTitle(SpellName(c.ranks[1].id))
                    if have < #c.ranks then root:CreateButton(have == 0 and "Learn" or ("Learn rank " .. (have + 1)), function() NodeLearn(c, have) end) end
                    if have > 0 then root:CreateButton("Unlearn", function() NodeUnlearn(c, have) end) end
                    root:CreateButton("Cancel", function() end)
                end)
            elseif have > 0 then NodeUnlearn(c, have)
            else NodeLearn(c, have) end
        elseif have < #c.ranks then
            NodeLearn(c, have)
        end
    end)
end

local function Turn(key, d) return function() view[key] = view[key] + d; PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN); Render() end end
prev:SetScript("OnClick", Turn("page", -1)); nxt:SetScript("OnClick", Turn("page", 1))
lprev:SetScript("OnClick", Turn("lpage", -1)); lnext:SetScript("OnClick", Turn("lpage", 1))
helpBtn:SetScript("OnClick", function() help:SetShown(not help:IsShown()) end)
portrait:SetScript("OnClick", function() help:SetShown(not help:IsShown()) end)
rollBtn:SetScript("OnClick", function() f:Hide(); WildcardShowDice() end)
mysRollBtn:SetScript("OnClick", function() Send("MROLL") end)
refreshBtn:SetScript("OnClick", function() Send("LIST"); Send("MLIST") end)
respecBtn:SetScript("OnClick", function()
    Confirm("WILDCARD_RESPEC", "Unlearn every Classless ability and get all Ability Essence back?", function() Send("RESPEC") end)
end)
tresetBtn:SetScript("OnClick", function()
    Confirm("WILDCARD_TRESPEC", "Unlearn every Hero talent and get all Talent Essence back?", function() Send("TRESPEC") end)
end)

-- ---------------------------------------------------------------- data

local function BuildChains()
    local byId = {}
    for _, e in ipairs(data.tal) do byId[e.id] = e end
    local hasNext = {}
    for _, e in ipairs(data.tal) do if e.prev and e.prev ~= 0 then hasNext[e.prev] = e end end
    local chains, trees, seen = {}, {}, {}
    for _, e in ipairs(data.tal) do
        if not (e.prev and e.prev ~= 0 and byId[e.prev]) then
            local c = {ranks = {e}, cls = e.cls}
            local cur = e
            while hasNext[cur.id] do cur = hasNext[cur.id]; c.ranks[#c.ranks + 1] = cur end
            chains[#chains + 1] = c
            if not seen[c.cls] then seen[c.cls] = true; trees[#trees + 1] = c.cls end
        end
    end
    table.sort(trees, function(a, b)
        if a == 0 or b == 0 then return b == 0 and a ~= 0 end
        return a < b
    end)
    data.chains, data.trees = chains, trees
    data.chainByFirst = {}
    for _, c in ipairs(chains) do data.chainByFirst[c.ranks[1].id] = c end
end

local pendingRender = false
local function SoonRender()
    if pendingRender then return end
    pendingRender = true
    C_Timer.After(0.05, function() pendingRender = false; Render() end)
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    -- the server sends "WCARD<tab>message" (Eluna on retail keeps the old 3.3.5 format)
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    local kind, a, b, c, d = strsplit(";", msg)
    if kind == "POOL" then
        if a == "1" then data.pool = {} end
        for id, lvl, rar, cls, role in string.gmatch(b or "", "(%d+):(%d+):(%d+):(%d+):(%a)") do
            data.pool[#data.pool + 1] = {id = tonumber(id), lvl = tonumber(lvl), rar = tonumber(rar), cls = tonumber(cls), role = role}
        end
    elseif kind == "TAL" then
        if a == "1" then data.tal = {} end
        for id, lvl, rar, prev, req, cls in string.gmatch(b or "", "(%d+):(%d+):(%d+):(%d+):([%d/]*):(%d+)") do
            local e = {id = tonumber(id), lvl = tonumber(lvl), rar = tonumber(rar), prev = tonumber(prev), cls = tonumber(cls)}
            if req ~= "" then
                e.req = {}
                for r in string.gmatch(req, "(%d+)") do e.req[#e.req + 1] = tonumber(r) end
            end
            data.tal[#data.tal + 1] = e
        end
    elseif kind == "BUILD" or kind == "TBUILD" then
        local set = kind == "BUILD" and data.newOwned or data.newTowned
        for id in string.gmatch(a or "", "(%d+)") do set[tonumber(id)] = true end
    elseif kind == "STATE" then
        -- STATE closes a LIST answer: swap in the new build and flash what is new
        local _, lvl, rer, pend, _, path, ae, aeTotal, te, teTotal = strsplit(";", msg)
        data.level, data.rerolls, data.pending = tonumber(lvl) or 1, tonumber(rer) or 0, tonumber(pend) or 0
        data.path, data.ae, data.aeTotal = tonumber(path) or 0, tonumber(ae) or 0, tonumber(aeTotal) or 0
        data.te, data.teTotal = tonumber(te) or 0, tonumber(teTotal) or 0
        local now = GetTime()
        if data.loaded then
            for id in pairs(data.newOwned) do if not data.owned[id] then data.flash[id] = now end end
            for id in pairs(data.newTowned) do if not data.towned[id] then data.flash[id] = now end end
        end
        data.owned, data.towned = data.newOwned, data.newTowned
        data.newOwned, data.newTowned = {}, {}
        data.build = {}
        for _, e in ipairs(data.pool) do if data.owned[e.id] then data.build[#data.build + 1] = e.id end end
        table.sort(data.build, function(x, y) return SpellName(x) < SpellName(y) end)
        BuildChains()
        data.loaded = true
        -- tell the server about spells this client cannot show (they are never rolled again)
        if not data.badSent and #data.pool > 0 then
            data.badSent = true
            local bad = {}
            for _, e in ipairs(data.pool) do if not C_Spell.GetSpellInfo(e.id) then bad[#bad + 1] = e.id end end
            for _, e in ipairs(data.tal) do if not C_Spell.GetSpellInfo(e.id) then bad[#bad + 1] = e.id end end
            for i = 1, #bad, 20 do Send("BAD;" .. table.concat(bad, ",", i, math.min(i + 19, #bad))) end
        end
        if data.path == 0 and f:IsShown() and WildcardPathFrame then f:Hide(); WildcardPathFrame:Show() return end
        SoonRender()
    elseif kind == "MYS" then
        if a == "1" then data.mysNew = {} end
        data.mysNew = data.mysNew or {}
        for id, spell, q, act in string.gmatch(b or "", "(%d+):(%d+):(%d+):(%d)") do
            data.mysNew[#data.mysNew + 1] = {id = tonumber(spell), enchant = tonumber(id), rar = tonumber(q), lvl = 0, active = act == "1"}
        end
    elseif kind == "MRUNES" then
        data.runes = tonumber(a) or 0; SoonRender()
    elseif kind == "MSTATE" then
        local old = {}
        for _, e in ipairs(data.mys) do if e.active then old[e.enchant] = true end end
        data.mys = data.mysNew or data.mys
        data.mysNew = nil
        for _, e in ipairs(data.mys) do if e.active and not old[e.enchant] and data.mysLoaded then data.flash[e.id] = GetTime() end end
        data.mysLoaded = true
        data.mslots, data.mused, data.mleg, data.mepic = tonumber(a) or 0, tonumber(b) or 0, tonumber(c) or 0, tonumber(d) or 0
        SoonRender()
    elseif kind == "MCHANGED" then
        if f:IsShown() then Send("MLIST") end
    elseif kind == "ERR" then
        UIErrorsFrame:AddMessage(a or "", 1, 0.2, 0.2)
        PlaySound(SOUNDKIT.IG_QUEST_LOG_ABANDON_QUEST or 846)
    elseif kind == "PSTAT" then
        data.pstat = tonumber(a) or 0
        WildcardRefreshPrimaryStat()
    elseif kind == "LEARNED" then
        PlaySound(SOUNDKIT.IG_QUEST_LIST_COMPLETE)
        if f:IsShown() then Send("LIST") end
    elseif kind == "NONE" then
        if f:IsShown() then Send("LIST") end
    elseif kind == "OPEN" then
        if a == "dice" then WildcardShowDice() return end
        if a == "mystic" and WildcardMysticCodexToggle then return end   -- the Mystic Codex window opens itself
        view.mode = (a == "mystic") and "mys" or "ca"
        if f:IsShown() then Send("LIST"); Send("MLIST"); Render() else f:Show() end
    end
end)
data.newOwned, data.newTowned = {}, {}

f:SetScript("OnShow", function()
    openAG:Stop(); openAG:Play()
    PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN)
    Send("LIST"); Send("MLIST"); Send("PSTAT;0")
    Render()
end)
f:SetScript("OnHide", function() PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE); help:Hide() end)

-- N key (Bindings.xml) and the slash commands
function WildcardCA_Toggle()
    view.mode = "ca"
    f:SetShown(not f:IsShown())
end
BINDING_HEADER_WILDCARD = "Draconic Hero"
BINDING_NAME_WILDCARD_TOGGLE = "Character Advancement"

local binder = CreateFrame("Frame")
binder:RegisterEvent("PLAYER_LOGIN")
binder:RegisterEvent("PLAYER_REGEN_ENABLED")
binder:SetScript("OnEvent", function(self)
    if InCombatLockdown() or self.done then return end
    -- like Descend, N opens Character Advancement (Heroes have no use for the default talent window)
    SetOverrideBinding(self, true, "N", "WILDCARD_TOGGLE")
    self.done = true
end)

SLASH_WILDCARDCA1 = "/ca"
SLASH_WILDCARDCA2 = "/advancement"
SlashCmdList["WILDCARDCA"] = WildcardCA_Toggle
