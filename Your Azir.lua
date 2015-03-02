--[[

		thx qpqp1020 to donate Azir for me

]]


if myHero.charName ~= "Azir" then return end

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("QDGEHEDJJIJ") 

require "SxOrbWalk"
--A basic BoL template for the Eclipse Lua Development Kit module's execution environment written by Nader Sl.

local version = 1.02
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Azirlua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Azir.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Azir:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Azir.version")
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


local player = GetMyHero()
local enemyHeros = GetEnemyHeroes()
local ts, enemyMinions, SxO
local flash
local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local Qrance, Wrance, Erance, Rrance, Srance = 1400, 1300, 1300, 500, 400

-- called once when the script is loaded
function OnLoad()
	GetSummoners()
	SxO = SxOrbWalk()
	LoadMenu()
  
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY,1500,DAMAGE_MAGIC, false)
end

-- handles script logic, a pure high speed loop
function OnTick()
	local TT = myHero + Vector(mousePos.x-myHero.x,myHero.y,mousePos.z-myHero.z):normalized()*(GetDistance(myHero,mousePos)+100)
	
	--kick()
	Combo()
	Harass()
	OnSpellcheck()
	Escape()

end

--handles overlay drawing (processing is not recommended here,use onTick() for that)
function OnDraw()
	ts:update()
	if ts.target ~= nil then
		TTarget = ts.target
		DrawCircle(TTarget.x, TTarget.y, TTarget.z, 100, 0xFF00FF)
	end
	--DrawCircle(TT.x, TT.y, TT.z, 100, 0xFF00FF)
end

function LoadMenu()
	Config = scriptConfig("Your Azir", "Your Azir")
	
	Config:addSubMenu("Combo", "combo")
		Config.combo:addParam("comboactive", "Combo Active", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.combo:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("usee", "Use E", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("Harass", "harass")
		Config.harass:addParam("harassactive", "Harass Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		Config.harass:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("LoneClear", "lineclear")
		Config.lineclear:addParam("lineactive", "LoneClear Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		
	Config:addSubMenu("Escape", "escape")
		Config.escape:addParam("escapeactive", "Escape Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
		
	--Config:addSubMenu("Kick", "kick")
		--Config.kick:addParam("kickactivate", "Kick Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	
	Config:addSubMenu("Orbwalk", "orbwalk")
		SxO:LoadToMenu(Config.orbwalk)
end

--combo
function Combo()
	ts:update()
	if Config.combo.comboactive and ts.target ~= nil then
		local Target = ts.target
		if AzirObject ~= nil then
			ASRange = GetDistance(AzirObject,ts.target)
		end
		if Config.combo.usew and Wready and GetDistance(ts.target, player) < Wrance then
			CastSpell(_W, Target.x, Target.z)
		end
		if Config.combo.useq and Qready and AzirObject ~= nil and GetDistance(ts.target, player) < Qrance and ASRange > Srance then
			CastSpell(_Q, Target.x, Target.z)
		end
		if Config.combo.usee and Erance and AzirObject ~= nil and ASRange < Srance then
			CastSpell(_E, AzirObject)
		end
	end
end

--harass
function Harass()
	if Config.harass.harassactive then
		ts:update()
		local Target = ts.target
		if Config.harass.usew and Target ~= nil then
			CastSpell(_W, Target.x, Target.z)
		end
		if Config.harass.useq and Target ~= nil then
			CastSpell(_Q, Target.x, Target.z)
		end
				
	end
end

function LC()
	if Config.lineclear.lineactive then
		local st = SxO:GetTarget()
		if st ~= nil then
			if AzirObject ~= nil then
				ASRange = GetDistance(AzirObject,st)
			end
			if Wready then
				CastSpell(_W, ts.x, ts.z)
			end
			if ASRange > Srance then
				CastSpell(_Q, ts.x, ts.z)
			end
		end
	end
end

--kick with flash, Ult
--[[function kick()
	ts:update()
	TTTarget = ts.target 
	if Config.kick.kickactive and GetDistance(TTTarget, myHero) < 2000 and Qrance and myHero:CanUseSpell(flash) == READY then
		local mousex = mousePos.x
		local mousez = mousePos.z
		local Kicktarget = myHero + Vector(TTTarget.x-myHero.x,myHero.y,TTTarget.z-myHero.z):normalized()*(GetDistance(myHero,TTTarget)+100)
		DrawCircle(Kicktarget.x, Kicktarget.y, kickactivate.z, 100, 0xFFFFFFFF)
		if Wready then
			CastSpell(_W, TTTarget.x, TTTarget.z)
		end
		if Qready and Eready and AzirObject ~= nil then
			CastSpell(_Q, TTTarget.x, TTTarget.z)
			CastSpell(_E, AzirObject)
		end
		if myHero:CanUseSpell(flash) == READY and Rready and GetDistance(myHero. TTTarget) > 100 then
			CastSpell(flash, Kicktarget.x, Kicktarget.z)
			CastSpell(_R, mousex, mousez)
		end
	end
end]]


--escape
function Escape()
	if Config.escape.escapeactive then
		local mousex = mousePos.x
		local mousez = mousePos.z
	
		if Wready then
			CastSpell(_W, mousex, mousez)
		end
		if Qready and AzirObject ~= nil then
			CastSpell(_Q, mousex, mousez)
			CastSpell(_E, AzirObject)
		end
	end
end

function OnCreateObj(obj)
	if obj and obj.name == "AzirSoldier" then 
		AzirObject = obj 
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

function GetSummoners()
	if string.lower(myHero:GetSpellData(SUMMONER_1).name) == "summonerflash" then
		flash = SUMMONER_1
	elseif string.lower(myHero:GetSpellData(SUMMONER_2).name) == "summonerflash" then
		flash = SUMMONER_2
	else
		flash = nil
	end
end
