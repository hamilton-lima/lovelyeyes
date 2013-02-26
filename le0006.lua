-- Example: Text with fill and border

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    text3 = Text:new("text3",5,5,"Lorem ipsum dolor sit amet, "
    .."\nconsectetur adipiscing elit. Mauris augue nibh, faucibus a, "
    .."\ncommodo id, rhoncus vitae, \nlorem. Vestibulum vehicula nisl "
    .."\nDonec sagittis. Ut nisi. Praesent feugiat felis id nunc. "
    .."\nDonec nec eros. Morbi dapibus, dui vel accumsan fermentum, "
    .."\ndolor augue euismod turpis, id congue urna lacus ac neque. Nullam ornare")
	text3.isDraggable = true   
	text3:setFont(love.default_font, 12)
	text3:setBorder(3)

	text4 = Text:new("text4",5,300,"Donec sagittis. Ut nisi. Praesent feugiat felis id nunc. "
    .."\nDonec nec eros. Morbi dapibus, dui vel accumsan fermentum, "
    .."\ndolor augue euismod turpis, id congue urna lacus ac neque. Nullam ornare")
	text4.isDraggable = true   
	text4:setFont(love.default_font, 15)
    text4.fillColor = NMSColor.BANANA

    text5 = Text:new("text5",5,450,"Donec sagittis. Ut nisi.\nPraesent feugiat felis id nunc")
	text5.isDraggable = true   
	text5:setFont(love.default_font, 30)
    text5.fillColor = NMSColor.BANANA
    text5.borderColor = NMSColor.APPLE
	text5:setBorder(4)
	
	group = Group:new("group")

	-- attention on the order that allows the transparent one over the other
	group:add(text4)
	group:add(text5)
    group:add(text3)
      
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