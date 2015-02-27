--
-- Author: peter
-- Date: 2014-06-08 14:14:59
--
local TScene = class("TScene", function()
    return display.newScene()
end)

-- --添加一个菜单
-- local function _addMenu(target)
-- 	local menu = ui.newMenu({})
-- 	target:addChild(menu)
-- 	return menu
-- end



--添加功能层
local function _addFunLayer(target)
    local layer = display.newLayer()
    target:addChild(layer)
    return layer
end

function TScene:ctor(name)
    if type(name) == "string" then
        self.name = name
    end
    -- --添加菜单
    -- self.menu = _addMenu(self)
    --添加功能层
    self.funlayer = _addFunLayer(self)
    tar = self
end

--设置背景
function TScene:setBg(bgImg)
    local bg = display.newSprite(bgImg..".png", display.cx, display.cy)
    self:addChild(bg,-1,0)
    self.bg = bg
end

--触摸开关
--switch 是否开启 true or false
--handle 回调，非必要
--sample
--[[
	self:touch(true)
	function Main:touchBegan(x,y)
		print(x,y)
		return true
	end
	function Main:touchMoved(x,y)
		print(x,y)
	end
	function Main:touchEnded(x,y)
		print(x,y)
	end
--]]
function TScene:touch(switch)
    if switch then
        self.funlayer:setTouchSwallowEnabled(false)
        self.funlayer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
        self.funlayer:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
            if event.name == "began" then
                if self.touchBegan then
                    local res = self:touchBegan(event.x, event.y)
                    res = res or false
                    return res
                end
            elseif event.name == "moved" then
                if self.touchMoved then
                    self:touchMoved(event.x, event.y)
                end
            elseif event.name == "ended" then
                if self.touchEnded then
                    self:touchEnded(event.x, event.y)
                end
            end
        end)
        self.funlayer:setTouchEnabled(switch)
    else
        self.funlayer:setTouchEnabled(false)
    end
end

return TScene

