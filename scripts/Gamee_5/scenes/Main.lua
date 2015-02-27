local Main = class("Main", function()
    return require("Gamee_5.basic.BasicScene").new("Main")
end)


function Main:ctor()
    audio.playMusic("bg.mp3", true)
    self.ok = false
    self.die = true
    self.started = false
    self:initUI()
    self:touch(true, function(event, x, y)
        return self:onTouch_(event, x, y)
    end)
end
--153 208 222 -背景211 241 249

function Main:initUI()
    self.bg = one.spp("#bg", display.cx, display.cy)
    self.bg:setColor(ccc3(211, 241, 249))

    self.cloud_1 = require("Gamee_5.sprites.Cloud_1").new(100,370)
    self:addChild(self.cloud_1)
    self.cloud_2 = require("Gamee_5.sprites.Cloud_2").new(display.right-200,410)
    self:addChild(self.cloud_2)

    self.city = require("Gamee_5.sprites.City").new()
    self:addChild(self.city)
    self.city:setColor(ccc3(153, 208, 222))

    self.c_b = require("Gamee_5.sprites.C_b").new()
    self.ship = require("Gamee_5.sprites.Ship").new(self.c_b:getContentSize().width/2, self.c_b:getContentSize().height/5*4)
    self.c_b:addChild(self.ship,10)

    self.c_s = require("Gamee_5.sprites.C_s").new()
    self.c_s:setColor(ccc3(211, 241, 249))

    self.num = require("Gamee_5.sprites.Num").new()
    
    self.ship_btn = one.spp("#s_b", display.cx, 150)
    self.ship_tap = one.spp("#tab", display.cx, 70)



    self.back = ui.newTTFLabelMenuItem({
        x = display.right/4,
        y = 110,
        text = "Back",
        align = ui.TEXT_ALIGN_CENTER,
        size = 80,
        listener = function( ... )
            print(11)
        end
        })
    self.menu:addChild(self.back)
    self.back:setEnabled(false)
    self.back:setOpacity(0)




    local jump = CCJumpBy:create(1.3, ccp(0, 0), 10, 1)
    local action = CCRepeatForever:create(jump)
    self.ship_btn:runAction(action)

    
end

function Main:onTouch_(event, x, y)
    if event == "began" then
        if not self.started then
            audio.playSound("click.wav")
            self.started = true
            self.die = false
            self.ship:jump()
            self.c_s:run()

        elseif not self.die then
            audio.playSound("click.wav")
            self.ship:jump()
        elseif self.die  then

            --- show 
            -- self:init()

            -- local move = CCMoveTo:create(0.3, ccp(display.cx, 150))
            -- local ease = CCEaseSineOut:create(move)
            -- self.ship_btn:runAction(ease)
            -- local move = CCMoveTo:create(0.3, ccp(display.cx, 70))
            -- local ease = CCEaseSineOut:create(move)
            -- self.ship_tap:runAction(ease)
            -- local op = CCFadeTo:create(0.3, 0)
            -- self.back:runAction(op)
            -- self.back:setEnabled(false)
        end
        return false
    end
end

function Main:setDie()
    local move = CCMoveBy:create(0.3, ccp(display.cx-display.right/4, 0))
    local ease = CCEaseSineOut:create(move)
    self.ship_btn:runAction(ease)
    local move = CCMoveBy:create(0.3, ccp(display.cx-display.right/4, 0))
    local ease = CCEaseSineOut:create(move)
    self.ship_tap:runAction(ease)
    local op = CCFadeTo:create(0.5, 255)
    self.back:runAction(op)
    self.back:setEnabled(true)


    audio.playSound("die.wav")
    self.die = true
    local ti = CCTintTo:create(0.3, 68, 68, 68)
    self.bg:runAction(ti)
    local tc = CCTintTo:create(0.3, 28, 28, 28)
    local td = CCTintTo:create(0.3, 28, 28, 28)
    self.city:runAction(tc,td)
    self.c_s:setDie()
    self:touch(false)
    self:performWithDelay(function()
        self:touch(true, function(event, x, y)
            return self:onTouch_(event, x, y)
        end)
    end, 0.5)

    -- enter
    
end

function Main:changeColor(index)
    if index == 5 then
        local ti = CCTintTo:create(0.3, 147, 251, 176)
        self.bg:runAction(ti)
        local tc = CCTintTo:create(0.3, 242, 205, 103)
        local td = CCTintTo:create(0.3, 242, 205, 103)
        self.city:runAction(tc,td)
        self.c_s:changeColor(147, 251, 176)
    elseif index == 10 then
        local ti = CCTintTo:create(0.3, 249, 144, 51)
        self.bg:runAction(ti)
        local tc = CCTintTo:create(0.3, 128, 224, 200)
        local td = CCTintTo:create(0.3, 128, 224, 200)
        self.city:runAction(tc,td)
        self.c_s:changeColor(249, 144, 51)
    elseif index == 15 then
        local ti = CCTintTo:create(0.3, 67, 46, 114)
        self.bg:runAction(ti)
        local tc = CCTintTo:create(0.3, 249, 243, 83)
        local td = CCTintTo:create(0.3, 249, 243, 83)
        self.city:runAction(tc,td)
        self.c_s:changeColor(67, 46, 114)
    end
end

function Main:init()
    self.c_b:back()
    self.c_s:back()
    self.num:back()
    self.ship:back()
    local ti = CCTintTo:create(0.2, 211, 241, 249)
    self.bg:runAction(ti)
    local tc = CCTintTo:create(0.2, 153, 208, 222)
    local td = CCTintTo:create(0.2, 153, 208, 222)
    self.city:runAction(tc,td)
    self.started = false
end


return Main