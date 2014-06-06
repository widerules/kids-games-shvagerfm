local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )
local scene = storyboard.newScene()

local _GAMEAMOUNT = 6
local _BTNSIZE = 0.07 * constants.W;

local gamePath = "scenes.game"

local resPath = "images/game"
local namePath = "/title"
local imagePath = "/titlepic"

local format = ".png"

local swypeGroup
local background, title, titlePic, complexity
local btnPlay, leftArrow, rightArrow

local game = {}

local function onHomeButtonClicked( event )
	storyboard.gotoScene("scenetemplate")

end;

local function onGamesTap(event)
	storyboard.gotoScene(gamePath..event.target.name, "slideLeft", 400)

end

function scene:createScene(event)
	local group = self.view

	background = display.newImage("images/background1.jpg", constants.CENTERX, constants.CENTERY)
	group:insert(background)


end

function scene:enterScene (event)
	local group = self.view
		local gameWidth = constants.W/4
		local gameHeight = 5*gameWidth/6
		for i=1, 6 do
			game[i] = display.newImage( "images/game"..i.."/titlepic.png", i*constants.CENTERX/2 , constants.CENTERY/2 )
			game[i].name = i
			game[i].width = gameWidth
			game[i].height = gameHeight
			if i < 4 then
				game[i].y = constants.CENTERY/2 
				game[i].x = i*constants.CENTERX/2
			else
				game[i].y = 3*constants.CENTERY/2 
				game[i].x = (i-3)*constants.CENTERX/2
			end
			game[i]:addEventListener("tap", onGamesTap )
			group:insert(game[i])
			i= i+1

		end
	homeButton = widget.newButton 
	{
		height = _BTNSIZE,
        width = _BTNSIZE,
        left = 0,
		top = 0,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png",
		width = _BTNSIZE,
		height = _BTNSIZE,
        onRelease = onHomeButtonClicked
	}
	--homeButton:addEventListener("tap", onHomeButtonClicked);
	group:insert (homeButton);	
		
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