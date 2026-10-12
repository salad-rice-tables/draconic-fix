-- Mystic Enchants window (Descend style): ring of Active Enchants on the left (Legendary / Artifact in the middle, Epic on the inner ring,
-- Rare on the outer ring), tabs "Enchant Collection" (the whole catalogue, found ones bright) and "Enchant Scrolls" (scrolls in your bags) on the right.
-- Data: MysticData.lua (catalogue), server MYS / MSTATE / MRUNES / MCHANGED. /mystic opens it, the server opens it with OPEN;mystic.
local PREFIX = "WCARD"
local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, msg, "WHISPER", UnitName("player")) end

local QCOL = {[3] = {0.0, 0.44, 0.87}, [4] = {0.64, 0.21, 0.93}, [5] = {1.0, 0.5, 0.0}, [6] = {0.9, 0.8, 0.5}}
local QNAME = {[3] = "Rare", [4] = "Epic", [5] = "Legendary", [6] = "Artifact"}
local CLASSES = {"all", "warrior", "paladin", "hunter", "rogue", "priest", "shaman", "mage", "warlock", "druid"}
local RARITIES = {0, 3, 4, 5, 6}   -- 0 = all
local SCROLL_FIRST, SCROLL_LAST, SCROLL_GENERIC = 9740001, 9743000, 9730031
local state = {owned = {}, active = {}, classIdx = 1, rarIdx = 1, ownedOnly = false, text = "", runes = 0, slots = 0, used = 0, page = 1, tab = "collection"}
do
    local _, token = UnitClass("player")
    token = token and string.lower(token) or ""
    for i, c in ipairs(CLASSES) do if c == token then state.classIdx = i end end
end
state.staged = {}
local function Active(id)
    local v = state.staged[id]
    if v ~= nil then return v end
    return state.active[id] and true or false
end
local function Dirty() for _ in pairs(state.staged) do return true end return false end
local RenderAll
local BYID = {}
for _, e in ipairs(WildcardMysticData or {}) do BYID[e[1]] = e end

-- Blizzard's ButtonFrameTemplate window (UI.lua), with the shared tab bar of the Hero windows
local f = WildcardMakeWindow("WildcardMysticCodex", 1080, 680, "Mystic Enchants", 134414)
f:SetPoint("CENTER")
f:SetFrameStrata("HIGH")
WildcardTabs(f, 2)
function WildcardMysticCodexShow() f:Show() end
function WildcardMysticCodexHide() f:Hide() end

local function Btn(parent, text, w, h)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(130, 24); b:SetText(text); return b
end
local function Panel(parent, x, y, w, h)
    local p = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    p:SetPoint("TOPLEFT", x, y); p:SetSize(w, h)
    WildcardSkin(p, 0.8)
    return p
end
local MASK = "Interface\\CharacterFrame\\TempPortraitAlphaMask"

-- a round enchant icon with a rarity ring (used by the wheel and by the list)
local function RoundIcon(parent, size)
    local b = CreateFrame("Button", nil, parent)
    b:SetSize(size, size)
    b.ring = b:CreateTexture(nil, "BACKGROUND"); b.ring:SetPoint("CENTER"); b.ring:SetSize(size, size)
    b.ring:SetTexture("Interface\\Buttons\\WHITE8x8"); b.ring:SetMask(MASK)
    b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetPoint("CENTER"); b.icon:SetSize(size - 6, size - 6); b.icon:SetMask(MASK)
    b.glow = b:CreateTexture(nil, "OVERLAY"); b.glow:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); b.glow:SetBlendMode("ADD")
    b.glow:SetPoint("CENTER"); b.glow:SetSize(size * 1.7, size * 1.7); b.glow:Hide()
    return b
end
local function Paint(b, e, owned, active)
    local c = QCOL[e[3]] or QCOL[3]
    b.ring:SetVertexColor(c[1], c[2], c[3], owned and 1 or 0.45)
    local tex = C_Spell.GetSpellTexture(e[2])
    b.icon:SetTexture(tex or 134400)
    b.icon:SetDesaturated(not owned); b.icon:SetAlpha(owned and 1 or 0.45)
    b.glow:SetShown(active and true or false); b.glow:SetVertexColor(c[1], c[2], c[3])
end
local HOW = {
    [3] = "How to acquire: Mystic Scrolls from creatures and chests, or the Mystic Forge.",
    [4] = "How to acquire: Mystic Scrolls dropped by dungeon bosses and mini-bosses, or the Mystic Forge.",
    [5] = "How to acquire: Mystic Scrolls dropped by bosses and mini-bosses only. Worldforged: found in the world, never sold.",
    [6] = "How to acquire: Mystic Scrolls dropped by bosses and mini-bosses only. Worldforged: found in the world, never sold.",
}
local function ShowTip(self)
    local e = self.e
    if not e then return end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetSpellByID(e[2])
    GameTooltip:AddLine(" ")
    local c = QCOL[e[3]] or QCOL[3]
    GameTooltip:AddLine((QNAME[e[3]] or "") .. " Mystic Enchant", c[1], c[2], c[3])
    if Active(e[1]) then GameTooltip:AddLine("Active - click to turn off (then Save Changes)", 0.3, 1, 0.3)
    elseif state.owned[e[1]] then GameTooltip:AddLine("Known - click to turn on (then Save Changes)", 1, 0.82, 0)
    else GameTooltip:AddLine("Not collected", 0.6, 0.6, 0.6) end
    if e[3] >= 5 then GameTooltip:AddLine("Worldforged Mystic Enchant", 0.3, 0.9, 0.9) end
    if e[4] and e[4] ~= "" then GameTooltip:AddLine("Class: " .. e[4], 0.7, 0.7, 0.9) end
    if not state.owned[e[1]] and HOW[e[3]] then GameTooltip:AddLine(HOW[e[3]], 1, 0.82, 0, true) end
    GameTooltip:Show()
end
local function Toggle(self)
    local e = self.e
    if not e or not state.owned[e[1]] then return end
    local id = e[1]
    local want = not Active(id)
    if want == (state.active[id] and true or false) then state.staged[id] = nil else state.staged[id] = want end
    RenderAll()
end

-- ---------------------------------------------------------------- left: Active Enchants wheel
local left = Panel(f, 12, -64, 360, 560)
local lt = left:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); lt:SetPoint("TOP", 0, -12); lt:SetText("ACTIVE ENCHANTS")
local CX, CY = 180, -270
local ringBg = left:CreateTexture(nil, "BACKGROUND"); ringBg:SetPoint("CENTER", left, "TOPLEFT", CX, CY); ringBg:SetSize(330, 330)
ringBg:SetAtlas("CovenantChoice-Offering-Ability-Ring-NightFae"); ringBg:SetDesaturated(true); ringBg:SetVertexColor(0.45, 0.45, 0.8, 0.9)
local ringBg2 = left:CreateTexture(nil, "BACKGROUND", nil, 1); ringBg2:SetPoint("CENTER", left, "TOPLEFT", CX, CY); ringBg2:SetSize(210, 210)
ringBg2:SetTexture("Interface\\Buttons\\WHITE8x8"); ringBg2:SetMask(MASK); ringBg2:SetVertexColor(0.1, 0.07, 0.17, 0.95)
local slotBtns = {}
local function SlotButton(i)
    local b = slotBtns[i]
    if b then return b end
    b = RoundIcon(left, i == 1 and 64 or 48)
    b:SetScript("OnEnter", ShowTip); b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    b:SetScript("OnClick", Toggle)
    slotBtns[i] = b
    return b
end
local function PlaceWheel(layout)   -- layout: list of {x, y, quality}
    for i, p in ipairs(layout) do
        local b = SlotButton(i)
        b:ClearAllPoints(); b:SetPoint("CENTER", left, "TOPLEFT", CX + p[1], CY + p[2]); b.q = p[3]; b:Show()
    end
    for i = #layout + 1, #slotBtns do slotBtns[i]:Hide() end
end
local slotsInfo = left:CreateFontString(nil, "OVERLAY", "GameFontNormal"); slotsInfo:SetPoint("BOTTOM", 0, 84)
local legend = left:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); legend:SetPoint("BOTTOM", 0, 62)
legend:SetText("Middle: Legendary / Artifact   Inner ring: Epic   Outer ring: Rare")
local saveBtn = Btn(left, "Save Changes"); saveBtn:SetPoint("BOTTOM", -22, 20)
local clearBtn = CreateFrame("Button", nil, left)
clearBtn:SetSize(30, 30); clearBtn:SetPoint("LEFT", saveBtn, "RIGHT", 10, 0)
clearBtn:SetNormalTexture("Interface/Buttons/UI-GroupLoot-Pass-Up"); clearBtn:SetPushedTexture("Interface/Buttons/UI-GroupLoot-Pass-Down"); clearBtn:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
clearBtn:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText("Discard unsaved changes"); GameTooltip:Show() end)
clearBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
local function RenderWheel()
    local act = {[3] = {}, [4] = {}, [5] = {}}
    for id in pairs(state.owned) do
        if Active(id) then
        local e = BYID[id]
        if e then local g = (e[3] >= 5) and 5 or e[3]; act[g][#act[g] + 1] = e end
        end
    end
    for _, l in pairs(act) do table.sort(l, function(a, b) return a[5] < b[5] end) end
    local total = math.max(1, state.slots)
    local nEpic = math.min(3, math.max(0, total - 1))
    local nRare = math.max(0, total - 1 - nEpic)
    local layout, groups = {{0, 0, 5}}, {{5, 1}}
    for k = 1, nEpic do local a = math.rad(90 + (k - 1) * 360 / nEpic + (nEpic == 1 and 0 or 0)); layout[#layout + 1] = {math.cos(a) * 66, math.sin(a) * 66, 4} end
    for k = 1, nRare do local a = math.rad(90 + (k - 1) * 360 / nRare); layout[#layout + 1] = {math.cos(a) * 128, math.sin(a) * 128, 3} end
    PlaceWheel(layout)
    local used = {[3] = 0, [4] = 0, [5] = 0}
    for i, p in ipairs(layout) do
        local b = slotBtns[i]
        local g = p[3]
        used[g] = used[g] + 1
        local e = act[g][used[g]]
        b.e = e
        if e then Paint(b, e, true, true)
        else
            local c = QCOL[g]
            b.ring:SetVertexColor(c[1], c[2], c[3], 0.35); b.icon:SetTexture(nil); b.glow:Hide()
        end
    end
    slotsInfo:SetText(string.format("Slots %d / %d      Runes: |cff6fd6ff%d|r", state.used, state.slots, state.runes))
end

-- ---------------------------------------------------------------- right: tabs, filters, list
local right = Panel(f, 380, -64, 688, 560)
local rightArt = right:CreateTexture(nil, "BACKGROUND", nil, -6); rightArt:SetPoint("TOPLEFT", 3, -3); rightArt:SetPoint("BOTTOMRIGHT", -3, 3)
rightArt:SetTexture("Interface/AddOns/Wildcard/art/bg_mystic"); rightArt:SetAlpha(0); rightArt:Hide()
local tabCol = Btn(right, "Enchant Collection"); tabCol:SetPoint("TOPLEFT", 10, -10)
local tabScr = Btn(right, "Enchant Scrolls"); tabScr:SetPoint("LEFT", tabCol, "RIGHT", 4, 0)
local classBtn = Btn(right, "Class"); classBtn:SetPoint("TOPRIGHT", -10, -10)
local rarBtn = Btn(right, "Rarity: All"); rarBtn:SetPoint("RIGHT", classBtn, "LEFT", -4, 0)
local search = CreateFrame("EditBox", nil, right, "InputBoxTemplate")
search:SetSize(190, 24); search:SetPoint("TOPLEFT", 18, -42); search:SetAutoFocus(false)
local ownedBtn = Btn(right, "Known only: off"); ownedBtn:SetPoint("LEFT", search, "RIGHT", 10, 0)
local rollBtn = Btn(right, "Roll (3 runes)"); rollBtn:SetPoint("TOPRIGHT", -10, -42)
local infoTxt = right:CreateFontString(nil, "OVERLAY", "GameFontNormal"); infoTxt:SetPoint("RIGHT", rollBtn, "LEFT", -10, 0)

local COLS, ROWS = 3, 6
local CELLW, CELLH = 216, 70
local cells = {}
local grid = CreateFrame("Frame", nil, right); grid:SetPoint("TOPLEFT", 12, -76); grid:SetSize(COLS * CELLW + 16, ROWS * CELLH)
for i = 1, COLS * ROWS do
    local c = CreateFrame("Button", nil, grid)
    c:SetSize(CELLW - 4, CELLH - 6)
    c:SetPoint("TOPLEFT", ((i - 1) % COLS) * CELLW, -math.floor((i - 1) / COLS) * CELLH)
    c.bg = c:CreateTexture(nil, "BACKGROUND"); c.bg:SetAllPoints(); c.bg:SetColorTexture(0.08, 0.05, 0.14, 0.88)
    c.hl = c:CreateTexture(nil, "HIGHLIGHT"); c.hl:SetAllPoints(); c.hl:SetColorTexture(1, 1, 1, 0.12)
    c.ic = RoundIcon(c, 48); c.ic:SetPoint("LEFT", 6, 0); c.ic:EnableMouse(false)
    c.name = c:CreateFontString(nil, "OVERLAY", "GameFontNormal"); c.name:SetPoint("LEFT", c.ic, "RIGHT", 8, 0); c.name:SetPoint("RIGHT", -4, 0)
    c.name:SetJustifyH("LEFT"); c.name:SetWordWrap(true); c.name:SetMaxLines(2); c.name:SetTextColor(1, 0.95, 0.85)
    c:SetScript("OnEnter", function(self)
        if self.scroll then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetBagItem(self.scroll[1], self.scroll[2]); GameTooltip:Show()
        else ShowTip(self) end
    end)
    c:SetScript("OnLeave", function() GameTooltip:Hide() end)
    c:SetScript("OnClick", function(self)
        if self.scroll then C_Container.UseContainerItem(self.scroll[1], self.scroll[2]) else Toggle(self) end
    end)
    cells[i] = c
end
local prevBtn = Btn(right, "Previous"); prevBtn:SetPoint("BOTTOMRIGHT", right, "BOTTOM", -70, 10)
local nextBtn = Btn(right, "Next"); nextBtn:SetPoint("BOTTOMLEFT", right, "BOTTOM", 70, 10)
local pageTxt = right:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); pageTxt:SetPoint("BOTTOM", 0, 15)
local hintTxt = right:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); hintTxt:SetPoint("BOTTOMLEFT", 14, 42)

local cur = right:CreateFontString(nil, "OVERLAY", "GameFontNormal"); cur:SetPoint("BOTTOMRIGHT", -16, 15)
local PER = COLS * ROWS
local function Matches(e)
    local cls = CLASSES[state.classIdx]
    if cls ~= "all" and not string.find(e[4], cls, 1, true) then return false end
    local r = RARITIES[state.rarIdx]
    if r ~= 0 and e[3] ~= r then return false end
    if state.ownedOnly and not state.owned[e[1]] then return false end
    if state.text ~= "" and not string.find(string.lower(e[5]), state.text, 1, true) then return false end
    return true
end

local function BagScrolls()
    local list = {}
    for bag = 0, 5 do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local id = C_Container.GetContainerItemID(bag, slot)
            if id and ((id >= SCROLL_FIRST and id <= SCROLL_LAST) or id == SCROLL_GENERIC) then list[#list + 1] = {bag, slot, id} end
        end
    end
    return list
end

-- ---------------------------------------------------------------- Enchant Scrolls tab: the altar on the left, the scrolls of your bags on the right
local altar = CreateFrame("Frame", nil, left); altar:SetPoint("TOPLEFT", 4, -4); altar:SetPoint("BOTTOMRIGHT", -4, 4); altar:SetFrameLevel(left:GetFrameLevel() + 5); altar:Hide()
local altBg = altar:CreateTexture(nil, "BACKGROUND"); altBg:SetAllPoints(); altBg:SetTexture("Interface/AddOns/Wildcard/art/bg_altar"); altBg:SetTexCoord(0, 1, 0.08, 0.92)
local altShade = altar:CreateTexture(nil, "BACKGROUND", nil, 1); altShade:SetAllPoints(); altShade:SetColorTexture(0, 0, 0, 0.35)
local altTitle = altar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); altTitle:SetPoint("TOP", 0, -14); altTitle:SetText("MYSTIC ALTAR")
local altRing = altar:CreateTexture(nil, "OVERLAY"); altRing:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); altRing:SetSize(170, 170); altRing:SetPoint("TOP", 0, -70)
local altIcon = altar:CreateTexture(nil, "ARTWORK"); altIcon:SetSize(134, 134); altIcon:SetPoint("CENTER", altRing)
local altMask = altar:CreateMaskTexture(); altMask:SetAllPoints(altIcon); altMask:SetAtlas("UI-HUD-ActionBar-IconFrame-Mask"); altIcon:AddMaskTexture(altMask)
local altGlow = altar:CreateTexture(nil, "OVERLAY", nil, 3); altGlow:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); altGlow:SetBlendMode("ADD")
altGlow:SetSize(260, 260); altGlow:SetPoint("CENTER", altRing)
local glowAG = altGlow:CreateAnimationGroup(); glowAG:SetLooping("BOUNCE")
local ga = glowAG:CreateAnimation("Alpha"); ga:SetFromAlpha(0.25); ga:SetToAlpha(0.9); ga:SetDuration(1.1); glowAG:Play()
local altStand = altar:CreateTexture(nil, "ARTWORK"); altStand:SetAtlas("UI-Achievement-Alert-Glow-glow"); altStand:SetBlendMode("ADD")
altStand:SetSize(300, 90); altStand:SetPoint("TOP", altRing, "BOTTOM", 0, 30); altStand:SetVertexColor(0.5, 0.3, 0.9)
local altName = altar:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); altName:SetPoint("TOP", altRing, "BOTTOM", 0, -26); altName:SetWidth(320)
local altInfo = altar:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); altInfo:SetPoint("TOP", altName, "BOTTOM", 0, -8); altInfo:SetWidth(320)
local reforgeBtn = Btn(altar, "Reforge"); reforgeBtn:SetPoint("BOTTOM", -82, 24)
local saveScrollBtn = Btn(altar, "Save to Collection"); saveScrollBtn:SetPoint("BOTTOM", 82, 24)
local scrollList = CreateFrame("Frame", nil, right); scrollList:SetPoint("TOPLEFT", 12, -76); scrollList:SetSize(664, 480); scrollList:Hide()
local SROWS = 8
local srows = {}
local sel = 1
local bagList = {}
local function SelScroll() return bagList[sel] end
local function UseScroll(it)
    if not it then return end
    C_Container.UseContainerItem(it[1], it[2])
    C_Timer.After(0.6, function() Send("MLIST") end)
end
local function ScrollEnchant(it) return it and BYID[it[3] - 9740000] end
local function RenderScrolls()
    bagList = BagScrolls()
    sel = math.max(1, math.min(sel, math.max(1, #bagList)))
    local cur_it = SelScroll()
    local e = ScrollEnchant(cur_it)
    local c = e and QCOL[e[3]] or {0.6, 0.55, 0.8}
    altRing:SetVertexColor(c[1], c[2], c[3]); altGlow:SetVertexColor(c[1], c[2], c[3])
    if cur_it then
        altIcon:SetTexture(e and C_Spell.GetSpellTexture(e[2]) or C_Item.GetItemIconByID(cur_it[3])); altIcon:SetDesaturated(false)
        local nm = C_Item.GetItemNameByID(cur_it[3]) or "Mystic Scroll"
        altName:SetText(nm); altName:SetTextColor(c[1] * 0.4 + 0.6, c[2] * 0.4 + 0.6, c[3] * 0.4 + 0.6)
        altInfo:SetText(e and ((QNAME[e[3]] or "") .. " Mystic Enchant") or "Mystic Scroll")
    else
        altIcon:SetTexture(134400); altIcon:SetDesaturated(true); altName:SetText("No scrolls"); altName:SetTextColor(0.7, 0.7, 0.7)
        altInfo:SetText("Scrolls drop from bosses and mini-bosses.")
    end
    saveScrollBtn:SetEnabled(cur_it ~= nil)
    for i, r in ipairs(srows) do
        local it = bagList[i]
        if not it then r:Hide() else
            r:Show(); r.it = it
            local en = ScrollEnchant(it)
            local cc = en and QCOL[en[3]] or {0.6, 0.55, 0.8}
            r.icon:SetTexture(en and C_Spell.GetSpellTexture(en[2]) or C_Item.GetItemIconByID(it[3]))
            r.ring:SetVertexColor(cc[1], cc[2], cc[3])
            local nm = C_Item.GetItemNameByID(it[3]) or "Mystic Scroll"
            r.name:SetText(nm); r.name:SetTextColor(1, 0.82, 0)
            r.sel:SetShown(i == sel)
        end
    end
    hintTxt:SetText(#bagList .. " scroll(s) in your bags. Activate learns the enchant and turns it on; Save to Collection only learns it.")
    tabCol:SetEnabled(true); tabScr:SetEnabled(false)
end
for i = 1, SROWS do
    local r = CreateFrame("Button", nil, scrollList)
    r:SetSize(664, 54); r:SetPoint("TOPLEFT", 0, -(i - 1) * 58)
    r.bg = r:CreateTexture(nil, "BACKGROUND"); r.bg:SetAllPoints(); r.bg:SetColorTexture(0.25, 0.1, 0.4, 0.12)
    r.sel = r:CreateTexture(nil, "BORDER"); r.sel:SetAllPoints(); r.sel:SetColorTexture(1, 0.82, 0.2, 0.28)
    r.icon = r:CreateTexture(nil, "ARTWORK"); r.icon:SetSize(38, 38); r.icon:SetPoint("LEFT", 10, 0)
    r.ring = r:CreateTexture(nil, "OVERLAY"); r.ring:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); r.ring:SetSize(46, 46); r.ring:SetPoint("CENTER", r.icon)
    r.name = r:CreateFontString(nil, "OVERLAY", "GameFontNormal"); r.name:SetPoint("LEFT", r.icon, "RIGHT", 12, 0); r.name:SetWidth(280); r.name:SetJustifyH("LEFT")
    r.act = Btn(r, "Activate"); r.act:SetPoint("RIGHT", -160, 0)
    r.save = Btn(r, "Save to Collection"); r.save:SetPoint("RIGHT", -10, 0)
    r.hl = r:CreateTexture(nil, "HIGHLIGHT"); r.hl:SetAllPoints(); r.hl:SetColorTexture(1, 1, 1, 0.08)
    r:SetScript("OnClick", function() sel = i; RenderScrolls() end)
    r:SetScript("OnEnter", function(self) if self.it then GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetBagItem(self.it[1], self.it[2]); GameTooltip:Show() end end)
    r:SetScript("OnLeave", function() GameTooltip:Hide() end)
    r.save:SetScript("OnClick", function() UseScroll(r.it) end)
    r.act:SetScript("OnClick", function()
        local en = ScrollEnchant(r.it)
        UseScroll(r.it)
        if en then C_Timer.After(1.2, function() if state.owned[en[1]] then state.staged[en[1]] = true; RenderAll() end end) end
    end)
    srows[i] = r
end
saveScrollBtn:SetScript("OnClick", function() UseScroll(SelScroll()) end)
reforgeBtn:SetScript("OnClick", function()
    local ff = _G.WildcardMysticForge
    if ff then ff:SetShown(not ff:IsShown()) elseif SlashCmdList.WILDCARDFORGE then SlashCmdList.WILDCARDFORGE() end
end)

local function RenderList()
    local scrollsTab = state.tab == "scrolls"
    altar:SetShown(scrollsTab); scrollList:SetShown(scrollsTab)
    grid:SetShown(not scrollsTab)
    for _, w in ipairs({prevBtn, nextBtn, pageTxt}) do w:SetShown(not scrollsTab) end
    if scrollsTab then RenderScrolls(); return end
    local items = {}
    if state.tab == "collection" then
        for _, e in ipairs(WildcardMysticData or {}) do if Matches(e) then items[#items + 1] = e end end
    else
        items = BagScrolls()
    end
    local pages = math.max(1, math.ceil(#items / PER))
    state.page = math.max(1, math.min(state.page, pages))
    for i, c in ipairs(cells) do
        local it = items[(state.page - 1) * PER + i]
        if not it then c:Hide() else
            c:Show()
            if state.tab == "collection" then
                c.scroll, c.e, c.ic.e = nil, it, it
                local own = state.owned[it[1]]
                Paint(c.ic, it, own, Active(it[1]))
                local col = QCOL[it[3]]
                c.name:SetText(it[5]); c.name:SetTextColor(col[1] * 0.4 + 0.6, col[2] * 0.4 + 0.6, col[3] * 0.4 + 0.6)
                c.name:SetAlpha(own and 1 or 0.55)
                if it[3] >= 5 then c.name:SetText(it[5] .. "|n|cff4de6e6Worldforged|r") end
            else
                c.scroll, c.e = {it[1], it[2]}, nil
                local ename = C_Item.GetItemNameByID(it[3]) or "Mystic Scroll"
                local e = BYID[it[3] - 9740000]
                c.ic.ring:SetVertexColor(e and QCOL[e[3]][1] or 0.6, e and QCOL[e[3]][2] or 0.6, e and QCOL[e[3]][3] or 0.6, 1)
                c.ic.icon:SetTexture(e and C_Spell.GetSpellTexture(e[2]) or C_Item.GetItemIconByID(it[3])); c.ic.icon:SetDesaturated(false); c.ic.icon:SetAlpha(1)
                c.ic.glow:Hide()
                c.name:SetText((ename:gsub("^Mystic Scroll: ", ""))); c.name:SetTextColor(1, 0.82, 0); c.name:SetAlpha(1)
            end
        end
    end
    pageTxt:SetText("Page " .. state.page .. " of " .. pages)
    prevBtn:SetEnabled(state.page > 1); nextBtn:SetEnabled(state.page < pages)
    local tot, found = 0, 0
    for _, e in ipairs(WildcardMysticData or {}) do tot = tot + 1; if state.owned[e[1]] then found = found + 1 end end
    hintTxt:SetText(state.tab == "collection" and (found .. " of " .. tot .. " collected. Click to toggle.") or "Click a scroll to learn its enchant.")
    local cname = CLASSES[state.classIdx]
    classBtn:SetText("Class: " .. (cname == "all" and "All" or cname:gsub("^%l", string.upper)))
    local r = RARITIES[state.rarIdx]
    rarBtn:SetText("Rarity: " .. (r == 0 and "All" or QNAME[r]))
    ownedBtn:SetText("Known only: " .. (state.ownedOnly and "on" or "off"))
    tabCol:SetEnabled(state.tab ~= "collection"); tabScr:SetEnabled(state.tab ~= "scrolls")
    infoTxt:SetText("")
    cur:SetText("Mystic Runes: |cff6fd6ff" .. (state.runes or 0) .. "|r")
end

local function Render() RenderWheel(); RenderList(); saveBtn:SetEnabled(Dirty()); clearBtn:SetShown(Dirty()) end
RenderAll = Render
saveBtn:SetScript("OnClick", function()
    local off, on = {}, {}
    for id, want in pairs(state.staged) do if want then on[#on + 1] = id else off[#off + 1] = id end end
    for _, id in ipairs(off) do Send("MOFF;" .. id) end
    for _, id in ipairs(on) do Send("MON;" .. id) end
    state.staged = {}
    C_Timer.After(0.6, function() Send("MLIST") end)
    Render()
end)
clearBtn:SetScript("OnClick", function() state.staged = {}; Render() end)
tabCol:SetScript("OnClick", function() state.tab = "collection"; state.page = 1; RenderList() end)
tabScr:SetScript("OnClick", function() state.tab = "scrolls"; state.page = 1; RenderList() end)
classBtn:SetScript("OnClick", function() state.classIdx = state.classIdx % #CLASSES + 1; state.page = 1; RenderList() end)
rarBtn:SetScript("OnClick", function() state.rarIdx = state.rarIdx % #RARITIES + 1; state.page = 1; RenderList() end)
ownedBtn:SetScript("OnClick", function() state.ownedOnly = not state.ownedOnly; state.page = 1; RenderList() end)
prevBtn:SetScript("OnClick", function() state.page = state.page - 1; RenderList() end)
nextBtn:SetScript("OnClick", function() state.page = state.page + 1; RenderList() end)
search:SetScript("OnTextChanged", function(self) state.text = string.lower(self:GetText() or ""); state.page = 1; RenderList() end)
search:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
rollBtn:SetScript("OnClick", function() Send("MROLL") end)
f:SetScript("OnShow", function() Send("MLIST"); Render(); WildcardSelectTab(f, 2) end)

-- server data: MYS;n;id:spell:q:active,...   MSTATE;slots;used;legendary;epic   MRUNES;n
local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON"); ev:RegisterEvent("BAG_UPDATE_DELAYED")
local pend
ev:SetScript("OnEvent", function(_, event, prefix, msg)
    if event == "BAG_UPDATE_DELAYED" then if f:IsShown() and state.tab == "scrolls" then RenderList() end return end
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    local kind, a, b = strsplit(";", msg)
    if kind == "MYS" then
        if a == "1" then pend = {owned = {}, active = {}} end
        pend = pend or {owned = {}, active = {}}
        for sid, _, _, act in string.gmatch(b or "", "(%d+):(%d+):(%d+):(%d)") do
            local id = tonumber(sid); pend.owned[id] = true; if act == "1" then pend.active[id] = true end
        end
    elseif kind == "MSTATE" then
        if pend then state.owned, state.active, pend = pend.owned, pend.active, nil end
        state.slots, state.used = tonumber(a) or 0, tonumber(b) or 0
        if f:IsShown() then Render() end
    elseif kind == "MRUNES" then
        state.runes = tonumber(a) or 0
        if f:IsShown() then RenderWheel() end
    elseif kind == "MCHANGED" then
        if f:IsShown() then Send("MLIST") end
    elseif kind == "OPEN" and a == "mystic" then
        f:Show()
    end
end)

function WildcardMysticCodexToggle() f:SetShown(not f:IsShown()) end
SLASH_WILDCARDMYSTIC1 = "/mystic"
SlashCmdList["WILDCARDMYSTIC"] = WildcardMysticCodexToggle
