-- Wildcard DX: the all-in-one developer/diagnostics window (/dx). Buttons run the server's GM commands (core .debug/.scene/.quest/.aura/.reload... and the .diag suite)
-- and the answers appear in the output pane (all system messages), which you can copy. ID boxes fill %id / %id2 / %text in the command templates.
local f
for _, tpl in ipairs({"BasicFrameTemplateWithInset", "ButtonFrameTemplate", "BackdropTemplate"}) do
    local ok, fr = pcall(CreateFrame, "Frame", "WildcardDXFrame", UIParent, tpl)
    if ok and fr then f = fr break end
end
f:SetSize(960, 640)
f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
f:SetFrameStrata("HIGH"); f:SetClampedToScreen(true); f:Hide()
table.insert(UISpecialFrames, "WildcardDXFrame")
if f.TitleText then f.TitleText:SetText("Dev Tools (GM)") else
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); t:SetPoint("TOP", 0, -5); t:SetText("Dev Tools (GM)")
end

local function Panel(parent, x, y, w, h, label)
    local p = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    p:SetPoint("TOPLEFT", x, y); p:SetSize(w, h)
    p:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12, insets = {left = 3, right = 3, top = 3, bottom = 3}})
    p:SetBackdropColor(0, 0, 0, 0.45); p:SetBackdropBorderColor(0.6, 0.55, 0.4, 1)
    if label then local fs = p:CreateFontString(nil, "OVERLAY", "GameFontNormal"); fs:SetPoint("TOPLEFT", 10, -8); fs:SetText(label) end
    return p
end
local function Btn(parent, text, w, x, y, fn)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(w, 22); b:SetText(text); b:SetPoint("TOPLEFT", x, y); b:SetScript("OnClick", fn)
    return b
end
local function Edit(parent, w, x, y, text)
    local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    e:SetSize(w, 22); e:SetPoint("TOPLEFT", x, y); e:SetAutoFocus(false); e:SetText(text or "")
    return e
end

-- ---------------------------------------------------------------- output pane (right)
local out = Panel(f, 440, -30, 510, 568)
local log = CreateFrame("ScrollingMessageFrame", nil, out)
log:SetPoint("TOPLEFT", 8, -8); log:SetPoint("BOTTOMRIGHT", -26, 40)
log:SetFontObject(ChatFontNormal); log:SetJustifyH("LEFT"); log:SetMaxLines(2000); log:SetFading(false); log:SetInsertMode("BOTTOM")
log:EnableMouseWheel(true)
log:SetScript("OnMouseWheel", function(self, d) if IsShiftKeyDown() then if d > 0 then self:PageUp() else self:PageDown() end else if d > 0 then self:ScrollUp() self:ScrollUp() self:ScrollUp() else self:ScrollDown() self:ScrollDown() self:ScrollDown() end end end)
local history = {}
local function AddLine(text, r, g, b)
    history[#history + 1] = text
    if #history > 2000 then table.remove(history, 1) end
    log:AddMessage(text, r or 1, g or 1, b or 1)
end
local copy
Btn(out, "Clear", 70, 8, -540, function() log:Clear(); history = {} end)
Btn(out, "Copy all", 80, 84, -540, function()
    copy.edit:SetText(table.concat(history, "\n")); copy:Show(); copy.edit:SetFocus(); copy.edit:HighlightText()
end)
local showAll = true
local chk = CreateFrame("CheckButton", nil, out, "UICheckButtonTemplate")
chk:SetPoint("TOPLEFT", 176, -538); chk:SetSize(24, 24); chk:SetChecked(true)
chk:SetScript("OnClick", function(self) showAll = self:GetChecked() end)
local chkl = out:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); chkl:SetPoint("LEFT", chk, "RIGHT", 2, 0); chkl:SetText("Capture all system messages")

-- copy window
copy = CreateFrame("Frame", nil, f, "BackdropTemplate")
copy:SetPoint("CENTER"); copy:SetSize(700, 420); copy:SetFrameStrata("DIALOG"); copy:Hide()
copy:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14, insets = {left = 4, right = 4, top = 4, bottom = 4}})
copy:SetBackdropColor(0, 0, 0, 0.95)
local sc = CreateFrame("ScrollFrame", nil, copy, "UIPanelScrollFrameTemplate")
sc:SetPoint("TOPLEFT", 10, -10); sc:SetPoint("BOTTOMRIGHT", -30, 40)
copy.edit = CreateFrame("EditBox", nil, sc)
copy.edit:SetMultiLine(true); copy.edit:SetFontObject(ChatFontNormal); copy.edit:SetWidth(650); copy.edit:SetAutoFocus(false)
copy.edit:SetScript("OnEscapePressed", function() copy:Hide() end)
sc:SetScrollChild(copy.edit)
Btn(copy, "Close", 80, 310, -388, function() copy:Hide() end)
local ct = copy:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); ct:SetPoint("BOTTOMLEFT", 12, 14); ct:SetText("Ctrl+C copies the selection. Paste it into the chat with Claude.")

