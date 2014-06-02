local memoryViewer = require ("memoryViewer")
local widget = require("widget")
local data = require("data")
local slide = require("slide")
local slideObject = require("slideObject")
local carousel = require( "carousel" )

shouldWork = true
memoryViewer.create(display.contentCenterX, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

local myCarousel
local myImages = {} -- массив картинок, которые будут отображаться на слайде
local myLabels = {} -- массив надписей, которые будут отображаться на слайде

-- кнопка для отображения следующего слайда
local next = widget.newButton
    {
        x = display.contentCenterX + display.contentCenterX / 4,
        y = display.contentCenterX,
        defaultFile = "btn.png",
        overFile = "btn.png",
        label = "Next",
        fontSize = 20,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        onRelease = function ()
            myCarousel:showNextSlide()
        end
    }

-- кнопка для отображения предыдущего слайда
local previous = widget.newButton
    {
        x = display.contentCenterX / 4,
        y = display.contentCenterX,
        defaultFile = "btn.png",
        overFile = "btn.png",
        label = "Prev",
        fontSize = 20,
        labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0, 0.5 } },
        onRelease = function ()
            myCarousel:showPreviousSlide()
        end
    }

-- создаем карусель по центру экрана размером 500х500
myCarousel = carousel.new( display.contentCenterX, display.contentCenterY, 500, 500 )

-- цикл добавления слайдов с объектами в карусель
for i = 1, 4 do

    -- создаем новый объект слайда (изображение) и вносим его в массив
    myImages[i] = slideObject.new()
    myImages[i].name = "image"..i
    myImages[i].createFunction = function( id ) myImages[id] = display.newImage( id..".png", id*30, id*30 ) return myImages[id] end
    myImages[i].showFunction = function( id ) myImages[id].isVisible = true print("id in show im: "..id) end
    myImages[i].hideFunction =  function( id ) myImages[id].isVisible = false  end
    myImages[i].removeFunction = function( id ) display.remove( myImages[id] ) myImages[id] = nil end

    -- создаем новый объект слайда (надпись) и вносим его в массив
    myLabels[i] = slideObject.new()
    myLabels[i].name = "label"..i
    myLabels[i].createFunction = function( id ) myLabels[id] = display.newText( "Label"..id, id*5, id*5, native.systemFont, 46 ) return myLabels[id] end
    myLabels[i].showFunction = function( id ) myLabels[id].isVisible = true  print("id in show lab: "..id) end
    myLabels[i].hideFunction =  function( id ) myLabels[id].isVisible = false end
    myLabels[i].removeFunction = function( id ) display.remove(myLabels[id]) myLabels[id] = nil end


    -- создать слайд по центру экрана размером 200х200 с именем slide (i-тый)
    local myNewSlide = slide.new( display.contentCenterX, display.contentCenterY, 200, 200, "slide"..i )

    -- добавить объекты из массивов на слайд
    myNewSlide:insertObject( myLabels[i] )
    myNewSlide:insertObject( myImages[i] )

    -- добавить слайд в карусель
    myCarousel:insertSlide(  myNewSlide )
end


myCarousel:showSlide( 1 ) -- показать первый слайд
