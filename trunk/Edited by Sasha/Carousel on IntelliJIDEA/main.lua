local memoryViewer = require ("memoryViewer")
local data = require("data")
local slide = require("slide")

shouldWork = true

memoryViewer.create(display.contentCenterX, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

local firstSlide = slide:create( display.contentCenterX, display.contentCenterY, 500, 500 )
firstSlide:insertObject( data.showLabel, data.hideLabel, "Label" )
firstSlide:insertObject( data.showLongLabel, data.hideLongLabel, "longLabel" )
firstSlide:insertObject( data.showImage, data.hideImage, "Image" )

firstSlide:showObject( 1 )
firstSlide:showObject( "longLabel" )
firstSlide:showObject( 3 )

print( firstSlide:getObjectsCount() )

local function hideAll()
    firstSlide:hideObject( "Label" )
    firstSlide:hideObject( 2 )
    firstSlide:hideObject( "Image" )
end

timer.performWithDelay( 4000, hideAll)
