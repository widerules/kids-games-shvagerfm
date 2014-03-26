--"including libs"
require "sqlite3"
local path = system.pathForFile( "animalskids.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )
local storyboard = require("storyboard");
local widget = require("widget");
local native = require ("native");
local data = require("data");

local scene = storyboard.newScene(); --create scene

local _W = display.contentWidth;			--storing width
local _H = display.contentHeight;			--storing height
local _CENTERX = display.contentCenterX;	--storing horizontal center
local _CENTERY = display.contentCenterY;	--storing verticall center
local _IMAGEWIDTH = 0.35*_W;					--storing image's width
local _IMAGEHEIGHT = 0.35*_W;				--storing image's height
local _BTNSIZE = 0.1*_W;					--storing buttons' size
local _WOODENWIDTH = 0.33*_W;				--storing wooden board's width
local _WOODENHEIGHT = 0.9*_H;				--storing wooden board's height
--I divided scene into two parts - for image and buttons and for "wooden board" 
local _RIGHTCENTERX = _CENTERX + 0.35*_W;	--center for wooden board 
local _LEFTCENTERX = _CENTERX - 0.15*_W;	--center for image

local index = 1;	--index of current animal
local needPlayAudio = true

local background;	--for loading background picture
local woodenLayer;	--for loading wooden texture 

--Buttons
local nextButton;
local previousButton;
local homeButton;

--dynamical controls, which need to be cleared on exit
local animalName;			--Text, for animal name
local animalDescription;	--Text, for animal rhyme
local animalImage;			--Image, for animal picture
local foodImage;			--Image, for food picture
local animalSound			--Sound of the animal

local total, totalScore, bgscore, coins
local coinsToScore
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
---------------------------------------
-----check totals & update 
---------------------------------------
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


----animation update score
local function animScore()
	local function listener()
		updateScore()
		coinsToScore:removeSelf( )
	end
	coinsToScore = display.newImage( "images/coins.png", _CENTERX, _CENTERY, _H/8, _H/8)
	coinsToScore.xScale, coinsToScore.yScale = 0.1, 0.1
	local function trans1()
	 	transition.to(coinsToScore, {time = 200, xScale = 1, yScale = 1, x = coins.x, y= coins.y, onComplete = listener})
	end
	spawnExplosionToTable(_CENTERX, _CENTERY)
	transition.to(coinsToScore, {time = 300, xScale = 2, yScale = 2, transition = easing.outBack, onComplete = trans1})
end
----------------------------------------
-- end totals f-ns
-----------------------------------------
--event listener for next button
local function onNextButtonClicked( event )
	index = index + 1;	--move to the next animal
	--if current is the last - start from the begining
	if index > table.maxn(data.animalsNames) then
		index = 1;
	end;
	counter = counter + 1
	storyboard.reloadScene(); 
end;

local function onPreviousButtonClicked( event )
	index = index - 1; --move to the previous animal
	--if current is first - start from the end
	if index < 1 then
		index = table.maxn(data.animalsNames);
	end;

	storyboard.reloadScene( );
end;

local function onHomeButtonClicked( event )
	--TO DO:
	storyboard.gotoScene("scenetemplate", "slideRight", 800)
	storyboard.removeScene("scenes.game1")
end;

local function onAnimalClicked( event )	
	needPlayAudio = true
	audio.play(animalSound)	
end;

function scene:createScene(event)
	local group = self.view;
	checkTotal()

	--setting up background (I have problems with this ...)
	background = display.newImage( "images/background2.png", _CENTERX, _CENTERY, true);
	background.height = _H;
	background.width = _W;
	group:insert(background);

	--setting up "background" for wooden board
	woodenLayer = display.newImage("images/wood_layer.png", _RIGHTCENTERX, _CENTERY);
	woodenLayer.height = _WOODENHEIGHT;
	woodenLayer.width = _WOODENWIDTH;
	woodenLayer.x = _W - woodenLayer.width/2 - _W/40
	group:insert(woodenLayer);

	--setting up buttons
	nextButton = widget.newButton
	{
		x = _LEFTCENTERX+2*_IMAGEWIDTH/3,
		y = _CENTERY,
		defaultFile = "images/next.png",
		overFile = "images/next.png", --here should be some new file ?
		width = _BTNSIZE,
		height = _BTNSIZE
	};
	nextButton:addEventListener( "tap", onNextButtonClicked );
	group:insert(nextButton);

	previousButton = widget.newButton
	{
		x = _LEFTCENTERX - 2*_IMAGEWIDTH/3,
		y = _CENTERY,
		defaultFile = "images/prev.png",
		overFile = "images/prev.png",
		width = _BTNSIZE,
		height = _BTNSIZE
	}
	previousButton:addEventListener( "tap", onPreviousButtonClicked );
	group:insert(previousButton);

	homeButton = widget.newButton 
	{
		x = _BTNSIZE/2,
		y = _BTNSIZE/2,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png",
		width = _BTNSIZE,
		height = _BTNSIZE
	}
	homeButton:addEventListener("tap", onHomeButtonClicked);
	group:insert (homeButton);	
---------------------------------------------------------------
----Score views
---------------------------------------------------------------
	bgscore = display.newImage("images/bgscore.png", 0, 0, _W/4, _W/12)
	bgscore.width, bgscore.height = _W/3, _W/12
	bgscore.x = bgscore.width/2
	bgscore.y = bgscore.height/2
	group:insert(bgscore)
	
	totalScore = display.newText("Score: "..total, 0,0, native.systemFont, _H/12)
	totalScore.x = 2*totalScore.width/3
	totalScore.y = bgscore.y
	group:insert(totalScore)

	coins = display.newImage("images/coins.png", 0, 0, bgscore.height/2, bgscore.height/2)
	coins.width, coins.height = 2*bgscore.height/3, 2*bgscore.height/3
	coins.x = bgscore.width - 3*coins.width/4
	coins.y = bgscore.y
	group:insert(coins)
------------------------------------------------------------------------------
--End score views
------------------------------------------------------------------------------
end;

function scene:enterScene(event)
	local group = self.view;	

	if counter == #data.animalsNames then
		animScore()
		
		counter = 0
	end

	animalName = display.newEmbossedText( data.animalsNames[index], woodenLayer.x, _CENTERY-_WOODENHEIGHT/2, "Rage Italic", _H/10);
	animalName:setFillColor( 0,0,0 );
	animalName.anchorY = 0;
	group:insert(animalName);

	animalDescription = display.newEmbossedText(data.animalsDescriptions[index], woodenLayer.x, 0, 0.85*_WOODENWIDTH, 0.5*_WOODENHEIGHT, "Arial", _H/24);	
	animalDescription.y = animalName.y + 3*animalDescription.height/4;
	animalDescription:setFillColor(0,0,0);
	group:insert(animalDescription);	

	animalImage = display.newImage( data.animalsImages[index], _LEFTCENTERX, _CENTERY );
	animalImage.height = _IMAGEHEIGHT;
	animalImage.width = _IMAGEWIDTH;
	animalImage:addEventListener( "tap", onAnimalClicked );
	group:insert(animalImage);

	foodImage = display.newImage (data.foodsImages[index], woodenLayer.x, _CENTERY+_WOODENHEIGHT/2);
	foodImage.anchorY = 1;
	foodImage.height = _IMAGEHEIGHT/2;
	foodImage.width = _IMAGEWIDTH/2;
	group:insert (foodImage);

	animalSound = audio.loadSound( data.animalsSounds[index])

	if needPlayAudio == true then
		needPlayAudio = false
		timer.performWithDelay( 500, onAnimalClicked )	
	end
end;

function scene:exitScene(event)
	animalName:removeSelf();
	animalDescription:removeSelf();
	animalImage:removeSelf();
	foodImage:removeSelf();
end;

function scene:destroyScene(event)

end;

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
return scene;