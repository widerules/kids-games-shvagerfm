local storyboard = require("storyboard")
local rate = require( "utils.rate" )
local memoryViewer = require ("utils.memoryViewer")
local constants = require( "constants" )

require "sqlite3"
local path = system.pathForFile( "coords.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

shouldWork = true

memoryViewer.create(constants.W/2, 20, shouldWork)
memoryViewer.updateInfoInLoop(100)

storyboard.purgeOnSceneChange = true

_LOCATION = 1
_LEVELS = {1, 1, 1 }

local createTable = [[CREATE TABLE coordinates (id INTEGER PRIMARY KEY, x, y, z);]]
db:exec(createTable)

for i = 1, 5 do
    local addPointCoordinates = [[INSERT INTO coordinates VALUES (NULL, ']].. i.. [[',']].. i.. [[',']].. i.. [['); ]]
    db:exec(addPointCoordinates)
end


print( "version " .. sqlite3.version() )

for row in db:nrows("SELECT * FROM coordinates") do
    local rowText = row.x .. " " .. row.y .. " " .. row.z
    local t = display.newText(rowText, 20, 30 * row.id, null, 16)
    print(rowText)
    t:setFillColor( 1, 0, 1 )
end

db:close()

local function exit ()
    rate.init()
end
local function onKeyEvent( event )

    local phase = event.phase
    local keyName = event.keyName

    if ( ("back" == keyName or "deleteBack" == keyName) and phase == "up" ) then
        local currentScene = storyboard.getCurrentSceneName()
        local lastScene = storyboard.getPrevious()

        if ( currentScene == "scenetemplate") then
            exit()

        elseif (currentScene == "scenes.locationMap") then

            local options =
            {
                effect = "slideRight",
                time = 500
            }
            transition.cancel( )
            storyboard.gotoScene( "scenetemplate", options )
            storyboard.removeAll( )
        else
            timer.performWithDelay(300, function()
                local options =
                {
                    effect = "slideRight",
                    time = 500
                }
                transition.cancel( )
                storyboard.gotoScene( lastScene, options )
                storyboard.removeAll( )
            end)

        end
    end
    if ( keyName == "volumeUp" and phase == "down" ) then
        local masterVolume = audio.getVolume()

        if ( masterVolume < 1.0 ) then
            masterVolume = masterVolume + 0.1
            audio.setVolume( masterVolume )
        end
        return false
    elseif ( keyName == "volumeDown" and phase == "down" ) then
        local masterVolume = audio.getVolume()

        if ( masterVolume > 0.0 ) then
            masterVolume = masterVolume - 0.1
            audio.setVolume( masterVolume )
        end
        return false
    end
    return true  --SEE NOTE BELOW
end
Runtime:addEventListener( "key", onKeyEvent )


storyboard.gotoScene("scenetemplate")