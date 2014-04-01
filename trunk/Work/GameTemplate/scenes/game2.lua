require "sqlite3"
local path = system.pathForFile( "colorskids.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )
local storyboard = require("storyboard")
local constants = require("constants")
local data = require("searchData")

local scene = storyboard.newScene()

-------------------------texts
local taskText = "Look for "
local message = "Well done !"

local _FONTSIZE = constants.H/7

local gamesWon = 0
local level = 1
local itemsCount = {2, 3, 4, 6, 9, 12, 16, 20}
local rows =       {1, 1, 2, 2, 3, 3, 4, 4}
local items = {}
local images = {}

local imageSize, spacingX, spacingY
local itemType, searchAmount
local taskLabel
local findSound, colorSound

local total, totalScore, bgscore, coins

local coinsToScore
local counter = 0

local star = {}
---------------------------------------------
--explosion
--------------------------------------------------
explosionTable        = {}                    -- Define a Table to hold the Spawns
i                    = 0                        -- Explosion counter in table
explosionTime        = 416.6667                    -- Time defined from EXP Gen 3 tool
_w                     = display.contentWidth    -- Get the devices Width
_h                     = display.contentHeight    -- Get the devices Height
resources            = "_resources"            -- Path to external resource files

local explosionSheetInfo    = require(resources..".".."Explosion")
local explosionSheet        = graphics.newImageSheet( resources.."/".."Explosion.png", explosionSheetInfo:getSheet() )

--------------------------------------------------
-- Define the animation sequence for the Explosion
-- from the Sprite sheet data
-- Change the sequence below to create IMPLOSIONS 
-- and EXPLOSIONS etc...
--------------------------------------------------
local animationSequenceData = {
  { name = "dbiExplosion",
      frames={
          1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
      },
      time=explosionTime, loopCount=1
  },
}

local function spawnExplosionToTable(spawnX, spawnY)
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
---------------------------------------
-----check totals & update 
---------------------------------------
local function checkTotal()
   local function dbCheck()
      local sql = [[SELECT value FROM statistic WHERE name='total';]]
      for row in db:nrows(sql) do
         return row.value
      end
   end
   total = dbCheck()
   if total == nil then
      local insertTotal = [[INSERT INTO statistic VALUES (NULL, 'total', '0'); ]]
      db:exec( insertTotal )
      print("total inserted to 0")
      total = 0
   else
      print("Total is "..total)
   end
end
local function updateScore()
	total = total + 5
	local tablesetup = [[UPDATE statistic SET value = ']]..total..[[' WHERE name = 'total']]
	db:exec(tablesetup)

	totalScore.text = "Score: "..total
end


----animation update score
local function animScore()
	local function listener()
		updateScore()
		coinsToScore:removeSelf( )
	end
	coinsToScore = display.newImage( "images/coins.png", _CENTERX, _CENTERY, _H/8, _H/8)
	coinsToScore.xScale, coinsToScore.yScale = 0.1, 0.1
	local function trans1()
	 	transition.to(coinsToScore, {time = 200, xScale = 1, yScale = 1, x = coins.x, y= coins.y, onComplete = listener})
	end
	spawnExplosionToTable(_CENTERX, _CENTERY)
	transition.to(coinsToScore, {time = 300, xScale = 2, yScale = 2, transition = easing.outBack, onComplete = trans1})
end
----------------------------------------
-- end totals f-ns
-----------------------------------------

local function generateItems()
	local tmp = table.copy(data.colors)
	local tmpindex = math.random(1, #tmp)

	itemType = tmp[tmpindex]
	items[1] = tmp[tmpindex]
	table.remove(tmp, tmpindex)
	searchAmount = 1

	for i = 2, itemsCount[level] do
		tmpindex = math.random (1, #tmp)		
		items[i] = tmp[tmpindex]
		table.remove(tmp,tmpindex)

		if #tmp < 1 then
			tmp = table.copy (data.colors)
		end

		if items[i] == itemType then
			searchAmount = searchAmount+1
		end
	end
end

local function onItemTapped (event)
	---
	local function encreaseScore()
		searchAmount = searchAmount - 1
		if searchAmount < 1 then
			gamesWon = gamesWon + 1
			if gamesWon>2 then
				gamesWon = 0
				animScore()
				if level<8 then
					level = level + 1
				end
			end
			storyboard.reloadScene()
		end
	end
-- right choice
	if event.target.type == itemType then
		colorSound = audio.loadSound( "sounds/"..event.target.type..".mp3" )
		audio.play( colorSound )
		event.target:removeEventListener( "tap", onItemTapped )
		transition.fadeOut( event.target, {time = 500, onComplete = encreaseScore} )	

-- wrong choice	
	else
		--soundItIs = audio.loadSound( "sounds/"..event.target.name.."is"..event.target.type..".mp3" )
		--audio.play( soundItIs )
		local baseRot = event.target.rotation
		local function toNormal()
			transition.to (event.target,{rotation = baseRot,  time = 125})
		end
		local function toRight()
			transition.to (event.target,{rotation = 30,  time = 250, onComplete = toNormal})
		end
		transition.to (event.target,{rotation = -30,  time = 125, onComplete = toRight})
	end
end

function scene:createScene(event)
	local group = self.view
----Checking total from DB
	checkTotal()

	background = display.newImage("images/background2.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)	
	
	---------------------------------------------------------------
----Score views
	---------------------------------------------------------------
	bgscore = display.newImage("images/bgscore.png", 0, 0, _W/5, _W/15)
	bgscore.width, bgscore.height = _W/5, _W/20
	bgscore.x = bgscore.width/2
	bgscore.y = bgscore.height/2
	group:insert(bgscore)

	totalScore = display.newText("Score: "..total, 0,0, native.systemFont, _H/24)
	totalScore.x = 2*totalScore.width/3
	totalScore.y = bgscore.y
	group:insert(totalScore)

	coins = display.newImage("images/coins.png", 0, 0, bgscore.height/2, bgscore.height/2)
	coins.width, coins.height = 2*bgscore.height/3, 2*bgscore.height/3
	coins.x = bgscore.width - 3*coins.width/4
	coins.y = bgscore.y
	group:insert(coins)
------------------------------------------------------------------------------
--End score views
------------------------------------------------------------------------------
	gamesWon = 0
	level = 1
end

function scene:willEnterScene(event)
	--computing size of spacing and actual image size, according to the amount of the items
	imageSize = constants.H/(rows[level]+1)
	spacingX = (constants.W - (itemsCount[level]/rows[level])*imageSize)/(itemsCount[level]/rows[level]+1)
	spacingY = imageSize / (rows[level]+1)
end

function scene:enterScene(event)
		local group = self.view
	
	generateItems()
	for i = 1, itemsCount[level]/rows[level] do
		images[i] = {}
		for j = 1, rows[level] do
			local index = math.random (1, #items)			
			images[i][j] = display.newImage( data.butterfliesPath..items[index]..data.format, i*spacingX+(i-0.5)*imageSize, j*spacingY+(j-0.5)*imageSize)			
			images[i][j].width = imageSize
			images[i][j].height = imageSize	
			images[i][j].rotation = math.random (-30,30)	
			images[i][j].type = items[index]	
			images[i][j]:addEventListener("tap", onItemTapped)
			group:insert(images[i][j])
			table.remove(items, index)
		end
	end


	local function hideLabel()
		transition.fadeOut( taskLabel, {time = 500} )
	end

	taskLabel = display.newEmbossedText( taskText..itemType, constants.CENTERX, constants.CENTERY, native.systemFont, _FONTSIZE )	
	
	taskLabel.xScale = 0.3
	taskLabel.yScale = 0.3
	taskLabel:setFillColor( 0,0,0 )
	group:insert(taskLabel)
	---- Sound
	findSound = audio.loadSound("sounds/find_"..itemType.."_butterfly.mp3")
	audio.play( findSound )

	transition.to(taskLabel, {time = 500, xScale = 1, yScale = 1, onComplete = function() timer.performWithDelay(1000, hideLabel) end})

---stars
	for i=1, 8 do
		if i < level then
			star[i] = display.newImage("images/starfull.png", 0, 0, constants.H/20, constants.H/12)
		else
	star[i] = display.newImage("images/star.png", 0, 0, constants.H/20, constants.H/12)
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
	for i = 1, #images do
		for j = 1, #images[i] do
			if images[i][j] ~= nil then
			print ("level "..level.." i "..i.." j "..j)
			images[i][j]:removeSelf()
			images[i][j] = nil
			end
		end
	end	

	taskLabel:removeSelf()
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene