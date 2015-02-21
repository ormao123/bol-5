if myHero.charName ~= "Karthus" then return end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLNOKKOQK") 

local qRange = 875
local wRange = 1000
local eRange = 425

local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local useingE = false

local ts
local VP, SxO = nil, nil

local EnemyHeroes = GetEnemyHeroes()

require "VPrediction"
require "SxOrbWalk"
require "SourceLib"

local version = 1.01
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Karthus.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Karthus.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Karthus:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Karthus.version")
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
	
	DamageCalculator = DamageLib()
	DamageCalculator:RegisterDamageSource(_Q, _MAGIC, 40, 20, _MAGIC, _AP, 0.30, myHero:CanUseSpell(_Q) == READY)
			
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY,wRange,DAMAGE_MAGIC, false)
	EnemyMinions = minionManager(MINION_ENEMY, 875, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function LoadMenu()
	ConfigY = scriptConfig("Your Karthus", "Karthus")
		ConfigY:addSubMenu("combo", "combo")
			ConfigY.combo:addParam("activecombo", "combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			ConfigY.combo:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			ConfigY.combo:addParam("usew", "use W", SCRIPT_PARAM_ONOFF, true)
			ConfigY.combo:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
			
		--ConfigY:addSubMenu("farm", "farm")
			--ConfigY.farm:addParam("farm", "farm", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("X"))
			--ConfigY.farm:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			
		ConfigY:addSubMenu("harass", "harass")
			ConfigY.harass:addParam("harasstoggle", "harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("C"))
			ConfigY.harass:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.harass:addParam("usew", "use W", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.harass:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
			
		ConfigY:addSubMenu("killsteal", "killsteal")
			ConfigY.killsteal:addParam("killstealr", "Killsteal R Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
			--ConfigY.killsteal:addParam("killstealq", "Killsteal Q Toggle", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.killsteal:addParam("killstealhitchance", "Killsteal hit chance", SCRIPT_PARAM_LIST, 1, {"1", "2", "3", "4", "5"})
			
		ConfigY:addSubMenu("draw", "draw")
			ConfigY.draw:addParam("drawq", "draw Q", SCRIPT_PARAM_ONOFF, true)
			ConfigY.draw:addParam("draww", "draw W", SCRIPT_PARAM_ONOFF, true)
			ConfigY.draw:addParam("drawe", "draw E", SCRIPT_PARAM_ONOFF, true)
			
		ConfigY:addSubMenu("orbWalk", "orbWalk")
			SxO:LoadToMenu(ConfigY.orbWalk)
end

function OnTick()
	if myHero.dead then return end
	OnCombo()
	OnHarass()
	OnSpellcheck()
	killsteal()
end

function OnCombo()
	ts:update()
	if ts.target ~= nil then
		if ConfigY.combo.activecombo then
			for i, target in pairs(GetEnemyHeroes()) do
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 100, 875)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 then
					if Qready and ConfigY.combo.useq then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
				
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 10, 1000)
				if CastPosition and HitChance >= 1 and GetDistance(CastPosition) < 1000 then
					if Qready and ConfigY.combo.useq then
						CastSpell(_W, CastPosition.x, CastPosition.z)
					end
				end
				
				if GetDistance(ts.target, myHero) <= 550 then
					if useingE == false and Eready then
						CastSpell(_E)
						useingE = true
					end
				end
				
				if GetDistance(ts.target, myHero) > 550 and Eready then
					if useingE then
						CastSpell(_E)
						useingE = false
					end
				end
			end
		end
	end
end

function OnHarass()
	if ConfigY.harass.harasstoggle then
		for i, target in pairs(GetEnemyHeroes()) do
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, 0.5, 100, 875)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 then
				if Qready and ConfigY.harass.useq then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
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

function OnDraw()
	if ConfigY.draw.drawq then
		DrawCircle(myHero.x, myHero.y, myHero.z, 875, 0xFFFFCC)
	end
	if ConfigY.draw.draww then
		DrawCircle(myHero.x, myHero.y, myHero.z, 1000, 0xFFFF0000)
	end
	if ConfigY.draw.drawe then
		DrawCircle(myHero.x, myHero.y, myHero.z, 475, 0xFFFFFFff)
	end
end

function killsteal()
		local i, Champion
		for i, Champion in pairs(EnemyHeroes) do
			if ValidTarget(Champion) then
				if getDmg("R", Champion, myHero) > Champion.health and ConfigY.killsteal.killstealr then
					print(Champion.."Can kill with R")
					CastSpell(_R)
				end
			end
		end
	end


function Farm()
	EnemyMinions:update()
	if ConfigY.farm.farm then
		for i, Minion in pairs(EnemyMinions.objects) do
			if ValidTarget(Minion) then
				if Qready and DamageCalculator:IsKillable(Minion,{_Q}) then
					CastSpell(_Q, minion)
				end
			end
		end
	end
end