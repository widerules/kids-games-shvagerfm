-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
require "sqlite3"
local path = system.pathForFile( "pullups.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )
local storyboard = require( "storyboard" )
storyboard.purgeOnSceneChange = true
local scene = storyboard.newScene()
local widget = require( "widget" )
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------

-- forward declarations and other locals
local background, title, navBar, textDescr, currentProgram, tempProgram, currentDay, goToListBtn, nextProgram, reloadProgram, bgOverlay, backBtn
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
---выход
local function exit()
	storyboard.gotoScene("scenetemplate", 500, "slideRight" )
end
---
local function backBtnRelease()
	storyboard.removeScene("scenes.programchange")
	storyboard.gotoScene("scenetemplate",  "slideRight", 800)
end
-- установка дня в базу текущий день =1 (начало следующей тренировки)
local function setDay()
currentDay = 1
local updateDay = [[UPDATE statistic SET value = ']]..currentDay..[[' WHERE name = 'currentDay'; ]]
db:exec( updateDay )
end

--проверка текущей программы из базы
local function checkProgram()
	local sql = [[SELECT value FROM statistic WHERE name='currentProgram';]]
	for row in db:nrows(sql) do
		return row.value
	end
end
--- установка значения текущей программы
currentProgram = checkProgram()
print("currProgram"..currentProgram)
--- установка флага на необходимость изменения программы в 0 и установка дня в 1
local function reProgramChange()
		setDay()
		local programChange = "0"
		local updProgramChange = [[UPDATE statistic SET value = ']]..programChange..[[' WHERE name = 'programChange'; ]]
		db:exec( updProgramChange )
	end

---переход на следующую программу
local function goToNextTraining()
			reProgramChange()
			----------------------
			currentProgram = currentProgram + 1
			local updateProgram = [[UPDATE statistic SET value = ']]..currentProgram..[[' WHERE name = 'currentProgram'; ]]
			db:exec( updateProgram )
			---------------------------------
			storyboard.gotoScene( "scenes.training", "slideLeft", 800 )
end

---повтор текущей программы
local function loadProgramAgain()
		reProgramChange()
		--------------------------
		storyboard.gotoScene( "scenes.training", "slideLeft", 800 )
	end

---дополнительная ф-я выбор программы из списка
local function goToList()
	reProgramChange()
	storyboard.gotoScene( "scenes.firsttest", "slideLeft", 800 )
end

--значения программ
local namesPrograms = {"< 4", "4-5", "6-8", "9-11", "12-15", "16-20", "21-25", "26-30", "31-35", "36-40", "более 40"}


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local lblNextProgram = namesPrograms[currentProgram + 1].." подтягиваний"
	local lblReloadProgram = namesPrograms[tonumber(currentProgram)].." подтягиваний"
	print(currentProgram)
	print(lblNextProgram)
	print(lblreloadProgram)
	local group = self.view
	setDay()
	background = display.newImageRect("images/background.jpg", centerX, centerY, _W, _H)
	background.x = centerX
	background.y = centerY
	background.width = _W
	background.height = _H
	--background:setFillColor(0, 0, 0, 0.9)
	group:insert(background)
	bgOverlay = display.newRect(centerX, centerY, _W, _H)
	bgOverlay:setFillColor( 0, 0, 0, 0.8 )
	group:insert(bgOverlay)

	navBar = display.newImageRect("images/navBar.png", 0, 0, _W, _H)

	navBar.x = display.contentWidth*.5
	navBar.width = _W
	navBar.height = _H/8
	navBar.y = _H/16
	group:insert(navBar)

	backBtn = widget.newButton{ 
	defaultFile = "images/backButton.png", 
	overFile = "images/backButton_over.png", 
	onRelease = backBtnRelease,
	isEnabled = true,
	}
	backBtn.width = _W/6
	backBtn.height = _H/16
	backBtn.x = backBtn.width
	backBtn.y = navBar.y
	group:insert(backBtn)

	title = display.newEmbossedText("Внимание!", centerX, 40, native.systemFont, _H/22)
	title.x = display.contentWidth*.5
	title.y = navBar.y
	group:insert( title )
	--text = display.newEmbossedText("Внимание!", centerX, _H/8, native.systemFont, _H/24 )
	--group:insert(text)
	
	textDescr = display.newEmbossedText("Определив текущий уровень вашей подготовки выберите подходящий Вам вариант", centerX, _H/8, _W - 10, _H/3, native.systemFont, _H/32 )
	textDescr.y = _H/3
	textDescr.x = centerX
	group:insert(textDescr)

	nextProgram = widget.newButton
		{
			top = _H/3,
		    width = 3*_W/4,
		    height = _W/4,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_1",
		    label = "Следующая тренировка\n"..lblNextProgram,
		    fontSize = _H/32,
		    onRelease = goToNextTraining,
		    
		}
	nextProgram.x = centerX
	group:insert(nextProgram)

	reloadProgram = widget.newButton
		{
			top = _H/2,
		    width = 3*_W/4,
		    height = _W/4,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_2",
		    label = "Повторить тренировку\n"..lblReloadProgram,
		    fontSize = _H/32,
		    onRelease = loadProgramAgain,
		    
		}
	reloadProgram.x = centerX 
	group:insert(reloadProgram)

	goToListBtn = widget.newButton
		{
			top = 2*_H/3,
		    width = 3*_W/4,
		    height = _W/4,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_3",
		    label = "Выбрать из списка",
		    fontSize = _H/32,
		    onRelease = goToList,
		    
		}
	goToListBtn.x = centerX 
	group:insert(goToListBtn)
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
