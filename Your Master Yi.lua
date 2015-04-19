--[[
        Your Master Yi

	v 1.0		Release
	V 1.01		Fix Q Rogic, W Cansle,
	v 1.02		Fix Bug

]]











if myHero.charName ~= "MasterYi" then return end

require "SourceLib"
local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Master Yi:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end


local Author = "Your"

local version = "1.02"
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Master Yi.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/version/Your Master Yi.version")
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

local Ignite = nil

local defaultRange = myHero.range + GetDistance(myHero.minBBox)
local enemyHeroes = GetEnemyHeroes()


local enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_MAXHEALTH_DEC)

local Q = {Name = "Alpha Strike", Range = 600, IsReady = function() return myHero:CanUseSpell(_Q) == READY end,}
local W = {Name = "Meditate", Range = defaultRange, IsReady = function() return myHero:CanUseSpell(_W) == READY end,}
local E = {Name = "Wuju Style", Range = defaultRange, IsReady = function() return myHero:CanUseSpell(_E) == READY end,}
local R = {Name = "Highlander", Range = 125, IsReady = function() return myHero:CanUseSpell(_R) == READY end,}

local qDmg = 0
local wDmg = 0
local eDmg = 0


local JungleMobs = {}
local JungleFocusMobs = {}


local EvadingSpell =
{
	["Jax"]			= {"CounterStrike"},
	["Teemo"]		= {"BlindingDart"},
}

local KillText = {}
local KillTextColor = ARGB(250, 255, 38, 1)
local KillTextList =
 {
	"Harass your enemy!", 					-- 01
	"Wait for your CD's!",					-- 02
	"Kill! - Ignite",						-- 03
	"Kill! - (Q)",							-- 04
	"Kill! - (W)",							-- 05
	"Kill! - (E)",							-- 06
	"Kill! - (Q)+(W)",						-- 07
	"Kill! - (Q)+(E)",						-- 08
	"Kill! - (W)+(E)",						-- 09
	"Kill! - (Q)+(W)+(E)"					-- 10
}

local MMALoaded, RebornLoaded, RevampedLoaded, SxOLoaded, SACLoaded = nil, nil, nil, nil, nil

local function OrbLoad()
	if _G.MMA_Loaded then
		MMALoaded = true
		AutoupdaterMsg("Found MMA")
	elseif _G.AutoCarry then
		if _G.AutoCarry.Helper then
			RebornLoaded = true
			AutoupdaterMsg("Found SAC: Reborn")
		else
			RevampedLoaded = true
			AutoupdaterMsg("Found SAC: Revamped")
		end
	elseif _G.Reborn_Loaded then
		SACLoaded = true
		DelayAction(OrbLoad, 1)
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		require 'SxOrbWalk'
		SxO = SxOrbWalk()
		SxOLoaded = true
		AutoupdaterMsg("Loaded SxO")
	elseif FileExist(LIB_PATH .. "SOW.lua") then
		require 'SOW'
		SOW = SOW(VP)
		SOWLoaded = true
		ScriptMsg("Loaded SOW")
	else
		AutoupdaterMsg("Cant Fine OrbWalker")
	end
end

local function OrbReset()
	if MMALoaded then
		_G.MMA_ResetAutoAttack()
	elseif RebornLoaded then
		_G.AutoCarry.MyHero:AttacksEnabled(true)
	elseif SxOLoaded then
		SxO:ResetAA()
	elseif SOWLoaded then
		SOW:resetAA()
	end
end

function OrbwalkCanMove()
 	if RebornLoaded then
    	return _G.AutoCarry.Orbwalker:CanMove()
 	elseif MMALoaded then
	    return _G.MMA_AbleToMove
	 elseif SxOLoaded then
 	   return SxO:CanMove()
	elseif SOWLoaded then
	   return SOW:CanMove()
	 end
end

local function OrbTarget(rance)
	local T
	if MMALoad then T = _G.MMA_Target end
	if RebornLoad then T = _G.AutoCarry.Crosshair.Attack_Crosshair.target end
	if RevampedLoaded then T = _G.AutoCarry.Orbwalker.target end
	if SxOLoad then T = SxO:GetTarget() end
	if SOWLoaded then T = SOW:GetTarget() end
	if T == nil then
		T = STS:GetTarget(rance)
	end
	if T and T.type == player.type and ValidTarget(T, rance) then
		return T
	end
end

function Setting()



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

	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object and object.valid and not object.dead then
			if FocusJungleNames[object.name] then
				JungleFocusMobs[#JungleFocusMobs+1] = object
			elseif JungleMobNames[object.name] then
				JungleMobs[#JungleMobs+1] = object
			end
		end
	end
end

function GetJungleMob(rance)
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, rance) then
			return Mob
		end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, rance) then
			return Mob
		end
	end
end

function OnLoad()
	STS = SimpleTS()
	OrbLoad()
	local Ignite = GetSummonerSlot("Ignite", player)
	if Ignite ~= nil then AutoupdaterMsg("Ignite Manager On") end

	LoadMenu()

 	if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true
	else
		TwistedTreeline = false
	end
end



function LoadMenu()
	Config = scriptConfig("[Your] Master Yi", "[Your] Master Yi")
		Config:addSubMenu("Hotkey", "Hotkey")
			Config.Hotkey:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Config.Hotkey:addParam("Clear", "Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			Config.Hotkey:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

		Config:addSubMenu("Combo", "Combo")
			Config.Combo:addParam("UseQ", "UseQ", SCRIPT_PARAM_ONOFF, true)
			Config.Combo:addParam("UseW", "UseW", SCRIPT_PARAM_ONOFF, true)
			Config.Combo:addParam("UseE", "UseE", SCRIPT_PARAM_ONOFF, true)
			Config.Combo:addParam("UseR", "UseR", SCRIPT_PARAM_ONOFF, true)
			--Config.Combo:addParam("UseItem", "UseItem", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("Harass", "Harass")
			Config.Harass:addParam("UseQ", "UseQ", SCRIPT_PARAM_ONOFF, true)
			Config.Harass:addParam("UseW", "UseW", SCRIPT_PARAM_ONOFF, false)
			Config.Harass:addParam("UseE", "UseE", SCRIPT_PARAM_ONOFF, false)

		Config:addSubMenu("Clear", "Clear")
			Config.Clear:addParam("UseQ", "UseQ", SCRIPT_PARAM_ONOFF, true)
			--Config.Clear:addParam("UseW", "UseW", SCRIPT_PARAM_ONOFF, false)
			Config.Clear:addParam("UseE", "UseE", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("KillSteal", "KillSteal")
			Config.KillSteal:addParam("Enable", "Enable", SCRIPT_PARAM_ONOFF, true)
			Config.KillSteal:addParam("UseQ", "UseQ", SCRIPT_PARAM_ONOFF, true)

		if Ignite ~= nil then
			Config:addSubMenu("Summoner", "Summoner")
				Config.Summoner:addParam("Ignite", "Ignite", SCRIPT_PARAM_ONOFF, true)
		end

		Config:addSubMenu("Evade", "Evade")
			Config.Evade:addParam("Evade", "Evade With Evadeee", SCRIPT_PARAM_ONOFF, true)
			for i, enemy in pairs(enemyHeroes) do
				if EvadingSpell[enemy] ~= nil then
					Config.Evade:addParam(EvadingSpell[enemy][0], "Evade "..EvadingSpell[enemy][0], SCRIPT_PARAM_ONOFF, true)
				end
			end


		Config:addSubMenu("QSetting", "QSetting")
			Config.QSetting:addParam("Packet", "Packet Cast Only VIP", SCRIPT_PARAM_ONOFF, true)
			--Config.QSetting:addParam("Magnet", "Magnet", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("WSetting", "WSetting")
			Config.WSetting:addParam("Cansle", "Attack Cansle", SCRIPT_PARAM_ONOFF, true)
			Config.WSetting:addParam("Packet", "Packet Cast Only VIP", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("ESetting", "ESetting")
			Config.ESetting:addParam("Packet", "Packet Cast Only VIP", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("RSetting", "RSetting")
			Config.RSetting:addParam("Packet", "Packet Cast Only VIP", SCRIPT_PARAM_ONOFF, true)


		Config:addSubMenu("Draw", "Draw")
			Config.Draw:addParam("DrawQ", "Draw Q Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawQColor", "Draw Q Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("DrawW", "Draw W Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawWColor", "Draw W Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("DrawE", "Draw E Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawEColor", "Draw E Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("DrawR", "Draw R Rance", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("DrawRColor", "Draw R Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
			Config.Draw:addParam("INFO1", "", SCRIPT_PARAM_INFO, "")
			Config.Draw:addParam("KillMark", "KillMark", SCRIPT_PARAM_ONOFF, true)
			Config.Draw:addParam("TargetMark", "TargetMark", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("OrbWalker", "Orbwalker")
			if MMALoaded then
				Config.Orbwalker:addParam("INFO", "MMA Load", SCRIPT_PARAM_INFO, "")
			elseif SACLoaded then
				Config.Orbwalker:addParam("INFO", "Reborn Load", SCRIPT_PARAM_INFO, "")
			elseif SxOLoaded then
				SxO:LoadToMenu(Config.Orbwalker)
				Config.Orbwalker:addParam("INFO", "", SCRIPT_PARAM_INFO, "")
				Config.Orbwalker:addParam("INFO2", "SxOrbWalk Setting", SCRIPT_PARAM_INFO, "")
			elseif SOWLoaded then
				SOW:LoadToMenu(Config.Orbwalker)
				Config.Orbwalker:addParam("INFO", "", SCRIPT_PARAM_INFO, "")
				Config.Orbwalker:addParam("INFO2", "SOW Setting", SCRIPT_PARAM_INFO, "")
			end

		Config:addParam("INFO", "", SCRIPT_PARAM_INFO, "")
		Config:addParam("Version", "Version", SCRIPT_PARAM_INFO, version)
		Config:addParam("Author", "Author", SCRIPT_PARAM_INFO, Author)
end

function OnTick(  )
	if player.dead then return end

	DamageCalculation()
	if Config.Hotkey.Combo then OnCombo() end
	if Config.Hotkey.Harass then OnHarass() end
	if Config.Hotkey.Clear then OnClear() end
	if Config.KillSteal.Enable then KillSteal() end
	if Config.Evade.Evade then Evade() end
end

function OnDraw(  )
	if player.dead then return end
	if Q.IsReady() and Config.Draw.DrawQ then
		DrawCircle(player.x, player.y, player.z, Q.Range, TARGB(Config.Draw.DrawQColor))
	end

	if W.IsReady() and Config.Draw.DrawW then
		DrawCircle(player.x, player.y, player.z, W.Range, TARGB(Config.Draw.DrawWColor))
	end

	if E.IsReady() and Config.Draw.DrawE then
		DrawCircle(player.x, player.y, player.z, E.Range, TARGB(Config.Draw.DrawEColor))
	end

	if R.IsReady() and Config.Draw.DrawR then
		DrawCircle(player.x, player.y, player.z, R.Range, TARGB(Config.Draw.DrawRColor))
	end

	if Config.Draw.KillMark then
		for i, enemy in pairs(enemyHeroes) do
			if ValidTarget(enemy) and enemy ~= nil then
				local barPos = GetHPBarPos(enemy)
				DrawText(KillTextList[KillText[i]], 18, barPos.x, barPos.y-60, KillTextColor)
			end
		end
	end

	if Config.Draw.TargetMark then
		if OrbTarget(Q.Range) then
			local Target = OrbTarget(Q.Range)
			DrawCircle(Target.x, Target.y, Target.z, (GetDistance(Target.minBBox, Target.maxBBox)/2), ARGB(100,76,255,76))
		end
	end
end

function OnCombo()
	local target = OrbTarget(Q.Range)
	if ValidTarget(target) then
		if Config.Combo.UseQ and GetDistance(target, player) >= W.Range  then CastQ(target) end
		if Config.Combo.UseE then CastE(target) end
		if Config.Combo.UseR then CastR(target) end
	end
end


function OnHarass()
	local target = OrbTarget(Q.Range)
	if ValidTarget(target) then
		if Config.Harass.UseQ then CastQ(target) end
		if Config.Harass.UseE then CastE(target) end
	end
end

function OnClear(  )
	Setting()
	local Mob = GetJungleMob(Q.Range)
	if Mob ~= nil then
		if Config.Clear.UseQ then CastQ(Mob) end
		if Config.Clear.UseE then CastE(Mob) end
	else
		enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if ValidTarget(minion) and not minion.dead then
				if Config.Clear.UseQ then CastQ(minion) end
				if Config.Clear.UseE then CastE(minion) end
			end
		end
	end
end

function KillSteal(  )
	for _, enemy in pairs(enemyHeroes) do
		if enemy ~= nil and ValidTarget(enemy) then
		local distance = GetDistance(enemy, player)
		local hp = enemy.health
			if hp <= qDmg and Q.IsReady() and (distance <= Q.Range)
				then CastQ(enemy)
			elseif hp <= wDmg and W.IsReady() and (distance <= W.Range)
				then CastW(enemy)
			elseif hp <= eDmg and E.IsReady() and (distance <= E.Range)
				then CastE(enemy)
			elseif hp <= (qDmg + wDmg) and Q.IsReady() and W.IsReady() and (distance <= Q.Range)
				then CastW(enemy)
			elseif hp <= (qDmg + eDmg) and Q.IsReady() and E.IsReady() and (distance <= Q.Range)
				then CastE(enemy)
			elseif hp <= (wDmg + eDmg) and W.IsReady() and E.IsReady() and (distance <= W.Range)
				then CastE(enemy)
			elseif hp <= (qDmg + wDmg + eDmg) and Q.IsReady() and W.IsReady() and E.IsReady() and (distance <= Q.Range)
				then CastE(enemy)
			end
		end
	end
end

function Evade()
	if _G.Evadeee_impossibleToEvade then
		local T = OrbTarget(Q.Range)
		if T ~= nil then
			EvadeQ(T)
		end
	end
end

---------------------------------------------------------------------
--- Cast Functions for Spells ---------------------------------------
---------------------------------------------------------------------

function CastQ( target )
	if target.dead then return end
	if not OrbwalkCanMove() then return end
	if GetDistance(target, player) <= Q.Range and target ~= nil then
		if VIP_USER then
			if Config.QSetting.Packet then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = target.networkID}):send()
			else
				CastSpell(_Q, target)
			end
		else
			CastSpell(_Q, target)
		end
	end
end

function EvadeQ()
	local c = nil
	if Config.Hotkey.Combo or Config.Hotkey.Harass then
		c = OrbTarget(Q.Range)
	end
	if c == nil then
		enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if c == nil then
				c = minion
			else
				if GetDistance(c, player) > GetDistance(minion, player) then
					c = minion
				end
			end
		end
	end
	if c == nil then
		local c = GetJungleMob(Q.Range)
	end
	if c == nil then
		c = OrbTarget(Q.Range)
	end
	if c ~= nil and Q.IsReady() then
		CastQ(c)
	end
end

function CastW( target )
	if target.dead then return end
	if not OrbwalkCanMove() then return end
	if GetDistance(target, player) <= W.Range and target ~= nil then
		if VIP_USER then
			if Config.QSetting.Packet then
				Packet("S_CAST", {spellId = _W}):send()
				if Config.WSetting.Cansle then
					OrbReset()
				end
			else
				CastSpell(_W, target)
				if Config.WSetting.Cansle then
					OrbReset()
				end
			end
		else
			CastSpell(_W, target)
			if Config.WSetting.Cansle then
				OrbReset()
			end
		end
	end
end

function CastE( target )
	if target.dead then return end
	if not OrbwalkCanMove() then return end
	if GetDistance(target, player) <= E.Range and target ~= nil then
		if VIP_USER then
			if Config.QSetting.Packet then
				Packet("S_CAST", {spellId = _E}):send()
			else
				CastSpell(_E, target)
			end
		else
			CastSpell(_E, target)
		end
	end
end

function CastR( target )
	if target.dead then return end
	if not OrbwalkCanMove() then return end
	if GetDistance(target, player) <= R.Range and target ~= nil then
		if VIP_USER then
			if Config.QSetting.Packet then
				Packet("S_CAST", {spellId = _R}):send()
			else
				CastSpell(_R, target)
			end
		else
			CastSpell(_R, target)
		end
	end
end

function ItemCansle(  )

end


---------------------------------------------------------------------
--- Athor Functions -------------------------------------------------
---------------------------------------------------------------------

function GetSummonerSlot(name, unit)
    unit = unit or player
    if unit:GetSpellData(SUMMONER_1).name == name then return SUMMONER_1 end
    if unit:GetSpellData(SUMMONER_2).name == name then return SUMMONER_2 end
    return nil
end


---------------------------------------------------------------------
--- Function Damage Calculations for Skills/Items/Enemys ---
---------------------------------------------------------------------

function DamageCalculation()
	for i, enemy in pairs(enemyHeroes) do
		if ValidTarget(enemy) and enemy ~= nil then
			aaDmg 		= getDmg("AD", enemy, myHero)
			qDmg 		= ((getDmg("Q", enemy, myHero)) or 0)
			wDmg		= ((getDmg("W", enemy, myHero)) or 0)
			eDmg		= ((getDmg("E", enemy, myHero)) or 0)
			--iDmg 		= ((Ignite and getDmg("IGNITE", enemy, myHero)) or 0)	-- Ignite
			local abilityDmg = qDmg + wDmg + eDmg
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
			elseif enemy.health <= wDmg then
				if W.IsReady() then KillText[i] = 5
					else KillText[i] = 2
				end
			-- "Kill! - (E)" --
			elseif enemy.health <= eDmg then
				if E.IsReady() then KillText[i] = 6
					else KillText[i] = 2
				end
			-- "Kill! - (Q)+(W)" --
			elseif enemy.health <= qDmg+wDmg then
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
			elseif enemy.health <= qDmg+wDmg+eDmg then
				if Q.IsReady() and W.IsReady() and E.IsReady() then KillText[i] = 10
					else KillText[i] = 2
				end
			-- "Harass your enemy!" --
			else KillText[i] = 1
			end
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

--[[
function OnCreateObj(obj)
	if GetDistance(obj, player) < 300 then
		if obj.name == "Counterstrike_cas.troy" then
			local target = OrbTarget(Q.Range)
			if target ~= nil then
				EvadeQ(target)
			end
		end
	end
end
]]
function OnProcessSpell(unit, spell)
	--[[if GetDistance(unit, player) < Q.Range then
		if spell.name == "BlindingDart" and spell.target.isMe then
			local target = OrbTarget(Q.Range)
			if target ~= nil then
				EvadeQ(target)
			end
		end
	end]]
	if unit.isMe then
		if spell.name:lower():find("attack") then
			local target = OrbTarget(Q.Range)
			if Config.Hotkey.Combo and Config.Combo.UseW then
				CastW(target)
			end
			if Config.Hotkey.Harass and Config.Harass.UseW then
				CastW(target)
			end
		end
	end
end
