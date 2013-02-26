Keyboard = {}

Keyboard.__index = Keyboard

Keyboard.pt_BR = {}
Keyboard.pt_BR["'"] = { 
	['a'] = 'á', 
	['e'] = 'é', 
	['i'] = 'í', 
	['o'] = 'ó', 
	['u'] = 'ú', 
	['c'] = 'ç', 
	['A'] = 'Á', 
	['E'] = 'É', 
	['I'] = 'Í', 
	['O'] = 'Ó', 
	['U'] = 'Ú', 
	['C'] = 'Ç'	
}

Keyboard.pt_BR["~"] = { 
	['a'] = 'ã' }

Keyboard.pt_BR["^"] = { 
	['e'] = 'ê' }
	
Keyboard.pt_BR.width = { 
	['á'] = 'a', 
	['ã'] = 'a', 
	['é'] = 'e', 
	['ê'] = 'e', 
	['í'] = 'i', 
	['ó'] = 'o', 
	['ú'] = 'u', 
	['ç'] = 'c', 
	['Á'] = 'A', 
	['Ã'] = 'A', 
	['É'] = 'E', 
	['Ê'] = 'E', 
	['Í'] = 'I', 
	['Ó'] = 'O', 
	['Ú'] = 'U', 
	['Ç'] = 'C', 
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

