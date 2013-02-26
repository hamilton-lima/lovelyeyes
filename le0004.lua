-- Example: Wrapping components in a Group

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    text3 = Text:new("text3",5,5,"drag the mouse over the rectangles")

    text4 = Text:new("text4",5,100,"Im outside the Group")

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

	Group = Group:new("Group")
    Group:add(rec1)
    Group:add(rec2)
    Group:add(text3)
      
end

function draw()
	Group:draw()
	text4:draw()
end

function update(delta)
    Group:update(delta)
    text4:update(delta)
end

function mousepressed( x, y, button )
    Group:mousepressed( x, y, button )
    text4:mousepressed( x, y, button )
end

function mousereleased( x, y, button )
    Group:mousereleased( x, y, button )
    text4:mousereleased( x, y, button )
end 

function keypressed(key) 
    Group:keypressed(key)
    text4:keypressed(key)
end