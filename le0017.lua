-- Example: Using Sprites

function load()

    love.graphics.setBackgroundColor( ColorUtil.WHITE ) 
	love.graphics.setLineStyle( love.line_smooth )

	label = Text:new("label",20,20,"sprites are cool... =)") 
    sprite1 = Sprite:new("sprite1",120,120,"images/cow.png") 
       
 	group = Group:new("Group")
	group:add(label)
	group:add(sprite1)
	group.forceDragging = true
	
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