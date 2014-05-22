local memoryViewer = require ("memoryViewer")

shouldWork = true

memoryViewer.create(display.contentCenterX, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

function showLabel()
	local myText = display.newText( "Hello World!", 200, 200, native.systemFont, 46 )
	return myText
end

function showLongLabel()
	local myLongText = display.newText( "MY LONGLONGLONGLONGLONGLONGLONG", 300, 500, native.systemFont, 26 )
	return myLongText
end

function showImage()
	local myImage = display.newImage("img.png", 500, 500)
	return myImage;
end

function showSomething(someFunctionWhichReturnObject)
	someFunctionWhichReturnObject.isVisible = true
end

functionArray = {}
functionArray[1] = showLabel;
functionArray[2] = showLongLabel;
functionArray[3] = showImage;

local i = 1
for i = 1, #functionArray do
	showSomething(functionArray[i]())
end

