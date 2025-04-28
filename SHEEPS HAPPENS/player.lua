Player = Class{}

function Player:init()
    self.x = 40
    self.y = 20
    self.width = 16
    self.height = 21
    self.collider = world:newBSGRectangleCollider(self.x, self.y - 1, self.width - 4, self.height + 1, 3) -- Use self.x and self.y here
    self.collider:setFixedRotation(true)
    self.collider:setCollisionClass("Player")
    self.speed = 60 -- Set a reasonable speed value
    self.spriteSheet = love.graphics.newImage('assets/FarmerSheet.png')
    self.grid = anim8.newGrid(16, 21, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {
        up = anim8.newAnimation(self.grid('1-4', 1), 0.2),
        left = anim8.newAnimation(self.grid('1-4', 2), 0.2),
        down = anim8.newAnimation(self.grid('1-4', 3), 0.2),
        right = anim8.newAnimation(self.grid('1-4', 4), 0.2)
    }

    self.anim = self.animations.down

    self.walkEffect = love.audio.newSource("assets/SoundEffects/Walking.mp3", "static")
    self.walkEffect:setLooping(true)
    self.walkEffect:setVolume(0.2)
    self.walkEffect:setPitch(0.75)

    self.NormalSheep = love.audio.newSource("assets/NormalSheep/NormalSheep.wav", "static")
    self.NormalSheep:setLooping(true)
    self.NormalSheep:setVolume(1)

end

function Player:update(dt)
    local isMoving = false
    local vx, vy = 0, 0

    if love.keyboard.isDown("w") then
        vy = -self.speed -- Apply speed directly
        self.anim = self.animations.up
        isMoving = true
        self.dir = "up"
    end
    if love.keyboard.isDown("a") then
        vx = -self.speed -- Apply speed directly
        self.anim = self.animations.left
        isMoving = true
        self.dir = "left"
    end
    if love.keyboard.isDown("s") then
        vy = self.speed -- Apply speed directly
        self.anim = self.animations.down
        isMoving = true
        self.dir = "down"
    end
    if love.keyboard.isDown("d") then
        vx = self.speed -- Apply speed directly
        self.anim = self.animations.right
        isMoving = true
        self.dir = "right"
    end
    
    if isMoving then
        if not self.walkEffect:isPlaying() then
            self.walkEffect:play()
        end
    else
        self.walkEffect:stop()
    end

    self.collider:setLinearVelocity(vx, vy) -- Do not scale velocity by dt here

    if not isMoving then
        self.anim:gotoFrame(1)
    end

    self.anim:update(dt)
    self.x = self.collider:getX()
    self.y = self.collider:getY()

    if love.keyboard.isDown("space") then
       local px, py = self.collider:getPosition() 
       if self.dir == "up" then
            py = py - 10
        elseif self.dir == "down" then
            py = py + 10
        elseif self.dir == "left" then
            px = px - 10
        elseif self.dir == "right" then
            px = px + 10
        end
       local colliders = world:queryCircleArea(px, py, 8, {"Sheep"})
    end

    if colliders and #colliders > 0 then
        for _, sheep in ipairs(colliders) do
            if sheep:getCollisionClass() == "Sheep" then
                self.NormalSheep:play()
            end
        end
    end
end

function Player:render()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, nil, nil, 8, 9.5)
end