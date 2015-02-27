--
-- Author: peter
-- Date: 2014-05-01 21:21:39
--
local Num = class("Num", function( ... )
	return  display.newLayer()
end)

function Num:ctor()
	self.num = 0
	self.day_label = one.spp("#days", display.cx, display.top/3*2-40,self)
	self.num_3 = one.spp("#0", display.cx-40, display.top/3*2+25, self)
	self.num_2 = one.spp("#0", display.cx, display.top/3*2+25,self)
	self.num_3:setVisible(false)
	self.num_2:setVisible(false)
	self.num_1 = one.spp("#0", display.cx, display.top/3*2+25,self)
	tar:addChild(self)
	self.nums = {}
	for i=1,9 do
		self.nums[i] = display.newSpriteFrame(i..".png") 
	end
	self.nums[10] = display.newSpriteFrame("0.png") 
end

function Num:addNum()
	self.num = self.num + 1
	tar:changeColor(self.num)
	local num = self.num
	if num>=100 then
		local bai = math.floor(num/100)
		local shi = math.floor((num-bai*100)/10)
		local ge = num-bai*100-shi*10
		self.num_2:setVisible(true)
		self.num_3:setVisible(true)
		self.num_1:setPositionX(display.cx+40)
		self.num_2:setPositionX(display.cx)
		self.num_3:setPositionX(display.cx-40)
		if ge == 0 then
			self.num_1:setDisplayFrame(self.nums[10])
		else
			self.num_1:setDisplayFrame(self.nums[ge])
		end
		if shi == 0 then
			self.num_2:setDisplayFrame(self.nums[10])
		else
			self.num_2:setDisplayFrame(self.nums[shi])
		end
		self.num_3:setDisplayFrame(self.nums[bai])
	elseif num>=10 then
		local shi = math.floor(num/10)
		local ge = num - shi*10
		self.num_2:setVisible(true)
		self.num_2:setPositionX(display.cx-22)
		self.num_1:setPositionX(display.cx+22)
		if ge == 0 then
			self.num_1:setDisplayFrame(self.nums[10])
		else
			self.num_1:setDisplayFrame(self.nums[ge])
		end
		self.num_2:setDisplayFrame(self.nums[shi])
	else
		self.num_1:setDisplayFrame(self.nums[num])
	end
end

function Num:back()
	self.num = 0
	self.num_2:setVisible(false)
	self.num_3:setVisible(false)
	self.num_1:setPositionX(display.cx)
	self.num_1:setDisplayFrame(self.nums[10])
end

return Num