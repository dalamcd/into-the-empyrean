m = {

	x = 50,
	y = 50,
	velX = 0,
	velY = 0,
	destX = 0,
	destY = 0,
	speed = 100,
	map = nil,
	img = nil,
	moving = false,
	start = nil,
	goal = nil,
	moveNodes = {}
}

function m:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function m:init(img, map)
	self.img = love.graphics.newImage(img)
	self.map = map
	self.x = self.map:getTile(1, 1):getXPos()
	self.y = self.map:getTile(1, 1):getYPos()
	self:moveToTile(self.map:getTile(1, 1))
--  self.moveNodes = {self.map:getTile(5, 1), self.map:getTile(5,7), self.map:getTile(1,1)}
end

function m:width()
	return self.img:getWidth() or 1
end

function m:height()
	return self.img:getHeight() or 1
end

function m:moveToCoords(x, y)
	self.destX = x
	self.destY = y

	local run = x - self.x
	local rise = y - self.y
	local m = math.sqrt(run^2 + rise^2)

	self.velX = run / m
	self.velY = rise / m
end


function m:findRouteToTile(t)

	local start = {self.map:getTileAtPos(self.x, self.y)}
	local goal = t

	local possibleRoutes = {}
	table.insert(possibleRoutes, start)
	local tempRoutes = {}

	while(not routeFound) do

		for i, routes in ipairs(possibleRoutes) do

			for j, tile in ipairs(routes) do

				neighbors = {tile:getNeighbors()}
				
				for k, adjacentTile in ipairs(neighbors) do
					if( adjacentTile:isWalkable()) then

						local tempRoute = routes[i]
						table.insert(tempRoute, adjacentTile)
						if not self.checkForLoops(tempRoute) then table.insert(tempRoutes, tempRoute) end
					end
				end
			end
		end

		possibleRoutes = tempRoutes
		tempRoutes = {}
		routeFound = true
		for a, b in ipairs(possibleRoutes) do
			for c, d in ipairs(b) do
				print ("Route number: " .. a .. " Tile: " .. d:toString())
			end
		end
	end 
end

function m.checkForLoops(route)

	for i, v in ipairs(route) do
		for j, b in ipairs(route) do
			if b == v and (i ~= table.getn(route) and j ~= table.getn(route)) then
				return true
			end
		end
	end
	return false
end

function m:moveToTile(t)
	self:moveToCoords(t:getXPos(), t:getYPos())
end

function m:addTileToRoute(t)
	if self.moveNodes[table.getn(self.moveNodes)] ~= t then
		table.insert(self.moveNodes, t)
	end
end

function m:update(dt)

self.moving = false

	debugText2 = tostring(table.getn(self.moveNodes))

	if math.abs(self.destX - self.x) > 1 or math.abs(self.destY - self.y) > 1 then
		self.moving = true
		self.x = self.x + (self.velX * self.speed) * dt
		self.y = self.y + (self.velY * self.speed) * dt
	else
		self.destX = self.x
		self.destY = self.y
	end

	debugText = tostring(self.moving)

	if self.moving == false and table.getn(self.moveNodes) >= 1 then
		self:moveToTile(self.moveNodes[1])
		table.remove(self.moveNodes, 1)
	end
end

return m