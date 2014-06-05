local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )
local scene = storyboard.newScene()
local slideObject = require("carousel.slideObject")
local slide = require("carousel.slide")
local carousel = require("carousel.carousel")

local _GAMEAMOUNT = 6

local gamePath = "scenes.game"

local resPath = "images/game"
local namePath = "/title"
local imagePath = "/titlepic"

local format = ".png"

local swypeGroup
local background
local titlePics = {}
local titles = {}
local btnPlay, leftArrow, rightArrow

local myCarousel


local function animButtons(target)
	local function transIn() 
		transition.to( target, {time = 1500, alpha = 1, onComplete = animButtons} )
	end
	local transout = transition.to( target, {time = 1500, alpha = 0.3, onComplete = transIn} )
end

local function animPlay()
	transition.to(btnPlay, {time = 300, xScale = 2.2, yScale = 2.2, transition = easing.continuousLoop})
end


local function showArrows()
    if (_GAME<_GAMEAMOUNT) then
        rightArrow.isVisible = true;
        transition.to(rightArrow, {time = 200, alpha = 1})
    else
        rightArrow.isVisible = false;
    end
end

local function goNextGame()
    if _GAME < _GAMEAMOUNT then
        _GAME = _GAME + 1

        myCarousel:showNextSlide()
        showArrows()
    end
end

local function goPreviousGame()
    if _GAME > 1 then
        _GAME = _GAME - 1

        myCarousel:showPreviousSlide()
        showArrows()
    else
        storyboard.gotoScene("scenetemplate", "slideRight", 800)
        storyboard.removeScene("scenes.gametitle")
    end
end

local function startDrag(event)
	local swipeLength = math.abs(event.x - event.xStart) 
	
	local t = event.target
	local phase = event.phase
	if "began" == phase then
		return true
	elseif "moved" == phase then
	elseif "ended" == phase or "cancelled" == phase then
		if event.xStart > event.x and swipeLength > 50 then 
			goNextGame()
		elseif event.xStart < event.x and swipeLength > 50 then 
		    goPreviousGame()
		end	
	end
end

local function startGame(event)
	    storyboard.gotoScene(gamePath .. _GAME, "slideLeft", 400)
        storyboard.removeScene("scenes.gametitle")
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage("images/background1.jpg", constants.CENTERX, constants.CENTERY)
	group:insert(background)
	group:addEventListener( "touch", startDrag )

    myCarousel = carousel.new( constants.CENTERX, constants.CENTERY, constants.W, constants.H )

    for i = 1, _GAMEAMOUNT do
        -- title pics
        local newTitlePic = slideObject.new()
        newTitlePic.name = "titlePic"..i
        newTitlePic.createFunction = function(id)
            titlePics[id] = display.newImage(resPath .. id .. imagePath .. format, 0, constants.CENTERY, constants.W/2, 3*constants.W/8)
            titlePics[id].width = constants.W/2
            titlePics[id].height = 3*constants.W/8
            titlePics[id].x = 0.6*titlePics[id].width
            titlePics[id].alpha = 0
            transition.to(titlePics[id], {time = 200, alpha = 1})
            return titlePics[id]
        end

        newTitlePic.showFunction = function(id)
            titlePics[id].isVisible = true
            transition.to(titlePics[id], {time = 200, alpha = 1})
        end

        newTitlePic.hideFunction = function(id) titlePics[id].isVisible = false end
        newTitlePic.removeFunction = function(id) display.remove( titlePics[id-1] ) titlePics[id] = nil end

        -- titles
        local newTitle = slideObject.new()
        newTitle.name = "title"..i
        newTitle.createFunction = function(id)
            titles[id] = display.newImage(resPath .. id .. namePath .. format,  0, 0, constants.W/4, constants.W/12)
            titles[id].y = titles[id].height
            titles[id].x = constants.W - titles[id].width
            titles[id].alpha = 0
            transition.to(titles[id], {time = 200, alpha = 1})
            return titles[id]
        end

        newTitle.showFunction = function(id)
            titles[id].isVisible = true
            transition.to(titles[id], {time = 200, alpha = 1})
        end

        newTitle.hideFunction = function(id) titles[id].isVisible = false end
        newTitle.removeFunction = function(id) display.remove( titles[id] )  titles[id] = nil end

        -- play button
        local newButton = slideObject.new()
        newButton.name = "playButton"..i
        newButton.createFunction = function()
            btnPlay = widget.newButton
                {
                    width = constants.W/3,
                    height = constants.W/6,
                    defaultFile = "images/btnPlay.png",
                    overFile = "images/btnPlayOver.png",
                    id = "button_1",
                    onRelease = startGame,
                }
            btnPlay.x = 0.7*constants.W
            btnPlay.y = constants.CENTERY
            btnPlay.alpha = 0
            transition.to(btnPlay, {time = 200, alpha = 1})
            return btnPlay
        end

        newButton.showFunction = function()
            btnPlay.isVisible = true
            transition.to(btnPlay, {time = 200, alpha = 1})
            animPlay()
        end

        newButton.hideFunction = function()  btnPlay.isVisible = false end
        newButton.removeFunction = function() display.remove( btnPlay ) btnPlay = nil end

        local newSlide = slide.new( constants.CENTERX, constants.CENTERY, constants.W, constants.H )
        newSlide:insertObject( newTitlePic )
        newSlide:insertObject( newTitle )
        newSlide:insertObject( newButton )

        myCarousel:insertSlide( newSlide )
     end

	admob.init()
end

function scene:enterScene (event)
	local group = self.view
	admob.showAd( "interstitial" )

    myCarousel:showSlide( _GAME )

	leftArrow = widget.newButton
		{
			width = constants.W/12,
			height = constants.W/4,
			defaultFile = "images/leftarrow.png",
			id = "button_2",
			onRelease = goPreviousGame
		}
	leftArrow.x =  leftArrow.width/2
	leftArrow.y = constants.CENTERY
	leftArrow.alpha = 0
	transition.to(leftArrow, {time = 200, alpha = 1})
	group:insert(leftArrow)

		rightArrow = widget.newButton
			{
				width = constants.W/12,
				height = constants.W/4,
				defaultFile = "images/rightarrow.png",
				id = "button_3",
				onRelease = goNextGame
			}
		rightArrow.x = constants.W - rightArrow.width/2
		rightArrow.y = constants.CENTERY	
		rightArrow.alpha = 0
		transition.to(rightArrow, {time = 200, alpha = 1})
		group:insert(rightArrow)

	animButtons(rightArrow)
    animButtons(leftArrow)
    showArrows()
    animPlay()
end


function scene:exitScene(event)
    myCarousel:hideSlide(_GAME)

	display.remove (swypeGroup)
	swypeGroup = nil
	display.remove(rightArrow)
	rightArrow = nil
	display.remove(leftArrow)
	leftArrow = nil
end

function scene:destroyScene(event)
    myCarousel:destroy()
    myCarousel = nil
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene