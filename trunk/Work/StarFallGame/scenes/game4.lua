local storyboard = require ("storyboard")
local widget = require ("widget")
local physics = require( "physics")
local constants = require ("constants")
local data = require ("starFallData")
local popup = require("utils.popup")
local explosion = require("utils.explosion")

local scene = storyboard.newScene()

-------------------------------------constants
local _INFOSTARSIZE = constants.H/6
local _FRICTION = 0.7
local _FONTSIZE = constants.H / 15
local _STARSPEED = 9
local _TOTALSTARS = 50 				--total amount of stars, wich will be created
local _GENERATIONDELAY = 200		--pause between star generation
local _STARSIZE

-------------------------------------texts
local scoreText = "Score: "

local timerID, index, loopNumber 	--index for randomly choosing one type of stars, loopNumber to dedicate end of the star generating
local starType, starTypeImage 		--storing type of the star, showing this type 
local score, record					--score variables

local starGroup, informationGroup 	--group for falling stars and for information such as type of the star and score
local scoreLabel 					--for showing score during the game
local background, informationBackground  --for showing main background, and panel with information
local gameWon, level, colors

--this function called each time when user touch star
local function onStarTouched(event)
	--if user touched star of correct type
	if event.target.starType == starType then		
		--remove event listener from this star
		event.target:removeEventListener("touch", onStarTouched) 

		explosion.spawnExplosion(event.target.x, event.target.y)
		
		--make it a little bit bigger
		event.target.xScale = 1.5
		event.target.yScale = 1.5

		--move it to the left corner
		transition.to (event.target, {time = 300, x = constants.W, y = 0, alpha = 0, onComplete = function () display.remove(event.target) end}) 
		
		--encrease score, and show new score
		score = score + 1
		scoreLabel.text = scoreText..score
	end
end

--this function called at the end of the game
local function showPopUp ()
	--TODO: show pop up with score and records
end

function scene:createScene(event)
	local group = self.view

	starGroup = display.newGroup( )
	group:insert(starGroup)

 	informationGroup = display.newGroup( )
 	group:insert(informationGroup)

 	gameWon = 0
 	level = 1
end

function scene:willEnterScene(event)
	_STARSPEED = data.difficults[level].speed
	_TOTALSTARS = data.difficults[level].amount
	_GENERATIONDELAY = data.difficults[level].generationDelay

	physics.start(true)
	physics.setGravity(0, _STARSPEED) 
	colors = {1, 2, 3, 4, 5, 6, 7}
	while #colors > data.difficults[level].colors do
		table.remove (colors, math.random(1, #colors))
	end
	index = math.random(1, #colors)
	starType = data.colors[colors[index]]
	score = 0
	loopNumber = 0
	_STARSIZE = constants.H / data.difficults[level].size
end

function scene:enterScene (event)
	local group = self.view	

	local function startFalling()
		local function listener()
		timerID = timer.performWithDelay( _GENERATIONDELAY, 
			function()
				for i = 1, 5 do
					index = math.random (1, #colors)
					local star = display.newImage(data.starPath..data.colors[colors[index]]..data.format, 0, 0)
					star.x = constants.W * math.random()
					star.width = _STARSIZE
					star.height = _STARSIZE
					star.starType = data.colors[colors[index]]
					star:addEventListener( "touch", onStarTouched )
					starGroup:insert(star)
					physics.addBody( star, {density=1, friction=_FRICTION, bounce=0} )
				end
				--I didn't find any better way to catch the end of generating ...
				loopNumber = loopNumber + 1
				if loopNumber == _TOTALSTARS then
					--otherwise - popup shown without delay
					timer.performWithDelay( 2500, 
						function () 
							popup.showPopUp("Well done !\nYour score: "..score, "scenetemplate", "scenes.game4") 
							gameWon = gameWon + 1
							if gameWon>0 then
								gameWon = 0
								if level<4 then
									level = level + 1
								end
							end
						end) --lets all stars fall down and shows pop-up
				end
			end, _TOTALSTARS )
		end
	transition.to(starTypeImage, {time=500, xScale = 1.2, yScale=1.2, x = informationBackground.x - starTypeImage.width, y = informationBackground.y, onComplete= listener})
	end

	informationBackground = display.newImage("images/informationbg.png", constants.CENTERX, _INFOSTARSIZE/2)
	informationBackground.width = constants.W/3
	informationBackground.height = 1.5*_INFOSTARSIZE
	informationBackground.x = constants.W - informationBackground.width/2
	informationGroup:insert(informationBackground)

	starTypeImage = display.newImage( data.starPath..data.colors[colors[index]]..data.format, _INFOSTARSIZE, _INFOSTARSIZE )
	starTypeImage.width = _INFOSTARSIZE
	starTypeImage.height = _INFOSTARSIZE
	starTypeImage.x = constants.CENTERX
	starTypeImage.y = constants.CENTERY
	informationGroup:insert(starTypeImage)
	transition.to( starTypeImage, {time = 1000, rotation = 370, alpha = 1, xScale = 3, yScale = 3, transition= easing.outBack, onComplete = startFalling} )

	scoreLabel = display.newEmbossedText( scoreText..0, 0, informationBackground.y, native.systemFont, _FONTSIZE )
	scoreLabel.x = constants.W - 2*scoreLabel.width/3
	group:insert(scoreLabel)

	background = display.newImage ("images/background4.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	starGroup:insert(background)

end

function scene:exitScene(event)
	timer.cancel(timerID)
	physics.stop()
	transition.cancel()

	starTypeImage:removeSelf( )
	scoreLabel:removeSelf()
	popup.hidePopUp()
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