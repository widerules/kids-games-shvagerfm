local memoryViewer = require ("memoryViewer")
local data = require("data")

shouldWork = true

memoryViewer.create(display.contentCenterX, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

showingFunctionArray = {}
showingFunctionArray[1] = data.showLabel;
showingFunctionArray[2] = data.showLongLabel;
showingFunctionArray[3] = data.showImage;

hidingFunctionArray = {}
hidingFunctionArray[1] = data.hideLabel;
hidingFunctionArray[2] = data.hideLongLabel;
hidingFunctionArray[3] = data.hideImage;

local function invokeFunction( functionForInvoking )
	functionForInvoking()
end

local i = 1
for i = 1, #showingFunctionArray do
	invokeFunction(showingFunctionArray[i])
	invokeFunction(hidingFunctionArray[i])
end
