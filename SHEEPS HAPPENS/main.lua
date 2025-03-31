anim8 = require "libraries/anim8"
Class = require "libraries/class"
push = require "libraries/push"
sti = require "libraries/sti"
camera = require "libraries/camera"
wf = require "libraries/windfield"


function love.load()
    cam = camera(nil, nil, 3.5) -- Initialize the camera with a scale

    love.graphics.setDefaultFilter("nearest", "nearest") -- Set the default filter for images to nearest neighbor

    love.window.setTitle("Sheeps Happens") -- Set the window title

    world = wf.newWorld(0, 0)

    gameMap = sti("maps/TestMap.lua") -- Load the map using STI

    player = {}
    player.collider = world:newBSGRectangleCollider(200, 100, 16, 19, 14) 
    player.collider:setFixedRotation(true) -- Set the collider to not rotate
    player.x = 0
    player.y = 0
    player.speed = 40
    player.spriteSheet = love.graphics.newImage('assets/FarmerSheet.png')
    player.grid = anim8.newGrid(16, 19, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    
    player.animations = {}
    player.animations['up'] = anim8.newAnimation(player.grid('1-4', 1), 0.2) 
    player.animations['left'] = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animations['down'] = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animations['right'] = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animations.down

    Walls = {}
    if gameMap.layers["walls"] then
        for i, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static') 
            table.insert(Walls, wall)
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- Exit the game
    end
end

function love.update(dt)
    local isMoving = false 

    local vx = 0
    local vy = 0

    if love.keyboard.isDown("w") then
        vy = player.speed * -1
        player.anim = player.animations.up
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        vx = player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        vy = player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("d") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    player.collider:setLinearVelocity(vx, vy) 

    if isMoving == false then
        player.anim:gotoFrame(1)
    end

    world:update(dt) 
    
    player.x = player.collider:getX() 
    player.y = player.collider:getY() 

    player.anim:update(dt) 

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x < w / 2 / cam.scale then
        cam.x = w / 2 / cam.scale
    end

    if cam.y < h / 2 / cam.scale then
        cam.y = h / 2 / cam.scale
    end

    if cam.x > mapW - w / 2 / cam.scale then
        cam.x = mapW - w / 2 / cam.scale
    end

    if cam.y > mapH - h / 2 / cam.scale then
        cam.y = mapH - h / 2 / cam.scale
    end

    world:update(dt)
    
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["water"])
        gameMap:drawLayer(gameMap.layers["grass"])
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, nil, nil, 8, 9.5)
        --world:draw()
    cam:detach() 
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10) -- Display the FPS in the top-left corner
end