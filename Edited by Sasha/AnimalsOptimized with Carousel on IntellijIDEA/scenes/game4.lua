local storyboard = require( "storyboard")
local popup = require("utils.popup")
local data = require("data.itemsData")
local constants = require( "constants")
local explosion = require( "utils.explosion" )

local scene = storyboard.newScene()

explosion.createExplosion()

local _BERRYPATH = "images/berry.png"
local _HOGPATH = "images/hog.png"
local _MUSHPATH = "images/grib"
local _FORMAT = ".png"

local _IMAGESIZE = 0.2*constants.H

_GAME = 4

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

local soundHarp 
local birdSound
local rainSound
local hogSound

local timers = {}
local total, totalScore, bgscore, coins
local coinsToScore

local function onNextButtonClicked()
	storyboard.reloadScene( )
end

local function onHomeButtonClicked( event )
    popup.hidePopup()
	local options =
		{
    		effect = "slideRight",
    		time = 400
		}
	storyboard.gotoScene("scenes.gametitle", options)
	storyboard.removeScene("scenes.game4")

end;

local function onItemClicked(event)
	local t = event.target

	local function updateScore ()
		score.text = "Score: "..itemsFound
	end

	local function vanishAway ()    
		transition.to(t,{time = 1000, alpha = 0, x =constants.W, y = 0, xScale = 0.1, yScale = 0.1})
	end
	transition.scaleTo(t, {xScale = 1.5*t.xScale, yScale = 1.5*t.yScale, time = 500, onComplete = vanishAway})
	explosion.spawnExplosion(t.x, t.y)
	t:removeEventListener( "touch", onItemClicked ) 

	itemsFound = itemsFound + 1
	
	if (itemsFound == 7) then
		soundHarp = audio.loadSound( "sounds/harp.ogg")
		audio.play( soundHarp )
		timers[#timers+1] = timer.performWithDelay( 800, popup.showPopupWithNextButton("Well done !", "scenes.gametitle", "scenes.game4"), 1)
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
			display.remove( rain )
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
		
		sunAnimation()                  
		iteration = iteration + 1               
	elseif iteration == 2 then
		
		rainAnimation()
		
		iteration = iteration + 1
	else
		
		fillWithBerries(group)
		iteration = 1
	end
end

function scene:exitScene(event)
	
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
		display.remove( rain )
		rain = nil
	end

	while (table.maxn(hogs)>0) do
		display.remove( hogs[#hogs] )
        table.remove( hogs )
	end

	while (table.maxn(mushrooms)>0) do
		display.remove( mushrooms[#mushrooms] )
        table.remove(mushrooms)
	end

	while (table.maxn(berries)>0) do
		display.remove( berries[#berries] )
        table.remove(berries)
	end

	if (sun ~= nil) then
		display.remove( sun )
        sun = nil
	end

	if (cloud ~= nil) then
		display.remove( cloud )
        cloud = nil
    end
end

function scene:destroyScene(event)
    explosion.destroyExplosion()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene