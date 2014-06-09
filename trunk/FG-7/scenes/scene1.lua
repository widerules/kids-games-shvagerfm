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
local nextButton, previousButton, homeButton
local dots = {}
local but = {}
local dotName = {}

local soundName

--[[local function onHomeButtonTapped (event)
    storyboard.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
    storyboard.removeScene( "scenes.game1" )
end
--]]
local function onPreviousButtonTapped (event)
    if index > 1 then
        index = index - 1
    else
        index = #data.shapes
    end
    storyboard.reloadScene()
end

local function onNextButtonTapped (event)

    if index < #data.shapes then
        index = index + 1
    else
        index = 1
    end

    storyboard.reloadScene()
end

local function sayName()
    soundName = audio.loadSound( "sounds/"..data.shapes[index]..".mp3" )
    audio.play( soundName )
end

local function completedShape ()
    image = display.newImage(data.formPath..data.shapes[index]..data.format, constants.CENTERX, constants.CENTERY)
    image.width = _IMAGESIZE
    image.height = _IMAGESIZE
    sayName()
end

function scene:createScene(event)
    local group = self.view

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

    previousButton = widget.newButton
        {
            x = constants.CENTERX - _IMAGESIZE,
            y = constants.CENTERY,
            defaultFile = "images/prev.png",
            overFile = "images/prev.png",
            width = _BTNSIZE,
            height = _BTNSIZE,
            onRelease = onPreviousButtonTapped
        }

    group:insert(previousButton)

    nextButton = widget.newButton
        {
            x = constants.CENTERX + _IMAGESIZE,
            y = constants.CENTERY,
            defaultFile = "images/next.png",
            overFile = "images/next.png",
            width = _BTNSIZE,
            height = _BTNSIZE,
            onRelease = onNextButtonTapped
        }

    group:insert(nextButton)

end



function scene:enterScene(event)
    local group = self.view
    local shape = data.shapes[index]
    local completed = -1
    --DRAW SHAPE
    for i = 1,table[shape].size do
        dots[i] = display.newGroup()
        print(table[shape][i].x, table[shape][i].y)
        local img = display.newCircle(table[shape][i].x, table[shape][i].y, _RADIUS)
        img:setFillColor(0,0,0)
        dots[i]:insert(img)
        dotName[i] = display.newText(i, table[shape][i].x, table[shape][i].y, native.systemFont, _RADIUS*1.8)
        group:insert(dots[i])
        group:insert(dotName[i])
        but[i]  = widget.newButton {
            id = i,
            isEnabled = (i == 1),
            width = _RADIUS*2,
            height = _RADIUS*2,
            x = table[shape][i].x,
            y = table[shape][i].y,
            onRelease = function (event)
                if event.phase == "ended" then
                    if (i == 1) then
                        completed = completed + 1
                    end
                    img:setFillColor(1, 1, 0)
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
                        for j = 1, #dots do
                            display.remove(dots[j])
                            display.remove(dotName[j])
                        end
                        completedShape(shape)
                    end
                end
            end
        }
        but[i].alpha = 0.01
        dots[i]:insert(but[i])
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
    display.remove(previousButton)
    previousButton = nil
    display.remove(nextButton)
    nextButton = nil
    display.remove(background)
    background = nil

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene