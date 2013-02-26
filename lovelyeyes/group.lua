Group = {}
Group.__index = Group

-- create the new Group
function Group:new(id)
    local me = {} 
    setmetatable(me, Group)

    me.childs = {}
    me.mousePressed = false
    me.mouseReleased = true
    me.id = id
    me.forceDragging = false
    return me
end

function Group:add(e)
    table.insert(self.childs, e)
    e.owner = self
end

function Group:draw()
    for n=1,table.getn(self.childs),1 do 
      self.childs[n]:draw()
    end
end

-- the click should only go to the first
-- check from the last in the list to the first 
function Group:mousepressed( x, y, button )
    self.mousePressed = true

    for n=table.getn(self.childs),1,-1 do 
        if self.childs[n]:mousepressed( x, y, button ) then

            -- will drag even if the child is not set to
            if self.forceDragging then 
                self.childs[n].isDragging = true
                self.childs[n].dragX = x
                self.childs[n].dragY = y
            end
            
            break
        end
    end
end

function Group:mousereleased( x, y, button )
    self.mousePressed = false
    
    for n=table.getn(self.childs),1,-1 do 
        if self.childs[n]:mousereleased( x, y, button ) then 

            if self.forceDragging then 
                self.childs[n].isDragging = false
            end
            break
        end
    end
end

-- update()
function Group:update(delta)
    for n=table.getn(self.childs),1,-1 do 
        self.childs[n]:update(delta) 
    end
    
    if self.forceDragging then
        self:dragging(love.mouse.getX(),love.mouse.getY())
    end
end

-- release focus from all except from the requester
function Group:requestFocus(id)

    for n=1,table.getn(self.childs),1 do 
        if self.childs[n].id ~= id then
            self.childs[n].hasFocus = false
        end 
    end

end

-- find the next to give focus to
function Group:lostFocus(id)

    local found = 0
    
    for n=1,table.getn(self.childs),1 do 
        if self.childs[n].id == id then 
            found = n
            break
        end
    end

    local start = 0
    if found+1 > table.getn(self.childs) then 
        start=1
    else 
        start=found+1
    end 

    found = 0
    -- first try to find the next that canHaveFocus
    for n=start,table.getn(self.childs),1 do 
        if self.childs[n].canHaveFocus then
           self.childs[n].hasFocus = true
           found = n 
           break
        end
    end

    -- second try to find the next that canHaveFocus
    if found == 0 then 
        for n=1,start,1 do 
            if self.childs[n].canHaveFocus then
               self.childs[n].hasFocus = true
               break
            end
        end
    end

end

-- enter trigger the action, Tab release the focus
function Group:keypressed(key) 

    for n=1,table.getn(self.childs),1 do 
        if self.childs[n]:keypressed(key) then
            break
        end
    end
end

-- dragg the draggable
function Group:dragging( x, y )
    for n=table.getn(self.childs),1,-1 do 
        if self.childs[n].isDragging 
            and self.mousePressed
            and self.forceDragging then
            
            self.childs[n].x = self.childs[n].x + ( x - self.childs[n].dragX )
            self.childs[n].y = self.childs[n].y + ( y - self.childs[n].dragY )
            self.childs[n].dragX = x
            self.childs[n].dragY = y
            break
        end
    end
end

-- return an element from the list by id
function Group:getbyid(id)
    for n=table.getn(self.childs),1,-1 do 
        if self.childs[n].id == id then
            return self.childs[n]
        end
    end
    return nil
end

function Group:tostring()
    buffer = ""
    for n=1,table.getn(self.childs),1 do 
        buffer = buffer .. self.childs[n]:tostring() .. "\n"
    end
    
    return buffer
end


-- dump the current positions of the elements in a .lua file 
function Group:dump()
    filename = self.id .. os.date("_%Y%m%d_%H%M%S") .. ".lua"
    
    local file = love.filesystem.newFile( filename, 2 )
    local success = love.filesystem.open( file )
          success = love.filesystem.write( file, self:tostring() )

    local success = love.filesystem.close( file )
end
