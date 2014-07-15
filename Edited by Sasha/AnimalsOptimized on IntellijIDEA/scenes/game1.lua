local storyboard = require("storyboard");
local widget = require("widget");
local native = require ("native");
local data = require("data.data");
local constants = require("constants")


local scene = storyboard.newScene();

local _IMAGEWIDTH = 0.35 * constants.W;
local _IMAGEHEIGHT = 0.35 * constants.W;
local _BTNSIZE = 0.07 * constants.W;
local _WOODENWIDTH = 0.33 * constants.W;
local _WOODENHEIGHT = 0.9 * constants.H;

--I divided scene into two parts - for image and buttons and for "wooden board" 
local _RIGHTCENTERX = constants.CENTERX + 0.35 * constants.W;	--center for wooden board 
local _LEFTCENTERX = constants.CENTERX - 0.15 * constants.W;	--center for image


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

local function onNextButtonClicked( event )
	index = index + 1;	--move to the next animal
	
	--if current is the last - start from the begining
	if index > table.maxn(data.animalsNames) then
		index = 1;
	end;
	if animalDescription ~=nil then
		display.remove(animalDescription)
		animalDescription = nil
	end
	
	storyboard.reloadScene(); 
end;

local function onPreviousButtonClicked( event )
	index = index - 1; --move to the previous animal
	
	--if current is first - start from the end
	if index < 1 then
		index = table.maxn(data.animalsNames);
	end;
	
	display.remove(animalDescription)
	storyboard.reloadScene( );
end;

local function onHomeButtonClicked( event )
	--TO DO:
	local options =
		{
    		effect = "slideRight",
    		time = 500,
    		--params = { ind = 1 }
		}
	storyboard.gotoScene("scenes.menu", options)
	storyboard.removeScene("scenes.game1")

end;

local function onAnimalClicked( event )	
	needPlayAudio = true
	audio.play(animalSound)	
end;

function scene:createScene(event)
	local group = self.view;


	--setting up background (I have problems with this ...)
	background = display.newImage( "images/background2.jpg", constants.CENTERX, constants.CENTERY, true);
	background.height = constants.H;
	background.width = constants.W;
	group:insert(background);

	--setting up "background" for wooden board
	woodenLayer = display.newImage("images/wood_layer.png", _RIGHTCENTERX, constants.CENTERY);
	woodenLayer.height = _WOODENHEIGHT;
	woodenLayer.width = _WOODENWIDTH;
	woodenLayer.x = constants.W - woodenLayer.width/2 - constants.W/40
	group:insert(woodenLayer);

	--setting up buttons
	nextButton = widget.newButton
	{
		x = _LEFTCENTERX+2*_IMAGEWIDTH/3,
		y = constants.CENTERY,
		defaultFile = "images/next.png",
		overFile = "images/next.png", --here should be some new file ?
		width = 1.2*_BTNSIZE,
		height = 1.2*_BTNSIZE,
        onRelease = onNextButtonClicked
	};
	group:insert(nextButton);

	previousButton = widget.newButton
	{
		x = _LEFTCENTERX - 2*_IMAGEWIDTH/3,
		y = constants.CENTERY,
		defaultFile = "images/prev.png",
		overFile = "images/prev.png",
		width = 1.2*_BTNSIZE,
		height = 1.2*_BTNSIZE,
        onRelease = onPreviousButtonClicked
	}
	group:insert(previousButton);

	homeButton = widget.newButton 
	{
		height = _BTNSIZE,
        width = _BTNSIZE,
        left = 0,
		top = 0,
		defaultFile = "images/home.png",
		overFile = "images/homehover.png",
		width = _BTNSIZE,
		height = _BTNSIZE,
        onRelease = onHomeButtonClicked
	}
	--homeButton:addEventListener("tap", onHomeButtonClicked);
	group:insert (homeButton);	

end;

function scene:enterScene(event)
	local group = self.view;	


	animalName = display.newEmbossedText( data.animalsNames[index], woodenLayer.x, constants.CENTERY - _WOODENHEIGHT/2, "Rage Italic", constants.H/10);
	animalName:setFillColor( 0,0,0 );
	animalName.anchorY = 0;
	group:insert(animalName);

	if data.animalsDescriptions[index] ~= nil then
		animalDescription = display.newEmbossedText(data.animalsDescriptions[index], woodenLayer.x, 0, 0.85 * _WOODENWIDTH, 0.7 * _WOODENHEIGHT, "Arial", constants.H/24);
		animalDescription.y = animalName.y + 3*animalDescription.height/4;
		animalDescription:setFillColor(0,0,0);
		group:insert(animalDescription);	
	end

	animalImage = display.newImage( data.animalsImages[index], _LEFTCENTERX, constants.CENTERY );
	animalImage.height = _IMAGEHEIGHT;
	animalImage.width = _IMAGEWIDTH;
	animalImage:addEventListener( "tap", onAnimalClicked );
	group:insert(animalImage);

	if data.foodsImages[index] ~= nil then
		foodImage = display.newImage (data.foodsImages[index], woodenLayer.x, constants.CENTERY + _WOODENHEIGHT/2);
		foodImage.anchorY = 1;
		foodImage.height = _IMAGEHEIGHT/2;
		foodImage.width = _IMAGEWIDTH/2;
		group:insert (foodImage);
	end

	animalSound = audio.loadSound( data.animalsSounds[index])

	if needPlayAudio == true then
		needPlayAudio = false
		timer.performWithDelay( 500, onAnimalClicked )	
	end
end;

function scene:exitScene(event)
	animalImage:removeEventListener( "tap", onAnimalClicked )
	
	if animalName ~= nil then
		display.remove(animalName)
	end
	
	if animalDescription ~= nil then
		display.remove(animalDescription);
	end
	
	if animalImage ~= nil then
		display.remove(animalImage);
	end
	
	if foodImage ~= nil then
		display.remove(foodImage);
		foodImage = nil
	end
	
	audio.stop()
    audio.dispose ( animalSound )
    animalSound = nil
	transition.cancel( )
end;

function scene:destroyScene(event)

end;

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene;