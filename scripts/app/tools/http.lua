--
-- Author: shen
-- Date: 2014-07-21 08:10:17
--
local http = class("http")
local s_url = "http://115.29.110.108"

function http:ctor()
--print("new_http")
end

function http:post(url, req, lis)
    local res = {}
    local callback = function(event)
        local request = event.request
        if event.name == "completed" then
            local code = request:getResponseStatusCode()
            if code ~= 200 then
                print("http"..code)
                res.stu = false
                res.msg = "server error or bad request"
                lis(res)
                return
            end
            res.stu = true
            res.body = request:getResponseString()
            print(res.body)
            lis(res)
        elseif event.name == "failed" then
            res.stu = false
            res.err_code = request:getErrorCode()
            res.err_meg = request:getErrorMessage()
            lis(res)
            print(request:getErrorCode(), request:getErrorMessage())
            return
        end
    end
    local request = network.createHTTPRequest(callback, url, "POST")
    for k,v in pairs(req) do
        request:addPOSTValue(k, v)
    end
    request:start()
end

-- function http:login(lis)
--  local accountId = user:getStringForKey("yixin_accountId", "")
--  accountId = "test"
--     if accountId == "" then
--         print("ERROR:hava no accountId,please login yixin")
--     else
--         local args = {}
--         args.action = "login"
--         local info = {}
--         info.accountid = accountId
--         args.info = json.encode(info)
--         self:post(s_url.."/user", args, function(res)
--             if res.stu then
--                 local info = json.decode(res.body)
--                 if info.status == "ok" then
--                     -- user:setStringForKey("nick", info.nick)
--                     -- user:setIntegerForKey("money", info.money)
--                     -- user:setIntegerForKey("power", math.ceil(info.power.value))
--                     -- user:setIntegerForKey("id", info.id)
--                     -- user:setIntegerForKey("prop",info.props)
--                     -- user:setIntegerForKey("diamond",info.diamond)
--                     if lis then
--                         lis()
--                     end
--                 else
--                     print(res)
--                 end
--             end

--         end)
--     end
-- end

return http


