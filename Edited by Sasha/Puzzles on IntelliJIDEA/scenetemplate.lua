local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )

local scene = storyboard.newScene()

local backgroundImagePyth = "images/bghome.jpg"

local playBtnImagePyth = "images/btnPlay.png"
local playBtnOverImagePyth = "images/btnPlayOver.png"

local exitBtnImagePyth = "images/btnExit.png"
local exitBtnOverImagePyth = "images/btnExit.png"

local shareBtnImagePyth = "images/btnShare.png"
local shareBtnOverImagePyth = "images/btnShare.png"

local settingsBtnImagePyth = "images/btnSettings.png"
local settingsBtnOverImagePyth = "images/btnSettings.png"

function scene:createScene(event)
    local group = self.view

    local background = display.newImage (backgroundImagePyth, constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert(background)

    local btnPlay = widget.newButton
        {
            width = constants.W/4,
            height = constants.W/8,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = playBtnImagePyth,
            overFile = playBtnOverImagePyth,
            onRelease = function ()
                admob.showAd( "interstitial" )
                storyboard.gotoScene("scenes.locationMap")
            end
        }
    btnPlay.y = constants.CENTERY - 0.5*btnPlay.height
    group:insert(btnPlay)

    local btnExit = widget.newButton
        {
            width = constants.W/10,
            height = constants.W/10,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = exitBtnImagePyth,
            overFile = exitBtnOverImagePyth,
            onRelease = function ()
                print("exited")
                -- TODO: exit app
            end

        }
    btnExit.x = constants.W - btnExit.width
    btnExit.y = btnExit.height
    group:insert(btnExit)

    local btnSettings = widget.newButton
        {
            width = constants.W/10,
            height = constants.W/10,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = settingsBtnImagePyth,
            overFile = settingsBtnOverImagePyth,
            onRelease = function ()
                print("settings button")
            -- TODO: show settings box
            end
        }
    btnSettings.x = btnSettings.width
    btnSettings.y = btnSettings.height
    group:insert(btnSettings)

    local btnShare = widget.newButton
        {
            width = constants.W/10,
            height = constants.W/10,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = shareBtnImagePyth,
            overFile = shareBtnOverImagePyth,
            onRelease = function ()
                print("share btn click")
            -- TODO: share with friends
            end
        }
    btnShare.x = btnShare.width * 1.5 + btnSettings.width
    btnShare.y = btnShare.height
    group:insert(btnShare)

    admob.init()
end

function scene:enterScene (event)
end

function scene:exitScene(event)
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene