display.setStatusBar( display.HiddenStatusBar )
--these 2 variables will be the checks that control our event system.
local inEvent = 0
local eventRun = 0

local _W = display.contentWidth
local _H = display.contentHeight
local groundMin = 1.3*_H
local groundMax = 1.06*_H 
local groundLevel = groundMin
local speed = 5
local hero
local collisionRect

local player = display.newGroup()
local screen = display.newGroup()
local blocks = display.newGroup()

local sheetData = {
	width = 100,
	height = 100,
	numFrames = 7,
	sheetContentWidth = 700,
	sheetContentHeight = 100
}
local monsterSheet = graphics.newImageSheet("images/monsterSpriteSheet.png", sheetData)
		local sequenceData = {
		{
		name = "running",
		start = 1,
		count = 6,
		time = 500,
		loopCount=0,
		},
		{
		name = "jumping",
		frames = 7,7,
		time = 1000,
		loopCount=1,
	}
	}



local function onBackgroundTap(self)
	local function updRunning()
		hero:setSequence("running")
		hero:play()
		transition.to(hero, {time = 500, y = hero.y + hero.height})
	end
	local function updJump()
		hero:setSequence("jumping")
		transition.to( hero, {time=500, y = hero.y - hero.height, onComplete = updRunning} )
	end
	jumpingT = timer.performWithDelay(1, updJump, 1)
	--speed = 0
	--timer.cancel( running1 )
end
local function checkCollisions()
     wasOnGround = onGround
     --checks to see if the collisionRect has collided with anything. This is why it is lifted off of the ground
     --a little bit, if it hits the ground that means we have run into a wall. We check this by cycling through
     --all of the ground pieces in the blocks group and comparing their x and y coordinates to that of the collisionRect
     for a = 1, blocks.numChildren, 1 do
          if(collisionRect.y - 10 > blocks[a].y - 170 and blocks[a].x - 40 < collisionRect.x and blocks[a].x + 40 > collisionRect.x) then
               speed = 0
          end
     end
     --this is where we check to see if the monster is on the ground or in the air, if he is in the air then he can't jump(sorry no double
     --jumping for our little monster, however if you did want him to be able to double jump like Mario then you would just need
     --to make a small adjustment here, by adding a second variable called something like hasJumped. Set it to false normally, and turn it to
     --true once the double jump has been made. That way he is limited to 2 hops per jump.
     --Again we cycle through the blocks group and compare the x and y values of each.
     for a = 1, blocks.numChildren, 1 do
          if(hero.y >= blocks[a].y - 170 and blocks[a].x < hero.x + 60 and blocks[a].x > hero.x - 60) then
               hero.y = blocks[a].y - 171
               onGround = true
               break
          else
               onGround = false
          end
     end
end

local function updateMonster()
     --if our monster is jumping then switch to the jumping animation
     --if not keep playing the running animation
     if(onGround) then
          --if we are alread on the ground we don't need to prepare anything new
          if(wasOnGround) then
          else
               hero:setSequence( "running" )
               hero:play()
          end
     else
          hero:setSequence("jumping")
          hero:play()
     end
 
     if(hero.accel > 0) then
          hero.accel = hero.accel - 1
     end
 
     --update the monsters position accel is used for our jump and
     --gravity keeps the monster coming down. You can play with those 2 variables
     --to make lots of interesting combinations of gameplay like 'low gravity' situations
     hero.y = hero.y - hero.accel
     hero.y = hero.y - hero.gravity
     --update the collisionRect to stay in front of the monster
     collisionRect.y = hero.y
end
--this is the function that handles the jump events. If the screen is touched on the left side
--then make the monster jump
function touched( event )
     if(event.phase == "began") then
          if(event.x < 241) then
               if(onGround) then
                    hero.accel = hero.accel + 20
               end
          end
     end
end

function checkEvent()
     --first check to see if we are already in an event, we only want 1 event going on at a time
     if(eventRun > 0) then
          --if we are in an event decrease eventRun. eventRun is a variable that tells us how
          --much longer the event is going to take place. Everytime we check we need to decrement
          --it. Then if at this point eventRun is 0 then the event has ended so we set inEvent back
          --to 0.
          eventRun = eventRun - 1
          if(eventRun == 0) then
               inEvent = 0
          end
     end
     --if we are in an event then do nothing
     if(inEvent > 0 and eventRun > 0) then
          --Do nothing
     else
          --if we are not in an event check to see if we are going to start a new event. To do this
          --we generate a random number between 1 and 100. We then check to see if our 'check' is
          --going to start an event. We are using 100 here in the example because it is easy to determine
          --the likelihood that an event will fire(We could just as easilt chosen 10 or 1000).
          --For example, if we decide that an event is going to
          --start everytime check is over 80 then we know that everytime a block is reset there is a 20%
          --chance that an event will start. So one in every five blocks should start a new event. This
          --is where you will have to fit the needs of your game.
          check = math.random(100)
 
          --this first event is going to cause the elevation of the ground to change. For this game we
          --only want the elevation to change 1 block at a time so we don't get long runs of changing
          --elevation that is impossible to pass so we set eventRun to 1.
          if(check > 80 and check < 99) then
               --since we are in an event we need to decide what we want to do. By making inEvent another
               --random number we can now randomly choose which direction we want the elevation to change.
               inEvent = math.random(10)
               eventRun = 1
          end
          if(check > 98) then
			     inEvent = 11
			     eventRun = 2
			end
     end
     --if we are in an event call runEvent to figure out if anything special needs to be done
     if(inEvent > 0) then
          runEvent()
     end
end
--this function is pretty simple it just checks to see what event should be happening, then
--updates the appropriate items. Notice that we check to make sure the ground is within a
--certain range, we don't want the ground to spawn above or below whats visible on the screen.
function runEvent()
     if(inEvent < 6) then
          groundLevel = groundLevel + 40
     end
     if(inEvent > 5 and inEvent < 11) then
          groundLevel = groundLevel - 40
     end
     if(groundLevel < groundMax) then
          groundLevel = groundMax
     end
     if(groundLevel > groundMin) then
          groundLevel = groundMin
     end
end

local backbackground = display.newImage("images/background.png")
backbackground.width = _W
backbackground.height = _H
backbackground.x = 0.5*_W
backbackground.y = 0.5*_H
--backbackground:addEventListener( "tap", onBackgroundTap )

local backgroundfar = display.newImage("images/bgfar1.png")
backgroundfar.width = 2*_W
backgroundfar.height = _H
backgroundfar.x = _W
backgroundfar.y = 0.5*_H

local backgroundnear1 = display.newImage("images/bgnear2.png")
backgroundnear1.width = _W
backgroundnear1.height = _H
backgroundnear1.x = 0.5*_W
backgroundnear1.y = 0.5*_H
 
local backgroundnear2 = display.newImage("images/bgnear2.png")
backgroundnear2.width = _W
backgroundnear2.height = _H
backgroundnear2.x = 1.5*_W
backgroundnear2.y = 0.5*_H
--the update function will control most everything that happens in our game
--this will be called every frame(30 frames per second in our case, which is the Corona SDK default)
local function update( event )
--updateBackgrounds will call a function made specifically to handle the background movement
updateBackgrounds()
updateBlocks()
updateMonster()
updateBlocks()
checkCollisions()
speed = speed + .0005

end
 
function updateBackgrounds()
--far background movement
backgroundfar.x = backgroundfar.x - (speed/55)
 
--near background movement
backgroundnear1.x = backgroundnear1.x - (speed/5)
--if the sprite has moved off the screen move it back to the
--other side so it will move back on
if(backgroundnear1.x < -0.5*_W) then
backgroundnear1.x = 1.5*_W
end
 
backgroundnear2.x = backgroundnear2.x - (speed/5)
if(backgroundnear2.x < -0.5*_W) then
backgroundnear2.x = 1.5*_W
end
end
 
--this is how we call the update function, make sure that this line comes after the
--actual function or it will not be able to find it
--timer.performWithDelay(how often it will run in milliseconds, function to call,
--how many times to call(-1 means forever))
running1 = timer.performWithDelay(1, update, -1)

--create a new group to hold all of our blocks

 
--setup some variables that we will use to position the ground

--this for loop will generate all of your ground pieces, we are going to
--make 8 in all.
for a = 1, 8, 1 do
isDone = false
 
--get a random number between 1 and 2, this is what we will use to decide which
--texture to use for our ground sprites. Doing this will give us random ground
--pieces so it seems like the ground goes on forever. You can have as many different
--textures as you want. The more you have the more random it will be, just remember to
--up the number in math.random(x) to however many textures you have.
numGen = math.random(2)
local newBlock
print (numGen)
if(numGen == 1 and isDone == false) then
newBlock = display.newImage("images/ground1.png")
newBlock.width = _W/6
newBlock.height = 0.75*_H
isDone = true
end
 
if(numGen == 2 and isDone == false) then
newBlock = display.newImage("images/ground2.png")
newBlock.width = _W/6
newBlock.height = 0.75*_H
isDone = true
end
 
--now that we have the right image for the block we are going
--to give it some member variables that will help us keep track
--of each block as well as position them where we want them.
newBlock.name = ("block" .. a)
newBlock.id = a
 
--because a is a variable that is being changed each run we can assign
--values to the block based on a. In this case we want the x position to
--be positioned the width of a block apart.
newBlock.x = (a * newBlock.width) - newBlock.width
newBlock.y = groundLevel
blocks:insert(newBlock)
end

function updateBlocks()
     for a = 1, blocks.numChildren, 1 do
          if(a > 1) then
               newX = (blocks[a - 1]).x + 79
          else
               newX = (blocks[8]).x + 79 - speed
          end
         if((blocks[a]).x < -40) then
		     if(inEvent == 11) then
		          (blocks[a]).x, (blocks[a]).y = newX, 600
		     else
		          (blocks[a]).x, (blocks[a]).y = newX, groundLevel
		     end
		     checkEvent()
		else
		     (blocks[a]):translate(speed * -1, 0)
		end
     end
end


hero = display.newSprite( monsterSheet, sequenceData )
hero:setSequence( "running" )

--finds the center of the screen
--a boolean variable that shows which direction we are moving
right = true

hero.x = _W/4
hero.y = _H - hero.height
hero.gravity = -6
hero.accel = 0
--calling play will start the loaded animation
hero:play()
collisionRect = display.newRect(hero.x + 36, hero.y, 1, 70)
collisionRect.strokeWidth = 1
collisionRect:setFillColor(140, 140, 140)
collisionRect:setStrokeColor(180, 180, 180)
collisionRect.alpha = 0
--used to put everything on the screen into the screen group
--this will let us change the order in which sprites appear on
--the screen if we want. The earlier it is put into the group the
--further back it will go
screen:insert(backbackground)
screen:insert(backgroundfar)
screen:insert(backgroundnear1)
screen:insert(backgroundnear2)
screen:insert(blocks)
screen:insert(hero)
screen:insert(collisionRect)

Runtime:addEventListener("touch", touched, -1)