require "sqlite3"
local path = system.pathForFile( "puzzlesDataBase.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )

-- ========================== BEGIN OF METHODS DECLARATION =======================================================================

-- create empty tables in data base
local function createAllDataBaseTables()
    local createPartTable = [[CREATE TABLE IF NOT EXISTS Part (id INTEGER PRIMARY KEY, x, y, idPuzzle, picture);]]
    db:exec (createPartTable)

    local createPuzzleTable = [[CREATE TABLE IF NOT EXISTS Puzzle (id INTEGER PRIMARY KEY, name, diffucult, partsCount, picture, shadow);]]
    db:exec (createPuzzleTable)

    local createLevelTable = [[CREATE TABLE IF NOT EXISTS Level (id INTEGER PRIMARY KEY, name, idPuzzle, idLocation);]]
    db:exec (createLevelTable)

    local createLocationTable = [[CREATE TABLE IF NOT EXISTS Location (id INTEGER PRIMARY KEY, name, levelsCount, pictures);]]
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

-- DOES NOT WORK
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

-- add data to table: Location.     data is an array of tables, like: {name, levelsCount, pictures}
local function addDataToLocationTable(data)
    if (data ~= nil) then
        for i = 1, #data do
            local request = [[INSERT INTO Location VALUES (NULL, ']] .. data[i].name .. [[',']] .. data[i].levelsCount .. [[',']] .. data[i].pictures .. [['); ]]
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
    if (data ~= nil) then
        for i = 1, #data do
            local request = [[INSERT INTO Part VALUES (NULL, ']] .. data[i].x .. [[',']] .. data[i].y .. [[',']] ..data[i].idPuzzle .. [[',']] .. data[i].picture .. [['); ]]
            db:exec(request)
        end
    end
end

-- if tables are empty - add data
local function fillAllDataBaseTables()

    -- check
    local isLocationTableEmpty = (checkLocationTable() == nil)
    local isLevelTableEmpty = (checkLevelTable() == nil)
    local isPuzzleTableEmpty = (checkPuzzleTable() == nil)
    local isPartTableEmpty = (checkPartTable() == nil)

    if isLocationTableEmpty then
        local locationData = {}
        locationData[1] = { name = "Forest", levelsCount = 1, pictures = "forest_pict" }
        locationData[2] = { name = "City", levelsCount = 2, pictures = "city_pict" }
        addDataToLocationTable(locationData)
    end

    if isLevelTableEmpty then
        local levelData = {}
        levelData[1] = { name = "level_name_1", idPuzzle = "1", idLocation = "1" }
        levelData[2] = { name = "level_name_2", idPuzzle = "2", idLocation = "1" }
        addDataToLevelTable(levelData)
    end

    if isPuzzleTableEmpty then
        local puzzleData = {}
        puzzleData[1] = { name = "puzzle_name_1", difficult = "1", partsCount = "1", picture = "pic1", shadow = "shadow1" }
        puzzleData[2] = { name = "puzzle_name_2", difficult = "2", partsCount = "2", picture = "pic2", shadow = "shadow2" }
        addDataToPuzzleTable(puzzleData)
    end

    if isPartTableEmpty then
        local partData = {}
        partData[1] = { x = "0", y = "0", idPuzzle = "1", picture = "id_pic1" }
        partData[2] = { x = "1", y = "1", idPuzzle = "2", picture = "id_pic2" }
        addDataToPartTable(partData)
    end

end

local function getTableIdByName(tableName, name)
    local request = [[SELECT * FROM ]] .. tableName.. [[ WHERE name=']] .. name .. [[';]]
    for row in db:nrows(request) do
        return row.id
    end
end

local function getPuzzleIdByName(name)
    return getTableIdByName("Puzzle", name)
end

local function getLocationIdByName(name)
    return getTableIdByName("Location", name)
end

local function getLevelIdByName(name)
    return getTableIdByName("Level", name)
end

-- argument "puzzle" might be: 1. Puzzle.name
--                             2. Puzzle.id
local function getPuzzleParts(puzzle) -- returns array of Part
    local parts = {}

    local id = tonumber(puzzle)

    if (id == nil) then -- если было указано имя пазла, то найти его id
        id = getPuzzleIdByName(puzzle)
    end

    local request = [[SELECT * FROM Part WHERE idPuzzle=']] .. id .. [[';]]
    for row in db:nrows(request) do
        parts[#parts+1] = row
    end

    return parts
end

-- argument "location" might be: 1. Location.name
--                               2. Location.id
local function getLocationLevels(location)
    local levels = {}

    local id = tonumber(location)

    if (id == nil) then
        id = getLocationIdByName(location)
    end

    local request = [[SELECT * FROM Level WHERE idLocation=']] .. id .. [[';]]
    for row in db:nrows(request) do
        levels[#levels+1] = row
    end

    return levels
end

local function getLevelPuzzles(level)
    local puzzles = {}

    local id = tonumber(level)

    if (id == nil) then
        id = getLevelIdByName(level)
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
-- ========================== END OF METHODS DECLARATION =======================================================================

createAllDataBaseTables() -- try to create empty tables
fillAllDataBaseTables() -- add data, if tables are empty

-- print parts info
local parts = getPuzzleParts("puzzle_name_1") -- get array of Part for some puzzle
for i = 1, #parts do
    print(parts[i].x, parts[i].y, parts[i].picture)
end

-- print levels names
local levels = getLocationLevels("Forest")
for i = 1, #levels do
    print(levels[i].name)
end

local levelPuzzles = getLevelPuzzles(1)
for i = 1, #levelPuzzles do
    print(levelPuzzles[i].name)
end




db:close()