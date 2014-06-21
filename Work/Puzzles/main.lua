--
-- Created by IntelliJ IDEA.
-- User: Svyat
-- Date: 19/06/2014
-- Time: 04:30 PM
-- To change this template use File | Settings | File Templates.
--

local composer = require "composer"
local database = require "utils.database"

database.create()
database.fill()

composer.recycleOnSceneChange = true

composer.gotoScene("scenes.scenetemplate")