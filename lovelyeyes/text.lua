Text = {}

Text.__index = function (table, key)
    if Text[key] ~= nil then
        return Text[key]
    else 
        return Rectangle[key]
    end
end

-- create the new text object
function Text:new(id,x,y,text,keyboard)
    local me = Text:new(id,x,y,text)
    me.keyboard = keyboard
    return me
end


-- create the new text object
function Text:new(id,x,y,text)
   
    local me = Rectangle:new(id,x,y,1,1)
    setmetatable(me, Text)

    me.border = 0
    me.text = text
    me.lines = Text:split(text)
    me.margin = 5
    me.font = love.graphics.newFont(love.default_font, 12)
    me.color = NMSColor.EGGPLANT
    me:calculateRectangle(me)
    me.fillColor = nil
    me.keyboard = nil 

    return me
end

-- from http://lua-users.org/wiki/SplitJoin
function Text:split(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

-- return the widder line size
function Text:getLinesWidth(font,keyboard,lines)
    width = 0
    for n=1, table.getn(lines),1 do
        current = Text:getStringWidth(font,keyboard,lines[n])
        if current > width then 
            width = current 
        end
    end
    return width
end

-- calculates the string width
-- if has keyboard set check for widths table
function Text:getStringWidth(font,keyboard__,s)

	if keyboard__ == nil then 
		return font:getWidth(s)
	else
		local width = 0
		for n=1,string.len(s)+1,1 do
	    	one = string.sub(s, n, n)
	    	if keyboard__.map.width[one] ~= nil then
				width = width + font:getWidth(keyboard__.map.width[one])
			else
				width = width + font:getWidth(one)
			end
		end
		return width
	end
end

-- change the text
function Text:setText(text)
    self.text = text
    self.lines = Text:split(text)
    self:calculateRectangle()
end

-- change the border
function Text:setBorder(n)
	self.border = n
    self:calculateRectangle()
end

-- recalculate the rectangle need to the text
function Text:calculateRectangle()

    self.w = Text:getLinesWidth(self.font, self.keyboard, self.lines) 
        + (2* self.margin) + (2* self.border)

	local inLinesSpace = self.font:getHeight() * 0.04
	-- inLinesSpace = 0.5
    
   	self.h = self.border 
   			+ self.margin 
        	+ ( table.getn(self.lines) * (self.font:getHeight() + self.margin +inLinesSpace ) )
        	+ self.border 
end

-- change the font
function Text:setFont(fontName, fontSize)
    self.font = love.graphics.newFont(fontName, fontSize)
    self:calculateRectangle()
end

-- draw the text
function Text:draw()
    Rectangle.draw(self)
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
     
    love.graphics.draw( self.text, 
        self.x + self.margin + self.border, 
        self.y + self.margin + self.border + self.font:getHeight() ) 
end

-- represent the initialization code of the element
-- based on the current state
-- 
-- example : 
-- text3 = Text:new("text3",150,10,"nothing to say")

--
function Text:tostring()
    return self.id .. " = Text:new(\"" 
        .. self.id .. "\","
        .. self.x  .. ","
        .. self.y  .. ","
        .. "\"" .. Text:escape(self.text) .. "\")"
end

function Text:escape (s)
  s = string.gsub(s, "\t", "\\t")
  s = string.gsub(s, "\n", "\\n")
  return s
end
