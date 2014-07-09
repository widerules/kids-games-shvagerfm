local storyboard = require("storyboard")
local widget = require("widget")
local constants = require ("constants")
local data = require ("data.studyData")
local gmanager = require("utils.gmanager")

local scene = storyboard.newScene()

local _CIRCLESSIZE = constants.H/6
local _FONTSIZE = constants.H / 5;


local currentColor

local circles = {}
local butterfly
local colorName
local colorSound

local background, pallete, canvas, backBtn

local function backHome()
		local options =
		{
    		effect = "slideRight",
    		time = 400,
    		--params = { ind = _GAME }
		}
		storyboard.gotoScene( "scenes.menu", options)
		storyboard.removeScene( "scenes.game1" )
end

local function onCircleClicked (event)
	for i = 1, 7, 1 do
		if circles[i] == event.target then
			currentColor = i
		end
	end
	
	storyboard.reloadScene()
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage("images/background1.jpg", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	pallete = display.newImage("images/pallete.png", 0.75*constants.W, constants.H*0.6)
	pallete.width = constants.W*0.5
	pallete.height = constants.H*0.8 
	group:insert(pallete)

	canvas = display.newImage("images/canvas.png", 0.25*constants.W, constants.CENTERY)
	canvas.width = constants.W*0.35
	canvas.height = constants.H*0.8
	group:insert(canvas)

	backBtn = widget.newButton
		{	height = 0.05*constants.W,
			width = 0.05*constants.W,
			top = 0,
			left = 0,
		    defaultFile = "images/back.png",
		    overFile = "images/back.png",
		    id = "home",
		    onRelease = backHome		    
		}

	group:insert( backBtn )
	
	currentColor = 1
	for i = 1,7,1 do
		circles[i] = display.newImage (data.circlesPath..data.colors[i]..data.format, 0, 0)
		circles[i]:addEventListener( "tap", onCircleClicked )
		circles[i].height = _CIRCLESSIZE
		circles[i].width = _CIRCLESSIZE
		circles[i].xScale, circles[i].yScale = 0.1, 0.1
		group:insert(circles[i])
	end

	circles[1].x = pallete.x + _CIRCLESSIZE/2
	circles[1].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/20

	circles[2].x = pallete.x - _CIRCLESSIZE/2 - constants.H/30	
	circles[2].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/15

	circles[3].x = pallete.x - 4*_CIRCLESSIZE/2.75 - constants.H/30	
	circles[3].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/5.5

	circles[4].x = pallete.x - 4*_CIRCLESSIZE/2.5 - constants.H/30	
	circles[4].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/2.75

	circles[5].x = pallete.x - _CIRCLESSIZE - constants.H/50	
	circles[5].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/1.95
	
	circles[6].x = pallete.x - constants.H/60	
	circles[6].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/1.7
	
	circles[7].x = pallete.x - constants.H/20	
	circles[7].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/3.25
	for i = 1, 7 do
		transition.to( circles[i],{time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
    end
    gmanager.initGame()
end

function scene:enterScene(event)
	--TODO :

	local group = self.view
	colorSound = audio.loadSound( "sounds/"..data.colors[currentColor]..".mp3" )
	audio.play( colorSound )
	
	butterfly = display.newImage (data.butterfliesPath..data.colors[currentColor]..data.format, 0, 0)
	butterfly.x = canvas.x
	butterfly.y = canvas.y
	butterfly.width = canvas.width*0.8
	butterfly.height = canvas.height*0.8
	butterfly.xScale, butterfly.yScale = 0.3, 0.3
	transition.to( butterfly, {time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
	group:insert(butterfly)

	colorName = display.newEmbossedText( data.colors[currentColor], pallete.x, _FONTSIZE/2 , native.systemFont, _FONTSIZE)
	colorName:setFillColor(data.textColors[currentColor][1], data.textColors[currentColor][2],data.textColors[currentColor][3])
	group:insert(colorName)

	
end

function scene:exitScene(event)
	--TODO :

	display.remove(butterfly)
	display.remove(colorName)

end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene" , scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene)
scene:addEventListener( "destroyScene", scene)

return scene