Button = {}

Button.__index = function (table, key)
    if Button[key] ~= nil then
        return Button[key]
    else 
    	return Text.__index(table,key)
    end
end

-- create the new text object
function Button:new(id,x,y,text)
   
    local me = Text:new(id,x,y,text)
    setmetatable(me, Button)

    me.border = 1
    me.margin = 5
    me.font = love.graphics.newFont(love.default_font, 12)
    me.color = ColorUtil.BLACK
    me.gradientNormal = Gradient:new( ColorUtil.WHITE, ColorUtil.grayPercent( 50 ) )
    me.gradientOver = Gradient:new( ColorUtil.grayPercent( 50 ), ColorUtil.WHITE )
    me.gradient = me.gradientNormal
    me.originalMargin = 5
    me.highlightMargin = 4

    table.insert(me.onMousePressed, function(self)
		self.gradient = self.gradientOver
	end)

	table.insert(me.onMouseReleased, function(self)
		self.gradient = self.gradientNormal
	end)
	
    return me
end

-- represent the initialization code of the element
-- based on the current state
-- 
-- example : 
-- button3 = Button:new("button3",150,10,"clickme")

--
function Button:tostring()
    return self.id .. " = Button:new(\"" 
        .. self.id .. "\","
        .. self.x  .. ","
        .. self.y  .. ","
        .. "\"" .. Text:escape(self.text) .. "\")"
end


function Button:mouseOver()
	self.margin = self.highlightMargin 
	Rectangle:mouseOver()
end

function Button:mouseOut()
	self.margin = self.originalMargin
	Rectangle:mouseOut()
end

-- change the button gradient end color 
function Button:setColor( newColor )
    self.gradientNormal = Gradient:new( ColorUtil.WHITE, newColor )
    self.gradientOver = Gradient:new( newColor, ColorUtil.WHITE )
    self.gradient = self.gradientNormal
end

