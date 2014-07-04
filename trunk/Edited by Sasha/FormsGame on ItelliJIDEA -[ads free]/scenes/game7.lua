--
-- Created by IntelliJ IDEA.
-- User: Svyat
-- Date: 21/06/2014
-- Time: 07:44 PM
-- To change this template use File | Settings | File Templates.
--

local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require ("constants")
local data = require( "data.shapesData")


local table = {
    {1, 1},
    {1, 1},
    {1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {2, 1, 2},
    {2, 1, 2},
    {2, 3, 1, 2, 3},
    {2, 3, 1, 2, 3},
    {2, 2, 1, 2, 2},
    {2, 2, 1, 2, 2},
    {2, 1, 1, 2, 1},
    {2, 1, 1, 2, 1},
    {1, 2, 1, 1, 2},
    {1, 2, 1, 1, 2}
}


local scene = storyboard.newScene()

local _IMAGESIZE, _BUTTONSIZE
--local _FONTSIZE = constants.H / 14
local lvlInfo

local level--, gamesWon

local background, backBtn

local index = {}

local images = {}
local downImg = {}
local button

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

local function transitionFigure()

    transition.to(images[#images], {time = 300, alpha = 0})

    transition.to(button, {time = 500,
                           x = images[#images].x,
                           y = images[#images].y,
                           xScale = _IMAGESIZE/_BUTTONSIZE,
                           yScale = _IMAGESIZE/_BUTTONSIZE})
end

local function toNextFigure()  --функция для перехода на следующую фигуру
    level = (level < #table) and level + 1 or 1
    storyboard.reloadScene()
end

local function sayName(event)
    soundName = audio.loadSound( "sounds/"..data.shapes[index[1]]..".mp3" )
    audio.play( soundName )
end

local function buttonListener (event)   --обработчик сообщений от кнопки
    transitionFigure(event.target)
    sayName()
    timers[#timers+1] = timer.performWithDelay(1000, toNextFigure)
end

local function createBut(group)  --создаём точки
    local t = math.random(1, 3)
    local tmpIndex = {}

    for i = 1, 3 do
        if (i ~= t) then
            if (i == 1) then
                repeat
                    tmpIndex[i] = math.random(1, 13)
                until (tmpIndex[i] ~= index[1])
            elseif (i == 2) then
                repeat
                    tmpIndex[i] = math.random(1, 13)
                until (tmpIndex[i] ~= index[1] and tmpIndex[i] ~= tmpIndex[i-1])
            else
                repeat
                    tmpIndex[i] = math.random(1, 13)
                until (tmpIndex[i] ~= tmpIndex[i-1] and tmpIndex[i] ~= tmpIndex[i-2])
            end
        else
            tmpIndex[i] = index[1]
        end
    end

    for i = 1, 3 do
        if (i == t) then
            button  = widget.newButton {
                id = tmpIndex[i],
                width = _BUTTONSIZE,
                height = _BUTTONSIZE,

                defaultFile = data.formPath..data.shapes[tmpIndex[i]]..data.format,

                x = constants.W*0.25*i,
                y = constants.H*0.8,

                onRelease = buttonListener
            }
            group:insert(button)
        else
            downImg[#downImg+1] = display.newImage(data.formPath..data.shapes[tmpIndex[i]]..data.format)
            downImg[#downImg].x = constants.W*0.25*i
            downImg[#downImg].y = constants.H*0.8
            downImg[#downImg].width = _BUTTONSIZE
            downImg[#downImg].height = _BUTTONSIZE
            group:insert(downImg[#downImg])
        end
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

    _BUTTONSIZE = constants.W*0.2

    --gamesWon = 0
    level = 1
end

function scene:willEnterScene(event)
    local group = self.view

    lvlInfo = table[level]

    _IMAGESIZE = constants.W*0.7/(#lvlInfo+1)

end

function scene:enterScene(event)
    local group = self.view

    index[1] = math.random (1, 13)
    index[2] = index[1]
    index[3] = index[1]

    while (index[2] == index[1]) do
        index[2] = math.random(1, 13)
    end

    while (index[3] == index[1] or index[3] == index[2]) do
        index[3] = math.random(1, 13)
    end

    for i = 1, #lvlInfo do
        images[#images+1] = display.newImage(data.formPath..data.shapes[index[lvlInfo[i]]]..data.format)
        images[#images].width = _IMAGESIZE
        images[#images].height = _IMAGESIZE
        images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
        images[#images].y = constants.H*0.35
        group:insert(images[#images])
    end

    images[#images+1] = display.newImage("images/ask.png")
    images[#images].width = _IMAGESIZE
    images[#images].height = _IMAGESIZE
    images[#images].x = images[#images].width*0.8 + images[#images].width*1.3*(#images-1)
    images[#images].y = constants.H*0.35

    group:insert(images[#images])

    createBut(group)

end

function scene:exitScene(event)
    local group = self.view

    lvlInfo = nil

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
    for i = 1, #downImg do
        group:remove(downImg[i])
        downImg[i] = nil
    end
    group:remove(button)
    button = nil

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