local composer = require("composer")
local widget = require("widget")
local constants = require("constants")

local popup = {}

local _POPUPSIZE = constants.W*0.8

local popupBg, moreGamesBtn, disableAdsBtn, settingsLabel, musicLabel, blackBg, closePopupBtn
local switch

local moreGamesURL = "http://plus.google.com/+solyankanetua-ShvagerFM"
local disableAdsURL = "market://details?id=com.shvagerfm.samspuzzles"

local onScreen = false

local backgroundSnd = audio.loadSound("sounds/fon.mp3")

popup.isOnScreen = function()
    return onScreen
end

local function destroyPopup ()

    display.remove( popupBg )
    display.remove( closePopupBtn )
    display.remove( moreGamesBtn )
    display.remove( disableAdsBtn )
    display.remove( settingsLabel )
    display.remove( musicLabel )
    display.remove( switch )
    display.remove( blackBg )


    blackBg = nil
    popupBg = nil
    closePopupBtn = nil
    moreGamesBtn = nil
    disableAdsBtn = nil
    settingsLabel = nil
    musicLabel = nil
    switch = nil

    onScreen = false
end

local function onMoreGamesBtnClicked()
   system.openURL(moreGamesURL)
end

local function onDisableAdsBtnClicked()
    system.openURL(disableAdsURL)
end

local function onExitButtonClicked()
    destroyPopup()
end

local function onChangeVolumeStateClicked( event )
    local switch = event.target

    if (switch.isOn == true) then
        audio.play(backgroundSnd)
        _PLAY_SOUND = true
    else
        audio.stop()
        _PLAY_SOUND = false
    end

end

popup.show = function ()

    blackBg = display.newRect(constants.CENTERX, constants.CENTERY, constants.W, constants.H)
    blackBg:setFillColor(0, 0, 0)
    blackBg.alpha = 0.8

    popupBg = display.newImage("images/popup_bg.png", constants.CENTERX, constants.CENTERY)
    popupBg.width = _POPUPSIZE
    popupBg.height = _POPUPSIZE*0.66

    settingsLabel = display.newText("Settings", popupBg.x, popupBg.y * 0.6, "Arial", popupBg.height * 0.15  )
    musicLabel = display.newText("Music: ", popupBg.x * 0.6, popupBg.y, "Arial", popupBg.height * 0.1)

    switch = widget.newSwitch {
            left = 100,
            top = 300,
            onPress = onChangeVolumeStateClicked
        }

    switch:setState( { isOn=_PLAY_SOUND, isAnimated=true} )
    switch.x = popupBg.x
    switch.y = popupBg.y
    switch.width = popupBg.width * 0.17
    switch.height = popupBg.height * 0.17

    moreGamesBtn = widget.newButton{
        width = popupBg.width*0.33,
        height = popupBg.y * 0.5,
        x = popupBg.x * 0.7,
        y = popupBg.y * 1.45,
        defaultFile = "images/More_a.png",
        overFile = "images/More_n.png",
        onRelease = onMoreGamesBtnClicked
    }

    disableAdsBtn = widget.newButton{
        width = popupBg.width*0.33,
        height = popupBg.y * 0.5,
        x = moreGamesBtn.x * 1.85,
        y = popupBg.y * 1.45,
        defaultFile = "images/Disable_a.png",
        overFile = "images/Disable_n.png",
        onRelease = onDisableAdsBtnClicked
    }

    closePopupBtn = widget.newButton {
        width = popupBg.width*0.13,
        height = popupBg.width * 0.13,
        x = popupBg.width * 0.88,
        y = popupBg.y * 0.6,
        defaultFile = "images/exit_a.png",
        overFile = "images/exit_n.png",
        onRelease = onExitButtonClicked
    }

    onScreen = true
end

popup.hide = function()
    destroyPopup()
end

return popup