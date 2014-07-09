local storyboard = require("storyboard")
local rate = require( "utils.rate" )
local memoryViewer = require( "utils.memoryViewer" )
local constants = require( "constants" )
local popup = require("utils.popup")
storyboard.purgeOnSceneChange = true

shouldWork = false

memoryViewer.create(constants.W/2, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

local function exit ()
   rate.init()
end
-- Your code here
local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName

if ( ("back" == keyName or "deleteBack" == keyName) and phase == "up" ) then
      local currentScene = storyboard.getCurrentSceneName()
      local lastScene = storyboard.getPrevious()

         
         if ( currentScene == "scenetemplate") then
            exit()
       
         --[[elseif (currentScene == "scenes.gametitle" or currentScene == "scenes.gametitle2") then
            timer.performWithDelay(500, function()
               local options =
                  {
                     effect = "slideRight",
                     time = 600,
                  }
               transition.cancel( )
               popup.hidePopup()
               storyboard.gotoScene( "scenetemplate", options )
               storyboard.removeAll( )
             end)
         elseif (currentScene == "scenes.game3") then]]

         else
             timer.performWithDelay(500, function()
                local options =
                   {
                      effect = "slideRight",
                      time = 600
                   }
                transition.cancel( )
                audio.stop()
                popup.hidePopup()
                storyboard.gotoScene( lastScene, options )
                storyboard.removeAll( )
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
   return true  --SEE NOTE BELOW
end
Runtime:addEventListener( "key", onKeyEvent )


storyboard.gotoScene("scenetemplate")