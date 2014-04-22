----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

require "sqlite3"
local path = system.pathForFile( "pullups.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
local ui = require("utils.ui")
local math = require( "math" )
local firstLaunch = true

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
--variables
local navBar, backBtn, statContainer, title, level, sets, dayN, background, startBtn, restWindow, timerHand, counter, plusBtn, tSets, totalSets, nowPushup, explain, currentDay, currentProgram, currentLevel, totalPushups--, timer
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local n = 1
local daysN, setsBg
local setsCount, totSets = 0, 0
local dayN = {}
local programs = {"program1", 'program2', 'program3', 'program4', 'program5', 'program6', 'program7', 'program8', 'program9', 'program10', 'program11', 'program12'}
local tempProgram
local numSeconds, seconds, numMinutes, timerText




local function backBtnRelease()
	storyboard.removeScene("scenes.training")
	storyboard.gotoScene("scenetemplate",  "slideRight", 800)
end



local function checkProgramLength()
	
	local sql = [[SELECT * from ]]..currentProgram..[[;]]
	for day in db:urows(sql) do 

		table.insert(dayN, day)
	end
	daysN = table.maxn(dayN)
	

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
local function checkVariables()
	totalPushups = dbCheck()
	currentDay = checkDay()
	tempProgram = checkProgram()
	currentProgram = "program"..tempProgram

	currentLevel = checkLevel()
	
	
end
-- перезагрузка сцены
local function reload()
	display.remove(setsBg)
	storyboard.reloadScene("scenes.training")
end 
-- ф-я кнопки стоп на таймере отдыха
local function stopTimer()
	display.remove(restWindow)
	display.remove(counter)
	display.remove(stopBtn)
	display.remove(plusBtn)
	display.remove(timerHand)
	timer.cancel(timer1)
	n = n+1
	system.setIdleTimer( true )
	reload()
end

-- ф-я +30 сек к таймеру
local function plusTime()
	numSeconds = numSeconds + 30

	numMinutes = math.floor(numSeconds / 60)
	seconds = numSeconds % 60

	if seconds < 10 then 
		seconds = 0 .. seconds
	end

	if numMinutes < 10 then
		numMinutes = 0 .. numMinutes
	end

	timerText = numMinutes .. ':' .. seconds

	counter.text = timerText
end

-- ф-я вызов таймера, возможно надо переделать на popup окно
local function rest()
	-- проверка выполнена тренировка или нет
	if setsCount == n then
		--тренировка выполнена

		local function onComplete( event )

			local action = event.action
			if "clicked" == event.action then
			    if 1 == event.index then
			    	storyboard.gotoScene( "scenetemplate", "slideRight", 800 )
			    	storyboard.removeScene("scenes.training")
		
			    end
			end
			
		end

		-- запись в базу переменной обновление total
		totalPushups = totalPushups + totSets
		local insertQuery = [[UPDATE statistic SET value = ']]..totalPushups..[[' WHERE name = 'total'; ]]
		db:exec( insertQuery )
		
		local updateLevel = [[UPDATE statistic SET value = ']]..currentLevel..[[' WHERE name = 'currentLevel'; ]]
		db:exec( updateLevel )
		--- программа пройдена
		if currentDay == tostring(daysN) then
			
			local programChange = "1"
			local updProgramChange = [[UPDATE statistic SET value = ']]..programChange..[[' WHERE name = 'programChange'; ]]
			db:exec( updProgramChange )
			local alert = native.showAlert( "Молодец!", "Ты прошел программу! Испытай себя и приступай к новой программе через 2 дня отдыха.", { "OK" }, onComplete )
		else
			currentDay = currentDay + 1
			local updateDay = [[UPDATE statistic SET value = ']]..currentDay..[[' WHERE name = 'currentDay'; ]]
			db:exec( updateDay )
			local alert = native.showAlert( "Молодец!", "Ты выполнил тренировку!", { "OK" }, onComplete )
		end
		


		
	else
		--тренировка не выполнена - таймер
		system.setIdleTimer( false )
		startBtn:setEnabled(false)
		backBtn:setEnabled(false)
		numSeconds = 120
		numMinutes = 0
		timerText = 0 .. numMinutes .. ':' .. numSeconds

		restWindow = display.newRect( centerX, centerY, 3*_W/4, 3*_H/4)
		restWindow:setFillColor( 0, 0, 0, 0.9 )
		restWindow.x = centerX
		restWindow.y = centerY
		restWindow.width = 0
		restWindow.height = 0
		restWindow.alpha = 0.5
		transition.to(restWindow, {time=500, width = _W, height = _H, alpha = 1})
		
		counter = display.newText( timerText, centerX, centerY, system.systemFontBold, 128 )
		counter:setFillColor( 1, 1, 1 )
		counter.alpha = 0
		transition.to(counter, {time=1000, alpha = 1})

		timerHand = display.newImage( "images/timerhand.png", centerX, 150, _W, _H)
		local arrow = display.newRect(timerHand.x, timerHand.y, timerHand.x + 10, 0)

		stopBtn = widget.newButton
		{
		    width = _W/2,
		    height = _W/6,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_1",
		    label = 'Стоп',
		    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		    font = native.systemFont,
		    fontSize = 56,
		    onRelease = stopTimer,
		}
		stopBtn.x = centerX
		stopBtn.y = 3*centerY/2
		stopBtn.alpha = 0
		transition.to(stopBtn, {time=1000, alpha = 1})

		plusBtn = widget.newButton
		{
		    width = _W/2,
		    height = _W/6,
		    defaultFile = "images/button.png",
		    overFile = "images/pbutton.png",
		    id = "button_1",
		    label = '+ 30 сек',
		    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		    font = native.systemFont,
		    fontSize = 56,
		    onRelease = plusTime,
		}
		plusBtn.x = centerX
		plusBtn.y = 3*centerY/2 - plusBtn.height
		plusBtn.alpha = 0
		transition.to(plusBtn, {time=1000, alpha = 1})
		
		function counter:timer( event )
			numSeconds = numSeconds - 1
			
			numMinutes = math.floor(numSeconds / 60)
			seconds = numSeconds % 60

			if seconds < 10 then
				seconds = 0 .. seconds
			end

			if numMinutes < 10 then
				numMinutes = 0 .. numMinutes
			end

			timerText = numMinutes .. ':' .. seconds

			counter.text = timerText

			if numSeconds == 0 then
				system.setIdleTimer( true )
				stopTimer()
			end
		end

		timer1 = timer.performWithDelay( 1000, counter, 0 )
	end
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	local lastScene = storyboard.getPrevious()
	print(lastScene)
	checkVariables()
	checkProgramLength()
	-- проверка текущий день тренировки и сама тренировка (пока для одной строки)- ТРЕБУЕТ ДОРАБОТКИ!!!
	local selectCurrent = [[SELECT * FROM ]]..currentProgram..[[ WHERE day = ']]..currentDay..[[';]]
	db:exec(selectCurrent)
	for id,level,day,sets in db:urows(selectCurrent) do 

		dayN = currentDay
		setsC = sets
		currentLevel = level
	end

	background = display.newImageRect( "images/background.jpg", centerX, centerY, _W, _H)
	background.x = centerX
	background.y = centerY
	background.width = _W
	background.height = _H
	group:insert( background )

	navBar = display.newImageRect("images/navBar.png", 0, 0, _W, _H)

	navBar.x = display.contentWidth*.5
	navBar.width = _W
	navBar.height = _H/8
	navBar.y = _H/16
	group:insert(navBar)




	title = display.newEmbossedText("День ".. dayN, centerX, 40, native.systemFont, _H/22)
	title.x = display.contentWidth*.5
	title.y = navBar.y
	group:insert( title )

	

	---------- перевод строки с сетами в массив и переменная длинны масива и общего количества подтягиваний
	tSets= {}
	for i in string.gmatch(setsC, "%S+") do
  	table.insert(tSets, i)
  	
	end
	--print(totSets)
	for i=1, #tSets do
		totSets = totSets + tSets[i]
		setsCount = i
	end
	
	statContainer = display.newImageRect( "images/blockhome.png", centerX, _H/2 + _H/3, _W, _H/2)
	statContainer:setFillColor( 27/255, 200/255, 237/255 )
	statContainer.x = centerX
	statContainer.y = 3*_H/4 + _H/20
	statContainer.width = _W - _W/20
	statContainer.height = _H/4

	group:insert(statContainer)

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end

function scene:willEnterScene( event )
	local group = self.view
	
	---------

end
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	print("n="..n)
	if tonumber(tempProgram) < 3 then
		if firstLaunch == true then
		storyboard.showOverlay("scenes.infopull", {time=1000, effect="fromTop", isModal = true })
		firstLaunch = false
	end
	end
	--Setup the back button
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
	
	local sheetData = {
	width = 300,
	height = 100,
	numFrames = 5,
	sheetContentWidth=300,
	sheetContentHeight=500
}
local setsSheet = graphics.newImageSheet("images/setsbg.png", sheetData)
	local sequenceData = {
		
		{
		name = "1",
		start = 1,
		count = 1,
		},
		{
		name = "2",
		start = 2,
		count = 1,
		},
		{
		name = "3",
		start = 3,
		count = 1,
		},
		{
		name = "4",
		start = 4,
		count = 1,
		},
		{
		name = "5",
		start = 5,
		count = 1,
		},

	}


	setsBg = display.newSprite(setsSheet, sequenceData)
	setsBg:setSequence(n)
	
	group:insert(setsBg)

	sets = display.newEmbossedText(setsC, centerX/2, centerY/3, native.systemFont, _H/24)
	sets.x = sets.width/2 + 10
	group:insert( sets )
	setsBg.width = sets.width + sets.width/10
	setsBg.height = sets.height
	setsBg.x = sets.width/2 + 10
	setsBg.y = centerY/3 + sets.height/2
	totalSets = display.newEmbossedText("Всего " .. totSets, 3*centerX/2, centerY/3, native.systemFont, _H/24)
	group:insert( totalSets )
	nowPushup = display.newEmbossedText("Cейчас нужно подтянуться:", centerX, centerY/2, native.systemFont, _H/24)
	group:insert( nowPushup )
	explain = display.newEmbossedText("Подтянитесь необходимое количество раз и нажмите на кнопку. Отдыхайте между подходами необходимое время.", centerX, 4*centerY/3 + _W/6, _W - _W/10, 0, native.systemFont, _H/36)
	explain.align = center
	explain.x = centerX
	--explain.y = 5*centerY/3 

	group:insert( explain )

	startBtn = widget.newButton
		{
		    width = _H/3,
		    height = _H/3,
		    defaultFile = "images/timer.png",
		    overFile = "images/ptimer.png",
		    id = "button_1",
		    label = tSets[n],
		    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		    font = native.systemFont,
		    fontSize = 126,
		    isEnabled = true,
		    onRelease = rest,
		    
		}
		
	startBtn.x = centerX
	startBtn.y = centerY
	group:insert( startBtn )

	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
	---------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
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

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene