local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")

local scene = storyboard.newScene()
local bg

local width = 0.3*constants.W
local count = constants.W/6
local gameTitles = {
    colors = "com.shvagerfm.colorsgame",
    shapes = "com.shvagerfm.formsgame",
    fruits = "com.shvagerfm.fruitsgame"
}
local gameImages = {}

local gotoGame = function(event)
    local id = gameTitles[event.target.game]
    print("id: ", id)
    if (id) then
        system.openURL( "market://details?id=" .. id )
    end
end

local addTitle = function(game)
    local image = display.newImage("images/titles/" .. game .. ".png", count, constants.CENTERY)
    image.game = game
    image.width = width
    --image.height = width
    count = count + constants.W/3
    image:addEventListener("tap", gotoGame)
    return image
end

function scene:createScene(event)
    local group = self.view
    bg = display.newRect(constants.CENTERX, constants.CENTERY, constants.W, constants.H)
    bg:setFillColor(0.38, 0.77, 0.92)
    group:insert(bg)
    
    gameImages.colors = addTitle('colors')
    gameImages.shapes = addTitle('shapes')
    gameImages.fruits = addTitle('fruits')
    
    group:insert(gameImages.colors)
    group:insert(gameImages.shapes)
    group:insert(gameImages.fruits)
    
end

function scene:enterScene (event)
    local group = self.view
end


function scene:exitScene(event)
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene