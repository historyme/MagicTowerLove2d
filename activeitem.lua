local ActiveItem = class('ActiveItem')

function ActiveItem:initialize()
    self.isDoor = false
end

function ActiveItem:draw(game, i, j)

end

function ActiveItem:animation()

end

function ActiveItem:active(game, hero)
    return false
end

return ActiveItem