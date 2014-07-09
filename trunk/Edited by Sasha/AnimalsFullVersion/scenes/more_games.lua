local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")

local scene = storyboard.newScene()
local bg

local titleWidth = 0.28 * constants.W
local titleHeight = 7 * titleWidth / 4
local count = 0.2 * constants.W

local gameTitles = {
    colors = "com.shvagerfm.ColorsForKids",
    shapes = "com.shvagerfm.formsgame",
    fruits = "com.shvagerfm.FuitsVegetables"
}
local gameImages = {}

local function exit ()
    storyboard.gotoScene("scenetemplate", "slideRight", 400)
end

local gotoGame = function(event)
    local id = gameTitles[event.target.game]
   
    if (id) then
        system.openURL( "market://details?id=" .. id )
    end
end

local addTitle = function(game)
    local image = display.newImage("images/titles/" .. game .. ".png", count, constants.CENTERY)
    image.game = game
    image.width = titleWidth
    image.height = titleHeight
    count = count + titleWidth
    image:addEventListener("tap", gotoGame)
	
    return image
end

function scene:createScene(event)
    local group = self.view
    bg = display.newImage("images/titles/moregamesbg.png", constants.CENTERX, constants.CENTERY, constants.W, constants.H)
    bg.width = constants.W
    bg.height = constants.H
    
    group:insert(bg)
    
    gameImages.colors = addTitle('colors')
    gameImages.shapes = addTitle('shapes')
    gameImages.fruits = addTitle('fruits')
    
    group:insert(gameImages.colors)
    group:insert(gameImages.shapes)
    group:insert(gameImages.fruits)
    local exitBtn = widget.newButton
        {   
            width = constants.H/8,
            height = constants.H/8,
            top = 0,
            defaultFile = "images/exit.png",
            overFile = "images/exit.png",
            id = "button_2",
            onRelease = exit,
        }
		
    exitBtn.x = constants.W - exitBtn.width/2
    group:insert(exitBtn)

    count = 0.2 * constants.W
end

function scene:enterScene (event)
    local group = self.view
end


function scene:exitScene(event)
    display:remove( bg )

    bg = nil
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene