if myHero.charName ~= "Katarina" then return end

require "DamageLib"
require "RepositoryLib"

local Passive = {radius = 340}
local Q = {range = 625}
local W = {radius = 135}
local E = {range = 725}
local R = {range = 550}
local HG = {range = 700}
local BC = {range = 550}
local EX = {range = 650}
local IG = {range = 600}

local function Qdmg(target)
    if Ready(_Q) then
        return CalcMagicalDamage(myHero,target,(45 + 30 * myHero:GetSpellData(_Q).level + 0.3 * myHero.ap))
    end
    return 0
end

local function Edmg(target)
    if Ready(_E) then
        return CalcMagicalDamage(myHero,target,(15 * myHero:GetSpellData(_E).level + 0.5 * myHero.totalDamage + 0.25 * myHero.ap))
    end
    return 0
end

local function Rdmg(target)
    if Ready(_R) then
        return CalcMagicalDamage(myHero,target,(187.5 + 187.5 * myHero:GetSpellData(_R).level + 3.3 * myHero.bonusDamage + 2.85 * myHero.ap/2.5 * 0.9))
    end
    return 0
end

local function HGdmg(target)
    return CalcMagicalDamage(myHero,target,(170.5 + 4.5 * myHero.levelData.lvl + 0.3 * myHero.ap))
end

local function BCdmg(target)
    return CalcMagicalDamage(myHero,target,(100))
end

local function Ignitedmg(target)
    return 70 + 20 * myHero.levelData.lvl
end

local function Spinning()
	for i = 0, myHero.buffCount do 
    local buff = myHero:GetBuff(i)
		if buff.name == "katarinarsound" then 
			return true
		end
	end
	return false
end

local function HeroesAround(pos, range, team)
	local Count = 0
	for i = 1, Game.HeroCount() do
		local minion = Game.Hero(i)
		if minion and minion.team == team and not minion.dead and pos:DistanceTo(minion.pos) <= range then
			Count = Count + 1
		end
	end
	return Count
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

local RepoKatarina = MenuElement({type = MENU, id = "RepoKatarina", name = "Roman Repo 7.24", leftIcon = "https://raw.githubusercontent.com/RomanovHD/GOSext/master/Repository/Screenshot_1.png"})

RepoKatarina:MenuElement({id = "Me", name = "Katarina", drop = {"v4.0"}})
RepoKatarina:MenuElement({id = "Core", name = " ", drop = {"Champion Core"}})
RepoKatarina:MenuElement({id = "Combo", name = "Combo", type = MENU})
    RepoKatarina.Combo:MenuElement({id = "Q", name = "Q - Bouncing Blade", value = true})
    RepoKatarina.Combo:MenuElement({id = "W", name = "W - Preparation", value = true})
    RepoKatarina.Combo:MenuElement({id = "E", name = "E - Shunpo", value = true})
	RepoKatarina.Combo:MenuElement({id = "R", name = "R - Death Lotus", value = true})
	RepoKatarina.Combo:MenuElement({id = "RAoE", name = "X enemies to R", value = 3, min = 2, max = 6})
    RepoKatarina.Combo:MenuElement({id = "HG", name = "Item - Hextech Gunblade", value = true})
    if myHero:GetSpellData(SUMMONER_1).name == "SummonerDot"
	or myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" then
        RepoKatarina.Combo:MenuElement({id = "IG", name = "Spell - Ignite", value = true})
    end
    if myHero:GetSpellData(SUMMONER_1).name == "SummonerExhaust"
	or myHero:GetSpellData(SUMMONER_2).name == "SummonerExhaust" then
        RepoKatarina.Combo:MenuElement({id = "EX", name = "Spell - Exhaust", value = true})
	end

RepoKatarina:MenuElement({id = "Harass", name = "Harass", type = MENU})
    RepoKatarina.Harass:MenuElement({id = "Q", name = "Q - Bouncing Blade", value = true})
    RepoKatarina.Harass:MenuElement({id = "W", name = "W - Preparation", value = true})
	RepoKatarina.Harass:MenuElement({id = "E", name = "E - Shunpo", value = true})
	RepoKatarina.Harass:MenuElement({id = "X", name = "Block E into minion wave", value = 5, min = 0, max = 7})

RepoKatarina:MenuElement({id = "Clear", name = "Clear", type = MENU})
	RepoKatarina.Clear:MenuElement({id = "Q", name = "Q - Bouncing Blade", value = true})
	RepoKatarina.Clear:MenuElement({id = "QX", name = "Minions [for lane]", value = 3, min = 1, max = 3})
	RepoKatarina.Clear:MenuElement({id = "W", name = "W - Preparation", value = true})
	RepoKatarina.Clear:MenuElement({id = "WX", name = "Minions [for lane]", value = 5, min = 1, max = 7})
	RepoKatarina.Clear:MenuElement({id = "E", name = "E - Shunpo [Jungle only]", value = true})
	RepoKatarina.Clear:MenuElement({id = "Key", name = "Enable/Disable", key = string.byte("A"), toggle = true})

RepoKatarina:MenuElement({id = "Killsteal", name = "Killsteal", type = MENU})
    RepoKatarina.Killsteal:MenuElement({id = "Q", name = "Q - Bouncing Blade", value = true})
	RepoKatarina.Killsteal:MenuElement({id = "E", name = "E - Shunpo", value = true})
	RepoKatarina.Killsteal:MenuElement({id = "R", name = "R - Death Lotus", value = true})

RepoKatarina:MenuElement({id = "Flee", name = "Flee", type = MENU})
    RepoKatarina.Flee:MenuElement({id = "W", name = "W - Preparation", value = true})
	RepoKatarina.Flee:MenuElement({id = "E", name = "E - Shunpo", value = true})

RepoKatarina:MenuElement({id = "Draw", name = "Drawings", type = MENU})
    RepoKatarina.Draw:MenuElement({id = "Q", name = "Q - Bouncing Blade", value = true})
    RepoKatarina.Draw:MenuElement({id = "E", name = "E - Shunpo", value = true})
    RepoKatarina.Draw:MenuElement({id = "R", name = "R - Death Lotus", value = true})
    RepoKatarina.Draw:MenuElement({id = "C", name = "Enable Text", value = true})

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
	Activator()
    CancelR()
    RebootOrb()
end

function CancelR()
    if HeroesAround(myHero.pos, 550, 300 - myHero.team) == 0 and Spinning() then
		EnableOrb(true)
    end
end

function RebootOrb()
    if Spinning() == false then
		EnableOrb(true)
    end
end

lastW = Game.Timer()
lastR = Game.Timer()
function Combo()
    local target = GetTarget(E.range + Passive.radius)
	if target == nil then return end

    if IsValidTarget(target,W.radius + Passive.radius/2) and RepoKatarina.Combo.W:Value() and Ready(_W) then
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
		Control.CastSpell(HK_W)
        lastW = Game.Timer()
    end
    
	if IsValidTarget(target,Q.range) and RepoKatarina.Combo.Q:Value() and Ready(_Q) then
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
        if GetDistance(myHero.pos,target.pos) < 500 then
            if myHero:GetSpellData(_W).level ~= 0 then
                if Game.Timer() - lastW > 1.25 then
                    Control.CastSpell(HK_Q,target)
                end
            else
                Control.CastSpell(HK_Q,target)
            end
        else
            Control.CastSpell(HK_Q,target)
        end
    end

    if IsValidTarget(target,E.range + Passive.radius) and RepoKatarina.Combo.E:Value() and Ready(_E) then
       	if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
		if GetDistance(myHero.pos,target.pos) < E.range then
            if myHero:GetSpellData(_Q).level ~= 0 then
                if GetDistance(myHero.pos,target.pos) < Q.range then
                    if myHero:GetSpellData(_Q).currentCd >= 2 then
                        Control.CastSpell(HK_E,target)
                    end
                elseif GetDistance(myHero.pos,target.pos) > Q.range then
                    Control.CastSpell(HK_E,target)
                end
            else
                Control.CastSpell(HK_E,target)
            end
        end
    end

    if IsValidTarget(target,R.range) and RepoKatarina.Combo.R:Value() and Game.CanUseSpell(_R) == 0 then
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
        if (R.range - target.distance)/target.ms * Rdmg(target) >= target.health and Rdmg(target) * 2.5 > target.health then
            EnableOrb(false)
			Control.CastSpell(HK_R)
			lastR = Game.Timer()
		end
		if RepoKatarina.Combo.RAoE:Value() <= HeroesAround(myHero.pos, R.range, 300 - myHero.team) then
			EnableOrb(false)
			Control.CastSpell(HK_R)
			lastR = Game.Timer()
		end
    end
