--
-- Author: shen
-- Date: 2014-03-25 16:03:34
--
local PlayLayer = class("PlayLayer", function()
	return display.newLayer()
end)
local jigsaw = require("Gamee_4.sprites.Jigsaw")
local n = 1
local max = 13
--判断用途
local isTurned = false
local isFirst = true
--调试
local c = 0
local d = 0

function PlayLayer:ctor()
	self.obj_left = nil
	self.obj_right = nil
	self.obj_front = nil
	self.isTouch = true
	-- 生成一堆随机数
	n = math.random(1,max)
	isTurned = math.random(0,1)
	self.scale = (display.height - 84) / (1160 - 84)
	self:setPositionY(84)
	self:setAnchorPoint(ccp(0.5, 0))
	local card = 1
	local back = tools:addSp("card_"..card, self, display.cx, 998/2, -1)
	back:setPositionY(998/2)	
	circle = tools:addSp("circle_1", self, display.cx, 806)
	local time = one.ttf("30s", display.cx, 915, 35, ccc3(59, 68, 85), "showg.ttf", nil, self)
	time:setZOrder(100)

	self.level = one.ttf("", display.cx + 215, 915, 77, ccc3(59, 68, 85), "showg.ttf", nil, self)
	self.level:setZOrder(100)

	time:schedule(function ()
		time:setString(""..self:getParent().time.."s")
	end, 0.1)
	local line = tools:addSp("line_1", self, display.cx, 346, 1)
	self:setScale(self.scale)
	if isFirst then
		isFirst = false
	else
		self:setScaleX(0)	
	end
	
	c = c + 1
end

function PlayLayer:startGame(f)
	if f then
		n = 1
		self.obj_front = tools:addSp("obj/p"..n.."_3", self, display.cx, 346, 1)
		self.obj_front:setOpacity(0)
		self.obj_right = jigsaw.new(n,1,0)
		self:addChild(self.obj_right)
		self.obj_left = jigsaw.new(n,-1,0)
		self:addChild(self.obj_left)
	else
		self.obj_front = tools:addSp("obj/p"..n.."_3", self, display.cx, 346, 1)
		self.obj_front:setOpacity(0)
		self.obj_right = jigsaw.new(n,1)
		self:addChild(self.obj_right)
		self.obj_left = jigsaw.new(n,-1)
		self:addChild(self.obj_left)
	end
	tools:addSp("obj/p"..n.."_0", self, display.cx, 806,1)
	self:getParent():setEventTouch(self, function(tEvent,x,y,tx,ty)
		print(tEvent,x,y,tx,ty)
		if self.isTouch then
			if x*tx < 0 then

			else
				if tx > display.cx then
					sp = self.obj_right
				else
					sp = self.obj_left
				end
				if tEvent == "right" or tEvent == "left" then
					sp:flipX()	
				end
				if tEvent == "up" or tEvent == "down" then
					sp:flipY()
				end	
			end

			self:check()
			
		end
		
	end, 20)
end

function PlayLayer:check()
	if self.obj_left:isR() and self.obj_right:isR() and not isTruned then
		self.isTouch = false
		print("check")
		-- self:removeAllNodeEventListeners()
		self.obj_left:moveBy(0, 10, 0)
		self.obj_right:moveBy(0, -10, 0)
		local fun = function()
			self:getParent():changeLayer()
		end
		fun = CCCallFunc:create(fun)
		local action = transition.sequence({CCFadeTo:create(0.2, 255),fun})
		self.obj_front:runAction(action)
	end
end

function PlayLayer:destory()
	local fun = CCCallFunc:create(function()
		local action = CCScaleTo:create(0.2,self.scale)
		-- self:setZOrder(-2)
		self:getParent().cLayer:runAction(action)
		self.isTouch = true
		self:removeSelf()
		d = d + 1
		print(c,d)
	end)
	local action = transition.sequence({CCScaleTo:create(0.2, 0, self.scale),fun})
	self:runAction(action)
end
return PlayLayer