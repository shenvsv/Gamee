--
-- Author: bacoo
-- Date: 2014-08-04 15:26:20
--
local GameOver = class("GameOver", function()
    return display.newLayer()
        --return one.sp("GameOver_Board", display.cx, display.cy, target)
end)

--[[
	score-------------本局的分数  number
	worldRank---------世界排名    number
	friendRank--------好友排名    number
	history-----------历史最高分  number
	money-------------本局金币    number
	newRe-------------是否新纪录  boolean
	gameName----------游戏名      string
	againListen-------再来一次回调 function
--]]
function GameOver:ctor(score,worldRank,friendRank,history,money,newRe,gameName,againListen)
    local addTime = 1.5
    tar:addChild(self)
    self:setZOrder(1000)
    self.run = true
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        self.run = false
        if self.scoreSch then
            scheduler.unscheduleGlobal(self.scoreSch)
        end
        self.scoreLabel:setString(score)
        self.scoreLabel:setScale(1)
        if self.coinSch then
            scheduler.unscheduleGlobal(self.coinSch)
        end
        self.coinLabel:setString(money)
        self.coinLabel:setScale(1)
        if self.hisSch then
            scheduler.unscheduleGlobal(self.hisSch)
        end
        self.historyScoreLabel:setString(history.."分")
        self.historyScoreLabel:setScale(1)
        if self.worldSch then
            scheduler.unscheduleGlobal(self.worldSch)
        end
        self.worldScoreLabel:setString(worldRank.."名")
        self.worldScoreLabel:setScale(1)
        one.action(self.replayBtn, "scaleto", 0.4, 1, "backout", cal)
        one.action(self.homeBtn, "scaleto", 0.4, 1, "backout", cal)
        self:setTouchEnabled(false)
    end)
    self.score = score
    --创建灰度
    self.grey = one.sp("Main_Grey_Layer", display.cx, display.cy, self)
    self.grey:setZOrder(-10)
    self.board = one.sp("GameOver_Board", display.cx, display.cy+30, self)
    self.board:setScale(0)
    one.action(self.board, "scaleto", 0.4, 1, "bout", function()
        local scoreAddEach = score/(addTime*60)
        local scoreNow = 0
        local coinNow = 0
        self:setTouchEnabled(true)
        self.scoreSch = scheduler.scheduleUpdateGlobal(function()
            scoreNow = scoreNow+scoreAddEach
            self.scoreLabel:setString(math.floor(scoreNow))
            if scoreNow>= score-4 or scoreNow>=score then
                scoreNow = score
                self.scoreLabel:setString(math.floor(scoreNow))
                scheduler.unscheduleGlobal(self.scoreSch)
                self:performWithDelay(function( ... )
                    self.scoreLabel:setScale(0)
                    one.action(self.scoreLabel, "scaleto", 0.3, 1, "bout", function()
                        end)
                end, 0.2)
            end
        end)
        self.coinSch = scheduler.scheduleUpdateGlobal(function()
            coinNow = coinNow+0.5
            self.coinLabel:setString(math.floor(coinNow))
            if coinNow == money then
                scheduler.unscheduleGlobal(self.coinSch)
            end
        end)
        self:performWithDelay(function()
            one.action(self.historyScoreLabel, "scaleto", 0.3, 1, "bout", function()
                if self.run then
                    local nowScore = 0
                    local speed = history/((addTime+0.5)*60)
                    self.hisSch = scheduler.scheduleUpdateGlobal(function()
                        nowScore = nowScore + speed
                        self.historyScoreLabel:setString(math.floor(nowScore).."分")
                        if nowScore>=history then
                            nowScore=history
                            self.historyScoreLabel:setString(history.."分")
                            scheduler.unscheduleGlobal(self.hisSch)
                            one.action(self.replayBtn, "scaleto", 0.4, 1, "backout", cal)
                            one.action(self.homeBtn, "scaleto", 0.4, 1, "backout", cal)
                        end
                    end)
                else
                    self.historyScoreLabel:setString(history.."分")
                end

            end)
            one.action(self.worldScoreLabel, "scaleto", 0.3, 1, "bout", function()
                if self.run then
                    local nowScore = 0
                    local speed = worldRank/((addTime)*60)
                    self.worldSch = scheduler.scheduleUpdateGlobal(function()
                        nowScore = nowScore + speed
                        self.worldScoreLabel:setString(math.floor(nowScore).."名")
                        if nowScore>=worldRank then
                            nowScore=worldRank
                            self.worldScoreLabel:setString(worldRank.."名")
                            scheduler.unscheduleGlobal(self.worldSch)
                        end
                    end)
                else
                    self.worldScoreLabel:setString(worldRank.."名")
                end
            end)
        end, 0.5)
    end)
    --炫耀按钮
    self.shareBtn = one.btn({"GameOver_Share",2}, 155, 315, function( ... )
    	self.run = false
        if self.scoreSch then
            scheduler.unscheduleGlobal(self.scoreSch)
        end
        self.scoreLabel:setString(score)
        self.scoreLabel:setScale(1)
        if self.coinSch then
            scheduler.unscheduleGlobal(self.coinSch)
        end
        self.coinLabel:setString(money)
        self.coinLabel:setScale(1)
        if self.hisSch then
            scheduler.unscheduleGlobal(self.hisSch)
        end
        self.historyScoreLabel:setString(history.."分")
        self.historyScoreLabel:setScale(1)
        if self.worldSch then
            scheduler.unscheduleGlobal(self.worldSch)
        end
        self.worldScoreLabel:setString(worldRank.."名")
        self.worldScoreLabel:setScale(1)
        self.replayBtn:setScale(1)
        self.homeBtn:setScale(1)
        self:setTouchEnabled(false)
        local screen = display.printscreen(tar, args)
        self.white = display.newColorLayer(ccc4(255, 255, 255, 255))
        self:addChild(self.white)
        self.white:setZOrder(10)
        local fOut = CCFadeOut:create(0.5)
        local call = CCCallFunc:create(function()
            one.action(self.screenBoard, "moveto", 0.5, ccp(display.cx, display.top/3*2+40), "backout", function( ... )
                self.textBoard = one.sp("GameOver_Text_Board", display.cx, display.top/3*2-100, self)
                one.ttf("我在GAMEE中玩\""..gameName.."\"拿到"..score.."分，\n在好友中排名第"..friendRank.."！求虐求调教！",self.textBoard:w()/2 , self.textBoard:h()/2, 25, ccc3(155, 155, 155), MAIN_FONT, ui.TEXT_ALIGN_LEFT, self.textBoard)
                self.textBoard:setZOrder(-1)
                one.action(self.textBoard, "moveto", 0.3, ccp(display.cx, display.top/3*2-290), "backout", function( ... )
                    one.action(self.quanBtn, "scaleto", 0.3, 1, "backout", cal)
                end)
                self.quanBtn = one.btn({"GameOver_Quan",2}, display.cx, display.top/3*2-290-130, function()
                    self.white:setOpacity(255)
                    local fOut = CCFadeOut:create(0.5)
                    local call = CCCallFunc:create(function()
                        --
                        end)
                    local action = transition.sequence({fOut,call})
                    self.white:runAction(action)
                    self.textBoard:removeSelf()
                    self.screenBoard:removeSelf()
                    self.quanBtn:removeSelf()
                    self.cancelBtn:removeSelf()
                    self.board:show()
                end, nil, self)
                self.quanBtn:setScale(0)
                self.cancelBtn = one.btn({"GameOver_Cancel",2}, display.cx, self.quanBtn:y()-100, function()
                    self.white:setOpacity(255)
                    local fOut = CCFadeOut:create(0.5)
                    local call = CCCallFunc:create(function()
                        --
                        end)
                    local action = transition.sequence({fOut,call})
                    self.white:runAction(action)
                    self.textBoard:removeSelf()
                    self.screenBoard:removeSelf()
                    self.quanBtn:removeSelf()
                    self.cancelBtn:removeSelf()
                    self.board:show()
                end, nil, self)
            end)
        end)
        local action = transition.sequence({fOut,call})
        self.white:runAction(action)
        self.board:hide()
        self.screenBoard = one.sp("GameOver_Screen_Board", display.cx, display.cy, self)
        self.screenColl = one.coll(0, 26, self.screenBoard:w(), self.screenBoard:h()-50, self.screenBoard)
        self.screenColl:addChild(screen)
        screen:setPosition(self.screenColl:w()/2, self.screenColl:h()/2)
        screen:setScale(0.84)
    end, sound, self.board)
    --查看排名按钮
    self.rankBtn = one.btn({"GameOver_Rank",2}, 155, 225, function( ... )
        -- body
        end, sound, self.board)
    --再玩一次按钮
    self.replayBtn = one.btn({"GameOver_Replay",2}, 252, 100, function( ... )
        self.replayBtn:setButtonEnabled(false)
        if againListen then
            againListen()
        end
    end, sound, self.board)
    self.replayBtn:setScale(0)
    --回到主界面按钮
    self.homeBtn = one.btn({"GameOver_Home",2}, 480, 100, function( ... )
        self.homeBtn:setButtonEnabled(false)
        app:enterScene("MainScene")
    end, sound, self.board)
    self.homeBtn:setScale(0)
    --世界排名
    self.worldLabel = one.ttf("世界排名", 376, 332, GAME_OVER_LABEL_SIZE, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    self.worldScoreLabel = one.ttf(worldRank.."名", 376, 290, GAME_OVER_LABEL_SCORE_SIZE, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    self.worldScoreLabel:x(360+self.worldScoreLabel:w()/2)
    self.worldScoreLabel:setScale(0)
    self.worldScoreLabel:setString("0名")
    --历史最高
    self.historyLabel = one.ttf("历史最高", 376, 238, GAME_OVER_LABEL_SIZE, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    self.historyScoreLabel = one.ttf(history.."分", 376, 196, GAME_OVER_LABEL_SCORE_SIZE, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    self.historyScoreLabel:x(360+self.historyScoreLabel:w()/2)
    self.historyScoreLabel:setScale(0)
    self.historyScoreLabel:setString("0分")
    --本次分数
    self.scoreBoard = one.sp("GameOver_Score", 167, self.board:h()-38, self.board)
    self.scoreLabel = one.ttf(0, self.scoreBoard:w()/2, self.scoreBoard:h()/2, GAME_OVER_SCORE_SIZE, GAME_OVER_SCORE_COLOR, GAME_OVER_SCORE_FONT, align, self.scoreBoard)
    --金币
    self.coinOut = one.sp("GameOver_Coin_Out", self.board:w()-45, 350, self.board)
    self.coin = one.sp("GameOver_Coin", self.board:w()-45, 350, self.board)
    self.coinLabel = one.ttf(10,self.board:w()-85, 354, 42, ccc3(255, 255, 255), MAIN_FONT, align, self.board)
    self.coinLabel:x(self.coin:x()-self.coinLabel:w()/2-30)
    self.coinLabel:setString(0)
    local filp_1 = CCOrbitCamera:create(0.5, 1, 0, 0, 180, 0, 0)
    local filp_2 = CCOrbitCamera:create(0.5, 1, 0, 180, 180, 0, 0)
    local filp = transition.sequence({filp_1,filp_2})
    local ac = CCRepeatForever:create(filp)
    self.coin:runAction(ac)
    --是否新纪录
    if newRe then
        local finSize = 0.33
        self.newRe = one.sp("GameOver_New",self.board:w()-140, 414, self.board)
        self.newReMo = one.sp("GameOver_New_Mo",self.newRe:w()/2, self.newRe:h()/2, self.newRe)
        local sc = CCScaleTo:create(0.3, finSize)
        local ease = CCEaseBounceOut:create(sc)
        local fOut = CCFadeOut:create(0.3)
        self.newReMo:runAction(fOut)
        self.newRe:runAction(ease)
    end
end

return GameOver


