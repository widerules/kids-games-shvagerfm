local memoryViewer = require ("memoryViewer")
local data = require("data")
local slide = require("slide")
local slideObject = require("slideObject")
local slideObject = require("slideObject")

shouldWork = true
memoryViewer.create(display.contentCenterX, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

local myLabel, myImage

local function createMyLabel() myLabel = display.newText( "Hello World!", 5, 5, native.systemFont, 46 ) return myLabel end
local function showMyLabel() myLabel.isVisible = true end
local function hideMyLabel() myLabel.isVisible = false end
local function removeMyLabel() display.remove( myLabel ) myLabel = nil end

local function createMyImage() myImage = display.newImage("img.png", 50, 50) return myImage end
local function showMyImage() myImage.isVisible = true end
local function hideMyImage() myImage.isVisible = false end
local function removeMyImage() display.remove( myImage ) myImage = nil end

-- create label - slide object
local label1 = slideObject.create()
label1.name = "Label"
label1.createFunction = createMyLabel
label1.showFunction = showMyLabel
label1.hideFunction =  hideMyLabel
label1.removeFunction = removeMyLabel

-- create image - slide object
local image1 = slideObject.create()
image1.name = "cute image"
image1.createFunction = createMyImage
image1.showFunction = showMyImage
image1.hideFunction = hideMyImage
image1.removeFeunction = removeMyImage

local longlabel1 = slideObject.create()



local firstSlide = slide.create( display.contentCenterX, display.contentCenterY, 200, 200 )

firstSlide:insertObject( image1 )
firstSlide:insertObject( label1 )

print(firstSlide:count())

firstSlide:showAllObjects()
--firstSlide:hideObject( 1 )
