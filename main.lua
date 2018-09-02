class = require'lib/middleclass'
local Game = require'game'


function love.load()
    require("mobdebug").start()
    game = Game:new()    
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
