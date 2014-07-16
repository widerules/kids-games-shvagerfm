local storyboard = require("storyboard")
local widget = require("widget")
local constants = require ("constants")
local data = require( "data.shapesData")

local scene = storyboard.newScene()

local _BTNSIZE = 0.1*constants.W
local _IMAGESIZE = 0.4*constants.W
local _FONTSIZE = 0.07*constants.H

local index = 1

print("game1")

local background, image, itemName
local nextButton, previousButton, homeButton

local soundName
local function onHomeButtonTapped (event)
	storyboard.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
	storyboard.removeScene( "scenes.game1" )
end

local function onPreviousButtonTapped (event)
	if index > 1 then
		index = index - 1
	else
		index = #data.shapes
	end
	storyboard.reloadScene()
end

local function onNextButtonTapped (event)
	
		if index < #data.shapes then
			index = index + 1
		else
			index = 1
		end
	
	storyboard.reloadScene()
end
local function sayName()
		soundName = audio.loadSound( "sounds/"..data.shapes[index]..".mp3" )
		audio.play( soundName )
	end

function scene:createScene(event)
	local group = self.view

	background = display.newImage ("images/background.jpg", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	homeButton = widget.newButton
	{
		x = _BTNSIZE/2,
		y = _BTNSIZE/2,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png",
		width = _BTNSIZE,
		height = _BTNSIZE,
		onRelease = onHomeButtonTapped
	}
	
	group:insert(homeButton)

	previousButton = widget.newButton
	{
		x = constants.CENTERX - _IMAGESIZE, 
		y = constants.CENTERY,
		defaultFile = "images/prev.png",
		overFile = "images/prev.png",
		width = _BTNSIZE,
		height = _BTNSIZE,
		onRelease = onPreviousButtonTapped
	}
	
	group:insert(previousButton)

	nextButton = widget.newButton
	{
		x = constants.CENTERX + _IMAGESIZE,
		y = constants.CENTERY,
		defaultFile = "images/next.png",
		overFile = "images/next.png",
		width = _BTNSIZE,
		height = _BTNSIZE,
		onRelease = onNextButtonTapped
	}
	
	group:insert(nextButton)

end



function scene:enterScene(event)
	local group = self.view
	
		sayName()
		image = display.newImage ("images/"..data.shapes[index]..".png", constants.CENTERX, constants.CENTERY)
		image.width = _IMAGESIZE
		image.height = _IMAGESIZE
		image.xScale, image.yScale = 0.3, 0.3
		transition.to( image, {time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
		group:insert(image)
		image:addEventListener( "tap",  sayName)

		itemName = display.newText (data.shapes[index], constants.CENTERX, constants.CENTERY + _IMAGESIZE/2 + _FONTSIZE, native.systemFont, _FONTSIZE)
		itemName:setFillColor( 0, 0, 0 )		
		group:insert(itemName)

	--play sound
end

function scene:exitScene(event)
	image:removeEventListener( "tap",  sayName)
	transition.cancel( )
	audio.dispose( soundName )
	soundName = nil
	display.remove(image)
	image = nil
	display.remove( itemName )
	itemName = nil
end

function scene:destroyScene(event)
	display.remove(homeButton)
	homeButton = nil
	display.remove(previousButton)
	previousButton = nil
	display.remove(nextButton)
	nextButton = nil

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene