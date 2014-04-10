local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")

local scene = storyboard.newScene()

function scene:createScene(event)
	local group = self.view

	btnPlay = widget.newButton
		{
			width = constants.W/3,
			height = constants.W/6,
			x = constants.CENTERX,
			y = constants.CENTERY,
			defaultFile = "images/button.png",
			overFile = "images/pbutton.png",
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