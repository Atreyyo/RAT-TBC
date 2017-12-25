--########### Raid Ability Tracker 
--########### By Atreyyo @ Warmane, Outland
--##########################################

Rat = CreateFrame("Button", "Rat", UIParent); -- Create first frame
Rat.Mainframe = CreateFrame("Frame","RMF",UIParent) -- Create Mainframe
Rat.Options = CreateFrame("Frame","OPTIONS",UIParent) -- Create Optionsframe
Rat.Minimap = CreateFrame("Frame",nil,Minimap) -- Minimap Frame
Rat.Version = CreateFrame("Frame","RVF",UIParent) -- Create Versionframe
Rat_Version = GetAddOnMetadata("Rat", "Version")

-- local variables // Zedar
local getSpells 
local getInvCd
local getThrottle

local LOCAL_PLAYER_CLASS = UnitClass("player")

local RAT_PlayerSpells = {}

local RAT_InitializePlayerSpells

-- local global variables // Zedar
-- Local variables can speed up lookup time by ~30%
local GetTime = GetTime 
local UnitClass = UnitClass 
local math = math 
local math_floor = math.floor 
local string = string 
local strfind = strfind 
local string_sub = string.sub 
local GetSpellCooldown = GetSpellCooldown
local GetBagName = GetBagName 

-- Variables

RAT_CP_OBJ=nil
RAT_CP_TYPE=nil
Rat_unit = UnitName("player") 
-- Tables

RatTbl = {}
RatVersionTbl = {}
VersionFTbl = {}
getThrottle = {}
sendThrottle = {}
RatFrames = {}
Rat_Settings = Rat_Settings or {}

cdtbl = { 
	-- Warrior
	["Shield Wall"] = "Interface\\Icons\\Ability_Warrior_ShieldWall",
	["Berserker Rage"] = "Interface\\Icons\\Spell_Nature_AncestralGuardian",
	["Pummel"] = "Interface\\Icons\\INV_Gauntlets_04",
	["Disarm"] = "Interface\\Icons\\Ability_Warrior_Disarm",	
	["Intervene"] = "Interface\\Icons\\Ability_Warrior_VictoryRush",
	["Mocking Blow"] = "Interface\\Icons\\Ability_Warrior_PunishingBlow",
	["Taunt"] = "Interface\\Icons\\Spell_Nature_Reincarnation",
	["Challenging Shout"] = "Interface\\Icons\\Ability_BullRush",
	["Last Stand"] = "Interface\\Icons\\Spell_Holy_AshesToAshes",
	
	-- Warlock
	["Master Soulstone"] = "Interface\\Icons\\INV_Misc_Orb_04",	
	["Ritual of Souls"] = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness",
	["Soulshatter"] = "Interface\\Icons\\Spell_Arcane_Arcane01",
	
	-- Rogue
	["Kick"] = "Interface\\Icons\\Ability_Kick",	
	["Vanish"] = "Interface\\Icons\\Ability_Vanish",
	["Evasion"] = "Interface\\Icons\\Spell_Shadow_ShadowWard",
	["Blind"] = "Interface\\Icons\\Spell_Shadow_MindSteal",
	["Cloak of Shadows"] = "Interface\\Icons\\Spell_Shadow_NetherCloak",
	
	-- Paladin
	["Lay on Hands"] = "Interface\\Icons\\Spell_Holy_LayOnHands",
	["Blessing of Protection"] = "Interface\\Icons\\Spell_Holy_SealOfProtection",
	["Divine Shield"] = "Interface\\Icons\\Spell_Holy_DivineIntervention",
	["Divine Intervention"] = "Interface\\Icons\\Spell_Nature_TimeStop",
	["Righteous Defense"] = "Interface\\Icons\\INV_Shoulder_37",
	["Blessing of Freedom"] = "Interface\\Icons\\Spell_Holy_SealOfValor",
	
	-- Shaman
	["Reincarnation"] = "Interface\\Icons\\Spell_Nature_Reincarnation",
	["Mana Tide Totem"] = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",	
	["Heroism"] = "Interface\\Icons\\Ability_Shaman_Heroism",
	["Bloodlust"] = "Interface\\Icons\\Ability_Shaman_Bloodlust",
	["Chain Lightning"] = "Interface\\Icons\\Spell_Nature_ChainLightning",
	["Elemental Mastery"] = "Interface\\Icons\\Spell_Nature_WispHeal",
	["Nature\'s Swiftness"] = "Interface\\Icons\\Spell_Nature_RavenForm",
	
	-- Hunter
	["Tranquilizing Shot"] = "Interface\\Icons\\Spell_Nature_Drowsy",	
	["Misdirection"] = "Interface\\Icons\\Ability_Hunter_Misdirection",
	
	-- Druid
	["Innervate"] = "Interface\\Icons\\Spell_Nature_Lightning",
	["Challenging Roar"] = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
	["Rebirth"] = "Interface\\Icons\\Spell_Nature_Reincarnation",
	["Nature\'s Swiftness"] = "Interface\\Icons\\Spell_Nature_RavenForm",
	
	-- Priest
	["Fear Ward"] = "Interface\\Icons\\Spell_Holy_Excorcism",
	["Power Infusion"] = "Interface\\Icons\\Spell_Holy_PowerInfusion",
	
	-- Mage
	["Arcane Power"] = "Interface\\Icons\\Spell_Nature_Lightning",
	["Counterspell"] = "Interface\\Icons\\Spell_Frost_IceShock",
	["Invisibility"] = "Interface\\Icons\\Ability_Mage_Invisibility",
	["Ritual of Refreshment"] = "Interface\\Icons\\Spell_Arcane_MassDispel",
	
}

RatMenu = {
	[1] = "Druid",
	[2] = "Hunter",
	[3] = "Mage",
	[4] = "Paladin",
	[5] = "Priest",
	[6] = "Rogue",
	[7] = "Shaman",
	[8] = "Warlock",
	[9] = "Warrior",
	[10] = "Settings",
}

RatAbilityMenu = {
	["Warrior"] = {
		["Shield Wall"] = "Interface\\Icons\\Ability_Warrior_ShieldWall",
		["Berserker Rage"] = "Interface\\Icons\\Spell_Nature_AncestralGuardian",
		["Pummel"] = "Interface\\Icons\\INV_Gauntlets_04",
		["Disarm"] = "Interface\\Icons\\Ability_Warrior_Disarm",	
		["Intervene"] = "Interface\\Icons\\Ability_Warrior_VictoryRush",
		["Mocking Blow"] = "Interface\\Icons\\Ability_Warrior_PunishingBlow",
		["Taunt"] = "Interface\\Icons\\Spell_Nature_Reincarnation",
		["Challenging Shout"] = "Interface\\Icons\\Ability_BullRush",
		["Last Stand"] = "Interface\\Icons\\Spell_Holy_AshesToAshes",
	},
	["Warlock"] = {
		["Master Soulstone"] = "Interface\\Icons\\INV_Misc_Orb_04",	
		["Ritual of Souls"] = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness",
		["Soulshatter"] = "Interface\\Icons\\Spell_Arcane_Arcane01",
	},
	["Rogue"] = {
		["Kick"] = "Interface\\Icons\\Ability_Kick",	
		["Vanish"] = "Interface\\Icons\\Ability_Vanish",
		["Evasion"] = "Interface\\Icons\\Spell_Shadow_ShadowWard",
		["Blind"] = "Interface\\Icons\\Spell_Shadow_MindSteal",
		["Cloak of Shadows"] = "Interface\\Icons\\Spell_Shadow_NetherCloak",
	},
	["Paladin"] = {
		["Lay on Hands"] = "Interface\\Icons\\Spell_Holy_LayOnHands",
		["Blessing of Protection"] = "Interface\\Icons\\Spell_Holy_SealOfProtection",
		["Divine Shield"] = "Interface\\Icons\\Spell_Holy_DivineIntervention",
		["Divine Intervention"] = "Interface\\Icons\\Spell_Nature_TimeStop",
		["Righteous Defense"] = "Interface\\Icons\\INV_Shoulder_37",
		["Blessing of Freedom"] = "Interface\\Icons\\Spell_Holy_SealOfValor",
	},
	["Shaman"] = { 
		["Reincarnation"] = "Interface\\Icons\\Spell_Nature_Reincarnation",
		["Mana Tide Totem"] = "Interface\\Icons\\Spell_Frost_SummonWaterElemental",	
		["Heroism"] = "Interface\\Icons\\Ability_Shaman_Heroism",
		["Bloodlust"] = "Interface\\Icons\\Ability_Shaman_Bloodlust",
		["Chain Lightning"] = "Interface\\Icons\\Spell_Nature_ChainLightning",
		["Elemental Mastery"] = "Interface\\Icons\\Spell_Nature_WispHeal",
		["Nature\'s Swiftness"] = "Interface\\Icons\\Spell_Nature_RavenForm",
	},
	["Hunter"] = {
		["Tranquilizing Shot"] = "Interface\\Icons\\Spell_Nature_Drowsy",	
		["Misdirection"] = "Interface\\Icons\\Ability_Hunter_Misdirection",
	},
	["Druid"] = {
		["Innervate"] = "Interface\\Icons\\Spell_Nature_Lightning",
		["Challenging Roar"] = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
		["Rebirth"] = "Interface\\Icons\\Spell_Nature_Reincarnation",
		["Nature\'s Swiftness"] = "Interface\\Icons\\Spell_Nature_RavenForm",
	},
	["Priest"] = {
		["Fear Ward"] = "Interface\\Icons\\Spell_Holy_Excorcism",
		["Power Infusion"] = "Interface\\Icons\\Spell_Holy_PowerInfusion",
	},
	["Mage"] = {
		["Arcane Power"] = "Interface\\Icons\\Spell_Nature_Lightning",
		["Counterspell"] = "Interface\\Icons\\Spell_Frost_IceShock",
		["Invisibility"] = "Interface\\Icons\\Ability_Mage_Invisibility",
		["Ritual of Refreshment"] = "Interface\\Icons\\Spell_Arcane_MassDispel",
	},
}

Rat_Font = {
	[1] = "ABF",
	[2] = "Accidental Presidency",
	[3] = "Adventure",
	[4] = "Avqest",
	[5] = "Bazooka",
	[6] = "BigNoodleTitling",
	[7] = "BigNoodleTitling-Oblique",
	[8] = "BlackChancery",
	[9] = "Emblem",
	[10] = "Enigma__2",
	[11] = "Movie_Poster-Bold",
	[12] = "Porky",
	[13] = "rm_midse",
	[14] = "Tangerin",
	[15] = "Tw_Cen_MT_Bold",
	[16] = "Ultima_Campagnoli",
	[17] = "VeraSe",
	[18] = "visitor2",
	[19] = "Yellowjacket",
}

Rat_FontSize = {
	[1] = 12,
	[2] = 13,
	[3] = 10,
	[4] = 11,
	[5] = 11,
	[6] = 12,
	[7] = 12,
	[8] = 12,
	[9] = 11,
	[10] = 11,
	[11] = 20,
	[12] = 10,
	[13] = 12,
	[14] = 12,
	[15] = 12,
	[16] = 12,
	[17] = 11,
	[18] = 12,
	[19] = 10,
}

Rat_BarTexture = {
	[1] = "Aluminium",
	[2] = "Armory",
	[3] = "BantoBar",
	[4] = "Glaze2",
	[5] = "Gloss",
	[6] = "Graphite",
	[7] = "Grid",
	[8] = "Healbot",
	[9] = "LiteStep",
	[10] = "Minimalist",
	[11] = "normTex",
	[12] = "Otravi",
	[13] = "Outline",
	[14] = "Perl",
	[15] = "Round",
	[16] = "Smooth",
}


-- Default setting check

function RatDefault()
	for i=1,9 do
		if Rat_Settings[RatMenu[i]] == nil then
			Rat_Settings[RatMenu[i]] = 1
		end
	end
	
	if Rat_unit == nil then 
		Rat_unit = UnitName("player") 
		if RatTbl[Rat_unit] == nil then RatTbl[Rat_unit] = { } end
	end
	
	if Rat_Settings["showhide"] == nil then 
		Rat_Settings["showhide"] = 1 
	end
	if Rat_Settings["scale"] == nil then
		Rat_Settings["scale"] = 1
	end
	
	RAT_InitializePlayerSpells()
end
-- Register events

Rat:RegisterEvent("ADDON_LOADED") 
Rat:RegisterEvent("RAID_ROSTER_UPDATE")
Rat:RegisterEvent("PARTY_MEMBERS_CHANGED")
Rat:RegisterEvent("PARTY_MEMBERS_CHANGED")
Rat:RegisterEvent("SPELL_UPDATE_COOLDOWN")
Rat:RegisterEvent("CHAT_MSG_ADDON")
Rat:RegisterEvent("BAG_UPDATE_COOLDOWN")
Rat:RegisterEvent("LEARNED_SPELL_IN_TAB")

-- function to handle events

function Rat:OnEvent()
	if (event == "ADDON_LOADED") and (arg1 == "Rat" or arg1 == "rat" or arg1 == "RAT") then
		Rat:Print("RAT Loaded!")
		Rat:Print("type |cFFFFFF00 /rat show|r to show frame")
		Rat:Print("type |cFFFFFF00 /rat hide|r to hide frame")
		Rat:Print("type |cFFFFFF00 /rat options|r to show options menu")
		Rat:Print("Hold down 'Alt' to move the window")
		Rat.Mainframe:ConfigFrame()
		RatDefault()
		Rat.Options:ConfigFrame()
		Rat.Version:ConfigFrame()
		Rat.Minimap:CreateMinimapIcon()
		getSpells()
		getInvCd()
		sendCds()
		Rat:Update(true)
	elseif (event == "CHAT_MSG_ADDON") then
		if string_sub(arg1,1,3) == "RAT" then
			if Rat_unit ~= arg4 then 
				if string_sub(arg1,4,7) == "SYNC" then
					local cd = string_sub(arg1, string.find(arg1, "[", 1, true)+1, string.find(arg1, "]", 1, true)-1)
					local duration = arg2
					local cdname = string_sub(arg1, string.find(arg1, "(", 1, true)+1, string.find(arg1, ")", 1, true)-1)
					local name = arg4
					Rat:AddCd(name,cdname,cd,duration) 
					getSpells()
					getInvCd()
					sendCds()
					Rat:Update(true)
				end
				if string_sub(arg1,4,10) == "VERSION" then
					if string_sub(arg1,11,15) == "CHECK" then
						if sendThrottle["version"] == nil or (GetTime() - sendThrottle["version"]) > 10 then
							SendAddonMessage("RATVERSIONSYNC",Rat_Version,"RAID")
							sendThrottle["versioncheck"] = GetTime()
						end
					end
					if string_sub(arg1,11,15) == "SYNC" then
						RatVersionTbl[arg4] = arg2
						Rat.Version:Check()
					end
				end
			end
		end
	elseif (event == "RAID_ROSTER_UPDATE") then
		getSpells()
		getInvCd()
		Rat:Cleardb()
		Rat:HideVersionNameFrames()
		Rat:Update(true)
		sendCds()
	elseif (event == "PARTY_MEMBERS_CHANGED") then
		if not GetRaidRosterInfo(1) then
			getSpells()
			getInvCd()
			Rat:Cleardb()
			Rat:HideVersionNameFrames()
			Rat:Update(true)
			sendCds()		
		end
	
	elseif (event == "SPELL_UPDATE_COOLDOWN") then
		getSpells()
		getInvCd()
		Rat:Cleardb()
		sendCds()
		Rat:Update()
	elseif (event == "BAG_UPDATE_COOLDOWN") then
		getInvCd()
		sendCds()
		Rat:Update()
	elseif (event == "LEARNED_SPELL_IN_TAB") then
		RAT_InitializePlayerSpells()
	end
end

-- function to check version

function Rat.Version:Check()
	if Rat.Version:IsVisible() then 
		local count = 0
		local xaxis = 0
		local yaxis = 0
		for name, version in pairs(RatVersionTbl) do
			if count >= 30 then
				xaxis = 320
				yaxis = -450
			elseif count >= 20 then
				xaxis = 220
				yaxis = -300
			elseif count >= 10 then
				xaxis = 120
				yaxis = -150
			end
			VersionFTbl[name] = VersionFTbl[name] or Rat.Version:Insert(name)
			local frame = VersionFTbl[name]
			frame:SetPoint("TOPLEFT",1+xaxis,-(1+(15*count)+yaxis))
			frame.text:SetText(name.." |cFFFFFFFFv"..version)
			frame.text:SetTextColor(1,1,1,1) 
			frame.texture:SetTexture(Rat:GetClassColors(name))
			frame:Show()
			Rat.Version:SetWidth(123+(xaxis))
			Rat.Version:SetWidth(123+(xaxis))
			if count < 10 then 
				Rat.Version:SetHeight(18+(15*count))
			else
				Rat.Version:SetHeight(153)
			end
			Rat.Version.close:SetPoint("CENTER",0,-((Rat.Version:GetHeight()/2)+6))
			count = count+1
		end
	end
end

-- function to create nameframes for the version check

function Rat.Version:Insert(name)
	local frame = CreateFrame('Button', name, Rat.Version)
	frame:SetWidth(120)
	frame:SetHeight(15)
	frame:SetBackdropColor(1,1,1,0.6)
	frame.texture = frame:CreateTexture(nil, 'ARTWORK')
	frame.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	frame.texture:SetWidth(118)
	frame.texture:SetHeight(13)
	frame.texture:SetPoint('TOPLEFT', 1, -1)
	frame.texture:SetTexture("Interface/TargetingFrame/UI-StatusBar")
	frame.text = frame:CreateFontString(nil, "OVERLAY")
	frame.text:SetPoint("CENTER",0, 1)
	frame.text:SetFont("Fonts\\FRIZQT__.TTF", 12)
	frame.text:SetTextColor(1, 1, 1, 1)
	frame.text:SetShadowOffset(1,-1)
	frame.text:SetText("name")
	frame:SetMovable(1)
	frame:RegisterForDrag("LeftButton")
	frame:EnableMouse(1)
	frame:SetScript("OnDragStart", function() Rat.Version:StartMoving() end)
	frame:SetScript("OnDragStop", function() Rat.Version:StopMovingOrSizing() end)	
	return frame
end

-- function to config versionframe

function Rat.Version:ConfigFrame()

	backdrop = {
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile="true",
		tileSize="8",
		edgeSize="8",
		insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
	}

	self:SetFrameStrata("HIGH")
	self:SetWidth(120) -- Set these to whatever height/width is needed 
	self:SetHeight(100) -- for your Texture
	self:SetPoint("CENTER",0,0)
	self:SetMovable(1)
	self:RegisterForDrag("LeftButton")
	self:EnableMouse(1)
	self:EnableMouseWheel(1)
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0,0,0,1)
	self:SetResizable(enable)
	self:SetMinResize(400, 120)
	self:SetScript("OnDragStart", self.StartMoving)
	self:SetScript("OnDragStop", self.StopMovingOrSizing)	
	-- close button

	self.close = CreateFrame("Button",nil,self,"UIPanelButtonTemplate")
	self.close:SetPoint("CENTER",0,-((self:GetHeight()/2)+5))
	self.close:SetFrameStrata("HIGH")
	self.close:SetWidth(79)
	self.close:SetHeight(18)
	self.close:SetText("Close")
	self.close:SetScript("OnClick", function() PlaySound("igMainMenuOptionCheckBoxOn"); self:Hide(); end)
	
	self:Hide()
end

-- function to config mainframe

function Rat.Mainframe:ConfigFrame()
	if Rat_Settings["topbarcolor"] == nil then
		Rat_Settings["topbarcolor"] = {["r"] = 0.1, ["g"] = 0.1, ["b"] = 1}
	end
	if Rat_Settings["abilitybarcolor"] == nil then
		Rat_Settings["abilitybarcolor"] = {["r"] = 0.0, ["g"] = 0.44, ["b"] = 0.87}
	end
	if Rat_Settings["abilitytextcolor"] == nil then
		Rat_Settings["abilitytextcolor"] = {["r"] = 1, ["g"] = 1, ["b"] = 1}
	end
	if Rat_Settings["font"] == nil then
		Rat_Settings["font"] = 1
	end
	if Rat_Settings["bartexture"] == nil then
		Rat_Settings["bartexture"] = 1
	end
	Rat.Mainframe.options = {}
	function Rat.Mainframe.options:StartMoving()
		this:StartMoving()
		this.drag = true
	end
	
	function Rat.Mainframe.options:StopMovingOrSizing()
		this:StopMovingOrSizing()
		this.drag = false
	end
	
	backdrop = {
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile="false",
			tileSize="8",
			edgeSize="8",
			insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
	}
	self:SetFrameStrata("LOW")
	self:SetWidth(250) -- Set these to whatever height/width is needed 
	self:SetHeight(21) -- for your Texture
	self:SetPoint("CENTER",0,0)
	self:SetMovable(1)
	self:EnableMouse(1)
	self:RegisterForDrag("LeftButton")
	self:SetBackdrop(backdrop)
	
	self:SetScript("OnDragStart", Rat.Mainframe.options.StartMoving)
	self:SetScript("OnDragStop", Rat.Mainframe.options.StopMovingOrSizing)
	self:SetScript("OnUpdate", function()
		this:EnableMouse(IsAltKeyDown())
		if not IsAltKeyDown() and this.drag then
			self.options:StopMovingOrSizing()
		end
	end)
	
	self.Background = {}
	self.Background.Top = CreateFrame("Frame",nil,self) -- top frame
	self.Background.Tab1 = CreateFrame("Frame",nil,self) -- mid frame
	
	-- create top background
	local backdrop = {
			bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
			tile="false",
			tileSize="4",
			edgeSize="4",
			insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
	}
	self.Background.Top:SetFrameStrata('BACKGROUND')
	self.Background.Top:SetWidth(self:GetWidth()-2)
	self.Background.Top:SetHeight(20)
	self.Background.Top:SetBackdrop(backdrop)
	self.Background.Top:SetBackdropColor(0,0,0,1)
	self.Background.Top:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
	self.Background.Top:SetScript("OnEnter", function() 
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
		GameTooltip:SetText("Hold 'Alt' key to move the window", 1, 1, 1, 1);
		GameTooltip:Show()
	end)
	self.Background.Top:SetScript("OnEnter", function()
		GameTooltip:Hide()
	end)
	
	topbg = self.Background.Top:CreateTexture(nil, 'ARTWORK',self)
	topbg:SetPoint("TOPLEFT",1,-1)
	topbg:SetWidth(self:GetWidth()-5)
	topbg:SetHeight(17)
	topbg:SetTexture(Rat_Settings["topbarcolor"]["r"],Rat_Settings["topbarcolor"]["g"],Rat_Settings["topbarcolor"]["b"])
	topbg:SetGradientAlpha("Vertical", 1,1,1, 0.25, 1, 1, 1, 1)
	
	self.Background.Top.Title = self.Background.Top:CreateFontString(nil, "ARTWORK")
	self.Background.Top.Title:SetPoint("LEFT", 22, 0)
	self.Background.Top.Title:SetFont("Interface\\AddOns\\Rat\\fonts\\"..Rat_Font[Rat_Settings["font"]]..".TTF", Rat_FontSize[Rat_Settings["font"]]+1)
	self.Background.Top.Title:SetTextColor(255, 255, 255, 1)
	self.Background.Top.Title:SetShadowOffset(2,-2)
	self.Background.Top.Title:SetText("RAT v"..Rat_Version)
	
	for i=1,9 do

		local r, l, t, b = Rat:ClassPos(RatMenu[i])
		local frame = CreateFrame('Button', RatMenu[i], self)
		frame:SetWidth(16)
		frame:SetHeight(16)
		frame:SetBackdropColor(0,0,0,1)
		frame:SetPoint('TOPRIGHT', -(i*17)-3, -1)
		frame:SetFrameStrata('MEDIUM')
		frame.Icon = frame:CreateTexture(nil, 'ARTWORK')
		frame.Icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		frame.Icon:SetTexCoord(r, l, t, b)
		frame.Icon:SetPoint('TOPRIGHT', -1, -1)
		frame.Icon:SetWidth(16)
		frame.Icon:SetHeight(16)
		local r,g,b,o=Rat:ClassColors(RatMenu[i])
		frame:SetScript("OnEnter", function() 
			GameTooltip:SetOwner(frame, "ANCHOR_TOPRIGHT");
			GameTooltip:SetText(this:GetName(), r,g,b,o);
			GameTooltip:Show()
		end)
		frame:SetScript("OnLeave", function() GameTooltip:Hide() end)
		frame:SetScript("OnMouseDown", function()
			if (arg1 == "LeftButton") then
				if Rat_Settings[this:GetName()] == 1 then
					Rat_Settings[this:GetName()] = 0
					frame.Icon:SetVertexColor(0.5, 0.5, 0.5)
				else
					Rat_Settings[this:GetName()] = 1
					frame.Icon:SetVertexColor(1.0, 1.0, 1.0)
				end
			end
		end)
		if Rat_Settings[RatMenu[i]] == 1 then
			frame.Icon:SetVertexColor(1, 1, 1)
		else
			frame.Icon:SetVertexColor(0.5, 0.5, 0.5)
		end
	end
		
	-- create mid background	
	local backdrop = {
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile="true",
		tileSize="8",
		edgeSize="22",
		insets={
				left="2",
				right="2",
				top="2",
				bottom="2"
			}
		}
	self.Background.Tab1:SetFrameStrata("BACKGROUND")
	self.Background.Tab1:SetWidth(self:GetWidth())
	self.Background.Tab1:SetHeight(22)
	self.Background.Tab1:SetBackdrop(backdrop)
	self.Background.Tab1:SetBackdropColor(0,0,0,0.5)
	self.Background.Tab1:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -1)

	-- create close button
	self.CloseButton = CreateFrame("Button",nil,self,"UIPanelCloseButton")
	self.CloseButton:SetPoint("TOPLEFT",self:GetWidth()-23,2)
	self.CloseButton:SetWidth(24)
	self.CloseButton:SetHeight(24)
	self.CloseButton:SetFrameStrata('MEDIUM')
	self.CloseButton:SetScript("OnMouseUp", function()
			if (arg1 == "LeftButton") then
				Rat_Settings["showhide"] = 0
			end
		end)
		
	-- icon
	self.Iconframe = CreateFrame('Button',"Iconframe",self)
	self.Iconframe:SetWidth(18)
	self.Iconframe:SetHeight(18)
	self.Iconframe:SetPoint("TOPLEFT",2,-1)
	self.Iconframe:SetFrameStrata('MEDIUM')
	self.Iconframe.Icon = self.Iconframe:CreateTexture(nil,'ARTWORK')
	self.Iconframe.Icon:SetWidth(18)
	self.Iconframe.Icon:SetHeight(18)
	self.Iconframe.Icon:SetPoint('TOPLEFT', 0, 0)
	self.Iconframe.Icon:SetTexture("Interface\\AddOns\\Rat\\media\\icon.tga")
	self.Iconframe:SetScript("OnEnter", function() 
		self.Iconframe.Icon:SetVertexColor(0.5, 0.5, 0.5)
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
		GameTooltip:SetText("Options Menu", 1, 1, 1, 1);
		GameTooltip:Show()
	end)
	self.Iconframe:SetScript("OnLeave", function() 
		self.Iconframe.Icon:SetVertexColor(1.0, 1.0, 1.0)
		GameTooltip:Hide()
	end)
	self.Iconframe:SetScript("OnMouseDown", function()
			if (arg1 == "LeftButton") then
				if Rat.Options:IsVisible() then 
					Rat.Options:Hide()
				else 
					Rat.Options:Show() 
				end
			end
		end)
end

function Rat.Options:ConfigFrame()

	self.List = CreateFrame("Frame","LISTOPTIONS",self) -- Create List
	
	backdrop = {
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		tile="true",
		tileSize="4",
		edgeSize="2",
		insets={
				left="1",
				right="1",
				top="1",
				bottom="1"
			}
	}

	self:SetFrameStrata("BACKGROUND")
	self:SetWidth(800) -- Set these to whatever height/width is needed 
	self:SetHeight(500) -- for your Texture
	self:SetPoint("CENTER",0,0)
	self:SetMovable(1)
	self:EnableMouse(1)
	self:EnableMouseWheel(1)
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0,0,0,1)
	self:SetResizable(enable)
	
	-- options text
	local text = self:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER", self, "CENTER", 0, (self:GetHeight()/2)-25)
    text:SetFont("Fonts\\FRIZQT__.TTF", 25)
	text:SetTextColor(1, 1, 1, 1)
	text:SetShadowOffset(2,-2)
    text:SetText("RAT v"..Rat_Version.." OPTIONS")
	
	-- Version check button
	self.version = CreateFrame("Button",nil,self)
	self.version:SetPoint("TOPRIGHT",-19,-1)
	self.version:SetWidth(89)
	self.version:SetHeight(16)		
	self.version:SetBackdrop(backdrop)
	self.version:SetBackdropColor(0,0,0,1)
	self.version:SetScript("OnClick", function() 
		PlaySound("igMainMenuOptionCheckBoxOn"); 
		if sendThrottle["versioncheck"] == nil or (GetTime() - sendThrottle["versioncheck"]) > 10 then
			SendAddonMessage("RATVERSIONCHECK",0,"RAID"); 
			Rat.Version:Show() 
			sendThrottle["versioncheck"] = GetTime()
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A Rat:|r Don't spam the check function!",1,1,1)
		end
	end)
	self.version:SetScript("OnEnter", function() 
		self.version:SetBackdropColor(1,1,1,0.6)
	end)
	self.version:SetScript("OnLeave", function() 
		self.version:SetBackdropColor(0,0,0,0.6)
	end)

	local text = self.version:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER", self.version, "CENTER", 0, 1)
    text:SetFont("Fonts\\FRIZQT__.TTF", 12)
	text:SetTextColor(1, 1, 1, 1)
	text:SetShadowOffset(2,-2)
    text:SetText("Version Check")	
	
	-- close button
	
	self.close = CreateFrame("Button",nil,self)
	self.close:SetPoint("CENTER",0,-((self:GetHeight()/2))+15)
	self.close:SetFrameStrata("HIGH")
	self.close:SetWidth(79)
	self.close:SetHeight(18)
	self.close:SetBackdrop(backdrop)
	self.close:SetBackdropColor(0,0,0,1)
	self.close:SetScript("OnClick", function() PlaySound("igMainMenuOptionCheckBoxOn"); self:Hide(); end)

	self.close:SetScript("OnEnter", function() 
		self.close:SetBackdropColor(1,1,1,0.6)
	end)
	self.close:SetScript("OnLeave", function() 
		self.close:SetBackdropColor(0,0,0,0.6)
		--self.close:SetBackdropColor(1,1,1,0)
	end)
	
	local text = self.close:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER", self.close, "CENTER", 0, 1)
    text:SetFont("Fonts\\FRIZQT__.TTF", 12)
	text:SetTextColor(1, 1, 1, 1)
	text:SetShadowOffset(2,-2)
    text:SetText("Close")	
	
	--self:Hide()
	
	-- List
	
	self.List:SetFrameStrata("HIGH")
	self.List:SetWidth(200) -- Set these to whatever height/width is needed 
	self.List:SetHeight(425) -- for your Texture
	self.List:SetPoint("TOPLEFT",25,-50)
	self.List:EnableMouse(1)
	self.List:EnableMouseWheel(1)
	self.List:SetBackdrop(backdrop)
	self.List:SetBackdropColor(0,0,0,1)
	
	-- create menu and tabs

	self.tab1 = CreateFrame("button","tab1",self)
	self.tab2 = CreateFrame("button","tab2",self)
	self.tab3 = CreateFrame("button","tab3",self)
	self.tab4 = CreateFrame("button","tab4",self)
	self.tab5 = CreateFrame("button","tab5",self)
	self.tab6 = CreateFrame("button","tab6",self)
	self.tab7 = CreateFrame("button","tab7",self)
	self.tab8 = CreateFrame("button","tab8",self)
	self.tab9 = CreateFrame("button","tab9",self)
	self.tab10 = CreateFrame("button","tab10",self)
	
	for i=1,10 do
		
		-- tab
		local tab = self["tab"..i]
		tab:SetFrameStrata("LOW")
		tab:SetWidth(525) 
		tab:SetHeight(425) 
		tab:SetPoint("TOPLEFT",250,-50)
		tab:EnableMouse(1)
		tab:EnableMouseWheel(1)
		tab:SetBackdrop(backdrop)
		tab:SetBackdropColor(0,0,0,1)
		
		-- tab content
		if i == 10 then
		
			-- Scale slider
			self.Slider = CreateFrame("Slider", "Slider", self.tab10, 'OptionsSliderTemplate')
			self.Slider:SetWidth(200)
			self.Slider:SetHeight(20)
			self.Slider:SetPoint("TOPLEFT", 50, -25)
			self.Slider:SetMinMaxValues(0.5, 1.5)
			self.Slider:SetValue(Rat_Settings["scale"])
			self.Slider:SetValueStep(0.025)
			getglobal(self.Slider:GetName() .. 'Low'):SetText('-100%')
			getglobal(self.Slider:GetName() .. 'High'):SetText('100%')
			self.Slider:SetScript("OnValueChanged", function() 
				Rat_Settings["scale"] = this:GetValue()
				Rat.Mainframe:SetScale(Rat_Settings["scale"])
			end)
			self.Slider:Show()
			Rat.Mainframe:SetScale(Rat_Settings["scale"])
			
			local text = self.Slider:CreateFontString(nil, "OVERLAY")
			text:SetPoint("CENTER", 0, 15)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Scale")	
			
			-- minimap option
			
			local Checkbox = CreateFrame("CheckButton", "Minimap", self.tab10, "UICheckButtonTemplate")
			Checkbox:SetPoint("TOPLEFT",45,-230)
			Checkbox:SetWidth(35)
			Checkbox:SetHeight(35)
			Checkbox:SetFrameStrata("MEDIUM")
			Checkbox:SetScript("OnClick", function () 
				if Checkbox:GetChecked() == nil then 
					Rat_Settings["Minimap"] = nil
				elseif Checkbox:GetChecked() == 1 then 
					Rat_Settings["Minimap"] = 1 
				end
				end)
			Checkbox:SetScript("OnEnter", function() 
				GameTooltip:SetOwner(Checkbox, "ANCHOR_RIGHT");
				GameTooltip:SetText("Turn on/off", 255, 255, 0, 1, 1);
				GameTooltip:Show()
			end)
			Checkbox:SetScript("OnLeave", function() GameTooltip:Hide() end)
			Checkbox:SetChecked(Rat_Settings["Minimap"])
			local text = Checkbox:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 45, 0)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Show minimap icon")
			
			-- notify option
			
			local Checkbox = CreateFrame("CheckButton", "Notify", self.tab10, "UICheckButtonTemplate")
			Checkbox:SetPoint("TOPLEFT",45,-280)
			Checkbox:SetWidth(35)
			Checkbox:SetHeight(35)
			Checkbox:SetFrameStrata("MEDIUM")
			Checkbox:SetScript("OnClick", function () 
				if Checkbox:GetChecked() == nil then 
					Rat_Settings["Notify"] = nil
				elseif Checkbox:GetChecked() == 1 then 
					Rat_Settings["Notify"] = 1 
				end
				end)
			Checkbox:SetScript("OnEnter", function() 
				GameTooltip:SetOwner(Checkbox, "ANCHOR_RIGHT");
				GameTooltip:SetText("Notify when abilites are ready", 255, 255, 0, 1, 1);
				GameTooltip:Show()
			end)
			Checkbox:SetScript("OnLeave", function() GameTooltip:Hide() end)
			Checkbox:SetChecked(Rat_Settings["Notify"])
			local text = Checkbox:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 45, 0)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Ability notification")
			
			-- invert abilities
			
			local Checkbox = CreateFrame("CheckButton", "invert abilities", self.tab10, "UICheckButtonTemplate")
			Checkbox:SetPoint("TOPLEFT",45,-325)
			Checkbox:SetWidth(35)
			Checkbox:SetHeight(35)
			Checkbox:SetFrameStrata("MEDIUM")
			Checkbox:SetScript("OnClick", function () 
				if Checkbox:GetChecked() == nil then 
					Rat_Settings["invert abilities"] = nil
				elseif Checkbox:GetChecked() == 1 then 
					Rat_Settings["invert abilities"] = 1 
				end
				end)
			Checkbox:SetScript("OnEnter", function() 
				GameTooltip:SetOwner(Checkbox, "ANCHOR_RIGHT");
				GameTooltip:SetText("Invert the way abilities stack, so they stack up", 255, 255, 0, 1, 1);
				GameTooltip:Show()
			end)
			Checkbox:SetScript("OnLeave", function() GameTooltip:Hide() end)
			Checkbox:SetChecked(Rat_Settings["invert abilities"])
			local text = Checkbox:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 45, 0)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Invert abilities")	
			
			-- Buttons for color picker
			
			local backdrop = {
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					bgFile = "Interface/Tooltips/UI-Tooltip-Background",
					tile="false",
					tileSize="4",
					edgeSize="4",
					insets={
						left="2",
						right="2",
						top="2",
						bottom="2"
					}
			}
			
			-- top bar 
			self.topbarcolor =  CreateFrame("Button","topbarcolor",self.tab10) -- 
			self.topbarcolor:SetWidth(25)
			self.topbarcolor:SetHeight(25)
			self.topbarcolor:SetPoint("TOPLEFT", 50, -80)
			self.topbarcolor:SetBackdrop(backdrop)
			self.topbarcolor:SetScript("OnClick", function()
				Rat:OpenColorPicker(this, "topbarcolor")
			end)
			
			self.topbarcolor.Texture = self.topbarcolor:CreateTexture(nil, 'ARTWORK')
			self.topbarcolor.Texture:SetTexture(Rat_Settings["topbarcolor"]["r"],Rat_Settings["topbarcolor"]["g"],Rat_Settings["topbarcolor"]["b"],1)
			self.topbarcolor.Texture:SetPoint('TOPLEFT', 2, -2)
			self.topbarcolor.Texture:SetWidth(21)
			self.topbarcolor.Texture:SetHeight(21)	
			
			local text = self.topbarcolor:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 40, 0)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Title bar color")

			
			-- ability bar 
			self.abilitybarcolor =  CreateFrame("Button","abilitybarcolor",self.tab10) -- 
			self.abilitybarcolor:SetWidth(25)
			self.abilitybarcolor:SetHeight(25)
			self.abilitybarcolor:SetPoint("TOPLEFT", 50, -130)
			self.abilitybarcolor:SetBackdrop(backdrop)
			self.abilitybarcolor:SetScript("OnClick", function()
				Rat:OpenColorPicker(this, "abilitybarcolor")
			end)
			
			self.abilitybarcolor.Texture = self.abilitybarcolor:CreateTexture(nil, 'ARTWORK')
			self.abilitybarcolor.Texture:SetTexture(Rat_Settings["abilitybarcolor"]["r"],Rat_Settings["abilitybarcolor"]["g"],Rat_Settings["abilitybarcolor"]["b"],1)
			self.abilitybarcolor.Texture:SetPoint('TOPLEFT', 2, -2)
			self.abilitybarcolor.Texture:SetWidth(21)
			self.abilitybarcolor.Texture:SetHeight(21)	
			
			local text = self.abilitybarcolor:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 40, 0)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Ability bar color")
			
			-- ability text 
			self.abilitytextcolor =  CreateFrame("Button","abilitytextcolor",self.tab10) -- 
			self.abilitytextcolor:SetWidth(25)
			self.abilitytextcolor:SetHeight(25)
			self.abilitytextcolor:SetPoint("TOPLEFT", 50, -180)
			self.abilitytextcolor:SetBackdrop(backdrop)
			self.abilitytextcolor:SetScript("OnClick", function()
				Rat:OpenColorPicker(this, "abilitytextcolor")
			end)
			
			self.abilitytextcolor.Texture = self.abilitytextcolor:CreateTexture(nil, 'ARTWORK')
			self.abilitytextcolor.Texture:SetTexture(Rat_Settings["abilitytextcolor"]["r"],Rat_Settings["abilitytextcolor"]["g"],Rat_Settings["abilitytextcolor"]["b"],1)
			self.abilitytextcolor.Texture:SetPoint('TOPLEFT', 2, -2)
			self.abilitytextcolor.Texture:SetWidth(21)
			self.abilitytextcolor.Texture:SetHeight(21)	
			
			local text = self.abilitytextcolor:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 40, 0)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Ability text color")

			-- font dropdown
			
			self.FontDropdown = CreateFrame("Button", "Font Dropdown",self.tab10, "UIDropDownMenuTemplate")
			self.FontDropdown:SetPoint("TOPLEFT", 250, -80)
			
			local text = self.FontDropdown:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 165, 2)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Font")
			
			UIDropDownMenu_Initialize(self.FontDropdown, Rat.Options.FontDrop)
			UIDropDownMenu_SetSelectedID(self.FontDropdown, Rat_Settings["font"])
			
			-- bartexture dropdown

			self.BarTextureDropdown = CreateFrame("Button", "Bar texture Dropdown",self.tab10, "UIDropDownMenuTemplate")
			self.BarTextureDropdown:SetPoint("TOPLEFT", 250 , -130)
			
			local text = self.BarTextureDropdown:CreateFontString(nil, "OVERLAY")
			text:SetPoint("LEFT", 165, 2)
			text:SetFont("Fonts\\FRIZQT__.TTF", 12)
			text:SetTextColor(1, 1, 1, 1)
			text:SetShadowOffset(2,-2)
			text:SetText("Bar texture")
			
			UIDropDownMenu_Initialize(self.BarTextureDropdown, Rat.Options.BarTextureDrop)
			UIDropDownMenu_SetSelectedID(self.BarTextureDropdown, Rat_Settings["bartexture"])
			
				
		else
			local r,g,b,o = Rat:ClassColors(RatMenu[i])
			local text = self["tab"..i]:CreateFontString(nil, "OVERLAY")
			text:SetPoint("CENTER", 0, (self["tab"..i]:GetHeight()/2)-25)
			text:SetFont("Fonts\\FRIZQT__.TTF", 17)
			text:SetTextColor(r, g, b, o)
			text:SetShadowOffset(2,-2)
			text:SetText(RatMenu[i].."|cffFFFFFF Options")
			
			local x = 0
			local y = 0
			for ability,texture in pairs(RatAbilityMenu[RatMenu[i]]) do
				if (ability == "Bloodlust" and UnitFactionGroup("player") ~= "Horde") or (ability == "Heroism" and UnitFactionGroup("player") ~= "Alliance") then
				else
					if y == 4 then
						x=x+1
						y=0
					end
					
					local Checkbox = CreateFrame("CheckButton", ability, self["tab"..i], "UICheckButtonTemplate")
					Checkbox:SetPoint("TOPLEFT",75+(x*150),-(y*80)-75)
					Checkbox:SetWidth(58)
					Checkbox:SetHeight(62)
					Checkbox:SetFrameStrata("LOW")
					Checkbox:SetScript("OnClick", function () 
						if Checkbox:GetChecked() == nil then 
							Rat_Settings[ability] = nil
						elseif Checkbox:GetChecked() == 1 then 
							Rat_Settings[ability] = 1 
						end
						end)
					Checkbox:SetScript("OnEnter", function() 
						GameTooltip:SetOwner(Checkbox, "ANCHOR_RIGHT");
						GameTooltip:SetText("Show/Hide this ability", 255, 255, 0, 1, 1);
						GameTooltip:Show()
					end)
					Checkbox:SetScript("OnLeave", function() GameTooltip:Hide() end)
					Checkbox:SetChecked(Rat_Settings[ability])
					local Icon = self["tab"..i]:CreateTexture(nil, 'ARTWORK',1)
					Icon:SetTexture(texture)
					Icon:SetWidth(34)
					Icon:SetHeight(34)
					Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					Icon:SetPoint("CENTER", Checkbox, "CENTER",1,-1)
					local text = self["tab"..i]:CreateFontString(nil, "OVERLAY")
					text:SetPoint("CENTER", Checkbox, "CENTER", 0, 27)
					text:SetFont("Fonts\\FRIZQT__.TTF", 12)
					text:SetTextColor(1, 1, 1, 1)
					text:SetShadowOffset(2,-2)
					text:SetText(ability)	
					
					y=y+1
				end
			end
			tab:Hide()
		end
		
		-- menu buttons
		local frame = CreateFrame("button",i,self.List)
		frame:SetWidth(198)
		frame:SetHeight(40)
		frame:SetPoint("TOPLEFT",1,-(i*frame:GetHeight()-frame:GetHeight()))
		frame:EnableMouse(1)

		local highlight = frame:CreateTexture(nil, 'OVERLAY')
		highlight:SetTexture("Interface\\Glues\\CharacterSelect\\Glues-CharacterSelect-Highlight")
		highlight:SetPoint('CENTER', 0, 0)
		highlight:SetWidth(frame:GetWidth())
		highlight:SetHeight(frame:GetHeight()+4)
		highlight:SetAlpha(0)

		frame:SetScript("OnClick", function() 
			for index=1,10 do
				if self["tab"..index]:IsVisible() then
					self["tab"..index]:Hide()
				end
			end
			self["tab"..this:GetName()]:Show()
		end)
		frame:SetScript("OnEnter", function() 
			highlight:SetAlpha(0.5)
		end)
		frame:SetScript("OnLeave", function() 
			highlight:SetAlpha(0)
		end)
		
		local icon = frame:CreateTexture(nil, 'ARTWORK')
		local r,g,b,o = 1,1,1,1
		if i == 10 then
			icon:SetTexture("Interface\\Icons\\Trade_Engineering")
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			r,g,b,o = 1,1,1,1
		else
			local d, l, t, p = Rat:ClassPos(RatMenu[i])
			icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			icon:SetTexCoord(d, l, t, p)
			r,g,b,o = Rat:ClassColors(RatMenu[i])
		end
		icon:SetPoint('TOPLEFT', 1, -4)
		icon:SetWidth(frame:GetHeight()-4)
		icon:SetHeight(frame:GetHeight()-7)
		
		local text = frame:CreateFontString(nil, "OVERLAY")
		text:SetPoint("LEFT",80, 0)
		text:SetFont("Fonts\\FRIZQT__.TTF", 17)
		text:SetTextColor(r,g,b,o)
		text:SetShadowOffset(1,-1)
		text:SetText(RatMenu[i])
	
	end
	self:Hide()
