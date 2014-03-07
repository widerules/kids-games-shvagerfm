local storyboard = require( "storyboard")
local widget = require("widget")
local constants = require( "constants")

local scene = storyboard.newScene()

local _IMAGESIZE = 0.3*constants.H

local layers = {}
local groups = {}
local hogs = {}

local function fillWithHogs(group)
	group:insert (layers[1])
	group:insert (layers[2])
	group:insert (layers[3])
	group:insert (layers[4])

	group:insert (groups[1])

	group:insert (layers[5])

	group:insert (groups[2])

	group:insert (layers[6])

	group:insert (groups[3])

	group:insert (layers[7])
	group:insert (layers[8])

	group:insert (groups[4])

	group:insert (layers[9])
	group:insert (layers[10])
	group:insert (layers[11])
	group:insert (layers[12])

	group:insert (groups[5])

	group:insert (layers[13])
	group:insert (layers[14])

	hogs[1] = display.newImage("images/hog.png", constants.W-_IMAGESIZE/1.5, constants.CENTERY+_IMAGESIZE/1.5)
	hogs[1].width = _IMAGESIZE/1.2
	hogs[1].height = _IMAGESIZE/1.2
	hogs[1].xScale = -1
	groups[5]:insert(hogs[1])

	--hogs[2]	
end

function scene:createScene (event)
	local group = self.view

	for i = 1, 14, 1 do
		layers[i] = display.newImage("images/layer"..i..".png", constants.CENTERX, constants.CENTERY)
		layers[i].height = constants.H
		layers[i].width = constants.W
--		group:insert (layers[i])		
	end

	for i = 1, 5, 1 do
		groups[i] = display.newGroup();
	end

	fillWithHogs(group)
--[[
	group:insert(4, groups[1])
	group:insert(7, group[2])
	group:insert(9, groups[3])
	group:insert(12, groups[4])
	group:insert(17, groups[5])
]]
	
end
	
function scene:enterScene(event)
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