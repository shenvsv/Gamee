local Yixin = class("Yixin")


function Yixin:ctor()
    self.code = nil
    self.access_token = nil
    self.refresh_token = nil
end


function yixin_callback(code)
    yixin.code = code
    yixin:getToken()
end

--弹出网页认证
function Yixin:oauth()
    if device.platform == "android" then
        luaj.callStaticMethod("prime/bacoo/gamee/Gamee", "login", {}, "()V")
    end
end

--用code换取accesstoken
function Yixin:getToken()
    local args = {}
    args.client_id = YIXIN_APPID
    args.client_secret = YIXIN_APPS
    args.grant_type = "authorization_code"
    args.code = self.code
    one.post(YIXIN_TOKEN_URL, args, function(res)
        local res_tab = json.decode(res)
        --获取access_token存入user
        local access_token = res_tab.access_token
        self.access_token = access_token
        user:setStringForKey("yixin_access_token", access_token)
        --获取re_token存入user
        local refresh_token = res_tab.refresh_token
        self.refresh_token = refresh_token
        user:setStringForKey("yixin_refresh_token", refresh_token)
        self:getInfo()
    end)
end

--分享图片到易信朋友圈
function Yixin:shareImg()
-- body
end

--分享文字到易信朋友圈
function Yixin:shareText()
-- body
end

--获取好友列表
function Yixin:getFri(listener)
    local access_token = user:getStringForKey("yixin_access_token","")
    if access_token ~= "" then
        local url = "https://open.yixin.im/api/friendlist?access_token=" .. access_token
        one.get(url, function(res)
            local info = json.decode(res)
            local friendtable = info.friendlist
            local friendlist = json.encode(friendtable)
        end)
    end
end


--获取用户信息
function Yixin:getInfo(listener)
    self:refresh(function()
        one.get("https://open.yixin.im/api/userinfo?access_token="..self.access_token,function(res)
            print(res)
            --将信息存入user
            local info_tab = json.decode(res).userinfo
            local accountId = info_tab.accountId
            user:setStringForKey("yixin_accountId", accountId)
            local nick = info_tab.nick
            user:setStringForKey("yixin_nick", nick)
            local icon = info_tab.icon
            user:setStringForKey("yixin_icon", icon)
            if listener then
                listener()
            else
                tar.allNode.myInfo.info:loginCallBack()
            end
        end)
    end)
end

--判断用户是否授权
function Yixin:haveLogin()
    local access_token = user:getStringForKey("yixin_access_token", "")
    if access_token == "" then
        return false
    else
        self.access_token = access_token
        return true
    end
end

function Yixin:refresh( listen )
    local args = {}
    args.client_id = YIXIN_APPID
    args.client_secret = YIXIN_APPS
    args.grant_type = "refresh_token"
    args.refresh_token = user:getStringForKey("yixin_refresh_token","")
    if args.refresh_token and args.refresh_token~="" then
        one.post("https://open.yixin.im/oauth/token", args, function(res)
        local res_tab = json.decode(res)
        --获取access_token存入user
        local access_token = res_tab.access_token
        self.access_token = access_token
        user:setStringForKey("yixin_access_token", access_token)
        --获取re_token存入user
        local refresh_token = res_tab.refresh_token
        self.refresh_token = refresh_token
        user:setStringForKey("yixin_refresh_token", refresh_token)
        listen()
    end)
    else
        listen()
    end
end

return Yixin

