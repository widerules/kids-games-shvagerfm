local composer = require "composer"
local rate = require( "utils.rate" )
local memoryViewer = require( "utils.memoryViewer" )
local constants = require( "constants" )
local settingsPopup = require "utils.settingsPopup"
local exitPopup = require "utils.exitPopup"

_PLAY_SOUND = true

composer.recycleOnSceneChange = true

local shouldWork = true
memoryViewer.create(constants.W/2, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

math.randomseed(os.time())

local function exit ()
  rate.init()
end
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName

   if ( ("back" == keyName or "deleteBack" == keyName) and phase == "up" ) then
    local currentScene = composer.getSceneName("current")

            if (currentScene == "scenes.start_page") then
                if (settingsPopup.isOnScreen() == true) then
                    settingsPopup.hide()
                    return true
                elseif (exitPopup.isOnScreen() == true) then
                    exit()
                    return true
                elseif (exitPopup.isOnScreen() == false) then
                    exitPopup.show(composer.getVariable("btns"))
                    return true
                end

            end

            if ( currentScene == "scenes.scenetemplate") then
                composer.gotoScene("scenes.start_page")
            else
                timer.performWithDelay(500, function()
                    transition.cancel( )
                    composer.gotoScene( "scenes.scenetemplate")
                end)
            end
   
   end
   if ( keyName == "volumeUp" and phase == "down" ) then
      local masterVolume = audio.getVolume()
      if ( masterVolume < 1.0 ) then
         masterVolume = masterVolume + 0.1
         audio.setVolume( masterVolume )
      end
      return false
   elseif ( keyName == "volumeDown" and phase == "down" ) then
      local masterVolume = audio.getVolume()
      if ( masterVolume > 0.0 ) then
         masterVolume = masterVolume - 0.1
         audio.setVolume( masterVolume )
      end
      return false
   end

   return true
end

Runtime:addEventListener( "key", onKeyEvent )

composer.gotoScene( "scenes.start_page" )