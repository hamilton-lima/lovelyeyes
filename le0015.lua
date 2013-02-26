-- Example: Creating Rounded box

function load()

    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    label = Text:new("label",20,20,"wow ! this is rounded !!")    
    box1= Polygon:roundedBox("box1",20,50,100,100, 10)    
    box2= Polygon:roundedBox("box2",20,190,100,100, 20)    
    box3= Polygon:roundedBox("box3",20,320,200,100, 30)    

 	group = Group:new("Group")
	group:add(label)
	group:add(box1)
	group:add(box2)	
	group:add(box3)
	
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