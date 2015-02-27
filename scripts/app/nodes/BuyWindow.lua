--
-- Author: bacoo
-- Date: 2014-07-27 16:04:09
--
local BuyWindow = class("BuyWindow", function( ... )
    return display.newNode()
end)

local Coin_Exchange = 100
local Prop_Exchange = 1


function BuyWindow:ctor(model)
    self.model = model
    self:setZOrder(100)
    self.buyConut = 1
    self:setPosition(display.cx,display.cy)
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
    if model == "coin" then
        self.title = "我要购买"
        --需要话费的种类
        self.needKind = "钻石"
        --需要花费的数额
        self.needCount = 1
        one.sp("Main_Buy_Coin", self.board:w()-134, self.board:h()/2+60, self.board)
        self.needKindIcon = one.sp("Main_Buy_Need_Diamond", 350, 176, self.board)
    elseif model == "diamond" then
        self.title = "我要购买"
        --需要话费的种类
        self.needKind = "￥"
        --需要花费的数额
        self.needCount = 1
        one.sp("Main_Buy_Diamond", self.board:w()-134, self.board:h()/2+60, self.board)
        self.needKindIcon = one.ttf("￥", 350, 180, BUY_WINDOW_HEVEY_SIZE, BUY_WINDOW_HEVEY_COLOR, DIALOG_TITLE_FONT, align, self.board)
    elseif model == "prop" then
        self.title = "我要购买"
        --需要话费的种类
        self.needKind = "金币"
        --需要花费的数额
        self.needCount = 1
        one.sp("Main_Buy_Prop", self.board:w()-134, self.board:h()/2+60, self.board)
        self.needKindIcon = one.sp("Main_Buy_Need_Coin", 350, 176, self.board)
    end
    --设置Yes按键
    self.yes_btn = one.btn("Dialog_Yes_btn", self.board:w()/4, self.board:h()/7, function()
        one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 0, "expout", function()
            if self.model == "coin" then
            tar.pay.money(self.buyConut*Coin_Exchange, function(event)
                tar.allNode.myInfo.info:updateInfo(event,"coin")
            end)
        elseif self.model == "diamond" then
            tar.buyConut = self.buyConut
            tar.pay.diamond(self.buyConut, function(event)
                local event = json.decode(event)
                if event.stu == "ok" then
                    event.props = user:getIntegerForKey("prop")
                    event.money = user:getIntegerForKey("money")
                    event.diamond = user:getIntegerForKey("diamond")+tar.buyConut
                    tar.allNode.myInfo.info:updateInfo(event,"diamond")
                end
            end)
        elseif self.model == "prop" then
            tar.pay.props(self.buyConut*Prop_Exchange,function(event)
             tar.allNode.myInfo.info:updateInfo(event,"prop")
            end)
        end
            self:removeSelf()
        end)
    end, nil, self.board)
    --设置No按键
    self.no_btn = one.btn("Dialog_No_btn", self.board:w()/4*3, self.board:h()/7, function()
        one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 0, "expout", function()
            self:removeSelf()
        end)
    end, nil, self.board)
    --   ←按键
    self.leftBtn = one.btn({"Main_Buy_Left",2}, 130, self.board:h()/2+60, function( ... )
        if self.buyConut ~= 1 then
            self.buyConut = self.buyConut -1
        end
        self:updateLabel()
    end, sound, self.board)
    --   →按键
    self.rightBtn = one.btn({"Main_Buy_Right",2}, 310, self.board:h()/2+60, function( ... )
        if self.buyConut <=100 then
            self.buyConut = self.buyConut + 1
        end
        self:updateLabel()
    end, sound, self.board)
    --够买数目的标题
    local buycount = self.buyConut
    if self.model == "coin" then
        buycount = buycount*Coin_Exchange
    elseif self.model == "prop" then
        buycount = buycount*Prop_Exchange
    end
    self.buyConutLabel = one.ttf(buycount, 220, self.board:h()/2+70, BUY_WINDOW_COUNT_SIZE, BUY_WINDOW_COUNT_COLOR, DIALOG_TITLE_FONT, align, self.board)
    --设置标题
    self.title = one.ttf(self.title, 150, self.board:h()-50, BUY_WINDOW_LIGHT_SIZE, BUY_WINDOW_LIGHT_COLOR, DIALOG_TITLE_FONT, align, self.board)
    --需要花费的标题
    self.needlabel = one.ttf("支付"..self.needCount, self.board:w()/2, 180, BUY_WINDOW_HEVEY_SIZE, BUY_WINDOW_HEVEY_COLOR, DIALOG_TITLE_FONT, align, self.board)
    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
            if not self.board:getCascadeBoundingBox():containsPoint(ccp(event.x,event.y)) then
                self.grey:setVisible(false)
                one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 0, "expout", function()
                    self:removeSelf()
                end)
            end
        end
    end)
    self.board:setScale(0)
    one.action(self.board, "scaleto", DIALOG_ACTION_TIME, 1, "backout", cal)
end

--更新Label
function BuyWindow:updateLabel()
    local buycount = self.buyConut
    if self.model == "coin" then
        buycount = buycount*Coin_Exchange
    elseif self.model == "prop" then
        buycount = buycount*Prop_Exchange
    end
    self.needCount = self.buyConut
    --更新够买数目的标题
    self.buyConutLabel:setString(buycount)
    --改变字体大小
    if buycount>=1000 then
        self.buyConutLabel:setFontSize(BUY_WINDOW_COUNT_SIZE_SMALL)
    else
        self.buyConutLabel:setFontSize(BUY_WINDOW_COUNT_SIZE)
    end
    --更新需要话费的标题
    self.needlabel:setString("支付"..self.needCount)
    if self.needCount>=10 then
        self.needKindIcon:x(364)
    else
        self.needKindIcon:x(350)
    end
end

return BuyWindow

