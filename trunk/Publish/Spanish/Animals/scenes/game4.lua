_GAME = 4
local storyboard = require( "storyboard")
local widget = require("widget")

local data = require("itemsData")
local constants = require( "constants")



local scene = storyboard.newScene()

local _BERRYPATH = "images/berry.png"
local _HOGPATH = "images/hog.png"
local _MUSHPATH = "images/grib"
local _FORMAT = ".png"

local _FONTSIZE = constants.H / 15
local _IMAGESIZE = 0.2*constants.H

local iteration = 1
local itemsFound = 0

local score
local sun
local cloud
local rain

local group

local layers = {}
local groups = {}
local hogs = {}
local mushrooms ={}
local berries = {}

local popupBg
local popupText
local nextBtn
local homeBtn

local soundHarp 
local birdSound
local rainSound
local hogSound

local timers = {}
local total, totalScore, bgscore, coins
local coinsToScore
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


local function onNextButtonClicked()
	storyboard.reloadScene( )
end

local function onHomeButtonClicked( event )
	--TO DO:
	local options =
		{
    		effect = "slideRight",
    		time = 400,
    		params = { ind = 4 }
		}
	storyboard.gotoScene("scenes.gametitle", options)
	storyboard.removeScene("scenes.game4")

end;

local function showPopUp()
	local soundWell = audio.loadSound( "sounds/welldone.mp3")
	audio.play( soundWell )
	popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY )
	popupBg.height = 0.7*constants.H
	popupBg.width = 0.7*constants.W

	popupText = display.newText("¡Bravo!", popupBg.x, 0, native.systemFont, 2*_FONTSIZE)
	popupText.y = popupBg.y - popupBg.height/4

	homeBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x - 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png"
	}
	homeBtn:addEventListener( "tap", onHomeButtonClicked )

	nextBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x + 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/next.png",
		overFile = "images/next.png"
	}       
	nextBtn:addEventListener( "tap", onNextButtonClicked )
end

local function onItemClicked(event)
	local t = event.target

	local function updateScore ()
		score.text = "Score: "..itemsFound
	end

	local function vanishAway ()    
		transition.to(t,{time = 1000, alpha = 0, x =constants.W, y = 0, xScale = 0.1, yScale = 0.1})
	end
	transition.scaleTo(t, {xScale = 1.5*t.xScale, yScale = 1.5*t.yScale, time = 500, onComplete = vanishAway})
	spawnExplosionToTable(t.x, t.y)
	t:removeEventListener( "touch", onItemClicked ) 

	itemsFound = itemsFound + 1
	
	if (itemsFound == 7) then
		soundHarp = audio.loadSound( "sounds/harp.ogg")
		audio.play( soundHarp )
		timers[#timers+1] = timer.performWithDelay( 800, showPopUp, 1)             
	end
end

local function fillWithHogs(group)
	local i
	hogSound = audio.loadSound("sounds/hog_sound2.mp3")
	audio.play(hogSound)

	for i = 1, 7, 1 do
		local function addHog()
			hogs[i] = display.newImage (_HOGPATH, data.hogsPositions.x[i], data.hogsPositions.y[i])
			hogs[i].width = data.HOGIMAGESIZE*data.hogsSizes[i]
			hogs[i].height = data.HOGIMAGESIZE*data.hogsSizes[i]
			hogs[i].xScale = 0.3
			hogs[i]:addEventListener( "touch", onItemClicked )  
			transition.to(hogs[i], {xScale = data.hogsScale[i], alpha =1, transition=easing.outBack, time = 300})                    
			groups[data.hogsGroups[i]]:insert (hogs[i])                             
		end
		timers[#timers + 1] = timer.performWithDelay( i*300, addHog )
	end  
	local function sayFind()
		findSound = audio.loadSound( "sounds/findhedgehogs.mp3" )
		audio.play( findSound )
	end
	timer.performWithDelay( 2100, sayFind )   
end

local function fillWithMushrooms(group)
	local i
	for i = 1, 7, 1 do
		local function addMushroom()
			mushrooms[i] = display.newImage (_MUSHPATH..data.mushroomsTypes[i].._FORMAT, data.mushroomsPositions.x[i], data.mushroomsPositions.y[i])
			mushrooms[i].width = data.MUSHIMAGESIZE*data.mushroomsSizes[i]
			mushrooms[i].height = data.MUSHIMAGESIZE*data.mushroomsSizes[i]
			mushrooms[i].xScale = 0.3
			mushrooms[i]:addEventListener( "touch", onItemClicked )
			transition.to(mushrooms[i], {xScale = data.mushroomsScale[i], alpha =1, transition=easing.outBack, time = 300})
			groups[data.mushroomsGroups[i]]:insert(mushrooms[i])
		end
		timers[#timers + 1] = timer.performWithDelay( i*300, addMushroom)
	end
	local function sayFind()
		findSound = audio.loadSound( "sounds/findmushrums.mp3" )
		audio.play( findSound )
	end
	timer.performWithDelay( 2100, sayFind ) 
end

local function fillWithBerries(group)
	local i
	for i = 1, 7, 1 do
		local function addBerry()
				berries[i] = display.newImage(_BERRYPATH, data.berriesPosition.x[i], data.berriesPosition.y[i])
				berries[i].width = data.BERRYIMAGESIZE * data.berriesSizes[i]
				berries[i].height = data.BERRYIMAGESIZE * data.berriesSizes[i]
				transition.to(mushrooms[i], {xScale = 1, alpha =1, transition=easing.outBack, time = 300})
				berries[i]:addEventListener( "touch", onItemClicked )
				groups[data.berriesGroups[i]]:insert(berries[i])
		end
		timers[#timers + 1] = timer.performWithDelay( i*300, addBerry )
	end
	local function sayFind()
		findSound = audio.loadSound( "sounds/findberryes.mp3" )
		audio.play( findSound )
	end
	timer.performWithDelay( 2100, sayFind ) 
end

local function sunAnimation ()
	birdSound = audio.loadSound("sounds/birds_sing.ogg")
	audio.play(birdSound)

	sun = display.newImage("images/sun.png", constants.W, constants.H)
	sun.width = _IMAGESIZE 
	sun.height = _IMAGESIZE
	sun.anchorY = 0.4
	-- groups[1]:insert(sun)
	group:insert(sun)
	local function fill ()
		audio.stop()
		timers[#timers + 1] = timer.performWithDelay( 500, fillWithHogs )
	end

	local function onRotateNeg()
		transition.to(sun, {rotation = 0, time = 1000, onComplete = fill})              
	end

	local function onRotatePos()            
		transition.to(sun, {rotation = 360, time = 1000, onComplete = onRotateNeg})                     
	end

	local function toNormal ()
		transition.scaleTo(sun, {xScale = 1, yScale = 1, time = 500, onComplete = onRotatePos})
	end

	local function toBig()
		transition.scaleTo(sun, {xScale = 1.5, yScale = 1.5, time = 500, onComplete = toNormal})
	end

	transition.moveTo(sun, {x = constants.CENTERX, y = _IMAGESIZE*0.8, time = 2000, transition=easing.outBack, onComplete = toBig})
end

local function onRainFinished(event)
	if (event.phase == "ended") then
		if (rain~=nil) then
			rain:removeSelf( )
			rain = nil
		end
		audio.pause( rainSound )
		fillWithMushrooms()
	end
end


local function rainAnimation()
	rainSound = audio.loadSound("sounds/rain_sound.ogg")
	audio.play( rainSound )
	cloud = display.newImage("images/tucha.png", 0,0)
	cloud.width = _IMAGESIZE
	cloud.height = _IMAGESIZE
	-- groups[1]:insert(cloud)
	group:insert(cloud)

	local function rainStart()
		local rainSheetData = 
		{
			width = constants.H,
			height = 2*constants.H/3,
			numFrames = 4,
			sheetContentWidth = constants.H*2,
			sheetContentHeight = 4*constants.H/3
		}
		local rainSheet = graphics.newImageSheet("images/rain.png", rainSheetData)
		local sequenceDataRain = 
		{
			name = "rain",
			start = 1,
			count = 4,
			time = 100,
			loopCount=6,
			loopDirection = forward
		}
		
		rain = display.newSprite( rainSheet, sequenceDataRain)
		group:insert(rain)
		rain.x = constants.CENTERX
		rain.y = constants.CENTERY
		rain:addEventListener( "sprite", onRainFinished)
		rain.timeScale = 0.4
		rain:play()

	end
	transition.moveTo(cloud, {x = constants.CENTERX, y = _IMAGESIZE*0.8, time = 2000, onComplete = rainStart})
end

function scene:createScene (event)

	group = self.view
	local i

	for i = 1, 10, 1 do
		layers[i] = display.newImage("images/layer"..i..".png", constants.CENTERX, constants.CENTERY)
		layers[i].height = constants.H
		layers[i].width = constants.W
	end     

	for i = 1,9,1 do
		groups[i] = display.newGroup( )
	end
	
	group:insert (1, layers[1])
	group:insert (2, groups[1])
	group:insert (3, layers[2])
	group:insert (4, groups[2])
	group:insert (5, layers[3])
	group:insert (6, groups[3])
	group:insert (7, layers[4])
	group:insert (8, groups[4])
	group:insert (9, layers[5])
	
	group:insert (10, groups[5])
	group:insert (11, layers[6])
	group:insert (12, groups[6])
	group:insert (13, layers[7])

	group:insert (14, groups[7])
	group:insert (15, layers[8])
	group:insert (16, groups[8])
	group:insert (17, layers[9])
	group:insert (18, groups[9])
	group:insert (19, layers[10])
	
end
		
function scene:enterScene(event)
	itemsFound = 0

	if iteration == 1 then  
		--TODO:Sun animation
		sunAnimation()                  
		iteration = iteration + 1               
	elseif iteration == 2 then
		--TODO: rain animation
		rainAnimation()
		--fillWithMushrooms(group)
		iteration = iteration + 1
	else
		--TODO ???
		fillWithBerries(group)
		iteration = 1
	end
end

function scene:exitScene(event)
	 --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	audio.stop()
	audio.dispose( rainSound )
	rainSound = nil
	audio.dispose(soundHarp)
	soundHarp = nil
	audio.dispose(birdSound)
	birdSound = nil
	audio.dispose(hogSound)
	hogSound = nil

	while (#timers > 0) do
		timer.cancel(timers[#timers])
		table.remove( timers )
	end

	transition.cancel()
	
	if (rain~=nil) then
		rain:removeSelf( )
		rain = nil
	end

	while (table.maxn(hogs)>0) do
        hogs[#hogs]:removeSelf()
        table.remove( hogs )
	end

	while (table.maxn(mushrooms)>0) do
        mushrooms[#mushrooms]:removeSelf()
        table.remove(mushrooms)
	end

	while (table.maxn(berries)>0) do
        berries[#berries]:removeSelf()
        table.remove(berries)
	end

	if (popupBg ~= nil) then
        popupBg:removeSelf()
        nextBtn:removeSelf()
        homeBtn:removeSelf()
        popupText:removeSelf()
        popupBg = nil
        nextBtn = nil
        homeBtn = nil
        popupText = nil
	end

	if (sun ~= nil) then
        sun:removeSelf()
        sun = nil
	end

	if (cloud ~= nil) then
        cloud:removeSelf( )
        cloud = nil
	end
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene