local Floorpoint = require'floorpoint'
local Floor = class('Floor')

function Floor:initialize(index, game, ch)
    self.index = index
    self.floorPoints= {}
    self.downStairX = 0
    self.downStairY = 0
    self.upStairX = 0
    self.upStairY = 0
    for i = 1, game.map_width do
        self.floorPoints[i] = {}
    end
    
    self:init(game, ch)
end

function Floor:init(game, ch)
    local point = nil
    local sprite_map = game.resMan.sprite_map
    for i = 1, game.map_height do
        for j = 1, game.map_width do
            local val = ch[i][j]
            --print('val='.. val)
            if(val == 0)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,0,0)
            elseif(val == 1)then
                point=Floorpoint:new(game, val, sprite_map['wall'],nil,0,0,0)
            elseif(val == 2)then
                point=Floorpoint:new(game, val, sprite_map['water'],nil,0,0,0)
            elseif(val == 3)then
                point=Floorpoint:new(game, val, sprite_map['sky'],nil,0,0,0)
            elseif(val == 4)then
                point=Floorpoint:new(game, val, sprite_map['barrier'],nil,0,0,0)
            elseif(val == 10)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['lightning'],0,0,0)
            elseif(val == 11)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['redjewel'],0,0,0)
            elseif(val == 12)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['bluejewel'],0,0,0)
            elseif(val == 13)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['enemyinfo'],0,0,0)
            elseif(val == 14)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['allkey'],0,0,0)
            elseif(val == 15)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['yellowkey'],0,0,0)
            elseif(val == 16)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['bluekey'],0,0,0)
            elseif(val == 17)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['redkey'],0,0,0)
            elseif(val == 18)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['redpotion'],0,0,0)
            elseif(val == 19)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['bluepotion'],0,0,0)
            elseif(val == 20)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['sword1'],0,0,0)
            elseif(val == 21)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['shield1'],0,0,0)
            elseif(val == 22)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['coin'],0,0,0)
            elseif(val == 23)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['fly'],0,0,0)
            elseif(val == 24)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['cross'],0,0,0)
            elseif(val == 25)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['sword2'],0,0,0)
            elseif(val == 26)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['shield2'],0,0,0)
            elseif(val == 27)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['floor'],0,0,0)
            elseif(val == 28)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['stick'],0,0,0)
            elseif(val == 29)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['fly2'],0,0,0)
            elseif(val == 30)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['drink'],0,0,0)
            elseif(val == 31)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['sword3'],0,0,0)
            elseif(val == 32)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['shield3'],0,0,0)
            elseif(val == 33)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['atk'],0,0,0)
            elseif(val == 34)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['def'],0,0,0)
            elseif(val == 35)then
                point=Floorpoint:new(game, val, sprite_map['ground'],sprite_map['lelseife'],0,0,0)
            elseif(val == 81)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,6,0)
            elseif(val == 83)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,7,0)
            elseif(val == 91)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,1,0)
            elseif(val == 92)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,2,0)
            elseif(val == 93)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,3,0)
            elseif(val == 96)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,8,0)
            elseif(val == 97)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,9,0)
            elseif (val >=40 and val <=80)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,val,0)
            elseif(val == 94)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,4,0)
                self.upStairX = j
                self.upStairY = i
            elseif(val == 95)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,5,0)
                self.downStairX = j
                self.downStairY = i
            elseif(val >=101 and val <=200)then
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,val -100,0,0)
            elseif(val >=201 and val <=300)then
                --print('val='..val)
                point=Floorpoint:new(game, val, sprite_map['ground'],nil,0,0,val)
            end
            
            if point then
                self.floorPoints[i][j] = point 
            end
        end
    end
end


function Floor:canMove(game, hero, nextX, nextY, dir)
    local pointY = self.floorPoints[nextY]
    if pointY then
        local point = pointY[nextX]
        if point then
            return point:canMove(game, hero, dir)
        else
            return false
        end
    else
        return false
    end
end


function Floor:draw(game)
    height = game.map_height
    width = game.map_width
    
    --print('self.index =' .. self.index  )
	for i = 1, height do
		for j = 1, width do
            local point = self.floorPoints[i][j]
            --print('self.index =' .. self.index .. ' point.specialID ' .. self.floorPoints[i][j].specialID)
			point:draw(game, i, j);
		end
	end
end


function Floor:animation(game)
    height = game.map_height
    width = game.map_width
    
	for i = 1, height do
		for j = 1, width do
            local point = self.floorPoints[i][j]
			point:animation();
		end
	end
end

function Floor:getActiveItemID(x, y)
    print('x= '.. x .. ' y = ' .. y)
    local point = self.floorPoints[y][x]
    local itemID = point.itemID
    local distory = point.spriteItemDistroy

    if  distory ==  true then
        return -1
    end

    return itemID
end

function Floor:distroyItem(x, y)
    local point = self.floorPoints[y][x]
    point.spriteItem = nil
    point.spriteItemDistroy = true
end

function Floor:getStairPos(updown)
    local x = 0
    local y = 0
    if updown == 'up' then
        x = self.upStairX
        y = self.upStairY
    elseif updown == 'down' then
        x = self.downStairX
        y = self.downStairY
    end

    return x,y
end

return Floor