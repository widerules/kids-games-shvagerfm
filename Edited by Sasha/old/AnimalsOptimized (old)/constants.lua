local widget = require("widget");

local consts = {};

consts.W = display.contentWidth;			--storing width
consts.H = display.contentHeight;			--storing height
consts.CENTERX = display.contentCenterX;	--storing horizontal center
consts.CENTERY = display.contentCenterY;	--storing verticall center

--[[consts.homeButton = widget.newButton
{
	defaultFile = "images\\home.png",
	overFile = "images\\home.png",
	width = 0.1*consts.W;
	height = 0.1*consts.W;
}--]]

return consts