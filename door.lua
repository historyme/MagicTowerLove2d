local ActiveItem = require'activeitem'
local Door = class('Door', ActiveItem)

function Door:initialize(game, doorID)
    self.isDoor = true
    self.doorID = doorID
    self.sprites = {}
    self.state = 1
    self.opened = false
    self.lock = false
    self:init(game)
end

function Door:init(game)
    local t = self.doorID
    local resMan = game.resMan
	if(t == 1) then
        self.sprites=resMan.doorSprite['yellow']
    elseif (t == 2) then
        self.sprites=resMan.doorSprite['blue']
    elseif (t == 3) then
        self.sprites=resMan.doorSprite['red']
    elseif (t == 6) then
        for i=1,4 do
            self.sprites[i]=resMan.sprite_map['shopleft']
        end
    elseif (t == 7) then
        for i=1,4 do
            self.sprites[i]=resMan.sprite_map['shopright']
        end
    elseif (t == 8) then
        self.sprites=resMan.doorSprite['special']
        self.lock = true
    elseif (t == 9) then
        self.sprites=resMan.doorSprite['special']
        self.lock = false
    end
end


function Door:draw(game, i, j)
    if (not self.opened) then 
        if self.sprites[self.state] then
            game:drawPoint(self.sprites[self.state], i, j)
        end
    end
end

function Door:open()
    self.state = self.state + 1
	if(self.state==5) then
        self.state = 1
        self.opened = true
		return true
    end
	return false
end

function Door:active(game, hero, nextX, nextY)
    local ret = false
    local id = self.doorID
    if self.opened then
        return true
    end
    
    if self.lock then
        return false
    end
    
    if id == 1 then
        ret = hero:tryOpenDoor('yellow')
    elseif id == 2 then
        ret = hero:tryOpenDoor('blue')
    elseif id == 3 then
        ret = hero:tryOpenDoor('red')
    elseif ((id == 8) or (id == 9))then
        ret = hero:tryOpenDoor('special')
    end
    
    if ret then
        game.opening = true
        game.openingdoor = self
    end
    
    return ret
end

function Door:unlock()
    self.lock = false
end

return Door