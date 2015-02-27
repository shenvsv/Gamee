--
-- Author: shen
-- Date: 2014-07-21 08:12:38
--
local TestScene = class("TestScene", function ()
	return TScene.new("TestScene")
end)

local http = require("app.tools.http")

function TestScene:ctor()
	-- body
end

function TestScene:onEnter()
	self.pay = require("app.tools.pay")
-- demos
	-- 金钱接口 金币目前必须为 100 倍数（1 diamond 100 money）
    user:setIntegerForKey("id", 1)
    -- self.pay.money(100, function (event)
    --     if event.stu == "ok" then
    --         print(event.diamond, event.props, event.money)
    --     else
    --         print(event.msg)
    --     end
    -- end)
	
	-- 道具接口 （ 1 道具 10 金币）
	-- self.pay.props(3, function (event)
	-- 	if event.stu == "ok" then
 --            print(event.diamond, event.props, event.money)
 --        else
 --            print(event.msg)
 --        end
	-- end)

	-- 购买游戏接口
	-- gameid = 4
	-- self.pay.game(4, function (event)
 --        if event.stu == "ok" then
 --            print(event.own)
 --        else
 --            print(event.msg)
 --        end
 --    end)


	self.game = require("app.tools.game")

	-- 游戏收藏接口
	-- gameid = 5
	-- self.game.fav (5, function (event)
	--     if event.stu == "ok" then
 --            print(event.fav)
 --        else
 --            print(event.msg) 
 --        end	
	-- end)
	
	-- self.game.start(6)
	ser:upload(22,3)

end

return TestScene