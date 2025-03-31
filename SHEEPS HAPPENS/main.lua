anim8 = require "libraries/anim8"
Class = require "libraries/class"
push = require "libraries/push"
sti = require "libraries/sti"
camera = require "libraries/camera"
wf = require "libraries/windfield"
button = require "button" 

function love.load()
    cam = camera(nil, nil, 3.5) -- Initialize the camera with a scale

    love.graphics.setDefaultFilter("nearest", "nearest") -- Set the default filter for images to nearest neighbor

    love.window.setTitle("Sheeps Happens") -- Set the window title

    world = wf.newWorld(0, 0)

    gameMap = sti("maps/TestMap.lua") -- Load the map using STI

    game = {
        state = { -- Properly define the game state table
            menu = true,
            paused = false,
            running = false,
            ended = false 
        }
    }

    buttons = {
        menu_state = {}
    } 

    function startGame()
        game.state["menu"] = false
        game.state["running"] = true
    end


    buttons.menu_state.playGame = button("Play Game", startGame, nil, 120, 50)
    buttons.menu_state.settings = button("Settings", nil, nil, 120, 50)
    buttons.menu_state.exitGame = button("Exit Game", love.event.quit, nil, 120, 50)
    
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

    sounds = {}
    sounds.soundtrack = love.audio.newSource("assets/songs/soundtrack.wav", "stream") 
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit() -- Exit the game
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if not game.state["running"] then
        if button == 1 then
            if game.state["menu"] then
                for index in pairs(buttons.menu_state) do
                    buttons.menu_state[index]:CheckPressed(x, y)
                end
            end
        end
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
    if game.state["running"] then
        sounds.soundtrack:stop() 
        cam:attach()
            gameMap:drawLayer(gameMap.layers["water"])
            gameMap:drawLayer(gameMap.layers["grass"])
            player.anim:draw(player.spriteSheet, player.x, player.y, nil, nil, nil, 8, 9.5)
        cam:detach() 
        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10) 

    elseif game.state["menu"] then
        love.graphics.clear(0.1, 0.5, 0.2) 
        love.graphics.setFont(love.graphics.newFont(24)) 
        love.graphics.print("Sheeps Happens...", love.graphics.getWidth() / 2 - love.graphics.getFont():getWidth("Sheep Happens...") / 2, love.graphics.getHeight() / 2 - 100)
        love.graphics.setFont(love.graphics.newFont(18)) 
        buttons.menu_state.playGame:draw( 
            love.graphics.getWidth() / 2 - buttons.menu_state.playGame.width / 2, -- Center horizontally
            love.graphics.getHeight() / 2 - buttons.menu_state.playGame.height / 2 -- Center vertically
        )
        buttons.menu_state.settings:draw(
            love.graphics.getWidth() / 2 - buttons.menu_state.settings.width / 2, 
            love.graphics.getHeight() / 2 - buttons.menu_state.settings.height / 2 + 60 
        )
        buttons.menu_state.exitGame:draw( 
            love.graphics.getWidth() / 2 - buttons.menu_state.exitGame.width / 2, 
            love.graphics.getHeight() / 2 - buttons.menu_state.exitGame.height / 2 + 120 
        )
        sounds.soundtrack:play()
        sounds.soundtrack:setLooping(true) 
        sounds.soundtrack:setVolume(0.2) 
    end

    if not game.state["running"] and not game.state["menu"] then
       love.graphics.clear(0.5, 0.5, 0.5) 
        return
    end
end