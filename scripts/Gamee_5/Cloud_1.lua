--
-- Author: peter
-- Date: 2014-05-01 20:27:18
--
local Cloud_1 = class("Cloud_1", function( ... )
	return display.newSprite("#cloud_1.png")
end)

function Cloud_1:ctor(x,y)
	self:setPosition(x, y)
	self.speed = 0.5
	self:scheduleUpdate(function()
		self:setPositionX(self:getPositionX()+self.speed)
		if self:getPositionX()>display.right+self:getContentSize().width/2 then
			self:setPositionX(display.left-self:getContentSize().width/2)
		end
	end)
end

return Cloud_1