Polygon = {}

Polygon.__index = function (table, key)
    if Polygon[key] ~= nil then
        return Polygon[key]
    else 
        return Rectangle[key]
    end
end

-- create the new text object
function Polygon:new(id,x,y,w,h)
    local me = Rectangle:new(id,x,y,w,h)
    setmetatable(me, Polygon)
    me.points = {}
    me.matrix = {}
    me.fillSegments = nil

    -- propagate all the dragging X,Y to the polygon
    table.insert(me.onDragging, function(self,dragX,dragY)
    	trace:setText( trace.text .. "drag" .. dragX .. " " .. dragY)
		self:updatePoints(self,dragX,dragY)
	end)
        
    return me
end

function Polygon:draw()

	if self.gradient ~= nil then
		self.gradient:verticalPoly(self)
		
    elseif self.fillColor ~= mil then
    	love.graphics.setColor( self.fillColor )
    	if self.fillSegments == nil then
    		love.graphics.polygon(love.draw_fill, self.points)
    	else 
    		-- make the fill in small chunks
    		for n=1, table.getn(self.fillSegments) do
    			love.graphics.polygon(love.draw_fill, self.fillSegments[n])
    		end
    	end
	end
	
    -- border
    if self.borderColor ~= mil then
    	local currentLine = love.graphics.getLineWidth()
    	love.graphics.setLineWidth(self.border)
	    love.graphics.setColor(self.borderColor)
	    love.graphics.polygon(love.draw_line, self.points)
    	love.graphics.setLineWidth(currentLine)
    end
	
end

-- update all the points during the dragging
-- 
function Polygon:updatePoints(dragX,dragY)

	if self.fillSegments ~= nil then
		for n=1, table.getn(self.fillSegments) do
			for m=1, table.getn(self.fillSegments[n])-1,2 do 
				self.fillSegments[n][m] = self.fillSegments[n][m] - dragX
				self.fillSegments[n][m+1] = self.fillSegments[n][m+1] - dragY
    		end
    	end
    end

	for m=1, table.getn(self.points[n])-1,2 do 
		self.points[n][m] = self.points[n][m] - dragX
		self.points[n][m+1] = self.points[n][m+1] - dragY
    end
    
    self:updateMatrix()

end


-- updates the polygon information 
-- x,y
-- w,h 
-- a matrix data with 0/1 where 1 means a point
--   that starts from x,y
--
function Polygon:updateMatrix()

    local calculatedPoints = self:getAllSegmentsPoints()
    
    local minX = calculatedPoints[1]
    local maxX = calculatedPoints[1]
    local minY = calculatedPoints[2]
    local maxY = calculatedPoints[2]
    
    -- identify the height of the polygon
    for n=1, table.getn(calculatedPoints)-1,2 do
    	local x = calculatedPoints[n]
    	local y = calculatedPoints[n+1]
    	if y > maxY then maxY = y end
    	if y < minY then minY = y end
    	if x > maxX then maxX = x end
    	if x < minX then minX = x end
    end

    -- calculates the height width of the polygon
    self.h = maxY - minY
    self.w = maxX - minX
    
    -- this will be used as refence to draw the matrix
    self.x = minX
    self.y = minY
    
    -- use the matrix to add to the result 
    -- number the matrix from 1 to width and height
    -- and add to the x,y 
    self.matrix = {}
    for i = 1,self.h do
		self.matrix[i] = {}
		for j = 1,self.w do
			self.matrix[i][j] = 0
		end
	end

    -- store the column values in the lines
    for n=1, table.getn(calculatedPoints)-1,2 do
    	local x = calculatedPoints[n]
    	local y = calculatedPoints[n+1]
    	
    	local i = y -self.y +1
    	local j = x -self.x +1

    	if i > self.h then 
    		i = self.h
    	end

    	if j > self.w then 
    		j = self.w
    	end

		self.matrix[i][j] = 1
    end
    
	self:fillMatrixExternalPoints()
    
end

-- fill the external points of the polygon
-- in order to identify what points are internal
-- and what points are external to the polygon at the 
-- matrix, so the gradient can identify the internal ones
-- will fill the external with "2"
--
function Polygon:fillMatrixExternalPoints()

	-- fill top down
	for j = 1,self.w do
		for i = 1,self.h do
			if self.matrix[i][j] == 1 then
				break
			end
			self.matrix[i][j] = 2
		end
	end

	-- fill bottom up
	for j = 1,self.w do
		for i = self.h,1,-1 do
			if self.matrix[i][j] == 1 then
				break
			end
			self.matrix[i][j] = 2
		end
	end

	-- fill left right
	for i =1, self.h do
		for j = 1,self.w do
			if self.matrix[i][j] == 1 then
				break
			end
			self.matrix[i][j] = 2
		end
	end

	-- fill right left
	for i =1, self.h do
		for j = self.w,1,-1 do
			if self.matrix[i][j] == 1 then
				break
			end
			self.matrix[i][j] = 2
		end
	end
	
end

-- calculates all the points from the segments
--
function Polygon:getAllSegmentsPoints()

	local result = {}

	-- from first to last point
	for n=1, table.getn(self.points)-3, 2 do 
		local temp = Polygon:getSegmentPoints( 
			self.points[n], self.points[n+1], 
			self.points[n+2], self.points[n+3] )
		for i=1,table.getn(temp),1 do
			table.insert(result,temp[i])
		end
	end
	
	-- from the last to the first point
	temp = Polygon:getSegmentPoints( 
		self.points[table.getn(self.points)-1], self.points[table.getn(self.points)], 
		self.points[1], self.points[2] )
		
	for i=1,table.getn(temp),1 do
		table.insert(result,temp[i])
	end

	return result
end


-- calculate the points from x,y to x1,y1
-- this can be used to the gradient fill, 
-- or to split a line in 2 pieces
function Polygon:getSegmentPoints(x,y,x1,y1)

	local difX = (x1 - x) 
	local difY = (y1 - y) 
	local result = {}
	local step = 1
	local directionX = 1
	local directionY = 1
	
	if difX < 0 then directionX = -1 end
	if difY < 0 then directionY = -1 end
	
	difX = math.abs(difX)
	difY = math.abs(difY)

	table.insert( result, x )
	table.insert( result, y )
	
	-- step from x to x1, calculate the % of each step related
	-- to the total dif and apply the same % to the y of the step
	if difX > difY then 

		for n=1,difX,step do 
			table.insert( result, x+(n*directionX) )

			if difY ~= 0 then 
				table.insert( result, y + (math.ceil( (n / difX) * difY) * directionY )  )
			else 
				table.insert( result, y )
			end
		end
	else 

		for n=1,difY,step do 
			if difX ~= 0 then 
				table.insert( result, x + ( math.ceil( (n / difY) * difX) * directionX ) )
			else 
				table.insert( result, x )
			end
	
			table.insert( result, y +(n*directionY) )
		end
	end

	table.insert( result, x1 )
	table.insert( result, y1 )

	return result
end



-- create the triangle Polygon
-- return a list of pair of points
function Polygon:triangle(id,x,y,w,h)
	local me = Polygon:new(id,x,y,w,h)

	me.points = { x+(w/2),y, x+w,y+h, x,y+h }
	me:updateMatrix()
	
	return me
end

-- create a regular Polygon
-- inside a circunference
function Polygon:star(id,x,y,w,sides,innerHeight)
	local me = Polygon:new(id,x,y,w,w)
	me.sides = sides

	local radius = w / 2
	local sideAngle = 360 / sides
	local halfSideAngle = sideAngle / 2
	local startX = x 
	local startY = y 

	-- point #1 
	table.insert( me.points, x + radius )
	table.insert( me.points, y )

	local currentAngle = math.rad( halfSideAngle )
	local tcos = math.ceil(innerHeight * math.cos( currentAngle ) )
	local tsin = math.ceil(innerHeight * math.sin( currentAngle ) )
	table.insert( me.points, x + radius + tsin )
	table.insert( me.points, y + radius - tcos )

	for n=1,sides-1 do 
		currentAngle = math.rad(sideAngle * n)
		tcos = math.ceil(radius * math.cos( currentAngle ) )
		tsin = math.ceil(radius * math.sin( currentAngle ) )
		table.insert( me.points, x + radius + tsin )
		table.insert( me.points, y + radius - tcos )

		currentAngle = math.rad((sideAngle * n) + halfSideAngle )
		tcos = math.ceil(innerHeight * math.cos( currentAngle ) )
		tsin = math.ceil(innerHeight * math.sin( currentAngle ) )
		table.insert( me.points, x + radius + tsin )
		table.insert( me.points, y + radius - tcos )
	end

	-- make the fillSegments
	me.fillSegments = {}
	
	-- cut the star external triangles
	for n=3,table.getn(me.points)-5,4 do
		local triangle = {}
		table.insert( triangle, me.points[n])
		table.insert( triangle, me.points[n+1])
		table.insert( triangle, me.points[n+2])
		table.insert( triangle, me.points[n+3])
		table.insert( triangle, me.points[n+4])
		table.insert( triangle, me.points[n+5])
		
		table.insert( me.fillSegments, triangle)
	end

	local triangle = {}
	table.insert( triangle, me.points[table.getn(me.points)-1])
	table.insert( triangle, me.points[table.getn(me.points)])
	table.insert( triangle, me.points[1])
	table.insert( triangle, me.points[2])
	table.insert( triangle, me.points[3])
	table.insert( triangle, me.points[4])
	table.insert( me.fillSegments, triangle)

	-- inner polygon
	local inner = {}
	for n=3,table.getn(me.points),4 do
		table.insert( inner, me.points[n])
		table.insert( inner, me.points[n+1])
	end
	table.insert( me.fillSegments, inner)
	
		
	me:updateMatrix()
	return me
