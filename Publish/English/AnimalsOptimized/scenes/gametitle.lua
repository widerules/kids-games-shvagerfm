local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )

local scene = storyboard.newScene()

local _GAMEAMOUNT = 6

local indexGame = 1

local gamePath = "scenes.game"

local resPath = "images/game"
local namePath = "/title"
local imagePath = "/titlepic"
local difPath = "/complexity"

local format = ".png"

local swypeGroup
local background, title, titlePic, complexity
local btnPlay, leftArrow, rightArrow

local function goNextGame()
	if indexGame < _GAMEAMOUNT then
		indexGame = indexGame + 1

		local options =
		{
    		effect = "slideLeft",
    		time = 500,
    		params = { ind = indexGame }
		}
		storyboard.gotoScene("scenes.gametitle2", options)
	end 
end

local function goPreviousGame()
	if indexGame > 1 then
		indexGame = indexGame - 1

		local options =
		{
    		effect = "slideRight",
    		time = 500,
    		params = { ind = indexGame }
		}
		storyboard.gotoScene("scenes.gametitle2", options)
	else
        storyboard.gotoScene("scenetemplate", "slideRight", 800)
        storyboard.removeScene("scenes.gametitle")
	end
end
local function animButtons(target)
	local function transIn() 
		transition.to( target, {time = 1500, alpha = 1, onComplete = animButtons} )
	end
	local transout = transition.to( target, {time = 1500, alpha = 0.3, onComplete = transIn} )
	end

local function animPlay()
	transition.to(btnPlay, {time = 300, xScale = 2.2, yScale = 2.2, transition = easing.continuousLoop})
end
local function startDrag(event)
	local swipeLength = math.abs(event.x - event.xStart) 
	print(event.phase, swipeLength)
	local t = event.target
	local phase = event.phase
	if "began" == phase then
		return true
	elseif "moved" == phase then
	elseif "ended" == phase or "cancelled" == phase then
		if event.xStart > event.x and swipeLength > 50 then 
			goNextGame()
		elseif event.xStart < event.x and swipeLength > 50 then 
		    goPreviousGame()
		end	
	end
end

local function startGame(event)
		
	    storyboard.gotoScene(gamePath .. indexGame, "slideLeft", 400)
        storyboard.removeScene("scenes.gametitle")
end

function scene:createScene(event)
	local group = self.view

	indexGame = event.params.ind

	background = display.newImage("images/background1.jpg", constants.CENTERX, constants.CENTERY)
	group:insert(background)
	group:addEventListener( "touch", startDrag )

	admob.init()
	
end

function scene:enterScene (event)
	local group = self.view
	admob.showAd( "interstitial" )
	indexGame = event.params.ind

	titlePic = display.newImage(resPath .. indexGame .. imagePath .. format, 0, constants.CENTERY, constants.W/2, 3*constants.W/8)
	titlePic.width = constants.W/2
	titlePic.height = 3*constants.W/8
	titlePic.x = 0.6*titlePic.width
	titlePic.alpha = 0
	transition.to(titlePic, {time = 200, alpha = 1})
	group:insert(titlePic)

	
	title = display.newImage(resPath .. indexGame .. namePath .. format,  0, 0, constants.W/4, constants.W/12)
	title.y = title.height
	title.x = constants.W - title.width
	title.alpha = 0
	transition.to(title, {time = 200, alpha = 1})
	group:insert(title)

	leftArrow = widget.newButton
		{
			width = constants.W/12,
			height = constants.W/4,
			defaultFile = "images/leftarrow.png",
			id = "button_2",
			onRelease = goPreviousGame
		}
	leftArrow.x =  leftArrow.width/2
	leftArrow.y = constants.CENTERY
	leftArrow.alpha = 0
	transition.to(leftArrow, {time = 200, alpha = 1})
	group:insert(leftArrow)

	if indexGame < _GAMEAMOUNT then
		rightArrow = widget.newButton
			{
				width = constants.W/12,
				height = constants.W/4,
				defaultFile = "images/rightarrow.png",
				id = "button_3",
				onRelease = goNextGame
			}
		rightArrow.x = constants.W - rightArrow.width/2
		rightArrow.y = constants.CENTERY	
		rightArrow.alpha = 0
		transition.to(rightArrow, {time = 200, alpha = 1})
		group:insert(rightArrow)
	end

	btnPlay = widget.newButton
		{
			width = constants.W/3,
			height = constants.W/6,
			defaultFile = "images/btnPlay.png",
			overFile = "images/btnPlayOver.png",
			id = "button_1",
			onRelease = startGame,
		}
	btnPlay.x = 0.7*constants.W
	btnPlay.y = constants.CENTERY
	btnPlay.alpha = 0
	transition.to(btnPlay, {time = 200, alpha = 1})
	group:insert(btnPlay)

	animButtons(rightArrow)
        animButtons(leftArrow)
        animPlay()
end


function scene:exitScene(event)
	display.remove(titlePic)
	titlePic = nil
	display.remove(title)
	title = nil
	display.remove(complexity)
	complexity = nil
	display.remove (swypeGroup)
	swypeGroup = nil
	display.remove(rightArrow)
	rightArrow = nil
	display.remove(leftArrow)
	leftArrow = nil
	display.remove(btnPlay)
	btnPlay = nil
	--index = nil
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene