local ResManager = require'resmanager'
local FloorMaps = require'floormaps'
local Maps = require'mapdat'
local MsgBox = require'msgbox'
local Hero = require'hero'

local Game = class('Game')

function Game:initialize()
    print('new Game')
end
 
function  Game:init()
    self.map_height = 11
    self.map_width = 11

    self.map_floornum = 22
    self.special_floornum = 46
    self.moving = false
    self.time_move = 0
    self.time_animation = 0
    self.state = 'GAME_STATE_NONE'
    self.time_hint = 0
    self.count_hint = 0
    self.opening = false
    self.time_open = 0
    self.openingdoor = nil
    self.flooring = false
    self.time_floor = 0
    
    self.floormaps = nil
    self.msgBox = nil
    
    self.resMan = ResManager:new()
    
    self:initFloorMaps()
    
    self:initMsgBox()

    self.hero = Hero:new()
    self.hero:init()
end

function Game:update(dt)
    if game:isFree() then
        if (love.keyboard.isDown('up') and game:canMove('up')) then
            game.moving = true
        elseif (love.keyboard.isDown('down') and game:canMove('down')) then
            game.moving = true
        elseif (love.keyboard.isDown('right') and game:canMove('right')) then
            game.moving = true
        elseif (love.keyboard.isDown('left') and game:canMove('left')) then
            game.moving = true
        end
    end
    
    self.hero:update(dt)

    self:run(dt)
end

function Game:run(dt)
    if self.moving then
        self.time_move = self.time_move + dt;
        if (self.time_move>=0.03) then
            self.time_move = self.time_move - 0.03
            if (self.hero:moveComplete(self,dt)) then
                self.moving = false
            end
        end
    end
    
    --开门
    if self.opening then
        self.time_open = self.time_open + dt
        if self.time_open>=0.05 then
            self.time_open = self.time_open - 0.05
            if self.openingdoor:open() then
                self.opening = false
                self.openingdoor = nil
            end
        end
    end
    
    --上下楼
    if (self.flooring) then
        self.time_floor = self.time_floor + dt
        if (self.time_floor >= 0.4) then
            self.time_floor = 0
            self.flooring = false
        end
    end
    
    --动画
    self.time_animation = self.time_animation + dt
    if(self.time_animation>=0.1) then  -- // 四次后又回到自身状态
        self.time_animation = self.time_animation - 0.1
        self.floormaps:animation(self)
    end
    
    --提示类，需要按回车，或者0.8s以后自动关闭
    if self.state == 'GAME_STATE_HINT' then
        self.time_hint = self.time_hint + dt
        if (love.keyboard.isDown('return') or self.time_hint >= 0.8) then
            self.count_hint = 1 + self.count_hint
        end
        
        if self.count_hint >= 1 then
            self.count_hint = 0
            self.time_hint = 0
            self.state = 'GAME_STATE_NONE'
            self.msgBox:showMsg(false)
        end
    end

end

function Game:isFree()
    if (self.moving) then
        return false 
    end
    
    if (not (self.state == 'GAME_STATE_NONE')) then
        return false 
    end
    
    if self.opening then
        return false
    end
    
    return true
end

--初始化地图
function Game:initFloorMaps()
    self.floormaps = FloorMaps:new()
    
    for i = 1, self.map_floornum do
        self.floormaps:newFloor(i, self, Maps[i])
    end
    
    for i = 32, self.special_floornum do
        self.floormaps:newFloor(i, self, Maps[i])
    end
end

function Game:initMsgBox()
    self.msgBox = MsgBox:new(self)
end

function Game:setMsg(str)
    self.state = 'GAME_STATE_HINT'
    self.msgBox:setMessage(str)
    self.msgBox:showMsg(true)
end

function Game:setMsgBatch(str)
    self.state = 'GAME_STATE_SPEECH'
    self.msgBox:setMessageBatch(str)
    self.msgBox:showMsg(true)
end

function Game:drawPoint(sprite, i, j)
    love.graphics.draw(sprite.img, sprite.quad, (j-1)*self.resMan.tiled_width + self.resMan.ScreenLeft, (i-1)*self.resMan.tiled_height)
end

function Game:upStair()
    self.flooring = true
    return self.floormaps:upStair(self)
end

function Game:downStair()
    self.flooring = true
    return self.floormaps:downStair(self)
end

function Game:canMove(dir)
    return self.hero:canMove(self, dir)
end

function Game:openDoor(floorID, x, y)
    self.floormaps:openDoor(floorID, x, y)
end

function Game:draw()
    self.floormaps:draw(self)
    self.hero:draw(self)
    self.msgBox:draw()
end

--需要弄清楚，love.keypressed处理与love.update的顺序,或者全部重写love.run()
--按照11.1版本的love.run, love.event中处理love.keypressed，在love.update之前
function Game:keypressed(key)
    --对话
    if key == 'return' then
        if self.state == 'GAME_STATE_SPEECH' then
            if not self.msgBox:nextMsg() then
                self.state = 'GAME_STATE_NONE'
                self.msgBox:showMsg(false)
            end
        end
    end
end

function Game:keyreleased(key)

end

--返回模块
return Game