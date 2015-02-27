local Dialog = class("Dialog",function()
    return display.newNode()
end)

function Dialog:ctor(title,listener,keep,cancelListen,cancel,only)
    self:setPosition(display.cx,display.cy)
    self:setZOrder(100)
    --设置遮罩层
    self.grey = one.sp("Main_Grey_Layer", 0, 0, self)
    self.layer = display.newLayer()
    tar:addChild(self)
    self.layer:setTouchSwallowEnabled(true)
    self.layer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self.layer:setTouchEnabled(true)
    self:addChild(self.layer)

    --设置地板
    self.board =  one.sp("Dialog_Board", 0, 0, self)
    --设置Yes按键
    self.yes_btn = one.btn({"Dialog_Yes_btn",2}, self.board:w()/4, self.board:h()/4, function()
        if listener then
            listener()
        end
        if not keep then
            one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 0, "expout", function()
                self:removeSelf()
            end)
        end
    end, nil, self.board)
    if not only then
        --设置No按键
        self.no_btn = one.btn({"Dialog_No_btn",2}, self.board:w()/4*3, self.board:h()/4, function()
            if cancelListen then
                cancelListen()
            end
            one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 0, "expout", function()
                self:removeSelf()
            end)
        end, nil, self.board)
    else
        self.yes_btn:x(self.board:w()/2)
    end
    --设置标题
    self.title = one.ttf(title, self.board:w()/2, self.board:h()/5*3+20, DIALOG_TITLE_SIZE, BUY_WINDOW_COUNT_COLOR, DIALOG_TITLE_FONT, align, self.board)

    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
            if cancel then
                return
            end
            if not self.board:getCascadeBoundingBox():containsPoint(ccp(event.x,event.y)) then
                self.grey:setVisible(false)
                if cancelListen then
                    cancelListen()
                end
                one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 0, "expout", function()
                    self:removeSelf()
                end)
            end
        end
    end)

    self.board:setScale(0)
    one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 1, "backout", cal)
end

return Dialog


