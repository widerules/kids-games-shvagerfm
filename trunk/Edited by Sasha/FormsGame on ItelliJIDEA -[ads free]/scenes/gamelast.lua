local storyboard = require( "storyboard" )
local widget = require( "widget" )
local native = require( "native" )
local constants = require("constants")
local explosion = require( "utils.explosion" )

local scene = storyboard.newScene()

explosion.createExplosion()

local background, shape
local popupTimer
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local amount = 12
local shapes = {"square", "triangle", "rhombus", "oval", "rectangle",  "round", "heart", "star"}
local items, backBtn
local find
local magicSound = audio.loadSound("sounds/magic.mp3")
local shapeSound
local selected
local toLeftTransition, toRightTransition
local rLeft, rRight, stopR, cancelAll
local totalItems = amount

local popupBg;
local popupText;
local homeBtn;
local nextBtn;
local _W = display.contentWidth
local _H = display.contentHeight
local _FONTSIZE = constants.H / 15;
local plopSound = audio.loadSound("sounds/Plopp.mp3")
local starSound = audio.loadSound( "sounds/start.mp3" )


local function backHome()
    storyboard.gotoScene( "scenes.scenetemplate", "slideRight", 800 )
    --storyboard.removeScene("scenes.gamelast")
end

local function onHomeButtonClicked(event)

    storyboard.gotoScene( "scenes.scenetemplate", "slideRight", 800 )

end;
local function nextBtnOnClck()

    storyboard.reloadScene()
end
local function showPopUp()
    popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
    popupBg.height = 0.7*constants.H;
    popupBg.width = 0.7*constants.W;

    popupText = display.newText("Well done!", popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
    popupText.y = popupBg.y-popupBg.height+2*popupText.width/3;

    homeBtn = widget.newButton
        {
            width = 0.4*popupBg.height,
            height = 0.4*popupBg.height,
            x = popupBg.x - 0.4*popupBg.width/2,
            y = popupBg.y + 0.4*popupBg.height/2,
            defaultFile = "images/home.png",
            overFile = "images/homehover.png",

        }
    homeBtn:addEventListener( "tap", onHomeButtonClicked );

    nextBtn = widget.newButton
        {
            width = 0.4*popupBg.height,
            height = 0.4*popupBg.height,
            x = popupBg.x + 0.4*popupBg.width/2,
            y = popupBg.y + 0.4*popupBg.height/2,
            defaultFile = "images/next.png",
            overFile = "images/next.png"
        }
    nextBtn:addEventListener( "tap", nextBtnOnClck);
end

stopR = function (self)
    transition.to(self, {time = 100, rotation = 0 })
end
rLeft = function (self)
    toLeftTransition = transition.to(self, {time=600, rotation=-10.0, onComplete=rRight })
end
rRight = function (self)

    toRightTransition = transition.to(self, {time=600, rotation=10.0, onComplete=rLeft })
end

cancelAll = function (self)
    if (toLeftTransition) then
        transition.cancel(toLeftTransition)
    end
    if (toRightTransition) then
        transition.cancel(toRightTransition)
    end
    stopR(self)
end
local function disApp(self)
    transition.to(self, {time = 800, rotation = 360, xScale = .2, yScale = .2, alpha = 0, onComplete = stopR})
    explosion.spawnExplosion(self.x, self.y)
end
local function enLarge(self)
    transition.to(self, {time = 500, xScale = 1.1, yScale = 1.1, onComplete = disApp})
end

local function onItemTap( event, self )
    event.target:removeEventListener( "tap", onItemTap )

    if selected ~= nil then
        if selected.id == event.target.id then
            cancelAll(selected)
            selected = nil
        elseif selected.shapeType == event.target.shapeType then
            shapeSound = audio.loadSound( "sounds/"..selected.shapeType..".mp3")
            audio.play( shapeSound )

            -- hide pair
            cancelAll(selected)
            enLarge(selected)
            enLarge(event.target)
            audio.play( starSound )
            selected = nil
            totalItems = totalItems - 2

            -- if all pairs is found
            if totalItems == 0 then

                popupTimer = timer.performWithDelay(1400, function()
                    audio.play(magicSound)
                    showPopUp()
                end)
            end
        else
            -- cancel transition
            event.target:addEventListener( "tap", onItemTap )
            selected:addEventListener( "tap", onItemTap )
            cancelAll(selected)
            selected = nil

        end
    else
        audio.play( plopSound )
        selected = event.target
        rLeft(event.target)
    end

    return true
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    find = audio.loadSound("sounds/fpairs.mp3")
    audio.play(find)
    background = display.newImage( "images/background3.jpg", centerX, centerY)
    background.width = _W
    background.height = _H
    group:insert( background )
end


function scene:enterScene( event )
    local group = self.view

    local sheetData = {
        width = 330,
        height = 330,
        numFrames = 8,
        sheetContentWidth = 1320,
        sheetContentHeight = 660
    }
    local shapeSheet = graphics.newImageSheet("images/shapes.png", sheetData)
    local sequenceData = {
        {
            name = "square",
            start = 1,
            count = 1,
        },
        {
            name = "triangle",
            start = 2,
            count = 1,
        },
        {
            name = "rhombus",
            start = 3,
            count = 1,
        },
        {
            name = "oval",
            start = 4,
            count = 1,
        },
        {
            name = "rectangle",
            start = 5,
            count = 1,
        },
        {
            name = "round",
            start = 6,
            count = 1,
        },
        {
            name = "heart",
            start = 7,
            count = 1,
        },
        {
            name = "star",
            start = 8,
            count = 1,
        }
    }


    local itemW
    local itemH = _H / 3
    itemW = itemH
    local i,j
    items = {}
    local temp

    local indexes = {}

    -- delete 2 random shape
    -- because we have 2 useless shapes
    for i=1, 2 do
        table.remove(shapes, math.random(1, #shapes))
    end

    for i=1, #shapes do
        indexes[shapes[i]] = 2
    end
    local shape, index

    for i=1, 3 do
        for j=1, 4 do
            temp = display.newSprite( shapeSheet, sequenceData )

            index = math.random(1, 6)
            while indexes[shapes[index]] == 0 do
                index = math.random(1, 6)
            end

            if indexes[shapes[index]] > 0 then
                temp:setSequence(shapes[index])
                temp.id = shapes[index] .. indexes[shapes[index]]
                temp.shapeType = shapes[index]
                indexes[shapes[index]] = indexes[shapes[index]] - 1
            end

            temp.width = itemW
            temp.height = itemH

            temp.x = j * itemW - itemW / 2 + _W / 8
            temp.y = i * itemH - itemH / 2
            temp.xScale, temp.yScale = 0.3, 0.3
            temp:addEventListener( "tap", onItemTap )

            table.insert(items, temp)
        end
    end

    backBtn = widget.newButton
        {
            width = 0.1*constants.W,
            height = 0.1*constants.W,
            defaultFile = "images/home.png",
            overFile = "images/homehover.png",
            id = "home",
            onRelease = backHome
        }
    backBtn.x = backBtn.width/2
    backBtn.y = backBtn.height/2
    group:insert( backBtn )
    for i=1, #items do
        transition.to( items[i], {time = 500, xScale = 1, yScale=1, transition=easing.outBack} )
        group:insert( items[i] )
    end


end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view

    if popupTimer ~= nil then
        timer.cancel(popupTimer)
        popupTimer = nil
    end

    display.remove(backBtn)
    backBtn = nil
    transition.cancel( )
    audio.stop()
    storyboard.purgeAll()
    if items ~=nil then
        for i=1, #items do
            if items[i] ~= nil then
                display.remove( items[i] )
                items[i] = nil
            end
        end
    end
    if popupBg ~= nil then
        display.remove( popupBg )
        display.remove( popupText )
        display.remove( nextBtn )
        display.remove( homeBtn )
        popupBg = nil
        popupText = nil
        nextBtn = nil
        homeBtn = nil
    end

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    explosion.destroyExplosion()
end

function scene:willEnterScene( event )
    local group = self.view
    totalItems = amount
    shapes = {"square", "triangle", "rhombus", "oval", "rectangle",  "round", "heart", "star"}
end



scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene