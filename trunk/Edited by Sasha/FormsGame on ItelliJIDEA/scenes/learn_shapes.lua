local composer = require("composer")
local widget = require("widget")
local constants = require ("constants")
local data = require( "data.shapesData")
local sam = require "utils.sam"

local scene = composer.newScene()

local _BTNSIZE = 0.1*constants.W
local _IMAGESIZE = 0.4*constants.W
local _FONTSIZE = 0.07*constants.H

local index = 1

local background, image, itemName
local nextButton, previousButton, homeButton

local soundName
local function onHomeButtonTapped (event)
	composer.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
end

local function onPreviousButtonTapped (event)
	if index > 1 then
		index = index - 1
	else
		index = #data.shapes
	end
    composer.gotoScene("scenes.learn_shapes")
end

local function onNextButtonTapped (event)
	
		if index < #data.shapes then
			index = index + 1
		else
			index = 1
		end

        composer.gotoScene("scenes.learn_shapes")
end

local function sayName()
		soundName = audio.loadSound( "sounds/"..data.shapes[index]..".mp3" )
		audio.play( soundName )
end

function scene:create(event)
	local group = self.view

	background = display.newImage("images/bg".. math.random(1, 6) .. ".jpg", constants.CENTERX, constants.CENTERY)
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

function scene:show(event)
	local group = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        sam.show(constants.W * 0.15, 1)
    elseif ( phase == "did" ) then
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


    end
end

function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        transition.cancel( )
        audio.dispose( soundName )
    elseif (phase == "did") then
        image:removeEventListener( "tap",  sayName)

        display.remove(image)
        display.remove( itemName )

        soundName = nil
        image = nil
        itemName = nil


    end
end

function scene:destroy(event)
	display.remove(homeButton)
	display.remove(previousButton)
	display.remove(nextButton)

    homeButton = nil
    previousButton = nil
	nextButton = nil

    sam.hide()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene