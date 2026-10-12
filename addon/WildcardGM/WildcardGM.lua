-- Wildcard GM Tool: /gmt. One Blizzard-style window: results on the left, 3D preview in the middle, tabs (Move / Groups / Emotes) on the right.
local PREFIX = "WCARD"
C_ChatInfo.RegisterAddonMessagePrefix(PREFIX)
local function Send(msg) C_ChatInfo.SendAddonMessage(PREFIX, "GMT;" .. msg, "WHISPER", UnitName("player")) end

local msgText, pendingModel, pendingExt
local kind, results, selectedId = "c", {}, nil
local ROWS, ROW_H = 14, 20

-- ---------------------------------------------------------------- frame
local f
for _, tpl in ipairs({"BasicFrameTemplateWithInset", "ButtonFrameTemplate", "BackdropTemplate"}) do
    local ok, fr = pcall(CreateFrame, "Frame", "WildcardGMFrame", UIParent, tpl)
    if ok and fr then f = fr break end
end
f:SetSize(940, 600)
f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving); f:SetScript("OnDragStop", f.StopMovingOrSizing)
f:SetFrameStrata("HIGH"); f:SetClampedToScreen(true); f:Hide()
table.insert(UISpecialFrames, "WildcardGMFrame")
if f.TitleText then f.TitleText:SetText("GM Tool") else
    local t = f:CreateFontString(nil, "OVERLAY", "GameFontNormal"); t:SetPoint("TOP", 0, -5); t:SetText("GM Tool")
end

-- a titled, inset sub-panel (like the Blizzard "inset" boxes)
local function Panel(parent, x, y, w, h, label)
    local p = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    p:SetPoint("TOPLEFT", x, y); p:SetSize(w, h)
    p:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 12,
        insets = {left = 3, right = 3, top = 3, bottom = 3}})
    p:SetBackdropColor(0, 0, 0, 0.45); p:SetBackdropBorderColor(0.6, 0.55, 0.4, 1)
    if label then
        local fs = p:CreateFontString(nil, "OVERLAY", "GameFontNormal"); fs:SetPoint("TOPLEFT", 10, -8); fs:SetText(label)
        p.label = fs
    end
    return p
end

local function Btn(parent, text, w, x, y, fn)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(w, 22); b:SetText(text); b:SetPoint("TOPLEFT", x, y); b:SetScript("OnClick", fn)
    return b
end

-- layout columns: left 12..312, middle 320..640, right 648..928
local left = Panel(f, 12, -30, 300, 558)
local mid = Panel(f, 320, -30, 320, 558, "3D Preview")
local right = Panel(f, 648, -30, 280, 558)

-- ---------------------------------------------------------------- left: kind tabs, search, results
local bNpc, bObj
local function SetKind(k)
    kind = k
    bNpc:SetEnabled(k ~= "c"); bObj:SetEnabled(k ~= "g")
end
bNpc = Btn(left, "NPC", 100, 10, -10, function() SetKind("c") end)
bObj = Btn(left, "Object", 100, 114, -10, function() SetKind("g") end)
local search = CreateFrame("EditBox", nil, left, "InputBoxTemplate")
search:SetSize(204, 22); search:SetPoint("TOPLEFT", 16, -42); search:SetAutoFocus(false)
local page, total, lastQuery = 0, 0, "a"
local PAGE = 40
local function DoSearch(p)
    results = {}
    if p == nil or type(p) ~= "number" then page = 0 else page = math.max(0, p) end
    if msgText then msgText:SetText("Searching...") end
    if page == 0 then lastQuery = (search:GetText() ~= "" and search:GetText() or "a") end
    Send("S;" .. kind .. ";" .. lastQuery .. ";" .. page)
end
search:SetScript("OnEnterPressed", function(self) self:ClearFocus(); DoSearch(0) end)
Btn(left, "Search", 70, 222, -42, function() DoSearch(0) end)

local rows = {}
local list = CreateFrame("Frame", nil, left)
list:SetPoint("TOPLEFT", 10, -74); list:SetSize(280, ROWS * ROW_H)
local offset = 0
local model, ShowModel
local function Refresh()
    for i = 1, ROWS do
        local r, row = results[i + offset], rows[i]
        if r then
            row.text:SetText(r.id .. "  " .. r.name); row.data = r; row:Show()
            row.hl:SetShown(selectedId == r.id)
        else row:Hide() end
    end
