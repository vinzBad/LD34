-- # TODOS
-- [x] random list of dots
-- [x] each planet has one quality and one need, represented by dots
-- [x] spaceships fly between those planets
-- [ ] gameplay
-- [ ] ???
-- [ ] PROOOFIT


local game = { 
	planetSize = 32,
	planetCount = 10,
	shipSize = 8,
	shipCount = 40,
	qualities = {
		{11, 118, 0},
		{2, 75, 89}, 
		{212, 118, 28}, 
		{142, 0, 7}
	}
}

function game.init()
	love.graphics.setLineWidth( 2 )
	game.planets = {}
	for i = 0,game.planetCount do
		repeat
			x=love.math.random(game.planetSize,love.graphics.getWidth() - game.planetSize)
			y=love.math.random(game.planetSize,love.graphics.getHeight() - game.planetSize)
		until(game.isValidPlanetPos(x,y))
		q = math.random(#game.qualities)
		repeat
			n = math.random(#game.qualities)
		until(q ~= n)
		game.planets[i] = {id=i, x=x, y=y, quality=game.qualities[q], need=game.qualities[n]}
	end	
	game.ships = {}
	
	for i = 0,game.shipCount do 
		repeat
			x=love.math.random(game.shipSize,love.graphics.getWidth() - game.shipSize)
			y=love.math.random(game.shipSize,love.graphics.getHeight() - game.shipSize)
		until(game.isValidShipPos(x,y))
		game.ships[i] = {id=i, x=x, y=y, target=game.planets[math.random(#game.planets)]}
	end 
	
end

function game.isValidPlanetPos(x,y)
	for i, planet in ipairs(game.planets) do
		if math.pow(game.planetSize *5, 2) > math.pow(x-planet.x, 2) + math.pow(y-planet.y, 2) then
			return false
		end
	end
	return true
end

function game.isValidShipPos(x,y)
	for i, ship in ipairs(game.ships) do
		if math.pow(game.shipSize *5, 2) > math.pow(x-ship.x, 2) + math.pow(y-ship.y, 2) then
			return false
		end
	end
	return true
end

function love.load(arg)
	game.init()
end

local accu = 0
local timer = 0.1
function love.update(dt)
	accu = accu + dt
	if accu >= timer then
		accu = accu - timer
		-- game.init() -- uncomment this for seizures
	end
	
	for i, ship in ipairs(game.ships) do
		dx = ship.target.x  - ship.x 
		dy = ship.target.y  - ship.y
		l = (math.sqrt(dx * dx + dy * dy))
		dx = dx / l
		dy = dy / l
		ship.x = ship.x + dx * 100 * dt
		ship.y = ship.y + dy * 100 * dt
		if math.pow(game.planetSize , 2) > math.pow(ship.x-ship.target.x, 2) + math.pow(ship.y-ship.target.y, 2) then
			id = ship.target.id
			repeat
				ship.target = game.planets[math.random(#game.planets)]
			until (id ~= ship.target.id)
		end
	end
end

function love.keypressed(key)
	if key=='escape' then
		love.event.push('quit')
	end	
	if key==' ' then
		game.init()
	end
end

function love.draw(dt)	
	
	for i, planet in ipairs(game.planets) do
		love.graphics.setColor(255, 255, 255)
		love.graphics.circle("fill", planet.x, planet.y, game.planetSize, 32)
		love.graphics.setColor(planet.quality)
		love.graphics.circle("fill", planet.x - 10, planet.y, 8, 32)
		love.graphics.setColor(planet.need)
		love.graphics.circle("line", planet.x + 10, planet.y, 8, 32)
	end
	for i, ship in ipairs(game.ships) do
		love.graphics.setColor(227, 148, 72)
		love.graphics.circle("fill", ship.x, ship.y, game.shipSize, 32)	
	end
end
