local storyboard = require ("storyboard")
local constants = require("constants")
local data = require ("pairData")

local scene = storyboard.newScene()

_GAME = 5

local _FONTSIZE = constants.H / 13
local _MAXLEVEL = 4
local _ITEMH, _ITEMW

local cardAmount = {6, 8, 12, 16}
local rows = {2, 2, 3, 4}
local level = 1
local gameWon = 0

local background, backBtn
local animals = {}
local folds = {}

local previous
local totalCards

local star = {}
local starToScore
local items = {}


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
			print ("second press")
			if previous.animalType == event.target.animalType then
				
				--previous:removeEventListener( "tap", onFoldClicked )
				--local wellDone = audio.loadSound( "sounds/welldone.mp3" )
				--audio.play(wellDone)
				local function checkAmount()
					totalCards = totalCards - 2
					if totalCards == 0	then
						--popup.showPopUp("Well done!", "scenetemplate", "scenes.game3")
						gameWon = gameWon + 1
						if gameWon>0 and level < _MAXLEVEL then
							gameWon = 0
							level = level + 1
                        else
                            --gmanager.nextGame()
							level = 1
						end
						storyboard.reloadScene( )
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
			print ("previous is nil")
		else
			print ("first press")
			--local soundName = audio.loadSound( "sounds/"..event.target.butterflyType..".mp3" )
			--audio.play(soundName)
			previous = event.target
		end
	end
	transition.to(event.target, {time = 500, xScale = 0, alpha = 0, transition = easing.inBack, onComplete = compare})
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage( "images/background5.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)
end

function scene:enterScene (event)
	local group = self.view

	previous = nil
	animals = table.copy(data.animals)
	totalCards = cardAmount[level]

	if constants.H / rows[level]<constants.W/(cardAmount[level]/rows[level]) then
		itemH = 0.9*constants.H / rows[level]
		itemW = itemH
	else
		itemW = 0.9*constants.W / (cardAmount[level]/rows[level]+1)
		itemH = itemW
	end

	local spacingX = (constants.W - itemW * cardAmount[level]/rows[level]) / (cardAmount[level]/rows[level]+1) 
	local spacingY = (constants.H - itemH * rows[level]) / (rows[level]+1) 

	items = {}
	local temp

	local indexes = {}

	for i=1, #data.animals - cardAmount[level]/2 do
		local posToRemove = math.random(1, #animals)
		print(posToRemove)
		table.remove(animals, posToRemove)
	end

	for i=1, #animals do
		indexes[animals[i]] = 2
	end

	local animal, index


	for i=1, rows[level] do
		for j= 1, (cardAmount[level]/rows[level]) do
			index = math.random(1, cardAmount[level]/2)
			while indexes[animals[index]] == 0 do
				index = math.random(1, cardAmount[level]/2)
			end

			if indexes[animals[index]] > 0 then
				temp = display.newImage (data.animalsPath..animals[index]..data.format, 0, 0)
				temp.animalType = animals[index]
				indexes[animals[index]] = indexes[animals[index]] - 1
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
		folds[i].animalType = items[i].animalType
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

	for i = 1, #star do
		display.remove (star[i])
		star[i] = nil
	end
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene