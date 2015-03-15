
local version = 1.00
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your ADC Series.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Your ADC Series.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your ADC Series:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/verion/Your ADC Series.version")
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

local champions = {
	["Graves"]		= true,
	--["Lucian"]		= true,
	--["MissFortune"]	= true,
	--["Vayne"]		= true,
	--["Sivir"]		= true,
	--["Ashe"]		= true,
	["Urgot"]		= true,
	["Ezreal"]		= true,
	--["Jinx"]		= true,
	--["Kalista"]		= true,
	--["Caitlyn"]		= true,
	--["KogMaw"]		= true,
	["Corki"]		= true,
	--["Tristana"]	= true,
	--["Twitch"]		= true,
}

for k, _ in pairs(champions) do
    local className = k:gsub("%s+", "")
    class(className)
    champions[k] = _G[className]
end

if not champions[myHero.charName] then return end

require 'Sourcelib'
require "VPrediction"
	

local champ = champions[myHero.charName]
local HPred, SxO, STS = nil, nil, nil
local ts
local Config = nil
local player = myHero
local enemyHeroes = GetEnemyHeroes()
local EnemyMinions = minionManager(MINION_ENEMY, 1500, player, MINION_SORT_MAXHEALTH_DEC)
local JungleMinions = minionManager(MINION_JUNGLE, 1500, player, MINION_SORT_MAXHEALTH_DEC)
local champLoaded = false
local MMALoad, RebornLoad, SxOLoad, RevampedLoaded = false, false, false, false


local cansleingspell = {
	["Thresh"] = {"ThreshE"}
}


local gapcloserspell = {
	["Thresh"] = {"threshqleap", "ThreshE"}
}

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
	champ = champ()
	
	if not champ then AutoupdaterMsg("There was an error while loading " .. player.charName .. ", please report the shown error to Yours, thanks!") return else champLoaded = true end
	
	AutoupdaterMsg(player.charName.." Load")
	OnOrbLoad()
	VP = VPrediction()
	
	LoadMenu()
	
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

	JungleMobs = {}
	JungleFocusMobs = {}

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

function OnTick()
	if not champLoaded then return end

	OnSpellcheck()
	if champ.OnTick then
        champ:OnTick()
    end
	
	
	
	
	if champ.OnCombo and Config.combo.active then
        champ:OnCombo()
    elseif champ.OnHarass and Config.harass.active then
        champ:OnHarass()
	elseif champ.LineClear and Config.lc.active then
		champ:LineClear()
	elseif champ.OnFarm and Config.fm.active then
		champ:OnFarm()
    end
end

function OnDraw()
	if champ.OnDraw then
		champ.OnDraw()
	end
end

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

local function OrbTarget(rance)
	local T
	if MMALoad then T = _G.MMA_Target end
	if RebornLoad then T = _G.AutoCarry.Crosshair.Attack_Crosshair.target end
	if RevampedLoaded then T = _G.AutoCarry.Orbwalker.target end
	if SxOLoad then T = SxO:GetTarget() end
	if T and T.type == player.type and ValidTarget(T, rance) then return T end
end

function LoadMenu()
	Config = MenuWrapper("[Your Series] " .. player.charName, "unique" .. player.charName:gsub("%s+", ""))
		
		if SxOLoad then
			Config:SetOrbwalker(SxO)
		end
	
		Config = Config:GetHandle()
	
		if champ.OnCombo then
			Config:addSubMenu("Combo", "combo")
				Config.combo:addParam("active", "Combo Active", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		end
		
		if champ.OnHarass then
			Config:addSubMenu("Harass", "harass")
				Config.harass:addParam("active", "Harass Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		end
		
		if champ.LineClear then
			Config:addSubMenu("Line Clear", "lc")
				Config.lc:addParam("active", "Line Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		end
		
		if champ.OnDraw then
			Config:addSubMenu("Draw", "draw")
		end
		
		if champ.OnFarm then
			Config:addSubMenu("farming","fm")
				Config.fm:addParam("active", "Farming", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		end
		
		
		
		if champ.ApplyMenu then champ:ApplyMenu() end
		
		
end

function buffcheck(target)
	if player.charName == "Urgot" then
		return TargetHaveBuff("urgotcorrosivedebuff", target)
	end
end

function OnSpellcheck()
	if player:CanUseSpell(_Q) == READY then
		Qready = true
	else
		Qready = false
	end
	
	if player:CanUseSpell(_W) == READY then
		Wready = true
	else
		Wready = false
	end
	
	if player:CanUseSpell(_E) == READY then
		Eready = true
	else
		Eready = false
	end
	
	if player:CanUseSpell(_R) == READY then
		Rready = true
	else
		Rready = false
	end
end


--[[function OnProcessSpell(unit, spell)
	if #ToInterrupt > 0 then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= player.team and GetDistance(unit) < 1100 then
				if cansleingspell[player.charName][i] ~= nil then 
					CastSpell(cansleingspell[player.charName][1], unit.x, unit.z)
				end
			end
		end
	end
	if unit.type == player.type and unit.team ~= player.team and spell then
		if gapcloserspell[unit.charName] ~= nil then
			for i=1, #gapcloserspell[unit.charName] do
				if spell.name == gapcloserspell[unit.charName][i] then
					anitGapcloser(Vector(spell.endPos), unit, spell.name)
				end
			end
		end
	end
end

function anitGapcloser(endPos, unit, name)
	if GetDistance(endPos, player) < 100 then
		if player:GetSpellData(_Q).name == name then CastSpell(_Q, unit)
		elseif player:GetSpellData(_W).name == name then CastSpell(_W, unit)
		elseif player:GetSpellData(_E).name == name then CastSpell(_E, unit)
		elseif player:GetSpellData(_R).name == name then CastSpell(_R, unit)
		end
	end
end]]

function GetJungleMob(rance)
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, rance) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, rance) then return Mob end
	end
end

function GetBestLineFarmPosition(range, width, objects)
	local BestPos 
	local BestHit = 0
	for i, object in ipairs(objects) do
		local EndPos = Vector(player.visionPos) + range * (Vector(object) - Vector(player.visionPos)):normalized()
		local hit = CountObjectsOnLineSegment(player.visionPos, EndPos, width, objects)
		if hit > BestHit then
			BestHit = hit
			BestPos = Vector(object)
			if BestHit == #objects then
			   break
			end
		 end
	end

	return BestPos, BestHit
end


---------------------------------------------------------
------------------------Graves
---------------------------------------------------------

function Graves:__init()
	local Qrance = 900
	local Wrance = 1100
	local Erance = 425
	local Rrance = 600
end

 function Graves:OnCombo()
	local Target = OrbTarget(1100)
	if Target ~= nil then
		if Config.combo.useq then
			local CastPosition, HitChance, Hit = VP:GetConeAOECastPosition(Target, 0.25, 25 * math.pi/180, 900, 2000, player)		
			if HitChance >= 2 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if Config.combo.usew then
			local CastPosition, TargetHitChance, Targets = VP:GetCircularAOECastPosition(Target, 0.25, 250, 1100, 1650, player)
			if TargetHitChance >= 2 then
				CastSpell(_W, CastPosition.x, CastPosition.z)
			end
		end
	end
 end
 
 function Graves:OnHarass()
	local Target = OrbTarget(1100)
	if Target ~= nil then
		if Config.harass.useq and player.mana > (player.maxMana*(Config.harass.perq*0.01)) then
			local CastPosition, HitChance, Hit = VP:GetConeAOECastPosition(Target, 0.25, 25 * math.pi/180, 900, 2000, player)		
			if HitChance >= 2 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
 end
 
function Graves:OnTick()
	local i, t
	for i, t in pairs(enemyHeroes) do
		if ValidTarget(t) and Config.ks.user and GetDistance(t, player) < 1000 and getDmg("R", t, player) > t.health then
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(t, 0.25, 100, 1100, 2100, player)
			if MainTargetHitChance >= 2 then
				CastSpell(_R, AOECastPosition.x, AOECastPosition.z) 
			end
		end
	end
 end
 
 function Graves:OnDraw()
	if Config.draw.drawq then
		DrawCircle(player.x, player.y, player.z, 900, TARGB(Config.draw.drawqcolor))
	end
	if Config.draw.drawr then
		DrawCircle(player.x, player.y, player.z, 1000, TARGB(Config.draw.drawrcolor))
	end
	if Config.draw.draww then
		DrawCircle(player.x, player.y, player.z, 1100, TARGB(Config.draw.drawwcolor))
	end
 end
 
 function Graves:LineClear()
	JungleMinions:update()
	for i, minion in pairs(JungleMinions.objects) do
		if minion ~= nil and not minion.dead and GetDistance(minion) < 900 and Config.lc.useq and player.mana > (player.maxMana*(Config.lc.perq*0.01)) then
			local bestpos, besthit = GetBestLineFarmPosition(900, 1000, JungleMinions.objects)
			if bestpos ~= nil then
				CastSpell(_Q, bestpos.x, bestpos.z)
			end
		end
	end
	EnemyMinions:update()
	for i, minion in pairs(EnemyMinions.objects) do
		if minion ~= nil and not minion.dead and GetDistance(minion) < 900 and Config.lc.useq and player.mana > (player.maxMana*(Config.lc.perq*0.01)) then
			local bestpos, besthit = GetBestLineFarmPosition(900, 1000, EnemyMinions.objects)
			if bestpos ~= nil then
				CastSpell(_Q, bestpos.x, bestpos.z)
			end
		end
	end
end

 function Graves:ApplyMenu()
		Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
		
		Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		Config.lc:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.lc:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		Config.draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawqcolor", "Draw Q Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		Config.draw:addParam("draww", "Draw W", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawwcolor", "Draw W Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		Config.draw:addParam("drawr", "Draw R", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawrcolor", "Draw R Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		
	Config:addSubMenu("KillSteal", "ks")
		Config.ks:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
 end
 
---------------------------------------------------------
------------------------Corki
---------------------------------------------------------

function Corki:__init()
	
 end
 
 function Corki:OnCombo()
	local Target = OrbTarget(1300)
	if Target ~= nil then
		if GetDistance(Target, player) < 825 and Qready and Config.combo.useq then
			local CastPosition, TargetHitChance, Targets = VP:GetCircularAOECastPosition(Target, 0.5, 450, 825, 1125, player)
			if TargetHitChance >= 2 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if GetDistance(Target, player) < 600 and Eready and Config.combo.usee then
			CastSpell(_E, Target)
		end
		if GetDistance(Target, player) < 1225 and Rready and Config.combo.user then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 75, 1225, 2000, player, true)
			if HitChance >= 2 then
				CastSpell(_R, CastPosition.x, CastPosition.z)
			end
		end
	end
 end
 
 function Corki:OnHarass()
	local Target = OrbTarget(1300)
	if Target ~= nil then
		if GetDistance(Target, player) < 825 and Qready and Config.harass.useq and player.mana > (player.maxMana*(Config.harass.perq*0.01)) then
			local CastPosition, TargetHitChance, Targets = VP:GetCircularAOECastPosition(Target, 0.5, 450, 825, 1125, player)
			if TargetHitChance >= 2 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if GetDistance(Target, player) < 1225 and Rready and Config.harass.user and player.mana > (player.maxMana*(Config.harass.perr*0.01)) then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 75, 1225, 2000, player, true)
			if HitChance >= 2 then
				CastSpell(_R, CastPosition.x, CastPosition.z)
			end
		end
	end
 end
 
function Corki:OnTick()
end

 function Corki:LineClear()
	JungleMinions:update()
	for i, minion in pairs(JungleMinions.objects) do
		if minion ~= nil and not minion.dead and GetDistance(minion) < 900 and Config.lc.useq and player.mana > (player.maxMana*(Config.lc.perq*0.01)) then
			local bestpos, besthit = GetBestLineFarmPosition(825, 450, JungleMinions.objects)
			if bestpos ~= nil then
				CastSpell(_Q, bestpos.x, bestpos.z)
			end
		end
	end
	EnemyMinions:update()
	for i, minion in pairs(EnemyMinions.objects) do
		if minion ~= nil and not minion.dead and GetDistance(minion) < 900 and Config.lc.useq and player.mana > (player.maxMana*(Config.lc.perq*0.01)) then
			local bestpos, besthit = GetBestLineFarmPosition(825, 450, EnemyMinions.objects)
			if bestpos ~= nil then
				CastSpell(_Q, bestpos.x, bestpos.z)
			end
		end
	end
end

 function Corki:OnDraw()
	if Config.draw.drawq then
		DrawCircle(player.x, player.y, player.z, 825, TARGB(Config.draw.drawqcolor))
	end
	if Config.draw.drawr then
		DrawCircle(player.x, player.y, player.z, 1250, TARGB(Config.draw.drawrcolor))
	end
 end
 
 function Corki:ApplyMenu()
		Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
		
		Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		Config.harass:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("perr", "Until % R", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		Config.lc:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.lc:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	
		Config.draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawqcolor", "Draw Q Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		Config.draw:addParam("drawr", "Draw R", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawrcolor", "Draw R Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})	
		
	Config:addSubMenu("KillSteal", "ks")
		Config.ks:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
		
 end
 
function Urgot:__init()
 end
 
 function Urgot:OnCombo()
	local Target = OrbTarget(1200)
		if Config.combo.usee and Eready then
			local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(Target, 0.8, 200, 900)
			if HitChance >= 2 and GetDistance(CastPosition) < 900 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
		
		if Target ~= nil then
			if Config.combo.useq and Qready and GetDistance(Target) < 1200 then
				if Config.combo.usew and Wready and GetDistance(Target, player) < 1200 then
					CastSpell(_W)
				end
				if buffcheck(Target) then
					local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, 0.5, 75, 1200)
					if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1200 and Target.dead == false then
							CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				else
					local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.5, 75, 1100, 1500, player, true)
					if HitChance >= 2 and GetDistance(CastPosition) < 1100 then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
 end
 
 function Urgot:OnHarass()
	if player.mana > (player.maxMana*(Config.harass.perq*0.01)) then
		local Target = OrbTarget(1200)
		if Config.harass.usee and Eready and Target ~= nil then
			local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(Target, 0.8, 200, 900)
			if HitChance >= 2 and GetDistance(CastPosition) < 900 then
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
	
		if Target ~= nil and Config.harass.useq then
			if buffcheck(Target) then
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(Target, 0.5, 75, 1200)
				if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1200 and Target.dead == false then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			else
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.5, 75, 1100, 1500, player, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1100 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
 end
 
 function Urgot:OnTick()
 end
 
