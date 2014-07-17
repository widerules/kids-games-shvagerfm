local composer = require("composer")
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

local function createPopupWithHomeButton ( homeSceneToGo )

    popupBg = display.newImage( "images/popup/popup_bg.png", constants.CENTERX, constants.CENTERY );
    popupBg.height = 0.7*constants.H;
    popupBg.width = 0.7*constants.W;

    local function onHomeButtonClicked ()
        destroyPopup()
        composer.gotoScene(homeSceneToGo, "slideRight", 500)
    end

    homeBtn = widget.newButton
        {
            width = 0.4*popupBg.height,
            height = 0.4*popupBg.height,
            x = popupBg.x - 0.4*popupBg.width/2,
            y = popupBg.y + 0.4*popupBg.height/2,
            defaultFile = "images/popup/home_a.png",
            overFile = "images/popup/home_n.png",
            onRelease = onHomeButtonClicked
        }

end

popup.showPopUpWithNextButton = function (homeSceneToGo)

    local function addNextButtonToPopup ()

        local function onNextButtonClicked()
            destroyPopup()
            local currentScene = composer.getSceneName("current")
            composer.gotoScene(currentScene)
        end

        nextBtn = widget.newButton
            {
                width = 0.4*popupBg.height,
                height = 0.4*popupBg.height,
                x = popupBg.x + 0.4*popupBg.width/2,
                y = popupBg.y + 0.4*popupBg.height/2,
                defaultFile = "images/popup/next_a.png",
                overFile = "images/popup/next_n.png",
                onRelease = onNextButtonClicked
            }

    end

    createPopupWithHomeButton (homeSceneToGo)
    addNextButtonToPopup()

end

popup.showPopUpWithReloadButton = function (homeSceneToGo)

    local function addReloadButtonToPopup ()

        local function onReloadButtonClicked()
            destroyPopup()
            local currentScene = composer.getSceneName("current")
            composer.gotoScene(currentScene)
        end

        reloadBtn = widget.newButton
            {
                width = 0.4*popupBg.height,
                height = 0.4*popupBg.height,
                x = popupBg.x + 0.4*popupBg.width/2,
                y = popupBg.y + 0.4*popupBg.height/2,
                defaultFile = "images/popup/next_a.png",
                overFile = "images/popup/next_n.png",
                onRelease = onReloadButtonClicked
            }

    end

    createPopupWithHomeButton (homeSceneToGo)
    addReloadButtonToPopup()

end

popup.show = function(sceneToGo)

    local function addNextButtonToPopup ()

        local function onNextButtonClicked()
            destroyPopup()
            local currentScene = composer.getSceneName("current")
            composer.gotoScene(currentScene)
        end

        nextBtn = widget.newButton
            {
                width = 0.4*popupBg.height,
                height = 0.4*popupBg.height,
                x = popupBg.x + 0.4*popupBg.width/2,
                y = popupBg.y + 0.4*popupBg.height/2,
                defaultFile = "images/popup/next_a.png",
                overFile = "images/popup/next_n.png",
                onRelease = onNextButtonClicked
            }

    end

    if (sceneToGo == nil) then
        sceneToGo = "scenes.scenetemplate"
    end

    createPopupWithHomeButton (sceneToGo)
    addNextButtonToPopup()
end

popup.hide = function()
    destroyPopup()
end

return popup