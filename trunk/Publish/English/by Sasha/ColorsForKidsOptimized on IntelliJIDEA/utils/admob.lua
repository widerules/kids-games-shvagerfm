admob = {}

admob.provider = "admob"

admob.countBeforeShowAds = 1


local ads = require ( "ads" )

admob.appID = "ca-app-pub-8763317495638154/2851595229"

admob.init = function ()
	if admob.appID then
		ads.init( admob.provider, admob.appID, admob.adListener )
	end
end

admob.showAd = function( adType )
	if admob.countBeforeShowAds == 1 then

    	ads.show( adType, { x=0, y=0 } )
    	admob.countBeforeShowAds = 0
	end
end

-- Set up ad listener.
admob.adListener = function ( event )
end

return admob