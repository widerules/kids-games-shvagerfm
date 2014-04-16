local storyboard = require ("storyboard")
local widget = require ("widget")
local physics = require( "physics")
local constants = require ("constants")
local data = require ("starFallData")
local explosion = require("utils.explosion")

local scene = storyboard.newScene()

_GAME = 4

-------------------------------------constants
local _INFOSTARSIZE = constants.H/6
local _FRICTION = 0.7
local _FONTSIZE = constants.H / 15
local _STARSPEED = 9
local _TOTALSTARS = 50 				--total amount of stars, wich will be created
local _GENERATIONDELAY = 200		--pause between star generation
local _STARSIZE
local _BTNSIZE

-------------------------------------texts
local scoreText = "Score: "

local timerID, index, loopNumber 	--index for randomly choosing one type of stars, loopNumber to dedicate end of the star generating
local starType, starTypeImage 		--storing type of the star, showing this type 
local score, record, generated					--score variables
local starTimerID = {}

local rateStars = {}
local starGroup, informationGroup 	--group for falling stars and for information such as type of the star and score
local scoreLabel 					--for showing score during the game
local background, informationBackground  --for showing main background, and panel with information
local gameWon, level, colors
local popupText, popupBg, nextBtn, homeBtn, roloadBtn --pop-up variables

-----------------------------------------------------------------------------------------------------------POPUP
local function onNextButtonClicked() --to load next level - incrementing level var
	if level < 7 then
		level = level + 1
	end
	storyboard.reloadScene( )
end

local function onReloadButtonClicked()
    storyboard.reloadScene()	-- to reload scene just reloading scene
end

local function onHomeButtonClicked () 
		local options =
		{
    		effect = "slideRight",
    		time = 800,
    		params = { ind = _GAME }
		}
		storyboard.gotoScene( "scenes.gametitle", options)
		storyboard.removeScene( "scenes.game4" )
end

local function showPopUp (message)

    --setting up popup layout
    popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
    popupBg.height = 0.9*constants.H;
    popupBg.width = 0.7*constants.W;

    _BTNSIZE = 0.3*popupBg.height

    --show popup text
    popupText = display.newText(message, popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
    popupText.y = popupBg.y-popupBg.height/2+2*popupText.height/3;

    --setting up buttons
    homeBtn = widget.newButton
    {
    	width = _BTNSIZE,
        height = _BTNSIZE,
        x = popupBg.x - 1.5*_BTNSIZE,
        y = popupBg.y + _BTNSIZE,
        defaultFile = "images/home.png",
        overFile = "images/homehover.png",
        onRelease = onHomeButtonClicked
    }
    
    reloadBtn = widget.newButton
    {
        width = _BTNSIZE,
        height = _BTNSIZE,
        x = popupBg.x,
        y = popupBg.y + _BTNSIZE,
        defaultFile = "images/reload.png",
        overFile = "images/reloadhover.png",
        onRelease = onReloadButtonClicked
    }
    --if current level is not max - show next button
    if level<7 then
    	nextBtn = widget.newButton
    	{
        	width = _BTNSIZE,
        	height = _BTNSIZE,
        	x = popupBg.x + 1.5*_BTNSIZE,
        	y = popupBg.y + _BTNSIZE,
        	defaultFile = "images/next.png",
        	overFile = "images/next.png",
        	onRelease = onNextButtonClicked
    	}
    else
    	--if current level is max - change text
    	popupText.text = "Congratulations!"
    	--and move two buttons to center
    	reloadBtn.x = popupBg.x + _BTNSIZE
    	homeBtn.x = popupBg.x - _BTNSIZE       
    end
    
    --draw 3 empty stars
    for i = 1,3 do
    	rateStars[i] = display.newImage ("images/star.png", 0, 0)
    	rateStars[i].width = 1.2*_INFOSTARSIZE
    	rateStars[i].height = 1.2*_INFOSTARSIZE
    	rateStars[i].y = popupText.y + _FONTSIZE + _INFOSTARSIZE
    	rateStars[i].x = popupBg.x + 1.5*1.2*(i-2)*_INFOSTARSIZE    		
    end

    --of score more than 0, start giving golden stars
    if score > 0 then
    	--SOUND_PLACE positive end of the game
    	local wellDone = audio.loadSound("sounds/welldone.mp3")
    	audio.play( wellDone )
    	--calculating actual rating
    	local rate = math.round(3/math.floor(generated/score))
    	if rate < 3 then 
    		rate = rate + 1
    	end 

    	--to give golden star, we remembers coordinates of the empty-star, delete it, and draw golden star on it's place
    	for i = 1, rate do
    		local function addStar ()
		    	local x = rateStars[i].x
		    	local y = rateStars[i].y
		    	local width = rateStars[i].width
		    	local height = rateStars[i].height
		    	rateStars[i]:removeSelf()
		    	rateStars[i] = display.newImage ("images/starfull.png", x, y)
		    	rateStars[i].height = height
		    	rateStars[i].width = width
		    	rateStars[i].xScale = 0.7
		    	rateStars[i].yScale = 0.7
		    	transition.to(rateStars[i], {time = 500, xScale = 1, yScale = 1, transition = easing.outBack})
	    	end
    		starTimerID[i] = timer.performWithDelay( i*600, addStar )
    	end
    else
    	--SOUND_PLACE negative end of the game (score == 0)
    	popupText.text = "Loose"
    	
    end	

end

local function hidePopUp()
	if popupBg ~= nil then
		popupBg:removeSelf( )
		popupText:removeSelf( )		
		homeBtn:removeSelf( )
		reloadBtn:removeSelf()
		popupBg = nil
		popupText = nil				
		homeBtn = nil
		reloadBtn = nil
		if nextBtn ~= nil then
			nextBtn:removeSelf()
			nextBtn = nil
		end
		for i = 1, #rateStars do
			if rateStars[i] ~= nil then
				rateStars[i]:removeSelf( )
				rateStars[i] = nil
			end
		end
	end
end
------------------------------------------------------------------------------------------------------------------------END POPUP

--this function called each time when user touch star
local function onStarTouched(event)
	--if user touched star of correct type
	if event.target.starType == starType then
		--SOUND_PLACE Correct item selected sound

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

function scene:createScene(event)
	local group = self.view

	starGroup = display.newGroup( )
	group:insert(starGroup)

 	informationGroup = display.newGroup( )
 	group:insert(informationGroup)

 	level = 1
end

function scene:willEnterScene(event)
	_STARSPEED = data.difficults[level].speed

	physics.start(true)
	physics.setGravity(0, _STARSPEED) 
	colors = {1, 2, 3, 4, 5, 6, 7}
	while #colors > data.difficults[level].colors do
		table.remove (colors, math.random(1, #colors))
	end
	index = math.random(1, #colors)
	starType = data.colors[colors[index]]
	score = 0
	generated = 0
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
					local star = display.newImage(data.itemPath[1]..data.colors[colors[index]]..data.format, 0, 0)					
					star.x = constants.W * math.random()
					star.y = -_STARSIZE
					star.width = _STARSIZE
					star.height = _STARSIZE
					star.starType = data.colors[colors[index]]
					star:addEventListener( "touch", onStarTouched )
					starGroup:insert(star)
					physics.addBody( star, {density=0, friction=_FRICTION, bounce=0} )
					if star.starType == starType then
						generated = generated + 1
					end
				end
				--I didn't find any better way to catch the end of generating ...
				loopNumber = loopNumber + 1
				if loopNumber == _TOTALSTARS then
					--otherwise - popup shown without delay
					timer.performWithDelay( 4000, 
						function () 
							showPopUp("Well done!")							
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

	starTypeImage = display.newImage( data.itemPath[1]..data.colors[colors[index]]..data.format, _INFOSTARSIZE, _INFOSTARSIZE )
	starTypeImage.width = _INFOSTARSIZE
	starTypeImage.height = _INFOSTARSIZE
	starTypeImage.x = constants.CENTERX
	starTypeImage.y = constants.CENTERY
	informationGroup:insert(starTypeImage)
	--SOUND_PLACE Start game
	local soundStart = audio.loadSound("sounds/catch"..data.colors[colors[index]]..".mp3")
	audio.play( soundStart )
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
	if timerID ~= nil then 
		timer.cancel(timerID)
	end
	for i = 1, #starTimerID do 
		if starTimerID[i] ~= nil then
			timer.cancel(starTimerID[i])
		end
	end

	physics.stop()
	transition.cancel()

	display.remove(starTypeImage)
	display.remove(scoreLabel)
	
	hidePopUp()
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