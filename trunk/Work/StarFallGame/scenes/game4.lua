local storyboard = require ("storyboard")
local widget = require ("widget")
local physics = require( "physics")
local constants = require ("constants")
local data = require ("starFallData")

local scene = storyboard.newScene()

local _STARSIZE = constants.H/8
local _FRICTION = 0.7
local _FONTSIZE = constants.H / 15;

local scoreText = "Score: "

local timerID, index, loopNumber
local starType, starTypeImage
local score, record

local starGroup, informationGroup
local scoreLabel
local background, informationBackground

local function onStarTouched(event)
	if event.target.starType == starType then
		event.target:removeEventListener("touch", onStarTouched)
		
		event.target.xScale = 1.5
		event.target.yScale = 1.5

		transition.to (event.target, {time = 300, x = constants.W, y = 0, alpha = 0, onComplete = function () display.remove(event.target) end})
		
		score = score + 1
		scoreLabel.text = scoreText..score
	end
end

local function showPopUp ()
	print(score)
end

function scene:createScene(event)
	local group = self.view

	starGroup = display.newGroup( )
	group:insert(starGroup)

 	informationGroup = display.newGroup( )
 	group:insert(informationGroup)
end

function scene:willEnterScene(event)
	physics.start(true)
	physics.getGravity(0, 5 )
	index = math.random(1, #data.colors)	
	starType = data.colors[index]
	score = 0
	loopNumber = 0
end

function scene:enterScene (event)

	local group = self.view

	informationBackground = display.newImage("images/popupbg.png", constants.CENTERX, _STARSIZE)
	informationBackground.width = constants.W
	informationBackground.height = 2*_STARSIZE
	informationGroup:insert(informationBackground)

	starTypeImage = display.newImage( data.starPath..data.colors[index]..data.format, _STARSIZE, _STARSIZE )
	starTypeImage.width = _STARSIZE*1.5
	starTypeImage.height = _STARSIZE*1.5
	informationGroup:insert(starTypeImage)

	scoreLabel = display.newEmbossedText( scoreText..0, informationBackground.x, informationBackground.y, native.systemFont, _FONTSIZE )

	background = display.newImage ("images/background4.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	starGroup:insert(background)

	timerID = timer.performWithDelay( data.delay, 
		function()
			for i = 1, 5 do
				index = math.random (1, #data.colors)
				local star = display.newImage(data.starPath..data.colors[index]..data.format, 0, 0)
				star.x = constants.W * math.random()
				--star.y = _STARSIZE*2
				star.width = _STARSIZE
				star.height = _STARSIZE
				star.starType = data.colors[index]
				star:addEventListener( "touch", onStarTouched )
				starGroup:insert(star)
				physics.addBody( star, {density=1, friction=_FRICTION, bounce=0} )
			end
			loopNumber = loopNumber + 1
			if loopNumber == data.totalGameLoops then
				timer.performWithDelay( 2500, function() showPopUp() end)
			end
		end, data.totalGameLoops )
end

function scene:exitScene(event)
	timer.cancel(timerID)
	physics.stop()
	transition.cancel()

	starTypeImage:removeSelf( )
	scoreLabel:removeSelf()
end

function scene:destroyScene(event)
	background:removeSelf( )
	informationBackground:removeSelf()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )


return scene