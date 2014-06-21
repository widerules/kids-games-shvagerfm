local composer = require ("composer")
local widget = require("widget")
local constants = require("data.constants")
local admob = require( "utils.admob" )

local scene = composer.newScene()

local backgroundImagePyth = "images/start_bg.jpg"

local playBtnImagePyth = "images/play_a.png"
local playBtnOverImagePyth = "images/play_n.png"

local logoImagePyth = "images/logo.png"

local exitBtnImagePyth = "images/exit_a.png"
local exitBtnOverImagePyth = "images/exit_n.png"

local shareBtnImagePyth = "images/share_a.png"
local shareBtnOverImagePyth = "images/share_n.png"

local settingsBtnImagePyth = "images/settings_a.png"
local settingsBtnOverImagePyth = "images/settings_n.png"

local background, logo, btnPlay, btnExit, btnSettings, btnShare

function scene:create(event)
    local group = self.view

    background = display.newImage (backgroundImagePyth, constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert(background)

    logo = display.newImage(logoImagePyth, constants.CENTERX, constants.CENTERY*0.4)
    logo.width = constants.W*0.4
    logo.height = constants.W*0.2
    group:insert(logo)

    local btnPlay = widget.newButton
        {
            width = constants.W*0.3,
            height = constants.W*0.17,
            x = constants.CENTERX,
            y = constants.CENTERY*1.25,
            defaultFile = playBtnImagePyth,
            overFile = playBtnOverImagePyth,
            onRelease = function ()
                --admob.showAd( "interstitial" )
                composer.gotoScene("scenes.locationMap")

                --приделать обработку
            end
        }
    group:insert(btnPlay)

    local btnExit = widget.newButton
        {
            width = constants.W*0.13,
            height = constants.W*0.13,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = exitBtnImagePyth,
            overFile = exitBtnOverImagePyth,
            onRelease = function ()
                print("exited")
            -- TODO: exit app
            end

        }
    btnExit.x = constants.W - btnExit.width*0.6
    btnExit.y = btnExit.height*0.6
    group:insert(btnExit)

    local btnSettings = widget.newButton
        {
            width = constants.W*0.17,
            height = constants.W*0.13,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = settingsBtnImagePyth,
            overFile = settingsBtnOverImagePyth,
            onRelease = function ()
                print("settings button")
            -- TODO: show settings box
            end
        }
    btnSettings.x = btnSettings.width*0.5
    btnSettings.y = btnSettings.height*0.5
    group:insert(btnSettings)

    local btnShare = widget.newButton
        {
            width = constants.W*0.17,
            height = constants.W*0.13,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = shareBtnImagePyth,
            overFile = shareBtnOverImagePyth,
            onRelease = function ()
                print("share btn click")
            -- TODO: share with friends
            end
        }
    btnShare.x = btnShare.width*0.5
    btnShare.y = constants.H - btnShare.height*0.5
    group:insert(btnShare)

    admob.init()
end

function scene:show (event)
    local group = self.view
end

function scene:hide(event)
    local group = self.view
end

function scene:destroy(event)
    local group = self.view

    display.remove(background)
    display.remove(logo)
    display.remove(btnPlay)
    display.remove(btnExit)
    display.remove(btnShare)
    display.remove(btnSettings)

    group:remove(background)
    group:remove(logo)
    group:remove(btnPlay)
    group:remove(btnExit)
    group:remove(btnShare)
    group:remove(btnSettings)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene