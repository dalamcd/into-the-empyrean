platform = {}
player = {}

local pawn = require('pawn')
local map = require('map')
local tile = require('tile')

function love.load()

	math.randomseed(213423423)
	
	debugText = ""
	debugText2 = ""
	debugText3 = ""
	debugText4 = ""

	m = map:new()
	m:init(23, 18)

	p = pawn:new()
	p:init("purple.png", m)
	pawns = {p}

	debugText4 = m:getTile(5,5):toString()

end

function love.update(dt)

	if love.keyboard.isDown('escape') then
		love.event.quit()
	end

	if love.keyboard.isDown('a') then
		print(m:getTile(5, 5):toString())
	end

	if love.mouse.isDown(1) then
		t = m:getTileAtPos(love.mouse.getX(), love.mouse.getY()) or m:getTile(1, 1)
		p:findRouteToTile(t)
	end
--[[
		for i, v in pairs(m.tiles) do
			if v:inTileBounds(love.mouse.getX(), love.mouse.getY()) then
				p:moveToCoords(v:getXPos(), v:getYPos())
			end
		end
		--p:moveToCoords(love.mouse.getX(), love.mouse.getY())
	end
--]]
	for i, v in pairs(pawns) do
		v:update(dt)
	end

end

function love.draw()

	ydist = 12
	xdist = 650

	love.graphics.print(debugText, xdist, 0)
	love.graphics.print(debugText2, xdist, ydist)
	love.graphics.print(debugText3, xdist, ydist*2)
	love.graphics.print(debugText4, xdist, ydist*3)


	for i, v in pairs(m.tiles) do
		love.graphics.draw(v.img, v:getX()*tileWidth, v:getY()*tileHeight, 0, 1, 1)
	end

	if p.moving == true then

		love.graphics.line(p.x, p.y, p.destX, p.destY)
		
		if table.getn(p.moveNodes) == 1 then
			love.graphics.line(p.destX, p.destY, p.moveNodes[1]:getXPos(), p.moveNodes[1]:getYPos())
		end

		if table.getn(p.moveNodes) > 1 then
			love.graphics.line(p.destX, p.destY, p.moveNodes[1]:getXPos(), p.moveNodes[1]:getYPos())
			for i = 1, table.getn(p.moveNodes) - 1 do
				love.graphics.line(p.moveNodes[i]:getXPos(), p.moveNodes[i]:getYPos(), p.moveNodes[i+1]:getXPos(), p.moveNodes[i+1]:getYPos())
			end
		end
	end

	for i, v in pairs(pawns) do
		love.graphics.draw(v.img, v.x, v.y, 0, 1, 1, 16, 16)
	end
end