end

-- create a regular Polygon
-- inside a circunference
function Polygon:regularPolygon(id,x,y,w,sides)
	local me = Polygon:new(id,x,y,w,w)
	me.sides = sides

	local radius = w / 2
	local sideAngle = 360 / sides
	local startX = x 
	local startY = y 

	-- point #1 
	table.insert( me.points, x + radius )
	table.insert( me.points, y )

	for n=1,sides-1 do 
		local currentAngle = math.rad(sideAngle * n)
		local tcos = math.ceil(radius * math.cos( currentAngle ) )
		local tsin = math.ceil(radius * math.sin( currentAngle ) )
		table.insert( me.points, x + radius + tsin )
		table.insert( me.points, y + radius - tcos )
	end

	me:updateMatrix()
	return me
end


-- create the new roundedBox Polygon
-- return a list of pair of points
function Polygon:roundedBox(id,x,y,w,h,arc)
	local me = Polygon:new(id,x,y,w,h)

	me.points = {}
	me.arc = arc
	
	-- top left
	local startX = x + arc
	local startY = y + arc
	local arcPoints = Polygon:topLeftArc(arc)
	for n=1,table.getn( arcPoints)-1,2 do
		table.insert( me.points, startX - arcPoints[n] )
		table.insert( me.points, startY - arcPoints[n+1] )
	end	
		
	-- top right
	startX = x + w -arc
	startY = y
	local arcPoints = Polygon:topRightArc(arc)
	for n=1,table.getn( arcPoints)-1,2 do
		table.insert( me.points, startX + arcPoints[n] )
		table.insert( me.points, startY + arcPoints[n+1] )
	end	
	
	-- bottom right
	startX = x + w - arc
	startY = y + h - arc
	local arcPoints = Polygon:bottomRightArc(arc)
	for n=1,table.getn( arcPoints)-1,2 do
		table.insert( me.points, startX + arcPoints[n] )
		table.insert( me.points, startY + arcPoints[n+1] )
	end	

	-- bottom left
	startX = x + arc
	startY = y + h - arc
	local arcPoints = Polygon:bottomLeftArc(arc)
	for n=1,table.getn( arcPoints)-1,2 do
		table.insert( me.points, startX - arcPoints[n] )
		table.insert( me.points, startY + arcPoints[n+1] )
	end	

	me:updateMatrix()
	return me
end

-- calculate a list of points of a top/right arc
function Polygon:topRightArc(arc)
	local points = {}
	
	for x=1,arc,1 do
		table.insert( points, x )
		table.insert( points, arc - math.ceil(math.sqrt(arc^2 - x^2)) ) 
	end
	
	return points
end

-- calculate a list of points of a bottom/right arc
function Polygon:bottomRightArc(arc)
	local points = {}
	
	for x=arc,1,-1 do
		table.insert( points, x )
		table.insert( points, math.ceil(math.sqrt(arc^2 - x^2)) ) 
	end
	
	return points
end

-- calculate a list of points of a bottom/left arc
function Polygon:bottomLeftArc(arc)
	local points = {}
	
	for x=1,arc,1 do
		table.insert( points, x )
		table.insert( points, math.ceil(math.sqrt(arc^2 - x^2)) ) 
	end
	
	return points
end

-- calculate a list of points of a bottom/left arc
function Polygon:topLeftArc(arc)
	local points = {}
	
	for x=arc,1,-1 do
		table.insert( points, x )
		table.insert( points, math.ceil(math.sqrt(arc^2 - x^2)) ) 
	end
	
	return points
end
