local composer = require ("composer")
local widget = require("widget")
local constants = require("constants")
local admob = require( "utils.admob" )
local database = require("utils.database")

local scene = composer.newScene()

local location

local background

local buttons = {}

function scene:create(event)
    local group = self.view

    --[[
    if (event.params[1] == "forest") then
        location = 1
    elseif (event.params[1] == "city") then
        location = 2
    elseif (event.params[1] == "farm") then
        location = 3
    end]]

    --if (location == nil) then return end

    location = database.getLocation(event.params[1])

    if (location == nil) then return end

    background = display.newImage("images/"..location.pictures..".png", constants.CENTERX, constants.CENTERY, constants.W, constants.H)
    group:insert(background)

end

function scene:show(event)
    local group = self.view

    if(event.phase == "will") then
        --ссылка на БД
        local nButtons = location.levelsCount
        for i = 1, nButtons do
            buttons[i] = widget.newButton{
                defaultFile = "images/puzzles/puz_active_0"..i..".png",
                isEnabled = true,               --ссылка на БД
                label = i,
                fontSize = constants.W*0.05,
                labelColor = {default = {1, 1, 1}},
                onRelease = function()
                    print ("button #"..i.." was pressed")
                end
            }
            buttons[i].height = buttons[i].height*constants.W*0.16/buttons[i].width
            buttons[i].width = constants.W * 0.16    -- исключительно для <= 8 кнопок
            buttons[i].x = (i<5) and constants.W*0.22*i or constants.W*0.22*(i%4)--(i<5) and constants.W*0.25*i-buttons[i].width/2 or constants.W*0.25*(i%4)-buttons[i].width/2
            buttons[i].y = (i<5) and constants.H*0.3 or constants.CENTERY+constants.H*0.25

            group:insert(buttons[i])
        end
    elseif(event.phase == "did") then
    end

end

function scene:hide(event)
    local group = self.view

    if(event.phase == "will") then
    elseif (event.phase == "did") then
        for i = 1, #buttons do
            group:remove(buttons[i])
        end
    end

end

function scene:destroy(event)
    local group = self.view
    group:remove(background)
    background = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene