require "sqlite3"
local path = system.pathForFile( "puzzlesDataBase.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

local database = {}
-- ========================== BEGIN OF METHODS DECLARATION =======================================================================

-- create empty tables in data base
database.create = function()
    local createPartTable = [[CREATE TABLE IF NOT EXISTS Part (id INTEGER PRIMARY KEY, x, y, idPuzzle, picture);]]
    db:exec (createPartTable)

    local createPuzzleTable = [[CREATE TABLE IF NOT EXISTS Puzzle (id INTEGER PRIMARY KEY, name, diffucult, partsCount, picture, shadow);]]
    db:exec (createPuzzleTable)

    local createLevelTable = [[CREATE TABLE IF NOT EXISTS Level (id INTEGER PRIMARY KEY, name, idPuzzle, idLocation);]]
    db:exec (createLevelTable)

    local createLocationTable = [[CREATE TABLE IF NOT EXISTS Location (id INTEGER PRIMARY KEY, name, levelsCount, picture);]]
    db:exec (createLocationTable)
end

local function checkTableExistence(tableName)
    local sql = [[SELECT * FROM ]] .. tableName .. [[]]
    for row in db:nrows(sql) do
        return row.id
    end
end

local function checkLocationTable()
    return checkTableExistence("Location")
end

local function checkLevelTable()
    return checkTableExistence("Level")
end

local function checkPuzzleTable()
    return checkTableExistence("Puzzle")
end

local function checkPartTable()
    return checkTableExistence("Part")
end

-- DOES NOT WORK :(
local function addDataToTable(table, data)
    if (data ~= nil) then
        for i = 1, #data do
            local request = [[INSERT INTO ]] .. table .. [[ VALUES (NULL, ']]
            for j = 1, #data[i] do
                request = request .. [[',']] .. data[i][j] .. [[' ]]
            end
            request = request .. [[); ]]

            db:exec(request)
        end
    end
end

-- add data to table: Location.     data is an array of tables, like: {name, levelsCount, picture}
local function addDataToLocationTable(data)
    if (data ~= nil) then
        for i = 1, #data do
            local request = [[INSERT INTO Location VALUES (NULL, ']] .. data[i].name .. [[',']] .. data[i].levelsCount .. [[',']] .. data[i].picture .. [['); ]]
            db:exec(request)
        end
    end
end

-- add data to table: Level.     data is an array of tables, like: {name, idPuzzle, idLocation}
local function addDataToLevelTable(data)
    if (data ~= nil) then
        for i = 1, #data do
            local request = [[INSERT INTO Level VALUES (NULL, ']] .. data[i].name .. [[',']] .. data[i].idPuzzle .. [[',']] .. data[i].idLocation .. [['); ]]
            db:exec(request)
        end
    end
end

-- add data to table: Level.     data is an array of tables, like: {name, difficult, partsCount, picture, shadow}
local function addDataToPuzzleTable(data)
    if (data ~= nil) then
        for i = 1, #data do
            local request = [[INSERT INTO Puzzle VALUES (NULL, ']] .. data[i].name .. [[',']] .. data[i].difficult .. [[',']] .. data[i].partsCount .. [[',']] ..data[i].picture .. [[',']] .. data[i].shadow .. [['); ]]
            db:exec(request)
        end
    end
end

-- add data to table: Level.     data is an array of tables, like: {x, y, idPuzzle, picture}
local function addDataToPartTable(data)
    for i = 1, #data do
        local request = [[INSERT INTO Part VALUES (NULL, ']] .. data[i].x .. [[',']] .. data[i].y .. [[',']] ..data[i].idPuzzle .. [[',']] .. data[i].picture .. [['); ]]
        db:exec(request)
    end
end

-- if tables are empty - add date
database.fill = function()

-- check
    local isLocationTableEmpty = (checkLocationTable() == nil)
    local isLevelTableEmpty = (checkLevelTable() == nil)
    local isPuzzleTableEmpty = (checkPuzzleTable() == nil)
    local isPartTableEmpty = (checkPartTable() == nil)

    -- add data to Location table
    if isLocationTableEmpty then
        local locationData = {}
        locationData[1] = { name = "forest", levelsCount = 7, picture = "forest_bg" }
        locationData[2] = { name = "city", levelsCount = 7, picture = "city_bg" }
        locationData[3] = { name = "farm", levelsCount = 7, picture = "farm_bg" }
        addDataToLocationTable(locationData)
    end

    -- add data to Level table
    if isLevelTableEmpty then
        local levelData = {}
        levelData[1] = { name = "level1", idPuzzle = "1", idLocation = "1" }
        levelData[2] = { name = "level2", idPuzzle = "2", idLocation = "1" }
        levelData[3] = { name = "level3", idPuzzle = "3", idLocation = "1" }
        levelData[4] = { name = "level4", idPuzzle = "4", idLocation = "1" }
        levelData[5] = { name = "level5", idPuzzle = "5", idLocation = "1" }
        levelData[6] = { name = "level6", idPuzzle = "6", idLocation = "1" }
        levelData[7] = { name = "level7", idPuzzle = "7", idLocation = "1" }

        levelData[8] = { name = "level1", idPuzzle = "8", idLocation = "2" }
        levelData[9] = { name = "level2", idPuzzle = "9", idLocation = "2" }
        levelData[10] = { name = "level3", idPuzzle = "10", idLocation = "2" }
        levelData[11] = { name = "level4", idPuzzle = "11", idLocation = "2" }
        levelData[12] = { name = "level5", idPuzzle = "12", idLocation = "2" }
        levelData[13] = { name = "level16", idPuzzle = "13", idLocation = "2" }
        levelData[14] = { name = "level7", idPuzzle = "14", idLocation = "2" }

        levelData[15] = { name = "level1", idPuzzle = "15", idLocation = "3" }
        levelData[16] = { name = "level2", idPuzzle = "16", idLocation = "3" }
        levelData[17] = { name = "level3", idPuzzle = "17", idLocation = "3" }
        levelData[18] = { name = "level4", idPuzzle = "18", idLocation = "4" }
        levelData[19] = { name = "level5", idPuzzle = "19", idLocation = "5" }
        levelData[20] = { name = "level6", idPuzzle = "20", idLocation = "6" }
        levelData[21] = { name = "level7", idPuzzle = "21", idLocation = "7" }

        addDataToLevelTable(levelData)
    end

    -- add data ti Puzzle table
    if isPuzzleTableEmpty then
        local puzzleData = {}
        puzzleData[1] = { name = "puzzle_name_1", difficult = "1", partsCount = "1", picture = "pic1", shadow = "shadow1" }
        puzzleData[2] = { name = "puzzle_name_2", difficult = "2", partsCount = "2", picture = "pic2", shadow = "shadow2" }
        addDataToPuzzleTable(puzzleData)
    end

    -- add data to Part table
    if isPartTableEmpty then
        local partData = {}
        partData[1] = { x = "0", y = "0", idPuzzle = "1", picture = "id_pic1" }
        partData[2] = { x = "1", y = "1", idPuzzle = "2", picture = "id_pic2" }
        addDataToPartTable(partData)
    end

end

-- general function
local function getTableIdByName(tableName, name)
    local request = [[SELECT * FROM ]] .. tableName.. [[ WHERE name=']] .. name .. [[';]]
    for row in db:nrows(request) do
        return row.id
    end
end

database.getPuzzleIdByName = function(name)
    return getTableIdByName("Puzzle", name)
end

database.getLocationIdByName = function(name)
    return getTableIdByName("Location", name)
end

database.getLevelIdByName = function(name)
    return getTableIdByName("Level", name)
end

--      ARGUMENT:
--      "puzzle" might be: 1. Puzzle.name
--                         2. Puzzle.id
--      RETURNS:
--      array of Part, associated with "puzzle", where:     Part = {x, y, idPuzzle, picture}
database.getPuzzleParts = function(puzzle) -- returns array of Part
    local parts = {}

    local id = tonumber(puzzle)

    if (id == nil) then -- если было указано имя пазла, то найти его id
        id = getTableIdByName("Puzzle", puzzle)
    end

    local request = [[SELECT * FROM Part WHERE idPuzzle=']] .. id .. [[';]]
    for row in db:nrows(request) do
        parts[#parts+1] = row
    end

    return parts
end

--      ARGUMENT:
--      "location" might be: 1. Location.name
--                           2. Location.id
--      RETURN:
--      array of Level, associated with "location", where:     Level = {name, idPuzzle, idLocation}
database.getLocationLevels = function(location)
    local levels = {}

    local id = tonumber(location)

    if (id == nil) then
        id = getTableIdByName("Location", location)
    end

    local request = [[SELECT * FROM Level WHERE idLocation=']] .. id .. [[';]]
    for row in db:nrows(request) do
        levels[#levels+1] = row
    end

    return levels
end

--      ARGUMENT:
--      "level" might be: 1. Level.name
--                        2. Level.id
--      RETURN:
--      array (usually only 1 object) of Puzzle, associated with "level", where:     Puzzle = {name, diffucult, partsCount, picture, shadow}
database.getLevelPuzzles = function(level)
    local puzzles = {}

    local id = tonumber(level)

    if (id == nil) then
        id = getTableIdByName("Level", level)
    end

    local puzzleId
    local r = [[SELECT * FROM Level WHERE id=']] .. id .. [[';]]
    for row in db:nrows(r) do
        puzzleId = row.idPuzzle
        break
    end

    local request = [[SELECT * FROM Puzzle WHERE id=']] .. puzzleId .. [[';]]
    for row in db:nrows(request) do
        puzzles[#puzzles+1] = row
    end

    return puzzles
end

database.getLocation = function(name)
    local location = {}

    local id = tonumber(name)

    if (id == nil) then
        id = getTableIdByName("Location", name)
    end

    local request = [[SELECT * FROM Location WHERE id=']] .. id .. [[';]]

    for row in db:nrows(request) do
        location = row
    end

    return location
end

database.close = function()
    db:close()
end

-- ========================== END OF METHODS DECLARATION =======================================================================


return database