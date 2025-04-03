anim8 = require "libraries/anim8"
Class = require "libraries/class"
push = require "libraries/push"
sti = require "libraries/sti"
camera = require "libraries/camera"
wf = require "libraries/windfield"
button = require "button"

require "player" -- Import the Player class
require "map"    -- Import the map logic
require "menu"   -- Import the menu logic
require "game"   -- Import the game state logic

function love.load()
    love.window.setMode(1280, 720, {resizable = true})
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Sheeps Happens")

    cam = camera(nil, nil, 3.5) 
    world = wf.newWorld(0, 0, true) -- Ensure the physics world is initialized with default gravity

    initializeGame() -- Initialize game state and objects
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    handleMenuMousePressed(x, y, button) -- Delegate to menu logic
end

function love.update(dt)
    updateGame(dt) 

    local mapWidth, mapHeight = getMapDimensions() 
    local camX, camY = cam:position()
    local camWidth, camHeight = love.graphics.getWidth() / cam.scale, love.graphics.getHeight() / cam.scale

    cam:lookAt(
        math.max(camWidth / 2, math.min(camX, mapWidth - camWidth / 2)),
        math.max(camHeight / 2, math.min(camY, mapHeight - camHeight / 2))
    )
end

function love.draw()
    drawGame() 
end