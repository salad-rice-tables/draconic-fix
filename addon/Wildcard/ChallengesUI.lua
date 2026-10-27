-- =====================================================================
-- Challenges window (Ascension-style): opened from any Challenge Master
-- ("Open Challenges Window" gossip option -> server sends CHALOPEN).
-- Blizzard PortraitFrameTemplate like Advancement.lua, no new art.
-- Protocol (prefix WCARD): server "CHALOPEN;key:st,...,canStart:0/1"
--   (st: -=none, A=active, D=done, F=failed, P=perished); client sends
--   "CHALQUERY" (slash /challenges), "CHALTAKE;key", "CHALDROP;key", "CHALRESET".
-- =====================================================================

local PREFIX = "WCARD"
local MODES = {
    {key = "hardcore", name = "Hardcore", desc = "Die once and your hero stays a ghost forever."},
    {key = "ironman", name = "Iron Man", desc = "Only white and grey gear, no Mystic Enchants, no groups."},
    {key = "exile", name = "Exile", desc = "Capital cities are closed to you."},
    {key = "lonewolf", name = "Lone Wolf", desc = "You never join a group."},
    {key = "selfmade", name = "Self-Made", desc = "No trading, no mail, no auction house."},
    {key = "slow", name = "Slow & Steady", desc = "You gain only half experience."},
}
local STTXT = {["-"] = {"available", "ffffffff"}, A = {"Active", "ff00ff00"}, D = {"Completed", "ffffd100"},
    F = {"Failed", "ff808080"}, P = {"Fallen", "ff601010"}}
local state, canStart = {}, true

local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, msg, "WHISPER", UnitName("player")) end

local ok, f = pcall(CreateFrame, "Frame", "WildcardChallengesFrame", UIParent, "PortraitFrameTemplate")
local blizz = ok and f ~= nil
if not blizz then f = CreateFrame("Frame", "WildcardChallengesFrame", UIParent, "BackdropTemplate") end
f:SetSize(520, 560)
f:SetPoint("CENTER", 0, 10)
f:SetFrameStrata("HIGH")
f:SetToplevel(true)
f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton"); f:SetClampedToScreen(true)
f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
if not blizz then
    f:SetBackdrop({bgFile = "Interface/DialogFrame/UI-DialogBox-Background-Dark", edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11}})
else
    if f.SetTitle then pcall(f.SetTitle, f, "Challenges") end
    if f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, 133741) end
    if f.Inset then f.Inset:Hide() end
end
f:Hide()

local rows = {}
for i, m in ipairs(MODES) do
    local y = -60 - (i - 1) * 66
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); t:SetPoint("TOPLEFT", 24, y); t:SetText(m.name)
    local d = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); d:SetPoint("TOPLEFT", 24, y - 18); d:SetWidth(330); d:SetJustifyH("LEFT"); d:SetText(m.desc)
    local s = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); s:SetPoint("TOPLEFT", 24, y - 34)
    local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); b:SetSize(120, 24); b:SetPoint("TOPRIGHT", -24, y - 8)
    b:SetScript("OnClick", function()
        local st = state[m.key] or "-"
        if st == "A" then Send("CHALDROP;" .. m.key)
        elseif st == "-" then Send("CHALTAKE;" .. m.key) end
    end)
    rows[i] = {t = t, s = s, b = b, key = m.key}
end
local function Refresh()
    for _, r in ipairs(rows) do
        local st = state[r.key] or "-"
        local txt, hex = unpack(STTXT[st] or STTXT["-"])
        r.s:SetText(txt); r.s:SetTextColor(1, 1, 1)
        if st == "A" then r.b:SetText("Abandon"); r.b:Enable()
        elseif st == "-" and canStart then r.b:SetText("Take"); r.b:Enable()
        elseif st == "-" then r.b:SetText("Locked"); r.b:Disable()
        else r.b:SetText(txt); r.b:Disable() end
        local _ = hex
    end
end
local rb = CreateFrame("Button", nil, f, "UIPanelButtonTemplate"); rb:SetSize(200, 24); rb:SetPoint("BOTTOM", 0, 20)
rb:SetText("Reset (if bugged)")
rb:SetScript("OnClick", function() Send("CHALRESET") end)
local hint = f:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
hint:SetPoint("BOTTOM", 0, 48); hint:SetWidth(460)
hint:SetText("Take up to level 10. Milestones pay at 20/40/60/80, title at 90. Hardcore death is forever.")

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    if msg:sub(1, 8) ~= "CHALOPEN" then return end
    state, canStart = {}, true
    for kv in msg:sub(10):gmatch("[^,]+") do
        local k, v = kv:match("^(.-):(.*)$")
        if k == "canStart" then canStart = (v == "1") else state[k] = v end
    end
    Refresh(); f:Show()
end)
SLASH_WILDCARDCHALLENGES1 = "/challenges"
SlashCmdList["WILDCARDCHALLENGES"] = function() Send("CHALQUERY") end
