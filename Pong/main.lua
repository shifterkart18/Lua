--Window constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--Game constants
PADDLE_WIDTH = 5
PADDLE_HEIGHT = 20
PADDLE_SPEED = 200
BALL_SIZE = 5

push = require 'push'

function love.load()
	math.randomseed(os.time())

	love.window.setTitle("Pong")

	love.graphics.setDefaultFilter('nearest', 'nearest')

	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)

	player1Score = 0
	player2Score = 0

	player1Y = 30
	player2Y = VIRTUAL_HEIGHT - 40

	resetBall()

	gameState = 'start'

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false, 
		vsync = true,
		resizable = false
	})
end

function resetBall()
	ballX = VIRTUAL_WIDTH / 2 - 2
	ballY = VIRTUAL_HEIGHT / 2 - 2
	ballDX = math.random(2) == 1 and -100 or 100 --lua ternary operator equivalent
	ballDY = math.random(-50, 50)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		elseif gameState == 'play' then
			gameState = 'start'
			resetBall()
		end
	end
end

function love.update(dt)
	if love.keyboard.isDown('w') then
		player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
	elseif love.keyboard.isDown('s') then
		player1Y = math.min(VIRTUAL_HEIGHT - PADDLE_HEIGHT, player1Y + PADDLE_SPEED * dt)
	end

	if love.keyboard.isDown('up') then
		player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
	elseif love.keyboard.isDown('down') then
		player2Y = math.min(VIRTUAL_HEIGHT - PADDLE_HEIGHT, player2Y + PADDLE_SPEED * dt)
	end

	if gameState == 'play' then
		ballX = ballX + ballDX * dt
		ballY = ballY + ballDY * dt
	end
end

function love.draw()
	push:apply('start')

	--clear the screen to a non black background (RGBA) 0 to 1.0
	love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)

	drawGameState()
	drawScore()
	
	--paddles
	love.graphics.rectangle('fill', 10, player1Y, PADDLE_WIDTH, PADDLE_HEIGHT)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, PADDLE_WIDTH, PADDLE_HEIGHT)

	--ball
	love.graphics.rectangle('fill', ballX, ballY, BALL_SIZE, BALL_SIZE)

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