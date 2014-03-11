--"including libs"
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

--event listener for next button
local function onNextButtonClicked( event )
	index = index + 1;	--move to the next animal
	--if current is the last - start from the begining
	if index > table.maxn(data.animalsNames) then
		index = 1;
	end;

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
end;

function scene:enterScene(event)
	local group = self.view;	

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