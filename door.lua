local ActiveItem = require'activeitem'
local Door = class('Door', ActiveItem)

function Door:initialize(game, doorID)
    self.doorID = doorID
    self.sprites = {}
    self.state = 1
    self.opened = false
    self:init(game)
end

function Door:init(game)
    local t = self.doorID
	if(t == 1) then
        self.sprites=game.resMan.s_yellowdoor
    elseif (t == 2) then
        self.sprites=game.resMan.s_bluedoor
    elseif (t == 3) then
        self.sprites=game.resMan.s_reddoor
    elseif (t == 6) then
        for i=1,4 do
            self.sprites[i]=game.resMan.sprite_map['shopleft']
        end
    elseif (t == 7) then
        for i=1,4 do
            self.sprites[i]=game.resMan.sprite_map['shopright']
        end
    elseif (t == 8) then
        self.sprites=game.resMan.s_specialdoor
        self.opened = false
    elseif (t == 9) then
        self.sprites=game.resMan.s_specialdoor
        self.opened = true
    end
end


function Door:draw(game, i, j)
    if (not self.opened) or (self.isStair) then 
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

function Door:active(game, hero)
    local ret = false
    
    if self.opened then
        return true
    end
    
    if self.doorID == 1 then
        ret = hero:tryOpenDoor('yellow')
    elseif self.doorID == 2 then
        ret = hero:tryOpenDoor('blue')
    elseif self.doorID == 3 then
        ret = hero:tryOpenDoor('red')
    end
    
    if ret then
        game.opening = true
        game.openingdoor = self
    end
    
    return ret
end

return Door