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
local tableView = require("utils.tableView")
local ui = require("utils.ui")

display.setStatusBar( display.HiddenStatusBar ) 

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------
--variables
local background, textCenter, myList
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight
local data = {}
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight
local navBar, navHeader, backBtn
local topBoundary = display.screenOriginY
local bottomBoundary = display.screenOriginY 
local myList

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local function checkProgram()
	local sql = [[SELECT value FROM statistic WHERE name='currentProgram';]]
	for row in db:nrows(sql) do
		return row.value
	end
end
local function checkProgramExist()
	tempProgram = tonumber(checkProgram())
	print("tp"..tempProgram)
	
end



local function listButtonRelease(event)
	self = event.target
	local id = self.id
	print(data[id].program)
	local function setProgram()
	local sql = [[UPDATE statistic SET value = ']]..data[id].program..[[' WHERE name = 'currentProgram']]
	db:exec( sql )
end
	setProgram()
	local sql2 = [[UPDATE statistic SET value = '1' WHERE name = 'currentDay']]
	db:exec( sql2 )
	checkProgramExist()
	local function goTraining()
	storyboard.removeScene("scenes.firsttest")
	storyboard.gotoScene("scenes.training",  "slideLeft", 800)
	end	
	
	if tostring(tempProgram) == tostring(data[id].program) then
		goTraining()
	end	
end

local function backBtnRelease()
	storyboard.gotoScene("scenetemplate",  "slideRight", 800)
end
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
		
	background = display.newImageRect( "images/background.jpg", centerX, centerY, _W, _H)
	background.x = centerX
	background.y = centerY
	background.width = _W
	background.height = _H
	group:insert( background )

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

data[1] = {}
data[1].title = "Программа 1"
data[1].subtitle = "Подтягиваетесь < 4 раз ?"
data[1].program = "1"

data[2] = {}
data[2].title = "Программа 2"
data[2].subtitle = "Подтягиваетесь 4-5 раз?"
data[2].program = "2"
	
data[3] = {}
data[3].title = "Программа 3"
data[3].subtitle = "Подтягиваетесь 6-8 раз?"
data[3].program = "3"

data[4] = {}
data[4].title = "Программа 4"
data[4].subtitle = "Подтягиваетесь 9-11 раз?"
data[4].program = "4"

data[5] = {}
data[5].title = "Программа 5"
data[5].subtitle = "Подтягиваетесь 12-15 раз?"
data[5].program = "5"

data[6] = {}
data[6].title = "Программа 6"
data[6].subtitle = "Подтягиваетесь 16-20 раз?"
data[6].program = "6"

data[7] = {}
data[7].title = "Программа 7"
data[7].subtitle = "Подтягиваетесь 21-25 раз?"
data[7].program = "7"

data[8] = {}
data[8].title = "Программа 8"
data[8].subtitle = "Подтягиваетесь 26-30 раз?"
data[8].program = "8"

data[9] = {}
data[9].title = "Программа 9"
data[9].subtitle = "Подтягиваетесь 31-35 раз?"
data[9].program = "9"

data[10] = {}
data[10].title = "Программа 10"
data[10].subtitle = "Подтягиваетесь 36-40 раз?"
data[10].program = "10"

data[11] = {}
data[11].title = "Программа 11"
data[11].subtitle = "Подтягиваетесь более 40 раз?"	
data[11].program = "11"
---------------------------------------
---------------------------------------

local myList = tableView.newList{
data=data,
default="images/listItemBg.png",
over="images/listItemBg_over.png",
onRelease=listButtonRelease,

--backgroundColor={1, 1, 1},
top=_H/6 + _H/16,
bottom=bottomBoundary,

callback = function( row )


local g = display.newGroup()

local title = display.newText( row.title, 0, 0, native.systemFontBold, _H/24 )
title:setFillColor(0,0,0)
g:insert(title)
title.x = title.width*0.5 + _W/8
title.y = 0 - title.height/2

local subtitle = display.newText( row.subtitle, 0, 0, native.systemFont, _H/32 )
subtitle:setFillColor(80/255,80/255,80/255)
g:insert(subtitle)
subtitle.x = subtitle.width*0.5 + _W/20
subtitle.y = title.y + title.height 


return g

end
}


group:insert(myList)

	navBar = ui.newButton{
	default = "images/navBar.png",
	
}
navBar.x = display.contentWidth*.5

navBar.width = _W
navBar.height = _H/8
navBar.y = _H/16
group:insert(navBar)


--Setup the back button
backBtn = ui.newButton{ 
	default = "images/backButton.png", 
	over = "images/backButton_over.png", 
	onRelease = backBtnRelease
}
backBtn.width = _W/6
backBtn.height = _H/16
backBtn.x = backBtn.width
backBtn.y = navBar.y
--backBtn.alpha = 0
group:insert(backBtn)


navHeader = display.newText("Выберите программу", 0, 0, native.systemFontBold, _H/24)
navHeader:setFillColor(1, 1, 1)
navHeader.x = display.contentWidth*.5 + backBtn.width
navHeader.y = navBar.y
group:insert(navHeader)
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
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