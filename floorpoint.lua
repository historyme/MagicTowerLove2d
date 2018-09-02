local Door = require'door'
local Stair = require'stair'
local Monster = require'monster'
local Npc = require'npc'

local FloorPoint = class('FloorPoint')

function FloorPoint:initialize(game, itemID, spriteType, spriteItem, monsterID, activeItemID, specialID)
    self.itemID = itemID
    self.spriteType = spriteType
    self.spriteItem = spriteItem
    self.spriteItemDistroy = false
    self.specialID = specialID
    self.activeItem = nil
    self.monster = nil
    
    if ((activeItemID > 0 and activeItemID <= 3) or (activeItemID >= 6 and activeItemID <=9) ) then
        self.activeItem = Door:new(game, activeItemID)
    elseif (activeItemID >= 4 and activeItemID <= 5) then
        self.activeItem = Stair:new(game, activeItemID)
    elseif activeItemID >= 10 then
        self.activeItem = Npc:new(game, activeItemID)
    end
    
    if monsterID > 0 then
        self.monster = Monster:new(game, monsterID)
    end
end

function FloorPoint:canMove(game, hero, nextX, nextY, dir)
    if(self.spriteType.innerID == game.resMan.sprite_map['ground'].innerID) then
        if self.activeItem then
            return self.activeItem:active(game, hero, nextX, nextY)
        end

        if self.monster then
            return self.monster:active(game, hero, nextX, nextY)
        end
        
        return true
    end
    
    return false
end

function FloorPoint:drawSpecialPoint(specialID, game, i, j)
    if (specialID == 201) then
        game:drawPoint(game.s_sigh, i, j)
    elseif (specialID == 202) then
        game:drawPoint(game.s_sighed, i, j)
    elseif (specialID == 203) then
        game:drawPoint(game.s_up, i, j)
    elseif (specialID == 204) then
        game:drawPoint(game.s_left, i, j)
    elseif (specialID == 205) then
        game:drawPoint(game.s_right, i, j)
    elseif (specialID == 206) then
        game:drawPoint(game.s_down, i, j)
    elseif (specialID == 207) then
        game:drawPoint(game.s_wall, i, j)
    elseif (specialID == 208) then
        game:drawPoint(game.s_portal, i, j)
    elseif (specialID == 209) then
        game:drawPoint(game.s_flower, i, j)
    elseif (specialID == 210) then
        game:drawPoint(game.s_box, i, j)
    elseif (specialID == 211) then
        game:drawPoint(game.s_flower, i, j)
        game:drawPoint(game.s_boxed, i, j)
    end
    
end

function FloorPoint:draw(game, i, j)
    if self.spriteType then
        game:drawPoint(self.spriteType, i, j)
    end
    
    if self.spriteItem then
        game:drawPoint(self.spriteItem, i, j)
    end
    
    if (self.specialID > 0) then
        self:drawSpecialPoint(self.specialID, game, i, j)
    end
    
    if (self.activeItem) then
        self.activeItem:draw(game, i, j)
    end
    
    if (self.monster) then
        self.monster:draw(game, i, j)
    end
end

function FloorPoint:animation()
    if (self.monster) then
        self.monster:animation()
    end
    
    if (self.activeItem) then
        self.activeItem:animation()
    end
    
end

function FloorPoint:openDoor(x,y)
    local item = self.activeItem
    if item then
        if item.isDoor then
            item:unlock()
        end
    end
end

return FloorPoint