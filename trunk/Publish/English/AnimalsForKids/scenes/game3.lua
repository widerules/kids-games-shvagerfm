require "sqlite3"
local path = system.pathForFile( "animalskids.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )
local storyboard = require( "storyboard");
local widget = require( "widget");
local data = require ("shapesData");
local constants = require("constants");
local native = require( "native");

local scene = storyboard.newScene();

local _IMAGESIZE = 0.2*constants.H;
local _FONTSIZE = constants.H / 15;
local _SPACING = 0.1*constants.H;
local _DELTA = 0.08*constants.H;

local _ANIMALSPATH = "images/animals/";
local _SHAPESPATH = "images/animals/s";
local _FORMAT = ".png";

local _LEFTCENTER;
local _RIGHTCENTER;

local indexes = {};
local positions = {};
local animalsPictures = {};
local shapesPictures = {};
local labels = {};

local animalSound;

local background;
local leftBar;
local plate;

local popupBg;
local popupText;
local homeBtn;
local nextBtn;
local soundHarp = audio.loadSound( "sounds/harp.ogg")

local onPlaces = 0;

local total, totalScore, bgscore, coins
local coinsToScore
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
	local wellSound = audio.loadSound( "sounds/welldone.mp3")
    audio.play( wellSound )
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

local function generateIndexes()
	for i = 1, 5, 1 do
		local flag = false;
		while (flag == false) do
			flag = true;
			local tmp = math.random(1, table.maxn(data.animals));		
			for j = 1, table.maxn (indexes), 1 do
				if (indexes[j] == tmp) then
					flag = false;					
				end;
			end;
			if (flag == true) then
				table.insert(indexes, tmp);
				print(tmp);					
			end;
		end;
	end;
end;

local function onHomeButtonClicked(event)
	storyboard.gotoScene("scenetemplate", "slideRight", 800)
    storyboard.removeScene("scenes.game3")
end;

--- animaton Scale to 1.5
local function animScaleOnDrag(self)
	self.xScale = 1.5
	self.yScale = 1.5
end
local function animScaleBack(self)
	self.xScale = 1
	self.yScale = 1
end
local function animOnPutOn(self)
	local function setToBig()
		transition.scaleTo(self, {xScale = 1.5, yScale = 1.5, time = 500})
	end	
	transition.scaleTo(self, {xScale = 1.3, yScale = 1.3, time = 300, onComplete=setToBig})
end

local function animOnPutOnShape(self)
	local function setToBig()
		transition.scaleTo(self, {xScale = 1, yScale = 1, time = 500})
	end	
	transition.scaleTo(self, {xScale = 0.8, yScale = 0.8, time = 300, onComplete=setToBig})
end

local function onNextButtonClicked (event)
	storyboard.reloadScene( );
end;

local function showPopUp()
	popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
	popupBg.height = 0.7*constants.H;
	popupBg.width = 0.7*constants.W;

	popupText = display.newText("Well done !", popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
	popupText.y = popupBg.y-popupBg.height+2*popupText.width/3;

	homeBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x - 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png"
	}
	homeBtn:addEventListener( "tap", onHomeButtonClicked );

	nextBtn = widget.newButton
	{
		width = 0.4*popupBg.height,
		height = 0.4*popupBg.height,
		x = popupBg.x + 0.4*popupBg.width/2,
		y = popupBg.y + 0.4*popupBg.height/2,
		defaultFile = "images/next.png",
		overFile = "images/next.png"
	}	
	nextBtn:addEventListener( "tap", onNextButtonClicked );
	animScore()
end;

local function onAnimalDrag(event)
	
	local t = event.target;
	local name = tostring(t.name)
	animalSound = audio.loadSound("sounds/"..name..".mp3")
	local phase = event.phase;
	animScaleOnDrag(t)
	if "began" == phase then 
		startX = t.x;
		startY = t.y;

		--bring the letter on top (just for being sure)
		local parent = t.parent;
		parent:insert (t);
		display.getCurrentStage():setFocus(t);
		
		t.isFocus = true;
		t.x0 = event.x - t.x;
		t.y0 = event.y - t.y;

	elseif "moved" == phase and t.isFocus then
		t.x = event.x-t.x0;
		t.y = event.y-t.y0;
	elseif "ended" == phase or "cancel" == phase then 
		local flag = false;
		local index = 0;
		--find which animal dragged
		for i = 1, table.maxn(animalsPictures), 1 do
			if animalsPictures[i]==t then
				index = i;
			end;
		end;		

		if math.abs(t.x - shapesPictures[index].x)<_DELTA and math.abs (t.y-shapesPictures[index].y)<_DELTA then
			t.x = shapesPictures[index].x;
			t.y = shapesPictures[index].y;
			onPlaces = onPlaces + 1;
			animOnPutOn(t)
			animOnPutOnShape(shapesPictures[index])
			audio.play( animalSound )
			spawnExplosionToTable(t.x, t.y)
			t:removeEventListener( "touch", onAnimalDrag )
		else 
			t.x = startX;
			t.y = startY;
			animScaleBack(t)
		end;

		display.getCurrentStage():setFocus(nil);
		t.isFocus = false;
		startX = nil;
		startY = nil;

		if onPlaces == 5 then
			audio.play( soundHarp )
			timer.performWithDelay( 800, showPopUp, 1)
		end;

	end;
end;

function scene:createScene(event)
	checkTotal()
	local group = self.view;

	background = display.newImage("images/bg.png", constants.CENTERX, constants.CENTERY, true);
	background.height = constants.H;
	background.width = constants.W;
	group:insert(background);

	leftBar = display.newImage("images/leftbar.png",0,constants.CENTERY);
	leftBar.height = constants.H;
	leftBar.width = 0.2*constants.W;
	leftBar.x = leftBar.width/2;
	group:insert(leftBar);

	plate = display.newImage("images/plate.png", 0 , constants.CENTERY);
	plate.height = 0.9*constants.H;
	plate.width = 0.7*constants.W;
	plate.x = leftBar.x+leftBar.width/2+plate.width/2+0.05*constants.W;
	group:insert(plate);

	_LEFTCENTER = leftBar.x;
	_RIGHTCENTER = plate.x;

	positions = 
	{
		x = 
		{
			plate.x-plate.width/2+_IMAGESIZE/2+_SPACING,
			plate.x+plate.width/2-_IMAGESIZE/2-_SPACING,
			plate.x,
			plate.x-plate.width/2+_IMAGESIZE/2+_SPACING,
			plate.x+plate.width/2-_IMAGESIZE/2-_SPACING
		},
		y = 
		{
			plate.y-plate.height/2+_IMAGESIZE/2+_FONTSIZE+_SPACING,
			plate.y-plate.height/2+_IMAGESIZE/2+_FONTSIZE+_SPACING,
			plate.y,
			plate.y+plate.height/2-_IMAGESIZE/2 - _FONTSIZE - _SPACING,
			plate.y+plate.height/2-_IMAGESIZE/2 - _FONTSIZE - _SPACING
		}
	}

---------------------------------------------------------------
----Score views
---------------------------------------------------------------
	bgscore = display.newImage("images/bgscore.png", 0, 0, _W/4, _W/12)
	bgscore.width, bgscore.height = _W/5, _W/20
	bgscore.x = constants.W - bgscore.width/2
	bgscore.y = bgscore.height/2
	group:insert(bgscore)
	
	
	coins = display.newImage("images/coins.png", 0, 0, bgscore.height/2, bgscore.height/2)
	coins.width, coins.height = 2*bgscore.height/3, 2*bgscore.height/3
	coins.x = bgscore.x + 0.5*bgscore.width - 3*coins.width/4
	coins.y = bgscore.y
	group:insert(coins)

	totalScore = display.newText("Score: "..total, 0,0, native.systemFont, _H/24)
	totalScore.x = bgscore.x - totalScore.width/4
	totalScore.y = bgscore.y
	group:insert(totalScore)

------------------------------------------------------------------------------
--End score views
------------------------------------------------------------------------------

end;

function scene:enterScene(event)
	local group = self.view;

	generateIndexes();

	local imageY = _IMAGESIZE/2;--+0.05*constants.H;
	animalsPictures[1] = display.newImage(_ANIMALSPATH..data.animals[indexes[1]].._FORMAT, 0, imageY);
	animalsPictures[1].height = _IMAGESIZE;
	animalsPictures[1].width = _IMAGESIZE;
	animalsPictures[1].name = data.animals[indexes[1]]
	animalsPictures[1]:addEventListener( "touch", onAnimalDrag );
	group:insert(animalsPictures[1]);

	for i = 2, 5, 1 do
		imageY = animalsPictures[i-1].y + _IMAGESIZE;-- + 0.05*constants.H;
		animalsPictures[i] = display.newImage (_ANIMALSPATH..data.animals[indexes[i]].._FORMAT, 0, imageY);
		animalsPictures[i].height = _IMAGESIZE;
		animalsPictures[i].width = _IMAGESIZE;
		animalsPictures[i].name = data.animals[indexes[i]]
		animalsPictures[i]:addEventListener( "touch", onAnimalDrag );
		group:insert(animalsPictures[i]); 
	end;

	
	
	local tmpPos = { x = table.copy(positions.x), y = table.copy(positions.y)};
	
	for i = 1,5,1 do 

		transition.to(animalsPictures[i], {x=_LEFTCENTER, transition=easing.outBounce, time = 500})

		local randPos = math.random (1, table.maxn(tmpPos.x));
		
		shapesPictures[i] = display.newImage (_SHAPESPATH..data.animals[indexes[i]].._FORMAT,0,0);
		shapesPictures[i].height = _IMAGESIZE*1.5;
		shapesPictures[i].width = _IMAGESIZE*1.5;	
		shapesPictures[i].x = tmpPos.x[randPos];
		shapesPictures[i].y = tmpPos.y[randPos];
		group:insert(shapesPictures[i]);

		labels[i] = display.newEmbossedText( data.animals[indexes[i]], shapesPictures[i].x, shapesPictures[i].y-1.5*_IMAGESIZE/2-_FONTSIZE/2, native.systemFontBold , _FONTSIZE);
		labels[i]:setFillColor( 0,0,0 );
		group:insert (labels[i]);

		table.remove( tmpPos.x, randPos );
		table.remove( tmpPos.y, randPos );
	end;
end;


function scene:exitScene(event)
	for i = 1, table.maxn(animalsPictures), 1 do 
		animalsPictures[i]:removeSelf( );
		shapesPictures[i]:removeSelf();
		labels[i]:removeSelf();
	end;

	while (table.maxn(labels)>0) do
		table.remove(labels, 1);
	end;
	
	while (table.maxn(indexes)>0) do
		table.remove(indexes);
	end;

	if popupBg ~= nil then
		popupBg:removeSelf();
		popupText:removeSelf();
		nextBtn:removeSelf();
		homeBtn:removeSelf();
		popupBg = nil
	end;

	onPlaces = 0;
end;

function scene:destroyScene(event)
end;

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene;