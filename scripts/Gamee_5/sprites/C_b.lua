--
-- Author: peter
-- Date: 2014-05-01 20:56:14
--
local C_b = class("C_b", function( ... )
	return display.newSprite("#c_big.png")
end)

function C_b:ctor()
	self:setPosition(display.cx, display.top/3*2)
	tar:addChild(self)
	self:scheduleUpdate(function( ... )
		if not tar.die then
			self:setRotation(self:getRotation()+1)
			if self:getRotation()>=360 then
				tar.num:addNum()
				self:setRotation(self:getRotation()-360)
			end
		end
	end)
end

function C_b:back()
	local rota = CCRotateTo:create(0.3, 0)
	local call = CCCallFunc:create(function( ... )
		self:setRotation(0)
	end)
	local action = transition.sequence({rota,call})
	self:runAction(action)
end


return C_b