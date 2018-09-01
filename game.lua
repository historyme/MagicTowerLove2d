local FloorMaps = require'floormaps'
local Maps = require'mapdat'
local MsgBox = require'msgbox'
local Hero = require'hero'

local Game = class('Game')

function Game:initialize()
    print('new Game')
end
 
function  Game:init()
    --每一个sprite的唯一ID
    self.spriteInnerID = 1
    
    self.tiled_height = 32
    self.tiled_width = 32
    self.map_height = 11
    self.map_width = 11
    self.ScreenLeft = 0
    self.fontsize = 16

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
    
    self.activeItemID = 0
    
    self.floormaps = nil
    self.msgBox = nil
    
    self.ht_map=love.graphics.newImage('Res/map.png')
    self.ht_icon=love.graphics.newImage('Res/icon.png')
    self.ht_hero=love.graphics.newImage('Res/hero.png')
    self.ht_monster=love.graphics.newImage('Res/monster.png')
    self.ht_skin=love.graphics.newImage('Res/skin.png')
    self.ht_npc=love.graphics.newImage('Res/npc.png')
    self.ht_special=love.graphics.newImage('Res/special.png')
    
    self.he_GetItem=love.audio.newSource("Res/item.ogg", "static")
    self.he_OpenDoor=love.audio.newSource("Res/door.ogg", "static")
    self.he_Attack=love.audio.newSource("Res/attack.ogg", "static")
    self.he_Music=love.audio.newSource("Res/bgm.mp3", "static")
    
    self.hgef=love.graphics.newFont("Res/YaHeiConsolas.ttf", self.fontsize)
    love.graphics.setFont(self.hgef)
    
    --ht_hero
    self:initHeroSprite()
    
    --ht_map
    self.s_ground=self:newSprite(self.ht_map,0,0,self.tiled_width,self.tiled_height)
    self.s_wall=self:newSprite(self.ht_map,self.tiled_width,0,self.tiled_width,self.tiled_height)
    self.s_water=self:newSprite(self.ht_map,self.tiled_width,self.tiled_height,self.tiled_width,self.tiled_height)
    self.s_sky=self:newSprite(self.ht_map,0,self.tiled_height,self.tiled_width,self.tiled_height)
    self.s_lightning=self:newSprite(self.ht_npc,0,self.tiled_height*4,self.tiled_width,self.tiled_height)
    self.s_barrier=self:newSprite(self.ht_special,self.tiled_width*4,self.tiled_height*30,self.tiled_width,self.tiled_height)
    --ht_door
    self.s_yellowdoor = {}
    self.s_bluedoor = {}
    self.s_reddoor = {}
    self.s_specialdoor = {}
    for i=1,4 do
        self.s_yellowdoor[i]=self:newSprite(self.ht_map,0,self.tiled_height*(i+1),self.tiled_width,self.tiled_height)
        self.s_bluedoor[i]=self:newSprite(self.ht_map,self.tiled_width,self.tiled_height*(i+1),self.tiled_width,self.tiled_height)
        self.s_reddoor[i]=self:newSprite(self.ht_map,self.tiled_width*2,self.tiled_height*(i+1),self.tiled_width,self.tiled_height)
        self.s_specialdoor[i]=self:newSprite(self.ht_map,self.tiled_width*3,self.tiled_height*(i+1),self.tiled_width,self.tiled_height)
    end
    self.s_downstair=self:newSprite(self.ht_map,0,self.tiled_height*6,self.tiled_width,self.tiled_height)
    self.s_upstair=self:newSprite(self.ht_map,self.tiled_width,self.tiled_height*6,self.tiled_width,self.tiled_height)
    self.s_shopleft=self:newSprite(self.ht_map,0,self.tiled_height*7,self.tiled_width,self.tiled_height)
    self.s_shopright=self:newSprite(self.ht_map,self.tiled_width*2,self.tiled_height*7,self.tiled_width,self.tiled_height)
    --ht_item
    self.s_yellowkey=self:newSprite(self.ht_icon,0,0,self.tiled_width,self.tiled_height)
    self.s_bluekey=self:newSprite(self.ht_icon,self.tiled_width,0,self.tiled_width,self.tiled_height)
    self.s_redkey=self:newSprite(self.ht_icon,self.tiled_width*2,0,self.tiled_width,self.tiled_height)
    self.s_allkey=self:newSprite(self.ht_icon,self.tiled_width*3,0,self.tiled_width,self.tiled_height)
    self.s_coin=self:newSprite(self.ht_icon,0,self.tiled_height*2,self.tiled_width,self.tiled_height)
    self.s_fly=self:newSprite(self.ht_icon,0,self.tiled_height*6,self.tiled_width,self.tiled_height)
    self.s_fly2=self:newSprite(self.ht_icon,0,self.tiled_height*6,self.tiled_width,self.tiled_height)
    self.s_floor=self:newSprite(self.ht_icon,self.tiled_width,self.tiled_height*5,self.tiled_width,self.tiled_height)
    self.s_level=self:newSprite(self.ht_icon,self.tiled_width*2,self.tiled_height*4,self.tiled_width,self.tiled_height)
    self.s_storey=self:newSprite(self.ht_icon,self.tiled_width*2,self.tiled_height*3,self.tiled_width,self.tiled_height)
    self.s_cross=self:newSprite(self.ht_icon,self.tiled_width*3,self.tiled_height*5,self.tiled_width,self.tiled_height)
    self.s_stick=self:newSprite(self.ht_icon,0,self.tiled_height*5,self.tiled_width,self.tiled_height)
    self.s_drink=self:newSprite(self.ht_icon,self.tiled_width,self.tiled_height*6,self.tiled_width,self.tiled_height)
    self.s_heart=self:newSprite(self.ht_icon,self.tiled_width*2,self.tiled_height*6,self.tiled_width,self.tiled_height)
    self.s_expr=self:newSprite(self.ht_icon,self.tiled_width*3,self.tiled_height*6,self.tiled_width,self.tiled_height)
    self.s_time=self:newSprite(self.ht_icon,self.tiled_width,self.tiled_height*3,self.tiled_width,self.tiled_height)
    self.s_step=self:newSprite(self.ht_icon,self.tiled_width,self.tiled_height*4,self.tiled_width,self.tiled_height)
    self.s_damage=self:newSprite(self.ht_icon,self.tiled_width*2,self.tiled_height*5,self.tiled_width,self.tiled_height)
    self.s_enemyinfo=self:newSprite(self.ht_icon,self.tiled_width,self.tiled_height*2,self.tiled_width,self.tiled_height)
    self.s_bluejewel=self:newSprite(self.ht_icon,self.tiled_width*2,self.tiled_height,self.tiled_width,self.tiled_height)
    self.s_redjewel=self:newSprite(self.ht_icon,self.tiled_width*3,self.tiled_height,self.tiled_width,self.tiled_height)
    self.s_redpotion=self:newSprite(self.ht_icon,self.tiled_width*2,self.tiled_height*2,self.tiled_width,self.tiled_height)
    self.s_bluepotion=self:newSprite(self.ht_icon,self.tiled_width*3,self.tiled_height*2,self.tiled_width,self.tiled_height)
    self.s_sword1=self:newSprite(self.ht_icon,0,self.tiled_height,self.tiled_width,self.tiled_height)
    self.s_shield1=self:newSprite(self.ht_icon,self.tiled_width,self.tiled_height,self.tiled_width,self.tiled_height)
    self.s_sword2=self:newSprite(self.ht_icon,0,self.tiled_height*3,self.tiled_width,self.tiled_height)
    self.s_shield2=self:newSprite(self.ht_icon,0,self.tiled_height*4,self.tiled_width,self.tiled_height)
    self.s_sword3=self:newSprite(self.ht_icon,self.tiled_width*3,self.tiled_height*3,self.tiled_width,self.tiled_height)
    self.s_shield3=self:newSprite(self.ht_icon,self.tiled_width*3,self.tiled_height*4,self.tiled_width,self.tiled_height)
    --special
    self.s_sigh=self:newSprite(self.ht_special,self.tiled_width*6,self.tiled_height*25,self.tiled_width,self.tiled_height)
    self.s_sighed=self:newSprite(self.ht_special,self.tiled_width*6,self.tiled_height*26,self.tiled_width,self.tiled_height)
    self.s_up=self:newSprite(self.ht_special,0,self.tiled_height*29,self.tiled_width,self.tiled_height)
    self.s_down=self:newSprite(self.ht_special,self.tiled_width,self.tiled_height*29,self.tiled_width,self.tiled_height)
    self.s_left=self:newSprite(self.ht_special,self.tiled_width*2,self.tiled_height*29,self.tiled_width,self.tiled_height)
    self.s_right=self:newSprite(self.ht_special,self.tiled_width*3,self.tiled_height*29,self.tiled_width,self.tiled_height)
    self.s_portal=self:newSprite(self.ht_special,self.tiled_width*6,self.tiled_height*29,self.tiled_width,self.tiled_height)
    self.s_flower=self:newSprite(self.ht_special,self.tiled_width*7,self.tiled_height*23,self.tiled_width,self.tiled_height)
    self.s_box=self:newSprite(self.ht_special,self.tiled_width*6,self.tiled_height*24,self.tiled_width,self.tiled_height)
    self.s_boxed=self:newSprite(self.ht_special,self.tiled_width*7,self.tiled_height*24,self.tiled_width,self.tiled_height)
    self.s_atk=self:newSprite(self.ht_special,self.tiled_width*7,self.tiled_height*26,self.tiled_width,self.tiled_height)
    self.s_def=self:newSprite(self.ht_special,self.tiled_width*7,self.tiled_height*27,self.tiled_width,self.tiled_height)
    self.s_life=self:newSprite(self.ht_special,self.tiled_width*7,self.tiled_height*27,self.tiled_width,self.tiled_height)
    
    self.monsters = {}
    self.monsters[1]={name='绿色史莱姆',position=0,hp=50,atk=20,def=1,money=1,experience=1,special=0}
    self.monsters[2]={name='红色史莱姆',position=1,hp=70,atk=15,def=2,money=2,experience=2,special=0}
    self.monsters[3]={name='青头怪',position=2,hp=200,atk=35,def=10,money=5,experience=5,special=0}
    self.monsters[4]={name='史莱姆王',position=3,hp=700,atk=250,def=125,money=32,experience=30,special=0}
    self.monsters[5]={name='小蝙蝠',position=4,hp=100,atk=20,def=5,money=3,experience=3,special=0}
    self.monsters[6]={name='大蝙蝠',position=5,hp=150,atk=65,def=30,money=10,experience=8,special=0}
    self.monsters[7]={name='红蝙蝠',position=6,hp=550,atk=160,def=95,money=25,experience=20,special=0}
    self.monsters[8]={name='冥灵魔王',position=7,hp=30000,atk=2100,def=1700,money=250,experience=220,special=0}
    self.monsters[9]={name='初级法师',position=8,hp=125,atk=50,def=25,money=10,experience=7,special=0}
    self.monsters[10]={name='高级法师',position=9,hp=1000,atk=200,def=110,money=30,experience=25,special=0}
    self.monsters[11]={name='初级巫师',position=10,hp=500,atk=120,def=70,money=20,experience=17,special=3}
    self.monsters[12]={name='高级巫师',position=11,hp=1234,atk=400,def=260,money=47,experience=45,special=3}
    self.monsters[13]={name='骷髅人',position=12,hp=110,atk=25,def=5,money=5,experience=4,special=0}
    self.monsters[14]={name='骷髅士兵',position=13,hp=150,atk=40,def=20,money=8,experience=6,special=0}
    self.monsters[15]={name='骷髅队长',position=14,hp=400,atk=90,def=50,money=15,experience=12,special=0}
    self.monsters[16]={name='冥队长',position=15,hp=3000,atk=880,def=790,money=80,experience=72,special=0}
    self.monsters[17]={name='兽人',position=16,hp=300,atk=75,def=45,money=13,experience=10,special=0}
    self.monsters[18]={name='兽面武士',position=17,hp=900,atk=450,def=330,money=50,experience=50,special=0}
    self.monsters[19]={name='石头人',position=18,hp=30,atk=95,def=0,money=15,experience=15,special=2}
    self.monsters[20]={name='影子战士',position=19,hp=3100,atk=1250,def=1050,money=105,experience=95,special=0}
    self.monsters[21]={name='初级卫兵',position=20,hp=450,atk=150,def=90,money=22,experience=19,special=0}
    self.monsters[22]={name='中级卫兵',position=21,hp=1250,atk=500,def=400,money=55,experience=55,special=0}
    self.monsters[23]={name='高级卫兵',position=22,hp=1500,atk=560,def=460,money=60,experience=60,special=0}
    self.monsters[24]={name='双手剑士',position=23,hp=1200,atk=620,def=520,money=65,experience=75,special=0}
    self.monsters[25]={name='冥战士',position=24,hp=2000,atk=680,def=590,money=70,experience=65,special=0}
    self.monsters[26]={name='初级骑士',position=25,hp=850,atk=350,def=200,money=45,experience=40,special=0}
    self.monsters[27]={name='高级骑士',position=26,hp=900,atk=750,def=650,money=77,experience=70,special=0}
    self.monsters[28]={name='灵武士',position=27,hp=3000,atk=980,def=900,money=88,experience=75,special=0}
    self.monsters[29]={name='红衣魔王',position=28,hp=15000,atk=1000,def=1000,money=100,experience=100,special=0}
    self.monsters[30]={name='魔法警卫',position=29,hp=1300,atk=300,def=150,money=40,experience=35,special=1}
    self.monsters[31]={name='灵法师',position=30,hp=1500,atk=830,def=730,money=80,experience=70,special=1}
    self.monsters[36]={name='冥队长',position=15,hp=3333,atk=1200,def=1133,money=112,experience=100,special=0}
    self.monsters[38]={name='黑衣魔王',position=36,hp=50000,atk=3300,def=2600,money=0,experience=0,special=0}
    self.monsters[39]={name='铁面人',position=34,hp=50,atk=1221,def=0,money=127,experience=111,special=2}
    self.monsters[46]={name='高级巫师',position=11,hp=5000,atk=2500,def=1500,money=0,experience=0,special=3}
    self.monsters[47]={name='铁面人',position=34,hp=100,atk=2333,def=0,money=0,experience=0,special=2}
    self.monsters[48]={name='灵武士',position=27,hp=1600,atk=1306,def=1200,money=117,experience=100,special=0}
    self.monsters[49]={name='红衣魔王',position=28,hp=20000,atk=1777,def=1444,money=133,experience=133,special=0}
    
    self:initMonstersSprite(49)
    
    self:initNpcsSprite(8)
    
    self:initFloorMaps()
    
    self:initMsgBox()

    self.hero = Hero:new()
    self.hero:init()
end

--新建quad,这个是sprite的另一种表示方法,quad只包含sprite图片位置参数
function Game:newSprite(img, x, y, width, height)
    local sprite ={quad = nil, img = nil, innerID = -1}
    sprite.quad = love.graphics.newQuad(x, y, width, height, img:getDimensions())
    sprite.img = img
    sprite.innerID = self.spriteInnerID
    self.spriteInnerID = self.spriteInnerID + 1
    return sprite
end


function Game:initHeroSprite()
    self.heroSprite = {}
    for i=1,4 do
        self.heroSprite[i] = {}
    end
    
    for i=1,4 do -- 4个动作
        for j=1,4 do -- 4个方向 1下2左3右4上
            self.heroSprite[i][j] = self:newSprite(self.ht_hero,(i-1)*self.tiled_width,(j-1)*(self.tiled_height+1),self.tiled_width,self.tiled_height+1)
        end
    end
end

function Game:initMonstersSprite(monsterCount)
    self.monstersSprite = {}
    for i=1, monsterCount do --- monsterCount只怪物
        self.monstersSprite[i] = {}
    end
    
    for i=1, monsterCount do
        for j=1,4 do -- 每只4张图片
            self.monstersSprite[i][j] = {}
        end
    end

    for i=1, monsterCount do
        for j=1,4 do
            local monster = self.monsters[i]
            if monster then
                local position = monster.position
                self.monstersSprite[i][j] = self:newSprite(self.ht_monster,self.tiled_width*(j-1),self.tiled_height*position,self.tiled_width,self.tiled_height)
            end
        end
    end
