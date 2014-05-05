
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require( "widget" )
local native = require( "native" )
local constants = require("constants")
---------------------------------------------------------------------------------
--variables
local background, shape
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local amount = 12
local shapes = {"square", "triangle", "rhombus", "oval", "rectangle",  "round", "heart", "star"}
local items, backBtn
local find
local magicSound = audio.loadSound("sounds/magic.mp3")
local shapeSound
local selected
local toLeftTransition, toRightTransition
local rLeft, rRight, stopR, cancelAll
local totalItems = amount
local explosion

local popupBg;
local popupText;
local homeBtn;
local nextBtn;
local _W = display.contentWidth
local _H = display.contentHeight
local _FONTSIZE = constants.H / 15;
local plopSound = audio.loadSound("sounds/Plopp.mp3")
local starSound = audio.loadSound( "sounds/start.mp3" )
-- functions
--------------------------
explosionTable        = {}                    -- Define a Table to hold the Spawns
i                    = 0                        -- Explosion counter in table
explosionTime        = 466.6667                    -- Time defined from EXP Gen 3 tool
resources            = "_resources"  
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

    local destroySpawneExplosion = timer.performWithDelay (explosionTime, removeExplosionSpawn(explosionTable[i]))
end
-----------------------------------------------------------
local function backHome()
	storyboard.gotoScene( "scenetemplate", "slideRight", 800 )
	--storyboard.removeScene("scenes.gamelast")
end

local function onHomeButtonClicked(event)
		
		storyboard.gotoScene( "scenetemplate", "slideRight", 800 )

end;
local function nextBtnOnClck()
	
		storyboard.reloadScene()
	end
local function showPopUp()
	popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
	popupBg.height = 0.7*constants.H;
	popupBg.width = 0.7*constants.W;

	popupText = display.newText("Well done !", popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
	popupText.y = popupBg.y-popupBg.height+2*popupText.width/3;

	homeBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x - 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png",
		
	}
	homeBtn:addEventListener( "tap", onHomeButtonClicked );

	nextBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x + 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/next.png",
		overFile = "images/next.png"
	}	
	nextBtn:addEventListener( "tap", nextBtnOnClck);
end

stopR = function (self)
	transition.to(self, {time = 100, rotation = 0 })
	end
rLeft = function (self)
	toLeftTransition = transition.to(self, {time=600, rotation=-10.0, onComplete=rRight })
end
rRight = function (self)

	toRightTransition = transition.to(self, {time=600, rotation=10.0, onComplete=rLeft })
end

cancelAll = function (self)
	if (toLeftTransition) then
		transition.cancel(toLeftTransition)
	end
	if (toRightTransition) then
		transition.cancel(toRightTransition)
	end
	stopR(self)
end
local function disApp(self)
	transition.to(self, {time = 800, rotation = 360, xScale = .2, yScale = .2, alpha = 0, onComplete = stopR})
	spawnExplosionToTable(self.x, self.y)
end
local function enLarge(self)
	transition.to(self, {time = 500, xScale = 1.1, yScale = 1.1, onComplete = disApp})
end

local function onItemTap( event, self )
	event.target:removeEventListener( "tap", onItemTap )
	
	if selected ~= nil then
		if selected.id == event.target.id then 
			cancelAll(selected)
			selected = nil
		elseif selected.shapeType == event.target.shapeType then
			shapeSound = audio.loadSound( "sounds/"..selected.shapeType..".mp3")
			audio.play( shapeSound )

			-- hide pair
			cancelAll(selected)
			enLarge(selected)
			enLarge(event.target)
			audio.play( starSound )
			selected = nil
			totalItems = totalItems - 2

			-- if all pairs is found 
			if totalItems == 0 then

				audio.play(magicSound)
				showPopUp()
			end
		else
			-- cancel transition
			event.target:addEventListener( "tap", onItemTap )
			selected:addEventListener( "tap", onItemTap )
			cancelAll(selected)
			selected = nil

		end
	else
		audio.play( plopSound )
		selected = event.target
		rLeft(event.target)
	end
	
	return true
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	find = audio.loadSound("sounds/fpairs.mp3")
	audio.play(find)
	background = display.newImage( "images/background3.jpg", centerX, centerY, _W, _H)
	group:insert( background )
end


function scene:enterScene( event )
	local group = self.view

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
	

	local itemW
	local itemH = _H / 3
	itemW = itemH
	local i,j
	items = {}
	local temp

	local indexes = {}

	-- delete 2 random shape
	-- because we have 2 useless shapes
	for i=1, 2 do
		table.remove(shapes, math.random(1, #shapes))
	end

	for i=1, #shapes do
		indexes[shapes[i]] = 2
	end
	local shape, index

	for i=1, 3 do
		for j=1, 4 do
			temp = display.newSprite( shapeSheet, sequenceData )

			index = math.random(1, 6)
			while indexes[shapes[index]] == 0 do
				index = math.random(1, 6)
			end

			if indexes[shapes[index]] > 0 then
				temp:setSequence(shapes[index])
				temp.id = shapes[index] .. indexes[shapes[index]]
				temp.shapeType = shapes[index]
				indexes[shapes[index]] = indexes[shapes[index]] - 1
			end

			temp.width = itemW
			temp.height = itemH

			temp.x = j * itemW - itemW / 2 + _W / 8
			temp.y = i * itemH - itemH / 2
			temp.xScale, temp.yScale = 0.3, 0.3
			temp:addEventListener( "tap", onItemTap )
			
			table.insert(items, temp)
		end
	end

	backBtn = widget.newButton
		{
		    left = 0,
		    top = 0,
		    defaultFile = "images/home.png",
		    overFile = "images/homehover.png",
		    id = "home",
		    onRelease = backHome
		}

	group:insert( backBtn )
	for i=1, #items do
		transition.to( items[i], {time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
		group:insert( items[i] )
	end


end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	transition.cancel( )
	audio.stop()
	storyboard.purgeAll()
	if items ~=nil then
	for i=1, #items do
		if items[i] ~= nil then
			display.remove( items[i] )
			items[i] = nil
		end
	end
	end
	if popupBg ~= nil then
		display.remove( popupBg )
		display.remove( popupText )
		display.remove( nextBtn )
		display.remove( homeBtn )
		popupBg = nil
		popupText = nil
		nextBtn = nil
		homeBtn = nil
	end

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
end

function scene:willEnterScene( event )
	local group = self.view
	totalItems = amount
	shapes = {"square", "triangle", "rhombus", "oval", "rectangle",  "round", "heart", "star"}
end



scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene