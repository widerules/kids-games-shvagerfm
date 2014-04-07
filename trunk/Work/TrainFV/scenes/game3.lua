local storyboard = require ("storyboard")
local constants = require("constants")
local data = require("data.trainData")
local popup = require ("utils.popupTrain")
local scene = storyboard.newScene()

local _FONTSIZE = constants.H / 15
local _INFOSIZE = constants.H/6
local _SPACINGY = constants.H/15
local _BASKETSIZE = 0.4*constants.H
local _ITEMSIZE = 0.3*constants.H
local _SPEED = 10000  -- less - faster
local _DELTA = 0.15*constants.H;
local _SCORETOUP = 5

-----------------------------------------------texts
local _SCORETEXT = "Score: "
local _LEVELTEXT = "Level: "
local _LIFETEXT = "Lifes: "
local _LEVELUPTEXT = "Level up!"

local background, informationBackground, fruitBasket, vegetableBasket
local score, level, lifes, currentTimer, itemsGenerated
local scoreLabel, levelLabel, lifesLabel, levelUpLabel
local fruits, vegetables

--make item bigger on touch
local function scaleOnDrag (target)
	target.xScale = 1.2
	target.yScale = 1.2
end

--on item out of screen or put to wrong basket - lifes decreased and checked to be more than zero
local function decLifes()
	if lifes > 0 then 
		lifes = lifes - 1
		lifesLabel.text = _LIFETEXT..lifes

		if lifes < 1 then
			transition.cancel( )
			timer.cancel( currentTimer )
			popup.showPopUp (_SCORETEXT..score, "scenetemplate", "scenes.game3")
		end

		transition.to (lifesLabel, {time = 300, xScale = 1.6, yScale = 1.6, onComplete = function() transition.to(lifesLabel, {time = 300, xScale = 1, yScale = 1}) end})
	end
end

--if transition finished, this means that item is out of screen - so we should remove it and decrease lifes
local function onTransitionFinished(item)
	display:remove(item)
	decLifes()
end

--stop transition and move element wherever you want, rather put it to a basket or drop down
local function onElementTouched (event)
	local t = event.target
	local phase = event.phase

	transition.cancel(t.transition) --stops moving of the object	
	scaleOnDrag(t)		 --makes object bigger

	if phase == "began" then
		local parent = t.parent
		parent:insert(t)
		display.getCurrentStage():setFocus(t)

		t.isFocus = true
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

	elseif phase == "moved" and t.isFocus then
		t.x = event.x - t.x0
		t.y = event.y - t.y0

	elseif phase == "ended" or phase == "cancel" then
		t:removeEventListener( "touch", onElementTouched )
		display.getCurrentStage():setFocus(nil)
		t.isFocus = false

		local flag = false
	
		if  t.type == fruitBasket.type then
			if math.abs(t.x - fruitBasket.x)<_DELTA and math.abs(t.y-fruitBasket.y)<_DELTA then
				transition.to(t,{time = 300, x = fruitBasket.x, y = fruitBasket.y, alpha = 0, onCancel = onTransitionCanceled})
				score = score + 1
				scoreLabel.text = _SCORETEXT..score
				flag = true
			else
				transition.to(t,{time = 300, x = constants.CENTERX, y = constants.H+ _ITEMSIZE, alpha = 0, onComplete = decLifes, onCancel = onTransitionCanceled})
			end
		else
			if math.abs(t.x - vegetableBasket.x)<_DELTA and math.abs(t.y - vegetableBasket.y)<_DELTA then
				transition.to(t,{time = 300, x = vegetableBasket.x, y = vegetableBasket.y, alpha = 0, onCancel = onTransitionCanceled})
				score = score + 1
				scoreLabel.text = _SCORETEXT..score
				flag = true
			else
				transition.to(t,{time = 300, x = constants.CENTERX, y = constants.H+ _ITEMSIZE, alpha = 0, onComplete = decLifes, onCancel = onTransitionCanceled})
			end
		end	
		if flag == true then
			
			--SOUND_PLACE : correct basket
			--firework

			if score >= level*_SCORETOUP and _SPEED > 4500 then			
				_SPEED = _SPEED - 500
				itemsGenerated = 0

				level = level + 1

				levelUpLabel = display.newEmbossedText( _LEVELUPTEXT, constants.CENTERX, constants.CENTERY, native.systemFont, 2*_FONTSIZE )
				
				transition.to (levelUpLabel, 
				{
					time = 500,
					x = levelLabel.x,
					y = levelLabel.y,
					alpha = 0.1,
					xScale = 0.5,
					yScale = 0.5,
					onComplete = function ()
						levelLabel.text = _LEVELTEXT..level
						display.remove(levelUpLabel)
						levelUpLabel = nil		
					end
				})
			end
		else

			--SOUND_PLACE : uncorrect basket

		end		
	end
end

--if game lost - we stops all transitions and lets items fall down 
local function onTransitionCanceled(item)
	if lifes<1 then 
		item:removeEventListener( "touch", onElementTouched )
		transition.to (item, {time = 500, y = constants.H+_ITEMSIZE/2, alpha = 0, onComplete = function() display:remove(item) end})
	end
end

--generates one element and recursively calls it self 
local function generateElement(group)
	local item

	local itemType = data.types[math.random(1,2)]

	if itemType == "fruit" then
		if #fruits < 1 then
			fruits = table.copy(data.fruits)
		end

		local index = math.random (1, #fruits)
		item = display.newImage( data.pathToItems..fruits[index]..data.format, constants.W + _ITEMSIZE/2, constants.CENTERY - _SPACINGY)
		item.type = "fruit"

		table.remove( fruits, index )
	else
		if #vegetables < 1 then
			vegetables = table.copy(data.vegetables)
		end

		local index = math.random (1, #vegetables)
		item = display.newImage( data.pathToItems..vegetables[index]..data.format, constants.W + _ITEMSIZE/2, constants.CENTERY - _SPACINGY)
		item.type = "vegetable"

		table.remove(vegetables, index)
	end 

	item.width = _ITEMSIZE
	item.height = _ITEMSIZE
	item:addEventListener( "touch", onElementTouched )
	item.transition = transition.to (item, {time = _SPEED, x = 0 - _ITEMSIZE/2, onComplete = onTransitionFinished, onCancel = onTransitionCanceled})
	group:insert(item)

	itemsGenerated = itemsGenerated + 1

	if lifes > 0 then
		currentTimer = timer.performWithDelay( _SPEED/constants.W*_ITEMSIZE, function () generateElement(group) end )
	end
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage( "images/background3.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	informationBackground = display.newImage("images/informationbg.png", constants.CENTERX, _INFOSIZE/2)
	informationBackground.width = constants.W
	informationBackground.height = _INFOSIZE	
	group:insert(informationBackground)

	fruitBasket = display.newImage ("images/fruit_basket.png", 0, 0)
	fruitBasket.x = constants.CENTERX - _BASKETSIZE
	fruitBasket.y = constants.H - _BASKETSIZE/2
	fruitBasket.width = _BASKETSIZE
	fruitBasket.height = _BASKETSIZE
	fruitBasket.type = "fruit"
	group:insert(fruitBasket)

	vegetableBasket = display.newImage("images/vegetable_basket.png", 0, 0)
	vegetableBasket.x = constants.CENTERX + _BASKETSIZE
	vegetableBasket.y = constants.H - _BASKETSIZE/2
	vegetableBasket.width = _BASKETSIZE
	vegetableBasket.height = _BASKETSIZE
	vegetableBasket.type = "vegetable"
	group:insert(vegetableBasket)


end

function scene:enterScene (event)
	local group = self.view

	lifes = 5
	score = 0
	level = 1
	itemsGenerated = 0
	_SPEED = 10000

	fruits = table.copy(data.fruits)
	vegetables = table.copy(data.vegetables)

	scoreLabel = display.newEmbossedText( _SCORETEXT..score, 0, informationBackground.y, native.systemFont, _FONTSIZE )
	scoreLabel.anchorX = 0
	group:insert(scoreLabel)

	levelLabel = display.newEmbossedText( _LEVELTEXT..level, informationBackground.x, informationBackground.y, native.systemFont, _FONTSIZE)
	group:insert (levelLabel)

	lifesLabel = display.newEmbossedText( _LIFETEXT..lifes, constants.W, informationBackground.y, native.systemFont, _FONTSIZE )
	lifesLabel.anchorX = 1
	group:insert(lifesLabel)


	generateElement(group)
end

function scene:exitScene(event)
	lifes = 0
	transition.cancel()

	popup.hidePopUp()

	display.remove(scoreLabel)
	display.remove(levelLabel)
	display.remove(levelUpLabel)
	display.remove(lifesLabel)
	scoreLabel = nil
	levelLabel = nil
	levelUpLabel = nil
	lifesLabel = nil
end

function scene:destroyScene(event)
	background:removeSelf( )
	informationBackground:removeSelf()
	fruitBasket:removeSelf( )
	vegetableBasket:removeSelf( )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene