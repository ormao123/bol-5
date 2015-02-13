
local ts
local VERSION = 1.00
-- rance

local MyminBBox = GetDistance(myHero.minBBox)/2
local AArance = myHero.range+MyminBBox

function OnLoad()

	if myHero.charName ~="Teemo" then return end
	
	PrintChat("Hello, Yours Teemo ver."..VERSION)
    ConfigYT = scriptConfig("yours Teemo", "yoursTeemo")
		ConfigYT:addSubMenu("combo","combo")
			ConfigYT.combo:addParam("combohotkey","Combo Hot Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			ConfigYT.combo:addParam("castq", "Cast Q", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.combo:addParam("castw", "Cast W", SCRIPT_PARAM_ONOFF, true)
			--ConfigYT.combo:addParam("castr", "Cast R", SCRIPT_PARAM_ONOFF, true)
	
		ConfigYT:addSubMenu("harass", "harass")
			ConfigYT.harass:addParam("AUTOQ", "killsteal Auto Q", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("N"))
		
		ConfigYT:addSubMenu("draw", "draw")
			ConfigYT.draw:addParam("aadraw", "Draw AA rance", SCRIPT_PARAM_ONOFF, true)
			ConfigYT.draw:addParam("qdraw", "Draw Q rance", SCRIPT_PARAM_ONOFF, true)
			
		ts = TargetSelector(TARGET_LOW_HP_PRIORITY,580)
end

function OnTick()

	if myHero.dead then return end
	
	AUTOQ()
	COMBO()
	OnDraw()
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
					CastSpell(_Q, ts.target)
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

function AUTOQ()
	if ConfigYT.harass.AUTOQ then
		ts:update()
		if (ts.target ~= nil) then
			if (ts.target.health < 100) and (myHero:CanUseSpell(_Q) == READY) then
				CastSpell(_Q, ts.target)
			end
		end
	end
end