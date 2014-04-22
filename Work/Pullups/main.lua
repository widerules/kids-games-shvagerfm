-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
require "sqlite3"
local storyboard = require "storyboard"

local path = system.pathForFile( "pullups.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )
local total
-- load scenetemplate.lua
local function exitYes()
	db:close()
	native.requestExit()
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

local function onKeyEvent( event )

   local phase = event.phase
   local keyName = event.keyName
   print( event.phase, event.keyName )

   if ( "back" == keyName and phase == "up" ) then
     local lastScene = storyboard.getPrevious()
            print( "previous scene", lastScene )
            local currentScene = storyboard.getCurrentSceneName()
            if ( lastScene == "scenetemplate" ) then
            	--storyboard.removeScene(currentScene)
               storyboard.gotoScene( "scenetemplate", { effect="crossFade", time=500 } )
            elseif (lastScene == "scenes.firsttest") then
            	storyboard.gotoScene( "scenetemplate", { effect="crossFade", time=500 } )
            else
               exit()
            end
   
   end
   return true  --SEE NOTE BELOW
end
Runtime:addEventListener( "key", onKeyEvent )


-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):
local tablesetup1 = [[CREATE TABLE IF NOT EXISTS statistic (id INTEGER PRIMARY KEY autoincrement, name, value);]]
db:exec( tablesetup1 )
local tablesetup2 = [[CREATE TABLE IF NOT EXISTS program1 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup2 )
local tablesetup3 = [[CREATE TABLE IF NOT EXISTS program2 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup3 )
local tablesetup4 = [[CREATE TABLE IF NOT EXISTS program3 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup4 )
local tablesetup5 = [[CREATE TABLE IF NOT EXISTS program4 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup5 )
local tablesetup6 = [[CREATE TABLE IF NOT EXISTS program5 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup6 )
local tablesetup7 = [[CREATE TABLE IF NOT EXISTS program6 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup7 )
local tablesetup8 = [[CREATE TABLE IF NOT EXISTS program7 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup8 )
local tablesetup9 = [[CREATE TABLE IF NOT EXISTS program8 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup9 )
local tablesetup10 = [[CREATE TABLE IF NOT EXISTS program9 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup10 )
local tablesetup11 = [[CREATE TABLE IF NOT EXISTS program10 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup11 )
local tablesetup12 = [[CREATE TABLE IF NOT EXISTS program11 (id INTEGER PRIMARY KEY autoincrement, level, day, sets);]]
db:exec( tablesetup12 )


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
	
	local currentDay = checkDay()
	local currentProgram = checkProgram()
	local currentLevel = checkLevel()
	local programChange = checkProgramChange()

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
	if programChange == nil then
		print('programChange is not')
		local insertProgramChange = [[INSERT INTO statistic VALUES (NULL, 'programChange', '0'); ]]
		db:exec(insertProgramChange)
	else
		print('Program cahnge is '..programChange)
	end

total = dbCheck()
if total== nil then 
		print('total is not here')
		local insertQuery = [[INSERT INTO statistic VALUES (NULL, 'total', '0'); ]]
		db:exec( insertQuery )
		local insertProgram1 = [[
INSERT INTO program1 VALUES (NULL, '1', '1', '2 7 5 5 7');
INSERT INTO program1 VALUES (NULL, '1', '2', '3 8 6 6 8');
INSERT INTO program1 VALUES (NULL, '2', '3', '4 9 6 6 8');
INSERT INTO program1 VALUES (NULL, '2', '4', '5 8 7 7 9');
INSERT INTO program1 VALUES (NULL, '3', '5', '5 10 8 8 10');
INSERT INTO program1 VALUES (NULL, '3', '6', '6 10 8 8 11');
]]
db:exec( insertProgram1 )

local insertProgram2 = [[
INSERT INTO program2 VALUES (NULL, '4', '1', '4 9 6 6 9');
INSERT INTO program2 VALUES (NULL, '4', '2', '5 9 7 7 9');
INSERT INTO program2 VALUES (NULL, '4', '3', '6 10 8 8 10');
INSERT INTO program2 VALUES (NULL, '5', '4', '6 11 8 8 11');
INSERT INTO program2 VALUES (NULL, '5', '5', '7 12 10 10 12');
INSERT INTO program2 VALUES (NULL, '5', '6', '8 14 11 11 14');
]]
db:exec( insertProgram2 )

local insertProgram3 = [[
INSERT INTO program3 VALUES (NULL, '6', '1', '2 3 2 2 3');
INSERT INTO program3 VALUES (NULL, '6', '2', '2 3 2 2 4');
INSERT INTO program3 VALUES (NULL, '7', '3', '3 4 2 2 4');
INSERT INTO program3 VALUES (NULL, '7', '4', '3 4 3 3 4');
INSERT INTO program3 VALUES (NULL, '8', '5', '3 4 3 3 5');
INSERT INTO program3 VALUES (NULL, '8', '6', '4 5 4 4 6');
]]
db:exec( insertProgram3 )

local insertProgram4 = [[
INSERT INTO program4 VALUES (NULL, '9', '1', '3 5 3 3 5');
INSERT INTO program4 VALUES (NULL, '9', '2', '4 6 4 4 6');
INSERT INTO program4 VALUES (NULL, '10', '3', '5 7 5 5 6');
INSERT INTO program4 VALUES (NULL, '10', '4', '5 8 5 5 8');
INSERT INTO program4 VALUES (NULL, '11', '5', '6 9 6 6 8');
INSERT INTO program4 VALUES (NULL, '11', '6', '6 9 6 6 10');
]]
db:exec( insertProgram4 )

local insertProgram5 = [[
INSERT INTO program5 VALUES (NULL, '12', '1', '6 8 6 6 8');
INSERT INTO program5 VALUES (NULL, '12', '2', '6 9 6 6 9');
INSERT INTO program5 VALUES (NULL, '13', '3', '7 10 6 6 9');
INSERT INTO program5 VALUES (NULL, '13', '4', '7 10 7 7 10');
INSERT INTO program5 VALUES (NULL, '14', '5', '8 11 8 8 10');
INSERT INTO program5 VALUES (NULL, '15', '6', '9 11 9 9 11');
]]
db:exec( insertProgram5 )

local insertProgram6 = [[
INSERT INTO program6 VALUES (NULL, '16', '1', '8 11 8 8 10');
INSERT INTO program6 VALUES (NULL, '16', '2', '9 12 9 9 11');
INSERT INTO program6 VALUES (NULL, '17', '3', '9 13 9 9 12');
INSERT INTO program6 VALUES (NULL, '17', '4', '10 14 10 10 13');
INSERT INTO program6 VALUES (NULL, '18', '5', '11 15 10 10 13');
INSERT INTO program6 VALUES (NULL, '18', '6', '11 15 11 11 13');
INSERT INTO program6 VALUES (NULL, '19', '7', '12 16 11 11 15');
INSERT INTO program6 VALUES (NULL, '19', '8', '12 16 12 12 16');
INSERT INTO program6 VALUES (NULL, '20', '9', '13 17 13 13 16');
]]
db:exec( insertProgram6 )

local insertProgram7 = [[
INSERT INTO program7 VALUES (NULL, '21', '1', '12 16 12 12 15');
INSERT INTO program7 VALUES (NULL, '21', '2', '13 16 12 12 16');
INSERT INTO program7 VALUES (NULL, '22', '3', '13 17 12 12 16');
INSERT INTO program7 VALUES (NULL, '22', '4', '14 19 13 13 18');
INSERT INTO program7 VALUES (NULL, '23', '5', '14 19 14 14 19');
INSERT INTO program7 VALUES (NULL, '23', '6', '15 20 14 14 20');
INSERT INTO program7 VALUES (NULL, '24', '7', '16 20 16 16 20');
INSERT INTO program7 VALUES (NULL, '24', '8', '16 21 16 16 20');
INSERT INTO program7 VALUES (NULL, '25', '9', '17 22 16 16 21');
]]
db:exec( insertProgram7 )

local insertProgram8 = [[
INSERT INTO program8 VALUES (NULL, '26', '1', '16 18 15 15 17');
INSERT INTO program8 VALUES (NULL, '26', '2', '16 20 16 16 19');
INSERT INTO program8 VALUES (NULL, '27', '3', '17 21 16 16 20');
INSERT INTO program8 VALUES (NULL, '27', '4', '17 22 17 17 22');
INSERT INTO program8 VALUES (NULL, '28', '5', '18 23 18 18 22');
INSERT INTO program8 VALUES (NULL, '28', '6', '19 25 18 18 24');
INSERT INTO program8 VALUES (NULL, '29', '7', '19 26 18 18 25');
INSERT INTO program8 VALUES (NULL, '29', '8', '19 27 19 19 26');
INSERT INTO program8 VALUES (NULL, '30', '9', '20 28 20 20 28');
]]
db:exec( insertProgram8 )

local insertProgram9 = [[
INSERT INTO program9 VALUES (NULL, '31', '1', '20 25 19 19 23');
INSERT INTO program9 VALUES (NULL, '31', '2', '22 25 21 21 25');
INSERT INTO program9 VALUES (NULL, '32', '3', '23 26 23 23 25');
INSERT INTO program9 VALUES (NULL, '32', '4', '24 27 24 24 26');
INSERT INTO program9 VALUES (NULL, '33', '5', '25 28 24 24 27');
INSERT INTO program9 VALUES (NULL, '33', '6', '25 29 25 25 28');
INSERT INTO program9 VALUES (NULL, '34', '7', '26 29 25 25 29');
INSERT INTO program9 VALUES (NULL, '34', '8', '26 30 26 26 30');
INSERT INTO program9 VALUES (NULL, '35', '9', '26 32 26 26 32');
]]
db:exec( insertProgram9 )

local insertProgram10 = [[
INSERT INTO program10 VALUES (NULL, '36', '1', '23 27 22 22 26');
INSERT INTO program10 VALUES (NULL, '36', '2', '24 28 24 24 28');
INSERT INTO program10 VALUES (NULL, '37', '3', '25 29 24 24 29');
INSERT INTO program10 VALUES (NULL, '37', '4', '26 30 25 25 30');
INSERT INTO program10 VALUES (NULL, '38', '5', '26 31 25 25 31');
INSERT INTO program10 VALUES (NULL, '38', '6', '26 31 26 26 31');
INSERT INTO program10 VALUES (NULL, '39', '7', '27 31 26 26 32');
INSERT INTO program10 VALUES (NULL, '39', '8', '28 32 26 26 32');
INSERT INTO program10 VALUES (NULL, '40', '9', '28 34 27 27 34');
]]
db:exec( insertProgram10 )

local insertProgram11 = [[
INSERT INTO program11 VALUES (NULL, '42', '1', '25 28 24 24 26');
INSERT INTO program11 VALUES (NULL, '43', '2', '25 29 25 25 28');
INSERT INTO program11 VALUES (NULL, '44', '3', '25 30 25 25 29');
INSERT INTO program11 VALUES (NULL, '45', '4', '26 31 25 25 31');
INSERT INTO program11 VALUES (NULL, '46', '5', '26 32 26 26 32');
INSERT INTO program11 VALUES (NULL, '47', '6', '27 32 26 26 32');
INSERT INTO program11 VALUES (NULL, '48', '7', '27 34 26 26 33');
INSERT INTO program11 VALUES (NULL, '49', '8', '28 34 26 26 34');
INSERT INTO program11 VALUES (NULL, '50', '9', '29 35 27 27 35');
]]
db:exec( insertProgram11 )


storyboard.gotoScene( "scenetemplate" )
	else
		print('total exists')
		-- total = dbCheck()
		storyboard.gotoScene( "scenetemplate" )
	end


