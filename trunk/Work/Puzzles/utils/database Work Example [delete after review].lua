local database = require("database")

database.create() -- create empty database
database.fill() -- fill database

-- print parts info
local parts = database.getPuzzleParts("puzzle_name_1") -- get array of Part for some puzzle
for i = 1, #parts do
    print(parts[i].x, parts[i].y, parts[i].picture)
end

-- print levels names
local levels = database.getLocationLevels("Forest")
for i = 1, #levels do
    print(levels[i].name)
end

-- print level puzzle(s)
local levelPuzzles = database.getLevelPuzzles(1)
for i = 1, #levelPuzzles do
    print(levelPuzzles[i].name)
end

database.close() -- close database