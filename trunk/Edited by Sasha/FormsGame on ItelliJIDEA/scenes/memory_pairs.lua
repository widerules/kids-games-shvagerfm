local composer = require ("composer")
local widget = require ("widget")
local constants = require("constants")
local data = require ("data.pairData")
local popup = require ("utils.popup")
local explosion = require( "utils.explosion" )

explosion.createExplosion()

local scene = composer.newScene()

local _FONTSIZE = constants.H / 13
local _MAXLEVEL = 5
local _ITEMH, _ITEMW

local cardAmount = {6, 8, 12, 16, 20}
local rows = {2, 2, 3, 4, 4}
local level = 1
local gameWon = 0

local finishTimer
local background, backBtn
local animals = {}
local folds = {}

local previous
local totalCards

local star = {}
local starToScore
local items = {}

local plopSound = audio.loadSound("sounds/Plopp.mp3")
local starSound = audio.loadSound( "sounds/start.mp3" )


local function findIndex(object)
    local index = 1
    for i = 1, #folds do
        if folds[i]==object then
            index = i
            break
        end
    end
    return index
end

----animation update score
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
    starToScore = display.newImage( "images/starfull.png", constants.CENTERX, constants.CENTERY, constants.H/8, constants.H/8)
    starToScore.xScale, starToScore.yScale = 0.1, 0.1

    local function trans1()
        transition.to(starToScore, {time = 200, xScale = 1, yScale = 1, x = star[level-1].x, y= star[level-1].y, onComplete = listener})
    end
    explosion.spawnExplosion(constants.CENTERX, constants.CENTERY)
    transition.to(starToScore, {time = 300, xScale = 2, yScale = 2, transition = easing.outBack, onComplete = trans1})
end

local function onFoldClicked (event)
    event.target:removeEventListener( "tap", onFoldClicked )
    audio.play( plopSound )
    local function compare ()

        if previous ~= nil then
            if previous.animalType == event.target.animalType then

                --previous:removeEventListener( "tap", onFoldClicked )
                local wellDone = audio.loadSound( "sounds/welldone.mp3" )
                audio.play(wellDone)
                local function checkAmount()
                    totalCards = totalCards - 2
                    if totalCards == 0	then
                        animScore()
                        finishTimer = timer.performWithDelay(600, function()
                            popup.showPopUpWithNextButton("Well done!", "scenes.scenetemplate", "scenes.game5")
                        end)
                        gameWon = gameWon + 1
                        if gameWon>0 and level < _MAXLEVEL then
                            gameWon = 0
                            level = level + 1
                        else
                            level = 1
                        end
                    end
                end

                local function removeSecond()
                    transition.to(items[findIndex(event.target)], {time = 300, x = constants.W, y = 0, alpha = 0, onComplete = checkAmount})
                end
                transition.to(items[findIndex(previous)], {time = 300, x = constants.W, y = 0, alpha = 0, onComplete = removeSecond})

            else
                event.target:addEventListener( "tap", onFoldClicked )
                previous:addEventListener( "tap", onFoldClicked )
                transition.to( event.target, {time = 500, xScale = 1, alpha = 1, transition = easing.outBack} )
                transition.to(previous, {time = 500, xScale = 1, alpha = 1, transition = easing.outBack})
            end
            previous = nil
        else
            local soundName = audio.loadSound( "sounds/"..event.target.animalType..".mp3" )
            audio.play(soundName)
            previous = event.target
        end
    end
    transition.to(event.target, {time = 500, xScale = 0, alpha = 0, transition = easing.inBack, onComplete = compare})
end

function scene:create(event)
    local group = self.view

    background = display.newImage("images/bg".. math.random(1, 6) .. ".jpg", constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert(background)
end

function scene:show (event)
    local group = self.view
    local phase = event.phase
    --if level > 1 then
    --animScore()
    --end

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
        previous = nil
        animals = table.copy(data.animals)
        totalCards = cardAmount[level]

        if constants.H / rows[level]<constants.W/(cardAmount[level]/rows[level]) then
            itemH = 0.9*constants.H / rows[level]
            itemW = itemH
        else
            itemW = 0.9*constants.W / (cardAmount[level]/rows[level]+1)
            itemH = itemW
        end

        local spacingX = (constants.W - itemW * cardAmount[level]/rows[level]) / (cardAmount[level]/rows[level]+1)
        local spacingY = (constants.H - itemH * rows[level]) / (rows[level]+1)

        items = {}
        local temp

        local indexes = {}

        for i=1, #data.animals - cardAmount[level]/2 do
            local posToRemove = math.random(1, #animals)
            table.remove(animals, posToRemove)
        end

        for i=1, #animals do
            indexes[animals[i]] = 2
        end

        local animal, index


        for i=1, rows[level] do
            for j= 1, (cardAmount[level]/rows[level]) do
                index = math.random(1, cardAmount[level]/2)
                while indexes[animals[index]] == 0 do
                    index = math.random(1, cardAmount[level]/2)
                end

                if indexes[animals[index]] > 0 then
                    temp = display.newImage (data.animalsPath..animals[index]..data.format, 0, 0)
                    temp.animalType = animals[index]
                    indexes[animals[index]] = indexes[animals[index]] - 1
                end

                temp.width = itemW
                temp.height = itemH

                temp.x = (j-1) * itemW + itemW/2 + j*spacingX
                temp.y = i * itemH - itemH / 2 + i * spacingY

                --temp:addEventListener( "tap", onItemTap )

                table.insert(items, temp)
            end
        end

        for i=1, #items do
            group:insert( items[i] )

            folds[i] = display.newImage (data.foldPath, items[i].x, items[i].y)
            folds[i].width = 1.05*items[i].width
            folds[i].height = 1.05*items[i].height
            folds[i]:addEventListener("tap", onFoldClicked)
            folds[i].animalType = items[i].animalType
            group:insert(folds[i])
        end

        ---stars
        for i=1, _MAXLEVEL do
            if i < level then
                star[i] = display.newImage("images/starfull.png", 0, 0, constants.H/20, constants.H/12)
            else
                star[i] = display.newImage("images/starempty.png", 0, 0, constants.H/20, constants.H/12)
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
    elseif ( phase == "did" ) then
        for i=1, #items do
            if items[i] then
                display.remove( items[i] )
                items[i] = nil
            end
        end

        if folds ~= nil then
            for i = 1, #folds do
                if folds[i] ~= nil then
                    display.remove( folds[i] )
                    folds[i] = nil
                end

            end
        end
        popup.hidePopUp()
        for i = 1, #star do
            display.remove (star[i])
            star[i] = nil
        end
    end
end

function scene:destroy(event)
    explosion.destroyExplosion()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene