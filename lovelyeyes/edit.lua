Edit = {}
Edit.__index = function (table, key)
	if Edit[key] ~= nil then
        return Edit[key]
    else
    	return Text.__index(table,key)
    end
end

Edit.cursorFreqTime = 0.4

Edit.key_windows = 311
Edit.key_windows_context_menu = 319

Edit.keyMapping = {
				['`'] = '~',
				['1'] = '!',
				['2'] = '@',
				['3'] = '#',
				['4'] = '$',
				['5'] = '%',
				['6'] = '^',
				['7'] = '&',
				['8'] = '*',
				['9'] = '(',
				['0'] = ')',
				['-'] = '_',
				['='] = '+',
				['['] = '{',
				[']'] = '}',
				[';'] = ':',
				["'"] = '"',
				['\\'] = '|',
				[','] = '<',
				['.'] = '>',
				['/'] = '?',
			}


-- create the new edit object
function Edit:new(id,x,y,columns)

    local me = Text:new(id,x,y,"")
    setmetatable(me, Edit)
    me.canHaveFocus = true
    me.border = 1
    me.fillColor = NMSColor.ENDIVE
    me.borderColor = NMSColor.BLUEBERRY

	me.columns = columns
    me.cursorTimer = 0
    me.showCursor = true
    me.cursor = {}
    me.cursor.column = 1
    me.cursor.row = 1

    return me
end

-- returns true if the event is consumed
--
function Edit:keypressed(key)

   	-- if the rectangle already processed the event
	if Rectangle.keypressed(self,key) then
   		return true
   	end

	if self.hasFocus then
        if key == love.key_left then
        	self:moveLeft()
	    	return true

		elseif key == love.key_right then
			self:moveRight()
	    	return true

	    elseif key == love.key_up then
	    	self:moveUp()
	    	return true

	    elseif key == love.key_down then
	    	self:moveDown()
			return true

	    elseif key == love.key_return
	    	or key == love.key_kp_enter then

	    	self:doReturn()
			return true

		elseif key == love.key_home then
        	self.cursor.column = 1
	    	return true

        elseif key == love.key_end then
        	self.cursor.column = string.len(self.lines[self.cursor.row])+1
	    	return true

        elseif key == love.key_delete then
			self:delete()
			return true

	    elseif key == love.key_backspace then
	    	self:doBackspace()
	    	return true

	    elseif key == love.key_capslock
	    	or key == love.key_lshift
	    	or key == love.key_rshift
	    	or key == love.key_ralt
	    	or key == love.key_lalt
	    	or key == love.key_rctrl
	    	or key == love.key_lctrl
	    	or key == love.key_pageup
	    	or key == love.key_pagedown
	    	or key == Edit.key_windows
	    	or key == Edit.key_windows_context_menu
			or key == love.key_break
	    	or (key >= love.key_f1 and key <= love.key_f15)
	    	then return true

		else
			--local data
			function tochar ()
				if key == love.key_kp_period then return '.' end
				if key == love.key_kp_divide then return '/' end
				if key == love.key_kp_multiply then return '*' end
				if key == love.key_kp_minus then return '-' end
				if key == love.key_kp_plus then return '+' end
				if key == love.key_kp_enter then return '\n' end
				if key == love.key_kp_equals then return '=' end
				if (key >= love.key_kp0 and key <= love.key_kp9) then
					key = key - 208
				end
				return string.char(key)
			end
			local succes, data = pcall(tochar)
			if not succes or data == '<' then return true end

			if love.keyboard.isDown(love.key_capslock)
				or love.keyboard.isDown(love.key_lshift)
				or love.keyboard.isDown(love.key_rshift) then
				if Edit.keyMapping[data] then
					data = Edit.keyMapping[data]
				else
					data = string.upper(data)
				end
			end

			-- if there is a keyboard layout set
			if self.keyboard ~= nil then
				data = self.keyboard:onData(data)
			end
			
			local line = self.lines[self.cursor.row]
			local buffer = string.sub( line, 1, self.cursor.column-1)
				.. data
				.. string.sub( line, self.cursor.column )

			self.lines[self.cursor.row] = buffer
			self:rebuildText()
			self.cursor.column = self.cursor.column + string.len(data)
	    	return true
	    end

	end

	return false
end

function Edit:doBackspace()
	if string.len(self.text) > 0 and
		not (self.cursor.row ==1 and self.cursor.column ==1) then

		if self.cursor.column == 1 then
			-- merge the current line with the previous
			local previous = self.cursor.row -1
			local cursorPosition = string.len(self.lines[previous])+1

			if previous > 0 then
				self.lines[previous] = self.lines[previous] .. self.lines[self.cursor.row]
				table.remove(self.lines,self.cursor.row)
				self.cursor.row = previous
			end
        	self.cursor.column = cursorPosition
        else
			self:moveLeft()
        	self:delete()
		end

		self:removeLineIfEmpty()
		self:rebuildText()
    	return true
	end

end

