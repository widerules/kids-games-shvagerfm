local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")

local scene = storyboard.newScene()

function scene:createScene(event)
	local group = self.view
	local background = display.newImage ("images/bghome.jpg", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	local btnPlay = widget.newButton
		{
			width = constants.W/4,
			height = constants.W/8,
			x = constants.CENTERX,
			y = constants.CENTERY,
			defaultFile = "images/play.png",
			overFile = "images/playover.png",
			onRelease = function ()
				storyboard.gotoScene("scenes.menu")
			end
		}
		btnPlay.y = constants.CENTERY - 0.5*btnPlay.height
	group:insert(btnPlay)

    local btnMore = widget.newButton
        {
            width = constants.W/4,
            height = constants.W/10,
            x = constants.CENTERX,
            y = constants.CENTERY,
            defaultFile = "images/moregames.png",
            overFile = "images/moregamesover.png",
            onRelease = function ()
                storyboard.gotoScene( "scenes.more_games" )
            end

        }
    btnMore.y = constants.CENTERY + btnMore.height
    group:insert(btnMore)



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