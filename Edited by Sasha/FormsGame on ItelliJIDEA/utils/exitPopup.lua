local composer = require("composer")
local widget = require("widget")
local constants = require("constants")


local popup = {}

local _POPUPSIZE = constants.W*0.8

local popupBg, exitBtn, cancelBtn, rateBtn, buyBtn, blackBg

local backgroundBtns

local gameURL = "market://details?id=com.shvagerfm.samspuzzles"
local rateURL = "market://details?id=com.shvagerfm.samspuzzlesfree"

local onScreen = false

local function destroyPopup ()

    display.remove( popupBg )
    display.remove( exitBtn )
    display.remove( cancelBtn )
    display.remove( rateBtn )
    display.remove( buyBtn )
    display.remove(blackBg)

    popupBg = nil
    exitBtn = nil
    cancelBtn = nil
    rateBtn = nil
    buyBtn = nil
    blackBg = nil

    onScreen = false
end

local function onExitBtnClicked()
    destroyPopup()
    os.exit()
end

local function onCancelBtnClicked()
    for i = 1, #backgroundBtns do
        if backgroundBtns[i] ~= nil then
            backgroundBtns[i]:setEnabled(true)
        end
    end
    destroyPopup()
end

local function onRateBtnClicked()
    system.openURL(rateURL)
end

local function onBuyBtnClicked()
    system.openURL(gameURL)
end

popup.show = function(btns)

    backgroundBtns = btns

    for i = 1, #backgroundBtns do
        if backgroundBtns[i] ~= nil then
            backgroundBtns[i]:setEnabled(false)
        end
    end

    blackBg = display.newRect(constants.CENTERX, constants.CENTERY, constants.W, constants.H)
    blackBg:setFillColor(0, 0, 0)
    blackBg.alpha = 0.8

    popupBg = display.newImage("images/popup_bg.png", constants.CENTERX, constants.CENTERY)
    popupBg.width = _POPUPSIZE
    popupBg.height = _POPUPSIZE*0.66

    exitBtn = widget.newButton{
        width = popupBg.width*0.2,
        height = popupBg.width*0.2,
        x = popupBg.x*0.6,
        y = popupBg.y*0.8,
        defaultFile = "images/exit_popup_a.png",
        overFile = "images/exit_popup_n.png",
        onRelease = onExitBtnClicked
    }

    cancelBtn = widget.newButton{
        width = popupBg.width*0.2,
        height = popupBg.width*0.2,
        x = popupBg.x,
        y = popupBg.y*0.6,
        defaultFile = "images/cancel_a.png",
        overFile = "images/cancel_n.png",
        onRelease = onCancelBtnClicked
    }

    rateBtn = widget.newButton{
        width = popupBg.width*0.2,
        height = popupBg.width*0.2,
        x = popupBg.x*1.4,
        y = popupBg.y*0.8,
        defaultFile = "images/rate_a.png",
        overFile = "images/rate_n.png",
        onRelease = onRateBtnClicked
    }

    buyBtn = widget.newButton{
        width = popupBg.width*0.5,
        height = popupBg.height*0.5,
        x = popupBg.x,
        y = popupBg.y*1.37,
        defaultFile = "images/buy_a.png",
        overFile = "images/buy_n.png",
        onRelease = onBuyBtnClicked
    }

    onScreen = true
end

popup.hide = function()
    destroyPopup()
end

popup.isOnScreen = function()
    return onScreen
end

return popup