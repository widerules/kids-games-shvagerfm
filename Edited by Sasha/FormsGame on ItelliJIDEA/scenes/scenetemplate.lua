local composer = require( "composer" )
local constants = require "constants"
local widget = require("widget")
local admob = require( "utils.admob" )

local scene = composer.newScene()

local _GAME_COUNT = 7

local background, mikki, minni, sun, kidsAnimals, moreGames
local gamesButtons = {}
local buttonsLables = {"Learn shapes", "Find shapes", "Find pairs", "Memory pairs", "Shadows", "Draw shapes", "Associations"}
local buttonsIds = {"learn_shapes", "find_shapes", "find_pairs", "memory_pairs", "shadows", "draw_shapes", "associations"}

local bWidth = 0.33 * constants.W
local bHeight = constants.H / 7

local sizeFont = 0.07 * constants.H

local bgsound

local function soundOffOn()
    if _PLAY_SOUND == true then
        _PLAY_SOUND = false
        audio.setVolume(0)
        --audio.pause( bgsound )
    else
        _PLAY_SOUND = true
        audio.setVolume(1.0)

        --audio.resume( bgsound )
    end
end

local function getAnimalsForKids()
    composer.gotoScene("scenes.more_games")
end

function moveBack()
    transition.to( sun, {rotation = -20, time = 3000, transition = easing.inOutCubic, onComplete = moveForward})
end

function moveForward()
    transition.to( sun, {rotation = 20, time = 3000, transition = easing.inOutCubic, onComplete = moveBack})
end

local function sayMikki(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        local soundMikki = audio.loadSound( "sounds/mikkie1.mp3")
        audio.play( soundMikki )
    end
end
local function sayMinni(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        local soundMinni = audio.loadSound( "sounds/minnie1.mp3")
        audio.play( soundMinni )
    end
end
local function sunMoving(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        if _PLAY_SOUND == true then
            _PLAY_SOUND = false
            audio.setVolume(0)
            --audio.stop()
            sun:pause()
        else
            _PLAY_SOUND = true
            audio.setVolume(1)
            --audio.play( bgsound )
            --sun:play()
        end
        return true	-- indicates successful touch
    end
end

local function playGame(gameName)
    composer.gotoScene("scenes."..gameName, "slideLeft", 100 )
end

function scene:create( event )
    local group = self.view

    background = display.newImage( "images/background.jpg", constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert( background )

    local i = 1
    local currentY = bHeight

    for i = 1, _GAME_COUNT do
        gamesButtons[i] = widget.newButton {
                width = bWidth,
                height = bHeight,
                defaultFile = "images/button.png",
                overFile = "images/pbutton.png",
                id = buttonsIds[i],
                label = buttonsLables[i],
                labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
                fontSize = sizeFont,
                emboss = true,
                onRelease = function() playGame(buttonsIds[i]) end,

            }
        gamesButtons[i].x = constants.CENTERX
        gamesButtons[i].y = currentY
        group:insert(gamesButtons[i])

        currentY = currentY + bHeight * 0.9
    end

    admob.init()
end


-- Called immediately after scene has moved onscreen:
function scene:show( event )
    local group = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        bgsound = audio.loadSound( "sounds/bgsound.mp3" )
        admob.showAd( "interstitial" )
        --if _SOUNDON == true then
        audio.play( bgsound )
        --end

        mikki = display.newImage("images/miki.png", constants.W/6, 1.5*constants.CENTERY, 0.1*constants.W, 0.1*constants.H)
        mikki.width = 0.16*constants.W
        mikki.height = 0.5*constants.H
        group:insert( mikki )
        mikki:addEventListener("touch", sayMikki )

        minni = display.newImage("images/mini.png", 5*constants.W/6, 1.5*constants.CENTERY, 0.1*constants.W, 0.1*constants.H)
        minni.width = 0.16*constants.W
        minni.height = 0.5*constants.H
        group:insert( minni )
        minni:addEventListener("touch", sayMinni )

        kidsAnimals = display.newImage( "images/animals.png", constants.CENTERX, constants.CENTERY, 0.16*constants.H, 0.16*constants.H/6)
        kidsAnimals.width = 0.3*constants.H
        kidsAnimals.height = kidsAnimals.width
        kidsAnimals.x = constants.W - kidsAnimals.width
        kidsAnimals.y = 0.6*kidsAnimals.height
        group:insert( kidsAnimals )
        kidsAnimals:addEventListener("tap", getAnimalsForKids )

        local sheetData = {
            width = constants.H/2,
            height = 5*constants.H/12,
            numFrames = 4,
            sheetContentWidth = constants.H,
            sheetContentHeight = 10*constants.H/12
        }

        local shapeSheet = graphics.newImageSheet("images/sunsheet.png", sheetData)
        local sequenceData = {
            {
                name = "sunny",
                start = 1,
                count = 4,
                time = 500,
                loopCount=0,
                loopDirection = bounce,
            }
        }

        sun = display.newSprite( shapeSheet, sequenceData)
        sun.x = 0.5*sun.width
        sun.y = 0.5*sun.height
        sun:setSequence("sunny")
        --if _SOUNDON == true then
        sun:play()
        --end
        group:insert(sun)
        moveForward()
        sun.touch = sunMoving
        sun:addEventListener("touch",  sun)
    end
end

function scene:hide( event )
    local group = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        transition.cancel( )

        audio.stop()
        audio.dispose( bgsound )
        bgsound = nil
    elseif ( phase == "did" ) then

        sun:removeEventListener("touch",  sun)
        kidsAnimals:removeEventListener("tap", getAnimalsForKids )
        mikki:removeEventListener( "touch", sayMikki )
        minni:removeEventListener( "touch", sayMinni )

        display.remove( sun )
        display.remove( kidsAnimals )
        display.remove( mikki )
        display.remove( minni )

        sun = nil
        kidsAnimals = nil
        mikki = nil
        minni = nil
    end
end

function scene:destroy( event )
    local group = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene