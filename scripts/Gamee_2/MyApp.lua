
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")
one = require("one")
tar = nil
scheduler = require("framework.scheduler")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)

end

function MyApp:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile("Main.plist", "Main.png")
    self:enterScene("Main")
end

return MyApp
