--
-- Created by IntelliJ IDEA.
-- User: Svyat
-- Date: 19/06/2014
-- Time: 04:30 PM
-- To change this template use File | Settings | File Templates.
--

local composer = require "composer"
local database = require "utils.database"

database.create()
database.fill()

composer.recycleOnSceneChange = true

local function onKeyEvent(event)
    local phase = event.phase
    local name = event.keyName

    if ( ("back" == name or "deleteBack" == name) and phase == "up" ) then
        local currentScene = composer.getCurrentSceneName()


        if ( currentScene == "scenes.scenetemplate") then

        elseif(currentScene == "scenes.locationMap") then
            timer.performWithDelay(500, function()
                transition.cancel( )
                composer.gotoScene( "scenes.scenetemplate" )
                composer.removeAll()
            end)
        elseif (currentScene == "scenes.levelMap") then
            timer.performWithDelay(500, function()
                transition.cancel( )
                composer.gotoScene( "scenes.locationMap" )
                composer.removeAll()
            end)
        end

    end
    if ( name == "volumeUp" and phase == "down" ) then
        local masterVolume = audio.getVolume()
        if ( masterVolume < 1.0 ) then
            masterVolume = masterVolume + 0.1
            audio.setVolume( masterVolume )
        end
        --return false
    elseif ( keyName == "volumeDown" and phase == "down" ) then
        local masterVolume = audio.getVolume()
        if ( masterVolume > 0.0 ) then
            masterVolume = masterVolume - 0.1
            audio.setVolume( masterVolume )
        end
        --return false
    end
    --return true  --SEE NOTE BELOW
end

Runtime:addEventListener("key", onKeyEvent)

composer.gotoScene("scenes.scenetemplate")