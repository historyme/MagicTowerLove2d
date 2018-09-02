local ActiveItem = require'activeitem'
local Npc = class('Npc',ActiveItem)

function Npc:initialize(game, NpcID)
    self.NpcID = NpcID
	self.state = 1
	self.visitTimes = 0
    self.npcSprites = game.resMan:getNpcSprites(self.NpcID)
end

function Npc:draw(game, i, j)
    if self.npcSprites[self.state] then
        game:drawPoint(self.npcSprites[self.state], i, j)
    end
end

function Npc:animation()
    self.state = self.state + 1
	if self.state >= 5 then
        self.state = 1
    end
end

function Npc:active(game, hero, nextX, nextY)
    hero:meetNpc(game, self, nextX, nextY)
    return false
end

function Npc:visit()
    self.visitTimes = self.visitTimes + 1
end

function Npc:getVisitTimes()
    return self.visitTimes
end

return Npc