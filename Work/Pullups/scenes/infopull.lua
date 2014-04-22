-----------------------------------------------------------------------------------------
--
-- page1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
storyboard.purgeOnSceneChange = true
local scene = storyboard.newScene()
local widget = require( "widget" )
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- forward declarations and other locals
local background, text, closeIt, textPlain, textIn
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local trainText = "Эта тренировка состоит из опусканий. \n Вместо того, чтобы подтягиваться наверх вы становитесь на табурет так, чтобы зависнуть на перекладине так, как при полном подтягивании, то есть, с подбородком на высоте перекладины.\n Далее вы сходите с табурета и медленно опускаетесь, пока руки не распрямятся."
local function exit()
	storyboard.hideOverlay( 500, "slideUp" )
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	
	local group = self.view

	background = display.newRect(centerX, centerY, _W - _W/8, _H - _H/8)
	background:setFillColor(0, 0, 0, 0.9)
	group:insert(background)

	text = display.newEmbossedText("Внимание!", centerX, _H/8, native.systemFont, _H/24 )
	group:insert(text)
	textPlain = widget.newScrollView
	{
	top = _W/8, 
	left = _H/8 + _H/24, 
	width =_W ,
	height = _H - _H/6 -_H/24,
    scrollHeight = _H -_H/8 -_H/24,
    hideBackground = true,
    horizontalScrollDisabled = true
	}
	textPlain.x = centerX
	textPlain.y = centerY + _H/24
	textPlain.width = _W - _W/8
	group:insert(textPlain)
	textIn = display.newEmbossedText(trainText, centerX, 0, _W -_W/6, 0, native.systemFont, _H/36)
	textIn.width = _W - _W/6
	textIn.x = centerX
	textIn.y = textIn.height/2
	--textIn.height = textPlain.height

	textPlain:insert(textIn)
	closeIt = widget.newButton
	{
			 width = _W/8,
		    height = _W/8,
		    defaultFile = "images/exit.png",
		    overFile = "images/exit.png",
		    id = "button_2",
		    onRelease = exit,
	}
	closeIt.x = _W - _W/10
	closeIt.y = _H/10
	group:insert(closeIt)
end
	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	--удаляем листенер
	

	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc.)
	
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