end
for i = 1, ROWS do
    local row = CreateFrame("Button", nil, list)
    row:SetSize(280, ROW_H); row:SetPoint("TOPLEFT", 0, -(i - 1) * ROW_H)
    row.hl = row:CreateTexture(nil, "BACKGROUND"); row.hl:SetAllPoints(); row.hl:SetColorTexture(0.2, 0.5, 1, 0.35); row.hl:Hide()
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    row.text:SetPoint("LEFT", 4, 0); row.text:SetPoint("RIGHT", -4, 0); row.text:SetJustifyH("LEFT"); row.text:SetWordWrap(false)
    row:SetScript("OnClick", function(self)
        selectedId = self.data.id
        pendingModel = self.data.display
        pendingExt = (self.data.ext or ""):lower()
        if kind == "c" and self.data.display > 0 then
            local disp = self.data.display
            ShowModel(function() model:SetDisplayInfo(disp) end)
        else model:Hide(); model.none:Show(); model.none:SetText(kind == "g" and "Press Preview 3D" or "No preview") end
        Refresh()
    end)
    row:SetScript("OnDoubleClick", function(self) Send("P;" .. kind .. ";" .. self.data.id) end)
    rows[i] = row
end
list:EnableMouseWheel(true)
list:SetScript("OnMouseWheel", function(_, d) offset = math.max(0, math.min(math.max(0, #results - ROWS), offset - d * 3)); Refresh() end)

-- paging
local ny = -74 - ROWS * ROW_H - 8
Btn(left, "< Prev", 80, 10, ny, function() if page > 0 then DoSearch(page - 1) end end)
Btn(left, "Next >", 80, 210, ny, function() if (page + 1) * PAGE < total then DoSearch(page + 1) end end)
local pageText = left:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
pageText:SetPoint("TOP", left, "TOPLEFT", 150, ny - 3); pageText:SetWidth(110); pageText:SetText("")

-- actions
local ay = ny - 36
Btn(left, "Spawn here", 138, 10, ay, function() if selectedId then Send("P;" .. kind .. ";" .. selectedId) end end)
Btn(left, "Select nearest", 138, 152, ay, function() Send("N;" .. kind) end)
Btn(left, "Preview 3D (objects)", 280, 10, ay - 28, function()
    if kind == "g" and pendingModel and pendingModel > 0 then
        -- the preview is a PlayerModel: it shows .m2 only, a .wmo (houses, towers, ruins) crashes the client
        if pendingExt ~= "m2" then model:Hide(); model.none:Show(); model.none:SetText("No preview for this object type (" .. tostring(pendingExt ~= "" and pendingExt or "unknown") .. ")") return end
        local pm = pendingModel; ShowModel(function() model:SetModel(pm) end)
    end
end)
msgText = left:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
msgText:SetPoint("TOPLEFT", 12, ay - 62); msgText:SetWidth(276); msgText:SetJustifyH("LEFT"); msgText:SetJustifyV("TOP")
msgText:SetText("Double-click a result to spawn it. Select existing ones with Select nearest.")

-- ---------------------------------------------------------------- middle: 3D preview (left drag rotate, right drag move, wheel zoom)
model = CreateFrame("PlayerModel", nil, mid)
model:SetPoint("TOPLEFT", 8, -30); model:SetPoint("BOTTOMRIGHT", -8, 34)
model:Hide()
model.bg = mid:CreateTexture(nil, "ARTWORK"); model.bg:SetAllPoints(model); model.bg:SetColorTexture(0, 0, 0, 0.5)
model.none = mid:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); model.none:SetPoint("CENTER", model.bg); model.none:SetText("No preview")
local ph = mid:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall"); ph:SetPoint("BOTTOM", 0, 12)
ph:SetText("Left drag: rotate   Right drag: move   Wheel: zoom")
local view = {facing = 0, zoom = 1, y = 0, z = 0}
local function ApplyView()
    pcall(function() model:SetFacing(view.facing) end)
    pcall(function() model:SetCamDistanceScale(view.zoom) end)
    pcall(function() model:SetPosition(0, view.y, view.z) end)
end
local function ResetView() view.facing, view.zoom, view.y, view.z = 0, 1, 0, 0; ApplyView() end
local drag
model:EnableMouse(true); model:EnableMouseWheel(true)
model:SetScript("OnMouseDown", function(_, btn) local cx, cy = GetCursorPosition(); drag = {btn = btn, x = cx, y = cy} end)
model:SetScript("OnMouseUp", function() drag = nil end)
model:SetScript("OnUpdate", function()
    if not drag then return end
    local cx, cy = GetCursorPosition()
    local dx, dy = cx - drag.x, cy - drag.y
    drag.x, drag.y = cx, cy
    if drag.btn == "LeftButton" then view.facing = view.facing + dx * 0.012
    else view.y = view.y + dx * 0.004 * view.zoom; view.z = view.z + dy * 0.004 * view.zoom end
    ApplyView()
end)
model:SetScript("OnMouseWheel", function(_, d) view.zoom = math.max(0.15, math.min(6, view.zoom * (d > 0 and 0.88 or 1.14))); ApplyView() end)
local rv = CreateFrame("Button", nil, mid, "UIPanelButtonTemplate")
rv:SetSize(90, 20); rv:SetText("Reset view"); rv:SetPoint("TOPRIGHT", -8, -6); rv:SetScript("OnClick", ResetView)
ShowModel = function(fn)
    model:Show(); model.none:Hide(); ResetView()
    pcall(fn)
    ApplyView()
end

-- ---------------------------------------------------------------- right: tabs Move / Groups / Emotes
local tabs, pages = {}, {}
local function ShowTab(i)
    for k, p in ipairs(pages) do p:SetShown(k == i); tabs[k]:SetEnabled(k ~= i) end
end
local TABNAMES = {"Move", "Groups", "Emotes"}
for i, name in ipairs(TABNAMES) do
    tabs[i] = Btn(right, name, 86, 6 + (i - 1) * 90, -8, function() ShowTab(i) end)
    local p = CreateFrame("Frame", nil, right)
    p:SetPoint("TOPLEFT", 0, -36); p:SetPoint("BOTTOMRIGHT", 0, 0)
    pages[i] = p
end

-- Move tab
local mv = pages[1]
local selText = mv:CreateFontString(nil, "OVERLAY", "GameFontNormal")
selText:SetPoint("TOPLEFT", 12, -6); selText:SetWidth(256); selText:SetJustifyH("LEFT"); selText:SetJustifyV("TOP"); selText:SetHeight(48)
selText:SetText("Selected: none")
local YD = 91.44   -- centimetres in one yard (the game unit)
local function Edit(parent, w, x, y, text)
    local e = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
    e:SetSize(w, 22); e:SetPoint("TOPLEFT", x, y); e:SetAutoFocus(false); e:SetText(text)
    return e
end
local lbl = mv:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); lbl:SetPoint("TOPLEFT", 12, -62); lbl:SetText("Move step (cm):")
local step = Edit(mv, 56, 120, -58, "10")
local function S() return (tonumber((step:GetText():gsub(",", "."))) or 10) / YD end
for i = 1, 10 do   -- fine steps 0.1 ... 1 cm
    local v = i / 10
    Btn(mv, tostring(v), 25, 8 + (i - 1) * 26, -84, function() step:SetText(tostring(v)) end)
end
for i, v in ipairs({2, 5, 10, 50, 100, 200}) do
    Btn(mv, tostring(v), 40, 8 + (i - 1) * 43, -108, function() step:SetText(tostring(v)) end)
end
local function M(dx, dy, dz) Send(string.format("M;%.5f;%.5f;%.5f", dx, dy, dz)) end
local cx0, cw, cs = 8, 84, 88
local function Grid(r, c, text, fn) return Btn(mv, text, cw, cx0 + c * cs, -136 - r * 28, fn) end
Grid(0, 0, "X +", function() M(S(), 0, 0) end);      Grid(0, 1, "Y +", function() M(0, S(), 0) end);       Grid(0, 2, "Up", function() M(0, 0, S()) end)
Grid(1, 0, "X -", function() M(-S(), 0, 0) end);     Grid(1, 1, "Y -", function() M(0, -S(), 0) end);      Grid(1, 2, "Down", function() M(0, 0, -S()) end)
Grid(2, 0, "Forward", function() Send("MF;" .. string.format("%.5f", S())) end); Grid(2, 1, "Back", function() Send("MF;" .. string.format("%.5f", -S())) end); Grid(2, 2, "To me", function() Send("H") end)

local tl = mv:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); tl:SetPoint("TOPLEFT", 12, -228); tl:SetText("Turn step (deg):")
local tstep = Edit(mv, 56, 120, -224, "5")
local function T() return math.rad(tonumber(tstep:GetText()) or 5) end
for i, v in ipairs({0.5, 1, 5, 15, 45, 90}) do
    Btn(mv, tostring(v), 40, 8 + (i - 1) * 43, -250, function() tstep:SetText(tostring(v)) end)
end
Grid(5, 0, "Turn L", function() Send(string.format("T;%.6f", T())) end); Grid(5, 1, "Turn R", function() Send(string.format("T;%.6f", -T())) end)
Grid(5, 2, "Delete", function() Send("D") end)

local ex = mv:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); ex:SetPoint("TOPLEFT", 12, -338); ex:SetText("Exact position  (X / Y / Z / angle):")
local fx, fy, fz, fo = Edit(mv, 58, 12, -358, ""), Edit(mv, 58, 76, -358, ""), Edit(mv, 58, 140, -358, ""), Edit(mv, 58, 204, -358, "")
local function LoadBoxes(x, y, z, o)
    fx:SetText(string.format("%.3f", x)); fy:SetText(string.format("%.3f", y)); fz:SetText(string.format("%.3f", z)); fo:SetText(string.format("%.2f", math.deg(o)))
end
local last
Btn(mv, "Set exact", 126, 8, -386, function() Send("SET;" .. fx:GetText() .. ";" .. fy:GetText() .. ";" .. fz:GetText() .. ";" .. fo:GetText()) end)
Btn(mv, "Reload values", 126, 142, -386, function() if last then LoadBoxes(unpack(last)) end end)
local hint = mv:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
hint:SetPoint("TOPLEFT", 12, -418); hint:SetWidth(256); hint:SetJustifyH("LEFT")
hint:SetText("Steps are in centimetres and degrees. X/Y move along the map axes, Forward/Back along the object's facing. Spawning selects the new object automatically; Select nearest (left) picks an existing one.")

-- Groups tab
local gp = pages[2]
local draftText = gp:CreateFontString(nil, "OVERLAY", "GameFontHighlight"); draftText:SetPoint("TOPLEFT", 12, -6); draftText:SetText("Draft: 0 objects")
Btn(gp, "Add selected", 126, 8, -28, function() Send("G;A") end)
Btn(gp, "Clear draft", 126, 142, -28, function() Send("G;C") end)
local gname = CreateFrame("EditBox", nil, gp, "InputBoxTemplate")
gname:SetSize(150, 22); gname:SetPoint("TOPLEFT", 16, -62); gname:SetAutoFocus(false); gname:SetText("My group")
Btn(gp, "Save group", 100, 168, -62, function() Send("G;S;" .. gname:GetText()) end)
local groups, gsel = {}, nil
local grows = {}
for i = 1, 8 do
    local row = CreateFrame("Button", nil, gp)
    row:SetSize(260, 20); row:SetPoint("TOPLEFT", 10, -94 - (i - 1) * 20)
    row.hl = row:CreateTexture(nil, "BACKGROUND"); row.hl:SetAllPoints(); row.hl:SetColorTexture(0.2, 0.5, 1, 0.35); row.hl:Hide()
    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    row.text = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall"); row.text:SetPoint("LEFT", 4, 0)
    row:SetScript("OnClick", function(self) gsel = self.id; for _, r in ipairs(grows) do r.hl:SetShown(r.id == gsel) end end)
    row:SetScript("OnDoubleClick", function(self) Send("G;P;" .. self.id) end)
    grows[i] = row
