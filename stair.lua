local ActiveItem = require'activeitem'
local Stair = class('Stair', ActiveItem)

function Stair:initialize(game, stairID)
    self.stairID = stairID
    self.sprites = nil
    self:init(game)
end

function Stair:init(game)
    local sprite_map = game.resMan.sprite_map
    if (self.stairID == 4) then
        self.sprites=sprite_map['upstair']
    elseif (self.stairID == 5) then
        self.sprites=sprite_map['downstair']
    end
end

function Stair:draw(game, i, j)
    if self.sprites then
        game:drawPoint(self.sprites, i, j)
    end
end

function Stair:active(game, hero, nextX, nextY)
    if self.stairID == 4 then
        hero:upStair(game)
    elseif self.stairID == 5 then
        hero:downStair(game)
    end
    
    return false
end

return Stair