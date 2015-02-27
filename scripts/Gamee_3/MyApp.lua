
require("config")
require("framework.init")
--定义user
user = CCUserDefault:sharedUserDefault()
-- --自定义Scene类
TScene = require("lib.TScene")
-- --One模块
one = require("lib.one")
-- --全局变量：当前Scene
tar = nil

scheduler = require("framework.scheduler")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    audio.playMusic("Gamee_3_BGM.mp3", true)
    self:enterScene("Gamee_3_Scene")
end

return MyApp

