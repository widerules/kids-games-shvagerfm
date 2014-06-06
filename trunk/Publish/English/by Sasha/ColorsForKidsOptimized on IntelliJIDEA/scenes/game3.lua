local storyboard = require ("storyboard")
local widget = require ("widget")
local constants = require ("constants")
local data = require ("data.pairData")
local popup = require ("utils.popup")
local gmanager = require("utils.gmanager")

local scene = storyboard.newScene()

_GAME = 3

local _MAXLEVEL = 4

local cardAmount = {6, 8, 12, 16}
local rows = {2, 2, 3, 4}
local level = 1
local gameWon = 0

local background, backBtn
local butterflies
local folds = {}

local previous
local totalCards

local star = {}
local starToScore
local items = {}

local function backHome()
		local options =
		{
    		effect = "slideRight",
    		time = 800,
    		params = { ind = _GAME }
		}
		storyboard.gotoScene( "scenes.gametitle", options)
		storyboard.removeScene( "scenes.game3" )
end

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

local function onFoldClicked (event)
	event.target:removeEventListener( "tap", onFoldClicked )

	local function compare ()

		if previous ~= nil then

			if previous.butterflyType == event.target.butterflyType then

				local wellDone = audio.loadSound( "sounds/welldone.mp3" )
				audio.play(wellDone)
				local function checkAmount()
					totalCards = totalCards - 2
					if totalCards == 0	then
						popup.showPopUp("Well done!", "scenetemplate", "scenes.game3")
						gameWon = gameWon + 1
						if gameWon>0 and level < _MAXLEVEL then
							gameWon = 0
							level = level + 1
                        else
                            gmanager.nextGame()
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

	background = display.newImage ("images/background4.jpg", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)
    
    backBtn = widget.newButton
		{
		   height = 0.05*constants.W,
			width = 0.05*constants.W,
			top = 0,
			left = 0,
		    defaultFile = "images/back.png",
		    overFile = "images/back.png",
		    id = "home",
		    onRelease = backHome,
		    
		}
	group:insert( backBtn )

	local soundStart = audio.loadSound( "sounds/fpairs.mp3")
	audio.play(soundStart)

	gmanager.initGame()
end

function scene:willEnterScene(event)

end

function scene:enterScene (event)
	local group = self.view

	previous = nil
	butterflies = table.copy (data.butterflies)
	totalCards = cardAmount[level]

	local sheetData = {
		width = 512,
		height = 512,
		numFrames = 8,
		sheetContentWidth = 2048,
		sheetContentHeight = 1024
	}
	local butterfliesSheet = graphics.newImageSheet(data.butterfliesPath, sheetData)
	local sequenceData = {
		{
		name = "red",
		start = 1,
		count = 1,
		},
		{
		name = "orange",
		start = 2,
		count = 1,
		},
		{
		name = "yellow",
		start = 3,
		count = 1,
		},
		{
		name = "green",
		start = 4,
		count = 1,
		},
		{
		name = "indigo",
		start = 5,
		count = 1,
		},
		{
		name = "blue",
		start = 6,
		count = 1,
		},
		{
		name = "violet",
		start = 7,
		count = 1,
		},
		{
		name = "white",
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