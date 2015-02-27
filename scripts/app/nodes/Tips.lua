--
-- Author: bacoo
-- Date: 2014-08-04 13:57:05
--
local Tips = class("Tips", function()
	return CCProgressTimer:create(display.newSprite("#Main_Tips.png"))
end)

function Tips:ctor(father)
	father:addChild(self)
	self:setRotation(180)
	self:setPosition(father:getContentSize().width/2, father:getContentSize().height/2)
	self:setType(kCCProgressTimerTypeRadial)
    self:setPercentage(0)
    self:setReverseProgress(true)
    local pTo = CCProgressTo:create(0.8, 100)
    local ease = CCEaseExponentialOut:create(pTo)
    local del = CCDelayTime:create(3)
    local fOut = CCFadeOut:create(1)
    local call = CCCallFunc:create(function( ... )
    	self:removeSelf()
    end)
    local action = transition.sequence({ease,del,fOut,call})
    self:runAction(action)
end


return Tips