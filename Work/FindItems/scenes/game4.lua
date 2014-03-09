local storyboard = require( "storyboard")
local widget = require("widget")
--local timer = require( "timer")
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

local layers = {}
local groups = {}
local hogs = {}
local mushrooms ={}
local berries = {}

local popupBg
local popupText
local nextBtn
local homeBtn



local function onNextButtonClicked()
	storyboard.reloadScene( )
end

local function onHomeButtonClicked()
	--TODO: go to home screen
end

local function showPopUp()
        popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
        popupBg.height = 0.7*constants.H;
        popupBg.width = 0.7*constants.W;

        popupText = display.newText("Well done !", popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
        popupText.y = popupBg.y-popupBg.height+2*popupText.width/3;

        homeBtn = widget.newButton
        {
                width = 0.4*popupBg.width,
                height = 0.4*popupBg.height,
                x = popupBg.x - 0.4*popupBg.width/2,
                y = popupBg.y + popupBg.height/2 - 0.4*popupBg.height/2,
                defaultFile = "images/button.png",
                overFile = "images/pbutton.png",
                label = "Home",
                labelColor = {default = {0,0,0}, over = {0.1,0.1,0.1}},
                fontSize = 1.75*_FONTSIZE
        }
        homeBtn:addEventListener( "tap", onHomeButtonClicked );

        nextBtn = widget.newButton
        {
                width = 0.4*popupBg.width,
                height = 0.4*popupBg.height,
                x = popupBg.x + 0.4*popupBg.width/2,
                y = popupBg.y + popupBg.height/2 - 0.4*popupBg.height/2,
                defaultFile = "images/button.png",
                overFile = "images/pbutton.png",
                label = "Next",
                labelColor = {default = {0,0,0}, over = {0.1,0.1,0.1}},
                fontSize = 1.75*_FONTSIZE       
        }       
        nextBtn:addEventListener( "tap", onNextButtonClicked );
end

local function onItemClicked(event)
	local t = event.target

	local function updateScore ()
		score.text = "Score: "..itemsFound
	end

	local function vanishAway ()	
		transition.to(t,{time = 1000, alpha = 0, x =constants.W, y = 0, xScale = 0.1, yScale = 0.1, onComplete = updateScore})
	end	
	transition.scaleTo(t, {xScale = 1.5*t.xScale, yScale = 1.5*t.yScale, time = 500, onComplete = vanishAway})
	t:removeEventListener( "touch", onItemClicked )	

	itemsFound = itemsFound + 1
	
	if (itemsFound == 7) then
		timer.performWithDelay( 2000, showPopUp, 1)		
	end
end

local function fillWithHogs(group)
	
	for i = 1, 7, 1 do
		local function addHog()
			hogs[i]	= display.newImage (_HOGPATH, data.hogsPositions.x[i], data.hogsPositions.y[i])
			hogs[i].width = data.HOGIMAGESIZE*data.hogsSizes[i]
			hogs[i].height = data.HOGIMAGESIZE*data.hogsSizes[i]
			hogs[i].xScale = data.hogsScale[i]
			hogs[i]:addEventListener( "touch", onItemClicked )			
			groups[data.hogsGroups[i]]:insert (hogs[i])	
			transition.fadeIn( hogs[i], {time = 500} )
		end
		timer.performWithDelay( 1000, addHog )
	end	
end

local function fillWithMushrooms(group)
	for i = 1, 7, 1 do
		mushrooms[i] = display.newImage (_MUSHPATH..data.mushroomsTypes[i].._FORMAT, data.mushroomsPositions.x[i], data.mushroomsPositions.y[i])
		mushrooms[i].width = data.MUSHIMAGESIZE*data.mushroomsSizes[i]
		mushrooms[i].height = data.MUSHIMAGESIZE*data.mushroomsSizes[i]
		mushrooms[i].xScale = data.mushroomsScale[i]
		mushrooms[i]:addEventListener( "touch", onItemClicked )
		groups[data.mushroomsGroups[i]]:insert(mushrooms[i])

	end
end

local function fillWithBerries(group)
	for i = 1, 7, 1 do
		berries[i] = display.newImage(_BERRYPATH, data.berriesPosition.x[i], data.berriesPosition.y[i])
		berries[i].width = data.BERRYIMAGESIZE * data.berriesSizes[i]
		berries[i].height = data.BERRYIMAGESIZE * data.berriesSizes[i]
		berries[i]:addEventListener( "touch", onItemClicked )
		groups[data.berriesGroups[i]]:insert(berries[i])
	end
end

local function sunAnimation ()
	sun = display.newImage("images/sun.png", constants.W, constants.H)
	sun.width = _IMAGESIZE 
	sun.height = _IMAGESIZE
	sun.anchorY = 0.4
	groups[1]:insert(sun)

	local function fill ()
		timer.performWithDelay( 500, fillWithHogs )
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

	transition.moveTo(sun, {x = constants.CENTERX, y = _IMAGESIZE*0.8, time = 2000, onComplete = toBig})
end

local function rainAnimation()
	cloud = display.newImage("images/tucha.png", 0,0)
	cloud.width = _IMAGESIZE
	cloud.height = _IMAGESIZE
	groups[1]:insert(cloud)

	local function rainStart()
		local rainSheetData = 
		{
      		width = 240,
      		height = 157,
      		numFrames = 4,
      		sheetContentWidth = 480,
      		sheetContentHeight = 314
   		}
   		local rainSheet = graphics.newImageSheet("images/rain.png", rainSheetData)
      	local sequenceDataRain = 
      	{
      		name = "rain",
      		start = 1,
      		count = 4,
      		time = 100,
      		loopCount=4,
      		loopDirection = forward
      	}
   	
   		local rain = display.newSprite( rainSheet, sequenceDataRain)
   		rain.x = constants.CENTERX
   		rain.y = constants.CENTERY
   		rain.height = constants.H
   		rain.width = constants.W
   		rain:play()


	end
	transition.moveTo(cloud, {x = constants.CENTERX, y = _IMAGESIZE*0.8, time = 2000, onComplete = rainStart})
end

function scene:createScene (event)
	local group = self.view

	for i = 1, 14, 1 do
		layers[i] = display.newImage("images/layer"..i..".png", constants.CENTERX, constants.CENTERY)
		layers[i].height = constants.H
		layers[i].width = constants.W
	end	

	for i = 1,9,1 do
		groups[i] = display.newGroup( )
	end	

	group:insert (1, layers[1])
	group:insert (2, layers[2])
	group:insert (3, layers[3])
	group:insert (4, groups[1])
	group:insert (5, layers[4])
	group:insert (6, groups[2])
	group:insert (7, layers[5])
	group:insert (8, groups[3])
	group:insert (9, layers[6])
	group:insert (10, groups[4])
	group:insert (11, layers[7])
	group:insert (12, layers[8])
	group:insert (13, groups[5])
	group:insert (14, layers[9])
	group:insert (15, groups[6])
	group:insert (16, layers[10])
	group:insert (17, layers[11])
	group:insert (18, groups[7])
	group:insert (19, layers[12])
	group:insert (20, groups[8])
	group:insert (21, layers[13])
	group:insert (22, groups[9])
	group:insert (23, layers[14])
end
	
function scene:enterScene(event)
	local group = self.view
	
	itemsFound = 0

	score = display.newText("Score: 0", constants.W - _FONTSIZE/2, _FONTSIZE/2, native.systemFont, _FONTSIZE)
	score.x = constants.W-score.width/2
	if iteration == 1 then	
		--TODO:Sun animation
		sunAnimation()	
		--fillWithHogs(group)
		iteration = iteration + 1
		rainAnimation()
	elseif iteration == 2 then
		--TODO: rain animation
		fillWithMushrooms(group)
		iteration = iteration + 1
	else
		--TODO ???
		fillWithBerries(group)
		iteration = 1
	end
end

function scene:exitScene(event)

	score:removeSelf( )
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
	end

	if (sun ~= nil) then
		sun:removeSelf()
	end
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene