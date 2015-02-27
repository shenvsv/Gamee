--
-- Author: bacoo
-- Date: 2014-07-20 20:16:48
--
local Gamee_6_Board = class("Gamee_6_Board", function()
	return one.spp("Gamee_6_Board", display.cx, display.top, tar.boardLayer)
end)

function Gamee_6_Board:ctor(index)
	self.index = index
	self:y(display.top-80-160*(index-1))
	self:setColor(tar.level[index].color)
	if index == #tar.level then
		self.nextColor = ccc3(0 , 0, 0)
	else
		self.nextColor = tar.level[index+1].color
	end
	self.model = tar.level[index].model
	--创建障碍
	self:initObs()
end


function Gamee_6_Board:initObs()
	self.obsTab = {}
	local child = tar.level[self.index].child
	local Obs = require("Gamee_6.scenes.Gamee_6_Obs")
	for i,v in ipairs(child) do
		self.obsTab[i] = Obs.new(self,v.size,v.x,self.nextColor,v.action,v.y)
	end
end

function Gamee_6_Board:initMe()
	local yu = self.index%2
	local dir = nil
	if yu == 0 then
		dir = -1
	else
		dir = 1
	end
	self.me = require("Gamee_6.scenes.Gamee_6_Me").new(self,dir,self.nextColor,self.model)
	tar.me = self.me
end

function Gamee_6_Board:killObs()
	for i,v in ipairs(self.obsTab) do
		v.alive = false
	end
end

return Gamee_6_Board