-- =====================================================================
-- Wildcard client UI for the Draconic-WoW server (retail 12.1).
-- Descend-style ability roll: a die tumbles, lands in the rarity's colour
-- with the ability in its window, shows the spell's own tooltip lines and
-- offers Keep / Reroll.
--
-- Art (d20_spin, die_reveal, glow, rays, shadow) and the reveal design come
-- from mod-classless-wildcard by Dustin Hendrickson (GPL-2.0-or-later):
-- https://github.com/DustinHendrickson/mod-classless-wildcard
--
-- Protocol, addon prefix WCARD:
--   server -> client  DRAFT;<rerolls>;<id>:<rarity>[,...]   (rarity 1..4)
--                     NONE;<rerolls>
--                     LEARNED;<id>
--   client -> server  HELLO | PICK;1 | REROLL
-- Slash command: /wc  (shows the pending roll again)
-- =====================================================================

local ADDON = ...
local PREFIX = "WCARD"
local ART = "Interface\\AddOns\\" .. ADDON .. "\\"
local SPIN_TIME, BURST_TIME = 2.2, 0.4
local INFO_LINES = 9

-- our rarity 1..4 = Common, Uncommon, Rare, Epic -> art tiers 0..3
local TIERS = {
    [0] = {name = "Common",   rgb = {1, 1, 1},          rays = 0,    spin = 0,    pulse = 0,    pop = 0,  snd = SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON},
    [1] = {name = "Uncommon", rgb = {0.12, 1, 0},       rays = 0.22, spin = 0.04, pulse = 0.05, pop = 4,  snd = SOUNDKIT.LOOT_WINDOW_COIN_SOUND},
    [2] = {name = "Rare",     rgb = {0, 0.44, 0.87},    rays = 0.38, spin = 0.07, pulse = 0.10, pop = 9,  snd = SOUNDKIT.IG_QUEST_LIST_COMPLETE},
    [3] = {name = "Epic",     rgb = {0.64, 0.21, 0.93}, rays = 0.54, spin = 0.11, pulse = 0.16, pop = 15, snd = SOUNDKIT.UI_EPICLOOT_TOAST or SOUNDKIT.IG_QUEST_LIST_COMPLETE},
    [4] = {name = "Legendary", rgb = {1, 0.5, 0},       rays = 0.74, spin = 0.16, pulse = 0.24, pop = 24, snd = SOUNDKIT.UI_LEGENDARY_LOOT_TOAST or SOUNDKIT.IG_QUEST_LIST_COMPLETE},
}

C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
pcall(SetCVar, "scriptErrors", "1")   -- show Lua errors while the Hero UI is new

-- round icon (Descend emblem): a circular mask instead of SetPortraitToTexture, which newer clients lack
function WildcardRoundIcon(tex, path)
    tex:SetTexture(path)
    local m = tex:GetParent():CreateMaskTexture()
    m:SetTexture("Interface/CharacterFrame/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    m:SetAllPoints(tex)
    tex:AddMaskTexture(m)
end

local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, msg, "WHISPER", UnitName("player")) end

local ShowPick, PlaceSlots, ShowPrompt   -- forward declarations: used by functions defined above their bodies
local state = {rerolls = 0, spell = nil, tier = 0, phase = "idle", t0 = 0, awaiting = false, rot = 0, set = nil, locked = {}}

-- ---------------------------------------------------------------- frame

local reveal = CreateFrame("Frame", "WildcardRevealFrame", UIParent)
reveal:SetSize(420, 560)
reveal:SetPoint("CENTER", 0, 150)
reveal:SetScale(0.8)
reveal:SetFrameStrata("FULLSCREEN_DIALOG")
reveal:Hide()
tinsert(UISpecialFrames, "WildcardRevealFrame")

local function Scrim(y, h, a)
    local t = reveal:CreateTexture(nil, "BACKGROUND", nil, -6)
    t:SetTexture(ART .. "shadow"); t:SetSize(360, h); t:SetPoint("CENTER", 0, y); t:SetAlpha(a)
    return t
end
Scrim(176, 96, 0.85)
local textScrim = Scrim(-148, 122, 0.9)

local title = reveal:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
title:SetPoint("TOP", 0, -8)
title:SetShadowColor(0, 0, 0, 1); title:SetShadowOffset(1, -1)

local rays = reveal:CreateTexture(nil, "BACKGROUND", nil, 2)
rays:SetSize(372, 372); rays:SetPoint("CENTER", 0, 26); rays:SetTexture(ART .. "rays"); rays:SetBlendMode("ADD"); rays:Hide()
local rays2 = reveal:CreateTexture(nil, "BACKGROUND", nil, 3)
rays2:SetSize(268, 268); rays2:SetPoint("CENTER", 0, 26); rays2:SetTexture(ART .. "rays"); rays2:SetBlendMode("ADD"); rays2:Hide()
local glow = reveal:CreateTexture(nil, "BORDER")
glow:SetSize(310, 310); glow:SetPoint("CENTER", 0, 26); glow:SetTexture(ART .. "glow"); glow:SetBlendMode("ADD")

-- the icon sits behind the die so the die's window frames it (window centre 2,31)
local icon = reveal:CreateTexture(nil, "ARTWORK")
icon:SetPoint("CENTER", 2, 31)
local die = reveal:CreateTexture(nil, "OVERLAY")
die:SetSize(205, 205); die:SetPoint("CENTER", 0, 26)

local hover = CreateFrame("Button", nil, reveal)
hover:SetSize(250, 250); hover:SetPoint("CENTER", 0, 26)
hover:SetScript("OnEnter", function(self)
    if state.spell and state.phase == "shown" then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(state.spell)
        GameTooltip:Show()
    end
end)
hover:SetScript("OnLeave", function() GameTooltip:Hide() end)

local name = reveal:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
name:SetPoint("CENTER", 0, -138); name:SetJustifyH("CENTER")
local sub = reveal:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
sub:SetPoint("TOP", name, "BOTTOM", 0, -6); sub:SetJustifyH("CENTER")
do
    local face = title:GetFont()
    if face then name:SetFont(face, 24, ""); sub:SetFont(face, 15, "") end
    for _, fs in ipairs({name, sub}) do fs:SetShadowColor(0, 0, 0, 1); fs:SetShadowOffset(1, -1) end
end

-- tooltip-style plate with the spell's own lines (cost, range, cast, text)
local panel = reveal:CreateTexture(nil, "BACKGROUND", nil, 5)
panel:SetColorTexture(0, 0, 0, 0.86); panel:Hide()
local edges = {}
for i = 1, 4 do edges[i] = reveal:CreateTexture(nil, "BORDER"); edges[i]:SetColorTexture(1, 1, 1); edges[i]:Hide() end
edges[1]:SetPoint("TOPLEFT", panel); edges[1]:SetPoint("TOPRIGHT", panel); edges[1]:SetHeight(1)
edges[2]:SetPoint("BOTTOMLEFT", panel); edges[2]:SetPoint("BOTTOMRIGHT", panel); edges[2]:SetHeight(1)
edges[3]:SetPoint("TOPLEFT", panel); edges[3]:SetPoint("BOTTOMLEFT", panel); edges[3]:SetWidth(1)
edges[4]:SetPoint("TOPRIGHT", panel); edges[4]:SetPoint("BOTTOMRIGHT", panel); edges[4]:SetWidth(1)

local rows = {}
for i = 1, INFO_LINES do
    local r = {}
    r.left = reveal:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    r.left:SetWidth(300); r.left:SetJustifyH("LEFT"); r.left:SetJustifyV("TOP")
    r.left:SetPoint("TOP", i == 1 and sub or rows[i - 1].left, "BOTTOM", 0, i == 1 and -10 or -2)
    r.right = reveal:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    r.right:SetAllPoints(r.left); r.right:SetJustifyH("RIGHT"); r.right:SetJustifyV("TOP")
    rows[i] = r
end

local function FillInfo(spellId, width)
    local data = C_TooltipInfo and C_TooltipInfo.GetSpellByID(spellId)
    local lines = data and data.lines or {}
    local h, n = 0, 0
    for i = 1, INFO_LINES do
        local r, line = rows[i], lines[i + 1]   -- line 1 is the name, shown large
        r.left:SetWidth(width)
        if line and (line.leftText or line.rightText) then
            local lt, rt = line.leftText or "", line.rightText or ""
            r.left:SetText(lt); r.right:SetText(rt)
            if lt ~= "" and rt ~= "" and r.left:GetStringWidth() + r.right:GetStringWidth() + 8 > width then
                r.left:SetText(lt .. "  " .. rt); r.right:SetText("")
            end
            local c = line.leftColor
            if c then r.left:SetTextColor(c.r, c.g, c.b); r.right:SetTextColor(c.r, c.g, c.b) end
            r.left:Show(); r.right:Show()
            h = h + (r.left:GetStringHeight() or 12) + 2
            n = n + 1
        else
            r.left:SetText(""); r.right:SetText(""); r.left:Hide(); r.right:Hide()
        end
    end
    return h
end

local keep = CreateFrame("Button", nil, reveal, "UIPanelButtonTemplate")
keep:SetSize(150, 32); keep:SetText("Keep")
local reroll = CreateFrame("Button", nil, reveal, "UIPanelButtonTemplate")
reroll:SetSize(150, 32)
for _, b in ipairs({keep, reroll}) do
    b:SetNormalFontObject("GameFontNormalLarge"); b:SetHighlightFontObject("GameFontHighlightLarge")
    b:SetDisabledFontObject("GameFontDisableLarge")
end

-- ---------------------------------------------------------------- reel (as on Descend: a glowing strip of icons runs past, then the medallion appears)

local SLOT, SLOTS, LAND, VIEW = 46, 36, 28, 6
local ROLL_TIME, OPEN_TIME = 1.1, 0.5
local REEL_W = 6 * 46 + 40
local reel = CreateFrame("Frame", nil, reveal)
reel:SetSize(VIEW * SLOT + 40, 64); reel:SetPoint("CENTER", 0, 26); reel:SetScale(1.3); reel:Hide()
local reelGlow = reel:CreateTexture(nil, "BACKGROUND")
reelGlow:SetPoint("TOPLEFT", 14, 12); reelGlow:SetPoint("BOTTOMRIGHT", -14, -12)
reelGlow:SetAtlas("UI-Achievement-Alert-Glow-glow"); reelGlow:SetBlendMode("ADD"); reelGlow:SetVertexColor(0.3, 0.85, 1); reelGlow:SetAlpha(0.8)
local reelBar = reel:CreateTexture(nil, "BORDER")
reelBar:SetPoint("TOPLEFT", 20, -6); reelBar:SetPoint("BOTTOMRIGHT", -20, 6)
reelBar:SetColorTexture(0, 0, 0, 0); reelBar:Hide()   -- no dark plate behind the icons
local clip = CreateFrame("Frame", nil, reel)
clip:SetPoint("TOPLEFT", 20, -6); clip:SetPoint("BOTTOMRIGHT", -20, 6); clip:SetClipsChildren(true)
local strip = CreateFrame("Frame", nil, clip)
strip:SetSize(SLOTS * SLOT, 52); strip:SetPoint("LEFT", 0, 0)
local reelIcons = {}
for i = 1, SLOTS do
    local t = strip:CreateTexture(nil, "ARTWORK")
    t:SetSize(SLOT - 4, SLOT - 4); t:SetPoint("LEFT", (i - 1) * SLOT + 2, 0)
    t:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    reelIcons[i] = t
    local fr = strip:CreateTexture(nil, "OVERLAY")
    fr:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); fr:SetSize(SLOT - 2, SLOT - 2); fr:SetPoint("CENTER", t)
end
local function Cap(side)
    -- the two halves of the die (art/reel_cap_L and reel_cap_R, cut from the Descend reference) frame the reel; a cyan edge glows where the strip meets them
    local c = reel:CreateTexture(nil, "OVERLAY")
    c:SetSize(104, 104); c:SetPoint(side == "L" and "RIGHT" or "LEFT", reel, side == "L" and "LEFT" or "RIGHT", side == "L" and 34 or -34, 0)
    c:SetTexture("Interface/AddOns/Wildcard/art/reel_cap_" .. side)   -- the files live in the art folder
    return c
end
Cap("L"); Cap("R")
local FALLBACK = {136197, 135808, 135812, 136048, 136096, 135846, 136075, 135735, 132333, 136118, 135940, 136224}
local function ReelFill()
    local pool = WildcardPoolIcons and WildcardPoolIcons() or FALLBACK
    for i = 1, SLOTS do reelIcons[i]:SetTexture(pool[math.random(#pool)]) end
end
local function ReelLand()
    local info = state.spell and C_Spell.GetSpellInfo(state.spell)
    reelIcons[LAND]:SetTexture(info and info.iconID or 134400)
end
local function ReelPlace(p)    -- p 0..1 -> scroll offset, slow at the end
    local e = 1 - (1 - p) ^ 3
    local final = (LAND - 0.5) * SLOT - (VIEW * SLOT) / 2
    strip:SetPoint("LEFT", clip, "LEFT", -final * e, 0)
end

-- ---------------------------------------------------------------- animation

local function DieFrame(idx)
    local col, row = idx % 8, math.floor(idx / 8) % 2
    die:SetTexCoord(col / 8, (col + 1) / 8, row / 2, (row + 1) / 2)
end

local function HideResult()
    icon:Hide(); name:Hide(); sub:Hide(); keep:Hide(); reroll:Hide(); panel:Hide()
    for _, e in ipairs(edges) do e:Hide() end
    for _, r in ipairs(rows) do r.left:Hide(); r.right:Hide() end
end

local lastFx = 0
local function RollFx()
    if GetTime() - lastFx > 1 then lastFx = GetTime(); Send("FX") end
end

local function StartSpin()
    RollFx()
    state.phase, state.t0 = "spin", GetTime()
    title:SetText("")
    title:SetTextColor(1, 0.82, 0)
    glow:SetVertexColor(0.45, 0.75, 1); glow:SetAlpha(0)
    rays:Hide(); rays2:Hide()
    HideResult()
    die:SetDesaturated(false); die:SetVertexColor(1, 1, 1); die:SetTexture(ART .. "d20_spin"); die:SetSize(205, 205); DieFrame(0); die:SetAlpha(0); die:Show()
    ReelFill(); ReelLand(); ReelPlace(0); reel:SetAlpha(1); reel:SetWidth(40); reel:Hide()
    state.phase, state.t0 = "roll", GetTime()   -- 1. the die rolls, 2. it opens into the strip, 3. the icons run, 4. the strip closes into the result
    PlaySound(SOUNDKIT.UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_CHANGE or SOUNDKIT.IG_QUEST_LIST_OPEN)
    reveal:Show()
end

local function ShowResult()
    local t = TIERS[state.tier]
    local rgb = (state.rraw == 7 and {1, 0.15, 0.15}) or (state.rraw == 8 and {0.1, 0.9, 1}) or t.rgb
    state.phase = "shown"
    reel:Hide(); die:SetAlpha(1)
    glow:SetAlpha(0.55 + t.rays * 0.35); glow:SetVertexColor(rgb[1], rgb[2], rgb[3])
    local col, row = state.tier % 4, math.floor(state.tier / 4)
    die:SetDesaturated(false); die:SetVertexColor(1, 1, 1)
    die:SetTexture(ART .. "die_reveal")
    die:SetTexCoord(col / 4, (col + 1) / 4, row / 2, (row + 1) / 2)
    die:SetSize(280, 280)
    local info = C_Spell.GetSpellInfo(state.spell)
    icon:SetSize(96, 96); icon:SetTexture(info and info.iconID or 134400); icon:SetTexCoord(0.02, 0.98, 0.02, 0.98); icon:Show()
    local hex = string.format("|cff%02x%02x%02x", rgb[1] * 255, rgb[2] * 255, rgb[3] * 255)
    local tname = (state.rraw == 7 and "Immortal") or (state.rraw == 8 and "Godly") or t.name
    title:SetText(state.tier > 0 and (hex .. tname .. " Ability!|r") or "Ability Unlocked!")
    name:SetText(hex .. (info and info.name or ("Spell " .. state.spell)) .. "|r")
    sub:SetText(hex .. tname .. "|r")
    name:Show(); sub:Show()

    local panelW = math.max(344, math.min(480, math.max(name:GetStringWidth(), sub:GetStringWidth()) + 44))
    local inner = panelW - 44
    name:SetWidth(inner); sub:SetWidth(inner)
    local infoH = FillInfo(state.spell, inner)
    local blockH = 14 + name:GetStringHeight() + 6 + sub:GetStringHeight() + (infoH > 0 and (10 + infoH) or 0) + 14
    local top = -138 + name:GetStringHeight() / 2 + 14
    panel:ClearAllPoints(); panel:SetPoint("TOP", reveal, "CENTER", 0, top)
    panel:SetSize(panelW, blockH); panel:Show()
    for _, e in ipairs(edges) do e:SetVertexColor(rgb[1], rgb[2], rgb[3], 0.85); e:Show() end
    textScrim:SetSize(panelW + 140, blockH + 96)
    textScrim:ClearAllPoints(); textScrim:SetPoint("CENTER", 0, top - blockH / 2 - 24)

    keep:ClearAllPoints(); keep:SetPoint("TOPRIGHT", panel, "BOTTOM", -8, -14)
    reroll:ClearAllPoints(); reroll:SetPoint("TOPLEFT", panel, "BOTTOM", 8, -14)
    reroll:SetText(state.rerolls >= 99 and "Reroll (free)" or ("Reroll (" .. state.rerolls .. ")"))
    reroll:SetEnabled(state.rerolls > 0)
    keep:Show(); reroll:Show()
end

reveal:SetScript("OnUpdate", function(_, elapsed)
    local t = TIERS[state.tier] or TIERS[0]
    if state.hit and t.rays > 0 then
        state.rot = state.rot + elapsed * t.spin * 2 * math.pi
        rays:SetRotation(state.rot); rays2:SetRotation(-0.6 * state.rot)
        local breathe = 1 + math.sin(GetTime() * 3) * t.pulse
        local up = math.min(1, (GetTime() - state.hit) / 0.35)
        rays:SetAlpha(t.rays * breathe * up); rays2:SetAlpha(t.rays * 0.5 * (2 - breathe) * up)
    end
    if state.phase == "roll" then
        local el = GetTime() - state.t0
        local p = el / ROLL_TIME
        DieFrame(math.floor(el * 24))                         -- the d20 tumbles through its 16 frames
        die:SetAlpha(math.min(1, p * 5)); die:SetSize(190 + 30 * math.sin(math.min(1, p) * math.pi), 190 + 30 * math.sin(math.min(1, p) * math.pi))
        glow:SetAlpha(0.15 + 0.45 * math.min(1, p))
        if p >= 1 then state.phase, state.t0 = "open", GetTime(); reel:SetWidth(40); reel:SetAlpha(1); reel:Show() end
    elseif state.phase == "open" then
        local p = math.min(1, (GetTime() - state.t0) / OPEN_TIME)
        local e = 1 - (1 - p) ^ 3
        reel:SetWidth(40 + (REEL_W - 40) * e)                 -- the two halves of the die slide apart, the strip grows between them
        die:SetAlpha(1 - math.min(1, p * 1.8)); DieFrame(math.floor((GetTime() - state.t0) * 24))
        glow:SetAlpha(0.6)
        if p >= 1 then state.phase, state.t0 = "spin", GetTime(); die:SetAlpha(0); die:Hide(); reel:SetWidth(REEL_W) end
    elseif state.phase == "spin" then
        local p = (GetTime() - state.t0) / SPIN_TIME
        if p >= 1 then
            if state.awaiting then
                if GetTime() - state.awaitT0 > 5 then state.awaiting = false; reveal:Hide(); state.phase = "idle" else state.t0 = GetTime() end
                return
            end
            if state.pickAfter then   -- a three-card level up: straight from the reel to the choice, no single-ability flash in between
                local l = state.pickAfter
                state.pickAfter = nil
                reveal:Hide(); ShowPick(l)
                return
            end
            state.phase, state.t0 = "burst", GetTime()
            state.landSet = nil
            ReelLand(); ReelPlace(1)
            die:SetAlpha(0); die:Show()
            DieFrame(0)
            local rgb = t.rgb
            glow:SetAlpha(1); glow:SetVertexColor(rgb[1], rgb[2], rgb[3])
            state.hit = GetTime()
            if t.rays > 0 then
                rays:SetVertexColor(rgb[1], rgb[2], rgb[3]); rays:SetAlpha(0); rays:Show()
                if t.rays >= 0.5 then rays2:SetVertexColor(rgb[1], rgb[2], rgb[3]); rays2:SetAlpha(0); rays2:Show() end
            end
            if t.snd then PlaySound(t.snd) end
            return
        end
        if state.spell and p > 0.2 and not state.landSet then state.landSet = true; ReelLand() end
        ReelPlace(p)
        reelGlow:SetAlpha(0.6 + math.sin(GetTime() * 14) * 0.2)
        glow:SetAlpha(p * 0.5)
    elseif state.phase == "burst" then
        local p = (GetTime() - state.t0) / BURST_TIME
        if p >= 1 then
            if state.pickAfter then
                local l = state.pickAfter
                state.pickAfter = nil
                reveal:Hide(); ShowPick(l)
                return
            end
            ShowResult() return
        end
        glow:SetAlpha(1 - p * 0.3)
        reel:SetAlpha(1 - p * 0.6); reel:SetWidth(40 + (REEL_W - 40) * (1 - p) ^ 2); die:SetAlpha(p)
        local s = 205 + 75 * p + math.sin(p * math.pi) * t.pop
        die:SetSize(s, s)
    end
end)

-- ---------------------------------------------------------------- the starting set (four abilities, lock + roll, as on Descend)

local SET_N = 6
local setF = CreateFrame("Frame", "WildcardSetFrame", UIParent, "ButtonFrameTemplate")   -- Blizzard panel: portrait-less ButtonFrameTemplate with its Inset
if ButtonFrameTemplate_HidePortrait then pcall(ButtonFrameTemplate_HidePortrait, setF) end
if setF.SetTitle then setF:SetTitle("Your Starting Abilities") elseif setF.TitleText then setF.TitleText:SetText("Your Starting Abilities") end
setF:SetSize(760, 330); setF:SetPoint("TOP", 0, -110); setF:SetFrameStrata("DIALOG"); setF:Hide()
setF:SetMovable(true); setF:EnableMouse(true); setF:RegisterForDrag("LeftButton")
setF:SetScript("OnDragStart", setF.StartMoving); setF:SetScript("OnDragStop", setF.StopMovingOrSizing)
if setF.CloseButton then setF.CloseButton:Hide() end   -- the roll is finished with Keep Abilities
local sBg = setF:CreateTexture(nil, "BACKGROUND", nil, 1)   -- the Blizzard spellbook parchment behind the slots
if setF.Inset then sBg:SetPoint("TOPLEFT", setF.Inset, 3, -3); sBg:SetPoint("BOTTOMRIGHT", setF.Inset, -3, 3) else sBg:SetAllPoints() end
sBg:SetAtlas("spellbook-background-evergreen-left")
local sHint = setF:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
sHint:SetPoint("TOP", setF, "TOP", 0, -52); sHint:SetText("Lock the abilities you like, roll the rest.")
local setSlots = {}
for i = 1, SET_N do
    local x = (i - (SET_N + 1) / 2) * 100
    local b = CreateFrame("Button", nil, setF)
    b:SetSize(64, 64); b:SetPoint("CENTER", x, 6)
    b.back = b:CreateTexture(nil, "BACKGROUND"); b.back:SetAllPoints(); b.back:SetAtlas("UI-HUD-ActionBar-IconFrame-Background")
    b.icon = b:CreateTexture(nil, "ARTWORK"); b.icon:SetAllPoints()
    b.mask = b:CreateMaskTexture(); b.mask:SetAllPoints(); b.mask:SetAtlas("UI-HUD-ActionBar-IconFrame-Mask"); b.icon:AddMaskTexture(b.mask)
    b.frame = b:CreateTexture(nil, "OVERLAY"); b.frame:SetAtlas("UI-HUD-ActionBar-IconFrame"); b.frame:SetAllPoints()
    b.rar = b:CreateTexture(nil, "OVERLAY", nil, 1)           -- rarity: the Blizzard icon border, tinted
    b.rar:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); b.rar:SetPoint("TOPLEFT", -2, 2); b.rar:SetPoint("BOTTOMRIGHT", 2, -2)
    b:SetHighlightAtlas("UI-HUD-ActionBar-IconFrame-Mouseover", "ADD")
    b.name = b:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    b.name:SetPoint("TOP", b, "BOTTOM", 0, -8); b.name:SetWidth(96)
    b.lock = CreateFrame("Button", nil, setF)
    b.lock:SetSize(26, 26); b.lock:SetPoint("BOTTOM", b, "TOP", 0, 8)
    b.lock.tex = b.lock:CreateTexture(nil, "ARTWORK"); b.lock.tex:SetAllPoints()
    b.lock.tex:SetAtlas("QuestSharing-Padlock")
    b.lock:SetHighlightAtlas("search-highlight", "ADD")
    b:SetScript("OnEnter", function(self)
        local id = state.set and state.set[i] and state.set[i].id
        if not id or state.setPhase ~= "shown" then return end
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOM"); GameTooltip:SetSpellByID(id); GameTooltip:Show()
    end)
    b:SetScript("OnLeave", GameTooltip_Hide)
    setSlots[i] = b
end
local function SetLockLook(i)
    local locked = state.locked[i]
    local t = setSlots[i].lock.tex
    t:SetDesaturated(not locked)
    if locked then t:SetVertexColor(1, 0.85, 0.2) else t:SetVertexColor(1, 1, 1) end
    t:SetAlpha(locked and 1 or 0.75)
end
for i = 1, SET_N do
    setSlots[i].lock:SetScript("OnClick", function()
        if state.setPhase ~= "shown" then return end
        state.locked[i] = not state.locked[i]
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
        SetLockLook(i)
    end)
end
local rollBtn = CreateFrame("Button", nil, setF, "UIPanelButtonTemplate")
rollBtn:SetSize(190, 30); rollBtn:SetPoint("BOTTOMRIGHT", setF, "BOTTOM", -6, 4); rollBtn:SetText("Roll Abilities")
local keepSetBtn = CreateFrame("Button", nil, setF, "UIPanelButtonTemplate")
keepSetBtn:SetSize(190, 30); keepSetBtn:SetPoint("BOTTOMLEFT", setF, "BOTTOM", 6, 4); keepSetBtn:SetText("Keep Abilities")
for _, b in ipairs({rollBtn, keepSetBtn}) do
    b:SetNormalFontObject("GameFontNormalLarge"); b:SetHighlightFontObject("GameFontHighlightLarge")
    b:SetDisabledFontObject("GameFontDisableLarge")
end

-- three-card level-up draft: reuse the starting-set window, the cards are clickable and the locks are hidden
function PlaceSlots(n, gap)
    for i = 1, SET_N do
        local b = setSlots[i]
        if i <= n then b:ClearAllPoints(); b:SetPoint("CENTER", (i - (n + 1) / 2) * gap, 6); b:Show(); b.lock:SetShown(gap == 100)
        else b:Hide(); b.lock:Hide() end
    end
end
for i = 1, SET_N do
    setSlots[i]:SetScript("OnClick", function()
        if state.pickMode and state.setPhase == "shown" and state.set and state.set[i] then
            Send("PICK;" .. i .. ";" .. state.set[i].id)
            setF:Hide(); state.phase, state.setPhase, state.pickMode = "idle", nil, false
        end
    end)
end

local function SlotFill(i)
    local e = state.set[i]
    local info = e and C_Spell.GetSpellInfo(e.id)
    setSlots[i].icon:SetTexture(info and info.iconID or 134400)
    local t = TIERS[math.max(0, math.min(4, (e and e.tier or 0)))]
    local rc = (e and e.raw == 7 and {1, 0.15, 0.15}) or (e and e.raw == 8 and {0.1, 0.9, 1}) or t.rgb
    setSlots[i].rar:SetVertexColor(rc[1], rc[2], rc[3])
    setSlots[i].rar:SetAlpha(0.9)
    setSlots[i].name:SetText(info and info.name or "")
    setSlots[i].name:SetTextColor(t.rgb[1], t.rgb[2], t.rgb[3])
end

local function SetStart()          -- spin every slot that is not locked
    RollFx()
    state.phase, state.setPhase, state.setT0 = "set", "spin", GetTime()
    state.setStop = {}
    for i = 1, SET_N do
        state.setStop[i] = state.locked[i] and 0 or (1.1 + 0.35 * i)
        setSlots[i].landed = state.locked[i] and true or false
        if not state.locked[i] then setSlots[i].name:SetText(""); setSlots[i].rar:SetAlpha(0) end
        SetLockLook(i)
    end
    rollBtn:Disable(); keepSetBtn:Disable()
    reveal:Hide(); setF:Show()
    PlaySound(SOUNDKIT.UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_CHANGE or SOUNDKIT.IG_QUEST_LIST_OPEN)
end
local FALL = {136197, 135808, 135812, 136048, 136096, 135846, 136075, 135735, 132333, 136118, 135940, 136224}
setF:SetScript("OnUpdate", function()
    if state.setPhase ~= "spin" then return end
    local dt, allDone = GetTime() - state.setT0, true
    local pool = WildcardPoolIcons and WildcardPoolIcons() or FALL
    for i = 1, SET_N do
        if not state.locked[i] then
            if dt < state.setStop[i] or state.awaiting then
                allDone = false
                local step = math.floor(dt * (14 - math.min(8, dt * 4)))
                if setSlots[i].step ~= step then
                    setSlots[i].step = step
                    setSlots[i].icon:SetTexture(pool[math.random(#pool)])
                end
            elseif not setSlots[i].landed then
                SlotFill(i); setSlots[i].landed = true
                PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            end
        end
    end
    if allDone then
        state.setPhase = "shown"
        for i = 1, SET_N do SlotFill(i) end
        rollBtn:Enable(); keepSetBtn:Enable()
        PlaySound(SOUNDKIT.IG_QUEST_LIST_COMPLETE)
    end
end)
function ShowPick(list)
    state.set, state.pickMode, state.locked = list, true, {}
    state.phase, state.setPhase = "set", "shown"
    PlaceSlots(#list, 140)
    for i = 1, #list do SlotFill(i) end
    keepSetBtn:Hide()
    rollBtn:ClearAllPoints(); rollBtn:SetPoint("BOTTOM", setF, "BOTTOM", 0, 4); rollBtn:SetText("Reroll all three"); rollBtn:Enable()
    sHint:SetText("Click the ability you want to learn.")
    if setF.SetTitle then setF:SetTitle("A New Ability: choose one") end
    reveal:Hide(); setF:Show()
    PlaySound(SOUNDKIT.UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_CHANGE or SOUNDKIT.IG_QUEST_LIST_OPEN)
end
rollBtn:SetScript("OnClick", function()
    local mask = 0
    for i = 1, SET_N do if state.locked[i] then mask = mask + 2 ^ (i - 1) end end
    state.awaiting, state.awaitT0 = true, GetTime()
    SetStart()
    Send("REROLL;" .. mask)
end)
keepSetBtn:SetScript("OnClick", function()
    local ids = {}
    for i = 1, SET_N do if state.set and state.set[i] then ids[#ids + 1] = state.set[i].id end end
    Send("KEEPALL;" .. table.concat(ids, ","))
    setF:Hide(); state.phase, state.setPhase, state.set = "idle", nil, nil
end)

-- ---------------------------------------------------------------- the roll prompt
-- A pending roll (new character, new level) always shows this button at the top of the screen.
-- Nothing rolls until you click it, as on Descend.
local prompt = CreateFrame("Button", "WildcardRollPrompt", UIParent)
prompt:SetSize(260, 120); prompt:SetPoint("TOP", 0, -90); prompt:SetFrameStrata("DIALOG"); prompt:Hide()
local pdie = prompt:CreateTexture(nil, "ARTWORK")
pdie:SetSize(84, 84); pdie:SetPoint("TOP", 0, 0)
pdie:SetTexture(ART .. "d20_spin"); pdie:SetTexCoord(0, 1 / 8, 0, 1 / 2)
local pglow = prompt:CreateTexture(nil, "BACKGROUND")
pglow:SetSize(300, 300); pglow:SetPoint("CENTER", pdie, "CENTER")
pglow:SetTexture(ART .. "glow"); pglow:SetBlendMode("ADD"); pglow:SetVertexColor(0.2, 0.75, 1)
local prays = prompt:CreateTexture(nil, "BACKGROUND", nil, 1)
prays:SetSize(240, 240); prays:SetPoint("CENTER", pdie, "CENTER"); prays:SetTexture(ART .. "rays"); prays:SetBlendMode("ADD"); prays:SetVertexColor(0.3, 0.85, 1); prays:SetAlpha(0.55)
local pspin = prays:CreateAnimationGroup(); pspin:SetLooping("REPEAT")
local pr = pspin:CreateAnimation("Rotation"); pr:SetDegrees(-360); pr:SetDuration(40)
local ptext = prompt:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
ptext:SetPoint("TOP", pdie, "BOTTOM", 0, -2); ptext:SetText("Dice of Destiny")
local psub = prompt:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
psub:SetPoint("TOP", ptext, "BOTTOM", 0, -2); psub:SetText("|cff7fe0ffClick here to roll!|r")
for _, fs in ipairs({ptext, psub}) do fs:SetShadowColor(0, 0, 0, 1); fs:SetShadowOffset(1, -1) end
local pag = pglow:CreateAnimationGroup(); pag:SetLooping("BOUNCE")
local pa = pag:CreateAnimation("Alpha"); pa:SetFromAlpha(0.25); pa:SetToAlpha(1); pa:SetDuration(0.9)
local pbob = pdie:CreateAnimationGroup(); pbob:SetLooping("BOUNCE")
local pt = pbob:CreateAnimation("Translation"); pt:SetOffset(0, -8); pt:SetDuration(0.8); pt:SetSmoothing("IN_OUT")
function ShowPrompt()
    state.phase = "prompt"
    reveal:Hide()
    prompt:Show(); pag:Play(); pbob:Play(); pspin:Play()
    PlaySound(SOUNDKIT.UI_70_ARTIFACT_FORGE_APPEARANCE_APPEARANCE_CHANGE or SOUNDKIT.IG_QUEST_LIST_OPEN)
end
local function HidePrompt() prompt:Hide(); pag:Stop(); pbob:Stop(); pspin:Stop() end
prompt:SetScript("OnClick", function()
    HidePrompt()
    if state.pickList then
        local l = state.pickList
        state.pickList, state.pickAfter = nil, l
        local best = 0
        for _, e in ipairs(l) do if e.tier > best then best = e.tier end end
        state.spell, state.tier, state.rraw, state.hit = l[1].id, best, l[1].raw, nil
        StartSpin()
        title:SetText("")
        return
    end
    if state.set then state.locked = {}; SetStart() else StartSpin() end
end)
-- the Character Advancement "Dice of Destiny" button and /wc call this
function WildcardShowDice()
    if state.phase == "set" then setF:Show()
    elseif state.phase == "prompt" then prompt:Show()
    elseif state.phase == "shown" or state.phase == "spin" or state.phase == "burst" then reveal:Show()
    else Send("HELLO") end
end

keep:SetScript("OnClick", function()
    Send("PICK;1;" .. (state.spell or 0))
    reveal:Hide(); state.phase = "idle"; state.hit = nil
end)
reroll:SetScript("OnClick", function()
    if state.rerolls <= 0 then return end
    state.awaiting, state.awaitT0 = true, GetTime()
    StartSpin()
    Send("REROLL")
end)

-- ---------------------------------------------------------------- alerts: Blizzard achievement-alert look, stacked under each other, never on top of each other
-- (server: TOAST;title;text and MREV;kind;spellId;name;rarity). Every alert is one frame from a small pool; the frames are laid out in a column
-- (newest at the bottom), a long description plate adds to the height of its alert, extra alerts wait in a queue, and a repeat of the same alert is dropped.
local ALERT_TOP, ALERT_H, ALERT_GAP, ALERT_PLATE, ALERT_MAX = -150, 78, 8, 62, 1
local alertPool, alertActive, alertQueue = {}, {}, {}
local lastAlert = {}

local function AlertRelayout()
    local y = ALERT_TOP
    for _, a in ipairs(alertActive) do
        a:ClearAllPoints(); a:SetPoint("TOP", UIParent, "TOP", 0, y)
        y = y - ALERT_H - (a.hasDesc and (ALERT_PLATE - 2) or 0) - ALERT_GAP
    end
end

local AlertShow
local function AlertRelease(a)
    a:Hide(); a.ag:Stop(); a.sg:Stop(); a.shine:SetAlpha(0)
    for i, x in ipairs(alertActive) do if x == a then table.remove(alertActive, i) break end end
    alertPool[#alertPool + 1] = a
    AlertRelayout()
    local nxt = table.remove(alertQueue, 1)
    if nxt then AlertShow(nxt) end
end

local function NewAlert()
    local a = CreateFrame("Button", nil, UIParent)
    a:SetSize(311, ALERT_H); a:SetFrameStrata("FULLSCREEN_DIALOG"); a:Hide()
    a.iconBg = a:CreateTexture(nil, "BACKGROUND", nil, -1); a.iconBg:SetAtlas("Toast-IconBG", true); a.iconBg:SetPoint("LEFT", 15, 0)
    a.bg = a:CreateTexture(nil, "BORDER"); a.bg:SetAtlas("Toast-Frame"); a.bg:SetAllPoints()
    a.head = a:CreateFontString(nil, "ARTWORK", "GameFontWhiteTiny")
    a.head:SetSize(200, 12); a.head:SetPoint("TOP", 20, -22); a.head:SetTextColor(0.973, 0.937, 0.580)
    a.name = a:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    a.name:SetSize(200, 0); a.name:SetPoint("CENTER", a, "TOP", 20, -46); a.name:SetMaxLines(2); a.name:SetJustifyH("CENTER")
    local holder = CreateFrame("Frame", nil, a); holder:SetSize(60, 60); holder:SetPoint("LEFT", 10, 0)
    a.icon = holder:CreateTexture(nil, "ARTWORK"); a.icon:SetSize(45, 45); a.icon:SetPoint("CENTER")
    a.frame = holder:CreateTexture(nil, "OVERLAY"); a.frame:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); a.frame:SetSize(54, 54); a.frame:SetPoint("CENTER", a.icon)
    a.shine = a:CreateTexture(nil, "OVERLAY")
    a.shine:SetAtlas("ui-achievement-alert-glow-shine", true); a.shine:SetBlendMode("ADD"); a.shine:SetPoint("BOTTOMLEFT", 0, 0); a.shine:SetAlpha(0)
    local ok, plate = pcall(CreateFrame, "Frame", nil, a, "TooltipBackdropTemplate")
    if not ok or not plate then
        plate = CreateFrame("Frame", nil, a, "BackdropTemplate")
        plate:SetBackdrop({bgFile = "Interface/Buttons/WHITE8x8", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 12, insets = {left = 3, right = 3, top = 3, bottom = 3}})
        plate:SetBackdropColor(0, 0, 0, 0.9)
    end
    plate:SetPoint("TOPLEFT", a, "BOTTOMLEFT", 14, 2); plate:SetPoint("TOPRIGHT", a, "BOTTOMRIGHT", -14, 2); plate:SetHeight(ALERT_PLATE - 4)
    a.desc = plate:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    a.desc:SetPoint("TOPLEFT", 10, -8); a.desc:SetPoint("BOTTOMRIGHT", -10, 8); a.desc:SetJustifyH("LEFT"); a.desc:SetJustifyV("TOP")
    a.plate = plate
    a.ag = a:CreateAnimationGroup()
    local a1 = a.ag:CreateAnimation("Alpha"); a1:SetFromAlpha(0); a1:SetToAlpha(1); a1:SetDuration(0.35); a1:SetOrder(1)
    a.hold = a.ag:CreateAnimation("Alpha"); a.hold:SetFromAlpha(1); a.hold:SetToAlpha(1); a.hold:SetDuration(6); a.hold:SetOrder(2)
    local a3 = a.ag:CreateAnimation("Alpha"); a3:SetFromAlpha(1); a3:SetToAlpha(0); a3:SetDuration(0.8); a3:SetOrder(3)
    a.ag:SetScript("OnFinished", function() AlertRelease(a) end)
    a.sg = a.shine:CreateAnimationGroup()
    local s1 = a.sg:CreateAnimation("Alpha"); s1:SetFromAlpha(0); s1:SetToAlpha(1); s1:SetDuration(0.2); s1:SetOrder(1)
    local s2 = a.sg:CreateAnimation("Translation"); s2:SetOffset(240, 0); s2:SetDuration(0.85); s2:SetOrder(2)
    local s3 = a.sg:CreateAnimation("Alpha"); s3:SetStartDelay(0.35); s3:SetFromAlpha(1); s3:SetToAlpha(0); s3:SetDuration(0.5); s3:SetOrder(2)
    a.sg:SetScript("OnFinished", function() a.shine:SetAlpha(0) end)
    a:SetScript("OnClick", function() AlertRelease(a) end)
    a:SetScript("OnEnter", function(self) if self.spell and self.spell > 0 then GameTooltip:SetOwner(self, "ANCHOR_BOTTOM"); GameTooltip:SetSpellByID(self.spell); GameTooltip:Show() end end)
    a:SetScript("OnLeave", function() GameTooltip:Hide() end)
    return a
end

-- spec: {head, name, desc (optional), icon, spell, hold (seconds), sound}
function AlertShow(spec)
    local key = (spec.head or "") .. "|" .. (spec.name or "")
    if lastAlert.key == key and GetTime() - lastAlert.t < 1.5 then return end   -- the same alert twice in a row: once is enough
    lastAlert.key, lastAlert.t = key, GetTime()
    if #alertActive >= ALERT_MAX then alertQueue[#alertQueue + 1] = spec return end   -- one on screen, the rest wait their turn
    local a = table.remove(alertPool) or NewAlert()
    a.spell = spec.spell or 0
    a.icon:SetTexture(spec.icon or 134400)
    a.head:SetText(spec.head or ""); a.name:SetText(spec.name or "")
    a.hasDesc = spec.desc and spec.desc ~= ""
    a.desc:SetText(spec.desc or ""); a.plate:SetShown(a.hasDesc)
    a.hold:SetDuration(spec.hold or (a.hasDesc and 9 or 5))
    alertActive[#alertActive + 1] = a
    AlertRelayout()
    a:SetAlpha(0); a:Show(); a.ag:Stop(); a.ag:Play(); a.sg:Stop(); a.sg:Play()
    PlaySound(spec.sound or SOUNDKIT.UI_EPICLOOT_TOAST or SOUNDKIT.UI_ACHIEVEMENT_TOAST or 888)
end

function WildcardToast(title, text)
    AlertShow({head = title, name = text, icon = 236415, sound = SOUNDKIT.UI_ACHIEVEMENT_TOAST or SOUNDKIT.IG_QUEST_LIST_COMPLETE})
end

local MREV_COL = {Rare = "ff0070dd", Epic = "ffa335ee", Legendary = "ffff8000", Artifact = "ffe6cc80"}
local function ShowMysticReveal(kind, spellId, name, rar)
    local r, extra = strsplit("|", rar or "")
    local sid = tonumber(spellId) or 0
    local tex
    if sid > 0 then local info = C_Spell.GetSpellInfo(sid); tex = info and info.iconID end
    local c = MREV_COL[r or ""] or "ff6fd6ff"
    local desc = sid > 0 and C_Spell.GetSpellDescription and C_Spell.GetSpellDescription(sid) or ""
    local spec = {spell = sid, icon = tex or 134414}
    if kind == "C" then
        spec.icon = 237381; spec.head = "Campaign unlocked"; spec.name = "|cff7fd6ff" .. (name or "") .. "|r"
        spec.desc = (rar or "") .. "\n|cff9d9d9dOpen your quest log (L) to follow it.|r"
    elseif kind == "T" then
        spec.head = "Tome studied"; spec.name = "|cffff8000" .. (name or "") .. "|r"
        spec.desc = "|cffff8000" .. (r or "") .. "|r - " .. (desc or "") .. "|n|cff9d9d9dFind it in your spellbook and in Character Advancement (N).|r"
    elseif kind == "E" then
        spec.head = "Mystic Scroll unlocked"; spec.name = "|c" .. c .. (name or "") .. "|r"
        spec.desc = "|c" .. c .. (r or "") .. " enchant|r - " .. (desc or "") .. "\n|cff9d9d9dTurn it on in the Mystic tab (/ca).|r"
    elseif kind == "D" then
        spec.head = "Mystic Scroll: already known"; spec.name = "|c" .. c .. (name or "") .. "|r"
        spec.desc = "The scroll crumbles into a |cff6fd6ffMystic Rune|r.\n" .. (extra or "")
    else
        spec.icon = 134414; spec.head = "Mystic Rune obtained"; spec.name = "|cff6fd6ff" .. (name or "Mystic Rune") .. "|r"
        spec.desc = "|cffffffff" .. (rar or "") .. "|r" .. "\nSpend runes at a Mystic Altar or in the Mystic tab (/ca) to learn a new enchant."
    end
    AlertShow(spec)
end

-- ---------------------------------------------------------------- "New Ability Unlocked!" banner (Blizzard's level-up spell banner look)
local ban = CreateFrame("Frame", "WildcardAbilityBannerFrame", UIParent)
ban:SetSize(620, 72); ban:SetPoint("TOP", 0, -240); ban:SetFrameStrata("FULLSCREEN_DIALOG"); ban:Hide()
ban.bg = ban:CreateTexture(nil, "BACKGROUND"); ban.bg:SetAllPoints(); ban.bg:SetColorTexture(0, 0, 0, 0.75)
ban.fade = ban:CreateTexture(nil, "BACKGROUND", nil, 1); ban.fade:SetAllPoints(); ban.fade:SetColorTexture(0, 0, 0, 0)
ban.top = ban:CreateTexture(nil, "ARTWORK"); ban.top:SetColorTexture(1, 0.82, 0, 0.9); ban.top:SetPoint("TOPLEFT"); ban.top:SetPoint("TOPRIGHT"); ban.top:SetHeight(2)
ban.bot = ban:CreateTexture(nil, "ARTWORK"); ban.bot:SetColorTexture(1, 0.82, 0, 0.9); ban.bot:SetPoint("BOTTOMLEFT"); ban.bot:SetPoint("BOTTOMRIGHT"); ban.bot:SetHeight(2)
ban.icon = ban:CreateTexture(nil, "ARTWORK"); ban.icon:SetSize(52, 52); ban.icon:SetPoint("LEFT", 150, 0); ban.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
ban.ring = ban:CreateTexture(nil, "OVERLAY"); ban.ring:SetAtlas("UI-HUD-ActionBar-IconFrame-Border"); ban.ring:SetSize(64, 64); ban.ring:SetPoint("CENTER", ban.icon)
ban.head = ban:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge"); ban.head:SetPoint("TOPLEFT", ban.icon, "TOPRIGHT", 14, -2); ban.head:SetTextColor(0.1, 1, 0.1)
ban.head:SetText("New Ability Unlocked!")
ban.name = ban:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge"); ban.name:SetPoint("BOTTOMLEFT", ban.icon, "BOTTOMRIGHT", 14, 0); ban.name:SetTextColor(1, 0.82, 0)
local bag = ban:CreateAnimationGroup()
local b1 = bag:CreateAnimation("Alpha"); b1:SetFromAlpha(0); b1:SetToAlpha(1); b1:SetDuration(0.3); b1:SetOrder(1)
local b2 = bag:CreateAnimation("Alpha"); b2:SetFromAlpha(1); b2:SetToAlpha(1); b2:SetDuration(3.5); b2:SetOrder(2)
local b3 = bag:CreateAnimation("Alpha"); b3:SetFromAlpha(1); b3:SetToAlpha(0); b3:SetDuration(0.8); b3:SetOrder(3)
bag:SetScript("OnFinished", function() ban:Hide() end)
function WildcardAbilityBanner(name, icon)
    ban.icon:SetTexture(icon or 134400); ban.name:SetText(name or "")
    ban:SetAlpha(0); ban:Show(); bag:Stop(); bag:Play()
end

-- ---------------------------------------------------------------- events


-- Paragon / Prestige choice at level 90 (paragon.lua)
StaticPopupDialogs["WILDCARD_PARAGON"] = {
    text = "|cffffd200You reached the summit (level 90)!|r\n\n|cff3de6ffParagon|r: keep playing, earn Paragon levels (+Essence, Mystic Runes).\n|cffff5050Prestige|r: start again at level 1, keeping your Mystic collection, Paragon levels and every Legendary ability.",
    button1 = "Paragon", button2 = "Prestige", button3 = "Later",
    OnAccept = function() C_ChatInfo.SendAddonMessage(PREFIX, "PARA;1", "WHISPER", UnitName("player")) end,
    OnCancel = function()
        StaticPopup_Show("WILDCARD_PRESTIGE")
    end,
    timeout = 0, whileDead = true, hideOnEscape = false, exclusive = true,
}
StaticPopupDialogs["WILDCARD_PRESTIGE"] = {
    text = "|cffff5050Prestige|r sends you back to level 1. You keep Mystic enchants, Paragon levels and Legendary or better abilities; weaker abilities are forgotten. Are you sure?",
    button1 = YES, button2 = NO,
    OnAccept = function() C_ChatInfo.SendAddonMessage(PREFIX, "PARA;2", "WHISPER", UnitName("player")) end,
    OnCancel = function() StaticPopup_Show("WILDCARD_PARAGON") end,
    timeout = 0, whileDead = true, hideOnEscape = true,
}
SLASH_PARAGON1 = "/paragon"
SlashCmdList["PARAGON"] = function() C_ChatInfo.SendAddonMessage(PREFIX, "PARA;ASK", "WHISPER", UnitName("player")) end

local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("PLAYER_LEVEL_UP")
ev:SetScript("OnEvent", function(_, event, prefix, msg)
    -- the server sends "WCARD<tab>message" (Eluna on retail keeps the old 3.3.5 format)
    if type(msg) == "string" then msg = msg:gsub("^" .. PREFIX .. "	", "") end
    if event == "PLAYER_LEVEL_UP" then
        C_Timer.After(2.5, function() Send("HELLO") end)   -- ask for the new level's roll
        return
    end
    if event == "PLAYER_ENTERING_WORLD" then
        Send("UI")                                   -- tell the server to use these windows instead of gossip
        C_Timer.After(3, function() Send("LIST") end)   -- lets the server learn which spells this client cannot show
        C_Timer.After(5, function() Send("HELLO") end)
        return
    end
    if prefix ~= PREFIX then return end
    local kind, a, b, c, d = strsplit(";", msg)
    if kind == "MREV" then
        ShowMysticReveal(a, b, c, d)
        return
    end
    if kind == "DRAFT" then
        local list = {}
        for sid, srar in string.gmatch(b or "", "(%d+):(%d+)") do
            list[#list + 1] = {id = tonumber(sid), raw = tonumber(srar), tier = math.max(0, math.min(4, (tonumber(srar) or 1) - 1))}
        end
        if #list == 0 then return end
        local unknown = {}
        for _, e in ipairs(list) do if not C_Spell.GetSpellInfo(e.id) then unknown[#unknown + 1] = e.id end end
        if #unknown > 0 then      -- this client does not know a spell: ask the server for another roll
            Send("BAD;" .. table.concat(unknown, ","))
            return
        end
        if #list > 1 and c == "P" then   -- three cards of a level up: pick one (the starting set is the other multi-card case)
            state.rerolls = tonumber(a) or 0
            if state.phase == "set" and state.awaiting and state.pickMode then
                state.awaiting = false             -- the reroll that is spinning lands on the new three
                state.set = list
            else
                local same = state.pickList and state.pickList[1] and state.pickList[1].id == list[1].id
                if same or state.pickAfter or state.phase == "spin" or state.phase == "burst" or (state.phase == "set" and state.pickMode) then return end   -- the same level-up announced twice
                state.pickList = list
                ShowPrompt()                      -- Click the Dice, then the reel runs, then the three cards open
            end
            return
        end
        if #list > 1 then         -- the starting set
            if state.pickMode then state.pickMode = false; PlaceSlots(SET_N, 100); keepSetBtn:Show(); keepSetBtn:Enable() end
            state.rerolls = tonumber(a) or 0
            if state.phase == "set" and state.awaiting and state.set then
                for i = 1, #list do if state.locked[i] and state.set[i] then list[i] = state.set[i] end end   -- a locked slot never changes
            end
            state.set = list
            if state.phase == "set" and state.awaiting then
                state.awaiting = false             -- the spin that is running lands on the new set
            elseif state.phase ~= "set" then
                state.locked = {}
                ShowPrompt()
            end
            return
        end
        state.set = nil
        local id, rar = list[1].id, list[1].tier + 1
        state.rerolls = tonumber(a) or 0
        -- the same roll announced twice (login + map change) keeps what is already up
        if (reveal:IsShown() or prompt:IsShown()) and state.spell == tonumber(id) and not state.awaiting then return end
        state.spell = tonumber(id)
        state.rraw = list[1].raw
        state.tier = math.max(0, math.min(4, (tonumber(rar) or 1) - 1))
        state.hit = nil
        if state.awaiting then
            state.awaiting = false            -- the spin already running lands on the new roll
        else
            ShowPrompt()                      -- the roll waits for the click
        end
    elseif kind == "NONE" then
        state.rerolls = tonumber(a) or 0
        if state.phase ~= "spin" and state.phase ~= "set" then reveal:Hide(); HidePrompt(); state.phase = "idle" end
    elseif kind == "PARA" then
        if a == "ASK" then StaticPopup_Show("WILDCARD_PARAGON") end
    elseif kind == "TOAST" then
        WildcardToast(a, b)
    elseif kind == "LEARNED" then
        local info = C_Spell.GetSpellInfo(tonumber(a) or 0)
        -- the client shows its own "New Ability Unlocked!" banner for a learned spell, so no second one from us
        PlaySound(888)                       -- level-up fanfare, as on Descend
        C_Timer.After(1.5, function() if state.phase == "idle" then Send("HELLO") end end)   -- the next starting roll, if any
        UIErrorsFrame:AddMessage("Learned: " .. (info and info.name or a), 1, 0.82, 0)
    end
end)

SLASH_WILDCARD1 = "/wc"
SLASH_WILDCARD2 = "/wildcard"
SlashCmdList["WILDCARD"] = function() WildcardShowDice() end

-- ---------------------------------------------------------------- bug reports (/bug <text>)
-- Keeps the last Lua errors of this client and sends them with the text; the server adds where you are, your target,
-- Essence, Hero state and its own recent errors (bugreport.lua) and saves it all for the developer.
local lastErrors = {}
local autoSeen, autoLast, autoCount
do
    local prev = geterrorhandler()
    seterrorhandler(function(msg)
        local m = string.sub(tostring(msg), 1, 90)
        lastErrors[#lastErrors + 1] = m
        while #lastErrors > 3 do table.remove(lastErrors, 1) end
        -- every Lua error is reported automatically (deduplicated, at most one per 20 s, 15 per session)
        autoSeen = autoSeen or {}
        local now = GetTime()
        if not autoSeen[m] and (autoLast or -99) + 20 < now and (autoCount or 0) < 15 and Send then
            autoSeen[m] = true; autoLast = now; autoCount = (autoCount or 0) + 1
            local build = select(2, GetBuildInfo())
            pcall(Send, "BUG;[AUTO] " .. (m:gsub(";", ",")) .. ";client Lua error [build " .. tostring(build) .. "]")
        end
        if prev then return prev(msg) end
    end)
end
SLASH_WILDCARDBUG1 = "/bug"
SLASH_WILDCARDBUG2 = "/report"
SlashCmdList["WILDCARDBUG"] = function(text)
    text = (text or ""):gsub(";", ","):sub(1, 120)
    if text == "" then
        print("|cff00ccff[Bug report]|r Write what is wrong:  /bug <description>  (everything else is collected automatically)")
        return
    end
    local errs = table.concat(lastErrors, " | "):gsub(";", ","):sub(1, 110)
    local build = select(2, GetBuildInfo())
    Send("BUG;" .. text .. ";" .. errs .. " [build " .. tostring(build) .. "]")
    print("|cff00ccff[Bug report]|r Sent. Thank you!")
end
