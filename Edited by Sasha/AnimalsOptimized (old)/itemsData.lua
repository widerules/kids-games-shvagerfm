local constants = require("constants")

local data = {}

data.HOGIMAGESIZE = 0.15*constants.H
data.MUSHIMAGESIZE = 0.15*constants.H
data.BERRYIMAGESIZE = 0.15*constants.H

data.hogsGroups = { 8, 8, 3, 5, 4, 1, 8}
data.hogsScale = { -1, -1, 1, -1, -1, 1, 1}
data.hogsSizes = { 1.5, 1, 1, 1, 1, 1, 1}
data.hogsPositions = 
{
	x = 
	{
		constants.W-data.HOGIMAGESIZE/0.75,			--1
		constants.CENTERX-constants.W/30,		--2
		constants.CENTERX-data.HOGIMAGESIZE/0.65,	--3
		constants.W - constants.CENTERX/1.75,	--4
		data.HOGIMAGESIZE/0.85,							--5
		constants.CENTERX-data.HOGIMAGESIZE*2.6,	--6
		data.hogsSizes[7]*data.HOGIMAGESIZE				--7
	},
	y = 
	{
		constants.CENTERY+data.HOGIMAGESIZE/0.75,   		--1
		constants.CENTERY+2*data.HOGIMAGESIZE+constants.W/70,--2
		constants.CENTERY+data.HOGIMAGESIZE/2,			--3
		constants.CENTERY,							--4
		constants.CENTERY+data.HOGIMAGESIZE/1.25,			--5
		constants.CENTERY-data.HOGIMAGESIZE/2, 			--6
		constants.H-1.1*data.hogsSizes[7]*data.HOGIMAGESIZE		--7
	}
}

data.mushroomsGroups = {9, 8, 6, 8, 4, 1, 2}
data.mushroomsScale = {1, 1, 1, 1, -1, 1, -1}
data.mushroomsSizes = {1.2, 0.75, 1, 0.75, 1, 1, 0.75}
data.mushroomsTypes = {1, 2, 1, 2, 1, 1, 2}
data.mushroomsPositions = 
{
	x =
	{
		constants.CENTERX+data.MUSHIMAGESIZE*1.6,	--1
		constants.CENTERX- data.MUSHIMAGESIZE*1.4,	--2
		constants.CENTERX+data.MUSHIMAGESIZE*2.25,	--3
		data.MUSHIMAGESIZE*1.8,						--4
		data.MUSHIMAGESIZE*1.8,						--5
		constants.CENTERX - data.MUSHIMAGESIZE*2,	--6
		constants.CENTERX+data.MUSHIMAGESIZE*1.3	--7		
	},
	y = 
	{
		constants.H- data.MUSHIMAGESIZE/1.3,		--1
		constants.H- data.MUSHIMAGESIZE/1.1,		--2
		constants.CENTERY+data.MUSHIMAGESIZE,		--3
		constants.H- data.MUSHIMAGESIZE,			--4
		constants.CENTERY+data.MUSHIMAGESIZE*0.75,	--5
		constants.CENTERY - data.MUSHIMAGESIZE*0.5,	--6
		constants.CENTERY - data.MUSHIMAGESIZE/8	--7
	}
}

data.berriesGroups = {7, 6, 5, 7, 1, 5, 3}
data.berriesSizes = {1, 1, 1, 1, 0.75, 1, 1}
data.berriesPosition = 
{
	x = 
	{
		constants.W - data.BERRYIMAGESIZE*2, 		--1
		constants.CENTERX,						--2
		constants.CENTERX- data.BERRYIMAGESIZE*2.3,	--3
		data.BERRYIMAGESIZE*1.5,					--4
		constants.CENTERX*1.1,					--5
		constants.CENTERX*1.45,					--6
		constants.CENTERX*0.5 					--7
	},
	y = 
	{
		constants.CENTERY+data.BERRYIMAGESIZE*1.2,	--1
		constants.CENTERY+data.BERRYIMAGESIZE/1.75,	--2
		constants.CENTERY+1.5*data.BERRYIMAGESIZE,	--3
		constants.H - data.BERRYIMAGESIZE,			--4
		constants.CENTERY- data.BERRYIMAGESIZE/2,	--5
		constants.CENTERY- data.BERRYIMAGESIZE/2.3,	--6
		constants.CENTERY 						--7
	}	
}

return data