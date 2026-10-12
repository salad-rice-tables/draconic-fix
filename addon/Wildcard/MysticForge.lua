-- Mystic Forge window (server: FORGE;OPEN;bullion;bolt;runes;silver;marks and FORGE;RES;id;rarity;duplicate;spell;name).
-- Built like the modern Blizzard crafting frames: portrait frame, an inset with the result slot, a row of payment slots (icon buttons with counts and tooltips),
-- one primary "Forge" button. Pay 50 silver, 5 Marks of Descend, a Bedlam Bullion or a Bonzo Bolt: the slot cycles through the rarity colours, then shows the enchant you got.
local PREFIX = "WCARD"
local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, msg, "WHISPER", UnitName("player")) end
local QCOL = {[3] = {0.0, 0.44, 0.87}, [4] = {0.64, 0.21, 0.93}, [5] = {1.0, 0.5, 0.0}, [6] = {0.9, 0.8, 0.5}}
local QNAME = {[3] = "Rare", [4] = "Epic", [5] = "Legendary", [6] = "Artifact"}
local FORGE_ICON = 1500880
local PAY = {   -- method id, label, icon, cost, tooltip odds
    {method = 4, name = "Marks of Descend", icon = 4549168, cost = 5,  key = "marks",   odds = "Rare 62%, Epic 28%, Legendary 9%, Artifact 1%"},
    {method = 1, name = "Silver",             icon = 133785,  cost = 50, key = "silver",  odds = "Rare 62%, Epic 28%, Legendary 9%, Artifact 1%"},
    {method = 2, name = "Bedlam Bullion",     icon = 7816867, cost = 1,  key = "bullion", odds = "Rare 62%, Epic 28%, Legendary 9%, Artifact 1%"},
    {method = 3, name = "Bonzo Bolt",         icon = 7816863, cost = 1,  key = "bolt",    odds = "Rare 30%, Epic 45%, Legendary 22%, Artifact 3%"},
}
local have = {marks = 0, silver = 0, bullion = 0, bolt = 0, runes = 0}
local selected = 2    -- index in PAY

local f, body = WildcardMakeWindow("WildcardMysticForge", 460, 520, "Mystic Forge", FORGE_ICON)
f:SetPoint("CENTER", 0, 20)

local intro = body:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
intro:SetPoint("TOP", 0, -12); intro:SetWidth(400)
intro:SetText("Feed the forge and an old scroll unfolds: a Mystic Enchant for your collection.")

-- ---------------------------------------------------------------- result stage (inset panel)
local stage = CreateFrame("Frame", nil, body, "InsetFrameTemplate")
stage:SetPoint("TOP", 0, -52); stage:SetSize(404, 210)
local stageBg = stage:CreateTexture(nil, "BACKGROUND", nil, 1)   -- Blizzard marble, darkened, like the profession frames
stageBg:SetPoint("TOPLEFT", 3, -3); stageBg:SetPoint("BOTTOMRIGHT", -3, 3)
stageBg:SetTexture("Interface/FrameGeneral/UI-Background-Marble"); stageBg:SetVertexColor(0.45, 0.4, 0.38); stageBg:SetAlpha(0.9)
local shade = stage:CreateTexture(nil, "BACKGROUND", nil, 2)
shade:SetPoint("TOPLEFT", 3, -3); shade:SetPoint("BOTTOMRIGHT", -3, 3); shade:SetColorTexture(0, 0, 0, 0.35)

local slot = CreateFrame("Frame", nil, stage)
slot:SetSize(84, 84); slot:SetPoint("TOP", 0, -26)
local icon = slot:CreateTexture(nil, "ARTWORK"); icon:SetPoint("TOPLEFT", 8, -8); icon:SetPoint("BOTTOMRIGHT", -8, 8); icon:SetTexture(FORGE_ICON)
local imask = slot:CreateMaskTexture(); imask:SetAllPoints(icon); imask:SetAtlas("UI-HUD-ActionBar-IconFrame-Mask"); icon:AddMaskTexture(imask)
local ring = slot:CreateTexture(nil, "OVERLAY"); ring:SetAllPoints(); ring:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); ring:SetVertexColor(0.55, 0.5, 0.4)
local glow = slot:CreateTexture(nil, "OVERLAY"); glow:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); glow:SetBlendMode("ADD")
glow:SetSize(150, 150); glow:SetPoint("CENTER"); glow:SetAlpha(0)

local resName = stage:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); resName:SetPoint("TOP", slot, "BOTTOM", 0, -10); resName:SetWidth(380)
local resInfo = stage:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); resInfo:SetPoint("TOP", resName, "BOTTOM", 0, -4); resInfo:SetWidth(380); resInfo:SetSpacing(2)
resName:SetText("Choose a payment"); resInfo:SetText("")

-- ---------------------------------------------------------------- payment slots
local payLabel = body:CreateFontString(nil, "OVERLAY", "GameFontNormal"); payLabel:SetPoint("TOPLEFT", stage, "BOTTOMLEFT", 6, -14); payLabel:SetText("Payment")

local slots = {}
local function Refresh()
    for i, b in ipairs(slots) do
        local p = PAY[i]
        local n = have[p.key] or 0
        local ok = n >= p.cost
        b.count:SetText(tostring(n))
        if ok then b.count:SetTextColor(1, 1, 1) else b.count:SetTextColor(1, 0.2, 0.2) end
        b.icon:SetDesaturated(not ok)
        b.sel:SetShown(i == selected)
        b.cost:SetText("Cost: " .. p.cost .. (p.key == "silver" and " silver" or ""))
    end
end
for i, p in ipairs(PAY) do
    local b = CreateFrame("Button", nil, body)
    b:SetSize(64, 64); b:SetPoint("TOPLEFT", stage, "BOTTOMLEFT", 14 + (i - 1) * 100, -38)
    b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetPoint("TOPLEFT", 5, -5); b.icon:SetPoint("BOTTOMRIGHT", -5, 5); b.icon:SetTexture(p.icon)
    local m = b:CreateMaskTexture(); m:SetAllPoints(b.icon); m:SetAtlas("UI-HUD-ActionBar-IconFrame-Mask"); b.icon:AddMaskTexture(m)
    local frame = b:CreateTexture(nil, "OVERLAY"); frame:SetAllPoints(); frame:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); frame:SetVertexColor(0.7, 0.62, 0.45)
    b.sel = b:CreateTexture(nil, "OVERLAY", nil, 2); b.sel:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); b.sel:SetBlendMode("ADD"); b.sel:SetSize(86, 86); b.sel:SetPoint("CENTER"); b.sel:SetVertexColor(1, 0.82, 0)
    b.hi = b:CreateTexture(nil, "HIGHLIGHT"); b.hi:SetAllPoints(); b.hi:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); b.hi:SetBlendMode("ADD"); b.hi:SetAlpha(0.6)
    b.count = b:CreateFontString(nil, "OVERLAY", "NumberFontNormal"); b.count:SetPoint("BOTTOMRIGHT", -6, 6)
    b.cost = body:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); b.cost:SetPoint("TOP", b, "BOTTOM", 0, -2)
    b:SetScript("OnClick", function() selected = i; Refresh(); PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 856) end)
    b:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(p.name, 1, 0.82, 0)
        GameTooltip:AddLine("Cost: " .. p.cost .. (p.key == "silver" and " silver" or ""), 1, 1, 1)
        GameTooltip:AddLine("You have: " .. (have[p.key] or 0), 0.7, 0.7, 0.7)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine(p.odds, 0.4, 0.8, 1, true)
        GameTooltip:AddLine("Legendary needs level 30, Artifact level 50. Enchants of your class come up more often.", 0.6, 0.6, 0.6, true)
        GameTooltip:Show()
    end)
    b:SetScript("OnLeave", function() GameTooltip:Hide() end)
    slots[i] = b
end

-- primary button, runes line
local forgeBtn = CreateFrame("Button", nil, body, "UIPanelButtonTemplate")
forgeBtn:SetSize(180, 34); forgeBtn:SetPoint("BOTTOM", 0, 44); forgeBtn:SetText("Forge")
local runeLine = body:CreateFontString(nil, "OVERLAY", "GameFontNormal"); runeLine:SetPoint("BOTTOM", 0, 18)
local note = body:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); note:SetPoint("BOTTOM", forgeBtn, "TOP", 0, 6); note:SetWidth(400)

-- ---------------------------------------------------------------- animation: the slot changes every 0.09 s with the colour of a random rarity, slowing down, until the result arrives
local spin = {t = 0, step = 0, active = false, result = nil, minTime = 2.4}
local data = WildcardMysticData or {}
local function RandIcon()
    local e = data[math.random(math.max(1, #data))]
    local tex = e and C_Spell.GetSpellTexture(e[2])
    return tex or FORGE_ICON
end
local function SetButtons(on)
    forgeBtn:SetEnabled(on)
    for _, b in ipairs(slots) do b:SetEnabled(on) end
end
local function Reveal()
    spin.active = false
    local r = spin.result
    local c = QCOL[r.q] or QCOL[3]
    ring:SetVertexColor(c[1], c[2], c[3]); glow:SetVertexColor(c[1], c[2], c[3]); glow:SetAlpha(1)
    icon:SetTexture(C_Spell.GetSpellTexture(r.spell) or FORGE_ICON)
    resName:SetText("|cff" .. string.format("%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255) .. r.name .. "|r")
    resInfo:SetText((QNAME[r.q] or "") .. " Mystic Enchant\n" .. (r.dup and "|cffffd200You already had it: the scroll turned into a Mystic Rune.|r" or "|cff40ff40New enchant added to your collection!|r"))
    PlaySound(r.q >= 5 and (SOUNDKIT.UI_LEGENDARY_LOOT_TOAST or 888) or (SOUNDKIT.UI_EPICLOOT_TOAST or 888))
    if r.q >= 5 and WildcardToast then WildcardToast("Mystic Enchant unlocked", r.name) end
    SetButtons(true)
    Send("FORGEOPEN")   -- refresh the counts
end
f:SetScript("OnUpdate", function(_, el)
    if not spin.active then
        if glow:GetAlpha() > 0.45 then glow:SetAlpha(glow:GetAlpha() - el * 0.25) end
        return
    end
    spin.t = spin.t + el
    local interval = 0.08 + math.min(0.25, spin.t / 10)
    spin.step = spin.step + el
    if spin.step >= interval then
        spin.step = 0
        local q = 3 + math.random(0, 3)
        local c = QCOL[q]
        ring:SetVertexColor(c[1], c[2], c[3]); icon:SetTexture(RandIcon()); glow:SetVertexColor(c[1], c[2], c[3]); glow:SetAlpha(0.7)
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 856)
    end
    if spin.t >= spin.minTime and spin.result then Reveal() end
end)

local function Buy()
    if spin.active then return end
    local p = PAY[selected]
    if (have[p.key] or 0) < p.cost then note:SetText("|cffff5050You do not have enough " .. p.name .. ".|r"); return end
    note:SetText("")
    spin.active, spin.t, spin.step, spin.result = true, 0, 0, nil
    resName:SetText("The forge glows..."); resInfo:SetText("")
    SetButtons(false)
    Send("FORGEBUY;" .. p.method)
    -- if the server answers with an error the stage must not hang
    C_Timer.After(6, function() if spin.active and not spin.result then spin.active = false; resName:SetText("Nothing happened"); SetButtons(true) end end)
end
forgeBtn:SetScript("OnClick", Buy)

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    local kind, a, b, c, d, e, g = strsplit(";", msg)
    if kind == "FORGE" then
        if a == "OPEN" then
            have.bullion, have.bolt, have.runes, have.silver, have.marks = tonumber(b) or 0, tonumber(c) or 0, tonumber(d) or 0, tonumber(e) or 0, tonumber(g) or 0
            runeLine:SetText("Mystic Runes: |cff6fd6ff" .. have.runes .. "|r")
            Refresh()
            if not f:IsShown() then f:Show() end
        elseif a == "RES" then
            spin.result = {id = tonumber(b), q = tonumber(c) or 3, dup = d == "1", spell = tonumber(e) or 0, name = g or "Mystic Enchant"}
            if not spin.active then Reveal() end
        end
    elseif kind == "ERR" and spin.active and not spin.result then
        spin.active = false
        resName:SetText("The forge refuses"); resInfo:SetText(a or "")
        SetButtons(true)
    end
end)
f:SetScript("OnShow", function()
    resName:SetText("Choose a payment"); resInfo:SetText(""); note:SetText("")
    icon:SetTexture(FORGE_ICON); ring:SetVertexColor(0.55, 0.5, 0.4)
    Refresh(); Send("FORGEOPEN")
end)
Refresh()
SLASH_WILDCARDFORGE1 = "/forge"
SlashCmdList["WILDCARDFORGE"] = function() f:SetShown(not f:IsShown()) end
