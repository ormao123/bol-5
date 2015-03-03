--[[
	Changelog
	v. 1.02
	SomeFix error
	Add auto Q stun
	
	v. 1.03
	add Feedback
	
	v. 1.04
	back
	Fix
]]



if myHero.charName ~= "Zilean" then return end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("VILJLQLPMON") 

require "VPrediction"
require "SxOrbWalk"

local ts, enemyMinions
local VP = nil
local SxO = nil

local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local Qrance = 900

local version = 1.04
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Zilean.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Zilean.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Zilean:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Zilean.version")
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
	
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY,1000,DAMAGE_MAGIC, false)
	
	LoadMenu()
	
end

function LoadMenu()
	Config = scriptConfig("Your Zilean", "your zilean")
	
	Config:addSubMenu("Combo", "combo")
		Config.combo:addParam("comboactive", "Combo Active", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("Harass", "harass")
		Config.harass:addParam("harassactive", "harass Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("harassper", "Until % use Harass", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
	Config:addSubMenu("W Setting", "wsetting")
		Config.wsetting:addParam("useforq", "Use for Q", SCRIPT_PARAM_ONOFF, true)
		Config.wsetting:addParam("usefore", "Use for E", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("Draw", "Draw")
		Config.Draw:addParam("drawQ", "drawQ", SCRIPT_PARAM_ONOFF, true)
		Config.Draw:addParam("drawE", "drawE", SCRIPT_PARAM_ONOFF, true)
		Config.Draw:addParam("drawR", "drawR", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("ads", "ads")
		Config.ads:addParam("autow", "Auto W", SCRIPT_PARAM_ONOFF, true)
		Config.ads:addParam("autoqstun", "Auto Q Stun", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
		Config.ads:addParam("runmod", "Run Mod", SCRIPT_PARAM_ONOFF, true)
		Config.ads:addParam("runmodper", "Until % use runmod", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
	Config:addSubMenu("Ult", "ult")
	for _, ally in ipairs(GetAllyHeroes()) do
		Config.ult:addParam(ally.charName, ally.charName, SCRIPT_PARAM_ONOFF, true)
	end
	
	Config:addSubMenu("orbWalk", "orbWalk")
			SxO:LoadToMenu(Config.orbWalk)
end

function OnTick()
	OnSpellcheck()
	OnCombo()
	OnHarass()
	autoW()
	autoR()
	OnDraw()
	AutoQstun()
	RunMod()
end

function OnDraw()
	if Qready and Config.Draw.drawQ then DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0x111111) end
	if Eready and Config.Draw.drawE then DrawCircle(myHero.x, myHero.y, myHero.z, 550, 0x111111) end
	if Rready and Config.Draw.drawR then DrawCircle(myHero.x, myHero.y, myHero.z, 780, 0x111111) end
end

function OnCombo()
	ts:update()
	if Config.combo.comboactive and ts.target ~= nil then
		if Eready and Config.combo.usee and slowcheck(ts.tarhet) == false then
			if GetDistance(ts.target, myHero) > 550 then
				CastSpell(_E, myHero)
			else
				CastSpell(_E, ts.target)
			end
		end
		local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 150, Qrance)
		if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Qrance and ts.target.dead == false then
			if Qready and Config.combo.useq then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if Wready and Config.combo.usew and Qready == false then
			CastSpell(_W)
		end
	end
end

function OnHarass()
	ts:update()
	if Config.harass.harassactive  and ts.target ~= nil  then
		if myHero.mana > (myHero.maxMana*(Config.harass.harassper*0.01)) then
			if Eready and Config.harass.usee then
				CastSpell(_E, ts.target)
			end
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 150, Qrance)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Qrance and ts.target.dead == false then
				if Qready and Config.harass.useq then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function RunMod()
	if Config.ads.runmod and myHero.mana > (myHero.maxMana*(Config.ads.runmodper*0.01)) then
		if CountEnemies(1000, myHero) == 0 then
			if Eready then
				CastSpell(_E, myHero)
			elseif Eready == false and Wready then
				CastSpell(_W)
			end
		end
	end
end

function AutoQstun()
	if Config.ads.autoqstun then
		ts:update()
		local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 150, Qrance)
		if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Qrance and ts.target.dead == false then
			if Qready then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if Wready then
			CastSpell(_W)
		end
	end
end

function autoR()
	if Rready then
		if myHero.health / myHero.maxHealth < 0.3 and CountEnemies(1000, myHero) > 0 then
			CastSpell(_R, myHero)
		end
		for _, ally in ipairs(GetAllyHeroes()) do
			if Config.ult[ally.charName] then
				if ally.health / ally.maxHealth < 0.2 and GetDistance(ally) <= 900 and CountEnemies(1000, ally) > 0 then
					CastSpell(_R, ally)
				end
			end
		end
	end
end
	
function autoW()
	if Config.wsetting.combo then
		if Config.combo.comboactive == false then
			if Qready == false or Eready == false then
				CastSpell(_W)
			end
		end
	end
end

function CountEnemies(range, unit)
    local Enemies = 0
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and GetDistance(enemy, unit) < (range or math.huge) then
            Enemies = Enemies + 1
        end
    end
    return Enemies
end

function slowcheck(target)
	return TargetHaveBuff("slow", target)
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
	
	if myHero:CanUseSpell(_R) == READY then
		Rready = true
	else
		Rready = false
	end
end