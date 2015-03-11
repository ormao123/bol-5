--[[
Your Helper

-enemy vision Done
-enemy Spell Cooldown
-enemy Anti closurer Done
-Auto Potion
-Auto QSS
-Enemy position Done
-Ward Position
-Auto Item
-Auto Summoner Spell

]]

local version = 1.00
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Helper.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Helper.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Helper:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/version/Your Helper.version")
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

 -- require
 require 'sourceLib'
 
 -- local
 
 local clean, smite = nil, nil
 
 -- Vision
 local defaultColor = {100, 255, 0, 0}
 local defaultWidth = 2
 local defaultQuality = 30
 local visionRadius = 1200
 local cachedPoints = {}
 local previousQuality = defaultQuality
 
 
 local WARD_RANGE = 600
 local WARD_MAGIC_RANGE = 1000
 
 local TRINKET_RANGE = 600
 
 -- posion
 local mana_potion_time, health_potion_time, flask_potion_time =0, 0, 0
 
 -- Ward
 
 local Ward = {}
 
 -- other
 local player		= myHero
 local enemyHeroes	= GetEnemyHeroes()
 
 local BuffTypes = {
            [5] = true, -- Stun
            [7] = true, -- Silence
            [10] = false, -- Slow
}

local stealthBuffTable = {
	["Rengar"] = { "RengarR" },
  --camouflagestealth
	["MonkeyKing"] = { "monkeykingdecoystealth" },
	["Talon"] = { "TalonShadowAssault" },
	--["Vayne"] = { "vaynetumblefade" },
	["Twitch"] = { "TwitchHideInShadows" },
	["Khazix"] = { "khazixrstealth" },
	["Akali"] = { "akaliwstealth" },
}
 -- Item Load
 
function LoadItem()
	ItemNames				= {
		[3364]				= "TrinketSweeperLvl3",
		[2050]				= "ItemMiniWard",
		[3180]				= "OdynsVeil",
		[3140]				= "QuicksilverSash",
		[2044]				= "SightWard",
		[2043]				= "VisionWard",
		[2003]				= "RegenerationPotion",
		[2004]				= "FlaskOfCrystalWater",
		[2041]				= "ItemCrystalFlask",
	}
	
	_G.ITEM_1				= 06
	_G.ITEM_2				= 07
	_G.ITEM_3				= 08
	_G.ITEM_4				= 09
	_G.ITEM_5				= 10
	_G.ITEM_6				= 11
	_G.ITEM_7				= 12
	
	___GetInventorySlotItem	= rawget(_G, "GetInventorySlotItem")
	_G.GetInventorySlotItem	= GetSlotItem
end

function GetSlotItem(id, unit)
	
	unit 		= unit or myHero

	if (not ItemNames[id]) then
		return ___GetInventorySlotItem(id, unit)
	end

	local name	= ItemNames[id]
	
	for slot = ITEM_1, ITEM_7 do
		local item = unit:GetSpellData(slot).name
		if ((#item > 0) and (item:lower() == name:lower())) then
			return slot
		end
	end

end

-- Get Summoner Spell

function GetSS()
	--QS
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerboost") then
		clean = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerboost") then
		clean = SUMMONER_2
	end
	
	--Smite
	if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then
		Smite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonersmite") then
		Smite = SUMMONER_2
	end
end

 -- Get ITEM

 -- other
 
 function champOnScreen(champ)
    local pos = WorldToScreen(D3DXVECTOR3(champ.x, champ.y, champ.z))
    return pos.x <= WINDOW_W and pos.x >= 0 and pos.y >= 0 and pos.y <= WINDOW_H
 end

 function OnApplyBuff(u,s,b)
 if u.isMe then
 end
 end

function Variables()
	ChampionCount = 0
    ChampionTable = {}
 
    for i = 1, heroManager.iCount do
        local champ = heroManager:GetHero(i)
               
        if champ.team ~= player.team then
            ChampionCount = ChampionCount + 1
            ChampionTable[ChampionCount] = { player = champ, indicatorText = "", damageGettingText = "", ultAlert = false, ready = true}
        end
    end
end
 -- Main System

function OnLoad()
	LoadItem()
	GetSS()
	Variables()
	LoadMenu()
end


function OnTick()
	DmgCalc()
	Drink()
end

function OnDraw()
	VisionDraw()
	EnemyPath()
	chkmOnDraw()
end

function LoadMenu()
	menu = scriptConfig("[Your] Helper", "[Your] Helper")
	
	-- Vision
	menu:addSubMenu("Enemy Vision", "EnemyVision")
		menu.EnemyVision:addParam("active", "Active", SCRIPT_PARAM_ONOFF, true)
		menu.EnemyVision:addParam("color", "Color", SCRIPT_PARAM_COLOR, defaultColor)
		menu.EnemyVision:addParam("screen", "Only draw when enemy on screan", SCRIPT_PARAM_ONOFF, true)
		menu.EnemyVision:addParam("width", "Line width", SCRIPT_PARAM_SLICE, defaultWidth, 1, 5, 0)
		menu.EnemyVision:addParam("quality", "Calculation quality", SCRIPT_PARAM_SLICE, defaultQuality, 10, 100, 0)
	
	-- QSS	
	--[[menu:addSubMenu("Quick silver", "qs")
		menu.qs:addParam("active", "Active", SCRIPT_PARAM_ONOFF, true)
		menu.qs:addParam("delay", "QSS Delay *0.1 ", SCRIPT_PARAM_SLICE, 0.1, 0, 1, 2)
		menu.qs:addParam("sep", "", SCRIPT_PARAM_INFO, "")
		menu.qs:addParam("stun", "Stun", SCRIPT_PARAM_ONOFF, true) -- 5
		menu.qs:addParam("silence", "Silence", SCRIPT_PARAM_ONOFF, true) -- 7
		menu.qs:addParam("slow", "Slow", SCRIPT_PARAM_ONOFF, true) -- 10]]
		
	menu:addSubMenu("Anti Stealth", "as")
		menu.as:addParam("active", "Active", SCRIPT_PARAM_ONOFF, true)
		
	menu:addSubMenu("Where he go", "whg")
		menu.whg:addParam("active", "Active", SCRIPT_PARAM_ONOFF, true)
		
	menu:addSubMenu("Can he kill me", "chkm")
		menu.chkm:addParam("active", "Active", SCRIPT_PARAM_ONOFF, true)
		local i, Champion
		for i, Champion in pairs(enemyHeroes) do
			menu.chkm:addParam(Champion.charName,"Draw for: " .. Champion.charName .. "?", SCRIPT_PARAM_LIST, 1, {"YES", "NO"})
		end
		
	menu:addSubMenu("Auto Posion", "posion")
		menu.posion:addParam("active", "Active", SCRIPT_PARAM_ONOFF, true)
		menu.posion:addParam("health", "Use Health posion under %", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
		menu.posion:addParam("mana", "Use Mana posion under %", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
end

 -- enemy Vision
 
 function VisionDraw()
	-- Don't draw when disabled
    if not menu.EnemyVision.active then return end

    -- Check if quality changed
    if previousQuality ~= menu.EnemyVision.quality then
        -- Reset cached points
        cachedPoints = {}
    end

    for _, enemy in pairs(enemyHeroes) do
        if enemy.visible then

            -- Enemy on screen check
            if not menu.EnemyVision.screen or champOnScreen(enemy) then

                local gridPos = GameHandler:GetGridGameCoordinates(enemy)
                local points = {}
                local pointsFound = false

                for key, value in pairs(cachedPoints) do
                    if key == gridPos then
                        points = value
                        pointsFound = true
                        break
                    end
                end

                if not pointsFound then
                    local x, y, z = gridPos.x, gridPos.y, gridPos.z
                    local quality = 2 * math.pi / menu.EnemyVision.quality
                    for theta = 0, 2 * math.pi + quality, quality do
                        local point = D3DXVECTOR3(x + visionRadius * math.cos(theta), y, z - visionRadius * math.sin(theta))
                        for step = 0, visionRadius, 25 do
                            local gamePos = GameHandler:GetGridGameCoordinates(Vector(x + step * math.cos(theta), y, z - step * math.sin(theta)))
                            if isObstacle(gamePos) then                    
                                point = D3DXVECTOR3(gamePos.x, gamePos.y, gamePos.z)
                                break
                            end
                        end
                        points[#points + 1] = point
                    end
                    cachedPoints[gridPos] = points
                end

                -- Calculate world to screen
                local screenPoints = {}
                for _, point in ipairs(points) do
                    c = WorldToScreen(point)
                    screenPoints[#screenPoints + 1] = D3DXVECTOR2(c.x, c.y)
                end

                -- Draw the lines
                if screenPoints and #screenPoints > 0 then
                    DrawLines2(screenPoints, menu.EnemyVision.width, TARGB(menu.EnemyVision.color))
                end

            end

        end
    end
 end
 
 
function isObstacle(vector, brush)

    if brush == nil then
        return IsWall(D3DXVECTOR3(vector.x, 0, vector.z)) or IsWallOfGrass(D3DXVECTOR3(vector.x, 0, vector.z))
    elseif brush == false then
        return IsWall(D3DXVECTOR3(vector.x, 0, vector.z))
    else
        return IsWallOfGrass(D3DXVECTOR3(vector.x, 0, vector.z))
    end

end
 
 -- Auto Qss
 
 --[[function UseItems(unit, scary)
	if not ValidTarget(unit) or lastRemove > os.clock() - 1 then return end
	for i, Item in pairs(Items) do
		local Item = Items[i]
		if GetInventoryItemIsCastable(Item.id) and GetDistanceSqr(unit) <= Item.range * Item.range then
			if Item.id == 3139 or Item.id ==  3140 then
				if isCC() or scary then
					DelayAction(function() CastItem(Item.id) end, QSSMenu.delay*0.1)
					lastRemove = os.clock()
					return true
				end
			end
		end
	end
	if QSSMenu.Summoner and SummonerSlot and myHero:CanUseSpell(SummonerSlot) == 0 and isCC(true) then
		DelayAction(function() CastSpell(SummonerSlot) end, QSSMenu.delay*0.1)
		lastRemove = os.clock()
	end
end]]

 -- Anti Stealth
 
 function OnProcessSpell(unit, spell)
	if stealthBuffTable[unit.charName] ~= nil and unit.team ~= player.team then
		for i=1, #stealthBuffTable[unit.charName] do
			if spell.name == stealthBuffTable[unit.charName][i] then
				AntiStealth(unit)
			end
		end
	 end
 end
 

 
 function AntiStealth(unit)
	if menu.as.active then
		if GetInventoryItemIsCastable(3364) and GetDistance(unit) <= (TRINKET_RANGE + TRINKET_RANGE / 2) then
			if GetDistance(unit) <= TRINKET_RANGE then
				print("Cast 3364"..unit.charName)
				CastItem(3364, unit.x, unit.z)
			else
			local castPos = myHero + (Vector(unit) - myHero):normalized() * (TRINKET_RANGE + TRINKET_RANGE / 2)
				print("Cast 3364"..unit..castPos)
				CastItem(3364, castPos.x, castPos.z)
			end
		elseif GetInventoryItemIsCastable(2043) and GetDistance(unit) <= (WARD_MAGIC_RANGE + WARD_RANGE) then
			if GetDistance(unit) <= WARD_RANGE then
				print("Cast 2043"..unit.charName)
				CastItem(2043, unit.x, unit.z)
			else
			local castPos = myHero + (Vector(unit) - myHero):normalized() * WARD_RANGE
				print("Cast 2043"..unit..CastPos)
				CastItem(2043, castPos.x, castPos.z)
			end
		end
	end
 end
 
 
 -- enemy Path
 
 function EnemyPath()
	if menu.whg.active then
		for i, enemy in pairs(enemyHeroes) do
			if ValidTarget(enemy, 3000) then
				if enemy.hasMovePath and enemy.pathCount >= 2 then				
					local enemyIndexPath = enemy:GetPath(enemy.pathIndex)
					if enemyIndexPath then
						DrawLine3D(enemy.x, enemy.y, enemy.z, enemyIndexPath.x, enemyIndexPath.y, enemyIndexPath.z, 1, ARGB(255, 255, 0, 0))
						for i=enemy.pathIndex, enemy.pathCount-1 do
							local Path = enemy:GetPath(i)
							local Path2 = enemy:GetPath(i+1)
							DrawLine3D(Path.x, Path.y, Path.z, Path2.x, Path2.y, Path2.z, 1, ARGB(255, 255, 255, 0))
						end
					end
				end
			end
		end
	end
 end
 
 
  -- can he kill me
  
  function DmgCalc()
    for i = 1, ChampionCount do
        local Champion = ChampionTable[i].player
        if ValidTarget(Champion) and Champion.visible then
               
               
        SpellQ = getDmg("Q", myHero, Champion)
        SpellW = getDmg("W", myHero, Champion)
        SpellE = getDmg("E", myHero, Champion)
        SpellR = getDmg("R", myHero, Champion)
        SpellI = getDmg("IGNITE", myHero, Champion)
 

        if myHero.health < SpellR then
            ChampionTable[i].indicatorText = "Killed me with: R"

        elseif myHero.health < SpellQ then
            ChampionTable[i].indicatorText = "Killed me with: Q"

        elseif myHero.health < SpellW then
            ChampionTable[i].indicatorText = "Killed with: W"

        elseif myHero.health < SpellE then
            ChampionTable[i].indicatorText = "Killed me with: E"

        elseif myHero.health < SpellQ + SpellR then
            ChampionTable[i].indicatorText = "Killed me with: Q + R"

        elseif myHero.health < SpellW + SpellR then
            ChampionTable[i].indicatorText = "Killed me with: W + R"

        elseif myHero.health < SpellE + SpellR then
            ChampionTable[i].indicatorText = "Killed me with: E + R"

        elseif myHero.health < SpellQ + SpellW + SpellR then
            ChampionTable[i].indicatorText = "Killed me with: Q + W + R"

        elseif myHero.health < SpellQ + SpellE + SpellR then
            ChampionTable[i].indicatorText = "Killed me with: Q + E + R"

        else
            local dmgTotal = (SpellQ + SpellW + SpellE + SpellR)
            local hpLeft = math.round(myHero.health - dmgTotal)
            local percentLeft = math.round(hpLeft / myHero.maxHealth * 100)
                ChampionTable[i].indicatorText = "Cant kill me ( " .. percentLeft .. "% )"
        end
 
            local ChampionAD = getDmg("AD", myHero, Champion)  
            ChampionTable[i].damageGettingText = Champion.charName .. " Killed me with " .. math.ceil(myHero.health / ChampionAD) .. " hits"
        end
    end
end

function chkmOnDraw()
	if menu.chkm.active then                
        for i = 1, ChampionCount do
            local Champion = ChampionTable[i].player
 
			if ValidTarget(Champion) and Champion.visible and menu.chkm[Champion.charName] == 1 then
				local barPos = WorldToScreen(D3DXVECTOR3(Champion.x, Champion.y, Champion.z))
				local pos = { X = barPos.x - 35, Y = barPos.y - 50 }

				DrawText(ChampionTable[i].indicatorText, 15, pos.X + 20, pos.Y, (ChampionTable[i].ready and ARGB(255, 0, 255, 0)) or ARGB(255, 255, 220, 0))
				DrawText(ChampionTable[i].damageGettingText, 15, pos.X + 20, pos.Y + 15, ARGB(255, 255, 0, 0))
			end
        end
    end
end

-- Auto Posion

function Drink()
	if menu.posion.active then
		if GetInventoryItemIsCastable(2041) and player.health <= player.maxHealth*menu.posion.health*0.01 and player.mana <= player.maxMana*menu.posion.mana*0.01 and flask_potion_time+12 < os.clock() then
			CastItem(2041)
			flask_potion_time = os.clock()
		end
		if GetInventoryItemIsCastable(2003) and myHero.health/myHero.maxHealth*100 <=menu.posion.health and health_potion_time+15 < os.clock() then
			CastItem(2003)
			health_potion_time = os.clock()
		end
		if GetInventoryItemIsCastable(2004) and myHero.mana/myHero.maxMana*100 <=menu.posion.mana and mana_potion_time+15 < os.clock() then
			CastItem(2004)
			mana_potion_time = os.clock()
		end
	end
end