-- ---------------------------------------------------------------- command input (top of the left side)
local left = Panel(f, 12, -30, 420, 568)
local lastCmd
local function Run(cmd)
    if not cmd or cmd == "" then return end
    lastCmd = cmd
    AddLine("|cff7fd6ff> " .. cmd .. "|r")
    SendChatMessage(cmd, "SAY")
end
local ID, ID2, TEXT
local function Fill(t)
    t = t:gsub("%%id2", function() return ID2:GetText() end)
    t = t:gsub("%%id", function() return ID:GetText() end)
    t = t:gsub("%%text", function() return TEXT:GetText() end)
    return t
end
local lbl = left:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); lbl:SetPoint("TOPLEFT", 10, -10); lbl:SetText("ID")
ID = Edit(left, 70, 28, -6, "")
local lbl2 = left:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); lbl2:SetPoint("TOPLEFT", 108, -10); lbl2:SetText("ID2")
ID2 = Edit(left, 60, 132, -6, "")
local lbl3 = left:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); lbl3:SetPoint("TOPLEFT", 200, -10); lbl3:SetText("Text")
TEXT = Edit(left, 150, 232, -6, "")
local cmdBox = Edit(left, 330, 12, -34, "")
cmdBox:SetScript("OnEnterPressed", function(self) Run(Fill(self:GetText())); self:SetText("") ; self:ClearFocus() end)
cmdBox:SetScript("OnArrowPressed", function(self, key) if key == "UP" and lastCmd then self:SetText(lastCmd) end end)
Btn(left, "Run", 70, 346, -34, function() Run(Fill(cmdBox:GetText())); cmdBox:SetText("") end)
local hint = left:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
hint:SetPoint("TOPLEFT", 12, -60); hint:SetWidth(396); hint:SetJustifyH("LEFT")
hint:SetText("Type any GM command above (with the dot). Buttons fill %id, %id2 and %text from the boxes. Target an NPC first for the NPC buttons.")

