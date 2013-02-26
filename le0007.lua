-- Example: NMSColors 

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    text1 = Text:new("text1",5,5,"This is a set of cool colors")
    text2 = Text:new("text2",5,25,"...")

    group = Group:new("group")
	group:add(text1)
	group:add(text2)

    x = 10
    y = 50


    for key, value in pairs( NMSColor ) do 
		local foo = Rectangle:new("foo",x,y,50,50)
		foo.fillColor = value
		foo.colorName = key
		
		foo.onMouseOver = function(self)
        	text2:setText(self.colorName)
    	end

		group:add(foo)
	
		x = x + 60
		if x > 400 then
			x = 10
			y = y + 60
		end
	end
      
end

function draw()
	group:draw()
end

function update(delta)
    group:update(delta)
end

function mousepressed( x, y, button )
    group:mousepressed( x, y, button )
end

function mousereleased( x, y, button )
    group:mousereleased( x, y, button )
end 

function keypressed(key) 
    group:keypressed(key)
end