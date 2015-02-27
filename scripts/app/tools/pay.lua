--
-- Author: shen
-- Date: 2014-07-23 16:05:52
--
local pay = {}

function pay.diamond(n, fun)
    -- 唉。。id先这么放着好了。。
    local id = user:getIntegerForKey("id", 0)
    id = ""..id
    local args = {id, n, fun}
    luaj.callStaticMethod("prime/bacoo/gamee/Gamee", "pay", args)
end

function pay.money(money, fun)
    local event = {}
    local req = {}
    req.action = "money"
    local info = {}
    -- 唉。。id先这么放着好了。。
    local id = user:getIntegerForKey("id", 0)
    info.id = id
    if not money then
        money = 0
    end
    info.money = money
    req.info = json.encode(info)
    http:post(SERVER_URL.."/user" , req, function(res)
        if res.stu then
            res = json.decode(res.body)
            if res.status == "ok" then
                event.stu = "ok"
                event.props = res.props
                event.money = res.money
                event.diamond = res.diamond
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

function pay.power(fun)
    local event = {}
    local req = {}
    req.action = "power"
    local info = {}
    -- 唉。。id先这么放着好了。。
    local id = user:getIntegerForKey("id", 0)
    info.id = id
    req.info = json.encode(info)
    http:post(SERVER_URL.."/user" , req, function(res)
        if res.stu then
            res = json.decode(res.body)
            if res.status == "ok" then
                event.stu = "ok"
                event.power = res.power
                event.money = res.money
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

function pay.props(props, fun)
    local event = {}
    local req = {}
    req.action = "props"
    local info = {}
    -- 唉。。id先这么放着好了。。
    local id = user:getIntegerForKey("id", 0)
    info.id = id
    if not props then
        props = 0
    end
    info.props = props
    req.info = json.encode(info)
    http:post(SERVER_URL.."/user" , req, function(res)
        if res.stu then
            res = json.decode(res.body)
            if res.status == "ok" then
                event.stu = "ok"
                event.props = res.props
                event.money = res.money
                event.diamond = res.diamond
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

function pay.game(gameid, fun)
    local event = {}
    local req = {}
    req.action = "own"
    local info = {}
    -- 唉。。id先这么放着好了。。
    local id = user:getIntegerForKey("id", 0)
    info.id = id
    info.gameid = gameid
    req.info = json.encode(info)
    http:post(SERVER_URL.."/user" , req, function(res)
        if res.stu then
            res = json.decode(res.body)
            if res.status == "ok" then
                event.stu = "ok"
                event.own = res.own
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

return pay
