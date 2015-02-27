local AllGame = class("AllGame", function()
    return display.newLayer()
end)

function AllGame:ctor()
    local games = user:getStringForKey("allgame")
    if games and games~="" then
       self:initGameBoard(json.decode(games))
    end
    ser:getAllGames(handler(self, self.initGameBoard))
end


--初始化滑动列表
function AllGame:initGameBoard(games)
    if self.gameBoards then
        for i,v in ipairs(self.gameBoards) do
            self.list:removeAllItems()
        end
    end
    self.last = nil
    --创建GameBoard
    self.gameBoards = {}
    --创建存储图片的文件夹
    ser:makeDir(device.writablePath.."image")
    --创建列表
    self.list = require("lib.ListNode").new(self,self.right,display.top-130,"por",10,MIN_MOVE)
    --遍历全部游戏，添加到游戏面板
    for i,v in ipairs(games) do
        local own = v.own
        local fav = v.fav
        local id = v.id
        local url = v.url
        local img = v.img
        local name = v.name
        local date = v.date
        local des = v.des
        self.gameBoards[i] = require("app.nodes.GameBoard").new(i,name,date,id,img,url,own,fav,des)
        self.list:addItem(self.gameBoards[i])
    end
    self.up = one.sp("List_Up", display.cx, display.top-120, self)
    self.up:ap(ccp(0.5, 1))
    self.up:setScaleY(0)
    self.down = one.sp("List_Down", display.cx, 0, self)
    self.down:ap(ccp(0.5, 0))
    self.down:setScaleY(0)
end


function AllGame:addCallBack()
    for i,v in ipairs(self.gameBoards) do
        require("app.nodes.Tips").new(v.buy_btn)
    end
end

function AllGame:loveCallBack()
    for i,v in ipairs(self.gameBoards) do
        require("app.nodes.Tips").new(v.love_btn)
    end
end

function AllGame:closeLastInfo(index)
    if self.last~=index and self.last then
        self.gameBoards[self.last]:clickInfo()
    end
    self.last = index
end

function AllGame:closeRank(index)
    if index == self.lastRank then
        return
    end
    if self.lastRank then
        self.gameBoards[self.lastRank]:filp()
    end
    self.lastRank = index
end

function AllGame:_up()
    self.up:setScaleY(self.up:getScaleY()+0.2)
    if self.up:getScaleY() >=1 then
        self.up:setScaleY(1)
    end
end

function AllGame:_down()
    self.down:setScaleY(self.down:getScaleY()+0.2)
    if self.down:getScaleY() >=1 then
        self.down:setScaleY(1)
    end
end

function AllGame:_relese()
    one.action(self.up, "scaleto", 0.3, {1,0}, "sineout", cal)
    one.action(self.down, "scaleto", 0.3, {1,0}, "sineout", cal)
end

function AllGame:_upAuto()
    one.action(self.up, "scaleto", 0.2, {1,1}, "sineout", function()
        one.action(self.up, "scaleto", 0.2, {1,0}, "sineout", cal)
    end)
end

function AllGame:_downAuto( ... )
   one.action(self.down, "scaleto", 0.2, {1,1}, "sineout", function()
        one.action(self.down, "scaleto", 0.2, {1,0}, "sineout", cal)
    end)
end

function AllGame:refresh()
    ser:getAllGames(handler(self, self.initGameBoard))
end

return AllGame


