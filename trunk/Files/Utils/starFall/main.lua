-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local physics = require("physics")
physics.start()
-- Your code here
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

explosionTable        = {}                    -- Define a Table to hold the Spawns
i                    = 0                        -- Explosion counter in table
explosionTime        = 466.6667                    -- Time defined from EXP Gen 3 tool
resources            = "_resources"  
--------------------------------------------------
-- Create and assign a new Image Sheet using the
-- Coordinates file and packed texture.
--------------------------------------------------
local explosionSheetInfo    = require(resources..".".."Explosion")
local explosionSheet        = graphics.newImageSheet( resources.."/".."Explosion.png", explosionSheetInfo:getSheet() )

local animationSequenceData = {
  { name = "dbiExplosion",
      frames={
          1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
      },
      time=explosionTime, loopCount=1
  },
}

function spawnExplosionToTable(spawnX, spawnY)
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
    
    --Add a timer to the Spawned Explosion.
    --Explosion are destroyed after all the frames have been played after a determined
    --amount of time as setup by the Explosion Generator Tool.
    local destroySpawneExplosion = timer.performWithDelay (explosionTime, removeExplosionSpawn(explosionTable[i]))
end

local function destroyStar(event)
	spawnExplosionToTable(event.x,event.y)
	display.remove( event.target )
end

timer.performWithDelay( 100, function()
	local coord = _W*math.random()
	local coord2 = _W*math.random() + math.random( 1, 10)
	local coord3 = _W*math.random() + math.random( 1, 100)
	local star = display.newImage("star.png", 0, 0, _H/10, _H/10)
	star.x = coord
	star:addEventListener( "touch", destroyStar )
	physics.addBody( star, {density=3, friction=0.5, bounce=0} )
	local star2 = display.newImage("star2.png", 0, 0, _H/10, _H/10)
	star2.x = coord2
	star2:addEventListener( "touch", destroyStar )
	physics.addBody( star2, {density=1, friction=0.5, bounce=0} )
	local star3 = display.newImage("star3.png", 0, 0, _H/10, _H/10)
	star3.x = coord3
	star3:addEventListener( "touch", destroyStar )
	physics.addBody( star3, {density=1, friction=0.5, bounce=0} )
end, 100 )

