local composer = require ("composer")
local widget = require("widget")
local constants = require("constants")

local scene = composer.newScene()

local bg

local titleWidth = 0.28 * constants.W
local titleHeight = 1.75 * titleWidth
local startPictureX, startPictureY

local pictureWidth, pictureHeight
local currentX, currentY

local gameTitles = {
    colors = "com.shvagerfm.ColorsForKids",
    animals = "com.shvagerfm.AnimalsForKids",
    fruits = "com.shvagerfm.FuitsVegetables",
    puzzles = "com.shvagerfm.samspuzzlesfree"
}
local gameImages = {}

local function exit ()
    composer.gotoScene("scenes.scenetemplate", "slideRight", 400)
end

local gotoGame = function(event)
    local id = gameTitles[event.target.game]
    print(id)
    if (id) then
        system.openURL( "market://details?id=" .. id )
    end
end

local addTitle = function(game)
    local image = display.newImage("images/titles/" .. game .. ".png", count, constants.CENTERY)
    image.game = game
    image.width = pictureWidth
    image.height = pictureHeight
    image.x = currentX
    image.y = currentY

    if (currentX < constants.CENTERX) then
        currentX = currentX + pictureWidth + pictureWidth * 0.2
    else
        currentX = startPictureX
        currentY = currentY + pictureHeight + pictureHeight * 0.07
    end

    image:addEventListener("tap", gotoGame)
    return image
end

function scene:create(event)
    local group = self.view

    bg = display.newImage("images/bg".. math.random(1, 6) .. ".jpg", constants.CENTERX, constants.CENTERY)
    bg.width = constants.W
    bg.height = constants.H
    group:insert(bg)

    pictureHeight = bg.height * 0.4
    pictureWidth = pictureHeight

    startPictureX = constants.CENTERX - pictureWidth / 2
    startPictureY = bg.height * 0.1 + pictureHeight / 2

    currentX = startPictureX
    currentY = startPictureY

    gameImages.colors = addTitle('colors')
    gameImages.animals = addTitle('animals')
    gameImages.fruits = addTitle('fruits')
    gameImages.puzzles = addTitle('puzzles')
    
    group:insert(gameImages.colors)
    group:insert(gameImages.animals)
    group:insert(gameImages.fruits)
    group:insert(gameImages.puzzles)
    local exitBtn = widget.newButton
        {   
            width = 0.2*constants.H,
            height = 0.2*constants.H,
            defaultFile = "images/exit_a.png",
            overFile = "images/exit_n.png",
            id = "button_2",
            onRelease = exit,
            
        }
    exitBtn.x = constants.W * 0.92
    exitBtn.y = constants.H * 0.12
    group:insert(exitBtn)
end

function scene:show(event)
end

function scene:hide(event)
end

function scene:destroy(event)
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene