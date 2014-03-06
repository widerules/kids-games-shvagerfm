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

local background;
local leftBar;
local plate;

local popupBg;
local popupText;
local homeBtn;
local nextBtn;

local onPlaces = 0;

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
	--TO DO:
	--returning to the main screen
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
end;

local function onAnimalDrag(event)
	
	local t = event.target;
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
			showPopUp();
		end;

	end;
end;

function scene:createScene(event)
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

end;

function scene:enterScene(event)
	local group = self.view;

	generateIndexes();

	local imageY = _IMAGESIZE/2;--+0.05*constants.H;
	animalsPictures[1] = display.newImage(_ANIMALSPATH..data.animals[indexes[1]].._FORMAT,_LEFTCENTER, imageY);
	animalsPictures[1].height = _IMAGESIZE;
	animalsPictures[1].width = _IMAGESIZE;
	animalsPictures[1]:addEventListener( "touch", onAnimalDrag );
	group:insert(animalsPictures[1]);

	for i = 2, 5, 1 do
		imageY = animalsPictures[i-1].y + _IMAGESIZE;-- + 0.05*constants.H;
		animalsPictures[i] = display.newImage (_ANIMALSPATH..data.animals[indexes[i]].._FORMAT, _LEFTCENTER, imageY);
		animalsPictures[i].height = _IMAGESIZE;
		animalsPictures[i].width = _IMAGESIZE;
		animalsPictures[i]:addEventListener( "touch", onAnimalDrag );
		group:insert(animalsPictures[i]); 
	end;

	local tmpPos = { x = table.copy(positions.x), y = table.copy(positions.y)};
	
	for i = 1,5,1 do 
		local randPos = math.random (1, table.maxn(tmpPos.x));
		
		shapesPictures[i] = display.newImage (_SHAPESPATH..data.animals[indexes[i]].._FORMAT,0,0);
		shapesPictures[i].height = _IMAGESIZE*1.5;
		shapesPictures[i].width = _IMAGESIZE*1.5;	
		shapesPictures[i].x = tmpPos.x[randPos];
		shapesPictures[i].y = tmpPos.y[randPos];
		group:insert(shapesPictures[i]);

		labels[i] = display.newEmbossedText( data.animals[indexes[i]], shapesPictures[i].x, shapesPictures[i].y-_IMAGESIZE/2-_FONTSIZE/2, native.systemFontBold , _FONTSIZE);
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