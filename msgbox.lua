local MsgBox = class('MsgBox')

function MsgBox:initialize(game)
    self.msg = ''
    self.show = false
    
    self.boxPosX = game.resMan.tiled_width/2 + game.resMan.ScreenLeft
    self.boxPosY = game.map_height*game.resMan.tiled_height - 5 * game.resMan.tiled_height
    self.strPosX = self.boxPosX + game.resMan.tiled_width/4 
    self.strPosY = self.boxPosY + game.resMan.tiled_height/4
    
    self.boxSizeWidth  = game.resMan.tiled_width *(game.map_width    - 1)
    self.boxSizeheight = game.resMan.tiled_height*(game.map_height/2 - 1)
    
    self.stringBatch = {}
    self.index = 1
end

function MsgBox:draw()
    if self.show then
        local r,g,b,a = love.graphics.getColor()
        
        love.graphics.setBlendMode("alpha")
        love.graphics.setColor(0.5, 0.5, 0.5, 0.5)
        love.graphics.rectangle('fill', self.boxPosX, self.boxPosY,self.boxSizeWidth, self.boxSizeheight)
        
        love.graphics.setColor(1, 1, 1, 1) -- 白色
        love.graphics.print(self.msg, self.strPosX , self.strPosY)
        
        love.graphics.setColor(r,g,b,a)
    end
end

function MsgBox:setMessage(string)
    self.msg = string
end

function MsgBox:setMessageBatch(stringBatch)
    self.stringBatch = stringBatch
    self.msg = self.stringBatch[self.index]
end

function MsgBox:nextMsg()
    self.index = self.index + 1
    self.msg = self.stringBatch[self.index]
    
    if self.msg then
        return true
    else
        self.stringBatch = {}
        self.index = 1
        return false
    end
end

function MsgBox:showMsg(show)
    self.show = show
end

return MsgBox