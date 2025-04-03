Player = Class{}

function Player:init()
    self.x = 200
    self.y = 200
    self.width = 16
    self.height = 19
    self.collider = world:newBSGRectangleCollider(self.x, self.y, self.width, self.height, 4) -- Use self.x and self.y here
    self.collider:setFixedRotation(true)
    self.speed = 600 -- Set a reasonable speed value
    self.spriteSheet = love.graphics.newImage('assets/FarmerSheet.png')
    self.grid = anim8.newGrid(16, 19, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {
        up = anim8.newAnimation(self.grid('1-4', 1), 0.2),
        left = anim8.newAnimation(self.grid('1-4', 2), 0.2),
        down = anim8.newAnimation(self.grid('1-4', 3), 0.2),
        right = anim8.newAnimation(self.grid('1-4', 4), 0.2)
    }

    self.anim = self.animations.down
end

function Player:update(dt)
    local isMoving = false
    local vx, vy = 0, 0

    if love.keyboard.isDown("w") then
        vy = -self.speed -- Apply speed directly
        self.anim = self.animations.up
        isMoving = true
    end
    if love.keyboard.isDown("a") then
        vx = -self.speed -- Apply speed directly
        self.anim = self.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("s") then
        vy = self.speed -- Apply speed directly
        self.anim = self.animations.down
        isMoving = true
    end
    if love.keyboard.isDown("d") then
        vx = self.speed -- Apply speed directly
        self.anim = self.animations.right
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, vy) -- Do not scale velocity by dt here

    if not isMoving then
        self.anim:gotoFrame(1)
    end

    self.anim:update(dt)
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Player:render()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, nil, nil, 8, 9.5)
end