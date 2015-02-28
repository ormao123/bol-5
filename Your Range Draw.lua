--[[
	Your Range Draw
]]
local version = 0.1
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Range Draw.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Range Draw.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Range Draw:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Range Draw.version")
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

local Champ = {
	-- [''] = {AA = , Q = , W = , E = ,R = },
	['Garen'] = {AA = 125, Q = 125, W = 0, E = 235, R = 400},
	['Gailo'] = {AA = 125, Q = 940, W = 800, E = 1180,R = 600},
	['Gangplank'] = {AA = 125, Q = 625, W = 0, E = 1200,R = 0},
	['Gragas'] = {AA = 125, Q = 850, W = 0, E = 600,R = 1150},
	['Graves'] = {AA = 525, Q = 750, W = 950, E = 425,R = 1000},
	['Gnar'] = {AA = 395, Q = 1100, W = 0, E = 450,R = 0},
	['Nami'] = {AA = 550, Q = 875, W = 725, E = 800,R = 0},
	['Nasus'] = {AA = 125, Q = 0, W = 600, E = 650,R = 0},
	['Nautilus'] = {AA = 175, Q = 950, W = 0, E = 400,R = 825},
	['Nocturne'] = {AA = 125, Q = 1200, W = 0, E = 425,R = 0},
	['Nunu'] = {AA = 125, Q = 125, W = 700, E = 550,R = 650},
	['Nidalee'] = {AA = 525, Q = 1500, W = 900, E = 600,R = 0},
	['Darius'] = {AA = 125, Q = 425, W = 300, E = 540,R = 460},
	['Diana'] = {AA = 150, Q = 830, W = 200, E = 450,R = 825},
	['Draven'] = {AA = 550, Q = 0, W = 0, E = 1050,R = 0},
	['Ryze'] = {AA = 550, Q = 625, W = 600, E = 600,R = 0},
	['Rammus'] = {AA = 125, Q = 200, W = 0, E = 325,R = 300},
	['Lux'] = {AA = 550, Q = 1000, W = 1000, E = 1100,R = 0},
	['Rumble'] = {AA = 125, Q = 600, W = 0, E = 1000,R = 1700},
	['Renekton'] = {AA = 125, Q = 450, W = 550, E = 550,R = 0},
	['Leona'] = {AA = 125, Q = 0, W = 450, E = 700,R = 0},
}

function OnLoad()
	LoadMenu()
end

function OnDraw()
	if menu.draw.mychamp then
		if Champ[myHero.charName] ~= nil and myHero.dead == false then
			range = Champ[myHero.charName]
			if GetDistance(myHero, myHero) < 1500 then
				if menu.draw.mychamp.draw then
					if menu.draw.mychamp.aa then
						DrawCircle(myHero.x, myHero.y, myHero.z, range.AA, 0xFFFFCC)
					end
					if menu.draw.mychamp.q then
						DrawCircle(myHero.x, myHero.y, myHero.z, range.Q, 0xFFFF0000)
					end
					if menu.draw.mychamp.w then
						DrawCircle(myHero.x, myHero.y, myHero.z, range.W, 0x111111)
					end
					if menu.draw.mychamp.e then
						DrawCircle(myHero.x, myHero.y, myHero.z, range.E, 0xFFFFFFff)
					end
					if menu.draw.mychamp.r then
						DrawCircle(myHero.x, myHero.y, myHero.z, range.R, 0xFFFFFFFF)
					end
				end
			end
		end
	end
	for _, target in ipairs(GetEnemyHeroes()) do
		if menu.draw[target.charName] then
			if Champ[target.charName] ~= nil and target.dead == false then
				range = Champ[target.charName]
				if GetDistance(target, myHero) < 1500 then
					if menu.draw[target.charName].draw then
						if menu.draw[target.charName].aa then
							DrawCircle(target.x, target.y, target.z, range.AA, 0xFFFFCC)
						end
						if menu.draw[target.charName].q then
							DrawCircle(target.x, target.y, target.z, range.Q, 0xFFFF0000)
						end
						if menu.draw[target.charName].w then
							DrawCircle(target.x, target.y, target.z, range.W, 0x111111)
						end
						if menu.draw[target.charName].e then
							DrawCircle(target.x, target.y, target.z, range.E, 0xFFFFFFff)
						end
						if menu.draw[target.charName].r then
							DrawCircle(target.x, target.y, target.z, range.R, 0xFFFFFFFF)
						end
					end
				end
			end
		end
	end
end

function LoadMenu()
	menu = scriptConfig("Your Range Draw", "Your Range Draw")
	menu:addSubMenu("Draw Setting", "draw")
		menu.draw:addSubMenu("my Champ", "mychamp")
		if Champ[myHero.charName] ~= nil then
			menu.draw.mychamp:addParam("draw", "Draw ?", SCRIPT_PARAM_ONOFF, true)
			menu.draw.mychamp:addParam("aa", "Draw aa?", SCRIPT_PARAM_ONOFF, true)
			menu.draw.mychamp:addParam("q", "Draw Q?", SCRIPT_PARAM_ONOFF, true)
			menu.draw.mychamp:addParam("w", "Draw W?", SCRIPT_PARAM_ONOFF, true)
			menu.draw.mychamp:addParam("e", "Draw E?", SCRIPT_PARAM_ONOFF, true)
			menu.draw.mychamp:addParam("r", "Draw R?", SCRIPT_PARAM_ONOFF, true)
		else
			menu.draw.mychamp:addParam("nys", "not yet surpot", SCRIPT_PARAM_INFO)
		end
			
	for _, cp in ipairs(GetEnemyHeroes()) do
		menu.draw:addSubMenu(cp.charName, cp.charName)
		if Champ[cp.charName] ~= nil then
			menu.draw[cp.charName]:addParam("draw", "Draw "..cp.charName.." ?", SCRIPT_PARAM_ONOFF, true)
			menu.draw[cp.charName]:addParam("aa", "Draw "..cp.charName.." aa?", SCRIPT_PARAM_ONOFF, true)
			menu.draw[cp.charName]:addParam("q", "Draw "..cp.charName.." Q?", SCRIPT_PARAM_ONOFF, true)
			menu.draw[cp.charName]:addParam("w", "Draw "..cp.charName.." W?", SCRIPT_PARAM_ONOFF, true)
			menu.draw[cp.charName]:addParam("e", "Draw "..cp.charName.." E?", SCRIPT_PARAM_ONOFF, true)
			menu.draw[cp.charName]:addParam("r", "Draw "..cp.charName.." R?", SCRIPT_PARAM_ONOFF, true)
		else
			
			menu.draw[cp.charName]:addParam("nys",   "not yet surpot", SCRIPT_PARAM_INFO)
		end
	end
end