local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = storyboard.newScene()
local widget = require("widget")

local DISPLAY_CENTER_X = display.contentCenterX
local DISPLAY_CENTER_Y = display.contentCenterY

local dirPath = "images/"
local partsDirPath = dirPath.."parts/"
local examplePath = dirPath.."example.png"

local example
local parts = {}

local saveButton, upButton, downButton, leftButton, rightButton
local infoTextBox

local currentPart = nil

local leftCornerX = 0
local leftCornerY = 0

local function fileExists(name)
    return os.rename(name, name)
end

function scene:addImageControls()
    local group = self.view

    local dx = 1
    local dy = 1

    leftButton = widget.newButton {
        x = saveButton.x + saveButton.width/2 + 40,
        y = 50,
        defaultFile = "images/left.png",
        overFile = "images/left.png",
        onRelease = function()
            if (currentPart ~= nil) then
                currentPart.image.x = currentPart.image.x - dx

                local info = "x: " .. currentPart.image.x - leftCornerX .. "; y: "..currentPart.image.y - leftCornerY
                currentPart.image:removeEventListener("touch", part) -- TODO: make it working

                infoTextBox.text = info
            end
        end
    }
    group:insert(leftButton)

    upButton = widget.newButton {
        x = leftButton.x + leftButton.width/2 + 20,
        y = leftButton.y - 20,
        defaultFile = "images/up.png",
        overFile = "images/up.png",
        onRelease = function()
            if (currentPart ~= nil) then
                currentPart.image.y = currentPart.image.y - dy

                local info = "x: " .. currentPart.image.x - leftCornerX .. "; y: "..currentPart.image.y - leftCornerY
                currentPart.image:removeEventListener("touch", part) -- TODO: make it working

                infoTextBox.text = info
            end
        end
    }
    group:insert(upButton)

    downButton = widget.newButton {
        x = leftButton.x + leftButton.width/2 + 20,
        y = leftButton.y + 20,
        defaultFile = "images/down.png",
        overFile = "images/down.png",
        onRelease = function()
            if (currentPart ~= nil) then
                currentPart.image.y = currentPart.image.y + dy

                local info = "x: " .. currentPart.image.x - leftCornerX .. "; y: "..currentPart.image.y - leftCornerY
                currentPart.image:removeEventListener("touch", part) -- TODO: make it working

                infoTextBox.text = info
            end
        end
    }
    group:insert(downButton)

    rightButton = widget.newButton {
        x = upButton.x + upButton.width/2 + 20,
        y = 50,
        defaultFile = "images/right.png",
        overFile = "images/right.png",
        onRelease = function()
            if (currentPart ~= nil) then
                currentPart.image.x = currentPart.image.x + dx

                local info = "x: " .. currentPart.image.x - leftCornerX .. "; y: "..currentPart.image.y - leftCornerY
                currentPart.image:removeEventListener("touch", part) -- TODO: make it working

                infoTextBox.text = info
            end
        end
    }
    group:insert(rightButton)
end

function scene:addInfoTextBox()
    local group = self.view
    local fontSize = 24

    infoTextBox = display.newText( "0", DISPLAY_CENTER_X - DISPLAY_CENTER_X/2,  50, native.systemFont, fontSize)
    group:insert(infoTextBox)
end

function scene:addSaveButton()
    local group = self.view

    saveButton = widget.newButton
        {
            x = DISPLAY_CENTER_X + DISPLAY_CENTER_X/3,
            y = 50,
            width = 200,
            height = 100,
            defaultFile = "images/btn.png",
            overFile = "images/btn.png",
            fontSize = 20,
            label = "Save coordinates",
            onRelease = function()
                if (currentPart ~= nil) then
                    local info = "["..currentPart.name.."] x: " .. currentPart.image.x - leftCornerX .. "; y: "..currentPart.image.y - leftCornerY
                    currentPart.image:removeEventListener("touch", part) -- TODO: make it working

                    infoTextBox.text = info
                    print(info)
                end
            end
        }
    group:insert(saveButton)
end

function scene:loadExample()
    local group = self.view

    example = display.newImage( examplePath )
    example.x = DISPLAY_CENTER_X + DISPLAY_CENTER_X/3
    example.y = DISPLAY_CENTER_Y
    group:insert(example)

    leftCornerX = example.x - example.width/2
    leftCornerY = example.y - example.height/2
end

function scene:loadAllParts()
    local group = self.view

    local fileFormats = {".png", ".jpg"}

    local i = 1
    while (true) do

        local fileFound = false

        for j = 1, #fileFormats do
            local currentFile = partsDirPath..i..fileFormats[j]
            local part = { image, name }
            part.image =  display.newImage(currentFile)
            part.name = currentFile

            if part.image ~= nil then
                part.image.x = math.random( DISPLAY_CENTER_X / 2 +1 ) + DISPLAY_CENTER_X / 6
                part.image.y = math.random( DISPLAY_CENTER_Y ) + DISPLAY_CENTER_Y / 2

                function part:touch( event )
                    if event.phase == "began" then

                        display.getCurrentStage():setFocus( self.image, event.id )

                        self.markX = self.image.x
                        self.markY = self.image.y

                    elseif event.phase == "moved" then

                        local x = (event.x - event.xStart) + self.markX
                        local y = (event.y - event.yStart) + self.markY

                        self.image.x, self.image.y = x, y

                        local info = "x: " .. x - leftCornerX .. "; y: "..y - leftCornerY
                        infoTextBox.text = info

                    elseif event.phase == "ended" or event.phase == "cancelled" then

                        display.getCurrentStage():setFocus(nil)
                        local currX = self.image.x
                        local currY = self.image.y

                        currentPart = self

                    end

                    return true
                end

                part.image:addEventListener("touch", part)
                group:insert(part.image)
                parts[i] = part
                fileFound = true
                break
            end


        end

        if fileFound == false then
            return
        else
            i = i + 1
        end

    end
end

function scene:createScene( event )
    self:addInfoTextBox()
    self:addSaveButton()
    self:addImageControls()
    self:loadExample()
end


function scene:enterScene( event )


    self:loadAllParts()
end

function scene:exitScene( event )
end

function scene:destroyScene( event )
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene