--
-- Created by IntelliJ IDEA.
-- User: Svyat
-- Date: 21/06/2014
-- Time: 07:44 PM
-- To change this template use File | Settings | File Templates.
--

local storyboard = require ("storyboard")
--local composer = require("composer")
local widget = require("widget")
local constants = require ("constants")
local data = require( "data.shapesData")

local scene = storyboard.newScene()

local _IMAGESIZE, _BUTTONSIZE
--local _FONTSIZE = constants.H / 14

local level--, gamesWon

local background, backBtn

local index, indexAdd1, indexAdd2

local images = {}
local buttons = {}

local timers = {}

local soundName--, soundStart, dotSound

local function backHome()
    storyboard.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
    storyboard.removeScene( "scenes.game7" )
end

--[[
local function sayGood()
    if(math.random() < 0.5) then
        soundName = audio.loadSound("sounds/good.mp3")
    else soundName = audio.loadSound("sounds/welldone.mp3")
    end
    audio.play(soundName)
end]]

--[[
local function playStart()
    soundStart = audio.loadSound("sounds/start.mp3")
    audio.play(soundStart)
end]]

local function transitionFigure(button)

    transition.to(images[#images], {time = 300, alpha = 0})

    transition.to(button, {time = 500,
                           x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1),
                           y = constants.CENTERY*0.8,
                           xScale = _IMAGESIZE/button.width,
                           yScale = _IMAGESIZE/button.height})
end

local function toNextFigure()  --функция для перехода на следующую фигуру
    level = (level < 7) and level + 1 or 1
    storyboard.gotoScene("scenes.game7")
end

local function sayName(event)
    soundName = audio.loadSound( "sounds/"..data.shapes[index]..".mp3" )
    audio.play( soundName )
end

local function buttonListener (event)   --обработчик сообщений от кнопок
    if (event.target.id == index) then
        transitionFigure(event.target)
        sayName()
        timers[#timers+1] = timer.performWithDelay(1000, toNextFigure)
    end
end

local function createBut(group)  --создаём точки
    local t = math.random(1, 3)
    local tmpIndex = {}

    for i = 1, 3 do
        if (i ~= t) then
            if (i == 1) then
                repeat
                    tmpIndex[i] = math.random(1, 13)
                until (tmpIndex[i] ~= index)
            elseif (i == 2) then
                repeat
                    tmpIndex[i] = math.random(1, 13)
                until (tmpIndex[i] ~= index and tmpIndex[i] ~= tmpIndex[i-1])
            else
                repeat
                    tmpIndex[i] = math.random(1, 13)
                until (tmpIndex[i] ~= tmpIndex[i-1] and tmpIndex[i] ~= tmpIndex[i-2])
            end
        else
            tmpIndex[i] = index
        end
    end

    for i = 1, 3 do

        buttons[i]  = widget.newButton {
            id = tmpIndex[i],
            width = _BUTTONSIZE,
            height = _BUTTONSIZE,

            defaultFile = data.formPath..data.shapes[tmpIndex[i]]..data.format,

            x = constants.W*0.25*i,
            y = constants.H*0.8,

            onRelease = buttonListener
        }

        group:insert(buttons[i])
    end
end

function scene:createScene(event)
    local group = self.view
    background = display.newImage("images/background2.jpg", constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert(background)

    backBtn = widget.newButton
        {
            --left = 0,
            --top = 0,
            defaultFile = "images/home.png",
            overFile = "images/homehover.png",
            id = "home",
            onRelease = backHome,

        }
    backBtn.width, backBtn.height = 0.1*constants.W, 0.1*constants.W
    backBtn.x, backBtn.y = backBtn.width/2, backBtn.height/2
    group:insert( backBtn )

    math.randomseed(os.time())

    _BUTTONSIZE = constants.W*0.15

    --gamesWon = 0
    level = 1
end

function scene:willEnterScene(event)
    local group = self.view

    if (level == 1) then
        _IMAGESIZE = constants.W*0.7/3
    elseif (level == 2 or level == 3) then
        _IMAGESIZE = constants.W*0.7/4
    elseif (level == 4 or level == 5) then
        _IMAGESIZE = constants.W*0.7/6
    end

end

function scene:enterScene(event)
    local group = self.view

    index = math.random (1, 13)
    indexAdd1 = index
    indexAdd2 = index

    if (level == 1) then
        for i = 1, 2 do
            images[#images+1] = display.newImage(data.formPath..data.shapes[index]..data.format)
            images[#images].width = _IMAGESIZE
            images[#images].height = _IMAGESIZE
            images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
            images[#images].y = constants.CENTERY*0.8
            group:insert(images[#images])
        end
    elseif (level == 2) then
        for i = 1, 3 do

            images[#images+1] = display.newImage(data.formPath..data.shapes[index]..data.format)
            images[#images].width = _IMAGESIZE
            images[#images].height = _IMAGESIZE
            images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
            images[#images].y = constants.CENTERY*0.8

            group:insert(images[#images])
        end
    elseif (level == 3) then

        while (indexAdd1 == index) do
            indexAdd1 = math.random(1, 13)
        end

        for i = 1, 3 do

            if (i%2 == 0) then
                images[#images+1] = display.newImage(data.formPath..data.shapes[index]..data.format)
            else
                images[#images+1] = display.newImage(data.formPath..data.shapes[indexAdd1]..data.format)
            end

            images[#images].width = _IMAGESIZE
            images[#images].height = _IMAGESIZE
            images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
            images[#images].y = constants.CENTERY*0.8

            group:insert(images[#images])
        end
    elseif (level == 4) then

        while (indexAdd1 == index) do
            indexAdd1 = math.random(1, 13)
        end

        while (indexAdd2 == index or indexAdd2 == indexAdd1) do
            indexAdd2 = math.random(1, 13)
        end

        for i = 1, 5 do
            if (i == 3) then
                images[#images+1] = display.newImage(data.formPath..data.shapes[index]..data.format)
            elseif (i%3 == 1) then
                images[#images+1] = display.newImage(data.formPath..data.shapes[indexAdd1]..data.format)
            else
                images[#images+1] = display.newImage(data.formPath..data.shapes[indexAdd2]..data.format)
            end
            images[#images].width = _IMAGESIZE
            images[#images].height = _IMAGESIZE
            images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
            images[#images].y = constants.CENTERY*0.8
            group:insert(images[#images])
        end

    elseif (level == 5) then

        while (indexAdd1 == index) do
            indexAdd1 = math.random(1, 13)
        end

        for i = 1, 5 do
            if (i == 3) then
                images[#images+1] = display.newImage(data.formPath..data.shapes[index]..data.format)
            else
                images[#images+1] = display.newImage(data.formPath..data.shapes[indexAdd1]..data.format)
            end
            images[#images].width = _IMAGESIZE
            images[#images].height = _IMAGESIZE
            images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
            images[#images].y = constants.CENTERY*0.8
            group:insert(images[#images])
        end

    elseif (level == 6) then

        while (indexAdd1 == index) do
            indexAdd1 = math.random(1, 13)
        end

        for i = 1, 5 do
            if (i%3 == 1) then
                images[#images+1] = display.newImage(data.formPath..data.shapes[indexAdd1]..data.format)
            else
                images[#images+1] = display.newImage(data.formPath..data.shapes[index]..data.format)
            end
            images[#images].width = _IMAGESIZE
            images[#images].height = _IMAGESIZE
            images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
            images[#images].y = constants.CENTERY*0.8
            group:insert(images[#images])
        end

    elseif (level == 7) then

        while (indexAdd1 == index) do
            indexAdd1 = math.random(1, 13)
        end

        for i = 1, 5 do
            if (i%3 == 2) then
                images[#images+1] = display.newImage(data.formPath..data.shapes[indexAdd1]..data.format)
            else
                images[#images+1] = display.newImage(data.formPath..data.shapes[index]..data.format)
            end
            images[#images].width = _IMAGESIZE
            images[#images].height = _IMAGESIZE
            images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
            images[#images].y = constants.CENTERY*0.8
            group:insert(images[#images])
        end

    end

    images[#images+1] = display.newImage("images/question.png")
    images[#images].width = _IMAGESIZE
    images[#images].height = _IMAGESIZE
    images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
    images[#images].y = constants.CENTERY*0.8

    group:insert(images[#images])

    createBut(group)

end

function scene:exitScene(event)
    local group = self.view

    transition.cancel()
    audio.stop()

    if (soundName ~= nil) then
        audio.dispose(soundName)
        soundName = nil
    end

    for i = 1, #timers do
        timer.cancel(timers[i])
    end
    for i = 1, #images do
        group:remove(images[i])
        images[i] = nil
    end
    for i = 1, #buttons do
        group:remove(buttons[i])
        buttons[i] = nil
    end

end

function scene:destroyScene(event)
    display.remove(backBtn)
    backBtn = nil
    display.remove(background)
    background = nil

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene