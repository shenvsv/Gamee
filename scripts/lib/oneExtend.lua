--
-- Author: Bacootang
-- Date: 2014-06-08 15:49:15
--
oneExtend = class("oneExtend")
oneExtend.__index = oneExtend



function oneExtend.extent(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, oneExtend)
    return target
end

function oneExtend:x(x)
    if x then
        self:setPositionX(x)
    end
    return self:getPositionX()
end


function oneExtend:y(y)
    if y then
        self:setPositionY(y)
    end
    return self:getPositionY()
end


function oneExtend:w()
    return self:getContentSize().width
end

function oneExtend:h()
    return self:getContentSize().height
end

function oneExtend:sp(x,y)
    self:setPosition(x, y)
end

function oneExtend:ap(ap)
    if ap then
        self:setAnchorPoint(ap)
    end
    return self
end

function oneExtend:addClick(listener)
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self._touch_x = event.x
            self._touch_y = event.y
            return true
        elseif event.name == "ended" then
            if self._touch_x == event.x and self._touch_y == event.y then
                listener(self)
            end
        end
    end)
    return self
end

function oneExtend:addBtnLis(listener)
    self._btnEnable=true
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self._touch_x = event.x
            self._touch_y = event.y
            if self._btnEnable then
                if self:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) then
                    if self._sel then
                        self._sel:setVisible(true)
                        self:setOpacity(0)
                    end
                else
                    if self._sel then
                        self._sel:setVisible(false)
                        self:setOpacity(255)
                    end
                end
            end
            return true
        elseif event.name == "moved" then
            if self._btnEnable then
                if self:getCascadeBoundingBox():containsPoint(ccp(event.x, event.y)) then
                    if self._sel then
                        self._sel:setVisible(true)
                        self:setOpacity(0)
                    end
                else
                    if self._sel then
                        self._sel:setVisible(false)
                        self:setOpacity(255)
                    end
                end
            end
        elseif event.name == "ended" then
            if self._btnEnable then
                if math.abs(self._touch_x-event.x)<4*MIN_MOVE and math.abs(self._touch_y-event.y)<4*MIN_MOVE then
                    listener(self)
                end
                if self._sel then
                    self._sel:setVisible(false)
                    self:setOpacity(255)
                end
            end
        end
    end)
    return self
end

function oneExtend:setButtonEnabled(switch)
    self._btnEnable = switch
    if self._dis then
        self._dis:setVisible(not switch)
    end
    return self
end




