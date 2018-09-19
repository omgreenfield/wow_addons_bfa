
local name, SPELLDB = ...
local lower = string.lower
local match = string.match
local remove = table.remove
local GetSpellInfo = GetSpellInfo
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitName = UnitName
local IsInInstance = IsInInstance
local GetNumSubgroupMembers = GetNumSubgroupMembers
local CooldownFrame_Set = CooldownFrame_Set
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo -- new fix

local CommPrefix  = "PABop31ms337x" -- Receive ability and cooldown
local CommPrefix2 = "PABm4d4f4k4l0" -- Send GUID for syncing
local CommPrefix3 = "PABl0lz3r1n4h" -- Receive GUID for syncing

local db
local pGUID
local pName

local PAB = CreateFrame("Frame","PAB",UIParent)
local PABIcons = CreateFrame("Frame",nil,UIParent)
local PABAnchor = CreateFrame("Frame",nil,UIParent)
local PABTooltip = CreateFrame("GameTooltip", "PABGameTooltip", nil, "GameTooltipTemplate")
PABTooltip:SetMinimumWidth(200)
PABTooltip:SetHeight(200)

local iconlist = {}
local anchors = {}
local syncGUIDS = {}
local activeGUIDS = {}

local function print(...)
	for i=1,select('#',...) do
		ChatFrame1:AddMessage("|cff33ff99ATT|r: " .. select(i,...))
	end
end

local InArena = function() return (select(2,IsInInstance()) == "arena") end

local validUnits = {
	["player"] = true,
	["pet"] = true,
	["party1"] = true,
	["party2"] = true,
	["party3"] = true,
	["party4"] = true,
	["partypet1"] = true,
	["partypet2"] = true,
	["partypet3"] = true,
	["partypet4"] = true,
}

local defaultAbilities = {
	["DRUID"] = {
		["ALL"] = {	-- All specs
			{5211, 50}, -- Mighty Bash
		},
		[102] = {	-- Balance
			{78675, 60}, -- Solar Beam
			{22812, 60},    -- Barkskin
		},
		[103] = {	-- Feral
			{106839, 15}, -- Skull Bash
			{61336, 120, 2}, -- Survival Instincts
		},
		[104] = {	-- Guardian
		},
		[105] = {	-- Restoration
			{22812, 60},    -- Barkskin
			{102342, 90}, -- Ironbark
			{203651, 45}, -- Overgrowth
		},
	},
	["HUNTER"] = {
		["ALL"] = {	-- All specs
			{186265, 180}, 	-- Aspect of the Turtle
		},
		[253] = {	-- Beast Mastery
			{187650, 30}, -- Freezing Trap
		},
		[254] = {	-- Marksmanship
			{187650, 30}, -- Freezing Trap
		},
		[255] = {	-- Survival
			{187650, 24}, -- Freezing Trap
		},
	},
	["MAGE"] = 	{
		["ALL"] = {	-- All specs
			{198111, 45, false, talent="honor"}, -- Temporal Shield
			{2139, 24}, 	-- Counterspell
			{45438, 240},   -- Ice Block
			{113724, 45, false, talent="spec"}, -- Ring of Frost
		},
		[62] = {	-- Arcane
		},
		[63] = {	-- Fire
			{31661, 20}, -- Dragon's Breath
			{86949, 300}, -- Cauterize
		},
		[64] = {	-- Frost

		},
	},
	["PALADIN"] = {
		["ALL"] = {	-- All specs
			{853, 30}, 	-- Hammer of Justice
			{66115, 15}, 	-- Hand of Freedom
		},
		[65] = {	-- Holy
			{150630, 300, 2}, -- Hand of Protection
			{6940, 150, 2}, -- Blessing of Sacrifice
			{642, 300}, -- Divine Shield
			{216331, 60, false, talent="spec"}, -- Avenging Crusader
			{31842, 120, false, talent="spec"}, -- Avenging Wrath, is replaced by crusader and should be implicitly hidden
		},
		[70] = {	-- Retribution
			{642, 240}, -- Divine Shield
			{96231, 15},  -- Rebuke
			{150630, 300}, -- Hand of Protection
		},
	},
	["PRIEST"] = {
		["ALL"] = {	-- All specs
			
		},
		[256] = {	-- Discipline		
			{8122, 30}, 	-- Psychic Scream
			{33206, 210},	-- Pain Suppression
			{62618, 180}, -- Power Word: Barrier
		},
		[257] = {	-- Holy
			{213602, 30}, -- Greater Fade
			{197268, 45}, -- Ray of Hope
			{47788, 240}, -- Guardian Spirit
		},
		[258] = {	-- Shadow
			{47585, 120},  	-- Dispersion
			{8122, 30}, 	-- Psychic Scream
			{15487, 45},   	-- Silence
		},
	},
	["ROGUE"] = {
		["ALL"] = {	-- All specs
			{1766, 15}, 	-- Kick
			{2094, 120}, 	-- Blind
			{31224, 90},   	-- Cloak of Shadows
		},
		[259] = {	-- Assassination
			{5277, 120}, -- Evasion
		},
		[260] = {	-- Combat
		},
		[261] = {	-- Subtlety
			{5277, 120}, -- Evasion
			{76577, 180, false, talent="honor"},  -- Smoke Bomb
		},
	},
	["SHAMAN"] = {
		["ALL"] = {	-- All specs
			{108271, 90}, -- Astral Shift
			{57994, 12}, 	-- Wind Shear
		},
		[262] = {	-- Elemental
		},
		[263] = {	-- Enhancement
		},
		[264] = {	-- Restoration
			{98008, 180},   -- Spirit Link Totem
		},
	},
	["WARLOCK"] = {
		["ALL"] = {	-- All specs
			{19647, 24}, 	-- Spell Lock
			{104773, 180}, -- Unending Resolve
			{6789, 45, false, talent="spec"}, -- Mortal Coil
			{108416, 60, false, talent="spec"}, -- Dark Pact
			{212295, 45, false, talent="honor"}, -- Nether Ward
		},
		[265] = {	-- Affliction
		},
		[266] = {	-- Demonology
		},
		[267] = {	-- Destruction
		},
	},
	["WARRIOR"] = {
		["ALL"] = {	-- All specs
			{6552, 15}, 	-- Pummel
			{236077, 30, false, talent="honor"}, -- Disarm
			{107570, 30, false, talent="spec"}, -- Storm Bolt
		},
		[71] = {	-- Arms
			{5246, 90}, 	-- Intimidating Shout
			{118038, 180}, -- Die by the Sword
		},
		[72] = {	-- Fury
			{5246, 90}, 	-- Intimidating Shout
		},
		[73] = {	-- Protection
		},
	},
	["DEATHKNIGHT"] = {
		["ALL"] = {	-- All specs
			{47528, 15}, 	-- Mind Freeze
			{48707, 60},   	-- Anti-Magic Shell
			{48792, 180}, -- Icebound Fortitude
		},
		[250] = {	-- Blood
		},
		[251] = {	-- Frost
			{212552, 45}, -- Wraith Walk
		},
		[252] = {	-- Unholy
			{108194, 45}, -- Asphyxiate
			{47482, 30}, -- Leap (Interrupt pet)
		},
	},
	["MONK"] = {
		["ALL"] = {	-- All specs
			{119996, 25}, -- Transcendence:Transfer (Monk port)
			{119381, 45, false, talent="spec"}, -- Leg Sweep
		},
		[268] = {	-- Brewmaster
		},
		[269] = {	-- Windwalker
			{116705, 15}, -- Spear Hand Strike
			{122470, 90}, -- Touch of Karma
		},
		[270] = {	-- Mistweaver
			{116849, 180}, 	-- Life Cocoon
		},
	},
	["DEMONHUNTER"] = {
		["ALL"] = {
			{198589, 60}, -- Blur
			{183752, 15}, -- Consume Magic
			{217832, 15}, -- Imprison
		},
		[577] = { -- Havoc

		},
		[581] = { -- Vengeance

		},
	}
}

-- Localized names:
local PvPTrinketName = GetSpellInfo(208683)
local EveryManForHimselfName = GetSpellInfo(59752) 
local StoneformName = GetSpellInfo(20594)
local AdaptedName = GetSpellInfo(195756)
local WillOfTheForsakenName = GetSpellInfo(7744)

local PvPTrinket = { ability = PvPTrinketName, cooldown = 120, id = 208683 }


local function convertspellids(t)
	local temp = {}
	for class, table in pairs(t) do
		temp[class] = {}
		for spec, spells in pairs(table) do
			spec = tostring(spec)
			temp[class][spec] = {}
			for k, spell in pairs(spells) do
				local spellInfo = GetSpellInfo(spell[1])
				if spellInfo then temp[class][spec][#temp[class][spec]+1] = { ability = spellInfo, cooldown = spell[2], id = spell[1], maxcharges = spell[3], talent = spell.talent } end
			end
		end
	end
	return temp
end

defaultAbilities = convertspellids(defaultAbilities)



local cooldownResetters = {
	[11958] = { -- Cold Snap
		[120] = 1, 		-- Cone of Cold
		[45438] = 1,  	-- Ice Block
		[122] = 1, 		-- Frost Nova
	},
}

local temp = {}
for k, v in pairs(cooldownResetters) do
	local spellInfo = GetSpellInfo(k)
	if spellInfo then
		temp[spellInfo] = {}
		if type(v) == "table" then
			for id in pairs(v) do
				local spellInfo2 = GetSpellInfo(id)
				if spellInfo2 then temp[spellInfo][spellInfo2] = 1 end
			end
		else
			temp[GetSpellInfo(k)] = v
		end
	end
end

cooldownResetters = temp
temp = nil
convertspellids = nil



-- Inspection stuff (Based on PABR):
local inspected = {}
local inspect_queue = {}
local nextInspectTick = 0

local supportedUnits = { "party1", "party2", "party3", "party4", "player" }
local function PABFindUnitByGUID(guid)
	if guid then
		for i, unit in pairs(supportedUnits) do
			if UnitGUID(unit) == guid then
				return unit
			end
		end
	end
end

function PAB:GetSpecByGUID(guid)
	return inspected[guid]
end

function PAB:GetSpecByUnit(unit)
	local guid = UnitGUID(unit)
	if guid then return inspected[guid] end
end

function PAB:QueueInspect(unit)
	local guid = UnitGUID(unit)
	if guid then
		self:DequeueInspectByGUID(guid)
		inspect_queue[#inspect_queue+1] = guid
	end
end

function PAB:DequeueInspectByGUID(guid)
	for i=#inspect_queue, 1, -1 do
		if inspect_queue[i] == guid then
			table.remove(inspect_queue, i)
		end
	end
end

function PAB:InspectPlayer()
	self:InspectIsReady(UnitGUID("player"))
end

function PAB:InspectIsReady(guid)
	local inspectedUnit = PABFindUnitByGUID(guid)
	if not inspectedUnit then return end
	local isInspect = inspectedUnit ~= "player"

	self:DequeueInspectByGUID(guid)

	if isInspect then
		inspected[guid] = GetInspectSpecialization(inspectedUnit) or 0
		self:UpdateAnchors()
	else
		local spec = GetSpecialization()
		if spec then
			inspected[guid] = GetSpecializationInfo(spec) or 0
		end
	end
end

function PAB:EnqueueInspect()
	table.wipe(inspect_queue)
	for i=1, GetNumGroupMembers() do
		self:QueueInspect("party"..i)
	end
end

function PAB:ProcessInspectQueue()
	if GetTime() > nextInspectTick then
		nextInspectTick = GetTime() + 1

		self:InspectPlayer()

		for i, guid in pairs(inspect_queue) do
			local unit = PABFindUnitByGUID(guid)
			if unit and CanInspect(unit) and not (InspectFrame and InspectFrame:IsShown()) then
				NotifyInspect(unit)
				break
			end
		end
	end
end

function PAB:INSPECT_READY(guid)
	self:InspectIsReady(guid)
end

hooksecurefunc("NotifyInspect", function(unit) nextInspectTick = GetTime() + 3 end)




function PAB:SavePositions()
	for k,anchor in ipairs(anchors) do
		local scale = anchor:GetEffectiveScale()
		local worldscale = UIParent:GetEffectiveScale()
		local x = anchor:GetLeft() * scale
		local y = (anchor:GetTop() * scale) - (UIParent:GetTop() * worldscale)
	
		if not db.positions[k] then
			db.positions[k] = {}
		end
	
		db.positions[k].x = x
		db.positions[k].y = y
	end
end

function PAB:FindCompactRaidFrameByUnit(unit)
	if not unit or not UnitGUID(unit) then return end
	for i=1, 5 do
		local frame = _G["CompactRaidFrame"..i]
		if frame and frame.unit and UnitGUID(frame.unit) == UnitGUID(unit) then
			return frame:GetName()
		end
	end
end

function PAB:LoadPositions()
	db.positions = db.positions or {}
	for k,anchor in ipairs(anchors) do
		anchors[k]:ClearAllPoints()
		local raidFrame
		if db.attach then raidFrame = self:FindCompactRaidFrameByUnit(k==5 and "player" or "party"..k) end
		if raidFrame then
			anchors[k]:SetPoint(db.growLeft and "BOTTOMLEFT" or "BOTTOMRIGHT", raidFrame, db.growLeft and "TOPLEFT" or "TOPRIGHT", db.offsetX, db.offsetY)
		else
			if db.positions[k] then
				local x = db.positions[k].x
				local y = db.positions[k].y
				local scale = anchors[k]:GetEffectiveScale()
				anchors[k]:SetPoint("TOPLEFT", UIParent,"TOPLEFT", x/scale, y/scale)
			else
				anchors[k]:SetPoint("CENTER", UIParent, "CENTER")
			end
		end
	end
end

local backdrop = {bgFile="Interface\\Tooltips\\UI-Tooltip-Background", edgeFile="", tile=false,}
function PAB:CreateAnchors()
	for i=1,5 do
		local anchor = CreateFrame("Frame","PABAnchor"..i ,PABAnchor)
		anchor:SetBackdrop(backdrop)
		anchor:SetHeight(15)
		anchor:SetWidth(15)
		anchor:SetBackdropColor(1,0,0,1)
		anchor:EnableMouse(true)
		anchor:SetMovable(true)
		anchor:Show()
		anchor.icons = {}
		anchor.HideIcons = function() for k,icon in ipairs(anchor.icons) do icon:Hide(); icon.inUse = nil end end
		anchor:SetScript("OnMouseDown",function(self,button) if button == "LeftButton" and not db.attach then self:StartMoving() end end)
		anchor:SetScript("OnMouseUp",function(self,button) if button == "LeftButton" and not db.attach then self:StopMovingOrSizing(); PAB:SavePositions() end end)
		anchors[i] = anchor
		
		local index = anchor:CreateFontString(nil,"ARTWORK","GameFontNormal")
		index:SetPoint("CENTER")
		index:SetText(i)
	end
end

-- creates a new raw frame icon that can be used/reused to show cooldowns
local function CreateIcon(anchor)
	local icon = CreateFrame("Frame",anchor:GetName().."Icon".. (#anchor.icons+1),PABIcons)
	icon:SetHeight(30)
	icon:SetWidth(30)

	local cd = CreateFrame("Cooldown",icon:GetName().."Cooldown",icon,"CooldownFrameTemplate")
	icon.cd = cd
	
	icon.Start = function(sentCD, startNextRecharge)
		icon.cooldown = tonumber(sentCD)
		if icon.maxcharges then
			local charges = tonumber(icon.chargesText:GetText():match("^[0-9]+$"))
			charges = charges - 1
			if charges ~= 0 or startNextRecharge then
				CooldownFrame_Set(cd, GetTime(), icon.cooldown, 1, 1, icon.maxcharges)
				icon.cd:SetDrawEdge(true)
				icon.cd:SetDrawSwipe(false)
				icon.starttime = GetTime()
			elseif charges == 0 and not startNextRecharge then
				CooldownFrame_Set(cd, icon.starttime, icon.cooldown, 1)
				icon.cd:SetDrawEdge(false)
				icon.cd:SetDrawSwipe(true)
				--icon.starttime = GetTime()
			end
			if not startNextRecharge then
				icon.chargesText:SetText(charges and charges <= 0 and 0 or charges)
			end

			--[[
			if charges == icon.maxcharges or startNextRecharge then
				CooldownFrame_Set(cd,GetTime(),icon.cooldown, 1, 1, icon.maxcharges)
				icon.cd:SetDrawEdge(true)
				icon.cd:SetDrawSwipe(false)
				icon.starttime = GetTime()
			end
			if not startNextRecharge then
				charges = charges - 1
				icon.chargesText:SetText(charges and charges <= 0 and 0 or charges)
			end
			if charges == 0 then
				icon.cd:SetDrawEdge(true)
				icon.cd:SetDrawSwipe(true)
			end
			]]
		else
			CooldownFrame_Set(cd,GetTime(),icon.cooldown, 1)
			icon.starttime = GetTime()
		end
		icon:Show()
		icon.active = true;

        activeGUIDS[icon.GUID] = activeGUIDS[icon.GUID] or {}
		activeGUIDS[icon.GUID][icon.ability] = activeGUIDS[icon.GUID][icon.ability] or {}
		activeGUIDS[icon.GUID][icon.ability].starttime = icon.starttime
		activeGUIDS[icon.GUID][icon.ability].cooldown =  icon.cooldown
	end
	
	icon.Stop = function()
		CooldownFrame_Set(cd,0,0,0);
		icon.starttime = 0
	end
	
	icon.SetTimer = function(starttime,cooldown)
		CooldownFrame_Set(cd,starttime,cooldown,1)
		icon.active = true
		icon.starttime = starttime
		icon.cooldown = cooldown
	end
	
	local texture = icon:CreateTexture(nil,"ARTWORK")
	texture:SetAllPoints(true)
	
	icon.texture = texture

	PAB:ApplyIconTextureBorder(icon)

	icon.chargesText = icon:CreateFontString(nil, "string", "GameFontNormal")
	icon.chargesText:SetTextColor(1, 1, 1)
	icon.chargesText:SetText("")
	icon.chargesText:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT")

	-- tooltip:
	icon:EnableMouse()
	icon:SetScript('OnEnter', function()
		if db.showTooltip and icon.abilityID then
			PABTooltip:ClearLines()
			PABTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR")
			PABTooltip:SetSpellByID(icon.abilityID)
		end
	end)
	icon:SetScript('OnLeave', function()
		if db.showTooltip and icon.abilityID then
			PABTooltip:ClearLines()
			PABTooltip:Hide()
		end
	end)

	return icon
end

-- adds a new icon to icon list of anchor
function PAB:AddIcon(icons,anchor)
	local newicon = CreateIcon(anchor)
	iconlist[#iconlist+1] = newicon
	icons[#icons+1] = newicon
	return newicon
end

-- applies texture border to an icon
function PAB:ApplyIconTextureBorder(icon)
    if db.showIconBorders then
		icon.texture:SetTexCoord(0,1,0,1)
	else
		icon.texture:SetTexCoord(0.07,0.9,0.07,0.90)
	end
end

-- hides anchors currently not in use due to too few party members
function PAB:ToggleAnchorDisplay()
	-- Player (Test):
	if db.showSelf and anchors[5] then anchors[5]:Show() end
	-- Party members:
	for i=1,GetNumSubgroupMembers() do anchors[i]:Show() end

	for k=GetNumSubgroupMembers()+1,4 do
		anchors[k]:Hide()
		anchors[k].HideIcons()
	end
	if not db.showSelf and anchors[5] then
		anchors[5]:Hide()
		anchors[5]:HideIcons()
	end
end

-- shuffles raw icon frames around on group update, changed settings, etc
-- also sets attributes for each icon frame
function PAB:UpdateAnchor(unit, i)
		local _,class = UnitClass(unit)
        local guid = UnitGUID(unit)
		if not class or not guid then return end

		local anchor = anchors[i]
		anchor.GUID = guid
		anchor.class = class
		local icons = anchor.icons 
		local numIcons = 1
		-- PvP Trinket:
		if db.showTrinket then
			local ability, id, cooldown = PvPTrinket.ability, PvPTrinket.id, PvPTrinket.cooldown
			local icon = icons[numIcons] or self:AddIcon(icons,anchor)
			icon.texture:SetTexture(self:FindAbilityIcon(ability, id))
			icon.GUID = anchor.GUID
			icon.ability = ability
			icon.abilityID = id
			icon.cooldown = cooldown
			icon.showing = true
			icon.inUse = true
            icon.spec = nil

			PAB:ApplyIconTextureBorder(icon)

			activeGUIDS[icon.GUID] = activeGUIDS[icon.GUID] or {}
			if activeGUIDS[icon.GUID][icon.ability] then
				icon.SetTimer(activeGUIDS[icon.GUID][ability].starttime,activeGUIDS[icon.GUID][ability].cooldown)
			else
				icon.Stop()
			end
			numIcons = numIcons + 1
		elseif icons[1] and icons[1].ability == PvPTrinketName then
			icons[1]:Hide()
			icons[1].showing = nil
			icons[1].inUse = nil
            icons[1].spec = nil
			table.remove(icons, 1)
		end
		-- Abilities [All Specs]:
		for abilityIndex, abilityTable in pairs(db.abilities[class]["ALL"]) do
			local ability, id, cooldown, maxcharges, talent = abilityTable.ability, abilityTable.id, abilityTable.cooldown, abilityTable.maxcharges, abilityTable.talent
			local icon = icons[numIcons] or self:AddIcon(icons,anchor)
			icon.texture:SetTexture(self:FindAbilityIcon(ability, id))
			icon.GUID = anchor.GUID
			icon.ability = ability
			icon.abilityID = id
			icon.cooldown = cooldown
			icon.maxcharges = maxcharges
			icon.chargesText:SetText(maxcharges or "")
			icon.inUse = true
            icon.spec = talent

			PAB:ApplyIconTextureBorder(icon)

			activeGUIDS[icon.GUID] = activeGUIDS[icon.GUID] or {}
			if activeGUIDS[icon.GUID][icon.ability] then
				icon.SetTimer(activeGUIDS[icon.GUID][ability].starttime,activeGUIDS[icon.GUID][ability].cooldown)
			else
				icon.Stop()
			end
			numIcons = numIcons + 1
		end
		-- Abilities [Current Spec]:
		local unitSpec = tostring(self:GetSpecByGUID(anchor.GUID))
		if unitSpec and unitSpec ~= "0" and unitSpec ~= "ALL" and unitSpec ~= "nil" then
			for abilityIndex, abilityTable in pairs(db.abilities[class][unitSpec]) do
				local ability, id, cooldown, maxcharges, talent = abilityTable.ability, abilityTable.id, abilityTable.cooldown, abilityTable.maxcharges, abilityTable.talent
				local icon = icons[numIcons] or self:AddIcon(icons,anchor)
				icon.texture:SetTexture(self:FindAbilityIcon(ability, id))
				icon.GUID = anchor.GUID
				icon.ability = ability
				icon.abilityID = id
				icon.cooldown = cooldown
				icon.maxcharges = maxcharges
				icon.chargesText:SetText(maxcharges or "")
				icon.inUse = true
				icon.spec = talent

				PAB:ApplyIconTextureBorder(icon)

				activeGUIDS[icon.GUID] = activeGUIDS[icon.GUID] or {}
				if activeGUIDS[icon.GUID][icon.ability] then
					icon.SetTimer(activeGUIDS[icon.GUID][ability].starttime,activeGUIDS[icon.GUID][ability].cooldown)
				else
					icon.Stop()
				end
				numIcons = numIcons + 1
			end
		end

		-- clean leftover icons
		for j=numIcons,#icons do
			icons[j].spec = nil
			icons[j].seen = nil
			icons[j].active = nil
			icons[j].inUse = nil
			icons[j].showing = nil
		end

		self:ToggleIconDisplay(i)
end

-- responsible for actual anchoring of icons
function PAB:ToggleIconDisplay(i)
	local anchor = anchors[i]
	local icons = anchor.icons
	local count = 1
	local lastActiveIndex = 0;
	-- hiding all icons before anchoring and deciding whether to show them
	for k, icon in pairs(icons) do
		if icon and icon.ability and icon.inUse then
			if icon.spec then
				icon.showing = (not db.hidden and icon.seen) or (db.hidden and activeGUIDS[icon.GUID][icon.ability] and icon.active)
			else
				icon.showing = (activeGUIDS[icon.GUID] and activeGUIDS[icon.GUID][icon.ability] and icon.active) or (not db.hidden)
			end
		end
		icon:ClearAllPoints()
		icon:Hide()
	end

	for k, icon in pairs(icons) do
		if icon and icon.ability and icon.showing then
		    if db.iconOffsetX == nil then
                db.iconOffsetX = "0"
            end
			if count == 1 then
				icon:SetPoint(db.growLeft and "TOPRIGHT" or "TOPLEFT", anchor, db.growLeft and "BOTTOMLEFT" or "BOTTOMRIGHT", db.growLeft and -1 * db.iconOffsetX or db.iconOffsetX, 0)
			else
				icon:SetPoint(db.growLeft and "RIGHT" or "LEFT", icons[lastActiveIndex], db.growLeft and "LEFT" or "RIGHT", db.growLeft and -1 * db.iconOffsetX or db.iconOffsetX, 0)
			end
			lastActiveIndex = k
			count = count + 1
			icon:Show()
		end
	end
	--self:ToggleAnchorDisplay()
end

function PAB:UpdateAnchors()
	-- Player (Test):
	if db.showSelf and anchors[5] then self:UpdateAnchor("player", 5) end
	-- Party members:
	for i=1, GetNumSubgroupMembers() do
		local unit = "party"..i
		self:UpdateAnchor(unit, i)
	end

	self:ToggleAnchorDisplay()
	self:ApplyAnchorSettings()
end

function PAB:UpdateIcons()
	-- Player (Test):
	if db.showSelf and anchors[5] then self:ToggleIconDisplay(5) end
	-- Party members:
	for i=1, GetNumSubgroupMembers() do
		self:ToggleIconDisplay(i)
	end
end

function PAB:ApplyAnchorSettings()
	PABIcons:SetScale(db.scale or 1)
	
	if db.arena then
		if InArena() then
			PABIcons:Show()
		else
			PABIcons:Hide()
		end
	else
		PABIcons:Show()
	end

	self:UpdateIcons()

	if db.lock then PABAnchor:Hide() else PABAnchor:Show() end
end

function PAB:GroupUpdate()
	self:InspectPlayer()
	self:EnqueueInspect()
	if not pGUID then pGUID = UnitGUID("player") end
	if not pName then pName = UnitName("player") .. "-" .. GetRealmName() end
	self:LoadPositions()
	self:RequestSync()
	self:UpdateAnchors()
end

function PAB:GROUP_JOINED()
	self:GroupUpdate()
end

function PAB:GROUP_ROSTER_UPDATE()
	self:GroupUpdate()
end

function PAB:UNIT_OTHER_PARTY_CHANGED()
	self:GroupUpdate()
end

function PAB:PLAYER_ENTERING_WORLD()
	self:InspectPlayer()
	self:EnqueueInspect()
	if InArena() then self:StopAllIcons() end -- Cooldowns reset when joining arena
	if not pGUID then pGUID = UnitGUID("player") end
	if not pName then pName = UnitName("player") .. "-" .. GetRealmName() end
	self:LoadPositions()
	self:RequestSync()
	self:UpdateAnchors()
end



function PAB:COMBAT_LOG_EVENT_UNFILTERED()
    local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName, spellSchool, auraType = CombatLogGetCurrentEventInfo()

		if(event == "SPELL_CAST_SUCCESS" ) then
		 self:StartCooldown(spellName, self:GetUnitByGUID(sourceGUID))
	end
	    if(event == "SPELL_AURA_APPLIED" ) then
		self:StartCooldown(spellName, self:GetUnitByGUID(sourceGUID))
	end
end

function PAB:FindAbilityByName(abilities, name)
	if abilities then
		for i, v in pairs(abilities) do
			if v and v.ability and v.ability == name then return v, i end
		end
	end
end

function PAB:GetUnitByGUID(guid)
	for k,v in pairs(validUnits) do
		if UnitGUID(k) == guid then
			return k
		end
	end
end

function PAB:StartCooldown(spellName, unit, cooldown)
	if not unit then return end -- in case unit is bugged
	local index = match(unit, "party[pet]*([1-4])")

	if unit == "player" or unit == "pet" then
		if(not db.showSelf ) then return end
		unit = "player"
		index = 5
	elseif index then
		unit = "party"..index
	end

	local anchor = anchors[tonumber(index)]
	if not anchor or not index then return end

	local _,class = UnitClass(unit)
	local spec = tostring(self:GetSpecByUnit(unit))
	local cAbility = self:FindAbilityByName(db.abilities[class]["ALL"], spellName) or self:FindAbilityByName(db.abilities[class][spec], spellName) 
	if cooldown and cAbility then cAbility.cooldown = cooldown end
	local start, duration, enabled = GetSpellCooldown(PvPTrinketName);
    -- trinket fix 
    	if  spellName == PvPTrinketName then
		spellName = PvPTrinketName
		cAbility = {cooldown = 120}
	end
	-- 30 second trinket trigger

	if  spellName == EveryManForHimselfName then
		spellName = PvPTrinketName
		cAbility = {cooldown = 90}
	end

	if spellName == AdaptedName then
		spellName = PvPTrinketName
		cAbility = {cooldown = 60}
	end
	if (duration ) then
		if  spellName == WillOfTheForsakenName  then
if ( start > 0 and duration > 0) then
 spellName = PvPTrinketName
  duration = start + duration - GetTime()
 cAbility = {cooldown = duration }
else
 spellName = PvPTrinketName
 cAbility = {cooldown = 30}
end
	end
	if  spellName == StoneformName  then
if ( start > 0 and duration > 0) then
 spellName = PvPTrinketName
  duration = start + duration - GetTime()
 cAbility = {cooldown = duration }
else
 spellName = PvPTrinketName
 cAbility = {cooldown = 30}
end
	end
	    
end
	self:TrackCooldown(anchor, spellName, cAbility and cAbility.cooldown or nil)
end

function PAB:TrackCooldown(anchor, ability, cooldown)
	for k,icon in ipairs(anchor.icons) do
		if cooldown then
			-- Direct cooldown
			if icon.ability == ability and (not icon.maxcharges) then
				icon.seen = true
				icon.Start(cooldown)
			end		
		end
		-- Cooldown resetters
		if cooldownResetters[ability] then
			if type(cooldownResetters[ability]) == "table" then
				--for k in pairs(cooldownResetters[ability]) do if k == icon.ability then icon.Stop(); break end end
				if cooldownResetters[ability][icon.ability] then icon.Stop() end
			else
				icon.Stop()
			end
		end
	end
end



function PAB:UNIT_SPELLCAST_SUCCEEDED(unit, ability)
	if (unit == "player" or unit == "pet") and ability then self:SendCooldown(ability) end

	if ability then
		self:StartCooldown(ability, unit);
	end
end

local timers, timerfuncs, timerargs = {}, {}, {}
function PAB:Schedule(duration,func,...)
	timers[#timers+1] = duration
	timerfuncs[#timerfuncs+1] = func
	timerargs[#timerargs+1] = {...}
end

local time = 0
local function PAB_OnUpdate(self,elapsed)
	time = time + elapsed
	if time > 0.05 then
		-- Inspection stuff:
		PAB:ProcessInspectQueue()
		--  Update icon activity
		for k,icon in ipairs(iconlist) do
			if icon.active then
				icon.timeleft = icon.starttime + icon.cooldown - GetTime()
				if icon.timeleft <= 0 then
					if not icon.showing then icon:Hide() end
					if activeGUIDS[icon.GUID] then activeGUIDS[icon.GUID][icon.ability] = nil end -- There was error when activeGUIDS[icon.GUID] is nil
					icon.active = nil
					if icon.maxcharges then
						local charges = tonumber(icon.chargesText:GetText():match("^[0-9]+$"))
						charges = math.min(icon.maxcharges, charges+1)
						icon.chargesText:SetText(charges)
						if charges < icon.maxcharges then
							icon.Start(icon.cooldown, true)
						end
					end
				end
			end
		end
		PAB:UpdateIcons()
		
		-- Update Timers
		if #timers > 0 then
			for i=#timers,1,-1 do 
				timers[i] = timers[i] - 0.05
				if timers[i] <= 0 then
					remove(timers,i)
					remove(timerfuncs,i)(PAB,unpack(remove(timerargs,i)))
				end
			end
		end
		
		time = 0
	end
end

-- resets all icons on zone change
function PAB:StopAllIcons()
	for k,v in ipairs(iconlist) do
		v.Stop()
		v.seen = nil
	end
	wipe(activeGUIDS)
end

function PAB:RequestSync()
	wipe(syncGUIDS)
	if self.useCrossAddonCommunication then self:SendAddonMessage(CommPrefix2, pGUID .. "|" .. GetTime(), "PARTY") end
end

function PAB:CHAT_MSG_ADDON(prefix, message, dist, sender)
	if dist == "PARTY" and sender ~= pName then
		--if dist == "PARTY" then -- debug only
		if prefix == CommPrefix then
			local GUID, ability, cooldown, spellID = match(message,"(.+)|(.+)|(.+)|(.+)")
			if syncGUIDS[GUID] then
				self:StartCooldown(GetSpellInfo(spellID), self:GetUnitByGUID(GUID), cooldown)
			end
		elseif prefix == CommPrefix2 then
			local GUID, guidTime = match(message, "(.+)|(.+)")
			self:SendAddonMessage(CommPrefix3, pGUID, "PARTY")
		elseif prefix == CommPrefix3 then
			for i=1, GetNumSubgroupMembers() do if UnitGUID("party"..i) == message then syncGUIDS[message] = anchors[i] end end
			if UnitGUID("player") == message then syncGUIDS[message] = anchors[5] end  	-- debug only
		end
	end
end

function PAB:SendAddonMessage(prefix, message, dest, target)
	--thanks Jax!
	local chl = strlower(dest)
	if (chl == "raid" and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0) or (chl == "party" and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) == 0) or (chl == "guild" and not IsInGuild()) then
		return
	end
	SendAddonMessage(prefix, message, dest, target)
end

-- sends message to your party via addon communication
function PAB:SendCooldown(ability)
	if not self.useCrossAddonCommunication then return end
	local start, duration, enabled = GetSpellCooldown(ability)
	--print("Sending: " .. ability .. " | " .. start + duration - GetTime())
	if not start then return end
	local spellID = select(7, GetSpellInfo(ability))
	-- events can fire before GetSpellCooldown actually returns anything, these events are then scheduled to be checked again
	if enabled == 0 then
		self:Schedule(0.05, self.SendCooldown, ability)
		return
	elseif start > 0 and duration > 0 then
		self:SendAddonMessage(CommPrefix, pGUID .. "|" .. ability .. "|" .. (start + duration - GetTime()) .. "|" .. spellID, "PARTY")
	end
end

local function PAB_OnLoad(self)

	if C_ChatInfo.RegisterAddonMessagePrefix(CommPrefix) and C_ChatInfo.RegisterAddonMessagePrefix(CommPrefix2) and C_ChatInfo.RegisterAddonMessagePrefix(CommPrefix3) then
		self.useCrossAddonCommunication = true
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("GROUP_JOINED")
	self:RegisterEvent("GROUP_ROSTER_UPDATE")
	self:RegisterEvent("UNIT_OTHER_PARTY_CHANGED")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	if self.useCrossAddonCommunication then self:RegisterEvent("CHAT_MSG_ADDON") end
	self:RegisterEvent("INSPECT_READY")
	self:SetScript("OnEvent",function(self,event,...) if self[event] then self[event](self,...) end end)
	
	PABDB = PABDB or { abilities = defaultAbilities, scale = 1  }
	db = PABDB

	self:CreateAnchors()
	self:UpdateAnchors()
	self:LoadPositions()
	self:CreateOptions()

	if not db.classSelected then db.classSelected = "WARRIOR" end
	self:UpdateScrollBar()
	
	self:SetScript("OnUpdate",PAB_OnUpdate)

	-- thanks BigDebuffs
	hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
		local name = frame:GetName()
		if not name or not name:match("^Compact") or not db.attach then return end
		for k,anchor in ipairs(anchors) do
			local raidFrame = PAB:FindCompactRaidFrameByUnit(k==5 and "player" or "party"..k)
			if name == raidFrame then
				anchors[k]:ClearAllPoints()
				anchors[k]:SetPoint(db.growLeft and "BOTTOMLEFT" or "BOTTOMRIGHT", raidFrame, db.growLeft and "TOPLEFT" or "TOPRIGHT", db.offsetX, db.offsetY)
			end
		end
	end)

	
	print("Arena Team Tracker updated by Izy. Type /att to open options")
end

function PAB:FindAbilityIcon(ability, id)
	local icon;
	if id then
		icon = GetSpellTexture(id)
	else
		icon = GetSpellTexture(self:FindAbilityID(ability))
	end
	return icon
end

function PAB:FindAbilityID(ability)
	for _,S in pairs(SPELLDB) do
		for _,v in pairs(S) do
			for _,sp in pairs(v) do
				for _,SPELLID in pairs(sp) do
					local spellName, spellRank, spellIcon = GetSpellInfo(SPELLID)
					if(spellName == ability) then
						return SPELLID
					end
				end
			end
		end
	end
end

function PAB:FormatAbility(s)
	s = s:gsub("(%a)(%a*)('*)(%a*)", function (a,b,c,d) return a:upper()..b:lower()..c..d:lower() end)
	s = s:gsub("(The)", string.lower)
	s = s:gsub("(Of)", string.lower)
	return s
end

-------------------------------------------------------------
-- Options
-------------------------------------------------------------

local SO = LibStub("LibSimpleOptions-1.01")

local function CreateListButton(parent,index)
	local button = CreateFrame("Button",parent:GetName()..index,parent)
	
	button:SetWidth(130)
	button:SetHeight(16)
	local font = CreateFont("PABListFont")
	font:SetFont(GameFontNormal:GetFont(),12)
	font:SetJustifyH("LEFT")
	button:SetNormalFontObject(font)
	button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight","ADD")
	button:SetScript("OnClick",function(self) parent.currentButton = self:GetText(); PAB:UpdateScrollBar() end)
	return button
end

local function CreateEditBox(name,parent,width,height)
	local editbox = CreateFrame("EditBox",parent:GetName()..name,parent,"InputBoxTemplate")
	editbox:SetHeight(height)
	editbox:SetWidth(width)
	editbox:SetAutoFocus(false)
	
	local label = editbox:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
	label:SetText(name)
	label:SetPoint("BOTTOMLEFT", editbox, "TOPLEFT",-3,0)
	return editbox
end

function PAB:CreateOptions()
	local panel = SO.AddOptionsPanel("ATT", function() end)
	self.panel = panel
	SO.AddSlashCommand("ATT","/att")
	local title, subText = panel:MakeTitleTextAndSubText("Arena Team Tracker: Battle for Azeroth","General settings")
	local scale = panel:MakeSlider(
	     'name', 'Scale',
	     'description', 'Adjust the scale of icons',
	     'minText', '0.1',
	     'maxText', '5',
	     'minValue', 0.1,
	     'maxValue', 5,
	     'step', 0.05,
	     'default', 1,
	     'current', db.scale,
	     'setFunc', function(value) db.scale = value; PAB:ApplyAnchorSettings() end,
	     'currentTextFunc', function(value) return string.format("%.2f",value) end)
	scale:SetPoint("TOPLEFT",subText,"TOPLEFT",16,-32)

	local attach = panel:MakeToggle(
	     'name', 'Attach to raid frames',
	     'description', 'Attach to Blizzard raid frames',
	     'default', false,
	     'getFunc', function() return db.attach end,
	     'setFunc', function(value) db.attach = value; PAB:LoadPositions(); PAB:ApplyAnchorSettings() end)
	attach:SetPoint("TOPLEFT",scale,"TOPLEFT", 0, -32)

	local offsetX = CreateEditBox("Offset X", panel, 50, 25)
	offsetX:SetText(db.offsetX or "0")
	offsetX:SetCursorPosition(0)
	offsetX:SetPoint("TOPLEFT", attach, "TOPLEFT", 0, -40)
	offsetX:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		local num = self:GetText():match("%-?%d+$")
		if num then
			print("Offset X changed and saved: " .. tostring(num))
			db.offsetX = num
			PAB:LoadPositions(); PAB:ApplyAnchorSettings();
		else
			print("Wrong value for Offset X/Y")
			self:SetText(db.offsetX)
		end
	end)
	panel.offsetX = offsetX

	local offsetY = CreateEditBox("Offset Y", panel, 50, 25)
	offsetY:SetText(db.offsetY or "0")
	offsetY:SetCursorPosition(0)
	offsetY:SetPoint("LEFT", offsetX, "RIGHT", 10, 0)
	offsetY:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		local num = self:GetText():match("%-?%d+$")
		if num then
			print("Offset Y changed and saved: " .. tostring(num))
			db.offsetY = num
			PAB:LoadPositions(); PAB:ApplyAnchorSettings();
		else
			print("Wrong value for Offset X/Y")
			self:SetText(db.offsetY)
		end
	end)
	panel.offsetY = offsetY

	local iconOffsetX = CreateEditBox("Icon Offset X", panel, 50, 25)
	iconOffsetX:SetText(db.iconOffsetX or "0")
	iconOffsetX:SetCursorPosition(0)
	iconOffsetX:SetPoint("LEFT", offsetY, "RIGHT", 10, 0)
	iconOffsetX:SetScript("OnEnterPressed", function(self)
		self:ClearFocus()
		local num = self:GetText():match("%-?%d+$")
		if num then
			print("Icon Offset X changed and saved: " .. tostring(num))
			db.iconOffsetX = num
			PAB:LoadPositions(); PAB:ApplyAnchorSettings();
		else
			print("Wrong value for Icon Offset X")
			self:SetText(db.iconOffsetX)
		end
	end)
	panel.iconOffsetX = iconOffsetX

	local lock = panel:MakeToggle(
	     'name', 'Lock',
	     'description', 'Show/hide anchors',
	     'default', false,
	     'getFunc', function() return db.lock end,
	     'setFunc', function(value) db.lock = value; PAB:ApplyAnchorSettings() end)
	lock:SetPoint("TOP",panel,"TOP",10,-36)
	
	local arena = panel:MakeToggle(
	     'name', 'Arena',
	     'description', 'Show in arena only',
	     'default', false,
	     'getFunc', function() return db.arena end,
	     'setFunc', function(value) db.arena = value; PAB:ApplyAnchorSettings() end)
	arena:SetPoint("TOP",lock,"BOTTOM",0,-5)

	local hidden = panel:MakeToggle(
	     'name', 'Hidden',
	     'description', 'Show icon only when on cooldown',
	     'default', false,
	     'getFunc', function() return db.hidden end,
	     'setFunc', function(value) db.hidden = value; PAB:ApplyAnchorSettings() end)
	hidden:SetPoint("TOP",arena,"BOTTOM",0,-5)

	local growLeft = panel:MakeToggle(
	     'name', 'Grow Left',
	     'description', 'Grow ability bars to the left',
	     'default', false,
	     'getFunc', function() return db.growLeft end,
	     'setFunc', function(value) db.growLeft = value; PAB:LoadPositions(); PAB:ApplyAnchorSettings(); end)
	growLeft:SetPoint("LEFT",lock,"RIGHT",50,0)

	local showTrinket = panel:MakeToggle(
	     'name', 'Show PvP Trinket',
	     'description', 'Show PvP Trinket cooldown',
	     'default', false,
	     'getFunc', function() return db.showTrinket end,
	     'setFunc', function(value) db.showTrinket = value; PAB:ApplyAnchorSettings() PAB:UpdateAnchors() end)
	showTrinket:SetPoint("TOP",growLeft,"BOTTOM",0,-5)

	local showSelf = panel:MakeToggle(
	     'name', 'Show Self',
	     'description', 'Show self cooldowns',
	     'default', false,
	     'getFunc', function() return db.showSelf end,
	     'setFunc', function(value) db.showSelf = value; PAB:ApplyAnchorSettings() PAB:UpdateAnchors() end)
	showSelf:SetPoint("TOP",showTrinket,"BOTTOM",0,-5)

	local showTooltip = panel:MakeToggle(
	     'name', 'Show Tooltip',
	     'description', 'Show spell tooltips when possible',
	     'default', false,
	     'getFunc', function() return db.showTooltip end,
	     'setFunc', function(value) db.showTooltip = value; end)
	showTooltip:SetPoint("TOP",showSelf,"BOTTOM",0,-5)

	local showIconBorders = panel:MakeToggle(
	     'name', 'Draw borders for icons',
	     'description', 'Draw borders for cooldown icons',
	     'default', false,
	     'getFunc', function() return db.showIconBorders end,
	     'setFunc', function(value) db.showIconBorders = value; PAB:UpdateAnchors() end)
	showIconBorders:SetPoint("TOP",showTooltip,"BOTTOM",0,-5)
	
	local title2, subText2 = panel:MakeTitleTextAndSubText("Ability editor","Change what party member abilities are tracked")
	title2:ClearAllPoints()
	title2:SetPoint("LEFT",panel,"LEFT",16,80)
	subText2:ClearAllPoints()
	subText2:SetPoint("TOPLEFT",title2,"BOTTOMLEFT",0,-8)
	
	self:CreateAbilityEditor()
end

local function count(t) local i = 0 for k,v in pairs(t) do i = i + 1  end return i end



function PAB:UpdateScrollBar()
	local btns = self.btns
	local scrollframe = self.scrollframe
	local classSelectedSpecs = db.abilities[db.classSelected] 
	--local classSelectedListLength = 25
	local line = 1	

	-- for specID, abilities in pairs(classSelectedSpecs) do classSelectedListLength = classSelectedListLength + count(abilities) end
	for specID, abilities in pairs(classSelectedSpecs) do
		for abilityIndex, abilityTable in pairs(abilities) do
			local ability, id, cooldown, maxcharges = abilityTable.ability, abilityTable.id, abilityTable.cooldown, abilityTable.maxcharges
			btns[line]:SetText(ability)
			test = btns[line]:GetText()
			if btns[line]:GetText() ~= scrollframe.currentButton then
				btns[line]:SetNormalTexture("")
			else 

				btns[line]:SetNormalTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
				btns[line]:GetNormalTexture():SetBlendMode("ADD") 
				scrollframe.addeditbox:SetText(ability)
				scrollframe.ideditbox:SetText(id or "")
				scrollframe.cdeditbox:SetText(cooldown or "")
				scrollframe.maxchargeseditbox:SetText(maxcharges or "")
	     		scrollframe.dropdown2.initialize()
	     		scrollframe.dropdown2:SetValue(tostring(specID))
			end 
			
			btns[line]:Show()
			line = line + 1

		end 


	end 			

	 for i=line,25 do btns[i]:Hide() end
end
--[
function PAB:OnVerticalScroll(offset,itemHeight)
	local scrollbar = _G[self.scrollframe:GetName().. "ScrollBar"]
	scrollbar:SetValue(offset);
	self.scrollframe.offset = floor((offset / itemHeight) + 0.5);
	self:UpdateScrollBar()
end
--]
function PAB:CreateAbilityEditor()
	local panel = self.panel
	local btns = {}
	self.btns = btns
	local scrollframe = CreateFrame("ScrollFrame", "PABScrollFrame",panel,"UIPanelScrollFrameTemplate")
	local child = CreateFrame("ScrollFrame" ,"PABScrollFrame" , scrollframe )
	child:SetSize(150, 180)
	scrollframe:SetScrollChild(child)
	local button1 = CreateListButton(child,"20")
	button1:SetPoint("TOPLEFT",child,"TOPLEFT",11,0)
	btns[#btns+1] = button1
	for i=2,25 do
		local button = CreateListButton(child,tostring(i))

		button:SetPoint("TOPLEFT",btns[#btns],"BOTTOMLEFT")
		btns[#btns+1] = button
		
	end

	scrollframe:SetWidth(150); 
	scrollframe:SetHeight(180)
	scrollframe:SetPoint('LEFT',16,-45)
--	scrollframe:SetBackdrop(backdrop)
	scrollframe:SetBackdropColor(.6,.6,.6,0.25)
--  scrollframe:SetScript("OnVerticalScroll", function(self,offset) PAB:OnVerticalScroll(offset,16) end)
	scrollframe:SetScript("OnLoad",function(self) if not db.classSelected then db.classSelected = "WARRIOR" end; PAB:UpdateScrollBar(); end)
	
	
	self.scrollframe = child
	scrollframe.dropdown2 = nil
	
	local dropdown = panel:MakeDropDown(
       'name', 'Class',
	     'description', 'Pick a class to edit the ability list',
	     'values', {
		     		"WARRIOR", "Warrior",
					"DEATHKNIGHT", "Deathknight",
					"PALADIN", "Paladin",
					"PRIEST", "Priest",
					"SHAMAN", "Shaman",
					"DRUID", "Druid",
					"ROGUE", "Rogue",
					"MAGE", "Mage",
					"WARLOCK", "Warlock",
					"HUNTER", "Hunter",
					"MONK", "Monk",
					"DEMONHUNTER", "Demon Hunter",
	      },
	     'default', 'WARRIOR',
	     'getFunc', function() return db.classSelected end ,
	     'setFunc', function(value)
	     	db.classSelected = value; PAB:UpdateScrollBar();
	     	child.dropdown2.values = { "ALL", "All Specs" }
	     	for i=1, GetNumClasses() do
	     		local className, classTag, classID = GetClassInfo(i)
	     		if classTag == db.classSelected then
	     			for j=1, GetNumSpecializationsForClassID(classID) do
	     				local specID, specName = GetSpecializationInfoForClassID(classID, j)
	     				child.dropdown2.values[#child.dropdown2.values+1] = tostring(specID)
	     				child.dropdown2.values[#child.dropdown2.values+1] = specName
	     			end
	     			break
	     		end
	     	end
	     	child.dropdown2.initialize()
	     	child.dropdown2:SetValue("ALL")
	     end)
	dropdown:SetPoint("TOPLEFT",scrollframe,"TOPRIGHT",20,-8)
	child.dropdown = dropdown

	local dropdown2 = panel:MakeDropDown(
       'name', 'Spec',
	     'description', 'Pick a spec',
	     'values', {
		     		"ALL", "All Specs",
					"71", "Arms",
					"72", "Fury",
					"73", "Protection",
	      },
	     'default', 'ALL',
	     'current', 'ALL',
	     'setFunc', function(value) end)
	dropdown2:SetPoint("TOPLEFT",dropdown,"BOTTOMLEFT",0,-15)
	child.dropdown2 = dropdown2

	local addeditbox = CreateEditBox("Ability name",scrollframe,120,25)
	child.addeditbox = addeditbox
	addeditbox:SetPoint("TOPLEFT",dropdown2,"BOTTOMLEFT",20,-15)

	local ideditbox = CreateEditBox("Spell ID",scrollframe,50,25)
	ideditbox:SetPoint("LEFT",addeditbox,"RIGHT",15,0)
	child.ideditbox = ideditbox

	local cdeditbox = CreateEditBox("CD (s)",scrollframe,50,25)
	cdeditbox:SetPoint("LEFT",ideditbox,"RIGHT",15,0)
	child.cdeditbox = cdeditbox

	local maxchargeseditbox = CreateEditBox("Max Charges",scrollframe,50,25)
	maxchargeseditbox:SetPoint("LEFT",cdeditbox,"RIGHT",15,0)
	child.maxchargeseditbox = maxchargeseditbox

	local addbutton = panel:MakeButton(
	     'name', 'Add/Edit',
	     'description', "Add a new ability with a specified cooldown.",
	     'func', function() 
	     		local id = ideditbox:GetText():match("^[0-9]+$")
	     		local spec = dropdown2.value
	     		local ability = PAB:FormatAbility(addeditbox:GetText())
	     		local iconfound = PAB:FindAbilityIcon(ability, id)
	     		local cdtext = cdeditbox:GetText():match("^[0-9]+$")
	     		local maxcharges = maxchargeseditbox:GetText():match("^[0-9]+$")
	     		if iconfound and cdtext and (not spec or db.abilities[db.classSelected] and db.abilities[db.classSelected][spec]) then
	     			print("Added/updated "..ability)
	     			local abilities = db.abilities[db.classSelected][spec or "ALL"]
	     			local _ability, _index = self:FindAbilityByName(abilities, ability)
	     			if _ability and _index then
	     				-- editing:
	     				abilities[_index] = {ability = ability, cooldown = tonumber(cdtext), id = tonumber(id), maxcharges = maxcharges and maxcharges ~= "" and tonumber(maxcharges) or nil}
	     			else
	     				-- adding new:
	     				table.insert(abilities, {ability = ability, cooldown = tonumber(cdtext), id = tonumber(id), maxcharges = maxcharges and maxcharges ~= "" and tonumber(maxcharges) or nil})
	     			end
	     			child.currentButton = ability
	     			PAB:UpdateScrollBar()
	     			PAB:UpdateAnchors()
	     		else
	     			print("Invalid spell spec/name/cooldown")
	     		end
	      end
	)
	addbutton:SetPoint("TOPLEFT",addeditbox,"BOTTOMLEFT",-5,0)
	
	local removebutton = panel:MakeButton(
	     'name', 'Remove',
	     'description', 'Remove the selected ability',
	     'func', function()
	     		 print("Removed " .. addeditbox:GetText())
	     		 local spec = dropdown2.value
	     		 local _ability, _index = self:FindAbilityByName(db.abilities[db.classSelected][spec or "ALL"], addeditbox:GetText())
	     		 if _ability and _index then table.remove(db.abilities[db.classSelected][spec], _index) end

	     		 addeditbox:SetText(""); 
	     		 ideditbox:SetText("");
	     		 cdeditbox:SetText(""); 
	     		 maxchargeseditbox:SetText("");
	     		 child.currentButton = nil; 
	     		 PAB:UpdateScrollBar(); 
	     		 PAB:UpdateAnchors() 
	     end
	)
	removebutton:SetPoint("TOPLEFT",addbutton,"BOTTOMLEFT",0,-5)
	
	local description =  panel:CreateFontString(nil,"ARTWORK","GameFontNormal")
	description:SetText(" Add (or remove) extra abilities that you want to track. \r\n The addon is still in BETA but most of the things are working. \r\n \r\n For future improvements and bug fixes please support me at  <>  http://twitch.tv/imedia <> \r\n Enjoy!");
	description:SetNonSpaceWrap(true)
	description:SetJustifyH("LEFT")
	description:SetWidth(100)
	description:SetHeight(100)
	description:SetPoint("TOPLEFT",scrollframe,"BOTTOMLEFT",0,-10)
	description:SetPoint("RIGHT", -32, 0)
end

PAB:RegisterEvent("VARIABLES_LOADED")
PAB:SetScript("OnEvent",PAB_OnLoad)
