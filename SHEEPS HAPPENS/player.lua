Player = Class{}

function Player:init(x, y, speed)
    self.x = x
    self.y = y
    self.collider = world:newBSGRectangleCollider(40, 20, 40, 80, 14)
    self.collider:setFixedRotation(true)
    self.width = 32
    self.height = 32
    self.speed = speed
    self.spriteSheet= love.graphics.newImage('assets/FarmerSheet.png')
    self.grid = anim8.newGrid(16, 19, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations['up'] = anim8.newAnimation(self.grid('1-4', 1), 0.2)
    self.animations['left'] = anim8.newAnimation(self.grid('1-4', 2), 0.2)
    self.animations['down'] = anim8.newAnimation(self.grid('1-4', 3), 0.2)
    self.animations['right'] = anim8.newAnimation(self.grid('1-4', 4), 0.2)

    self.anim = self.animations.down
end

function Player:update(dt)
    local isMoving = false
    
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
        self.anim = self.animations.up
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
        self.anim = self.animations.right
        isMoving = true
    end

    if not isMoving then
        self.anim:gotoFrame(1)
    end

    self.anim:update(dt) 
    
end

function Player:render()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, nil, nil, 8, 9.5)
    love.graphics.pop()
end