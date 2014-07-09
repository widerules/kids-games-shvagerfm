local storyboard = require "storyboard"
local constants = require ( "constants" )
local rate = require( "utils.rate" )
local memoryViewer = require ("utils.memoryViewer")
local popup = require("utils.popup")

shouldWork = false

memoryViewer.create(constants.W/2, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

storyboard.purgeOnSceneChange = true

local function exit ()
	rate.init()
end

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName

   if ( ("back" == keyName or "deleteBack" == keyName) and phase == "up" ) then
      local currentScene = storyboard.getCurrentSceneName()
      local lastScene = storyboard.getPrevious()
         
         if ( currentScene == "scenetemplate") then
            exit()
       
         --[[elseif (currentScene == "scenes.gametitle" or currentScene == "scenes.gametitle2") then
            timer.performWithDelay(300, function()
               popup.hidePopup()
               local options =
                  {
                     effect = "slideRight",
                     time = 500
                  }
               storyboard.gotoScene( "scenetemplate", options )
               storyboard.removeAll( )
            end)]]
         else
            timer.performWithDelay(500, function()
                popup.hidePopup()
                local options =
                   {
                      effect = "slideRight",
                      time = 500
                   }
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

storyboard.gotoScene( "scenetemplate" )