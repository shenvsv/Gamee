--
-- Author: shen
-- Date: 2014-07-17 15:40:08
--
local qr = {}

-- 显示二维码
function qr.show(text)
	local args = {}
    args = {text}
    luaj.callStaticMethod("prime/bacoo/gamee/Gamee", "showQr", args)
end

-- 扫描二维码
function qr.scan(fun)
    local args = {fun}
    luaj.callStaticMethod("prime/bacoo/gamee/Gamee", "scanQr", args)
end

-- 使用之前check 游戏的canShare参数
function qr.share(gameid)
	local qr_text = {}
	qr_text.gameid = gameid
	qr_text.id = user:getIntegerForKey("id", 0)
	if qr_text.id == 0 then
		return
	end
	qr.show(json.encode(qr_text))
end

-- 获取游戏的接口
function qr.get(fun)
	local event = {}
	qr.scan(function (result)
		event.stu = "re"
		fun(event)
		local id = user:getIntegerForKey("id", 0)

		if id == 0 then
			event.stu = "err"
			event.msg = "二维码来源或解析错误"
			fun(event)
			return
		end

		local qr_info = json.decode(result)
		if qr_info then
			if qr_info.id and qr_info.gameid then
				print(qr_info.id , qr_info.gameid)
				local req = {}
				req.action = "getshare"
				local info = {id = id, shareid = qr_info.id, gameid = qr_info.gameid}
				req.info = json.encode(info)
				http:post(SERVER_URL.."/user", req, function (res)
					if res.stu then
						print(res.body)
			    		res = json.decode(res.body)
			    		if res.status == "ok" then
			    			event = res
			    			event.stu = "ok"
			    		else
			    			event.stu = "err"
			    			event.msg = res.msg
			    		end
			    	else
			    		event.stu = "err"
			    		event.msg = "网络验证失败"
			    	end
			    	fun(event)
				end)
			else
				event.stu = "err"
				event.msg = "二维码来源或解析错误"
				fun(event)
			end
		else
			event.stu = "err"
			event.msg = "二维码来源或解析错误"
			fun(event)
		end
		
	end)
end

return qr