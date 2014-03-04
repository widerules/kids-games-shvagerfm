-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require "storyboard"

--global center & heigh-width
_CENTERX = display.contentCenterX
_CENTERY = display.contentCenterY
_W = display.contentWidth
_H = display.contentHeight
-- load scenetemplate.lua
storyboard.gotoScene( "scenetemplate" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):