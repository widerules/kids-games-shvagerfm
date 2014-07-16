local coordsCalc = {}

local _W = 1280
local _H = 720

local REAL_WIDTH = display.contentWidth
local REAL_HEIGHT = display.contentHeight

coordsCalc.calc = function(width, height)
    local widthPr = width / _W
    local heightPr = height / _H

    local dimension = {}
    dimension.width = REAL_WIDTH * widthPr
    dimension.height = REAL_HEIGHT * heightPr

    return dimension
end

return coordsCalc