local storyboard = require("storyboard")
local widget = require("widget")
local constants = require ("constants")
local data = require( "data.shapesData")
local table = require("data.dots_coordinates")

local scene = storyboard.newScene()

local _BTNSIZE = 0.1*constants.W
local _IMAGESIZE = 0.4*constants.W
local _FONTSIZE = constants.H / 14
local _RADIUS = 0.025*constants.W

local index = 1

local background, image
local homeButton
local dots = {}
local but = {}
local dotName = {}
local img = {}
local completed

local soundName, soundStart, dotSound

--[[local function onHomeButtonTapped (event)
    storyboard.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
    storyboard.removeScene( "scenes.game1" )
end
]]
local function sayGood()
    if(math.random() < 0.5) then
        soundName = audio.loadSound("sounds/good.mp3")
    else soundName = audio.loadSound("sounds/welldone.mp3")
    end
    audio.play(soundName)
end

local function playStart()
    soundStart = audio.loadSound("sounds/start.mp3")
    audio.play(soundStart)
end

local function toNextFigure()

    if index < #data.shapes then
        index = index + 1
    else
        index = 1
    end
    transition.to(image, {time = 1500, rotation = 360, transition = easing.outBack,
                          x = -_IMAGESIZE, xScale = image.width*0.1, yScale = image.height*0.1})
    timer.performWithDelay(500, sayGood)
    timer.performWithDelay(1600, storyboard.reloadScene)
end

local function sayName(event)
    soundName = audio.loadSound( "sounds/"..data.shapes[index]..".mp3" )
    audio.play( soundName )
    soundName = nil
end

local function completedShape ()

    for j = 1, #dots do
        display.remove(dots[j])
        display.remove(dotName[j])
    end

    image = display.newImage(data.formPath..data.shapes[index]..data.format, constants.CENTERX, constants.CENTERY)
    image.width = _IMAGESIZE*0.1
    image.height = _IMAGESIZE*0.1
    image.alpha = 0.0

    transition.scaleTo(image, {time = 500, xScale = 10.0, yScale = 10.0, transition = easing.outBack})
    transition.fadeIn(image, {time = 500})

    timer.performWithDelay(500, sayName)
    timer.performWithDelay(2000, toNextFigure)
end

local function buttonListener (event)
   -- print(event.phase)
    local shape = data.shapes[index]
    local i = tonumber(event.target.id)
    --if(event.phase == "began") then return end
    print(event.phase)
    --if(event.target.isEnabled == false) then return end
    event.target:setEnabled(false)
    print ("in button")
        audio.play(dotSound)
        img[i]:setFillColor(1, 1, 0)
        transition.scaleTo(img[i], {time = 300, xScale = 1.5, yScale = 1.5, transition = easing.outBack})
        transition.scaleTo(dotName[i], {time = 300, xScale = 1.5, yScale = 1.5, transition = easing.outBack})
        but[i].width = but[i].width * 1.5
        but[i].height = but[i].height * 1.5


    if (completed == true) then
        local line = display.newLine(table[shape][table[shape].size].x, table[shape][table[shape].size].y, table[shape][1].x, table[shape][1].y)
        line:setStrokeColor(1, 1, 0)
        line.strokeWidth = _RADIUS
        dots[i]:insert(line)

        dotName[table[shape].size]:toFront()
        dotName[1]:toFront()

        playStart()

        --del = 0
        local listener = function () return completedShape(shape) end
        timer.performWithDelay(1000, completedShape)
    else
        if(i>1) then
            local line = display.newLine(table[shape][i-1].x, table[shape][i-1].y, table[shape][i].x, table[shape][i].y)
            line:setStrokeColor(1, 1, 0)
            line.strokeWidth = _RADIUS
            dots[i]:insert(line)
            dotName[i-1]:toFront()
            dotName[i]:toFront()
        end
        if (i < #but) then
            but[i+1]:setEnabled(true)           --ВОТ! ЗДЕСЬ ВКЛЮЧАЕТСЯ СЛЕДУЮЩАЯ КНОПКА! НО ПРИ БЕГАН ОНА НЕ ВКЛЮЧАЕТСЯ #@#$@!%$#%

            print(#but)
        else
            but[1]:setEnabled(true)
            completed = true
        end
    end
end

function scene:createScene(event)
    local group = self.view

    math.randomseed(os.time())

    background = display.newImage ("images/background2.jpg", constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert(background)

    homeButton = widget.newButton
        {
            x = _BTNSIZE/2,
            y = _BTNSIZE/2,
            defaultFile = "images/home.png",
            overFile = "images/homehover.png",
            width = _BTNSIZE,
            height = _BTNSIZE,
            --onRelease = onHomeButtonTapped
        }

    group:insert(homeButton)

end

function scene:enterScene(event)
    local group = self.view
    local shape = data.shapes[index]
    local del = 0 -- delay
    completed = false

    dotSound = audio.loadSound("sounds/plopp.mp3")
    --DRAW SHAPE
    for i = 1,table[shape].size do
        dots[i] = display.newGroup()
        img[i] = display.newCircle(table[shape][i].x, table[shape][i].y, _RADIUS)
        img[i]:setFillColor(0,0,0)
        img[i].alpha = 0.0
        transition.fadeIn(img[i], {time = 1000, delay = del})
        dots[i]:insert(img[i])
        dotName[i] = display.newText(i, table[shape][i].x, table[shape][i].y, native.systemFont, _RADIUS*1.8)
        dotName[i].alpha = 0.0
        transition.fadeIn(dotName[i], {time = 1000, delay = del})
        group:insert(dots[i])
        group:insert(dotName[i])

        but[i]  = widget.newButton {
            id = i,
            isEnabled = (i==1),
            width = _RADIUS*2,
            height = _RADIUS*2,
            x = table[shape][i].x,
            y = table[shape][i].y,
            onEvent = buttonListener
            --[[onEvent = function (event)
                --if event.phase == "began" then
                    audio.play(dotSound)
                    if (i == 1) then
                        completed = completed + 1
                    end
                    img:setFillColor(1, 1, 0)
                    transition.scaleTo(img, {time = 300, xScale = 1.5, yScale = 1.5, transition = easing.outBack})
                    transition.scaleTo(dotName[i], {time = 300, xScale = 1.5, yScale = 1.5, transition = easing.outBack})
                    but[i].width = but[i].width * 1.5
                    but[i].height = but[i].height * 1.5
                    but[i]:setEnabled(false)
                    if (i > 1)  then
                        local line = display.newLine(table[shape][i-1].x, table[shape][i-1].y, table[shape][i].x, table[shape][i].y)
                        line:setStrokeColor(1, 1, 0)
                        line.strokeWidth = _RADIUS
                        dots[i]:insert(line)
                        dotName[i-1]:toFront()
                        dotName[i]:toFront()
                    end
                    if (i < table[shape].size and (completed ~= 1)) then
                        but[i+1]:setEnabled(true)
                    end
                    if i == table[shape].size then
                        but[1]:setEnabled(true)
                    end
                    if (completed == 1) then

                        local line = display.newLine(table[shape][table[shape].size].x, table[shape][table[shape].size].y, table[shape][1].x, table[shape][1].y)
                        line:setStrokeColor(1, 1, 0)
                        line.strokeWidth = _RADIUS
                        dots[i]:insert(line)

                        dotName[table[shape].size]:toFront()
                        dotName[1]:toFront()

                        playStart()

                        del = 0
                        local listener = function () return completedShape(shape) end
                        timer.performWithDelay(1000, listener)
                  --  end
                end
            end--]]
        }
        but[i].alpha = 0.01
        dots[i]:insert(but[i])
        --but[i]:addEventListener("touch", buttonListener)
        del = del + 500
    end
end

function scene:exitScene(event)
    local group = self.view
    for i = 1, #dots do
        display.remove(dots[i])
        display.remove(but[i])
        display.remove(dotName[i])
    end
    --transition.cancel( )
    audio.dispose( soundName )
    soundName = nil
    display.remove(image)
    image = nil
    storyboard.purgeScene("scene1")
end

function scene:destroyScene(event)
    display.remove(homeButton)
    homeButton = nil

    audio.dispose(soundStart)
    audio.dispose(dotSound)

    soundStart = nil
    dotSound = nil

    display.remove(background)
    background = nil

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene