--
-- Author: peter
-- Date: 2014-05-01 21:01:30
--
local C_s = class("C_s", function( ... )
	return display.newSprite("#c_small.png")
end)

function C_s:ctor()
	self:setPosition(display.cx, display.top/3*2)
	tar:addChild(self)
	self:setRotation(20)
	self.random_sc_1 = 0
	self.random_sc_2 = 0
	self.random_sc_3 = 0
	self.random_sc_4 = 0


	self.bars = {{},{},{},{}}

	self.bars[1][1] = require("Gamee_5.sprites.Bar_1").new(self:getContentSize().width,self:getContentSize().height/2,1,1)
	self:addChild(self.bars[1][1])
	self.bars[1][1]:setColor(ccc3(211, 241, 249))

	self.bars[1][2] = require("Gamee_5.sprites.Bar_1").new(595/2+self:getContentSize().width/2,self:getContentSize().height/2,2,1)
	self:addChild(self.bars[1][2])
	self.bars[1][2]:setColor(ccc3(211, 241, 249))

 
	self.bars[2][1] = require("Gamee_5.sprites.Bar_2").new(self:getContentSize().width/2,0,1,2)
	self:addChild(self.bars[2][1])
	self.bars[2][1]:setColor(ccc3(211, 241, 249))

	self.bars[2][2] = require("Gamee_5.sprites.Bar_2").new(self:getContentSize().width/2,self:getContentSize().height/2-595/2,2,2)
	self:addChild(self.bars[2][2])
	self.bars[2][2]:setColor(ccc3(211, 241, 249))

 
	self.bars[3][1] = require("Gamee_5.sprites.Bar_3").new(0,self:getContentSize().height/2,1,3)
	self:addChild(self.bars[3][1])
	self.bars[3][1]:setColor(ccc3(211, 241, 249))

	self.bars[3][2] = require("Gamee_5.sprites.Bar_3").new(self:getContentSize().width/2-595/2,self:getContentSize().height/2,2,3)
	self:addChild(self.bars[3][2])
	self.bars[3][2]:setColor(ccc3(211, 241, 249))

 
	self.bars[4][1] = require("Gamee_5.sprites.Bar_1").new(self:getContentSize().width/2,self:getContentSize().height,1,4)
	self:addChild(self.bars[4][1])
	self.bars[4][1]:setColor(ccc3(211, 241, 249))

	self.bars[4][2] = require("Gamee_5.sprites.Bar_1").new(self:getContentSize().width/2,self:getContentSize().height/2+595/2,2,4)
	self:addChild(self.bars[4][2])
	self.bars[4][2]:setColor(ccc3(211, 241, 249))

	self:scheduleUpdate(function()
		if not tar.die then
			self:setRotation(self:getRotation()-0.15)
		end
	end)
end

function C_s:run()

	for i,v in ipairs(self.bars) do
		for a,b in ipairs(v) do
			b:setScaleX(0)
		end
	end

	self.random_sc_1 = math.random(-13,13)/100
	local sc_1 = CCScaleTo:create(0.15, 0.25+self.random_sc_1, 1)
	local sc_2 = CCScaleTo:create(0.15, 0.25-self.random_sc_1, 1)
	self.bars[1][1]:runAction(sc_1)
	self.bars[1][2]:runAction(sc_2)

	self:performWithDelay(function( ... )
		if self.random_sc_1>0 then
			self.bars[1][1].dir = 1
			self.bars[1][2].dir = 2
		else
			self.bars[1][1].dir = 2
			self.bars[1][2].dir = 1
		end
	end, 0.15)

	self:performWithDelay(function( ... )
		if not tar.die then
			self.random_sc_2 = math.random(-13,13)/100
			local sc_1 = CCScaleTo:create(0.15, 0.25+self.random_sc_2, 1)
			local sc_2 = CCScaleTo:create(0.15, 0.25-self.random_sc_2, 1)
			self.bars[2][1]:runAction(sc_1)
			self.bars[2][2]:runAction(sc_2)
		end
	end, 1.3)

	self:performWithDelay(function( ... )
		if not tar.die then
			if self.random_sc_2>0 then
				self.bars[2][1].dir = 1
				self.bars[2][2].dir = 2
			else
				self.bars[2][1].dir = 2
				self.bars[2][2].dir = 1
			end
		end
			
	end, 1.45)

	self:performWithDelay(function( ... )
		if not tar.die then
			self.random_sc_3 = math.random(-13,13)/100
			local sc_1 = CCScaleTo:create(0.15, 0.25+self.random_sc_3, 1)
			local sc_2 = CCScaleTo:create(0.15, 0.25-self.random_sc_3, 1)
			self.bars[3][1]:runAction(sc_1)
			self.bars[3][2]:runAction(sc_2)
		end
			
	end, 2.6)

	self:performWithDelay(function( ... )
		if not tar.die then
			if self.random_sc_3>0 then
				self.bars[3][1].dir = 1
				self.bars[3][2].dir = 2
			else
				self.bars[3][1].dir = 2
				self.bars[3][2].dir = 1
			end
		end
		
	end, 2.75)

	self:performWithDelay(function( ... )
		if not tar.die then
			self.random_sc_4 = math.random(-13,13)/100
			local sc_1 = CCScaleTo:create(0.15, 0.25+self.random_sc_4, 1)
			local sc_2 = CCScaleTo:create(0.15, 0.25-self.random_sc_4, 1)

			self.bars[4][1]:runAction(sc_1)
			self.bars[4][2]:runAction(sc_2)
		end
		
	end, 3.9)

	self:performWithDelay(function( ... )
		if not tar.die then
			if self.random_sc_4>0 then
				self.bars[4][1].dir = 1
				self.bars[4][2].dir = 2
			else
				self.bars[4][1].dir = 2
				self.bars[4][2].dir = 1
			end
		end
			
	end, 4.05)


end

function C_s:back()
	for i,v in ipairs(self.bars) do
		for a,b in ipairs(v) do
			local sc = CCScaleTo:create(0.2, 0, 1)
			local ti = CCTintTo:create(0.2, 211, 241, 249)
			local action = CCSpawn:createWithTwoActions(sc, ti)
			b:runAction(action)
		end
	end
	local ti = CCTintTo:create(0.2, 211, 241, 249)
	self:runAction(ti)
	self:performWithDelay(function()
		self:setRotation(20)
	end, 0.21)
end

function C_s:setDie()
	self:stopAllActions()
	local ti = CCTintTo:create(0.3, 68, 68, 68)
	self:runAction(ti)
	for i,v in ipairs(self.bars) do
		for a,b in ipairs(v) do
			b.dir = nil
			local ti = CCTintTo:create(0.3, 68, 68, 68)
			b:runAction(ti)
		end
	end
end

function C_s:changeColor(r,g,t)
	local ti = CCTintTo:create(0.3, r, g, t)
	self:runAction(ti)
	for i,v in ipairs(self.bars) do
		for a,b in ipairs(v) do
			local ti = CCTintTo:create(0.3, r, g, t)
			b:runAction(ti)
		end
	end
end


return C_s