function Urgot:LineClear()
	
	if Config.lc.active and player.mana > (player.maxMana*(Config.lc.perq*0.01)) then
		JungleMinions:update()
		for i, minion in ipairs(JungleMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= 1200 and Qready and Config.lc.useq then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.5, 75, 1200, 1500, player, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
		EnemyMinions:update()
		for i, minion in ipairs(EnemyMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= 1200 and Qready and Config.lc.useq then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.5, 75, 1200, 1500, player, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function Ezreal:OnFarm()
	EnemyMinions:update()
	for i, minion in ipairs(EnemyMinions.objects) do
		if ValidTarget(minion) and GetDistance(minion) <= 1200 and Qready and getDmg("Q", minion, player) > minion.health and Config.fm.useq then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.5, 75, 1200, 1500, player, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end
 
 function Urgot:OnDraw()
	if Config.draw.drawq then
		DrawCircle(player.x, player.y, player.z, 1100, TARGB(Config.draw.drawqcolor))
	end
	if Config.draw.drawe then
		DrawCircle(player.x, player.y, player.z, 900, TARGB(Config.draw.drawecolor))
	end
 end
 
 function Urgot:ApplyMenu()
		Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
		
		Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("perq", "Until % Harass", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		Config.draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawqcolor", "Draw Q Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		Config.draw:addParam("drawe", "Draw E", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawecolor", "Draw E Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		
		Config.lc:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.lc:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		Config.fm:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
 end
 
--[[function jinx:__init()
end
 
function jinx:OnCombo()
	local Target = OrbTarget(1200)
end
 
function jinx:OnHarass()
end
 
function jinx:OnTick()
end
 
function jinx:ApplyMenu()

		Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
		
		Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("perq", "Until % Harass", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		Config.draw:addParam("draww", "Draw W", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawwcolor", "Draw W Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		Config.draw:addParam("drawe", "Draw E", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawecolor", "Draw E Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		
		Config.lc:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.lc:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
end]]
 
function Ezreal:__init()
end

function Ezreal:OnCombo()
	local Target = OrbTarget(1200)
	if Target ~= nil then
		if Config.combo.useq and Qready then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 50, 1150, 2025, player, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if Config.combo.usew and Wready then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 50, 1150, 2025, player, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
				CastSpell(_W, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function Ezreal:OnHarass()
	local Target = OrbTarget(1200)
	if Target ~= nil then
		if Config.harass.useq and Qready and player.mana > (player.maxMana*(Config.harass.perq*0.01)) then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 50, 1150, 2025, player, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 1200 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end


function Ezreal:LineClear()
	if Config.lc.active and player.mana > (player.maxMana*(Config.lc.perq*0.01)) then
		JungleMinions:update()
		for i, minion in ipairs(JungleMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= 1150 and Qready and Config.lc.useq then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.25, 50, 1150, 2025, player, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1150 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
		EnemyMinions:update()
		for i, minion in ipairs(EnemyMinions.objects) do
			if ValidTarget(minion) and GetDistance(minion) <= 1150 and Qready and Config.lc.useq then
				local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.25, 50, 1150, 2025, player, true)
				if HitChance >= 2 and GetDistance(CastPosition) < 1150 then
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function Ezreal:OnDraw()
	if Config.draw.drawq then
		DrawCircle(player.x, player.y, player.z, 1150, TARGB(Config.draw.drawqcolor))
	end
	if Config.draw.draww then
		DrawCircle(player.x, player.y, player.z, 1000, TARGB(Config.draw.drawqcolor))
	end
end

function Ezreal:OnTick()
	local i, t
	for i, t in pairs(enemyHeroes) do
		if ValidTarget(t) and Config.ks.useq and GetDistance(t, player) < 1150 and getDmg("Q", t, player) > t.health then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(t, 0.25, 50, 1150, 2025, player, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 1150 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
		if ValidTarget(t) and Config.ks.useq and GetDistance(t, player) < Config.ks.perr and getDmg("R", t, player) > t.health and GetDistance(t, player) > 100 then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(t, 0.98, 120, Config.ks.perr, 2000, player, true)
			if HitChance >= 2 then
				CastSpell(_R, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function Ezreal:OnFarm()
	EnemyMinions:update()
	for i, minion in ipairs(EnemyMinions.objects) do
		if ValidTarget(minion) and GetDistance(minion) <= 1150 and Qready and getDmg("Q", minion, player) > minion.health and Config.fm.useq then
			local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.25, 50, 1150, 2025, player, true)
			if HitChance >= 2 and GetDistance(CastPosition) < 1150 then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function Ezreal:ApplyMenu()
		Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
		
		Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("perq", "Until % Harass", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
		Config.draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawqcolor", "Draw Q Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		Config.draw:addParam("draww", "Draw W", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawwcolor", "Draw W Color", SCRIPT_PARAM_COLOR, {100, 255, 0, 0})
		
		Config.lc:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.lc:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		
	Config:addSubMenu("KillSteal", "ks")
		Config.ks:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("perr", "Until % Harass", SCRIPT_PARAM_SLICE, 1000, 1000, 5000, 0)
		
		Config.fm:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
end
 
--[[function Karthus:__init()
end

function Karthus:OnCombo()
end

function Karthus:OnHarass()
end

function Karthus:OnTick()
end

function Karthus:ApplyMenu()
end]]
 