-- Example: Simple one line Edit

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 
    label = Text:new("label",20,20,"Type in some text")    
    edit1 = Edit:new("edit1",20,50,10)    
    edit1:setText("abcdefghijklmnopqrstuvxwyz")

	group = Group:new("Group")
	group:add(edit1)
	group:add(label)
	edit1:requestFocus()
      
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