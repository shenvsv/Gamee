--
-- Author: peter
-- Date: 2014-05-01 20:32:52
--
local Cloud_2 = class("Cloud_2", function( ... )
	return display.newSprite("#cloud_2.png")
end)

function Cloud_2:ctor(x,y)
	self:setPosition(x, y)
	self.speed = -0.3
	self:scheduleUpdate(function()
		if not tar.die then
			self:setPositionX(self:getPositionX()+self.speed)
			if self:getPositionX()<display.left-self:getContentSize().width/2 then
				self:setPositionX(display.right+self:getContentSize().width/2)
			end
		end
	end)
end

return Cloud_2