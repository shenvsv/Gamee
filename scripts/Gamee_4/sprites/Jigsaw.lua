--
-- Author: shen
-- Date: 2014-03-25 20:45:54
--
local Jigsaw = class("Jigsaw", function()
	return display.newSprite("obj/p2_1.png")
end)

function Jigsaw:ctor(n,p,f)
	self.p = p
	self:setPosition(display.cx + p*(self:getContentSize().width/2 +10),346)	
	self:change(n,f)
end

function Jigsaw:change(n,f)
	local i
	if self.p == - 1 then
		i = 1
	else
		i = 2	
	end
	local cctexture = CCTextureCache:sharedTextureCache():addImage("obj/p"..n.."_"..i..".png")
	self:setTexture(cctexture)
	self.h = tools:random()
	self.v = tools:random()
	while self.h == 1 and self.v == 1 do
		self.h = tools:random()
		self.v = tools:random()
	end
	if f then
		if self.p == - 1 then
			self.h = 1
			self.v = 1	
		else
			self.h = 1
			self.v = - 1
		end
	end
	self:setScaleX(self.v)
	self:setScaleY(self.h)
end	

function Jigsaw:isR()
	if self.h == 1 and self.v == 1 then
		return true
	end
	return false
end

function Jigsaw:flipX()
	h = self.h
	if self.v == 1 then
		self.v = -1
		local action = CCSequence:createWithTwoActions(CCScaleTo:create(0.05, 0, h),CCScaleTo:create(0.05, -1, h))
		self:runAction(action)	
	else
		self.v = 1
		local action = CCSequence:createWithTwoActions(CCScaleTo:create(0.05, 0, h),CCScaleTo:create(0.05, 1, h))
		self:runAction(action)	
	end	
end

function Jigsaw:flipY()
	v = self.v
	if self.h == 1 then
		self.h = -1
		local action = CCSequence:createWithTwoActions(CCScaleTo:create(0.1, v, 0),CCScaleTo:create(0.1, v, -1))
		self:runAction(action)	
	else
		self.h = 1
		local action = CCSequence:createWithTwoActions(CCScaleTo:create(0.1, v, 0),CCScaleTo:create(0.1, v, 1))
		self:runAction(action)	
	end	
end

function Jigsaw:getRe()
	if self.h == 1 and self.v == 1 then
		return true
	end
	return false
end

return Jigsaw