----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
local admob = require( "admob" )
------------------------------------------

----------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
--variables
local background, btnOne, btnTwo, btnThree, mikki, minni, sun, kidsAnimals, moreGames
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local bWidth = _W/2
local bHeight = bWidth/3


local bgsound = audio.loadSound( "sounds/bgsound.wav" )
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- functions
-----------------------------

local function soundOffOn()
	if _SOUNDON == true then
	_SOUNDON = false
	print(_SOUNDON)
	audio.pause( bgsound )

else
	_SOUNDON = true
	print(_SOUNDON)
	audio.resume( bgsound )
	end
end
-------------------------------
local function getAnimalsForKids()
	print("lin to app")
	system.openURL( "market://details?id=com.shvagerfm.AnimalsForKids" )
end
local function gameFirst()
	storyboard.gotoScene( "scenes.gamefirst", "slideLeft", 500 )
	storyboard.removeScene("scenetemplate")
end 
local function gameSecond()
	storyboard.gotoScene( "scenes.gamesecond", "slideLeft", 500 )
	storyboard.removeScene("scenetemplate")

end 
local function gameThree()	
	storyboard.gotoScene( "scenes.gamelast", "crossFade", 300 )
	storyboard.removeScene("scenetemplate")
end 
local function gameFour()
	storyboard.gotoScene( "scenes.game3", "slideLeft", 500 )
	storyboard.removeScene("scenetemplate")
end 

function moveBack()
	transition.to( sun, {rotation = -20, time = 3000, transition = easing.inOutCubic, onComplete = moveForward})
end
function moveForward()
transition.to( sun, {rotation = 20, time = 3000, transition = easing.inOutCubic, onComplete = moveBack})
end
local function sunMoving(self, event)
	if event.phase == "ended" or event.phase == "cancelled" then
		
		if _SOUNDON == true then
			_SOUNDON = false
			print(_SOUNDON)
			audio.stop()
			sun:pause()
			print("pause")
		else
			_SOUNDON = true
			print(_SOUNDON)
			audio.play( bgsound )
			print("play")
			sun:play()
		end
		return true	-- indicates successful touch
	end
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	background = display.newImage( "images/background.png", centerX, centerY, _W, _H)
	group:insert( background )
	
	mikki = display.newImage("images/miki.png", _W/6, 3*centerY/2, _W/10, _H/10)
	mikki.width = _W/6
	mikki.height = _H/2
	group:insert( mikki )
	minni = display.newImage("images/mini.png", 5*_W/6, 3*centerY/2, _W/10, _H/10)
	minni.width = _W/6
	minni.height = _H/2
	group:insert( minni )
	btnOne = widget.newButton
		{
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_1",
		    label = "Learn shapes",
		    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = _H/12,
		    emboss = true,
		    onRelease = gameFirst,
		    
		}
	btnOne.x = centerX

	btnTwo = widget.newButton
		{	
			top = _H/4,
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_2",
		    label = "Find",
		    labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = _H/12,
		    emboss = true,
		    onRelease = gameSecond,
		    
		}
	btnTwo.x = centerX
	

	btnThree = widget.newButton
		{
			top = _H/2,
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_3",
		    label = "Find pairs",
		    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = _H/12,
		    emboss = true,
		    onRelease = gameThree,
		    
		}
	btnThree.x = centerX

	btnFour = widget.newButton
		{
			top = 3*_H/4,
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_3",
		    label = "Place shapes",
		    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = _H/12,
		    emboss = true,
		    onRelease = gameFour,
		    
		}
	btnFour.x = centerX
	
	admob.init()
	
	group:insert( btnOne)
	group:insert( btnTwo)
	group:insert( btnThree)
	group:insert( btnFour)	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	admob.showAd( "interstitial" )
	if _SOUNDON == true then
	audio.play( bgsound )
	end

	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------

	kidsAnimals = display.newImage( "images/animals.png", centerX, centerY, _H/6, _H/6)
	kidsAnimals.width = _H/4
	kidsAnimals.height = kidsAnimals.width
	kidsAnimals.x = _W - kidsAnimals.width
	kidsAnimals.y = kidsAnimals.height
	group:insert( kidsAnimals )
	kidsAnimals:addEventListener("tap", getAnimalsForKids )

	moreGames = display.newEmbossedText( "More games", 0, 0, native.systemFont, _H/20 )
	moreGames.y = _H/16
	moreGames.x = kidsAnimals.x
	moreGames:setFillColor( 1, 0.6, 0 )
	group:insert(moreGames)
	

	local sheetData = {
	width = 300,
	height = 249,
	numFrames = 4,
	sheetContentWidth = 600,
	sheetContentHeight = 498
}
	local shapeSheet = graphics.newImageSheet("images/sunsheet.png", sheetData)
		local sequenceData = {
		{
		name = "sunny",
		start = 1,
		count = 4,
		--frames = {1, 2, 3, 4},
		time = 500,
		loopCount=0,
		loopDirection = bounce,
		}
	}
	sun = display.newSprite( shapeSheet, sequenceData)
	sun.x = sun.width/2
	sun.y = sun.height/2
	sun:setSequence("sunny")
	if _SOUNDON == true then
	sun:play()
	end
	group:insert(sun)
	moveForward()
	sun.touch = sunMoving
	sun:addEventListener("touch",  sun)
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	audio.stop()
	audio.dispose( bgsound )
	bgsound = nil

	if (sun) then
		sun:removeEventListener("touch",  sun)
	end
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene