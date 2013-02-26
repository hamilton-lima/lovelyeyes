-- Example: Buttons

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    edit1 = Edit:new("edit1",33,58,10)
	edit2 = Edit:new("edit2",174,59,10)
	button1 = Button:new("button1",28,93,"copy 1")
	button2 = Button:new("button2",171,94,"copy 2")
	button3 = Button:new("button3",171,150,"red button")

	
	button3:setColor( NMSColor.RED_PEPPER )
    
    label = Text:new("label",20,20,"click on the buttons to move the text.")    

    edit1:setText("1234")
    edit2:setText("      ")

	button1.onClick = function(self)
        edit1:setText(edit2.text)
        edit2:setText(" ")
    end

    button2.onClick = function(self)
        edit2:setText(edit1.text)
        edit1:setText(" ")
    end

	group = Group:new("Group")
	group:add(edit1)
	group:add(edit2)
	group:add(button1)
	group:add(button2)
	group:add(button3)
	group:add(label)
      
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