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
local background, shape1, shape2, shape3, titleText
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local rightIndex
local anIndex1, anIndex2
local shapes = {"square", "triangle", "rhombus", "oval", "rectangle",  "round", "heart", "star"}

local rightChoise
local square = audio.loadSound("sounds/fsquare.wav")
local rectangle = audio.loadSound("sounds/frectangle.wav")
local round = audio.loadSound("sounds/fround.mp3")
local oval = audio.loadSound("sounds/foval.wav")
local triangle = audio.loadSound("sounds/ftriangle.wav")
local star = audio.loadSound("sounds/fstar.wav")
local heart = audio.loadSound("sounds/fheart.wav")
local rhombus = audio.loadSound("sounds/frhombus.wav")
local good = audio.loadSound("sounds/good.wav")
local well = audio.loadSound("sounds/welldone.wav")
local try = audio.loadSound("sounds/tryagain.wav")
local sounds = {square, triangle, rhombus, oval, rectangle, round, heart, star}
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- functions
--------------------------
explosionTable        = {}                    -- Define a Table to hold the Spawns
i                    = 0                        -- Explosion counter in table
explosionTime        = 466.6667                    -- Time defined from EXP Gen 3 tool
resources            = "_resources1"  
--------------------------------------------------
-- Create and assign a new Image Sheet using the
-- Coordinates file and packed texture.
--------------------------------------------------
local explosionSheetInfo    = require(resources..".".."Explosion")
local explosionSheet        = graphics.newImageSheet( resources.."/".."Explosion.png", explosionSheetInfo:getSheet() )

local animationSequenceData = {
  { name = "dbiExplosion",
      frames={
          1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
      },
      time=explosionTime, loopCount=1
  },
}

function spawnExplosionToTable(spawnX, spawnY)
    i = i + 1                                        -- Increment the spawn counter
    
    explosionTable[i] = display.newSprite( explosionSheet, animationSequenceData )
    explosionTable[i]:setSequence( "dbiExplosion" )    -- assign the Animation to play
    explosionTable[i].x=spawnX                        -- Set the X position (touch X)
    explosionTable[i].y=spawnY                        -- Set the Y position (touch Y)
    explosionTable[i]:play()                        -- Start the Animation playing
    explosionTable[i].xScale = 1                    -- X Scale the Explosion if required
    explosionTable[i].yScale = 1                    -- Y Scale the Explosion if required
    
    --Create a function to remove the Explosion - triggered from the DelatedTimer..
    local function removeExplosionSpawn( object )
        return function()
            object:removeSelf()    -- remove the explosion from table
            object = nil
        end
    end
    
    --Add a timer to the Spawned Explosion.
    --Explosion are destroyed after all the frames have been played after a determined
    --amount of time as setup by the Explosion Generator Tool.
    local destroySpawneExplosion = timer.performWithDelay (explosionTime, removeExplosionSpawn(explosionTable[i]))
end
-----------------------------------------------------------

local function reload()
	storyboard.reloadScene()
end 
local function backHome()

		storyboard.gotoScene( "scenetemplate", "slideRight", 800 )

end
local function loadIndexes()
	while anIndex1 == anIndex2 or anIndex1 == rightIndex or anIndex2 == rightIndex do
		anIndex1 = math.random(1,8)
		anIndex2 = math.random(1,8)
	end
end
local function setShapes()
	if math.random() < 0.33 then
			shape1:setSequence(rightIndex)
			shape2:setSequence(anIndex1)
			shape3:setSequence(anIndex2)
		elseif math.random < 0.66 then
			shape1:setSequence(anIndex1)
			shape2:setSequence(rightIndex)
			shape3:setSequence(anIndex2)
		else
			shape1:setSequence(anIndex2)
			shape2:setSequence(anIndex1)
			shape3:setSequence(rightIndex)
	end
	-- body
end

local function stopR(self)
	transition.to(self, {time = 100, rotation = 0})
	end
local function rRight(self)
	transition.to(self, {time=100, rotation=10.0, onComplete=stopR})
    end
local function rLeft(self)
	transition.to(self, {time=100, rotation=-10.0, onComplete=rRight})
	end


local function disApp(self)
	transition.to(self, {time = 800, rotation = 360, xScale = .2, yScale = .2, alpha = 0, onComplete = stopR})
end
local function enLarge(self)
	transition.to(self, {time = 500, xScale = 1.1, yScale = 1.1, onComplete = disApp})
end
local function wellDone(self)
	local tempsound = math.random()
	if tempsound < 0.5 then 
	audio.play(good)
	else
		audio.play(well)
	end
	self:toFront()
	transition.to(self, {time = 500, xScale = 1.5, yScale = 1.5, rotation=180, x = centerX, onComplete = reload})
end

local function answer(self, event)
if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page1.lua scene
		print(shapes[rightIndex])
		print(self.sequence)
		if self.sequence == shapes[rightIndex] then 
			print ("good")
			wellDone(self)
			
			spawnExplosionToTable(self.x,self.y)
			else
				
				rLeft(self)
				
		end
		return true	-- indicates successful touch
	end
	-- body
end
local function findShape()
	audio.play(sounds[rightIndex])
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	background = display.newImage( "images/background2.png", centerX, centerY, _W, _H)
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
	group:insert( backBtn )
end

function scene:willEnterScene( event )
	local group = self.view
end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	rightIndex = math.random(1, 8)
	while anIndex1 == anIndex2 or anIndex1 == rightIndex or anIndex2 == rightIndex do
		anIndex1 = math.random(1, 8)
		anIndex2 = math.random(1, 8)
	end

	titleText = display.newText( "Find " .. shapes[rightIndex], 0, 0, native.systemFont, 46 )
	--titleText:setReferencePoint( display.CenterReferencePoint )
	titleText.x = display.contentWidth * 0.5
	titleText.y = display.contentHeight - (display.contentHeight*0.1)
	findShape()

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
		name = "round",
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
	
	shape1 = display.newSprite( shapeSheet, sequenceData)
	shape1.width = _W/4
	shape1.x = _W/6
	shape1.y = _H/2
	shape1.touch = answer
	shape1:addEventListener("touch", shape1)

	shape2 = display.newSprite( shapeSheet, sequenceData)
	shape2.width = _W/4
	shape2.x = _W/2
	shape2.y = _H/2
	shape2.touch = answer
	shape2:addEventListener("touch", shape2)

	shape3 = display.newSprite( shapeSheet, sequenceData)
	shape3.width = _W/4
	shape3.x = _W*5/6
	shape3.y = _H/2
	shape3.touch = answer
	shape3:addEventListener("touch", shape3)

	if math.random() <= 0.33 then
			shape1:setSequence(shapes[rightIndex])
			shape2:setSequence(shapes[anIndex1])
			shape3:setSequence(shapes[anIndex2])
		elseif math.random() <= 0.66 then
			shape1:setSequence(shapes[anIndex1])
			shape2:setSequence(shapes[rightIndex])
			shape3:setSequence(shapes[anIndex2])
		else
			shape1:setSequence(shapes[anIndex2])
			shape2:setSequence(shapes[anIndex1])
			shape3:setSequence(shapes[rightIndex])
	end
	group:insert( titleText )
	group:insert( shape1 )
	group:insert( shape2 )
	group:insert( shape3 )

	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	display.remove(shape1)
	display.remove(shape2)
	display.remove(shape3)
	display.remove(titleText)
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
scene:addEventListener( "willEnterScene", scene )
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