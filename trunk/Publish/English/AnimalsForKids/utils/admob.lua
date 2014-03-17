admob = {}

admob.provider = "admob"
local ads = require ( "ads" )
-- Your application ID in admob

admob.appID = "ca-app-pub-8763317495638154/6195451628"

admob.init = function ()
	if admob.appID then
		ads.init( admob.provider, admob.appID, admob.adListener )
	end
end

admob.showAd = function( adType )
    ads.show( adType, { x=0, y=0 } )
end

-- Set up ad listener.
admob.adListener = function ( event )
	-- event table includes:
	-- 		event.provider
	--		event.isError (e.g. true/false )
	
	local msg = event.response
	-- just a quick debug message to check what response we got from the library
	print("Message received from the ads library: ", msg)
end

return admob