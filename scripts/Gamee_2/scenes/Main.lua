local Main = class("Main", function()
    return require("Gamee_2.basic.BasicScene").new("Main")
end)


function Main:ctor()
    self:initUI()
end

function Main:initUI()
    self.score = 0
    self.start = false
    self.waterlayer = display.newLayer()
    self:addChild(self.waterlayer)
    self.water = one.spp("#water", display.cx, display.top, self.waterlayer)
    self.water:setAnchorPoint(ccp(0.5, 1))
    self.btn_rain = one.btnn("#btn_rain", display.right/3*2, display.top/3, function( ... )
        self.rainlayer:stop()
        self.btn_rain:setEnabled(false)
        local move = CCMoveBy:create(0.5, ccp(0, display.top/8*7-display.top/5*3))
        local ease = CCEaseSineOut:create(move)
        self.waterlayer:runAction(ease)
        local fade = CCFadeOut:create(1)
        self.unbre:runAction(fade)

        self.btn_rain:setVisible(false)
        self.btn_water:setVisible(false)
        self.btn_board:setVisible(false)
        self.play:setVisible(false)

        self.time:fade()
        local move = CCMoveBy:create(0.5, ccp(0, display.top/8*7-display.top/5*3))
        local ease = CCEaseSineOut:create(move)
        self.time:runAction(ease)

        self.playlayer:init()
        local move = CCMoveBy:create(0.5, ccp(0, display.top/8*7-display.top/5*3))
        local ease = CCEaseSineOut:create(move)
        self.playlayer:runAction(ease)
        
        self:performWithDelay(function( ... )
            self:touch(true, function(event, x, y)
                return self:onTouch_(event, x, y)
            end)
            
        end, 1)


    end, nil, self.waterlayer)
    self.btn_rain:setEnabled(false)
    self.btn_rain:setAnchorPoint(ccp(0.5, 1))
    self.btn_water = one.spp("Gamee_2_btn_water",display.right/3*2-100 , display.top/3-250, self.waterlayer)
    self.btn_water:setAnchorPoint(ccp(0.5, 1))
    self.btn_water:setZOrder(10)
    self.btn_board = one.spp("Gamee_2_btn_board",display.right/3*2, display.top/3+2,  self.waterlayer)
    self.btn_board:setAnchorPoint(ccp(0.5, 1))
    self.btn_board:setZOrder(10)
    self.play = one.spp("Gamee_2_play_btn", display.right/3*2-10, display.top/6, self.waterlayer)
    self.play:setOpacity(0)
    self.play:setZOrder(10)

    self.rainlayer = require("Gamee_2.layers.Rainlayer").new()
    self.waterlayer:addChild(self.rainlayer)
    self.rainlayer:start()

    self.yellow = one.spp("#yellow", display.cx, display.top/5*3-20, self.waterlayer)
    self.yellow:setAnchorPoint(ccp(0.5, 0))
    self.title = one.spp("#title", display.cx+20, display.top/6*5+20, self.waterlayer)
    self.unbre = one.spp("#unbre", display.right/2-123, display.top/5*3-10, self.waterlayer)
    self.dot_1 = one.spp("#dot_r", 108, 170, self.title)
    local jump = CCJumpBy:create(0.6, ccp(0, 0), 30, 1)
    local action = CCRepeatForever:create(jump)
    self.dot_1:runAction(action)
    self.dot_2 = one.spp("#dot_r", 182, 170, self.title)
    local jump = CCJumpBy:create(0.7, ccp(0, 0), 30, 1)
    local action = CCRepeatForever:create(jump)
    self.dot_2:runAction(action)
    self.dot_3 = one.spp("#dot_b", 303, 80, self.title)
    local jump = CCJumpBy:create(0.6, ccp(0, 0), 30, 1)
    local action = CCRepeatForever:create(jump)
    self.dot_3:runAction(action)

    self.time = require("Gamee_2.layers.Time").new()
    self:addChild(self.time)
    self.time:setPositionY(-display.top/8*7+display.top/5*3)

    self.playlayer = require("Gamee_2.layers.Play").new(self.yellow:getPositionY()+display.top/8*7-display.top/5*3)
    self:addChild(self.playlayer)
    self.playlayer:setPositionY(-display.top/8*7+display.top/5*3)

    self:performWithDelay(function()
        local move = CCMoveBy:create(0.8, ccp(100, self.btn_water:getContentSize().height-10))
        local ease = CCEaseSineOut:create(move)
        local call = CCCallFunc:create(function( ... )
            self.btn_rain:setEnabled(true)
        end)
        local action = transition.sequence({ease,call})
        self.btn_water:runAction(action)
        local fade = CCFadeIn:create(1.5)
        self.play:runAction(fade)
    end, 0.5)
end

function Main:onTouch_(event, x, y)
    if event == "began" then
        for i,v in ipairs(self.playlayer.Stab) do
            if v.floor == 2 then
                if v:getCascadeBoundingBox():containsPoint(ccp(x, y)) then
                    if not self.start then
                        self.start = true
                        self.time:start()
                    end
                    audio.playSound("s.ogg")
                    self.playlayer:down()
                    v:bye()
                    self.score = self.score + 1
                    return false
                end
            end
        end
        for i,v in ipairs(self.playlayer.Ltab) do
            if v.floor == 2 then
                if v:getCascadeBoundingBox():containsPoint(ccp(x, y)) then
                    self:over()
                    return false
                end
            end
        end
        return false
    end
end

function Main:over()
    print("//"..self.score)
    
    -- self:touch(false)
    -- self.playlayer:over()
    -- self.time:over()
    -- local move = CCMoveBy:create(0.5, ccp(0, -display.top/8*7+display.top/5*3))
    -- local ease = CCEaseSineOut:create(move)
    -- self.waterlayer:runAction(ease)

    -- local move = CCMoveBy:create(0.5, ccp(0, -display.top/8*7+display.top/5*3))
    -- local ease = CCEaseSineOut:create(move)
    -- self.time:runAction(ease)

    -- local move = CCMoveBy:create(0.5, ccp(0, -display.top/8*7+display.top/5*3))
    -- local ease = CCEaseSineOut:create(move)
    -- self.playlayer:runAction(ease)

    -- self.rainlayer.die = false
    -- self.rainlayer:start()

    

    -- local fade = CCFadeIn:create(2)
    -- self.unbre:runAction(fade)

    -- self.btn_rain:setVisible(true)
    -- self.btn_water:setVisible(true)
    -- self.btn_board:setVisible(true)
    -- self.play:setVisible(true)
    -- self.play:setOpacity(0)
    -- self.time.time = 30
    -- self.start = false
    -- self.btn_water:setPosition(display.right/3*2-100 , display.top/3-250)
    -- self:performWithDelay(function(  )
    --     local move = CCMoveBy:create(0.8, ccp(100, self.btn_water:getContentSize().height-10))
    --     local ease = CCEaseSineOut:create(move)
    --     local call = CCCallFunc:create(function( ... )
    --         self.btn_rain:setEnabled(true)
    --     end)
    --     local action = transition.sequence({ease,call})
    --     self.btn_water:runAction(action)
    --     local fade = CCFadeIn:create(1.5)
    --     self.play:runAction(fade)
    -- end, 0.5)
    print("over")
end


return Main