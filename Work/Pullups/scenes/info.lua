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
local textVar = "1. Сделайте тест. Он позволит вам выбрать соответствующий тренировочный цикл. \n 2. На основании теста вы выбираете цикл, из которого начнется тренировка. \n 3. Выполняйте тренировку согласно рекомендаций данного цикла. Помните, чтобы между тренировками делать минимум один день перерыва, а после 3 дней – паузу как минимум на 2 дня. \n 4. Если во время цикла вы не смогли выполнить цикл упражнений данного дня – сделайте перерыв на 2-3 дня и начните цикл сначала.\n 5. Когда вы удачно завершите данный цикл – сделайте перерыв для восстановления перед тем, как приступить к повторному тесту. Такой перерыв не должен длиться меньше 2 дней.\n 6. После перерыва выполните тест. Помните, что перед тестом нужно немного размяться, а после него – сделать паузу для восстановления (минимум 2 дня). Тест покажет вам – какой цикл выбрать дальше. \n 7. После перерыва начните выполнение следующего цикла.\n 8. Повторяйте эту схему пока не перейдете к последнему циклу – 25-30 подтягиваний. Теперь вы находитесь в хорошей форме. Можете попробовать тренироваться дальше, чтобы достичь 50-ти, но уровень в 30 подтягиваний достаточен для поддерживания хорошего физического состояния и красивой мускулатуры.\n 9. После правильного выполнения последнего тренировочного цикла снова сделайте перерыв, отдохните и снова пройдите тест. Теперь вы вполне можете выполнить 50 подтягиваний. Если вы пока не смогли сделать этого – ничего страшного. Повторите последний тренировочный цикл и попробуйте снова."
local function exit()
	storyboard.hideOverlay( 500, "slideUp" )
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	
	local group = self.view

	background = display.newRect(centerX, centerY, _W - _W/8, _H - _H/8)
	background:setFillColor(0, 0, 0, 0.9)
	group:insert(background)

	text = display.newEmbossedText("Правила", centerX, _H/8, native.systemFont, _H/24 )
	text:setFillColor(1, 1, 1)
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
	textIn = display.newEmbossedText(textVar, centerX, 0, _W -_W/6, 0, native.systemFont, _H/36)
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
