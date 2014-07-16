local storyboard = require("storyboard")
local constants = require("constants")
local data = require("data.searchData")
local popup = require("utils.popup")
local explosion = require( "utils.explosion" )

local scene = storyboard.newScene()
local widget = require("widget")

local taskText = "Look for "
local message = "Well done !"

local _FONTSIZE = constants.H/7
explosion.createExplosion()

local gamesWon = 0
local level = 1
local itemsCount = {2, 3, 4, 6, 9, 12, 16, 20}
local rows =       {1, 1, 2, 2, 3, 3, 4, 4}
local items = {}
local images = {}
local timers = {}

local imageSize, spacingX, spacingY
local itemType, searchAmount
local taskLabel

local background, backBtn
local counter

local soundName, soundTitle
local star = {}
local starToScore


local function backHome()
    popup.hidePopup()
	local options =
		{
    		effect = "slideRight",
    		time = 400
		}
	storyboard.gotoScene("scenes.menu", options)
	storyboard.purgeScene("scenes.game5")
end

local function animScore()
    local function listener()
        display.remove(star[level-1])
        star[level-1] = display.newImage("images/starfull.png")
        star[level-1].width = constants.H/16
        star[level-1].height = constants.H/16
        star[level-1].x = constants.W - star[level-1].width/2
        star[level-1].y = level - 1 > 1 and star[level-2].y - star[level-1].height or constants.H - star[level-1].height/2
        starToScore:removeSelf( )
        starToScore = nil
    end
    audio.play( starSound )
    starToScore = display.newImage( "images/starfull.png", constants.CENTERX, constants.CENTERY)
    starToScore.width, starToScore.height =  constants.H/16, constants.H/16
    starToScore.xScale, starToScore.yScale = 0.1, 0.1

    local function trans1()
        transition.to(starToScore, {time = 200, xScale = 1, yScale = 1, x = star[level-1].x, y= star[level-1].y, onComplete = listener})
    end
    explosion.spawnExplosion(constants.CENTERX, constants.CENTERY)
    transition.to(starToScore, {time = 300, xScale = 2, yScale = 2, transition = easing.outBack, onComplete = trans1})
end

