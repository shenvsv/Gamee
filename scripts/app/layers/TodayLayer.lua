local TodayLayer = class("TodayLayer", function()
    return display.newLayer()
end)

function TodayLayer:ctor()
    --今日游戏的版
    self.newestGame = require("app.nodes.NewestGame").new()
    self:addChild(self.newestGame)
    --今日排行榜
    self.todayRank = require("app.nodes.TodayRank").new()
    self:addChild(self.todayRank)
end


return TodayLayer

