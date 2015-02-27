local AllNode = class("AllNode", function()
    return display.newNode()
   -- return one.coll(0, 0, display.right, display.top-132, "")
end)

function AllNode:ctor()
    tar:addChild(self)
    --今日游戏
    self.today = require("app.layers.TodayLayer").new()
    self:addChild(self.today)

    --全部游戏
    self.allgame = require("app.layers.AllGame").new()
    self:addChild(self.allgame)
    self.allgame:setPositionX(-display.right)
    --我的信息
    self.myInfo = require("app.layers.MyInfo").new()
    self:addChild(self.myInfo)
    self.myInfo:setPositionX(display.right)
end

return AllNode

