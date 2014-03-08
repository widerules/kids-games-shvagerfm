local storyboard = require( "storyboard")
local widget = require("widget")
local constants = require( "constants")

local scene = storyboard.newScene()

local _HOGIMAGESIZE = 0.15*constants.H
local _MUSHIMAGESIZE = 0.15*constants.H
local _BERRYIMAGESIZE = 0.15*constants.H

local _BERRYPATH = "images/berry.png"
local _HOGPATH = "images/hog.png"
local _MUSHPATH = "images/grib"
local _FORMAT = ".png"

local layers = {}
local groups = {}
local hogs = {}
local mushrooms ={}
local berries = {}

--here begins block, which I will move to data.lua
local hogsGroups = { 5, 5, 2, 4, 3, 1, 5}
local hogsScale = { -1, -1, 1, -1, -1, 1, 1}
local hogsSizes = { 1.5, 1, 1, 1, 1, 1, 1}
local hogsPositions = 
{
	x = 
	{
		constants.W-_HOGIMAGESIZE/0.75,			--1
		constants.CENTERX-constants.W/30,		--2
		constants.CENTERX-_HOGIMAGESIZE/0.65,	--3
		constants.W - constants.CENTERX/1.75,	--4
		_HOGIMAGESIZE/0.85,							--5
		constants.CENTERX-_HOGIMAGESIZE*2.6,	--6
		hogsSizes[7]*_HOGIMAGESIZE				--7
	},
	y = 
	{
		constants.CENTERY+_HOGIMAGESIZE/0.75,   		--1
		constants.CENTERY+2*_HOGIMAGESIZE+constants.W/70,--2
		constants.CENTERY+_HOGIMAGESIZE/2,			--3
		constants.CENTERY,							--4
		constants.CENTERY+_HOGIMAGESIZE/1.25,			--5
		constants.CENTERY-_HOGIMAGESIZE/2, 			--6
		constants.H-1.1*hogsSizes[7]*_HOGIMAGESIZE		--7
	}
}

local mushroomsGroups = {6, 5, 4, 5, 3, 2, 1}
local mushroomsScale = {1, 1, 1, 1, -1, 1, -1}
local mushroomsSizes = {1.2, 0.75, 1, 0.75, 1, 1, 0.75}
local mushroomsTypes = {1, 2, 1, 2, 1, 1, 2}
local mushroomsPositions = 
{
	x =
	{
		constants.CENTERX+_MUSHIMAGESIZE*1.6,	--1
		constants.CENTERX- _MUSHIMAGESIZE*1.4,	--2
		constants.CENTERX+_MUSHIMAGESIZE*2.25,	--3
		_MUSHIMAGESIZE*1.8,						--4
		_MUSHIMAGESIZE*1.8,						--5
		constants.CENTERX - _MUSHIMAGESIZE*2,	--6
		constants.CENTERX+_MUSHIMAGESIZE*1.3	--7		
	},
	y = 
	{
		constants.H- _MUSHIMAGESIZE/1.3,		--1
		constants.H- _MUSHIMAGESIZE/1.1,		--2
		constants.CENTERY+_MUSHIMAGESIZE,		--3
		constants.H- _MUSHIMAGESIZE,			--4
		constants.CENTERY+_MUSHIMAGESIZE*0.75,	--5
		constants.CENTERY - _MUSHIMAGESIZE*0.5,	--6
		constants.CENTERY - _MUSHIMAGESIZE/8	--7
	}
}

local berriesGroups = {5, 4, 3, 5, 1, 3, 2}
local berriesSizes = {1, 1, 1, 1, 0.75, 1, 1}
local berriesPosition = 
{
	x = 
	{
		constants.W - _BERRYIMAGESIZE*2, 		--1
		constants.CENTERX,						--2
		constants.CENTERX- _BERRYIMAGESIZE*2.3,	--3
		_BERRYIMAGESIZE*1.5,					--4
		constants.CENTERX*1.1,					--5
		constants.CENTERX*1.45,					--6
		constants.CENTERX*0.5 					--7
	},
	y = 
	{
		constants.CENTERY+_BERRYIMAGESIZE*1.2,	--1
		constants.CENTERY+_BERRYIMAGESIZE/1.75,	--2
		constants.CENTERY+1.5*_BERRYIMAGESIZE,	--3
		constants.H - _BERRYIMAGESIZE,			--4
		constants.CENTERY- _BERRYIMAGESIZE/2,	--5
		constants.CENTERY- _BERRYIMAGESIZE/2.3,	--6
		constants.CENTERY 						--7
	}	
}
--here it finishes

local function fillWithHogs(group)
	for i = 1, 5, 1 do
		groups[i] = display.newGroup();
	end	
	
	group:insert(4, groups[1])
	group:insert(7, groups[2])
	group:insert(9, groups[3])
	group:insert(12, groups[4])
	group:insert(17, groups[5])

	for i = 1, 7, 1 do
		hogs[i]	= display.newImage (_HOGPATH, hogsPositions.x[i], hogsPositions.y[i])
		hogs[i].width = _HOGIMAGESIZE*hogsSizes[i]
		hogs[i].height = _HOGIMAGESIZE*hogsSizes[i]
		hogs[i].xScale = hogsScale[i]
		groups[hogsGroups[i]]:insert (hogs[i])
	end	
end

local function fillWithMushrooms(group)
	for i = 1, 6, 1 do
		groups[i] = display.newGroup();
	end

	group:insert(4, groups[1])
	group:insert(5, groups[2])
	group:insert(9, groups[3])
	group:insert(13, groups[4])
	group:insert(17, groups[5])
	group:insert(19, groups[6])

	for i = 1, 7, 1 do
		mushrooms[i] = display.newImage (_MUSHPATH..mushroomsTypes[i].._FORMAT, mushroomsPositions.x[i], mushroomsPositions.y[i])
		mushrooms[i].width = _MUSHIMAGESIZE*mushroomsSizes[i]
		mushrooms[i].height = _MUSHIMAGESIZE*mushroomsSizes[i]
		mushrooms[i].xScale = mushroomsScale[i]
		groups[mushroomsGroups[i]]:insert(mushrooms[i])
	end
end

local function fillWithBerries(group)
	for i = 1, 5, 1 do
		groups[i] = display.newGroup( )
	end

	group:insert(4, groups[1])
	group:insert(7, groups[2])
	group:insert(11, groups[3])
	group:insert(13, groups[4])
	group:insert(16, groups[5])

	for i = 1, 7, 1 do
		berries[i] = display.newImage(_BERRYPATH, berriesPosition.x[i], berriesPosition.y[i])
		berries[i].width = _BERRYIMAGESIZE * berriesSizes[i]
		berries[i].height = _BERRYIMAGESIZE * berriesSizes[i]
		groups[berriesGroups[i]]:insert(berries[i])
	end
end

function scene:createScene (event)
	local group = self.view

	for i = 1, 14, 1 do
		layers[i] = display.newImage("images/layer"..i..".png", constants.CENTERX, constants.CENTERY)
		layers[i].height = constants.H
		layers[i].width = constants.W
		group:insert (layers[i])		
	end	

	--depend on the value of some variable one of the following funcs will be called
	--fillWithHogs(group)
	--fillWithMushrooms(group)
	fillWithBerries(group)	
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