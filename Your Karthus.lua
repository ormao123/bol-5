if myHero.charName ~= "Karthus" then return end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLNOKKOQK") 

local qRange = 875
local wRange = 1000
local eRange = 425

local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local useingE = false
local EActive = false
local recall = false
local j, CanKillChampion
	local status
	
local ts
local VP, SxO = nil, nil

local EnemyHeroes = GetEnemyHeroes()

require "VPrediction"
require "SxOrbWalk"
require "SourceLib"

local version = 1.09
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
	SxO:DisableAttacks()
	
	LoadMenu()
	
	DamageCalculator = DamageLib()
	DamageCalculator:RegisterDamageSource(_Q, _MAGIC, 40, 20, _MAGIC, _AP, 0.30, myHero:CanUseSpell(_Q) == READY)
			
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY,wRange,DAMAGE_MAGIC, false)
	enemyMinions = minionManager(MINION_ENEMY, 875, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function LoadMenu()
	ConfigY = scriptConfig("Your Karthus", "Karthus")
		ConfigY:addSubMenu("combo", "combo")
			ConfigY.combo:addParam("activecombo", "combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			ConfigY.combo:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			ConfigY.combo:addParam("usew", "use W", SCRIPT_PARAM_ONOFF, true)
			ConfigY.combo:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
			ConfigY.combo:addParam("pere", "Until % use W", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
			
		ConfigY:addSubMenu("farm", "farm")
			ConfigY.farm:addParam("farm", "farm", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			ConfigY.farm:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			
		ConfigY:addSubMenu("harass", "harass")
			ConfigY.harass:addParam("harassactive", "harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			ConfigY.harass:addParam("harasstoggle", "harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("X"))
			ConfigY.harass:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			ConfigY.harass:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			ConfigY.harass:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
			ConfigY.harass:addParam("pere", "Until % E", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			--ConfigY.harass:addParam("usew", "use W", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.harass:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
			
		ConfigY:addSubMenu("killsteal", "killsteal")
			ConfigY.killsteal:addParam("killstealmark", "Killsteal Mark", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.killsteal:addParam("killstealq", "Killsteal Q Toggle", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.killsteal:addParam("killstealhitchance", "Killsteal hit chance", SCRIPT_PARAM_LIST, 1, {"1", "2", "3", "4", "5"})
			
		ConfigY:addSubMenu("ads", "ads")
			ConfigY.ads:addParam("adsr", "Use R After You dead", SCRIPT_PARAM_ONOFF, true)
			
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
	Farm()
	
	for i = 1, myHero.buffCount do
		local buff = myHero:getBuff(i)
		if buff.name == "KarthusDefile" then
			EActive = true
		else
			EActive = false
		end
	end
end

function OnCombo()
	ts:update()
	if ts.target ~= nil then
		if ConfigY.combo.activecombo then
			for i, target in pairs(GetEnemyHeroes()) do
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 100, 875)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 and target.dead == false then
					if Qready and ConfigY.combo.useq then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
				
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 10, 1000)
				if CastPosition and HitChance >= 1 and GetDistance(CastPosition) < 1000 then
					if Wready and ConfigY.combo.usew then
						CastSpell(_W, CastPosition.x, CastPosition.z)
					end
				end
				
				if CountEnemyHeroInRange(eRange) >= 1 and EActive == false and Eready and myHero.mana >= (myHero.maxMana*(ConfigY.combo.pere*0.01)) then
					CastSpell(_E)
				end
				
				if CountEnemyHeroInRange(eRange) == 0 and EActive == true and Eready then
					CastSpell(_E)
				end
			end
		end
	end
end

function OnHarass()
	if ConfigY.harass.harasstoggle and recall() == false or ConfigY.harass.harassactive then
		for i, target in pairs(GetEnemyHeroes()) do
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, 0.5, 100, 875)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 and target.dead == false then
				if Qready and ConfigY.harass.useq and myHero.mana > (myHero.maxMana*(ConfigY.harass.perq*0.01)) then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
				if ConfigY.harass.usee and CountEnemyHeroInRange(eRange) >= 1 and EActive == false and Eready and myHero.mana >= (myHero.maxMana*(ConfigY.harass.pere*0.01)) then
					CastSpell(_E)
				end
				
				if CountEnemyHeroInRange(eRange) == 0 and EActive() and Eready then
					CastSpell(_E)
				elseif myHero.mana < (myHero.maxMana*(ConfigY.harass.pere*0.01)) and EActive() and Eready then
					CastSpell(_E)
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
	if ConfigY.killsteal.killstealmark then
		for j, CanKillChampion in pairs(EnemyHeroes) do
			if ValidTarget(CanKillChampion) then
				if stat(CanKillChampion) == "Can" then
					DrawText(CanKillChampion.charName.." can kill with R? | "..stat(CanKillChampion), 18, 100, 100+j*20, 0xFFFF0000) 
				else
					DrawText(CanKillChampion.charName.." can kill with R? | "..stat(CanKillChampion), 18, 100, 100+j*20, 0xFFFFFF00) 
				end
			end
		end
	end
end

function stat(unit)
	if getDmg("R", unit, myHero) > unit.health then
		status = "Can"
	else
		status = "Cant"
	end
	return status
end

function Farm()
	if ConfigY.farm.farm then
		enemyMinions:update()
		for i, minion in ipairs(enemyMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= 875 and myHero:CanUseSpell(_Q) == READY and getDmg("Q", minion, myHero)/1.5 > minion.health and ConfigY.farm.useq then
				CastSpell(_Q, minion)
			end
		end
	end
end

function OnApplyBuff(source, unit, buff)
	if unit and unit.isMe and buff.name == "KarthusDefile" then 
		EActive = true
    end
	if unit and unit.isMe and buff.name == "recall" then 
		recall = true
    end
end

function OnRemoveBuff(unit, buff)
    if unit and unit.isMe and buff.name == "KarthusDefile" then 
        EActive = false
    end
	if unit and unit.isMe and buff.name == "recall" then 
		recall = false
    end
end

function EActive()
  return TargetHaveBuff("KarthusDefile", myHero)
end

function recall()
  return TargetHaveBuff("recall", myHero)
end
