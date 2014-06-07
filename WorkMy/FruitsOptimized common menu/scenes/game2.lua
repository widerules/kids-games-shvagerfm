local storyboard = require("storyboard")
local widget = require("widget")
local data = require ("data.findData")
local constants = require("constants")

local scene = storyboard.newScene()

_GAME = 2

---------------------------------------texts
local findVegTask = "Look for Vegetables!"
local findFrtTask = "Look for Fruits!"

local _FONTSIZE = constants.H / 7
local _BTNSIZE = 0.1*constants.W

local gamesWon = 0
local level = 1
local itemsCount = {2, 3, 4, 6, 9, 12, 16, 20}
local rows =       {1, 1, 2, 2, 3, 3, 4, 4}
local items = {}
local images = {}

local imageSize, spacing
local itemType, searchAmount
local taskLabel, homeButton

local soundName
local soundItIs
local soundTitle
local star = {}

local function toTitle()
	local options = 
	{
		effect = "slideLeft",
		time = 800
	}
	storyboard.gotoScene("scenes.menu", options)
	storyboard.removeScene( "scenes.game2" )
end

local function onHomeButtonTapped (event)
	toTitle()
end

--makes a set of names of fruits and vegetables
local function generateItems()
	local tmpindex = 1

	local veg = table.copy(data.vegetables)	
	for i = 1, math.round(itemsCount[level]/2) do
		tmpindex = math.random(1,#veg)	 
		items[i] = {}
		items[i].value = veg[tmpindex]
		items[i].type = "vegetable"
		table.remove(veg, tmpindex)

		if #veg < 1 then
			veg = table.copy(data.vegetables)
		end
	end

	local frt = table.copy(data.fruits)
	for i = math.round(itemsCount[level]/2)+1, itemsCount[level] do
		tmpindex = math.random(1,#frt)
		items[i] = {}
		items[i].value = frt[tmpindex]
		items[i].type = "fruit"
		table.remove (frt, tmpindex)

		if #frt<1 then
			frt = table.copy(data.fruits)
		end
	end
end
---tap on object
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
					storyboard.reloadScene()					
				else
					toTitle()
				end
			else
				storyboard.reloadScene()
			end			
		end
	end
-- right choice
	if event.target.type == itemType then
		soundName = audio.loadSound( "sounds/"..event.target.name..".mp3" )
		audio.play( soundName )
		event.target:removeEventListener( "tap", onItemTapped )
		transition.fadeOut( event.target, {time = 500, onComplete = encreaseScore} )	
-- wrong choice	
	else
		soundItIs = audio.loadSound( "sounds/"..event.target.name.."is"..event.target.type..".mp3" )
		audio.play( soundItIs )
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

	background = display.newImage("images/background2.jpg", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)
	
	homeButton = widget.newButton
	{
		x = _BTNSIZE/2,
		y = _BTNSIZE/2,
		defaultFile = "images/back.png",
		overFile = "images/back.png",
		width = _BTNSIZE,
		height = _BTNSIZE,
		onRelease = onHomeButtonTapped
	}
	group:insert(homeButton)
	
	gamesWon = 0
	level = 1
end

function scene:willEnterScene(event)
	--computing size of spacing and actual image size, according to the amount of the items
	imageSize = constants.H/(rows[level]+1)
	spacingX = (constants.W - (itemsCount[level]/rows[level])*imageSize)/(itemsCount[level]/rows[level]+1)
	spacingY = imageSize / (rows[level]+1)

	--defining which type of items we will look for and amount of items of this type on the board
	itemType = data.types[math.random(1,2)]
	searchAmount = math.round(itemsCount[level]/2)
	if itemType == "fruit" and itemsCount[level]%2 == 1 then
		searchAmount = searchAmount - 1
	end

end

function scene:enterScene(event)
	local group = self.view
	
	generateItems()
	for i = 1, itemsCount[level]/rows[level] do
		images[i] = {}
		for j = 1, rows[level] do
			local index = math.random (1, #items)			
			images[i][j] = display.newImage( data.pathToItems..items[index].value..data.format, i*spacingX+(i-0.5)*imageSize, j*spacingY+(j-0.5)*imageSize)			
			images[i][j].width = imageSize
			images[i][j].height = imageSize
			images[i][j].name = items[index].value
			images[i][j].type = items[index].type
			images[i][j]:addEventListener("tap", onItemTapped)
			group:insert(images[i][j])
			table.remove(items, index)
		end
	end

	local function hideLabel()
		transition.fadeOut( taskLabel, {time = 500} )
	end

	taskLabel = display.newEmbossedText( "", constants.CENTERX, constants.CENTERY, native.systemFont, _FONTSIZE )	
	if itemType == "vegetable" then
		soundTitle = audio.loadSound( "sounds/lookforvegetables.mp3" )
		taskLabel.text = findVegTask
	else
		soundTitle = audio.loadSound( "sounds/lookforfruits.mp3" )
		taskLabel.text = findFrtTask
	end
	audio.play( soundTitle )
	taskLabel.xScale = 0.3
	taskLabel.yScale = 0.3
	taskLabel:setFillColor( 0,0,0 )
	group:insert(taskLabel)
	transition.to(taskLabel, {time = 500, xScale = 1, yScale = 1, onComplete = function() timer.performWithDelay(1000, hideLabel) end})
---stars
	for i=1, 8 do
		if i < level then
			star[i] = display.newImage("images/starfull.png", 0, 0, constants.H/8, constants.H/8)
		else
	star[i] = display.newImage("images/star.png", 0, 0, constants.H/8, constants.H/8)
	end
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

			display.remove( images[i][j] )
			
			end
		end
	end	
	display.remove( taskLabel )

end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
return scene