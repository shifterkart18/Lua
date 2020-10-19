--Window constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--Game constants
PADDLE_SPEED = 200
BALL_SIZE = 4

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
	math.randomseed(os.time())

	love.window.setTitle("Pong")

	love.graphics.setDefaultFilter('nearest', 'nearest')

	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)

	player1Score = 0
	player2Score = 0

	ball = Ball()
	paddle1 = Paddle(10, 10)
	paddle2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30)

	gameState = 'start'

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false, 
		vsync = true,
		resizable = false
	})
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		elseif gameState == 'play' then
			gameState = 'start'
			ball:reset()
		end
	end
end

function love.update(dt)
	if ball:collides(paddle1) then
		ball.dx = -ball.dx
	end

	if ball:collides(paddle2) then
		ball.dx = -ball.dx
	end

	if ball.y <= 0 then
		ball.dy = -ball.dy
		ball.y = 0
	end
	
	if ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
		ball.dy = -ball.dy
		ball.y = VIRTUAL_HEIGHT - BALL_SIZE
	end
	
	if love.keyboard.isDown('w') then
		paddle1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		paddle1.dy = PADDLE_SPEED
	else
		paddle1.dy = 0
	end

	if love.keyboard.isDown('up') then
		paddle2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('down') then
		paddle2.dy = PADDLE_SPEED
	else
		paddle2.dy = 0
	end

	paddle1:update(dt)
	paddle2:update(dt)

	if gameState == 'play' then
		ball:update(dt)
	end
end

function love.draw()
	push:apply('start')

	--clear the screen to a non black background (RGBA) 0 to 1.0
	love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)

	drawGameState()
	drawScore()
	
	paddle1:render()
	paddle2:render()
	ball:render()

	displayFPS()

	push:apply('end')
end

function drawGameState()
	--Make sure our hello world is centered and pretty
	love.graphics.setFont(smallFont)

	if gameState == 'start' then
		love.graphics.printf('Press enter to play', 0, 20, VIRTUAL_WIDTH, 'center')
	end
end

function drawScore()
	--Print the score
	love.graphics.setFont(scoreFont)
	love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayFPS()
	love.graphics.setColor(0, 1, 0, 1)
	love.graphics.setFont(smallFont)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20) --examples of string concat
	love.graphics.setColor(1, 1, 1, 1)
end