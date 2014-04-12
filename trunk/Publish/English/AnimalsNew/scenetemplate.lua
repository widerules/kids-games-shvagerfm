local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")

local scene = storyboard.newScene()

function scene:createScene(event)
	local group = self.view

	local background = display.newImage ("images/bgmain.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	btnPlay = widget.newButton
		{
			width = constants.W/3,
			height = constants.W/6,
			x = constants.CENTERX,
			y = constants.CENTERY,
			defaultFile = "images/homeplay.png",
			overFile = "images/homeplayover.png",
			onRelease = function ()
				storyboard.gotoScene("scenes.gametitle", {params = {ind = 1}})
			end

		}
	group:insert(btnPlay)
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