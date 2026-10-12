-- Conquest of Azeroth class window (server: COAASK): the 21 classes in a list on the left, the chosen class with its story and the abilities it
-- learns by level on the right (hover for the tooltip), "Become a <class>" asks once more and answers COA;<key>.
local PREFIX = "WCARD"
local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, msg, "WHISPER", UnitName("player")) end
local DATA = WildcardCoaData or {}

local f, body = WildcardMakeWindow("WildcardConquestChoice", 880, 600, "Choose your Conquest class")
f:SetPoint("CENTER")

-- ---------------------------------------------------------------- list (left)
local listBox = CreateFrame("Frame", nil, body, "InsetFrameTemplate")
listBox:SetPoint("TOPLEFT", 0, 0); listBox:SetPoint("BOTTOMLEFT", 0, 0); listBox:SetWidth(250)
local sf = CreateFrame("ScrollFrame", nil, listBox, "UIPanelScrollFrameTemplate")
sf:SetPoint("TOPLEFT", 6, -6); sf:SetPoint("BOTTOMRIGHT", -28, 6)
local content = CreateFrame("Frame", nil, sf); content:SetSize(214, #DATA * 38); sf:SetScrollChild(content)
local selected
local rows = {}

-- ---------------------------------------------------------------- detail (right)
local detail = CreateFrame("Frame", nil, body, "InsetFrameTemplate")
detail:SetPoint("TOPLEFT", listBox, "TOPRIGHT", 8, 0); detail:SetPoint("BOTTOMRIGHT", 0, 0)
local art = detail:CreateTexture(nil, "BACKGROUND", nil, 1); art:SetPoint("TOPRIGHT", -4, -4); art:SetPoint("BOTTOMRIGHT", -4, 4); art:SetWidth(290); art:SetAlpha(0.6); art:Hide()
local icon = detail:CreateTexture(nil, "ARTWORK"); icon:SetSize(64, 64); icon:SetPoint("TOPLEFT", 18, -18)
icon:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
local ring = detail:CreateTexture(nil, "OVERLAY"); ring:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); ring:SetSize(112, 112); ring:SetPoint("TOPLEFT", icon, "TOPLEFT", -14, 14)
local title = detail:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); title:SetPoint("TOPLEFT", icon, "TOPRIGHT", 16, -4); title:SetTextColor(0.77, 0.12, 0.23)
local story = detail:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
story:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8); story:SetPoint("RIGHT", -18, 0); story:SetJustifyH("LEFT"); story:SetJustifyV("TOP")
local abl = detail:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); abl:SetPoint("TOPLEFT", 18, -160); abl:SetText("Class abilities")
local abHint = detail:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); abHint:SetPoint("LEFT", abl, "RIGHT", 10, 0); abHint:SetText("learned as you level, paid with Essence")
local cells = {}
for i = 1, 24 do
    local b = CreateFrame("Button", nil, detail)
    b:SetSize(48, 48); b:SetPoint("TOPLEFT", 22 + ((i - 1) % 6) * 84, -188 - math.floor((i - 1) / 6) * 88)
    b.ic = b:CreateTexture(nil, "ARTWORK"); b.ic:SetSize(44, 44); b.ic:SetPoint("TOPLEFT", 2, -2); b.ic:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
    b.rg = b:CreateTexture(nil, "OVERLAY"); b.rg:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); b.rg:SetBlendMode("ADD"); b.rg:SetSize(80, 80); b.rg:SetPoint("CENTER")
    b.nm = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); b.nm:SetPoint("TOP", b, "BOTTOM", 0, -2); b.nm:SetWidth(82); b.nm:SetWordWrap(true); b.nm:SetMaxLines(2)
    b.lv = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"); b.lv:SetPoint("TOP", b.nm, "BOTTOM", 0, -1)
    b:SetScript("OnEnter", function(self) if self.spell then GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetSpellByID(self.spell); GameTooltip:Show() end end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    cells[i] = b
end
local tabs = {}
for k = 1, 4 do
    local t = CreateFrame("Button", nil, detail, "UIPanelButtonTemplate")
    t:SetSize(140, 24); t:SetPoint("TOPLEFT", 18 + (k - 1) * 144, -128); t:Hide()
    tabs[k] = t
end
local choose = CreateFrame("Button", nil, detail, "UIPanelButtonTemplate")
choose:SetSize(220, 30); choose:SetPoint("BOTTOMRIGHT", -18, 16)
local note = detail:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); note:SetPoint("BOTTOMLEFT", 18, 24); note:SetText("This choice is permanent.")

StaticPopupDialogs["WILDCARD_COA_CONFIRM"] = {
    text = "Become a %s for good? Your class cannot be changed later.",
    button1 = YES, button2 = NO,
    OnAccept = function(_, data) Send("COA;" .. data); f:Hide() end,
    timeout = 0, whileDead = true, hideOnEscape = true,
}

local build = 1
local function Show(c)
    local builds = c[6]
    local label, kit, descr = c[2], c[4], c[3]
    if builds and builds[build] then
        local bd = builds[build]
        label = c[2] .. ": " .. bd[2]
        kit = bd[4]
        descr = c[3] .. "|n|n|cffffd200" .. bd[2] .. "|r  " .. bd[3]
        -- the info tab (empty key) lists what every build learns; the build tabs show only their own abilities
        if bd[1] ~= "" then
            local shared = {}
            for _, b2 in ipairs(builds) do if b2[1] == "" then for _, e in ipairs(b2[4]) do shared[e[1]] = true end end end
            local own = {}
            for _, e in ipairs(kit) do if not shared[e[1]] then own[#own + 1] = e end end
            kit = own
        end
    end
    title:SetText(c[2]); story:SetText(descr)
    if c[5] and c[5] ~= "" then art:SetTexture("Interface/AddOns/Wildcard/art/class_" .. c[5]); art:Show() else art:Hide() end
    local first = kit[1] and kit[1][1]
    local info = first and C_Spell.GetSpellInfo(first)
    icon:SetTexture(info and info.iconID or 134400)
    for k, cell in ipairs(cells) do
        local e = kit[k]
        if e then
            local inf = C_Spell.GetSpellInfo(e[1])
            cell.spell = e[1]
            cell.ic:SetTexture(inf and inf.iconID or 134400)
            cell.nm:SetText(inf and inf.name or ("Spell " .. e[1])); cell.lv:SetText("Level " .. e[2]); cell:Show()
        else cell:Hide() end
    end
    for k, t in ipairs(tabs) do
        local bd = builds and builds[k]
        if bd then t:SetText(bd[2]); t:SetEnabled(k ~= build); t:Show() else t:Hide() end
    end
    local info = builds and builds[build] and builds[build][1] == ""
    choose:SetText(info and "Pick a build tab to choose" or ("Become a " .. label))
    choose:SetEnabled(not info)
    return label
end
local function Select(i)
    selected = i; build = 1
    local c = DATA[i]
    if not c then return end
    Show(c)
    for k, r in ipairs(rows) do r.sel:SetShown(k == i) end
end
for k, t in ipairs(tabs) do t:SetScript("OnClick", function() local c = DATA[selected]; if c and c[6] and c[6][k] then build = k; Show(c) end end) end
choose:SetScript("OnClick", function()
    local c = DATA[selected]
    if not c then return end
    local key, name = c[1], c[2]
    if c[6] and c[6][build] then key = c[6][build][1]; name = c[2] .. ": " .. c[6][build][2] end
    StaticPopup_Show("WILDCARD_COA_CONFIRM", name, nil, key)
end)

for i, c in ipairs(DATA) do
    local b = CreateFrame("Button", nil, content)
    b:SetSize(214, 36); b:SetPoint("TOPLEFT", 0, -(i - 1) * 38)
    b.sel = b:CreateTexture(nil, "BACKGROUND"); b.sel:SetAllPoints(); b.sel:SetColorTexture(0.77, 0.12, 0.23, 0.35); b.sel:Hide()
    b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    b.ic = b:CreateTexture(nil, "ARTWORK"); b.ic:SetSize(30, 30); b.ic:SetPoint("LEFT", 4, 0); b.ic:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
    local first = c[4][1] and c[4][1][1]
    local info = first and C_Spell.GetSpellInfo(first)
    b.ic:SetTexture(info and info.iconID or 134400)
    b.tx = b:CreateFontString(nil, "OVERLAY", "GameFontNormal"); b.tx:SetPoint("LEFT", b.ic, "RIGHT", 8, 0); b.tx:SetText(c[2])
    b:SetScript("OnClick", function() Select(i) end)
    rows[i] = b
end
f:SetScript("OnShow", function() if not selected then Select(1) end end)

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    if msg:sub(1, 6) == "COAASK" then f:Show() end
end)
SLASH_WILDCARDCOA1 = "/coa"
SlashCmdList["WILDCARDCOA"] = function() f:SetShown(not f:IsShown()) end
