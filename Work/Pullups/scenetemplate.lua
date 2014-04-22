----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------
require "sqlite3"
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
local admob = require( "utils.admob" )

local path = system.pathForFile( "pullups.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
--variables
local lblCurrentProgram, playerMedal, playerStatus, exitBtn, infoBtn, clearBtn, startBtn, statContainer, background, medal, total, currentDay, currentProgram, currentLevel, programChange, progressView
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local progressView = nil

--таблицы картинок медалей и статусов
local medals = {"null.png", "newguy.png", "sporty.png", "turnik.png", "strong.png", "super.png"}
local yourStatus = {"Нет", "Новичок", "Спортсмен", "Турникмен", "Силач", "Супермен"}

--значения программ
local namesPrograms = {"< 4", "4-5", "6-8", "9-11", "12-15", "16-20", "21-25", "26-30", "31-35", "36-40", "более 40"}

--local total = 1
local tempTable = {}
--local tablesetup = [[CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY autoincrement, name, value);]]
--db:exec( tablesetup )
local tablesetup1 = [[CREATE TABLE IF NOT EXISTS statistic (id INTEGER PRIMARY KEY autoincrement, name, value);]]
db:exec( tablesetup1 )

local function exitYes()
	db:close()
	native.requestExit()
end

local function setProgress()
	local program, day, totalDays, query, percent
	
	if currentProgram ~= "0" then
		program = "program" .. currentProgram

		day = currentDay
		query = [[SELECT COUNT(*) AS count FROM ]] .. program

		for row in db:nrows(query) do
			totalDays = row.count
			print ('tttt ' .. totalDays)	
		end

		percent = day / totalDays

		progressView:setProgress(percent)
	end
end

local function exit ()
	local function onComplete( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
                exitYes()
        elseif 2 == i then

        end
    end
	end
	local alert = native.showAlert( "Выход", "Вы действительно хотите выйти?", { "OK", "Нет" },  onComplete)
	 
end


local function onSystemEvent( event )
if event.type == "applicationExit" then
	db:close()
end
end

local function clearTotal()

	local function onComplete( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
        	display.remove(score)
		display.remove(displayLevel)
		display.remove(displayTraining)
		display.remove(statContainer)
		if currentProgram ~= "0" then
		display.remove(progressView)
		end
		display.remove(playerMedal)
		display.remove(playerStatus)
			local insertQuery = [[UPDATE statistic SET value = '0'; ]]
			db:exec( insertQuery )
            storyboard.reloadScene()
        elseif 2 == i then

        end
    end
	end
	local alert = native.showAlert( "Очистка", "Вы действительно хотите удалить статистику?", { "OK", "Нет" },  onComplete)
			
		
end
local function dbCheck()
	local sql = [[SELECT value FROM statistic WHERE name='total';]]
	for row in db:nrows(sql) do
		return row.value
	end
	
end
local function checkProgram()
	local sql = [[SELECT value FROM statistic WHERE name='currentProgram';]]
	for row in db:nrows(sql) do
		return row.value
	end
end
local function checkDay()
	local sql2 = [[SELECT value FROM statistic WHERE name='currentDay';]]
	for row in db:nrows(sql2) do
		return row.value
	end
end
local function checkLevel()
	local sql = [[SELECT value FROM statistic WHERE name='currentLevel';]]
	for row in db:nrows(sql) do
		return row.value
	end
end
local function checkProgramChange()
	local sql = [[SELECT value FROM statistic WHERE name='programChange';]]
	for row in db:nrows(sql) do
		return row.value
	end
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local function testOverlay()
	storyboard.showOverlay("scenes.info", {time=1000, effect="fromTop", isModal = true })
end


local function goToTraining()
	print(total)
	if currentProgram == "0" then
		display.remove(score)
		display.remove(displayLevel)
		display.remove(displayTraining)
		storyboard.removeScene("scenetemplate")
		storyboard.gotoScene( "scenes.firsttest", "slideLeft", 800 )
	else
		if programChange == "0" then
			print("checkProgram = 0")
			display.remove(score)
			display.remove(displayLevel)
			display.remove(displayTraining)
			display.remove(statContainer)
			storyboard.removeScene("scenetemplate")
			storyboard.gotoScene( "scenes.training", "slideLeft", 800 )
		else
			print("checkProgram = 1")
					
					storyboard.gotoScene("scenes.programchange", {time=500, effect="slideLeft"})

			end
	end
end
local function checkVariables()
	total = dbCheck()
	currentDay = checkDay()
	currentProgram = checkProgram()
	--
		if tonumber(currentProgram) < 1 then
		lblCurrentProgram = "Нет"
	else
		lblCurrentProgram = namesPrograms[tonumber(currentProgram)].." подтягиваний"
	end
	--
	currentLevel = checkLevel()
	programChange = checkProgramChange()

	print("programChange"..programChange)
	-- проверка если запись total в базе есть то присваиваем переменной "total" значение, если нету то записываем total со значением 0
	if total== nil then 
		print('total is not here')
		local insertQuery = [[INSERT INTO statistic VALUES (NULL, 'total', '0'); ]]
		db:exec( insertQuery )
	else
		print('total exists')
		-- total = dbCheck()
	end
	-- проверка текущего дня
	if currentDay == nil then
		print('Training not Started')
		local insertDay = [[INSERT INTO statistic VALUES (NULL, 'currentDay', '0'); ]]
		db:exec( insertDay )
	else
		print('Day is exists')
		print('Current Day'..currentDay)
	end
	-- проверка текущей программы
	if currentProgram == nil then
		print('CurrProgram is not set')
		local insertProgram = [[INSERT INTO statistic VALUES (NULL, 'currentProgram', '0'); ]]
		db:exec(insertProgram)
	else
		print('Program is '..currentProgram)
	end
	-- проверка уровня
	if currentLevel == nil then
		print('CurrLevel is not set')
		local insertLevel = [[INSERT INTO statistic VALUES (NULL, 'currentLevel', '0'); ]]
		db:exec(insertLevel)
	else
		print('Level is '..currentLevel)
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	admob.init()

	background = display.newImageRect( "images/background1.jpg", centerX, centerY, _W, _H)
	--background:setFillColor( 0.85, 0.85, 0.85 )
	background.x = centerX
	background.y = centerY
	background.width = _W
	background.height = _H
	group:insert( background )

	
end
function scene:willEnterScene( event )
	local group = self.view
	
	---------

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	checkVariables()

	admob.showAd( "interstitial" )

	local levelTemp
	if tonumber(currentLevel) < 1 then 
		levelTemp = 1
			elseif tonumber(currentLevel) < 10 then
				levelTemp =2
			elseif tonumber(currentLevel) < 20 then
				levelTemp = 3
			elseif tonumber(currentLevel) < 30 then
				levelTemp = 4
			elseif tonumber(currentLevel) < 40 then
				levelTemp = 5
			else
				levelTemp = 6
	end


	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	clearBtn = widget.newButton
		{
		    width = _W/8,
		    height = _W/8,
		    defaultFile = "images/delete.png",
		    overFile = "images/delete.png",
		    id = "button_1",
		    onRelease = clearTotal,
		    
		}
	clearBtn.x = _W/10
	clearBtn.y = _H/10

	infoBtn = widget.newButton
		{
		    width = _W/8,
		    height = _W/8,
		    defaultFile = "images/info.png",
		    overFile = "images/info.png",
		    id = "button_1",
		    onRelease = testOverlay,
		    
		}
	infoBtn.x = _W - _W/4
	infoBtn.y = _H/10

	exitBtn = widget.newButton
		{	
			--top = display.contentHeight/3,
		    width = _W/8,
		    height = _W/8,
		    defaultFile = "images/exit.png",
		    overFile = "images/exit.png",
		    id = "button_2",
		    onRelease = exit,
		    
		}
	exitBtn.x = _W - _W/10
	exitBtn.y = _H/10
	

	startBtn = widget.newButton
		{
			top = centerY/2,
		    width = _W/2,
		    height = _W/2,
		    defaultFile = "images/timer.png",
		    overFile = "images/ptimer.png",
		    id = "button_3",
		    label = "Старт",
		    fontSize = _W/10,
		    onRelease = goToTraining,
		    
		}
	startBtn.x = centerX

	statContainer = display.newImageRect( "images/blockhome.png", centerX, _H/2 + _H/3, _W, _H/2)
	statContainer:setFillColor( 27/255, 200/255, 237/255 )
	statContainer.x = centerX
	statContainer.y = 3*_H/4 + _H/20
	statContainer.width = _W - _W/20
	statContainer.height = _H/3

	
	-- медаль
	playerMedal = display.newImage( "images/"..medals[levelTemp],centerX/3, _H/2 + _H/5 +_H/32 )
	playerMedal.width = _W/4
	playerMedal.height = _W/4

	score = display.newEmbossedText("Всего подтянулся: ".. total, centerX + centerX/4, _H/2 + _H/6, native.systemFont, _H/32)
	displayLevel = display.newEmbossedText("Уровень: "..currentLevel, centerX + centerX/4, _H/2 + _H/6 + _H/24, native.systemFont, _H/32)
	playerStatus = display.newEmbossedText( "Статус: "..yourStatus[levelTemp], centerX + centerX/4, _H/2 + _H/6 + _H/12, native.systemFont, _H/32 )
	displayTraining = display.newEmbossedText("Текущая тренировка:\nПрограмма "..lblCurrentProgram.."; День "..currentDay, centerX, _H/2 + _H/3 +_H/24, _W - _W/8, 200, native.systemFont, _H/32)
	
	group:insert( clearBtn )
	group:insert( infoBtn )
	group:insert( exitBtn )
	group:insert( startBtn )
	group:insert( statContainer )
	group:insert( playerMedal )
	group:insert(playerStatus)
	group:insert(score)
	group:insert(displayLevel)
	group:insert(displayTraining)

	-- Узнать общее количество дней в программе
	-- Узнать текущий дней
	-- Получить процентное соотношение

	
	if currentProgram ~= "0" then
		progressView = widget.newProgressView
		{
		    left = 60,
		    top = _H - 60,
		    width = _W - 120,
		    isAnimated = true
		}
		group:insert(progressView)
		setProgress()
	end
end

function scene:willExitScene( event )
	local group = self.view
	storyboard.removeAll()
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	storyboard.purgeAll()
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
scene:addEventListener( "willEnterScene", scene )
-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "willExitScene", scene )
-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
Runtime:addEventListener( "system", onSystemEvent )

---------------------------------------------------------------------------------

return scene