end

function Game:initNpcsSprite(npcCount)
    self.npcsSprite = {}
    for i=1, npcCount do --- npcCount种Npc
        self.npcsSprite[i] = {}
        for j=1,4 do -- 每种4张图片
            self.npcsSprite[i][j] = {}
        end
    end

    for i=1,4 do
        self.npcsSprite[1][i]=self:newSprite(self.ht_npc,self.tiled_width*(i-1),self.tiled_height*7,self.tiled_width,self.tiled_height) --公主51 52
        self.npcsSprite[2][i]=self:newSprite(self.ht_npc,self.tiled_width*(i-1),self.tiled_height*6,self.tiled_width,self.tiled_height) --蓝色商店 47 48
        self.npcsSprite[3][i]=self:newSprite(self.ht_npc,self.tiled_width*(i-1),0,                  self.tiled_width,self.tiled_height)   --老人 40 41 45 49 53 55->
        self.npcsSprite[4][i]=self:newSprite(self.ht_npc,self.tiled_width*(i-1),self.tiled_height,  self.tiled_width,self.tiled_height); --[32] 42 46 50 54 
        self.npcsSprite[5][i]=self:newSprite(self.ht_npc,self.tiled_width*(i-1),self.tiled_height*2,self.tiled_width,self.tiled_height); --[64] 43 51
        self.npcsSprite[6][i]=self:newSprite(self.ht_npc,self.tiled_width*(i-1),self.tiled_height*3,self.tiled_width,self.tiled_height); --[96] 44  
    end
end

function Game:getNpcSprites(npcID)
    if npcID==51 or npcID==52 then
        return self.npcsSprite[1]
    elseif npcID==47 or npcID==48 then
        return self.npcsSprite[2]
    elseif (npcID==40 or npcID==41 or npcID==45 or npcID==49 or npcID==53 or npcID==48 or npcID>=55) then
        return self.npcsSprite[3]
    elseif (npcID==42 or npcID==46 or npcID==50 or npcID==54) then
        return self.npcsSprite[4]
    elseif (npcID==43 or npcID==51) then
        return self.npcsSprite[5]
    elseif (npcID==44) then
        return self.npcsSprite[6]
    else
        return nil
    end
end


function Game:update(dt)
    self.hero:update(dt)

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

    --前方遇到NPC
    if self.state == 'GAME_STATE_MEET_NPC' then
        local npcID = self.activeItemID
        self.hero:meetNpc(self, npcID)
    end
end

function Game:isFree()
    if (self.moving) then
        return false 
    end
    
    if (not self.state == 'GAME_STATE_NONE') then
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
    love.graphics.draw(sprite.img, sprite.quad, (j-1)*self.tiled_width + self.ScreenLeft, (i-1)*self.tiled_height)
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