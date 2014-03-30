----------------------------------------------------------------------------------
--      Game1 Title
--      Scene notes
---------------------------------------------------------------------------------
require "sqlite3"
local path = system.pathForFile( "colorskids.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

local storyboard = require("storyboard")
local widget = require("widget")
local constants = require ("constants")


local scene = storyboard.newScene()


local background, title, titlePic
----------------------------------------------------------------------------------
local function goNextGame()
	storyboard.gotoScene( "scenes.gametitle2", "slideLeft", 500)
	--storyboard.removeAll( )
end

local function play()
	storyboard.gotoScene( "scenes.game1", "fade", 100 )
end

local function startDrag(event)
			local swipeLength = math.abs(event.x - event.xStart) 
			print(event.phase, swipeLength)
			local t = event.target
			local phase = event.phase
			if "began" == phase then
				return true
			elseif "moved" == phase then
			elseif "ended" == phase or "cancelled" == phase then
				if event.xStart > event.x and swipeLength > 50 then 
					goNextGame()
		        elseif event.xStart < event.x and swipeLength > 50 then 
		            print( "Swiped Right" )
				end	
			end
		end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
        local group = self.view
background = display.newImage("images/background1.png", constants.CENTERX, constants.CENTERY, constants.W, constants.H)
group:insert( background )

titlePic = display.newImage("images/game1/titlepic.png", 0, constants.CENTERY, constants.W/2, 3*constants.W/8)
titlePic.x = 0.7*titlePic.width
group:insert(titlePic)

title = display.newImage( "images/game1/title.png",  0, 0, constants.W/4, constants.W/12)
title.y = title.height
title.x = constants.W - title.width
group:insert(title)

btnPlay = widget.newButton
	{
		width = constants.W/3,
		height = constants.W/6,
		defaultFile = "images/game1/btnPlay.png",
		overFile = "images/game1/btnPlayOver.png",
		id = "button_1",
		onRelease = play,
	}
btnPlay.x = 0.7*constants.W
btnPlay.y = constants.CENTERY
group:insert(btnPlay)
leftArrow = widget.newButton
	{
		width = constants.W/12,
		height = constants.W/4,
		defaultFile = "images/game1/leftarrow.png",
		id = "button_2",
		--onRelease = goGame2,
	}
leftArrow.x =  leftArrow.width/2
leftArrow.y = constants.CENTERY

rightArrow = widget.newButton
	{
		width = constants.W/12,
		height = constants.W/4,
		defaultFile = "images/game1/rightarrow.png",
		id = "button_3",
		onRelease = goNextGame,
	}
rightArrow.x = constants.W - rightArrow.width/2
rightArrow.y = constants.CENTERY
group:insert(leftArrow)
group:insert(rightArrow)
end


-- Called BEFORE scene has moved onscreen:
function scene:willEnterScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
        local group = self.view
        background:addEventListener("touch", startDrag)
        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. start timers, load audio, start listeners, etc.)

        -----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

        -----------------------------------------------------------------------------

end


-- Called AFTER scene has finished moving offscreen:
function scene:didExitScene( event )
        local group = self.view

        -----------------------------------------------------------------------------

        --      This event requires build 2012.782 or later.

        -----------------------------------------------------------------------------

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
        local group = self.view
        background:removeEventListener("touch", startDrag )
        -----------------------------------------------------------------------------

        --      INSERT code here (e.g. remove listeners, widgets, save state, etc.)

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is displayed via storyboard.showOverlay()
function scene:overlayBegan( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end


-- Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
function scene:overlayEnded( event )
        local group = self.view
        local overlay_name = event.sceneName  -- name of the overlay scene

        -----------------------------------------------------------------------------

        --      This event requires build 2012.797 or later.

        -----------------------------------------------------------------------------

end



---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "willEnterScene" event is dispatched before scene transition begins
scene:addEventListener( "willEnterScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "didExitScene" event is dispatched after scene has finished transitioning out
scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-- "overlayBegan" event is dispatched when an overlay scene is shown
scene:addEventListener( "overlayBegan", scene )

-- "overlayEnded" event is dispatched when an overlay scene is hidden/removed
scene:addEventListener( "overlayEnded", scene )

---------------------------------------------------------------------------------

return scene
    