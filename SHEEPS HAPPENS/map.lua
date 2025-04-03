function loadMap()
    gameMap = sti("maps/Back.lua")
    Walls = {}

    if gameMap.layers["walls"] then
        for _, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(Walls, wall)
        end
    end
end

function getMapDimensions()
    return gameMap.width * gameMap.tilewidth, gameMap.height * gameMap.tileheight
end

function drawMap()
    gameMap:drawLayer(gameMap.layers["back"])
    world:draw()
end