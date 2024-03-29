-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local storyboard = require "storyboard"
local rate = require( "utils.rate" )
local admob = require( "utils.admob" )

storyboard.disableAutoPurge = true

--global center & heigh-width
_CENTERX = display.contentCenterX
_CENTERY = display.contentCenterY
_W = display.contentWidth
_H = display.contentHeight
_GAME = 1
-- load scenetemplate.lua

local function exit ()
	rate.init()
end
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( ("back" == keyName or "deleteBack" == keyName) and phase == "up" ) then
      local currentScene = storyboard.getCurrentSceneName()
      local lastScene = storyboard.getPrevious()
         print( "previous scene", lastScene )
         
         if ( currentScene == "scenetemplate") then
            exit()
       
         elseif (currentScene == "scenes.gametitle" or currentScene == "scenes.gametitle2") then
           
               local options =
                  {
                     effect = "slideRight",
                     time = 800,
                  }
               storyboard.gotoScene( "scenetemplate", options )
               storyboard.removeAll( )
         else
            local options =
               {
                  effect = "slideRight",
                  time = 800,
                  params = { ind = _GAME }
               }
            storyboard.gotoScene( lastScene, options )
            storyboard.removeAll( )

         end
   end
   if ( keyName == "volumeUp" and phase == "down" ) then
      local masterVolume = audio.getVolume()
      print( "volume:", masterVolume )
      if ( masterVolume < 1.0 ) then
         masterVolume = masterVolume + 0.1
         audio.setVolume( masterVolume )
      end
      return false
   elseif ( keyName == "volumeDown" and phase == "down" ) then
      local masterVolume = audio.getVolume()
      print( "volume:", masterVolume )
      if ( masterVolume > 0.0 ) then
         masterVolume = masterVolume - 0.1
         audio.setVolume( masterVolume )
      end
      return false
   end
   return true  --SEE NOTE BELOW
end
Runtime:addEventListener( "key", onKeyEvent )

admob.init()
storyboard.gotoScene( "scenetemplate" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):