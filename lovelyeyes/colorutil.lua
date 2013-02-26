ColorUtil = {}

ColorUtil.__index = ColorUtil

ColorUtil.WHITE = love.graphics.newColor(255,255,255)
ColorUtil.BLACK = love.graphics.newColor(0,0,0)

-- level from 1 to 100
function ColorUtil.grayPercent( level )
	local grayValue = 255 * ((100-level)/100)
	return love.graphics.newColor(grayValue,grayValue,grayValue)
end