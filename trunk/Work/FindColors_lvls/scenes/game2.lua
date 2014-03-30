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
				if level<8 then
					level = level + 1
				end
			end
			storyboard.reloadScene()
		end
	end
-- right choice
	if event.target.type == itemType then
		--soundName = audio.loadSound( "sounds/"..event.target.name..".mp3" )
		--audio.play( soundName )
		event.target:removeEventListener( "tap", onItemTapped )
		transition.fadeOut( event.target, {time = 500, onComplete = encreaseScore} )	
-- wrong choice	
	else
		--soundItIs = audio.loadSound( "sounds/"..event.target.name.."is"..event.target.type..".mp3" )
		--audio.play( soundItIs )
		local function toNormal()
			transition.to (event.target,{rotation = 0,  time = 125})
		end
		local function toRight()
			transition.to (event.target,{rotation = 30,  time = 250, onComplete = toNormal})
		end
		transition.to (event.target,{rotation = -30,  time = 125, onComplete = toRight})
	end
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage("images/background2.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)	
	
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
	--audio.play( soundTitle )
	taskLabel.xScale = 0.3
	taskLabel.yScale = 0.3
	taskLabel:setFillColor( 0,0,0 )
	group:insert(taskLabel)
	transition.to(taskLabel, {time = 500, xScale = 1, yScale = 1, onComplete = function() timer.performWithDelay(1000, hideLabel) end})
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