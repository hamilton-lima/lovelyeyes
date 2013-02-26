Sprite = {}

Sprite.__index = function (table, key)
    if Sprite[key] ~= nil then
        return Sprite[key]
    else 
        return Rectangle[key]
    end
end

-- create the new text object
function Sprite:new(id,x,y,imageName)
   
    local me = Rectangle:new(id,x,y,1,1)
    setmetatable(me, Sprite)

    me.border = 0
    me.imageName = imageName 
    me.image = love.graphics.newImage( imageName ) 
    me.margin = 5
    me:calculateRectangle(me)
    me.fillColor = nil
    me.keyboard = nil 

    return me
end

-- change the border
function Sprite:setBorder(n)
	self.border = n
    self:calculateRectangle()
end

-- recalculate the rectangle need to the text
function Sprite:calculateRectangle()

    self.w = self.image:getWidth() + (2* self.margin) + (2* self.border)
   	self.h = self.border 
   			+ self.margin 
        	+ self.image:getHeight()
        	+ self.border 
end

-- draw the text
function Sprite:draw()
    Rectangle.draw(self)
    love.graphics.draw( self.image, 
        self.x + self.margin + self.border, 
        self.y + self.margin + self.border + self.image:getHeight() / 2 ) 
end

-- represent the initialization code of the element
-- based on the current state
-- 
-- example : 
-- sprite1 = Text:new("sprite1",150,10,"images/bla.png")

--
function Sprite:tostring()
    return self.id .. " = Sprite:new(\"" 
        .. self.id .. "\","
        .. self.x  .. ","
        .. self.y  .. ","
        .. "\"" .. self.imageName .. "\")"
end
