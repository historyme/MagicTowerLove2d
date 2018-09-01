class = require'lib/middleclass'
local Game = require'game'


function love.load()
    game = Game:new()    
    game:init()
        
    love.audio.play(game.he_Music)
end

function love.update(dt)
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

    game:update(dt)
end

function love.draw()
    if game then
        game:draw()
    end
end

function love.keypressed(key)
    game:keypressed(key)
end

function love.keyreleased(key)
    game:keyreleased(key)
end
