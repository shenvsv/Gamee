--
-- Author: shen
-- Date: 2014-07-09 13:23:46
--
local UISwitch = class("UISwitch", function ()
	return display.newSprite("#Main_Setting_Btn.png")
end)
local len = 70
function UISwitch:ctor(x,y,bar,fun,stu)

	self.bar = bar
	self.fun = fun

	self.x = x
	self.l = x - len
	self.r = x + len

	self.on = one.sp("Main_Setting_On", 40, 35, self)
	self.off = one.sp("Main_Setting_Off", 40, 35, self)

	if stu then
		self:setPosition(self.r, y-1)
		self.bar:setPosition(self.r, y)
		self.off:setVisible(false)
		self.stu = false
		self:switchTo(self.r)
	else	
		self:setPosition(self.l, y-1)
		self.bar:setPosition(self.l, y)
		self.on:setVisible(false)
		self.stu = true
		self:switchTo(self.l)
	end

	self:setTouchEnabled(true)
	self.bar:setTouchEnabled(true)

	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		self:setTouchEnabled(false)
		self.bar:setTouchEnabled(false)
		if event.name == "began" then
			self.prevX = event.x
			return true
		end

		if event.name == "moved" then
			if event.x < self.l then
				self:switchTo(self.l)
			elseif event.x > self.r then
				self:switchTo(self.r)	
			else
				self:switchTo(event.x)	
			end
		end

		if event.name == "ended" or event.name == "cancelled" then
			if event.x == self.prevX then
				if self.stu then
					self:slowSwitchTo(self.l,self.bar)
				else
					self:slowSwitchTo(self.r,self.bar)	
				end
			else
				self:switchOver()
				self:setTouchEnabled(true)
				self.bar:setTouchEnabled(true)
			end
		end
		
	end)

	self.bar:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		if event.x > self.l and event.x < self.r then
			self:setTouchEnabled(false)
			self.bar:setTouchEnabled(false)
			if self.stu then
				self:slowSwitchTo(self.l,self.bar)
			else
				self:slowSwitchTo(self.r,self.bar)	
			end
		end
	end)

end

function UISwitch:switchTo(x)
	self:setPositionX(x)
	self.bar:setPositionX(x)
	self:setRotation((x-self.l)/len * 360)
	if x < self.x and self.stu then
		self.on:setVisible(false)
		self.off:setVisible(true)
		self.stu = false
	end

	if x > self.x and not self.stu then
		self.on:setVisible(true)
		self.off:setVisible(false)
		self.stu = true
	end
end

function UISwitch:slowSwitchTo(last)
	local x = self:getPositionX()
	local time = 0.1
	local angle = (last - x)/len * 360
	one.action(self, "rotateby", time + 0.05, angle, nil, function ()
		self:switchOver()
		self:setTouchEnabled(true)
		self.bar:setTouchEnabled(true)
	end)
	self:moveTo(time, last, self:getPositionY())
	self.bar:moveTo(time, last, self.bar:getPositionY())
end

function UISwitch:switchOver()
	local x = self:getPositionX()
	if x == self.x then
		if self.stu then
			self:switchTo(self.r)
			self.fun(true)
		else
			self:switchTo(self.l)
			self.fun(false)	
		end
	end
	if x < self.x then
		self:switchTo(self.l)
		self.fun(false)
	end
	if x > self.x then
		self:switchTo(self.r)
		self.fun(true)
	end
end

return UISwitch