-- Example: Draggable Rectangles

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 
    rec1 = Rectangle:new("rec1",20,20,150,150)    
    rec2 = Rectangle:new("rec2",30,30,150,150)
    rec2.isDraggable = true     
end

function draw()
	rec1:draw()
	rec2:draw()
end

function update(delta)
    rec1:update(delta)
    rec2:update(delta)
end

function mousepressed( x, y, button )
    rec1:mousepressed( x, y, button )
    rec2:mousepressed( x, y, button )
end

function mousereleased( x, y, button )
    rec1:mousereleased( x, y, button )
    rec2:mousereleased( x, y, button )
end 

function keypressed(key) 
    rec1:keypressed(key)
    rec2:keypressed(key)
end