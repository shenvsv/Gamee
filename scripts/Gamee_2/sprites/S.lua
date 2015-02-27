--
-- Author: peter
-- Date: 2014-04-23 17:53:12
--
local S = class("S", function( ... )
	return display.newSprite("#s_1.png")
end)

function S:ctor(color,x,y,floor,hx)
	self.hx = hx
	if color == 2 then
		local frame = display.newSpriteFrame("s_2.png")
		self:setDisplayFrame(frame)
	elseif color == 3 then
		local frame = display.newSpriteFrame("s_3.png")
		self:setDisplayFrame(frame)
	end
	self:setPosition(x,y)
	self.floor = floor
end

function S:down()
	self.floor = self.floor - 1
	local move = CCMoveBy:create(0.1, ccp(0, -self.hx))
	local ease = CCEaseSineOut:create(move)
	self:runAction(ease)
end

function S:bye()
	local sc = CCScaleTo:create(0.1, 0)
	local call = CCCallFunc:create(function( ... )
		table.removebyvalue(self:getParent():getParent().Stab, self, true)
		self:removeSelf()
	end)
	local action = transition.sequence({sc,call})
	self:runAction(action)
end

return S