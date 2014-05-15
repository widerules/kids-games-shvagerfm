local storyboard = require("storyboard")
local widget = require("widget")
local constants = require("constants")

local popup = {}

local _FONTSIZE = constants.H / 15

local popupText, popupBg, nextBtn, reloadBtn, homeBtn

local function destroyPopup ()

    display.remove( popupBg )
    display.remove( popupText )
    display.remove( nextBtn )
    display.remove( reloadBtn )
    display.remove( homeBtn )

    popupBg = nil
    popupText = nil
    nextBtn = nil
    reloadBtn = nil
    homeBtn = nil

    popupBg = nil

end

local function createPopupWithHomeButton (message, homeSceneToGo, sceneToClose)
    
    popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
    popupBg.height = 0.7*constants.H;
    popupBg.width = 0.7*constants.W;

    popupText = display.newText(message, popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
    popupText.y = popupBg.y-popupBg.height/2+2*popupText.height/3;


    local function onHomeButtonClicked ()
        destroyPopup()
        storyboard.gotoScene(homeSceneToGo, "slideRight", 500)
        storyboard.removeScene(sceneToClose)
    end

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

end

popup.showPopupWithNextButton = function (message, homeSceneToGo, sceneToClose)

    local function addNextButtonToPopup ()

        local function onNextButtonClicked()
            destroyPopup()
            storyboard.reloadScene( )
        end

        nextBtn = widget.newButton
            {
                width = 0.4*popupBg.height,
                height = 0.4*popupBg.height,
                x = popupBg.x + 0.4*popupBg.width/2,
                y = popupBg.y + 0.4*popupBg.height/2,
                defaultFile = "images/next.png",
                overFile = "images/next.png",
                onRelease = onNextButtonClicked
            }

    end

    createPopupWithHomeButton (message, homeSceneToGo, sceneToClose)
    addNextButtonToPopup()

end

popup.showPopupWithReloadButton = function (message, homeSceneToGo, sceneToClose)

    local function addReloadButtonToPopup ()

        local function onReloadButtonClicked()
            destroyPopup()
            storyboard.reloadScene( )
        end

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

    createPopupWithHomeButton (message, homeSceneToGo, sceneToClose)
    addReloadButtonToPopup()

end

popup.hidePopup = function()
    destroyPopup()
end

return popup