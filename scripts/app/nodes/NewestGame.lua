local NewestGame = class("NewestGame", function()
    return display.newSprite("#Main_Today_Newest_Board.png")
end)

function NewestGame:ctor()
    self.inShare = false
    self:setPosition(display.cx,display.top-724)
    self:setAnchorPoint(ccp(0.5,0))
    self.name  = ""
    --添加日期底板
    self.date_tip_board = one.sp("Main_Date_Tip", 0, self:getContentSize().height, self)
    self.date_tip_board:setAnchorPoint(ccp(0,1))
    self.date_tip_board:setZOrder(10)
    --添加日期
    self.date_tip = one.ttf("", self.date_tip_board:w()/3, self.date_tip_board:h()/3*2, 40, ccc3(255,255,255), MAIN_FONT, align, self.date_tip_board)
    self.date_tip:rotation(-45)
    --添加够买按钮
    self.buy_btn  = one.btn({"Main_Buy",2}, self:getContentSize().width/5, 80, function()
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
            if self.id then
                require("app.nodes.Dialog").new("确认花费1钻石购买\n"..self.name.."吗？",function( ... )
                    tar.pay.game(self.id, function (event)
                        if event.stu == "ok" then
                            self.buy_btn:hide()
                            self.shareBtn:show()
                            tar.allNode.allgame.gameBoards[1].buy_btn:hide()
                            tar.allNode.allgame.gameBoards[1].play_btn:show()
                            tar.allNode.myInfo.loveAndGame:update()
                        else
                            print(event.msg)
                        end
                    end)
                end)
            end
        else
            require("app.nodes.Dialog").new("请先登录哦！~",function( ... )
                yixin:oauth()
            end)
        end
    end, nil, self)
    self.buy_btn:hide()
    
    --分享
    self.shareBtn = one.btn({"Main_Share",2}, self:getContentSize().width/5, 80, function( ... )
        self:flipShare()
    end, nil, self)
    self.shareBtn:hide()
    --返回
    self.backShareBtn = one.btn({"Main_Back",2}, self:getContentSize().width/5, 80, function( ... )
        self:flipShare()
    end, nil, self):hide()
    --添加收藏按钮
    self.love_btn = one.btn({"Main_Love",2}, self:getContentSize().width/5*4+20, 80, function()
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
            if self.love_btn then
                self.love_btn:hide()
            end
            if self.have_love_btn then
                self.have_love_btn:show()
            end
            tar.game.fav(self.id, function (event)
                if event.stu == "ok" then
                    tar.allNode.allgame.gameBoards[1].love_btn:hide()
                    tar.allNode.allgame.gameBoards[1].have_love_btn:show()
                    if tar.allNode.myInfo.ifShowRank then
                        tar.allNode.myInfo:hideRank()
                    end
                    tar.allNode.myInfo.loveAndGame:update()
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
    self.love_btn:setScale(0.7)
    --收藏过的按钮
    self.have_love_btn = one.btn({"Main_Love_fav",2}, self:getContentSize().width/5*4+20, 80, function()
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
            if self.love_btn then
                self.love_btn:show()
            end
            if self.have_love_btn then
                self.have_love_btn:hide()
            end
            if self.id then
                tar.game.fav (self.id, function (event)
                    if event.stu == "ok" then
                        tar.allNode.allgame.gameBoards[1].love_btn:show()
                        tar.allNode.allgame.gameBoards[1].have_love_btn:hide()
                        if tar.allNode.myInfo.ifShowRank then
                            tar.allNode.myInfo:hideRank()
                        end
                        tar.allNode.myInfo.loveAndGame:update()
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
                            print(11)
                            toast:removeSelf()
                        end)
                        local ac = transition.sequence({inn,de,out,call})
                        ttf:runAction(ac)
                    else
                        print(event.msg)
                    end
                end)
            end
        end
    end, sound, self)
    self.have_love_btn:setScale(0.7)
    if self.fav then
        self.love_btn:hide()
    else
        self.have_love_btn:hide()
    end
    --获取缓存中的allgame
    local allgame = user:getStringForKey("allgame","")
    if allgame and allgame~="" then
        --读取缓存中的全部游戏
        allgame = json.decode(allgame)
        self.name = allgame[1].name
        self.id = allgame[1].id
        self.img = allgame[1].img
        self.date = allgame[1].date
        self.url = allgame[1].url
        self.fav = allgame[1].fav
        self.own = allgame[1].own
        --   tar.allNode.today.todayRank:getBothRank(self.id)
        if self.fav then
            self.love_btn:hide()
            self.have_love_btn:show()
        else
            self.have_love_btn:hide()
            self.love_btn:show()
        end
        if self.own then
            self.shareBtn:show()
            self.buy_btn:hide()
        else
            self.shareBtn:hide()
            self.buy_btn:hide()
        end
        --设置图片
        if io.exists(device.writablePath.."image/"..self.id..".png") then
            --添加游戏缩略图
            -- self.gameImage = one.sp(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, self)
            -- self.gameImage:setScaleY(0.9)
            self.gameImage = one.btn(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, function()
                    self.game.start(self.gameId)
                end, sound, self)
                self.gameImage:setScaleY(0.9)
            --要是不存在就先用默认的图片，然后下载，最后动态更新
        else
            --下载大小图，--添加游戏缩略图
            ser:downLoadFile(img, device.writablePath.."image/"..self.id..".png", function()
                -- self.gameImage = one.sp(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, self)
                -- self.gameImage:setScaleY(0.9)
                self.gameImage = one.btn(device.writablePath.."image/"..self.id, self:getContentSize().width/2, 368, function()
                    self.game.start(self.gameId)
                end, sound, self)
                self.gameImage:setScaleY(0.9)
            end)
            ser:downLoadFile(string.sub(img,1,-5).."_m.png", device.writablePath.."image/"..self.id.."_m.png", nil)
        end
        --设置日期
        self.date_tip:setString(string.sub(self.date, -5,-1))
    end
    self.shareBoard = one.sp("Main_Share_Board", self:getContentSize().width/2, self:getContentSize().height/2+78, self)
    self.shareBoard:setScale(0.92)
    self.shareBoard:setVisible(false)
    --ShareBoardBtn
    self.shareBoardBtn = one.btn({"Main_Show_Code",2}, self.shareBoard:w()/2, self.shareBoard:h()/5, function( ... )
        local args = {}
        args.id = user:getIntegerForKey("id")
        args.gameid = self.gameId
        args = json.encode(args)
        tar.qr.show(args)
    end, nil, self.shareBoard)
    self.shareBoardBtn:setButtonEnabled(false)

    --添加开始游戏按钮
    self.play_btn = one.btn({"Main_Play",2}, self:getContentSize().width/2, 80, function()
       -- USING_TEXTURE = false
        --app:enterScene("Gamee_2_Start")
        self.game.start(self.gameId)
    end, sound, self)
end

function NewestGame:flipShare( ... )
    --翻转
    local filp_1 = CCOrbitCamera:create(0.2, 1, 0, 0, 180, 0, 0)
    --换成分享
    local call_1 = CCCallFunc:create(function()
        if self.gameImage then
            self.gameImage:setVisible(self.inShare)
        end
        self.date_tip_board:setVisible(self.inShare)
        self.shareBoard:setVisible(not self.inShare)
        self.shareBtn:setVisible(self.inShare)
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
    self:runAction(action)
end


return NewestGame