end
local function RefreshGroups()
    for i, row in ipairs(grows) do
        local e = groups[i]
        if e then row.id = e.id; row.text:SetText(e.name .. "  (" .. e.n .. ")"); row.hl:SetShown(gsel == e.id); row:Show() else row:Hide() end
    end
end
Btn(gp, "Spawn group", 126, 8, -262, function() if gsel then Send("G;P;" .. gsel) end end)
Btn(gp, "Undo spawn", 126, 142, -262, function() Send("G;U") end)
Btn(gp, "Delete group", 126, 8, -290, function() if gsel then Send("G;X;" .. gsel); gsel = nil end end)
Btn(gp, "Refresh", 126, 142, -290, function() Send("G;L") end)
local gh = gp:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
gh:SetPoint("TOPLEFT", 12, -322); gh:SetWidth(256); gh:SetJustifyH("LEFT")
gh:SetText("Select objects, Add selected, Save group. Double-click a group to spawn it at your feet.")

-- Emotes tab
local ep = pages[3]
local EMOTES = {{"Stop", 0}, {"Talk", 1}, {"Bow", 2}, {"Wave", 3}, {"Cheer", 4}, {"Exclaim", 5}, {"Question", 6}, {"Eat", 7}, {"Dance", 10}, {"Laugh", 11},
    {"Sleep", 12}, {"Sit", 13}, {"Rude", 14}, {"Roar", 15}, {"Kneel", 16}, {"Kiss", 17}, {"Cry", 18}, {"Chicken", 19}, {"Beg", 20}, {"Applaud", 21},
    {"Shout", 22}, {"Flex", 23}, {"Shy", 24}, {"Point", 25}, {"Salute", 66}, {"Work: mine", 233}, {"Work: smith", 234}, {"Work: chop", 133}}
