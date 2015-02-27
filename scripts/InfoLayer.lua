--
-- Author: Bacootang
-- Date: 2014-06-22 17:43:03
--
local InfoLayer = class("InfoLayer", function( ... )
    return display.newLayer()
end)

function InfoLayer:ctor()
    self:initUI()
end

function InfoLayer:initUI()
    tar:addChild(self)
    --头像
    self.info_head_icon = one.sp("Main_Head_Icon", display.cx/2-60, display.top-230, self)
    self.info_head_icon:setScale(0.6)
    --面板
    self.info_board = one.sp("Main_Info_Board", display.cx+70, display.top-250, self)
    --名字
    self.info_name_label = one.ttf("广广一世", self.info_board:x(), self.info_board:y()+105, INFO_NAME_SIZE, INFO_NAME_COLOR, NAME_FONT,align, self)
    --钻石
    self.info_diamond = one.sp("Main_Info_Diamond", 40 , self.info_board:h()/2,self.info_board)
    --金币
    self.info_coin = one.sp("Main_Info_Coin", 40, self.info_board:h()/5*4, self.info_board)
    --道具
    self.info_prop = one.sp("Main_Info_Prop", 40, self.info_board:h()/5, self.info_board)
    --金钱数
    self.info_coin_label = one.ttf("23", 100, self.info_coin:y()+4, INFO_LABEL_SIZE, INFO_LABEL_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    --钻石数
    self.info_diamond_label = one.ttf("100", 100, self.info_diamond:y()+4, INFO_LABEL_SIZE, INFO_LABEL_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    --道具数
    self.info_prop_label = one.ttf("7", 100, self.info_prop:y()+4, INFO_LABEL_SIZE, INFO_LABEL_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    --体力值外框
    self.info_out_circle = one.sp("Main_Info_Out_Circle", self.info_board:w()/2+40, self.info_board:h()/2, self.info_board)
    --体力值Blank
    self.info_power_blank = one.sp("Main_Info_Power_Blank", self.info_board:w()/2+40, self.info_board:h()/2, self.info_board)
    --体力值
    self.info_power = CCProgressTimer:create(CCSprite:create("Main_Info_Power.png"))
    self.info_power:setType(kCCProgressTimerTypeRadial)
    self.info_power:setReverseProgress(true)
    self.info_power:setPosition(self.info_board:w()/2+40, self.info_board:h()/2)
    self.info_power:setPercentage(0)
    self.info_board:addChild(self.info_power)
    --体力值Label
    self.info_power_label = one.ttf("0",self.info_board:w()/2+40, self.info_board:h()/2+2, INFO_POWER_SIZE, INFO_POWER_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    --商店
    self.info_shop = one.btn("Main_Info_Shop", self.info_board:w()-30, 30, function( event )
        -- body
        end, sound, self.info_board):onButtonPressed(function( event )
        event.target:setScale(1.2)
        end):onButtonRelease(function( event )
        event.target:setScale(1)
        end)
    --一秒后执行POWER
    self:performWithDelay(function( ... )
        self:setPower(75)
    end, 1)

end

--设置体力
function InfoLayer:setPower(power)
    --更新体力值label
    self.info_update_power_sch = scheduler.scheduleUpdateGlobal(function()
        self.info_power_label:setString(math.floor(self.info_power:getPercentage()))
    end)
    --更新体力进度条
    one.action(self.info_power, "proto", INFO_POWER_ACTION_TIME, power, "backout", function()
        scheduler.unscheduleGlobal(self.info_update_power_sch)
    end)
end

--设置金币数
function InfoLayer:setCoin(coins)
    self.info_coin_label:setString(coins)
end

--设置钻石数
function InfoLayer:setDiamond(diamonds)
    self.info_diamond_label:setString(diamonds)
end

--设置道具数
function InfoLayer:setprop(props)
    self.info_prop_label:setString(props)
end

--从服务器获取各项数值
function InfoLayer:getCountsFromServer()

end

--登陆弹出易信窗口
function InfoLayer:loginYixin()
    if yixin:haveLogin() then
        yixin:getInfo()
    else
        yixin:oauth()
    end
end

return InfoLayer

