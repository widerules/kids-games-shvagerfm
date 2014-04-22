----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
--variables
local background, btnOne, btnTwo, btnThree, shape, backBtn, optionsBtn
local name = "square"
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local left, center, right, square
local sSquare = audio.loadSound("sounds/square.mp3")
local sRectangle = audio.loadSound("sounds/rectangle.mp3")
local sRound = audio.loadSound("sounds/circle.mp3")
local sOval = audio.loadSound("sounds/oval.mp3")
local sTriangle = audio.loadSound("sounds/triangle.mp3")
local sStar = audio.loadSound("sounds/star.mp3")
local sHeart = audio.loadSound("sounds/heart.mp3")
local sRhombus = audio.loadSound("sounds/rhombus.mp3")

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- functions

local function backHome()
		storyboard.removeScene("scenes.gamefirst")
		storyboard.gotoScene( "scenetemplate", "slideRight", 800 )

end


local function scaling()
	shape.width = _W/3
	shape.height = _W/3
	-- body
end
local function square()

	audio.play(sSquare)
	shape:setSequence("square")
	name = "square"
	scaling()
end

local function rectangle()
	
	audio.play(sRectangle)
	shape:setSequence("rectangle")
	scaling()
	name = "rectangle"
end

local function triangle()
	
	audio.play(sTriangle)
	shape:setSequence("triangle")
	scaling()
	name = "triangle"
end

local function circle()

	audio.play(sRound)
	shape:setSequence("circle")
	scaling()
	name = "circle"
end

local function oval()
	
	audio.play(sOval)
	shape:setSequence("oval")
	scaling()
	name = "oval"
end

local function rhombus()
	
	audio.play(sRhombus)
	shape:setSequence("rhombus")
	scaling()
	name = "rhombus"
end

local function star()

	audio.play(sStar)
	shape:setSequence("star")
	scaling()
	name = "star"
end

 local function heart()
	
	audio.play(sHeart)
	shape:setSequence("heart")
	scaling()
	name = "heart"
end
local function selfTouch(self)
	if name == "square" then 
		square()
	
	elseif name == "triangle" then
		triangle()

	elseif name == "rectangle" then
		rectangle()

	elseif name == "circle" then
		circle()

	elseif name == "oval" then
		oval()

	elseif name == "rhombus" then
		rhombus()

	elseif name == "star" then
		star()

	elseif name == "heart" then
		heart()
	end
end
local function nextShape()
	if name == "square" then 
		triangle()
	
	elseif name == "triangle" then
		rectangle()

	elseif name == "rectangle" then
		circle()

	elseif name == "circle" then
		oval()

	elseif name == "oval" then
		rhombus()

	elseif name == "rhombus" then
		star()

	elseif name == "star" then
		heart()

	elseif name == "heart" then
		square()
	end
end

local function prevShape()
	if name == "square" then 
		heart()
	
	elseif name == "triangle" then
		square()

	elseif name == "rectangle" then
		triangle()

	elseif name == "circle" then
		rectangle()

	elseif name == "oval" then
		circle()

	elseif name == "rhombus" then
		oval()

	elseif name == "star" then
		rhombus()

	elseif name == "heart" then
		star()
	end
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	background = display.newImage( "images/background.png", _CENTERX, _CENTERY, _W, _H)
	group:insert( background )
	
	backBtn = widget.newButton
		{
		    left = 0,
		    top = 0,
		    defaultFile = "images/home.png",
		    overFile = "images/homehover.png",
		    id = "home",
		    onRelease = backHome,
		    
		}

	group:insert( background )

	group:insert( backBtn )
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	left = display.newImage(group,"images/prev.png", 0, _H/2, _W/4, _W/4)
	left.x = _W/6
	left.y = _H/2
	left.width = _W/4
	left.height = _W/4
	left.tap = prevShape
	left:addEventListener("tap", left)
	
	right = display.newImage(group,"images/next.png", _W -_W/4, centerY/2, _W/4, _W/4)
	right.x = _W -_W/6
	right.y = _H/2
	right.width = _W/4
	right.height = _W/4
	right.tap = nextShape
	right:addEventListener("tap", right)


	local sheetData = {
	width = 330,
	height = 330,
	numFrames = 8,
	sheetContentWidth = 1320,
	sheetContentHeight = 660
}
	local shapeSheet = graphics.newImageSheet("images/shapes.png", sheetData)
		local sequenceData = {
		{
		name = "square",
		start = 1,
		count = 1,
		},
		{
		name = "triangle",
		start = 2,
		count = 1,
		},
		{
		name = "rhombus",
		start = 3,
		count = 1,
		},
		{
		name = "oval",
		start = 4,
		count = 1,
		},
		{
		name = "rectangle",
		start = 5,
		count = 1,
		},
		{
		name = "circle",
		start = 6,
		count = 1,
		},
		{
		name = "heart",
		start = 7,
		count = 1,
		},
		{
		name = "star",
		start = 8,
		count = 1,
		}
	}
	shape = display.newSprite( shapeSheet, sequenceData)
	shape:setSequence("square")
	
	shape.x = _W/2
	shape.y = _H/2
	shape.width = _W/3
	shape.height = _W/3
	shape.tap = selfTouch
	shape:addEventListener("tap", shape)

	
	group:insert( left )
	group:insert( shape )
	group:insert( right )
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	storyboard.purgeAll()
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
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