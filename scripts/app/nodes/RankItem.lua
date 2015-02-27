local RankItem = class("RankItem", function( ... )
    return display.newSprite("#Main_Rank_Item_Board.png")
end)

--基础的离父类的坐标
local basic_height = 108
--皇冠和排名的x坐标
local rank_x = 50
--名字的x坐标
local nick_x = 110
--分数的x坐标
local score_x = 400

function RankItem:ctor(father,index,nick,scr,id,first,rank,list)
    if father then
        father:addChild(self)
    end
    if not list then
        if first then
            local id = user:getIntegerForKey("id", 0)
            if id and id ~= 0 then
                self:setPosition(father:getContentSize().width/2,father:getContentSize().height-basic_height-(self:getContentSize().height+10)*(index))
            else
                self:setPosition(father:getContentSize().width/2,father:getContentSize().height-basic_height-(self:getContentSize().height+10)*(index-1))
            end
        else
            self:setPosition(father:getContentSize().width/2,father:getContentSize().height-basic_height-(self:getContentSize().height+10)*(index-1))
        end
    end

    --设置前三特别的皇冠
    local name = nick
    if string.len(nick)>15 then
        name = string.sub(nick,1, 15).."..."
    end
    local my = user:getIntegerForKey("id")
    if id == my  then
        one.sp("Main_Rank_Mine", self:getContentSize().width/2, self:getContentSize().height/2, self)
    end
    if index == 1 then
        if rank then
            if rank == 1 then
                one.sp("Main_Rank_1_King", rank_x,self:getContentSize().height/2, self)
            end
            local n = one.ttf(rank, rank_x, self:getContentSize().height/2, 40, ccc3(255, 255, 255), MAIN_FONT, align, self)
            local t = one.ttf(name, nick_x, self:getContentSize().height/2, 40 , ccc3(255, 255, 255), MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
            t:setPositionX(nick_x+t:getContentSize().width/2)
            local s = one.ttf(scr.."分", score_x, self:getContentSize().height/2, 40 , ccc3(255, 255, 255), MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
            s:setPositionX(score_x+s:getContentSize().width/2)
            if id == my then
                t:setColor(ccc3(255, 255, 255))
                s:setColor(ccc3(255, 255, 255))
                n:setColor(ccc3(255, 255, 255))
            end
        else
            one.sp("Main_Rank_1_King", rank_x,self:getContentSize().height/2, self)
            local n = one.ttf(1, rank_x, self:getContentSize().height/2, 40, RANK_1_COLOR, MAIN_FONT, align, self)
            local t = one.ttf(name, nick_x, self:getContentSize().height/2, 40 , RANK_1_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
            t:setPositionX(nick_x+t:getContentSize().width/2)
            local s = one.ttf(scr.."分", score_x, self:getContentSize().height/2, 40 , RANK_1_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
            s:setPositionX(score_x+s:getContentSize().width/2)
            if id == my then
                t:setColor(ccc3(255, 255, 255))
                s:setColor(ccc3(255, 255, 255))
                n:setColor(ccc3(255, 255, 255))
            end
        end
    elseif index == 2 then
        one.sp("Main_Rank_2_King", rank_x,self:getContentSize().height/2, self)
        local n = one.ttf(2, rank_x, self:getContentSize().height/2, 40, RANK_2_COLOR, MAIN_FONT, align, self)
        local t = one.ttf(name, nick_x, self:getContentSize().height/2, 40 , RANK_2_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
        t:setPositionX(nick_x+t:getContentSize().width/2)
        local s = one.ttf(scr.."分", score_x, self:getContentSize().height/2, 40 , RANK_2_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
        s:setPositionX(score_x+s:getContentSize().width/2)
        if id == my then
            t:setColor(ccc3(255, 255, 255))
            s:setColor(ccc3(255, 255, 255))
            n:setColor(ccc3(255, 255, 255))
        end
    elseif index == 3 then
        one.sp("Main_Rank_2_King", rank_x,self:getContentSize().height/2, self)
        local n = one.ttf(3, rank_x, self:getContentSize().height/2, 40, RANK_3_COLOR, MAIN_FONT, align, self)
        local t = one.ttf(name, nick_x, self:getContentSize().height/2, 40 , RANK_3_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
        t:setPositionX(nick_x+t:getContentSize().width/2)
        local s = one.ttf(scr.."分", score_x, self:getContentSize().height/2, 40 , RANK_3_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
        s:setPositionX(score_x+s:getContentSize().width/2)
        if id == my then
            t:setColor(ccc3(255, 255, 255))
            s:setColor(ccc3(255, 255, 255))
            n:setColor(ccc3(255, 255, 255))
        end
    else
        local n = one.ttf(index, rank_x, self:getContentSize().height/2, 40, RANK_OTHER_COLOR, MAIN_FONT, align, self)
        local t = one.ttf(name, nick_x, self:getContentSize().height/2, 40 , RANK_OTHER_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
        t:setPositionX(nick_x+t:getContentSize().width/2)
        local s = one.ttf(scr.."分", score_x, self:getContentSize().height/2, 40 , RANK_OTHER_COLOR, MAIN_FONT, ui.TEXT_ALIGN_LEFT, self)
        s:setPositionX(score_x+s:getContentSize().width/2)
        if id == my then
            t:setColor(ccc3(255, 255, 255))
            s:setColor(ccc3(255, 255, 255))
            n:setColor(ccc3(255, 255, 255))
        end
    end

end

return RankItem


