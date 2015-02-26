--[[
	update 1.02
	Fix Harass Mode
	
	update 1.03
	use Q without E
]]




if myHero.charName ~= "Urgot" then return end

require "VPrediction"
require "SxOrbWalk"

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLNROQLSO") 

local ts
local enemyMinions
local VP, SxO = nil, nil
local Qready, Wready, Eready, Rready = nil, nil, nil, nil

local version = 1.03
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your J.Urgot.H.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your J.Urgot.H.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your J.Urgot.H:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your J.Urgot.H.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end



function OnLoad()
	
	VP = VPrediction()
	SxO = SxOrbWalk()

	LoadMenu()
	
	ts = TargetSelector(TARGET_NEAR_MOUSE,1300)
	enemyMinions = minionManager(MINION_ENEMY, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function OnTick()
	farm()
	Combo()
	harass()
	OnSpellcheck()
end

function OnDraw()
	if Config.draw.qrance then DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0x111111) end
	if Config.draw.erance then DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0x111111) end
end

function LoadMenu()
	Config = scriptConfig("J.Urgot.H", "J.Urgot.H")
	
	Config:addSubMenu("combo", "combo")
		Config.combo:addParam("comboactive", "combo Hotkey", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.combo:addParam("useq", "USE Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usew", "USE W", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usee", "USE E", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("harass", "harass")
		Config.harass:addParam("harassactive", "Harass hotkey", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		Config.harass:addParam("useq", "USE Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("usee", "USE E", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("harassper", "Until % use Harass", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
	Config:addSubMenu("farm", "farm")
		Config.farm:addParam("farmactive", "Farm Hotkey", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		Config.farm:addParam("useq", "USE Q", SCRIPT_PARAM_ONOFF, true)
		Config.farm:addParam("farmper", "Until % use Farm", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
	Config:addSubMenu("orbWalk", "orbWalk")
		SxO:LoadToMenu(Config.orbWalk)
		
	Config:addSubMenu("draw", "draw")
		Config.draw:addParam("qrance", "Draw Q rance", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("erance", "Draw E rance", SCRIPT_PARAM_ONOFF, true)
end

function farm()
	if Config.farm.farmactive and myHero.mana > (myHero.maxMana*(Config.farm.farmper*0.01)) then
		enemyMinions:update()
		for i, minion in ipairs(enemyMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= 1200 and Qready and getDmg("Q", minion, myHero) > minion.health and Config.farm.useq then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.5, 75, 1200, 1500, myHero, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function Combo()
	if Config.combo.comboactive then
		ts:update()
		if Config.combo.usee and Eready then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.8, 75, 1200, 1500, myHero, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 900 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
		
		if ts.target ~= nil and Ehit(ts.target) then
			if Config.combo.useq and Qready and GetDistance(ts.target) <1200 then
				if Config.combo.usew and Wready then
					CastSpell(_W)
				end
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.5, 75, 1200, 1500, myHero, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		elseif ts.target ~= nil and Ehit(ts.target) == false and Eready == false and Qready then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.5, 75, 1200, 1500, myHero, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function harass()
	if Config.harass.harassactive and myHero.mana > (myHero.maxMana*(Config.harass.harassper*0.01)) then
		ts:update()
		if Config.harass.usee and Eready and ts.target ~= nil then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.8, 75, 1200, 1500, myHero, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 900 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
		
		if ts.target ~= nil and Ehit(ts.target) then
			if Config.harass.useq and Qready and GetDistance(ts.target) <1200 then
				CastSpell(_Q, ts.target)
			end
		end
	end
end

function Ehit(target)
	return TargetHaveBuff("urgotcorrosivedebuff", target)
end

function OnSpellcheck()
	if myHero:CanUseSpell(_Q) == READY then
		Qready = true
	else
		Qready = false
	end
	
	if myHero:CanUseSpell(_W) == READY then
		Wready = true
	else
		Wready = false
	end
	
	if myHero:CanUseSpell(_E) == READY then
		Eready = true
	else
		Eready = false
	end
	
	if myHero:CanUseSpell(_Q) == READY then
		Rready = true
	else
		Rready = false
	end
end