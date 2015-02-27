--
-- Author: shen
-- Date: 2014-07-08 12:47:51
--
local SettingsLayer = class("SettingsLayer", function ()
    return display.newLayer()
end)
local switch = require("app.sprites.UISwitch")
-- inits
local top = display.top - 143
local s_top = top - 157
local s_cen = 474
-- settings
local isWifi = true
local isSound = true
local isMusic = true

function SettingsLayer:ctor()
    tar:addChild(self)
    self:setPositionY(self:getPositionY()+12)
    self:setVisible(false)
    one.sp("Main_Grey_Layer", display.cx, display.cy, self)
    self.cli = display.newClippingRegionNode(CCRect(0, display.bottom, 626, top))
    self:addChild(self.cli)

    self.main = one.sp("Main_Setting_Main", display.cx, top - 415, self.cli)

    self.dis = one.btn({"Main_Setting_Dismiss",2}, display.cx + 240, self.main:getContentSize().height-57, function ()
        self.dis:setTouchEnabled(false)

        self:dismiss()

        self.dis:setTouchEnabled(true)
    end, nil, self.main)
    self.main:setPositionY(top + 420)
    self:read()

end

function SettingsLayer:read()
    isWifi = user:getBoolForKey("wifi", true)
    isSound = user:getBoolForKey("sound", true)
    isMusic = user:getBoolForKey("music", true)

    local wifi_bar =  display.newSprite("#Main_Setting_Bar.png")
    self.main:addChild(wifi_bar, -1)
    local wifi = switch.new(s_cen,self.main:getContentSize().height - 189, wifi_bar, function (status)
        isWifi = status
        user:setBoolForKey("wifi", isWifi)
    end, isWifi)
    self.main:addChild(wifi)

    local sound_bar =  display.newSprite("#Main_Setting_Bar.png")
    self.main:addChild(sound_bar, -1)
    local sound = switch.new(s_cen,self.main:getContentSize().height - 358, sound_bar, function (status)
        isSound = status
        user:setBoolForKey("sound", isSound)
    end, isSound)
    self.main:addChild(sound)

    local music_bar =  display.newSprite("#Main_Setting_Bar.png")
    self.main:addChild(music_bar, -1)
    local music = switch.new(s_cen,self.main:getContentSize().height - 529, music_bar, function (status)
        isMusic = status
        user:setBoolForKey("music", isMusic)
    end, isMusic)
    self.main:addChild(music)
end

function SettingsLayer:dismiss()
    one.action(self.main, "moveto", 0.3, ccp(display.cx, top + 420), "expout", function ()
        self:setTouchSwallowEnabled(false)
        self:setTouchEnabled(false)
        self:setVisible(false)
    end)
end

function SettingsLayer:show()
    self:setVisible(true)
    self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(true)
    -- print(11)
    one.action(self.main, "moveto", 0.3, ccp(display.cx, top - 415), "backout", function ()

        end)

end

return SettingsLayer

