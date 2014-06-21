local database = require("database")
local composer = require("composer")

database.create() -- create empty database
database.fill() -- fill database

composer:gotoScene("work")