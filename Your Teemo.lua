


if myHero.charName ~="Teemo" then return end
 -- bol script status
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("VILJLIPLIQH") 


require "SourceLib"

local flash = nil
local ignite = nil
local ts
local SOWLoaded, SxOLoaded, MMALoaded, RebornLoaded, RevampedLoaded = false, false, false, false, false
local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local version = 1.00
local Player = myHero
local EnemyHeroes = GetEnemyHeroes()
local SxO = nil
-- rance

local AUTO_UPDATE = false
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Teemo.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Your Teemo.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Teemo:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/version/Your Teemo.version")
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

local MyminBBox = GetDistance(myHero.minBBox)/2
local AArance = myHero.range+MyminBBox
local Qrance= 680
local enemyMinions = minionManager(MINION_ENEMY, Qrance, myHero, MINION_SORT_MAXHEALTH_DEC)

local bestshroom =
 {
	{x = 10406, y = 50.08506, z = 3050},
	{x = 10202, y = -71.2406, z = 4884},
	{x = 11222, y = -2.569444, z = 5592},
	{x = 10032, y = 49.70721, z = 6610},
	{x = 8580, y = -50.36785, z = 5560},
	{x = 11960, y = 52.09994, z = 7400},
	{x = 4804, y = 40.283, z = 8334},
	{x = 6264, y = -62.41959, z = 9332},
	{x = 4724, y = -71.2406, z = 10024},
	{x = 3636, y = -8.188844, z = 9348},
	{x = 4425, y = 56.8484, z = 11810},
	{x = 2848, y = 51.84816, z = 7362}
 }
local middleshroom = {}
local rawshroom = {}
 
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
		DelayAction(OrbLoad, 1)
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		require 'SxOrbWalk'
		SxO = SxOrbWalk()
		SxOLoaded = true
		AutoupdaterMsg("Loaded SxO")
	elseif FileExist(LIB_PATH .. "SOW.lua") then
		require 'SOW'
		SOWi = SOW(VP)
		Menu:addParam("info0", "", SCRIPT_PARAM_INFO, "")
		Menu:addParam("info1", "SOW settings", SCRIPT_PARAM_INFO, "")
		SOWLoaded = true
		AutoupdaterMsg("Loaded SOW")
	else
		AutoupdaterMsg("Using AllClass TS")
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

local function OrbReset()
	if MMALoaded then
		_G.MMA_ResetAutoAttack()
	elseif SxOrbLoaded then
		SxOrb:ResetAA()
	elseif SOWLoaded then
		SOW:resetAA()
	end
end

function OnLoad()
	OrbLoad()
	
	SxO = SxOrbWalk()
    STS = SimpleTS()
	
	OnLoadMenu()
end

function OnLoadMenu()
	Config = scriptConfig("yours Teemo", "yoursTeemo")
		Config:addSubMenu("combo","combo")
			Config.combo:addParam("combohotkey","Combo Hot Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Config.combo:addParam("castq", "Cast Q", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("castw", "Cast W", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("castr", "Cast R", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("userminion", "Use R Minion", SCRIPT_PARAM_ONOFF, true)
	
		Config:addSubMenu("killsteal", "killsteal")
			Config.killsteal:addParam("killstealQ", "killsteal Auto Q", SCRIPT_PARAM_ONOFF, true)
			Config.killsteal:addParam("flashQkilsteal","killsteal Auto flash Q", SCRIPT_PARAM_ONOFF, false)
		
		Config:addSubMenu("harass", "harass")
			Config.harass:addParam("harassQ","harass", SCRIPT_PARAM_ONOFF, true)
			
		Config:addSubMenu("ADS", "ADS")
			Config.ADS:addParam("AutoR", "Auto R around best locate", SCRIPT_PARAM_ONOFF, true)
		
		Config:addSubMenu("draw", "draw")
			Config.draw:addParam("aadraw", "Draw AA rance", SCRIPT_PARAM_ONOFF, true)
			Config.draw:addParam("qdraw", "Draw Q rance", SCRIPT_PARAM_ONOFF, true)
			Config.draw:addParam("bshroom", "Best shroom Draw", SCRIPT_PARAM_ONOFF, true)
			Config.draw:addParam("targetdraw", "Target Draw", SCRIPT_PARAM_ONOFF, false)
			
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
end

function OnTick()

	if myHero.dead then return end
	
	killsteal()
	
	COMBO()
	OnDraw()
	harass()
	AutoShroom()
	OnSpellcheck()
end

function harass()
	local Target = OrbTarget(Qrance)
	if Config.harass.harassQ then
		if Target ~= nil and GetDistance(Target, Player) <= Qrance and Qready then
			CastSpell(_Q, Target)
		end
	end
end

function COMBO()
	if (Config.combo.combohotkey) then
		local Target = OrbTarget(Qrance)
		if Wready then
			if Config.combo.castw then
					CastSpell(_W)
				end
			end
		if (Target ~= nil) then
			if Config.combo.castq then
				if Qready then
					CastSpell(_Q, Target)
					OrbReset()
				end
			end
			if Config.combo.castr then
				if Rready then
					CastR(Target)
				end
			end
		end
	end
end

function CastR(T)
	if GetDistance(player, T) < 240 and Rready then
		CastSpell(_R, T.x, T.z)
	elseif GetDistance(player, T) < 600 and Rready then
		if Config.combo.userminion then
			for _, minion in pairs(enemyMinions.objects) do
				if GetDistance(player, minion) <= 240 and GetDistance(minion, T) >= 400 then
					CastSpell(_R, minion.x, minion.z)
				end
			end
		end
	end
end

function OnDraw()
	if Config.draw.aadraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, AArance, 0xFFFFCC)
	end
    if Config.draw.qdraw then
        DrawCircle(myHero.x, myHero.y, myHero.z, Qrance, 0xFFFF0000)
    end
	if Config.draw.targetdraw then
		local Target = OrbTarget(Qrance)
		if Target ~= nil then
			DrawCircle(Target.x,Target.y, Target.z, 100, 0xFFFFFFff)
		end
	end
	if Config.draw.bshroom then
		for _, v in ipairs(bestshroom) do
			DrawCircle(v.x, v.y, v.z, 100, 0x33FFFF)
		end
	end
end

function AutoShroom()
	if Config.ADS.AutoR then
		for _, v in ipairs(bestshroom) do
			if GetDistance(player, v) < 240 and Qready then
				for i = 1, objManager.maxObjects, 1 do
					local obj = objManager:GetObject(i)
					if obj ~= nil and obj.valid and obj.team == myHero.team and (obj.name:lower():find("mushroom") then 
						if GetDistance(v, obj) < 50 then
							return
						end
					else
						CastSpell(_R, v.x, v.z);
					end
				end
			end		
		end
	end
end

function GetSummoners()
	if string.lower(myHero:GetSpellData(SUMMONER_1).name) == "summonerflash" then
		flash = SUMMONER_1
	elseif string.lower(myHero:GetSpellData(SUMMONER_2).name) == "summonerflash" then
		flash = SUMMONER_2
	else
		flash = nil
	end
end

function killsteal()
	local i, Champion
	for i, Champion in pairs(EnemyHeroes) do
		if ValidTarget(Champion) then
			if GetDistance(Champion, Player) <= Qrance and myHero:CanUseSpell(_Q) == READY and getDmg("Q", Champion, Player) > Champion.health and Config.killsteal.killstealQ then
				CastSpell(_Q, Champion)
			end
			if Config.killsteal.flashQkilsteal then
				if GetDistance (Champion, Player) <= Qrance and myHero:CanUseSpell(_Q) == READY and getDmg("Q", Champion, Player) > Champion.health then
					GetSummoners()
					CastSpell(flash, Champion.x, Champion.z)
					CastSpell(_Q, Champion)
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

function OnProcessSpell(unit, spell)
	if unit ~= nil then
		if unit.team ~= player.team and unit.type == "obj_AI_Hero" then
			if spell.name:lower():find("BasicAttack") and spell.target == player then
				CastSpell(_Q, unit)
			end
		end
	end
end