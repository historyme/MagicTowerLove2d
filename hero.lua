local Hero = class('Hero')

function Hero:initialize(game)
    print('new Hero')
    
    self.dir = {['x'] = {} , ['y'] = {}}
    
    self.dir['x'][1]=0 --下
	self.dir['x'][2]=-1 -- 左
    self.dir['x'][3]=1 -- 右
    self.dir['x'][4]=0 -- 上
    
    self.dir['y'][1]=1
    self.dir['y'][2]=0
    self.dir['y'][3]=0
    self.dir['y'][4]=-1
    
    self:init()
end

function Hero:init()
    self.lv=1
    self.hp=1000
    self.atk=10
    self.def=10
    self.money=0
    self.experience=0
    self.redkey=0
    self.bluekey=0
    self.yellowkey=0
    self.special=0
    self.x=6
    self.y=10
    self.face=4
    self.move=1
    self.now_floor=0
    self.max_floor=0
    self.fly_floor=0
end

function Hero:canMove(game, dir)
    if dir == 'up' then
        self.face = 4
    elseif dir == 'down' then
        self.face = 1
    elseif dir == 'right' then
        self.face = 3
    elseif dir =='left' then
        self.face = 2
    end
    
    local bmove = game.floormaps:canMove(game,self, self:nextX(), self:nextY(), dir)
    
    return bmove
end

function Hero:nextX()
    return self.x + self.dir['x'][self.face]
end

function Hero:nextY()
    return self.y + self.dir['y'][self.face]
end

function Hero:drawHero(sprite, game, i, j)
    love.graphics.draw(sprite.img, sprite.quad,
        (i-1)*game.resMan.tiled_width +game.resMan.tiled_width/4 *(self.move-1)*self.dir['x'][self.face] + game.resMan.ScreenLeft,
        (j-1)*game.resMan.tiled_height+game.resMan.tiled_height/4*(self.move-1)*self.dir['y'][self.face])
end

function Hero:draw(game)
    local sprite = game.resMan.heroSprite[self.move][self.face]
    if sprite then
        self:drawHero(sprite, game, self.x, self.y)
    end
end

function Hero:moveComplete(game, dt)
    self.move = self.move + 1
	if self.move >= 5 then
        self.move = 1
        self.x = self.x + self.dir['x'][self.face];
		self.y = self.y + self.dir['y'][self.face];
        
        self:onHeroMoveComplite(game, self.x, self.y)
        
        return true
    end
    
    return false
end


function Hero:onHeroMoveComplite(game, x, y)
    --获取当前位置的物品
    local floor = game.floormaps:curFloorMap()
    local itemID = floor:getActiveItemID(x, y)

    print('item = '..itemID)
    
    if itemID == 15 then
        self.yellowkey = self.yellowkey + 1
        print('yellowkey = '.. self.yellowkey)
        game:setMsg("获得黄钥匙")
        floor:distroyItem(x, y)
    elseif itemID == 16 then
        self.bluekey = self.bluekey + 1
        print('bluekey = '.. self.bluekey)
        game:setMsg("获得蓝钥匙")
        floor:distroyItem(x, y)
    elseif itemID == 17 then
        self.redkey = self.redkey + 1
        print('redkey = '.. self.redkey)
        game:setMsg("获得红钥匙")
        floor:distroyItem(x, y)
    end
end

function Hero:tryOpenDoor(door)
    local ret= false
    
    if door == 'red' then
        if self.redkey > 0 then
            self.redkey = self.redkey - 1
            ret = true
        end
    elseif door == 'blue' then
        if self.bluekey > 0 then
            self.bluekey = self.bluekey - 1
            ret = true
        end
    elseif door == 'yellow' then
        if self.yellowkey > 0 then
            self.yellowkey = self.yellowkey - 1
            ret = true
        end
    end
    
    return ret
end

function Hero:upStair(game)
    local x,y = game:upStair()
    self.x = x
    self.y = y
end

function Hero:downStair(game)
    local x,y = game:downStair()
    self.x = x
    self.y = y
end

function Hero:update(dt)
    

end

function Hero:meetNpc(game, npcID)

	if npcID == 44 then
        local fairy_hint={
            "我：\n（这是什么鬼地方，阴森森的）\n\n[按回车键继续]",
            "我：\n（今天和女朋友结对编程时，\n就因为大括号是否应该换行的\n问题，一言不合，她竟然就跑\n出来了...）",
            "我：\n（结果我追着她到了这个鬼地\n方，这是哪啊.....）\n......\n（大声喊）XX！XX！！",
            "仙子：\n哎你是谁，为什么跑到这来了？",
            "我：\n这里是哪？怎么这么阴森？\n你又是谁？",
            "仙子：\n这是镇妖塔，镇压着一方魔物。\n我是这里的守塔仙子。\n这不是你该来的地方，快点回\n去吧。",
            "我：\n仙子你好，你看到了一个小女\n孩吗？\n......\n（比划）大概这么高，齐刘海",
            "仙子：\n啊看到了，她刚刚冲进了塔里！\n我都没来得及拦住她哎。",
            "我：\n她进去了？那我也要进去找她！\n",
            "仙子：\n她这时候恐怕已经被魔物抓起\n来了，凶多吉少，你进去也没\n用的。",
            "我：\n她是我的女朋友！\n我一定要把她安全带出来！\n",
            "仙子：\n但是这里面魔物很凶猛的，特\n别是顶楼的boss更是厉害得很\n啊。",
            "我：\n那该怎么办？怎么才能救出她\n呢？",
            "仙子：\n如果你能把七楼的十字架交给\n我，我就能大幅提高你的能力\n，这样或许你就能救出她了。",
            "我：\n好！我这就去替你找回你的十\n字架！而且我一定能把她给救\n出来！",
            "仙子：\n去吧，我相信你！祝你好运！",
            "S/L: 存档/读档\nF: 楼层飞行（需飞行器）\nR: 重新开始\nM: 音乐开关\nH: 查看帮助\nQ: 退出游戏",
            "仙子：\n（痴情的孩子啊......）"
        }
        game:setMsgBatch(fairy_hint)
    end

end

return Hero