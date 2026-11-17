-- CoAUI core: atlas helper (CoA atlases are plain files + texcoords, registered through the client's files/ + mappings/ system)
CoAUI = CoAUI or {}
CoAUIDB = CoAUIDB or {}

function CoAUI.SetAtlas(tex, name, useSize)
	local a = CoAUI_Atlas[name]
	if not a then return false end
	tex:SetTexture(a[1])
	tex:SetTexCoord(a[4], a[5], a[6], a[7])
	if useSize then tex:SetSize(a[2], a[3]) end
	return true
end

-- vertical flipbook: frames laid out left->right, top->bottom on a texture of w x h with frames of fw x fh
function CoAUI.SetFlipFrame(tex, atlasName, fw, fh, frame)
	local a = CoAUI_Atlas[atlasName]
	if not a then return end
	local w, h = a[2], a[3]
	local cols = math.floor(w / fw)
	local col, row = (frame - 1) % cols, math.floor((frame - 1) / cols)
	local l, t = col * fw / w, row * fh / h
	tex:SetTexture(a[1])
	tex:SetTexCoord(l, l + fw / w, t, t + fh / h)
end

function CoAUI.PlayerAura(spellID)
	local ok, a = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
	if ok and a then return a end
end

-- movable helper: saved position per frame name
function CoAUI.MakeMovable(f, name)
	f:SetMovable(true); f:EnableMouse(true); f:RegisterForDrag("LeftButton"); f:SetClampedToScreen(true)
	f:SetScript("OnDragStart", function(s) if not InCombatLockdown() then s:StartMoving() end end)
	f:SetScript("OnDragStop", function(s)
		s:StopMovingOrSizing()
		local p, _, rp, x, y = s:GetPoint()
		CoAUIDB[name] = {p, rp, x, y}
	end)
	local pos = CoAUIDB[name]
	if pos then f:ClearAllPoints(); f:SetPoint(pos[1], UIParent, pos[2], pos[3], pos[4]) end
end

-- /spell <text | id> : search the CoA spells (GM spell checker) and print what each does; shift-click a link for the full tooltip
SLASH_COASPELL1 = "/spell"
SlashCmdList.COASPELL = function(msg)
	msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
	if msg == "" then print("|cff66ccff/spell <name or id>|r - search CoA spells"); return end
	local id, n = tonumber(msg), 0
	for _, r in ipairs(CoAUI_SpellIndex or {}) do
		if (id and (r[1] == id or r[1] - 7000000 == id)) or (not id and r[2]:lower():find(msg, 1, true)) then
			n = n + 1
			if n <= 15 then
				local link = (C_Spell.GetSpellLink and C_Spell.GetSpellLink(r[1])) or r[2]
				local desc = (C_Spell.GetSpellDescription and C_Spell.GetSpellDescription(r[1])) or ""
				print(("|cffffd100%d|r %s  |cffaaaaaa%s|r"):format(r[1], link, desc:gsub("\n", " "):sub(1, 220)))
			end
		end
	end
	print(("|cff66ccff%d match(es)|r%s"):format(n, n > 15 and " (first 15 shown)" or ""))
end

-- debug: remember the last cast failures / UI errors in CoAUIDB.errors (read the SavedVariables file after /reload)
local errf = CreateFrame("Frame")
for _, e in ipairs({"UI_ERROR_MESSAGE", "UNIT_SPELLCAST_FAILED", "UNIT_SPELLCAST_FAILED_QUIET", "UNIT_SPELLCAST_INTERRUPTED", "UNIT_SPELLCAST_START", "UNIT_SPELLCAST_SENT"}) do errf:RegisterEvent(e) end
errf:SetScript("OnEvent", function(_, e, a, b, c, d)
	CoAUIDB = CoAUIDB or {}; CoAUIDB.errors = CoAUIDB.errors or {}
	if (e:find("UNIT_SPELLCAST") and a ~= "player") then return end
	table.insert(CoAUIDB.errors, date("%H:%M:%S ") .. e .. " " .. tostring(a) .. " " .. tostring(b) .. " " .. tostring(c) .. " " .. tostring(d))
	while #CoAUIDB.errors > 25 do table.remove(CoAUIDB.errors, 1) end
end)
SLASH_COACHECK1 = "/spellcheck"
SlashCmdList.COACHECK = function(msg)
	local id = tonumber(msg) or 7500970
	local u, nm = C_Spell.IsSpellUsable(id)
	local cd = C_Spell.GetSpellCooldown(id)
	local info = C_Spell.GetSpellInfo(id)
	CoAUIDB = CoAUIDB or {}
	CoAUIDB.check = {id = id, usable = tostring(u), nomana = tostring(nm), cdStart = cd and cd.startTime, cdDur = cd and cd.duration, known = tostring(IsPlayerSpell(id)),
		mana = UnitPower("player", 0) .. "/" .. UnitPowerMax("player", 0), name = info and info.name, castTime = info and info.castTime, minRange = info and info.minRange, maxRange = info and info.maxRange,
		combat = tostring(InCombatLockdown()), dead = tostring(UnitIsDeadOrGhost("player")), mounted = tostring(IsMounted())}
end
