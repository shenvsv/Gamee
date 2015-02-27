
local Gamee_3_Scene = class("Gamee_3_Scene", function()
    return require("lib.TScene").new("Gamee_3_Scene")
end)

local GanNode = nil

function Gamee_3_Scene:ctor()
    self.score = 0
    display.addSpriteFramesWithFile("Gamee_3.plist", "Gamee_3.png")
    math.newrandomseed()
    self:initUI()
    self:initStart()
    self:initColl()
end

function Gamee_3_Scene:initUI()
    self.bg = one.color(ccc4(233, 230, 214, 255), target)
    self.shan_1 = one.spp("#Gamee_3_Shan_1", 54, 140, target)
    self.shan_2 = one.spp("#Gamee_3_Shan_2", 50, 360, target)
    self.lake = one.spp("#Gamee_3_Lake", display.cx, 0, target)
    self.lake:ap(ccp(0.5, 0))
    self.tree_1 = one.spp("#Gamee_3_Tree_1", display.right-10, 380, target)
    self.tree_2 = one.spp("#Gamee_3_Tree_2", display.right-30, 590, target)
    self.stone_1 = one.spp("#Gamee_3_Stone_1", display.right-35, 250, target)
    self.stone_2 = one.spp("#Gamee_3_Stone_2", display.right-50, 140, target)
    self.duck_2 = one.spp("#Gamee_3_Duck_2",display.cx-40, 110, target)
    self.duck_2:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self.duck_2:x(self.duck_2:x()+dt*20)
        if self.duck_2:x()>= display.right+self.duck_2:w()/2 then
            self.duck_2:x(display.left -self.duck_2:w()/2 )
        end
    end)
    self.duck_2:scheduleUpdate()
    self.duck_1 = one.spp("#Gamee_3_Duck_1",display.right-50, 100, target)
    self.duck_1:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self.duck_1:x(self.duck_1:x()-dt*30)
        if self.duck_1:x()<= display.left-self.duck_1:w()/2 then
            self.duck_1:x(display.right +self.duck_1:w()/2 )
        end
    end)
    --
    self.leaf_1 = one.spp("#Gamee_3_Leaf_1", display.right+10, 75, target)
    self.leaf_2 = one.spp("#Gamee_3_Leaf_2", 45, display.top-200, target)
    self.leaf_3 = one.spp("#Gamee_3_Leaf_3", 35, display.cy-194, target)
    self.leaf_3:setRotation(25)
    self.birdTree = one.spp("#Gamee_3_Bird_Tree", 45, display.cy-120, target)
    self.monkey = one.spp("#Gamee_3_monkey00",55, display.cy-205, target)
    local frames = display.newFrames("Gamee_3_monkey%02d.png", 0, 30)
    local animation = display.newAnimation(frames, 0.8/30)
    display.setAnimationCache("monkey", animation)
    function monkeyAni()
        self:performWithDelay(function()
            self.monkey:playAnimationOnce(display.getAnimationCache("monkey"),false,function( ... )
                monkeyAni()
            end)
        end,2)
    end
    monkeyAni()
    self.bird = one.spp("#Gamee-3-bird00", 5, display.cy-15, target)
    self.bird:setScale(0.9)
    local frames = display.newFrames("Gamee-3-bird%02d.png", 0, 13)
    local animation = display.newAnimation(frames, 0.5/14)
    display.setAnimationCache("bird", animation)
    self.scoreBoard = one.spp("#Gamee_3_Score_Board", 50, display.cy+100, target)
    self.scoreGe = one.spp("#Gamee_3_Num_0", self.scoreBoard:w()-25, self.scoreBoard:h()/3+10, self.scoreBoard)
    self.scoreShi = one.spp("#Gamee_3_Num_0", self.scoreBoard:w()-55, self.scoreBoard:h()/3+10, self.scoreBoard)
    self.scoreBai = one.spp("#Gamee_3_Num_0", self.scoreBoard:w()-85, self.scoreBoard:h()/3+10, self.scoreBoard)
    self.coll = one.coll(0, 60, display.right, display.top, target)
    self.ganNode = GanNode.new()
    self.coll:addChild(self.ganNode)
    self.stone_3 = one.spp("#Gamee_3_Stone_3", display.right/5+10, 60, target)
    self.stone_4 = one.spp("#Gamee_3_Stone_4", display.right/5*2+10, 50, target)
    self.stone_5 = one.spp("#Gamee_3_Stone_3", display.right/5*3+10, 60, target)
    self.stone_6 = one.spp("#Gamee_3_Stone_4", display.right/5*4, 50, target)
    self.touch = display.newLayer()
    self.upLine = one.spp("#Gamee_3_Line", display.cx, display.top-130, target)
    self.upLine:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        for i,v in ipairs(self.ganNode.zhi) do
            if v.alive then
                if self.upLine:getCascadeBoundingBox():intersectsRect(v:getCascadeBoundingBox()) then
                    v.alive = false
                    one.action(v, "scaleto", 0.2, {0.5,1}, nil, cal)
                end
            end
        end
    end)
    self.upLine:scheduleUpdate()
    self.downLine = one.spp("#Gamee_3_Line", display.cx, 160, target)
    self.downLine:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        for i,v in ipairs(self.ganNode.zhi) do
            if not v.alive then
                if self.downLine:getCascadeBoundingBox():intersectsRect(v:getCascadeBoundingBox()) then
                    v.alive = true
                    one.action(v, "scaleto", 0.8, {1,1}, nil, cal)
                end
            end
        end
    end)
    self.downLine:scheduleUpdate()
    self:addChild(self.touch)
    self.touch:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
    self.touch:setTouchEnabled(true)
    self.touch:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            for k,v in pairs(event.points) do
                self.ganNode:flip(v.x)
            end
            return true
        elseif event.name == "moved" then
            for k,v in pairs(event.points) do
                if v.prevX == 0 then
                    self.ganNode:flip(v.x)
                end
            end
        end
    end)
    self.leaf_4 = one.spp("#Gamee_3_Leaf_4", display.cx, display.top, target)
    self.leaf_4:ap(ccp(0.5, 1))
end

function Gamee_3_Scene:initStart( ... )
	self.startBg = one.color(ccc4(233, 230, 214, 255), self)
	self.startTree_1 = one.spp("#Gamee_3_Start_Tree_1", 140, 380, self.startBg)
	self.startTree_2 = one.spp("#Gamee_3_Start_Tree_2", display.right-40, 420, self.startBg)
	self.startTree_3 = one.spp("#Gamee_3_Tree_2", display.right-120, 540, self.startBg)
	self.startShan = one.spp("#Gamee_3_Shan_1", 50, 170, self.startBg)
	self.startShan:setRotation(-10)
	self.startLaker = one.spp("#Gamee_3_Start_Lake", display.cx, 0, self.startBg):ap(ccp(0.5, 0))
	self.startDoor = one.spp("#Gamee_3_Start_Door", 280, 300, self.startBg)
	self.startLeave= one.spp("#Gamee_3_Leaf_4", display.cx, display.top, self.startBg):ap(ccp(0.5, 1))
	self.startStone = one.spp("#Gamee_3_Stone_2", display.right-100, 140, self.startBg)
	self.startDuck_1 = one.spp("#Gamee_3_Duck_1",display.right-50, 100, self.startBg)
	self.startDuck_2 = one.spp("#Gamee_3_Duck_2",display.cx-40, 60, self.startBg)
	self.startDuck_2:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self.startDuck_2:x(self.startDuck_2:x()+dt*20)
        if self.startDuck_2:x()>= display.right+self.startDuck_2:w()/2 then
            self.startDuck_2:x(display.left -self.startDuck_2:w()/2 )
        end
    end)
    self.startDuck_2:scheduleUpdate()
    self.startBtn = one.btnn({"#Gamee_3_Start_Btn",2}, 190, 235, function()
        local speed = 0.5
    	self.startBtn:setButtonEnabled(false)
    	self.sc = scheduler.scheduleUpdateGlobal(function()
    		self.ci:setScale(self.ci:getScale()-speed)
            speed = speed + 0.02
    		if self.ci:getScale()<=1 then
    			self.startBg:setVisible(false)
    			scheduler.unscheduleGlobal(self.sc)
    			self:performWithDelay(function( ... )
                    local speed_2 = speed
    				self.sc = scheduler.scheduleUpdateGlobal(function()
    					self.ci:setScale(self.ci:getScale()+speed_2)
                        speed_2 = speed_2+0.02
    					if self.ci:getScale()>=40 then
    						self:startGame()
    						scheduler.unscheduleGlobal(self.sc)
    					end
    				end)
    			end, 0)
    		end
    	end)
   	end, nil, self.startDoor)
    self.startBird = one.spp("#Gamee-3-bird00", 260, 360, self.startDoor)
    self.startBird:setScale(0.6)
   	function ani()
   		self.startBird:playAnimationOnce(display.getAnimationCache("bird"))
   		self:performWithDelay(function()
   			ani()
   		end, 2)
   	end
   	ani()
