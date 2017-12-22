if myHero.charName ~= "LeeSin" then return end

require "DamageLib"
require "RepositoryLib"

local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local Q = {range = 1100, speed = 1750, delay = 0.25, width = 80}
local W = {range = 700}
local E = {range = 350}
local R = {range = 375}
local Flash = {range = 425}

local icon = {	Lee = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/LeeSin.png",
				P = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/Flurry.png",
				Q = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/SonicWave.png",
				Q2 = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/ResonatingStrike.png",
				W = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/Safeguard.png",
				W2 = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/IronWill.png",
				E = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/Tempest.png",
				E2 = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/Cripple.png",
				R = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/LeeSin/DragonsRage.png",
				Ward = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/Item/Ward.png",
				Flash = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/Item/Flash.png" }

local function Qdmg(target)
    if Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
        return CalcPhysicalDamage(myHero,target,(25 + 30 * myHero:GetSpellData(_Q).level + 0.9 * myHero.bonusDamage))
    end
    return 0
end

local function Q2dmg(target)
    if Ready(_Q) then
        return CalcPhysicalDamage(myHero,target,(25 + 30 * myHero:GetSpellData(_Q).level + 0.9 * myHero.bonusDamage + (0.08 * (target.maxHealth - (target.health - Qdmg(target))))))
    end
    return 0
end

local function Edmg(target)
    if Ready(_E) then
        return CalcMagicalDamage(myHero,target,(35 + 35 * myHero:GetSpellData(_E).level + myHero.bonusDamage))
    end
    return 0
end

local function Rdmg(target)
    if Ready(_R) then
        return CalcPhysicalDamage(myHero,target,(150 * myHero:GetSpellData(_R).level + 2 * myHero.bonusDamage))
    end
    return 0
end

local HKITEM = {
	[ITEM_1] = HK_ITEM_1,
	[ITEM_2] = HK_ITEM_2,
	[ITEM_3] = HK_ITEM_3,
	[ITEM_4] = HK_ITEM_4,
	[ITEM_5] = HK_ITEM_5,
	[ITEM_6] = HK_ITEM_6,
	[ITEM_7] = HK_ITEM_7,
}

local RLee = MenuElement({type = MENU, id = "RLee", name = "Repository 7.24", leftIcon = "https://raw.githubusercontent.com/RomanovHD/ExternalRepository/master/RepoLogo.png"})

RLee:MenuElement({id = "Me", name = "Lee Sin", drop = {"v2.0"}, leftIcon = icon.Lee})
RLee:MenuElement({id = "Combo", name = "Combo", type = MENU})
	RLee.Combo:MenuElement({id = "Q", name = "Q - Sonic Wave", value = true, leftIcon = icon.Q})
	RLee.Combo:MenuElement({id = "Q2", name = "Q - Resonating Strike", value = true, leftIcon = icon.Q2})
	RLee.Combo:MenuElement({id = "W", name = "W - Safeguard", value = true, leftIcon = icon.W})
	RLee.Combo:MenuElement({id = "W2", name = "W - Iron Will", value = true, leftIcon = icon.W2})
	RLee.Combo:MenuElement({id = "E", name = "E - Tempest", value = true, leftIcon = icon.E})
	RLee.Combo:MenuElement({id = "E2", name = "E - Cripple", value = true, leftIcon = icon.E2})
	RLee.Combo:MenuElement({id = "R", name = "R - Dragon's Rage", value = true, leftIcon = icon.R})
	RLee.Combo:MenuElement({id = "P", name = "P - Flurry", value = true, leftIcon = icon.P})

RLee:MenuElement({id = "Harass", name = "Harass", type = MENU})
	RLee.Harass:MenuElement({id = "Q", name = "Q - Sonic Wave", value = true, leftIcon = icon.Q})
	RLee.Harass:MenuElement({id = "Q2", name = "Q - Resonating Strike", value = false, leftIcon = icon.Q2})
	RLee.Harass:MenuElement({id = "W", name = "W - Safeguard", value = true, leftIcon = icon.W})
	RLee.Harass:MenuElement({id = "W2", name = "W - Iron Will", value = true, leftIcon = icon.W2})
	RLee.Harass:MenuElement({id = "E", name = "E - Tempest", value = true, leftIcon = icon.E})
	RLee.Harass:MenuElement({id = "E2", name = "E - Cripple", value = true, leftIcon = icon.E2})
	RLee.Harass:MenuElement({id = "P", name = "P - Flurry", value = true, leftIcon = icon.P})
	RLee.Harass:MenuElement({id = "MP", name = "Min energy", value = 35, min = 0, max = 100})
	RLee.Harass:MenuElement({id = "Key", name = "Enable/Disable", key = string.byte("S"), toggle = true})

RLee:MenuElement({id = "Clear", name = "Clear", type = MENU})
	RLee.Clear:MenuElement({id = "Q", name = "Q - Sonic Wave", value = true, leftIcon = icon.Q})
	RLee.Clear:MenuElement({id = "Q2", name = "Q - Resonating Strike", value = true, leftIcon = icon.Q2})
	RLee.Clear:MenuElement({id = "W", name = "W - Safeguard", value = true, leftIcon = icon.W})
	RLee.Clear:MenuElement({id = "W2", name = "W - Iron Will", value = true, leftIcon = icon.W2})
    RLee.Clear:MenuElement({id = "WX", name = "Min minions [lane]", value = 4, min = 1, max = 7})
	RLee.Clear:MenuElement({id = "E", name = "E - Tempest", value = true, leftIcon = icon.E})
	RLee.Clear:MenuElement({id = "E2", name = "E - Cripple", value = true, leftIcon = icon.E2})
	RLee.Clear:MenuElement({id = "EX", name = "Min minions [lane]", value = 5, min = 1, max = 7})
	RLee.Clear:MenuElement({id = "P", name = "P - Flurry", value = true, leftIcon = icon.P})
	RLee.Clear:MenuElement({id = "MP", name = "Min energy", value = 35, min = 0, max = 100})
    RLee.Clear:MenuElement({id = "Key", name = "Enable/Disable", key = string.byte("A"), toggle = true})
    
RLee:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
	RLee.Killsteal:MenuElement({id = "Q", name = "Q - Sonic Wave", value = true, leftIcon = icon.Q})
	RLee.Killsteal:MenuElement({id = "Q2", name = "Q - Resonating Strike", value = true, leftIcon = icon.Q2})
    RLee.Killsteal:MenuElement({id = "E", name = "E - Tempest", value = true, leftIcon = icon.E})
	RLee.Killsteal:MenuElement({id = "R", name = "R - Dragon's Rage", value = true, leftIcon = icon.R})

RLee:MenuElement({id = "Flee", name = "Flee", type = MENU})
	RLee.Flee:MenuElement({id = "W", name = "W - Safeguard", value = true, leftIcon = icon.W})
	RLee.Flee:MenuElement({id = "Ward", name = "I - Ward", value = true, leftIcon = icon.Ward})

RLee:MenuElement({id = "Draw", name = "Drawings", type = MENU})
    RLee.Draw:MenuElement({id = "Q", name = "Q - Sonic Wave", value = true, leftIcon = icon.Q})
    RLee.Draw:MenuElement({id = "W", name = "W - Safeguard", value = true, leftIcon = icon.W})
    RLee.Draw:MenuElement({id = "C", name = "Enable Text", value = true})

Callback.Add("Tick", function() Tick() end)
Callback.Add("Draw", function() Drawings() end)

function Tick()
	local Mode = GetMode()
	if Mode == "Combo" then
		Combo()
	elseif Mode == "Harass" then
		Harass()
	elseif Mode == "Clear" then
		Lane()
	elseif Mode == "Flee" then
		Flee()
    end
	Killsteal()
end

function CastQ(target)
	if target.ms ~= 0 and (Q.range - GetDistance(target.pos,myHero.pos))/target.ms <= GetDistance(myHero.pos,target.pos)/(Q.speed + Q.delay) and not IsFacing(target) then return end
	if Ready(_Q) and castSpell.state == 0 and target:GetCollision(Q.width, Q.speed, Q.delay) == 0 then
        if (Game.Timer() - OnWaypoint(target).time < 0.15 or Game.Timer() - OnWaypoint(target).time > 1.0) then
            local qPred = GetPred(target,Q.speed,Q.delay + Game.Latency()/1000)
            CastSpell(HK_Q,qPred,Q.range + 200,250)
        end
	end
end

function Buffed()
	for i = 0, myHero.buffCount do 
    local buff = myHero:GetBuff(i)
		if buff and buff.name == "blindmonkpassive_cosmetic" then 
			return true
		end
	end
	return false
end

function Combo()
    local target = GetTarget(1300)
    if target == nil then return end

    if IsValidTarget(target,R.range) and RLee.Combo.R:Value() and Ready(_R) and Rdmg(target) + Qdmg(target) + Q2dmg(target) + Edmg(target) > target.health then
        Control.CastSpell(HK_R, target)
    end

    if GetDistance(myHero.pos,target.pos) < myHero.range and Buffed() and RLee.Combo.P:Value() then return end
    
	if IsValidTarget(target,Q.range) and RLee.Combo.Q:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
		CastQ(target)
    end
    if IsValidTarget(target,1300) and RLee.Combo.Q2:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" then
        Control.CastSpell(HK_Q)
    end
    if IsValidTarget(target,E.range) and RLee.Combo.E:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkEOne" then
		Control.CastSpell(HK_E)
    end
    if IsValidTarget(target,500) and RLee.Combo.E2:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkETwo" then
		Control.CastSpell(HK_E)
	end
    if IsValidTarget(target,E.range) and RLee.Combo.W:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
		Control.CastSpell(HK_W, myHero)
    end
    if IsValidTarget(target,E.range) and RLee.Combo.W2:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWTwo" then
		Control.CastSpell(HK_W)
	end
end

function Harass()
	local target = GetTarget(Q.range)
	if target == nil then return end
    if myHero.mana < RLee.Harass.MP:Value() * 2 then return end
    if GetDistance(myHero.pos,target.pos) < myHero.range and Buffed() and RLee.Harass.P:Value() then return end
    
	if IsValidTarget(target,Q.range) and RLee.Harass.Q:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
		CastQ(target)
    end
    if IsValidTarget(target,1300) and RLee.Harass.Q2:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" then
        Control.CastSpell(HK_Q)
    end
    if IsValidTarget(target,E.range) and RLee.Harass.E:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkEOne" then
		Control.CastSpell(HK_E)
    end
    if IsValidTarget(target,500) and RLee.Harass.E2:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkETwo" then
		Control.CastSpell(HK_E)
	end
    if IsValidTarget(target,E.range) and RLee.Harass.W:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
		Control.CastSpell(HK_W, myHero)
    end
    if IsValidTarget(target,E.range) and RLee.Harass.W2:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWTwo" then
		Control.CastSpell(HK_W)
	end
end

function Lane()
	if RLee.Clear.Key:Value() == false then return end
	if myHero.mana < RLee.Clear.MP:Value() * 2 then return end
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
        if minion then
        if GetDistance(myHero.pos,minion.pos) < myHero.range and Buffed() and RLee.Clear.P:Value() then return end
			if minion.team == 300 - myHero.team then
				if IsValidTarget(minion,Q.range) and minion:GetCollision(Q.width, Q.speed, Q.delay) == 0 and RLee.Clear.Q:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQOne" and Qdmg(minion) + Q2dmg(minion) > minion.health then
                    Control.CastSpell(HK_Q, minion.pos)
                end
                if IsValidTarget(minion,Q.range) and RLee.Clear.Q2:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" then
                    Control.CastSpell(HK_Q)
                end
                if MinionsAround(myHero.pos, E.range, 300 - myHero.team) >= RLee.Clear.EX:Value() and RLee.Clear.E:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkEOne" then
                    Control.CastSpell(HK_E)
                end
                if IsValidTarget(minion,500) and RLee.Clear.E2:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkETwo" then
                    Control.CastSpell(HK_E)
                end
                if MinionsAround(myHero.pos, E.range, 300 - myHero.team) >= RLee.Clear.WX:Value() and RLee.Clear.W:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
                    Control.CastSpell(HK_W, myHero)
                end
                if IsValidTarget(minion,E.range) and RLee.Clear.W2:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWTwo" then
                    Control.CastSpell(HK_W)
                end
			end
			if minion.team == 300 then
				if IsValidTarget(minion,Q.range) and minion:GetCollision(Q.width, Q.speed, Q.delay) == 0 and RLee.Clear.Q:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQOne" then
                    Control.CastSpell(HK_Q, minion.pos)
                end
                if IsValidTarget(minion,Q.range) and RLee.Clear.Q2:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQTwo" then
                    Control.CastSpell(HK_Q)
                end
                if IsValidTarget(minion,E.range) and RLee.Clear.E:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkEOne" then
                    Control.CastSpell(HK_E)
                end
                if IsValidTarget(minion,500) and RLee.Clear.E2:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkETwo" then
                    Control.CastSpell(HK_E)
                end
                if IsValidTarget(minion,E.range) and RLee.Clear.W:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
                    Control.CastSpell(HK_W, myHero)
                end
                if IsValidTarget(minion,E.range) and RLee.Clear.W2:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWTwo" then
                    Control.CastSpell(HK_W)
                end
			end
		end
	end
end

function Killsteal()
    local target = GetTarget(Q.range)
    if target == nil then return end

	if IsValidTarget(target,E.range) and RLee.Killsteal.E:Value() and Ready(_E) and myHero:GetSpellData(_E).name == "BlindMonkEOne" and Edmg(target) > target.health then
        Control.CastSpell(HK_E)
    end
	if IsValidTarget(target,Q.range) and RLee.Killsteal.Q2:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQOne" and Qdmg(target) + Q2dmg(target) > target.health then
		CastQ(target)
		Control.CastSpell(HK_Q)
    end
    if IsValidTarget(target,Q.range) and RLee.Killsteal.Q:Value() and Ready(_Q) and myHero:GetSpellData(_Q).name == "BlindMonkQOne" and Qdmg(target) > target.health then
        CastQ(target)
	end
    if IsValidTarget(target,R.range) and RLee.Killsteal.R:Value() and Ready(_R) and Rdmg(target) > target.health then
        Control.CastSpell(HK_R,target)
    end
end

function Flee()
	local Wally = GetFleeHero(W.range)
	local Wminion = GetFleeMinion(W.range,myHero.team)
	if RLee.Flee.W:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWOne" and Wally then
		Control.CastSpell(HK_W, Wally.pos)
	end
	if RLee.Flee.W:Value() and Ready(_W) and myHero:GetSpellData(_W).name == "BlindMonkWOne" and Wminion then
		Control.CastSpell(HK_W, Wminion.pos)
	end
end

function Drawings()
    if myHero.dead then return end
    if RLee.Draw.Q:Value() and Ready(_Q) then Draw.Circle(myHero.pos, Q.range, 3,  Draw.Color(255, 000, 222, 255)) end
    if RLee.Draw.W:Value() and Ready(_W) then Draw.Circle(myHero.pos, W.range, 3,  Draw.Color(255, 255, 200, 000)) end
	
	if RLee.Draw.C:Value() then
		local textPos = myHero.pos:To2D()
		if RLee.Harass.Key:Value() then
			Draw.Text("HARASS ENABLED", 20, textPos.x - 57, textPos.y + 60, Draw.Color(255, 000, 255, 000)) 
		else
			Draw.Text("HARASS DISABLED", 20, textPos.x - 57, textPos.y + 60, Draw.Color(255, 225, 000, 000)) 
		end
		if RLee.Clear.Key:Value() then
			Draw.Text("CLEAR ENABLED", 20, textPos.x - 57, textPos.y + 40, Draw.Color(255, 000, 255, 000)) 
		else
			Draw.Text("CLEAR DISABLED", 20, textPos.x - 57, textPos.y + 40, Draw.Color(255, 225, 000, 000)) 
		end
    end
end
