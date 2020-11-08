Ball = Class{}

MIN_DX = 140
MAX_DX = 200

function Ball:init()
    self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
    self.width = BALL_SIZE
    self.height = BALL_SIZE
    self.dx = 0
	self.dy = 0
end

function Ball:collides(box)
    if self.x > box.x + box.width or self.x + self.width < box.x then
        return false
    end

    if self.y > box.y + box.height or self.y + self.height < box.y then
        return false
    end

    return true
end

function Ball:reset(servingPlayer)
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = math.random(-50, 50) * 1.5
    
    if servingPlayer == 1 then
		ball.dx = math.random(MIN_DX, MAX_DX)
	else
		ball.dx = -math.random(MIN_DX, MAX_DX)
	end 
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end