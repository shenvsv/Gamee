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

function StartPlay.play(gameId,date,info)
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
        StartPlay.downloadGame(gameId,date,info)
        return
    end
    local ifGameDir = lfs.chdir(device.writablePath.."games/"..gameId)
    if not ifGameDir then
        StartPlay.downloadGame(gameId,date,info)
        return
    end
    local ifGame = io.exists(device.writablePath.."games/"..gameId.."/Gamee_"..gameId..".mb")
    if not ifGame then
        StartPlay.downloadGame(gameId,date,info)
        return
    end
    --开始游戏
    StartPlay.start(gameId,date)
end

function StartPlay.downloadGame(gameId,date,info)
    local wifiSwitch = user:getBoolForKey("wifi", false)
    if wifiSwitch then
    --
    else
        tar.downDialog = require("app.nodes.Dialog").new("现 在 下 载 更 新 包 ？",function()
            local ifGame = io.exists(device.writablePath.."games/"..gameId.."/Gamee_"..gameId..".mb")
            if ifGame then
                tar.downDialog:removeSelf()
                StartPlay.start(gameId,date)
            else
                local lfs = require("lfs")
                lfs.mkdir(device.writablePath.."games")
                lfs.mkdir(device.writablePath.."games/"..gameId)
                tar.downDialog.yes_btn:setVisible(false)
                tar.downDialog.title:setString("正在努力下载！\n0k/0k")
                tar.downDialog.title:runAction(CCFadeOut:create(0.3))
                local move = CCMoveTo:create(0.5, ccp(tar.downDialog.no_btn:x(),tar.downDialog.board:h()/7 ))
                local scale = CCScaleTo:create(0.5, 0.75)
                local ac = CCSpawn:createWithTwoActions(move, scale)
                tar.downDialog.no_btn:runAction(ac)
                tar.downDialog.out = one.sp("Main_Down_Pro_Out",tar.downDialog.board:w()/2,tar.downDialog.board:h()/2-5, tar.downDialog.board)
                tar.downDialog.inn = CCProgressTimer:create(display.newSprite("#Main_Down_Pro_In.png"))
                tar.downDialog.inn:setType(kCCProgressTimerTypeBar)
                tar.downDialog.inn:setMidpoint(CCPointMake(0, 0))
                tar.downDialog.inn:setBarChangeRate(CCPointMake(1, 0))
                tar.downDialog.inn:setPercentage(0)
                tar.downDialog.run = true
                tar.downDialog.inn:setPosition(tar.downDialog.board:w()/2,tar.downDialog.board:h()/2-5)
                tar.downDialog.board:addChild(tar.downDialog.inn)
                tar.downDialog.coll = one.coll(0, 0, tar.downDialog.board:w(), display.top, tar.downDialog.board)
                tar.downDialog.g = one.sp("Main_Download_G01",tar.downDialog.out:x()-tar.downDialog.out:w()/2,tar.downDialog.out:y()+45, tar.downDialog.coll)
                tar.downDialog.g:x(tar.downDialog.out:x()-tar.downDialog.out:w()/2)
                tar.downDialog.g:setScaleX(-1)
                local frames = display.newFrames("Main_Download_G%02d.png", 1, 24)
                local animation = display.newAnimation(frames, 0.5/24)
                tar.downDialog.g:playAnimationForever(animation)
                tar.downDialog.downText = one.ttf("0 / 0 kb", tar.downDialog.board:w()/2, tar.downDialog.out:y()-45, 40, BUY_WINDOW_HEVEY_COLOR, MAIN_FONT, align, tar.downDialog.board)
                tar.downDialog.speed = {}
                tar.downDialog.last = 0
                tar.downDialog.speedcount = 0
                function onRequestFinished(event)
                    if event.name == "inprogress" then
                        local total = math.floor(event.dltotal/1024)
                        tar.downDialog.total = total
                        local now = math.floor(event.dlnow/1024)
                        tar.downDialog.downText:setString(now.." / "..total.." kb")
                        if total~=0 then
                            tar.downDialog.inn:setPercentage(math.floor(event.dlnow/1024)/math.floor(event.dltotal/1024)*100)
                            if math.floor(event.dlnow/1024)/math.floor(event.dltotal/1024)>tar.downDialog.last then
                                table.insert(tar.downDialog.speed,(math.floor(event.dlnow/1024)/math.floor(event.dltotal/1024)-tar.downDialog.last)*162)
                                tar.downDialog.last = math.floor(event.dlnow/1024)/math.floor(event.dltotal/1024)
                                if #tar.downDialog.speed>=4 then
                                    tar.downDialog.speedcount = tar.downDialog.speed[#tar.downDialog.speed]+tar.downDialog.speed[#tar.downDialog.speed-1]+tar.downDialog.speed[#tar.downDialog.speed-2]+tar.downDialog.speed[#tar.downDialog.speed-3]
                                    tar.downDialog.speedcount = tar.downDialog.speedcount/4
                                end
                                if tar.downDialog.g:x()> tar.downDialog.out:x()-tar.downDialog.out:w()/2+math.floor(event.dlnow/1024)/math.floor(event.dltotal/1024)*tar.downDialog.out:w()-tar.downDialog.g:w()/2 then
                                    tar.downDialog.speedcount = 0
                                end
                            end
                            tar.downDialog.g:x(tar.downDialog.g:x()+tar.downDialog.speedcount )
                        end
                        tar.downDialog.title:setString("正在下载")
                    elseif event.name == "completed" then
                        tar.downDialog.downText:setString(tar.downDialog.total.." / "..tar.downDialog.total.." kb")
                        tar.downDialog.inn:setPercentage(100)
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
                                tar.downDialog.downText:setString("下载完成，正在解压~")
                                one.action(tar.downDialog.g, "moveto", 1, ccp(display.right+40, tar.downDialog.g:y()), ease, function( ... )
                                    tar.downDialog.g:removeSelf()
                                end)
                                local args = {device.writablePath.."games/"..gameId.."/"..gameId..".zip", device.writablePath.."games/"..gameId.."/", function(event)
                                    if event == "ok" then
                                        tar.downDialog.yes_btn:setVisible(true)
                                        tar.downDialog.yes_btn:setOpacity(0)
                                        tar.downDialog.yes_btn:runAction(CCFadeIn:create(0.3))
                                        local sc = CCScaleTo:create(0.3, 1)
                                        local mo = CCMoveTo:create(0.3, ccp(tar.downDialog.board:w()/4*3, tar.downDialog.board:h()/4))
                                        local ac = CCSpawn:createWithTwoActions(sc, mo)
                                        tar.downDialog.no_btn:runAction(ac)
                                        tar.downDialog.title:show()
                                        tar.downDialog.title:runAction(CCFadeIn:create(0.3))
                                        tar.downDialog.out:runAction(CCFadeOut:create(0.3))
                                        tar.downDialog.inn:runAction(CCFadeOut:create(0.3))
                                        tar.downDialog.title:setString("下载完成，\n是否开始游戏？")
                                        tar.downDialog.title:y(tar.downDialog.board:h()/5*3+20)
                                        tar.downDialog.downText:hide()
                                        --tar.downDialog.ing:hide()
                                        one.action(tar.downDialog.g, "moveto", 1, ccp(display.right+40, tar.downDialog.g:y()), ease, function( ... )
                                            tar.downDialog.g:removeSelf()
                                        end)

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
        tar.downDialog.date = one.ttf(date, 90, 400, 38, ccc3(247, 94, 46), MAIN_FONT, align,  tar.downDialog.board)
        tar.downDialog.ing = one.ttf(info, tar.downDialog.board:w()/2+60, 400, 35, BUY_WINDOW_HEVEY_COLOR, MAIN_FONT, align, tar.downDialog.board)
        tar.downDialog.yes_btn:y(70)
        tar.downDialog.no_btn:y(70)
        tar.downDialog.title:setFontSize(40)
        tar.downDialog.title:y(tar.downDialog.board:getContentSize().height/2+20)
    end
end

function StartPlay.start(gameId,date)
    print(gameId,date)
end

return StartPlay








