--
-- Author: Bacootang
-- Date: 2014-06-22 20:46:54
--
local ScrollLayer = class("ScrollLayer", function( ... )
    return display.newLayer()
end)

function ScrollLayer:ctor()
    self:initUI()
    --创建当前场景状态机
    self.scene_fsm = {}
    cc.GameObject.extend(self.scene_fsm)
        :addComponent("components.behavior.StateMachine")
        :exportMethods()
    self.scene_fsm:setupState({
        initial = "today",
        events = {
            {name = "left", from = "today",   to = "myinfo" },
            {name = "left",  from = "allgame",  to = "today"},
            {name = "left",  from = "myinfo",  to = "myinfo"},
            {name = "right", from = "today", to = "allgame"},
            {name = "right",from = "myinfo",to = "today"},
            {name = "right",from = "allgame",to = "allgame"},
            {name = "gotoday",from = "*",to = "today"},
            {name = "gomyinfo",from = "*",to = "myinfo"},
            {name = "goallgame",from = "*",to = "allgame"},
        },
        callbacks = {
            --往左滑之前执行
            onbeforeleft = function( event )
                if self.scene_fsm:getState() == "allgame" then
                    self.scene_fsm:doEvent("gotoday")
                else
                    self.scene_fsm:doEvent("gomyinfo")
                end
            end,
            --往右滑前执行
            onbeforeright = function( event )
                if self.scene_fsm:getState() == "myinfo" then
                    self.scene_fsm:doEvent("gotoday")
                else
                    self.scene_fsm:doEvent("goallgame")
                end
            end,
            --去往seting
            ongomyinfo = function( event )
                if tar.allNode then
                    tar.allNode:stopAllActions()
                end
                tar.allNode.allgame:closeLastInfo()
                tar.allNode.allgame:closeRank()
                self.scroll_today:setColor(INFO_SCROLL_UNSELECT_COLOR)
                self.scroll_myinfo:setColor(INFO_SCROLL_SELECT_COLOR)
                self.scroll_allgame:setColor(INFO_SCROLL_UNSELECT_COLOR)
                self.scroll_today:setTouchEnabled(true)
        self.scroll_allgame:setTouchEnabled(true)
        self.scroll_myinfo:setTouchEnabled(false)
                one.action(tar.allNode, "moveto", SCROLL_MOVE_TIME, ccp(-display.right, 0), "sineout", nil)
                one.action(self.scroll_bar, "moveto", SCROLL_MOVE_TIME, ccp(self.scroll_myinfo:x(), self.scroll_bar:y()), "backout", function( ... )
                    one.action(self.scroll_bar, "scaleto", 0.5, {SCROLL_BAR_SCALE,1}, "sineout", nil)
                end)
            end,
            --去allgame
            ongoallgame = function( event )
                if tar.allNode then
                    tar.allNode:stopAllActions()
                end
                self.scroll_today:setColor(INFO_SCROLL_UNSELECT_COLOR)
                self.scroll_myinfo:setColor(INFO_SCROLL_UNSELECT_COLOR)
                self.scroll_allgame:setColor(INFO_SCROLL_SELECT_COLOR)
                self.scroll_today:setTouchEnabled(true)
                self.scroll_allgame:setTouchEnabled(false)
                self.scroll_myinfo:setTouchEnabled(true)
                one.action(tar.allNode, "moveto", SCROLL_MOVE_TIME, ccp(display.right, 0), "sineout", nil)
                one.action(self.scroll_bar, "moveto", SCROLL_MOVE_TIME, ccp(self.scroll_allgame:x(), self.scroll_bar:y()), "backout", function( ... )
                    one.action(self.scroll_bar, "scaleto", 0.5, {SCROLL_BAR_SCALE,1}, "sineout", nil)
                    if event.args[1] then
                        event.args[1]()
                    end
                end)
            end,
            --去today
            ongotoday = function( event )
                if tar.allNode then
                    tar.allNode:stopAllActions()
                end
                tar.allNode.allgame:closeLastInfo()
                tar.allNode.allgame:closeRank()
                self.scroll_today:setColor(INFO_SCROLL_SELECT_COLOR)
                self.scroll_myinfo:setColor(INFO_SCROLL_UNSELECT_COLOR)
                self.scroll_allgame:setColor(INFO_SCROLL_UNSELECT_COLOR)
                self.scroll_today:setTouchEnabled(false)
                    self.scroll_allgame:setTouchEnabled(true)
                    self.scroll_myinfo:setTouchEnabled(true)
                one.action(tar.allNode, "moveto", SCROLL_MOVE_TIME, ccp(0, 0), "sineout", nil)
                one.action(self.scroll_bar, "moveto", SCROLL_MOVE_TIME, ccp(self.scroll_today:x(), self.scroll_bar:y()), "backout", function( ... )
                    one.action(self.scroll_bar, "scaleto", 0.5, {SCROLL_BAR_SCALE,1}, "sineout", nil)
                    
                end)
            end,
        }
    })
    --创建状态机
    self.fsm_ = {}
    cc.GameObject.extend(self.fsm_)
        :addComponent("components.behavior.StateMachine")
        :exportMethods()

    --绑定状态事件
    self.fsm_:setupState({
        initial = "free",
        events = {
            {name = "press", from = "free",   to = "ready" },
            {name = "turn",  from = "ready",  to = "move"},
            {name = "turn",  from = "lovegame",  to = "move"},
            {name = "run",  from = "move",  to = "move"},
            {name = "run", from = "ready", to = "ready"},
            {name = "run", from = "lovegame", to = "lovegame"},
            {name = "run", from = "allgame", to = "allgame"},
            {name = "run", from = "todayrank", to = "todayrank"},
            {name = "run", from = "gameimg", to = "gameimg"},
            {name = "touchallgame", from = "ready", to = "allgame"},
            {name = "touchtodayrank", from = "ready", to = "todayrank"},
            {name = "release",from = "*",to = "free"},
            {name = "loveandgame",from = "ready",to = "lovegame"},
            {name = "touchgameimg", from = "ready", to = "gameimg"},
        },
        callbacks = {
            --松开回掉
            onrelease = function(event)
                --更新当前scene位置
                self:updatePos()
            end,
            --按下回掉
            onpress = function(event)
                --初始化开始触摸的坐标
                self:initTouchBeganPos()
                self:setTouchBeganPos(event.args[1], event.args[2])
                if tar.allNode.myInfo.loveAndGame.board:getCascadeBoundingBox():containsPoint(ccp(event.args[1], event.args[2])) then
                    self.fsm_:doEvent("loveandgame")
                end
            end,
            --移动回掉
            onrun = function(event)
                --如果开始碰到的是loveAndGame就不监听
                if self.fsm_:getState() == "lovegame" then
                    if tar.allNode.myInfo.loveAndGame.gameNode:isVisible() then
                        -- if tar.allNode.myInfo.loveAndGame.gameNode:isHead() then
                        --     if event.args[1]>self.touchBeganPos.x then
                        --         self.fsm_:doEvent("turn",event.args[1],event.args[2])
                        --     end
                        -- end
                    end
                    if tar.allNode.myInfo.loveAndGame.loveNode:isVisible() then
                        -- if tar.allNode.myInfo.loveAndGame.loveNode:isHead() then
                        --     if event.args[1]>self.touchBeganPos.x then
                        --         self.fsm_:doEvent("turn",event.args[1],event.args[2])
                        --     end
                        -- end
                    end
                    return
                end
                --如果状态是在滑动allgame的list就不监听
                if self.fsm_:getState() == "allgame" then
                    return
                end
                --如果还没确定
                if self.fsm_:getState() == "ready" then
                    --如果触摸到了ALLGAME的LIST
                    if tar.allNode.allgame.list then
                        if tar.allNode.allgame.list:getCascadeBoundingBox():containsPoint(ccp(event.args[1],event.args[2])) then
                            if math.abs(event.args[1]-self.touchBeganPos.x)>MIN_MOVE or math.abs(event.args[2]-self.touchBeganPos.y)>MIN_MOVE then
                                --如果滑动的x大于y就转向
                                if math.abs(event.args[1]-self.touchBeganPos.x) > math.abs(event.args[2]-self.touchBeganPos.y) then
                                    self.fsm_:doEvent("turn",event.args[1],event.args[2])
                                    return
                                    --否则取消监听，
                                else
                                    self.fsm_:doEvent("touchallgame")
                                    return
                                end
                            end
                        end
                    end
                    if tar.allNode.today.todayRank then
                        if tar.allNode.today.todayRank:getCascadeBoundingBox():containsPoint(ccp(event.args[1],event.args[2])) then
                            if math.abs(event.args[1]-self.touchBeganPos.x)>MIN_MOVE or math.abs(event.args[2]-self.touchBeganPos.y)>MIN_MOVE then
                                --如果滑动的x大于y就转向
                                if math.abs(event.args[1]-self.touchBeganPos.x) > math.abs(event.args[2]-self.touchBeganPos.y) then
                                    self.fsm_:doEvent("turn",event.args[1],event.args[2])
                                    return
                                    --否则取消监听，
                                else
                                    self.fsm_:doEvent("touchtodayrank")
                                    return
                                end
                            end
                        end
                    end
                    if tar.allNode.myInfo.gameImg then
                        if tar.allNode.myInfo.gameImg:getCascadeBoundingBox():containsPoint(ccp(event.args[1],event.args[2])) then
                            if math.abs(event.args[1]-self.touchBeganPos.x)>MIN_MOVE or math.abs(event.args[2]-self.touchBeganPos.y)>MIN_MOVE then
                                --如果滑动的x大于y就转向
                                if math.abs(event.args[1]-self.touchBeganPos.x) > math.abs(event.args[2]-self.touchBeganPos.y) then
                                    self.fsm_:doEvent("turn",event.args[1],event.args[2])
                                    return
                                    --否则取消监听，
                                else
                                    self.fsm_:doEvent("touchgameimg")
                                    return
                                end
                            end
                        end
                    end
                    --如果移动大于最小移动值
                    if math.abs(event.args[1]-self.touchBeganPos.x)>MIN_MOVE then
                        self.fsm_:doEvent("turn",event.args[1],event.args[2])
                    end
                    --如果确定了移动
                elseif self.fsm_:getState() == "move" then
                    --在移动坐标中添加值
                    self:addTouchMovedPos(event.args[1], event.args[2])
                    self.scroll_bar:x(self.scroll_bar:x()-(self.touchMovedPos[#self.touchMovedPos].x-self.touchMovedPos[#self.touchMovedPos-1].x)/2)
                    if tar.allNode:getPositionX()>display.right+100 or tar.allNode:getPositionX()<-display.right-100 then
                        return
                    end
                    tar.allNode:setPositionX(tar.allNode:getPositionX()+(self.touchMovedPos[#self.touchMovedPos].x-self.touchMovedPos[#self.touchMovedPos-1].x))
                end
            end,
            --改变状态回掉
            onturn = function(event)
                self:addTouchMovedPos(event.args[1], event.args[2])
                --one.action(self.scroll_bar, "scaleto", 0.2, {1,1}, "backout", nil)
                self.scroll_bar:stopAllActions()
                self.scroll_bar:setScale(1)
            end
        },

    })
    --设置下层接受
    self:setTouchSwallowEnabled(false)
    --单点触摸
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    --开启触摸
    self:setTouchEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
            --              --大于触摸范围就反回
            --              if event.y > self.scroll_bg:y() then
            --                  return false
            --              end
            self.fsm_:doEvent("press",event.x,event.y)
            return true
        elseif event.name == "moved" then
            self.fsm_:doEvent("run",event.x,event.y)
        elseif event.name == "ended" then
            self.fsm_:doEvent("release")
        end
    end)

end

--初始化触摸开始坐标点
function ScrollLayer:initTouchBeganPos()
    --记录触摸开始的坐标
    self.touchBeganPos = {x=0,y=0}
    self.touchMovedPos = {}
end

function ScrollLayer:setTouchBeganPos(x,y)
    self.touchBeganPos = {x=x,y=y}
end

function ScrollLayer:addTouchMovedPos(x,y)
    table.insert(self.touchMovedPos,{x=x,y=y})
end

function ScrollLayer:updatePos()
    if #self.touchMovedPos > 3 then
        if self.touchMovedPos[#self.touchMovedPos-1].x-self.touchMovedPos[#self.touchMovedPos-2].x > MIN_SPEED  then
            if self.scene_fsm:getState() == "allgame" then
                self.scene_fsm:doEvent("goallgame")
            else
                self.scene_fsm:doEvent("right")
            end
        elseif self.touchMovedPos[#self.touchMovedPos-1].x-self.touchMovedPos[#self.touchMovedPos-2].x < -MIN_SPEED  then
            if self.scene_fsm:getState() == "myinfo" then
                self.scene_fsm:doEvent("gomyinfo")
            else
                self.scene_fsm:doEvent("left")
            end
        else
            if self.scroll_bar:x() < (self.scroll_today:x()+self.scroll_allgame:x())/2 then
                self.scene_fsm:doEvent("goallgame")
            elseif self.scroll_bar:x() < (self.scroll_today:x()+self.scroll_myinfo:x())/2 then
                self.scene_fsm:doEvent("gotoday")
            else
                self.scene_fsm:doEvent("gomyinfo")
            end
        end
    elseif #self.touchMovedPos>=1 then
        if self.touchMovedPos[#self.touchMovedPos].x-self.touchMovedPos[1].x > MIN_SPEED  then
            if self.scene_fsm:getState() == "allgame" then
                self.scene_fsm:doEvent("goallgame")
            else
                self.scene_fsm:doEvent("right")
            end
        elseif self.touchMovedPos[#self.touchMovedPos].x-self.touchMovedPos[1].x < -MIN_SPEED  then
            if self.scene_fsm:getState() == "myinfo" then
                self.scene_fsm:doEvent("gomyinfo")
            else
                self.scene_fsm:doEvent("left")
            end
        else
            if self.scroll_bar:x() < (self.scroll_today:x()+self.scroll_allgame:x())/2 then
                self.scene_fsm:doEvent("goallgame")
            elseif self.scroll_bar:x() < (self.scroll_today:x()+self.scroll_myinfo:x())/2 then
                self.scene_fsm:doEvent("gotoday")
            else
                self.scene_fsm:doEvent("gomyinfo")
            end
        end
    else
        if self.scroll_bar:x() < (self.scroll_today:x()+self.scroll_allgame:x())/2 then
            self.scene_fsm:doEvent("goallgame")
        elseif self.scroll_bar:x() < (self.scroll_today:x()+self.scroll_myinfo:x())/2 then
            self.scene_fsm:doEvent("gotoday")
        else
            self.scene_fsm:doEvent("gomyinfo")
        end
    end
end

function ScrollLayer:initUI()
    tar:addChild(self)
    --今日按键
    self.scroll_today = one.sp("Main_Today_title",display.cx, display.top-116, self)
    self.scroll_today:setColor(INFO_SCROLL_SELECT_COLOR)
    self.scroll_today:setTouchSwallowEnabled(true)
    self.scroll_today:setTouchEnabled(true)
    self.scroll_today:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        self.scroll_today:setTouchEnabled(false)
        self.scroll_allgame:setTouchEnabled(true)
        self.scroll_myinfo:setTouchEnabled(true)
        self.scene_fsm:doEvent("gotoday")
    end)
    --AllGame按键
    self.scroll_allgame = one.sp("Main_Allgames_Title", display.right/6, display.top-116, self)
    self.scroll_allgame:setTouchSwallowEnabled(true)
    self.scroll_allgame:setTouchEnabled(true)
    self.scroll_allgame:setColor(INFO_SCROLL_UNSELECT_COLOR)
    self.scroll_allgame:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        self.scroll_today:setTouchEnabled(true)
        self.scroll_allgame:setTouchEnabled(false)
        self.scroll_myinfo:setTouchEnabled(true)
        self.scene_fsm:doEvent("goallgame")
    end)
    --Myinfo按键
    self.scroll_myinfo = one.sp("Main_Myinfo_title", display.right/6*5, display.top-116, self)
    self.scroll_myinfo:setColor(INFO_SCROLL_UNSELECT_COLOR)
    self.scroll_myinfo:setTouchSwallowEnabled(true)
    self.scroll_myinfo:setTouchEnabled(true)
    self.scroll_myinfo:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        self.scroll_today:setTouchEnabled(true)
        self.scroll_allgame:setTouchEnabled(true)
        self.scroll_myinfo:setTouchEnabled(false)
        self.scene_fsm:doEvent("gomyinfo")
    end)
    --BarBoard
    self.scroll_bar_board = one.sp("Main_Scroll_Bar_Board", display.cx, display.top-128, self)
    --BAR
    self.scroll_bar = one.sp("Main_Scroll_Bar", display.cx,display.top-124 , self):ap(ccp(0.5, 1))
    self.scroll_bar:setScaleX(SCROLL_BAR_SCALE)
end

return ScrollLayer