local function generateItems()
	local tmp = table.copy(data.colors)
	local tmpindex = math.random(1, #tmp)

	itemType = tmp[tmpindex]
	items[1] = tmp[tmpindex]
	table.remove(tmp, tmpindex)
	searchAmount = 1

	for i = 2, itemsCount[level] do
		tmpindex = math.random (1, #tmp)		
		items[i] = tmp[tmpindex]
		table.remove(tmp,tmpindex)

		if #tmp < 1 then
			tmp = table.copy (data.colors)
		end

		if items[i] == itemType then
			searchAmount = searchAmount+1
		end
	end
end

local function wellDone()

	local tempsound = math.random()
	if tempsound < 0.5 then 
		soundName = audio.loadSound( "sounds/good.mp3" )
	else
		soundName = audio.loadSound( "sounds/welldone.mp3" )
	end

		audio.play( soundName )
end

local function onItemTapped (event)
	---
	local function reloadFunc()
		storyboard.reloadScene() 
	end
	local function encreaseScore()
		searchAmount = searchAmount - 1
		if searchAmount < 1 then
			gamesWon = gamesWon + 1
			if gamesWon>2 then
				gamesWon = 0
				if level < 8 then
					level = level + 1
                    animScore()
                    timers[#timers+1] = timer.performWithDelay( 700, reloadFunc )
                else
                    level = level + 1
                    animScore()
                    timers[#timers+1] = timer.performWithDelay(600, function()
                        level = 1
                        popup.showPopupWithReloadButton("Well done !", "scenes.menu", "scenes.game5")
                    end)

				end
				wellDone()
				
			else
				reloadFunc()
			end
			
		end
	end
	
    -- right choice
	if event.target.type == itemType then
		wellDone()
		event.target:removeEventListener( "tap", onItemTapped )
		local function animDisapp(self)
			transition.to(self, {time = 700, xScale = 0.1, yScale = 0.1 , alpha = 0.1, transition = easing.inBack, onComplete = encreaseScore})
		end
		event.target:toFront()
		transition.to( event.target, {time = 700, rotation = 360, xScale = 1.5, yScale = 1.5, x = constants.CENTERX, y = constants.CENTERY, transition = easing.outBack, onComplete = animDisapp} )	

		-- wrong choice	
	else
		local soundItIs
		if counter > 2 then
			audio.play( soundTitle )
			counter = 1
		else
			soundItIs = audio.loadSound( "sounds/no.mp3" )
			audio.play( soundItIs )
		end
		
		
		local baseRot = event.target.rotation
		local function toNormal()
			transition.to (event.target,{rotation = baseRot,  time = 125})
		end
		local function toRight()
			transition.to (event.target,{rotation = 30,  time = 250, onComplete = toNormal})
		end
		
		transition.to (event.target,{rotation = -30,  time = 125, onComplete = toRight})
		counter = counter + 1
	end
end

function scene:createScene(event)
    --print ("1 st line of createScene: "..system.getInfo( "textureMemoryUsed" ) / 1000000)
	local group = self.view

	background = display.newImage("images/background2.jpg", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)	
	
	backBtn = widget.newButton
		{
		    height = 0.07*constants.W,
            width = 0.07*constants.W,
            left = 0,
		    top = 0,
		    defaultFile = "images/home.png",
		    overFile = "images/homehover.png",
		    id = "home",
		    onRelease = backHome,   
		}
	
	group:insert( backBtn )

	gamesWon = 0
	level = 1

    --print ("end of createScene: "..system.getInfo( "textureMemoryUsed" ) / 1000000)
end

function scene:willEnterScene(event)
    --print ("1st line of willEnterScene: "..system.getInfo( "textureMemoryUsed" ) / 1000000)
	--computing size of spacing and actual image size, according to the amount of the items
	imageSize = constants.H/(rows[level]+1)
	spacingX = (constants.W - (itemsCount[level]/rows[level])*imageSize)/(itemsCount[level]/rows[level]+1)
	spacingY = imageSize / (rows[level]+1)
    --print ("end of willEnterScene: "..system.getInfo( "textureMemoryUsed" ) / 1000000)
end

function scene:enterScene(event)
    --print ("1st line of enterScene: "..system.getInfo( "textureMemoryUsed" ) / 1000000)
	local group = self.view

	counter = 1
	generateItems()
	
	for i = 1, itemsCount[level]/rows[level] do
		images[i] = {}
		for j = 1, rows[level] do
			local index = math.random (1, #items)			
			images[i][j] = display.newImage( data.butterfliesPath..items[index]..data.format, i*spacingX+(i-0.5)*imageSize, j*spacingY+(j-0.5)*imageSize)			
			images[i][j].width = imageSize
			images[i][j].height = imageSize	
			images[i][j].rotation = math.random (-30,30)	
			images[i][j].type = items[index]			
			images[i][j]:addEventListener("tap", onItemTapped)
			group:insert(images[i][j])
			table.remove(items, index)
		end
    end

    --print ("images downloaded in enterScene: "..system.getInfo( "textureMemoryUsed" ) / 1000000)

	local function hideLabel()
		transition.to( taskLabel, {time = 300, alpha = 0} )
	end

	taskLabel = display.newEmbossedText( taskText..itemType, constants.CENTERX, constants.CENTERY, native.systemFont, _FONTSIZE )	
    soundTitle = audio.loadSound( "sounds/find_"..itemType..".mp3" )
	audio.play( soundTitle )
	taskLabel.xScale = 0.3
	taskLabel.yScale = 0.3
	taskLabel:setFillColor( 0,0,0 )
	group:insert(taskLabel)
	transition.to(taskLabel, {time = 500, xScale = 1, yScale = 1, onComplete = function() timer.performWithDelay(1000, hideLabel) end})

	---stars
	for i=1, 8 do
		if i < level then
			star[i] = display.newImage("images/starfull.png", 0, 0, constants.H/20, constants.H/12)
		else
			star[i] = display.newImage("images/star.png", 0, 0, constants.H/20, constants.H/12)
	end
	
	star[i].width, star[i].height = constants.H/16, constants.H/16
	star[i].x = constants.W - star[i].width/2
	
	if i == 1 then
		star[i].y = constants.H - star[i].height/2
	else
		star[i].y = star[i-1].y - star[i].height
	end
	group:insert(star[i])

    end

    --print ("end of enterScene: "..system.getInfo( "textureMemoryUsed" ) / 1000000)

end

function scene:exitScene(event)

    for i = 1, #timers do
        timer.cancel(timers[i])
        timers[i] = nil
    end

    for i = 1, #star do
        display.remove(star[i])
        star[i] = nil
    end

    for i = 1, #images do
        for j = 1, #images[i] do
            if images[i][j] ~= nil then

                display.remove( images[i][j] )
                images[i][j] = nil
            end
        end
    end

    if taskLabel ~= nil then
        display.remove( taskLabel )
        taskLabel = nil
    end

    display:remove( background )
    background = nil

    transition.cancel( )
    audio.stop()

    audio.dispose ( soundName )
    audio.dispose ( soundTitle )

    soundName = nil
    soundTitle = nil
end

function scene:destroyScene(event)
    explosion.destroyExplosion()
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene