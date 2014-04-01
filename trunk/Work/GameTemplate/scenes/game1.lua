require "sqlite3"
local path = system.pathForFile( "colorskids.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

local storyboard = require("storyboard")
local widget = require("widget")
local constants = require ("constants")
local data = require ("studyData")

local scene = storyboard.newScene()

local _CIRCLESSIZE = constants.H/6
local _FONTSIZE = constants.H / 5;


local currentColor

local circles = {}
local butterfly
local colorName
local colorSound

local background, pallete, canvas

local total, totalScore
local counter = 0


---------------------------------------------
--explosion
--------------------------------------------------
explosionTable        = {}                    -- Define a Table to hold the Spawns
i                    = 0                        -- Explosion counter in table
explosionTime        = 416.6667                    -- Time defined from EXP Gen 3 tool
_w                     = display.contentWidth    -- Get the devices Width
_h                     = display.contentHeight    -- Get the devices Height
resources            = "_resources"            -- Path to external resource files

local explosionSheetInfo    = require(resources..".".."Explosion")
local explosionSheet        = graphics.newImageSheet( resources.."/".."Explosion.png", explosionSheetInfo:getSheet() )

--------------------------------------------------
-- Define the animation sequence for the Explosion
-- from the Sprite sheet data
-- Change the sequence below to create IMPLOSIONS 
-- and EXPLOSIONS etc...
--------------------------------------------------
local animationSequenceData = {
  { name = "dbiExplosion",
      frames={
          1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
      },
      time=explosionTime, loopCount=1
  },
}

local function spawnExplosionToTable(spawnX, spawnY)
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
----------------------------------

local function checkTotal()
   local function dbCheck()
      local sql = [[SELECT value FROM statistic WHERE name='total';]]
      for row in db:nrows(sql) do
         return row.value
      end
   end
   total = dbCheck()
   if total == nil then
      local insertTotal = [[INSERT INTO statistic VALUES (NULL, 'total', '0'); ]]
      db:exec( insertTotal )
      print("total inserted to 0")
      total = 0
   else
      print("Total is "..total)
   end
end
local function updateScore()
	total = total + 5
	local tablesetup = [[UPDATE statistic SET value = ']]..total..[[' WHERE name = 'total']]
	db:exec(tablesetup)
	totalScore.text = "Score: "..total
end

local function onCircleClicked (event)
	for i = 1, 7, 1 do
		if circles[i] == event.target then
			currentColor = i
		end
	end
	counter = counter + 1
	storyboard.reloadScene()
end

function scene:createScene(event)
	local group = self.view
	checkTotal()
	background = display.newImage("images/background1.png", constants.CENTERX, constants.CENTERY)
	background.width = constants.W
	background.height = constants.H
	group:insert(background)

	pallete = display.newImage("images/pallete.png", 0.75*constants.W, constants.H*0.6)
	pallete.width = constants.W*0.5
	pallete.height = constants.H*0.8 
	group:insert(pallete)

	canvas = display.newImage("images/canvas.png", 0.25*constants.W, constants.CENTERY)
	canvas.width = constants.W*0.35
	canvas.height = constants.H*0.8
	group:insert(canvas)

	totalScore = display.newText("Score: "..total, 0,0, native.systemFont, _H/12)
	totalScore.x = totalScore.width
	totalScore.y = totalScore.height
	group:insert(totalScore)
	

	currentColor = 1
	for i = 1,7,1 do
		circles[i] = display.newImage (data.circlesPath..data.colors[i]..data.format, 0, 0)
		circles[i]:addEventListener( "tap", onCircleClicked )
		circles[i].height = _CIRCLESSIZE
		circles[i].width = _CIRCLESSIZE
		circles[i].xScale, circles[i].yScale = 0.1, 0.1
		group:insert(circles[i])
	end

	circles[1].x = pallete.x + _CIRCLESSIZE/2
	circles[1].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/20

	circles[2].x = pallete.x - _CIRCLESSIZE/2 - constants.H/30	
	circles[2].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/15

	circles[3].x = pallete.x - 4*_CIRCLESSIZE/2.75 - constants.H/30	
	circles[3].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/5.5

	circles[4].x = pallete.x - 4*_CIRCLESSIZE/2.5 - constants.H/30	
	circles[4].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/2.75

	circles[5].x = pallete.x - _CIRCLESSIZE - constants.H/50	
	circles[5].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/1.95
	
	circles[6].x = pallete.x - constants.H/60	
	circles[6].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/1.7
	
	circles[7].x = pallete.x - constants.H/20	
	circles[7].y = pallete.y - pallete.height/2 + _CIRCLESSIZE/2 + constants.H/3.25
	for i = 1, 7 do
		transition.to( circles[i],{time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
	end
end

function scene:enterScene(event)
	--TODO :
	if counter == 5 then
		updateScore()
		counter = 0
	end
	--checkTotal()
	local group = self.view
	colorSound = audio.loadSound( "sounds/"..data.colors[currentColor]..".mp3" )
	audio.play( colorSound )
	
	butterfly = display.newImage (data.butterfliesPath..data.colors[currentColor]..data.format, 0, 0)
	butterfly.x = canvas.x
	butterfly.y = canvas.y
	butterfly.width = canvas.width*0.8
	butterfly.height = canvas.height*0.8
	butterfly.xScale, butterfly.yScale = 0.3, 0.3
	transition.to( butterfly, {time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
	group:insert(butterfly)

	colorName = display.newEmbossedText( data.colors[currentColor], pallete.x, _FONTSIZE/2 , native.systemFont, _FONTSIZE)
	colorName:setFillColor(data.textColors[currentColor][1], data.textColors[currentColor][2],data.textColors[currentColor][3])
	group:insert(colorName)

	
end

function scene:exitScene(event)
	--TODO :
	--for i=1,7 do
	--	circles[i]:removeSelf()
	--end
	butterfly:removeSelf()
	colorName:removeSelf()	
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene" , scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene)
scene:addEventListener( "destroyScene", scene)

return scene