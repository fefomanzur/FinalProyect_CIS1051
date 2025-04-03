function initializeGame()
    game = {
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false
        }
    }

    loadMenu()
    loadMap()
    player = Player()
end

function updateGame(dt)
    if game.state["running"] then
        player:update(dt)
        world:update(dt)
        cam:lookAt(player.x, player.y) -- Update the camera to follow the player
    end
end

function drawGame()
    if game.state["running"] then
        cam:attach()
        drawMap() -- Draw the map first
        player:render() -- Render the player after the map
        cam:detach()
    elseif game.state["menu"] then
        drawMenu()
    end
end
