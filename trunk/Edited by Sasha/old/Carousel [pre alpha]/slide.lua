local slide = {}

local showingFunctions = {}
local hidingFunctions = {}

local x, y, width, height, objectsCount

slide.create = function(xValue, yValue, widthValue, heightValue)
	objectsCount = 0

	x = xValue
	y = yValue
	
	if widthValue>0 then
		width = widthValue
	else
		print("width == " .. widthValue .. ". It should be greater the 0!")
		
	if heightValue>0 then
		height = heightValue
	else
		print("height == " .. heightValue .. ". It should be greater the 0!")
end

slide.getObjectsCount = function()
	return objectsCount
end

slide.insert = function(showingFunction, hidingFunction)
	if showingFunction == nil or hidingFunction == nil then
		print("One of the functions is not exist!")
	else
		showingFunctions[objectsCount + 1] = showingFunction
		hidingFunctions[objectsCount + 1] = hidingFunction
		objectsCount = objectsCount + 1
	end
end

return slide