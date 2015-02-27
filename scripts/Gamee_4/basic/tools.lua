--
-- Author: shen
-- Date: 2014-03-31 19:03:55
--
local tools = {}

function tools:addSp(img,target,x,y,z)
	local sp = display.newSprite(img..".png", x, y)
	target:addChild(sp)
	if z then
		sp:setZOrder(z)
	end
	return sp 	
end

function tools:addBtn(img,x,y,target,listener,sound)
	local args = {}
	args.image = img..".png"
	args.imageSelected = img.."_pre.png"
	args.x             = x
	args.y             = y
	args.listener      = listener or nil
	args.sound         = sound or nil
	local btn = ui.newImageMenuItem(args)
	if target.menu then
		target.menu:addChild(btn)
		return btn
	else
		target.menu = ui.newMenu({btn})	
		target:addChild(target.menu,2)
		return btn
	end
end

function tools:setBg(bgImg,layer)
	local bg = display.newSprite(bgImg..".png", display.cx, display.cy)
	layer:addChild(bg,-1,0)
	layer.bg = bg
end

function tools:random()
	local a = math.random(0,1)
	if a == 0 then
		return -1
	else
		return 1	
	end
end

return tools