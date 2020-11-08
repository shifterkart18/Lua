--Window constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--Game constants
PADDLE_SPEED = 200
BALL_SIZE = 4
SCORE_TO_WIN = 3
SPEED_MULT = 1.03

Class = require 'class'
push = require 'push'

require 'Ball'
require 'Paddle'

function love.load()
	math.randomseed(os.time())

	love.window.setTitle("Pong")
	love.graphics.setDefaultFilter('nearest', 'nearest')

	loadFonts()
	loadSounds()

	ball = Ball()
	paddle1 = Paddle(10, 10)
	paddle2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT - 30)

	resetGame()

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false, 
		vsync = true,
		resizable = true
	})
end

function love.resize(width, height)
	push:resize(width, height)
end

function loadFonts()
	smallFont = love.graphics.newFont('font.ttf', 8)
	scoreFont = love.graphics.newFont('font.ttf', 32)
	victoryFont = love.graphics.newFont('font.ttf', 24)
end

function loadSounds()
	sounds = {
		['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		['point_scored'] = love.audio.newSource('sounds/score.wav', 'static'),
		['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
	}
end

function resetGame()
	gameState = 'start'

	player1Score = 0
	player2Score = 0
	winningPlayer = 0

	servingPlayer = math.random(2) == 1 and 1 or 2

	ball:reset(servingPlayer)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'serve'
		elseif gameState == 'serve' then
			gameState = 'play'
		elseif gameState == 'victory' then
			resetGame()
		end
	end
end

function checkScore()
	if ball.x <= 0 then
		player2Score = player2Score + 1
		servingPlayer = 1
		ball:reset(servingPlayer)

		sounds['point_scored']:play()
		
		if player2Score >= SCORE_TO_WIN then
			gameState = 'victory'
			winningPlayer = 2
		else
			gameState = 'serve'
		end
	end

	if ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
		player1Score = player1Score + 1
		servingPlayer = 2
		ball:reset(servingPlayer)

		sounds['point_scored']:play()
		
		if player1Score >= SCORE_TO_WIN then
			gameState = 'victory'
			winningPlayer = 1
		else
			gameState = 'serve'
		end
	end
end

function checkPaddleCollision()
	if ball:collides(paddle1) then
		ball.dx = -ball.dx * SPEED_MULT
		ball.x = ball.x + 5
		
		if ball.dy < 0 then
			ball.dy = -math.random(10, 150)
		else
			ball.dy = math.random(10, 150)
		end

		sounds['paddle_hit']:play()
	end

	if ball:collides(paddle2) then
		ball.dx = -ball.dx * SPEED_MULT
		ball.x = ball.x - 4
		
		if ball.dy < 0 then
			ball.dy = -math.random(10, 150)
		else
			ball.dy = math.random(10, 150)
		end
		
		sounds['paddle_hit']:play()
	end
end

function checkWallCollision()
	if ball.y <= 0 then
		ball.dy = -ball.dy
		ball.y = 0
		sounds['wall_hit']:play()
	end
	
	if ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
		ball.dy = -ball.dy
		ball.y = VIRTUAL_HEIGHT - BALL_SIZE
		sounds['wall_hit']:play()
	end
end

function checkPaddleInput()
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
end

function love.update(dt)
	if gameState == 'play' then
		checkScore()
		checkPaddleCollision()
		checkWallCollision()
		
		ball:update(dt)
	end

	checkPaddleInput()

	paddle1:update(dt)
	paddle2:update(dt)
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
		love.graphics.printf('Welcome to Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Press Enter to Play!', 0, 32, VIRTUAL_WIDTH, 'center')
	elseif gameState == 'serve' then
		love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s Turn!", 0, 20, VIRTUAL_WIDTH, 'center')
		love.graphics.printf('Press Enter to Serve!', 0, 32, VIRTUAL_WIDTH, 'center')
	elseif gameState == 'victory' then
		love.graphics.setFont(victoryFont)
		love.graphics.printf("Player " .. tostring(winningPlayer) .. " Wins!", 0, 10, VIRTUAL_WIDTH, 'center')
		love.graphics.setFont(smallFont)
		love.graphics.printf('Press Enter to Play Again!', 0, 42, VIRTUAL_WIDTH, 'center')
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