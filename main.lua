class = require'lib/middleclass'
local Game = require'game'

local game = Game:new()  

function love.load()
    require("mobdebug").start()  
    game:init()
end

function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.keyreleased(key)
    game:keyreleased(key)
end
