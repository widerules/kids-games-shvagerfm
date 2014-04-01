----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
require "sqlite3"

local path = system.pathForFile( "animalskids.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local widget = require("widget")
local rate = require( "utils.rate" )
local admob = require( "utils.admob" )

local btnGame1, btnGame2, btnGame3, btnGame4, background, title
local btnGameHeight = _H/4
local btnGameWidth = 3*_H/4

local total, totalScore, bgscore, coins

--local bgsound = audio.loadSound( "sounds/bgsound.mp3" )

--local harp = audio.loadSound( "sounds/harp.wav")
----------------------------------------------------------------------------------
local function goGame1()
		storyboard.gotoScene("scenes.game1", "slideLeft", 800)
		storyboard.removeAll( )
	end
-- переход на игру 2
local function goGame2()
		storyboard.gotoScene("scenes.game2", "slideLeft", 800)
		storyboard.removeAll( )
	end
local function goGame3()
		storyboard.gotoScene("scenes.game3", "slideLeft", 800)
		storyboard.removeAll( )
	end

local function goGame4()
		storyboard.gotoScene("scenes.game4", "slideLeft", 800)
		storyboard.removeAll( )
	end

local function exit ()
	rate.init()
end
---------------------------------------------------------------------------------
local function checkTotal()
   local function dbCheck()
      local sql = [[SELECT value FROM statistic WHERE name='total';]]
      for row in db:nrows(sql) do
         return row.value
      end
   end

   total = dbCheck()
   if total == nil then
      local insertTotal = [[INSERT INTO statistic VALUES (NULL, 'total', '0'); ]]
      db:exec( insertTotal )
      print("total inserted to 0")
      total = 0
   else
      print("Total is "..total)
   end
end
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	

background = display.newImage( "images/background.png", _CENTERX, _CENTERY, _W, _H)
	group:insert(background)

title = display.newEmbossedText("Animals for Kids", _CENTERX, 0, native.systemFont, _H/8)
title.y = title.height
title:setFillColor( 1, 0.6, 0 )
group:insert(title)

exitBtn = widget.newButton
		{	
		    width = _H/8,
		    height = _H/8,
		    defaultFile = "images/exit.png",
		    overFile = "images/exit.png",
		    id = "button_2",
		    onRelease = exit,
		    
		}
	exitBtn.x = _W - _W/10
	exitBtn.y = _H/10
	group:insert(exitBtn)
	admob.init()
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	checkTotal()
	local group = self.view
	admob.showAd( "interstitial" )
	btnGame1 = widget.newButton
	{
		width = btnGameWidth,
		height = btnGameHeight,
		defaultFile = "images/btn1.png",
		id = "button_1",
		onRelease = goGame1,
	}
	btnGame1.x = _CENTERX/2
	btnGame1.y = 1.5*btnGameHeight

	group:insert(btnGame1)

	btnGame2 = widget.newButton
	{
		width = btnGameWidth,
		height = btnGameHeight,
		defaultFile = "images/btn2.png",
		id = "button_2",
		onRelease = goGame2,
	}
	btnGame2.x = 3*_CENTERX/2
	btnGame2.y = 1.5*btnGameHeight

	group:insert(btnGame2)

	btnGame3 = widget.newButton
	{
		width = btnGameWidth,
		height = btnGameHeight,
		defaultFile = "images/btn3.png",
		id = "button_3",
		onRelease = goGame3,
	}
	btnGame3.x = _CENTERX/2
	btnGame3.y = 3*btnGameHeight

	group:insert(btnGame3)

	btnGame4 = widget.newButton
	{
		width = btnGameWidth,
		height = btnGameHeight,
		defaultFile = "images/btn4.png",
		id = "button_4",
		onRelease = goGame4,
	}
	btnGame4.x = 3*_CENTERX/2
	btnGame4.y = 3*btnGameHeight

	group:insert(btnGame4)
	---------------------------------------------------------------
----Score views
	---------------------------------------------------------------
	bgscore = display.newImage("images/bgscore.png", 0, 0, _W/4, _W/20)
	bgscore.width, bgscore.height = _W/5, _W/20
	bgscore.x = bgscore.width/2
	bgscore.y = bgscore.height/2
	group:insert(bgscore)

	totalScore = display.newText("Score: "..total, 0,0, native.systemFont, _H/24)
	totalScore.x = 2*totalScore.width/3
	totalScore.y = bgscore.y
	group:insert(totalScore)

	coins = display.newImage("images/coins.png", 0, 0, bgscore.height/2, bgscore.height/2)
	coins.width, coins.height = 2*bgscore.height/3, 2*bgscore.height/3
	coins.x = bgscore.width - 3*coins.width/4
	coins.y = bgscore.y
	group:insert(coins)
------------------------------------------------------------------------------
--End score views
------------------------------------------------------------------------------

	--audio.play( bgsound )
	admob.showAd( "interstitial" )
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	--audio.stop()

	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene