local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )

local scene = storyboard.newScene()

function scene:createScene(event)
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