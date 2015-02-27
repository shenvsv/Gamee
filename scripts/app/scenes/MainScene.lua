
local MainScene = class("MainScene", function()
    return TScene.new("MainScene")
end)

function MainScene:ctor()
    self:loading()
end

--开场动画
function MainScene:loading()
    local actionTime = 0.5
    self.loadingLayer = one.color(ccc4(41, 150, 166, 255), tar)
    self.loadingLayer:setZOrder(100)
    self.loadingLayer:x(-display.right)
    self.g = one.sp("Main_Loading_G", display.cx, display.cy, self.loadingLayer)
    self.g:y(display.cy+self.g:h()/2)
    self.gamee = one.sp("Main_Loading_Gamee", display.cx, self.g:y()-170, self.loadingLayer)
    self.text = one.sp("Main_Loading_Text", display.cx,self.gamee:y()-60, self.loadingLayer)
    self.gamee:setOpacity(0)
    self.text:setOpacity(0)
    self.gamee:y(self.text:y())
    local move = CCMoveTo:create(actionTime, ccp(display.cx, self.g:y()-170))
    local ease = CCEaseSineOut:create(move)
    local fout = CCFadeIn:create(actionTime)
    local two = CCSpawn:createWithTwoActions(ease, fout)
    local call = CCCallFunc:create(function( ... )
        local fin = CCFadeIn:create(actionTime)
        self.text:runAction(fin)
        self:performWithDelay(function()
            one.action(self, "moveto", actionTime/2, ccp(0, 0), "sineout", function()
                self.scroll:setTouchEnabled(true)
                self.loadingLayer:removeSelf()
            end)
        end, 1)
    end)
    local action = transition.sequence({two,call})
    self.gamee:runAction(action)
end

--界面布局
function MainScene:initUI()
    self:setPositionX(display.right)
    --背景
    self.bg     = display.newColorLayer(ccc4(221,221,221,255))
    self:addChild(self.bg)
    --滑动层
    self.scroll = require("app.layers.ScrollLayer").new()
    self.scroll:setZOrder(10)
    --菜单按钮
    self.menu = require("app.nodes.Menu").new()
    self.allNode = require("app.layers.AllNode").new()
    --标题背景
    self.title_bg = display.newColorLayer(ccc4(255,255,255,255))
    self.title_bg:setPositionY(display.top-128)
    self:addChild(self.title_bg)
    --标题
    self.title  = one.sp("Main_Title", display.cx, display.top, target):ap(ccp(0.5, 1))
    --包含三个layer的容器

    --历史
    -- self.history = one.btn({"Main_History",2}, display.right-130, self.title:h()/2, function( ... )
    --             --require("app.nodes.GameOver").new(1234,233,3,2632,10,false,"翻图大作战",function( ... )
    --         ser:getFriendRank(2, function( res )
    --             --print(res)
    --         end)
    --     -- end)
    -- end, nil, self.title)
    --更多
    self.more = one.btn({"Main_More",2}, display.right-46,self.title:h()/2+2, function( ... )
        self.menu:show()
    end, nil, self.title)
    --添加设置层
    self.settings = require("app.layers.SettingsLayer").new()
    self.settings:setZOrder(100)
    --二维码类
    self.qr = require("app.tools.qr")
    --支付类
    self.pay = require("app.tools.pay")
    --够买游戏
    self.game = require("app.tools.game")
end

function MainScene:onEnter()
    self:initUI()
    --更新设置
    -- local wifi_setting = user:getBoolForKey("wifi",true)
    --  local StartPlay = require("app.tools.StartPlay")
    --  StartPlay.play(2)
   --require("app.nodes.Continue").new()
end


function MainScene:onExit()
end

return MainScene