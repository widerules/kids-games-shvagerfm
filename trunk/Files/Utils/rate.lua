require "sqlite3"

local path = system.pathForFile( "pullups.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

local M = {}

M.rateIt = function ()
	local options =
	{	
		androidAppPackageName = "com.shvagerfm.Pullupspro",
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
	print (M.isRated())
	if (not M.isRated()) then
		native.showAlert( "Спасибо!", "Если Вам понравилось приложение оставьте отзыв", { "OK", "Выход" }, onComplete )
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
		native.showAlert( "Выход", "Вы действительно хотите выйти", { "Выход", "Нет" }, onComplete )
	end
end

return M