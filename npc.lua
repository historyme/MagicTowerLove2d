local ActiveItem = require'activeitem'
local Npc = class('Npc',ActiveItem)

function Npc:initialize(game, NpcID)
    self.NpcID = NpcID
	self.state = 1
	self.visit = 1
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

function Npc:active(game, hero)
    game.state = 'GAME_STATE_MEET_NPC'
    game.activeItemID = self.NpcID
    return false
end

return Npc