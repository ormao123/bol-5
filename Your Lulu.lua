if myHero.charName ~= "Lulu" then return end

local version = 1.03
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Lulu.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Lulu.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Lulu:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/version/Your Lulu.version")
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

require 'VPrediction'
require 'SxOrbWalk'
require 'sourceLib'

local HPred, SxO, STS = nil, nil, nil
local ts
local Qrance, Wrance, Erance, Rrance = 950, 650, 650, 900 
local Config = nil
local player = myHero
local enemyHeroes = GetEnemyHeroes()
local allyHeroes = GetAllyHeroes()
local enemyMinions = minionManager(MINION_ENEMY, 1500, myHero, MINION_SORT_MAXHEALTH_DEC)
local jungleMinions = minionManager(MINION_JUNGLE, 1500, myHero, MINION_SORT_MAXHEALTH_DEC)

local InterruptList = {
    { charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    { charName = "FiddleSticks", spellName = "Crowstorm"},
    { charName = "FiddleSticks", spellName = "DrainChannel"},
    { charName = "Galio", spellName = "GalioIdolOfDurand"},
    { charName = "Karthus", spellName = "FallenOne"},
    { charName = "Katarina", spellName = "KatarinaR"},
    { charName = "Lucian", spellName = "LucianR"},
    { charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    { charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    { charName = "Nunu", spellName = "AbsoluteZero"},
    { charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    { charName = "Shen", spellName = "ShenStandUnited"},
    { charName = "Urgot", spellName = "UrgotSwap2"},
    { charName = "Varus", spellName = "VarusQ"},
    { charName = "Warwick", spellName = "InfiniteDuress"}
}
local ToInterrupt = {}

function OnLoad()
	
	VP		= VPrediction()
	STS		= SimpleTS()
	SxO		= SxOrbWalk()
	
	
	LoadMenu()
	
	for i = 1, heroManager.iCount do 
        local hero = heroManager:GetHero(i) 
		for _, champ in pairs(InterruptList) do 
			if hero.charName == champ.charName then 
				table.insert(ToInterrupt, champ.spellName) 
			end
        end 
    end 
end

function OnTick()
	if Config.combo.active then
		OnCombo()
	elseif Config.harass.active then
		OnHarass()
	elseif Config.lc.active then
		OnLineClear()
	end
	OnKillsteal()
	OnSpellcheck()
	if Config.ads.autor and Rready then
		if player.health < (player.maxHealth*(Config.ads.autorper*0.01)) and countEnemy(player, 200) >= 1 then
			CastSpell(_R, player)
		end
		for _, i in pairs (allyHeroes) do
			if i.health < (i.maxHealth*(Config.ads.autorper*0.01)) and countEnemy(i, 200) >= 1 then
				CastSpell(_R, i)
			end
		end
	end
end

function OnDraw()
	DrawCircle(player.x, player.y, player.z, Qrance, 0xffff0000)
	DrawCircle(player.x, player.y, player.z, Wrance, 0xffff0000)
	DrawCircle(player.x, player.y, player.z, Erance, 0xffff0000)
	DrawCircle(player.x, player.y, player.z, Rrance, 0xffff0000)
end

function LoadMenu()
	Config = MenuWrapper("[Your] " .. player.charName, "unique" .. player.charName:gsub("%s+", ""))
	
		Config:SetTargetSelector(STS)
		Config:SetOrbwalker(SxO)
		Config = Config:GetHandle()
		
		Config:addSubMenu("Combo", "combo")
			Config.combo:addParam("active", "Active", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
			--Config.combo:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("Harass", "harass")
			Config.harass:addParam("active", "Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
			Config.harass:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
			--Config.harass:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("Line Clear", "lc")
			Config.lc:addParam("active", "Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			Config.lc:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("Ads","ads")
			--Config.ads:addParam("autow", "Auto Shild", SCRIPT_PARAM_ONOFF, false)
			Config.ads:addParam("interrupt", "interrupt", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("samrtr", "Use R", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
			Config.ads:addParam("autor", "Auto R", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("autorper", "Auto R ally under health %", SCRIPT_PARAM_SLICE, 30, 1, 100, 0)
end

function OnCombo()
	local Target = STS:GetTarget(Qrance)
	if Target ~= nil then
		if Config.combo.usee and Eready then
			CastSpell(_E, Target)
		end
		if Config.combo.useq and GetDistance(Target, player) < Qrance then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, 0.25,60,950, 1600, myHero, false)
			if CastPosition and HitChance >= 2 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if Config.combo.user and Rready then
			SamrtR()
		end
	end
end

function OnHarass()
	local Target = STS:GetTarget(Qrance+Erance)
	if Target ~= nil then
		if GetDistance(Target, player) < Qrance then
			if Config.harass.usew and Eready then
				CastSpell(_W, Target)
			end
			if Config.harass.useq and Qrance then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, 0.25,60,950, 1600, myHero, false)
				if CastPosition and HitChance >= 2 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		elseif GetDistance(Target, player) < Qrance+Erance then
			SmartW(Target)
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, 0.25,60,950, 1600, myHero, false)
			if CastPosition and HitChance >= 2 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function OnLineClear()
	enemyMinions:update()
	local minion
	for _, minion in pairs(enemyMinions.objects) do
		if Config.lc.useq then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, 0.25,60,950, 1600, myHero, false)
			if CastPosition and HitChance >= 2 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function SamrtR()
	if CountEnemyHeroInRange(Rrance) >= Config.ads.smartr then
		CastSpell(_R, player)
	end
	for _, i in pairs (allyHeroes) do
		if countEnemy(i, 200) >= Config.ads.smartr then
			CastSpell(_R, i)
		end
	end
end

function countEnemy(allyHero, range)
	local nearEnemy=0
	for i, e in pairs(enemyHeroes) do
		if GetDistance(allyHero, enemyHeroes) < range then
			nearEnemy = nearEnemy + 1
		end
	end
	return nearEnemy
end

function OnKillsteal()
end

function SmartW(target)
	enemyMinions:update()
	for i, minion in pairs(enemyMinions.objects) do
		if GetDistance(minion, player) < Erance and GetDistance(minion, target) < Qrance and getDmg("E", minion, player) < minion.health then
			CastSpell(_E, minion)
		end
	end
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

function OnProcessSpell(unit, spell)
	if #ToInterrupt > 0 and WReady then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= myHero.team and GetDistance(unit) < SpellW.Range then
				CastSpell(_W, unit.x, unit.z)
			end
		end
	end
end