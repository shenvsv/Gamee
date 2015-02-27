--
-- Author: Bacootang
-- Date: 2014-07-01 15:15:11
--
local Server = class("Server")
local s_url = "http://115.29.110.108"

function Server:ctor()
end

--登录服务器接口，获取名字和ID
function Server:login(lis)
  --  user:setStringForKey("yixin_accountId","a0e4af4e1ff17bb1c3061cd18d77b7a0")
    local accountId = user:getStringForKey("yixin_accountId", "")
    if accountId == "" then
        print("ERROR:hava no accountId,please login yixin")
    else
        local args = {}
        args.action = "login"
        local info = {}
        info.accountid = accountId
        local yixin_nick = user:getStringForKey("yixin_nick")
        if yixin_nick and yixin_nick~="" then
            info.nick = yixin_nick
        end
        args.info = json.encode(info)
        one.post("http://115.29.110.108/user", args, function( res )
            local info = json.decode(res)
            if info.status == "ok" then
                print(res)
                user:setStringForKey("nick", info.nick)
                user:setIntegerForKey("money", tonumber(info.money))
                user:setIntegerForKey("power", math.ceil(info.power.value))
                user:setIntegerForKey("id", tonumber(info.id))
                user:setIntegerForKey("prop",tonumber(info.props))
                user:setIntegerForKey("diamond",tonumber(info.diamond))
                if lis then
                    lis()
                end
            else
                print(res)
            end

        end)
    end
end

--修改角色名字
function Server:changeNick(newNick)
    local args = {}
    args.action = "nick"
    local info = {}
    info.id = user:getIntegerForKey("id",0)
    info.nick = newNick
    args.info = json.encode(info)
    one.post("http://115.29.110.108/user", args, function( res )
        --print(res)
        local info = json.decode(res)
        if info.status == "ok" then
            user:setStringForKey("nick", info.nick)
            --在界面修改名字
        else
            print(res)
        end
    end)
end

--获取全部信息
function Server:getAll(listener)
    local args = {}
    args.action = "getall"
    local info = {}
    info.id = user:getIntegerForKey("id")
    args.info = json.encode(info)
    one.post("http://115.29.110.108/user", args, function( res )
        local info = json.decode(res)
        if info.status == "ok" then
            --获取体力值
            user:setIntegerForKey("power", math.ceil(tonumber(info.power.value)))
            user:setIntegerForKey("money", tonumber(info.money))
            user:setIntegerForKey("diamond", tonumber(info.diamond))
            user:setIntegerForKey("prop", tonumber(info.props))
            user:setStringForKey("nick", tonumber(info.nick))
            if listener then
                listener()
            end
        else
            print(res)
        end
    end)
end

-- 设置用户信息
function Server:setter(money,diamond,props,power)
    local args = {}
    args.action = "setter"
    local info = {}
    info.id = user:getIntegerForKey("id",0)
    if money then
        info.money = money
    end
    if diamond then
        info.diamond = diamond
    end
    if props then
        info.props = props
    end
    if power then
        info.power = power
    end
    args.info = json.encode(info)
    one.post("http://115.29.110.108/user", args, function( res )
        local info = json.decode(res)
        if info.status == "ok" then
            --获取体力值
            user:setIntegerForKey("power", math.ceil(tonumber(info.power.value)))
            user:setIntegerForKey("money", tonumber(info.money))
            user:setIntegerForKey("diamond", tonumber(info.diamond))
            user:setIntegerForKey("prop", tonumber(info.props))
            user:setStringForKey("nick", info.nick)
        else
            print(res)
        end
    end)
end

function Server:upload(score, gameid)
    local args = {}
    args.action = "update"
    local info = {}
    info.id = user:getIntegerForKey("id",0)
    info.score = score
    info.gameid = gameid
    args.info = json.encode(info)
    one.post("http://115.29.110.108/game", args, function( res )
        local info = json.decode(res)
        if info.status == "ok" then
            local rank = info.rank
            --反悔前十名的帮当
            local board = json.decode(info.board)
            user:setIntegerForKey("power", math.ceil(tonumber(info.power.value)))
            print(res)
        else
            print(res)
        end
    end)
end

--获取好友榜单，传入gameId
function Server:getFriendRank(gameId,hand)
    yixin:refresh(function()
        local access_token = user:getStringForKey("yixin_access_token","")
        if access_token ~= "" then
            local url = "https://open.yixin.im/api/friendlist?access_token=" .. access_token
            one.get(url, function(res)
                local info = json.decode(res)
                local friendtable = info.friendlist
                user:setStringForKey("friendlist", json.encode(friendtable))
                local args = {}
                args.action = "friendlist"
                local info = {}
                info.id = user:getIntegerForKey("id")
                info.list = friendtable
                info.gameid = gameId
                args.info = json.encode(info)
                one.post("http://115.29.110.108/game", args, function( res )
                    local info = json.decode(res)
                    if info.status == "ok" then
                        local board = info.board
                       -- print(res)
                        hand(board,info.rank,info.score)
                    else
                        print(res)
                    end
                end)
            end)
        end
    end)
end



function Server:getAllGames(listen)
    local args = {}
    args.action = "getall"
    local info = {}
    local id = user:getIntegerForKey("id",0)
    if id and id~=0 then
        info.id = id
    end
    args.info = json.encode(info)
    one.post("http://115.29.110.108/game", args, function( res )
        local info = json.decode(res)
        if info.status == "ok" then
            local games = info.games
            user:setStringForKey("allgame", json.encode(games))
            if listen then
                listen(games)
            end
        else
            local games = user:getStringForKey("allgame")
            if games and games ~= "" then
                listen(json.decode(games))
            end
            print(res)
        end
    end)
end

--返回榜单  传入gameid
function Server:getRank(gameId,hand)
    local args = {}
    args.action = "board"
    local info = {}
    info.gameid = gameId
    local id = user:getIntegerForKey("id")
    if id and id~=0 then
        info.id = id
    end
    args.info = json.encode(info)
    one.post("http://115.29.110.108/game", args, function( res )
        local info = json.decode(res)
        --print(res)
        if info.status == "ok" then
            local board = info.board
            hand(board,info.rank,info.score)
        else
            print(res)
        end
    end)
end

--下载文件函数
function Server:downLoadFile(url,path,listener)
    one.get(url,function( res,data )
        local wr = io.writefile(path, data, "w+b")
        if wr then
            if listener then
                listener()
            end
        else
            print("error")
        end
    end )
end

function Server:havaLogin()
    if self.id == "" then
        return false
    else
        return true
    end
end

function Server:getMine(listener)
    local args = {}
    args.action = "mine"
    local info = {}
    local id = user:getIntegerForKey("id",0)
    info.id = id
    args.info = json.encode(info)
    one.post("http://115.29.110.108/user", args, function( res )
        local info = json.decode(res)
        if info.status == "ok" then
            local game = info.own
            local love = info.fav
            if listener then
                listener(game,love)
            end
        else
            print(res)
        end
    end)
end




function Server:makeDir(path)
    require("lfs")
    lfs.mkdir(path)
end

return Server
-- 收藏 id allgames