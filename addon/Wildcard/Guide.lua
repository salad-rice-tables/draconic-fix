-- Wildcard Guide: the fourth tab of the Hero windows. Plain Blizzard window with a scrolling text that explains how everything works.
local f, body = WildcardMakeWindow("WildcardGuide", 1080, 680, "Wildcard Guide")
f:SetPoint("CENTER")
f:SetFrameStrata("HIGH")
WildcardTabs(f, 4)
function WildcardGuideShow() f:Show() end
function WildcardGuideHide() f:Hide() end
function WildcardGuideToggle() f:SetShown(not f:IsShown()) end

local scroll = CreateFrame("ScrollFrame", "WildcardGuideScroll", body, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 8, -8); scroll:SetPoint("BOTTOMRIGHT", -30, 8)
local content = CreateFrame("Frame", nil, scroll)
content:SetSize(980, 10)
scroll:SetScrollChild(content)
local text = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
text:SetPoint("TOPLEFT", 8, -4); text:SetWidth(960); text:SetJustifyH("LEFT"); text:SetJustifyV("TOP"); text:SetSpacing(4)

local H, W = "|cffffd100", "|cffffffff"
text:SetText(table.concat({
    H .. "How Wildcard works|r",
    "Every hero collects abilities from every class. You do not pick a class: you roll abilities, keep the ones you like and build your own hero.",
    " ",
    H .. "1. The Dice of Destiny|r",
    "Use the " .. W .. "Dice of Destiny|r item (it is in your bags) or press " .. W .. "N|r. At the start you roll " .. W .. "6 abilities|r: two offensive, two defensive, one mobility and one utility. At every level up the Dice offer " .. W .. "three cards|r of one kind (offense, defense, mobility, healing, buff, control, utility, in rotation). Pick one card to keep it.",
    " ",
    H .. "2. Keep, Reroll and Lock|r",
    "- " .. W .. "Keep|r: the ability goes to your spellbook right away, as the real retail spell.",
    "- " .. W .. "Reroll|r: throws away the cards that are not locked and rolls new ones. You never get the same card again in that reroll.",
    "- " .. W .. "Lock|r: click the lock on a card to keep it on the table while you reroll the others. Locked cards stay as they are.",
    "- You get " .. W .. "5 rerolls|r every level. Up to level 10 rerolls are free. The counter is at the bottom left of the window.",
    " ",
    H .. "3. Rarity|r",
    "Common (grey-white), Uncommon (green), Rare (blue), Epic (purple), Legendary (orange) and Immortal (red). Rarer cards are stronger and appear less often. Rarity also sets how much Essence the spell costs.",
    " ",
    H .. "4. Essence|r",
    "Every ability costs " .. W .. "Essence|r, the one resource all heroes share, no matter which class the spell came from. Weak spells cost a little, strong ones cost more. Essence regenerates when you are not casting.",
    " ",
    H .. "5. Your spellbook|r",
    "Learned abilities show in your normal spellbook (P) and can be dragged onto your action bars like any spell. In Character Advancement (N) you can see all you own. If you do not like an ability you can forget it and roll a new one in its place (it costs a reroll after level 10).",
    " ",
    H .. "6. The other tabs|r",
    "- " .. W .. "Character Advancement|r: your build, your abilities and talents. Classless heroes spend Ability Essence there; Wildcard heroes roll them with the Dice.",
    "- " .. W .. "Mystic Enchants|r: runes and enchants you collect and place on your gear. The Mystic Forge crafts new ones.",
    "- " .. W .. "Skill Cards|r: your starting abilities shown as cards, with the packs of cards you can open.",
    "- " .. W .. "Guide|r: this page.",
    " ",
    H .. "7. Your primary stat|r",
    "You choose Strength, Agility, Intellect or Spirit. It grows with your level and decides how much damage and healing your abilities do. Gear adds more, just as on retail.",
    " ",
    H .. "8. Playing alone or in a group|r",
    "- In a 5-player dungeon with " .. W .. "no other player|r (Manastorm) the creatures are adapted to a lone hero: they have less health and you carry protective boons. In a group everything is exactly as on retail.",
    "- Everything else (quests, loot, professions, world quests) works as on retail.",
    " ",
    H .. "9. Tips|r",
    "- Pick abilities that work together: a way to start fights, a way to survive, a way to move and one utility.",
    "- Lock the cards you like and reroll the rest.",
    "- Use " .. W .. "/essence|r to pick the colour of your Essence bar (" .. W .. "/essence reset|r goes back to the default).",
    "- Use " .. W .. "/bug your text|r to report a problem: it saves where you are and the latest errors. This is a test realm.",
}, "\n"))
content:SetHeight(text:GetStringHeight() + 20)

SLASH_WILDCARDGUIDE1 = "/wcguide"
SlashCmdList["WILDCARDGUIDE"] = WildcardGuideToggle
