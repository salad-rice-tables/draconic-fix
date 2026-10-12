-- Plays voice lines the server asks for ("VO;<FileDataID>" on the WCARD addon channel), for scripted scenes such as the Diplomacy quest.
-- /vo <id> [channel]   plays a voice file now (channel: Master, Dialog, SFX, Music, Ambience; default Master)
-- /vo debug            toggles a chat line for every request from the server        /vo sound   shows the sound settings that can mute dialog
C_ChatInfo.RegisterAddonMessagePrefix("WCARD")
local debug = false
local CHANNEL = "Master"
local function Play(id, channel)
    local ok, willPlay, handle = pcall(PlaySoundFile, id, channel or CHANNEL)
    if debug then print("|cff00ff96[WildcardVO]|r PlaySoundFile(" .. tostring(id) .. ", " .. tostring(channel or CHANNEL) .. ") -> ok " .. tostring(ok) .. ", willPlay " .. tostring(willPlay) .. ", handle " .. tostring(handle)) end
    return ok and willPlay
end
local function Settings()
    for _, c in ipairs({"Sound_EnableAllSound", "Sound_MasterVolume", "Sound_EnableDialog", "Sound_DialogVolume", "Sound_EnableSFX", "Sound_SFXVolume", "Sound_NumChannels", "Sound_OutputDriverName"}) do
        print(c .. " = " .. tostring(GetCVar(c)))
    end
end
local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(_, event, prefix, msg)
    if event == "PLAYER_LOGIN" then print("|cff00ff96[WildcardVO]|r loaded. /vo <id> [channel] tests a voice file, /vo debug logs, /vo sound shows the sound settings.") return end
    if prefix ~= "WCARD" or type(msg) ~= "string" then return end
    msg = msg:gsub("^WCARD\t", "")
    local id = msg:match("^VO;(%d+)$")
    if id then Play(tonumber(id)) end
end)
SLASH_WILDCARDVO1 = "/vo"
SlashCmdList["WILDCARDVO"] = function(arg)
    arg = arg or ""
    local a, b = arg:match("^(%S*)%s*(%S*)$")
    a = (a or ""):lower()
    if a == "debug" then debug = not debug print("|cff00ff96[WildcardVO]|r debug " .. tostring(debug))
    elseif a == "sound" then Settings()
    elseif tonumber(a) then debug = true Play(tonumber(a), b ~= "" and b or nil)
    else print("/vo <FileDataID> [Master|Dialog|SFX|Music|Ambience]  |  /vo debug  |  /vo sound") end
end
