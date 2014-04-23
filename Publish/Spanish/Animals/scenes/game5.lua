
local storyboard = require("storyboard")
local constants = require("constants")
local data = require("searchData")
local localized = require("data").animalsLocalized

local scene = storyboard.newScene()
local widget = require("widget")
-------------------------texts
local taskText = "Encuentra "
local message = "¡Bravo!"

local _FONTSIZE = constants.H/7

_GAME = 5

local gamesWon = 0
local level = 1
local itemsCount = {2, 3, 4, 6, 9, 12, 16, 20}
local rows =       {1, 1, 2, 2, 3, 3, 4, 4}
local items = {}
local images = {}

local imageSize, spacingX, spacingY
local itemType, searchAmount
local taskLabel

local background, backBtn, homeBtn, backBtn
local counter

local soundName, soundTitle
local star = {}
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

local function backHome()
		--TO DO:
	local options =
		{
    		effect = "slideRight",
    		time = 800,
    		params = { ind = 5 }
		}
	storyboard.gotoScene("scenes.gametitle", options)
	storyboard.removeScene("scenes.game5")
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

local function playAgain()
	level = 1
	popupBg:removeSelf( )
	popupText:removeSelf( )
	homeBtn:removeSelf( )
	nextBtn:removeSelf( )

	storyboard.reloadScene()
end

local function showPopUp()
	local sound = audio.loadSound( "sounds/playagain.mp3")
	audio.play( sound )
	popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
	popupBg.height = 0.7*constants.H;
	popupBg.width = 0.7*constants.W;

	popupText = display.newText("¡Bravo!", popupBg.x, 0, native.systemFont, _FONTSIZE);
	popupText.y = popupBg.y-popupBg.height+2*popupText.width/3;

	homeBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x - 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png",
		onRelease = backHome
	}


	nextBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x + 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/reload.png",
		overFile = "images/reloadhover.png",
		onRelease = playAgain
	}	


end;

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

local function wellDone()

	local tempsound = math.random()
	if tempsound < 0.5 then 
	soundName = audio.loadSound( "sounds/good.mp3" )
	else
		soundName = audio.loadSound( "sounds/welldone.mp3" )
	end

		audio.play( soundName )
end

local function onItemTapped (event)
	---
	local function reloadFunc()
		storyboard.reloadScene() 
	end
	local function encreaseScore()
		searchAmount = searchAmount - 1
		if searchAmount < 1 then
			gamesWon = gamesWon + 1
			if gamesWon>2 then
				gamesWon = 0
				animScore()
				if level < 8 then
					level = level + 1
					timer.performWithDelay( 1000, reloadFunc )
				else
					showPopUp()
				end
				wellDone()
				
			else
				reloadFunc()
			end
			
		end
	end
-- right choice
	if event.target.type == itemType then
		wellDone()
		event.target:removeEventListener( "tap", onItemTapped )
		local function animDisapp(self)
			transition.to(self, {time = 700, xScale = 0.1, yScale = 0.1 , alpha = 0.1, transition = easing.inBack, onComplete = encreaseScore})
		end
		event.target:toFront()
		transition.to( event.target, {time = 700, rotation = 360, xScale = 1.5, yScale = 1.5, x = constants.CENTERX, y = constants.CENTERY, transition = easing.outBack, onComplete = animDisapp} )	
-- wrong choice	
	else
		local soundItIs
		if counter > 2 then
			audio.play( soundTitle )
			counter = 1
		else
			soundItIs = audio.loadSound( "sounds/no.mp3" )
			audio.play( soundItIs )
		end
		
		
		local baseRot = event.target.rotation
		local function toNormal()
			transition.to (event.target,{rotation = baseRot,  time = 125})
		end
		local function toRight()
			transition.to (event.target,{rotation = 30,  time = 250, onComplete = toNormal})
		end
		
		transition.to (event.target,{rotation = -30,  time = 125, onComplete = toRight})
		counter = counter + 1
	end
end

function scene:createScene(event)
	local group = self.view


	background = display.newImage("images/background2.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)	
	
	backBtn = widget.newButton
		{
		    
		     height = 0.07*constants.W,
            width = 0.07*constants.W,
            left = 0,
		    top = 0,
		    defaultFile = "images/home.png",
		    overFile = "images/homehover.png",
		    id = "home",
		    onRelease = backHome,
		    
		}
	--backBtn.width, backBtn.height = 0.1*constants.W, 0.1*constants.W
	--backBtn.x, backBtn.y = backBtn.width/2, backBtn.height/2
	group:insert( backBtn )

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
		
	counter = 1
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
		transition.to( taskLabel, {time = 300, alpha = 0} )
	end
print(itemType, localized[itemType])
	taskLabel = display.newEmbossedText( taskText..localized[itemType], constants.CENTERX, constants.CENTERY, native.systemFont, _FONTSIZE )	
    soundTitle = audio.loadSound( "sounds/find_"..itemType..".mp3" )
	audio.play( soundTitle )
	taskLabel.xScale = 0.3
	taskLabel.yScale = 0.3
	taskLabel:setFillColor( 0,0,0 )
	group:insert(taskLabel)
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
	if taskLabel ~= nil then
	taskLabel:removeSelf()
	taskLabel = nil
	end
	if popupBg ~= nil then
		popupBg:removeSelf();
		popupText:removeSelf();
		nextBtn:removeSelf();
		homeBtn:removeSelf();
		popupBg = nil
	end;
	transition.cancel( )
	audio.stop()

end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene