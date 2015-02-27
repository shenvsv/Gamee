--
-- Author: bacoo
-- Date: 2014-07-08 17:37:37
--
local MyInfo = class("MyInfo", function( ... )
    return display.newLayer()
end)

--整个我的信息界面
function MyInfo:ctor()
    self.world ={}
    self.friend = {}
    self.model = nil
    --是否展示了榜
    self.inRank = false
    --是否展示了分享
    self.inShare = false
    --当前展示的游戏ID
    self.gameId = nil
    --当前展示的类型
    self.gameModel = nil
    --是否正在展示排行榜
    self.ifShowRank = false
    local rect = CCRect(0, 0, display.right, display.top-138)
    self.coll = display.newClippingRegionNode(rect)
    self:addChild(self.coll)
    --添加我的信息面板
    self.info = require("app.nodes.Info").new()
    self.coll:addChild(self.info)
    --添加我的游戏和收藏
    self.loveAndGame = require("app.nodes.LoveAndGame").new()
    self.coll:addChild(self.loveAndGame)

    local rect = CCRect(0, 0, display.right, display.top-500)
    self.rankColl = display.newClippingRegionNode(rect)
    self:addChild(self.rankColl)
    --添加Board
    self.rankBoard = one.sp9("Main_My_Info_Rank_Borad", display.cx, display.top-190, CCSize(display.right-36, display.top-520), self.rankColl)
    --添加排行榜NODE
    self.rankNode = display.newNode()
    self.rankBoard:addChild(self.rankNode)
    self.rankNode:setVisible(false)
    --添加白板
    self.witheRankBoard = one.sp9("Main_My_Info_Rank_White", self.rankBoard:w()/2, 400, CCSize(display.right-70, self.rankBoard:h()-140), self.rankNode)
    self.witheRankBoard:y(self.rankBoard:h()-self.witheRankBoard:h()/2-20)
    --黄色的拦
    self.yellowBar = one.sp9("Main_My_Info_Rank_Yellow",self.witheRankBoard:w()/2 , self.witheRankBoard:h()-26, CCSize(self.witheRankBoard:w(), 53), self.witheRankBoard)
    self.select_board = one.sp("Main_Rank_Select_Board", self.yellowBar:w()/4, self.yellowBar:h()-28, self.yellowBar)
    --好友按钮
    self.fri_btn = one.btn("Main_Fri_Rank_Lebel", self.yellowBar:w()/4, self.yellowBar:h()-25.5, function( ... )

            --移动按键板
            self.select_board:x(self.yellowBar:w()/4)
    end, nil, self.yellowBar)
    --世界按钮
    self.world_btn = one.btn({"Main_World_Rank_Lebel",2}, self.yellowBar:w()/4*3, self.yellowBar:h()-25.5, function( ... )
        --移动按键板
        self.select_board:x(self.yellowBar:w()/4*3)
    end, nil, self.yellowBar)
    --查看详细排行榜
    self.rankBtn = one.btn({"Main_Rank",2}, self.rankBoard:w()/5*4, 60, function( ... )
        self:flipRank()
    end, nil, self.rankBoard)
    --返回按键
    self.backRankBtn = one.btn({"Main_Back",2}, self.rankBoard:w()/5*4, 60, function( ... )
        self:flipRank()
    end, nil, self.rankBoard):hide()
    --开始游戏按钮
    self.playBtn = one.btn({"Main_Play",2}, self.rankBoard:w()/2, 60, function( ... )
        -- body
        if self.id then
            --todo
            tar.game.start(tonumber(self.gameId))
        end
        
        end, nil, self.rankBoard):hide()
    self.playBtn:setScale(0.9)
    --够买游戏按钮
    self.buyBtn = one.btn({"Main_Buy",2}, self.rankBoard:w()/2, 60, function( ... )
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
            for i,v in ipairs(tar.allNode.allgame.gameBoards) do
                if v.id == tonumber(self.gameId) then
                    self.name = v.name
                end
            end
            require("app.nodes.Dialog").new("确认花费1钻石购买\n"..self.name.."吗？",function( ... )
                tar.pay.game(tonumber(self.gameId), function (event)
                    if event.stu == "ok" then
                        self.buyBtn:hide()
                        self.playBtn:show()
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
            require("app.nodes.Dialog").new("请先登录哦！~",function( ... )
                yixin:oauth()
            end)
        end
    end, nil, self.rankBoard):hide()
    --分享按钮
    self.shareBtn = one.btn({"Main_Share",2}, self.rankBoard:w()/5, 60, function( ... )
        self:flipShare()
    end, nil, self.rankBoard)
    --返回分享按键
    self.backShareBtn = one.btn({"Main_Back",2}, self.rankBoard:w()/5, 60, function( ... )
        self:flipShare()
    end, nil, self.rankBoard):hide()
    --取消收藏按钮
    self.haveLoveBtn = one.btn({"Main_Love_fav",2},self.rankBoard:w()/5, 60, function( ... )
        local gameId = tonumber(self.gameId)
        self:hideRank()
        tar.game.fav(gameId, function (event)
            if gameId == tar.allNode.today.newestGame.id then
                tar.allNode.today.newestGame.love_btn:show()
                tar.allNode.today.newestGame.have_love_btn:hide()
            end
            for i,v in ipairs(tar.allNode.allgame.gameBoards) do
                if v.id == gameId then
                    v.love_btn:show()
                    v.have_love_btn:hide()
                end
            end
            tar.allNode.myInfo.loveAndGame:update()
            if event.stu == "ok" then
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
    end, nil, self.rankBoard):hide()
    --ShareBoard
    self.shareBoard = one.sp("Main_Share_Board", self.rankBoard:w()/2, (self.rankBoard:h()-100)/2+100, self.rankBoard)
    self.shareBoard:setVisible(false)
    --更改大小
    if self.rankBoard:h()- self.shareBoard:h()<120 then
        self.shareBoard:setScale((self.rankBoard:h()-120)/self.shareBoard:h())
    end
    --ShareBoardBtn
    self.shareBoardBtn = one.btn({"Main_Show_Code",2}, self.shareBoard:w()/2, self.shareBoard:h()/5, function( ... )
        tar.qr.share(tonumber(self.gameId))
    end, nil, self.shareBoard)
    self.shareBoardBtn:setButtonEnabled(false)
end

--显示排行
function MyInfo:showRank(gameId,model,own)

    for i,v in ipairs(self.loveAndGame.loveNode.items) do
        v:setButtonEnabled(false)
    end
    for i,v in ipairs(self.loveAndGame.gameNode.items) do
        v:setButtonEnabled(false)
    end
    local move_height = 390
    local action_time = 0.3
    self.own = own
    --如果排行榜正在显示
    ser:getRank(gameId, function(board,rank,score)
        local rankItem = require("app.nodes.RankItem")
        local first = fasle
        local id = user:getIntegerForKey("id")
        if id and id~=0 then
            local nick = user:getStringForKey("nick")
            self.world[1] = rankItem.new(self.witheRankBoard,1,nick,score,id,false,rank)
            self.world[1]:setScale(0.95)
            first = true
        end
        for i,v in ipairs(board) do
            if i <= 5 then
                self.world[i] = rankItem.new(self.witheRankBoard,i,v.nick,v.score,v.id,true)
                self.world[i]:setScale(0.95)
                self.world[i]:setVisible(false)
            end
        end
        for i,v in ipairs(board) do
            if i <= 5 then
                self.friend[i] = rankItem.new(self.witheRankBoard,i,v.nick,v.score,v.id,true)
                self.friend[i]:setScale(0.95)
            end
        end
    end)
    if self.ifShowRank then
        if self.gameId == gameId and self.gameModel ==model then
            self.loveAndGame:setFrame()
            self:hideRank()
        else
            self.gameId = gameId
            self.gameModel = model
            --收回榜，再出来
            one.action(self.rankBoard, "moveby", action_time, ccp(0, (display.top-520)/2+314), "expout", function()
                self.shareBoard:setVisible(false)
                self.rankNode:setVisible(false)
                self.shareBtn:setVisible(true)
                self.haveLoveBtn:hide()
                self.backShareBtn:setVisible(false)
                self.rankBtn:setVisible(true)
                self.backRankBtn:setVisible(false)
                if model == "game" then
                    self.playBtn:show()
                    self.buyBtn:hide()
                elseif model == "love" then
                    if own then
                        self.playBtn:show()
                        self.buyBtn:hide()
                        self.shareBtn:setVisible(false)
                        self.haveLoveBtn:show()
                    else
                        self.buyBtn:show()
                        self.playBtn:hide()
                        self.haveLoveBtn:show()
                        self.shareBtn:setVisible(false)
                    end
                end
                --创建简介图
                if self.gameImg then
                    self.gameImg:removeSelf()
                end
                self.gameImg = one.sp(device.writablePath.."image/"..self.gameId, self.rankBoard:w()/2, (self.rankBoard:h()-100)/2+100, self.rankBoard)
                --更改大小
                if self.rankBoard:h()- self.gameImg:h()<120 then
                    self.gameImg:setScale((self.rankBoard:h()-120)/self.gameImg:h())
                end
                --添加标题地板
                self.gameImg.inInfo = 0
                self.mask = one.btn({"Main_All_Game_Name_Tip",2},self.gameImg:w()-114, self.gameImg:h()-50, function()
                    self.gameImg.inInfo = math.abs(self.gameImg.inInfo-1)
                    one.action(self.infoBoard, "scaleto", 0.3, self.gameImg.inInfo, "expout", cal)
                end, sound, self.gameImg)
                self.mask:setZOrder(9)
                self.infoBoard = one.sp9("Main_All_Game_Info_Board", self.gameImg:w(), self.gameImg:h(), CCSize(self.gameImg:w(), self.gameImg:h()), self.gameImg)
                self.infoBoard:ap(ccp(1, 1))
                self.infoBoard:setZOrder(8)
                self.infoBoard:setScale(0)
                self.infoText = one.ttf(infoText or "这是一个测试，\n简单有趣的测试！", self.infoBoard:w()/2, self.infoBoard:h()/2, 30, BUY_WINDOW_HEVEY_COLOR, MAIN_FONT, align, self.infoBoard)
                --游戏名字
                self.nameLebel = one.ttf(name or "测试", self.mask:getContentSize().width/3*2, 47, ALL_GAME_NAME_SIZE, ALL_GAME_NAME_COLOR, MAIN_FONT, align, self.mask)
                self.nameLebel:setZOrder(10)
                --游戏的日期
                self.dateLebel = one.ttf(string.sub(date or "14.08.06", 4,-1), 100, 47, ALL_GAME_NAME_SIZE, ALL_GAME_NAME_COLOR, MAIN_FONT, align, self.mask)
                self.dateLebel:x(34+self.dateLebel:w()/2)
                self.dateLebel:setZOrder(10)
                self.gameImg:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
                self.gameImg:setTouchEnabled(true)
                self.gameImg:setTouchSwallowEnabled(false)
                self.gameImg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                    if event.name == "began" then
                        self.y = event.y
                        return true

                    elseif event.name == "moved" then
                        self.status = tar.scroll.fsm_:getState()
                    elseif event.name == "ended" then
                        if self.status == "gameimg" then
                            if self.ifShowRank then
                                if event.y<self.y then
                                    self:hideRank()
                                end
                            end
                        end
                        self.status = nil
                    end
                end)
                --出来
                one.action(self.rankBoard, "moveby", action_time, ccp(0, -(display.top-520)/2-314), "backout", function( ... )
                    for i,v in ipairs(self.loveAndGame.loveNode.items) do
                        v:setButtonEnabled(true)
                    end
                    for i,v in ipairs(self.loveAndGame.gameNode.items) do
                        v:setButtonEnabled(true)
                    end
                end)
            end)

        end
    else
        self.shareBoard:setVisible(false)
        self.rankNode:setVisible(false)
        self.shareBtn:setVisible(true)
        self.backShareBtn:setVisible(false)
        self.rankBtn:setVisible(true)
        self.haveLoveBtn:hide()
        self.backRankBtn:setVisible(false)
        --是否展示了榜为真
        self.ifShowRank = true
        if model == "game" then
            self.playBtn:show()
            self.buyBtn:hide()
        elseif model == "love" then
            if own then
                self.playBtn:show()
                self.buyBtn:hide()
                self.shareBtn:setVisible(false)
                self.haveLoveBtn:show()
            else
                self.buyBtn:show()
                self.playBtn:hide()
                self.haveLoveBtn:show()
                self.shareBtn:setVisible(false)
            end
        end
        self.gameId = gameId
        self.gameModel = model
        --创建简介图
        if self.gameImg then
            self.gameImg:removeSelf()
        end
        self.gameImg = one.sp(device.writablePath.."image/"..gameId, self.rankBoard:w()/2, (self.rankBoard:h()-100)/2+100, self.rankBoard)
        --更改大小
        if self.rankBoard:h()- self.gameImg:h()<120 then
            self.gameImg:setScale((self.rankBoard:h()-120)/self.gameImg:h())
        end
        --添加标题地板
        self.gameImg.inInfo = 0
        self.mask = one.btn({"Main_All_Game_Name_Tip",2},self.gameImg:w()-114, self.gameImg:h()-50, function()
            self.gameImg.inInfo = math.abs(self.gameImg.inInfo-1)
            one.action(self.infoBoard, "scaleto", 0.3, self.gameImg.inInfo, "expout", cal)
        end, sound, self.gameImg)
        self.mask:setZOrder(9)
        self.infoBoard = one.sp9("Main_All_Game_Info_Board", self.gameImg:w(), self.gameImg:h(), CCSize(self.gameImg:w(), self.gameImg:h()), self.gameImg)
        self.infoBoard:ap(ccp(1, 1))
        self.infoBoard:setZOrder(8)
        self.infoBoard:setScale(0)
        self.infoText = one.ttf(infoText or "这是一个测试，\n简单有趣的测试！", self.infoBoard:w()/2, self.infoBoard:h()/2, 30, BUY_WINDOW_HEVEY_COLOR, MAIN_FONT, align, self.infoBoard)
        --游戏名字
        self.nameLebel = one.ttf(name or "测试", self.mask:getContentSize().width/3*2, 47, ALL_GAME_NAME_SIZE, ALL_GAME_NAME_COLOR, MAIN_FONT, align, self.mask)
        self.nameLebel:setZOrder(10)
        --游戏的日期
        self.dateLebel = one.ttf(string.sub(date or "14.08.06", 4,-1), 100, 47, ALL_GAME_NAME_SIZE, ALL_GAME_NAME_COLOR, MAIN_FONT, align, self.mask)
        self.dateLebel:x(34+self.dateLebel:w()/2)
        self.dateLebel:setZOrder(10)
        self.gameImg:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
        self.gameImg:setTouchEnabled(true)
        self.gameImg:setTouchSwallowEnabled(false)
        self.gameImg:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                self.y = event.y
                return true

            elseif event.name == "moved" then
                self.status = tar.scroll.fsm_:getState()
            elseif event.name == "ended" then
                if self.status == "gameimg" then
                    if self.ifShowRank then
                        if event.y<self.y then
                            self:hideRank()
                        end
                    end
                end
                self.status = nil
            end
        end)
        --移动信息
        one.action(self.info, "moveby", action_time, ccp(0, move_height), "expout", function( ... )
            for i,v in ipairs(self.loveAndGame.loveNode.items) do
                v:setButtonEnabled(true)
            end
            for i,v in ipairs(self.loveAndGame.gameNode.items) do
                v:setButtonEnabled(true)
            end
        end)
        --移动loveAndGame
        one.action(self.loveAndGame, "moveby", action_time, ccp(0, move_height), "expout", function( ... )
            one.action(self.rankBoard, "moveby", action_time, ccp(0, -(display.top-520)/2-314), "backout", nil)
        end)
    end
    tar.allNode.myInfo.info.info_out_circle:setTouchEnabled(false)
    self.model = model
end

--收回榜
function MyInfo:hideRank(listener)
    self.model = nil
    self.world ={}
    self.friend ={}
    local move_height = -390
    local action_time = 0.3
    self.gameId = nil
    self.gameModel = nil
    self.ifShowRank = false
    self.inRank = false
    self.inShare = false
    --收回榜
    one.action(self.rankBoard, "moveby", action_time, ccp(0, (display.top-520)/2+314), "expout",function( ... )
        --回复原位
        --移动信息
        one.action(self.info, "moveby", action_time, ccp(0, move_height), "expout", function( ... )
            self.backRankBtn:setVisible(false)
            self.rankBtn:setVisible(true)
            self.haveLoveBtn:hide()
            self.buyBtn:hide()
            self.shareBoardBtn:setButtonEnabled(false)
            if listener then
                listener()
            end
        end)
        --移动loveAndGame
        one.action(self.loveAndGame, "moveby", action_time, ccp(0, move_height), "expout", function( ... )
            for i,v in ipairs(self.loveAndGame.loveNode.items) do
                v:setButtonEnabled(true)
            end
            for i,v in ipairs(self.loveAndGame.gameNode.items) do
                v:setButtonEnabled(true)
            end
        end)
    end)
    tar.allNode.myInfo.info.info_out_circle:setTouchEnabled(true)
end

--点击排行榜后的旋转
function MyInfo:flipRank()
    --翻转
    local filp_1 = CCOrbitCamera:create(0.2, 1, 0, 0, 180, 0, 0)
    --换成排行榜
    local call_1 = CCCallFunc:create(function()
        self.inShare = false
        --隐藏分享面板
        self.shareBoard:setVisible(false)
        --显示分享按键
        -- if self.own then
        --     self.shareBtn:setVisible(true)
        -- end
        if self.model =="game" then
            self.shareBtn:setVisible(true)
            self.backShareBtn:setVisible(false)
        end
        --隐藏返回分享按键
        self.backShareBtn:setVisible(false)
        self.rankNode:setVisible(not self.inRank)
        self.rankBtn:setVisible(self.inRank)
        if self.gameImg then
            self.gameImg:setVisible(self.inRank)
        end
        self.backRankBtn:setVisible(not self.inRank)
        self.inRank = not self.inRank
        self.rankBtn:setButtonEnabled(false)
        self.backRankBtn:setButtonEnabled(false)
    end)
    --翻转
    local filp_2 = CCOrbitCamera:create(0.2, 1, 0, 180, 180, 0, 0)
    local call_2 = CCCallFunc:create(function()
        self.rankBtn:setButtonEnabled(true)
        self.backRankBtn:setButtonEnabled(true)
    end)
    local action = transition.sequence({filp_1,call_1,filp_2,call_2})
    self.rankBoard:runAction(action)
end

--点击分享后的旋转
function MyInfo:flipShare()
    --翻转
    local filp_1 = CCOrbitCamera:create(0.2, 1, 0, 0, 180, 0, 0)
    --换成分享
    local call_1 = CCCallFunc:create(function()
        self.inRank = false
        --将显示排行榜的按钮显示
        self.rankBtn:setVisible(true)
        --隐藏排行榜返回按钮
        self.backRankBtn:setVisible(false)
        self.rankNode:setVisible(false)
        self.shareBoard:setVisible(not self.inShare)
        self.shareBtn:setVisible(self.inShare)
        if self.gameImg then
            self.gameImg:setVisible(self.inShare)
        end
        self.backShareBtn:setVisible(not self.inShare)
        self.inShare = not self.inShare
        self.shareBtn:setButtonEnabled(false)
        self.backShareBtn:setButtonEnabled(false)
    end)
    --翻转
    local filp_2 = CCOrbitCamera:create(0.2, 1, 0, 180, 180, 0, 0)
    local call_2 = CCCallFunc:create(function()
        self.shareBtn:setButtonEnabled(true)
        self.backShareBtn:setButtonEnabled(true)
        self.shareBoardBtn:setButtonEnabled(self.inShare)
    end)
    local action = transition.sequence({filp_1,call_1,filp_2,call_2})
    self.rankBoard:runAction(action)
end

return MyInfo

