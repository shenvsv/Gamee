--
-- Author: bacoo
-- Date: 2014-07-20 20:25:21
--
local Gamee_6_Me = class("Gamee_6_Me", function( ... )
    return one.spp("Gamee_6_Peng", x, 10, "")
end)

--弹跳时间
local jump_time = 0.7
--重力时间
local grav_time = 0.25
--弹跳高度
local jumo_height = 60


function Gamee_6_Me:ctor(father,dir,color,model)
    --定义速度
    self.runSpeed = 200
    self.model = model
    if model == "speed" then
        self.runSpeed = 350
    end
    self.floor = 1
    self.father = father
    self.color = color
    --定义是否可以跳
    self.canJump = true
    father:addChild(self)
    --定义前进的方向
    self.dir = dir
    if dir == 1 then
        self:x(-self:w()/2)
    elseif dir == -1 then
        self:x(father:w()+self:w()/2)
    end
    self:y(10)
    --设置碰撞的方块
    self.peng = one.spp("Gamee_6_Peng", self:w()/2, self:h()/2, self)
    --我的粒子系统
    local par = CCParticleSystemQuad:create("Gamee_6_Run.plist")
    par:setPositionX(par:getPositionX()+2)
    par:setPositionY(par:getPositionY()+3)
    par:setStartColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
    par:setEndColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
    self:addChild(par)
    --定义显示的方块
    self.cube = one.spp("Gamee_6_Cube", self:w()/2, self:h()/2, self)
    --设置方块的颜色
    self.cube:setColor(color)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self:x(self:x()+self.runSpeed*self.dir*dt)
        -- tar.leftBar:setScaleX(1-(70-self:y())/60)
        -- tar.rightBar:setScaleX(1-(70-self:y())/60)
        if self.dir == 1 then
            if self.model == "move" then
                if self:x()<=-10 then
                    self.runSpeed = -self.runSpeed
                end
            end
            if self:x()>=self:getParent():w()+10 then
                local par = CCParticleSystemQuad:create("Gamee_6_Star.plist")
                par:setAutoRemoveOnFinish(true)
                par:setStartColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
                par:setEndColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
                tar.gameBoard[tar.nowLevel-1]:addChild(par)
                par:setPosition(self:getPositionX(),80)
                self:removeSelf()
                tar.me = nil
                audio.playSound("Gamee_6_Success.wav")
                self.father:killObs()
             --   one.action(tar.leftBar, "scaleto", 0.1, {0,1}, ease, cal)
              --  one.action(tar.rightBar, "scaleto", 0.1, {0,1}, ease, cal)
                tar:callNextMe(true)
            end
        else
            if self.model == "move" then
                if self:x()>=self:getParent():w()+10 then
                    self.runSpeed = -self.runSpeed
                end
            end
            if self:x()<=-10 then
                local par = CCParticleSystemQuad:create("Gamee_6_Star.plist")
                par:setAutoRemoveOnFinish(true)
                par:setStartColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
                par:setEndColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
                tar.gameBoard[tar.nowLevel-1]:addChild(par)
                par:setPosition(self:getPositionX(),80)
                self:removeSelf()
                tar.me = nil
                audio.playSound("Gamee_6_Success.wav")
                self.father:killObs()
         --       one.action(tar.leftBar, "scaleto", 0.1, {0,1}, ease, cal)
          --      one.action(tar.rightBar, "scaleto", 0.1, {0,1}, ease, cal)
                tar:callNextMe(true)
            end
        end
    end)
    self:scheduleUpdate()
end

function Gamee_6_Me:jump()
    if self.model == "grav" then
        if self.canJump then
            self:stopAllActions()
            self.canJump = false
            local grav = CCMoveBy:create(grav_time, ccp(0, self.floor*140))
            self.floor = -self.floor
            --主角弹跳
            self:runAction(grav)
            self:performWithDelay(function( ... )
                self.canJump = true
            end, grav_time-0.02)
        end
    elseif self.model == "move" then
        self.runSpeed = -self.runSpeed
    else
        if self.canJump then
            self:stopAllActions()
            self.cube:stopAllActions()
            self.peng:stopAllActions()
            self.canJump = false
            self:y(10)
            self.cube:setRotation(0)
            self.peng:setRotation(0)
            local jump = CCJumpBy:create(jump_time, ccp(0, 0), jumo_height, 1)
            local rota = CCRotateBy:create(jump_time, 180*self.dir)
            local rota_p = CCRotateBy:create(jump_time, 180*self.dir)
            --主角弹跳
            self:runAction(jump)
            --方块旋转
            self.cube:runAction(rota)
            self.peng:runAction(rota_p)
            self:performWithDelay(function( ... )
                self.canJump = true
            end, jump_time-0.05)
        end
    end
end

function Gamee_6_Me:die()
    local par = CCParticleSystemQuad:create("Gamee_6_Boom.plist")
    par:setAutoRemoveOnFinish(true)
    par:setStartColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
    par:setEndColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
    tar.gameBoard[tar.nowLevel-1]:addChild(par)
    par:setPosition(self:getPosition())
    self:stopAllActions()
    self.cube:stopAllActions()
    self.peng:stopAllActions()
    self:unscheduleUpdate()
    tar:die()
    tar.lifeLabel:setString("0")
    -- one.action(tar.leftBar, "scaleto", 0.1, {0,1}, ease, cal)
    --             one.action(tar.rightBar, "scaleto", 0.1, {0,1}, ease, cal)
   -- tar.lifeLabel:x(10+tar.lifeLabel:w()/2)
    self:removeSelf()
end

function Gamee_6_Me:back()
    local par = CCParticleSystemQuad:create("Gamee_6_Boom.plist")
    par:setAutoRemoveOnFinish(true)
    par:setStartColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
    par:setEndColor(ccc4f(self.color.r/255, self.color.g/255, self.color.b/255, 1))
    tar.gameBoard[tar.nowLevel-1]:addChild(par)
    par:setPosition(self:getPosition())
    self:stopAllActions()
    self.cube:stopAllActions()
    self.peng:stopAllActions()
    if self.dir == 1 then
        self:x(-self:w()/2)
    elseif self.dir == -1 then
        self:x(self.father:w()+self:w()/2)
    end
    self:y(10)
    self.floor = 1
    self.cube:setRotation(0)
    self.peng:setRotation(0)
    self.canJump = true
    tar.lifeLabel:setString(tar.life)
end

return Gamee_6_Me


