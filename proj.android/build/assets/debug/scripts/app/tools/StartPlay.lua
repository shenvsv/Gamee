--
-- Author: bacoo
-- Date: 2014-07-28 20:38:19
--


--游戏开始的方法
--调用 StartPlay.play(id)  id  为游戏的ID
--首先判断游戏是否存在
--不存在弹窗是否下载
--存在的话就开始加载游戏
local StartPlay = {}

function StartPlay.play(gameId)
    --首先判断是否存在games文件夹
    --不存在就创建
    --存在就看是否存在游戏ID的文件夹
    --不存在就创建然后下载游戏
    --再看存不存在game.mb文件夹
    --不存在重新下载游戏
    --存在运行游戏
    local lfs = require("lfs")
    local ifGames = lfs.chdir(device.writablePath.."games")
    if not ifGames then
        StartPlay.downloadGame(gameId)
        return
    end
    local ifGameDir = lfs.chdir(device.writablePath.."games/"..gameId)
    if not ifGameDir then
        StartPlay.downloadGame(gameId)
        return
    end
    local ifGame = io.exists(device.writablePath.."games/"..gameId.."/Gamee_"..gameId..".mb")
    if not ifGame then
        StartPlay.downloadGame(gameId)
        return
    end
    --开始游戏
    StartPlay.start(gameId)
end

function StartPlay.downloadGame(gameId)
    local wifiSwitch = user:getBoolForKey("wifi", false)
    if wifiSwitch then
    --todo
    else

        tar.downDialog = require("app.nodes.Dialog").new("游戏未下载，\n确定下载游戏么？",function()
            local ifGame = io.exists(device.writablePath.."games/"..gameId.."/Gamee_"..gameId..".mb")
            if ifGame then
                tar.downDialog:removeSelf()
                StartPlay.start(gameId)
            else
                local lfs = require("lfs")
                lfs.mkdir(device.writablePath.."games")
                lfs.mkdir(device.writablePath.."games/"..gameId)
                tar.downDialog.yes_btn:setVisible(false)
                tar.downDialog.title:setString("正在努力下载！\n0k/0k")
                function onRequestFinished(event)
                    if event.name == "inprogress" then
                        local total = math.floor(event.dltotal/1024).."k"
                        local now = math.floor(event.dlnow/1024).."k"
                        tar.downDialog.title:setString("正在努力下载！\n"..now.."/"..total)
                    elseif event.name == "completed" then
                        tar.request = nil
                        local request = event.request
                        local code = request:getResponseStatusCode()
                        if code ~= 200 then
                            tar.downDialog.title:setString("对不起，\n下载出了点问题~")
                            return
                        else
                            local data = request:getResponseData()
                            local wr = io.writefile(device.writablePath.."games/"..gameId.."/"..gameId..".zip", data, "w+b")
                            if wr then
                                tar.downDialog.title:setString("下载完成，\n正在解压~")
                                local args = {device.writablePath.."games/"..gameId.."/"..gameId..".zip", device.writablePath.."games/"..gameId.."/", function(event)
                                    if event == "ok" then
                                        tar.downDialog.yes_btn:setVisible(true)
                                        tar.downDialog.title:setString("下载完成，\n是否开始游戏？")
                                    else
                                        tar.downDialog.title:setString("对不起，\n解压失败~")
                                    end
                                end}
                                luaj.callStaticMethod("prime/bacoo/gamee/Gamee", "Unzip", args)
                            end
                        end
                    elseif event.name == "failed" then
                        tar.downDialog.title:setString("对不起，\n下载出了点问题~")
                    end
                end
                local url = "http://115.29.110.108/download/"..gameId..".zip"
                tar.request = network.createHTTPRequest(onRequestFinished, url, "GET")
                tar.request:setTimeout(100)
                tar.request:start()
            end
        end,true,function()
            if tar.request then
                if tar.request.cancel then
                    tar.request:cancel()
                end
            end
        end,true)

    end
end

function StartPlay.start(gameId)
    print(gameId)
end

return StartPlay







