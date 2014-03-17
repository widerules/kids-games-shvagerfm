----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require( "widget" )
local native = require( "native" )
local constants = require("constants")
----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
--variables
local background, shape
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local amount = 12
local shapes = {"square", "triangle", "rhombus", "oval", "rectangle",  "round", "heart", "star"}
local items, backBtn
local find = audio.loadSound("sounds/fpairs.wav")
local magicSound = audio.loadSound("sounds/magic.mp3")
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

local explosionTime        = 2000                    -- Time defined from EXP Gen 3 tool
local resources            = "_resources"   
local explosionSheetInfo    = require(resources..".".."Explosion")
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
-- functions
local function backHome()
	storyboard.gotoScene( "scenetemplate", "slideRight", 800 )
	storyboard.removeScene("scenes.gamelast")
end

local function onHomeButtonClicked(event)
		storyboard.removeScene("scenes.game3")
		storyboard.gotoScene( "scenetemplate", "slideRight", 800 )

end;
local function nextBtnOnClck()
	if popupBg ~= nil then
		popupBg:removeSelf();
		popupText:removeSelf();
		nextBtn:removeSelf();
		homeBtn:removeSelf();
	end;
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
	-- print("stopR called")
	transition.to(self, {time = 100, rotation = 0 })
	end
rLeft = function (self)
	-- print("left called")
	toLeftTransition = transition.to(self, {time=600, rotation=-10.0, onComplete=rRight })
end
rRight = function (self)
	-- print("right called")
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
end
local function enLarge(self)
	transition.to(self, {time = 500, xScale = 1.1, yScale = 1.1, onComplete = disApp})
end

local function onItemTap( event )
	print( "Tap event on: " .. event.target.id )
	if selected ~= nil then
		if selected.id == event.target.id then 
			print ("same figure")
			cancelAll(selected)
			selected = nil
		elseif selected.shapeType == event.target.shapeType then
			print ("right choise")
			-- hide pair
			cancelAll(selected)
			enLarge(selected)
			enLarge(event.target)

			selected = nil
			totalItems = totalItems - 2

			-- if all pairs is found 
			if totalItems == 0 then

				audio.play(magicSound)
				explosion.isVisible = true
				explosion.xScale = 1.5
				explosion.yScale = 1.5
				explosion:setSequence( "dbiExplosion" ) 
				explosion:play()
				showPopUp()
			end
		else
			-- cancel transition
			cancelAll(selected)
			selected = nil
		end
	else
		selected = event.target
		rLeft(event.target)
	end
	
	return true
end





-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	print('createScene')
	audio.play(find)
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	print("enterScene")
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
	background = display.newImage( "images/background3.png", centerX, centerY, _W, _H)
	group:insert( background )
	
	local explosionSheet = graphics.newImageSheet( resources.."/".."Explosion.png", explosionSheetInfo:getSheet() )

	local animationSequenceData = {
 	 { name = "dbiExplosion",
      frames={
          1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48
      },
      time=explosionTime, loopCount=1
 	 },
	}

	explosion = display.newSprite(explosionSheet, animationSequenceData )
	explosion.x = centerX
	explosion.y = centerY
	explosion.isVisible = false
	group:insert(explosion)

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
		group:insert( items[i] )
	end


end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	storyboard.purgeAll()
	print ("exitScene")

	if popupBg ~= nil then
		popupBg:removeSelf()
		popupText:removeSelf()
		nextBtn:removeSelf()
		homeBtn:removeSelf()
		popupBg = nil
		popupText = nil
	end
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	 -- storyboard.removeScene("scenes.gamelast")
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	print('destroyScene')
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end

function scene:willEnterScene( event )
	print('willEnterScene')
	local group = self.view
	totalItems = amount
	shapes = {"square", "triangle", "rhombus", "oval", "rectangle",  "round", "heart", "star"}
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