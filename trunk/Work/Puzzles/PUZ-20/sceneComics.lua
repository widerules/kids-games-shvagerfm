--
-- Created by IntelliJ IDEA.
-- User: Svyat
-- Date: 12/06/2014
-- Time: 11:15 AM
-- To change this template use File | Settings | File Templates.
--

local storyboard = require("storyboard")
local widget = require("widget")
local constants = require("constants")
local comics = require("comics")

local scene = storyboard.newScene()




function scene:createScene(event)
    local group = self.view

end

function scene:enterScene(event)
    local group = self.view
    local c = comics.init({imageSrc = "pic1.png", nFrames = 4, listener = function () print("This comics works!") end, timeShow = 1000, timeTransition = 500})
    c.start()
end

function scene:exitScene(event)
    local group = self.view

end

function scene:destroyScene(event)


end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene

