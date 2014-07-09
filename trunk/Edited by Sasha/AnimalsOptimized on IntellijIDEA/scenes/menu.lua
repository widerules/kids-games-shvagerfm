local storyboard = require ("storyboard")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )
local scene = storyboard.newScene()

local _GAMEAMOUNT = 7
local _BTNSIZE = 0.07 * constants.W;

local gamePath = "scenes.game"

local resPath = "images/game"
local namePath = "/title"
local imagePath = "/titlepic"

local format = ".png"

local background, title, titlePic, complexity
local btnPlay
local homeButton

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
	background.width = constants.W
	background.height = constants.H
	group:insert(background)
			admob.init()

end

function scene:enterScene (event)
	admob.showAd( "interstitial" )
	local group = self.view	

		local inRow = math.floor(_GAMEAMOUNT/2)	
		local gameWidth, gameHeight
		local vGap, hGap1, hGap2
		
		if _GAMEAMOUNT % 2 == 0 then
			gameWidth = constants.W/(inRow+1)
			hGap2 = (constants.W-inRow*gameWidth)/(inRow+1)
		else
			gameWidth = constants.W/(inRow+2)
			hGap2 = (constants.W - (inRow+1)*gameWidth)/(inRow+2)
		end 
		hGap1 = (constants.W-inRow*gameWidth)/(inRow+1)

		gameHeight = 5*gameWidth/6
		vGap = (constants.H - 2*gameHeight)/3
	
		for i=1, _GAMEAMOUNT do			
			if i <= _GAMEAMOUNT/2 then
				game[i] = display.newImage( "images/game"..i.."/titlepic.png", (i-0.5)*gameWidth+hGap1*i , 0.5*gameHeight + vGap)				
			else
				game[i] = display.newImage( "images/game"..i.."/titlepic.png", (i-0.5-inRow)*gameWidth+hGap2*(i-inRow) , 1.5*gameHeight + vGap*2)				
			end
			game[i].name = i
			game[i].width = gameWidth
			game[i].height = gameHeight
			game[i]:addEventListener("tap", onGamesTap )

			group:insert(game[i])			
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
	group:insert (homeButton);	
		
end


function scene:exitScene(event)
    local group = self.view

    for i = 1, _GAMEAMOUNT do
        display.remove(game[i])
        game[i] = nil
    end

    group:remove(homeButton)
    homeButton = nil
end

function scene:destroyScene(event)
    display.remove(background)
    background = nil
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene