-- Example: Save the current state of the objects

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    text1 = Text:new("text1",5,5,"To help the positioning of the components\n"
    .."just add to a Group make all of then draggable thru the Group\n"
    .."and call the method dump() for the Group or for one component")

	text2 = Text:new("text2",5,300,"Donec sagittis. Ut nisi. Praesent feugiat felis id nunc. "
    .."\nDonec nec eros. Morbi dapibus, dui vel accumsan fermentum, "
    .."\ndolor augue euismod turpis, id congue urna lacus ac neque. Nullam ornare")

	text3 = Text:new("text3",5,70,"press: 1 to enable/disable dragging, 2 to dump()")
	message = Text:new("message",5,100,"...")

    rec1 = Rectangle:new("rec1",520,20,150,150)    
    rec2 = Rectangle:new("rec2",530,30,150,150)

	group = Group:new("Group")

	-- attention on the order that allows the transparent one over the other
	group:add(text1)
	group:add(text2)
	group:add(text3)
	group:add(message)
	group:add(rec1)
	group:add(rec2)
      
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
    
	if key == love.key_1 then
		if group.forceDragging then 
            group.forceDragging = false
            message:setText("Group Dragging disabled")
        else
            group.forceDragging = true
            message:setText("Group Dragging ENABLED")
        end 
	end    
	
	if key == love.key_2 then
		group:dump()
        message:setText("dump saved on : " .. love.filesystem.getSaveDirectory()) 
	end    
	
	
end