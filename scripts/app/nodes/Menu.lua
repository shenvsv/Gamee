--
-- Author: bacoo
-- Date: 2014-07-18 14:37:20
--
local Menu = class("Menu", function()
    return display.newLayer()
end)

local action_time = 0.3

function Menu:ctor()
    tar:addChild(self)
    self:setZOrder(10)
    self:setPosition(display.cx,display.cy-79)
    self:setVisible(false)
    self:setScale(0)
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            self:hide(nil,true)
        end
    end)
    local x = display.cx -108
    local y = display.cy -37
    local each_y = 73
    --我的信息
    self.mine = one.btn({"Main_Mine",2}, x, y, function()
        self:hide()
        local id = user:getIntegerForKey("id")
        if id and id~=0 then
        --进入个人页面
        else
            yixin:oauth()
        end
    end, nil, self)
    --扫一扫
    self.sao = one.btn({"Main_Sao",2}, x, y-each_y, function( ... )
        self:hide(function()
            tar.qr.get(function (event)
                    -- 扫描结束，返回cocos界面回调
                    if event.stu == "re" then
                        --
                    end
                    -- 识别完毕回调
                    if event.stu == "ok" then
                        -- 获取成功
                        tar.allNode.myInfo.loveAndGame:update()
                    end
                    if event.stu == "err" then
                        -- 获取失败
                        print("qr",event.msg)
                    end
            end)

        end)
    end, nil, self)
    --设置
    self.setting = one.btn({"Main_Setting",2}, x, y-each_y*2, function( ... )
        self:hide()
        tar.settings:show()
    end, nil, self)
    --注销
    self.logout = one.btn({"Main_Log_Out",2},x, y-each_y*3, function( ... )
        self:hide()
        require("app.nodes.Dialog").new("真的要注销么？？",function( ... )
            tar.allNode.myInfo.info:logout()
        end)
    end, nil, self):hide()
    --退出
    self.exit = one.btn({"Main_Exit",2},x, y-each_y*3, function( ... )
        self:hide()
        os.exit()
    end, nil, self)
    local id = user:getIntegerForKey("id")
    if id and id~=0 then
        ser:login(function()
            --获取头像文件，有就添加头像，没有就下载头像
            function addIcon()
                self.mine_head = display.newSprite(device.writablePath.."image/"..id..".jpg", 36, self.mine:h()/2)
                self.mine:addChild(self.mine_head)
                self.mine_head:setScale(0.055)
                self.mine_name = one.ttf(user:getStringForKey("nick"), 0, self.mine:h()/2, 31, ccc3(255, 255, 255), MAIN_FONT, align, self.mine)
                self.mine_name:x(66+self.mine_name:w()/2)
                self.logout:show()
                local y = display.cy -37
                local each_y = 73
                self.exit:y(y-each_y*4)
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
        end)
    else
        self.mine_name = one.ttf("登录",  self.mine:w()/2, self.mine:h()/2, 35, ccc3(255, 255, 255), MAIN_FONT, align, self.mine)
    end
    self.btn_tab = {self.mine,self.sao,self.setting,self.logout,self.exit}
end

function Menu:show()
    self:stopAllActions()
    self:setVisible(true)
    one.action(self, "scaleto", action_time, 1, "expout", nil)
    for i,v in ipairs(self.btn_tab) do
        one.action(v, "fadein", action_time, 120, "expout", nil)
    end
end

function Menu:hide(listener,dont)
    if not dont then
        self:stopAllActions()
    end
    one.action(self, "scaleto", action_time, 0, "expout", function( ... )
        self:setVisible(false)
        if listener then
            listener()
        end
    end)
    for i,v in ipairs(self.btn_tab) do
        one.action(v, "fadeout", action_time, 100, "expout", nil)
    end
end

return Menu




