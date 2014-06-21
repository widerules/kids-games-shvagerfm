local database = require("database")
local composer = require("composer")

local storyboard = require( "storyboard" )
local widget = require( "widget" )
local scene = composer.newScene()
local widget = require("widget")

local DISPLAY_CENTER_X = display.contentCenterX
local DISPLAY_CENTER_Y = display.contentCenterY

local _CURRENT_LEVEL = 1

--local dirPath = "images/"
--local partsDirPath = dirPath.."parts/"
local puzzle
local puzzlePicture, puzzleShadow

local parts = {}
local partsPictures = {}

local partsOnPlaces = 0;

function scene:loadPuzzle()
    local puzzles = database.getLevelPuzzles(_CURRENT_LEVEL)
    puzzle = puzzles[1]
end

function scene:loadParts()
    parts = database.getPuzzleParts(puzzle.id)
end

function scene:removePuzzle()
    display.remove(puzzlePicture)
    puzzlePicture = nil
end

function scene:removeParts()
    for i = 1, #partsPictures do
        display.remove( partsPictures[i].image )
        partsPictures[i].image = nil
    end
end

function scene:showPuzzle()
    local group = self.view

    puzzlePicture = display.newImage( puzzle.picture .. ".png" )
    puzzlePicture.x = DISPLAY_CENTER_X + DISPLAY_CENTER_X/3
    puzzlePicture.y = DISPLAY_CENTER_Y

    group:insert(puzzlePicture)
end

function scene:showParts()
    local group = self.view

    for i = 1, #parts do

        local currentPart = {}

        currentPart.image = display.newImage( parts[i].picture .. ".png" )
        currentPart.image.x = math.random( DISPLAY_CENTER_X / 2 +1 ) + DISPLAY_CENTER_X / 6
        currentPart.image.y = math.random( DISPLAY_CENTER_Y ) + DISPLAY_CENTER_Y / 2
        currentPart.id = i

        function currentPart:touch( event )
            if event.phase == "began" then
                display.getCurrentStage():setFocus( self.image, event.id )
                self.markX = self.image.x
                self.markY = self.image.y
            elseif event.phase == "moved" then
                local x = (event.x - event.xStart) + self.markX
                local y = (event.y - event.yStart) + self.markY
                self.image.x, self.image.y = x, y
            elseif event.phase == "ended" or event.phase == "cancelled" then
                display.getCurrentStage():setFocus(nil)
                local currX = self.image.x
                local currY = self.image.y

                local delta = self.image.contentWidth * 0.2;
                if (math.abs(self.image.x - parts[self.id].x) <= delta and math.abs(self.image.y - parts[self.id].y) <= delta) then
                    self.image.x = parts[self.id].x
                    self.image.y = parts[self.id].y
                    self.image:removeEventListener("touch", currentPart)
                    partsOnPlaces = partsOnPlaces + 1;
                end

                if (partsOnPlaces == #parts)  then
                    print("done!")
                end
            end
            return true
        end

        currentPart.image:addEventListener("touch", currentPart)
        group:insert(currentPart.image)
        partsPictures[i] = currentPart
    end
end

function scene:create( event )
    self:loadPuzzle()
    self:loadParts()
end


function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    partsOnPlaces = 0

    if ( phase == "will" ) then
        self:showPuzzle()
    elseif ( phase == "did" ) then
        self:showParts()
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        self:removeParts()
    elseif ( phase == "did" ) then
        self:removeParts()
    end
end

function scene:destroy( event )

end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene