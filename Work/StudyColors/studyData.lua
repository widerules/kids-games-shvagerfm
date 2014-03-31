local constants = require( "constants")

local data = {}

data.butterfliesPath = "images/butterflies/"
data.circlesPath = "images/circles/"
data.format = ".png"

data.colors = 
{
	"red",
	"orange",
	"yellow",
	"green",
	"cyan",
	"blue",
	"purple"	
}

data.textColors = 
{
	{1, 0, 0},		--red
	{1, 0.8, 0},	--orange
	{1, 1, 0},		--yellow
	{0, 1, 0},		--green
	{0, 1, 1},		--cyan
	{0, 0, 1},		--blue
	{1, 0, 1}		--purple
}

return data