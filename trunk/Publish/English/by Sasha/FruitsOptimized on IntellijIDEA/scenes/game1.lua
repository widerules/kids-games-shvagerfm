local storyboard = require("storyboard")
local widget = require("widget")
local constants = require ("constants")
local data = require( "data.studyData")

local scene = storyboard.newScene()

_GAME = 1

local _BTNSIZE = 0.1*constants.W
local _IMAGESIZE = 0.3*constants.W
local _FONTSIZE = 0.07*constants.H

local index = 1
local isVegetables = true

--local vegetables, fruits

local background, image, itemName
local nextButton, previousButton, vegetablesButton, fruitsButton, homeButton

local soundName

local function toTitle()
	local options = 
	{
		effect = "slideLeft",
		time = 400
	}
	storyboard.gotoScene("scenes.gametitle", options)
	storyboard.removeScene( "scenes.game1" )
end

local function onHomeButtonTapped (event)
	toTitle()
end

local function onPreviousButtonTapped (event)
	if index > 1 then
		index = index - 1
	elseif isVegetables == true then
		isVegetables = false
		index = #data.fruits
	else
		isVegetables = true
		index = #data.vegetables
	end
	storyboard.reloadScene()
end

local function onNextButtonTapped (event)
	if isVegetables then
		if index < #data.vegetables then
			index = index + 1
		else
			index = 1
			isVegetables = false
		end
	else
		if index < #data.fruits then
			index = index + 1
		else
			index = 1
			isVegetables = true
		end
	end
	storyboard.reloadScene()
end

local function onVegetablesButtonClicked (event)
	index = 1
	isVegetables = true

	storyboard.reloadScene()

	--play sound of Vegetables Group
end

local function onFruitsButtonClicked (event)
	index = 1
	isVegetables = false

	storyboard.reloadScene()

	--play sound of Fruits Group
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage ("images/background1.jpg", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	homeButton = widget.newButton
	{
		x = _BTNSIZE/2,
		y = _BTNSIZE/2,
		defaultFile = "images/back.png",
		overFile = "images/back.png",
		width = _BTNSIZE,
		height = _BTNSIZE,
		onRelease = onHomeButtonTapped
	}
	group:insert(homeButton)

	previousButton = widget.newButton
	{
		x = constants.CENTERX - _IMAGESIZE, 
		y = constants.CENTERY,
		defaultFile = "images/left.png",
		overFile = "images/left.png",
		width = _BTNSIZE,
		height = _BTNSIZE
	}
	previousButton:addEventListener( "tap" , onPreviousButtonTapped )
	group:insert(previousButton)

	nextButton = widget.newButton
	{
		x = constants.CENTERX + _IMAGESIZE,
		y = constants.CENTERY,
		defaultFile = "images/right.png",
		overFile = "images/right.png",
		width = _BTNSIZE,
		height = _BTNSIZE
	}
	nextButton:addEventListener( "tap", onNextButtonTapped )
	group:insert(nextButton)

	vegetablesButton = widget.newButton
	{
		x = constants.W - _BTNSIZE,
		y = _BTNSIZE/2,
		defaultFile = "images/vegbtn.png",
		overFile = "images/vegbtn.png",
		width = 2 * _BTNSIZE,
		height = _BTNSIZE
	}
	vegetablesButton:addEventListener( "tap", onVegetablesButtonClicked )
	group:insert(vegetablesButton)

	fruitsButton = widget.newButton
	{
		x = constants.W - _BTNSIZE,
		y = constants.H - _BTNSIZE/2,
		defaultFile = "images/frtbtn.png",
		overFile = "images/frtbtn.png",
		width = 2 * _BTNSIZE,
		height =  _BTNSIZE
	}
	fruitsButton:addEventListener( "tap", onFruitsButtonClicked )
	group:insert(fruitsButton)	
end

function scene:enterScene(event)
	local group = self.view

	if isVegetables == true then
		soundName = audio.loadSound( "sounds/"..data.vegetables[index]..".mp3" )
		audio.play( soundName )
		image = display.newImage (data.pathToVegetables..data.vegetables[index]..data.format, constants.CENTERX, constants.CENTERY)
		image.width = _IMAGESIZE
		image.height = _IMAGESIZE
		image.xScale, image.yScale = 0.3, 0.3
		transition.to( image, {time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
		group:insert(image)

		itemName = display.newText (data.vegetablesEN[index], constants.CENTERX, constants.CENTERY + _IMAGESIZE/2 + _FONTSIZE, native.systemFont, _FONTSIZE)
		itemName:setFillColor( 0, 0, 0 )		
		group:insert(itemName)

		--load corresponding sound
	else
		soundName = audio.loadSound( "sounds/"..data.fruits[index]..".mp3" )
		audio.play( soundName )
		image = display.newImage (data.pathToFruits..data.fruits[index]..data.format, constants.CENTERX, constants.CENTERY)
		image.width = _IMAGESIZE
		image.height = _IMAGESIZE
		image.xScale, image.yScale = 0.3, 0.3
		transition.to( image, {time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
		group:insert(image)

		itemName = display.newText (data.fruitsEN[index], constants.CENTERX, constants.CENTERY + _IMAGESIZE/2 + _FONTSIZE, native.systemFont, _FONTSIZE)
		itemName:setFillColor( 0, 0, 0 )		
		group:insert(itemName)

		--load corresponding sound
	end

	--play sound
end

function scene:exitScene(event)
	transition.cancel( )
	display.remove(image)
	display.remove(itemName)

end

function scene:destroyScene(event)
	display.remove( homeButton )
	display.remove( previousButton )
	display.remove( nextButton )
	display.remove( vegetablesButton )
	display.remove( fruitsButton )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene