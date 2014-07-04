local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
local admob = require( "utils.admob" )


local background, btnOne, btnTwo, btnThree, btnFour, btnFive, btnSix, btnSeven, mikki, minni, sun, kidsAnimals, moreGames
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local bWidth = 0.33*_W
local bHeight = 0.24*bWidth
local sizeFont = 0.07*_H
local sizeBtn

local bgsound
-- functions
-----------------------------

local function soundOffOn()
	if _SOUNDON == true then
	_SOUNDON = false
	audio.pause( bgsound )
else
	_SOUNDON = true
	audio.resume( bgsound )
	end
end
-------------------------------
local function getAnimalsForKids()
				storyboard.gotoScene("scenes.more_games")
end
local function gameFirst()
	storyboard.gotoScene( "scenes.game1", "slideLeft", 100 )
	storyboard.removeScene("scenes.scenetemplate")
end 
local function gameSecond()
	storyboard.gotoScene( "scenes.game2", "slideLeft", 100 )
	storyboard.removeScene("scenes.scenetemplate")

end 
local function gameThree()	
	storyboard.gotoScene( "scenes.gamelast", "crossFade", 100 )
	storyboard.removeScene("scenes.scenetemplate")
end 
local function gameFour()
	storyboard.gotoScene( "scenes.game5", "slideLeft", 100 )
	storyboard.removeScene("scenes.scenetemplate")
end 
local function gameFive()
	storyboard.gotoScene( "scenes.game3new", "slideLeft", 100 )
	storyboard.removeScene("scenes.scenetemplate")
end
local function gameSix()
    storyboard.gotoScene( "scenes.game6", "slideLeft", 100 )
    storyboard.removeScene("scenes.scenetemplate")
end
local function gameSeven()
    storyboard.gotoScene( "scenes.game7", "slideLeft", 100 )
    storyboard.removeScene("scenes.scenetemplate")
end

function moveBack()
	transition.to( sun, {rotation = -20, time = 3000, transition = easing.inOutCubic, onComplete = moveForward})
end
function moveForward()
transition.to( sun, {rotation = 20, time = 3000, transition = easing.inOutCubic, onComplete = moveBack})
end

local function sayMikki(event)
	if event.phase == "ended" or event.phase == "cancelled" then
	local soundMikki = audio.loadSound( "sounds/mikkie1.mp3")
	audio.play( soundMikki )
	end
end
local function sayMinni(event)
	if event.phase == "ended" or event.phase == "cancelled" then
	local soundMinni = audio.loadSound( "sounds/minnie1.mp3")
	audio.play( soundMinni )
end
end
local function sunMoving(self, event)
	if event.phase == "ended" or event.phase == "cancelled" then
		
		if _SOUNDON == true then
			_SOUNDON = false
			audio.stop()
			sun:pause()
		else
			_SOUNDON = true
			audio.play( bgsound )
			sun:play()
		end
		return true	-- indicates successful touch
	end
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	background = display.newImage( "images/background.jpg", centerX, centerY, _W, _H)
	group:insert( background )
	
	
	btnOne = widget.newButton
		{
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_1",
		    label = "Learn shapes",
		    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = sizeFont,
		    emboss = true,
		    onRelease = gameFirst,
		    
		}
	btnOne.x = centerX

	btnTwo = widget.newButton
		{	
			top = 0.25*_H,
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_2",
		    label = "Find shapes",
		    labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = sizeFont,
		    emboss = true,
		    onRelease = gameSecond,
		    
		}
	btnTwo.y = btnOne.y + bHeight
	btnTwo.x = centerX
	

	btnThree = widget.newButton
		{
			top = 0.5*_H,
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_3",
		    label = "Find pairs",
		    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = sizeFont,
		    emboss = true,
		    onRelease = gameThree,
		    
		}
	btnThree.y = btnTwo.y + bHeight
	btnThree.x = centerX

	btnFour = widget.newButton
		{
			top = 0.75*_H,
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_3",
		    label = "Memory pairs",
		    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = sizeFont,
		    emboss = true,
		    onRelease = gameFour,
		    
		}
	btnFour.x = centerX
	btnFour.y = btnThree.y + bHeight


	btnFive = widget.newButton
		{
			top = 0.75*_H,
		    width = bWidth,
		    height = bHeight,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_3",
		    label = "Shadows",
		    labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.9 } },
		    fontSize = sizeFont,
		    emboss = true,
		    onRelease = gameFive,
		    
		}
	btnFive.x = centerX
	btnFive.y = btnFour.y + bHeight

    btnSix = widget.newButton
        {
            top = 0.75*_H,
            width = bWidth,
            height = bHeight,
            defaultFile = "images/button.png",
            overFile = "images/pbutton.png",
            id = "button_6",
            label = "Draw shapes",
            labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.9 } },
            fontSize = sizeFont,
            emboss = true,
            onRelease = gameSix,

        }
    btnSix.y = btnFive.y + bHeight
    btnSix.x = centerX

    btnSeven = widget.newButton
        {
            top = 0.75*_H,
            width = bWidth,
            height = bHeight,
            defaultFile = "images/button.png",
            overFile = "images/pbutton.png",
            id = "button_7",
            label = "Associations",
            labelColor = { default={ 0,0,0 }, over={ 0, 0, 0, 0.9 } },
            fontSize = sizeFont,
            emboss = true,
            onRelease = gameSeven,

        }
    btnSeven.y = btnSix.y + bHeight
    btnSeven.x = centerX
	admob.init()
	
	group:insert( btnOne)
	group:insert( btnTwo)
	group:insert( btnThree)
	group:insert( btnFour)	
	group:insert( btnFive)
    group:insert( btnSix)
    group:insert (btnSeven)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	bgsound = audio.loadSound( "sounds/bgsound.mp3" )
	admob.showAd( "interstitial" )
	if _SOUNDON == true then
	audio.play( bgsound )
	end

	mikki = display.newImage("images/miki.png", _W/6, 1.5*centerY, 0.1*_W, 0.1*_H)
	mikki.width = 0.16*_W
	mikki.height = 0.5*_H
	group:insert( mikki )
	mikki:addEventListener("touch", sayMikki )
	minni = display.newImage("images/mini.png", 5*_W/6, 1.5*centerY, 0.1*_W, 0.1*_H)
	minni.width = 0.16*_W
	minni.height = 0.5*_H
	group:insert( minni )
	minni:addEventListener("touch", sayMinni )

	kidsAnimals = display.newImage( "images/animals.png", centerX, centerY, 0.16*_H, 0.16*_H/6)
	kidsAnimals.width = 0.3*_H
	kidsAnimals.height = kidsAnimals.width
	kidsAnimals.x = _W - kidsAnimals.width
	kidsAnimals.y = 0.6*kidsAnimals.height
	group:insert( kidsAnimals )
	kidsAnimals:addEventListener("tap", getAnimalsForKids )

	
	local sheetData = {
	width = _H/2,
	height = 5*_H/12,
	numFrames = 4,
	sheetContentWidth = _H,
	sheetContentHeight = 10*_H/12
}
	local shapeSheet = graphics.newImageSheet("images/sunsheet.png", sheetData)
		local sequenceData = {
		{
		name = "sunny",
		start = 1,
		count = 4,
		time = 500,
		loopCount=0,
		loopDirection = bounce,
		}
	}
	sun = display.newSprite( shapeSheet, sequenceData)
	sun.x = 0.5*sun.width
	sun.y = 0.5*sun.height
	sun:setSequence("sunny")
	if _SOUNDON == true then
	sun:play()
	end
	group:insert(sun)
	moveForward()
	sun.touch = sunMoving
	sun:addEventListener("touch",  sun)
	
end

function scene:exitScene( event )
	local group = self.view
	audio.stop()
	audio.dispose( bgsound )
	transition.cancel( )
	bgsound = nil

	if sun ~= nil then
		sun:removeEventListener("touch",  sun)
		display.remove( sun )
		sun = nil
	end
	if kidsAnimals ~= nil then
	kidsAnimals:removeEventListener("tap", getAnimalsForKids )
	display.remove( kidsAnimals )
	kidsAnimals = nil
	end
	if mikki ~=nil then
	mikki:removeEventListener( "touch", sayMikki )
	display.remove( mikki )
	mikki = nil
	end
	if minni ~=nil then
	minni:removeEventListener( "touch", sayMinni )
	display.remove( minni )
	minni = nil
	end
end

function scene:destroyScene( event )
	local group = self.view
	
end

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene