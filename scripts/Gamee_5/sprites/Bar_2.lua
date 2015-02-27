--
-- Author: peter
-- Date: 2014-05-02 03:10:00
--
--
-- Author: peter
-- Date: 2014-05-01 22:42:49
--
local Bar_2 = class("Bar_2", function( ... )
	return display.newSprite("Gamee_5_s_2.png")
end)

local basic_sc = 0.2
local sc_speed = 0.001


function Bar_2:ctor(x,y,way,dir)
	self.dir = nil
	self.way = way
	if way ==1 then
		if dir == 1 then
			self:setAnchorPoint(ccp(0, 0.5))
			self:setPosition(x-5, y)
		elseif dir == 2 then
			self:setRotation(90)
			self:setAnchorPoint(ccp(0, 0.5))
			self:setPosition(x, y+5)
		elseif dir == 3 then
			self:setAnchorPoint(ccp(1, 0.5))
			self:setPosition(x+5, y)
		elseif dir == 4 then
			self:setAnchorPoint(ccp(1, 0.5))
			self:setRotation(90)
			self:setPosition(x, y-5)
		end
		self:setScaleX(0)
	end
	if way == 2 then
		
		if dir == 1 then
			self:setAnchorPoint(ccp(1, 0.5))
			self:setPosition(x+5, y)
		elseif dir == 2 then
			self:setRotation(90)
			self:setAnchorPoint(ccp(1, 0.5))
			self:setPosition(x, y-5)
		elseif dir == 3 then
			self:setAnchorPoint(ccp(0, 0.5))
			self:setPosition(x-5, y)
		elseif dir == 4 then
			self:setAnchorPoint(ccp(0, 0.5))
			self:setRotation(90)
			self:setPosition(x, y+5)
		end
		self:setScaleX(0)
	end
	self:scheduleUpdate(function( ... )
		if not tar.die then
			if self.dir == 1 then
				self:setScaleX(self:getScaleX()-sc_speed)
				if self:getScaleX() <= 0.05 then
					self.dir = 2
				end
			elseif self.dir == 2 then
				self:setScaleX(self:getScaleX()+sc_speed)
				if self:getScaleX() >= 0.45 then
					self.dir = 1
				end
			end
			if self:getScaleX()~=0 then
				if self:getCascadeBoundingBox():intersectsRect(tar.ship.sh:getCascadeBoundingBox()) then
					if self.way == 1 then
						tar.ship:setPositionX(tar.ship:getPositionX()-5)
					elseif self.way == 2 then
						tar.ship:setPositionX(tar.ship:getPositionX()+5)
					end
					print(self.way)
					tar:setDie()
				end
			end
		end
	end)
end

return Bar_2