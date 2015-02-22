if myHero.charName ~= "DrMundo" then return end

require "VPrediction"
require "SxOrbWalk"

local ts, enemyMinions
local SxO, VP = nil, nil
local QRange, WRange, ERange, RRange = 1000, 320, 225, 0
local WActive = false

local version = 1.00
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Mundo.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Mundo.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Mundo:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Mundo.version")
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
	enemyMinions = minionManager(MINION_ENEMY, 1000, myHero, MINION_SORT_MAXHEALTH_DEC)
	
end

function OnTick()
	killsteal()
	Harass()
	Farm()
	Combo()
	R()
end

function OnDraw()
	if Config.draw.drawrrance then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0x111111)
	end
end

function LoadMenu()
	Config = scriptConfig("Your Mundo", "Dr.Mundo")
		Config:addSubMenu("combo", "combo")
			Config.combo:addParam("combo", "combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Config.combo:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("useE", "Use E", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("harass", "harass")
			Config.harass:addParam("harass", "harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			Config.harass:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		
		Config:addSubMenu("farm", "farm")
			Config.farm:addParam("farm", "farm",  SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			Config.farm:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			--Config.farm:addParam("useQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("ads", "ads")
			Config.ads:addParam("ks", "KS with Q", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("per", "when % use R", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
			
		Config:addSubMenu("draw", "draw")
			Config.draw:addParam("drawrrance", "draw R rance", SCRIPT_PARAM_ONOFF, true)
			--Config.draw:addParam("drawaarance", "draw AA rance", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("orbWalk", "orbWalk")
			SxO:LoadToMenu(Config.orbWalk)
end

function Farm()
	if Config.farm.farm then
		enemyMinions:update()
		for i, minion in ipairs(enemyMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= QRange and myHero:CanUseSpell(_Q) == READY and getDmg("Q", minion, myHero) > minion.health and Config.farm.useQ then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.5, 75, 1000, 1500, myHero, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function Harass()
	if Config.harass.harass then
		if ValidTarget(ts.target, QRange) and myHero:CanUseSpell(_Q) == READY then
			for i, target in pairs(GetEnemyHeroes()) do
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.5, 75, 1000, 1500, myHero, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1300 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
        end
	end
end

function Combo()
	if Config.combo.combo then
		ts:update()
		if ValidTarget(ts.target, QRange) and myHero:CanUseSpell(_Q) == READY and Config.combo.useQ then
			for i, target in pairs(GetEnemyHeroes()) do
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 0.5, 75, 1000, 1500, myHero, true)
            	if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end

		if not WActive and myHero:CanUseSpell(_W) == READY and CountEnemyHeroInRange(WRange) >= 1 and Config.combo.useW then
			CastSpell(_W)
			else 
	
			if WActive and CountEnemyHeroInRange(WRange) == 0 and Config.combo.useW then
				CastSpell(_W)
			end
		end

		if CountEnemyHeroInRange(ERange) >= 1 and myHero:CanUseSpell(_E) == READY and Config.combo.useE then
			CastSpell(_E)
		end
	end
end

function R()
	if Config.ads.user then
		if myHero.health < (myHero.maxHealth*(Config.ads.per*0.01)) then
			if myHero:CanUseSpell(_R) then
				CastSpell(_R)
			end
		end
	end
end

function killsteal()
	local i, Champion
	for i, Champion in pairs(GetEnemyHeroes()) do
		if ValidTarget(Champion) then
			if getDmg("Q", Champion, myHero) > Champion.health and Config.ads.ks then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Champion, 0.5, 75, 1000, 1500, myHero, true)
            	if HitChance >= 2 and GetDistance(CastPosition) < 1000 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function OnApplyBuff(source, unit, buff)
    if unit and unit.isMe and buff.name == "BurningAgony" then 
        WActive = true
    end
end

function OnRemoveBuff(unit, buff)
    if unit and unit.isMe and buff.name == "BurningAgony" then 
        WActive = false
    end
end
