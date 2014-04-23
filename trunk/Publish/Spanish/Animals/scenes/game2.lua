_GAME = 2

local storyboard = require( "storyboard")
local widget = require( "widget")
local data = require( "feedData")
local constants = require( "constants")

local scene = storyboard.newScene( )



local _ANIMALSPATH = "images/"
local _FOODPATH = "images/"
local _FORMAT = ".png"

local _FONTSIZE = constants.H / 15;
local _IMAGESIZE = 0.4*constants.H;
local _FOODSIZE = 0.7*_IMAGESIZE;
local _SPACING = 0.1*constants.H;
local _DELTA = 0.1*constants.H;

local _PANECENTERX
local _BARCENTERX


local indexes = {}
local positions = {}
local foodPositions = {}
local animalsPictures = {}
local foodPictures = {}

local animalSound;

local background, homeBtn
local rightBar;
local pane;
local starToScore
local counter = 0

explosionTable        = {}                    -- Define a Table to hold the Spawns
i                    = 0                        -- Explosion counter in table
explosionTime        = 416.6667                    -- Time defined from EXP Gen 3 tool
_w                     = display.contentWidth    -- Get the devices Width
_h                     = display.contentHeight    -- Get the devices Height
resources            = "_resources"            -- Path to external resource files

local explosionSheetInfo    = require(resources..".".."Explosion")
local explosionSheet        = graphics.newImageSheet( resources.."/".."Explosion.png", explosionSheetInfo:getSheet() )

--------------------------------------------------
-- Define the animation sequence for the Explosion
-- from the Sprite sheet data
-- Change the sequence below to create IMPLOSIONS 
-- and EXPLOSIONS etc...
--------------------------------------------------
local animationSequenceData = {
  { name = "dbiExplosion",
      frames={
          1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
      },
      time=explosionTime, loopCount=1
  },
}

local function spawnExplosionToTable(spawnX, spawnY)
    i = i + 1                                        -- Increment the spawn counter
    
    explosionTable[i] = display.newSprite( explosionSheet, animationSequenceData )
    explosionTable[i]:setSequence( "dbiExplosion" )    -- assign the Animation to play
    explosionTable[i].x=spawnX                        -- Set the X position (touch X)
    explosionTable[i].y=spawnY                        -- Set the Y position (touch Y)
    explosionTable[i]:play()                        -- Start the Animation playing
    explosionTable[i].xScale = 1                    -- X Scale the Explosion if required
    explosionTable[i].yScale = 1                    -- Y Scale the Explosion if required
    
    --Create a function to remove the Explosion - triggered from the DelatedTimer..
    local function removeExplosionSpawn( object )
        return function()
            object:removeSelf()    -- remove the explosion from table
            object = nil
        end
    end
    
    --Add a timer to the Spawned Explosion.
    --Explosion are destroyed after all the frames have been played after a determined
    --amount of time as setup by the Explosion Generator Tool.
    local destroySpawneExplosion = timer.performWithDelay (explosionTime, removeExplosionSpawn(explosionTable[i]))
end

local function backHome( event )
    --TO DO:
    local options =
        {
            effect = "slideRight",
            time = 500,
            params = { ind = 2 }
        }
    storyboard.gotoScene("scenes.gametitle", options)
    storyboard.removeScene("scenes.game2")

end;

----animation update score
local function animScore()
    local function listener()
        starToScore:removeSelf( )
        starToScore = nil
    end
    starToScore = display.newImage( "images/starfull.png", constants.CENTERX, constants.CENTERY, constants.H/8, constants.H/8)
    starToScore.xScale, starToScore.yScale = 0.1, 0.1
    
    local function trans1()
        transition.to(starToScore, {time = 200, xScale = 1, yScale = 1, x = star[level].x, y= star[level].y, onComplete = listener})
    end
    spawnExplosionToTable(constants.CENTERX, constants.CENTERY)
    transition.to(starToScore, {time = 300, xScale = 2, yScale = 2, transition = easing.outBack, onComplete = trans1})
end


local soundHarp = audio.loadSound( "sounds/harp.ogg")

local onPlaces

local function generateIndexes ()
        local tmp = {}
        for i = 1,table.maxn(data.animals),1 do
                table.insert(tmp,i)
        end

        local rand;
        for i = 1, 3, 1 do
                rand = math.random(1, table.maxn(tmp))
                table.insert(indexes,tmp[rand])
                table.remove( tmp, rand )
        end
end

local function animScaleOnDrag(self)
        self.xScale = 1.5
        self.yScale = 1.5
end

local function animScaleBack(self)
        self.xScale = 1
        self.yScale = 1
end

local function animOnPutOn(self)
        local function animFinished()
                self:toBack()           
        end
        transition.scaleTo(self, {xScale = 0, yScale = 0, time = 500, onComplete = animFinished})
end

local function onHomeButtonClicked(event)
        --TODO: go to home screen
        storyboard.gotoScene("scenetemplate", "slideRight", 400)
        storyboard.removeScene("scenes.game2")
end

local function onNextButtonClicked(event)
        storyboard.reloadScene( )
end

local function showPopUp()
        popupBg = display.newImage( "images/popupbg.png", constants.CENTERX, constants.CENTERY );
        popupBg.height = 0.7*constants.H;
        popupBg.width = 0.7*constants.W;

        popupText = display.newText("¡Bravo!", popupBg.x, 0, native.systemFont, 2*_FONTSIZE);
        popupText.y = popupBg.y - popupBg.height/4;

        homeBtn = widget.newButton
        {
                width = 0.4*popupBg.height,
                height = 0.4*popupBg.height,
                x = popupBg.x - 0.4*popupBg.width/2,
                y = popupBg.y + 0.4*popupBg.height/2,
                defaultFile = "images/home.png",
                overFile = "images/homehover.png"
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
        nextBtn:addEventListener( "tap", onNextButtonClicked );
        
end;

local function onFoodDrag (event)
local t = event.target
        local phase = event.phase
        animScaleOnDrag(t)

        if "began" == phase then 
                startX = t.x
                startY = t.y
                
                local parent = t.parent
                parent:insert (t)
                display.getCurrentStage():setFocus(t)
                
                t.isFocus = true
                t.x0 = event.x - t.x
                t.y0 = event.y - t.y

        elseif "moved" == phase and t.isFocus then
                t.x = event.x-t.x0
                t.y = event.y-t.y0
        elseif "ended" == phase or "cancel" == phase then 
                
                local flag = false
                local index = 0

                --find which food dragged
                for i = 1, table.maxn(foodPictures), 1 do
                        if foodPictures[i]==t then
                                index = i
                        end
                end             

                if math.abs(t.x - animalsPictures[index].x)<_DELTA and math.abs (t.y-animalsPictures[index].y)<_DELTA then
                        t.x = animalsPictures[index].x
                        t.y = animalsPictures[index].y
                        local name = tostring(animalsPictures[index].name)
                        animalSound = audio.loadSound("sounds/"..name..".mp3")
                        onPlaces = onPlaces + 1;
                        animOnPutOn(t)
                        audio.play(animalSound)
                        spawnExplosionToTable(t.x, t.y)
                        t:removeEventListener( "touch", onFoodDrag )
                else 
                        t.x = startX
                        t.y = startY
                        animScaleBack(t)
                end;

                display.getCurrentStage():setFocus(nil)
                t.isFocus = false
                startX = nil
                startY = nil

                if onPlaces == 3 then
                		audio.play( soundHarp )
                        timer.performWithDelay( 800, showPopUp, 1)
                end

        end
end

function scene:createScene(event)
        local group = self.view
        local feedSound = audio.loadSound( "sounds/feed.mp3")
        audio.play( feedSound )
        background = display.newImage("images/background3.png", constants.CENTERX, constants.CENTERY)
        background.height = constants.H
        background.width = constants.W
        group:insert(background)

        rightBar = display.newImage("images/right_bar.png", 0, constants.CENTERY)
        rightBar.height = constants.H
        rightBar.width = 0.2*constants.W
        rightBar.x = constants.W - rightBar.width/2;
        group:insert(rightBar)

        _BARCENTERX = rightBar.x

        pane = display.newImage("images/layer.png",0,constants.CENTERY)
        pane.height = 0.9*constants.H
        pane.width = 0.7*constants.W
        pane.x = pane.width/2+0.05*constants.W
        group:insert(pane)

        _PANECENTERX = pane.x

        positions = 
        {
                x = 
                {
                        pane.x - _IMAGESIZE/2-_SPACING,
                        pane.x + _IMAGESIZE/2+_SPACING,
                        pane.x - _IMAGESIZE/2-_SPACING
                },
                y = 
                {
                        pane.y - _IMAGESIZE/2 - _SPACING/3,
                        pane.y,
                        pane.y + _IMAGESIZE/2 + _SPACING/3

                }       
        }

    backBtn = widget.newButton
        {
            height = 0.07*constants.W,
            width = 0.07*constants.W,
            left = 0,
            top = 0,
            defaultFile = "images/home.png",
            overFile = "images/homehover.png",
            id = "home",
            onRelease = backHome,
            
        }
    --backBtn.width, backBtn.height = 0.08*constants.W, 0.08*constants.W
    --backBtn.x, backBtn.y = backBtn.width/2, backBtn.height/2
    group:insert( backBtn )

end

function scene:enterScene(event)
        local group = self.view;

        onPlaces = 0

        generateIndexes();
        positions.foodY = 
        {
                _FOODSIZE/2+_SPACING,
                3*_FOODSIZE/2+_SPACING,
                5*_FOODSIZE/2+_SPACING
        }

        local randFood

        for i = 1, 3, 1 do
                animalsPictures[i] = display.newImage( _ANIMALSPATH..data.animals[indexes[i]].._FORMAT, 0, 0)
                animalsPictures[i].height = _IMAGESIZE
                animalsPictures[i].width = _IMAGESIZE
                animalsPictures[i].name = data.animals[indexes[i]]
                group:insert(animalsPictures[i])
                transition.to(animalsPictures[i], {x=positions.x[i], y=positions.y[i], transition=easing.outBounce, time = 400})

                randFood = math.random( 1, table.maxn(positions.foodY))

                foodPictures[i] = display.newImage (_FOODPATH..data.food[indexes[i]].._FORMAT, constants.W, positions.foodY[randFood])
                foodPictures[i].height = _FOODSIZE
                foodPictures[i].width = _FOODSIZE
                foodPictures[i]:addEventListener( "touch", onFoodDrag )
                group:insert(foodPictures[i])   
                transition.to(foodPictures[i], {x=_BARCENTERX, transition=easing.outBounce, time = 400})
                table.remove(positions.foodY, randFood)
        end
end

function scene:exitScene(event)
        while (table.maxn(indexes)>0) do
                table.remove( indexes )
        end

        while (table.maxn(animalsPictures) > 0) do
            display.remove( animalsPictures[#animalsPictures] )
                table.remove(animalsPictures)
        end

        while (table.maxn(foodPictures) > 0) do
            display.remove( foodPictures[#foodPictures] )              
                table.remove(foodPictures)
        end

        if popupBg ~= nil then
            display.remove(popupBg)
            display.remove(popupText)
            display.remove( nextBtn )
            display.remove( homeBtn )
        end;
end

function scene:destroyScene(event)
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene