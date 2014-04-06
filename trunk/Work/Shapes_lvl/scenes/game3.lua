local storyboard = require ("storyboard")
local constants = require("constants")
local data = require("shapesData")

local scene = storyboard.newScene()

local _BARHEIGHT = 0.2*constants.H
local _ITEMSIZE
local _SHADOWSIZE
local _SPACINGANIMALS
local _SPACINGSHADOWS
local _PLATEXZERO 
local _PLATEYZERO 

local itemAmount = 		{1, 2, 4, 6, 8} --items
local shadowAmount = 	{2, 3, 6, 6, 8}	--shadows
local rows = 			{1, 1, 2, 2, 2}	--rows

local animals = {}
local animalsImages = {}
local shadows = {}
local shadowsImages = {}

local level
local background, barBackground, plate

local function generateItems()
	local tmpindex = 1
	local items = table.copy(data.animals)

	for i = 1, itemAmount[level] do
		tmpindex = math.random(1, #items)
		table.insert( animals, items[tmpindex] )
		table.insert( shadows, items[tmpindex])
		table.remove( items, tmpindex)
	end

	for i = 1, shadowAmount[level]-itemAmount[level] do
		tmpindex = math.random(1, #items)
		table.insert(shadows, items[tmpindex])
		table.remove (items, tmpindex)
	end
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage ("images/background3.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	barBackground = display.newImage ("images/bar.png", constants.CENTERX, constants.H - _BARHEIGHT/2)
	barBackground.width = constants.W
	barBackground.height = _BARHEIGHT
	group:insert(barBackground)

	plate = display.newImage ("images/plate.png", constants.CENTERX, constants.CENTERY - _BARHEIGHT/3)
	plate.width = 0.95*constants.W
	plate.height = 0.7*constants.H
	group:insert (plate)

	level = 3

	_ITEMSIZE = barBackground.height*0.95	
	_SPACINGANIMALS = (constants.W-_ITEMSIZE*itemAmount[level])/(itemAmount[level]+1)
	_PLATEXZERO = plate.x - plate.width/2
	_PLATEYZERO = plate.y - plate.height/2

	if plate.height / rows[level] < plate.width / (shadowAmount[level]/rows[level]) then
		_SHADOWSIZE = plate.height / (rows[level]+1)
		_SPACINGY = _SHADOWSIZE / rows[level]
		_SPACINGSHADOWS = (plate.width - _SHADOWSIZE*shadowAmount[level]/rows[level]) / (shadowAmount[level]/rows[level]+1)
	else
		_SHADOWSIZE = plate.width / (shadowAmount[level]/rows[level]+1)
		_SPACINGY = (plate.height - _SHADOWSIZE*rows[level])/(rows[level]+1)
		_SPACINGSHADOWS = _SHADOWSIZE / (shadowAmount[level]/rows[level]+1)
	end
end

function scene:willEnterScene(event)	
	generateItems()
end

function scene:enterScene (event)
	local group = self.view

	for i = 1, #animals do
		animalsImages[i] = display.newImage( data.animalsPath..animals[i]..data.format, i * _SPACINGANIMALS + (i-0.5)*_ITEMSIZE, barBackground.y)
		animalsImages[i].width = _ITEMSIZE
		animalsImages[i].height = _ITEMSIZE
		animalsImages[i].type = animals[i]
		group:insert(animalsImages[i])
	end

	for i = 1, shadowAmount[level]/rows[level] do
		shadowsImages[i] = {}
		for j = 1, rows[level] do
			local index = math.random(1, #shadows)
			shadowsImages[i][j] = display.newImage (data.shapesPath..shadows[index]..data.format, _PLATEXZERO + i * _SPACINGSHADOWS + (i-0.5) * _SHADOWSIZE, j * _SPACINGY + (j - 0.5)* _SHADOWSIZE)
			shadowsImages[i][j].width = _SHADOWSIZE
			shadowsImages[i][j].height = _SHADOWSIZE
			shadowsImages[i][j].type = shadows[index]
			group:insert (shadowsImages[i][j])
			table.remove (shadows, index)
		end
	end
	
end

function scene:exitScene(event)
	while #animals > 0 do
		table.remove(animals)
	end
	while #shadows > 0 do
		table.remove(shadows)
	end
	while #animalsImages > 0 do

		display.remove(animalsImages[#animalsImages])
		table.remove (animalsImages, #animalsImages)
	end
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene