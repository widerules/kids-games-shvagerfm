local storyboard = require( "storyboard");
local widget = require( "widget");
local data = require ("..\\shapesData");
local constants = require("constants")

local scene = storyboard.newScene();

local _IMAGESIZE = 0.2*constants.H;
local _FONTSIZE = constants.H / 18;
local _SPACING = 0.1*constants.H;

local _ANIMALSPATH = "images\\animals\\";
local _SHAPESPATH = "images\\animals\\s";
local _FORMAT = ".png";

local _LEFTCENTER;
local _RIGHTCENTER;

local indexes = {};
local animalsPictures = {};
local shapesPictures = {};

local background;
local leftBar;
local plate;

local debugText;

local animals = {};

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

function scene:createScene(event)
	local group = self.view;

	background = display.newImage("images\\bg.png", constants.CENTERX, constants.CENTERY, true);
	background.height = constants.H;
	background.width = constants.W;
	group:insert(background);

	leftBar = display.newImage("images\\leftbar.png",0,constants.CENTERY);
	leftBar.height = constants.H;
	leftBar.width = 0.2*constants.W;
	leftBar.x = leftBar.width/2;
	group:insert(leftBar);

	plate = display.newImage("images\\plate.png", 0 , constants.CENTERY);
	plate.height = 0.9*constants.H;
	plate.width = 0.7*constants.W;
	plate.x = leftBar.x+leftBar.width/2+plate.width/2+0.05*constants.W;
	group:insert(plate);

	_LEFTCENTER = leftBar.x;
	_RIGHTCENTER = plate.x;

end;

function scene:enterScene(event)
	local group = self.view;

	generateIndexes();

	local imageY = _IMAGESIZE/2;--+0.05*constants.H;
	animalsPictures[1] = display.newImage(_ANIMALSPATH..data.animals[indexes[1]].._FORMAT,_LEFTCENTER, imageY);
	animalsPictures[1].height = _IMAGESIZE;
	animalsPictures[1].width = _IMAGESIZE;
	group:insert(animalsPictures[1]);

	for i = 2, 5, 1 do
		imageY = animalsPictures[i-1].y + _IMAGESIZE;-- + 0.05*constants.H;
		animalsPictures[i] = display.newImage (_ANIMALSPATH..data.animals[indexes[i]].._FORMAT, _LEFTCENTER, imageY);
		animalsPictures[i].height = _IMAGESIZE;
		animalsPictures[i].width = _IMAGESIZE;
		group:insert(animalsPictures[i]); 
	end;

	shapesPictures[1] = display.newImage(_SHAPESPATH..data.animals[indexes[1]].._FORMAT, 0, 0);
	shapesPictures[1].height = _IMAGESIZE;
	shapesPictures[1].width = _IMAGESIZE;
	shapesPictures[1].x = plate.x - plate.width/2 + _IMAGESIZE/2 + _SPACING;
	shapesPictures[1].y = plate.y - plate.height/2 + _IMAGESIZE/2 + _FONTSIZE + _SPACING;
	group:insert(shapesPictures[1]);
end;


function scene:exitScene(event)
end;

function scene:destroyScene(event)
end;

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene;