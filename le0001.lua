-- Example: Create rectangles

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    rec1 = Rectangle:new("rec1",20,20,150,150)    
    rec2 = Rectangle:new("rec2",30,30,150,150)    
end

function draw()
	rec1:draw()
	rec2:draw()
end

