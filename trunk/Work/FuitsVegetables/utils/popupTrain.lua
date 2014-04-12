local storyboard = require("storyboard")
local widget = require("widget")
local constants = require("constants")

local popup = {}

local _FONTSIZE = constants.H / 15

local popupText, popupBg, reloadBtn, homeBtn --pop-up variables

--next round of the game
local function onReloadButtonClicked()
	storyboard.reloadScene( )
end

--------------closes current scene and goes to home screen
--message - text to show
--sceneToGo - name of the home scene
--sceneToClose - name of current scene
popup.showPopUp = function (message, sceneToGo, sceneToClose)

	local function onHomeButtonClicked () 
		storyboard.gotoScene(sceneToGo, "slideRight", 800)
    	storyboard.removeScene(sceneToClose)
	end
    
    popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
    popupBg.height = 0.7*constants.H;
    popupBg.width = 0.7*constants.W;

    popupText = display.newText(message, popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
    popupText.y = popupBg.y-popupBg.height/2+2*popupText.height/3;

    homeBtn = widget.newButton
    {
    	width = 0.4*popupBg.height,
        height = 0.4*popupBg.height,
        x = popupBg.x - 0.4*popupBg.width/2,
        y = popupBg.y + 0.4*popupBg.height/2,
        defaultFile = "images/home.png",
        overFile = "images/homehover.png",
        onRelease = onHomeButtonClicked
    }

    reloadBtn = widget.newButton
    {
        width = 0.4*popupBg.height,
        height = 0.4*popupBg.height,
        x = popupBg.x + 0.4*popupBg.width/2,
        y = popupBg.y + 0.4*popupBg.height/2,
        defaultFile = "images/reload.png",
        overFile = "images/reloadhover.png",
        onRelease = onReloadButtonClicked
    }       
end

popup.hidePopUp = function ()
	if popupBg ~= nil then
		popupBg:removeSelf( )
		popupText:removeSelf( )
		reloadBtn:removeSelf()
		homeBtn:removeSelf( )
		popupBg = nil
	end
end


return popup