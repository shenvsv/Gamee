--
-- Author: peter
-- Date: 2014-04-23 15:29:42
--
local Rainlayer = class("Rainlayer", function( ... )
	return display.newLayer()
end)

function Rainlayer:ctor(  )
	self.last = nil
	self.die = false
end

function Rainlayer:start()
	self.sch = scheduler.scheduleGlobal(function( ... )
		local num = math.random(1,3)
		local x = math.random(1,4)
		if x == 3 then
			x = 1
		end
		if x == self.last then
			x = self.last + 1
			if x==5 then
				x = 1
			end
		end
		
		self.last = x
		local rain = require("Gamee_2.sprites.Rain_"..num).new(x)
		self:addChild(rain)
	end, 2)
end


function Rainlayer:stop()
	scheduler.unscheduleGlobal(self.sch)
	self.die = true
end


return Rainlayer