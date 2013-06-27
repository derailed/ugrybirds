local physics = require( "physics" )
physics.start()
physics.setScale(40)

local bird    = display.newImage( 'assets/bird.png' )
local shot    = audio.loadSound("sounds/shot.aif");
local stretch = audio.loadSound("sounds/stretch.aif")
local game    = display.newGroup()

display.setDefault( "fillColor", 255, 105, 73)

function draw_landscape()
  -- local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
  -- background:setFillColor(152,108,170)
  -- background:toBack()  
  
  local sky = display.newImage("assets/sky.png")
  sky.height = 700
  sky:toBack()
  
  local sun = display.newCircle( 900, 200, 60, 60 )
  sun:setFillColor( 250, 253, 126 )  
end

function draw_bird()
  bird.x      = 200
  bird.width  = 60
  bird.height = 60
  physics.addBody( bird, "dynamic", { density=2.0, friction=1.0, bounce=0.5, radius = 28 } )
  game:insert( bird )
end

function draw_grounds()
  local floor = display.newRect( -480, 600, 5000, 168 )
  floor:setFillColor( 168, 105, 73 )
  physics.addBody( floor, "static", {density=1.0, friction=1.0, bounce=0.5, isSensor=false} )
  game:insert( floor )
end

function draw_blocks()
  local size   = 60
  local spacer = size+20
  local start_x = 600
  local x       = 0
  local y       = 300
  for row=0,3 do
    x = start_x
    for col=0,1  do  
      x = x + (col*spacer)      
      y = y - (col*size) 
      local rect = display.newImage( 'assets/box.png')
      rect.x = x
      rect.y = y
      rect.width  = size
      rect.height = size-3
      physics.addBody( rect, "dynamic", {density=0.5, friction=0.3, bounce=-10, isSensor=false} )    
      game:insert( rect )    
    end
  end
end

-- Let the game begin...
draw_landscape()
draw_bird()
draw_grounds()
draw_blocks()

function birdTouched(evt)
  if evt.phase == "began" then
    display.getCurrentStage():setFocus( bird )
    audio.play(stretch)
  elseif evt.phase == "ended" then
    bird:applyLinearImpulse( evt.xStart - evt.x, evt.yStart-evt.y, bird.x, bird.y )
    display.getCurrentStage():setFocus(nil)
    audio.play(shot)    
  end
end
bird:addEventListener( "touch", birdTouched )

function loop(e)
  local targetx = 300 - bird.x
  game.x = game.x + (targetx-game.x)*0.05
end
Runtime:addEventListener( 'enterFrame', loop )