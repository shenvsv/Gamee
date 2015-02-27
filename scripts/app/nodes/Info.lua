--
-- Author: bacoo
-- Date: 2014-07-10 11:57:43
--
local Info = class("Info", function( ... )
    return display.newLayer()
end)

function Info:ctor()
    --底板
    self.back_board = one.sp("Main_My_Info_Board", display.cx, display.top-326, self)
    --放置板
    self.info_board = one.sp("Main_Info_Board", display.cx+70, display.top-340, self)
    --设置名字
    local name = user:getStringForKey("nick","")
    self.info_name_label = one.ttf(name, self.info_board:x(), self.info_board:y()+154, INFO_NAME_SIZE, INFO_NAME_COLOR, NAME_FONT,align, self)
    --钻石按钮
    self.info_diamond = one.btn("Main_Info_Diamond", 90, self.info_board:h()/5*4, function( ... )
        self:addDiamond()
    end, nil, self.info_board)
    --金币按钮
    self.info_coin = one.btn("Main_Info_Coin", 90, self.info_board:h()/2, function( ... )
        self:addCoin()
    end, nil, self.info_board)
    --道具按钮
    self.info_prop = one.btn("Main_Info_Prop", 90, self.info_board:h()/5, function( ... )
        self:addProp()
    end, nil, self.info_board)
    --金钱数
    local coin = user:getIntegerForKey("money", "0")
    self.info_coin_label = one.ttf(coin, 100, self.info_board:h()/2+4, INFO_LABEL_SIZE, INFO_LABEL_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    self.info_coin_label:x(80+self.info_coin_label:w()/2)
    --钻石数
    local diamond = user:getIntegerForKey("diamond", "0")
    self.info_diamond_label = one.ttf(diamond, 100, self.info_board:h()/5*4+4, INFO_LABEL_SIZE, INFO_LABEL_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    self.info_diamond_label:x(80+self.info_diamond_label:w()/2)
    --道具数
    local prop = user:getIntegerForKey("prop", "0")
    self.info_prop_label = one.ttf(prop, 100, self.info_board:h()/5+4, INFO_LABEL_SIZE, INFO_LABEL_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    self.info_prop_label:x(80+self.info_prop_label:w()/2)
    --体力值外框
    self.info_out_circle = one.sp("Main_Info_Out_Circle", self.info_board:w()/2+70, self.info_board:h()/2, self.info_board)
    self.info_out_circle:addClick(function( ... )
        self:addPower()
    end)
    --体力值
    self.info_power = CCProgressTimer:create(display.newSprite("#Main_Info_Power.png"))
    self.info_power:setType(kCCProgressTimerTypeRadial)
    self.info_power:setReverseProgress(true)
    self.info_power:setPosition(self.info_board:w()/2+70, self.info_board:h()/2)
    self.info_power:setPercentage(100)
    self.info_board:addChild(self.info_power)
    --体力值Label
    self.info_power_label = one.ttf("100",self.info_board:w()/2+70, self.info_board:h()/2+2, INFO_POWER_SIZE, INFO_POWER_COLOR,MAIN_FONT, ui.TEXT_ALIGN_CENTER, self.info_board)
    --获取id，如果有就获得以ID+HeadIcon的头像，要是没有就创建登录按钮
    local id = user:getIntegerForKey("id")
    if id and id~=0 then
        if io.exists(device.writablePath.."image/"..id..".jpg") then
            self.info_head = display.newSprite(device.writablePath.."image/"..id..".jpg", display.cx/3-6, display.top-340)
            self:addChild(self.info_head)
            self.info_head:setScale(0.171)
            self.info_head_out = one.sp("Main_My_Info_Out",self.info_head:getPositionX(), self.info_head:getPositionY(), self)
            tar.menu.mine_head = display.newSprite(device.writablePath.."image/"..id..".jpg",36, tar.menu.mine:h()/2)
            tar.menu.mine:addChild(tar.menu.mine_head)
            tar.menu.mine_head:setScale(0.055)
        end
        ser:login(function()
            --获取头像文件，有就添加头像，没有就下载头像
            function addIcon()
                if self.info_head then
                    self.info_head:removeSelf()
                    self.info_head_out:removeSelf()
                    tar.menu.mine_head:removeSelf()
                end
                self.info_head = display.newSprite(device.writablePath.."image/"..id..".jpg", display.cx/3-6, display.top-340)
                self:addChild(self.info_head)
                self.info_head:setScale(0.18)
                self.info_head_out = one.sp("Main_My_Info_Out",self.info_head:getPositionX(), self.info_head:getPositionY(), self)
                tar.menu.mine_head = display.newSprite(device.writablePath.."image/"..id..".jpg",36, tar.menu.mine:h()/2)
                tar.menu.mine:addChild(tar.menu.mine_head)
                tar.menu.mine_head:setScale(0.055)
            end
            if io.exists(device.writablePath.."image/"..id..".jpg") then
                addIcon()
            else
                ser:makeDir(device.writablePath.."image")
                local icon_url = user:getStringForKey("yixin_icon")
                print(icon_url)
                function downIcon()
                    ser:downLoadFile(icon_url, device.writablePath.."image/"..id..".jpg", function( ... )
                        addIcon()
                    end)
                end
                if icon_url and icon_url ~= "" then
                    downIcon()
                else
                    yixin:getInfo(downIcon)
                end
            end
            --设置名字
            local name = user:getStringForKey("nick","")
            self.info_name_label:setString(name)
            --设置金钱数
            local money = user:getIntegerForKey("money")
            self.info_coin_label:setString(money)
            --设置钻石数
            local diamond = user:getIntegerForKey("diamond")
            self.info_diamond_label:setString(diamond)
            --设置道具数
            local prop = user:getIntegerForKey("prop")
            self.info_prop_label:setString(prop)
            --设置体力值
            local power = user:getIntegerForKey("power")
            self.info_power_label:setString(power)
            self.info_power:setPercentage(power)
            --获取我的游戏和我的收藏
            ser:getMine(function(game,love)
                --将我的游戏和我的收藏传入initLoveAndGame,初始化initLoveAndGame
                self:getParent():getParent().loveAndGame:initLoveAndGame(game, love)
            end)
        end)
    else
        self.loginBtn = one.btn({"Main_My_Info_Login_Btn",2},display.cx-230 , display.top-300, function( ... )
            yixin:oauth()
        end, nil, self)
    end
    self:refresh()
end

--登出操作
function Info:logout()
    --重置user
    user:setIntegerForKey("id", 0)
    user:setStringForKey("accountId", "")
    user:setStringForKey("yixin_accountId", "")
    user:setStringForKey("nick", "")
    user:setIntegerForKey("money", 0)
    user:setIntegerForKey("power", 0)
    user:setIntegerForKey("diamond", 0)
    user:setIntegerForKey("prop", 0)
    user:setStringForKey("yixin_access_token", "")
    user:setStringForKey("yixin_refresh_token", "")
    user:setStringForKey("yixin_nick", "")
    user:setStringForKey("yixin_icon", "")
    user:setStringForKey("game", "")
    user:setStringForKey("love", "")
    --移除头像外框
    if self.info_head_out then
        self.info_head_out:removeSelf()
        self.info_head_out  = nil
    end
    --移除头像
    if self.info_head then
        self.info_head:removeSelf()
        self.info_head = nil
    end
    --添加登录按键
    if self.loginBtn then
        self.loginBtn:removeSelf()
        self.loginBtn = nil
    end
    self.loginBtn = one.btn({"Main_My_Info_Login_Btn",2},display.cx-230 , display.top-300, function( ... )
        yixin:oauth()
    end, nil, self)
    --隐藏注销按钮
    tar.menu.logout:hide()
    local y = display.cy -37
    local each_y = 73
    tar.menu.exit:y(y-each_y*3)
    self.info_name_label:setString("")
    self.info_power_label:setString("100")
    self.info_coin_label:setString("0")
    self.info_prop_label:setString("0")
    self.info_diamond_label:setString("0")
    self.info_coin_label:x(80+self.info_coin_label:w()/2)
    self.info_diamond_label:x(80+self.info_diamond_label:w()/2)
    self.info_prop_label:x(80+self.info_prop_label:w()/2)
    --把体力值变满
    self.info_power:setPercentage(100)
    --移除收藏和够买的游戏
    tar.allNode.myInfo.loveAndGame:removeAllLovaAndGame()
    --移除小头像
    if tar.menu.mine_head then
        tar.menu.mine_head:removeSelf()
        tar.menu.mine_head = nil
        tar.menu.mine_name:setString("登录")
        tar.menu.mine_name:x(66+tar.menu.mine_name:w()/2)
    end
    tar.allNode.today.todayRank:freshRank()
    for i,v in ipairs(tar.allNode.allgame.gameBoards) do
        v:refreshRank()
    end
    if tar.allNode.today.todayRank.friRank then
        if tar.allNode.today.todayRank.friRank[0] then
            tar.allNode.today.todayRank.friRank[0]:removeSelf()
            tar.allNode.today.todayRank.friRank = {}
        end
    end
end

function Info:loginCallBack()
    ser:login(function()
        local id = user:getIntegerForKey("id")
        --获取头像文件，有就添加头像，没有就下载头像
        function addIcon()
            self.info_head = display.newSprite(device.writablePath.."image/"..id..".jpg", display.cx/3-6, display.top-340)
            self:addChild(self.info_head)
            self.info_head:setScale(0.171)
            self.info_head_out = one.sp("Main_My_Info_Out",self.info_head:getPositionX(), self.info_head:getPositionY(), self)
            tar.menu.mine_head = display.newSprite(device.writablePath.."image/"..id..".jpg",36, tar.menu.mine:h()/2)
            tar.menu.mine:addChild(tar.menu.mine_head)
            tar.menu.mine_head:setScale(0.055)
            if self.loginBtn then
                self.loginBtn:removeSelf()
                self.loginBtn = nil
            end
        end
        if io.exists(device.writablePath.."image/"..id..".jpg") then
            addIcon()
        else
            ser:makeDir(device.writablePath.."image")
            local icon_url = user:getStringForKey("yixin_icon")
            function downIcon()
                ser:downLoadFile(icon_url, device.writablePath.."image/"..id..".jpg", function( ... )
                    addIcon()
                end)
            end
            if icon_url and icon_url ~= "" then
                downIcon()
            else
                yixin:getInfo(downIcon)
            end
        end
        --设置名字
        local name = user:getStringForKey("nick","")
        self.info_name_label:setString(name)
        --设置金钱数
        local money = user:getIntegerForKey("money")
        self.info_coin_label:setString(money)
        --设置钻石数
        local diamond = user:getIntegerForKey("diamond")
        self.info_diamond_label:setString(diamond)
        --设置道具数
        local prop = user:getIntegerForKey("prop")
        self.info_prop_label:setString(prop)
        --设置体力值
        local power = user:getIntegerForKey("power")
        self.info_power_label:setString(power)
        self.info_power:setPercentage(power)
        self.info_coin_label:x(80+self.info_coin_label:w()/2)
        self.info_diamond_label:x(80+self.info_diamond_label:w()/2)
        self.info_prop_label:x(80+self.info_prop_label:w()/2)
        tar.menu.mine_name:setString(name)
        tar.menu.mine_name:x(66+tar.menu.mine_name:w()/2)
        -- tar.menu.mine_head = display.newSprite(device.writablePath.."image/"..id..".jpg",36, tar.menu.mine:h()/2)
        -- tar.menu.mine:addChild(tar.menu.mine_head)
        -- tar.menu.mine_head:setScale(0.055)
        --现实注销
        tar.menu.logout:show()
        local y = display.cy -37
        local each_y = 73
        tar.menu.exit:y(y-each_y*4)
        --获取我的游戏和我的收藏
        ser:getMine(function(game,love)
            --将我的游戏和我的收藏传入initLoveAndGame,初始化initLoveAndGame
            self:getParent():getParent().loveAndGame:initLoveAndGame(game, love)
        end)
        tar.allNode.today.todayRank:freshRank()
        for i,v in ipairs(tar.allNode.allgame.gameBoards) do
            v:refreshRank()
        end
        tar.allNode.allgame:refresh()
    end)
end

--兑换金币
function Info:addCoin()
    local id = user:getIntegerForKey("id",0)
    if id and id~=0 then
        require("app.nodes.BuyWindow").new("coin")
    end
end

--够买钻石
function Info:addDiamond()
    local id = user:getIntegerForKey("id",0)
    if id and id~=0 then
        require("app.nodes.BuyWindow").new("diamond")
    end
end

--够买道具
function Info:addProp()
    local id = user:getIntegerForKey("id",0)
    if id and id~=0 then
        require("app.nodes.BuyWindow").new("prop")
    end
end

--更新信息
function Info:updateInfo(event,kind)
    if event.stu == "ok" then
        self:performWithDelay(function( ... )
            local prop = event.props
            local diamond = event.diamond
            local money = event.money
            user:setIntegerForKey("prop", prop)
            user:setIntegerForKey("diamond", diamond)
            user:setIntegerForKey("money", money)
            self.info_coin_label:setString(money)
            self.info_prop_label:setString(prop)
            self.info_diamond_label:setString(diamond)
            self.info_coin_label:x(80+self.info_coin_label:w()/2)
            self.info_diamond_label:x(80+self.info_diamond_label:w()/2)
            self.info_prop_label:x(80+self.info_prop_label:w()/2)
        end, 0.2)

    else
        if event.msg == "no enough money" then
            listener = nil
            if kind == "prop" then
                listener = function()
                    require("app.nodes.BuyWindow").new("coin")
                end
            elseif kind == "coin" then
                listener = function()
                    require("app.nodes.BuyWindow").new("diamond")
                end
            end
            require("app.nodes.Dialog").new("余额不足购买失败！\n是否充值呢？",listener)
        else
            require("app.nodes.Dialog").new("购买失败！~~~")
        end
    end
end

--够买体力
function Info:addPower()
    local id = user:getIntegerForKey("id",0)
    if id and id~=0 then
        local power = user:getIntegerForKey("power", 0)
        local needCoin = (100-power)*1
        if needCoin~=0 then
            require("app.nodes.Dialog").new("花费100金币\n充满体力值么？",function()
                tar.pay.power(function( event )
                    if event.stu =="ok" then
                        ser:getAll(function()
                            --设置名字
                            local name = user:getStringForKey("nick","")
                            self.info_name_label:setString(name)
                            --设置金钱数
                            local money = user:getIntegerForKey("money")
                            self.info_coin_label:setString(money)
                            --设置钻石数
                            local diamond = user:getIntegerForKey("diamond")
                            self.info_diamond_label:setString(diamond)
                            --设置道具数
                            local prop = user:getIntegerForKey("prop")
                            self.info_prop_label:setString(prop)
                            --设置体力值
                            local power = user:getIntegerForKey("power")
                            self.info_power_label:setString(power)
                            self.info_power:setPercentage(power)
                        end)
                    else
                        print("error")
                    end
                end)
            end)
        else
            require("app.nodes.Dialog").new("体力值是满的哦!\n@_@!",function()
                end,nil,nil,nil,true)
        end
    end
end

function Info:refresh()
    self.freshTime = 3000
    self.nowTime = 0
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        local id  = user:getIntegerForKey("id")
        if id and id ~=0 then
            self.nowTime = self.nowTime +1
            if self.nowTime == 1800 then
                self.nowTime = 0
                ser:getAll(function()
                    --设置名字
                    local name = user:getStringForKey("nick","")
                    self.info_name_label:setString(name)
                    --设置金钱数
                    local money = user:getIntegerForKey("money")
                    self.info_coin_label:setString(money)
                    --设置钻石数
                    local diamond = user:getIntegerForKey("diamond")
                    self.info_diamond_label:setString(diamond)
                    --设置道具数
                    local prop = user:getIntegerForKey("prop")
                    self.info_prop_label:setString(prop)
                    --设置体力值
                    local power = user:getIntegerForKey("power")
                    self.info_power_label:setString(power)
                    self.info_power:setPercentage(power)
                end)
            end
        end
    end)
    self:scheduleUpdate()
end

return Info













