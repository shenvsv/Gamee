
local MainScene = class("MainScene", function()
    return require("Gamee_4.basic.BaseScene").new()
end)
local playlayer = require("Gamee_4.layers.PlayLayer")


function MainScene:ctor()
	print(222)
	self.score = 0
	self.start = false
	self.time = 3
	-- tools:addBtn("pause1", 60, 44, self, function ( ... )

	-- end)
	tools:setBg("background", self) 

	local play = playlayer.new()
	self:addChild(play)
	play:startGame(0)
	self.cLayer = play		

end

function MainScene:changeLayer()
	self.score = self.score + 1
	if not self.start then
		self.start = true
		self.sch = self:schedule(function ()
			self.time = self.time - 1
			print(self.time)
			if self.time < 0 then
				self:over()
			end
		end, 1)
	end
	self.tPoint = {}
	self.tPoint.t = false
	local play = playlayer.new()
	play.level:setString(""..self.score+1)
	self:addChild(play,-1)
	local lastlayer = self.cLayer
	lastlayer:destory()
	self.cLayer = nil
	self.cLayer = play
	self.cLayer:setZOrder(0)
	self.cLayer:startGame()
end

function MainScene:onEnter()
	    
end

function MainScene:onExit()

end

function MainScene:over()
	self:stopAction(self.sch)
	require("app.tools.game").over(self.score, 4)

end	

return MainScene
