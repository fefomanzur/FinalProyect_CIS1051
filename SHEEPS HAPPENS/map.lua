function loadMap()
    gameMap = sti("maps/Back.lua")
    Walls = {}
    Sheep = {}

    if gameMap.layers["walls"] then
        for _, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            wall:setCollisionClass("Walls")
            table.insert(Walls, wall)
        end
    end

    if gameMap.layers["sheep"] then
        for _, obj in pairs(gameMap.layers["sheep"].objects) do
            local sheep = world:newBSGRectangleCollider(obj.x, obj.y, obj.width, obj.height, 8)
            sheep:setType('static')
            sheep:setCollisionClass("Sheep")
            table.insert(Sheep, sheep)
        end
    end
end

function getMapDimensions()
    return gameMap.width * gameMap.tilewidth, gameMap.height * gameMap.tileheight
end

function drawMap()
    gameMap:drawLayer(gameMap.layers["maze"])
    gameMap:drawLayer(gameMap.layers["Sheep"])
    world:draw()
    world:setQueryDebugDrawing(true)
end