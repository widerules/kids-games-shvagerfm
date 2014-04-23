-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here


require "sqlite3"
local path = system.pathForFile( "puzzle.sqlite", system.DocumentsDirectory )
local db = sqlite3.open( path )
local storyboard = require("storyboard")

db:exec([[CREATE TABLE IF NOT EXISTS coordinates (id INTEGER NOT NULL, figure_id INTEGER NOT NULL, kx, ky, PRIMARY KEY(id, figure_id));]])
db:exec([[CREATE TABLE IF NOT EXISTS figures (id INTEGER NOT NULL PRIMARY KEY, path)]])

storyboard.gotoScene( "scenes.game1")