
if myHero.charName ~="Teemo" then return end

local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0 --we initalize the variables
	
local ts
local version = 1.02
local Qcasting = false
local Qdamage = { 80, 125, 170, 215, 260}
-- rance

local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Teemo.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Teemo.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Teemo:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Teemo.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				--[[AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")]]
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

local MyminBBox = GetDistance(myHero.minBBox)/2
local AArance = myHero.range+MyminBBox

function OnLoad()
	
    ConfigYT = scriptConfig("yours Teemo", "yoursTeemo")
		ConfigYT:addSubMenu("combo","combo")
			ConfigYT.combo:addParam("combohotkey","Combo Hot Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			ConfigYT.combo:addParam("castq", "Cast Q", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.combo:addParam("castw", "Cast W", SCRIPT_PARAM_ONOFF, true)
			--ConfigYT.combo:addParam("castr", "Cast R", SCRIPT_PARAM_ONOFF, true)
			
		ConfigYT:addSubMenu("orbwalk","orbwalk")
			ConfigYT.orbwalk:addParam("OWcombomod","Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			--ConfigYT.orbwalk:addParam("OWlasthit","lasthit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			--ConfigYT.orbwalk:addParam("OWharass","harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	
		ConfigYT:addSubMenu("harass", "harass")
			ConfigYT.harass:addParam("killstealQ", "killsteal Auto Q", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("N"))
		
		ConfigYT:addSubMenu("draw", "draw")
			ConfigYT.draw:addParam("aadraw", "Draw AA rance", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.draw:addParam("qdraw", "Draw Q rance", SCRIPT_PARAM_ONOFF, true)
			
		ts = TargetSelector(TARGET_LOW_HP_PRIORITY,580)
end

function OnTick()

	if myHero.dead then return end
	
	killsteal()
	COMBO()
	OnDraw()
	if ConfigYT.orbwalk.OWcombomod then
		OrbWalk()
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
		DrawCircle(myHero.x, myHero.y, myHero.z, AArance, 0xFFFFFF00)
	end
    if ConfigYT.draw.qdraw then
        DrawCircle(myHero.x, myHero.y, myHero.z, 580, 0xFFFF0000)
    end
end

function killsteal()
	if ConfigYT.harass.killstealQ then
		ts:update()
		if (ts.target ~= nil) then
			if (ts.target.health < Qdamage[myHero:GetSpellData(_Q).level]) and (myHero:CanUseSpell(_Q) == READY) then
				CastSpell(_Q, ts.target)
			end
		end
	end
end
-- orbwalk

function OrbWalk()
	ts:update() --our target is teh currently selected one(you can also use the targetselector whatever)
	if ts.target ~=nil and GetDistance(ts.target) <= AArance then --if it valid then lets go
		if timeToShoot() then --see code later
			myHero:Attack(ts.target) --AA
		elseif heroCanMove() and Qcasting == false then --if we cant attack but we can move
			moveToCursor() --we move to cursor
		end
	else		
		moveToCursor() --if the target isnt valid we jsut move to cursor
	end
end

function OnProcessSpell(object, spell) --if smth happens
	if object == myHero then --if we are teh owner from teh object
		if spell.name:lower():find("attack") then --and the name is attack
			lastAttack = GetTickCount() - GetLatency()/2 --the last attack is GetTickCount, that is the curent time - getlatenxy/2, why 2? because we need the time for the attack client-server and server-client
			lastWindUpTime = spell.windUpTime*1000 --the lastwinduptime
			lastAttackCD = spell.animationTime*1000 --and our "cd"
		end 
	end
end

function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20) --if aa on cd, we can move
end 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD) --if aa ready, we can shoot
end 

function moveToCursor()
	if GetDistance(mousePos) > 10 then --well not rly much to say 
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*250 --we just move 250 units in direction of our mouse
		myHero:MoveTo(moveToPos.x, moveToPos.z) --and there we go
	end 
end