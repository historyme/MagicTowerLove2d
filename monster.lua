local Monster = class('Monster')

function Monster:initialize(game, monsterID)
    self.monsterID = monsterID
    self.monster = game.resMan.monsters[monsterID]
    self.monsterSprites = game.resMan.monstersSprite[monsterID]
    self:initMonster()
end

function Monster:initMonster()
    self.die = false
    self.state = 1
    self.hp = self.monster.hp
end

function Monster:draw(game, i, j)
    if not self.die then
        if self.monsterSprites[self.state] then
            game:drawPoint(self.monsterSprites[self.state], i, j)
        end
    end
end

function Monster:animation()
    self.state = self.state + 1
	if self.state >= 5 then
        self.state = 1
    end
end

function Monster:getDef(heroAtk)
    local def = 0
    if self.monster.special == 2 then
        def = heroAtk - 1
    else
        def = self.monster.def
    end
    
    return def
end

function Monster:getAtk()
    return self.monster.atk
end

function Monster:getMoney()
    return self.monster.money
end

function Monster:getExperience()
    return self.monster.experience
end

function Monster:getHp()
    return self.hp
end
function Monster:haveEffect(effect)
    if effect == 'SuckBlood' then
        if self.monster.special == 1 then
            return true
        end
    elseif effect == 'Strong' then
        if self.monster.special == 2 then
            return true
        end
    elseif effect == 'MagicAtk' then
    if self.monster.special == 3 then
        return true
    end
    end
    
    return false
end

function Monster:active(game, hero, nextX, nextY)
    if self.die then
        return true
    end
    
    if hero:canBeat(self) then
        game.battling = true
        game.monster_battling = self
    end
    
    return false
end

function Monster:goDie()
    self.die = true
end

function Monster:beAttacked(hero_atk)
    local damage = hero_atk - self:getDef(hero_atk)

    self.hp = self.hp - damage

    if  self.hp <= 0 then
        return true
    else
        return false
    end
end

return Monster