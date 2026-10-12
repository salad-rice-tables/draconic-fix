-- =====================================================================
-- Hero path choice in the Blizzard style (like the specialization pick in the talent window): a window with three panels, each with the
-- path emblem, title, the points that matter and a Choose button that asks once more. Shown when the server sends CHOOSE; answers CHOOSE;1|2|3.
-- =====================================================================
local PREFIX = "WCARD"
local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, msg, "WHISPER", UnitName("player")) end

local f, body = WildcardMakeWindow("WildcardPathFrame", 1040, 620, "Choose your Hero path")
f:SetPoint("CENTER")
f:SetFrameStrata("DIALOG")

local note = body:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
note:SetPoint("TOP", 0, -14); note:SetWidth(940)
note:SetText("There is only one class here: the Hero. Every ability of every class can be yours. This choice is permanent.")

local later = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
later:SetSize(160, 26); later:SetPoint("BOTTOM", 0, 34); later:SetText("Decide later")
later:SetScript("OnClick", function() f:Hide() end)
local laterNote = body:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
laterNote:SetPoint("TOP", later, "BOTTOM", 0, -4); laterNote:SetText("Press N to open this again.")

local PATHS = {
    {id = 1, name = "Classless", color = {0, 0.8, 1}, icon = 133743,
     lines = {"Pick exactly the abilities you want, from every class.",
              "Ability Essence: 3 at level 1 and 1 more every level from 4.",
              "Cost by rarity: Common 1, Uncommon 2, Rare 3, Epic 5.",
              "Unlearn for a full refund or respec for free.",
              "Talent Essence from level 10 for talents of any class."}},
    {id = 2, name = "Wildcard", color = {1, 0.5, 0}, icon = 237285,
     lines = {"Let the Dice of Destiny decide.",
              "6 abilities at level 1 (offence, defence, mobility, utility), then a new roll every level.",
              "Keep the roll, or reroll it (5 rerolls per level).",
              "Talents roll too, on even levels from 10.",
              "Rarer rolls glow brighter. Free, but never your choice."}},
    {id = 3, name = "Conquest", color = {0.77, 0.12, 0.23}, icon = 136147,
     lines = {"Become one of 21 Conquest of Azeroth classes.",
              "Necromancer, Chronomancer, Tinker, Witch Doctor and more.",
              "Your class kit is learned as you level.",
              "Talent Essence from level 10 for Hero talents.",
              "A fixed identity with a unique toolkit."}},
}

local W, G = 320, 14
local cards = {}
for i, p in ipairs(PATHS) do
    local c = CreateFrame("Frame", nil, body, "InsetFrameTemplate")
    c:SetSize(W, 440); c:SetPoint("TOP", (i - 2) * (W + G), -52)
    local art = c:CreateTexture(nil, "BACKGROUND", nil, 0)
    art:SetPoint("TOPLEFT", 3, -3); art:SetPoint("BOTTOMRIGHT", -3, 3)
    art:SetTexture("Interface/AddOns/Wildcard/art/bg_path" .. i); art:SetTexCoord(0, 1, 0.15, 0.84); art:SetAlpha(0.5)
    local tint = c:CreateTexture(nil, "BACKGROUND", nil, 1)
    tint:SetPoint("TOPLEFT", 3, -3); tint:SetPoint("BOTTOMRIGHT", -3, 3)
    tint:SetColorTexture(p.color[1], p.color[2], p.color[3], 0.10)
    local emblem = c:CreateTexture(nil, "ARTWORK")
    emblem:SetSize(84, 84); emblem:SetPoint("TOP", 0, -22)
    emblem:SetTexture(p.icon)
    local emask = c:CreateMaskTexture(); emask:SetAllPoints(emblem); emask:SetAtlas("UI-HUD-ActionBar-IconFrame-Mask"); emblem:AddMaskTexture(emask)
    local eframe = c:CreateTexture(nil, "OVERLAY"); eframe:SetAtlas("UI-HUD-ActionBar-IconFrame"); eframe:SetAllPoints(emblem)
    local eborder = c:CreateTexture(nil, "OVERLAY", nil, 1); eborder:SetAtlas("UI-HUD-ActionBar-IconFrame-Border")
    eborder:SetPoint("TOPLEFT", emblem, -3, 3); eborder:SetPoint("BOTTOMRIGHT", emblem, 3, -3); eborder:SetVertexColor(p.color[1], p.color[2], p.color[3])
    local name = c:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    name:SetPoint("TOP", emblem, "BOTTOM", 0, -16); name:SetText(p.name); name:SetTextColor(p.color[1], p.color[2], p.color[3])
    local rule = c:CreateTexture(nil, "ARTWORK")
    rule:SetSize(240, 1); rule:SetPoint("TOP", name, "BOTTOM", 0, -10); rule:SetColorTexture(0.85, 0.68, 0.28, 0.8)
    local y = -170
    for _, l in ipairs(p.lines) do
        local fs = c:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        fs:SetPoint("TOPLEFT", 22, y); fs:SetWidth(W - 44); fs:SetJustifyH("LEFT"); fs:SetText("|cffffd200- |r" .. l)
        y = y - fs:GetStringHeight() - 10
    end
    local b = CreateFrame("Button", nil, c, "UIPanelGoldButtonTemplate")
    b:SetSize(190, 30); b:SetPoint("BOTTOM", 0, 20); b:SetText("Choose " .. p.name)
    b:SetScript("OnClick", function()
        StaticPopupDialogs["WILDCARD_PATH_CONFIRM"] = {
            text = "Walk the " .. p.name .. " path for good?",
            button1 = YES, button2 = NO,
            OnAccept = function() Send("CHOOSE;" .. p.id); PlaySound(SOUNDKIT.UI_70_ARTIFACT_FORGE_TRAIT_GOLDTRAIT or 54130); f:Hide() end,
            timeout = 0, whileDead = true, hideOnEscape = true,
        }
        StaticPopup_Show("WILDCARD_PATH_CONFIRM")
    end)
    c:EnableMouse(true)
    c:SetScript("OnEnter", function() tint:SetColorTexture(p.color[1], p.color[2], p.color[3], 0.22) end)
    c:SetScript("OnLeave", function() if not c:IsMouseOver() then tint:SetColorTexture(p.color[1], p.color[2], p.color[3], 0.10) end end)
    cards[i] = c
end

f:SetScript("OnShow", function() PlaySound(SOUNDKIT.IG_QUEST_LIST_OPEN) end)

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    -- the server sends "WCARD<tab>message" (Eluna on retail keeps the old 3.3.5 format)
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    if msg == "CHOOSE" then
        if WildcardAdvancementFrame then WildcardAdvancementFrame:Hide() end
        if not f:IsShown() then f:Show() end
    elseif msg:find("^STATE;") then
        local path = select(6, strsplit(";", msg))
        if path ~= "0" and f:IsShown() then f:Hide() end
    end
end)
