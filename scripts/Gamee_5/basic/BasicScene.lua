--
-- Author: bacootang
-- Date: 2014-03-10 12:30:25
--
local scheduler = require("framework.scheduler")

local BasicScene = class("BasicScene", function()
	return display.newScene()
end)

--添加功能层
local function _addFunLayer(target)
	local layer = display.newLayer()
	target:addChild(layer)
	return layer
end

--添加一个菜单，z坐标为2
local function _addMenu(target)
	local menu = ui.newMenu({})
	target:addChild(menu,2)
	return menu
end


function BasicScene:ctor(name)
	self.name = name
	--添加菜单
	self.menu = _addMenu(self)
	--添加功能层
	self.funlayer = _addFunLayer(self)
	--定时器的集合
	self._sch = {}
	tar = self
end

--设置背景
function BasicScene:setBg(bgImg)
	local bg = display.newSprite(bgImg..".png", display.cx, display.cy)
	self:addChild(bg,-1,0)
	self.bg = bg
end

--设置定时器
--name   string,名字,同一SCENE中的name不可重复
--time   迭代时间,0为每帧刷新
--handle 回调函数
--返回值  true,false
--sample
--[[
	self:sch("pig",0,function()
		print(1)
	end)
--]]
function BasicScene:sch(name,time,handle)
	if self._sch[name] or time < 0 then
		return false
	end
	local sc = nil
	if time == 0 then
		sc = scheduler.scheduleUpdateGlobal(handle)
	else
		sc = scheduler.scheduleGlobal(handle, time)
	end
	self._sch[name] = sc
	return true
end

function BasicScene:stopsch(name)
	if not self._sch[name] then
		return false
	end
	local sc = self._sch[name]
	scheduler.unscheduleGlobal(sc)
	return true
end



--触摸开关
--switch 是否开启 true or false
--handle 回调，非必要
--sample
--[[
	self:touch(true, function(event,x,y)
		if event=="began" then
			print(x,y)
			return true
		end
	end)
--]]
function BasicScene:touch(switch,handle)
	if switch and handle then
		self.funlayer:addTouchEventListener(handle)
		self.funlayer:setTouchEnabled(switch)
	else
		self.funlayer:setTouchEnabled(false)
	end
end

--按键开关
--switch 是否开启 true or false
--handle 回调，非必要
--sample
--[[
	self:key(true,function(event)
	    if event == "back" then
	    elseif event == "menu" then
	    end
	end)
--]]
function BasicScene:key(switch,handle)
	if switch and handle then
		self.funlayer:addKeypadEventListener(handle)
		self.funlayer:setKeypadEnabled(switch)
	else
		self.funlayer:setKeypadEnabled(false)
	end
end

--重力开关
--switch 是否开启 true or false
--handle 回调，非必要
--sample
--[[
	self:gra(true,function(x, y, z, timestamp)
	    -- x, y, z 分别是三个轴的重力值，从 -1.0 到 1.0
	    -- timestamp 是发生事件的时间点（秒）
	end)
--]]
function BasicScene:gra(switch,handle)
	if switch and handle then
		self.funlayer:addAccelerateEventListener(handle)
		self.funlayer:setAccelerometerEnabled(switch)
	else
		self.funlayer:setAccelerometerEnabled(false)
	end
end


function BasicScene:onExit()
	for k,v in pairs(self._sch) do
		scheduler.unscheduleGlobal(v)
	end
end

return BasicScene