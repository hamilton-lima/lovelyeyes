Gradient = {}

Gradient.__index = Gradient

Gradient.VERTICAL = 1
Gradient.HORIZONTAL = 2

-- create the new text object
function Gradient:new(color1,color2)
   
    local me = {}
    setmetatable(me, Gradient)
	me.color1 = color1
	me.color2 = color2
	me.mode = Gradient.VERTICAL 
    return me
end

function Gradient:draw(x,y,w,h)
	if self.mode == Gradient.VERTICAL then
		self:vertical(x,y,w,h)
	elseif self.mode == Gradient.HORIZONTAL	then 
		self:horizontal(x,y,w,h)
	end
end

-- draw a vertical gradient in a polygon
function Gradient:verticalPoly(poly)
	
	local x = poly.x
	local y = poly.y
	local w = poly.w
	local h = poly.h
	local matrix = poly.matrix
	
	-- save the current color / point	
	local currentColor = love.graphics.getColor() 
	local currentLine = love.graphics.getLineWidth()  
	
	love.graphics.setLineWidth(2)
	love.graphics.setColor( self.color1 )

	-- start color	
	local red = self.color1:getRed()
	local green = self.color1:getGreen()
	local blue = self.color1:getBlue()
	
	local x1 = x + w
	
	-- steps of the gradient
	local stepRed = ( self.color2:getRed() - self.color1:getRed() ) / h
	local stepGreen = ( self.color2:getGreen() - self.color1:getGreen() ) / h
	local stepBlue = ( self.color2:getBlue() - self.color1:getBlue() ) / h

	-- each line 
	for i=1,h do
		love.graphics.setColor( red, green, blue )
		
		local foundFirstX = -1 
		local foundLastX = -1 

		-- each column		
		for j=1,w do

			-- found external
			if matrix[i][j] == 2 then
				if foundFirstX > 0 and foundLastX > 0 then
					love.graphics.line( x+foundFirstX-1, y+i, x+foundLastX, y+i )
					foundFirstX = -1 
					foundLastX = -1 
				end
			end
			
			if matrix[i][j] == 1 then
				if foundFirstX < 0 then
					foundFirstX = j 
					foundLastX = j 
				else
					foundLastX = j 
				end
			end
			
		end

		if foundFirstX > 0 and foundLastX > 0 then
			love.graphics.line( x+foundFirstX-1, y+i, x+foundLastX, y+i )
		end
		
		red = red + stepRed
		green = green + stepGreen
		blue = blue + stepBlue
	end
	
	love.graphics.setColor( currentColor )
	love.graphics.setLineWidth(currentLine)  
end

-- draw the vertical gradient
function Gradient:vertical(x,y,w,h)
	local currentColor = love.graphics.getColor() 
	local currentLine = love.graphics.getLineWidth()  
	
	love.graphics.setLineWidth(2)
	love.graphics.setColor( self.color1 )
	
	local red = self.color1:getRed()
	local green = self.color1:getGreen()
	local blue = self.color1:getBlue()
	
	local x1 = x + w
	
	local stepRed = ( self.color2:getRed() - self.color1:getRed() ) / h
	local stepGreen = ( self.color2:getGreen() - self.color1:getGreen() ) / h
	local stepBlue = ( self.color2:getBlue() - self.color1:getBlue() ) / h
	
	for n=y+2, y+(h-2),1 do
		love.graphics.setColor( red, green, blue )
		love.graphics.line( x, n, x1, n ) 
		
		red = red + stepRed
		green = green + stepGreen
		blue = blue + stepBlue
	end
	
	love.graphics.setColor( self.color2 )
	love.graphics.line( x, y+h-2, x1, y+h-2 ) 
	love.graphics.setColor( currentColor )
	love.graphics.setLineWidth(currentLine)  

end

-- draw the horizontal gradient
function Gradient:horizontal(x,y,w,h)
	local currentColor = love.graphics.getColor() 
	local currentLine = love.graphics.getLineWidth()  
	
	love.graphics.setLineWidth(2)
	love.graphics.setColor( self.color1 )
	
	local red = self.color1:getRed()
	local green = self.color1:getGreen()
	local blue = self.color1:getBlue()
	
	local y1 = y + h
	
	local stepRed = ( self.color2:getRed() - self.color1:getRed() ) / w
	local stepGreen = ( self.color2:getGreen() - self.color1:getGreen() ) / w
	local stepBlue = ( self.color2:getBlue() - self.color1:getBlue() ) / w
	
	for n=x+2, x+(w-3),1 do
		love.graphics.setColor( red, green, blue )
		love.graphics.line( n, y, n, y1 ) 
		
		red = red + stepRed
		green = green + stepGreen
		blue = blue + stepBlue
	end
	
	love.graphics.setColor( self.color2 )
	love.graphics.line( x+w-2, y, x+w-2, y1 ) 
	love.graphics.setColor( currentColor )
	love.graphics.setLineWidth(currentLine)  

end

