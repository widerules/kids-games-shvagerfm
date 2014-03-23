local storyboard = require ("storyboard")
local widget = require ("widget")
local constants = require ("constants")
local data = require ("pairData")

local scene = storyboard.newScene()

local _FONTSIZE = constants.H / 13

local background
local butterflies
local folds = {}

local previous
local totalCards

local popupBg
local popupText
local homeBtn
local nextBtn

local function onHomeButtonClicked(event)
	--goto main screen	
end

local function onNextButtonClicked(event)
	storyboard.reloadScene( )
end

local function showPopUp()
	popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
	popupBg.height = 0.7*constants.H;
	popupBg.width = 0.7*constants.W;

	popupText = display.newText("Well done !", popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
	popupText.y = popupBg.y-popupBg.height+2*popupText.width/3;

	homeBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x - 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png",
		
	}
	homeBtn:addEventListener( "tap", onHomeButtonClicked );

	nextBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x + 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/next.png",
		overFile = "images/next.png"
	}	
	nextBtn:addEventListener( "tap", onNextButtonClicked);
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
	local function compare ()
		if previous ~= nil then
			if previous.butterflyType == event.target.butterflyType then
				print ("pair!")

				event.target:removeEventListener( "tap", onFoldClicked )
				previous:removeEventListener( "tap", onFoldClicked )

				local function checkAmount()
					totalCards = totalCards - 2
					if totalCards == 0	then
						showPopUp()
					end				
				end

				local function removeSecond()
					print("hey, I am here !")
					transition.to(items[findIndex(event.target)], {time = 1000, x = constants.W, y = 0, alpha = 0, onComplete = checkAmount})
				end
				transition.to(items[findIndex(previous)], {time = 1000, x = constants.W, y = 0, alpha = 0, onComplete = removeSecond})				
			else
				print("not pair!")
				transition.fadeIn( event.target, {time = 500} )
				transition.fadeIn(previous, {time = 500})
			end
			previous = nil
		else
			previous = event.target
		end
	end
	transition.fadeOut(event.target, {time = 500, onComplete = compare})
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage ("images/background3.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

end

function scene:willEnterScene(event)
	butterflies = table.copy (data.butterflies)
	totalCards = data.amount
end

function scene:enterScene (event)
	local group = self.view

	previous = nil

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
		name = "cyan",
		start = 5,
		count = 1,
		},
		{
		name = "blue",
		start = 6,
		count = 1,
		},
		{
		name = "purple",
		start = 7,
		count = 1,
		},
		{
		name = "white",
		start = 8,
		count = 1,
		}
	}
	

	local itemW
	local itemH = constants.H / 3
	itemW = itemH
	local i,j
	items = {}
	local temp

	local indexes = {}

	-- delete 2 random shape
	-- because we have 2 useless colors
	for i=1, 2 do
		table.remove(butterflies, math.random(1, #butterflies))
	end

	for i=1, #butterflies do
		indexes[butterflies[i]] = 2
	end
	local butterfly, index

	for i=1, 3 do
		for j=1, 4 do
			temp = display.newSprite( butterfliesSheet, sequenceData )

			index = math.random(1, 6)
			while indexes[butterflies[index]] == 0 do
				index = math.random(1, 6)
			end

			if indexes[butterflies[index]] > 0 then
				temp:setSequence(butterflies[index])				
				temp.butterflyType = butterflies[index]
				indexes[butterflies[index]] = indexes[butterflies[index]] - 1
			end

			temp.width = itemW
			temp.height = itemH

			temp.x = 1.15 * j * itemW - itemW  / 2 + constants.W / 17
			temp.y = i * itemH - itemH / 2

			--temp:addEventListener( "tap", onItemTap )

			table.insert(items, temp)
		end
	end

	for i=1, #items do
		group:insert( items[i] )

		folds[i] = display.newImage (data.foldPath, items[i].x, items[i].y)
		folds[i].width = items[i].width
		folds[i].height = 0.8*items[i].height
		folds[i]:addEventListener("tap", onFoldClicked)
		folds[i].butterflyType = items[i].butterflyType
		group:insert(folds[i])		
	end

end

function scene:exitScene(event)
	for i=1, #items do
		if items[i] then
			items[i]:removeSelf()
		end
	end

	for i = 1, #folds do
		if folds[i] then
			folds[i]:removeSelf()
		end
	end

	if popupBg ~= nil then
		popupBg:removeSelf()
		popupText:removeSelf()
		nextBtn:removeSelf()
		homeBtn:removeSelf()
		popupBg = nil
		popupText = nil
	end
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )


return scene