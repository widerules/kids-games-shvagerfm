local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")

local scene = storyboard.newScene()

local _GAMEAMOUNT = 4

local index = 1

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
	if index <= _GAMEAMOUNT then
		index = index + 1

		local options =
		{
    		effect = "slideLeft",
    		time = 800,
    		params = { ind = index }
		}
		storyboard.gotoScene("scenes.gametitle2", options)
	end 
end

local function goPreviousGame()
	if index > 1 then
		index = index - 1

		local options =
		{
    		effect = "slideRight",
    		time = 800,
    		params = { ind = index }
		}
		storyboard.gotoScene("scenes.gametitle2", options)
	else
        storyboard.gotoScene("scenetemplate", "slideRight", 800)
        storyboard.removeScene("scenes.gametitle")
	end
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
	    storyboard.gotoScene(gamePath .. index, "slideRight", 800)
        storyboard.removeScene("scenes.gametitle")
end

function scene:createScene(event)
	local group = self.view

	index = event.params.ind

	background = display.newImage("images/background1.png", constants.CENTERX, constants.CENTERY)
	group:insert(background)

	btnPlay = widget.newButton
		{
			width = constants.W/3,
			height = constants.W/6,
			defaultFile = "images/btnPlay.png",
			overFile = "images/btnPlayOver.png",
			id = "button_1",
			onRelease = play,
		}
	btnPlay.x = 0.7*constants.W
	btnPlay.y = constants.CENTERY
	group:insert(btnPlay)
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
	group:insert(leftArrow)
	group:insert(rightArrow)

	group:addEventListener( "touch", startDrag )
end

function scene:enterScene (event)
	local group = self.view
	
	index = event.params.ind

	titlePic = display.newImage(resPath .. index .. imagePath .. format, 0, constants.CENTERY, constants.W/2, 3*constants.W/8)
	titlePic.x = 0.7*titlePic.width
	group:insert(titlePic)
	
	title = display.newImage(resPath .. index .. namePath .. format,  0, 0, constants.W/4, constants.W/12)
	title.y = title.height
	title.x = constants.W - title.width
	group:insert(title)
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
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene