--
-- Author: bacoo
-- Date: 2014-08-07 01:14:24
--
local Continue = class("Continue", function()
    return display.newLayer()
end)

function Continue:ctor(lis,score,worldRank,friendRank,history,money,newRe,gameName,againListen)
    tar:addChild(self)
    self.grey = one.sp("Main_Grey_Layer", display.cx, display.cy, self)
    self.board = one.sp("Prop_Continue_Board", display.cx, display.cy+20, self)
    self.btn = one.btn({"Prop_Continue_Btn",2}, 350, 76, function( ... )
        self.pro:stopAllActions()
        if lis then
            lis()
            self:removeSelf()
        end
    end, sound, self.board)
    self.pro = CCProgressTimer:create(display.newSprite("#Prop_Continue_Circle.png"))
    self.pro:setType(kCCProgressTimerTypeRadial)
    self.pro:setReverseProgress(false)
    self.pro:setPosition(73, 79)
    self.pro:setPercentage(100)
    self.board:addChild(self.pro)
    local pro = CCProgressTo:create(5, 100)
    local call = CCCallFunc:create(function()
    	require("app.nodes.GameOver").new(score,worldRank,friendRank,history,money,newRe,gameName,againListen)
        self:removeSelf()
    end)
    local action = transition.sequence({pro,call})
    self.pro:runAction(action)
    local prop = user:getIntegerForKey("prop",0)
    local diamond = user:getIntegerForKey("diamond",0)
    local money = user:getIntegerForKey("money",0)
    one.ttf(prop, 92, self.board:h()-74, 30, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    one.ttf(money, 172, self.board:h()-74, 30, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    one.ttf(diamond, 260, self.board:h()-74, 30, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    self.leftEye = one.sp("Prop_Continue_Left_Eye", 334, 235, self.board):rotation(50)
    self.rightEye = one.sp("Prop_Continue_Right_Eye", 400, 200, self.board):rotation(45)
    local sc = CCScaleTo:create(0.1, 1,0.1)
    local ea = CCEaseExponentialOut:create(sc)
    local sc = CCScaleTo:create(0.1, 1,1)
    local eaa = CCEaseExponentialOut:create(sc)
    local de = CCDelayTime:create(1)
    local ac = transition.sequence({ea,eaa,de})
    local re = CCRepeatForever:create(ac)
    self.leftEye:runAction(re)
    local sc = CCScaleTo:create(0.1, 1,0.1)
    local ea = CCEaseExponentialOut:create(sc)
    local sc = CCScaleTo:create(0.1, 1,1)
    local eaa = CCEaseExponentialOut:create(sc)
    local de = CCDelayTime:create(1)
    local ac = transition.sequence({ea,eaa,de})
    local re = CCRepeatForever:create(ac)
    self.rightEye:runAction(re)

end

return Continue

