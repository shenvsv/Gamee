local BasicScene = class("BasicScene", function()
	return TScene.new("BasicScene")
end)

--添加功能层
local function _addLayer(target,z)
	local layer = display.newLayer()
	target:addChild(layer,z)
	return layer
end

--添加一个菜单，z坐标为2
local function _addMenu(target)
	local menu = ui.newMenu({})
	target:addChild(menu,2)
	return menu
end


function BasicScene:ctor()
	--添加菜单
	self.menu = _addMenu(self)
	--添加功能层
	self.pop = _addLayer(self,3)
	self.main = _addLayer(self,2) 
	self.play = _addLayer(self,1)	
	--定时器的集合
	self._sch = {}
	self.tPoint = {}
end

--设置背景
function BasicScene:setBg(bgImg,layer)
	local bg = display.newSprite(bgImg..".png", display.cx, display.cy)
	layer:addChild(bg,-1,0)
	layer.bg = bg
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

function BasicScene:setClickTouch(layer,handler)
	layer:addTouchEventListener(nHandler, bIsMultiTouches, nPriority, bSwallowsTouches)
	handler(x,y)
	return false
end

function BasicScene:setEventTouch(layer,handle,dm)
	
	if not dm then
		dm = 10
	end
	-- layer.isTouch = true
	layer:setTouchEnabled(true)
	layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		local tEvent = nil
		x = event.x
		y = event.y
		if event.name == "began" then
			if self.tPoint.t then
				return false
			else
				self.tPoint.t = true
				self.tPoint.tx = x
				self.tPoint.ty = y
				return true	
			end
			
		else
			if self.tPoint.t then
				local dx = x - self.tPoint.tx
				local dy = y - self.tPoint.ty
				if math.abs(dx) >= math.abs(dy) then
					if math.abs(dx) > dm then
						if x > self.tPoint.tx then
							tEvent = "right"
						else
							tEvent = "left"	
						end
					end
				else
					if math.abs(dy) > dm then
						if y > self.tPoint.ty then
							tEvent = "up"
						else
							tEvent = "down"	
						end
					end	
				end	
			end				
		end
		if tEvent and tEvent ~= self.tPoint.tEvent and self.tPoint.t then
			handle(tEvent,x,y,self.tPoint.tx,self.tPoint.ty)
			self.tPoint.tx = x
			self.tPoint.ty = y
			self.tPoint.tEvent = tEvent
		end

		if event.name == "ended" or event.name == "cancelled" then
			self.tPoint = {}
			self.tPoint.t = false
		end
	end)
end

function BasicScene:ttf(text,x,y,size,color,font,align,target)
    local args = {}
    args.text = text or "Hello,World"
    args.x = x or display.cx
    args.y = y or display.cy
    args.size = size or 60
    args.color = color or display.COLOR_WHITE
    args.align = ui.TEXT_ALIGN_CENTER
    if font then
        args.font = font
    end
    local ttf = ui.newTTFLabel(args)
    -- oneExtend.extent(ttf)
    if target then
        target:addChild(ttf)
    else
        tar:addChild(ttf)
    end
    return ttf
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