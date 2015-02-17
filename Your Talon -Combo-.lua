if myHero.charName ~= "Talon" then return end

local ranceQ = 250
local ranceW = 750
local ranceE = 700
local ranceR = 650

local wDelay = 50

local ts


require "VPrediction"

local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local Qdmg, Wdmg, Edmg, Rdmg = nil, nil, nil, nil
local SxO = nil
--local tiamat, hydra = nil, nil
--local TMready, HRready = nil, nil

local version = 1.01
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Talon -Combo-.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Talon -Combo-.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Talon -Combo-:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Talon -Combo-.version")
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

	ts = TargetSelector(TARGET_LOW_HP_PRIORITY, 750)
	enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
	-- menu
	VP = VPrediction()
	require "SxOrbWalk"
	SxO = SxOrbWalk(VP)
	loadMenu()
	
	--GetItem()
	-- target
	

end

function loadMenu()
	ConfigY = scriptConfig("Your Talon", "Your Talon")
		ConfigY:addSubMenu("combo", "combo")
			ConfigY.combo:addParam("combo", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		
		ConfigY:addSubMenu("harass", "harass")
			ConfigY.harass:addParam("harass", "Harass toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, 90)
			ConfigY.harass:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
			
		ConfigY:addSubMenu("draw", "draw")
			--ConfigY.draw:addParam("drawkillable", "Draw Killable", SCRIPT_PARAM_ONOFF, true)
			ConfigY.draw:addParam("drawerance", "Draw E rance", SCRIPT_PARAM_ONOFF, true)
			--ConfigY.draw:addParam("drawwrance", "Draw W rance", SCRIPT_PARAM_ONOFF, true)
		
		ConfigY:addSubMenu("farming", "farming")
			ConfigY.farming:addParam("farm", "farm", SCRIPT_PARAM_ONKEYTOGGLE, false, 90)
			
		ConfigY:addSubMenu("OrbWalker", "OrbWalker")
			SxO:LoadToMenu(ConfigY.OrbWalker)
end

function OnTick()
	GetSpellStat()
	enemyMinions:update()
	farm()
	--GetItem()
	if ConfigY.harass.harass then
		Harass()
	end
	
	if ConfigY.combo.combo then
		OnCombo()
	end
end

function farm()
	if ConfigY.farming.farming then
		for index, minion in pairs(enemyMinions.objects) do
			if Wready and GetDistance(minion, myHero) <= ranceW then
			local Wdmg = getDmg("W", minion, myHero)
				if Wdmg >= minion.health then
					CastSpell(_W, minion)
				end
			end
		end
	end
end
--[[function GetItem()
	tiamat = GetInventorySlotItem(3077)
	hydra = GetInventorySlotItem(3074)
end]]

function Harass()
	ts:update()
	if ts.target == nil then return end
	if ConfigY.harass.usew and GetDistance(ts.target, myHero) < ranceW then
		CastSpell(_W, ts.target)
	end
end

function GetSpellStat()
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
	
	--[[if tiamat ~= nil and myHero:CanUseSpell(tiamat) == READY then
		TMready = true
	else
		TMready = false
	end
	
	if hydra ~= nil and myHero:CanUseSpell(hydra) == READY then
		HRready = true
	else
		HRready = false
	end]]
end

function OnCombo()
	ts:update()
	if ts.target == nil then return end
	if GetDistance(ts.target, myHero) < ranceE and Eready then
		CastSpell(_E, ts.target)
	end
	
	if GetDistance(ts.target, myHero) < ranceE and Wready then
		CastSpell(_W, ts.target)
	end
	
	if GetDistance(ts.target, myHero) < ranceQ and Qready then
		CastSpell(_Q)
		myHero:Attack(ts.target)
	end
	
	if GetDistance(ts.target, myHero) < ranceR and Rready then
		CastSpell(_R)
	end
	--if HRready then CastSpell(hydra, ts.target) end
	--if TMready then CastSpell(tiamat, ts.target) end
end


function OnDraw()                                                                                                          
	if ConfigY.draw.drawerance then
		DrawCircle(myHero.x, myHero.y, myHero.z, ranceE, 0xFFFFCC)
	end
end