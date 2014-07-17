local constants = require "constants"

local sam = {}

local samTimer, popupTimer
local samImg, samActive     --samActive:  1 - if samLook is active,  2 - if samGood is active
local samImgPath = {"images/sam/samLook.png", "images/sam/samGood.png" }

local samX, samY, samWidth, samHeight, samScale

local function swapSamActiveFunc()
    samActive = samActive == 1 and 2 or 1

    display.remove(samImg)
    samImg = nil

    samImg = display.newImage(samImgPath[samActive])
    samImg.width = constants.W * 0.2 * samImg.width/samImg.height
    samImg.height = constants.W * 0.2

    samWidth = samImg.width * samScale
    samHeight = samImg.height * samScale

    samImg.width = samWidth
    samImg.height = samHeight

    samImg.x = samX
    samImg.y = samY
end

sam.swapSamActive = function()

    swapSamActiveFunc()
    samTimer = timer.performWithDelay(1500, swapSamActiveFunc)

end

sam.show = function(x, scale)
    samActive = 1
    samScale = scale
    samImg = display.newImage(samImgPath[samActive])

    samImg.width = constants.W * 0.2 * samImg.width/samImg.height
    samImg.height = constants.W * 0.2

    samWidth = samImg.width * samScale
    samHeight = samImg.height * samScale

    samImg.width = samWidth
    samImg.height = samHeight

    samX = x
    samY = constants.H - samImg.height * 0.5

    samImg.x = samX
    samImg.y = samY
end

sam.hide = function()
    if samTimer ~= nil then
        timer.cancel(samTimer)
        samTimer = nil
    end

    display.remove(samImg)
    samImg = nil
end

return sam