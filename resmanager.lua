--资源文件管理器
local ResManager = class('ResManager')

function ResManager:initialize()
    --每一个sprite的唯一ID
    self.spriteInnerID = 1
    self.ht_res_map = {}
    self.sprite_map = {}
    self.sound_map = {}
    self.tiled_height = 32
    self.tiled_width = 32
    self.ScreenLeft = 0
    self.fontsize = 16
    self:initRes()
end

function ResManager:initRes()
    self:loadRes()
    self:initDoorSprite()
    self:initHeroSprite()
    self:initMonstersSprite()
    self:initNpcsSprite(8)
    self:initFont()
    self:initSfx()
end

function ResManager:loadRes()
    local i = 1
    local height = self.tiled_height
    local width = self.tiled_width
    
    local resources = 
    {
        {name = 'map',      filepath = 'Res/map.png'},
        {name = 'icon',     filepath = 'Res/icon.png'},
        {name = 'hero',     filepath = 'Res/hero.png'},
        {name = 'monster',  filepath = 'Res/monster.png'},
        {name = 'skin',     filepath = 'Res/skin.png'},
        {name = 'npc',      filepath = 'Res/npc.png'},
        {name = 'special',  filepath = 'Res/special.png'},
    }
    
    local sprites = 
    {
        --ht_map
        {name = 'ground',       res = 'map',        geometry = {0,0,width,height}},
        {name = 'wall',         res = 'map',        geometry = {width,0,width,height}},
        {name = 'water',        res = 'map',        geometry = {width,height,width,height}},
        {name = 'sky',          res = 'map',        geometry = {0,height,width,height}},
        {name = 'lightning',    res = 'npc',        geometry = {0,height*4,width,height}},
        {name = 'barrier',      res = 'special',    geometry = {width*4,height*30,width,height}},
        --ht_stair
        {name = 'downstair',    res = 'map',        geometry = {0,height*6,width,height}},
        {name = 'upstair',      res = 'map',        geometry = {width,height*6,width,height}},
        {name = 'shopleft',     res = 'map',        geometry = {0,height*7,width,height}},
        {name = 'shopright',    res = 'map',        geometry = {width*2,height*7,width,height}},
        --ht_item
        {name = 'yellowkey',    res = 'icon',       geometry = {0,0,width,height}},
        {name = 'bluekey',      res = 'icon',       geometry = {width,0,width,height}},
        {name = 'redkey',       res = 'icon',       geometry = {width*2,0,width,height}},
        {name = 'allkey',       res = 'icon',       geometry = {width*3,0,width,height}},
        {name = 'coin',         res = 'icon',       geometry = {0,height*2,width,height}},
        {name = 'fly',          res = 'icon',       geometry = {0,height*6,width,height}},
        {name = 'fly2',         res = 'icon',       geometry = {0,height*6,width,height}},
        {name = 'floor',        res = 'icon',       geometry = {width,height*5,width,height}},
        {name = 'level',        res = 'icon',       geometry = {width*2,height*4,width,height}},
        {name = 'storey',       res = 'icon',       geometry = {width*2,height*3,width,height}},
        {name = 'cross',        res = 'icon',       geometry = {width*3,height*5,width,height}},
        {name = 'stick',        res = 'icon',       geometry = {0,height*5,width,height}},
        {name = 'drink',        res = 'icon',       geometry = {width,height*6,width,height}},
        {name = 'heart',        res = 'icon',       geometry = {width*2,height*6,width,height}},
        {name = 'expr',         res = 'icon',       geometry = {width*3,height*6,width,height}},
        {name = 'time',         res = 'icon',       geometry = {width,height*3,width,height}},
        {name = 'step',         res = 'icon',       geometry = {width,height*4,width,height}},
        {name = 'damage',       res = 'icon',       geometry = {width*2,height*5,width,height}},
        {name = 'enemyinfo',    res = 'icon',       geometry = {width,height*2,width,height}},
        {name = 'bluejewel',    res = 'icon',       geometry = {width*2,height,width,height}},
        {name = 'redjewel',     res = 'icon',       geometry = {width*3,height,width,height}},
        {name = 'redpotion',    res = 'icon',       geometry = {width*2,height*2,width,height}},
        {name = 'bluepotion',   res = 'icon',       geometry = {width*3,height*2,width,height}},
        {name = 'sword1',       res = 'icon',       geometry = {0,height,width,height}},
        {name = 'shield1',      res = 'icon',       geometry = {width,height,width,height}},
        {name = 'sword2',       res = 'icon',       geometry = {0,height*3,width,height}},
        {name = 'shield2',      res = 'icon',       geometry = {0,height*4,width,height}},
        {name = 'sword3',       res = 'icon',       geometry = {width*3,height*3,width,height}},
        {name = 'shield3',      res = 'icon',       geometry = {width*3,height*4,width,height}},
        --special
        {name = 'sigh',         res = 'special',    geometry = {width*6,height*25,width,height}},
        {name = 'sighed',       res = 'special',    geometry = {width*6,height*26,width,height}},
        {name = 'up',           res = 'special',    geometry = {0,height*29,width,height}},
        {name = 'down',         res = 'special',    geometry = {width,height*29,width,height}},
        {name = 'left',         res = 'special',    geometry = {width*2,height*29,width,height}},
        {name = 'right',        res = 'special',    geometry = {width*3,height*29,width,height}},
        {name = 'portal',       res = 'special',    geometry = {width*6,height*29,width,height}},
        {name = 'flower',       res = 'special',    geometry = {width*7,height*23,width,height}},
        {name = 'box',          res = 'special',    geometry = {width*6,height*24,width,height}},
        {name = 'boxed',        res = 'special',    geometry = {width*7,height*24,width,height}},
        {name = 'atk',          res = 'special',    geometry = {width*7,height*26,width,height}},
        {name = 'def',          res = 'special',    geometry = {width*7,height*27,width,height}},
        {name = 'life',         res = 'special',    geometry = {width*7,height*27,width,height}},
    }
    
    i = 1
    while(resources[i])
    do
        self.ht_res_map[resources[i].name] = love.graphics.newImage(resources[i].filepath)
        i = i + 1
    end
    
    i = 1
    
    local name = nil
    local res = nil
    local geometry = nil
    
    while(sprites[i])
    do
        name = sprites[i].name
        res = self.ht_res_map[sprites[i].res]
        geometry = sprites[i].geometry
        
        self.sprite_map[name] = self:newSprite(res, geometry[1],geometry[2],geometry[3],geometry[4])
        i = i + 1
    end
    
end

function ResManager:initDoorSprite()
    print('initDoorSprite')
    local res = self.ht_res_map['map']
    local height = self.tiled_height
    local width = self.tiled_width
    --ht_door
    self.doorSprite = {}
    self.doorSprite['yellow'] = {}
    self.doorSprite['blue'] = {}
    self.doorSprite['red'] = {}
    self.doorSprite['special'] = {}
    for i=1,4 do
        self.doorSprite['yellow'][i]       =   self:newSprite(res, 0,      height*(i+1),   width,height)
        self.doorSprite['blue'][i]         =   self:newSprite(res, width,  height*(i+1),   width,height)
        self.doorSprite['red'][i]          =   self:newSprite(res, width*2,height*(i+1),   width,height)
        self.doorSprite['special'][i]      =   self:newSprite(res, width*3,height*(i+1),   width,height)
    end
end

function ResManager:initHeroSprite()
    print('initHeroSprite')
    local res = self.ht_res_map['hero']
    local height = self.tiled_height
    local width = self.tiled_width
    
    self.heroSprite = {}
    for i=1,4 do -- 4个动作
        self.heroSprite[i] = {}
        for j=1,4 do -- 4个方向 1下2左3右4上
            self.heroSprite[i][j] = self:newSprite(res,(i-1)*width,(j-1)*(height+1),width,height+1)
        end
    end
end

function ResManager:initMonstersSprite()
    print('initMonstersSprite')
    local res = self.ht_res_map['monster']
    local height = self.tiled_height
    local width = self.tiled_width
    
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
    local monsterCount = 49
    
    self.monstersSprite = {}
    for i=1, monsterCount do --- monsterCount只怪物
        self.monstersSprite[i] = {}
        for j=1,4 do -- 每只4张图片
            self.monstersSprite[i][j] = {}
        end
    end

    for i=1, monsterCount do
        for j=1,4 do
            local monster = self.monsters[i]
            if monster then
                local position = monster.position
                self.monstersSprite[i][j] = self:newSprite(res,width*(j-1),height*position,width,height)
            end
        end
    end
end

function ResManager:initNpcsSprite()
    print('initNpcsSprite')
    local npcCount = 6
    local res = self.ht_res_map['npc']
    local height = self.tiled_height
    local width = self.tiled_width
    
    self.npcsSprite = {}
    for i=1, npcCount do
        self.npcsSprite[i] = {}
        for j=1,4 do
            self.npcsSprite[i][j] = {}
        end
    end

    for i=1,4 do
        self.npcsSprite[1][i]=self:newSprite(res,width*(i-1),height*7,width,height) --公主51 52
        self.npcsSprite[2][i]=self:newSprite(res,width*(i-1),height*6,width,height) --蓝色商店 47 48
        self.npcsSprite[3][i]=self:newSprite(res,width*(i-1),0,       width,height) --老人 40 41 45 49 53 55->
        self.npcsSprite[4][i]=self:newSprite(res,width*(i-1),height,  width,height) --[32] 42 46 50 54 
        self.npcsSprite[5][i]=self:newSprite(res,width*(i-1),height*2,width,height) --[64] 43 51
        self.npcsSprite[6][i]=self:newSprite(res,width*(i-1),height*3,width,height) --[96] 44  
    end
end

function ResManager:getNpcSprites(npcID)
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

function ResManager:initFont()
    self.hgef=love.graphics.newFont("Res/YaHeiConsolas.ttf", self.fontsize)
    love.graphics.setFont(self.hgef)
end

function ResManager:initSfx()
    self.sound_map['getItem']=love.audio.newSource("Res/item.ogg", "static")
    self.sound_map['doorOpen']=love.audio.newSource("Res/door.ogg", "static")
    self.sound_map['attack']=love.audio.newSource("Res/attack.ogg", "static")
    --self.he_Music=love.audio.newSource("Res/bgm.mp3", "static")
end

function ResManager:playBGM(soundID)
    local sound = self.sound_map[soundID]
    love.audio.play(sound)
end

--新建quad,这个是sprite的另一种表示方法,quad只包含sprite图片位置参数
function ResManager:newSprite(img, x, y, width, height)
    local sprite ={quad = nil, img = nil, innerID = -1}
    sprite.quad = love.graphics.newQuad(x, y, width, height, img:getDimensions())
    sprite.img = img
    sprite.innerID = self.spriteInnerID
    self.spriteInnerID = self.spriteInnerID + 1
    return sprite
end

return ResManager