local storyboard = require ("storyboard")
local constants = require("constants")
local data = require("shapesData")
local popup = require("utils.popupTrain")

local scene = storyboard.newScene()

local _WELLDONETEXT = "Well done !"

local _BARHEIGHT = 0.2*constants.H
local _DELTA = 0.1*constants.W
local _FONTSIZE = constants.H / 14
local _MAXLEVEL = 15
local _SCALEVAL
local _ITEMSIZE
local _SHADOWSIZE
local _SPACINGANIMALS
local _SPACINGSHADOWS
local _PLATEXZERO 
local _PLATEYZERO 

local itemAmount = 		{1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 8} --items
local shadowAmount = 	{1, 2, 3, 2, 3, 4, 3, 4, 4, 6, 6, 6, 8, 8, 8}	--shadows
local rows = 			{1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2}	--rows

local animals = {}
local animalsImages = {}
local shadows = {}
local shadowsImages = {}

local level, onPlaces
local background, barBackground, plate, wellDoneLabel

local function animScaleBack (item)
	item.xScale = 1
	item.yScale = 1
end

local function animScaleOnDrag (item)
	item.xScale = _SCALEVAL
	item.yScale = _SCALEVAL
end

local function animOnPutOn(self)
	local function setToBig()
		transition.scaleTo(self, {xScale = _SCALEVAL, yScale = _SCALEVAL, time = 500})
	end	
	transition.scaleTo(self, {xScale = 0.8*_SCALEVAL, yScale = 0.8*_SCALEVAL, time = 300, onComplete=setToBig})
end

local function animOnPutOnShape(self)
	local function setToBig()
		transition.scaleTo(self, {xScale = 1, yScale = 1, time = 500})
	end	
	transition.scaleTo(self, {xScale = 0.8, yScale = 0.8, time = 300, onComplete=setToBig})
end

local function onAnimalDrag(event)
	local t = event.target
	local phase = event.phase
	animScaleOnDrag(t)
	if "began" == phase then 
		startX = t.x
		startY = t.y

		--bring the letter on top (just for being sure)
		local parent = t.parent
		parent:insert (t)
		display.getCurrentStage():setFocus(t)
		
		t.isFocus = true
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

	elseif "moved" == phase and t.isFocus then
		t.x = event.x-t.x0
		t.y = event.y-t.y0
	elseif "ended" == phase or "cancel" == phase then 
		local flag = false
		local index = 0
		--find which animal dragged
		for i = 1, #shadowsImages do
			for j = 1, #shadowsImages[i] do
				if shadowsImages[i][j].type == t.type then
					if math.abs(t.x - shadowsImages[i][j].x)<_DELTA and math.abs (t.y-shadowsImages[i][j].y)<_DELTA then
						t.x = shadowsImages[i][j].x
						t.y = shadowsImages[i][j].y
						onPlaces = onPlaces - 1
						animOnPutOn(t)
						animOnPutOnShape(shadowsImages[i][j])
						t:removeEventListener( "touch", onAnimalDrag )
					else 
						t.x = startX
						t.y = startY
						animScaleBack(t)
					end
				end
			end
		end		

		

		display.getCurrentStage():setFocus(nil)
		t.isFocus = false
		startX = nil
		startY = nil

		if onPlaces < 1 then
			if level == _MAXLEVEL then
				level = 0
				popup.showPopUp("You won !", "scenetemplate", "scenes.game2")
			else
				--audio.play( soundHarp )
				print ("you won")
				wellDoneLabel = display.newEmbossedText( _WELLDONETEXT, constants.CENTERX, constants.CENTERY, native.systemFont, 2*_FONTSIZE )
				transition.to (wellDoneLabel, 
					{
						time = 1000,
						y = 0,
						alpha = 0,
						xScale = 0.1,
						yScale = 0.1,
						onComplete = function ()
							display.remove (wellDoneLabel)
							wellDoneLabel = nil
							timer.performWithDelay( 300, function () storyboard.reloadScene( ) end )
						end
					})
			end
		end

	end
end

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

	level = 0

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
end

function scene:willEnterScene(event)	
	if level < _MAXLEVEL then
		level = level + 1
	end

	generateItems()
	onPlaces = itemAmount[level]
end

function scene:enterScene (event)
	local group = self.view


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
	_SCALEVAL = _SHADOWSIZE/_ITEMSIZE

	for i = 1, #animals do
		animalsImages[i] = display.newImage( data.animalsPath..animals[i]..data.format, i * _SPACINGANIMALS + (i-0.5)*_ITEMSIZE, barBackground.y)
		animalsImages[i].width = _ITEMSIZE
		animalsImages[i].height = _ITEMSIZE
		animalsImages[i].type = animals[i]
		animalsImages[i]:addEventListener( "touch", onAnimalDrag )
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

	for i = 1, #shadowsImages do
		for j = 1, #shadowsImages[i] do
			display.remove (shadowsImages[i][j])
			shadowsImages[i][j] = nil			
		end
	end
	popup.hidePopUp()
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene