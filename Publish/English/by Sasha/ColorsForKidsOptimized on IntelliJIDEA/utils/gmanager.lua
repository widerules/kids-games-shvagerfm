-- Module Game Manager
-- Implement interface for transition between games

-- Its uses file with settings where you set all games in right order
-- file path: utils/settings/gmanager.lua

local M = {}

local settings = require("utils.settings.gmanager")
local storyboard = require("storyboard")
local utils = require("utils.utils")

-- indicator of game with is started
M.currentGame = nil

-- init current game method
M.initGame = function(game)
    M.currentGame = game and game or storyboard.getCurrentSceneName()
end

-- reset current game. call in exit scene
M.resetGame = function()
    M.currentGame = nil
end

------------------------------------------------------------
-- go to next game method
-- @param {Table} animationOpts. Options for gotoScene
-- @param {Boolean} isMergeOpts. Merge with default options
------------------------------------------------------------
M.nextGame = function(animationOpts, isMergeOpts)
    local gameScene
    local gameIndex, nextGameIndex
    
    -- if currentGame didn't set exit
    if not M.currentGame then 
        return nil
    end
    
    if (animationOpts and isMergeOpts) then
        -- merge opts
    end
        
    animationOpts = animationOpts and animationOpts or settings.animationOptions
    
    -- get next game
    gameIndex = utils.indexOf(settings.gamesOrder, M.currentGame)
    
    if gameIndex then
        if gameIndex == #settings.gamesOrder then
            nextGameIndex = 1
        else
            nextGameIndex = gameIndex + 1
        end

        gameScene = settings.gamesOrder[nextGameIndex]
        
        storyboard.gotoScene(gameScene, animationOpts)
    end
end

------------------------------------------------------------
-- go to previous game method
-- @param {Table} animationOpts. Options for gotoScene
-- @param {Boolean} isMergeOpts. Merge with default options
------------------------------------------------------------
M.previousGame = function(animationOpts, isMergeOpts)
    local gameScene
    local gameIndex, prevGameIndex
    
    -- if currentGame didn't set exit
    if not M.currentGame then
        return nil
    end

    if (animationOpts and isMergeOpts) then
        -- merge opts
    end

    animationOpts = animationOpts and animationOpts or settings.animationOptions

    -- get next game
    gameIndex = utils.indexOf(settings.gamesOrder, M.currentGame)
    
    if gameIndex then
        if gameIndex == 1 then
            prevGameIndex = #settings.gamesOrder
        else
            prevGameIndex = gameIndex - 1
        end

        gameScene = settings.gamesOrder[prevGameIndex]

        storyboard.gotoScene(gameScene, animationOpts)
    end
end

return M