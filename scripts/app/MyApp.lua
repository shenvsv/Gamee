
require("config")
require("framework.init")
--定义user
user = CCUserDefault:sharedUserDefault()
-- --自定义Scene类
TScene = require("lib.TScene")
-- --One模块
one = require("lib.one")
-- --易信回掉
yixin_callback = nil
-- --全局易信变量
yixin = require("app.tools.Yixin").new()
-- --Server全局
ser = require("app.tools.Server").new()
-- --全局变量：当前Scene
tar = nil

-- -- http
http = require("app.tools.http").new()
-- -- -- 全局用户信息
-- userInfo = require("app.tools.userInfo").new()



scheduler = require("framework.scheduler")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    if device.platform == "mac" then
        MAIN_FONT = "华康圆体W7(P)"
        NAME_FONT = "华康圆体W7(P)"
        DIALOG_TITLE_FONT = "华康圆体W7(P)"
        GAME_OVER_SCORE_FONT = "Slicker"
    end
    CCFileUtils:sharedFileUtils():addSearchPath("res/")

    CCFileUtils:sharedFileUtils():addSearchPath("res/Gamee_2_res/")
    display.addSpriteFramesWithFile("Gamee_2_Main.plist", "Gamee_2_Main.png")

    CCFileUtils:sharedFileUtils():addSearchPath("res/Gamee_3_res/")
    display.addSpriteFramesWithFile("Gamee_3.plist", "Gamee_3.png")
    display.addSpriteFramesWithFile("Gamee_3_Apple.plist", "Gamee_3_Apple.png")
    display.addSpriteFramesWithFile("Gamee_3_Li.plist", "Gamee_3_Li.png")

    CCFileUtils:sharedFileUtils():addSearchPath("res/Gamee_4_res/")

    CCFileUtils:sharedFileUtils():addSearchPath("res/Gamee_5_res/")
    display.addSpriteFramesWithFile("Gamee_5_Main.plist", "Gamee_5_Main.png")

    CCFileUtils:sharedFileUtils():addSearchPath("res/Gamee_6_res/")
    -- display.addSpriteFramesWithFile("Gamee_6_Boom.plist", "Gamee_6_Boom.png")
    -- display.addSpriteFramesWithFile("Gamee_6_Run.plist", "Gamee_6_Run.png")
    -- display.addSpriteFramesWithFile("Gamee_6_Star.plist", "Gamee_6_Star.png")
    -- display.addSpriteFramesWithFile("Gamee_6.plist", "Gamee_6.png")

    display.addSpriteFramesWithFile("Gamee_Pic_1.plist", "Gamee_Pic_1.png")
    display.addSpriteFramesWithFile("Gamee_Pic_2.plist", "Gamee_Pic_2.png")
    self:enterScene("TestScene")
end

return MyApp

