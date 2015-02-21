--[[
	update note
	1.06 | Add Harass
]]


if myHero.charName ~="Teemo" then return end
 -- bol script status
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("VILJLIPLIQH") 

local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0 --we initalize the variables
	
	
require "SxOrbWalk"

local flash = nil
local ignite = nil
local ts
local version = 1.08
local Qcasting = false
local Rcasting = false
local Player = GetMyHero()
local EnemyHeroes = GetEnemyHeroes()
local SxO = nil
-- rance

local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Yours Teemo.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Yours Teemo.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Yours Teemo:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Yours Teemo.version")
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

function OnLoad()
	
	SxO = SxOrbWalk()
    ConfigYT = scriptConfig("yours Teemo", "yoursTeemo")
		ConfigYT:addSubMenu("combo","combo")
			ConfigYT.combo:addParam("combohotkey","Combo Hot Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			ConfigYT.combo:addParam("castq", "Cast Q", SCRIPT_PARAM_ONOFF, true)
			--ConfigYT.combo:addParam("qandaa", "AA after Q", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.combo:addParam("castw", "Cast W", SCRIPT_PARAM_ONOFF, true)
			--ConfigYT.combo:addParam("castr", "Cast R", SCRIPT_PARAM_ONOFF, true)
	
		ConfigYT:addSubMenu("killsteal", "killsteal")
			ConfigYT.killsteal:addParam("killstealQ", "killsteal Auto Q", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.killsteal:addParam("flashQkilsteal","killsteal Auto flash Q", SCRIPT_PARAM_ONOFF, false)
		
		ConfigYT:addSubMenu("harass", "harass")
			ConfigYT.harass:addParam("harassQ","harass", SCRIPT_PARAM_ONOFF, true)
		
		ConfigYT:addSubMenu("draw", "draw")
			ConfigYT.draw:addParam("aadraw", "Draw AA rance", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.draw:addParam("qdraw", "Draw Q rance", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.draw:addParam("bshroom", "Best shroom Draw", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.draw:addParam("targetdraw", "Target Draw", SCRIPT_PARAM_ONOFF, false)
			
		ConfigYT:addSubMenu("OrbWalker", "OrbWalker")
			SxO:LoadToMenu(ConfigYT.OrbWalker)
			
		ts = TargetSelector(TARGET_LOW_HP_PRIORITY,580)
end

function OnTick()

	if myHero.dead then return end
	
	killsteal()
	
	COMBO()
	OnDraw()
	harass()
end

function harass()
	ts:update()
	if ConfigYT.harass.harassQ then
		if ts.target ~= nil and GetDistance(ts.target, Player) <= 580 then
			CastSpell(_Q, ts.target)
		end
	end
end

function COMBO()
	if (ConfigYT.combo.combohotkey) then
		ts:update()
		if myHero:CanUseSpell(_W) == READY then
			if ConfigYT.combo.castw then
					CastSpell(_W)
				end
			end
		if (ts.target ~= nil) then
			if ConfigYT.combo.castq then
				if (myHero:CanUseSpell(_Q) == READY) then
					Qcasting = true
					CastSpell(_Q, ts.target)
					Qcasting = false
				end
			end
		end
	end
end

function OnDraw()

	if ConfigYT.draw.aadraw then
		DrawCircle(myHero.x, myHero.y, myHero.z, AArance, 0xFFFFCC)
	end
    if ConfigYT.draw.qdraw then
        DrawCircle(myHero.x, myHero.y, myHero.z, 580, 0xFFFF0000)
    end
	if ConfigYT.draw.targetdraw then
		ts:update()
		if ts.target ~= nil then
			DrawCircle(ts.target.x,ts.target.y, ts.target.z, 100, 0xFFFFFFff)
		end
	end
	if ConfigYT.draw.bshroom then
		for _, v in ipairs(bestshroom) do
			DrawCircle(v.x, v.y, v.z, 100, 0x33FFFF)
		end
	end
	--[[local i, Champion
	for i, Champion in pairs(EnemyHeroes) do
		if ValidTarget(Champion) then
			if GetDistance(Champion, Player) <= 1000 and getDmg("Q", Champion, Player) > Champion.health then
				DrawText("Can you Kill him with Q", 18, Champion.x, Champion.y, 0xFF000000)
			elseif GetDistance(Champion, Player) <= 1000 and getDmg("Q", Champion, Player) <= Champion.health then
				DrawText("Cant you Kill him with Q", 18, Champion.x, Champion.y, 0xFF000000)
			end
		end
	end]]
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
			if GetDistance(Champion, Player) <= 580 and myHero:CanUseSpell(_Q) == READY and getDmg("Q", Champion, Player) > Champion.health and ConfigYT.killsteal.killstealQ then
				CastSpell(_Q, Champion)
			end
			if GetDistance (Champion, Player) <= 980 and myHero:CanUseSpell(_Q) == READY and getDmg("Q", Champion, Player) > Champion.health and ConfigYT.killsteal.flashQkilsteal then
				GetSummoners()
				CastSpell(flash, Champion.x, Champion.z)
				CastSpell(_Q, Champion)
			end
		end
	end
end