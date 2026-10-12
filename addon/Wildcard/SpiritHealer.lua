-- Spirit Healer confirmation (server sends SPIRITASK after the gossip option; Accept answers SPIRITRES). The wording is Blizzard's.
local PREFIX = "WCARD"
StaticPopupDialogs["WILDCARD_SPIRIT_RES"] = {
    text = "Remember, if you find your corpse there is no penalty.  Are you sure you want to take up to 25%% durability damage (equipped and inventory) and incur 10 minutes of Resurrection Sickness?",
    button1 = ACCEPT, button2 = CANCEL,
    OnAccept = function() C_ChatInfo.SendAddonMessage(PREFIX, "SPIRITRES", "WHISPER", UnitName("player")) end,
    timeout = 0, whileDead = true, hideOnEscape = true, exclusive = true,
}
local ev = CreateFrame("Frame")
ev:RegisterEvent("CHAT_MSG_ADDON")
ev:SetScript("OnEvent", function(_, _, prefix, msg)
    if prefix ~= PREFIX or type(msg) ~= "string" then return end
    msg = msg:gsub("^" .. PREFIX .. "\t", "")
    if msg == "SPIRITASK" then StaticPopup_Show("WILDCARD_SPIRIT_RES") end
end)
