--
-- Author: peter
-- Date: 2014-04-23 17:04:01
--
local Play = class("Play", function( ... )
	return display.newLayer()
end)

local action_time = 0.5

function Play:ctor(y)
	self.L = require("Gamee_2.sprites.L")
	self.S = require("Gamee_2.sprites.S")
	math.randomseed(os.time())
	self.batch = display.newBatchNode("Gamee_2_Main.png", 100)
	self:addChild(self.batch)
	self.height = y
	self.h = {}
	for i=1,5 do
		self.h[i] = (self.height)/10*((i-1)*2+1)+20
	end
	self.hx = self.h[2] - self.h[1]
	self.h[6] = self.h[5] + self.hx
	self.Stab = {}
	self.Ltab = {}
end


function Play:init()
	for i=2,5 do
		local pos = math.random(1,4)
		local color = math.random(1,3)
		local s = self.S.new(color,display.right/8*((pos-1)*2+1),self.h[i],i,self.hx)
		self.batch:addChild(s)
		s:setOpacity(0)
		local fade = CCFadeIn:create(action_time)
		s:runAction(fade)
		table.insert(self.Stab, s)
		for a=1,4 do
			if a ~= pos then
				local hava = math.random(1,2)
				if hava == 2 then
					local co = math.random(1,3)
					local l = self.L.new(co,display.right/8*((a-1)*2+1),self.h[i],i,self.hx)
					self.batch:addChild(l)
					l:setOpacity(0)
					local fade = CCFadeIn:create(action_time)
					l:runAction(fade)
					table.insert(self.Ltab, l)
				end
			end
		end
	end
	local l = self.L.new(3,display.right/8*((1-1)*2+1),self.h[1],1,self.hx)
	self.batch:addChild(l)
	l:setOpacity(0)
	local fade = CCFadeIn:create(action_time)
	l:runAction(fade)
	table.insert(self.Ltab, l)
	local l = self.L.new(2,display.right/8*((2-1)*2+1),self.h[1],1,self.hx)
	self.batch:addChild(l)
	l:setOpacity(0)
	local fade = CCFadeIn:create(action_time)
	l:runAction(fade)
	table.insert(self.Ltab, l)
	local l = self.L.new(1,display.right/8*((3-1)*2+1),self.h[1],1,self.hx)
	self.batch:addChild(l)
	l:setOpacity(0)
	local fade = CCFadeIn:create(action_time)
	l:runAction(fade)
	table.insert(self.Ltab, l)
	local l = self.L.new(3,display.right/8*((4-1)*2+1),self.h[1],1,self.hx)
	self.batch:addChild(l)
	l:setOpacity(0)
	local fade = CCFadeIn:create(action_time)
	l:runAction(fade)
	table.insert(self.Ltab, l)
end

function Play:down()
	for i,v in ipairs(self.Stab) do
		v:down()
	end
	for i,v in ipairs(self.Ltab) do
		v:down()
	end
	local i = 5
	local pos = math.random(1,4)
	local color = math.random(1,3)
	local s = self.S.new(color,display.right/8*((pos-1)*2+1),self.h[6],i,self.hx)
	self.batch:addChild(s)
	local move = CCMoveBy:create(0.1, ccp(0, -self.hx))
	s:runAction(move)
	table.insert(self.Stab, s)
	for a=1,4 do
		if a ~= pos then
			local hava = math.random(1,2)
			if hava == 2 then
				local co = math.random(1,3)
				local l = self.L.new(co,display.right/8*((a-1)*2+1),self.h[6],i,self.hx)
				self.batch:addChild(l)
				local move = CCMoveBy:create(0.1, ccp(0, -self.hx))
				l:runAction(move)
				table.insert(self.Ltab, l)
			end
		end
	end
end

function Play:over()
	
	for i,v in ipairs(self.Stab) do
		local fade = CCFadeOut:create(0.5)
		local call = CCCallFunc:create(function( ... )
			v:bye()
		end)
		local action = transition.sequence({fade,call})
		v:runAction(action)
	end
	for i,v in ipairs(self.Ltab) do
		local fade = CCFadeOut:create(0.5)
		local call = CCCallFunc:create(function( ... )
			table.removebyvalue(self.Ltab, v, true)
			v:removeSelf()
		end)
		local action = transition.sequence({fade,call})
		v:runAction(action)
	end
end


return Play