local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )

local scene = storyboard.newScene()

function scene:createScene(event)
	local group = self.view
	local background = display.newImage ("images/bghome.png", constants.CENTERX, constants.CENTERY)
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
				storyboard.gotoScene("scenes.gametitle", {params = {ind = 1}})
			end
		}
		btnPlay.y = constants.CENTERY - 0.5*btnPlay.height
	group:insert(btnPlay)
	--local btnMore = widget.newButton
	--	{
	--		width = constants.W/3,
	--		height = constants.W/6,
	--		x = constants.CENTERX - constants.W/6,
	--		y = constants.CENTERY ,
	--		defaultFile = "images/moregames.png",
	--		overFile = "images/moregamesover.png",
	--		onRelease = function ()
	--			storyboard.gotoScene("scenes.gametitle", {params = {ind = 1}})
	--		end

	--	}
	--	btnMore.y = constants.CENTERY + 1.2*btnMore.height
	--	group:insert(btnMore)
	admob.init()
end

function scene:enterScene (event)
	admob.showAd( "interstitial" )
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