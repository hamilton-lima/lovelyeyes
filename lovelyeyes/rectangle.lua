Rectangle = {}
Rectangle.__index = Rectangle

function Rectangle:new(id,x,y,w,h)
   local me = {} 
   setmetatable(me, Rectangle)

   me.x = x 
   me.y = y 
   me.w = w
   me.h = h
   me.id = id
   me.fillColor = NMSColor.AVOCADO
   me.borderColor = NMSColor.BLUEBERRY
   
   me.border = 2

   me.onClick = nil
   me.onMouseOver = nil
   me.onMouseOut= nil

   me.isMouseOver = false
   me.isDraggable = false
   
   me.onMousePressed = {}
   me.onMouseReleased = {}
   me.onDragging = {}

   -- dragging data
   me.isDragging = false
   me.dragX = 0
   me.dragY = 0
   me.mousePressed = false
   
   -- focus control
   me.hasFocus = false
   me.onFocus = nil
   -- participate on the focus order
   me.canHaveFocus = false
   
   me.focusFillColor = love.graphics.newColor(255,255,255)
   me.focusFillBorder = 2
   me.owner = nil
   
   -- for debugging
   me.traceComponent = nil 
   
   -- handler for gradient fill component
   me.gradient = nil
      
   return me
end

function Rectangle:setBorder(n)
	self.border = n
end


function Rectangle:setCanFocus(focus) 
    self.canHaveFocus = focus 
end

function Rectangle:requestFocus()
   if self.owner ~= nil then
        self.owner:requestFocus(self.id)
   end
    
   self.hasFocus = true
   self:focus()
end

function Rectangle:focus()
    if self.onFocus ~= nil then
        self:onFocus()
    end
end

-- its trigged when the control has focus
-- or the user clicks
function Rectangle:click()
    if self.onClick ~= nil then
        self:onClick()
    end
end

function Rectangle:mouseOver()
    if self.onMouseOver ~= nil then
        self:onMouseOver()
    end
end

function Rectangle:mouseOut()
    if self.onMouseOut~= nil then
        self:onMouseOut()
    end
end

function Rectangle:draw()

    -- if hasFocus
    if self.hasFocus then 
        love.graphics.setColor( self.focusFillColor )
        love.graphics.rectangle( 2, self.x - self.focusFillBorder, 
            self.y - self.focusFillBorder,
            self.w + self.border + self.focusFillBorder, 
            self.h + self.border + self.focusFillBorder ) 
    end

    -- fill
    if self.gradient ~= nil then
    	self.gradient:draw(self.x, self.y, self.w, self.h)
    	
    elseif self.fillColor ~= mil then
    	love.graphics.setColor( self.fillColor )
	    love.graphics.rectangle( 2, self.x, self.y, self.w, self.h ) 
    end

    -- border
    if self.borderColor ~= mil then
	    love.graphics.setColor(self.borderColor)
	
	    -- top
	    love.graphics.rectangle( 2, self.x, self.y, self.w, self.border )
	    -- left
	    love.graphics.rectangle( 2, self.x, self.y, self.border, self.h )
	    -- bottom   
	    love.graphics.rectangle( 2, self.x, self.y +self.h -self.border, 
	        self.w, self.border )   
	    -- right
	    love.graphics.rectangle( 2, self.x +self.w -self.border, 
	        self.y, self.border, self.h )     
	end
	
end

function Rectangle:setPos(x,y)
    self.x = x
    self.y = y
end

-- check if the x,y is inside the rectangle
function Rectangle:has(x,y)

    return  
        (x > self.x) and
        (y > self.y) and
        (x < self.x + self.w) and
        (y < self.y + self.h) 
end

-- check if other rectangle intersecs with this one
function Rectangle:intersects(x1,y1,width1,height1)

    x2 = self.x
    y2 = self.y
    width2 = self.w
    height2 = self.h
    
    return not ( 
        (x2 > (x1 + width1 )) or
        (x1 > (x2 + width2 )) or
        (y2 > (y1 + height1)) or
        (y1 > (y2 + height2)) )
end

---------- movement functions and mouse events

-- the click should only go to the first
function Rectangle:mousepressed( x, y, button )
    self.mousePressed = true
    if self:has(x,y) then

        if self.canHaveFocus then 
            self:requestFocus()
        end

        self.isDragging = true
        self.dragX = x
        self.dragY = y

		for n=1, table.getn(self.onMousePressed),1 do
			self.onMousePressed[n](self)
		end
                
        -- event consumed
        return true
    end
    
    return false
end

function Rectangle:mousereleased( x, y, button )
    self.mousePressed = false
    
    if self:has(x,y) then 
        self.isDragging = false

        for n=1, table.getn(self.onMouseReleased),1 do
			self.onMouseReleased[n](self)
		end

        if self.onClick ~= nil then 
            self:click()
        end

        -- event consumed
        return true
    end
    
    return false
end

-- update()
function Rectangle:update(delta)
    self:checkMouseover(love.mouse.getX(),love.mouse.getY())
    self:checkMouseout(love.mouse.getX(),love.mouse.getY())
    self:dragging(love.mouse.getX(),love.mouse.getY())
end

-- enter trigger the action, Tab release the focus
function Rectangle:keypressed(key) 
   
	if self.hasFocus then 
        if key == love.key_tab then
	       self.hasFocus = false
	       
            -- if there are a owner notify that lostFocus()
           if self.owner ~= nil then
                self.owner:lostFocus(self.id)
            end 
	       return true
	       
	    elseif key == love.key_return 
	    	and self.onClick ~= nil then 
                self:click()
                return true
	    end

	end   

	return false
end

-- check if mouse is over  
function Rectangle:checkMouseover( x, y )
    if self:has(x,y) then
        self.isMouseOver = true
        self:mouseOver()
    end
end

-- check if mouse left the object mouseOut event  
function Rectangle:checkMouseout( x, y )
    if self.isMouseOver 
        and (not self:has(x,y)) then

        self.isMouseOver = false
        self:mouseOut()
    end
end

-- dragg the draggable
function Rectangle:dragging( x, y )

    if self.isDragging 
        and self.mousePressed
        and self.isDraggable then
	
        self.x = self.x + ( x - self.dragX )
        self.y = self.y + ( y - self.dragY )
        self.dragX = x
        self.dragY = y

        for n=1, table.getn(self.onDragging),1 do
			self.onDragging[n](self,self.dragX,self.dragY)
		end

        -- event consumed
        return true
    end
    return false    
end

-- represent the initialization code of the element
-- based on the current state
-- 
-- example : 
-- rec2 = Rectangle:new("rec2", 70,10,50,50)
--
function Rectangle:tostring()
    return self.id .. " = Rectangle:new(\"" 
        .. self.id .. "\","
        .. self.x  .. ","
        .. self.y  .. ","
        .. self.w  .. ","
        .. self.h  .. ")"

end

-- dump the current positions of the elements in a .lua file 
function Rectangle:dump()
    filename = self.id .. os.date("_%Y%m%d_%H%M%S") .. ".lua"
    
    local file = love.filesystem.newFile( filename, 2 )
    local success = love.filesystem.open( file )
    success = love.filesystem.write( file, self:tostring() )

    local success = love.filesystem.close( file )
end

