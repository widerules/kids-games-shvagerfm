local explosion = {}

local explosionTable        = {}                    -- Define a Table to hold the Spawns
local i                    = 0                        -- Explosion counter in table
local explosionTime        = 416.6667                    -- Time defined from EXP Gen 3 tool
local resources            = "data"            -- Path to external resource files
local explosionImageFolder = "images/explosion"

local explosionSheetInfo    = require(resources..".".."explosionData")
local explosionSheet        = graphics.newImageSheet( explosionImageFolder.."/".."Explosion.png", explosionSheetInfo:getSheet() )

local animationSequenceData = {
  { name = "dbiExplosion",
      frames={
          1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
      },
      time=explosionTime, loopCount=1
  },
}

explosion.spawnExplosion = function (spawnX, spawnY)
    i = i + 1                                        -- Increment the spawn counter
    
    explosionTable[i] = display.newSprite( explosionSheet, animationSequenceData )
    explosionTable[i]:setSequence( "dbiExplosion" )    -- assign the Animation to play
    explosionTable[i].x=spawnX                        -- Set the X position (touch X)
    explosionTable[i].y=spawnY                        -- Set the Y position (touch Y)
    explosionTable[i]:play()                        -- Start the Animation playing
    explosionTable[i].xScale = 1                    -- X Scale the Explosion if required
    explosionTable[i].yScale = 1                    -- Y Scale the Explosion if required
    
    --Create a function to remove the Explosion - triggered from the DelatedTimer..
    local function removeExplosionSpawn( object )
        return function()
            object:removeSelf()    -- remove the explosion from table
            object = nil
        end
    end

    local destroySpawneExplosion = timer.performWithDelay (explosionTime, removeExplosionSpawn(explosionTable[i]))
end

return explosion