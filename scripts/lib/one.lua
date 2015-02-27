--
-- Author: Bacootang
-- Date: 2014-06-08 15:47:22
--
require("config")
require("lib.oneExtend")
local one = {}


--创建一个sp并加到当前的SCENE
--img     sp图片，不需要.png
--x,y     sp的坐标
--返回值   sp，是否加入父节点
function one.sp(img,x,y,target)
    local name = img..".png"
    if USING_TEXTURE and string.sub(name,1,1)~="/" then
        name = "#"..name
    end
    local sp = display.newSprite(name, x, y)
    oneExtend.extent(sp)
    if target == "" then
        return sp,true
    end
    if target then
        target:addChild(sp)
        return sp ,true
    end
    if tar then
        tar:addChild(sp)
        return sp ,true
    end
    return sp , false
end

function one.spp(img,x,y,target)
    local name = img..".png"
    local sp = display.newSprite(name, x, y)
    oneExtend.extent(sp)
    if target == "" then
        return sp,true
    end
    if target then
        target:addChild(sp)
        return sp ,true
    end
    if tar then
        tar:addChild(sp)
        return sp ,true
    end
    return sp , false
end

function one.sp9(img,x,y,size,target)
    local name = img..".png"
    if USING_TEXTURE and string.sub(name,1,1)~="/" then
        name = "#"..name
    end
    --local sp = display.newSprite(name, x, y)
    local sp = display.newScale9Sprite(name, x, y, size)
    oneExtend.extent(sp)
    if target == "" then
        return sp,true
    end
    if target then
        target:addChild(sp)
        return sp ,true
    end
    if tar then
        tar:addChild(sp)
        return sp ,true
    end
    return sp , false
end

function one.spp9(img,x,y,size,target)
    local name = img..".png"
    --local sp = display.newSprite(name, x, y)
    local sp = display.newScale9Sprite(name, x, y, size)
    oneExtend.extent(sp)
    if target == "" then
        return sp,true
    end
    if target then
        target:addChild(sp)
        return sp ,true
    end
    if tar then
        tar:addChild(sp)
        return sp ,true
    end
    return sp , false
end

function one.coll(x,y,w,h,target)
    local rect = CCRect(x, y, w, h)
    local sp = display.newClippingRegionNode(rect)
    oneExtend.extent(sp)
    if target == "" then
        return sp,true
    end
    if target then
        target:addChild(sp)
        return sp ,true
    end
    if tar then
        tar:addChild(sp)
        return sp ,true
    end
    return sp , false
end

-- function one.btn(img,x,y,lis,sound,target)
--     local listener = function(event)
--         if sound then
--             audio.playSound(sound)
--         end
--         lis(event)
--     end
--     if type(img) == "string" then
--         local btn  = cc.ui.UIPushButton.new(img..".png")
--             :onButtonClicked(listener)
--         if x and y then
--             btn:align(display.CENTER, x, y)
--         end
--         if target and target~="" then
--             btn:addTo(target or tar)
--         end
--         return btn
--     elseif type(img)== "table" then
--         local name = img[1]
--         local se = img[2]
--         local images = nil
--         if se == 1 then
--             images = name
--         elseif se == 2 then
--             images = {normal = name..".png",pressed = name .. "_sel.png"}
--         elseif se == 3 then
--             images = {normal = name..".png",pressed = name .. "_sel.png",disabled = name .. "_dis.png"}
--         end
--         local btn  = cc.ui.UIPushButton.new(images)
--             :onButtonClicked(listener)
--         if x and y then
--             btn:align(display.CENTER, x, y)
--         end
--         if target and target~="" then
--             btn:addTo(target or tar)
--         end
--         return btn
--     end
-- end

function one.btn(img,x,y,lis,sound,target)
    local listener = function(event)
        if sound then
            audio.playSound(sound)
        end
        lis(event)
    end
    if type(img) == "string" then
        local btn  = one.sp(img, x, y, "")
        oneExtend.extent(btn)
        btn:addBtnLis(lis)
        if target and target~="" then
            btn:addTo(target or tar)
        end
        return btn
    elseif type(img)== "table" then
        local name = img[1]
        local se = img[2]
        local btn  = one.sp(img[1], x, y, "")
        oneExtend.extent(btn)
        btn:addBtnLis(lis)
        if se == 2 then
            btn._sel  = one.sp(img[1].."_sel", btn:w()/2, btn:h()/2, btn)
            btn._sel:hide()
        elseif se==3 then
            btn._sel  = one.sp(img[1].."_sel", btn:w()/2, btn:h()/2, btn)
            btn._dis  = one.sp(img[1].."_dis", btn:w()/2, btn:h()/2, btn)
            btn._sel:hide()
            btn._dis:hide()
        end
        if target and target~="" then
            btn:addTo(target or tar)
        end
        return btn
    end
end
function one.btnn(img,x,y,lis,sound,target)
    local listener = function(event)
        if sound then
            audio.playSound(sound)
        end
        lis(event)
    end
    if type(img) == "string" then
        local btn  = one.spp(img, x, y, "")
        oneExtend.extent(btn)
        btn:addBtnLis(lis)
        if target and target~="" then
            btn:addTo(target or tar)
        end
        return btn
    elseif type(img)== "table" then
        local name = img[1]
        local se = img[2]
        local btn  = one.spp(img[1], x, y, "")
        oneExtend.extent(btn)
        btn:addBtnLis(lis)
        if se == 2 then
            btn._sel  = one.spp(img[1].."_sel", btn:w()/2, btn:h()/2, btn)
            btn._sel:hide()
        elseif se==3 then
            btn._sel  = one.spp(img[1].."_sel", btn:w()/2, btn:h()/2, btn)
            btn._dis  = one.spp(img[1].."_dis", btn:w()/2, btn:h()/2, btn)
            btn._sel:hide()
            btn._dis:hide()
        end
        if target and target~="" then
            btn:addTo(target or tar)
        end
        return btn
    end
end

function one.color(col,target)
    local sp = display.newColorLayer(col)
    oneExtend.extent(sp)
    if target == "" then
        return sp,true
    end
    if target then
        target:addChild(sp)
        return sp ,true
    end
    if tar then
        tar:addChild(sp)
        return sp ,true
    end
    return sp , false
end

function one.ttf(text,x,y,size,color,font,align,target)
    local args = {}
    args.text = text or "Hello,World"
    args.x = x or display.cx
    args.y = y or display.cy
    args.size = size or 60
    args.color = color or display.COLOR_WHITE
    args.align = ui.TEXT_ALIGN_CENTER
    if font then
        args.font = font
    end
    local ttf = ui.newTTFLabel(args)
    oneExtend.extent(ttf)
    if target then
        target:addChild(ttf)
    else
        tar:addChild(ttf)
    end
    return ttf
end

function one.get(url,listener)
    local callback = function(event)

        if event.name == "completed" then
            local ok = (event.name == "completed")
            local request = event.request
            if not ok then
                print(request:getErrorCode(), request:getErrorMessage())
                return
            end
            local code = request:getResponseStatusCode()
            if code ~= 200 then
                print(code)
                local response = request:getResponseString()
                print(response)
                return
            end
            local response = request:getResponseString()
            local data = request:getResponseData()
            listener(response,data)
        end
    end
    local request = network.createHTTPRequest(callback, url, "GET")
    request:start()
end

function one.post(url,args,listener)
    local callback = function(event)
        if event.name == "completed" then
            local ok = (event.name == "completed")
            local request = event.request
            if not ok then
                print(request:getErrorCode(), request:getErrorMessage())
                return
            end
            local code = request:getResponseStatusCode()
            if code ~= 200 then
                print(code)
                print(request:getResponseString())
                return
            end
            local response = request:getResponseString()
            listener(response)
        end
    end
    local request = network.createHTTPRequest(callback, url, "POST")
    for k,v in pairs(args) do
        request:addPOSTValue(k, v)
    end
    request:start()
end

function one.action(target,ac,time,last,ease,cal)
    local action = nil
    local action_tab = {}
    action_tab.moveto = function(time,last)
        return CCMoveTo:create(time, last)
    end
    action_tab.moveby = function(time,last)
        return CCMoveBy:create(time, last)
    end
    action_tab.scaleto = function(time,last)
        if type(last) == "number" then
            return CCScaleTo:create(time, last)
        else
            return CCScaleTo:create(time, last[1], last[2])
        end
    end
    action_tab.scaleby = function(time,last)
        if type(last) == "number" then
            return CCScaleBy:create(time, last)
        else
            return CCScaleBy:create(time, last[1], last[2])
        end
    end
    action_tab.proto = function( time,last )
        return CCProgressTo:create(time, last)
    end
    action_tab.rotateto = function( time ,last )
        return  CCRotateTo:create(time, last)
    end

    action_tab.rotateby = function( time ,last )
        return  CCRotateBy:create(time, last)
    end
    action_tab.fadeout = function( time,last )
        return CCFadeOut:create(time)
    end
    action_tab.fadein = function( time,last )
        return CCFadeIn:create(time)
    end


    local ease_tab = {}
    ease_tab.backout = function()
        return CCEaseBackOut:create(action)
    end
    ease_tab.sineout = function()
        return CCEaseSineOut:create(action)
    end
    ease_tab.expout = function()
        return CCEaseExponentialOut:create(action)
    end

    ease_tab.bout = function()
        return CCEaseBounceOut:create(action)
    end

    action = action_tab[ac](time,last)
    if ease then
        action = ease_tab[ease]()
    end
    if cal then
        local call = CCCallFunc:create(cal)
        action = transition.sequence({action,call})
    end
    if target then
        target:runAction(action)
    end
    return action
end

return one






