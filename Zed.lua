if myHero.charName ~= "Zed" then return end

local _shadowPos = myHero.pos

require "DamageLib"
require "RepositoryLib"

local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
local Q = {range = 900, speed = 900, width = 70, delay = 0.25}
local W = {range = 650, speed = 1750, swaprange = 1300, delay = 0.25}
local E = {range = 290}
local R = {range = 625}
local BOTRK = {range = 550}
local EX = {range = 650}
local IG = {range = 600}

local HKITEM = {
	[ITEM_1] = HK_ITEM_1,
	[ITEM_2] = HK_ITEM_2,
	[ITEM_3] = HK_ITEM_3,
	[ITEM_4] = HK_ITEM_4,
	[ITEM_5] = HK_ITEM_5,
	[ITEM_6] = HK_ITEM_6,
	[ITEM_7] = HK_ITEM_7,
}

local function Qdmg(target)
    if Ready(_Q) then
        if Ready(_W) and GetDistance(myHero.pos,target.pos) < 900 and target:GetCollision(70, 900, 0.25) == 0 then
            return CalcPhysicalDamage(myHero,target,(45 + 35 * myHero:GetSpellData(_Q).level + 0.9 * myHero.bonusDamage) * 1.75 )
        elseif Ready(_W) and GetDistance(myHero.pos,target.pos) < 900 and target:GetCollision(70, 900, 0.25) ~= 0 then
            return CalcPhysicalDamage(myHero,target,(45 + 35 * myHero:GetSpellData(_Q).level + 0.9 * myHero.bonusDamage) * 1.75 * 0.6 )
        elseif not Ready(_W) and target:GetCollision(70, 900, 0.25) == 0 then
            return CalcPhysicalDamage(myHero,target,(45 + 35 * myHero:GetSpellData(_Q).level + 0.9 * myHero.bonusDamage))
        elseif not Ready(_W) and target:GetCollision(70, 900, 0.25) ~= 0 then
            return CalcPhysicalDamage(myHero,target,(45 + 35 * myHero:GetSpellData(_Q).level + 0.9 * myHero.bonusDamage * 0.6))
        end
    end
    return 0
end

local function Edmg(target)
    if Ready(_E) then
        return CalcPhysicalDamage(myHero,target,(45 + 25 * myHero:GetSpellData(_E).level + 0.8 * myHero.bonusDamage))
    end
    return 0
end

local function Passivedmg(target)
	for i = 0, target.buffCount do
		local buff = target:GetBuff(i)
		if buff.name == "zedpassivecd" then
			return 0
		end
	end
	if myHero.levelData.lvl >= 17 then
		return CalcMagicalDamage(myHero,target,(target.maxHealth * 0.1))
	elseif myHero.levelData.lvl >= 7 then
		return CalcMagicalDamage(myHero,target,(target.maxHealth * 0.08))
	else
		return CalcMagicalDamage(myHero,target,(target.maxHealth * 0.06))
	end
end

local function ComboAA(target)
	local AAdmg = CalcPhysicalDamage(myHero,target,(myHero.totalDamage))
	if myHero.attackSpeed >= 2.5 then
		return AAdmg * 5
	elseif myHero.attackSpeed >= 2 then
		return AAdmg * 4
	elseif myHero.attackSpeed >= 1.5 then
		return AAdmg * 3
	elseif myHero.attackSpeed >= 1 then
		return AAdmg * 2
	else
		return AAdmg
	end
end

local function ELdmg(target)
    for i = 0, myHero.buffCount do
		local buff = myHero:GetBuff(i)
		if buff and buff.name == "ASSETS/Perks/Styles/Domination/TLords/TLords.lua" then
			return CalcPhysicalDamage(myHero,target,(40 + 10 * myHero.levelData.lvl + 0.5 * myHero.bonusDamage + 0.3 * myHero.ap))
		end
    end
    return 0
end

local function BOTRKdmg(target)
    local items = {}
	for slot = ITEM_1,ITEM_6 do
		local id = myHero:GetItemData(slot).itemID 
		if id > 0 then
			items[id] = slot
		end
    end

    local BOTRK = items[3144] or items[3153]
    if BOTRK and myHero:GetSpellData(BOTRK).currentCd == 0 then
        return CalcMagicalDamage(myHero,target,(100))
    end
    return 0
end

local function Ignitedmg(target)
    if (myHero:GetSpellData(SUMMONER_1).name == "SummonerDot" and Ready(SUMMONER_1))
    or (myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" and Ready(SUMMONER_2)) then
        return 70 + 20 * myHero.levelData.lvl
    end
    return 0
end

local function Rdmg(target)
    if Ready(_R) then
        return CalcPhysicalDamage(myHero,target,(myHero.totalDamage + (0.15 + 0.10 * myHero:GetSpellData(_R).level) * (Passivedmg(target) + Qdmg(target) + Edmg(target) + Ignitedmg(target) * 0.5 + BOTRKdmg(target) + ELdmg(target) + ComboAA(target)) ))
    end
    return 0
end

local RepoZed = MenuElement({type = MENU, id = "RepoZed", name = "Roman Repo 7.24", leftIcon = "https://raw.githubusercontent.com/RomanovHD/GOSext/master/Repository/Screenshot_1.png"})

RepoZed:MenuElement({id = "Me", name = "Zed", drop = {"v4.0"}})
RepoZed:MenuElement({id = "Core", name = " ", drop = {"Champion Core"}})
RepoZed:MenuElement({id = "Combo", name = "Combo", type = MENU})
	RepoZed.Combo:MenuElement({id = "Q", name = "Q - Razor Shuriken", value = true})
	RepoZed.Combo:MenuElement({id = "W", name = "W - Living Shadow", value = true})
	RepoZed.Combo:MenuElement({id = "E", name = "E - Shadow Slash", value = true})
	RepoZed.Combo:MenuElement({id = "R", name = "R - Death Mark", value = true})
	RepoZed.Combo:MenuElement({id = "BOTRK", name = "Item - Blade of the Ruined King", value = true})
	if myHero:GetSpellData(SUMMONER_1).name == "SummonerDot"
	or myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" then
		RepoZed.Combo:MenuElement({id = "IG", name = "Spell - Ignite", value = true})
	end
	if myHero:GetSpellData(SUMMONER_1).name == "SummonerExhaust"
	or myHero:GetSpellData(SUMMONER_2).name == "SummonerExhaust" then
		RepoZed.Combo:MenuElement({id = "EX", name = "Spell - Exhaust", value = true})
	end

RepoZed:MenuElement({id = "Harass", name = "Harass", type = MENU})
	RepoZed.Harass:MenuElement({id = "Q", name = "Q - Razor Shuriken", value = true})
	RepoZed.Harass:MenuElement({id = "W", name = "W - Living Shadow", value = true})
	RepoZed.Harass:MenuElement({id = "E", name = "E - Shadow Slash", value = true})
	RepoZed.Harass:MenuElement({id = "MP", name = "Min energy", value = 35, min = 0, max = 100})

RepoZed:MenuElement({id = "Flee", name = "Flee", type = MENU})
	RepoZed.Flee:MenuElement({id = "W", name = "W - Living Shadow", value = true})

RepoZed:MenuElement({id = "Clear", name = "Clear", type = MENU})
	RepoZed.Clear:MenuElement({id = "Q", name = "Q - Razor Shuriken", value = true})
	RepoZed.Clear:MenuElement({id = "W", name = "W - Living Shadow", value = true})
	RepoZed.Clear:MenuElement({id = "WX", name = "Minions [for lane]", value = 5, min = 1, max = 7})
	RepoZed.Clear:MenuElement({id = "E", name = "E - Shadow Slash", value = true})
	RepoZed.Clear:MenuElement({id = "EX", name = "Minions [for lane]", value = 5, min = 1, max = 7})
	RepoZed.Clear:MenuElement({id = "MP", name = "Min energy", value = 35, min = 0, max = 100})
	RepoZed.Clear:MenuElement({id = "Key", name = "Enable/Disable", key = string.byte("A"), toggle = true})

RepoZed:MenuElement({id = "Draw", name = "Drawings", type = MENU})
    RepoZed.Draw:MenuElement({id = "Q", name = "Q - Razor Shuriken", value = true})
    RepoZed.Draw:MenuElement({id = "W", name = "W - Living Shadow", value = true})
    RepoZed.Draw:MenuElement({id = "E", name = "E - Shadow Slash", value = true})
    RepoZed.Draw:MenuElement({id = "R", name = "R - Death Mark", value = true})
    RepoZed.Draw:MenuElement({id = "C", name = "Enable Text", value = true})

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
	Activator()
end

function CastQ(target,from)
	if Ready(_Q) and castSpell.state == 0 then
        if (Game.Timer() - OnWaypoint(target).time < 0.15 or Game.Timer() - OnWaypoint(target).time > 1.0) then
            local qPred = GetPred(target,Q.speed,Q.delay + Game.Latency()/1000,from)
            CastSpell(HK_Q,qPred,Q.range + 200,250)
        end
	end
end

function CastW(target)
	if Ready(_W) and castSpell.state == 0 then
        if (Game.Timer() - OnWaypoint(target).time < 0.15 or Game.Timer() - OnWaypoint(target).time > 1.0) then
            local wPred = GetPred(target,W.speed,W.delay + Game.Latency()/1000)
			CastSpell(HK_W,wPred,W.range + 200,250)
			_shadowPos = wPred
        end
	end
end

function Combo()
    local target = GetTarget(Q.range + W.range)
    if target == nil then return end
    
    if IsValidTarget(target,R.range) and Ready(_R) and RepoZed.Combo.R:Value() and Passivedmg(target) + ELdmg(target) + ComboAA(target) + Qdmg(target) + Edmg(target) + Ignitedmg(target) + BOTRKdmg(target) + Rdmg(target) > target.health and myHero:GetSpellData(_R).toggleState == 0 then
		Control.CastSpell(HK_R,target)
	end
	if IsValidTarget(target,W.range + E.range) and RepoZed.Combo.W:Value() and Ready(_W) and myHero:GetSpellData(_W).toggleState == 0 then
		if not Ready(_Q) and not Ready(_E) then return end
		CastW(target)
	end
	if RepoZed.Combo.E:Value() and Ready(_E) then
		if (HeroesAround(_shadowPos, 290, 300 - myHero.team) >= 1 and myHero:GetSpellData(_W).toggleState == 2)
		or HeroesAround(myHero.pos, 290, 300 - myHero.team) >= 1 then
			Control.CastSpell(HK_E)
		end
	end
	if myHero:GetSpellData(_W).toggleState == 2 and GetDistance(_shadowPos,target.pos) < GetDistance(myHero.pos,target.pos) then
		_shadowPos = myHero.pos
		Control.CastSpell(HK_W)
	end
	if IsValidTarget(target,Q.range + W.range) and RepoZed.Combo.Q:Value() and Ready(_Q) then
		if Ready(_W) and myHero:GetSpellData(_W).toggleState == 0 then return end
		if GetDistance(target.pos,_shadowPos) >= GetDistance(target.pos,myHero.pos) then
			if GetDistance(target.pos,myHero.pos) <= Q.range then
				CastQ(target,myHero.pos)
			end
		else
			if GetDistance(target.pos,_shadowPos) <= Q.range then
				CastQ(target,_shadowPos)
			end
		end
	end
end

function Harass()
	local target = GetTarget(Q.range + W.range)
	if target == nil then return end
	if myHero.mana < RepoZed.Harass.MP:Value() * 2 then return end

	if IsValidTarget(target,W.range + E.range) and RepoZed.Harass.W:Value() and Ready(_W) and myHero:GetSpellData(_W).toggleState == 0 then
		if not Ready(_Q) and not Ready(_E) then return end
		CastW(target)
	end
	if RepoZed.Harass.E:Value() and Ready(_E) then
		if (HeroesAround(_shadowPos, 290, 300 - myHero.team) >= 1 and myHero:GetSpellData(_W).toggleState == 2)
		or HeroesAround(myHero.pos, 290, 300 - myHero.team) >= 1 then
			Control.CastSpell(HK_E)
		end
	end
	if IsValidTarget(target,Q.range) and RepoZed.Harass.Q:Value() and Ready(_Q) then
		if Ready(_W) and myHero:GetSpellData(_W).toggleState == 0 then return end
		if GetDistance(target.pos,_shadowPos) >= GetDistance(target.pos,myHero.pos) then
			if GetDistance(target.pos,myHero.pos) <= Q.range then
				CastQ(target,myHero.pos)
			end
		else
			if GetDistance(target.pos,_shadowPos) <= Q.range then
				CastQ(target,_shadowPos)
			end
		end
	end
end

function Flee()
	if Ready(_W) and RepoZed.Flee.W:Value() then
		local vec = Vector(myHero.pos):Extended(Vector(mousePos), W.range)
		Control.CastSpell(HK_W,vec)
	end
end

function Lane()
	if RepoZed.Clear.Key:Value() == false then return end
	if myHero.mana < RepoZed.Clear.MP:Value() * 2 then return end
	for i = 1, Game.MinionCount() do
		local minion = Game.Minion(i)
		if minion then
			if minion.team == 300 - myHero.team then
				if IsValidTarget(minion,W.range) and RepoZed.Clear.W:Value() and Ready(_W) and MinionsAround(minion.pos, 290, 300 - myHero.team) >= RepoZed.Clear.WX:Value() and myHero:GetSpellData(_W).toggleState == 0 then
					Control.CastSpell(HK_W,minion.pos)
				end
				if RepoZed.Clear.E:Value() and Ready(_E) then
					if (HeroesAround(_shadowPos, 290, 300 - myHero.team) >= RepoZed.Clear.EX:Value() and myHero:GetSpellData(_W).toggleState == 2)
					or MinionsAround(myHero.pos, 290, 300 - myHero.team) >= RepoZed.Clear.EX:Value() then
						Control.CastSpell(HK_E)
					end
				end
				if IsValidTarget(minion,Q.range) and RepoZed.Clear.Q:Value() and Ready(_Q) then
					Control.CastSpell(HK_Q, minion.pos)
				end
			end
			if minion.team == 300 then
				if IsValidTarget(minion,W.range) and RepoZed.Clear.W:Value() and Ready(_W) and MinionsAround(minion.pos, 290, 300) >= 1 and myHero:GetSpellData(_W).toggleState == 0 then
					Control.CastSpell(HK_W,minion.pos)
				end
				if RepoZed.Clear.E:Value() and Ready(_E) then
					if MinionsAround(_shadowPos, 290, 300) >= 1 
					or MinionsAround(myHero.pos, 290, 300) >= 1 then
						Control.CastSpell(HK_E)
					end
				end
				if IsValidTarget(minion,Q.range) and RepoZed.Clear.Q:Value() and Ready(_Q) then
					Control.CastSpell(HK_Q, minion.pos)
				end
			end
		end
	end
end

function Activator()
	local target = GetTarget(W.range + Q.range)
	local items = {}
	for slot = ITEM_1,ITEM_6 do
		local id = myHero:GetItemData(slot).itemID 
		if id > 0 then
			items[id] = slot
		end
    end
    if GetMode() == "Combo" then
    if target == nil then return end
        local BOTRK = items[3144] or items[3146]
        if BOTRK and myHero:GetSpellData(BOTRK).currentCd == 0 and RepoZed.Combo.BOTRK:Value() and GetDistance(myHero.pos,target.pos) < 550 then
            if myHero:GetSpellData(_R).toggleState ~= 0 then
                Control.CastSpell(HKITEM[BOTRK], target)
            end
        end
        if (myHero:GetSpellData(SUMMONER_1).name == "SummonerDot" and Ready(SUMMONER_1))
		or (myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" and Ready(SUMMONER_2)) then
			if RepoZed.Combo.IG:Value() and myHero:GetSpellData(_R).toggleState ~= 0 then
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerDot" and Ready(SUMMONER_1) then
					Control.CastSpell(HK_SUMMONER_1, target)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerDot" and Ready(SUMMONER_2) then
					Control.CastSpell(HK_SUMMONER_2, target)
				end
			end
		end
		if myHero:GetSpellData(SUMMONER_1).name == "SummonerExhaust"
		or myHero:GetSpellData(SUMMONER_2).name == "SummonerExhaust" then
			if RepoZed.Combo.EX:Value() and myHero:GetSpellData(_R).toggleState ~= 0 then
				if myHero:GetSpellData(SUMMONER_1).name == "SummonerExhaust" and Ready(SUMMONER_1) then
					Control.CastSpell(HK_SUMMONER_1, target)
				elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerExhaust" and Ready(SUMMONER_2) then
					Control.CastSpell(HK_SUMMONER_2, target)
				end
			end
		end
    end
end

function Drawings()
    if myHero.dead then return end
    if RepoZed.Draw.Q:Value() and Ready(_Q) then Draw.Circle(myHero.pos, Q.range, 3,  Draw.Color(255, 000, 222, 255)) end
    if RepoZed.Draw.W:Value() and Ready(_W) then Draw.Circle(myHero.pos, W.range, 3,  Draw.Color(255, 255, 200, 000)) end
	if RepoZed.Draw.E:Value() and Ready(_E) then Draw.Circle(myHero.pos, E.range, 3,  Draw.Color(255, 000, 043, 255)) end
	if RepoZed.Draw.R:Value() and Ready(_R) then Draw.Circle(myHero.pos, R.range, 3,  Draw.Color(255, 246, 000, 255)) end
	if RepoZed.Draw.C:Value() then
		local textPos = myHero.pos:To2D()
		if RepoZed.Clear.Key:Value() then
			Draw.Text("CLEAR ENABLED", 20, textPos.x - 57, textPos.y + 40, Draw.Color(255, 000, 255, 000)) 
		else
			Draw.Text("CLEAR DISABLED", 20, textPos.x - 57, textPos.y + 40, Draw.Color(255, 225, 000, 000)) 
		end
	end
end
