local Floor = require'floor'

local FloorMaps = class('FloorMaps')

function FloorMaps:initialize()
    self.Floors = {}
    self.curFloor = 1
end


function FloorMaps:newFloor(index, game, ch)
    --print('index ' .. type(index))
    self.Floors[index] = Floor:new(index, game, ch)
end

function FloorMaps:curFloorMap()
    local floor = self.Floors[self.curFloor]
    return floor
end

function FloorMaps:canMove(game, hero, nextX, nextY, dir)
    local floor = self:curFloorMap()
    if floor then
        return floor:canMove(game, hero, nextX, nextY, dir)
    end
    
    return false
end

function FloorMaps:draw(game)
    local floor = self:curFloorMap()
    
    --print('_floor.index ' .. self.curFloor .. ' floor.index ' ..floor.index)
    
    if floor then
        floor:draw(game)
    end
end

function FloorMaps:animation(game)
    local floor = self:curFloorMap()
    
    if floor then
        floor:animation(game)
    end
end

function FloorMaps:upStair(game)
    self.curFloor = self.curFloor + 1
    local floor = self:curFloorMap()
    local x,y = floor:getStairPos('down')
    return x,y
end

function FloorMaps:downStair(game)
    self.curFloor = self.curFloor - 1
    local floor = self:curFloorMap()
    local x,y = floor:getStairPos('up')
    return x,y
end

return FloorMaps