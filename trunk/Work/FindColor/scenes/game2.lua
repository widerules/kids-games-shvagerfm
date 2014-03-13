local storyboard = require("storyboard")
local widget = require("widget")
local constants = require("constants")
local data = require("searchData")

local scene = storyboard.newScene()

local _IMAGESIZE = 0.5* constants.H 
local _FONTSIZE = constants.H / 10

local positions = 
{
	x = 
	{
		constants.CENTERX - _IMAGESIZE - _IMAGESIZE/5,
		constants.CENTERX,
		constants.CENTERX + _IMAGESIZE + _IMAGESIZE/5,
		constants.CENTERX - _IMAGESIZE - _IMAGESIZE/5,
		constants.CENTERX,
		constants.CENTERX + _IMAGESIZE + _IMAGESIZE/5,
	},
	y = 
	{
		constants.CENTERY - _IMAGESIZE/2,
		constants.CENTERY ,
		constants.CENTERY - _IMAGESIZE/2,
		constants.CENTERY + _IMAGESIZE/2,
		constants.CENTERY + 2*_IMAGESIZE/3,
		constants.CENTERY + _IMAGESIZE/2
	},
	rot = 
	{
		math.random(-20,20),
		math.random(-10,10),
		math.random(-20,20),
		math.random (-30,30),
		math.random(-10,10),
		math.random(-30,30)
	}

}

local indexes = {}
local colorIndex

local butterflies = {}
local colorText

local background

local popupText
local popupBg
local nextBtn
local homeBtn

--[[
local function moveAnim(object)
	local bigger
	local smaller
	bigger = function()
		transition.scaleTo( object, {xScale = 1.1, yScale = 1.1, time = 500, onComplete = smaller} )
	end

	smaller = function()
		transition.scaleTo(object, {xScale = 0.9, yScale = 0.9, time = 500, onComplete = bigger})
	end

end
]]

local function generateIndexes ()
        local tmp = {}
        for i = 1,table.maxn(data.colors),1 do
                table.insert(tmp,i)
        end

        local rand;
        for i = 1, 6, 1 do
                rand = math.random(1, table.maxn(tmp))
                table.insert(indexes,tmp[rand])
                table.remove( tmp, rand )
        end

        colorIndex = indexes[math.random(1, table.maxn(indexes))]
end

local function onNextButtonClicked()
	storyboard.reloadScene( )
end

local function onHomeButtonClicked()
	--TODO: 
	--go to home screen
end

local function showPopUp()
        popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
        popupBg.height = 0.7*constants.H;
        popupBg.width = 0.7*constants.W;

        popupText = display.newText("Well done !", popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
        popupText.y = popupBg.y-popupBg.height/2+2*popupText.height/3;

        homeBtn = widget.newButton
        {
                width = 0.4*popupBg.height,
                height = 0.4*popupBg.height,
                x = popupBg.x - 0.4*popupBg.width/2,
                y = popupBg.y + 0.4*popupBg.height/2,
                defaultFile = "images/home.png",
                overFile = "images/homehover.png"
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
        nextBtn:addEventListener( "tap", onNextButtonClicked );
end;

local function onButterflyClicked(event)
	local butterflyIndex
	for i = 1, 6, 1 do
		if butterflies[i] == event.target then
			butterflyIndex = indexes[i]
			break
		end
	end

	if butterflyIndex == colorIndex then
		local function toNormal()
			transition.scaleTo( event.target, {xScale = 1, yScale = 1, time = 500} )
		end
		transition.scaleTo( event.target, {xScale = 1.2, yScale = 1.2, time = 500, onComplete = toNormal} )
		timer.performWithDelay( 1500, showPopUp )
		event.target:removeEventListener( "tap", onButterflyClicked )
		--play music
	else
		--show somehow, that this is uncorrect
	end
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage("images/background2.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

end

function scene:enterScene(event)
	local group = self.view

	generateIndexes()

	for i = 1, 6, 1 do
		butterflies[i] = display.newImage(data.butterfliesPath..data.colors[indexes[i]]..data.format, positions.x[i], positions.y[i])
		butterflies[i].width = _IMAGESIZE
		butterflies[i].height = _IMAGESIZE
		butterflies[i].rotation = positions.rot[i]
		butterflies[i]:addEventListener( "tap", onButterflyClicked )
		group:insert(butterflies[i])		
	end

	colorText = display.newEmbossedText(data.colors[colorIndex], constants.CENTERX, constants.CENTERY- _IMAGESIZE/2 - _FONTSIZE/2, native.systemFont, _FONTSIZE)
	colorText:setFillColor (data.textColors[colorIndex][1], data.textColors[colorIndex][2], data.textColors[colorIndex][3])	
	group:insert(colorText)

end

function scene:exitScene(event)
	while table.maxn(indexes) > 0 do
		table.remove(indexes)
	end

	while table.maxn (butterflies) > 0 do
		butterflies[#butterflies]:removeSelf()
		table.remove(butterflies)
	end

	colorText:removeSelf( )

	if popupBg ~= nil then
		popupBg:removeSelf( )
		popupText:removeSelf( )
		nextBtn:removeSelf()
		homeBtn:removeSelf( )
	end
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene)
scene:addEventListener( "destroyScene", scene )

return scene