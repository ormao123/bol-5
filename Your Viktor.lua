if not VIP_USER and myHero.charName ~= "Viktor" then return end

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Viktor:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end


--AutoupdaterMsg("WellCome "..ID)


local version = 1.02
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Viktor.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Your Viktor.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH


if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/version/Your Viktor.version")
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


require "SourceLib"
require "DivinePred"

local Q = {Rance = 740, IsReady = function() return myHero:CanUseSpell(_Q) == READY end, Damage = function(target) return getDmg("Q", target, myHero) end,}
local W = {Rance = 700, IsReady = function() return myHero:CanUseSpell(_W) == READY end, Damage = function(target) return getDmg("W", target, myHero) end,}
local E = {Rance = 760, Speed = 750, MinRance = 540, MaxRance = 1200, Radius = 75, Delay = 175, IsReady = function() return myHero:CanUseSpell(_E) == READY end, Damage = function(target) return getDmg("E", target, myHero) end,}
local R = {Rance = 700, IsReady = function() return myHero:CanUseSpell(_R) == READY end, Damage = function(target) return getDmg("R", target, myHero) end,}

local EnemyMinions = minionManager(MINION_ENEMY, 1500, player, MINION_SORT_MAXHEALTH_DEC)
local jungleMinion
local viktorE = LineSS(E.Speed,E.Rance,E.Radius,E.Delay,math.huge)
local player = myHero
local ts, SxO
local MMALoaded, SxOLoaded, RebornLoaded, RevampedLoaded, SOWLoaded = false, false, false, false, false
local DrawLeft, DrawRight, DrawTop
local enemyHeroes = GetEnemyHeroes()
JungleMobs = {}
JungleFocusMobs = {}

local KillText = {}
local KillTextColor = ARGB(250, 255, 38, 1)
local KillTextList =
 {		
	"Harass your enemy!", 					-- 01
	"Wait for your CD's!",					-- 02
	"Kill! - Ignite",						-- 03
	"Kill! - (Q)",							-- 04 
	"Kill! - (R)",							-- 05
	"Kill! - (E)",							-- 06
	"Kill! - (Q)+(R)",						-- 07
	"Kill! - (Q)+(E)",						-- 08
	"Kill! - (W)+(E)",						-- 09
	"Kill! - (Q)+(E)+(R)"					-- 10
}

local ToInterrupt = {}
local Interrupt = {}
local InterruptList = {
    {charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    {charName = "FiddleSticks", spellName = "Crowstorm"},
    {charName = "FiddleSticks", spellName = "Drain"},
    {charName = "Galio", spellName = "GalioIdolOfDurand"},
    {charName = "Karthus", spellName = "FallenOne"},
    {charName = "Katarina", spellName = "KatarinaR"},
    {charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    {charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    {charName = "Nunu", spellName = "AbsoluteZero"},
    {charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    {charName = "Shen", spellName = "ShenStandUnited"},
    {charName = "Urgot", spellName = "UrgotSwap2"},
    {charName = "Varus", spellName = "VarusQ"},
    {charName = "Warwick", spellName = "InfiniteDuress"}
}

local function OrbLoad()
	if _G.MMA_Loaded then
		MMALoaded = true
		AutoupdaterMsg("Found MMA")
	--[[elseif _G.AutoCarry then
		if _G.AutoCarry.Helper then
			RebornLoaded = true
			AutoupdaterMsg("Found SAC: Reborn")
		else
			RevampedLoaded = true
			AutoupdaterMsg("Found SAC: Revamped")
		end
	elseif _G.Reborn_Loaded then
		DelayAction(OrbLoad, 1)]]
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		require 'SxOrbWalk'
		SxO = SxOrbWalk()
		SxOLoaded = true
		AutoupdaterMsg("Loaded SxOrb")
	elseif FileExist(LIB_PATH .. "SOW.lua") then
		require 'SOW'
		SOWi = SOW(VP)
		SOWLoaded = true
		ScriptMsg("Loaded SOW")
	else
		AutoupdaterMsg("Cant Fine OrbWalker")
	end
end

local function OrbReset()
	if MMALoaded then
		_G.MMA_ResetAutoAttack()
	elseif SxOrbLoaded then
		SxO:ResetAA()
	elseif SOWLoaded then
		SOW:resetAA()
	end
end

local function OrbTarget(rance)
	local T
	if MMALoad then T = _G.MMA_Target end
	if RebornLoad then T = _G.AutoCarry.Crosshair.Attack_Crosshair.target end
	if RevampedLoaded then T = _G.AutoCarry.Orbwalker.target end
	if SxOLoad then T = SxO:GetTarget() end
	if T == nil then 
		T = STS:GetTarget(rance)
	end
	if T and T.type == player.type and ValidTarget(T, rance) then
		return T
	end
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


function OnLoad()
	AutoupdaterMsg("LOAD");
	
	OrbLoad()
	STS = SimpleTS()
	dp = DivinePred() 
	
	OnLoadMenu()
	
	
	
	
	for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
		for _, champ in pairs(InterruptList) do
			if hero.charName == champ.charName then
				table.insert(ToInterrupt, champ.spellName)
			end
        end
    end
if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true
	else
		TwistedTreeline = false
	end
	setting()
end

function setting()

	if not TwistedTreeline then
		JungleMobNames = {
			["SRU_MurkwolfMini2.1.3"]	= true,
			["SRU_MurkwolfMini2.1.2"]	= true,
			["SRU_MurkwolfMini8.1.3"]	= true,
			["SRU_MurkwolfMini8.1.2"]	= true,
			["SRU_BlueMini1.1.2"]		= true,
			["SRU_BlueMini7.1.2"]		= true,
			["SRU_BlueMini21.1.3"]		= true,
			["SRU_BlueMini27.1.3"]		= true,
			["SRU_RedMini10.1.2"]		= true,
			["SRU_RedMini10.1.3"]		= true,
			["SRU_RedMini4.1.2"]		= true,
			["SRU_RedMini4.1.3"]		= true,
			["SRU_KrugMini11.1.1"]		= true,
			["SRU_KrugMini5.1.1"]		= true,
			["SRU_RazorbeakMini9.1.2"]	= true,
			["SRU_RazorbeakMini9.1.3"]	= true,
			["SRU_RazorbeakMini9.1.4"]	= true,
			["SRU_RazorbeakMini3.1.2"]	= true,
			["SRU_RazorbeakMini3.1.3"]	= true,
			["SRU_RazorbeakMini3.1.4"]	= true
		}

		FocusJungleNames = {
			["SRU_Blue1.1.1"]			= true,
			["SRU_Blue7.1.1"]			= true,
			["SRU_Murkwolf2.1.1"]		= true,
			["SRU_Murkwolf8.1.1"]		= true,
			["SRU_Gromp13.1.1"]			= true,
			["SRU_Gromp14.1.1"]			= true,
			["Sru_Crab16.1.1"]			= true,
			["Sru_Crab15.1.1"]			= true,
			["SRU_Red10.1.1"]			= true,
			["SRU_Red4.1.1"]			= true,
			["SRU_Krug11.1.2"]			= true,
			["SRU_Krug5.1.2"]			= true,
			["SRU_Razorbeak9.1.1"]		= true,
			["SRU_Razorbeak3.1.1"]		= true,
			["SRU_Dragon6.1.1"]			= true,
			["SRU_Baron12.1.1"]			= true
		}
	else
		FocusJungleNames = {
			["TT_NWraith1.1.1"]			= true,
			["TT_NGolem2.1.1"]			= true,
			["TT_NWolf3.1.1"]			= true,
			["TT_NWraith4.1.1"]			= true,
			["TT_NGolem5.1.1"]			= true,
			["TT_NWolf6.1.1"]			= true,
			["TT_Spiderboss8.1.1"]		= true
		}
		JungleMobNames = {
			["TT_NWraith21.1.2"]		= true,
			["TT_NWraith21.1.3"]		= true,
			["TT_NGolem22.1.2"]			= true,
			["TT_NWolf23.1.2"]			= true,
			["TT_NWolf23.1.3"]			= true,
			["TT_NWraith24.1.2"]		= true,
			["TT_NWraith24.1.3"]		= true,
			["TT_NGolem25.1.1"]			= true,
			["TT_NWolf26.1.2"]			= true,
			["TT_NWolf26.1.3"]			= true
		}
	end
	 _JungleMobs = minionManager(MINION_JUNGLE, 1500, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function OnDraw()
	if Config.Draw.DrawQ then
		DrawCircle(player.x, player.y, player.z, Q.Rance, TARGB(Config.Draw.DrawQColor))
	end
	if Config.Draw.DrawW then
		DrawCircle(player.x, player.y, player.z, W.Rance, TARGB(Config.Draw.DrawWColor))
	end
	if Config.Draw.DrawE then
		DrawCircle(player.x, player.y, player.z, E.MaxRance, TARGB(Config.Draw.DrawEColor))
	end
	if Config.Draw.DrawR then
		DrawCircle(player.x, player.y, player.z, R.Rance, TARGB(Config.Draw.DrawRColor))
	end
	
	for i, j in ipairs(GetEnemyHeroes()) do
		if GetDistance(j) < 2000 and not j.dead and Config.Ads.dm then
			if KillText[i] == 1 then	
				local pos = GetHPBarPos(j)
				local dmg = GetSpellDmg(j)

				local pos2 = ((j.health - dmg)/j.maxHealth)*100
				DrawLine(pos.x+pos2, pos.y, pos.x+pos2, pos.y-30, 1, 0xffff0000)
			else
				for i, enemy in pairs(enemyHeroes) do
					if ValidTarget(enemy) and enemy ~= nil then
						local barPos = GetHPBarPos(enemy)
						DrawText(KillTextList[KillText[i]], 18, barPos.x, barPos.y-60, KillTextColor)
					end
				end
			end
		end
	end
	if Config.Draw.Ehelp and DrawLeft and DrawRight and DrawTop then
		DrawLine(DrawLeft.x, DrawLeft.y, DrawRight.x, DrawRight.y, 1, 0xFFFF0000)
		DrawLine(DrawLeft.x, DrawLeft.y, DrawTop.x, DrawTop.y, 1, 0xFFFF0000)
		DrawLine(DrawRight.x, DrawRight.y, DrawTop.x, DrawTop.y, 1, 0xFFFF0000)
		DrawLeft, DrawRight, DrawTop = nil
	end
end

function GetSpellDmg(enemy)
	local combodmg
	local Qdmg = getDmg("Q", enemy, player)
	local Edmg = getDmg("E", enemy, player)
	local Rdmg = getDmg("R", enemy, player)
	
	combodmg = Qdmg+Edmg+Rdmg
	return combodmg
end

function OnLoadMenu()
	
	Config = scriptConfig("Your Victor", "Your Victor");
	
		Config:addSubMenu("TargetSelector", "TargetSelector")
			STS:AddToMenu(Config.TargetSelector)
		
		Config:addSubMenu("HotKey", "HotKey")
			Config.HotKey:addParam("Combo", "Combo Active", SCRIPT_PARAM_ONKEYDOWN, false, 32);
			Config.HotKey:addParam("Harass", "Harass Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			Config.HotKey:addParam("HarassToggle", "Harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("G"))
			Config.HotKey:addParam("Clear", "Line Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			--Config.HotKey:addParam("Debug", "Debug", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
			
		Config:addSubMenu("Combo", "Combo")
			Config.Combo:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			Config.Combo:addParam("UseW", "Use W", SCRIPT_PARAM_ONOFF, true)
			Config.Combo:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
			--Config.Combo:addParam("UseR", "Use R", SCRIPT_PARAM_ONOFF, true)
			Config.Combo:addParam("FullCombo", "Use FullCombo", SCRIPT_PARAM_ONOFF, true)
			Config.Combo:addParam("FullComboHealth", "Use FullCombo % Health", SCRIPT_PARAM_SLICE, 60, 0, 100, 0)
			Config.Combo:addParam("FullComboType", "Full Combo Type", SCRIPT_PARAM_LIST, 1, {"Use All Skill Alway", "Use Not All Skill"})
			
		Config:addSubMenu("Harass", "Harass")
			Config.Harass:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			Config.Harass:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
			Config.Harass:addParam("Mana", "ManaManager", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			
		Config:addSubMenu("Clear", "Clear")
			Config.Clear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			Config.Clear:addParam("UseE", "Use E", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("QSetting", "QSetting")
			Config.QSetting:addParam("KillSteal", "KillSteal", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("WSetting", "WSetting")
			--Config.WSetting:addParam("KillSteal", "KillSteal", SCRIPT_PARAM_ONOFF, true)
			Config.WSetting:addParam("interrupt", "interrupt On", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("ESetting", "ESetting")
			Config.ESetting:addParam("KillSteal", "KillSteal", SCRIPT_PARAM_ONOFF, true)
			Config.ESetting:addParam("Logic", "Choose Logic", SCRIPT_PARAM_LIST, 1, {"Logic 1", "Logic 2"})
			
		Config:addSubMenu("RSetting", "RSetting")
			Config.RSetting:addParam("KillSteal", "KillSteal", SCRIPT_PARAM_ONOFF, true)
			Config.RSetting:addParam("interrupt", "interrupt On", SCRIPT_PARAM_ONOFF, true)
		
		Config:addSubMenu("Ads", "Ads")
			Config.Ads:addParam("Priority", "interrupt Priority", SCRIPT_PARAM_LIST, 1, {"W-R", "R-W"})
			Config.Ads:addParam("dm", "DamageManager", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("Draw", "Draw")
			Config.Draw:addParam("DrawQ", "Draw Q Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawQColor", "Draw Q Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("DrawW", "Draw W Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawWColor", "Draw W Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("DrawE", "Draw E Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawEColor", "Draw E Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("DrawR", "Draw R Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawRColor", "Draw R Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("Ehelp", "E help", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("OrbWalk", "OrbWalk")
		if SxOLoaded then
			Config.OrbWalk:addParam("info0", "", SCRIPT_PARAM_INFO, "")
			Config.OrbWalk:addParam("info1", "SxOrbWalk settings", SCRIPT_PARAM_INFO, "")
			SxO:LoadToMenu(Config.OrbWalk)
		elseif MMALoaded then
			Config.OrbWalk:addParam("r","MMA Road", SCRIPT_PARAM_INFO)
		elseif SOWLoaded then
			Config.OrbWalk:addParam("info0", "", SCRIPT_PARAM_INFO, "")
			Config.OrbWalk:addParam("info1", "SOW settings", SCRIPT_PARAM_INFO, "")
			SOWi:LoadToMenu(Config.OrbWalk)
		else
			Config.OrbWalk:addParam("r","SAC Load", SCRIPT_PARAM_INFO)
		end
		
		Config:addParam("INFO", "", SCRIPT_PARAM_INFO, "")
		Config:addParam("INFO2", "Version", SCRIPT_PARAM_INFO, version)
		Config:addParam("INFO3", "Author", SCRIPT_PARAM_INFO, "Yours")
end

function OnTick()
	local Target = OrbTarget(1500)
	if Config.HotKey.Combo then
		Combo()
	elseif Config.HotKey.Harass or Config.HotKey.HarassToggle then
		Harass()
	elseif Config.HotKey.Clear then
		Clear()
	elseif Config.HotKey.Debug then
		Debug()
	end
	killsteal()
	DamageCalculation()
end

function Combo()
	local Target = OrbTarget(1500)
	if Target ~= nil then
		if Config.Combo.FullCombo and Target.health < (Target.maxHealth*(Config.Combo.FullComboHealth*0.01)) and player.level >= 6 then
			FullCombo(Target)
		else
			NormalCombo(Target)
		end
	end
end

function NormalCombo(Target)
	if Target ~= nil then
		if Config.Combo.UseQ then
			CastQ(Target)
		end
		if Config.Combo.UseW then
			CastW(Target)
		end
		if Config.Combo.UseE then
			CastE(Target)
		end
	end
end

function FullCombo(Target)
	if Target ~= nil then
		if Config.Combo.FullComboType == 1 then
			if Q.IsReady() and W.IsReady() and E.IsReady() and R.IsReady() then
				DelayAction(function() CastR(Target) end, 0.1)
				DelayAction(function() CastW(Target) end, 0.1)
				DelayAction(function() CastQ(Target) end, 0.1)
				DelayAction(function() CastE(Target) end, 0.2)
			end
		elseif Config.Combo.FullComboType == 2 then
			if R.IsReady() then
				CastR(Target);
			end
			if W.IsReady() then
				CastW(Target);
			end
			if Q.IsReady() then
				CastQ(Target);
			end
			if E.IsReady() then
				CastE(Target);
			end
		end
	end
end

function Harass()
	local Target = OrbTarget(1500)
	if Target ~= nil and myHero.mana > (myHero.maxMana*(Config.Harass.Mana*0.01)) then
		if Config.Harass.UseQ and Q.IsReady() then
			CastQ(Target)
		end
		if Config.Harass.UseE and E.IsReady() then
			CastE(Target)
		end
	end
end

function Clear()
	_JungleMobs:update()
	for i, minion in pairs(_JungleMobs.objects) do
		if Config.Clear.UseE and E.IsReady() then
			if minion ~= nil and ValidTarget(minion) and  minion.dead == false and GetDistance(minion) < E.MinRance then
				local BestPos, besthit = GetBestLineFarmPosition(E.MinRance, 75, _JungleMobs.objects)
				if BestPos ~= nil and not minion.dead then
					CastE(BestPos)
				end
			end
		end
		if Config.Clear.UseQ and Q.IsReady() then
			if minion ~= nil and minion.dead == false and GetDistance(minion) < Q.Rance then
				CastQ(minion)
			end
		end
	end
	EnemyMinions:update()
	for i, minion in pairs(EnemyMinions.objects) do
		if Config.Clear.UseE and E.IsReady() then
			if minion ~= nil and ValidTarget(minion) and  minion.dead == false and GetDistance(minion) < E.MinRance then
				local BestPos, besthit = GetBestLineFarmPosition(E.MinRance, 75, EnemyMinions.objects)
				if BestPos ~= nil and not minion.dead then
					CastE(BestPos)
				end
			end
		end
		if Config.Clear.UseQ and Q.IsReady() then
			if minion ~= nil and minion.dead == false and GetDistance(minion) < Q.Rance then
				CastQ(minion)
			end
		end
	end
end

function killsteal()
	for i, t in pairs(enemyHeroes) do
		if ValidTarget(t) and Config.QSetting.KillSteal and GetDistance(t, player) < Q.Rance and Q.Damage(t) > t.health and Q.IsReady() then
			CastQ(t)
		end
		if ValidTarget(t) and Config.ESetting.KillSteal and GetDistance(t, player) < E.MaxRance and E.Damage(t) > t.health and E.IsReady() then
			CastE(t)
		end
		if ValidTarget(t) and Config.RSetting.KillSteal and GetDistance(t, player) < R.Rance and R.Damage(t) > t.health and R.IsReady() then
			CastR(t)
		end
	end
end

function CastQ(T)
	if Q.IsReady() then
		if GetDistance(T, player) < Q.Rance then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = T.networkID}):send()
			OrbReset()
		end
	end
end

function CastW(T)
	if W.IsReady() then
		if GetDistance(T, player) < W.Rance then
			local target = DPTarget(T)
			local state,hitPos,perc = dp:predict(target,CircleSS(math.huge,W.Rance,300,200,math.huge)) -- 300, 0.5, 1750, false

			if state==SkillShot.STATUS.SUCCESS_HIT then
				Packet("S_CAST", {spellId = _W, toX = hitPos.x, toY = hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
			end
		end
	end
end

function CastE(T)
	if Config.ESetting.Logic == 1 then
		ELogicOne(T);
	elseif Config.ESetting.Logic == 2 then
		ELogicTwo(T);
	elseif Config.ESetting.Logic == 3 then
		--ELogicThree(T);
	end
end

function ELogicOne(T)
	if E.IsReady() then
		if GetDistance(T, player) < E.MaxRance then
			local tr = GetDistance(myHero,T)

			if tr	<=	E.MinRance then
				Packet("S_CAST", {spellId = _E, toX = T.x, toY = T.z, fromX = T.x, fromY = T.z}):send()
			elseif tr>E.MinRance and tr< E.MaxRance then
				local target = DPTarget(T)
				local castPosX = (E.MinRance*T.x+(tr - E.MinRance)*myHero.x)/tr
				local castPosZ = (E.MinRance*T.z+(tr - E.MinRance)*myHero.z)/tr
				local state,hitPos,perc = dp:predict(target,viktorE,2,Vector(castPosX,0,castPosZ))
				if state == SkillShot.STATUS.SUCCESS_HIT then
					if GetDistance(myHero,hitPos) > E.MinRance then					
						local dist2 = GetDistance(myHero,hitPos)
						local hitPosX = (E.MinRance*hitPos.x+(dist2 - E.MinRance)*myHero.x)/dist2
						local hitPosZ = (E.MinRance*hitPos.z+(dist2 - E.MinRance)*myHero.z)/dist2
						Packet("S_CAST", {spellId = _E, toX = hitPosX, toY = hitPosZ, fromX = hitPosX, fromY = hitPosZ}):send()
					else
						Packet("S_CAST", {spellId = _E, toX = hitPos.x, toY = hitPos.z, fromX = hitPos.x, fromY = hitPos.z}):send()
					end
				end
			end
		end
	end
end

function ELogicTwo(T)
	if E.IsReady() then
		if GetDistance(T, player) < E.MaxRance then
			local tr = GetDistance(myHero,T)

			if tr	<=	E.MinRance then
				local behind = behind(myHero, T)
				Packet("S_CAST", {spellId = _E, toX = T.x, toY = T.z, fromX = behind.x, fromY = behind.z}):send()
			elseif tr>E.MinRance and tr< E.MaxRance then
				local target = DPTarget(T)
				local castPosX = (E.MinRance*T.x+(tr - E.MinRance)*myHero.x)/tr
				local castPosZ = (E.MinRance*T.z+(tr - E.MinRance)*myHero.z)/tr
				local state,hitPos,perc = dp:predict(target,viktorE,2,Vector(castPosX,0,castPosZ))
				if state == SkillShot.STATUS.SUCCESS_HIT then
					if GetDistance(myHero,hitPos) > E.MinRance then					
						local dist2 = GetDistance(myHero,hitPos)
						local hitPosX = (E.MinRance*hitPos.x+(dist2 - E.MinRance)*myHero.x)/dist2
						local hitPosZ = (E.MinRance*hitPos.z+(dist2 - E.MinRance)*myHero.z)/dist2
						local behind = behind(myHero, T)
						Packet("S_CAST", {spellId = _E, toX = hitPosX, toY = hitPosZ, fromX = behind.x, fromY = behind.z}):send()
					else
						local behind = behind(myHero, T)
						Packet("S_CAST", {spellId = _E, toX = hitPos.x, toY = hitPos.z, fromX = behind.x, fromY = behind.z}):send()
					end
				end
			end
		end
	end
end

function ELogicThree( T )
	-- body
	if E.IsReady() then
		if GetDistance(T, player) <= E.MinRance then
		if GetNearEnemy(T, E.Rance) >= 1 then
			local BestPos, BestHit = GetBestLinePosition(T, E.Rance, E.Radius, GetEnemyHeroes())
			if BestPos ~= nil then
				Packet("S_CAST", {spellId = _R, toX = BestPos.x, toY = BestPos.z, fromX = behind.x, fromY = behind.z}):send()
			end
		end
		end
	end
end


function CastR(T)
	if R.IsReady() then
		if GetDistance(T, player) < R.Rance then
			Packet("S_CAST", {spellId = _R, toX = T.x, toY = T.z, fromX = T.x, fromY = T.z}):send()
		end
	end
end

function OnProcessSpell(unit, spell)
	if #ToInterrupt > 0 then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= player.team then
				if Config.Ads.Priority == 1 then
					if Config.WSetting.interrupt and W.IsReady() and GetDistance(unit, player) < W.Rance then
						CastW(unit)
					end
					if  Config.RSetting.interrupt and R.IsReady() and R.IsReady() == false and GetDistance(unit, player) < R.Rance then
						CastR(unit)
					end
				elseif Config.Ads.Priority == 2 then
					if  Config.RSetting.interrupt and R.IsReady() and GetDistance(unit, player) < R.Rance then
						CastR(unit)
					end
					if Config.WSetting.interrupt and W.IsReady() and W.IsReady() == false and GetDistance(unit, player) < W.Rance then
						CastW(unit)
					end
				end
			end
		end
	end
end

function GetBestLineFarmPosition(range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local EndPos = Vector(myHero) + range * (Vector(object) - Vector(myHero)):normalized()
        local hit = CountObjectsOnLineSegment(myHero, EndPos, width, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = object
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function GetBestLinePosition(StartPos ,range, width, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local EndPos = Vector(StartPos) + range * (Vector(object) - Vector(StartPos)):normalized()
        local hit = CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = object
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
        if isOnSegment and GetDistanceSqr(pointSegment, object) < width * width and GetDistanceSqr(StartPos, EndPos) > GetDistanceSqr(StartPos, object) then
            n = n + 1
        end
    end
    return n
end

function behind(unit, target)
	return target + Vector(unit.x-target.x,unit.y,unit.z-target.z):normalized()*(GetDistance(unit,target)+100)
end

function GetNearEnemy(unit, rance)
	local count = 0
	for i, j in pairs(enemyHeroes) do
		if GetDistance(i, unit) < rance and unit ~= i then
			count = count + 1
		end
	end
	return count
end


function DamageCalculation()
	for i, enemy in pairs(enemyHeroes) do
		if ValidTarget(enemy) and enemy ~= nil then
			qDmg 		= ((getDmg("Q", enemy, myHero)) or 0)	
			eDmg		= ((getDmg("E", enemy, myHero)) or 0)	
			rDmg		= ((getDmg("R", enemy, myHero)) or 0)
			--iDmg 		= ((Ignite and getDmg("IGNITE", enemy, myHero)) or 0)	-- Ignite
			local abilityDmg = qDmg + rDmg + eDmg
			-- Set Kill Text --	
			-- "Kill! - Ignite" --
			--[[if enemy.health <= iDmgthen
					 if IREADY then KillText[i] = 3
					 else KillText[i] = 2
				 end]]
			-- "Kill! - (Q)" --
			elseif enemy.health <= qDmg then
				if Q.IsReady() then
					KillText[i] = 4
				else
					KillText[i] = 2
				end
			--	"Kill! - (W)" --
			elseif enemy.health <= rDmg then
				if W.IsReady() then KillText[i] = 5
					else KillText[i] = 2
				end
			-- "Kill! - (E)" --
			elseif enemy.health <= eDmg then
				if E.IsReady() then KillText[i] = 6
					else KillText[i] = 2
				end
			-- "Kill! - (Q)+(W)" --
			elseif enemy.health <= qDmg+rDmg then
				if Q.IsReady() and W.IsReady() then KillText[i] = 7
					else KillText[i] = 2
				end
			-- "Kill! - (Q)+(E)" --
			elseif enemy.health <= qDmg+eDmg then
				if Q.IsReady() and E.IsReady() then KillText[i] = 8
					else KillText[i] = 2
				end
			-- "Kill! - (W)+(E)" --
			elseif enemy.health <= wDmg+eDmg then
				if W.IsReady() and E.IsReady() then KillText[i] = 9
					else KillText[i] = 2
				end
			-- "Kill! - (Q)+(W)+(E)" --
			elseif enemy.health <= qDmg+rDmg+eDmg then
				if Q.IsReady() and W.IsReady() and E.IsReady() then KillText[i] = 10
					else KillText[i] = 2
				end
			-- "Harass your enemy!" -- 
			else KillText[i] = 1				
			end
		end
end