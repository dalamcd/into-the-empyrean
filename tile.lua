m = {
	x = 0,
	y = 0,
}

function m:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function m:init(m, x, y, tileType)
	self.map = m
	self.x = x
	self.y = y
	self.tileType = tileType or math.random(3)
	if self.tileType == 3 then
		if math.random(2) > 1 then
			self.tileType = 2
		end
	end

	if self.tileType == 1 then
		self.img = love.graphics.newImage("spots.png")
	elseif self.tileType == 2 then
		self.img = love.graphics.newImage("green.png")
	elseif self.tileType == 3 then
		self.img = love.graphics.newImage("green.png")
	else 
		self.img = love.graphics.newImage("purple.png")
	end
end

function m:toString()
	return "X: " .. self.x .. ", Y: " .. self.y

end

function m:isWalkable()
	if self.tileType == 1 then
		return false
	end
	return true
end

function m:getX()
	return self.x
end

function m:getY()
	return self.y
end

function m:getXPos()
	return self.x * tileWidth + (tileWidth/2)
end

function m:getYPos()
	return self.y * tileHeight + (tileHeight/2)
end

function m:getIndex()
	return self.map:getTileIndex(self.x, self.y)
end

function m:getNeighbor(dir)

	if dir == 'north' then
		if(self:getY() <= 1) then
			return self
		else
			return self.map:getTile(self:getX(), self:getY()-1)
		end
	elseif dir == 'northeast' then
		if(self:getY() <= 1) or (self:getX() >= self.map:getWidth()) then
			return self
		else
			return self.map:getTile(self:getX()+1, self:getY()-1)
		end
	elseif dir == 'east' then
		if(self:getX() >= self.map:getWidth()) then
			return self
		else
			return self.map:getTile(self:getX()+1, self:getY())
		end
	elseif dir == 'southeast' then
		if(self:getX() >= self.map:getWidth()) or (self:getY() >= self.map:getHeight()) then
			return self
		else
			return self.map:getTile(self:getX()+1, self:getY()+1)
		end
	elseif dir == 'south' then
		if(self:getY() >= self.map:getHeight()) then
			return self
		else
			return self.map:getTile(self:getX(), self:getY()+1)
		end
	elseif dir == 'southwest' then
		if(self:getX() <= 1) or (self:getY() >= self.map:getHeight()) then
			return self
		else
			return self.map:getTile(self:getX()-1, self:getY()+1)
		end
	elseif dir == 'west' then
		if(self:getX() <= 1) then
			return self
		else
			return self.map:getTile(self:getX()-1, self:getY())
		end
	elseif dir == 'northwest' then
		if(self:getX() <= 1) or (self:getY() <= 1) then
			return self
		else
			return self.map:getTile(self:getX()-1, self:getY()-1)
		end
	else return self
	end
end

function m:getNeighbors(corners)
	if corners then
		return self:getNeighbor('north'), self:getNeighbor('northeast'), self:getNeighbor('east'), self:getNeighbor('southeast'),
				self:getNeighbor('south'), self:getNeighbor('southwest'), self:getNeighbor('west'), self:getNeighbor('northwest')
	else
		return self:getNeighbor('north'), self:getNeighbor('east'), self:getNeighbor('south'), self:getNeighbor('west')
	end
end

function m:inTileBounds(x, y)
--	debugText = "X, Y: " .. x .. " " .. y .. "\n" .. self:getXPos() .. " " .. self:getYPos()

--	if (x == self:getXPos()) and (y == self:getYPos()) then
	if( x - self:getX()*tileWidth < tileWidth and x - self:getX()*tileWidth > 0) then
		if( y - self:getY() * tileHeight < tileHeight and y - self:getY() * tileHeight > 0) then
			return true
		end
	end
	return false
end

return m

