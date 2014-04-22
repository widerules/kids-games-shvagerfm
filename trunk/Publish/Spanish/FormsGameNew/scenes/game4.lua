local storyboard = require ("storyboard")
local widget = require ("widget")
local constants = require ("constants")
local data = require ("pairData")
local popup = require ("utils.popup")

local scene = storyboard.newScene()

local _FONTSIZE = constants.H / 13
local _MAXLEVEL = 4

local cardAmount = {6, 8, 12, 16}
local rows = {2, 2, 3, 4}
local level = 1
local gameWon = 0

local background
local butterflies
local folds = {}

local previous
local totalCards

local star ={}
local starToScore
---------------------------------------------------------------------------------
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
    
    --Add a timer to the Spawned Explosion.
    --Explosion are destroyed after all the frames have been played after a determined
    --amount of time as setup by the Explosion Generator Tool.
    local destroySpawneExplosion = timer.performWithDelay (explosionTime, removeExplosionSpawn(explosionTable[i]))
end
-----------------------------------------------------------

local function findIndex(object)
	local index = 1
	for i = 1, #folds do
		if folds[i]==object then
			index = i
			break
		end
	end
	return index
end

----animation update score
local function animScore()
	local function listener()
		starToScore:removeSelf( )
        starToScore = nil
	end
	starToScore = display.newImage( "images/starfull.png", constants.CENTERX, constants.CENTERY, constants.H/8, constants.H/8)
	starToScore.xScale, starToScore.yScale = 0.1, 0.1
	
	local function trans1()
	 	transition.to(starToScore, {time = 200, xScale = 1, yScale = 1, x = star[level].x, y= star[level].y, onComplete = listener})
	end
	spawnExplosionToTable(constants.CENTERX, constants.CENTERY)
	transition.to(starToScore, {time = 300, xScale = 2, yScale = 2, transition = easing.outBack, onComplete = trans1})
end

local function onFoldClicked (event)
	event.target:removeEventListener( "tap", onFoldClicked )

	local function compare ()

		if previous ~= nil then
			
			if previous.butterflyType == event.target.butterflyType then
				
				--previous:removeEventListener( "tap", onFoldClicked )
				local wellDone = audio.loadSound( "sounds/welldone.mp3" )
				audio.play(wellDone)
				local function checkAmount()
					totalCards = totalCards - 2
					if totalCards == 0	then
						popup.showPopUp("¡Bravo!", "scenetemplate", "scenes.game3")
						gameWon = gameWon + 1
						if gameWon>0 and level < _MAXLEVEL then
							gameWon = 0
							level = level + 1

						else
							level = 1
							
						end
					end				
				end

				local function removeSecond()
					transition.to(items[findIndex(event.target)], {time = 300, x = constants.W, y = 0, alpha = 0, onComplete = checkAmount})
				end
				transition.to(items[findIndex(previous)], {time = 300, x = constants.W, y = 0, alpha = 0, onComplete = removeSecond})
							
			else
				event.target:addEventListener( "tap", onFoldClicked )
				previous:addEventListener( "tap", onFoldClicked )
				transition.to( event.target, {time = 500, xScale = 1, alpha = 1, transition = easing.outBack} )
				transition.to(previous, {time = 500, xScale = 1, alpha = 1, transition = easing.outBack})
			end
			previous = nil
		else
			local soundName = audio.loadSound( "sounds/"..event.target.butterflyType..".mp3" )
			audio.play(soundName)
			previous = event.target
		end
	end
	transition.to(event.target, {time = 500, xScale = 0, alpha = 0, transition = easing.inBack, onComplete = compare})
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage ("images/background4.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

end

function scene:willEnterScene(event)
	butterflies = table.copy (data.butterflies)
	totalCards = cardAmount[level]
end

function scene:enterScene (event)
	local group = self.view
	if level > 1 then
	animScore()
	end
	previous = nil

	local sheetData = {
		width = 330,
		height = 330,
		numFrames = 8,
		sheetContentWidth = 1320,
		sheetContentHeight = 660
	}
	local butterfliesSheet = graphics.newImageSheet(data.butterfliesPath, sheetData)
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
	
	local itemH, itemW
	if constants.H / rows[level]<constants.W/(cardAmount[level]/rows[level]) then
		itemH = 0.9*constants.H / rows[level]
		itemW = itemH
	else
		itemW = 0.9*constants.W / (cardAmount[level]/rows[level]+1)
		itemH = itemW
	end

	local spacingX = (constants.W - itemW * cardAmount[level]/rows[level]) / (cardAmount[level]/rows[level]+1) 
	local spacingY = (constants.H - itemH * rows[level]) / (rows[level]+1) 
	local i,j
	items = {}
	local temp

	local indexes = {}

	-- delete 2 random shape
	-- because we have 2 useless colors
	for i=1, 8 - cardAmount[level]/2 do
		table.remove(butterflies, math.random(1, #butterflies))
	end

	for i=1, #butterflies do
		indexes[butterflies[i]] = 2
	end
	
	local butterfly, index

	for i=1, rows[level] do
		for j= 1, (cardAmount[level]/rows[level]) do
			temp = display.newSprite( butterfliesSheet, sequenceData )

			index = math.random(1, cardAmount[level]/2)
			while indexes[butterflies[index]] == 0 do
				index = math.random(1, cardAmount[level]/2)
			end

			if indexes[butterflies[index]] > 0 then
				temp:setSequence(butterflies[index])				
				temp.butterflyType = butterflies[index]
				indexes[butterflies[index]] = indexes[butterflies[index]] - 1
			end

			temp.width = itemW
			temp.height = itemH

			temp.x = (j-1) * itemW + itemW/2 + j*spacingX
			temp.y = i * itemH - itemH / 2 + i * spacingY

			--temp:addEventListener( "tap", onItemTap )

			table.insert(items, temp)
		end
	end

	for i=1, #items do
		group:insert( items[i] )

		folds[i] = display.newImage (data.foldPath, items[i].x, items[i].y)
		folds[i].width = 1.05*items[i].width
		folds[i].height = 1.05*items[i].height
		folds[i]:addEventListener("tap", onFoldClicked)
		folds[i].butterflyType = items[i].butterflyType
		group:insert(folds[i])		
	end
	---stars
	for i=1, _MAXLEVEL do
		if i < level then
			star[i] = display.newImage("images/stars/starfull.png", 0, 0, constants.H/20, constants.H/12)
		else
	star[i] = display.newImage("images/stars/star.png", 0, 0, constants.H/20, constants.H/12)
	end
	star[i].width, star[i].height = constants.H/16, constants.H/16
	star[i].x = constants.W - star[i].width/2
	if i == 1 then
		star[i].y = constants.H - star[i].height/2
	else
		star[i].y = star[i-1].y - star[i].height
	end
	group:insert(star[i])

	end

end

function scene:exitScene(event)
	for i=1, #items do
		if items[i] then
			items[i]:removeSelf()
			items[i] = nil
		end

	end
if folds ~= nil then
	for i = 1, #folds do
		if folds[i] ~= nil then
			folds[i]:removeSelf()
			folds[i] = nil
		end
		
	end
end
	popup.hidePopUp()
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )


return scene