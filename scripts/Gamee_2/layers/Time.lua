--
-- Author: peter
-- Date: 2014-04-23 16:36:02
--
local Time = class("Time", function( ... )
	return display.newLayer()
end)

local fade_action_time = 1

function Time:ctor()
	self.time = 30
	self.n = {}
	for i=1,10 do
		self.n[i] = display.newSpriteFrame(i..".png")
	end
	self.shi = one.spp("#3", display.right/5*2-40, display.top/5*3-40, self)
	self.shi:setOpacity(0)
	self.ge = one.spp("#10", display.right/5*3+40, display.top/5*3-40, self)
	self.ge:setOpacity(0)
	self.du = one.spp("#du", display.right/5*4+40, display.top/5*3+100, self)
	self.du:setOpacity(0)
end

function Time:fade()
	local fade  = CCFadeIn:create(fade_action_time)
	self.shi:runAction(fade)
	local fade  = CCFadeIn:create(fade_action_time)
	self.ge:runAction(fade)
	local fade  = CCFadeIn:create(fade_action_time)
	self.du:runAction(fade)
end

function Time:start()
	self.sch = scheduler.scheduleGlobal(function( ... )
		self.time = self.time - 1
		if self.time>=20 then
			self.shi:setDisplayFrame(self.n[2])
			local ge = self.time-20
			if ge == 0 then
				ge =10
			end
			self.ge:setDisplayFrame(self.n[ge])
		elseif self.time>=10 then
			self.shi:setDisplayFrame(self.n[1])
			local ge = self.time-10
			if ge == 0 then
				ge =10
			end
			self.ge:setDisplayFrame(self.n[ge])
		elseif self.time>0 then
			self.shi:setDisplayFrame(self.n[10])
			self.ge:setDisplayFrame(self.n[self.time])
		elseif self.time == 0 then
			self.shi:setDisplayFrame(self.n[10])
			self.ge:setDisplayFrame(self.n[10])
			tar:over()
			scheduler.unscheduleGlobal(self.sch)
		end
	end, 1)
end

function Time:over()
	self.time = 30
	local fade  = CCFadeOut:create(0.5)
	self.shi:runAction(fade)
	local fade  = CCFadeOut:create(0.5)
	self.ge:runAction(fade)
	local fade  = CCFadeOut:create(0.5)
	self.du:runAction(fade)
	self.shi:setDisplayFrame(self.n[3])
	self.ge:setDisplayFrame(self.n[10])
	scheduler.unscheduleGlobal(self.sch)
end

return Time