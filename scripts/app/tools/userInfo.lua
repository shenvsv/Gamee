--
-- Author: shen
-- Date: 2014-07-20 23:14:06
--

-- -- 变量(self)
-- isLogin 判断用户是否
local userInfo = class("userInfo")

function userInfo:ctor()
	self.id = user:getStringForKey("id", "")

	if self.id == "" then
		self.isOauth = false
	else
		self.isOauth = true	
	end
end

function userInfo:getAll()
	
end

function userInfo:oauth()
	
end

-- function userInfo:sch()
-- 	self.sch = scheduler.scheduleGlobal(function ( ... )
-- 		print("update")
-- 	end, 60)
-- end



return userInfo