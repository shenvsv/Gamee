--
-- Author: shen
-- Date: 2014-07-20 09:05:20
--
local OverLayer = class("OverLayer", function ()
	return display.newLayer()
end)

function OverLayer:ctor()
	tar:addChild(self)
	self:setPosition(display.cx,display.cy)
	self:setVisible(true)
	-- one.sp
end

return OverLayer
