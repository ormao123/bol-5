if myHero.charName ~= "Lucian" then return end

require "VPrediction"
require "SxOrbWalk"

local version = 0.1
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Lucian.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Lucian.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Lucian:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Lucian.version")
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

local QRange, QSpeed, QWidth, QDelay, QMaxRange = 622, math.huge, 55, 0.35, 1100
local WRange, WSpeed, WWidth, WDelay = 1000, 1600, 80, 0.3
local AARange = 622

local Player, EnemyHeroes = GetMyHero(), GetEnemyHeroes()
local ts, Minions
local VP, SxO
local buffactive = false

local function CastQ(unit)
	if GetDistance(unit, Player) <= QRange then
		CastSpell(_Q, unit)
	else
		local Position, HitChance = VP:GetPredictedPos(unit, QDelay, QSpeed, Player, false)
		local V, Vn, Vr, Tx, Ty, Tz, Distance, Radius, TopX, TopY, TopZ, LeftX, LeftY, LeftZ, RightX, RightY, RightZ, Left, Right, Top, Poly, Minion, Champion, i

		V = Vector(Position) - Vector(Player)

		Vn = V:normalized()
		Distance = GetDistance(Position, Player)
		Tx, Ty, Tz = Vn:unpack()
		TopX = Position.x - (Tx * Distance)
		TopY = Position.y - (Ty * Distance)
		TopZ = Position.z - (Tz * Distance)

		Vr = V:perpendicular():normalized()
		Radius = GetDistance(Target, Target.minBBox)
		Tx, Ty, Tz = Vr:unpack()
		LeftX = Position.x + (Tx * Radius)
		LeftY = Position.y + (Ty * Radius)
		LeftZ = Position.z + (Tz * Radius)
		RightX = Position.x - (Tx * Radius)
		RightY = Position.y - (Ty * Radius)
		RightZ = Position.z - (Tz * Radius)

		Left = WorldToScreen(D3DXVECTOR3(LeftX, LeftY, LeftZ))
		Right = WorldToScreen(D3DXVECTOR3(RightX, RightY, RightZ))
		Top = WorldToScreen(D3DXVECTOR3(TopX, TopY, TopZ))
		Poly = Polygon(Point(Left.x, Left.y), Point(Right.x, Right.y), Point(Top.x, Top.y))

		for i, Champion in pairs(EnemyHeroes) do
			local ToScreen = WorldToScreen(D3DXVECTOR3(Champion.x, Champion.y, Champion.z))
			local ToPoint = Point(ToScreen.x, ToScreen.y)
			if Poly:contains(ToPoint) and GetDistanceSqr(Champion, Player) <= QRangeSqr then
				CastSpell(_Q, Champion)
			end
		end

		for i, Minion in pairs(Minions.objects) do
			local ToScreen = WorldToScreen(D3DXVECTOR3(Minion.x, Minion.y, Minion.z))
			local ToPoint = Point(ToScreen.x, ToScreen.y)
			if Poly:contains(ToPoint) and GetDistanceSqr(Minion, Player) <= QRangeSqr then
				CastSpell(_Q, Minion)
			end
		end
	end
end

local function CastW(unit)
	local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, WDelay, WWidth, WRange, WSpeed, Player, true)
	if CastPosition and HitChance >= 2 and GetDistance(CastPosition, Player) <= WRange then
		CastSpell(_W, CastPosition.x, CastPosition.z)
	end
end

function OnLoad()
	VP = VPrediction()
	SxO = SxOrbWalk()
	
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1300, DAMAGE_PHYSICAL, false)
	Minions = minionManager(MINION_ENEMY, QRange, Player, MINION_SORT_MAXHEALTH_ASC)
	
	Menu = scriptConfig("L","L")
	Menu:addSubMenu("Combo", "combo")
		Menu.combo:addParam("combo","combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Menu.combo:addParam("useq", "useq", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("usew", "usew", SCRIPT_PARAM_ONOFF, true)
	
	Menu:addSubMenu("Harass", "harass")
		Menu.harass:addParam("combo","combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		Menu.harass:addParam("useq", "useq", SCRIPT_PARAM_ONOFF, true)
		
	Menu:addSubMenu("killsteal", "killsteal")
		Menu.killsteal:addParam("useq", "ks Q", SCRIPT_PARAM_ONOFF, true)
		Menu.killsteal:addParam("useW", "ks W", SCRIPT_PARAM_ONOFF, true)
		
	Menu:addSubMenu("Orbwalk", "Orbwalk")
		SxO:LoadToMenu(Menu.Orbwalk)
end

function OnTick()
	Combo()
	Harass()
	ks()
end

function ks()
	local i, Champion
	for i, Champion in pairs(EnemyHeroes) do
		if ValidTarget(Champion) then
			if GetDistance(Champion, Player) <= QRange and getDmg("Q", Champion, Player) > Champion.health and Menu.killsteal.useq then
				CastQ(Champion)
			end
			if GetDistance(Champion, Player) <= WRange and getDmg("W", Champion, Player) > Champion.health and Menu.killsteal.usew then
				CastW(Champion)
			end
		end
	end
end

function Harass()
	if Menu.harass.combo then
		Target = SxO:GetTarget()
		if Target ~= nil then
			if Menu.harass.useq then
				CastQ(Target)
			end
		end
	end
end

function Combo()
	if Menu.combo.combo then
		ts:update()
		Target = SxO:GetTarget()
		if Target ~= nil then
			if buffcheck() == false then
				if myHero:CanUseSpell(_Q) == READY and Menu.combo.useq then
					CastQ(Target)
				elseif myHero:CanUseSpell(_W) == READY and Menu.combo.usew then
					CastW(Target)
				end
			else
				DelayAction(function() myHero:Attack(Target) end, 0.5)
			end
		end
	end
end

function buffcheck()
	return TargetHaveBuff("lucianpassivebuff", myHero)
end