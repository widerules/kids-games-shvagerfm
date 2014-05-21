local storyboard = require "storyboard"
local rate = require( "utils.rate" )
local memoryViewer = require( "utils.memoryViewer" )
local constants = require( "constants" )


_SOUNDON = true

storyboard.purgeOnSceneChange = true

shouldWork = true

memoryViewer.create(constants.W/2, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

local function exit ()
  rate.init()
end
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
  

   if ( ("back" == keyName or "deleteBack" == keyName) and phase == "up" ) then
    local currentScene = storyboard.getCurrentSceneName()
     local lastScene = storyboard.getPrevious()

            
            if ( currentScene == "scenes.scenetemplate") then
               exit()
          
            else
               transition.cancel( )
               storyboard.gotoScene( "scenes.scenetemplate" )
               storyboard.removeAll( )
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
   return true  --SEE NOTE BELOW
end
Runtime:addEventListener( "key", onKeyEvent )
-- load scenetemplate.lua
storyboard.gotoScene( "scenes.scenetemplate" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):