--
-- Author: shen
-- Date: 2014-07-28 21:14:25
--
local game = {}

function game.fav(gameid, fun)
	local event = {}
    local req = {}
    req.action = "fav"
    local info = {}
    local id = user:getIntegerForKey("id", 0)
    info.id = id
    info.gameid = gameid
    req.info = json.encode(info)
    http:post(SERVER_URL.."/user" , req, function(res)
        if res.stu then
            res = json.decode(res.body)
            if res.status == "ok" then
                event.stu = "ok"
                event.fav = res.fav
            else
                event.stu = "err"
                event.msg = res.msg
            end
        else
            event.stu = "err"
            event.msg = "网络连接失败"
        end
        fun(event)
    end)	
end

function game.start(id)
    if id == 2 then
        local sceneClass = require("Gamee_2.scenes.Main")
        local scene = sceneClass.new(unpack(checktable(args)))
        display.replaceScene(scene)
    end

    if id == 3 then
        local sceneClass = require("Gamee_3.scenes.Gamee_3_Scene")
        local scene = sceneClass.new(unpack(checktable(args)))
        display.replaceScene(scene)
    end

    if id == 4 then
        tools = require("Gamee_4.basic.tools")
        local sceneClass = require("Gamee_4.scenes.MainScene")
        local scene = sceneClass.new(unpack(checktable(args)))
        display.replaceScene(scene)
    end

    if id == 5 then
        local sceneClass = require("Gamee_5.scenes.Main")
        local scene = sceneClass.new(unpack(checktable(args)))
        display.replaceScene(scene)
    end

    if id == 6 then
        local sceneClass = require("Gamee_6.scenes.Gamee_6_Scene")
        local scene = sceneClass.new(unpack(checktable(args)))
        display.replaceScene(scene)
    end
end

function game.over(score, id)
   ser:upload(199) 
end

return game