function Edit:doReturn()
	local currentLine = string.sub(self.lines[self.cursor.row],1, self.cursor.column-1)
	local toNewLine = string.sub(self.lines[self.cursor.row],self.cursor.column)

	table.insert(self.lines,self.cursor.row +1,toNewLine)
	self.lines[self.cursor.row] = currentLine

	self.cursor.row = self.cursor.row +1
	self.cursor.column = 1
	self:rebuildText()
end

function Edit:moveDown()
	self.cursor.row = self.cursor.row +1
	if self.cursor.row > table.getn(self.lines) then
		self.cursor.row = table.getn(self.lines)
	end

	-- check if the current column is valid for the new line
	local maxColumn = string.len(self.lines[self.cursor.row])
	if self.cursor.column > maxColumn+1 then
		self.cursor.column = maxColumn+1
	end
end

function Edit:moveUp()
	self.cursor.row = self.cursor.row -1
	if self.cursor.row <= 0 then
		self.cursor.row = 1
	end

	-- check if the current column is valid for the new line
	local maxColumn = string.len(self.lines[self.cursor.row])
	if self.cursor.column > maxColumn+1 then
		self.cursor.column = maxColumn+1
	end
end


function Edit:moveLeft()
	self.cursor.column = self.cursor.column -1
	if self.cursor.column <= 0 then

		-- if reach teh start of the line go to the previous
		self.cursor.row = self.cursor.row -1
		if self.cursor.row <= 0 then
			self.cursor.row = 1
		else
			self.cursor.column = string.len(self.lines[self.cursor.row])+1
		end
	end
end

function Edit:moveRight()
	self.cursor.column = self.cursor.column +1
	local maxColumn = string.len(self.lines[self.cursor.row])

	-- trying to go beyond the end of the line goto the next line
	if self.cursor.column > maxColumn+1 then

		self.cursor.row = self.cursor.row +1
		if self.cursor.row > table.getn(self.lines) then
			self.cursor.row = table.getn(self.lines)
		else
			self.cursor.column = 1
		end
	end
end

function Edit:delete()
	local maxColumn = string.len(self.lines[self.cursor.row])
	if self.cursor.column < maxColumn+1 then
		local line = self.lines[self.cursor.row]
		local buffer = string.sub( line, 1, self.cursor.column-1)
			.. string.sub( line, self.cursor.column+1 )

		self.lines[self.cursor.row] = buffer

		self:removeLineIfEmpty()
		self:rebuildText()
    else

    	if self.cursor.row < table.getn(self.lines) then
    		local originalRow = self.cursor.row
    		local originalColumn = self.cursor.column

    		self.cursor.row = self.cursor.row +1
    		self.cursor.column = 1

			self:delete()
			self:removeLineIfEmpty()
    		self.cursor.row = originalRow
    		self.cursor.column = originalColumn
			self:rebuildText()

		end
	end
end

-- remove the empty line
function Edit:removeLineIfEmpty()
	if string.len(self.lines[self.cursor.row]) == 0
		and table.getn(self.lines) > 1 then

		table.remove(self.lines,self.cursor.row)

		-- check if the row is still valid
		if self.cursor.row > table.getn(self.lines) then
			self.cursor.row = table.getn(self.lines)
		end
		self:rebuildText()

	end

end

-- rebuild the text value based on the lines
function Edit:rebuildText()
	local buffer = ""

	for n=1,table.getn(self.lines)-1,1 do
      buffer = buffer .. self.lines[n] .. "\n"
    end

    buffer = buffer .. self.lines[table.getn(self.lines)]
    self.text = buffer
    self:calculateRectangle()
end


--- track the time to udpate the cursor
function Edit:update(delta)
    Rectangle.update(self,delta)

	self.cursorTimer = self.cursorTimer + delta
	if self.cursorTimer > Edit.cursorFreqTime then
		self.showCursor  = not self.showCursor
		self.cursorTimer = 0
	end

end

function Edit:draw()

    Rectangle.draw(self)

	love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)

    local startX = self.x + self.margin + self.border
    local x   = startX
    local y   = self.y + self.margin + self.border + self.font:getHeight()
    local one = ""
	local inLinesSpace = self.font:getHeight() * 0.05

	for r=1,table.getn(self.lines),1 do
    	local line = self.lines[r]

	    for n=1,string.len(line)+1,1 do
	    	one = string.sub(line, n, n)
	    	love.graphics.draw( one, x, y )

	    	-- show the cursor
	    	if self.hasFocus
	    		and n == self.cursor.column
	    		and r == self.cursor.row then

			    if self.showCursor then
		    		love.graphics.rectangle(
		    			2, x, y - self.font:getHeight() +inLinesSpace,
		    			self.font:getWidth("i") / 1.5,
		    			self.font:getHeight() )
				end
			end
	    	-- x = x + self.font:getWidth(one)
	    	x = x + Text:getStringWidth(self.font,self.keyboard,one)
	    end
	    x = startX
	    y = y + self.font:getHeight() +	self.margin
    end

end

--
function Edit:tostring()
    return self.id .. " = Edit:new(\""
        .. self.id .. "\","
        .. self.x  .. ","
        .. self.y  .. ","
        .. self.columns .. ")"
end
