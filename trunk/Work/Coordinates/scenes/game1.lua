local storyboard = require ("storyboard")
local widget = require ("widget")
local constants = require ("constants")

local scene = storyboard.newScene()

local mainShape, background
local mainWidth, mainHeight
local xLabel, yLabel
local partsAmount = 5
local parts = {}
local secondParts = {}
local firstEnter = true

local function onReloadButtonClicked()
	storyboard.reloadScene()
end

local function onDrag (event)
	local t = event.target
	local phase = event.phase	

	if phase == "began" then
		local parent = t.parent
		parent:insert(t)
		display.getCurrentStage():setFocus(t)

		t.isFocus = true
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

	elseif phase == "moved" and t.isFocus then
		t.x = event.x - t.x0
		t.y = event.y - t.y0
	elseif phase == "ended" or phase == "cancel" then		
		display.getCurrentStage():setFocus(nil)
		t.isFocus = false	

		event.target.kx = event.target.x - mainShape.x
		event.target.kx = event.target.kx/constants.W
		event.target.ky = event.target.y - mainShape.y
		event.target.ky = event.target.ky/constants.H

		xLabel.text = "x: " .. event.target.kx
		yLabel.text = "y: " .. event.target.ky
	end
end

function scene:createScene(event)
	local group = self.view

	background = display.newImage( "images/background1.png", constants.CENTERX, constants.CENTERY, constants.W, constants.H)
	group:insert(background)

	xLabel = display.newEmbossedText( "x: 0", 0, 0, native.systemFont, constants.H / 16)
	xLabel.y = constants.H - 1.5*xLabel.height
	xLabel.x = constants.W - 0.5*xLabel.width
	group:insert (xLabel)

	yLabel = display.newEmbossedText( "y: 0", 0, 0, native.systemFont, constants.H / 16)
	yLabel.y = constants.H - 0.5*yLabel.height
	yLabel.x = constants.W - 0.5*yLabel.width
	group:insert(yLabel)

	mainShape = display.newImage("images/star.png", constants.CENTERX, constants.CENTERY)
	mainShape.baseWidth = mainShape.width
	mainShape.baseHeight = mainShape.height	
	mainShape.height = 0.5*constants.H
	mainShape.width = 0.5*constants.H
	group:insert(mainShape)

	reloadBtn = widget.newButton
    {
        width = constants.H/7,
        height = constants.H/7,
        x = constants.W - constants.W/14,
        y = constants.H/14,
        defaultFile = "images/reload.png",
        overFile = "images/reload.png",
        onRelease = onReloadButtonClicked
    }

    firstEnter = true
end

function scene:enterScene(event)
	local group = self.view	
	
	if firstEnter == true then
		local j = 1
		local k = 1

		for i = 1, 5 do
			parts[i] = display.newImage("images/parts/"..i..".gif", 0, 0)
			parts[i].kh = parts[i].height/mainShape.baseHeight
			parts[i].height = parts[i].kh*mainShape.height
			parts[i].kw = parts[i].width/mainShape.baseWidth
			parts[i].width = parts[i].kw*mainShape.width
			if k-0.5+parts[i].height/2 > constants.H then 
				k = 1
				j = j + 1
			end
			parts[i].x = (j-0.5) * parts[i].width
			parts[i].y = (k-0.5) * parts[i].height
			k = k + 1
			parts[i]:addEventListener("touch", onDrag)
			group:insert(parts[i])
		end	
	else
		for i = 1, 5 do
			secondParts[i] = display.newImage ("images/parts/" .. i .. ".gif", 0, 0)
			secondParts[i].height = parts[i].kh * mainShape.height
			secondParts[i].width = parts[i].kw * mainShape.width
			secondParts[i].x = mainShape.x + parts[i].kx*constants.W
			secondParts[i].y = mainShape.y + parts[i].ky*constants.H
			group:insert(secondParts[i])
		end
	end
end

function scene:exitScene(event)
	for i = 1, partsAmount do
		display.remove(parts[i])
	end

	firstEnter = false
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene