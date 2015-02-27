--
-- Author: bacoo
-- Date: 2014-07-09 21:37:41
--
local LoveAndGame = class("LoveAndGame", function( ... )
    return display.newLayer()
end)

local love_y = display.top-580

function LoveAndGame:ctor()
    --创建我的游戏按钮
    self.myGameBtn = one.btn({"Main_My_Info_Game",3}, display.cx-205, love_y, function( ... )
        --判断要是目前在我的收藏的选项，且在展示榜就关榜
        if self.myGameBtn:getZOrder() == -2 and tar.allNode.myInfo.ifShowRank then
            tar.allNode.myInfo:hideRank()
        end
        --设置游戏按钮zorder-1
        self.myGameBtn:setZOrder(-1)
        --设置不可点击
        self.myGameBtn:setButtonEnabled(false)
        --设置收藏按钮zorder-2，可点击
        self.myLoveBtn:setZOrder(-2)
        self.myLoveBtn:setButtonEnabled(true)
        self.gameNode:setVisible(true)
        self.loveNode:setVisible(false)
        self:setFrame()
    end, nil, self)
    self.myGameBtn:setZOrder(-1)
    self.myGameBtn:setButtonEnabled(false)
    --创建我的收藏按钮
    self.myLoveBtn = one.btn({"Main_My_Info_Love",3}, display.cx-60, love_y, function( ... )
        --判断要是目前在我的游戏的选项，且在展示榜就关榜
        if self.myLoveBtn:getZOrder() == -2 and tar.allNode.myInfo.ifShowRank then
            tar.allNode.myInfo:hideRank()
        end
        --设置游戏按钮zorder-1
        self.myGameBtn:setZOrder(-2)
        --设置不可点击
        self.myGameBtn:setButtonEnabled(true)
        --设置收藏按钮zorder-2，可点击
        self.myLoveBtn:setZOrder(-1)
        self.myLoveBtn:setButtonEnabled(false)
        self.gameNode:setVisible(false)
        self.loveNode:setVisible(true)
        self:setFrame()
    end, nil, self)
    self.myLoveBtn:setZOrder(-2)
    --设置喜欢和游戏面板
    self.board = one.sp("Main_My_Love_Game_Board", display.cx, love_y-150, self)
    --创建我的游戏列表
    self.gameNode = require("lib.ListNode").new(self.board,self.board:getContentSize().width-20,self.board:getContentSize().height,"land",20,MIN_MOVE)
    self.gameNode:setPositionX(10)
    --创建我的收藏列表
    self.loveNode = require("lib.ListNode").new(self.board,self.board:getContentSize().width-20,self.board:getContentSize().height,"land",20,MIN_MOVE)
    self.loveNode:setPositionX(10)
    self.loveNode:setVisible(false)
    local game = user:getStringForKey("game")
    local love = user:getStringForKey("love")
    if game and love and game~="" and love~="" then
        game = json.decode(game)
        love = json.decode(love)
        self:initLoveAndGame(game, love)
    end
end

function LoveAndGame:initLoveAndGame(game,love)
    local game = json.encode(game)
    local love = json.encode(love)
    user:setStringForKey("game", game)
    user:setStringForKey("love", love)
    local game = json.decode(game)
    local love = json.decode(love)
    self.loveNode:removeAllItems()
    self.gameNode:removeAllItems()
    --获取全部游戏
    local allgames = user:getStringForKey("allgame")
    allgames = json.decode(allgames)
    --通过获取全部游戏的大图下载地址然后获取小图的下载地址
    local basic_url = allgames[1].img
    basic_url = string.sub(basic_url, 1,-6)
    local basic_x = 100
    local each_x = 170
    --添加我的游戏
    for i,v in ipairs(game) do
        function addToNode()
            -- local gameItem = one.sp(device.writablePath.."image/"..v.."_m", x, y, "")
            -- gameItem:addClick(function( event )
            --     self:setFrame()
            --     event.frame:setVisible(true)
            --     self:getParent():getParent():showRank(event.gameId,"game")
            -- end)
            local gameItem = one.btn(device.writablePath.."image/"..v.."_m", x, y, function( event )
                self:setFrame()
                event.frame:setVisible(true)
                self:getParent():getParent():showRank(event.gameId,"game")
            end, sound, "")
            self.gameNode:addItem(gameItem, XOrY,true)
            gameItem.frame = one.sp("Main_Love_And_Game_Select", gameItem:getContentSize().width/2, gameItem:getContentSize().height/2, gameItem)
            gameItem.frame:setVisible(false)
            gameItem.gameId = v
        end
        --判断是是否存在小图
        if io.exists(device.writablePath.."image/"..v.."_m.png") then
            addToNode()
        else
            ser:downLoadFile(SERVER_URL.."/download/"..v.."_m.png", device.writablePath.."image/"..v.."_m.png", addToNode)
        end
    end
    --增加添加游戏按钮
    self.addGameBtn = one.btn({"Main_My_Info_Add",2}, x, y, function( ... )
        self:performWithDelay(function( ... )
            tar.scroll.scene_fsm:doEvent("goallgame",function( ... )
            tar.allNode.allgame:addCallBack()
        end)
        end, 0.02)
        
    end, sound, "")
    self.gameNode:addItem(self.addGameBtn, XOrY)
    --添加我的收藏
    for i,v in ipairs(love) do
        function addToNode()
            -- local loveItem = one.sp(device.writablePath.."image/"..v.."_m", x, y, "")
            
            -- loveItem:addClick(function(event)
            --     self:setFrame()
            --     event.frame:setVisible(true)
            --     self:getParent():getParent():showRank(event.gameId,"love",event.own)
            -- end)
            local loveItem =  one.btn(device.writablePath.."image/"..v.."_m", x, y, function( event )
                self:setFrame()
                event.frame:setVisible(true)
                self:getParent():getParent():showRank(event.gameId,"love",event.own)
            end, sound, "")
            self.loveNode:addItem(loveItem, XOrY,true)
            loveItem.frame = one.sp("Main_Love_And_Game_Select", loveItem:getContentSize().width/2, loveItem:getContentSize().height/2, loveItem)
            loveItem.frame:setVisible(false)
            for ii,vv in ipairs(game) do
                if vv == v then
                    loveItem.own = true
                end
            end
            loveItem.gameId = v
        end
        --判断是是否存在小图
        if io.exists(device.writablePath.."image/"..v.."_m.png") then
            addToNode()
        else
            ser:downLoadFile(SERVER_URL.."/download/"..v.."_m.png", device.writablePath.."image/"..v.."_m.png", addToNode)
        end
    end
    --增加添加游戏按钮
    self.addLoveBtn = one.btn({"Main_My_Info_Add",2}, x, y, function( ... )
        self:performWithDelay(function( ... )
            tar.scroll.scene_fsm:doEvent("goallgame",function( ... )
            tar.allNode.allgame:loveCallBack()
        end)
        end, 0.02)
        
    end, sound, "")
    self.loveNode:addItem(self.addLoveBtn, XOrY)
end

function LoveAndGame:setFrame()
    for i,v in ipairs(self.loveNode.items) do
        if v.frame then
            v.frame:setVisible(false)
        end                end
    for i,v in ipairs(self.gameNode.items) do
        if v.frame then
            v.frame:setVisible(false)
        end
    end
end

function LoveAndGame:removeAllLovaAndGame()
    self.loveNode:removeAllItems()
    self.gameNode:removeAllItems()
end

function LoveAndGame:update()
    --获取我的游戏和我的收藏
    ser:getMine(function(game,love)
        --将我的游戏和我的收藏传入initLoveAndGame,初始化initLoveAndGame
        self:initLoveAndGame(game, love)
    end)
end


return LoveAndGame
