local data = {}

data.starPath = "images/stars/"
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
		speed = 3,
		colors = 3,
		size = 4,				--smaller value of size var means bigger size on the display
		amount = 50,
		generationDelay = 200
	},
	{
		speed = 7,
		colors = 4,
		size = 5,
		amount = 70,
		generationDelay = 180
	},
	{
		speed = 8,
		colors = 6,
		size = 6,
		amount = 80,
		generationDelay = 160
	},
	{
		speed = 9.8,
		colors = 7,
		size = 7,
		amount = 90,
		generationDelay = 140
	},
}

return data