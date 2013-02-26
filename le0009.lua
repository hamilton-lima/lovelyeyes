-- Example: Focus on components and focus cycle

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 

    text1 = Text:new("text1",100,100,"Use Tab to cycle the Focus \nand Enter to run the action")
	text1:setFont(love.default_font, 30)
    text1.fillColor = NMSColor.BANANA
    text1.borderColor = NMSColor.APPLE
    text1.onClick = function(self)
    	if self.fillColor ~= nil then
    		self.fillColor = nil
    	else 
    		self.fillColor = NMSColor.BANANA
    	end
    end

    text2 = Text:new("text2",100,200,"Donec sagittis. Ut nisi.\nPraesent feugiat felis id nunc")
	text2:setFont(love.default_font, 30)
    text2.fillColor = NMSColor.BANANA
    text2.borderColor = NMSColor.APPLE
    text2.onClick = text1.onClick 

    text3 = Text:new("text3",100,300,"Donec sagittis. Ut nisi.\nPraesent feugiat felis id nunc")
	text3:setFont(love.default_font, 30)
    text3.fillColor = NMSColor.BANANA
    text3.borderColor = NMSColor.APPLE
    text3.onClick = text1.onClick 
        
    text4 = Text:new("text4",100,400,"Donec sagittis. Ut nisi.\nPraesent feugiat felis id nunc")
	text4:setFont(love.default_font, 30)
    text4.fillColor = NMSColor.BANANA
    text4.borderColor = NMSColor.APPLE
    text4.onClick = text1.onClick 
    
    text1.canHaveFocus = true
	-- no focus on #2
    text3.canHaveFocus = true
    text4.canHaveFocus = true

    text4:requestFocus()	
    
	group = Group:new("Group")

	group:add(text1)
	group:add(text2)
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