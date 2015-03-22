if myHero.charName ~= "Karthus" then return end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLNOKKOQK")

--[[

v. 1.02

Q Farming


v. 1.03

Add ManaManager


v. 1.04

Add KillSteal Mark

E Fix


v. 1.05

Add Harass Key (Not Toggle)

Add Harass E

E Fix

Fix Q Farming ( not perfect )

Fix harass to dead target

Now you not harass when recall


v. 1.06

Delete Q manaManager In Combo


v. 1.10

Add Dpred

Bug Fix


v 1.12

Fix KillMark

Now You can Combo in Dead Passive

Fix Error


v. 1.13

Damage Manager


v. 1.15

Auto downLoad DPred


v 1.16

Fix AutoDownload

Fix KillMark, now you can see stat (Can, Cant, Dead)


v, 1.17

Add OrbWalk Checker


v, 1.18

Farming Fix


v. 1.21

Add Menu Auto E Off

]]




local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Karthus:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end

local SCRIPT_INFO = {
	["Name"] = "Your Kathus",
	["Version"] = 1.21,
	["Author"] = {
		["Yours"] = "http://forum.botoflegends.com/user/145247-yours/"
	},
	["Credits"] = {
		["Yours"] = "http://forum.botoflegends.com/user/145247-yours/"
	},
}
local SCRIPT_UPDATER = {
	["Activate"] = true,
	["Script"] = SCRIPT_PATH..GetCurrentEnv().FILE_NAME,
	["URL_HOST"] = "raw.github.com",
	["URL_PATH"] = "/jineyne/bol/master/Your Karthus.lua",
	["URL_VERSION"] = "/jineyne/bol/master/Your Karthus.version"
}
local SCRIPT_LIBS = {
	["SourceLib"] = "https://raw.github.com/LegendBot/Scripts/master/Common/SourceLib.lua",
	["VPrediction"] = "https://raw.github.com/LegendBot/Scripts/master/Common/VPrediction.lua",
	["DivinePred"] = "http://divinetek.rocks/divineprediction/DivinePred.lua"
}
function Initiate()
	for LIBRARY, LIBRARY_URL in pairs(SCRIPT_LIBS) do
		if FileExist(LIB_PATH..LIBRARY..".lua") then
			require(LIBRARY)
		else
			DOWNLOADING_LIBS = true
			if LIBRARY == "DivinePred" then
				AutoupdaterMsg("Missing Library! Downloading "..LIBRARY..". If the library doesn't download, please download it manually.")
				DownloadFile("http://divinetek.rocks/divineprediction/DivinePred.lua", LIB_PATH.."DivinePred.lua",function() AutoupdaterMsg("Successfully downloaded "..LIBRARY) end)
				DownloadFile("http://divinetek.rocks/divineprediction/DivinePred.luac", LIB_PATH.."DivinePred.luac",function() AutoupdaterMsg("Successfully downloaded "..LIBRARY) end)
			else
				AutoupdaterMsg("Missing Library! Downloading "..LIBRARY..". If the library doesn't download, please download it manually.")
				DownloadFile(LIBRARY_URL,LIB_PATH..LIBRARY..".lua",function() AutoupdaterMsg("Successfully downloaded "..LIBRARY) end)
			end
		end
	end
	if DOWNLOADING_LIBS then return true end
	if SCRIPT_UPDATER["Activate"] then
		SourceUpdater("<font color=\"#6699ff\">"..SCRIPT_INFO["Name"].."</font>", SCRIPT_INFO["Version"], SCRIPT_UPDATER["URL_HOST"], SCRIPT_UPDATER["URL_PATH"], SCRIPT_UPDATER["Script"], SCRIPT_UPDATER["URL_VERSION"]):CheckUpdate()
	end
end
if Initiate() then return end



if VIP_USER then
 	AdvancedCallback:bind('OnApplyBuff', function(source, unit, buff) OnApplyBuff(source, unit, buff) end)
	AdvancedCallback:bind('OnRemoveBuff', function(unit, buff) OnRemoveBuff(unit, buff) end)
end

local qRange = 875
local wRange = 1000
local eRange = 425

local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local useingE = false
local EActive = false
local recall = false
local j, CanKillChampion
local status
local dead = false
local player = myHero

local ts
local VP, SxO, dp = nil, nil, nil

local EnemyHeroes = GetEnemyHeroes()

--require "SxOrbWalk"
require "SourceLib"



local enemyChamps = {}
local enemyChampsCount = 0

function OnOrbLoad()
	if _G.MMA_LOADED then
		AutoupdaterMsg("MMA LOAD")
		MMALoad = true
	elseif _G.AutoCarry then
		if _G.AutoCarry.Helper then
			AutoupdaterMsg("SIDA AUTO CARRY: REBORN LOAD")
			RebornLoad = true
		else
			AutoupdaterMsg("SIDA AUTO CARRY: REVAMPED LOAD")
			RevampedLoaded = true
		end
	elseif _G.Reborn_Loaded then
		DelayAction(OnOrbLoad, 1)
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		AutoupdaterMsg("SxOrbWalk Load")
		require 'SxOrbWalk'
		SxO = SxOrbWalk()
		SxOLoad = true
	end
end


function OnLoad()

	OnOrbLoad()

	VP = VPrediction()
	dp = DivinePred()
	if SxOLoad then
		SxO:DisableAttacks()
	end

	LoadMenu()
	initialize()

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

		ConfigY:addSubMenu("Prediction", "pred")
			ConfigY.pred:addParam("choose", "Chooes Type", SCRIPT_PARAM_LIST, 1, {"VPrediction", "DivinePred"})

		ConfigY:addSubMenu("killsteal", "killsteal")
			ConfigY.killsteal:addParam("killstealmark", "Killsteal Mark", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.killsteal:addParam("killstealq", "Killsteal Q Toggle", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.killsteal:addParam("killstealhitchance", "Killsteal hit chance", SCRIPT_PARAM_LIST, 1, {"1", "2", "3", "4", "5"})

		ConfigY:addSubMenu("ads", "ads")
			ConfigY.ads:addParam("adsr", "Use R After You dead", SCRIPT_PARAM_ONOFF, true)
			ConfigY.ads:addParam("autoff", "E Auto Off", SCRIPT_PARAM_ONOFF, true)
			ConfigY.ads:addParam("pa", "Passive Active Auto Attack", SCRIPT_PARAM_ONOFF, true)
			ConfigY.ads:addParam("dm", "Damage Manager", SCRIPT_PARAM_ONOFF, true)

		ConfigY:addSubMenu("draw", "draw")
			ConfigY.draw:addParam("drawq", "draw Q", SCRIPT_PARAM_ONOFF, true)
			ConfigY.draw:addParam("draww", "draw W", SCRIPT_PARAM_ONOFF, true)
			ConfigY.draw:addParam("drawe", "draw E", SCRIPT_PARAM_ONOFF, true)

		ConfigY:addSubMenu("orbWalk", "orbWalk")
			SxO:LoadToMenu(ConfigY.orbWalk)
end

function GetHPBarPos(enemy)
	enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}--GetEnemyBarData()
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = 171
	local BarPosOffsetY = 46
	local CorrectionY = 39
	local StartHpPos = 31

	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)

	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos =  Vector(barPos.x + 108 , barPos.y , 0)
	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function initialize()
		for i = 1, heroManager.iCount do
			local hero = heroManager:GetHero(i)
			if hero.team ~= myHero.team then enemyChamps[""..hero.networkID] = DPTarget(hero)
				enemyChampsCount = enemyChampsCount + 1
			end
		end
	end

function OnTick()
	if myHero.dead then return end
	OnCombo()
	OnHarass()
	OnSpellcheck()
	Farm()
	if CountEnemyHeroInRange(eRange) == 0 and EActive == true and Eready and ConfigY.ads.autoff then
		CastSpell(_E)
	end
	if dead then
		PassiveActive()
	end
end

function PassiveActive()
	ts:update()
	if ts.target ~= nil and ConfigY.ads.pa then
		if ConfigY.pred.choose == 1 then
			local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(ts.target, 0.5, 75, 875, 1700, player)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 and ts.target.dead == false then
				if Qready and ConfigY.combo.useq then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		elseif ConfigY.pred.choose == 2 then
			local target = DPTarget(ts.target)
			local state,hitPos,perc = dp:predict(target,CircleSS(math.huge,945,75,600,math.huge))
			if state == SkillShot.STATUS.SUCCESS_HIT then
				CastSpell(_Q,hitPos.x,hitPos.z)
			end
		end
		if ConfigY.pred.choose == 1 then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 10, 1000)
			if CastPosition and HitChance >= 1 and GetDistance(CastPosition) < 1000 then
				if Wready and ConfigY.combo.usew then
					CastSpell(_W, CastPosition.x, CastPosition.z)
				end
			end
		elseif ConfigY.pred.choose == 2 then
			local target = DPTarget(ts.target)
			local state,hitPos,perc = dp:predict(target,CircleSS(math.huge,1000,10,160,math.huge))
			if state == SkillShot.STATUS.SUCCESS_HIT then
				CastSpell(_W,hitPos.x,hitPos.z)
			end
		end
	end
end

function OnCombo()
	ts:update()
	if ts.target ~= nil then
		if ConfigY.combo.activecombo then
			if ConfigY.pred.choose == 1 and ConfigY.combo.useq then
				local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(ts.target, 0.5, 75, 875, 1700, player)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 and ts.target.dead == false then
					if Qready and ConfigY.combo.useq then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			elseif ConfigY.pred.choose == 2 and ConfigY.combo.useq then
				local target = DPTarget(ts.target)
				local state,hitPos,perc = dp:predict(target,CircleSS(math.huge,945,75,600,math.huge))
				if state == SkillShot.STATUS.SUCCESS_HIT then
					CastSpell(_Q,hitPos.x,hitPos.z)
				end
			end
			if ConfigY.pred.choose == 1 and ConfigY.combo.usew then
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(ts.target, 0.5, 10, 1000)
				if CastPosition and HitChance >= 1 and GetDistance(CastPosition) < 1000 then
					if Wready and ConfigY.combo.usew then
						CastSpell(_W, CastPosition.x, CastPosition.z)
					end
				end
			elseif ConfigY.pred.choose == 2 and ConfigY.combo.usew then
				local target = DPTarget(ts.target)
				local state,hitPos,perc = dp:predict(target,CircleSS(math.huge,1000,10,160,math.huge))
					if state == SkillShot.STATUS.SUCCESS_HIT then
						CastSpell(_W,hitPos.x,hitPos.z)
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

function OnHarass()
	if ConfigY.harass.harasstoggle and recall == false or ConfigY.harass.harassactive then
		ts:update()
		if ts.target ~= nil then
			if ConfigY.pred.choose == 1 then
				local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(ts.target, 0.5, 75, 875, 1700, player)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 and ts.target.dead == false then
					if Qready and ConfigY.harass.useq and myHero.mana > (myHero.maxMana*(ConfigY.harass.perq*0.01)) then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			elseif ConfigY.pred.choose == 2 then
				local target = DPTarget(ts.target)
				local state,hitPos,perc = dp:predict(target,CircleSS(math.huge,945,75,600,math.huge))
				if state == SkillShot.STATUS.SUCCESS_HIT and Qready and ConfigY.harass.useq and myHero.mana > (myHero.maxMana*(ConfigY.harass.perq*0.01)) then
					CastSpell(_Q,hitPos.x,hitPos.z)
				end
			end
			if ConfigY.harass.usee and CountEnemyHeroInRange(eRange) >= 1 and EActive == false and Eready and myHero.mana >= (myHero.maxMana*(ConfigY.harass.pere*0.01)) then
				CastSpell(_E)
			end

			if CountEnemyHeroInRange(eRange) == 0 and EActive and Eready then
				CastSpell(_E)
			elseif myHero.mana < (myHero.maxMana*(ConfigY.harass.pere*0.01)) and EActive and Eready then
				CastSpell(_E)
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
			if stat(CanKillChampion) == "Can" then
				DrawText(CanKillChampion.charName.." can kill with R? | "..stat(CanKillChampion), 18, 100, 100+j*20, 0xFFFF0000)
			elseif stat(CanKillChampion) == "Cant" or stat(CanKillChampion) == "dead" then
				DrawText(CanKillChampion.charName.." can kill with R? | "..stat(CanKillChampion), 18, 100, 100+j*20, 0xFFFFFF00)
			end
		end
	end
	for i, j in ipairs(GetEnemyHeroes()) do
		if GetDistance(j) < 2000 and not j.dead and ConfigY.ads.dm then
			local pos = GetHPBarPos(j)
			local dmg, Qdamage = GetSpellDmg(j)
			if dmg == "CanComboKill" then
				DrawText("Can Combo Kill!",18 , pos.x, pos.y-48, 0xffff0000)
			else
				local pos2 = ((j.health - dmg)/j.maxHealth)*100
				DrawLine(pos.x+pos2, pos.y, pos.x+pos2, pos.y-30, 1, 0xffff0000)
				local hit = tostring(math.ceil(j.health/Qdamage))
				DrawText("Q hit : "..hit,18 , pos.x, pos.y-48, 0xffff0000)
			end
		end
	end
end

function GetSpellDmg(enemy)
	local combodmg
	local Qdmg = getDmg("Q", enemy, player)
	local Edmg = getDmg("E", enemy, player)
	local Rdmg = getDmg("R", enemy, player)
	if enemy.health < Qdmg+Edmg+Rdmg then
		combodmg = "CanComboKill"
		return combodmg
	else
		combodmg = Qdmg+Edmg+Rdmg
		return combodmg, Qdmg
	end
end

function stat(unit)
	if getDmg("R", unit, myHero) > unit.health and not unit.dead then
		status = "Can"
	else
		status = "Cant"
	end
	if unit.dead then
		status = "dead"
	end
	return status
end

function Farm()
	if ConfigY.farm.farm then
		enemyMinions:update()
		for i, minion in ipairs(enemyMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= 875 and myHero:CanUseSpell(_Q) == READY and getDmg("Q", minion, myHero)-50 > minion.health and ConfigY.farm.useq then
				if ConfigY.pred.choose == 1 then
					local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(minion, 0.5, 75, 875, 1700, player)
					if CastPosition and HitChance >= 2 then
						if Qready then
							CastSpell(_Q, CastPosition.x, CastPosition.z)
						end
					end
				elseif ConfigY.pred.choose == 2 then
					local target = DPTarget(minion)
					local state,hitPos,perc = dp:predict(target,CircleSS(math.huge,845,75,600,math.huge))
					if state == SkillShot.STATUS.SUCCESS_HIT then
						CastSpell(_Q,hitPos.x,hitPos.z)
					end
				end
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
	if unit and unit.isMe and buff.name == "KarthusDeathDefiedBuff" then
		dead = true
	end
end

function OnRemoveBuff(unit, buff)
    if unit and unit.isMe and buff.name == "KarthusDefile" then
        EActive = false
    end
	if unit and unit.isMe and buff.name == "recall" then
		recall = false
    end
	if unit and unit.isMe and buff.name == "KarthusDeathDefiedBuff" then
		dead = false
	end
end
