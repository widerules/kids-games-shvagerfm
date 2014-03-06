local storyboard = require( "storyboard")
local widget = require( "widget")
local data = require( "feedData")
local constants = require( "constants")

local scene = storyboard.newScene( )

local _ANIMALSPATH = "images/animals/"
local _FOODPATH = "images/food/"
local _FORMAT = ".png"

local _FONTSIZE = constants.H / 15;
local _IMAGESIZE = 0.4*constants.H;
local _FOODSIZE = 0.7*_IMAGESIZE;
local _SPACING = 0.1*constants.H;
local _DELTA = 0.08*constants.H;

local _PANECENTERX
local _BARCENTERX

local indexes = {}
local positions = {}
local foodPositions = {}
local animalsPictures = {}
local foodPictures = {}

local background;
local rightBar;
local pane;

local onPlaces

local function generateIndexes ()
	local tmp = {}
	for i = 1,table.maxn(data.animals),1 do
		table.insert(tmp,i)
	end

	local rand;
	for i = 1, 3, 1 do
		rand = math.random(1, table.maxn(tmp))
		table.insert(indexes,tmp[rand])
		table.remove( tmp, rand )
	end
end

local function animScaleOnDrag(self)
	self.xScale = 1.5
	self.yScale = 1.5
end

local function animScaleBack(self)
	self.xScale = 1
	self.yScale = 1
end

local function animOnPutOn(self)
	--[[local function setToBig()
		transition.scaleTo(self, {xScale = 1.5, yScale = 1.5, time = 500})
	end	]]
	--transition.scaleTo(self, {xScale = 1.3, yScale = 1.3, time = 300, onComplete=setToBig})
	local function animFinished()
		self:toBack()		
	end
	transition.scaleTo(self, {xScale = 0, yScale = 0, time = 500, onComplete = animFinished})
end

local function onHomeButtonClicked(event)
	--TODO: go to home screen

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

local function onFoodDrag (event)
local t = event.target
	local phase = event.phase
	animScaleOnDrag(t)
	if "began" == phase then 
		startX = t.x
		startY = t.y
		
		local parent = t.parent
		parent:insert (t)
		display.getCurrentStage():setFocus(t)
		
		t.isFocus = true
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

	elseif "moved" == phase and t.isFocus then
		t.x = event.x-t.x0
		t.y = event.y-t.y0
	elseif "ended" == phase or "cancel" == phase then 
		
		local flag = false
		local index = 0

		--find which food dragged
		for i = 1, table.maxn(foodPictures), 1 do
			if foodPictures[i]==t then
				index = i
			end
		end		

		if math.abs(t.x - animalsPictures[index].x)<_DELTA and math.abs (t.y-animalsPictures[index].y)<_DELTA then
			t.x = animalsPictures[index].x
			t.y = animalsPictures[index].y
			onPlaces = onPlaces + 1;
			animOnPutOn(t)
			t:removeEventListener( "touch", onFoodDrag )
		else 
			t.x = startX
			t.y = startY
			animScaleBack(t)
		end;

		display.getCurrentStage():setFocus(nil)
		t.isFocus = false
		startX = nil
		startY = nil

		if onPlaces == 3 then
			timer.performWithDelay( 1500, showPopUp, 1)
		end

	end
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage("images/bg.png", constants.CENTERX, constants.CENTERY)
	background.height = constants.H
	background.width = constants.W
	group:insert(background)

	rightBar = display.newImage("images/right_bar.png", 0, constants.CENTERY)
	rightBar.height = constants.H
	rightBar.width = 0.2*constants.W
	rightBar.x = constants.W - rightBar.width/2;
	group:insert(rightBar)

	_BARCENTERX = rightBar.x

	pane = display.newImage("images/layer.png",0,constants.CENTERY)
	pane.height = 0.9*constants.H
	pane.width = 0.7*constants.W
	pane.x = pane.width/2+0.05*constants.W
	group:insert(pane)

	_PANECENTERX = pane.x

	positions = 
	{
		x = 
		{
			pane.x - _IMAGESIZE/2-_SPACING,
			pane.x + _IMAGESIZE/2+_SPACING,
			pane.x - _IMAGESIZE/2-_SPACING
		},
		y = 
		{
			pane.y - _IMAGESIZE/2 - _SPACING/3,
			pane.y,
			pane.y + _IMAGESIZE/2 + _SPACING/3

		}	
	}
end

function scene:enterScene(event)
	local group = self.view;

	onPlaces = 0

	generateIndexes();
	positions.foodY = 
	{
		_FOODSIZE/2+_SPACING,
		3*_FOODSIZE/2+_SPACING,
		5*_FOODSIZE/2+_SPACING
	}

	local randFood

	for i = 1, 3, 1 do
		animalsPictures[i] = display.newImage( _ANIMALSPATH..data.animals[indexes[i]].._FORMAT, positions.x[i],positions.y[i])
		animalsPictures[i].height = _IMAGESIZE
		animalsPictures[i].width = _IMAGESIZE
		group:insert(animalsPictures[i])

		randFood = math.random( 1, table.maxn(positions.foodY))

		foodPictures[i] = display.newImage (_FOODPATH..data.food[indexes[i]].._FORMAT, _BARCENTERX, positions.foodY[randFood])
		foodPictures[i].height = _FOODSIZE
		foodPictures[i].width = _FOODSIZE
		foodPictures[i]:addEventListener( "touch", onFoodDrag )
		group:insert(foodPictures[i])	

		table.remove(positions.foodY, randFood)
	end
end

function scene:exitScene(event)
	while (table.maxn(indexes)>0) do
		table.remove( indexes )
	end

	while (table.maxn(animalsPictures) > 0) do
		animalsPictures[#animalsPictures]:removeSelf()
		table.remove(animalsPictures)
	end

	while (table.maxn(foodPictures) > 0) do
		foodPictures[#foodPictures]:removeSelf()		
		table.remove(foodPictures)
	end

	if popupBg ~= nil then
		popupBg:removeSelf();
		popupText:removeSelf();
		nextBtn:removeSelf();
		homeBtn:removeSelf();
	end;
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene