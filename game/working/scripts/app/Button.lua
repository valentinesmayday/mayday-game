_ENV = {
	require = require,
	setmetatable = setmetatable
}

textures    = require('res.textures')
button_font = require('res.fonts').get('button')

button_mt = {}

button_mt.__index = button_mt;

function button_mt.draw(self)
	if self.t then self.t:draw(self.x, self.y) end
end

function button_mt.contains(self, x, y)
	return x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h
end

function create_from_texture(t, x, y, w, h)
	local o = { t = t, x = x or 0, y = y or 0, w = w or t.w, h = h or t.h }
	setmetatable(o, button_mt)
	return o
end

function create_from_file(filename, x, y, w, h)
	local t = textures.image(filename)
	return create_from_texture(t, x, y, w, h)
end

function create_from_text(text, x, y, font)
	local t = textures.text(text, font or button_font)
	return create_from_texture(t, x, y)
end

return {
	create_from_texture = create_from_texture ,
	create_from_file    = create_from_file    ,
	create_from_text    = create_from_text
}