end

-- dropdown functions

function Rat.Options:FontDrop()
	local info={}
	local i=1
	for k,v in pairs(Rat_Font) do
		info.text=v
		info.value=i
		info.func= function () UIDropDownMenu_SetSelectedID(Rat.Options.FontDropdown, this:GetID())
			Rat_Settings["font"] = this:GetID()
			Rat.Mainframe.Background.Top.Title:SetFont("Interface\\AddOns\\Rat\\fonts\\"..Rat_Font[Rat_Settings["font"]]..".TTF", Rat_FontSize[Rat_Settings["font"]]+1)
		end
		info.checked = nil
		info.checkable = nil
		UIDropDownMenu_AddButton(info, 1)
		i=i+1
	end
end

function Rat.Options:BarTextureDrop()
	local info={}
	local i=1
	for k,v in pairs(Rat_BarTexture) do
		info.text=v
		info.value=i
		info.func= function () UIDropDownMenu_SetSelectedID(Rat.Options.BarTextureDropdown, this:GetID())
			Rat_Settings["bartexture"] = this:GetID()
		end
		info.checked = nil
		info.checkable = nil
		UIDropDownMenu_AddButton(info, 1)
		i=i+1
	end
end

-- function that creates the cooldown bars that will be shown in the Rat window

function Rat:CreateFrame(name)
	local frame = CreateFrame('Button', name, Rat.Mainframe.Background.Tab1)
	frame:SetBackdrop({ bgFile=[[Interface/Tooltips/UI-Tooltip-Background]] })
	frame:SetBackdropColor(0,0,0,1)
	frame.unit = frame:CreateTexture(nil, 'ARTWORK')
	frame.unit:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	frame.unit:SetWidth(60)
	frame.unit:SetHeight(20)
	frame.unit:SetPoint('TOPLEFT', 1, -1)
	frame.unit:SetTexture("Interface/TargetingFrame/UI-StatusBar")
	frame.unitname = frame:CreateFontString(nil, "ARTWORK")
	frame.unitname:SetPoint("LEFT", frame.unit, "LEFT", 2, 0)
	frame.unitname:SetFont("Fonts\\FRIZQT__.TTF", 10)
	frame.unitname:SetTextColor(255, 255, 255, 1)
	frame.unitname:SetShadowOffset(2,-2)
	frame.unitname:SetText("Name")
	frame.icon = frame:CreateTexture(nil, 'OVERLAY')
	frame.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	frame.icon:SetWidth(20)
	frame.icon:SetHeight(20)
	frame.icon:SetPoint('TOPLEFT', 62, -1)
	frame.bar = frame:CreateTexture(nil, 'ARTWORK')
	frame.bar:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	frame.bar:SetWidth(20)
	frame.bar:SetHeight(20)
	frame.bar:SetPoint('TOPLEFT', 83, -1)
	frame.bar:SetTexture(Rat_Settings["abilitybarcolor"]["r"],Rat_Settings["abilitybarcolor"]["g"],Rat_Settings["abilitybarcolor"]["b"],1)
	frame.timer = frame:CreateFontString(nil, "OVERLAY")
	frame.timer:SetPoint("LEFT", frame, "LEFT", 90, 0)
	frame.timer:SetFont("Fonts\\FRIZQT__.TTF", 10)
	frame.timer:SetTextColor(Rat_Settings["abilitytextcolor"]["r"],Rat_Settings["abilitytextcolor"]["g"],Rat_Settings["abilitytextcolor"]["b"], 1)
	frame.timer:SetShadowOffset(2,-2)
	frame.timer:SetText("1")
	frame.time = frame:CreateFontString(nil, "OVERLAY")
	frame.time:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	frame.time:SetFont("Fonts\\FRIZQT__.TTF", 11)
	frame.time:SetTextColor(Rat_Settings["abilitytextcolor"]["r"],Rat_Settings["abilitytextcolor"]["g"],Rat_Settings["abilitytextcolor"]["b"], 1)
	frame.time:SetShadowOffset(2,-2)
	frame.time:SetText("1")
	frame.barglow = CreateFrame('Button', "glow", frame)
	frame.barglow:SetWidth(2)
	frame.barglow:SetHeight(20)
	frame.barglow.d = frame.barglow:CreateTexture(nil, "BORDER")
	frame.barglow.d:SetWidth(4)
	frame.barglow.d:SetHeight(20)
	frame.barglow.d:SetTexture(1, 1, 1, 0.7)
	frame.barglow.d:SetGradientAlpha("Horizontal", 1, 1, 1, 0, 1, 1, 1, 0.8)
	frame.barglow.u = frame.barglow:CreateTexture(nil, "BORDER")
	frame.barglow.u:SetWidth(4)
	frame.barglow.u:SetHeight(20)
	frame.barglow.u:SetTexture(1, 1, 1, 0.7)
	frame.barglow.u:SetGradientAlpha("Horizontal", 1, 1, 1, 0.8, 1, 1, 1, 0)
	frame.barglow.d:SetPoint("CENTER", -2, 0)
	frame.barglow.u:SetPoint("CENTER", 2, 0)
	frame:SetScript("OnClick", function()
		local playername = frame.unitname:GetText()
		local cooldowntimer = frame.time:GetText()
		local cooldownName = frame.timer:GetText()
		Rat:msg(playername.." has "..cooldowntimer.." cooldown on "..GetSpellLink(cooldownName))
	end)
	return frame
end

-- minimap

function Rat.Minimap:CreateMinimapIcon()
	local Moving = false
	
	function self:OnMouseUp()
		Moving = false;
	end
	
	function self:OnMouseDown()
		PlaySound("igMainMenuOptionCheckBoxOn")
		Moving = false;
		if (arg1 == "LeftButton") then 
			if Rat.Mainframe:IsVisible() then 
				Rat.Mainframe:Hide()
				Rat_Settings["showhide"] = 0
			else 
				Rat.Mainframe:Show() 
				Rat_Settings["showhide"] = 1
			end
		elseif (arg1 == "RightButton") then
			if Rat.Options:IsVisible() then Rat.Options:Hide()
			else Rat.Options:Show() end
		else Moving = true;
		end
	end
	
	function self:OnUpdate()
		if Moving == true then
			local xpos,ypos = GetCursorPosition();
			local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom();
			xpos = xmin-xpos/UIParent:GetScale()+70;
			ypos = ypos/UIParent:GetScale()-ymin-70;
			local RATIconPos = math.deg(math.atan2(ypos,xpos));
			if (RATIconPos < 0) then
				RATIconPos = RATIconPos + 360
			end
			Rat_Settings["MinimapX"] = 54 - (78 * cos(RATIconPos));
			Rat_Settings["MinimapY"] = (78 * sin(RATIconPos)) - 55;
			
			Rat.Minimap:SetPoint(
			"TOPLEFT",
			"Minimap",
			"TOPLEFT",
			Rat_Settings["MinimapX"],
			Rat_Settings["MinimapY"]);
		end
	end
	
	function self:OnEnter()
		GameTooltip:SetOwner(Rat.Minimap, "ANCHOR_LEFT");
		GameTooltip:SetText("Raid Ability Tracker");
		GameTooltip:AddLine("Left Click to show/hide RAT.",1,1,1);
		GameTooltip:AddLine("Right Click to show/hide options menu.",1,1,1);
		GameTooltip:AddLine("Middle Button Click to move Icon.",1,1,1);
		GameTooltip:Show()
	end
	
	function self:OnLeave()
		GameTooltip:Hide()
	end

	self:SetFrameStrata("LOW")
	self:SetWidth(31) -- Set these to whatever height/width is needed 
	self:SetHeight(31) -- for your Texture
	self:SetPoint("CENTER", -75, -20)
	
	self.Button = CreateFrame("Button",nil,self)
	self.Button:SetPoint("CENTER",0,0)
	self.Button:SetWidth(31)
	self.Button:SetHeight(31)
	self.Button:SetFrameLevel(8)
	self.Button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	self.Button:SetScript("OnMouseUp", self.OnMouseUp)
	self.Button:SetScript("OnMouseDown", self.OnMouseDown)
	self.Button:SetScript("OnUpdate", self.OnUpdate)
	self.Button:SetScript("OnEnter", self.OnEnter)
	self.Button:SetScript("OnLeave", self.OnLeave)
	
	local overlay = self:CreateTexture(nil, 'OVERLAY',self)
	overlay:SetWidth(53)
	overlay:SetHeight(53)
	overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	overlay:SetPoint('TOPLEFT',0,0)
	
	local icon = self:CreateTexture(nil, "BACKGROUND")
	icon:SetWidth(20)
	icon:SetHeight(20)
	icon:SetTexture("Interface\\AddOns\\Rat\\Media\\Icon")
	icon:SetTexCoord(0.18, 0.82, 0.18, 0.82)
	icon:SetPoint('CENTER', 0, 0)
	self.icon = icon
	
	Rat.Minimap:SetPoint(
			"TOPLEFT",
			"Minimap",
			"TOPLEFT",
			Rat_Settings["MinimapX"],
			Rat_Settings["MinimapY"])

end

-- Color picker functions

function Rat:SetColor()
	local r,g,b = ColorPickerFrame:GetColorRGB();
	local swatch,frame;
	frame = getglobal(RAT_CP_OBJ:GetName());      -- enregistre la couleur
	frame.r = r;
	frame.g = g;
	frame.b = b;
	
	if RAT_CP_TYPE == "topbarcolor" then
		topbg:SetTexture(r,g,b)
		topbg:SetGradientAlpha("Vertical", 1,1,1, 0.25, 1, 1, 1, 1)
		Rat.Options.topbarcolor.Texture:SetTexture(r,g,b)
		Rat_Settings[RAT_CP_TYPE]["r"] = r
		Rat_Settings[RAT_CP_TYPE]["g"] = g
		Rat_Settings[RAT_CP_TYPE]["b"] = b
	elseif RAT_CP_TYPE == "abilitybarcolor" then
		Rat.Options.abilitybarcolor.Texture:SetTexture(r,g,b)
		Rat_Settings[RAT_CP_TYPE]["r"] = r
		Rat_Settings[RAT_CP_TYPE]["g"] = g
		Rat_Settings[RAT_CP_TYPE]["b"] = b	
	elseif RAT_CP_TYPE == "abilitytextcolor" then
		Rat.Options.abilitytextcolor.Texture:SetTexture(r,g,b)
		Rat_Settings[RAT_CP_TYPE]["r"] = r
		Rat_Settings[RAT_CP_TYPE]["g"] = g
		Rat_Settings[RAT_CP_TYPE]["b"] = b	
	end
end

function Rat:CancelColor()
	local r = ColorPickerFrame.previousValues.r;
	local g = ColorPickerFrame.previousValues.g;
	local b = ColorPickerFrame.previousValues.b;
	local swatch,frame;

	frame = getglobal(RAT_CP_OBJ:GetName());      -- enregistre la couleur

	frame.r = r;
	frame.g = g;
	frame.b = b;

	if RAT_CP_TYPE == "topbarcolor" then
		topbg:SetTexture(r,g,b)
		topbg:SetGradientAlpha("Vertical", 1,1,1, 0.25, 1, 1, 1, 1)
		Rat.Options.topbarcolor.Texture:SetTexture(r,g,b)
		Rat_Settings[RAT_CP_TYPE]["r"] = r
		Rat_Settings[RAT_CP_TYPE]["g"] = g
		Rat_Settings[RAT_CP_TYPE]["b"] = b
	elseif RAT_CP_TYPE == "abilitybarcolor" then
		Rat.Options.abilitybarcolor.Texture:SetTexture(r,g,b)
		Rat_Settings[RAT_CP_TYPE]["r"] = r
		Rat_Settings[RAT_CP_TYPE]["g"] = g
		Rat_Settings[RAT_CP_TYPE]["b"] = b	
	elseif RAT_CP_TYPE == "abilitytextcolor" then
		Rat.Options.abilitytextcolor.Texture:SetTexture(r,g,b)
		Rat_Settings[RAT_CP_TYPE]["r"] = r
		Rat_Settings[RAT_CP_TYPE]["g"] = g
		Rat_Settings[RAT_CP_TYPE]["b"] = b	
	end
end

function Rat:OpenColorPicker(obj, type)
	RAT_CP_OBJ = obj
	RAT_CP_TYPE = type

	button = getglobal(obj:GetName());

	ColorPickerFrame.func = Rat.SetColor -- button.swatchFunc;
	ColorPickerFrame:SetColorRGB(Rat_Settings[RAT_CP_TYPE]["r"], Rat_Settings[RAT_CP_TYPE]["g"], Rat_Settings[RAT_CP_TYPE]["b"]);
	ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, opacity = button.opacity};
	ColorPickerFrame.cancelFunc = Rat.CancelColor

	ColorPickerFrame:SetPoint("TOPLEFT", obj, "TOPRIGHT", 0, 0)

	ColorPickerFrame:Show();
end

-- hypelink conversion to text

function Rat:hyperlink_name(hyperlink)
    local _, _, name = strfind(hyperlink, '|Hitem:%d+:%d+:%d+:%d+|h[[]([^]]+)[]]|h')
    return name
end

-- function to get chat type (say,party,raid,whisper)

function Rat:msg(text)
	local channel, chatnumber = ChatFrameEditBox.chatType
	if channel == "WHISPER" then
		chatnumber = ChatFrameEditBox.tellTarget
	elseif channel == "CHANNEL" then
		chatnumber = ChatFrameEditBox.channelTarget
	end
	SendChatMessage(text, channel, nil, chatnumber)
end

-- functions to list all abilities on cooldown into our table

function getInvCd()
	if RatTbl[Rat_unit] == nil then RatTbl[Rat_unit] = { } end
    for rbag = 0,4 do
        if GetBagName(rbag) then
            for rslot = 1, GetContainerNumSlots(rbag) do
				local s_time, duration, enabled = GetContainerItemCooldown(rbag, rslot)
				if s_time > 0 then					
					local name = Rat:hyperlink_name(GetContainerItemLink(rbag, rslot))
					--Rat:Print("1: "..s_time)
					for i,_ in pairs(cdtbl) do
						if strfind(GetContainerItemLink(rbag, rslot),i) then
							--Rat:Print(i.." "..duration.." "..enabled)
							if RatTbl[Rat_unit][i] == nil then RatTbl[Rat_unit][i] = { } end
							if duration > 2.5 then
								local timeleft = duration-(GetTime()-s_time)
								
								if (duration-math_floor(timeleft)) == 0 then
									--Rat:Print("sending cd "..i)
									SendAddonMessage("RATSYNC["..duration.."]("..i..")",timeleft,"RAID")
									RatTbl[Rat_unit][i]["duration"] = timeleft+GetTime()
									RatTbl[Rat_unit][i]["cd"] = duration
									sendThrottle[i] = GetTime()
								end
								if sendThrottle[i] == nil or (GetTime() - sendThrottle[i]) > 10 then
									--Rat:Print("sending cd "..i)
									SendAddonMessage("RATSYNC["..duration.."]("..i..")",timeleft,"RAID")
									RatTbl[Rat_unit][i]["duration"] = timeleft+GetTime()
									RatTbl[Rat_unit][i]["cd"] = duration
									sendThrottle[i] = GetTime()
								end
							elseif duration == 0 then
								RatTbl[Rat_unit][name]["duration"] = 0
							end
						end
					end
				end
			end
		end
	end
end


--[[ Optimized version, checks only spells that are tracked 
]]--
function getSpells()
if RatTbl[Rat_unit] == nil then RatTbl[Rat_unit] = { } end
for spell in pairs(RAT_PlayerSpells) do 
local start, duration, hasCooldown = GetSpellCooldown(spell)
	if RatTbl[Rat_unit][spell] == nil then RatTbl[Rat_unit][spell] = { } end
		if hasCooldown == 1 and duration > 2.5 then
			local timeleft = duration-(GetTime()-start)
			RatTbl[Rat_unit][spell]["duration"] = timeleft+GetTime()
			RatTbl[Rat_unit][spell]["cd"] = duration
		else
			--RatTbl[Rat_unit][spell]["duration"] = 0
		end
	end 
end 

-- function to send our cooldowns to the raid
function sendCds()
		local spellID = 1
		local spell = GetSpellName(spellID, BOOKTYPE_SPELL)
		if RatTbl[Rat_unit] == nil then RatTbl[Rat_unit] = { } end
		while (spell) do
			local start, duration, hasCooldown = GetSpellCooldown(spellID, BOOKTYPE_SPELL)
			for i,_ in pairs(RatTbl[Rat_unit]) do
				if i == spell then
				
					if hasCooldown == 1 and duration > 2.5 then
					local timeleft = duration-(GetTime()-start)
						if (RatTbl[Rat_unit][i]["cd"]-math_floor(timeleft)) == 0 then
							SendAddonMessage("RATSYNC["..duration.."]("..i..")",timeleft,"RAID")
							sendThrottle[i] = GetTime()
						end
						if sendThrottle[i] == nil or (GetTime() - sendThrottle[i]) > 10 then
							SendAddonMessage("RATSYNC["..duration.."]("..i..")",timeleft,"RAID")
							sendThrottle[i] = GetTime()
						end
					else
					end
				end
			end		
			spellID = spellID + 1
			spell = GetSpellName(spellID, BOOKTYPE_SPELL)
		end
	if sendThrottle["Master Soulstone"] == nil or (GetTime() - sendThrottle["Master Soulstone"]) > 10 then
		if (RatTbl[Rat_unit]["Master Soulstone"]) then
			if RatTbl[Rat_unit]["Master Soulstone"]["duration"]-GetTime() > 0 then
				SendAddonMessage("RATSYNC["..RatTbl[Rat_unit]["Master Soulstone"]["cd"].."](Master Soulstone)",RatTbl[Rat_unit]["Master Soulstone"]["duration"]-GetTime(),"RAID")
			else
			end
			sendThrottle["Master Soulstone"] = GetTime()
		end
	end
	sendAddMsg = GetTime()
end

-- add an ability cooldown we got from a raidmember

function Rat:AddCd(name,cdname,cd,duration)
	if name ~= nil and cdname ~= nil and cd ~= nil and duration ~= nil then
		if RatTbl[name] == nil then RatTbl[name] = {} end
		if RatTbl[name][cdname] == nil then RatTbl[name][cdname] = {} end
		RatTbl[name][cdname]["duration"] = duration+GetTime()
		RatTbl[name][cdname]["cd"] = cd
		Rat:Update()
	end
end

-- function to check if a player is still in raid

function Rat:InRaidCheck(name)
	if GetRaidRosterInfo(1) then
		for i=1,GetNumRaidMembers() do
			if name == UnitName("raid"..i) then
				return true
			end
		end
	elseif GetNumPartyMembers() ~= 0 then
		for i=1,GetNumPartyMembers() do
			if name == UnitName("party"..i) then
				return true
			end
		end		
	end
	return false
end

-- function to clear our database, we don't want cooldowns from people not in raid.

function Rat:Cleardb()
	if GetRaidRosterInfo(1) then
		for name,_ in pairs(RatTbl) do
			if name ~= UnitName("player") and not Rat:InRaidCheck(name) then
				for ability, dura in pairs(RatTbl[name]) do
					local rframe = name..ability
					RatFrames[rframe]:Hide()
				end
				RatTbl[name]=nil
			end
		end
	elseif GetNumPartyMembers() ~= 0 then
		for name,_ in pairs(RatTbl) do
			if name ~= UnitName("player") and not Rat:InRaidCheck(name) then
				for ability, dura in pairs(RatTbl[name]) do
					local rframe = name..ability
					RatFrames[rframe]:Hide()
				end
				RatTbl[name]=nil
			end
		end	
	else
		for name,_ in pairs(RatTbl) do
			if name ~= UnitName("player") then
				for ability, dura in pairs(RatTbl[name]) do
					local rframe = name..ability
					if rframe ~= nil then RatFrames[rframe]:Hide() end
				end
				RatTbl[name]=nil
			end
		end
	end
end

-- hides version frames for players not in raid anymore for our version check frame

function Rat:HideVersionNameFrames()
	if GetRaidRosterInfo(1) then
		for name,frame in pairs(VersionFTbl) do
			if name ~= UnitName("player") and not Rat:InRaidCheck(name) then
				frame:Hide()
				RatVersionTbl[name] = nil
			end
		end
	elseif GetNumPartyMembers() ~= 0 then
		for name,frame in pairs(VersionFTbl) do
			if name ~= UnitName("player") and not Rat:InRaidCheck(name) then
				frame:Hide()
				RatVersionTbl[name] = nil
			end
		end	
	else
		for name,frame in pairs(VersionFTbl) do
			if name ~= UnitName("player") then
				frame:Hide()
				RatVersionTbl[name] = nil
			end
		end
	end
	Rat.Version:Check()
end

-- function to get classcolors from a player

function Rat:GetClassColors(name)
	if name == UnitName("player") then
		if UnitClass("player") == "Warrior" then return 0.78, 0.61, 0.43,1
		elseif UnitClass("player") == "Hunter" then return 0.67, 0.83, 0.45
		elseif UnitClass("player") == "Mage" then return 0.41, 0.80, 0.94
		elseif UnitClass("player") == "Rogue" then return 1.00, 0.96, 0.41
		elseif UnitClass("player") == "Warlock" then return 0.58, 0.51, 0.79,1
		elseif UnitClass("player") == "Druid" then return 1, 0.49, 0.04,1
		elseif UnitClass("player") == "Shaman" then return 0.0, 0.44, 0.87	
		elseif UnitClass("player") == "Priest" then return 1.00, 1.00, 1.00
		elseif UnitClass("player") == "Paladin" then return 0.96, 0.55, 0.73
		end
	end
	if GetRaidRosterInfo(1) then
		for i=1,GetNumRaidMembers() do
			if UnitName("raid"..i) == name then
				if UnitClass("raid"..i) == "Warrior" then return 0.78, 0.61, 0.43,1
				elseif UnitClass("raid"..i) == "Hunter" then return 0.67, 0.83, 0.45
				elseif UnitClass("raid"..i) == "Mage" then return 0.41, 0.80, 0.94
				elseif UnitClass("raid"..i) == "Rogue" then return 1.00, 0.96, 0.41
				elseif UnitClass("raid"..i) == "Warlock" then return 0.58, 0.51, 0.79,1
				elseif UnitClass("raid"..i) == "Druid" then return 1, 0.49, 0.04,1
				elseif UnitClass("raid"..i) == "Shaman" then return 0.0, 0.44, 0.87	
				elseif UnitClass("raid"..i) == "Priest" then return 1.00, 1.00, 1.00
				elseif UnitClass("raid"..i) == "Paladin" then return 0.96, 0.55, 0.73
				end
			end
		end
	else
		for i=1,GetNumPartyMembers() do
			if UnitName("party"..i) == name then
				if UnitClass("party"..i) == "Warrior" then return 0.78, 0.61, 0.43,1
				elseif UnitClass("party"..i) == "Hunter" then return 0.67, 0.83, 0.45
				elseif UnitClass("party"..i) == "Mage" then return 0.41, 0.80, 0.94
				elseif UnitClass("party"..i) == "Rogue" then return 1.00, 0.96, 0.41
				elseif UnitClass("party"..i) == "Warlock" then return 0.58, 0.51, 0.79,1
				elseif UnitClass("party"..i) == "Druid" then return 1, 0.49, 0.04,1
				elseif UnitClass("party"..i) == "Shaman" then return 0.0, 0.44, 0.87	
				elseif UnitClass("party"..i) == "Priest" then return 1.00, 1.00, 1.00
				elseif UnitClass("party"..i) == "Paladin" then return 0.96, 0.55, 0.73
				end
			end
		end	
	end
end

function Rat_GetClassColors(name)
	if name == UnitName("player") then
		if UnitClass("player") == "Warrior" then return "|cffC79C6E"..name.."|r"
		elseif UnitClass("player") == "Hunter" then return "|cffABD473"..name.."|r"
		elseif UnitClass("player") == "Mage" then return "|cff69CCF0"..name.."|r"
		elseif UnitClass("player") == "Rogue" then return "|cffFFF569"..name.."|r"
		elseif UnitClass("player") == "Warlock" then return "|cff9482C9"..name.."|r"
		elseif UnitClass("player") == "Druid" then return "|cffFF7D0A"..name.."|r"
		elseif UnitClass("player") == "Shaman" then return "|cff0070DE"..name.."|r"
		elseif UnitClass("player") == "Priest" then return "|cffFFFFFF"..name.."|r"
		elseif UnitClass("player") == "Paladin" then return "|cffF58CBA"..name.."|r"
		end
	end
	if GetRaidRosterInfo(1) then
		for i=1,GetNumRaidMembers() do
			if UnitName("raid"..i) == name then
				if UnitClass("raid"..i) == "Warrior" then return "|cffC79C6E"..name.."|r"
				elseif UnitClass("raid"..i) == "Hunter" then return "|cffABD473"..name.."|r"
				elseif UnitClass("raid"..i) == "Mage" then return "|cff69CCF0"..name.."|r"
				elseif UnitClass("raid"..i) == "Rogue" then return "|cffFFF569"..name.."|r"
				elseif UnitClass("raid"..i) == "Warlock" then return "|cff9482C9"..name.."|r"
				elseif UnitClass("raid"..i) == "Druid" then return "|cffFF7D0A"..name.."|r"
				elseif UnitClass("raid"..i) == "Shaman" then return "|cff0070DE"..name.."|r"
				elseif UnitClass("raid"..i) == "Priest" then return "|cffFFFFFF"..name.."|r"
				elseif UnitClass("raid"..i) == "Paladin" then return "|cffF58CBA"..name.."|r"
				end
			end
		end
	else
		for i=1,GetNumPartyMembers() do
			if UnitName("party"..i) == name then
				if UnitClass("party"..i) == "Warrior" then return "|cffC79C6E"..name.."|r"
				elseif UnitClass("party"..i) == "Hunter" then return "|cffABD473"..name.."|r"
				elseif UnitClass("party"..i) == "Mage" then return "|cff69CCF0"..name.."|r"
				elseif UnitClass("party"..i) == "Rogue" then return "|cffFFF569"..name.."|r"
				elseif UnitClass("party"..i) == "Warlock" then return "|cff9482C9"..name.."|r"
				elseif UnitClass("party"..i) == "Druid" then return "|cffFF7D0A"..name.."|r"
				elseif UnitClass("party"..i) == "Shaman" then return "|cff0070DE"..name.."|r"
				elseif UnitClass("party"..i) == "Priest" then return "|cffFFFFFF"..name.."|r"
				elseif UnitClass("party"..i) == "Paladin" then return "|cffF58CBA"..name.."|r"
				end
			end
		end
	end
end

function Rat:ClassColors(class)
	if class == "Warrior" then return 0.78, 0.61, 0.43,1
	elseif class == "Hunter" then return 0.67, 0.83, 0.45
	elseif class == "Mage" then return 0.41, 0.80, 0.94
	elseif class == "Rogue" then return 1.00, 0.96, 0.41
	elseif class == "Warlock" then return 0.58, 0.51, 0.79,1
	elseif class == "Druid" then return 1, 0.49, 0.04,1
	elseif class == "Shaman" then return 0.0, 0.44, 0.87	
	elseif class == "Priest" then return 1.00, 1.00, 1.00
	elseif class == "Paladin" then return 0.96, 0.55, 0.73
	end
end

-- function to get class of a player

function Rat:GetClass(name)
	if name == UnitName("player") then
		if UnitClass("player") == "Warrior" then return "Warrior"
		elseif UnitClass("player") == "Hunter" then return "Hunter"
		elseif UnitClass("player") == "Mage" then return "Mage"
		elseif UnitClass("player") == "Rogue" then return "Rogue"
		elseif UnitClass("player") == "Warlock" then return "Warlock"
		elseif UnitClass("player") == "Druid" then return "Druid"
		elseif UnitClass("player") == "Shaman" then return "Shaman"
		elseif UnitClass("player") == "Priest" then return "Priest"
		elseif UnitClass("player") == "Paladin" then return "Paladin"
		end
	end
	if GetRaidRosterInfo(1) then
		for i=1,GetNumRaidMembers() do
			if UnitName("raid"..i) == name then
				if UnitClass("raid"..i) == "Warrior" then return "Warrior"
				elseif UnitClass("raid"..i) == "Hunter" then return "Hunter"
				elseif UnitClass("raid"..i) == "Mage" then return "Mage"
				elseif UnitClass("raid"..i) == "Rogue" then return "Rogue"
				elseif UnitClass("raid"..i) == "Warlock" then return "Warlock"
				elseif UnitClass("raid"..i) == "Druid" then return "Druid"
				elseif UnitClass("raid"..i) == "Shaman" then return "Shaman"
				elseif UnitClass("raid"..i) == "Priest" then return "Priest"
				elseif UnitClass("raid"..i) == "Paladin" then return "Paladin"
				end
			end
		end
	else
		for i=1,GetNumPartyMembers() do
			if UnitName("party"..i) == name then
				if UnitClass("party"..i) == "Warrior" then return "Warrior"
				elseif UnitClass("party"..i) == "Hunter" then return "Hunter"
				elseif UnitClass("party"..i) == "Mage" then return "Mage"
				elseif UnitClass("party"..i) == "Rogue" then return "Rogue"
				elseif UnitClass("party"..i) == "Warlock" then return "Warlock"
				elseif UnitClass("party"..i) == "Druid" then return "Druid"
				elseif UnitClass("party"..i) == "Shaman" then return "Shaman"
				elseif UnitClass("party"..i) == "Priest" then return "Priest"
				elseif UnitClass("party"..i) == "Paladin" then return "Paladin"
				end
			end
		end
	end
end

-- function to get correct coords for classes in the 

function Rat:ClassPos(class)
	if(class=="Warrior") then return 0.02, 	0.23,	0.03,	0.23;	end
	if(class=="Mage")    then return 0.27,	0.48,	0.03,	0.23;	end
	if(class=="Rogue")   then return 0.52,	0.73,	0.03,	0.23;	end
	if(class=="Druid")   then return 0.77,	0.98,	0.03,	0.23;	end
	if(class=="Hunter")  then return 0.02,	0.23,	0.28,	0.48;	end
	if(class=="Shaman")  then return 0.27,	0.48,	0.28,	0.48;	end
	if(class=="Priest")  then return 0.52,	0.73,	0.28,	0.48;	end
	if(class=="Warlock") then return 0.77,	0.98,	0.28,	0.48;	end
	if(class=="Paladin") then return 0.02,	0.23,	0.53,	0.72;	end
	return 0.25, 0.5, 0.5, 0.75	-- Returns empty next one, so blank
end

-- update function

function Rat:Update()
	if uptimer == nil or (GetTime() - uptimer > 0.01) then
			uptimer = GetTime()	
		if Rat_Settings["showhide"] == 1 then
			if not Rat.Mainframe:IsVisible() then
				Rat.Mainframe:Show()
			end
		else
			if Rat.Mainframe:IsVisible() then
				Rat.Mainframe:Hide()
			end
		end
		if Rat_Settings["Minimap"] == nil and Rat.Minimap:IsVisible() then
			Rat.Minimap:Hide()
		elseif Rat_Settings["Minimap"] == 1 and not Rat.Minimap:IsVisible() then
			Rat.Minimap:Show()
		end
		if Rat.Options.version ~= nil and (((GetRaidRosterInfo(1) and IsRaidOfficer("player")) or (GetNumPartyMembers() ~= 0 and UnitIsPartyLeader("player"))) and not Rat.Options.version:IsVisible()) then
			Rat.Options.version:Show()
		elseif Rat.Options.version ~= nil and (((GetRaidRosterInfo(1) and not IsRaidOfficer("player")) or (GetNumPartyMembers() ~= 0 and not UnitIsPartyLeader("player"))) and Rat.Options.version:IsVisible()) then
			Rat.Options.version:Hide()
		end
		Rat.Mainframe.Background.Top.Title:SetFont("Interface\\AddOns\\Rat\\fonts\\"..Rat_Font[Rat_Settings["font"]]..".TTF", Rat_FontSize[Rat_Settings["font"]]+1)		
		local db = Rat:SortDB()
		local i=1
		for index=1,getn(db) do
			local name=db[index].name
			local ability=db[index].ability
			local tname = name..ability
			RatFrames[tname] = RatFrames[tname] or Rat:CreateFrame(tname)
			local frame = RatFrames[tname]
					local texture = cdtbl[ability]
					local bardecay = 1-((RatTbl[name][ability]["cd"]-(RatTbl[name][ability]["duration"]-GetTime())) / RatTbl[name][ability]["cd"])
					local cdtime = rtime(RatTbl[name][ability]["duration"]-GetTime())
					if bardecay > 1 then
						bardecay = 1
					end
					if cdtime == nil then cdtime = 0 end
					frame:SetWidth(Rat.Mainframe:GetWidth()-4)
					frame:SetHeight(22)
					if Rat_Settings["invert abilities"] == nil then
						frame:SetPoint("TOPLEFT",2,(-22*i)+2)
					else
						frame:SetPoint("TOPLEFT",2,(22*i))
					end
					frame.unit:SetTexture(Rat:GetClassColors(name))
					frame.unit:SetGradientAlpha("Vertical", 1,1,1, 0, 1, 1, 1, 1)
					frame.unitname:SetText(name)
					frame.unitname:SetFont("Interface\\AddOns\\Rat\\fonts\\"..Rat_Font[Rat_Settings["font"]]..".TTF", Rat_FontSize[Rat_Settings["font"]])
					frame.icon:SetTexture(texture)
					frame.bar:SetWidth(bardecay*(Rat.Mainframe:GetWidth()-89))
					frame.bar:SetTexture("Interface\\AddOns\\Rat\\media\\bartextures\\"..Rat_BarTexture[Rat_Settings["bartexture"]]..".tga",true)	
					frame.bar:SetVertexColor(Rat_Settings["abilitybarcolor"]["r"],Rat_Settings["abilitybarcolor"]["g"],Rat_Settings["abilitybarcolor"]["b"],1)
					frame.timer:SetTextColor(Rat_Settings["abilitytextcolor"]["r"],Rat_Settings["abilitytextcolor"]["g"],Rat_Settings["abilitytextcolor"]["b"])
					frame.time:SetTextColor(Rat_Settings["abilitytextcolor"]["r"],Rat_Settings["abilitytextcolor"]["g"],Rat_Settings["abilitytextcolor"]["b"])
					if Rat_Settings["Notify"] == 1 and Rat_Settings[Rat:GetClass(name)] == 1 and Rat_Settings[ability] == 1 and math_floor(RatTbl[name][ability]["duration"]-GetTime()) == 0 then
						if Rat_Settings[tname] == nil or (GetTime()-Rat_Settings[tname]) > 2 or (GetTime()-Rat_Settings[tname]) < 0 then
							UIErrorsFrame:AddMessage(Rat_GetClassColors(name).." |cffFFFF00"..ability.." - READY!")
							Rat_Settings[tname] = GetTime()
						end
					end
					if cdtime ~= 0 then
						frame.timer:SetText(ability)
						frame.time:SetText(cdtime)
						frame.timer:SetFont("Interface\\AddOns\\Rat\\fonts\\"..Rat_Font[Rat_Settings["font"]]..".TTF", Rat_FontSize[Rat_Settings["font"]])
						frame.time:SetFont("Interface\\AddOns\\Rat\\fonts\\"..Rat_Font[Rat_Settings["font"]]..".TTF", Rat_FontSize[Rat_Settings["font"]])
					end
					if bardecay*(Rat.Mainframe:GetWidth()-89) > 0 then
						frame.barglow:SetPoint("RIGHT", -(Rat.Mainframe:GetWidth()-88)+(bardecay*(Rat.Mainframe:GetWidth()-89)),0)
						frame.barglow:Show()

						if Rat_Settings[Rat:GetClass(name)] == 1 then
							if Rat_Settings[ability] == nil then
								frame:Hide()
							else
								frame:Show()
								i = i+1
							end	
						else
							frame:Hide()							
						end	
					
					else
						frame.barglow:Hide()
						frame:Hide()
					end		
		end
	end
end

function Rat:SortDB()
	local tempdb={}
	local i=1
	for name,_ in pairs(RatTbl) do
		for ability,_ in pairs(RatTbl[name]) do
			if RatTbl[name][ability]["duration"] ~= nil and RatTbl[name][ability]["cd"] ~= nil then
				tempdb[i] = {
					["name"] = name,
					["ability"] = ability,
					["duration"] = RatTbl[name][ability]["duration"],
					["cd"] = RatTbl[name][ability]["cd"],
				}
				i=i+1
			end
		end
	end
	table.sort(tempdb, function(a,b) return a.duration>b.duration end)
	return tempdb
end

-- slash commands

function Rat.slash(arg1,arg2,arg3)
	if arg1 == nil or arg1 == "" then
		Rat:Print("type |cFFFFFF00 /rat show|r to show frame")
		Rat:Print("type |cFFFFFF00 /rat hide|r to hide frame")
		Rat:Print("type |cFFFFFF00 /rat options|r to show options menu")
		Rat:Print("Hold down 'Alt' to move the window")
		else
		if arg1 == "show" then
			Rat_Settings["showhide"] = 1
			Rat.Mainframe:Show()
		elseif arg1 == "hide" then
			Rat_Settings["showhide"] = 0
			Rat.Mainframe:Hide()
		elseif arg1 == "options" then
			Rat.Options:Show()
		else
			Rat:Print("unknown command");
		end
	end
end

SlashCmdList['RAT_SLASH'] = Rat.slash
SLASH_RAT_SLASH1 = '/rat'
SLASH_RAT_SLASH2 = '/RAT'

-- call events

Rat:SetScript("OnEvent", Rat.OnEvent)
Rat:SetScript("OnUpdate", Rat.Update)

-- sort function for our database

function sortDB()
	local sortedKeys = { }
	for k, v in pairs(RatTbl) do 
		for l, _ in pairs(RatTbl[k]) do
		table.insert(sortedKeys, RatTbl[k][l]["duration"]) 
		end
	end
	table.sort(sortedKeys, function(a,b) return a>b end)
	return sortedKeys
end

function Rat:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage("|cFFF5F54A RAT:|r "..msg)
end

-- function to format time into 00:00

function rtime(left)
	local min = math_floor(left / 60)
	local sec = math_floor(math.fmod(left, 60))

	if (this.min == min and this.sec == sec) then
		return nil
	end

	this.min = min
	this.sec = sec

	return string.format("%02d:%02s", min, sec)
end

function testsort()
	local temp=Rat:SortDB()
	for n in pairs(temp) do
	Rat:Print(temp[n].name.." "..temp[n].ability.." "..temp[n].duration.." "..temp[n].cd)
	end
end

function printdb()
	for n in pairs(RatTbl) do
		for v in pairs(RatTbl[n]) do
			Rat:Print(n.." "..v.." ")
		end
	end
end

function RAT_InitializePlayerSpells()
-- Initialize player cooldowns to track, may require event
	local spells_found = 0 
	for SpellName in pairs(cdtbl) do 
		if GetSpellName(SpellName) then 
		spells_found = spells_found+1
		RAT_PlayerSpells[SpellName] = true 
		end 
	end 
--Rat:Print("RAT DEBUG: No player spells found")
--assert(spells_found>0, "RAT DEBUG: No player spells found [Zedar]")
end 