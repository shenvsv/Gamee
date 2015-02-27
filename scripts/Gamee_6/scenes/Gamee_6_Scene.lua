
local Gamee_6_Scene = class("Gamee_6_Scene", function()
    return TScene.new("Gamee_6.scenes.Gamee_6_Scene")
end)

function Gamee_6_Scene:ctor()
	local Score_font = "score.ttf"
	if device.platform == "mac" then
		Score_font = "MyriadSetPro-Thin"
	end
	--是否死了。（控制触摸）
	self.alive = true
	--命
	self.life = 5
	--所有关卡的父节点
	self.boardLayer = display.newLayer()
	self:addChild(self.boardLayer)
	--关卡资源
	self.level = require("Gamee_6.scenes.Gamee_6_Level")
	--关卡面板
	local gamee_6_board = require("Gamee_6.scenes.Gamee_6_Board")
	self.gameBoard = {}
	for i,v in ipairs(self.level) do
		self.gameBoard[i] = gamee_6_board.new(i)
	end
	--现在的关卡
	self.nowLevel = 1
	self:callNextMe()
	--触摸
	self.touch = display.newLayer()
    self.touch:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
    self.touch:setTouchSwallowEnabled(false)
    self.touch:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
        	if self.alive then
        		if self.me then
        			self.me:jump()
        			return true
        		end
        	end
        	return false
        end
    end)
	self:addChild(self.touch)
	self.touch:setTouchEnabled(true)
	self:setPositionY(-160)
	self.top = one.color(ccc4(239, 239, 239, 255), self)
	self.top:y(display.top)
	self.top:setZOrder(100)
	self.left = one.spp("Gamee_6_Left", 40, 50, self.top):ap(ccp(0, 0))
	self.right = one.spp("Gamee_6_Right", display.right-40, 50, self.top):ap(ccp(1, 0))
	self.lifeLabel = one.ttf("5", self.left:w()+70, self.left:h()/2, 60, ccc3(0, 0, 0), Score_font, align, self.left)
	self.scoreLabel = one.ttf("0", -70, self.right:h()/2, 60, ccc3(0, 0, 0), Score_font, align, self.right)
	-- self.leftBar = one.spp9("Gamee_6_Cube", self.left:w(), 18, CCSize((display.right-136*2)/2, 36), self.left)
	-- self.leftBar:ap(ccp(0, 0.5))
	-- self.leftBar:setColor(ccc3(164, 84, 125))
	-- self.rightBar = one.spp9("Gamee_6_Cube", 0, 18, CCSize((display.right-136*2)/2, 36), self.right)
	-- self.rightBar:ap(ccp(1, 0.5))
	-- self.rightBar:setColor(ccc3(113, 141, 191))

end

function Gamee_6_Scene:callNextMe(up)
	if up then
		self.life = self.life+2
		self.lifeLabel:setString(self.life)
		self.scoreLabel:setString(self.nowLevel-1)
		self:performWithDelay(function( ... )
			if self.nowLevel == 2 then
				self.gameBoard[self.nowLevel]:initMe()
				self.nowLevel = self.nowLevel +1
				one.action(self, "moveto", 0.5, ccp(0, 0), "sineout", cal)
				one.action(self.top, "moveby", 0.5, ccp(0, -160), "sineout", cal)
			else
				one.action(self.boardLayer, "moveby", 0.5, ccp(0, 160), "sineout", function( ... )
					self.gameBoard[self.nowLevel]:initMe()
					self.nowLevel = self.nowLevel +1
				end)
			end
		end, 0.5)
	else
		self.gameBoard[self.nowLevel]:initMe()
		self.nowLevel = self.nowLevel +1
	end
end

function Gamee_6_Scene:die()
	self.alive = false
	-- self:performWithDelay(function( ... )
	-- 	Gamee_6:enterScene("Gamee_6_Scene")
	-- end, 2)
	--这里死了
	--！！！！！！！！！！！
	--分数==self.nowLevel-1
end

return Gamee_6_Scene
