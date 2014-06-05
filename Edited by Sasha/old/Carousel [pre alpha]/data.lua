local myText
local myLongText
local myImage

local data = {}

data.showLabel = function()
	myText = display.newText( "Hello World!", 200, 200, native.systemFont, 46 )
	return myText
end

data.showLongLabel = function()
	myLongText = display.newText( "MY LONGLONGLONGLONGLONGLONGLONG", 300, 500, native.systemFont, 26 )
	return myLongText
end

data.showImage = function()
	myImage = display.newImage("img.png", 500, 500)
	return myImage;
end

data.hideLabel = function()
	display.remove(myText)
	myText = nil
end

data.hideLongLabel = function()
	display.remove(myLongText)
	myLongText = nil
end

data.hideImage = function()
	display.remove(myImage)
	myImage = nil
end

return data