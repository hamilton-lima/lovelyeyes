-- Example: OnMouseOver and OnMouseOut event handlers

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    text3 = Text:new("text3",5,5,"drag the mouse over the rectangles")

    rec1 = Rectangle:new("rec1",30,30,50,50)    
    rec2 = Rectangle:new("rec2",50,50,50,50)
    rec2.isDraggable = true   
    
    rec2.onMouseOver = function(self)
        self.fillColor = NMSColor.BROCCOLI
        text3:setText("mouse over")
    end
    
    rec2.onMouseOut= function(self)
        self.fillColor = NMSColor.AVOCADO
        text3:setText("mouse out")
    end

      
end

function draw()
	rec1:draw()
	rec2:draw()
	text3:draw()
end

function update(delta)
    rec1:update(delta)
    rec2:update(delta)
    text3:update(delta)
end

function mousepressed( x, y, button )
    rec1:mousepressed( x, y, button )
    rec2:mousepressed( x, y, button )
    text3:mousepressed( x, y, button )
end

function mousereleased( x, y, button )
    rec1:mousereleased( x, y, button )
    rec2:mousereleased( x, y, button )
    text3:mousereleased( x, y, button )
end 

function keypressed(key) 
    rec1:keypressed(key)
    rec2:keypressed(key)
    text3:keypressed(key)
end