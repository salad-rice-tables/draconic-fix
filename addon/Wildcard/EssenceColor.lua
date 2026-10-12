-- Essence bar colour: every player can colour the Essence bar the way he likes. /essence opens the colour picker, /essence reset restores the default.
-- The fill of the bar is a grey texture that the game tints; we tint it with the saved colour (checked once a second, the bar is rebuilt by the game now and then).
local FILL_FILE = 457302   -- interface/unitpowerbaralt/generic1_horizontal_fill
local function Saved() WildcardEssenceDB = WildcardEssenceDB or {}; return WildcardEssenceDB end

local function Tint(frame, r, g, b, depth)
    if not frame or depth > 6 then return end
    for _, region in ipairs({frame:GetRegions()}) do
        if region.GetTextureFileID and region.SetVertexColor and region:GetTextureFileID() == FILL_FILE then region:SetVertexColor(r, g, b) end
    end
    for _, child in ipairs({frame:GetChildren()}) do Tint(child, r, g, b, depth + 1) end
end

local function Apply()
    local c = Saved().color
    if c and PlayerPowerBarAlt then pcall(Tint, PlayerPowerBarAlt, c.r, c.g, c.b, 0) end
end

C_Timer.NewTicker(1, Apply)

SLASH_WILDCARDESSENCE1 = "/essence"
SlashCmdList["WILDCARDESSENCE"] = function(msg)
    msg = (msg or ""):lower()
    if msg:find("reset") then
        Saved().color = nil
        print("|cff00ccff[Essence]|r Colour reset. It returns to the default after /reload.")
        return
    end
    local c = Saved().color or {r = 0.2, g = 0.5, b = 1}
    local function Pick()
        local r, g, b = ColorPickerFrame:GetColorRGB()
        Saved().color = {r = r, g = g, b = b}
        Apply()
    end
    local info = {r = c.r, g = c.g, b = c.b, hasOpacity = false, swatchFunc = Pick, opacityFunc = Pick,
        cancelFunc = function(prev) if prev then Saved().color = {r = prev.r, g = prev.g, b = prev.b}; Apply() end end}
    if ColorPickerFrame.SetupColorPickerAndShow then
        ColorPickerFrame:SetupColorPickerAndShow(info)
    else
        ColorPickerFrame.func, ColorPickerFrame.cancelFunc, ColorPickerFrame.previousValues = Pick, info.cancelFunc, {r = c.r, g = c.g, b = c.b}
        ColorPickerFrame:SetColorRGB(c.r, c.g, c.b); ColorPickerFrame:Show()
    end
end
