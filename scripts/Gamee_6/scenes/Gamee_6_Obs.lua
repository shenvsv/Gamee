--
-- Author: bacoo
-- Date: 2014-07-20 20:50:15
--
local Gamee_6_Obs = class("Gamee_6_Obs", function()
	return one.spp9("Gamee_6_Cube", x, y, CCSize(30, 10), "")
end)

function Gamee_6_Obs:ctor(father,size,x,color,action,y)
	father:addChild(self)
	self:setContentSize(size)
	self:x(x)
	if y then
		self:y(y)
	else
		self:y(self:h()/2)
	end
	self:setColor(color)
	self.alive = true
	if action then
		if action[1] == "jump" then
			local jump = CCJumpBy:create(action[3], ccp(0, 0), action[2], 1)
			local re = CCRepeatForever:create(jump)
			self:runAction(re)
		elseif action[1] == "scale" then
			local scale_1 = CCScaleTo:create(action[2], action[3], action[4])
			local scale_2 = CCScaleTo:create(action[2], 1, 1)
			local sq = transition.sequence({scale_1,scale_2})
			local re = CCRepeatForever:create(sq)
			self:runAction(re)
		elseif action[1] == "moveby" then
			local move_1 = CCMoveBy:create(action[2], ccp(action[3], action[4]))
			local move_2 = CCMoveBy:create(action[2], ccp(-action[3], action[4]))
			local sq = transition.sequence({move_1,move_2})
			local re = CCRepeatForever:create(sq)
			self:runAction(re)
		end
	end
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        if self.alive then
        	if tar.me then
        		if tar.me.peng then
        			if self:getCascadeBoundingBox():intersectsRect(tar.me.peng:getCascadeBoundingBox()) then
        				if tar.life == 0 then
        					return
        				end
        				tar.life = tar.life - 1
        				audio.playSound("Gamee_6_Boom.wav")
        				if tar.life == 0 then
        					self.alive = false
		        			tar.me:die()
		        			self:unscheduleUpdate()
        				else
        					tar.me:back()
        				end
		        	end
        		end
        	end
        end
    end)
    self:scheduleUpdate()
end

return Gamee_6_Obs