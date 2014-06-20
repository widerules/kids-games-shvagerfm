local composer = require ("composer")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )
local Location = require ("data.location")

local scene = composer.newScene()

--local index = 1

local activeLocation, leftLocation, rightLocation

local activeLocButton, leftLocButton, rightLocButton

local background

--local progressBar
local backButton
--local leftButton, rightButton

function scene:create(event)
    local group = self.view

    --[[background = display.newImage("images/start_bg.jpg", constants.W, constants.H)
    background.x = constants.CENTERX
    background.y = constants.CENTERY]]

    --[[leftButton = widget.newButton{
        width = constants.W*0.15,
        height = constants.W*0.15,
        x = constants.CENTERX,
        y = constants.CENTERY,
        defaultFile = nil,          --добавить путь к кнопкам
        overFile = nil,
        onRelease = function()
            index = index - 1
            local currScene = composer.getSceneName("current")
            composer.gotoScene(currScene)
        end
    }
    leftButton.x = leftButton.width*0.5]]

    --[[rightButton = widget.newButton{
        width = constants.W*0.15,
        height = constants.W*0.15,
        x = constants.CENTERX,
        y = constants.CENTERY,
        defaultFile = nil,          --добавить путь к кнопкам
        overFile = nil,
        onRelease = function()
            index = index + 1
            local currScene = composer.getSceneName("current")
            composer.gotoScene(currScene)
        end
    }
    rightButton.x = constants.W - rightButton.width*0.5]]

    backButton = widget.newButton{
        width = constants.W*0.17,
        height = constants.W*0.13,
        x = constants.CENTERX,
        y = constants.CENTERY,
        defaultFile = "images/settings_a.png",
        overFile = "images/settings_n.png",
        onRelease = function ()
            composer.gotoScene("scenes.scenetemplate")
        end
    }
    backButton.x = backButton.width*0.5
    backButton.y = backButton.height*0.5

    --group:insert(background)
    --group:insert(leftButton)
    --group:insert(rightButton)
    group:insert(backButton)

end

function scene:show(event)
    local group = self.view
    if(event.phase == "will") then

        activeLocation = Location:new({name = "Forest", txt = "sd", image = display.newImage("images/forest.png"), progress = 0, status = "opened", map = nil})

        activeLocation.image.width = constants.W*0.27
        activeLocation.image.height = constants.W*0.3
        activeLocation.image.x = constants.CENTERX
        activeLocation.image.y = constants.CENTERY

        leftLocation = Location:new({name = "City", txt = "sd", image = display.newImage("images/city.png"), progress = 0, status = "closed", map = nil})

        leftLocation.image.width = constants.W*0.2
        leftLocation.image.height = constants.W*0.22
        leftLocation.image.x = constants.CENTERX*0.5
        leftLocation.image.y = constants.CENTERY

        rightLocation = Location:new({name = "Farm", txt = "sd", image = display.newImage("images/farm.png"), progress = 0, status = "closed", map = nil})

        rightLocation.image.width = constants.W*0.2
        rightLocation.image.height = constants.W*0.22
        rightLocation.image.x = constants.CENTERX*1.5
        rightLocation.image.y = constants.CENTERY

        activeLocButton = widget.newButton{
            width = activeLocation.image.width,
            height = activeLocation.image.height,
            x = activeLocation.image.x,
            y = activeLocation.image.y,
            isEnabled = (activeLocation.status == "opened"),
            onRelease = function ()
                print ("center loc pressed")
                --composer.gotoScene("location") --добавить путь
            end
        }

        rightLocButton = widget.newButton{
            width = rightLocation.image.width,
            height = rightLocation.image.height,
            x = rightLocation.image.x,
            y = rightLocation.image.y,
            isEnabled = (rightLocation.status == "opened"),
            onRelease = function ()
                print ("right loc pressed")
            --composer.gotoScene("location") --добавить путь
            end
        }

        leftLocButton = widget.newButton{
            width = leftLocation.image.width,
            height = leftLocation.image.height,
            x = leftLocation.image.x,
            y = leftLocation.image.y,
            isEnabled = (leftLocation.status == "opened"),
            onRelease = function ()
                print ("left loc pressed")
            --composer.gotoScene("location") --добавить путь
            end
        }


        --locName = display.newText(activeLocation.name, constants.CENTERX, constants.CENTERY*0.6)
        --progressBar = display.newText(activeLocation.progress, constants.CENTERX, constants.CENTERY*1.5)

        group:insert(leftLocButton)
        group:insert(rightLocButton)
        group:insert(activeLocButton)
        group:insert(activeLocation.image)
        group:insert(leftLocation.image)
        group:insert(rightLocation.image)

    elseif (event.phase == "did") then

    end

end

function scene:hide(event)
    local group = self.view
    if(event.phase == "will") then

    elseif(event.phase == "did") then
        --display.remove(locName)
        --display.remove(progressBar)

        group:remove(activeLocButton)
        group:remove(rightLocButton)
        group:remove(leftLocButton)
        --group:remove(progressBar)
        --group:remove(locName)
        group:remove(activeLocation.image)
        group:remove(leftLocation.image)
        group:remove(rightLocation.image)

        activeLocButton = nil
        rightLocButton = nil
        leftLocButton = nil
        --progressBar = nil
        --locName = nil
        activeLocation = nil
        leftLocation = nil
        rightLocation = nil

    end
end

function scene:destroy(event)
    local group = self.view

    --display.remove(leftButton)
    --display.remove(rightButton)
    --display.remove(backButton)
    --display.remove(background)

    --group:remove(leftButton)
    --group:remove(rightButton)
    group:remove(backButton)
    --group:remove(background)

    -- = nil
    --rightButton = nil
    backButton = nil
    background = nil

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene