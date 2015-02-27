--
-- Author: peter
-- Date: 2014-04-23 17:52:43
--
local L = class("L", function( ... )
	return display.newSprite("#l_1.png")
end)

function L:ctor(color,x,y,floor,hx)
	self.hx = hx
	if color == 2 then
		local frame = display.newSpriteFrame("l_2.png")
		self:setDisplayFrame(frame)
	elseif color == 3 then
		local frame = display.newSpriteFrame("l_3.png")
		self:setDisplayFrame(frame)
	end
	self:setPosition(x,y)
	self.floor = floor
end

function L:down()
	self.floor = self.floor - 1
	local move = CCMoveBy:create(0.1, ccp(0, -self.hx))
	local call = CCCallFunc:create(function( ... )
		if self.floor == 0 then
			table.removebyvalue(self:getParent():getParent().Ltab, self, true)
			self:removeSelf()
		end
	end)
	local ease = CCEaseSineOut:create(move)
	local action = transition.sequence({ease,call})
	self:runAction(action)

end

return L