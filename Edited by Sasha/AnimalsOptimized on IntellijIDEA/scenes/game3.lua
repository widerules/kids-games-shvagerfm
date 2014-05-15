local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local data = require("data.shapesData")
local popup = require("utils.popup")

local scene = storyboard.newScene()

local _WELLDONETEXT = "Well done !"

local _BARHEIGHT = 0.2*constants.H
local _DELTA = 0.1*constants.W
local _FONTSIZE = constants.H / 14
local _MAXLEVEL = 21
local _BUTTONSIZE
local _SCALEVAL			--коэфициент увеличения животного до размеров его тени
local _ITEMSIZE 		--размер животного
local _SHADOWSIZE 		--размер тени
local _SPACINGANIMALS 	--отступы между животными в нижнем баре
local _SPACINGSHADOWS	--отступы по горизонтали между тенями
local _PLATEXZERO 		--левый верхний угол деревянной панели
local _PLATEYZERO

local itemAmount = 		{1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 8} --items
local shadowAmount = 	{1, 2, 3, 2, 3, 4, 3, 4, 5, 4, 5, 6, 5, 6, 7, 6, 7, 8, 7, 8, 8}	--shadows
local rows = 			{1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}	--rows

local animals = {}
local animalsImages = {}
local shadows = {}
local shadowsImages = {}
local stars = {}
local animalSound;

local starToScore

local level, onPlaces
local background, barBackground, plate, wellDoneLabel, homeBtn

local function onHomeButtonClicked( event )
    popup.hidePopup()
	local options =
		{
    		effect = "slideRight",
    		time = 500
		}
	storyboard.gotoScene("scenes.gametitle", options)
	storyboard.removeScene("scenes.game3")

end;

local function animScaleBack (item)
	item.xScale = 1
	item.yScale = 1
end

local function animScaleOnDrag (item)
	item.xScale = _SCALEVAL
	item.yScale = _SCALEVAL
end

local function animOnPutOn(self)
	local function setToBig()
		transition.scaleTo(self, {xScale = _SCALEVAL, yScale = _SCALEVAL, time = 500})
	end	
	transition.scaleTo(self, {xScale = 0.8*_SCALEVAL, yScale = 0.8*_SCALEVAL, time = 300, onComplete=setToBig})
end

local function animOnPutOnShape(self)
	local function setToBig()
		transition.scaleTo(self, {xScale = 1, yScale = 1, time = 500})
	end	
	transition.scaleTo(self, {xScale = 0.8, yScale = 0.8, time = 300, onComplete=setToBig})
end

----animation update score
local function animScore()
	local function listener()
		display.remove( starToScore )
        starToScore = nil
	end
	starToScore = display.newImage( "images/starfull.png", constants.CENTERX, constants.CENTERY, constants.H/8, constants.H/8)
	starToScore.xScale, starToScore.yScale = 0.1, 0.1
	
	local function trans1()
	 	transition.to(starToScore, {time = 200, xScale = 1, yScale = 1, x = star[level].x, y= star[level].y, onComplete = listener})
	end
	spawnExplosionToTable(constants.CENTERX, constants.CENTERY)
	transition.to(starToScore, {time = 300, xScale = 2, yScale = 2, transition = easing.outBack, onComplete = trans1})
end


local function onAnimalDrag(event)
	local t = event.target
	local name = tostring(t.type)
	animalSound = audio.loadSound("sounds/"..name..".mp3")
	local phase = event.phase
	animScaleOnDrag(t)
	if "began" == phase then 
		startX = t.x
		startY = t.y

		--bring the animal on top (just for being sure)
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
		
		--find which animal dragged
		for i = 1, #shadowsImages do
			for j = 1, #shadowsImages[i] do
				if shadowsImages[i][j].type == t.type then
					if math.abs(t.x - shadowsImages[i][j].x)<_DELTA and math.abs (t.y-shadowsImages[i][j].y)<_DELTA then
						t.x = shadowsImages[i][j].x
						t.y = shadowsImages[i][j].y
						onPlaces = onPlaces - 1
						animOnPutOn(t)
						animOnPutOnShape(shadowsImages[i][j])
						audio.play( animalSound )
						shadowsImages[i][j].isUsed = true
						t:removeEventListener( "touch", onAnimalDrag )
					else 
						t.x = startX
						t.y = startY
						animScaleBack(t)
					end
				end
			end
		end			

		display.getCurrentStage():setFocus(nil)
		t.isFocus = false
		startX = nil
		startY = nil

		if onPlaces < 1 then
			if level == _MAXLEVEL then
				level = 0
				popup.showPopupWithReloadButton("You won !", "scenes.gametitle", "scenes.game3")
			else
			
				for i = 1, #shadowsImages do
					for j = 1, #shadowsImages[i] do
						if shadowsImages[i][j].isUsed == false then
							transition.to( shadowsImages[i][j], {time = 500, xScale = 0.1, yScale = 0.1, alpha = 0} )
						end
					end
				end

				wellDoneLabel = display.newEmbossedText( _WELLDONETEXT, constants.CENTERX, constants.CENTERY, native.systemFont, 2*_FONTSIZE )
				transition.to (wellDoneLabel, 
					{
						time = 300,
						y = 0,
						alpha = 0,
						xScale = 0.1,
						yScale = 0.1,
						onComplete = function ()
							display.remove (wellDoneLabel)
							wellDoneLabel = nil	
							timer.performWithDelay( 300, function () storyboard.reloadScene() end)						
						end
					})
			end
		end

	end
end

local function drawStars (group)
	local _STARSIZE = (constants.H - _BARHEIGHT - _BUTTONSIZE) / 8
	local _STARPATH

	for i = 1, 8 do
		if i <= itemAmount[level] then
			_STARPATH = "images/starfull.png"
		else
			_STARPATH = "images/star.png"
		end

		stars[i] = display.newImage( _STARPATH , _PLATEXZERO/2, constants.H - _BARHEIGHT - (i-0.5)*_STARSIZE)
		stars[i].width = _STARSIZE
		stars[i].height = _STARSIZE
		group:insert(stars[i])
	end
end

local function generateItems()
	local tmpindex = 1
	local items = table.copy(data.animals)

	for i = 1, itemAmount[level] do
		tmpindex = math.random(1, #items)
		table.insert( animals, items[tmpindex] )
		table.insert( shadows, items[tmpindex])
		table.remove( items, tmpindex)
	end

	for i = 1, shadowAmount[level]-itemAmount[level] do
		tmpindex = math.random(1, #items)
		table.insert(shadows, items[tmpindex])
		table.remove (items, tmpindex)
	end
end

function scene:createScene(event)
	local group = self.view

	level = 21

	background = display.newImage ("images/bg.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	barBackground = display.newImage ("images/bar.png", constants.CENTERX, constants.H - _BARHEIGHT/2)
	barBackground.width = constants.W
	barBackground.height = _BARHEIGHT
	group:insert(barBackground)

	plate = display.newImage ("images/plate.png", 0,0)
	plate.width = 0.9*constants.W
	plate.height = (constants.H-_BARHEIGHT)
	plate.x = constants.W - plate.width/2 - 0.01*constants.W
	plate.y = constants.H - _BARHEIGHT - plate.height / 2
	group:insert (plate)

	_PLATEXZERO = plate.x - plate.width/2
	_PLATEYZERO = plate.y - plate.height/2
	_BUTTONSIZE = _PLATEXZERO

	homeBtn = widget.newButton
    {
    	height = 0.07*constants.W,
        width = 0.07*constants.W,
        x = _BUTTONSIZE/2,
        y = _BUTTONSIZE/2,
        defaultFile = "images/home.png",
        overFile = "images/homehover.png",
        onRelease = onHomeButtonClicked
    }
    group:insert(homeBtn)

    soundStart = audio.loadSound( "sounds/place.mp3" )
	audio.play(soundStart)
end

function scene:willEnterScene(event)	
	if level < _MAXLEVEL then
		level = level + 1
	end

	generateItems()
	onPlaces = itemAmount[level]
end

function scene:enterScene (event)
	local group = self.view
	

	_ITEMSIZE = barBackground.height*0.95	
	_SPACINGANIMALS = (constants.W-_ITEMSIZE*itemAmount[level])/(itemAmount[level]+1)

	if plate.height / rows[level] < plate.width / (shadowAmount[level]/rows[level]) then
		_SHADOWSIZE = plate.height / (rows[level]+1)
		_SPACINGY = _SHADOWSIZE / (rows[level]+1)
	else
		_SHADOWSIZE = plate.width / (shadowAmount[level]/rows[level]+1)
		_SPACINGY = (plate.height - _SHADOWSIZE*rows[level])/(rows[level]+1)
	end
	_SCALEVAL = _SHADOWSIZE/_ITEMSIZE

	for i = 1, #animals do
		animalsImages[i] = display.newImage( data.animalsPath..animals[i]..data.format, i * _SPACINGANIMALS + (i-0.5)*_ITEMSIZE, barBackground.y)
		animalsImages[i].width = _ITEMSIZE
		animalsImages[i].height = _ITEMSIZE
		animalsImages[i].type = animals[i]
		animalsImages[i]:addEventListener( "touch", onAnimalDrag )
		group:insert(animalsImages[i])
	end

	local tmpShadowAmount = shadowAmount[level]
	local itemsInRow = 0
	local rowsLeft = rows[level]

	for i = 1, rows[level] do
		shadowsImages[i] = {}

		itemsInRow = math.ceil (tmpShadowAmount/rowsLeft)
		tmpShadowAmount = tmpShadowAmount - itemsInRow
		rowsLeft = rowsLeft - 1

		_SPACINGSHADOWS = (plate.width - itemsInRow*_SHADOWSIZE) / (itemsInRow+1)
		for j = 1, itemsInRow do
			local index = math.random(1, #shadows)
			shadowsImages[i][j] = display.newImage (data.shapesPath..shadows[index]..data.format, _PLATEXZERO + j * _SPACINGSHADOWS + (j-0.5) * _SHADOWSIZE, i * _SPACINGY + (i - 0.5)* _SHADOWSIZE)
			shadowsImages[i][j].width = _SHADOWSIZE
			shadowsImages[i][j].height = _SHADOWSIZE
			shadowsImages[i][j].type = shadows[index]
			shadowsImages[i][j].isUsed = false
			group:insert (shadowsImages[i][j])
			table.remove (shadows, index)
		end
	end
	
	drawStars(group)
end

function scene:exitScene(event)
	while #animals > 0 do
		table.remove(animals)
    end

	while #shadows > 0 do
		table.remove(shadows)
    end

	while #animalsImages > 0 do
		display.remove(animalsImages[#animalsImages])
		table.remove (animalsImages, #animalsImages)
	end

	for i = 1, #shadowsImages do
		for j = 1, #shadowsImages[i] do
			if shadowsImages[i][j] ~= nil then
			display.remove (shadowsImages[i][j])
			shadowsImages[i][j] = nil	
			end		
		end
	end

	while #stars > 0 do
		display.remove(stars[#stars])
		table.remove(stars)
    end

    display:remove ( homeBtn )
    display:remove ( background )
    display:remove ( barBackground )

    --homeBtn = nil
    --background = nil
    --barBackground = nil

end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene