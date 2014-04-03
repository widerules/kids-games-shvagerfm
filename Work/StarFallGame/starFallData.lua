local data = {}

local _BIGSIZE	= 4
local _MIDSIZE	= 6
local _SMALLSIZE = 7

local _FASTSPEED = 9
local _MIDSPEED  = 6
local _SLOWSPEED = 3

data.itemPath = 
{
	"images/stars/"
}
data.format = ".png"

data.colors = 
{
	"blue",
	"green",
	"indigo",
	"orange",
	"purple",
	"red",
	"yellow"		
}

data.difficults =
{
	{
		colors = 2,
		size = _BIGSIZE,				--smaller value of size var means bigger size on the display
		speed = _SLOWSPEED
	},
	{	
		colors = 3,	
		size = _BIGSIZE,
		speed = _SLOWSPEED
	},
	{
		colors = 3,
		size = _BIGSIZE,
		speed = _MIDSPEED
	},
	{
		colors = 4,
		size = _MIDSIZE,
		speed = _MIDSPEED
	},
	{
		colors = 5,
		size = _MIDSIZE,
		speed = _MIDSPEED
	},
	{
		colors = 6,
		size = _SMALLSIZE,
		speed = _MIDSPEED
	},
	{
		colors = 7,
		size = _SMALLSIZE,
		speed = _FASTSPEED
	}
}

return data