require "sqlite3"

local path = system.pathForFile( "animalskids.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

local M = {}

M.rateIt = function ()
	local options =
	{	
		androidAppPackageName = "com.shvagerfm.AnimalsForKids",
		supportedAndroidStores = { "google" }
	}
	native.showPopup("rateApp", options)
end

M.initDB = function()
	local tablesetup = [[CREATE TABLE IF NOT EXISTS rateApp (id INTEGER PRIMARY KEY autoincrement, rated);]]
	db:exec( tablesetup )
end

M.isRated = function ()
	local sqlQuery = [[SELECT * FROM rateApp;]]
	local rated = false

	for row in db:nrows(sqlQuery) do
		rated = row.rated
	end

	return rated ~= false
end

M.saveRate = function ()
	local sqlQuery = [[INSERT INTO rateApp VALUES (NULL, 'true');]]
	db:exec(sqlQuery)
end

M.init = function ()
	M.initDB()

	local onComplete = function ( event )
		if "clicked" == event.action then
		    if 1 == event.index then
		    	M.saveRate()
		    	M.rateIt()
	    	elseif 2 == event.index then 
	    		db:close()
	    		native.requestExit()
		    end
		end
	end
	
	if (not M.isRated()) then
		native.showAlert( "Thank You!", "If you like our app  - please rate it", { "OK", "Exit" }, onComplete )
	else
		local onComplete = function ( event )
		if "clicked" == event.action then
		    if 1 == event.index then
		    	db:close()
	    		native.requestExit()
	    	elseif 2 == event.index then 
	    		
		    end
		end
	end
		native.showAlert( "Exit", "Do you really want to exit?", { "Exit", "No" }, onComplete )
	end
end

return M