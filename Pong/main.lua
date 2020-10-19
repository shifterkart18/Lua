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
	love.window.setTitle("Pong")

	love.graphics.setDefaultFilter('nearest', 'nearest')

	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)

	player1Score = 0
	player2Score = 0

	player1Y = 30
	player2Y = VIRTUAL_HEIGHT - 40

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false, 
		vsync = true,
		resizable = false
	})
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
end

function love.update(dt)
	if love.keyboard.isDown('w') then
		player1Y = player1Y - PADDLE_SPEED * dt
	elseif love.keyboard.isDown('s') then
		player1Y = player1Y + PADDLE_SPEED * dt
	end

	if love.keyboard.isDown('up') then
		player2Y = player2Y - PADDLE_SPEED * dt
	elseif love.keyboard.isDown('down') then
		player2Y = player2Y + PADDLE_SPEED * dt
	end
end

function love.draw()
	push:apply('start')

	--clear the screen to a non black background (RGBA) 0 to 1.0
	love.graphics.clear(
		40 / 255, 
		45 / 255, 
		52 / 255, 
		1)

	--Make sure our hello world is centered and pretty
	love.graphics.setFont(smallFont)
	love.graphics.printf(
		'Hello Pong!',
		0,
		20,
		VIRTUAL_WIDTH,
		'center')

	--Print the score
	love.graphics.setFont(scoreFont)
	love.graphics.print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
	love.graphics.print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
	
	--paddles
	love.graphics.rectangle('fill', 10, player1Y, PADDLE_WIDTH, PADDLE_HEIGHT)
	love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, PADDLE_WIDTH, PADDLE_HEIGHT)

	--ball
	love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, BALL_SIZE, BALL_SIZE)

	push:apply('end')
end