-- Example: Gradient fill and ColorUtil

function load()
    love.graphics.setBackgroundColor( NMSColor.GREEN_CABBAGE ) 
    rec1 = Rectangle:new("rec1",20,20,150,150)    
    rec2 = Rectangle:new("rec2",200,20,150,150)
    rec3 = Rectangle:new("rec3",400,20,350,50)
    rec4 = Rectangle:new("rec4",20,200,150,150)
    rec5 = Rectangle:new("rec5",200,200,150,150)
    rec6 = Rectangle:new("rec6",400,200,150,150)
    rec7 = Rectangle:new("rec7",20,400,150,150)
    rec8 = Rectangle:new("rec8",200,400,150,150)
    rec9 = Rectangle:new("rec9",400,400,350,50)
    rec9:setBorder(4)

    gradient1 = Gradient:new( ColorUtil.grayPercent(20), ColorUtil.BLACK )
    gradient2 = Gradient:new( ColorUtil.WHITE, ColorUtil.BLACK )
    gradient3 = Gradient:new( ColorUtil.WHITE, NMSColor.PAPAYA )
    gradient4 = Gradient:new( NMSColor.PAPAYA, ColorUtil.WHITE )
    gradient5 = Gradient:new( NMSColor.ENDIVE, NMSColor.KALE )
    gradient6 = Gradient:new( NMSColor.BLUEBERRY, NMSColor.SOUR_CHERRY )

    gradient7 = Gradient:new( NMSColor.GREEN_CABBAGE, NMSColor.FIDDLEHEAD )
    gradient8 = Gradient:new( ColorUtil.grayPercent(10), ColorUtil.grayPercent(50) )
    gradient9 = Gradient:new( NMSColor.SOUR_CHERRY, NMSColor.PAPAYA )
    
    gradient7.mode = Gradient.HORIZONTAL
    gradient8.mode = Gradient.HORIZONTAL
    gradient9.mode = Gradient.HORIZONTAL
    
    rec1.gradient = gradient1
    rec2.gradient = gradient2
    rec3.gradient = gradient3
    rec4.gradient = gradient4
    rec5.gradient = gradient5
    rec6.gradient = gradient6
    rec7.gradient = gradient7
    rec8.gradient = gradient8
    rec9.gradient = gradient9
    
	group = Group:new("Group")
    group:add(rec1)
    group:add(rec2)
    group:add(rec3)
    group:add(rec4)
    group:add(rec5)
    group:add(rec6)
    group:add(rec7)
    group:add(rec8)
    group:add(rec9)
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