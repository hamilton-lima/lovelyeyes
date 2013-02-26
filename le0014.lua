-- Example: Editors/Text with keyboard layout 

function load()

    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    label = Text:new("label",20,20,"IN TESTS !!! Type in some text, the first one has an pt_BR keyboard layout.")    

    edit1 = Edit:new("edit1",20,50,10)    
    edit1.keyboard = Keyboard:new()
    edit1:setText("my pt_BR editor")

	edit2 = Edit:new("edit2",20,150,10)    
    edit2:setText("acao")
    
    text5 = Text:new("text5",5,450,"Ação", Keyboard:new())

	text5.isDraggable = true   
	text5:setFont(love.default_font, 30)
    text5.fillColor = NMSColor.BANANA
    text5.borderColor = NMSColor.APPLE
	text5:setBorder(4)
    
 	group = Group:new("Group")
	group:add(edit1)
	group:add(edit2)
	group:add(label)
	group:add(text5)
	
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