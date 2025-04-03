function loadMenu()
    menuBackground = love.graphics.newImage("assets/MenuBackground2.png")

    -- Define the startGame function to change the game state
    local function startGame()
        game.state.menu = false
        game.state.running = true
        backgroundMusic:stop()
    end

    buttons = {
        menu_state = {
            playGame = button(" ", startGame, nil, 120, 50, "assets/buttons/PlayButton.png"),
            settings = button(" ", nil, nil, 120, 50, "assets/buttons/SettingsButton.png"),
            exitGame = button(" ", love.event.quit, nil, 120, 50, "assets/buttons/ExitButton.png")
        }
    }

    backgroundMusic = love.audio.newSource("assets/Songs/soundtrack.wav", "stream")
    backgroundMusic:setLooping(true)
    backgroundMusic:play()
    backgroundMusic:setVolume(0.5)
end

function handleMenuMousePressed(x, y, button)
    if game.state["menu"] and button == 1 then
        for _, btn in pairs(buttons.menu_state) do
            btn:CheckPressed(x, y)
        end
    end
end

function drawMenu()
    love.graphics.draw(menuBackground, 0, 0)
    buttons.menu_state.playGame:draw(580, 300)
    buttons.menu_state.settings:draw(580, 360)
    buttons.menu_state.exitGame:draw(580, 420)
end