-- ---------------------------------------------------------------- command catalogue
-- {label, command template, tooltip}
local GROUPS = {
 {"Inspect", {
   {"Everything", ".diag all", "you, area, phases, target/nearest NPC, nearest object"}, {"Me", ".diag me"}, {"Area + phases", ".diag area"}, {"NPC (target)", ".diag npc"},
   {"Object", ".diag go"}, {"Near 40 yd", ".diag near 40"}, {"Near 100 yd", ".diag near 100"}, {"My auras", ".diag auras"}, {"Target auras", ".diag auras t"},
   {"Quest %id", ".diag quest %id", "givers, enders, objectives, why you can't take it"}, {"Spell %id", ".diag spell %id"}, {"GPS", ".gps"}, {"Phases of target", ".debug phase"},
   {"NPC info", ".npc info"}, {"Object near", ".gobject near 20"}, {"Spawn count %id", ".list creature %id 10"}, {"Quest log", ".diag me"}}},
 {"Play", {
   {"Cinematic %id", ".debug play cinematic %id"}, {"Movie %id", ".debug play movie %id"}, {"Scene %id", ".scene play %id"}, {"Scene package %id", ".scene playpackage %id"},
   {"Cancel scene", ".scene cancel"}, {"Sound %id", ".debug play sound %id"}, {"Music %id", ".debug play music %id"}, {"Spell visual: cast %id on me", ".cast self %id"},
   {"Aura %id", ".aura %id"}, {"Remove aura %id", ".unaura %id"}, {"Remove all auras", ".unaura all"}, {"Morph %id", ".morph %id"}, {"Demorph", ".demorph"},
   {"NPC emote %id", ".npc playemote %id"}, {"NPC anim kit %id", ".npc set animkit %id"}, {"Scale %id", ".modify scale %id"}, {"Speed %id", ".modify speed all %id"}}},
 {"Quests", {
   {"Add %id", ".quest add %id"}, {"Complete %id", ".quest complete %id"}, {"Reward %id", ".quest reward %id"}, {"Remove %id", ".quest remove %id"}, {"Diagnose %id", ".diag quest %id"},
   {"Lookup quest %text", ".lookup quest %text"}, {"Reload quests", ".reload quest_template"}, {"Reload POI", ".reload quest_poi"}, {"Reload starters", ".reload creature_queststarter"},
   {"Reload enders", ".reload creature_questender"}, {"Reload conditions", ".reload conditions"}, {"Reload gossip", ".reload gossip_menu"}, {"Reload gossip options", ".reload gossip_menu_option"}}},
 {"NPC", {
   {"Add %id", ".npc add %id"}, {"Delete", ".npc delete"}, {"Move here", ".npc move"}, {"Info", ".npc info"}, {"Set level %id", ".npc set level %id"}, {"Set phase %id", ".npc set phase %id"},
   {"Set flags %id", ".npc set flag %id"}, {"Faction %id", ".npc set faction %id"}, {"Model %id", ".npc set model %id"}, {"Say %text", ".npc say %text"}, {"Yell %text", ".npc yell %text"},
   {"Respawn near", ".respawn"}, {"Kill", ".die"}, {"Revive", ".revive"}, {"Lookup creature %text", ".lookup creature %text"}, {"Reload templates", ".reload creature_template"},
   {"Reload creature text", ".reload creature_text"}, {"Reload vendors", ".reload npc_vendor"}}},
 {"World", {
   {"Tele %text", ".tele %text"}, {"Go xyz %id %id2", ".go xyz %id %id2"}, {"Where am I", ".gps"}, {"Weather %id %id2", ".wchange %id %id2"}, {"Level up %id", ".levelup %id"}, {"Cooldowns", ".cooldown"},
   {"Lookup area %text", ".lookup area %text"}, {"Lookup spell %text", ".lookup spell %text"}, {"Lookup item %text", ".lookup item %text"}, {"Server info", ".server info"},
   {"Reload Eluna", ".reload eluna"}, {"Reload all scripts", ".reload all scripts"}, {"Visible on/off", ".gm visible"}, {"Fly on/off", ".gm fly on"}, {"Unstuck", ".unstuck"}}},
}
local tabs, pages = {}, {}
local function ShowTab(i) for k, p in ipairs(pages) do p:SetShown(k == i); tabs[k]:SetEnabled(k ~= i) end end
for i, g in ipairs(GROUPS) do
    tabs[i] = Btn(left, g[1], 76, 10 + (i - 1) * 80, -84, function() ShowTab(i) end)
    local p = CreateFrame("Frame", nil, left)
    p:SetPoint("TOPLEFT", 0, -112); p:SetPoint("BOTTOMRIGHT", 0, 6)
    pages[i] = p
    for k, c in ipairs(g[2]) do
        local col, row = (k - 1) % 2, math.floor((k - 1) / 2)
        local b = Btn(p, c[1], 196, 10 + col * 202, -(row * 26), function() Run(Fill(c[2])) end)
        b:SetScript("OnEnter", function(self) GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(c[1]); GameTooltip:AddLine((c[3] and (c[3] .. "\n") or "") .. c[2], 0.8, 0.8, 0.8, true); GameTooltip:Show() end)
        b:SetScript("OnLeave", GameTooltip_Hide)
    end
end
ShowTab(1)

-- ---------------------------------------------------------------- capture the answers
local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_SYSTEM")
ev:RegisterEvent("UI_ERROR_MESSAGE")
ev:RegisterEvent("CINEMATIC_START"); ev:RegisterEvent("CINEMATIC_STOP"); ev:RegisterEvent("PLAY_MOVIE")
ev:SetScript("OnEvent", function(_, event, a, b)
    if not f:IsShown() then return end
    if event == "CHAT_MSG_SYSTEM" then
        if showAll and type(a) == "string" then AddLine(a) end
    elseif event == "UI_ERROR_MESSAGE" then
        AddLine("|cffff8080error: " .. tostring(b or a) .. "|r")
    elseif event == "PLAY_MOVIE" then AddLine("|cff80ff80movie started: " .. tostring(a) .. "|r")
    elseif event == "CINEMATIC_START" then AddLine("|cff80ff80cinematic started|r")
    elseif event == "CINEMATIC_STOP" then AddLine("|cff80ff80cinematic stopped|r") end
end)

SLASH_WILDCARDDX1 = "/dx"
SlashCmdList["WILDCARDDX"] = function() f:SetShown(not f:IsShown()) end
AddLine("|cff00ff96Dev Tools|r: type or click a command. /dx toggles this window. Output of the .diag suite is also saved on the server in DiagReport.txt.")
