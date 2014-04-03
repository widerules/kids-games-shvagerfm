local storyboard = require ("storyboard")
local constants = require("constants")
local data = require("data.trainData")

local scene = storyboard.newScene()

local _INFOSIZE = constants.H/6
local _SPACINGY = constants.H/15
local _BASKETSIZE = 0.4*constants.H
local _ITEMSIZE = 0.3*constants.H
local _SPEED = 5000
local _DELTA = 0.15*constants.H;

local background, informationBackground, fruitBasket, vegetableBasket
local score, lifes

--make item bigger on touch
local function scaleOnDrag (target)
	target.xScale = 1.2
	target.yScale = 1.2
end


local function transitionFinished(item)
	item:removeSelf()

	lifes = lifes - 1	
	--[[if lifes < 1 then
		transition.cancel( )
		print ("you loose")
	end]]
end


--stop transition and move element wherever you want, rather put it to a basket or drop down
local function onElementTouched (event)
	local t = event.target
	transition.cancel(t)
	local phase = event.phase
	scaleOnDrag(t)

	if phase == "began" then
		startX = t.x
		startY = t.y

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
			startX = nil
			startY = nil

			if  t.type == fruitBasket.type then
				if math.abs(t.x - fruitBasket.x)<_DELTA and math.abs(t.y-fruitBasket.y)<_DELTA then
					transition.to(t,{time = 300, x = fruitBasket.x, y = fruitBasket.y, alpha = 0})
					score = score + 1
				else
					transition.to(t,{time = 300, x = constants.CENTERX, y = constants.H+ _ITEMSIZE, alpha = 0})

				end
			else
				if math.abs(t.x - vegetableBasket.x)<_DELTA and math.abs(t.y - vegetableBasket.y)<_DELTA then
					transition.to(t,{time = 300, x = vegetableBasket.x, y = vegetableBasket.y, alpha = 0})
					score = score + 1
				else
					transition.to(t,{time = 300, x = constants.CENTERX, y = constants.H+ _ITEMSIZE, alpha = 0})
				end
			end			
		end

end

local function generateElement(group)
	local item

	local fruits = table.copy(data.fruits)
	local vegetables = table.copy(data.vegetables)

	local itemType = data.types[math.random(1,2)]

	if itemType == "fruit" then
		if #fruits < 1 then
			fruits = table.copy(data.fruits)
		end

		local index = math.random (1, #fruits)
		item = display.newImage( data.pathToItems..fruits[index]..data.format, - _ITEMSIZE/2, constants.CENTERY - _SPACINGY)
		item.type = "fruit"
	else
		if #vegetables < 1 then
			vegetables = table.copy(data.vegetables)
		end

		local index = math.random (1, #vegetables)
		item = display.newImage( data.pathToItems..vegetables[index]..data.format, - _ITEMSIZE/2, constants.CENTERY - _SPACINGY)
		item.type = "vegetable"
	end 
	item.width = _ITEMSIZE
	item.height = _ITEMSIZE
	item:addEventListener( "touch", onElementTouched )
	item.transition = transition.to (item, {time = _SPEED, x = constants.W + _ITEMSIZE, onComplete = transitionFinished(item)})
	group:insert(item)

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

	lifes = 3
	score = 0
end

function scene:enterScene (event)
	local group = self.view

	--here would be while
	for i = 1,10 do
		timer.performWithDelay(i*_SPEED/constants.W*_ITEMSIZE, function() generateElement(group) end)
	end
end

function scene:exitScene(event)
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