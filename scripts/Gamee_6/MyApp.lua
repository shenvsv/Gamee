
require("config")
require("framework.init")
--定义user
user = CCUserDefault:sharedUserDefault()
--自定义Scene类
TScene = require("lib.TScene")
--One模块
one = require("lib.one")
tar = nil
sch = require("framework.scheduler")


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    audio.playMusic("Gamee_2_BGM.mp3", true)
    -- self:enterScene("Gamee_2_Start")
end

return MyApp
