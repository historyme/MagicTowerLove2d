local Monster = class('Monster')

function Monster:initialize(game, monsterID)
    self.state = 1
    self.monsterID = monsterID
    self.monster = game.monsters[monsterID]
    self.monsterSprites = game.monstersSprite[monsterID]
end

function Monster:draw(game, i, j)
    if self.monsterSprites[self.state] then
        game:drawPoint(self.monsterSprites[self.state], i, j)
    end
end

function Monster:animation()
    self.state = self.state + 1
	if self.state >= 5 then
        self.state = 1
    end
end

        
return Monster