--
-- Author: peter
-- Date: 2014-04-23 15:32:53
--
local Rain_1 = class("Rain_1", function( ... )
	return display.newSprite("#rain_1.png")
end)


function Rain_1:ctor(x)
	self.die = false
	self:setPosition(display.right/5*x,display.top/5*3+100)
	self:scheduleUpdate(function( ... )
		if self:getParent().die then
			if not self.die then
				local fade = CCFadeOut:create(1)
				local call = CCCallFunc:create(function( ... )
					self:removeSelf()
				end)
				local action = transition.sequence({fade,call})
				self:runAction(action)
				self.die =true
			end	
		end
		self:setPositionY(self:getPositionY()-1)
		if self:getPositionY()<display.bottom-self:getContentSize().height/2 then
			self:removeSelf()
		end

	end)
end


return Rain_1