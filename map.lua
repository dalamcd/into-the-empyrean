local tile = require('tile')

tileWidth = 32
tileHeight = 32

m = {
	tiles = {},
	width = 0,
	height = 0
}

function m:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function m:init(x, y)

	self.width = x
	self.height = y

	for r = 1, x do
		for c = 1, y do
			local index = ((r-1)*x+c)
			self.tiles[index] = tile:new()
			self.tiles[index]:init(self, c, r)
		end
	end
end

function m:getWidth()
	return self.width
end

function m:getHeight()
	return self.height
end

function m:getTile(x, y)
	return self.tiles[(y-1)*self.width+x]
end

function m:getTileIndex(x, y)
	return (y-1)*self.width+x
end

function m:getTileAtPos(x, y)
	for i, v in pairs(self.tiles) do
		if v:inTileBounds(x, y) then
			return v
		end
	end
end

return m