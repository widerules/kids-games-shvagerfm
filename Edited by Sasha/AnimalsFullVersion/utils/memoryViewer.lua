local memoryviewer = {}

local infoLabel
local shouldWork

local function doUpdateInfo()
    if (infoLabel ~= nil) then
        infoLabel.text = system.getInfo( "textureMemoryUsed" ) / 1000000
    end
end

memoryviewer.create = function(x, y, isShouldWork )
    shouldWork = isShouldWork
    if (shouldWork == true) then
        infoLabel = display.newText(  system.getInfo( "textureMemoryUsed" ) / 1000000, x, y, native.systemFont, 40 )
    end
end

memoryviewer.updateInfo = function()
    doUpdateInfo()
end

memoryviewer.updateInfoInLoop = function( delay )
    timer.performWithDelay(delay, doUpdateInfo, -1)
end

memoryviewer.stopUpdating = function()
    timer.stop()
end

memoryviewer.destroy = function()
    memoryviewer.stopUpdating()
    display.remove( infoLabel )
    infoLabel = nil
end

return memoryviewer