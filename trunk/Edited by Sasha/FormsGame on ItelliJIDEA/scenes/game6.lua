local storyboard = require("storyboard")
local widget = require("widget")
local constants = require ("constants")
local data = require( "data.shapesData")
local table = require("data.dots_coordinates")
local sam = require("utils.sam")

local scene = storyboard.newScene()

local _BTNSIZE = 0.1*constants.W
local _IMAGESIZE = 0.4*constants.W
local _FONTSIZE = constants.H / 14
local _RADIUS = 0.025*constants.W

print("game6")

local index = 1

local background, image
local homeButton
local dots, but,dotName, img, completed

local timers

local soundName, soundStart, dotSound

local completedShape

local function onHomeButtonTapped (event)
    storyboard.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
    storyboard.removeScene( "scenes.game6" )
end

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

local function toNextFigure()  --функция для перехода на следующую фигуру

    if index < #data.shapes then
        index = index + 1
    else
        index = 1
    end
    if (image ~= nil) then
        transition.to(image, {time = 1500, rotation = 360, transition = easing.outBack,                                   --анимация для фигуры:
                          x = constants.W+_IMAGESIZE/2, y = 0, xScale = image.width*0.1, yScale = image.height*0.1})  --вращение, выезд за пределы экрана, уменьшение
    end
    timers[#timers+1] = timer.performWithDelay(500, sayGood)
    timers[#timers+1] = timer.performWithDelay(1600, storyboard.reloadScene)

end

local function sayName(event)
    soundName = audio.loadSound( "sounds/"..data.shapes[index]..".mp3" )
    audio.play( soundName )
end

local function buttonListener (event)   --обработчик сообщений от точек

    local shape = data.shapes[index]
    local i = tonumber(event.target.id)     --порядковый номер кнопки
    img[i].alpha = 1.0 -- на случай, если кнопка не успела прорисоваться на момент нажатия

    event.target:setEnabled(false)  --отклюачаем текущую кнопку

    audio.play(dotSound)

    --меняем цвет точки, а также с анимацией её увеличиваем
    img[i]:setFillColor(1, 1, 0)
    transition.scaleTo(img[i], {time = 300, xScale = 1.5, yScale = 1.5, transition = easing.outBack})
    transition.scaleTo(dotName[i], {time = 300, xScale = 1.5, yScale = 1.5, transition = easing.outBack})
    but[i].width = but[i].width * 1.5
    but[i].height = but[i].height * 1.5

    --проверка на завершённость контура
    if (completed == true) then

        --соединяем линией первую и последнюю точки
        local line = display.newLine(table[shape][table[shape].size].x, table[shape][table[shape].size].y, table[shape][1].x, table[shape][1].y)
        line:setStrokeColor(1, 1, 0)
        line.strokeWidth = _RADIUS
        dots[i]:insert(line)

        dotName[table[shape].size]:toFront()
        img[i]:toFront()
        dotName[1]:toFront()

        playStart()     --играет звук

        timers[#timers+1] = timer.performWithDelay(1000, completedShape)
    else
        if(i>1) then

            --соединяем линией текущую точку с предыдущей
            local line = display.newLine(table[shape][i-1].x, table[shape][i-1].y, table[shape][i].x, table[shape][i].y)
            line:setStrokeColor(1, 1, 0)
            line.strokeWidth = _RADIUS
            dots[i]:insert(line)
            img[i-1]:toFront()
            img[i]:toFront()
            dotName[i-1]:toFront()
            dotName[i]:toFront()

        end
        if (i < #but) then  --активируем следующую кнопку
            but[i+1]:setEnabled(true)           --ВОТ! ЗДЕСЬ ВКЛЮЧАЕТСЯ СЛЕДУЮЩАЯ КНОПКА! НО ПРИ БЕГАН ОНА НЕ ВКЛЮЧАЕТСЯ #@#$@!%$#%
        else
            but[1]:setEnabled(true)
            completed = true
        end
    end
end

local function createBut()  --создаём точки
    for i = 1, #dots do
        but[i]  = widget.newButton {
            id = i,
            isEnabled = (i==1), --по умолчанию активна только первая точка

            width = _RADIUS*2,
            height = _RADIUS*2,

            x = table[data.shapes[index]][i].x,
            y = table[data.shapes[index]][i].y,

            onRelease = buttonListener
        }
        but[i].alpha = 0.01         --делаем максимально прозрачную кнопку, чтобы она не перекрывала рисунок точки
        dots[i]:insert(but[i])
    end
end

completedShape =  function  ()       --функция вызывается при замыкании контура, рисует фигуру, говорит поздравления
   sam.swapSamActive()
   if (dots ~= nil and dotName ~= nil) then
       for j = 1, #dots do                 --удаляем точки и цифры
            display.remove(dots[j])
            display.remove(dotName[j])
       end
   end

    image = display.newImage(data.formPath..data.shapes[index]..data.format, constants.CENTERX, constants.CENTERY)  --рисует фигуру
    image.width = _IMAGESIZE*0.1
    image.height = _IMAGESIZE*0.1
    image.alpha = 0.0

    transition.scaleTo(image, {time = 500, xScale = 10.0, yScale = 10.0, transition = easing.outBack})
    transition.fadeIn(image, {time = 500})

    timers[#timers+1] = timer.performWithDelay(500, sayName)
    timers[#timers+1] = timer.performWithDelay(2000, toNextFigure)
end

function scene:createScene(event)
    local group = self.view

    math.randomseed(os.time())

    background = display.newImage ("images/background2.jpg", constants.CENTERX, constants.CENTERY)
    background.width = constants.W
    background.height = constants.H
    group:insert(background)

    sam.show(constants.W * 0.15, 1)

    homeButton = widget.newButton
        {
            x = _BTNSIZE/2,
            y = _BTNSIZE/2,
            defaultFile = "images/home.png",
            overFile = "images/homehover.png",
            width = _BTNSIZE,
            height = _BTNSIZE,
            onRelease = onHomeButtonTapped
        }

    group:insert(homeButton)

end

function scene:enterScene(event)
    local group = self.view

    local shape = data.shapes[index]
    timers = {}     --таймеры
    dots = {}       --точки
    but = {}        --кнопки
    dotName = {}    --цифры
    img = {}        --рисунки точек
    local del = 0   -- delay
    completed = false

    dotSound = audio.loadSound("sounds/Plopp.mp3")

    for i = 1,table[shape].size do

        dots[i] = display.newGroup()
        img[i] = display.newCircle(table[shape][i].x, table[shape][i].y, _RADIUS) --рисуем точки
        img[i]:setFillColor(0,0,0)
        img[i].alpha = 0.0
        transition.fadeIn(img[i], {time = 500, delay = del}) --анимация с задержкой, чтобы кнопки появлялись по очереди
        dots[i]:insert(img[i])

        dotName[i] = display.newText(i, table[shape][i].x, table[shape][i].y, native.systemFont, _RADIUS*1.8)   --делаем номера кнопок внутри точек
        dotName[i].alpha = 0.0
        transition.fadeIn(dotName[i], {time = 500, delay = del})

        group:insert(dots[i])
        group:insert(dotName[i])

        --local function listener() return createBut end


        del = del + 500             --увеличиваем задержку для следующей точки
    end
    createBut()
end

function scene:exitScene(event)
    local group = self.view
    for i = 1, #timers do
        timer.cancel(timers[i])
    end
    if (image ~= nil) then
        display.remove(image)
        image = nil
    end
    transition.cancel()
    audio.stop()
    if (soundStart ~= nil) then
       audio.dispose(soundStart)
       soundStart = nil
    end
    if (dotSound ~= nil) then
       audio.dispose(dotSound)
       dotSound = nil
    end

    if (dots ~= nil) then
        for i = 1, #dots do
            display.remove(dots[i])
        end
        dots = nil
    end
    if (but ~= nil) then
        for i = 1, #but do
            display.remove(but[i])
        end
        but = nil
    end
    if (dotName ~= nil) then
        for i = 1, #dotName do
            display.remove(dotName[i])
        end
        dotName = nil
    end
    if (img ~= nil) then
        for i = 1, #img do
            display.remove(img[i])
        end
        img = nil
    end



    if (soundName ~= nil) then
        audio.dispose( soundName )
        soundName = nil
    end
end

function scene:destroyScene(event)
    sam.hide()

    display.remove(homeButton)
    homeButton = nil
    display.remove(background)
    background = nil

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene