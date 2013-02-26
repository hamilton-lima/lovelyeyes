-- Example: Creating Regular Polygons and Stars

function load()

    love.graphics.setBackgroundColor( ColorUtil.WHITE ) 
	love.graphics.setLineStyle( love.line_smooth )

    label = Text:new("label",20,20,"look mamma !!\n with no hands !!") 
       
    poly1 = Polygon:triangle("poly1",20,100,100,100)    
    poly2 = Polygon:roundedBox("poly2",130,20,100,100, 10)    
    poly3 = Polygon:regularPolygon("poly3",240,20,100,5)
    poly4 = Polygon:regularPolygon("poly4",350,20,100,6)
    poly5 = Polygon:regularPolygon("poly5",460,20,100,7)
    poly6 = Polygon:regularPolygon("poly6",570,20,100,8)

    star1= Polygon:star("star1", 240, 130, 100, 5, 25)
    star2= Polygon:star("star2", 350, 130, 100, 6, 25)
    star3= Polygon:star("star3", 460, 130, 100, 7, 25)
    star4= Polygon:star("star4", 570, 130, 100, 8, 25)

    star5= Polygon:star("star5", 240, 240, 100, 5, 15)
    star6= Polygon:star("star6", 350, 240, 100, 5, 20)
    star7= Polygon:star("star7", 460, 240, 100, 5, 30)
    star8= Polygon:star("star8", 570, 240, 100, 5, 35)
    
    star5.fillColor = NMSColor.SQUASH
    star6.fillColor = NMSColor.SQUASH
    star7.fillColor = NMSColor.SQUASH
    star8.fillColor = NMSColor.SQUASH

    gradientCherry2Papaya = Gradient:new( NMSColor.SOUR_CHERRY, NMSColor.PAPAYA )
    gradientPapaya2Cherry = Gradient:new( NMSColor.PAPAYA,NMSColor.SOUR_CHERRY  )
    gradientGreeny = Gradient:new( NMSColor.GREEN_CABBAGE, NMSColor.FIDDLEHEAD )

    poly1.gradient = gradientGreeny
    poly2.gradient = gradientPapaya2Cherry
    poly6.gradient = gradientCherry2Papaya

    star1.gradient = gradientCherry2Papaya
    star2.gradient = gradientCherry2Papaya
    star3.gradient = gradientPapaya2Cherry
    
 	group = Group:new("Group")
	group:add(label)
	group:add(poly1)
	group:add(poly2)	
	group:add(poly3)
	group:add(poly4)
	group:add(poly5)	
	group:add(poly6)
	
	group:add(star1)
	group:add(star2)
	group:add(star3)
	group:add(star4)
	group:add(star5)
	group:add(star6)
	group:add(star7)
	group:add(star8)

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