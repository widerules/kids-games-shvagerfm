local composer = require( "composer" )
local widget = require("widget")
local constants = require "constants"
local settingsPopup = require "utils.settingsPopup"
local exitPopup = require "utils.exitPopup"

local scene = composer.newScene()

local background, logo, btnPlay, btnSettings, btnShare, btnExit

local backgroundImagePath = "images/start_bg.jpg"
local logoImagePath = "images/logo.png"

local playBtnImagePath = {}
playBtnImagePath[1] = "images/play_a.png"
playBtnImagePath[2]= "images/play_n.png"

local exitBtnImagePath = {}
exitBtnImagePath[1] = "images/exit_a.png"
exitBtnImagePath[2]= "images/exit_n.png"

local shareBtnImagePath = {}
shareBtnImagePath[1] = "images/share_a.png"
shareBtnImagePath[2] = "images/share_n.png"

local settingsBtnImagePath = {}
settingsBtnImagePath[1] = "images/settings_a.png"
settingsBtnImagePath[2] = "images/settings_n.png"

function scene:create( event )
    local group = self.view

    background = display.newImage( backgroundImagePath, constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert( background )

    logo = display.newImage( logoImagePath, constants.CENTERX * 1.34, constants.CENTERY * 0.53 )
    logo.width = constants.W * 0.35
    logo.height = constants.H * 0.48
    group:insert(logo)

    btnPlay = widget.newButton
        {
            width = constants.W*0.28,
            height = constants.W*0.2,
            x = constants.CENTERX * 1.35,
            y = constants.CENTERY*1.38,
            defaultFile = playBtnImagePath[1],
            overFile = playBtnImagePath[2],
            onRelease = function (event)
                if (exitPopup.isOnScreen() == false and settingsPopup.isOnScreen() == false) then
                    composer.gotoScene("scenes.scenetemplate")
                end
            end
        }
    group:insert(btnPlay)

    btnExit = widget.newButton
        {
            width = constants.W*0.13,
            height = constants.W*0.13,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = exitBtnImagePath[1],
            overFile = exitBtnImagePath[2],
            onRelease = function (event)
                if (exitPopup.isOnScreen() == false and settingsPopup.isOnScreen() == false) then
                    exitPopup.show({event.target, btnPlay, btnShare, btnSettings})
                end
            end

        }
    btnExit.x = constants.W - btnExit.width*0.6
    btnExit.y = btnExit.height*0.6
    group:insert(btnExit)

    btnSettings = widget.newButton
        {
            width = constants.W*0.17,
            height = constants.W*0.13,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = settingsBtnImagePath[1],
            overFile = settingsBtnImagePath[2],
            onRelease = function()
                if (settingsPopup.isOnScreen() == false) then
                    settingsPopup.show()
                else
                    settingsPopup.hide()
                end
            end
        }
    btnSettings.x = btnSettings.width*0.5
    btnSettings.y = btnSettings.height*0.5
    group:insert(btnSettings)

    btnShare = widget.newButton
        {
            width = constants.W*0.17,
            height = constants.W*0.13,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = shareBtnImagePath[1],
            overFile = shareBtnImagePath[2],
            onRelease = function ()
                -- TODO: add share btn event
                print("share btn clicked")
            end
        }
    btnShare.x = btnShare.width*0.5
    btnShare.y = constants.H - btnShare.height*0.5
    group:insert(btnShare)

    composer.setVariable("btns", {btnSettings, btnShare, btnExit, btnPlay})
end


function scene:show( event )
end

function scene:hide( event )
end

function scene:destroy( event )
    display.remove(background)
    display.remove(logo)
    display.remove(btnPlay)
    display.remove(btnExit)
    display.remove(btnShare)
    display.remove(btnSettings)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene