_ENV = {
	read_file  = read_file,
	write_file = write_file,
	string = string,
	pairs = pairs,
	_G = _G,
	setmetatable = setmetatable,
	msgbox = msgbox,
	type = type,
	quit = quit,
	rawset = rawset,
	rawget = rawget
}

module_mt = {}
module    = {}
t         = {} -- backing table

module_mt.__index = function(_, k)
	return rawget(t, k)
end

module_mt.__newindex = function(_, k, v)
	if type(v) ~= 'string' and type(v) ~= 'number' then
		msgbox('Can not insert value of type ' .. type(v) .. ' into save file')
		quit()
		return
	end
	rawset(t, k, v)
	save()
end

setmetatable(module, module_mt)

function load()
	local data = read_file('savefile')
	if not data then return end
	for k, v in string.gmatch(data, "([%-_%w]+)=([%/%-_%w]+)") do
		t[k] = v
	end
end

function save()
	local data
	for k, v in pairs(t) do
		data = data and data .. ','
		data = data or ''
		data = data .. k .. '=' .. v
	end
	_G.print('savefile = ' .. (data or ''))
	write_file('savefile', data)
end

function clear()
	for k,v in pairs(t) do t[k] = nil end
	save()
end

rawset(module, 'clear', clear)

load()

return module

