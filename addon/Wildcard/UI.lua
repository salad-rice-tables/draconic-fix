-- Shared window helper in the Blizzard style (wow-ui-source Blizzard_SharedXML: ButtonFrameTemplate, PortraitFrameTemplate, InsetFrameTemplate,
-- PanelTopTabButtonTemplate, UIPanelButtonTemplate). Falls back to older templates, then to a plain backdrop, so a window never fails to open.
function WildcardMakeWindow(name, w, h, title, portrait)
    local f
    for _, tpl in ipairs({"ButtonFrameTemplate", "BasicFrameTemplateWithInset", "PortraitFrameTemplate"}) do
        local ok, fr = pcall(CreateFrame, "Frame", name, UIParent, tpl)
        if ok and fr then f = fr; f.templateName = tpl; break end
    end
    if not f then
        f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
        f:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            edgeSize = 32, insets = {left = 8, right = 8, top = 8, bottom = 8}})
        f.templateName = "backdrop"
        local c = CreateFrame("Button", nil, f, "UIPanelCloseButton"); c:SetPoint("TOPRIGHT", -4, -4)
    end
    f:SetSize(w, h)
    if f.templateName == "ButtonFrameTemplate" and ButtonFrameTemplate_HidePortrait and not portrait then pcall(ButtonFrameTemplate_HidePortrait, f) end
    if f.SetTitle then pcall(f.SetTitle, f, title)
    elseif f.TitleText then f.TitleText:SetText(title)
    else
        local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); t:SetPoint("TOP", 0, -12); t:SetText(title)
    end
    if portrait and f.SetPortraitToAsset then pcall(f.SetPortraitToAsset, f, portrait) end
    f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetClampedToScreen(true); f:SetFrameStrata("HIGH"); f:Hide()
    table.insert(UISpecialFrames, name)
    -- content area below the title bar (the Inset of the template when it has one)
    local body = CreateFrame("Frame", nil, f)
    if f.Inset then body:SetPoint("TOPLEFT", f.Inset, "TOPLEFT", 4, -4); body:SetPoint("BOTTOMRIGHT", f.Inset, "BOTTOMRIGHT", -4, 4)
    else body:SetPoint("TOPLEFT", 14, -34); body:SetPoint("BOTTOMRIGHT", -14, 14) end
    f.body = body
    return f, body
end

-- Blizzard look for a plain panel: their inset nine-slice border (InsetFrameTemplate layout) over a dark body. The old backdrop is dropped.
function WildcardSkin(frame, alpha)
    if frame.SetBackdrop then pcall(frame.SetBackdrop, frame, nil) end
    local ok = NineSliceUtil and pcall(NineSliceUtil.ApplyLayoutByName, frame, "InsetFrameTemplate")
    if not frame.wcBg then
        frame.wcBg = frame:CreateTexture(nil, "BACKGROUND", nil, -7)
        frame.wcBg:SetPoint("TOPLEFT", 2, -2); frame.wcBg:SetPoint("BOTTOMRIGHT", -2, 2)
    end
    frame.wcBg:SetColorTexture(0.03, 0.03, 0.035, alpha or 0.8)
    if not ok and frame.SetBackdrop then   -- no nine-slice utility: keep a thin border
        pcall(frame.SetBackdrop, frame, {edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12})
    end
end

-- The three Hero windows share one tab bar at the bottom (Blizzard's PanelTabButtonTemplate + PanelTemplates API, as the character frame):
-- Character Advancement | Mystic Enchants | Skill Cards. WildcardSwitchTab(i) is defined by Advancement.lua.
function WildcardTabs(frame, selected)
    frame.Tabs = frame.Tabs or {}
    local labels = {"Character Advancement", "Mystic Enchants", "Skill Cards", "Guide"}
    for i, text in ipairs(labels) do
        local ok, t = pcall(CreateFrame, "Button", nil, frame, "PanelTabButtonTemplate")
        if not ok or not t then t = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate") end
        t:SetID(i); t:SetText(text)
        if frame.Tabs[i] ~= t then frame.Tabs[i] = t end
        if i == 1 then t:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 12, 2) end
        t:SetScript("OnClick", function() if WildcardSwitchTab then WildcardSwitchTab(i) end end)
    end
    if PanelTemplates_SetNumTabs then pcall(PanelTemplates_SetNumTabs, frame, #labels) end
    if PanelTemplates_SetTab then pcall(PanelTemplates_SetTab, frame, selected) end
    return frame.Tabs
end
function WildcardSelectTab(frame, i)
    if frame and PanelTemplates_SetTab and frame.Tabs then pcall(PanelTemplates_SetTab, frame, i) end
end

-- Follower Dungeons are the solo dungeons of this server: Manastorm
for _, key in ipairs({"LFG_TYPE_FOLLOWER_DUNGEON", "LFG_TYPE_FOLLOWER_DUNGEONS", "LFG_LIST_FOLLOWER_DUNGEON"}) do
    if type(_G[key]) == "string" then _G[key] = "Manastorm" end
end
