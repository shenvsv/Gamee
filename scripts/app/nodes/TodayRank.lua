--
-- Author: bacoo
-- Date: 2014-07-07 18:01:23
--
local TodayRank = class("TodayRank", function( ... )
    return display.newSprite("#Main_Today_Rank_Board.png")
end)

function TodayRank:ctor()
    --当前为Down
    self.downOrRise = "down"
    self:setAnchorPoint(ccp(0.5,1))
    self:setPosition(display.cx,display.top-724)
    --设置按键板
    self.select_board = one.sp("Main_Rank_Select_Board", self:getContentSize().width/3, self:getContentSize().height-43.5, self)
    --设置好友按键
    self.fri_btn = one.btn({"Main_Fri_Rank_Lebel",2}, self:getContentSize().width/3, self:getContentSize().height-41, function( ... )
        --移动按键板
        self.select_board:x(self:getContentSize().width/3)
        --现实好友排行
        self:showFriRank()
    end, nil, self)
    --设置世界按键
    self.world_btn = one.btn({"Main_World_Rank_Lebel",2}, self:getContentSize().width/3*2, self:getContentSize().height-41, function( ... )
        --移动按键板
        self.select_board:x(self:getContentSize().width/3*2)
        --显示世界排行
        self:showWorldRank()
    end, nil, self)
    --设置触摸
   -- self.newY = display.top-724
    self.basicY = display.top-724
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            self.y = event.y
            return true

        elseif event.name == "moved" then
            self.status = tar.scroll.fsm_:getState()
            local move = event.y - self.y
            self:getParent().newestGame:setPositionY(self.basicY+move)
            self:setPositionY(self.basicY+move)
        elseif event.name == "ended" then
            -- if self.status == "todayrank" then
            --     if event.y>self.y then
            --         self:riseRank()
            --     elseif event.y<self.y then
            --         self:downRank()
            --     end
            -- end
            if event.y>self.y then
                self.basicY = display.top-128
                one.action(self:getParent().newestGame, "moveto", TODAY_RANK_ACTION_TIME, ccp(display.cx, display.top-128), "backout", cal)
                one.action(self, "moveto", TODAY_RANK_ACTION_TIME, ccp(display.cx, display.top-128), "backout", cal)
            elseif event.y<self.y then
                self.basicY = display.top-724
                one.action(self:getParent().newestGame, "moveto", TODAY_RANK_ACTION_TIME, ccp(display.cx, display.top-724), "backout", cal)
                one.action(self, "moveto", TODAY_RANK_ACTION_TIME, ccp(display.cx, display.top-724), "backout", cal)
            end
            self.status = nil
        end

    end)
    --获取和设置排行榜
    --self:getBothRank(2)
    self:performWithDelay(function()
        local id = user:getIntegerForKey("id", 0)
        if id and id~=0 then
        --todo
        else
            --移动按键板
            self.select_board:x(self:getContentSize().width/3*2)
            --显示世界排行
            self:showWorldRank()
        end
    end, 1)
end

--获取双榜
function TodayRank:getBothRank(gameId)

    --用server类获取全球榜和好友榜
    ser:getRank(gameId,handler(self, self.setWorldRank))
    ser:getFriendRank(gameId,handler(self, self.setFriRank))
end

--设置好友榜
function TodayRank:setFriRank(board,rank,score)
    --将好友榜单保存
    self.friRank = {}
    local rankItem = require("app.nodes.RankItem")
    local first = fasle
    local id = user:getIntegerForKey("id")
    if id and id~=0 then
        local nick = user:getStringForKey("nick")
        for i,v in ipairs(board) do
            if v.nick == nick then
                self.friRank[0] = rankItem.new(self,1,v.nick,v.score,v.id,false,i)
                first = true
            end
        end
        for i,v in ipairs(board) do
            if i <= 13 then
                self.friRank[i] = rankItem.new(self,i,v.nick,v.score,v.id,true)

            end
        end
        if self.friRank and #self.friRank~=0 then
            --移动按键板
            self.select_board:x(self:getContentSize().width/3)
            --现实好友排行
            self:showFriRank()
        end
    else
        --移动按键板
            self.select_board:x(self:getContentSize().width/3*2)
            --显示世界排行
            self:showWorldRank()
    end

end

--升起RANK
function TodayRank:riseRank()
    if self.downOrRise == "down" then
        self.downOrRise = "rise"
        one.action(self:getParent().newestGame, "moveby", TODAY_RANK_ACTION_TIME, ccp(0, 594), "backout", cal)
        one.action(self, "moveby", TODAY_RANK_ACTION_TIME, ccp(0, 594), "backout", cal)
    end
end

--降落RANK
function TodayRank:downRank()
    if self.downOrRise == "rise" then
        self.downOrRise = "down"
        one.action(self:getParent().newestGame, "moveby", TODAY_RANK_ACTION_TIME, ccp(0, -594), "backout", cal)
        one.action(self, "moveby", TODAY_RANK_ACTION_TIME, ccp(0, -594), "backout", cal)
    end
end

--设置世界榜
function TodayRank:setWorldRank(board,rank,score)
    --将榜单保存刀self.worldRank中
    self.worldRank = {}
    local rankItem = require("app.nodes.RankItem")
    local first = fasle
    local id = user:getIntegerForKey("id")
    if id and id~=0 then
        local nick = user:getStringForKey("nick")
        if score then
            self.worldRank[0] = rankItem.new(self,1,nick,score,id,false,rank)
            first = true
            self.worldRank[0]:setVisible(false)
        end
    end
    for i,v in ipairs(board) do
        if id and id~=0 then
            if i <= 12 then
                self.worldRank[i] = rankItem.new(self,i,v.nick,v.score,v.id,true)
                self.worldRank[i]:setVisible(false)
            end
        else
            if i <= 13 then
                self.worldRank[i] = rankItem.new(self,i,v.nick,v.score,v.id,true)
                self.worldRank[i]:setVisible(false)
            end
        end
    end
end


function TodayRank:showFriRank()
    for i,v in ipairs(self.worldRank) do
        v:setVisible(false)
    end
    if self.friRank then
        for i,v in ipairs(self.friRank) do
            v:setVisible(true)
        end
    end
    if self.worldRank then
        if self.worldRank[0] then
            self.worldRank[0]:setVisible(false)
        end
    end
    if self.friRank then
        if self.friRank[0] then
            self.friRank[0]:setVisible(true)
        end
    end
end

function TodayRank:showWorldRank()
    if self.worldRank then
        for i,v in ipairs(self.worldRank) do
            v:setVisible(true)
        end
    end
    if self.friRank then
        for i,v in ipairs(self.friRank) do
            v:setVisible(false)
        end
    end
    if self.worldRank then
        if self.worldRank[0] then
            self.worldRank[0]:setVisible(true)
        end
    end
    if self.friRank then
        if self.friRank[0] then
            self.friRank[0]:setVisible(false)
        end
    end

end

function TodayRank:freshRank()
    if self.worldRank then
        for i,v in ipairs(self.worldRank) do
            v:removeSelf()
        end
    end
    if self.friRank then
        for i,v in ipairs(self.friRank) do
            v:removeSelf()
        end
    end
    self:performWithDelay(function( ... )
        local gameId = user:getIntegerForKey("newest", 0)
        self:getBothRank(gameId)
    end, 1)
end


return TodayRank