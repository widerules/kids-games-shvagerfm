local composer = require("composer")
local constants = require("constants")
local data = require("data.searchData")
local widget = require("widget")
local explosion = require( "utils.explosion" )
local popup = require( "utils.popup" )
local sam = require "utils.sam"

local scene = composer.newScene()

local taskText = "Look for "
local message = "Well done !"

local _FONTSIZE = constants.H/7

local gamesWon = 0
local level = 1
local itemsCount = {2, 3, 4, 6, 9, 12, 16, 16}
local rows =       {1, 1, 2, 2, 3, 3, 4, 4}
local items = {}
local images = {}

local imageSize, spacingX, spacingY
local itemType, searchAmount
local taskLabel

local background, backBtn, homeBtn, backBtn
local counter

local soundName, soundTitle
local star = {}
local starToScore
local starSound = audio.loadSound( "sounds/start.mp3" )


local function backHome()
    composer.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
end

----animation update score
local function animScore()
    local function listener()
        starToScore:removeSelf( )
        starToScore = nil
        local currentScene = composer.getSceneName("current")
        composer.gotoScene(currentScene)
    end
    audio.play( starSound )
    starToScore = display.newImage( "images/starfull.png", constants.CENTERX, constants.CENTERY, constants.H/8, constants.H/8)
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

    local function encreaseScore()
        searchAmount = searchAmount - 1
        if searchAmount < 1 then
            gamesWon = gamesWon + 1
            if gamesWon>2 then
                gamesWon = 0
                if level<8 then
                    level = level + 1
                    animScore()

                else
                    popup.show()
                    level = 1
                end
            else
                composer.gotoScene("scenes.find_shapes")

            end

        end
    end
    -- right choice
    if event.target.type == itemType then
        wellDone()
        event.target:removeEventListener( "tap", onItemTapped )
        sam.swapSamActive()
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
            soundItIs = audio.loadSound( "sounds/its_"..event.target.type..".mp3" )
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

function scene:create(event)
    local group = self.view

    background = display.newImage("images/bg".. math.random(1, 6) .. ".jpg", constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert(background)

    backBtn = widget.newButton
        {
            width = 0.15*constants.W,
            height = 0.1*constants.W,
            defaultFile = "images/back_a.png",
            overFile = "images/back_n.png",
            id = "home",
            onRelease = backHome,

        }
    backBtn.x = backBtn.width*0.5
    backBtn.y = backBtn.height*0.5
    group:insert( backBtn )

    explosion.createExplosion()

    gamesWon = 0
    level = 1

    sam.show(constants.W * 0.05, 0.5)
end

function scene:show(event)
    local group = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        imageSize = constants.H/(rows[level]+1)
        spacingX = (constants.W - (itemsCount[level]/rows[level])*imageSize)/(itemsCount[level]/rows[level]+1)
        spacingY = imageSize / (rows[level]+1)
    elseif ( phase == "did" ) then

        counter = 1
        generateItems()
        for i = 1, itemsCount[level]/rows[level] do
            images[i] = {}
            for j = 1, rows[level] do
                local index = math.random (1, #items)
                images[i][j] = display.newImage( data.imagesPath..items[index]..data.format, i*spacingX+(i-0.5)*imageSize, j*spacingY+(j-0.5)*imageSize)
                images[i][j].width = imageSize
                images[i][j].height = imageSize
                images[i][j].rotation = math.random (-30,30)
                images[i][j].type = items[index]
                images[i][j]:addEventListener("tap", onItemTapped)
                group:insert(images[i][j])
                table.remove(items, index)
            end
        end

        local function hideLabel()
            if (taskLabel ~= nil) then
                transition.fadeOut( taskLabel, {time = 500} )
            end
        end

        taskLabel = display.newEmbossedText( taskText..itemType, constants.CENTERX, constants.CENTERY, native.systemFont, _FONTSIZE )
        soundTitle = audio.loadSound( "sounds/f"..itemType..".mp3" )
        audio.play( soundTitle )
        taskLabel.xScale = 0.3
        taskLabel.yScale = 0.3
        taskLabel:setFillColor( 0,0,0 )

        group:insert(taskLabel)
        transition.to(taskLabel, {time = 500, xScale = 1, yScale = 1, onComplete = function() timer.performWithDelay(1000, hideLabel) end})

        ---stars
        for i=1, 8 do
            if i < level then
                star[i] = display.newImage("images/stars/starfull.png", 0, 0, constants.H/20, constants.H/12)
            else
                star[i] = display.newImage("images/stars/star.png", 0, 0, constants.H/20, constants.H/12)
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
    end
end


function scene:hide(event)
    local phase = event.phase

    if ( phase == "will" ) then
        transition.cancel( )
    elseif ( phase == "did" ) then

        if starToScore ~= nil then
            display.remove(starToScore)
            starToScore = nil
        end
        if images ~= nil then
            for i = 1, #images do
                for j = 1, #images[i] do
                    if images[i][j] ~= nil then
                        display.remove( images[i][j] )
                        images[i][j] = nil
                    end
                end
            end
        end

        local i = 1
        for i = 1, #star do
            display.remove(star[i])
            star[i] = nil
        end

        if starToScore ~= nil then
            display.remove( starToScore )
            starToScore = nil
        end

        if taskLabel ~= nil then
            display.remove( taskLabel )
            taskLabel = nil
        end

        popup.hide()
        explosion.destroyExplosion()

        print("hide")
    end
end

function scene:destroy(event)
    local group = self.view

    explosion.destroyExplosion()

    print("destroy")

    group:remove(backBtn)
    backBtn = nil

    sam.hide()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene