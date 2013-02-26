Keyboard = {}

Keyboard.__index = Keyboard

Keyboard.pt_BR = {}
Keyboard.pt_BR["'"] = { 
	['a'] = '�', 
	['e'] = '�', 
	['i'] = '�', 
	['o'] = '�', 
	['u'] = '�', 
	['c'] = '�', 
	['A'] = '�', 
	['E'] = '�', 
	['I'] = '�', 
	['O'] = '�', 
	['U'] = '�', 
	['C'] = '�'	
}

Keyboard.pt_BR["~"] = { 
	['a'] = '�' }

Keyboard.pt_BR["^"] = { 
	['e'] = '�' }
	
Keyboard.pt_BR.width = { 
	['�'] = 'a', 
	['�'] = 'a', 
	['�'] = 'e', 
	['�'] = 'e', 
	['�'] = 'i', 
	['�'] = 'o', 
	['�'] = 'u', 
	['�'] = 'c', 
	['�'] = 'A', 
	['�'] = 'A', 
	['�'] = 'E', 
	['�'] = 'E', 
	['�'] = 'I', 
	['�'] = 'O', 
	['�'] = 'U', 
	['�'] = 'C', 
}

function Keyboard:new()

    local me = {}
    setmetatable(me, Keyboard)
    me.buffer = nil
    me.lastChar = nil
    me.map = Keyboard.pt_BR
    
    return me
end

function Keyboard:onData( data )
	if self.buffer == nil then
		if self.map[data] ~= nil then
			self.buffer = self.map[data]
			self.lastChar = data
			return ""
		else 
			return data
		end 
	else
		local result = ""
		if self.buffer[data] ~= nil then
			result = self.buffer[data]
		else
			result = self.lastChar .. data
		end
					
		self.buffer = nil
		self.lastChar = nil
		return result 
	end
end

