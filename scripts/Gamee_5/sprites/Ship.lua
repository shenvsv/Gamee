--
-- Author: peter
-- Date: 2014-05-01 20:58:08
--
local Ship = class("Ship", function( ... )
	return display.newSprite("#ship.png")
end)


function Ship:ctor(x,y)
	self.x = x
	self.y = y
	self:setPosition(x, y)
	self.sh = one.spp("#shi", self:getContentSize().width/2, self:getContentSize().height/2+5, self)
	self:scheduleUpdate(function( ... )
		if not tar.die then
			if self.speed then
				self.speed = self.speed - 0.35
				self:setPositionY(self:getPositionY()+self.speed)
				if self:getPositionY()>=595-self:getContentSize().height/2 then
					self:setPositionY(595-self:getContentSize().height/2)
				end
				if self:getPositionY()<=595/2+162/2+self:getContentSize().height/2 then
					self:setPositionY(595/2+162/2+self:getContentSize().height/2)
				end
			end
		end
	end)
end

function Ship:jump()
	self.speed = 5
end

function Ship:back()
	local move = CCMoveTo:create(0.3, ccp(self.x, self.y))
	self:runAction(move)
end

return Ship