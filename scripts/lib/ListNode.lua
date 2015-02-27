--
-- Author: bacoo
-- Date: 2014-07-25 01:47:45
--
local ListNode = class("ListNode", function()
    return display.newClippingRegionNode(CCRect(0, 0, display.right, display.top))
end)

--father    父节点
--wid       可视窗口宽度
--hei       可视窗口高度
--dir       滑动的方向
--横向--land
--纵向--por
--dis           间距
--moveDis       滑动前的判断距离
function ListNode:ctor(father,wid,hei,dir,dis,movedis)
    if father then
        father:addChild(self)
    end
    self.width = wid or display.right
    self.height = hei or display.top
    self:setSize(self.width,self.height)
    self.haveRe = false
    --滑动的方向
    self.dir = dir or "por"
    --滑动前判断是否滑动的距离
    self.movedis = movedis or 0
    --每个字item之间的间距
    self.dis = dis or 10
    --滑动速度
    self.speed = 0
    --滑动速度减少的量
    self.eachMove = 0.1
    --滑动速度最大量
    self.maxSpeed = 50
    --所有item的集合
    self.items = {}
    --能否移动
    self.canMove = false
    --判断完成没
    self.panduan = false
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
    self:setTouchCaptureEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.speed = 0
            self.x = event.x
            self.y = event.y
            
            return true
        elseif event.name == "moved" then
            if self.dir == "por" then
                if self.panduan then
                    if self:needMove() then
                        if self.canMove then
                            table.insert(self.y_tab, event.y)
                            if self.items[1]:getPositionY()+self.y_tab[#self.y_tab]-self.y_tab[#self.y_tab-1] <= self.height-self.dis-self.items[1]:getContentSize().height/2 then
                                local move = self.height-self.dis-self.items[1]:getContentSize().height/2 - self.items[1]:getPositionY()
                                for i,v in ipairs(self.items) do
                                    v:setPositionY(v:getPositionY()+move)
                                end
                                if self:getParent()._up then
                                    self:getParent():_up()
                                end
                            elseif self.items[#self.items]:getPositionY()+self.y_tab[#self.y_tab]-self.y_tab[#self.y_tab-1] >= self.dis+self.items[#self.items]:getContentSize().height/2 then
                                local move = self.dis+self.items[#self.items]:getContentSize().height/2 - self.items[#self.items]:getPositionY()
                                for i,v in ipairs(self.items) do
                                    v:setPositionY(v:getPositionY()+move)
                                end
                                if self:getParent()._down then
                                    self:getParent():_down()
                                end
                            else
                                for i,v in ipairs(self.items) do
                                    v:setPositionY(v:getPositionY()+self.y_tab[#self.y_tab]-self.y_tab[#self.y_tab-1])
                                end
                            end
                        end
                    end
                else
                    if self.movedis == 0 then
                        self.panduan = true
                        self.canMove = true
                        self.y_tab = {event.y}
                    else
                        if math.abs(event.x-self.x)>=self.movedis or math.abs(event.y-self.y)>=self.movedis then
                            if math.abs(event.y-self.y) >= math.abs(event.x-self.x) then
                                self.panduan = true
                                self.canMove = true
                                self.y_tab = {event.y}
                            else
                                self.panduan = true
                                self.canMove = false
                            end
                        end
                    end
                end
            elseif self.dir == "land" then
                if self.panduan then
                    if self:needMove() then
                        if self.canMove then
                            table.insert(self.x_tab, event.x)
                            if self.items[1]:getPositionX()+self.x_tab[#self.x_tab]-self.x_tab[#self.x_tab-1] >= self.dis+self.items[1]:getContentSize().width/2 then
                                local move = (self.dis+self.items[1]:getContentSize().width/2)-self.items[1]:getPositionX()
                                for i,v in ipairs(self.items) do
                                    v:setPositionX(v:getPositionX()+move)
                                end
                            elseif self.items[#self.items]:getPositionX()+self.x_tab[#self.x_tab]-self.x_tab[#self.x_tab-1] <= self.width-self.dis-self.items[#self.items]:getContentSize().width/2 then
                                local move = (self.width -self.dis-self.items[#self.items]:getContentSize().width/2)-self.items[#self.items]:getPositionX()
                                for i,v in ipairs(self.items) do
                                    v:setPositionX(v:getPositionX()+move)
                                end
                            else
                                for i,v in ipairs(self.items) do
                                    v:setPositionX(v:getPositionX()+self.x_tab[#self.x_tab]-self.x_tab[#self.x_tab-1])
                                end
                            end
                        end
                    end
                else
                    if self.movedis == 0 then
                        self.panduan = true
                        self.canMove = true
                        self.x_tab = {event.x}
                    else
                        if math.abs(event.x-self.x)>=self.movedis or math.abs(event.y-self.y)>=self.movedis then
                            if math.abs(event.x-self.x) >= math.abs(event.y-self.y) then
                                self.panduan = true
                                self.canMove = true
                                self.x_tab = {event.x}
                            else
                                self.panduan = true
                                self.canMove = false
                            end
                        end
                    end
                end
            end
        elseif event.name == "ended" then
            if self.dir == "por" then
                if self.canMove then
                    if #self.y_tab>=3 then
                        self.speed = (self.y_tab[#self.y_tab-1]-self.y_tab[#self.y_tab-2])
                        if math.abs(self.speed) > self.maxSpeed then
                            self.speed = self.maxSpeed * (self.speed/math.abs(self.speed))
                        end
                    end
                end
                self.haveRe = true
                if self:getParent()._relese then
                    self:getParent():_relese()
                end
            elseif self.dir == "land" then
                if self.canMove then
                    if #self.x_tab>=3 then
                        self.speed = (self.x_tab[#self.x_tab-1]-self.x_tab[#self.x_tab-2])
                        if math.abs(self.speed) > self.maxSpeed then
                            self.speed = self.maxSpeed * (self.speed/math.abs(self.speed))
                        end
                    end
                end
            end
            self.canMove = false
            self.panduan = false
        end
    end)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        if self.dir == "por" then
            local needMove = self:needMove()
            if needMove then
                if self.items[1]:getPositionY()+self.speed <= self.height-self.dis-self.items[1]:getContentSize().height/2 then
                    local move = self.height-self.dis-self.items[1]:getContentSize().height/2 - self.items[1]:getPositionY()
                    for i,v in ipairs(self.items) do
                        v:setPositionY(v:getPositionY()+move)
                    end
                    self.speed = 0

                    if self.haveRe then
                        if self:getParent()._upAuto then
                            self:getParent():_upAuto()
                        end
                        self.haveRe = false
                    end
                elseif self.items[#self.items]:getPositionY()+self.speed >= self.dis+self.items[#self.items]:getContentSize().height/2 then
                    local move = self.dis+self.items[#self.items]:getContentSize().height/2 - self.items[#self.items]:getPositionY()
                    for i,v in ipairs(self.items) do
                        v:setPositionY(v:getPositionY()+move)
                    end
                    self.speed = 0
                    if self.haveRe then
                        if self:getParent()._downAuto then
                            self:getParent():_downAuto()
                        end
                        self.haveRe = false
                    end
                end
                for i,v in ipairs(self.items) do
                    v:setPositionY(v:getPositionY()+self.speed)
                    if self.speed > 0 then
                        self.speed = self.speed - self.eachMove
                        if math.abs(self.speed) <= self.eachMove then
                            self.speed = 0
                        end
                    elseif self.speed < 0 then
                        self.speed = self.speed + self.eachMove
                        if math.abs(self.speed) <= self.eachMove then
                            self.speed = 0
                        end
                    end
                end
            end
        elseif self.dir == "land" then
            local needMove = self:needMove()
            if needMove then
                if self.items[1]:getPositionX()+self.speed >= self.dis+self.items[1]:getContentSize().width/2 then
                    local move = (self.dis+self.items[1]:getContentSize().width/2)-self.items[1]:getPositionX()
                    for i,v in ipairs(self.items) do
                        v:setPositionX(v:getPositionX()+move)
                    end
                    self.speed = 0
                elseif self.items[#self.items]:getPositionX()+self.speed <= self.width-self.dis-self.items[#self.items]:getContentSize().width/2 then
                    local move = (self.width -self.dis-self.items[#self.items]:getContentSize().width/2)-self.items[#self.items]:getPositionX()
                    for i,v in ipairs(self.items) do
                        v:setPositionX(v:getPositionX()+move)
                    end
                    self.speed = 0
                end
                for i,v in ipairs(self.items) do
                    v:setPositionX(v:getPositionX()+self.speed)
                    if self.speed > 0 then
                        self.speed = self.speed - self.eachMove
                        if math.abs(self.speed) <= self.eachMove then
                            self.speed = 0
                        end
                    elseif self.speed < 0 then
                        self.speed = self.speed + self.eachMove
                        if math.abs(self.speed) <= self.eachMove then
                            self.speed = 0
                        end
                    end
                end
            end
        end
    end)
    self:scheduleUpdate()
end

--添加项
function ListNode:addItem(item,XOrY,last)
    --Gamee专用
    if last then
        table.insert(self.items, 1,item)
        self:addChild(item)
        item:setPosition(self.dis+item:getContentSize().width/2,XOrY or self.height/2)
        for i,v in ipairs(self.items) do
            if i~=1 then
                v:setPositionX(self.items[i-1]:getPositionX()+self.items[i-1]:getContentSize().width/2+self.dis+item:getContentSize().width/2)
            end
        end
    else
        table.insert(self.items, item)
        self:addChild(item)
        if self.dir == "por" then
            if #self.items<=1 then
                item:setPosition(XOrY or self.width/2,self.height-self.dis-item:getContentSize().height/2)
            else
                item:setPosition(XOrY or self.width/2, self.items[#self.items-1]:getPositionY()-self.items[#self.items-1]:getContentSize().height/2-self.dis-item:getContentSize().height/2)
            end
        elseif self.dir == "land" then
            if #self.items<=1 then
                item:setPosition(self.dis+item:getContentSize().width/2,XOrY or self.height/2)
            else
                item:setPosition(self.items[#self.items-1]:getPositionX()+self.items[#self.items-1]:getContentSize().width/2+self.dis+item:getContentSize().width/2, XOrY or self.height/2)
            end
        end
    end
end

--移除所有项
function ListNode:removeAllItems()
    for i,v in ipairs(self.items) do
        v:removeSelf()
    end
    self.items = {}
end

function ListNode:setMoveDis(movedis)
    self.movedis = movedis
end

--设置是否可以滑动
function ListNode:setMoveble(switch)
    self:setTouchEnabled(switch)
end

--设置可是范围大小
function ListNode:setSize(width,height)
    local ap = self:getAnchorPoint()
    local ax,ay = ap.x,ap.y
    local x,y = self:getPosition()
    local start_x = x-ax*width
    local start_y = y-ay*height
    local end_x = x+(1-ax)*width
    local end_y = y+(1-ay)*height
    local rect = CCRect(start_x, start_y, end_x, end_y)
    self:setClippingRegion(rect)
    self.width = width
    self.height = height
end

--判断是否需要滑动
function ListNode:needMove()
    if self.dir == "por" then
        if #self.items == 0 then
            return false
        end
        local long = 0
        for i,v in ipairs(self.items) do
            long = self.dis + v:getContentSize().height+long
        end
        long = long + self.dis
        if long >= self.height then
            return true
        else
            return false
        end
        return false
    elseif self.dir == "land" then
        if #self.items == 0 then
            return false
        end
        local long = 0
        for i,v in ipairs(self.items) do
            long = self.dis + v:getContentSize().width+long
        end
        long = long + self.dis
        if long >= self.width then
            return true
        else
            return false
        end
        return false
    end
end


--设置方向
function ListNode:setDir(dir)
    self.dir = dir
end

--是否到头了
function ListNode:isHead()
    if self.items then
        if self.items[1] then
            if self.items[1]:getPositionX() >= self.dis+self.items[1]:getContentSize().width/2 then
                return true
            end
            return false
        else
            return true
        end
    end
    return false
end


--设置最大滑动速度
function ListNode:setMaxSpeed(maxSpeed)
    self.maxSpeed = maxSpeed
end

return ListNode
