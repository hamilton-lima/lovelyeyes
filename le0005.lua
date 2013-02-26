-- Example: Draggable multiline text

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    text3 = Text:new("text3",5,5,"Lorem ipsum dolor sit amet, "
    .."\nconsectetur adipiscing elit. Mauris augue nibh, faucibus a, "
    .."\ncommodo id, rhoncus vitae, \nlorem. Vestibulum vehicula nisl "
    .."tincidunt leo. Sed ligula massa,\n tincidunt id, mollis at, "
    .."\nvulputate in, turpis. Proin adipiscing diam. " 
    .."\nInteger facilisis, justo sed placerat varius, "
    .."\nnisl mi mattis neque, vitae suscipit arcu velit ut enim. "
    .."\nDonec sagittis. Ut nisi. Praesent feugiat felis id nunc. "
    .."\nDonec nec eros. Morbi dapibus, dui vel accumsan fermentum, "
    .."\ndolor augue euismod turpis, id congue urna lacus ac neque. Nullam ornare")
	text3.isDraggable = true   
	text3:setFont(love.default_font, 12)

	text4 = Text:new("text4",5,300,"Lorem ipsum dolor sit amet, "
    .."\nconsectetur adipiscing elit. Mauris augue nibh, faucibus a, "
    .."\ncommodo id, rhoncus vitae, \nlorem. Vestibulum vehicula nisl "
    .."tincidunt leo. Sed ligula massa,\n tincidunt id, mollis at, "
    .."\nvulputate in, turpis. Proin adipiscing diam. " 
    .."\nInteger facilisis, justo sed placerat varius, "
    .."\nnisl mi mattis neque, vitae suscipit arcu velit ut enim. "
    .."\nDonec sagittis. Ut nisi. Praesent feugiat felis id nunc. "
    .."\nDonec nec eros. Morbi dapibus, dui vel accumsan fermentum, "
    .."\ndolor augue euismod turpis, id congue urna lacus ac neque. Nullam ornare")
	text4.isDraggable = true   
	text4:setFont(love.default_font, 15)

	group = Group:new("Group")
    group:add(text3)
    group:add(text4)
      
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