local City = class("City", function( ... )
	return display.newLayer()
end)

function City:ctor()
	self.speed = 1
	self.city_1 = display.newSprite("#city.png",0,0)
	self.city_2 = display.newSprite("#city.png", self.city_1:getContentSize().width-2, 0)
	self.city_1:setAnchorPoint(ccp(0, 0))
	self.city_2:setAnchorPoint(ccp(0, 0))
	self:addChild(self.city_1)
	self:addChild(self.city_2)
	self:scheduleUpdate(function( ... )
		if not tar.die then
			self.city_1:setPositionX(self.city_1:getPositionX()-self.speed)
			self.city_2:setPositionX(self.city_2:getPositionX()-self.speed)
			if self.city_1:getPositionX()<-self.city_1:getContentSize().width then
				self.city_1:setPositionX(self.city_2:getPositionX()+self.city_2:getContentSize().width-2)
			end
			if self.city_2:getPositionX()<-self.city_2:getContentSize().width then
				self.city_2:setPositionX(self.city_1:getPositionX()+self.city_1:getContentSize().width-2)
			end
		end
	end)
end

function City:setColor( color )
	self.city_1:setColor(color)
	self.city_2:setColor(color)
end

function City:runAction(a,b)
	self.city_1:runAction(a)
	self.city_2:runAction(b)
end

return City