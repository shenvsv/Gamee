--
-- Author: bacoo
-- Date: 2014-07-09 13:38:16
--
local GameBoard = class("GameBoard", function()
    return one.sp("Main_All_Game_Board", x, y, "")
end)

--第一个的出事Y值
local first_y = 390
--每个的高度
local each_height = 500
--缩略图的y值
local image_y = 200

function GameBoard:ctor(index,name,date,id,img,url,own,fav,info)
    self.inInfo = 0
    --判断是否在rank中
    self.inRank = false
    self.url = url
    self.index = index
    self.name = name
    self.date = date
    self.id = id
    self.img = img
    self.own = own
    self.fav = fav
    local scale = 0.7
    if index ==1 then
        user:setIntegerForKey("newest", tonumber(id))
    end
    --添加游戏开始按钮
    self.play_btn  = one.btn({"Main_All_Game_Play",2}, self:w()/2+12, 58, function()
        local StartPlay = require("app.tools.StartPlay")
        StartPlay.play(self.id,string.sub(self.date, -5,-1),info)
    end, nil, self)
    self.play_btn:setZOrder(10)
    self.play_btn:setScale(scale)
    self.play_btn:hide()
    --添加够买按键
    self.buy_btn  = one.btn({"Main_Buy",2}, self:w()/2+12, 58, function()
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
            require("app.nodes.Dialog").new("确认花费1钻石购买\n"..self.name.."吗？",function( ... )
                tar.pay.game(self.id, function (event)
                    if event.stu == "ok" then
                        self.buy_btn:hide()
                        self.play_btn:show()
                        self.own = true
                        tar.allNode.today.newestGame.buy_btn:hide()
                        tar.allNode.today.newestGame.shareBtn:show()
                        tar.allNode.myInfo.loveAndGame:update()
                    else
                        print(event.msg)
                    end
                end)
            end)
        else
            require("app.nodes.Dialog").new("请先登录哦！~",function( ... )
                yixin:oauth()
            end)
        end
    end, nil, self)
    self.buy_btn:hide()
    self.buy_btn:setScale(scale)
    self.buy_btn:setZOrder(10)
    if own then
        self.buy_btn:hide()
        if index == 1 then
            if tar.allNode then
                tar.allNode.today.newestGame.buy_btn:hide()
                tar.allNode.today.newestGame.shareBtn:show()
            end
            --更新排行榜
            --  tar.allNode.today.todayRank:freshRank()
        end
    else
        self.play_btn:hide()
        if index == 1 then
            if tar.allNode then
                tar.allNode.today.newestGame.buy_btn:hide()
                tar.allNode.today.newestGame.shareBtn:hide()
            end
            --更新排行榜
            -- tar.allNode.today.todayRank:freshRank()
        end
    end
    self.lock_btn = one.btn({"Main_Lock",2}, 70, 58, function()
        local id = user:getIntegerForKey("id")
        if id and id ~= 0 then
            require("app.nodes.Dialog").new("没解锁，是否解锁",function()
                tar.pay.game(self.id, function (event)
                    if event.stu == "ok" then
                        self.lock_btn:hide()
                        -- tar.allNode.today.newestGame.buy_btn:hide()
                        -- tar.allNode.today.newestGame.shareBtn:show()
                        tar.allNode.myInfo.loveAndGame:update()
                        ser:getAll(function()
                            --设置名字
                            local name = user:getStringForKey("nick","")
                            self.info_name_label:setString(name)
                            --设置金钱数
                            local money = user:getIntegerForKey("money")
                            self.info_coin_label:setString(money)
                            --设置钻石数
                            local diamond = user:getIntegerForKey("diamond")
                            self.info_diamond_label:setString(diamond)
                            --设置道具数
                            local prop = user:getIntegerForKey("prop")
                            self.info_prop_label:setString(prop)
                            --设置体力值
                            local power = user:getIntegerForKey("power")
                            self.info_power_label:setString(power)
                            self.info_power:setPercentage(power)
                        end)
                    else
                        print(event.msg)
                    end
                end)
            end)
        else
            require("app.nodes.Dialog").new("请登录",function( ... )
                yixin:oauth()
            end)
        end
    end, sound, self)
    if self.own then
        self.lock_btn:hide()
    end
    -- if self.index == 1 then
    --     self.lock_btn:hide()
    -- end
    self.lock_btn:setZOrder(10)
    --添加排行按钮
    self.rank_btn = one.btn({"Main_Rank",2}, self:getContentSize().width/10*9-12, 58, function()
        if not self.world then
            ser:getRank(self.id, function(board,rank,score)
                local rankItem = require("app.nodes.RankItem")
                local first = fasle
                local id = user:getIntegerForKey("id")
                self.world = require("lib.ListNode").new(self.whiteBoard,self.whiteBoard:getContentSize().width,self.whiteBoard:getContentSize().height-52,"por",10,MIN_MOVE)
                self.world:setZOrder(10)
                if id and id~=0 then
                    local nick = user:getStringForKey("nick")
                    local item = rankItem.new(nil,1,nick,score,id,false,rank,true)
                    first = true
                    self.world:addItem(item)
                end
                for i,v in ipairs(board) do
                    local item = rankItem.new(nil,i,v.nick,v.score,v.id,true,nil,true)
                    self.world:addItem(item)
                end
                self.world:setVisible(false)
                if id and id~=0 then
                --todo
                else
                    self.select_board:x(self.yellowBar:w()/4*3-30)
                    self.world:setVisible(true)
                    if self.friend then
                        self.friend:setVisible(false)
                    end
                end
            end)
            ser:getFriendRank(self.id, function(board,rank,score)
                local rankItem = require("app.nodes.RankItem")
                local first = fasle
                local id = user:getIntegerForKey("id")
                self.friend = require("lib.ListNode").new(self.whiteBoard,self.whiteBoard:getContentSize().width,self.whiteBoard:getContentSize().height-52,"por",10,MIN_MOVE)
                self.friend:setZOrder(100)
                if id and id~=0 then
                    local nick = user:getStringForKey("nick")
                    -- local item = rankItem.new(nil,1,nick,score,id,false,rank,true)
                    -- first = true
                    -- self.friend:addItem(item)
                    for i,v in ipairs(board) do
                        if v.nick == nick then
                            local item = rankItem.new(nil,1,v.nick,v.score,v.id,true,i,true)
                            first = true
                            self.friend:addItem(item)
                        end
                    end
                end
                for i,v in ipairs(board) do
                    local item = rankItem.new(nil,i,v.nick,v.score,v.id,true,nil,true)
                    self.friend:addItem(item)
                end
            end)
        end
        local id = user:getIntegerForKey("id", 0)

        self:filp()
        tar.allNode.allgame:closeRank(self.index)
        self.infoBoard:setOpacity(0)
        self.info:setOpacity(0)
    end, sound, self)
    self.rank_btn:setZOrder(10)
    self.rank_btn:setScale(scale)
    -- self.rank_btn:setTouchSwallowEnabled(true)
    --添加排行按钮
    self.back_btn = one.btn({"Main_Back",2}, self:getContentSize().width/10*9-12, 58, function()
        self:filp()
        self.infoBoard:setOpacity(255)
        self.info:setOpacity(255)
        tar.allNode.allgame.lastRank = nil
    end, sound, self)
    --   self.back_btn:setTouchSwallowEnabled(true)
    self.back_btn:setZOrder(10)
    self.back_btn:setVisible(false)
    self.back_btn:setScale(scale)
    --  self.back_btn:setTouchSwallowEnabled(true)
    --添加收藏按钮
    self.love_btn = one.btn({"Main_Love",2}, self:getContentSize().width/10*7+4, 58, function()
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
            self.love_btn:hide()
            self.have_love_btn:show()
            tar.game.fav (self.id, function (event)
                if event.stu == "ok" then
                    tar.allNode.myInfo.loveAndGame:update()
                    if tar.allNode.myInfo.ifShowRank then
                        tar.allNode.myInfo:hideRank()
                    end
                    if self.index == 1 then
                        tar.allNode.today.newestGame.love_btn:hide()
                        tar.allNode.today.newestGame.have_love_btn:show()
                    end
                    --toast
                    local toast = one.sp("Main_Toast", display.cx, 140, tar)
                    toast:setZOrder(100)
                    local ttf = one.ttf("收藏成功", toast:w()/2, toast:h()/2+2, 30, ccc3(255, 255, 255),MAIN_FONT, align, toast)
                    toast:setOpacity(0)
                    ttf:setOpacity(0)
                    local inn = CCFadeIn:create(0.5)
                    local de = CCDelayTime:create(1)
                    local out = CCFadeOut:create(0.5)
                    local ac = transition.sequence({inn,de,out})
                    toast:runAction(ac)
                    local inn = CCFadeIn:create(0.5)
                    local de = CCDelayTime:create(1)
                    local out = CCFadeOut:create(0.5)
                    local call = CCCallFunc:create(function()
                        toast:removeSelf()
                    end)
                    local ac = transition.sequence({inn,de,out,call})
                    ttf:runAction(ac)
                else
                    print(event.msg)
                end
            end)
        end
    end, sound, self)
    self.love_btn:setZOrder(10)
    --   self.love_btn:setTouchSwallowEnabled(true)
    self.love_btn:setScale(scale)
    --添加收藏过按钮
    self.have_love_btn = one.btn({"Main_Love_fav",2},  self:getContentSize().width/10*7+4, 58, function()
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
            self.love_btn:show()
            self.have_love_btn:hide()
            tar.game.fav (self.id, function (event)
                if event.stu == "ok" then
                    tar.allNode.myInfo.loveAndGame:update()
                    if tar.allNode.myInfo.ifShowRank then
                        tar.allNode.myInfo:hideRank()
                    end
                    if self.index == 1 then
                        tar.allNode.today.newestGame.have_love_btn:hide()
                        tar.allNode.today.newestGame.love_btn:show()
                    end
                    --toast
                    local toast = one.sp("Main_Toast", display.cx, 140, tar)
                    toast:setZOrder(100)
                    local ttf = one.ttf("取消成功", toast:w()/2, toast:h()/2+2, 30, ccc3(255, 255, 255),MAIN_FONT, align, toast)
                    toast:setOpacity(0)
                    ttf:setOpacity(0)
                    local inn = CCFadeIn:create(0.5)
                    local de = CCDelayTime:create(1)
                    local out = CCFadeOut:create(0.5)
                    local ac = transition.sequence({inn,de,out})
                    toast:runAction(ac)
                    local inn = CCFadeIn:create(0.5)
                    local de = CCDelayTime:create(1)
                    local out = CCFadeOut:create(0.5)
                    local call = CCCallFunc:create(function()
                        toast:removeSelf()
                    end)
                    local ac = transition.sequence({inn,de,out,call})
                    ttf:runAction(ac)
                else
                    print(event.msg)
                end
            end)
        end
    end, sound, self)
    self.have_love_btn:setZOrder(10)
    self.have_love_btn:setScale(scale)
    -- self.have_love_btn:setTouchSwallowEnabled(true)
    if fav then
        self.love_btn:hide()
    else
        self.have_love_btn:hide()
    end
    --添加标题地板
    self.mask = one.btn({"Main_All_Game_Name_Tip",2},480, 410, function()
        if self.inInfo == 1 then
            self:clickInfo()
            tar.allNode.allgame.last = nil
        else
            tar.allNode.allgame:closeLastInfo(self.index)
            self:clickInfo()
        end
    end, sound, self)
    self.mask:setZOrder(100)
    --  self.mask:setTouchSwallowEnabled(true)
    self.infoBoard = one.sp("Main_All_Game_Info_Board", self:getContentSize().width-18, self:getContentSize().height-18, self)
    self.infoBoard:ap(ccp(1, 1))
    self.infoBoard:setZOrder(99)
    self.infoBoard:setScale(0)
    self.info = one.ttf(info or "这是一个测试，\n简单有趣的测试！", self.infoBoard:w()/2, self.infoBoard:h()/2, 30, BUY_WINDOW_HEVEY_COLOR, MAIN_FONT, align, self.infoBoard)
    --游戏名字
    self.nameLebel = one.ttf(name, self.mask:getContentSize().width/3*2, 47, ALL_GAME_NAME_SIZE, ALL_GAME_NAME_COLOR, MAIN_FONT, align, self.mask)
    self.nameLebel:setZOrder(10)
    --游戏的日期
    self.dateLebel = one.ttf(string.sub(date, 4,-1), 100, 47, ALL_GAME_NAME_SIZE, ALL_GAME_NAME_COLOR, MAIN_FONT, align, self.mask)
    self.dateLebel:x(34+self.dateLebel:w()/2)
    self.dateLebel:setZOrder(10)
    --判断图片是否存在
    --如果存在用存在的Id的图片
    if io.exists(device.writablePath.."image/"..id..".png") then
        self.game = one.sp(device.writablePath.."image/"..id, self:w()/2, self:h()/2, self)
        --如果Index ==1。即为最新游戏的话更新首页的信息
        if self.index == 1 then
            if tar.allNode then
                if self.id ~= tar.allNode.today.newestGame.id then

                    tar.allNode.today.newestGame.name = self.name
                    tar.allNode.today.newestGame.id = self.id
                    tar.allNode.today.newestGame.date = self.date
                    if tar.allNode.today.newestGame.gameImage then
                        tar.allNode.today.newestGame.gameImage:removeSelf()
                    end
                    -- tar.allNode.today.newestGame.gameImage = one.sp(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, tar.allNode.today.newestGame)
                    -- tar.allNode.today.newestGame.gameImage:setScaleY(0.9)
                    tar.allNode.today.newestGame.gameImage = one.btn(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, function()
                        tar.game.start(self.gameId)
                    end, sound, tar.allNode.today.newestGame)
                    tar.allNode.today.newestGame.gameImage:setScaleY(0.9)
                    tar.allNode.today.newestGame.date_tip:setString(string.sub(self.date, -5,-1))
                    tar.allNode.today.todayRank:getBothRank(self.id)
                end

            end
        end
        --要是不存在就先用默认的图片，然后下载，最后动态更新
    else
        ser:downLoadFile(img, device.writablePath.."image/"..id..".png", function()
            self.game = one.sp(device.writablePath.."image/"..id, self:w()/2, self:h()/2, self)
            if self.index == 1 then
                if self.id ~= tar.allNode.today.newestGame.id then
                    tar.allNode.today.newestGame.name = self.name
                    tar.allNode.today.newestGame.id = self.id
                    tar.allNode.today.newestGame.date = self.date
                    if tar.allNode.today.newestGame.gameImage then
                        tar.allNode.today.newestGame.gameImage:removeSelf()
                    end
                    -- tar.allNode.today.newestGame.gameImage = one.sp(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, tar.allNode.today.newestGame)
                    -- tar.allNode.today.newestGame.gameImage:setScaleY(0.9)
                    tar.allNode.today.newestGame.gameImage = one.btn(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, function()
                        tar.game.start(self.gameId)
                    end, sound, tar.allNode.today.newestGame)
                    tar.allNode.today.newestGame.gameImage:setScaleY(0.9)
                    tar.allNode.today.newestGame.date_tip:setString(string.sub(self.date, -5,-1))
                    tar.allNode.today.todayRank:getBothRank(self.id)
                end
            end
        end)
        ser:downLoadFile(string.sub(img,1,-5).."_m.png", device.writablePath.."image/"..id.."_m.png", nil)
    end
    if self.index == 1 then
        self.newTip = one.sp("Main_All_Game_Tip", 0, self:h(), self)
        self.newTip:ap(ccp(0,1))
        self.newTip:setZOrder(1000)
        if tar.allNode then
            tar.allNode.today.todayRank:getBothRank(self.id)
        end
    end
    --创建排行榜Node
    self.rankNode =  display.newNode()
    self:addChild(self.rankNode)
    self.rankNode:setVisible(false)
    --创建白板
    self.whiteBoard = one.sp9("Main_My_Info_Rank_White", self:w()/2, self:h()/2, CCSize(self:w()-40, self:h()-30), self.rankNode)
    --创建黄条
    self.yellowBar = one.sp9("Main_My_Info_Rank_Yellow",self.whiteBoard:w()/2 , self.whiteBoard:h()-26, CCSize(self.whiteBoard:w(), 53), self.whiteBoard)
    --创建按键
    self.select_board = one.sp("Main_Rank_Select_Board", self.yellowBar:w()/4+30, self.yellowBar:h()-28, self.yellowBar)
    --创建好友
    self.fri_btn = one.btn("Main_Fri_Rank_Lebel", self.yellowBar:w()/4+30, self.yellowBar:h()-25.5, function( ... )
        --移动按键板
        self.select_board:x(self.yellowBar:w()/4+30)
        self.world:setVisible(false)
        if self.friend then
            self.friend:setVisible(true)
        end
    end, nil, self.yellowBar)
    --创建世界
    self.world_btn = one.btn({"Main_World_Rank_Lebel",2}, self.yellowBar:w()/4*3-30, self.yellowBar:h()-25.5, function( ... )
        --移动按键板
        self.select_board:x(self.yellowBar:w()/4*3-30)
        self.world:setVisible(true)
        if self.friend then
            self.friend:setVisible(false)
        end
    end, nil, self.yellowBar)
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
    self:setTouchCaptureEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            if self.inRank then
                for i,v in ipairs(tar.allNode.allgame.gameBoards) do
                    if i~=self.index then
                        if not v:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) then
                            tar.allNode.allgame.list:setTouchEnabled(false)
                        else
                            self:filp()
                            self.infoBoard:setOpacity(255)
                            self.info:setOpacity(255)
                            tar.allNode.allgame.lastRank = nil
                            return true
                        end
                    end

                end
            else
                self._x = event.x
                self._y = event.y
                -- if self.own then
                --     print(true)
                -- else
                --     require("app.nodes.Dialog").new("没解锁，是否解锁",function()
                --         print("lala")
                --     end)
                -- end
            end
            return true
        elseif event.name == "ended" then
            if self._x then
                if self._x == event.x and self._y == event.y then
                    if self.rank_btn:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) or self.back_btn:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) or self.love_btn:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) or self.have_love_btn:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) or self.mask:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) or self.lock_btn:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) then
                    -- print(1111)
                        
                    else
                        if self.index == 1 then
                       --  app:enterScene("Gamee_2_Scene")
                         tar.game.start(self.id)
                         tar.allNode.allgame.list:setTouchEnabled(true)
                        if self.world then
                            self.world:setTouchEnabled(true)
                        end
                        if self.friend then
                            self.friend:setTouchEnabled(true)
                        end
                        self._x = nil
                        self._y = nil
                        return
                        elseif self.own then
                         --   print("own")
                            tar.game.start(self.id)
                            tar.allNode.allgame.list:setTouchEnabled(true)
                            if self.world then
                                self.world:setTouchEnabled(true)
                            end
                            if self.friend then
                                self.friend:setTouchEnabled(true)
                            end
                            self._x = nil
                            self._y = nil
                            return

                        else
                            local id = user:getIntegerForKey("id")
                            if id and id ~= 0 then
                                require("app.nodes.Dialog").new("没解锁，是否解锁",function()
                                    tar.pay.game(self.id, function (event)
                                        if event.stu == "ok" then
                                            self.lock_btn:hide()
                                            -- tar.allNode.today.newestGame.buy_btn:hide()
                                            -- tar.allNode.today.newestGame.shareBtn:show()
                                            tar.allNode.myInfo.loveAndGame:update()
                                            self.own = true
                                            ser:getAll(function()
                                                --设置名字
                                                local name = user:getStringForKey("nick","")
                                                self.info_name_label:setString(name)
                                                --设置金钱数
                                                local money = user:getIntegerForKey("money")
                                                self.info_coin_label:setString(money)
                                                --设置钻石数
                                                local diamond = user:getIntegerForKey("diamond")
                                                self.info_diamond_label:setString(diamond)
                                                --设置道具数
                                                local prop = user:getIntegerForKey("prop")
                                                self.info_prop_label:setString(prop)
                                                --设置体力值
                                                local power = user:getIntegerForKey("power")
                                                self.info_power_label:setString(power)
                                                self.info_power:setPercentage(power)
                                            end)
                                        else
                                            print(event.msg)
                                        end
                                    end)
                                end)
                            else
                                require("app.nodes.Dialog").new("请登录",function( ... )
                                    yixin:oauth()
                                end)
                            end
                        end
                    end
                end
            end
            tar.allNode.allgame.list:setTouchEnabled(true)
            if self.world then
                self.world:setTouchEnabled(true)
            end
            if self.friend then
                self.friend:setTouchEnabled(true)
            end
            self._x = nil
            self._y = nil
        end
    end)
end

function GameBoard:filp()
    --翻转
    local filp_1 = CCOrbitCamera:create(0.2, 1, 0, 0, 180, 0, 0)
    --换成排行榜
    local call_1 = CCCallFunc:create(function()
        -- self.name:setVisible(self.inRank)
        --self.date:setVisible(self.inRank)
        --self.buy_btn:setVisible(self.inRank)
        self.mask:setVisible(self.inRank)
        self.rank_btn:setVisible(self.inRank)
        self.rankNode:setVisible(not self.inRank)
        --self.love_btn:setVisible(self.inRank)
        self.game:setVisible(self.inRank)
        self.back_btn:setVisible(not self.inRank)
        if self.newTip then
            self.newTip:setVisible(self.inRank)
        end
        self.inRank = not self.inRank
        self.love_btn:setOpacity(math.abs(self.love_btn:getOpacity()-255))
        self.love_btn:setTouchEnabled(not self.love_btn:isTouchEnabled())
        self.have_love_btn:setOpacity(math.abs(self.have_love_btn:getOpacity()-255))
        self.have_love_btn:setTouchEnabled(not self.have_love_btn:isTouchEnabled())
        self.rank_btn:setButtonEnabled(false)
        self.back_btn:setButtonEnabled(false)
    end)
    --翻转
    local filp_2 = CCOrbitCamera:create(0.2, 1, 0, 180, 180, 0, 0)
    local call_2 = CCCallFunc:create(function()
        self.rank_btn:setButtonEnabled(true)
        self.back_btn:setButtonEnabled(true)
    end)
    local action = transition.sequence({filp_1,call_1,filp_2,call_2})
    self:runAction(action)
end

function GameBoard:clickInfo()
    self.inInfo = math.abs(self.inInfo-1)
    one.action(self.infoBoard, "scaleto", 0.3, self.inInfo, "expout", cal)
end


function GameBoard:refreshRank()
    if self.world then
        self.world:removeSelf()
    end
    if self.friend then
        self.friend:removeSelf()
    end
    self.world = nil
    self.friend = nil
    if not self.world then
        ser:getRank(self.id, function(board,rank,score)
            local rankItem = require("app.nodes.RankItem")
            local first = fasle
            local id = user:getIntegerForKey("id")
            self.world = require("lib.ListNode").new(self.whiteBoard,self.whiteBoard:getContentSize().width,self.whiteBoard:getContentSize().height-52,"por",10,MIN_MOVE)
            self.world:setZOrder(100)
            if id and id~=0 then
                local nick = user:getStringForKey("nick")
                local item = rankItem.new(nil,1,nick,score,id,false,rank,true)
                first = true
                self.world:addItem(item)
            end
            for i,v in ipairs(board) do
                local item = rankItem.new(nil,i,v.nick,v.score,v.id,true,nil,true)
                self.world:addItem(item)
            end
            self.world:setVisible(false)
            if id and id~=0 then
            --todo
            else
                self.select_board:x(self.yellowBar:w()/4*3-30)
                self.world:setVisible(true)
                if self.friend then
                    self.friend:setVisible(false)
                end
            end
        end)
        ser:getFriendRank(self.id, function(board,rank,score)
            local rankItem = require("app.nodes.RankItem")
            local first = fasle
            local id = user:getIntegerForKey("id")
            self.friend = require("lib.ListNode").new(self.whiteBoard,self.whiteBoard:getContentSize().width,self.whiteBoard:getContentSize().height-52,"por",10,MIN_MOVE)
            self.friend:setZOrder(100)
            if id and id~=0 then
                local nick = user:getStringForKey("nick")
                -- local item = rankItem.new(nil,1,nick,score,id,false,rank,true)
                -- first = true
                -- self.friend:addItem(item)
                for i,v in ipairs(board) do
                    if v.nick == nick then
                        local item = rankItem.new(nil,1,v.nick,v.score,v.id,true,i,true)
                        first = true
                        self.friend:addItem(item)
                    end
                end
            end
            for i,v in ipairs(board) do
                local item = rankItem.new(nil,i,v.nick,v.score,v.id,true,nil,true)
                self.friend:addItem(item)
            end
            local id = user:getIntegerForKey("id", 0)
            if id and id ~=0 then
                --移动按键板
                self.select_board:x(self.yellowBar:w()/4+30)
                self.world:setVisible(false)
                if self.friend then
                    self.friend:setVisible(true)
                end
            else
                --移动按键板
                self.select_board:x(self.yellowBar:w()/4*3-30)
                self.world:setVisible(true)
                if self.friend then
                    self.friend:setVisible(false)
                end
            end
        end)
    end
end

return GameBoard



