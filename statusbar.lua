local StatusBar = class('StatusBar')

function StatusBar:initialize(game)
end

function StatusBar:draw(game)
    self:printHeroInfo(game)
end

function StatusBar:drawSprite(sprite, x, y)
    love.graphics.draw(sprite.img, sprite.quad, x, y)
end

function StatusBar:printHeroInfo(game)
    local py = 16
    local px = 350
    local now_floor = game.floormaps.curFloor
    local sprite = game.resMan.sprite_map
    local hero = game.hero
    local printInfo = love.graphics.print

    self:drawSprite(sprite['storey'] , 16 + px,py)
    
    if (now_floor<30) then
        printInfo(now_floor, 60+ px, py)
    else 
        printInfo("???", 60+ px, py)
    end
        
    py = py + 32
    self:drawSprite(sprite['level'],16+ px,py)
    printInfo(hero.lv,60+ px,py)
    if not (hero.special==0) then
        if (hero.special==1) then
            self:drawSprite(sprite['atk'],160+ px,py)
        elseif (hero.special==2) then
            self:drawSprite(sprite['def'],160+ px,py)
        elseif (hero.special==3) then
            self:drawSprite(sprite['life'],160+ px,py)
        end
        printInfo(hero:getSpecialLv(), 204+ px, py)
    end
    
    py = py + 32
    self:drawSprite(sprite['heart'],16+ px,py)
    printInfo(hero.hp, 60+ px, py)
    
    py = py + 32
    self:drawSprite(sprite['sword1'],16+ px,py)
    printInfo(hero.atk, 60+ px, py)
    
    py = py + 32
    self:drawSprite(sprite['shield1'],16+ px,py)
    if not (hero.special==2) then
        printInfo(hero.def, 60+ px, py)
    else
        printInfo(hero.def ..' (+'.. hero:getSpeDef() .. ')',60+ px,py)
    end

    py = py + 32
    self:drawSprite(sprite['yellowkey'],16+ px,py)
    printInfo(hero.yellowkey, 60+ px, py)
    
    py = py + 32
    self:drawSprite(sprite['bluekey'],16+ px,py)
    printInfo(hero.bluekey, 60+ px, py)
    
    py = py + 32
    self:drawSprite(sprite['redkey'],16+ px,py)
    printInfo(hero.redkey, 60+ px, py)
    
    py = py + 32
    self:drawSprite(sprite['coin'],16+ px,py)
    printInfo(hero.money, 60+ px, py)
    
    py = py + 32
    self:drawSprite(sprite['expr'],16+ px,py)
    printInfo(hero.experience, 60+ px, py)
end

return StatusBar
