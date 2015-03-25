
if not VIP_USER then return end



local version = 1.00
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Helper/Your GankWarming.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your GankWarming.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your GankWarming:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Helper/version/Your GankWarming.version")
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
	print("Load >> Your GankWarming")
	OnLoadMenu()
end

function OnDraw()
	for i, j in ipairs(GetEnemyHeroes()) do
		if ValidTarget(j, Config.rance) and Config.champ[j.charName] then
			DrawLine3D(myHero.x, myHero.y, myHero.z, j.x,j.y, j.z, 9, 0xffff0000)
		end
	end
end


function OnLoadMenu()
	Config = scriptConfig("Your GankWarming", "Your GankWarming")
		Config:addParam("active", "Active", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("G"))
		
		Config:addSubMenu("Champing setting", "champ")
			for i, j in ipairs(GetEnemyHeroes()) do
				Config.champ:addParam(j.charName, j.charName.." active", SCRIPT_PARAM_ONOFF, false)
			end
			
		Config:addParam("rance", "Rance", SCRIPT_PARAM_SLICE, 1000, 1000, 3000, 0)
end