local estate = false
Btn(ep, "Mode: one-shot", 260, 8, -6, function(self) estate = not estate; self:SetText(estate and "Mode: looping" or "Mode: one-shot") end)
for i, e in ipairs(EMOTES) do
    local col, rw = (i - 1) % 3, math.floor((i - 1) / 3)
    Btn(ep, e[1], 84, 8 + col * 88, -36 - rw * 26, function() Send("E;" .. (estate and "S" or "P") .. ";" .. e[2]) end)
end
local ey = -36 - math.ceil(#EMOTES / 3) * 26 - 4
local eid = CreateFrame("EditBox", nil, ep, "InputBoxTemplate")
eid:SetSize(70, 22); eid:SetPoint("TOPLEFT", 16, ey - 2); eid:SetAutoFocus(false); eid:SetText("0")
Btn(ep, "Emote ID", 100, 96, ey, function() Send("E;" .. (estate and "S" or "P") .. ";" .. (tonumber(eid:GetText()) or 0)) end)

ShowTab(1)
SetKind("c")

-- ---------------------------------------------------------------- server messages
local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    if msg:sub(1, 4) ~= "GMT;" then return end
    local body = msg:sub(5)
    local cmd = body:match("^(%a+)")
    if cmd == "B" then
        local tot, pg = body:match("^B;%a;(%d+);(%d+)")
        total, page = tonumber(tot) or 0, tonumber(pg) or 0
        results = {}; offset = 0; Refresh()
        pageText:SetText((page + 1) .. " / " .. math.max(1, math.ceil(total / PAGE)) .. "  (" .. total .. ")")
        msgText:SetText("Results coming...")
    elseif cmd == "R" then
        local k, id, disp, name = body:match("^R;(%a);(%d+);(%d+);(.*)$")
        local ext = ""
        if k == "g" and name then   -- objects carry the file type before the name: ext;name
            local e, n = name:match("^([%w%?]*);(.*)$")
            if n then ext, name = e, n end
        end
        if id then results[#results + 1] = {id = tonumber(id), display = tonumber(disp), name = name, ext = ext}; Refresh(); msgText:SetText(#results .. " results. Double-click to spawn.") end
    elseif cmd == "SEL" then
        local k, entry, name, x, y, z, o, row = body:match("^SEL;(%a);(%d+);(.-);([%-%d%.]+);([%-%d%.]+);([%-%d%.]+);([%-%d%.]+);(%d+)$")
        if entry then
            x, y, z, o = tonumber(x), tonumber(y), tonumber(z), tonumber(o)
            selText:SetText(string.format("Selected: %s (%s)  db %s\n%.3f, %.3f, %.3f  facing %.1f deg", name, entry, row, x, y, z, math.deg(o)))
            last = {x, y, z, o}; LoadBoxes(x, y, z, o)
        end
    elseif cmd == "DEL" then selText:SetText("Selected: none")
    elseif cmd == "ERR" then msgText:SetText("|cffff5555" .. (body:match("^ERR;(.*)$") or "error") .. "|r")
    elseif cmd == "GB" then groups = {}; RefreshGroups()
    elseif cmd == "GR" then
        local id, n, name = body:match("^GR;(%d+);(%d+);(.*)$")
        if id then groups[#groups + 1] = {id = tonumber(id), n = tonumber(n), name = name}; RefreshGroups() end
    elseif cmd == "GD" then
        local n, note = body:match("^GD;(%d+);?(.*)$")
        draftText:SetText("Draft: " .. (n or 0) .. " objects" .. ((note and note ~= "") and ("  (" .. note .. ")") or ""))
    end
end)

SLASH_WILDCARDGM1 = "/gmt"
SlashCmdList["WILDCARDGM"] = function() f:SetShown(not f:IsShown()) end
f:HookScript("OnShow", function() Send("G;L") end)