end

function Gamee_3_Scene:initColl()
    self.ci =display.newCircle(30, {
        x=display.right-50,
        y=100,
        fill=true,
        color=cc.c4f(1, 0, 0, 1)})
    self.aa = CCClippingNode:create(self.ci)
    self.aa:setInverted(true)
    self.ba = one.color(ccc4(0, 0, 0, 255), self.aa)
    self:addChild(self.aa)
    self.ci:setScale(40)
end



function Gamee_3_Scene:addScore()
    self.score = self.score +1
    self.ganNode.fallSpeed = self.ganNode.fallSpeed +20
    if self.ganNode.fallSpeed>=600 then
        self.ganNode.fallSpeed = 600
    end
    if self.score<10 then
        self.scoreGe:setDisplayFrame(display.newSpriteFrame("Gamee_3_Num_"..self.score..".png"))
        self.scoreGe:setScale(0)
        one.action(self.scoreGe, "scaleto", 0.5, 1, "bout", cal)
    elseif self.score <100 then
        local num = tostring(self.score)
        local shi = string.sub(num, 1,1)
        local ge = string.sub(num, -1,-1)
        self.scoreGe:setDisplayFrame(display.newSpriteFrame("Gamee_3_Num_"..ge..".png"))
        self.scoreShi:setDisplayFrame(display.newSpriteFrame("Gamee_3_Num_"..shi..".png"))
        self.scoreGe:setScale(0)
        one.action(self.scoreGe, "scaleto", 0.5, 1, "bout", cal)
        if ge == "0" then
            self.scoreShi:setScale(0)
            one.action(self.scoreShi, "scaleto", 0.5, 1, "bout", cal)
        end
    else
        local num = tostring(self.score)
        local bai = string.sub(num, 1,1)
        local shi = string.sub(num, 2,2)
        local ge = string.sub(num, -1,-1)
        self.scoreBai:setDisplayFrame(display.newSpriteFrame("Gamee_3_Num_"..bai..".png"))
        self.scoreGe:setDisplayFrame(display.newSpriteFrame("Gamee_3_Num_"..ge..".png"))
        self.scoreShi:setDisplayFrame(display.newSpriteFrame("Gamee_3_Num_"..shi..".png"))
        self.scoreGe:setScale(0)
        one.action(self.scoreGe, "scaleto", 0.5, 1, "bout", cal)
        if ge == "0" then
            self.scoreShi:setScale(0)
            one.action(self.scoreShi, "scaleto", 0.5, 1, "bout", cal)
        end
        if ge == "0" and shi =="0" then
            self.scoreBai:setScale(0)
            one.action(self.scoreBai, "scaleto", 0.5, 1, "bout", cal)
        end
    end
end

function Gamee_3_Scene:startGame()
    self.duck_1:scheduleUpdate()
    self.ganNode:scheduleUpdate()
    self:performWithDelay(function( ... )
        self.bird:playAnimationOnce(display.getAnimationCache("bird"))
        self.ganNode:fall()
    end, 1)
end

GanNode = class("GanNode", function()
    return display.newLayer()
end)

function GanNode:ctor()
    self.speed = 50
    self.gan = {{},{},{},{}}
    self.gan[1][1] = one.spp("#Gamee_3_Gan", display.right/5, 0, self)
    self.gan[1][1]:ap(ccp(0.5, 0))
    self.boom = {}
    self.zhi = {}
    self.zhi[1] = one.spp("#Gamee_3_Cha_2", self.gan[1][1]:w()/2-8, self.gan[1][1]:h()/6*4, self.gan[1][1]):ap(ccp(0, 0.5))
    self.zhi[2] = one.spp("#Gamee_3_Cha_1", self.gan[1][1]:w()/2+10, self.gan[1][1]:h()/6*2, self.gan[1][1]):ap(ccp(1, 0.5))
    self.zhi[3] = one.spp("#Gamee_3_Cha_2", self.gan[1][1]:w()/2-8, self.gan[1][1]:h()/6*0, self.gan[1][1]):ap(ccp(0, 0.5))
    self.boom[1] = one.spp("#Gamee_3_Boom", 60, 20, self.zhi[1])
    self.boom[2] = one.spp("#Gamee_3_Boom", 15, 40, self.zhi[2])
    self.boom[3] = one.spp("#Gamee_3_Boom", 60, 20, self.zhi[3])
    self.gan[2][1] = one.spp("#Gamee_3_Gan", display.right/5*2, 0, self)
    self.gan[2][1]:ap(ccp(0.5, 0))
    self.zhi[4] = one.spp("#Gamee_3_Cha_1", self.gan[2][1]:w()/2+10, self.gan[2][1]:h()/6*5, self.gan[2][1]):ap(ccp(1, 0.5))
    self.zhi[5] = one.spp("#Gamee_3_Cha_5", self.gan[2][1]:w()/2-4, self.gan[2][1]:h()/6*3, self.gan[2][1]):ap(ccp(0, 0.5))
    self.zhi[6] = one.spp("#Gamee_3_Cha_1", self.gan[2][1]:w()/2+10, self.gan[2][1]:h()/6*1, self.gan[2][1]):ap(ccp(1, 0.5))
    self.boom[4] = one.spp("#Gamee_3_Boom", 15, 40, self.zhi[4])
    self.boom[5] = one.spp("#Gamee_3_Boom", 58, 40, self.zhi[5])
    self.boom[6] = one.spp("#Gamee_3_Boom", 15, 40, self.zhi[6])
    self.gan[3][1] = one.spp("#Gamee_3_Gan", display.right/5*3, 0, self)
    self.gan[3][1]:ap(ccp(0.5, 0))
    self.zhi[7] = one.spp("#Gamee_3_Cha_4", self.gan[3][1]:w()/2-8, self.gan[3][1]:h()/6*4, self.gan[3][1]):ap(ccp(0, 0.5))
    self.zhi[8] = one.spp("#Gamee_3_Cha_3", self.gan[3][1]:w()/2+10, self.gan[3][1]:h()/6*2, self.gan[3][1]):ap(ccp(1, 0.5))
    self.zhi[9] = one.spp("#Gamee_3_Cha_4", self.gan[3][1]:w()/2-8, self.gan[3][1]:h()/6*0, self.gan[3][1]):ap(ccp(0, 0.5))
    self.boom[7] = one.spp("#Gamee_3_Boom", 65, 16, self.zhi[7])
    self.boom[8] = one.spp("#Gamee_3_Boom", 12, 50, self.zhi[8])
    self.boom[9] = one.spp("#Gamee_3_Boom", 65, 16, self.zhi[9])
    self.gan[4][1] = one.spp("#Gamee_3_Gan", display.right/5*4, 0, self)
    self.gan[4][1]:ap(ccp(0.5, 0))
    self.zhi[10] = one.spp("#Gamee_3_Cha_2", self.gan[4][1]:w()/2-8, self.gan[4][1]:h()/6*5, self.gan[4][1]):ap(ccp(0, 0.5))
    self.zhi[11] = one.spp("#Gamee_3_Cha_3", self.gan[4][1]:w()/2+10, self.gan[4][1]:h()/6*3, self.gan[4][1]):ap(ccp(1, 0.5))
    self.zhi[12] = one.spp("#Gamee_3_Cha_5", self.gan[4][1]:w()/2-4, self.gan[4][1]:h()/6, self.gan[4][1]):ap(ccp(0, 0.5))
    self.boom[10] = one.spp("#Gamee_3_Boom", 60, 20, self.zhi[10])
    self.boom[11] = one.spp("#Gamee_3_Boom", 12, 50, self.zhi[11])
    self.boom[12] = one.spp("#Gamee_3_Boom", 58, 40, self.zhi[12])
    self.gan[1][2] = one.spp("#Gamee_3_Gan", display.right/5, -self.gan[1][1]:h()+1, self)
    self.gan[1][2]:ap(ccp(0.5, 0))
    self.zhi[13] = one.spp("#Gamee_3_Cha_1", self.gan[1][2]:w()/2+10, self.gan[1][2]:h()/6*5, self.gan[1][2]):ap(ccp(1, 0.5))
    self.zhi[14] = one.spp("#Gamee_3_Cha_5", self.gan[1][2]:w()/2-4, self.gan[1][2]:h()/6*3, self.gan[1][2]):ap(ccp(0, 0.5))
    self.zhi[15] = one.spp("#Gamee_3_Cha_1", self.gan[1][2]:w()/2+10, self.gan[1][2]:h()/6*1, self.gan[1][2]):ap(ccp(1, 0.5))
    self.boom[13] = one.spp("#Gamee_3_Boom", 15, 40, self.zhi[13])
    self.boom[14] = one.spp("#Gamee_3_Boom", 58, 40, self.zhi[14])
    self.boom[15] = one.spp("#Gamee_3_Boom", 15, 40, self.zhi[15])
    self.gan[2][2] = one.spp("#Gamee_3_Gan", display.right/5*2, -self.gan[2][1]:h()+1, self)
    self.gan[2][2]:ap(ccp(0.5, 0))
    self.zhi[16] = one.spp("#Gamee_3_Cha_2", self.gan[2][2]:w()/2-8, self.gan[2][2]:h()/6*4, self.gan[2][2]):ap(ccp(0, 0.5))
    self.zhi[17] = one.spp("#Gamee_3_Cha_1", self.gan[2][2]:w()/2+10, self.gan[2][2]:h()/6*2, self.gan[2][2]):ap(ccp(1, 0.5))
    self.zhi[18] = one.spp("#Gamee_3_Cha_2", self.gan[2][2]:w()/2-8, self.gan[2][2]:h()/6*0, self.gan[2][2]):ap(ccp(0, 0.5))
    self.boom[16] = one.spp("#Gamee_3_Boom", 60, 20, self.zhi[16])
    self.boom[17] = one.spp("#Gamee_3_Boom", 15, 40, self.zhi[17])
    self.boom[18] = one.spp("#Gamee_3_Boom", 60, 20, self.zhi[18])
    self.gan[3][2] = one.spp("#Gamee_3_Gan", display.right/5*3, -self.gan[3][1]:h()+1, self)
    self.gan[3][2]:ap(ccp(0.5, 0))
    self.zhi[19] = one.spp("#Gamee_3_Cha_2", self.gan[3][2]:w()/2-8, self.gan[3][2]:h()/6*5, self.gan[3][2]):ap(ccp(0, 0.5))
    self.zhi[20] = one.spp("#Gamee_3_Cha_3", self.gan[3][2]:w()/2+10, self.gan[3][2]:h()/6*3, self.gan[3][2]):ap(ccp(1, 0.5))
    self.zhi[21] = one.spp("#Gamee_3_Cha_5", self.gan[3][2]:w()/2-4, self.gan[3][2]:h()/6, self.gan[3][2]):ap(ccp(0, 0.5))
    self.boom[19] = one.spp("#Gamee_3_Boom", 60, 20, self.zhi[19])
    self.boom[20] = one.spp("#Gamee_3_Boom", 12, 50, self.zhi[20])
    self.boom[21] = one.spp("#Gamee_3_Boom", 58, 40, self.zhi[21])
    self.gan[4][2] = one.spp("#Gamee_3_Gan", display.right/5*4, -self.gan[4][1]:h()+1, self)
    self.gan[4][2]:ap(ccp(0.5, 0))
    self.zhi[22] = one.spp("#Gamee_3_Cha_4", self.gan[4][2]:w()/2-8, self.gan[4][2]:h()/6*4, self.gan[4][2]):ap(ccp(0, 0.5))
    self.zhi[23] = one.spp("#Gamee_3_Cha_3", self.gan[4][2]:w()/2+10, self.gan[4][2]:h()/6*2, self.gan[4][2]):ap(ccp(1, 0.5))
    self.zhi[24] = one.spp("#Gamee_3_Cha_4", self.gan[4][2]:w()/2-8, self.gan[4][2]:h()/6*0, self.gan[4][2]):ap(ccp(0, 0.5))
    self.boom[22] = one.spp("#Gamee_3_Boom", 65, 16, self.zhi[22])
    self.boom[23] = one.spp("#Gamee_3_Boom", 12, 50, self.zhi[23])
    self.boom[24] = one.spp("#Gamee_3_Boom", 65, 16, self.zhi[24])
    for i,v in ipairs(self.zhi) do
        if i == 3 or i == 9 then
            v.alive = false
            v:setScaleX(0.5)
        elseif i<=12 then
            v.alive = true
        else
            v.alive = false
            v:setScaleX(0.5)
        end
    end
    self.fallTime = 200
    self.fallNow = 100
    self.fallSpeed = 300
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        for i,v in ipairs(self.gan) do
            for ii,vv in ipairs(v) do
                vv:y(vv:y()+self.speed*dt)
                if vv:y()>=display.top then
                    vv:y(vv:y()-2*vv:h()+1)
                end
            end
        end
        -- self.fallNow = self.fallNow +1
        -- if self.fallNow == self.fallTime then
        --     self.fallNow = 0
        --     self:fall()
        -- end
    end)
    --self:scheduleUpdate()
end

function GanNode:flip(x)
    if x<display.right*0.3 then
        self.gan[1][1]:setScaleX(-1*self.gan[1][1]:getScaleX())
        self.gan[1][2]:setScaleX(-1*self.gan[1][2]:getScaleX())
    elseif x<display.right*0.5 then
        self.gan[2][1]:setScaleX(-1*self.gan[2][1]:getScaleX())
        self.gan[2][2]:setScaleX(-1*self.gan[2][2]:getScaleX())
    elseif x<display.right*0.7 then
        self.gan[3][1]:setScaleX(-1*self.gan[3][1]:getScaleX())
        self.gan[3][2]:setScaleX(-1*self.gan[3][2]:getScaleX())
    else
        self.gan[4][1]:setScaleX(-1*self.gan[4][1]:getScaleX())
        self.gan[4][2]:setScaleX(-1*self.gan[4][2]:getScaleX())
    end
end

function GanNode:fall(line,coll)
    local rand = math.random(1,3)
    local appleOrLi = math.random(1,2)
    if line then
        rand = line
    end
    local fall = one.spp("#Gamee_3_Fall_"..appleOrLi, display.right*(0.2*rand+0.1), display.top, self)
    fall.id = appleOrLi
    if coll then
        fall.add = false
    else
        fall.add = true
    end
    fall:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        for i,v in ipairs(self.boom) do
            if v:getCascadeBoundingBox():intersectsRect(fall:getCascadeBoundingBox()) then
                self:unscheduleUpdate()
                if fall.id == 1 then
                    local par = CCParticleSystemQuad:create("Gamee_3_Apple.plist")
                    audio.playSound("Gamee_3_Die.ogg")
                    par:setAutoRemoveOnFinish(true)
                    self:addChild(par)
                    par:setPosition(fall:x(),fall:y())
                    fall:unscheduleUpdate()
                else
                    local par = CCParticleSystemQuad:create("Gamee_3_Li.plist")
                    audio.playSound("Gamee_3_Die.ogg")
                    par:setAutoRemoveOnFinish(true)
                    self:addChild(par)
                    par:setPosition(fall:x(),fall:y())
                    fall:unscheduleUpdate()
                end
                fall:removeSelf()
                tar.touch:setTouchEnabled(false)
                self:performWithDelay(function()
                    app:enterScene("Gamee_3_Scene")
                end, 2)
                return
            end
        end
        fall:y(fall:y()-self.fallSpeed*dt)
        if fall:y()<fall:h()/4*3 then
            if fall.id == 1 then
                local par = CCParticleSystemQuad:create("Gamee_3_Water.plist")
                par:setAutoRemoveOnFinish(true)
                self:addChild(par)
                par:setPosition(fall:x(),fall:y())
                audio.playSound("Gamee_3_Water.wav")
                local score = tostring(tar.score)
                if string.sub(score,-1,-1)== "4" then
                    self:fall(1)
                    self:fall(3,true)
                else
                    if fall.add then
                        self:fall()
                    end
                end

                tar:addScore()

                tar.bird:playAnimationOnce(display.getAnimationCache("bird"))
                -- audio.playSound("Gamee_3_Bird.wav")
                fall:unscheduleUpdate()
            else
                local par = CCParticleSystemQuad:create("Gamee_3_Water.plist")
                par:setAutoRemoveOnFinish(true)
                self:addChild(par)
                par:setPosition(fall:x(),fall:y())
                audio.playSound("Gamee_3_Water.wav")
                local score = tostring(tar.score)
                if string.sub(score,-1,-1)== "4" then
                    self:fall(1)
                    self:fall(3,true)
                else
                    if fall.add then
                        self:fall()
                    end
                end

                tar:addScore()

                tar.bird:playAnimationOnce(display.getAnimationCache("bird"))
                --audio.playSound("Gamee_3_Bird.wav")
                fall:unscheduleUpdate()
            end
            fall:removeSelf()
        end
    end)
    fall:scheduleUpdate()
end

return Gamee_3_Scene