end

function Harass()
	local target = GetTarget(E.range + Passive.radius)
	if target == nil then return end

    if IsValidTarget(target,W.radius + Passive.radius/2) and RepoKatarina.Harass.W:Value() and Ready(_W) then
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
		Control.CastSpell(HK_W)
        lastW = Game.Timer()
    end
    
	if IsValidTarget(target,Q.range) and RepoKatarina.Harass.Q:Value() and Ready(_Q) then
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
        if GetDistance(myHero.pos,target.pos) < 500 then
            if myHero:GetSpellData(_W).level ~= 0 then
                if Game.Timer() - lastW > 1.25 then
                    Control.CastSpell(HK_Q,target)
                end
            else
                Control.CastSpell(HK_Q,target)
            end
        else
            Control.CastSpell(HK_Q,target)
        end
    end

    if IsValidTarget(target,E.range + Passive.radius) and RepoKatarina.Harass.E:Value() and Ready(_E) then
        if IsUnderTurret(target) or MinionsAround(target.pos, 550, 300 - myHero.team) >= RepoKatarina.Harass.X:Value() or PercentHP(myHero) <= PercentHP(target) + 15 then return end
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
		if GetDistance(myHero.pos,target.pos) < E.range then
            if myHero:GetSpellData(_Q).level ~= 0 then
                if GetDistance(myHero.pos,target.pos) < Q.range then
                    if myHero:GetSpellData(_Q).currentCd >= 2 then
                        Control.CastSpell(HK_E,target)
                    end
                elseif GetDistance(myHero.pos,target.pos) > Q.range then
                    Control.CastSpell(HK_E,target)
                end
            else
                Control.CastSpell(HK_E,target)
            end
        end
    end
end

function Lane()
	if RepoKatarina.Clear.Key:Value() == false then return end
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if minion then
			if minion.team == 300 - myHero.team then
				if IsValidTarget(minion,Q.range) and RepoKatarina.Clear.Q:Value() and Ready(_Q) and MinionsAround(minion.pos, 300, 300 - myHero.team) >= RepoKatarina.Clear.QX:Value() then
					Control.CastSpell(HK_Q,minion)
				end
				if RepoKatarina.Clear.W:Value() and Ready(_W) and MinionsAround(myHero.pos, Passive.radius, 300 - myHero.team) >= RepoKatarina.Clear.WX:Value() then
					Control.CastSpell(HK_W)
				end
			end
			if minion.team == 300 then
				if IsValidTarget(minion,Q.range) and RepoKatarina.Clear.Q:Value() and Ready(_Q) then
					Control.CastSpell(HK_Q,minion)
				end
				if IsValidTarget(minion,Passive.radius) and RepoKatarina.Clear.W:Value() and Ready(_W) then
					Control.CastSpell(HK_W)
				end
				if IsValidTarget(minion,E.range) and RepoKatarina.Clear.E:Value() and Ready(_E) then
					Control.CastSpell(HK_E,minion)
				end
			end
		end
	end
end

function Killsteal()
    local target = GetTarget(E.range)
	if target == nil then return end
    
	if IsValidTarget(target,Q.range) and RepoKatarina.Killsteal.Q:Value() and Ready(_Q) then
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
        if Qdmg(target) > target.health then
            Control.CastSpell(HK_Q,target)
        end
    end

    if IsValidTarget(target,E.range) and RepoKatarina.Killsteal.E:Value() and Ready(_E) then
       	if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
		if Edmg(target) > target.health then
			Control.CastSpell(HK_E,target)
        end
    end

    if IsValidTarget(target,R.range) and RepoKatarina.Killsteal.R:Value() and Game.CanUseSpell(_R) == 0 then
		if Game.Timer() - lastR < 2.5 and HeroesAround(myHero.pos, R.range, 300 - myHero.team) ~= 0 then return end
        if (R.range - target.distance)/target.ms * Rdmg(target) >= target.health and Rdmg(target) * 2.5 > target.health then
            EnableOrb(false)
			Control.CastSpell(HK_R)
			lastR = Game.Timer()
		end
    end
end

function Flee()
	local Eally = GetFleeHero(E.range)
	local Eminion = GetFleeMinion(E.range,myHero.team)
	if RepoKatarina.Flee.E:Value() and Ready(_E) and Eally then
		Control.CastSpell(HK_E, Eally.pos)
	end
	if RepoKatarina.Flee.E:Value() and Ready(_E) and Eminion then
		Control.CastSpell(HK_E, Eminion.pos)
	end

	if RepoKatarina.Flee.W:Value() and Ready(_W) then
		Control.CastSpell(HK_W)
	end
end

function Activator()
	local target = GetTarget(E.range + Passive.radius)
	local items = {}
	for slot = ITEM_1,ITEM_6 do
		local id = myHero:GetItemData(slot).itemID 
		if id > 0 then
			items[id] = slot
		end
    end
    if GetMode() == "Combo" then
    if target == nil then return end
        local HG = items[3146]
        if HG and myHero:GetSpellData(HG).currentCd == 0 and RepoKatarina.Combo.HG:Value() and GetDistance(myHero.pos,target.pos) < R.range then
            if Game.CanUseSpell(_R) == 0 and (R.range - target.distance)/(0.6 * target.ms) * Rdmg(target) + HGdmg(target) >= target.health and Rdmg(target) * 2.5 + HGdmg(target) >= target.health then
                Control.CastSpell(HKITEM[HG], target)
            end
        end
        local BC = items[3144]
        if BC and myHero:GetSpellData(BC).currentCd == 0 and RepoKatarina.Combo.HG:Value() and GetDistance(myHero.pos,target.pos) < R.range then
            if Game.CanUseSpell(_R) == 0 and (R.range - target.distance)/(0.75 * target.ms) * Rdmg(target) + BCdmg(target) >= target.health and Rdmg(target) * 2.5 + BCdmg(target) >= target.health then
                Control.CastSpell(HKITEM[BC], target)
            end
        end
        if myHero:GetSpellData(SUMMONER_1).name == "SummonerDot"
		or myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" then
			if RepoKatarina.Combo.IG:Value() then
				local IgDamage = (R.range - target.distance)/target.ms * Rdmg(target) + IGdmg(target)
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerDot" and Ready(SUMMONER_1) and IgDamage > target.health and Rdmg(target) * 2.5 + IGdmg(target) >= target.health 
				and Game.CanUseSpell(_R) == 0 then
					Control.CastSpell(HK_SUMMONER_1, target)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" and Ready(SUMMONER_2) and IgDamage > target.health and Rdmg(target) * 2.5 + IGdmg(target) >= target.health 
				and Game.CanUseSpell(_R) == 0 then
					Control.CastSpell(HK_SUMMONER_2, target)
				end
			end
		end
		if myHero:GetSpellData(SUMMONER_1).name == "SummonerExhaust"
		or myHero:GetSpellData(SUMMONER_2).name == "SummonerExhaust" then
			if RepoKatarina.Combo.EX:Value() then
				local Damage = (R.range - target.distance)/(0.7 * target.ms) * Rdmg(target)
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerExhaust" and Ready(SUMMONER_1) and Damage > target.health and Rdmg(target) * 2.5 >= target.health 
				and Game.CanUseSpell(_R) == 0 then
					Control.CastSpell(HK_SUMMONER_1, target)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerExhaust" and Ready(SUMMONER_2) and Damage > target.health and Rdmg(target) * 2.5 >= target.health 
				and Game.CanUseSpell(_R) == 0 then
					Control.CastSpell(HK_SUMMONER_2, target)
				end
			end
		end
    end
end

function Drawings()
    if myHero.dead then return end
	if RepoKatarina.Draw.Q:Value() and Ready(_Q) then Draw.Circle(myHero.pos, Q.range, 3,  Draw.Color(255, 000, 222, 255)) end
	if RepoKatarina.Draw.E:Value() and Ready(_E) then Draw.Circle(myHero.pos, E.range, 3,  Draw.Color(255, 000, 043, 255)) end
	if RepoKatarina.Draw.R:Value() and Ready(_R) then Draw.Circle(myHero.pos, R.range, 3,  Draw.Color(255, 246, 000, 255)) end
	if RepoKatarina.Draw.C:Value() then
		local textPos = myHero.pos:To2D()
		if RepoKatarina.Clear.Key:Value() then
			Draw.Text("CLEAR ENABLED", 20, textPos.x - 57, textPos.y + 40, Draw.Color(255, 000, 255, 000)) 
		else
			Draw.Text("CLEAR DISABLED", 20, textPos.x - 57, textPos.y + 40, Draw.Color(255, 225, 000, 000)) 
		end
	end
end
