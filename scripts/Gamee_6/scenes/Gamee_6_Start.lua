--
-- Author: bacoo
-- Date: 2014-08-08 14:29:23
--
local Gamee_6_Start = class("Gamee_6_Start", function()
    return require("lib.TScene").new("Gamee_6_Start")
end)

function Gamee_6_Start:ctor()
    self.pur = one.color(ccc4(158, 81, 126, 255), target)
    self.green = one.color(ccc4(128, 195, 151, 255), target)
    self.green:y(display.top/4)
    self.yellow = one.color(ccc4(248, 208, 101, 255), target)
    self.yellow:y(display.top/4*2)
    self.blue = one.color(ccc4(89, 104, 143, 255), target)
    self.blue:y(display.top/4*3)
    self.title = one.spp("Gamee_6_Title", display.cx, 116, self.blue)
    self.title_i = one.spp("Gamee_6_Title_I", display.cx+75, 14, self.blue)
    self.title_i:ap(ccp(0.5, 0))
    self.start = one.btn({"Gamee_6_Play",2}, display.cx, 115, function()
        app:enterScene("Gamee_6_Scene")
    end, sound, self.green)
    self.z_1 = one.spp9("Gamee_6_Cube", display.right/3-40, 0,CCSize(50, 40), self.yellow):ap(ccp(0.5, 0)):setColor(ccc3(128, 195, 151))
    self.z_2 = one.spp9("Gamee_6_Cube", display.right/3*2+70, 0,CCSize(50, 40), self.yellow):ap(ccp(0.5, 0)):setColor(ccc3(128, 195, 151))
    self.z_1 = one.spp9("Gamee_6_Cube", display.right/3-100, 0,CCSize(40, 35), self.green):ap(ccp(0.5, 0)):setColor(ccc3(158, 81, 126))
    self.z_2 = one.spp9("Gamee_6_Cube", display.right/3*2+100, 0,CCSize(45, 35), self.green):ap(ccp(0.5, 0)):setColor(ccc3(158, 81, 126))
    local color = ccc3(248, 208, 101)
    self.par = CCParticleSystemQuad:create("Gamee_6_Run.plist")
    self.par:setPositionX(self.par:getPositionX()+2)
    self.par:setPositionY(self.par:getPositionY()+3)
    self.par:setStartColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
    self.par:setEndColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
    self:addChild(self.par)
    self.m = one.spp9("Gamee_6_Cube", display.cx/4-10,display.top/4*3+140,CCSize(30, 30), self)
    --self.m:ap(ccp(0.5, 0))
    self.m:setColor(ccc3(248, 208, 101))
    self.m:setRotation(-25)
    local jump = CCJumpTo:create(0.5, ccp(display.cx/4,display.top/4*3+200), 30, 1)
    self.m:setScaleX(1.5)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    	self.par:setPosition(self.m:x(), self.m:y()-15)
    end)
    self:scheduleUpdate()
    local sc = CCScaleTo:create(0.2, 0.8, 1.4)
    local s = CCScaleTo:create(0.2, 1.3, 0.6)
    local ss = CCScaleTo:create(0.2, 1)
    local b = CCEaseBounceOut:create(ss)
    local t = transition.sequence({sc,s,b})
    local tt = CCSpawn:createWithTwoActions(t, jump)
    local ca = CCCallFunc:create(function()
        one.action(self.m, "moveto", 0.6, ccp(display.cx/4+100,display.top/4*3+240), ease, function()
            local jump = CCJumpTo:create(0.9, ccp(display.cx/4+200, display.top/4*3+102), 90, 1)
            local rota = CCRotateTo:create(0.9, 180)
            local two = CCSpawn:createWithTwoActions(jump, rota)
            local call = CCCallFunc:create(function()
            	local sc = CCScaleTo:create(0.3, 1.4,0.7)
                	local st = CCScaleTo:create(0.3, 0.8,1.6)
                	local ss = CCScaleTo:create(0.2, 1)
                	local ea = CCEaseBackOut:create(ss)
                	local a = transition.sequence({sc,st,ea})
                	self.title_i:runAction(a)
                one.action(self.m, "moveto", 0.3, ccp(display.cx/4+260, display.top/4*3+102), ease, function()
                	
                    local jump = CCJumpBy:create(0.7, ccp(140, 0), 80, 1)
                    local rota = CCRotateTo:create(0.7, 360)
                    local two = CCSpawn:createWithTwoActions(jump, rota)
                    local call = CCCallFunc:create(function()
                        one.action(self.m, "moveby", 0.9, ccp(200, 0), ease, function( ... )
                            self.m:sp(display.right+40 ,display.top/2+15)
                            local color = ccc3(128, 195, 151)
                            self.par:setStartColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
    						self.par:setEndColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
                            self.m:setColor(ccc3(128, 195, 151))
                            one.action(self.m, "moveby", 0.3, ccp(-100, 0), ease, function( ... )
                                local jump = CCJumpBy:create(0.7, ccp(-160,0), 80, 1)
                                local rota = CCRotateTo:create(0.7, 360-180)
                                local two = CCSpawn:createWithTwoActions(jump, rota)
                                local call = CCCallFunc:create(function()
                                    one.action(self.m, "moveby", 0.9*0.8, ccp(-200*0.8, 0), ease, function( ... )
                                        local jump = CCJumpBy:create(0.7, ccp(-160,0), 80, 1)
                                        local rota = CCRotateTo:create(0.7, -1)
                                        local two = CCSpawn:createWithTwoActions(jump, rota)
                                        local call = CCCallFunc:create(function()
                                            self.m:setRotation(0)
                                            one.action(self.m, "moveby", 0.9*0.7, ccp(-200*0.7, 0), ease, function( ... )
                                                self.m:sp(-20, display.cy/2+15)
                                                local color = ccc3(158, 81, 126)
					                            self.par:setStartColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
					    						self.par:setEndColor(ccc4f(color.r/255, color.g/255, color.b/255, 1))
                                                self.m:setColor(ccc3(158, 81, 126))
                                                one.action(self.m, "moveby", 0.9*0.3, ccp(200*0.3, 0), ease, function( ... )
                                                    local jump = CCJumpBy:create(0.7, ccp(160,0), 80, 1)
                                                    local rota = CCRotateTo:create(0.7, -180)
                                                    local two = CCSpawn:createWithTwoActions(jump, rota)
                                                    local call = CCCallFunc:create(function()
                                                        one.action(self.m, "moveby", 0.9*1.3, ccp(200*1.3, 0), ease, function( ... )
                                                            local jump = CCJumpBy:create(0.7, ccp(160,0), 80, 1)
                                                            local rota = CCRotateTo:create(0.7, 0)
                                                            local two = CCSpawn:createWithTwoActions(jump, rota)
                                                            local call = CCCallFunc:create(function()
                                                            		one.action(self.m, "moveby", 0.9, ccp(200, 0), ease, function( ... )
                                                            			self.m:removeSelf()
                                                            			self.par:removeSelf()
                                                            			self:unscheduleUpdate()
                                                            		end)
                                                                end)
                                                            local ac = transition.sequence({two,call})
                                                            self.m:runAction(ac)
                                                        end)


                                                    end)
                                                    local ac = transition.sequence({two,call})
                                                    self.m:runAction(ac)
                                                end)
                                            end)

                                        end)
                                        local ac = transition.sequence({two,call})
                                        self.m:runAction(ac)
                                    end)

                                end)
                                local ac = transition.sequence({two,call})
                                self.m:runAction(ac)
                            end)
                        end)
                    end)
                    local ac = transition.sequence({two,call})
                    self.m:runAction(ac)
                end)
            end)
            local action = transition.sequence({two,call})
            self.m:runAction(action)
        end)
    end)
    local action = transition.sequence({tt,ca})
    self.m:runAction(action)
    self:poop()
end


function Gamee_6_Start:poop()
    one.action(self.start, "scaleto", 0.3, {1.2,0.8}, "sineout", function()
        one.action(self.start, "scaleto", 0.2, {0.8,1.4}, "sineout", function()
            one.action(self.start, "scaleto", 0.3, {1,1}, "backout", function()
                local de = CCDelayTime:create(1)
                local call = CCCallFunc:create(function()
                    self:poop()
                end)
                local ac = transition.sequence({de,call})
                self.start:runAction(ac)
            end)
        end)
    end)
end

return Gamee_6_Start




