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
local mySlides = {} -- массив слайдов (не обязательно создавать)
local myImages = {} -- массив 
local myLabels = {}

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

-- создание массива объектов, которые буду на карусели.
myImages[1] = slideObject.new()
myImages[1].name = "image1"
myImages[1].createFunction = function() myImages[1] = display.newImage( "1.png", 30, 30 ) return myImages[1] end
myImages[1].showFunction = function() myImages[1].isVisible = true  end
myImages[1].hideFunction =  function() myImages[1].isVisible = false  end
myImages[1].removeFunction = function() display.remove( myImages[1] ) myImages[1] = nil end

myLabels[1] = slideObject.new()
myLabels[1].name = "label1"
myLabels[1].createFunction = function() myLabels[1] = display.newText( "Label1", 5, 5, native.systemFont, 46 ) return myLabels[1] end
myLabels[1].showFunction = function() myLabels[1].isVisible = true  end
myLabels[1].hideFunction =  function() myLabels[1].isVisible = false end
myLabels[1].removeFunction = function() display.remove(myLabels[1]) myLabels[1] = nil end

myImages[2] = slideObject.new()
myImages[2].name = "image2"
myImages[2].createFunction = function() myImages[2] = display.newImage( "2.png", 60, 60 ) return myImages[2] end
myImages[2].showFunction = function() myImages[2].isVisible = true  end
myImages[2].hideFunction =  function() myImages[2].isVisible = false  end
myImages[2].removeFunction = function() display.remove( myImages[2] ) myImages[2] = nil end

myLabels[2] = slideObject.new()
myLabels[2].name = "label2"
myLabels[2].createFunction = function() myLabels[2] = display.newText( "Label2", 10, 10, native.systemFont, 46 ) return myLabels[2] end
myLabels[2].showFunction = function() myLabels[2].isVisible = true  end
myLabels[2].hideFunction =  function() myLabels[2].isVisible = false end
myLabels[2].removeFunction = function() display.remove(myLabels[2]) myLabels[2] = nil end

myImages[3] = slideObject.new()
myImages[3].name = "image3"
myImages[3].createFunction = function() myImages[3] = display.newImage( "3.png", 90, 90 ) return myImages[3] end
myImages[3].showFunction = function() myImages[3].isVisible = true  end
myImages[3].hideFunction =  function() myImages[3].isVisible = false  end
myImages[3].removeFunction = function() display.remove( myImages[3] ) myImages[3] = nil end

myLabels[3] = slideObject.new()
myLabels[3].name = "label3"
myLabels[3].createFunction = function() myLabels[3] = display.newText( "Label3", 15, 15, native.systemFont, 46 ) return myLabels[3] end
myLabels[3].showFunction = function() myLabels[3].isVisible = true  end
myLabels[3].hideFunction =  function() myLabels[3].isVisible = false end
myLabels[3].removeFunction = function() display.remove(myLabels[3]) myLabels[3] = nil end

myImages[4] = slideObject.new()
myImages[4].name = "image4"
myImages[4].createFunction = function() myImages[4] = display.newImage( "4.png", 120, 120 ) return myImages[4] end
myImages[4].showFunction = function() myImages[4].isVisible = true  end
myImages[4].hideFunction =  function() myImages[4].isVisible = false  end
myImages[4].removeFunction = function() display.remove( myImages[4] ) myImages[4] = nil end


myLabels[4] = slideObject.new()
myLabels[4].name = "label4"
myLabels[4].createFunction = function() myLabels[4] = display.newText( "Label4", 20, 20, native.systemFont, 46 ) return myLabels[4] end
myLabels[4].showFunction = function() myLabels[4].isVisible = true  end
myLabels[4].hideFunction =  function() myLabels[4].isVisible = false end
myLabels[4].removeFunction = function() display.remove(myLabels[4]) myLabels[4] = nil end


myCarousel = carousel.new( display.contentCenterX, display.contentCenterY, 500, 500 )

for i = 1, 4 do

    -- более краткая форма создания ;)
    --[[
    myImages[i] = slideObject.new()
    myImages[i].name = "image"..i
    myImages[i].createFunction = function( id ) myImages[id] = display.newImage( id..".png", id*30, id*30 ) return myImages[id] end
    myImages[i].showFunction = function( id ) myImages[id].isVisible = true print("id in show im: "..id) end
    myImages[i].hideFunction =  function( id ) myImages[id].isVisible = false  end
    myImages[i].removeFunction = function( id ) display.remove( myImages[id] ) myImages[id] = nil end

    myLabels[i] = slideObject.new()
    myLabels[i].name = "label"..i
    myLabels[i].createFunction = function( id ) myLabels[id] = display.newText( "Label"..id, id*5, id*5, native.systemFont, 46 ) return myLabels[id] end
    myLabels[i].showFunction = function( id ) myLabels[id].isVisible = true  print("id in show lab: "..id) end
    myLabels[i].hideFunction =  function( id ) myLabels[id].isVisible = false end
    myLabels[i].removeFunction = function( id ) display.remove(myLabels[id]) myLabels[id] = nil end
    --]]--

    -- создать слайд по центру экрана размером 200х200 с именем slide (i-тый)
    mySlides[i] = slide.new( display.contentCenterX, display.contentCenterY, 200, 200, "slide"..i )

    -- добавить объект из массива на слайд
    mySlides[i]:insertObject( myLabels[i] )
    mySlides[i]:insertObject( myImages[i] )

    -- добавить слайд в карусель
    myCarousel:insertSlide( mySlides[i] )
end


myCarousel:showSlide( 1 ) -- показать первый слайд
